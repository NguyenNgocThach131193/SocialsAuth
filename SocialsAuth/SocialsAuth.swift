//
//  AuthenticationManager.swift
//  Exersice Supplies
//
//  Created by Thach Nguyen Ngoc on 3/29/19.
//  Copyright © 2019 Thach Nguyen Ngoc. All rights reserved.
//

import Foundation
import UIKit
//import RxSwift
//import LineSDK
//import GoogleSignIn
//import Firebase
//import Firebase
//import TwitterKit
//import FirebaseAuth

private protocol DictionaryProtocol {
    var dictionary: [String : Any] { get }
}

public class SocialsAuth: NSObject {
    
    enum SocialType: DictionaryProtocol {
        
        case facebook(String)
        case google(String)
        case twitter(String)
        case line(String)

        var dictionary: [String : Any] {
            var params: [String : Any] = [:]
            switch self {
            case .facebook(let token):
                params["access_token"] = token
            case .google(let token):
                params["access_token"] = token
            case .twitter(let token):
                params["access_token"] = token
            case .line(let token):
                params["access_token"] = token
            }
            return params
        }
    }
    
//    private let disposeBag = DisposeBag()
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
    
//    typealias LoginCompletion = ResultHandler<(user: UserModel, token: String)>
//    private var loginCompletion: LoginCompletion?
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        setupSDKs()
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        let canLoginGoogle = GIDSignIn
//            .sharedInstance()
//            .handle(url,
//                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                    annotation: options[UIApplication.OpenURLOptionsKey.annotation])
//        let canLoginFacebook = ApplicationDelegate
//            .shared
//            .application(app,
//                         open: url,
//                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                         annotation: options[UIApplication.OpenURLOptionsKey.annotation])
//        let canLoginTwitter = TWTRTwitter.sharedInstance().application(app, open: url, options: options)
//        
//        let canLoginLine = LoginManager.shared.application(app, open: url, options: options)
//        
//        return canLoginGoogle || canLoginFacebook || canLoginTwitter || canLoginLine
        
//        let canLoginLine = LoginManager.shared.application(app, open: url, options: options)
        return true
    }
}

// MARK: - Setup
extension SocialsAuth {
    private func setupSDKs() {
        setupGoogle()
        setupLine()
        setupTwitter()
    }
    
    private func setupGoogle() {
//        GIDSignIn.sharedInstance()?.clientID
    }
    
    private func setupLine() {
//        LoginManager.shared.setup(channelID: "1602261894", universalLinkURL: nil)
    }
    
    private func setupTwitter() {
//        let info = Bundle.main.infoDictionary
//        if let twitterConsumerKey = info?["TwitterConsumerKey"] as? String, let twitterConsumerSecret = info?["TwitterConsumerSecret"] as? String {
//            let shared = TWTRTwitter.sharedInstance()
//            shared.start(withConsumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
//            let sessionStore = shared.sessionStore
//            if sessionStore.hasLoggedInUsers() {
//                if let userID = sessionStore.session()?.userID {
//                    sessionStore.logOutUserID(userID)
//                }
//            }
//        }
    }
}

// MARK: - Login Socials
extension SocialsAuth {
//    func loginWithGoogle(presenter: GIDSignInUIDelegate, complection: @escaping LoginCompletion) {
//        self.loginCompletion = complection
//        GIDSignIn.sharedInstance().uiDelegate = presenter
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().signIn()
//    }
//
//    static func loginViaFacebook(_ disposeBag: DisposeBag, presenter: UIViewController, _ resultHandler: @escaping ResultHandler<LoginManagerLoginResult>) {
//        let loginManager = LoginManager()
//        loginManager.defaultAudience = .friends
//        loginManager.loginBehavior = .browser
//        loginManager.logIn(permissions: ["public_profile", "email"], from: presenter) { (loginResult, error) in
//            if let error = error {
//                resultHandler(.failure(error))
//            } else if let loginResult = loginResult {
//                resultHandler(.success(loginResult))
//            } else {
//                resultHandler(.failure("Service.Error.DefaultMessage".localized()))
//            }
//        }
//    }
//
//    func loginWithFacebook(presenter: UIViewController, complection: @escaping LoginCompletion) {
//        AuthenticationManager.loginViaFacebook(disposeBag, presenter: presenter) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let loginResult):
//                if loginResult.isCancelled {
//                    print("Cancelled")
//                } else if let tokenString = loginResult.token?.tokenString {
//                    let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
//                    self.firebaseAuth(credential: credential, complection: { result in
//                        switch result {
//                        case .success(let uid):
//                            let socialType = SocialType.facebook(uid)
//                            self.login(with: socialType, complection)
//                        case .failure(let error):
//                            complection(.failure(error))
//                        }
//                    })
//                } else {
//                    complection(.failure("Service.Error.DefaultMessage".localized()))
//                }
//                break
//            case .failure(let error):
//                complection(.failure(error))
//                break
//            }
//        }
//    }
//
//    func loginWithLine(presenter: UIViewController, complection: @escaping LoginCompletion) {
//        LoginManager.shared.login(permissions: [.profile, .openID, .email], in: presenter, options: []) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let loginResult):
//                let socialType = SocialType.line(loginResult.accessToken.value)
//                self.login(with: socialType, complection)
//            case .failure(let error):
//                if (error as LineSDKError).isUserCancelled {
//
//                } else {
//                    complection(.failure(error))
//                }
//            }
//        }
//    }
//
//    func loginWithTwitter(presenter: UIViewController, complection: @escaping LoginCompletion) {
//        TWTRTwitter.sharedInstance().logIn { [weak self] (session, error) in
//            if let error = error {
//                if !error.twitterIsCancelled {
//                    complection(.failure(error))
//                }
//            } else if let session = session {
//                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
//                self?.firebaseAuth(credential: credential, complection: { result in
//                    switch result {
//                    case .success(let uid):
//                        let socialType = SocialType.twitter(uid)
//                        self?.login(with: socialType, complection)
//                    case .failure(let error):
//                        complection(.failure(error))
//                    }
//                })
//            } else {
//                complection(.failure("Service.Error.DefaultMessage".localized()))
//            }
//        }
//    }
//
//    typealias FirebaseAuthCompletion = ResultHandler<String>
//    private func firebaseAuth(credential: AuthCredential, complection: @escaping FirebaseAuthCompletion) {
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            if let error = error {
//                complection(.failure(error))
//            } else if let authResult = authResult {
//                complection(.success(authResult.user.uid))
//            } else {
//                complection(.failure(("Service.Error.DefaultMessage".localized())))
//            }
//            // User is signed in
//            // ...
//        }
//    }
}

// MARK: - GIDSignInUIDelegate, GIDSignInDelegate
//extension AuthenticationManager: GIDSignInUIDelegate, GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let loginCompletion = loginCompletion {
//            if let error = error {
//                if (error as NSError).code == GIDSignInErrorCode.canceled.rawValue {
//
//                } else {
//                    loginCompletion(.failure(error))
//                }
//            } else {
//                guard let authentication = user.authentication else { return }
//                let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                               accessToken: authentication.accessToken)
//                firebaseAuth(credential: credential) { [weak self] result in
//                    switch result {
//                    case .success(let uid):
//                        let socialType = SocialType.google(uid)
//                        self?.login(with: socialType, loginCompletion)
//                    case .failure(let error):
//                        loginCompletion(.failure(error))
//                    }
//                }
//            }
//        }
//    }
//}
//// MARK: - Services
//extension AuthenticationManager {
//    func login(with socialType: SocialType, _ resultHandler: @escaping LoginCompletion) {
//        // Hello kjasdkajhsd
////        UIHelper.showServiceLoading()
////        AuthenticationServices().postLoginSocial(disposeBag: disposeBag, socialType: socialType) { result in
////            UIHelper.hideServiceLoading()
////            switch result {
////            case .success(let (user, token)):
////                resultHandler(.success((user, token)))
////            case .failure(let error):
////                resultHandler(.failure(error))
////            }
////        }
//    }
//}
//
//extension Error {
//    var twitterIsCancelled: Bool {
//        return (self as NSError).code == TWTRLogInErrorCode.logInErrorCodeCancelled.rawValue
//    }
//}
