//
//  FormValidationViewController.swift
//  RxSampleiOS
//
//  Created by Kyle on 5/23/19.
//  Copyright © 2019 Blue Bottle Coffee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FormValidationViewController: NiblessViewController {
  private let viewModel: FormValidationViewModel
  private let formValidationView: FormValidationRootView
  
  private let disposeBag = DisposeBag()
  
  override init() {
    self.viewModel = FormValidationViewModel()
    self.formValidationView = FormValidationRootView(viewModel: viewModel)
    
    super.init()
  }
  
  override func loadView() {
    view = formValidationView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindViewModelState()
  }
  
  // MARK: Private methods
  private func bindViewModelState() {
    viewModel.state
      .subscribe(onNext: { [weak self] state in
        switch state {
        case .collecting:
          print("Collecting data...")
        case let .submitted(name: name, email: email, password: password):
          self?.submitted(name: name, email: email, password: password)
        }
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: Public methods
  func submitted(name: String, email: String, password: String) {
    let message = "Name: \(name), Email: \(email), Password: \(password)"
    let alert = UIAlertController(title: "Hey!",
                                  message: message,
                                  preferredStyle: .alert)
    let action = UIAlertAction(title: "Bye", style: .default) { _ in
      self.dismiss(animated: true)
    }
    alert.addAction(action)
    
    present(alert, animated: true)
  }
}
