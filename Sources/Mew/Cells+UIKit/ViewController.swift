//
//  TableViewCell+UIView.swift
//  Mew
//
//  Created by Shun Usami on 2019/08/28.
//  Copyright © 2019 Mercari. All rights reserved.
//

import UIKit

/// ViewController wrapper for View to use UIView as T of TableViewCell.
/// T should be `UIView & Injecatble & Instantiatable`
internal class ViewController<T: UIView, Environment>: UIViewController, Instantiatable where T: Injectable {
    // MARK: - Instantiatable
    typealias Input = T.Input
    var environment: Environment
    var content: T = T(frame: .zero)
    required init(with input: Input, environment: Environment) {
        self.content.input(input)
        self.environment = environment
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: Injectable {
    func input(_ input: T.Input) {
        content.input(input)
    }
}
extension ViewController: Emittable where T: Emittable {
    typealias Output = T.Output
    func output(_ handler: ((T.Output) -> Void)?) {
        content.output(handler)
    }
}
