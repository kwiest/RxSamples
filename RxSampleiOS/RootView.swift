//
//  RootView.swift
//  RxSampleiOS
//
//  Created by Kyle on 5/17/19.
//  Copyright © 2019 Blue Bottle Coffee. All rights reserved.
//

import UIKit
import RxSwift

class RootView: NiblessView {
  // MARK: Private properties
  private var hierarchyNotReady = true

  private let disposeBag = DisposeBag()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Rx Examples"
    label.font = .boldSystemFont(ofSize: 24)
    return label
  }()

  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [formInputExampleButton, tappingExampleButton])
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.alignment = .center
    stackView.spacing = 10
    return stackView
  }()

  // MARK: Public properties
  let formInputExampleButton: UIButton = {
    let button = BlueButton(title: "Form Input Example")
    button.isEnabled = true
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.widthAnchor.constraint(equalToConstant: 200).isActive = true
    return button
  }()

  let tappingExampleButton: UIButton = {
    let button = BlueButton(title: "Tapping Example")
    button.isEnabled = true
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    button.widthAnchor.constraint(equalToConstant: 200).isActive = true
    return button
  }()

  // MARK: Overridden methods
  override func didMoveToWindow() {
    super.didMoveToWindow()

    guard hierarchyNotReady else { return }

    styleView()
    constructHierarchy()
    activateConstraints()

    hierarchyNotReady = false
  }

  // MARK: Private methods
  private func styleView() {
    backgroundColor = .white
  }

  private func constructHierarchy() {
    addSubview(titleLabel)
    addSubview(buttonStackView)
  }

  private func activateConstraints() {
    activateTitleConstraints()
    activateButtonConstraints()
  }

  private func activateTitleConstraints() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    let centerX = titleLabel.centerXAnchor
      .constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
    let top = titleLabel.topAnchor
      .constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50)
    NSLayoutConstraint.activate([centerX, top])
  }

  private func activateButtonConstraints() {
    buttonStackView.translatesAutoresizingMaskIntoConstraints = false
    let top = buttonStackView.topAnchor
      .constraint(equalTo: titleLabel.bottomAnchor, constant: 50)
    let leading = buttonStackView.leadingAnchor
      .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
    let trailing = buttonStackView.trailingAnchor
      .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
    NSLayoutConstraint.activate([top, leading, trailing])
  }
}
