//
//  ViewControllerRequest.swift
//  Mew
//
//  Created by Shun Usami on 2019/06/26.
//  Copyright © 2019 Mercari. All rights reserved.
//

import Foundation
import UIKit

// Instantiatable
public protocol ViewControllerRequest: EnvironmentRequest where EnvironmentResponse == ViewControllerResponse {
    associatedtype Input
    associatedtype EnvironmentResponse = ViewControllerResponse
    
    var inputValue: Input { get }
}

extension ViewControllerRequest {
    public func response<V>(for type: V.Type, environment: V.Environment)
        -> ViewControllerResponse
        where V: UIViewController,
        V: Instantiatable,
        V.Input == Input {
            let viewController = V(with: inputValue, environment: environment)
            return ViewControllerResponse(viewController: viewController)
    }
}

// Injectable
public protocol InjectableViewControllerRequest: EnvironmentRequest where EnvironmentResponse == InjectableViewControllerResponse<Input> {
    associatedtype Input
    associatedtype EnvironmentResponse = InjectableViewControllerResponse<Input>
    
    var inputValue: Input { get }
}

extension InjectableViewControllerRequest {
    public func response<V>(for type: V.Type, environment: V.Environment)
        -> InjectableViewControllerResponse<Input>
        where V: UIViewController,
        V: Instantiatable,
        V: Injectable,
        V.Input == Input {
            let viewController = V(with: inputValue, environment: environment)
            return InjectableViewControllerResponse(
                viewController: viewController,
                input: viewController.input
            )
    }
}

// Emittable
public protocol EmittableViewControllerRequest: EnvironmentRequest where EnvironmentResponse == EmittableViewControllerResponse<Output> {
    associatedtype Input
    associatedtype Output
    associatedtype EnvironmentResponse = EmittableViewControllerResponse<Output>
    
    var inputValue: Input { get }
}

extension EmittableViewControllerRequest {
    public func response<V>(for type: V.Type, environment: V.Environment)
        -> EmittableViewControllerResponse<Output>
        where V: UIViewController,
        V: Instantiatable,
        V: Emittable,
        V.Input == Input,
        V.Output == Output {
            let viewController = V(with: inputValue, environment: environment)
            return EmittableViewControllerResponse(
                viewController: viewController,
                output: viewController.output
            )
    }
}

// Interactable
public protocol InteractableViewControllerRequest: EnvironmentRequest where EnvironmentResponse == InteractableViewControllerResponse<Input, Output> {
    associatedtype Input
    associatedtype Output
    associatedtype EnvironmentResponse = InteractableViewControllerResponse<Input, Output>
    
    var inputValue: Input { get }
}

extension InteractableViewControllerRequest {
    public func response<V>(for type: V.Type, environment: V.Environment)
        -> InteractableViewControllerResponse<Input, Output>
        where V: UIViewController,
        V: Instantiatable,
        V: Interactable,
        V.Input == Input,
        V.Output == Output {
            let viewController = V(with: inputValue, environment: environment)
            return InteractableViewControllerResponse(
                viewController: viewController,
                input: viewController.input,
                output: viewController.output
            )
    }
}
