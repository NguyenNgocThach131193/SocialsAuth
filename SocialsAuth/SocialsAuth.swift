//
//  AuthenticationManager.swift
//  Exersice Supplies
//
//  Created by Thach Nguyen Ngoc on 3/29/19.
//  Copyright © 2019 Thach Nguyen Ngoc. All rights reserved.
//

import Foundation
import UIKit
import LineSDK
import GoogleSignIn
import FirebaseAuth
import FBSDKLoginKit

private protocol DictionaryProtocol {
    var dictionary: [String : Any] { get }
}

public typealias ResultHandler<N> = (_ result: Result<N, Error>) -> Swift.Void

public class SocialsAuth: NSObject {

    public typealias SocialsAuthCredential = AuthCredential
    
    public static var privateShared: SocialsAuth!
    public static var shared: SocialsAuth {
        if privateShared == nil {
            DispatchQueue.global().sync(flags: .barrier) {
                if privateShared == nil {
                    self.privateShared = SocialsAuth()
                }
            }
        }
        return privateShared!
    }
    
    public override init() {
        super.init()
        setupSDKs()
    }
    
    public typealias LoginCompletion = ResultHandler<SocialsAuthCredential>
    public var loginCompletion: LoginCompletion?
    private var twitterProvider: OAuthProvider?
}

// MARK: - Setup functions
extension SocialsAuth {
    public func enableGoogleAuth(clientID: String) {
        GIDSignIn.sharedInstance().clientID = clientID
    }
    
    public func enableLINEAuth(channelID: String, universalLinkURL: URL? = nil) {
        LoginManager.shared.setup(channelID: channelID, universalLinkURL: universalLinkURL)
    }
    
    public func enableFacebookAuth(options: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.initializeSDK(options)
    }
}

// MARK: - UIApplication Delegate
extension SocialsAuth {
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let canLoginGoogle = GIDSignIn
            .sharedInstance()
            .handle(url)
        let canLoginFacebook = ApplicationDelegate
            .shared
            .application(app,
                         open: url,
                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                         annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        let canLoginLine = LoginManager.shared.application(app, open: url, options: options)
        
        return canLoginGoogle || canLoginFacebook || canLoginLine
    }
}

// MARK: - Auth socials public functions
extension SocialsAuth {
    public func loginWithGoogle(presenter: UIViewController, complection: @escaping LoginCompletion) {
        self.loginCompletion = complection
        GIDSignIn.sharedInstance()?.presentingViewController = presenter
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    public func loginWithFacebook(presenter: UIViewController, complection: @escaping LoginCompletion) {
        SocialsAuth.loginViaFacebook(presenter: presenter) { result in
            switch result {
            case .success(let loginResult):
                if loginResult.isCancelled {
                    print("Cancelled")
                } else if let tokenString = loginResult.token?.tokenString {
                    let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
                    complection(.success(credential))
                } else {
                    complection(.failure(SocialsAuth.defaultError))
                }
                break
            case .failure(let error):
                complection(.failure(error))
                break
            }
        }
    }
    
    public func loginWithLine(presenter: UIViewController, complection: @escaping LoginCompletion) {
        let profile = LoginPermission.profile
        let email = LoginPermission.email
        let openID = LoginPermission.openID
        LoginManager.shared.login(permissions: [profile, email, openID], in: presenter) { result in
            switch result {
            case .success(let loginResult):
                let credential = LineAuthProvider.credential(loginResult: loginResult)
                complection(.success(credential))
            case .failure(let error):
                complection(.failure(error))
            }
        }
    }
    
    /// https://firebase.google.com/docs/auth/ios/twitter-login
    ///
    /// - Parameter complection
    func loginWithTwitter(complection: @escaping LoginCompletion) {
        let provider = OAuthProvider(providerID: TwitterAuthProviderID)
        provider.getCredentialWith(nil) { (credential, error) in
            if let error = error {
                complection(.failure(error))
            } else if let credential = credential {
                complection(.success(credential))
            } else {
                complection(.failure(SocialsAuth.defaultError))
            }
        }
        self.twitterProvider = provider
    }
}

// MARK: - Firebase auth functions
extension SocialsAuth {
    public typealias FirebaseAuthCompletion = ResultHandler<String>
    public func firebaseAuth(credential: AuthCredential, fetchAccessToken: Bool, complection: @escaping FirebaseAuthCompletion) {
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            self?.handleAuthResult(input: (authResult: authResult, error: error), fetchAccessToken: fetchAccessToken, complection: complection)
        }
    }
    
    public func firebaseAuth(withCustomToken: String, fetchAccessToken: Bool, complection: @escaping FirebaseAuthCompletion) {
        Auth.auth().signIn(withCustomToken: withCustomToken) { [weak self] (authResult, error) in
            self?.handleAuthResult(input: (authResult: authResult, error: error), fetchAccessToken: fetchAccessToken, complection: complection)
        }
    }
    
    private func handleAuthResult(input: (authResult: AuthDataResult?, error: Error?), fetchAccessToken: Bool, complection: @escaping FirebaseAuthCompletion) {
        if let error = input.error {
            complection(.failure(error))
        } else if let authResult = input.authResult {
            let user = authResult.user
            user.getIDTokenResult(completion: { (tokenResult, error) in
                if fetchAccessToken {
                    user.getIDTokenResult(completion: { (tokenResult, error) in
                        if let error = error {
                            complection(.failure(error))
                        } else if let tokenResult = tokenResult {
                            complection(.success(tokenResult.token))
                        } else {
                            complection(.failure((SocialsAuth.defaultError)))
                        }
                    })
                } else {
                    complection(.success(user.uid))
                }
            })
        } else {
            complection(.failure((SocialsAuth.defaultError)))
        }
    }
    
    public func refreshToken(complection: @escaping FirebaseAuthCompletion) {
        Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { (token, error) in
            if let error = error {
                complection(.failure(error))
            } else if let token = token {
                complection(.success(token))
            } else {
                complection(.failure((SocialsAuth.defaultError)))
            }
        })
    }
}

// MARK: - Setup
extension SocialsAuth {
    private func setupSDKs() {
        
    }
}

// MARK: - Login Socials
extension SocialsAuth {
    internal static func loginViaFacebook(presenter: UIViewController, _ resultHandler: @escaping ResultHandler<LoginManagerLoginResult>) {
        let loginManager = LoginManager()
        loginManager.defaultAudience = .friends
        loginManager.logIn(permissions: ["public_profile", "email"], from: presenter) { (loginResult, error) in
            if let error = error {
                resultHandler(.failure(error))
            } else if let loginResult = loginResult {
                resultHandler(.success(loginResult))
            } else {
                resultHandler(.failure(SocialsAuth.defaultError))
            }
        }
    }
}

// MARK: - GIDSignInUIDelegate, GIDSignInDelegate
extension SocialsAuth: GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let complection = loginCompletion {
            if let error = error {
                complection(.failure(error))
            } else {
                guard let authentication = user.authentication else {
                    complection(.failure(SocialsAuth.defaultError))
                    return
                }
                let credential = GoogleAuthProvider.credential(
                    withIDToken: authentication.idToken,
                    accessToken: authentication.accessToken)
                complection(.success(credential))
            }
        }
    }
}

// MARK: - Logout
extension SocialsAuth {
    func signOut() {
        try? Auth.auth().signOut()
        if AccessToken.current != nil {
            LoginManager().logOut()
        }
    }
}
