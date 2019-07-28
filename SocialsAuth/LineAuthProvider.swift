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
    
    private var accessToken: String
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    static func credential(accessToken: LoginResult) -> LineAuthProvider {
        return LineAuthProvider(accessToken: accessToken.accessToken.value)
    }
}
