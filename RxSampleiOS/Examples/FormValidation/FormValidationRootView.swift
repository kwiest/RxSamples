//
//  FormValidationRootView.swift
//  RxSampleiOS
//
//  Created by Kyle on 5/23/19.
//  Copyright © 2019 Blue Bottle Coffee. All rights reserved.
//

import UIKit
import RxSwift

class FormValidationRootView: NiblessView {
  // MARK: Properties
  private let viewModel: FormValidationViewModel

  private var hierarchyNotReady = true

  private let disposeBag = DisposeBag()

  private lazy var formStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [nameInput,
                                               emailInput,
                                               passwordInput,
                                               submitButton])
    stack.axis = .vertical
    stack.alignment = .leading
    stack.spacing = 20
    return stack
  }()

  private let activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .gray)
    indicator.hidesWhenStopped = true
    return indicator
  }()

  let nameInput = FormInput(type: .text,
                            title: "Your name",
                            placeholder: "First name, Last name",
                            validations: [FormValidation.notEmpty])
  let emailInput = FormInput(type: .email,
                             title: "Email address",
                             placeholder: "me@example.com",
                             validations: [FormValidation.notEmpty,
                                           FormValidation.email])
  let passwordInput = FormInput(type: .password,
                                title: "Password (must contain a number)",
                                placeholder: "Super secure password",
                                validations: [FormValidation.notEmpty,
                                              FormValidation.containsNumber])

  let submitButton: UIButton = {
    let button = BlueButton(title: "Submit")
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.widthAnchor.constraint(equalToConstant: 200).isActive = true
    return button
  }()

  // MARK: Initializers
  init(frame: CGRect = .zero,
       viewModel: FormValidationViewModel) {
    self.viewModel = viewModel

    super.init(frame: frame)
    bindInputsToViewModel()
    bindViewModelToView()
  }

  // MARK: Overridden methods
  override func didMoveToWindow() {
    super.didMoveToWindow()

    guard hierarchyNotReady else { return }

    styleView()
    constructHierarchy()
    activateConstraints()
    setupSubmitButton()

    hierarchyNotReady = false
  }

  // MARK: Private methods
  private func styleView() {
    backgroundColor = .white
  }

  private func constructHierarchy() {
    addSubview(formStack)
    addSubview(activityIndicator)
  }

  private func setupSubmitButton() {
    submitButton.addTarget(viewModel,
                           action: #selector(FormValidationViewModel.submit),
                           for: .touchUpInside)
  }
}

extension FormValidationRootView {
  private func activateConstraints() {
    activateInputStackConstraints()
    activateActivityIndicatorConstraints()
  }

  private func activateInputStackConstraints() {
    formStack.translatesAutoresizingMaskIntoConstraints = false
    let top = formStack.topAnchor
      .constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50)
    let leading = formStack.leadingAnchor
      .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 50)
    NSLayoutConstraint.activate([top, leading])
  }

  private func activateActivityIndicatorConstraints() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    let centerX = activityIndicator.centerXAnchor
      .constraint(equalTo: centerXAnchor)
    let centerY = activityIndicator.centerYAnchor
      .constraint(equalTo: centerYAnchor)
    NSLayoutConstraint.activate([centerX, centerY])
  }
}

extension FormValidationRootView {
  private func bindViewModelToView() {
    bindSubmitButtonEnabled()
    bindActivityIndicatorAnimating()
  }

  private func bindSubmitButtonEnabled() {
    viewModel.submitButtonEnabled
      .asDriver(onErrorJustReturn: true)
      .drive(submitButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }

  private func bindActivityIndicatorAnimating() {
    viewModel.activityIndicatorAnimating
      .asDriver(onErrorJustReturn: false)
      .drive(activityIndicator.rx.isAnimating)
      .disposed(by: disposeBag)
  }
}

extension FormValidationRootView {
  private func bindInputsToViewModel() {
    bindNameToViewModel()
    bindEmailToViewModel()
    bindPasswordToViewModel()
  }

  private func bindNameToViewModel() {
    nameInput.inputValue
      .asDriver(onErrorJustReturn: "")
      .drive(viewModel.nameValue)
      .disposed(by: disposeBag)

    nameInput.isValid
      .asDriver(onErrorJustReturn: true)
      .drive(viewModel.nameIsValid)
      .disposed(by: disposeBag)
  }

  private func bindEmailToViewModel() {
    emailInput.inputValue
      .asDriver(onErrorJustReturn: "")
      .drive(viewModel.emailValue)
      .disposed(by: disposeBag)

    emailInput.isValid
      .asDriver(onErrorJustReturn: true)
      .drive(viewModel.emailIsValid)
      .disposed(by: disposeBag)
  }

  private func bindPasswordToViewModel() {
    passwordInput.inputValue
      .asDriver(onErrorJustReturn: "")
      .drive(viewModel.passwordValue)
      .disposed(by: disposeBag)

    passwordInput.isValid
      .asDriver(onErrorJustReturn: true)
      .drive(viewModel.passwordIsValid)
      .disposed(by: disposeBag)
  }
}
