//
//  FormValidationViewModel.swift
//  RxSampleiOS
//
//  Created by Kyle on 5/23/19.
//  Copyright © 2019 Blue Bottle Coffee. All rights reserved.
//

import RxSwift
import RxCocoa

class FormValidationViewModel {
  enum ViewState {
    case collecting
    case submitted(name: String, email: String, password: String)
  }

  // MARK: Properties
  var state: Observable<ViewState> { return stateSubject.asObservable() }
  private let stateSubject = BehaviorSubject<ViewState>(value: .collecting)

  let nameValue = BehaviorSubject<String>(value: "")
  let emailValue = BehaviorSubject<String>(value: "")
  let passwordValue = BehaviorSubject<String>(value: "")

  let nameIsValid = BehaviorSubject<Bool>(value: false)
  let emailIsValid = BehaviorSubject<Bool>(value: false)
  let passwordIsValid = BehaviorSubject<Bool>(value: false)

  let submitButtonEnabled = BehaviorSubject<Bool>(value: false)
  let activityIndicatorAnimating = BehaviorSubject<Bool>(value: false)

  private let disposeBag = DisposeBag()

  init() {
    bindValidState()
  }

  // MARK: Public methods
  @objc func submit() {
    indicateSigningIn()

    let (name, email, password) = getFormValues()
    stateSubject.onNext(.submitted(name: name, email: email, password: password))
  }

  // MARK: Private methods
  private func bindValidState() {
    Observable.combineLatest(nameIsValid, emailIsValid, passwordIsValid)
      .map { states in
        let (first, second, third) = states
        return first && second && third
      }
      .asDriver(onErrorJustReturn: true)
      .drive(submitButtonEnabled)
      .disposed(by: disposeBag)
  }

  private func indicateSigningIn() {
    submitButtonEnabled.onNext(false)
    activityIndicatorAnimating.onNext(true)
  }

  private func getFormValues() -> (String, String, String) {
    do {
      let name = try nameValue.value()
      let email = try emailValue.value()
      let pass = try passwordValue.value()
      return (name, email, pass)
    } catch {
      fatalError("Cannot extract form values")
    }
  }
}
