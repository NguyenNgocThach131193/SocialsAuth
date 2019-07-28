//
//  SocialsAuthResult.swift
//  SocialsAuth
//
//  Created by thachnn on 7/28/19.
//  Copyright © 2019 thachnn. All rights reserved.
//

import Foundation

public enum Result<Success, Failure> where Failure : Error {
    
    /// A success, storing a `Success` value.
    case success(Success)
    
    /// A failure, storing a `Failure` value.
    case failure(Failure)
    
}

extension Result {
    
}

extension Result : Equatable where Success : Equatable, Failure : Equatable {
    
}

extension Result : Hashable where Success : Hashable, Failure : Hashable {
    
}
