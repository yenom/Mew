//
//  ViewControllerResponse.swift
//  Mew
//
//  Created by Shun Usami on 2019/06/26.
//  Copyright © 2019 Mercari. All rights reserved.
//

import Foundation
import UIKit

public final class ViewControllerResponse {
    public let viewController: UIViewController
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

public final class InjectableViewControllerResponse<Input> {
    public let viewController: UIViewController
    public let input: (Input) -> Void
    
    public init(viewController: UIViewController,
                input: @escaping (Input) -> Void) {
        self.viewController = viewController
        self.input = input
    }
}

public final class EmittableViewControllerResponse<Output> {
    public let viewController: UIViewController
    public let output: (((Output) -> Void)?) -> Void
    
    public init(viewController: UIViewController,
                output: @escaping (((Output) -> Void)?) -> Void) {
        self.viewController = viewController
        self.output = output
    }
}

public final class InteractableViewControllerResponse<Input, Output> {
    public let viewController: UIViewController
    public let input: (Input) -> Void
    public let output: (((Output) -> Void)?) -> Void
    
    public init(viewController: UIViewController,
                input: @escaping (Input) -> Void,
                output: @escaping (((Output) -> Void)?) -> Void) {
        self.viewController = viewController
        self.input = input
        self.output = output
    }
}
