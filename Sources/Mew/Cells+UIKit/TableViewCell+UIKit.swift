//
//  TableViewCell+UIKit.swift
//  Mew
//
//  Created by Shun Usami on 2019/08/28.
//  Copyright © 2019 Mercari. All rights reserved.
//

import UIKit

// MARK: - TableViewCell with UIViewController
public extension Instantiatable where Self: UIViewController, Self: Injectable {
    /// Register dequeueable cell class for tableView
    ///
    /// - Parameter tableView: Parent tableView
    static func registerAsTableViewCell(on tableView: UITableView) {
        TableViewCell<Self>.internalRegister(to: tableView)
    }
    
    /// Dequeue Injectable cell instance from tableView
    ///
    /// - Parameters:
    ///   - tableView: Parent tableView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The ViewController's input.
    ///   - parentViewController: ParentViewController that must has tableView.
    /// - Returns: The Cell instance that added the ViewController.view, and the ViewController have injected dependency, VC hierarchy.
    static func dequeueAsTableViewCell<V>(from tableView: UITableView, for indexPath: IndexPath, input: Self.Input, parentViewController: V) -> UITableViewCell where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return TableViewCell<Self>.internalDequeued(from: tableView, for: indexPath, input: input, parentViewController: parentViewController)
    }
}

public extension Instantiatable where Self: UIViewController, Self: Injectable, Self: Emittable {
    /// Dequeue Injectable/Emittable cell instance from tableView
    ///
    /// - Parameters:
    ///   - tableView: Parent tableView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The ViewController's input.
    ///   - output: Handler for ViewController's output. Start handling when cell init. Don't replace handler when cell reused.
    ///   - parentViewController: ParentViewController that must has tableView.
    /// - Returns: The Cell instance that added the ViewController.
    static func dequeueAsTableViewCell<V>(from tableView: UITableView, for indexPath: IndexPath, input: Self.Input, output: ((Self.Output) -> Void)?, parentViewController: V) -> UITableViewCell where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return TableViewCell<Self>.internalDequeued(from: tableView, for: indexPath, input: input, output: output, parentViewController: parentViewController)
    }
}

// MARK: - TableViewCell with UIView
public extension Injectable where Self: UIView {
    /// Register dequeueable cell class for tableView
    ///
    /// - Parameters:
    ///   - tableView: Parent tableView
    ///   - environmentType: environment type use when dequeue.
    static func registerAsTableViewCell<Environment>(on tableView: UITableView, environmentType: Environment.Type) {
        ViewController<Self, Environment>.registerAsTableViewCell(on: tableView)
    }
    
    /// Register dequeueable cell class for tableView
    ///
    /// - Parameters:
    ///   - tableView: Parent tableView
    ///   - parent: Parent viewController 
    static func registerAsTableViewCell<Parent>(on tableView: UITableView, parent: Parent) where Parent: Instantiatable {
        registerAsTableViewCell(on: tableView, environmentType: Parent.Environment.self)
    }
    
    
    /// Dequeue Injectable cell instance from tableView
    ///
    /// - Parameters:
    ///   - tableView: Parent tableView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The View's input.
    ///   - parentViewController: ParentViewController that must has tableView.
    /// - Returns: The Cell instance that added the View.
    static func dequeueAsTableViewCell<V>(from tableView: UITableView, for indexPath: IndexPath, input: Self.Input, parentViewController: V) -> UITableViewCell where V: UIViewController, V: Instantiatable {
        return ViewController<Self, V.Environment>.dequeueAsTableViewCell(from: tableView, for: indexPath, input: input, parentViewController: parentViewController)
    }
}

public extension Injectable where Self: UIView, Self: Emittable {
    /// Dequeue Injectable/Emittable cell instance from tableView
    ///
    /// - Parameters:
    ///   - tableView: Parent tableView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The View's input.
    ///   - output: Handler for View's output. Start handling when cell init. Don't replace handler when cell reused.
    ///   - parentViewController: ParentViewController that must has tableView.
    /// - Returns: The Cell instance that added the View.
    static func dequeueAsTableViewCell<V>(from tableView: UITableView, for indexPath: IndexPath, input: Self.Input, output: ((Self.Output) -> Void)?, parentViewController: V) -> UITableViewCell where V: UIViewController, V: Instantiatable {
        return ViewController<Self, V.Environment>.dequeueAsTableViewCell(from: tableView, for: indexPath, input: input, output: output, parentViewController: parentViewController)
    }
}


