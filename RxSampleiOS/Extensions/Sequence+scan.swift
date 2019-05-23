//
//  Sequence+scan.swift
//  RxSampleiOS
//
//  Created by Kyle on 5/22/19.
//  Copyright © 2019 Blue Bottle Coffee. All rights reserved.
//

extension Sequence {
  typealias E = Element

  func scan<T>(_ initial: T, _ combine: (T, E) -> T) -> [T] {
    var acc = initial
    return self.map { (num: E) -> T in
      acc = combine(acc, num)
      return acc
    }
  }
}
