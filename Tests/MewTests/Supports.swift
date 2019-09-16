//
//  Supports.swift
//  MewTests
//
//  Created by tarunon on 2018/08/29.
//  Copyright © 2018 Mercari. All rights reserved.
//

import UIKit
import Mew
import XCTest

extension UIView {
    private static func contains(_ view: UIView, where condition: (UIView) -> Bool) -> Bool {
        if condition(view) { return true }
        return view.subviews.contains(where: { contains($0, where: condition) })
    }

    public func subviewTreeContains(with view: UIView) -> Bool {
        return UIView.contains(self, where: { $0 === view })
    }

    public func subviewTreeContains(where condition: (UIView) -> Bool) -> Bool {
        return UIView.contains(self, where: condition)
    }

    /// addSubview and add constraints/resizingMasks that make frexible size.
    public func addSubviewFrexibleSize(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        if translatesAutoresizingMaskIntoConstraints {
            subview.frame = bounds
            addSubview(subview)
            subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        } else {
            addSubview(subview)
            NSLayoutConstraint.activate(
                [
                    subview.topAnchor.constraint(equalTo: topAnchor),
                    subview.leftAnchor.constraint(equalTo: leftAnchor),
                    subview.rightAnchor.constraint(equalTo: rightAnchor),
                    subview.bottomAnchor.constraint(equalTo: bottomAnchor)
                ]
            )
        }
    }
}

final class View: UIView, Injectable, Emittable {
    typealias Input = Int
    var parameter: Int?
    var handler: ((Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func input(_ value: Int) {
        self.parameter = value
    }
    
    func output(_ handler: ((Int) -> Void)?) {
        self.handler = handler
    }
    
    func fire() {
        guard let parameter = parameter else {
            print("parameter has not been injected yet")
            return
        }
        handler?(parameter)
    }
}

final class ViewController: UIViewController, Instantiatable, Interactable {
    typealias Input = Int
    var parameter: Int
    var handler: ((Int) -> ())?

    let environment: Void

    init(with value: Int, environment: Void) {
        self.parameter = value
        self.environment = environment
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func input(_ value: Int) {
        self.parameter = value
    }

    func output(_ handler: ((Int) -> Void)?) {
        self.handler = handler
    }

    func fire() {
        handler?(parameter)
    }
}

final class TableViewController: UITableViewController, Instantiatable {
    let environment: Void
    enum Section: CaseIterable {
        case cellFromViewController, cellFromView
    }
    var sections: [Section] = Section.allCases
    var elements: [Int]

    init(with input: [Int], environment: Void) {
        self.environment = environment
        self.elements = input
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.registerAsTableViewCell(on: tableView)
        ViewController.registerAsTableViewHeaderFooterView(on: tableView)
        View.registerAsTableViewCell(on: tableView, parent: self)
        View.registerAsTableViewHeaderFooterView(on: tableView, parent: self)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch sections[indexPath.section] {
        case .cellFromViewController:
            return ViewController.dequeueAsTableViewCell(from: tableView, for: indexPath, input: elements[indexPath.row], parentViewController: self)
        case .cellFromView:
            return View.dequeueAsTableViewCell(from: tableView, for: indexPath, input: elements[indexPath.row], parentViewController: self)
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch sections[section] {
        case .cellFromViewController:
            return ViewController.dequeueAsTableViewHeaderFooterView(from: tableView, input: elements.count, parentViewController: self)
        case .cellFromView:
            return View.dequeueAsTableViewHeaderFooterView(from: tableView, input: elements.count, parentViewController: self)
        }
    }
}

final class CollectionViewController: UICollectionViewController, Instantiatable, UICollectionViewDelegateFlowLayout {
    let environment: Void
    enum Section: CaseIterable {
        case cellFromViewController, cellFromView
    }
    var sections: [Section] = Section.allCases
    var elements: [Int]

    init(with input: [Int], environment: Void) {
        self.environment = environment
        self.elements = input
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.registerAsCollectionViewCell(on: collectionView!)
        ViewController.registerAsCollectionViewHeaderFooterView(on: collectionView!, for: .header)
        View.registerAsCollectionViewCell(on: collectionView!, parent: self)
        View.registerAsCollectionViewHeaderFooterView(on: collectionView!, for: .header, parent: self)
        collectionViewLayout.invalidateLayout()
        collectionView?.reloadData()
        collectionView?.layoutIfNeeded()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
        case .cellFromViewController:
            return ViewController.dequeueAsCollectionViewCell(from: collectionView, for: indexPath, input: elements[indexPath.row], parentViewController: self)
        case .cellFromView:
            return View.dequeueAsCollectionViewCell(from: collectionView, for: indexPath, input: elements[indexPath.row], parentViewController: self)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch sections[indexPath.section] {
        case .cellFromViewController:
            return ViewController.dequeueAsCollectionViewHeaderFooterView(from: collectionView, of: kind, for: indexPath, input: elements.count, parentViewController: self)
        case .cellFromView:
            return View.dequeueAsCollectionViewHeaderFooterView(from: collectionView, of: kind, for: indexPath, input: elements.count, parentViewController: self)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44.0)
    }
}

final class AutolayoutViewController: UIViewController, Injectable, Instantiatable {
    struct Input {
        var additionalWidth: CGFloat
        var additionalHeight: CGFloat
    }
    var parameter: Input {
        didSet {
            updateLayout()
        }
    }

    let environment: Void

    init(with input: Input, environment: Void) {
        self.parameter = input
        self.environment = environment
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var squareRequiredView: UIView!
    var additionalWidthView: UIView!
    var additionalHeightView: UIView!
    var additionalWidthConstraints = [NSLayoutConstraint]()
    var additionalHeightConstraints = [NSLayoutConstraint]()

    /**
     ```
     ┌┬─┐
     ├┴─┤
     └──┘
     ```
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        squareRequiredView = UIView()
        squareRequiredView.translatesAutoresizingMaskIntoConstraints = false
        additionalWidthView = UIView()
        additionalWidthView.translatesAutoresizingMaskIntoConstraints = false
        additionalHeightView = UIView()
        additionalHeightView.translatesAutoresizingMaskIntoConstraints = false
        additionalWidthConstraints = [
            { let x = additionalWidthView.widthAnchor.constraint(equalToConstant: 0); x.priority = .defaultHigh + 1; return x }(),
            additionalWidthView.widthAnchor.constraint(lessThanOrEqualToConstant: 0)
        ]
        additionalHeightConstraints = [
            { let x = additionalHeightView.heightAnchor.constraint(equalToConstant: 0); x.priority = .defaultHigh + 1; return x }(),
            additionalHeightView.heightAnchor.constraint(lessThanOrEqualToConstant: 0)
        ]
        view.addSubview(squareRequiredView)
        view.addSubview(additionalWidthView)
        view.addSubview(additionalHeightView)
        NSLayoutConstraint.activate(
            [
                squareRequiredView.heightAnchor.constraint(equalToConstant: 200.0),
                squareRequiredView.widthAnchor.constraint(equalToConstant: 200.0),
                squareRequiredView.topAnchor.constraint(equalTo: view.topAnchor),
                squareRequiredView.leftAnchor.constraint(equalTo: view.leftAnchor),
                squareRequiredView.rightAnchor.constraint(equalTo: additionalWidthView.leftAnchor),
                additionalWidthView.topAnchor.constraint(equalTo: view.topAnchor),
                additionalWidthView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                additionalWidthView.rightAnchor.constraint(equalTo: view.rightAnchor),
                squareRequiredView.bottomAnchor.constraint(equalTo: additionalHeightView.topAnchor),
                additionalHeightView.leftAnchor.constraint(equalTo: view.leftAnchor),
                additionalHeightView.rightAnchor.constraint(equalTo: view.rightAnchor),
                additionalHeightView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

            ] + additionalWidthConstraints + additionalHeightConstraints
        )
        updateLayout()
    }

    func input(_ value: Input) {
        self.parameter = value
    }

    func updateLayout() {
        additionalWidthConstraints.forEach { $0.constant = parameter.additionalWidth }
        additionalHeightConstraints.forEach { $0.constant = parameter.additionalHeight }
    }
}

final class AutolayoutTableViewController: UITableViewController, Instantiatable, Injectable {
    let environment: Void
    var elements: [AutolayoutViewController.Input]

    init(with input: [AutolayoutViewController.Input], environment: Void) {
        self.environment = environment
        self.elements = input
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AutolayoutViewController.registerAsTableViewCell(on: tableView)
    }

    func input(_ input: [AutolayoutViewController.Input]) {
        self.elements = input
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return AutolayoutViewController.dequeueAsTableViewCell(from: tableView, for: indexPath, input: elements[indexPath.row], parentViewController: self)
    }
}

final class AutolayoutCollectionViewController: UICollectionViewController, Instantiatable, Injectable {
    let environment: Void
    let flowLayout: UICollectionViewFlowLayout
    var elements: [AutolayoutViewController.Input]

    init(with input: [AutolayoutViewController.Input], environment: Void) {
        self.environment = environment
        self.elements = input
        self.flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        AutolayoutViewController.registerAsCollectionViewCell(on: collectionView!)
        if #available(iOS 10.0, *) {
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        flowLayout.estimatedItemSize = CGSize(width: 200.0, height: 200.0)
        flowLayout.sectionInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    }

    func input(_ input: [AutolayoutViewController.Input]) {
        self.elements = input
        collectionView!.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return AutolayoutViewController.dequeueAsCollectionViewCell(from: collectionView, for: indexPath, input: elements[indexPath.row], parentViewController: self)
    }
}

func XCTAssertEqual(_ expression1: CGSize, _ expression2: CGSize, accurancy: CGFloat, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(expression1.height, expression2.height, accuracy: accurancy, file: file, line: line)
    XCTAssertEqual(expression1.width, expression2.width, accuracy: accurancy, file: file, line: line)
}
