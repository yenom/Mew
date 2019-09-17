# Mew (μ)

iOS MicroViewController support library.

## Installation

### Carthage
The latest version is 0.5.1
```
github "yenom/Mew"
```

### CocoaPods
```
pod 'Mew', :git => 'https://github.com/yenom/Mew.git'
```

## Usage

### ContainerView with Manual Control 
1. Add `ContainerView` in your xib/code.
2. Add childViewController using `containerView.addArrangedViewController`.
3. 🎉

### ContainerView with `Container<T>`
1. Conform your ViewController classes as `Instantiatable`.
2. Conform your ViewController classes `Injectable`, `Interactable` if need.
3. Add `ContainerView` in your xib/code.
4. Add childViewController using `containerView.makeContainer`.
5. 🎉

### Cells (ViewController)
1. Conform your TableViewController class as `Instantiatable`.
2. Conform your CellViewController class as `Instantiatable`, `Injectable`.
3. `CellViewController.registerAsTableViewCell`, `CellViewController.dequeuedAdTableViewCell` support TableView cells.
4. 🎉

### Cells (View)
1. Conform your TableViewController class as `Instantiatable`.
2. Conform your CellView class as `Injectable`.
3. `CellView.registerAsTableViewCell`, `CellView.dequeuedAdTableViewCell` support TableView cells.
4. 🎉

## Reference
My Presentation.
https://www.icloud.com/keynote/0vgTYDXyHQTd0l1FKTiF1jT7g#MicroViewController-en

## Supporting
|  | Supported |
----|---- 
| ContainerView | ✅ |
| Container<T> | ✅ |
| Environment, Testing support | ✅ |
| UITableView support | ✅ |
| UICollectionView support | ✅ |

## Committers

All Mercari iOS team.

## Contribution

Please read the CLA below carefully before submitting your contribution.

https://www.mercari.com/cla/

## License

Copyright 2018 Mercari, Inc.
Copyright 2019 Yenom, Inc.

Licensed under the MIT License.
