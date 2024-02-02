//
//  DataValidators.swift
//  myManga
//
//  Created by Emilian Ciprian Ignat on 20/12/23.
//

import Foundation


struct Validators {
    static let shared = Validators()
    
    func noValidate(_ value: String) -> String? {
        nil
    }
    
    func isEmpty(_ value: String) -> String? {
        value.isEmpty ? "cannot be empty." : nil
    }
    
    func validEmail(_ value: String) -> String? {
        let emailRegex = #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#
        do {
            let regex = try Regex(emailRegex)
            if let _ = try regex.wholeMatch(in: value) {
                return nil
            } else {
                return "is not a valid email."
            }
        } catch {
            return "is not a valid email."
        }
    }
    
    func greaterThan4(_ value: String) -> String? {
        var msg = ""
        if let err = isEmpty(value) {
            msg += err
        }
        if value.count < 4 {
            if msg.isEmpty {
                msg = "must be greater than 4 characters."
            } else {
                msg = "\(msg.dropLast()) and must be greater than 4 characters."
            }
        }
        if msg.isEmpty {
            return nil
        } else {
            return msg
        }
    }
    
    func passwordsMatch(_ password: String, _ confirmPassword: String) -> Bool? {
        return password == confirmPassword ? true : false
    }
}
