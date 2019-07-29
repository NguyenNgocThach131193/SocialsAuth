//
//  LineAuthProvider.swift
//  SocialsAuth
//
//  Created by thachnn on 7/28/19.
//  Copyright © 2019 thachnn. All rights reserved.
//

import Foundation
import LineSDK
import FirebaseAuth

public class LineAuthProvider: AuthCredential {
    
    var loginResult: LoginResult
    init(loginResult: LoginResult) {
        self.loginResult = loginResult
    }
    
    static func credential(loginResult: LoginResult) -> LineAuthProvider {
        return LineAuthProvider(loginResult: loginResult)
    }
}
