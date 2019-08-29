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
    static func register(to tableView: UITableView) {
        TableViewCell<Self>.register(to: tableView)
    }
    
    /// Dequeue Injectable cell instance from tableView
    ///
    /// - Parameters:
    ///   - tableView: Parent tableView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The ViewController's input.
    ///   - parentViewController: ParentViewController that must has tableView.
    /// - Returns: The Cell instance that added the ViewController.view, and the ViewController have injected dependency, VC hierarchy.
    static func dequeueCell<V>(from tableView: UITableView, for indexPath: IndexPath, input: Self.Input, parentViewController: V) -> UITableViewCell where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return TableViewCell<Self>.dequeued(from: tableView, for: indexPath, input: input, parentViewController: parentViewController)
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
    static func dequeueCell<V>(from tableView: UITableView, for indexPath: IndexPath, input: Self.Input, output: ((Self.Output) -> Void)?, parentViewController: V) -> UITableViewCell where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return TableViewCell<Self>.dequeued(from: tableView, for: indexPath, input: input, output: output, parentViewController: parentViewController)
    }
}

// MARK: - TableViewCell with UIView
public extension Instantiatable where Self: UIView, Self: Injectable {
    /// Register dequeueable cell class for tableView
    ///
    /// - Parameter tableView: Parent tableView
    static func register(to tableView: UITableView) {
        ViewController<Self>.register(to: tableView)
    }
    
    /// Dequeue Injectable cell instance from tableView
    ///
    /// - Parameters:
    ///   - tableView: Parent tableView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The View's input.
    ///   - parentViewController: ParentViewController that must has tableView.
    /// - Returns: The Cell instance that added the View.
    static func dequeueCell<V>(from tableView: UITableView, for indexPath: IndexPath, input: Self.Input, parentViewController: V) -> UITableViewCell where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return ViewController<Self>.dequeueCell(from: tableView, for: indexPath, input: input, parentViewController: parentViewController)
    }
}

public extension Instantiatable where Self: UIView, Self: Injectable, Self: Emittable {
    /// Dequeue Injectable/Emittable cell instance from tableView
    ///
    /// - Parameters:
    ///   - tableView: Parent tableView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The View's input.
    ///   - output: Handler for View's output. Start handling when cell init. Don't replace handler when cell reused.
    ///   - parentViewController: ParentViewController that must has tableView.
    /// - Returns: The Cell instance that added the View.
    static func dequeueCell<V>(from tableView: UITableView, for indexPath: IndexPath, input: Self.Input, output: ((Self.Output) -> Void)?, parentViewController: V) -> UITableViewCell where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return ViewController<Self>.dequeueCell(from: tableView, for: indexPath, input: input, output: output, parentViewController: parentViewController)
    }
}


