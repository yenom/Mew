//
//  TableViewHeaderFooterView+UIKit.swift
//  Mew
//
//  Created by Shun Usami on 2019/08/28.
//  Copyright © 2019 Mercari. All rights reserved.
//

import UIKit

// MARK: - TableViewHeaderFooterView with UIViewController
public extension Instantiatable where Self: UIViewController, Self: Injectable {
    /// Register dequeueable header/footer class for tableView
    ///
    /// - Parameter tableView: Parent tableView
    static func registerAsTableViewHeaderFooterView(on tableView: UITableView) {
        TableViewHeaderFooterView<Self>.register(to: tableView)
    }
    
    /// Dequeue Injectable header/footer instance from tableView
    ///
    /// - Parameters:
    ///   - tableView: Parent tableView that must have registered header/footer.
    ///   - input: The ViewController's input.
    ///   - parentViewController: ParentViewController that must has tableView.
    /// - Returns: The header/footer instance that added the ViewController.view, and the ViewController have injected dependency, VC hierarchy.
    static func dequeueAsTableViewHeaderFooterView<V>(from tableView: UITableView, input: Self.Input, parentViewController: V) -> UITableViewHeaderFooterView where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return TableViewHeaderFooterView<Self>.dequeued(from: tableView, input: input, parentViewController: parentViewController)
    }
}

public extension Instantiatable where Self: UIViewController, Self: Injectable, Self: Emittable {
    /// Dequeue Injectable/Emittable header/footer instance from tableView
    ///
    /// - Parameters:
    ///   - tableView: Parent tableView that must have registered header/footer.
    ///   - input: The ViewController's input.
    ///   - output: Handler for ViewController's output. Start handling when cell init. Don't replace handler when cell reused.
    ///   - parentViewController: ParentViewController that must has tableView.
    /// - Returns: The header/footer instance that added the ViewController.
    static func dequeueAsTableViewHeaderFooterView<V>(from tableView: UITableView, input: Self.Input, output: ((Self.Output) -> Void)?, parentViewController: V) -> UITableViewHeaderFooterView where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return TableViewHeaderFooterView<Self>.dequeued(from: tableView, input: input, output: output, parentViewController: parentViewController)
    }
}


// MARK: - TableViewHeaderFooterView with UIView
public extension Instantiatable where Self: UIView, Self: Injectable {
    /// Register dequeueable header/footer class for tableView
    ///
    /// - Parameter tableView: Parent tableView
    static func registerAsTableViewHeaderFooterView(on tableView: UITableView) {
        ViewController<Self>.registerAsTableViewHeaderFooterView(on: tableView)
    }
    
    /// Dequeue Injectable header/footer instance from tableView
    ///
    /// - Parameters:
    ///   - tableView: Parent tableView that must have registered header/footer.
    ///   - input: The View's input.
    ///   - parentViewController: ParentViewController that must has tableView.
    /// - Returns: The header/footer instance that added the View.
    static func dequeueAsTableViewHeaderFooterView<V>(from tableView: UITableView, input: Self.Input, parentViewController: V) -> UITableViewHeaderFooterView where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return ViewController<Self>.dequeueAsTableViewHeaderFooterView(from: tableView, input: input, parentViewController: parentViewController)
    }
}

public extension Instantiatable where Self: UIView, Self: Injectable, Self: Emittable {
    /// Dequeue Injectable/Emittable header/footer instance from tableView
    ///
    /// - Parameters:
    ///   - tableView: Parent tableView that must have registered header/footer.
    ///   - input: The View's input.
    ///   - output: Handler for View's output. Start handling when cell init. Don't replace handler when cell reused.
    ///   - parentViewController: ParentViewController that must has tableView.
    /// - Returns: The header/footer instance that added the View.
    static func dequeueAsTableViewHeaderFooterView<V>(from tableView: UITableView, input: Self.Input, output: ((Self.Output) -> Void)?, parentViewController: V) -> UITableViewHeaderFooterView where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return ViewController<Self>.dequeueAsTableViewHeaderFooterView(from: tableView, input: input, output: output, parentViewController: parentViewController)
    }
}
