//
//  Controls.swift
//  TokamakDemo
//
//  Created by Max Desiatov on 14/02/2019.
//  Copyright © 2019 Max Desiatov. Tokamak is available under the Apache 2.0
//  license. See the LICENSE file for more info.
//

import Tokamak

struct Controls: LeafComponent {
  typealias Props = Null

  static func render(props: Props, hooks: Hooks) -> AnyNode {
    let sliding = hooks.state(0.5 as Float)
    let switchState = hooks.state(true)
    let stepperState = hooks.state(0.0)
    let isEnabled = hooks.state(true)

    let children = [
      StackView.node(
        .init(
          alignment: .center,
          axis: .horizontal,
          spacing: 10.0
        ), [
          Switch.node(
            .init(
              value: isEnabled.value,
              valueHandler: Handler(isEnabled.set)
            )
          ),

          Label.node(.init(
            alignment: .center,
            text: "isEnabled \(isEnabled.value)"
          )),
        ]
      ),

      Slider.node(.init(
        Style(Width.equal(to: .parent)),
        isEnabled: isEnabled.value,
        value: sliding.value,
        valueHandler: Handler(sliding.set)
      )),

      Label.node(.init(alignment: .center, text: "\(sliding.value)")),

      StackView.node(
        .init(
          alignment: .center,
          axis: .horizontal,
          spacing: 10.0
        ), [
          Switch.node(
            .init(
              isEnabled: isEnabled.value,
              value: switchState.value,
              valueHandler: Handler(switchState.set)
            )
          ),

          Label.node(.init(alignment: .center, text: "\(switchState.value)")),
        ]
      ),

      StackView.node(
        .init(
          alignment: .center,
          axis: .horizontal,
          spacing: 10.0
        ), [
          Stepper.node(
            .init(
              autorepeat: false,
              isEnabled: isEnabled.value,
              maximumValue: 5.0,
              minimumValue: -5.0,
              stepValue: 0.5,
              value: stepperState.value,
              valueHandler: Handler(stepperState.set),
              wraps: true
            )
          ),

          Label.node(.init(alignment: .center, text: "\(stepperState.value)")),
        ]
      ),
    ]

    return StackView.node(
      .init(
        Edges.equal(to: .safeArea),
        alignment: .center,
        axis: .vertical,
        distribution: .fillEqually
      ),
      children
    )
  }
}
