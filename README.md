# OKTableViewLiaison

<p align="center">
<a href="https://travis-ci.org/OkCupid/OKTableViewLiaison">
<img src="https://travis-ci.org/OkCupid/OKTableViewLiaison.svg?branch=master&style=flat"
alt="Build Status">
</a>
<a href="https://cocoapods.org/pods/OKTableViewLiaison">
<img src="https://img.shields.io/cocoapods/v/OKTableViewLiaison.svg?style=flat"
alt="Pods Version">
</a>
</p>

----------------

`UITableView` made simple &#128588;

|         | Main Features  |
----------|-----------------
&#128585; | Skip the `UITableViewDataSource` & `UITableViewDelegate` boilerplate and get right to building your `UITableView`!
&#127744; | Closure based API for section and row configuration
&#128196; | Built-in paging functionality
&#9989;   | Unit Tested
&#128036; | Written in Swift 4.1

`OKTableViewLiaison` is 🔨 with &#10084;&#65039; by [📱 @ OkCupid](https://tech.okcupid.com).
We use the latest and greatest open source version of `master` in the OkCupid app.

## Requirements

- Xcode 9.0+
- iOS 9.0+

## Installation

### CocoaPods

The preferred installation method is with [CocoaPods](https://cocoapods.org). Add the following to your `Podfile`:

```ruby
pod 'OKTableViewLiaison'
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
`OKTableViewLiaison` allows you to more easily populate and manipulate `UITableView` rows and sections.

### Getting Started
To get started, all you need to do is `liaise` an instance of `UITableView` to with a `OKTableViewLiaison`:

```swift
let liaison = OKTableViewLiaison()
let tableView = UITableView()

liaison.liaise(tableView: tableView)
```

By liaising your tableView with the liaison, the liaison becomes both its `UITableViewDataSource` and `UITableViewDelegate`.
In the event you would like to remove the tableView from the liaison, simply invoke `liaison.detachTableView()`.

OKTableViewLiaison populates sections and rows using two main types:

### Section
`class OKTableViewSection<Header: UITableViewHeaderFooterView, Footer: UITableViewHeaderFooterView, Model>`

To create a section for our tableView, create an instance of `OKTableViewSection` and add it to the liaison.

```swift
let section = OKTableViewSection<UITableViewHeaderFooterView, UITableViewHeaderFooterView, String>(model: "Section")

let plainSection = OKPlainTableViewSection()

let liaison = OKTableViewLiaison(sections: [section, plainSection])
```
or

```swift
let section = OKTableViewSection<UITableViewHeaderFooterView, UITableViewHeaderFooterView, String>(model: "Section")

let plainSection = OKPlainTableViewSection()

liaison.append(sections: [section, plainSection])
```

### Supplementary Views
To notify the liaison that your `OKTableViewSection` will display a header and/or footer view, you must provide an instance of `OKTableViewSectionSupplementaryViewDisplayOption` during initialization.

```swift
let section = TableViewSection<UITableViewHeaderFooterView, UITableViewHeaderFooterView, HeaderModel>(model: HeaderModel(text: "Sample Model")",
supplementaryViewDisplay: .header(registrationType: OKTableViewSection.defaultHeaderClassRegistrationType))
```

If your section will only display a single supplementary view, the other supplementary view type provided in the generic declaration will be ignored.

You can set a static height of a supplementary view by calling `setHeight` with either a CGFloat value or closure:

```swift
section.setHeight(for: .header, value: 50)

section.setHeight(for: .header) { model -> CGFloat in
	return model.text == "Sample Model" ? 100 : 50
}
```

In the event a height is not provided for a supplementary view, the liaison will assume the supplementary view is self sizing and return `UITableViewAutomaticDimension`.

The `OKTableViewSection` supplementary views can be customized using `func setHeader(command: OKTableViewSectionCommand, with closure: @escaping (Header, Model, _ section: Int) -> Void)` or `func setFooter(command: OKTableViewSectionCommand, with closure: @escaping (Footer, Model, _ section: Int) -> Void)` at all the following lifecycle events:

- configuration
- didEndDisplaying
- willDisplay

```swift
section.setHeader(command: .configuration) { header, model, section in
	header.textLabel?.text = model.text
	header.contentView.backgroundColor = .black
}

section.setHeader(command: .willDisplay) { header, model, section in
	print("Header: \(header) will display for Section: \(section) with Model: \(model)")
}
```

### Rows
`class OKTableViewRow<Cell: UITableViewCell, Model>`

To add a row for a section, create an instance of `OKTableViewRow` and pass it to the initializer for a `OKTableViewSection` or if the row is added after instantiation you can perform that action via the liaison:

```swift
let row = OKTableViewRow<RowTableViewCell, RowModel>(model: RowModel(type: .small))
let section = OKPlainTableViewSection(rows: [row])
liaison.append(section: section)
```
or

```swift
let row = OKTableViewRow<RowTableViewCell, RowModel>(model: RowModel(type: .small))
let section = OKPlainTableViewSection()
liaison.append(section: section)
liaison.append(row: row)
```

`OKTableViewRow` heights are similarly configured to `OKTableViewSection`:

```swift
row.set(height: .height, value: 300)

row.set(height: .height) { model -> CGFloat in
	switch model.type {
	case .large:
		return 400
	case .medium:
		return 200
	case .small:
		return 50
	}
}
```

In the event a height is not provided, the liaison will assume the cell is self sizing and return `UITableViewAutomaticDimension`.

The `OKTableViewRow` can be customized using `func set(command: OKTableViewRowCommand, with closure: @escaping (Cell, Model, IndexPath) -> Void) ` at all the following lifecycle events:

-  accessoryButtonTapped
-  configuration
-  delete
-  didDeselect
-  didEndDisplaying
-  didEndEditing
-  didHighlight
-  didSelect
-  didUnhighlight
-  insert
-  move
-  reload
-  willBeginEditing
-  willDeselect
-  willDisplay
-  willSelect

```swift
row.set(command: .configuration) { cell, model, indexPath in
	cell.label.text = model.text
	cell.label.font = .systemFont(ofSize: 13)
	cell.contentView.backgroundColor = .blue
	cell.selectionStyle = .none
}

row.set(command: .didSelect) { cell, model, indexPath in
	print("Cell: \(cell) selected at IndexPath: \(indexPath)")
}
```

### Cell/View Registration
`OKTableViewLiaison` handles cell & view registration for `UITableView` view reuse on your behalf utilizing your sections/rows `OKTableViewRegistrationType`.

`OKTableViewRegistrationType` tells the liaison whether your reusable view should be registered via a `Nib` or `Class`.

By default, `OKTableViewRow` is instantiated with `OKTableViewRow.defaultClassRegistrationType`.

`OKTableViewSection` supplementary view registration is encapsulated by its`OKTableViewSectionSupplementaryViewDisplayOption`. By default, `OKTableViewSection` `supplementaryViewDisplay` is instantiated with `.none`.

### Pagination
`OKTableViewLiaison` comes equipped to handle your pagination needs. To configure the liaison for pagination, simply set its `paginationDelegate` to an instance of `OKTableViewLiaisonPaginationDelegate`.

`OKTableViewLiaisonPaginationDelegate` declares three methods:

`func isPaginationEnabled() -> Bool`, notifies the liaison if it should show the pagination spinner when the user scrolls past the last cell.

`func paginationStarted(indexPath: IndexPath)`, passes through the indexPath of the last `OKTableViewRow` managed by the liaison.

`func paginationEnded(indexPath: IndexPath)`, passes the indexPath of the first new `OKTableViewRow` appended by the liaison.

To update the liaisons results during pagination, simply use `append(sections: [OKAnyTableViewSection])` or `func append(rows: [OKAnyTableViewRow])` and the liaison will automatically handle the removal of the pagination spinner.

To use a custom pagination spinner, you can pass an instance `OKAnyTableViewRow` during the initialization of your `OKTableViewLiaison`. By default it uses `OKPaginationTableViewRow` provided by the framework.

### Tips & Tricks

Because `OKTableViewSection` and `OKTableViewRow` utilize generic types and manage view/cell type registration, instantiating multiple different configurations of sections and rows can get verbose. Creating a subclass or utilizing a factory to create your various `OKTableViewSection`/`OKTableViewRow` may be useful.

```swift
final class PostTextTableViewRow: OKTableViewRow<PostTextTableViewCell, String> {
	init(text: String) {
		super.init(text,
		registrationType: PostTextTableViewRow.defaultNibRegistrationType)
	}
}
```

```swift
static func contentRow(with image: UIImage, width: CGFloat) -> AnyTableViewRow {
	let row = OKTableViewRow<PostImageContentTableViewCell, UIImage>(image,
	registrationType: PostTextTableViewRow.defaultNibRegistrationType)

	row.set(height: .height) { image -> CGFloat in
		let ratio = image.size.width / image.size.height
		return width / ratio
	}

	row.set(command: .configuration) { cell, image, indexPath in
		cell.contentImageView.image = image
		cell.contentImageView.contentMode = .scaleAspectFill
	}

	return row
}
```

## Contribution

`OKTableViewLiaison` is a framework in its infancy. It's implementation is not perfect. Not all `UITableView` functionality has been `liaised` just yet. If you would like to help bring `OKTableViewLiaison` to a better place, feel free to make a pull request.

## Authors

✌️ Dylan Shine, dylan@okcupid.com

## License

OKTableViewLiaison is available under the MIT license. See the LICENSE file for more info.
