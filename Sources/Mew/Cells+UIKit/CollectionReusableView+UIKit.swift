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
    static func registerHeaderFooterView(on collectionView: UICollectionView, for kind: CollectionViewSupplementaryKind) {
        CollectionReusableView<Self>.register(to: collectionView, for: kind)
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
        return CollectionReusableView<Self>.dequeued(from: collectionView, of: kind, for: indexPath, input: input, sizeConstraint: sizeConstraint, parentViewController: parentViewController)
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
        return CollectionReusableView<Self>.dequeued(from: collectionView, of: kind, for: indexPath, input: input, output: output, sizeConstraint: sizeConstraint, parentViewController: parentViewController)
    }
}


// MARK: - CollectionReusableView with UIView
public extension Instantiatable where Self: UIView, Self: Injectable {
    /// Register dequeueable header/footer class for collectionView
    ///
    /// - Parameter collectionView: Parent collectionView
    static func registerHeaderFooterView(on collectionView: UICollectionView, for kind: CollectionViewSupplementaryKind) {
        ViewController<Self>.registerHeaderFooterView(on: collectionView, for: kind)
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
    static func dequeueHeaderFooterView<V>(from collectionView: UICollectionView, of kind: String, for indexPath: IndexPath, input: Self.Input, sizeConstraint: SizeConstraint? = nil, parentViewController: V) -> UICollectionReusableView where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return ViewController<Self>.dequeueAsCollectionViewHeaderFooterView(from: collectionView, of: kind, for: indexPath, input: input, sizeConstraint: sizeConstraint, parentViewController: parentViewController)
    }
}

public extension Instantiatable where Self: UIView, Self: Injectable, Self: Emittable {
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
    static func dequeueHeaderFooterView<V>(from collectionView: UICollectionView, of kind: String, for indexPath: IndexPath, input: Self.Input, output: ((Self.Output) -> Void)?, sizeConstraint: SizeConstraint? = nil, parentViewController: V) -> UICollectionReusableView where V: UIViewController, V: Instantiatable, Self.Environment == V.Environment {
        return ViewController<Self>.dequeueAsCollectionViewHeaderFooterView(from: collectionView, of: kind, for: indexPath, input: input, output: output, sizeConstraint: sizeConstraint, parentViewController: parentViewController)
    }
}

