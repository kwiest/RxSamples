//
//  RootViewController.swift
//  RxSampleiOS
//
//  Created by Kyle on 5/17/19.
//  Copyright © 2019 Blue Bottle Coffee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RootViewController: NiblessViewController {
  private enum ViewState {
    case formValidation
    case tapping
  }

  private let viewing = PublishSubject<ViewState>()
  private let disposeBag = DisposeBag()

  private let rootView = RootView()
  private let formValidationController = FormValidationViewController()

  override func loadView() {
    view = rootView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    rootView.formInputExampleButton.rx.tap
      .asControlEvent()
      .subscribe(onNext: { _ in
        self.viewing.onNext(.formValidation)
      })
      .disposed(by: disposeBag)

    viewing.asObservable()
      .subscribe(onNext: { view in self.present(view) })
      .disposed(by: disposeBag)
  }

  private func present(_ view: ViewState) {
    switch view {
    case .formValidation:
      present(formValidationController, animated: true)
    case .tapping:
      print("TBD")
    }
  }
}
