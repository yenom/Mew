//
//  CollectionViewCellTests.swift
//  MewTests
//
//  Created by tarunon on 2018/04/04.
//  Copyright © 2018 Mercari. All rights reserved.
//

import XCTest
@testable import Mew

class CollectionViewCellTests: XCTestCase {
    func testDequeueCollectionViewCellWithViewController() {
        let collectionViewController = CollectionViewController(with: [1, 2, 3], environment: ())
        _ = collectionViewController.view // load view
        INJECTABLE_VC: do {
            let cell = ViewController.dequeueAsCollectionViewCell(from: collectionViewController.collectionView, for: IndexPath(row: 0, section: 0), input: 39, parentViewController: collectionViewController) as! CollectionViewCell<ViewController>
            XCTAssertEqual(cell.content.parameter, 39)
            XCTAssertTrue(cell.contentView.subviewTreeContains(with: cell.content.view))
        }

        INJECTABLE_VIEW: do {
            let cell = View.dequeueAsCollectionViewCell(from: collectionViewController.collectionView, for: IndexPath(row: 0, section: 0), input: 39, parentViewController: collectionViewController) as! CollectionViewCell<Mew.ViewController<View, Void>>
            XCTAssertEqual(cell.content.content.parameter, 39)
            XCTAssertTrue(cell.contentView.subviewTreeContains(with: cell.content.view))
        }

        INTERACTABLE_VC: do {
            var expected: Int?
            let cell = ViewController.dequeueAsCollectionViewCell(from: collectionViewController.collectionView, for: IndexPath(row: 0, section: 0), input: 48, output: { expected = $0 }, parentViewController: collectionViewController) as! CollectionViewCell<ViewController>
            XCTAssertEqual(cell.content.parameter, 48)
            XCTAssertTrue(cell.contentView.subviewTreeContains(with: cell.content.view))
            XCTAssertNil(expected)
            cell.content.fire()
            XCTAssertEqual(expected, 48)
        }

        INTERACTABLE_VIEW: do {
            var expected: Int?
            let cell = View.dequeueAsCollectionViewCell(from: collectionViewController.collectionView, for: IndexPath(row: 0, section: 0), input: 48, output: { expected = $0 }, parentViewController: collectionViewController) as! CollectionViewCell<Mew.ViewController<View, Void>>
            XCTAssertEqual(cell.content.content.parameter, 48)
            XCTAssertTrue(cell.contentView.subviewTreeContains(with: cell.content.view))
            XCTAssertNil(expected)
            cell.content.content.fire()
            XCTAssertEqual(expected, 48)
        }
    }

    func testDequeueCollectionViewHeaderFooterWithViewController() {
        let collectionViewController = CollectionViewController(with: [1, 2, 3], environment: ())
        _ = collectionViewController.view // load view
        INJECTABLE_VC: do {
            let view = ViewController.dequeueAsCollectionViewHeaderFooterView(from: collectionViewController.collectionView, of: CollectionViewSupplementaryKind.header.rawValue, for: IndexPath(row: 0, section: 0), input: 39, parentViewController: collectionViewController) as! CollectionReusableView<ViewController>
            XCTAssertEqual(view.content.parameter, 39)
            XCTAssertTrue(view.subviewTreeContains(with: view.content.view))
        }

        INJECTABLE_VIEW: do {
            let view = View.dequeueAsCollectionViewHeaderFooterView(from: collectionViewController.collectionView, of: CollectionViewSupplementaryKind.header.rawValue, for: IndexPath(row: 0, section: 0), input: 39, parentViewController: collectionViewController) as! CollectionReusableView<Mew.ViewController<View, Void>>
            XCTAssertEqual(view.content.content.parameter, 39)
            XCTAssertTrue(view.subviewTreeContains(with: view.content.view))
        }

        INTERACTABLE_VC: do {
            var expected: Int?
            let view = ViewController.dequeueAsCollectionViewHeaderFooterView(from: collectionViewController.collectionView, of: CollectionViewSupplementaryKind.header.rawValue, for: IndexPath(row: 0, section: 0), input: 48, output: { expected = $0 }, parentViewController: collectionViewController) as! CollectionReusableView<ViewController>
            XCTAssertEqual(view.content.parameter, 48)
            XCTAssertTrue(view.subviewTreeContains(with: view.content.view))
            XCTAssertNil(expected)
            view.content.fire()
            XCTAssertEqual(expected, 48)
        }

        INTERACTABLE_VIEW: do {
            var expected: Int?
            let view = View.dequeueAsCollectionViewHeaderFooterView(from: collectionViewController.collectionView, of: CollectionViewSupplementaryKind.header.rawValue, for: IndexPath(row: 0, section: 0), input: 48, output: { expected = $0 }, parentViewController: collectionViewController) as! CollectionReusableView<Mew.ViewController<View, Void>>
            XCTAssertEqual(view.content.content.parameter, 48)
            XCTAssertTrue(view.subviewTreeContains(with: view.content.view))
            XCTAssertNil(expected)
            view.content.content.fire()
            XCTAssertEqual(expected, 48)
        }
    }

    func testViewControllerLifeCycle() {
        let exp = expectation(description: #function + "\(#line)")
        let collectionViewController = CollectionViewController(with: Array(0..<10), environment: ())
        let parent = UIViewController()
        UIApplication.shared.keyWindow?.rootViewController = parent
        parent.present(collectionViewController, animated: true, completion: {
            let viewControllers = collectionViewController.collectionView!.visibleCells
                .compactMap { $0 as? CollectionViewCell<ViewController> }
                .map { $0.content }

            viewControllers.forEach {
                XCTAssertEqual($0.parent, collectionViewController)
            }
            XCTAssertEqual(
                (collectionViewController.collectionView?.supplementaryView(forElementKind: CollectionViewSupplementaryKind.header.rawValue, at: IndexPath(item: 0, section: 0)) as? CollectionReusableView<ViewController>)?.content.parent,
                collectionViewController
            )
            XCTAssertEqual(
                (collectionViewController.collectionView?.supplementaryView(forElementKind: CollectionViewSupplementaryKind.header.rawValue, at: IndexPath(item: 0, section: 1)) as? CollectionReusableView<Mew.ViewController<View, Void>>)?.content.parent,
                collectionViewController
            )
            parent.dismiss(animated: true, completion: {
                exp.fulfill()
            })
        })
        self.wait(for: [exp], timeout: 5.0)
    }

    func testAutosizingCell() {
        let data = [
            [
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 0..<100)), additionalHeight: CGFloat(Int.random(in: 0..<100))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 0..<100)), additionalHeight: CGFloat(Int.random(in: 0..<100))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 0..<100)), additionalHeight: CGFloat(Int.random(in: 0..<100))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 0..<100)), additionalHeight: CGFloat(Int.random(in: 0..<100))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 0..<100)), additionalHeight: CGFloat(Int.random(in: 0..<100))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 0..<100)), additionalHeight: CGFloat(Int.random(in: 0..<100)))
            ],
            [
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 200..<1000)), additionalHeight: CGFloat(Int.random(in: 200..<1000))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 200..<1000)), additionalHeight: CGFloat(Int.random(in: 200..<1000))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 200..<1000)), additionalHeight: CGFloat(Int.random(in: 200..<1000))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 200..<1000)), additionalHeight: CGFloat(Int.random(in: 200..<1000))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 200..<1000)), additionalHeight: CGFloat(Int.random(in: 200..<1000))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 200..<1000)), additionalHeight: CGFloat(Int.random(in: 200..<1000))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 200..<1000)), additionalHeight: CGFloat(Int.random(in: 200..<1000)))
            ],
            [
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 0..<1000)), additionalHeight: CGFloat(Int.random(in: 0..<1000))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 0..<1000)), additionalHeight: CGFloat(Int.random(in: 0..<1000))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 0..<1000)), additionalHeight: CGFloat(Int.random(in: 0..<1000))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 0..<1000)), additionalHeight: CGFloat(Int.random(in: 0..<1000))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 0..<1000)), additionalHeight: CGFloat(Int.random(in: 0..<1000))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 0..<1000)), additionalHeight: CGFloat(Int.random(in: 0..<1000))),
                AutolayoutViewController.Input(additionalWidth: CGFloat(Int.random(in: 0..<1000)), additionalHeight: CGFloat(Int.random(in: 0..<1000)))
            ]
        ]
        VERTICAL: do {
            let collectionViewController = AutolayoutCollectionViewController(with: [], environment: ())
            _ = collectionViewController.view // load view
            (collectionViewController.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .vertical

            UIApplication.shared.keyWindow?.rootViewController = collectionViewController
            for expects in data {
                collectionViewController.input(expects)
                collectionViewController.collectionView!.layoutIfNeeded()
                let cells = collectionViewController.collectionView!.indexPathsForVisibleItems.sorted().compactMap { collectionViewController.collectionView!.cellForItem(at: $0) }
                zip(expects, cells).forEach { expect, cell in
                    let expectedSize = CGSize(width: min(collectionViewController.collectionView!.frame.width - 40.0, 200 + expect.additionalWidth), height: 200 + expect.additionalHeight)
                    XCTAssertEqual(cell.frame.size, expectedSize, accurancy: 1.0)
                    XCTAssertEqual(cell.contentView.frame.size, expectedSize, accurancy: 1.0)
                    let childViewController = collectionViewController.children.first(where: { $0.view.superview == cell.contentView }) as! AutolayoutViewController
                    XCTAssertEqual(childViewController.view.frame.size, expectedSize, accurancy: 1.0)
                    XCTAssertFalse(cell.hasAmbiguousLayout)
                }
            }
        }
        HORIZONTAL: do {
            let collectionViewController = AutolayoutCollectionViewController(with: [], environment: ())
            _ = collectionViewController.view // load view
            (collectionViewController.collectionViewLayout as! UICollectionViewFlowLayout).scrollDirection = .horizontal

            UIApplication.shared.keyWindow?.rootViewController = collectionViewController
            for expects in data {
                collectionViewController.input(expects)
                collectionViewController.collectionView!.layoutIfNeeded()
                let cells = collectionViewController.collectionView!.indexPathsForVisibleItems.sorted().compactMap { collectionViewController.collectionView!.cellForItem(at: $0) }
                zip(expects, cells).forEach { expect, cell in
                    let expectedSize = CGSize(width: 200 + expect.additionalWidth, height: min(collectionViewController.collectionView!.frame.height - 40.0, 200 + expect.additionalHeight))
                    XCTAssertEqual(cell.frame.size, expectedSize, accurancy: 1.0)
                    XCTAssertEqual(cell.contentView.frame.size, expectedSize, accurancy: 1.0)
                    let childViewController = collectionViewController.children.first(where: { $0.view.superview == cell.contentView }) as! AutolayoutViewController
                    XCTAssertEqual(childViewController.view.frame.size, expectedSize, accurancy: 1.0)
                    XCTAssertFalse(cell.hasAmbiguousLayout)
                }
            }
        }
    }

    static var allTests = [
        ("testDequeueCollectionViewCellWithViewController", testDequeueCollectionViewCellWithViewController),
        ("testDequeueCollectionViewHeaderFooterWithViewController", testDequeueCollectionViewHeaderFooterWithViewController),
        ("testViewControllerLifeCycle", testViewControllerLifeCycle),
        ("testAutosizingCell", testAutosizingCell)
    ]
}
