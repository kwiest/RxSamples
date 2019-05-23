//
//  FormInput.swift
//  RxSampleiOS
//
//  Created by Kyle on 5/20/19.
//  Copyright © 2019 Blue Bottle Coffee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum FormInputType {
  case text
  case email
  case password
  case number
}

class FormInput: UIStackView {
  // MARK: Public properties
  var inputValue: Observable<String> {
    return input.rx.text.asObservable()
      .filter { $0 != nil }
      .map { $0! }
  }
  var isValid: Observable<Bool> {
    if validations.isEmpty {
      return Observable.just(true)
    }

    return errors.asObservable()
      .map { $0.isEmpty }
      .skip(1)
  }

  // MARK: Private properties
  private let validations: [Validation<String>]
  private var errors = BehaviorSubject<[String]>(value: [])
  private let disposeBag = DisposeBag()

  private let label: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 14)
    label.textColor = .gray
    return label
  }()

  private var input: UITextField = {
    let input = UITextField()
    input.autocapitalizationType = .none
    input.autocorrectionType = .no
    return input
  }()

  private var error: UILabel = {
    let label = UILabel()
    label.text = ""
    label.textColor = .red
    label.font = .systemFont(ofSize: 12)
    return label
  }()

  init(frame: CGRect = .zero,
       type: FormInputType = .text,
       title: String,
       placeholder: String? = nil,
       validations: [Validation<String>] = []) {
    self.validations = validations

    super.init(frame: frame)
    
    setupValues(type: type, title: title, placeholder: placeholder)
    setupView()
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("Cannot be instantiated from storyboard or nib.")
  }

  // MARK: Private methods
  private func setupValues(type: FormInputType,
                     title: String,
                     placeholder: String?) {
    setKeyboardType(type)
    label.text = title
    input.placeholder = placeholder
    liveValidate()
  }

  private func setupView() {
    addArrangedSubview(label)
    addArrangedSubview(input)
    addArrangedSubview(error)
    axis = .vertical
    alignment = .leading
    spacing = 10
  }

  private func setKeyboardType(_ type: FormInputType) {
    switch type {
    case .email:
      input.keyboardType = .emailAddress
    case .password:
      input.isSecureTextEntry = true
    case .number:
      input.keyboardType = .numberPad
    default:
      input.keyboardType = .asciiCapable
    }
  }

  private func liveValidate() {
    input.rx.text
      .skip(1)
      .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
      .filter { $0 != nil }
      .distinctUntilChanged()
      .map { self.validate($0!) }
      .bind(to: self.errors)
      .disposed(by: disposeBag)

    errors
      .map { $0.joined(separator: ". ") }
      .bind(to: self.error.rx.text)
      .disposed(by: disposeBag)
  }

  private func validate(_ value: String) -> [String] {
    return validations.reduce([], { validationErrors, validation in
      var localErrors = validationErrors
      switch validation(value) {
      case .invalid(let errorMessage):
        localErrors.append(errorMessage)
      case .valid:
        break
      }

      return localErrors
    })
  }
}
