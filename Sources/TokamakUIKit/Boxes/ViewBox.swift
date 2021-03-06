//
//  ViewBox.swift
//  TokamakUIKit
//
//  Created by Max Desiatov on 29/12/2018.
//

import Tokamak
import UIKit

class ViewBox<T: UIView>: ViewControllerBox<UIViewController> {
  let view: T

  /// Array of constraints installed from props that configured this view
  var constraints = [NSLayoutConstraint]()

  init(_ view: T, _ viewController: UIViewController, _ node: AnyNode) {
    self.view = view

    super.init(viewController, node)
  }

  override var refTarget: Any {
    return view
  }

  func addChild<T>(_ vc: ViewControllerBox<T>) {
    vc.viewController.willMove(toParent: viewController)
    // FIXME: replace with auto layout constraints
    vc.viewController.view.frame = view.frame
    view.addSubview(vc.viewController.view)
    viewController.addChild(vc.viewController)
    vc.viewController.didMove(toParent: viewController)
  }
}
