//
//  CollectionReusableView+UIKit.swift
//  Mew
//
//  Created by Shun Usami on 2019/08/28.
//  Copyright © 2019 Mercari. All rights reserved.
//

import UIKit

// MARK: - CollectionReusableView with UIViewController
public extension Instantiatable where Self: UIViewController, Self: Injectable {
    /// Register dequeueable header/footer class for collectionView
    ///
    /// - Parameter collectionView: Parent collectionView
    static func registerAsCollectionViewHeaderFooterView(on collectionView: UICollectionView, for kind: CollectionViewSupplementaryKind) {
        CollectionReusableView<Self>.internalRegister(to: collectionView, for: kind)
    }
    
    /// Dequeue Injectable header/footer instance from collectionView
    ///
    /// - Parameters:
    ///   - collectionView: Parent collectionView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The ViewController's input.
    ///   - sizeConstraint: Requirement maximum size of Cell.
    ///   - parentViewController: ParentViewController that must has collectionView.
    /// - Returns: The header/footer instance that added the ViewController.view, and the ViewController have injected dependency, VC hierarchy.
    static func dequeueAsCollectionViewHeaderFooterView<V>(from collectionView: UICollectionView, of kind: String, for indexPath: IndexPath, input: Self.Input, sizeConstraint: SizeConstraint? = nil, parentViewController: V) -> UICollectionReusableView where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return CollectionReusableView<Self>.internalDequeued(from: collectionView, of: kind, for: indexPath, input: input, sizeConstraint: sizeConstraint, parentViewController: parentViewController)
    }
}

public extension Instantiatable where Self: UIViewController, Self: Injectable, Self: Emittable {
    /// Dequeue Injectable/Emittable header/footer instance from collectionView
    ///
    /// - Parameters:
    ///   - collectionView: Parent collectionView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The ViewController's input.
    ///   - output: Handler for ViewController's output. Start handling when cell init. Don't replace handler when cell reused.
    ///   - sizeConstraint: Requirement maximum size of Cell.
    ///   - parentViewController: ParentViewController that must has collectionView.
    /// - Returns: The header/footer instance that added the ViewController.
    static func dequeueAsCollectionViewHeaderFooterView<V>(from collectionView: UICollectionView, of kind: String, for indexPath: IndexPath, input: Self.Input, output: ((Self.Output) -> Void)?, sizeConstraint: SizeConstraint? = nil, parentViewController: V) -> UICollectionReusableView where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return CollectionReusableView<Self>.internalDequeued(from: collectionView, of: kind, for: indexPath, input: input, output: output, sizeConstraint: sizeConstraint, parentViewController: parentViewController)
    }
}


// MARK: - CollectionReusableView with UIView
public extension Injectable where Self: UIView {
    /// Register dequeueable header/footer class for collectionView
    ///
    /// - Parameters:
    ///   - collectionView: Parent collectionView
    ///   - kind: SupplementaryView of kind
    ///   - environmentType: environment type use when dequeue.
    static func registerAsCollectionViewHeaderFooterView<Environment>(on collectionView: UICollectionView, for kind: CollectionViewSupplementaryKind, environmentType: Environment.Type) {
        ViewController<Self, Environment>.registerAsCollectionViewHeaderFooterView(on: collectionView, for: kind)
    }
    
    /// Register dequeueable cell class for tableView
    ///
    /// - Parameters:
    ///   - collectionView: Parent collectionView
    ///   - kind: SupplementaryView of kind
    ///   - parent: Parent viewController
    static func registerAsCollectionViewHeaderFooterView<Parent>(on collectionView: UICollectionView, for kind: CollectionViewSupplementaryKind, parent: Parent) where Parent: Instantiatable {
        registerAsCollectionViewHeaderFooterView(on: collectionView, for: kind, environmentType: Parent.Environment.self)
    }
    /// Dequeue Injectable header/footer instance from collectionView
    ///
    /// - Parameters:
    ///   - collectionView: Parent collectionView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The View's input.
    ///   - sizeConstraint: Requirement maximum size of Cell.
    ///   - parentViewController: ParentViewController that must has collectionView.
    /// - Returns: The header/footer instance that added the View.
    static func dequeueAsCollectionViewHeaderFooterView<V>(from collectionView: UICollectionView, of kind: String, for indexPath: IndexPath, input: Self.Input, sizeConstraint: SizeConstraint? = nil, parentViewController: V) -> UICollectionReusableView where V: UIViewController, V: Instantiatable {
        return ViewController<Self, V.Environment>.dequeueAsCollectionViewHeaderFooterView(from: collectionView, of: kind, for: indexPath, input: input, sizeConstraint: sizeConstraint, parentViewController: parentViewController)
    }
}

public extension Injectable where Self: UIView, Self: Emittable {
    /// Dequeue Injectable/Emittable header/footer instance from collectionView
    ///
    /// - Parameters:
    ///   - collectionView: Parent collectionView that must have registered cell.
    ///   - indexPath: indexPath for dequeue.
    ///   - input: The View's input.
    ///   - output: Handler for View's output. Start handling when cell init. Don't replace handler when cell reused.
    ///   - sizeConstraint: Requirement maximum size of Cell.
    ///   - parentViewController: ParentViewController that must has collectionView.
    /// - Returns: The header/footer instance that added the View.
    static func dequeueAsCollectionViewHeaderFooterView<V>(from collectionView: UICollectionView, of kind: String, for indexPath: IndexPath, input: Self.Input, output: ((Self.Output) -> Void)?, sizeConstraint: SizeConstraint? = nil, parentViewController: V) -> UICollectionReusableView where V: UIViewController, V: Instantiatable {
        return ViewController<Self, V.Environment>.dequeueAsCollectionViewHeaderFooterView(from: collectionView, of: kind, for: indexPath, input: input, output: output, sizeConstraint: sizeConstraint, parentViewController: parentViewController)
    }
}

