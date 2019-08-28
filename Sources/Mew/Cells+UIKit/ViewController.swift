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
internal class ViewController<T: UIView>: UIViewController, Instantiatable where T: Instantiatable {
    typealias Input = T.Input
    typealias Environment = T.Environment
    var environment: T.Environment { return content.environment }
    var content: T
    required init(with input: Input, environment: Environment) {
        self.content = T(with: input, environment: environment)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ViewController: Injectable where T: Injectable {
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
