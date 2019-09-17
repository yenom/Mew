//
//  CollectionViewCell+UIKit.swift
//  Mew
//
//  Created by Shun Usami on 2019/08/28.
//  Copyright © 2019 Mercari. All rights reserved.
//

import UIKit

// MARK: - CollectionViewCell with UIViewController
public extension Instantiatable where Self: UIViewController, Self: Injectable {
    /// Register dequeueable cell class for collectionView
    ///
    /// - Parameter collectionView: Parent collectionView
    static func registerAsCollectionViewCell(on collectionView: UICollectionView) {
        CollectionViewCell<Self>.internalRegister(to: collectionView)
    }

    /// Dequeue Injectable cell instance from collectionView
    ///
    /// - Parameters:
    ///   - collectionView: Parent collectionView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The ViewController's input.
    ///   - sizeConstraint: Requirement maximum size of Cell.
    ///   - parentViewController: ParentViewController that must has collectionView.
    /// - Returns: The Cell instance that added the ViewController.view, and the ViewController have injected dependency, VC hierarchy.
    static func dequeueAsCollectionViewCell<V>(from collectionView: UICollectionView, for indexPath: IndexPath, input: Self.Input, sizeConstraint: SizeConstraint? = nil, parentViewController: V) -> UICollectionViewCell where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return CollectionViewCell<Self>.internalDequeued(from: collectionView, for: indexPath, input: input, sizeConstraint: sizeConstraint, parentViewController: parentViewController)
    }
}

public extension Instantiatable where Self: UIViewController, Self: Injectable, Self: Emittable {
    /// Dequeue Injectable/Emittable cell instance from collectionView
    ///
    /// - Parameters:
    ///   - collectionView: Parent collectionView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The ViewController's input.
    ///   - output: Handler for ViewController's output. Start handling when cell init. Don't replace handler when cell reused.
    ///   - sizeConstraint: Requirement maximum size of Cell.
    ///   - parentViewController: ParentViewController that must has collectionView.
    /// - Returns: The Cell instance that added the ViewController.
    static func dequeueAsCollectionViewCell<V>(from collectionView: UICollectionView, for indexPath: IndexPath, input: Self.Input, output: ((Self.Output) -> Void)?, sizeConstraint: SizeConstraint? = nil, parentViewController: V) -> UICollectionViewCell where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return CollectionViewCell<Self>.internalDequeued(from: collectionView, for: indexPath, input: input, output: output, sizeConstraint: sizeConstraint, parentViewController: parentViewController)
    }
}

// MARK: - CollectionViewCell with UIView
public extension Injectable where Self: UIView {
    /// Register dequeueable cell class for collectionView
    ///
    /// - Parameters:
    ///   - collectionView: Parent collectionView
    ///   - environmentType: environment type use when dequeue.
    static func registerAsCollectionViewCell<Environment>(on collectionView: UICollectionView, environmentType: Environment.Type) {
        ViewController<Self, Environment>.registerAsCollectionViewCell(on: collectionView)
    }
    
    /// Register dequeueable cell class for tableView
    ///
    /// - Parameters:
    ///   - collectionView: Parent collectionView
    ///   - parent: Parent viewController
    static func registerAsCollectionViewCell<Parent>(on collectionView: UICollectionView, parent: Parent) where Parent: Instantiatable {
        registerAsCollectionViewCell(on: collectionView, environmentType: Parent.Environment.self)
    }

    /// Dequeue Injectable cell instance from collectionView
    ///
    /// - Parameters:
    ///   - collectionView: Parent collectionView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The ViewController's input.
    ///   - sizeConstraint: Requirement maximum size of Cell.
    ///   - parentViewController: ParentViewController that must has collectionView.
    /// - Returns: The Cell instance that added the ViewController.view, and the ViewController have injected dependency, VC hierarchy.
    static func dequeueAsCollectionViewCell<V>(from collectionView: UICollectionView, for indexPath: IndexPath, input: Self.Input, sizeConstraint: SizeConstraint? = nil, parentViewController: V) -> UICollectionViewCell where V: UIViewController, V: Instantiatable {
        return ViewController<Self, V.Environment>.dequeueAsCollectionViewCell(from: collectionView, for: indexPath, input: input, sizeConstraint: sizeConstraint, parentViewController: parentViewController)
    }
}

public extension Injectable where Self: UIView, Self: Emittable {
    /// Dequeue Injectable/Emittable cell instance from collectionView
    ///
    /// - Parameters:
    ///   - collectionView: Parent collectionView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The ViewController's input.
    ///   - output: Handler for ViewController's output. Start handling when cell init. Don't replace handler when cell reused.
    ///   - sizeConstraint: Requirement maximum size of Cell.
    ///   - parentViewController: ParentViewController that must has collectionView.
    /// - Returns: The Cell instance that added the ViewController.
    static func dequeueAsCollectionViewCell<V>(from collectionView: UICollectionView, for indexPath: IndexPath, input: Self.Input, output: ((Self.Output) -> Void)?, sizeConstraint: SizeConstraint? = nil, parentViewController: V) -> UICollectionViewCell where V: UIViewController, V: Instantiatable {
        return ViewController<Self, V.Environment>.dequeueAsCollectionViewCell(from: collectionView, for: indexPath, input: input, output: output, sizeConstraint: sizeConstraint, parentViewController: parentViewController)
    }
}
