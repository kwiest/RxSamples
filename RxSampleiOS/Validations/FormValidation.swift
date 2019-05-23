//
//  FormValidation.swift
//  RxSampleiOS
//
//  Created by Kyle on 5/22/19.
//  Copyright © 2019 Blue Bottle Coffee. All rights reserved.
//

import Foundation

enum FormValidation {
  static var notEmpty: Validation<String> = { value in
    if value.isEmpty {
      return .invalid("Cannot be empty")
    }
    
    return .valid
  }

  static var email: Validation<String> {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    return matches(emailRegex, errorMessage: "Not a valid email address")
  }

  static var containsNumber: Validation<String> {
    let numRegex = ".*[0-9]+.*"

    return matches(numRegex, errorMessage: "Must contain at least one number")
  }

  static func matches<T>(_ regex: String,
                         errorMessage: String = "Does not match") -> Validation<T> {
    let test = NSPredicate(format: "SELF MATCHES %@", regex)

    return { (value: T) -> ValidationStatus in
      if test.evaluate(with: value) {
        return .valid
      }

      return .invalid(errorMessage)
    }
  }
}
