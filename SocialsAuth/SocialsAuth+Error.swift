//
//  SocialsAuth+Error.swift
//  SocialsAuth
//
//  Created by thachnn on 7/28/19.
//  Copyright © 2019 thachnn. All rights reserved.
//

import Foundation

public struct SocialsAuthErrorCode {
    public static let SocialsAuthDefaultErrorCode = 93
}

extension SocialsAuth {
    internal static var defaultError: Error {
        return NSError(domain: "SocialsAuth.DefaultError", code: SocialsAuthErrorCode.SocialsAuthDefaultErrorCode, userInfo: ["message": "Service.Error.DefaultMessage"])
    }
}
