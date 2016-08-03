//
//  GenericError.swift
//  DigitalDay
//
//  Created by SalmoJunior on 8/3/16.
//  Copyright © 2016 CI&T. All rights reserved.
//

import Foundation

enum GenericError : ErrorType {
    case Parse(String)
    case InvalidURL
    case NotFound
    case Connection
    case Server
    case Unexpected
}