//
//  CellProtocol.swift
//  Mew
//
//  Created by tarunon on 2018/09/07.
//  Copyright © 2018 Mercari. All rights reserved.
//

import UIKit

internal protocol CellProtocol: AnyObject {
    associatedtype Content: UIViewController
    var contentView: UIView { get }
    var contentViewController: Content? { get set }
    var parentViewController: UIViewController? { get set }
}

extension CellProtocol where Self: UIView {
    internal static var reuseIdentifier: String {
        return String(describing: ObjectIdentifier(Content.self).hashValue)
    }

    internal func _willMove(to newSuperview: UIView?) {
        guard let contentViewController = contentViewController else { return }
        if newSuperview == nil {
            contentViewController.willMove(toParent: parentViewController)
        } else {
            parentViewController?.addChild(contentViewController)
        }
    }

    internal func _didMoveToSuperview() {
        guard let contentViewController = contentViewController else { return }
        if superview == nil {
            contentViewController.removeFromParent()
        } else {
            contentViewController.didMove(toParent: parentViewController)
        }
    }
}

internal protocol TableViewCellProtocol: CellProtocol {}

extension TableViewCellProtocol where Self: UIView {
    internal func addViewController(_ viewController: Content, parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        self.contentViewController = viewController
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        _willMove(to: superview)
        contentView.addSubview(viewController.view)
        NSLayoutConstraint.activate(
            [
                viewController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                viewController.view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                viewController.view.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor),
                viewController.view.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
            ] + [
                viewController.view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                viewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ].map { $0.priority = UILayoutPriority.defaultHigh; return $0 }
        )
        _didMoveToSuperview()
    }
}

/// Requirement maximum size of CollectionViewCell.
public enum SizeConstraint: Equatable {
    case maximumSize(CGSize)
    case maximumWidth(CGFloat)
    case maximumHeight(CGFloat)
    /// Note: Support UICollectionViewFlowLayout sizing. Not yet UICollectionViewDelegateFlowLayout.
    case automaticDimension(UICollectionViewLayout)

    typealias Calculated = (width: CGFloat?, height: CGFloat?)

    func calculate() -> Calculated {
        switch self {
        case .maximumSize(let size):
            return (size.width, size.height)
        case .maximumWidth(let width):
            return (width, nil)
        case .maximumHeight(let height):
            return (nil, height)
        case .automaticDimension(let layout):
            let frame = layout.collectionView?.frame ?? .zero
            let direction = (layout as? UICollectionViewFlowLayout)?.scrollDirection
            let inset = (layout as? UICollectionViewFlowLayout)?.sectionInset ?? UIEdgeInsets.zero
            var result: Calculated = (nil, nil)
            if direction != UICollectionView.ScrollDirection.vertical {
                result.height = frame.height - inset.top - inset.bottom
            }
            if direction != UICollectionView.ScrollDirection.horizontal {
                result.width = frame.width - inset.left - inset.right
            }
            return result
        }
    }
}

// For Backward Compatibility
extension SizeConstraint {
    public init(from collectionViewLayout: UICollectionViewLayout) {
        self = .automaticDimension(collectionViewLayout)
    }

    public static func size(_ size: CGSize) -> SizeConstraint {
        return .maximumSize(size)
    }

    public static func dynamic(_ layout: UICollectionViewLayout) -> SizeConstraint {
        return .automaticDimension(layout)
    }
}

internal protocol CollectionViewCellProtocol: CellProtocol {
    var maxHeightConstraint: NSLayoutConstraint { get }
    var maxWidthConstraint: NSLayoutConstraint { get }
    var sizeConstraint: SizeConstraint.Calculated? { get set }
}

extension CollectionViewCellProtocol where Self: UIView {
    internal func addViewController(_ viewController: Content, parentViewController: UIViewController) {
        self.parentViewController = parentViewController
        self.contentViewController = viewController
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        _willMove(to: superview)
        contentView.addSubview(viewController.view)
        NSLayoutConstraint.activate(
            [
                viewController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                viewController.view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                viewController.view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                viewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ]
        )
        _didMoveToSuperview()
    }

    internal func updateSizeConstraint(_ sizeConstraint: SizeConstraint) {
        let newValue = sizeConstraint.calculate()
        if let oldValue = self.sizeConstraint, oldValue == newValue { return }
        self.sizeConstraint = newValue
        if let width = newValue.width {
            maxWidthConstraint.constant = width
            maxWidthConstraint.isActive = true
        } else {
            maxWidthConstraint.isActive = false
        }
        if let height = newValue.height {
            maxHeightConstraint.constant = height
            maxHeightConstraint.isActive = true
        } else {
            maxHeightConstraint.isActive = false
        }
    }
}
