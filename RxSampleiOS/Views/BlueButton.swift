//
//  BlueButton.swift
//  RxSampleiOS
//
//  Created by Kyle on 5/17/19.
//  Copyright © 2019 Blue Bottle Coffee. All rights reserved.
//

import UIKit

class BlueButton: UIButton {
  init(frame: CGRect = .zero, title: String) {
    super.init(frame: frame)

    setup(title: title)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("Cannot be instantiated from storyboard or nib.")
  }

  override var isEnabled: Bool {
    didSet {
      if isEnabled {
        backgroundColor = .brandBlue
      } else {
        backgroundColor = .gray80
      }
    }
  }

  // MARK: Private methods
  private func setup(title: String) {
    setTitle(title, for: .normal)
    titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 16)!
    titleLabel?.textColor = .white
  }
}
