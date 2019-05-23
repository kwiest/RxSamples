//
//  NiblessView.swift
//  RxSampleiOS
//
//  Created by Kyle on 5/17/19.
//  Copyright © 2019 Blue Bottle Coffee. All rights reserved.
//

import UIKit

class NiblessView: UIView {
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable,
  message: "Loading this view from a nib is unsupported in favor of initializer dependency injection."
  )
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
  }
}
