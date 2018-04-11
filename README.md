# TableViewLiaison

<p align="center">
<a href="https://travis-ci.org/okcupid/OKTableViewLiaison">
<img src="https://travis-ci.org/okcupid/OKTableViewLiaison.svg?branch=master&style=flat"
alt="Build Status">
</a>
<a href="https://coveralls.io/github/okcupid/OKTableViewLiaison?branch=master">
<img src="https://coveralls.io/repos/github/okcupid/OKTableViewLiaison/badge.svg?branch=master"
alt="Coverage Status" />
</a>
<a href="https://cocoapods.org/pods/OKTableViewLiaison">
<img src="https://img.shields.io/cocoapods/v/OKTableViewLiaison.svg?style=flat"
alt="Pods Version">
</a>
</p>

----------------

A data-driven `UITableView` framework for building fast and flexible lists.

|         | Main Features  |
----------|-----------------
&#128581; | Never set up UITableViewDataSource or UITableViewDelegate boilerplate again. Register cells? No More! Cell for item? Be gone!
&#128288; | Create collections with multiple data types
&#127744; | Closure access to all lifecycle events for UITableViewCell
&#128196; | Built-in paging functionality
&#9989;   | Fully unit tested
&#128241; | Simply `UITableView` at its core
&#128640; | Extendable API
&#128038; | Written in Swift 4.1

`OKTableViewLiaison` is built and maintained with &#10084;&#65039; by [OkCupid engineering](https://tech.okcupid.com).
We use the open source version `master` branch in the OkCupid app.

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
`TableViewLiaison` allows you to more easily populate and manipulate `UITableView` rows and sections.

![Gif](https://media.giphy.com/media/fHf8iigytMD0cvWalC/giphy.gif)

### Getting Started
To get started, all you need to do is `liaise` an instance of `UITableView` to with a `TableViewLiaison`:

```swift
let liaison = TableViewLiaison()
let tableView = UITableView()

liaison.liaise(tableView: tableView)
```

By liaising your tableView with the liaison, the liaison becomes both its `UITableViewDataSource` and `UITableViewDelegate`.
In the event you would like to remove the tableView from the liaison, simply invoke `liaison.detachTableView()`.

TableViewLiaison populates sections and rows using two main types:

### Section
`class TableViewSection<Header: UITableViewHeaderFooterView, Footer: UITableViewHeaderFooterView, Model>`

To create a section for our tableView, create an instance of `TableViewSection` and add it to the liaison. 

- TableViewSection is generic and you must specify the class types for the header, footer and item model type. 
- If your section doesn't have a header or footer you can use the default `UITableViewHeaderFooterView`
- The model for the section can differ than the model used for individual rows in the section depending on your implementation

```swift
let section = TableViewSection<UITableViewHeaderFooterView, UITableViewHeaderFooterView, String>(model: "Section")

let plainSection = PlainTableViewSection()

liaison.append(sections: [section, plainSection])
```

### Supplementary Views
When creating an instance of `TableViewSection` that has a header or footer supplementary view, you must provide the type of `UITableViewHeaderFooterView` for the TableViewSection generic instantiation.  

You must also call `supplementaryViewDisplay` and register the class name for the header and/or foot cell type. 

```swift
let section = TableViewSection<UITableViewHeaderFooterView, UITableViewHeaderFooterView, HeaderModel>(model: HeaderModel(text: "Sample Model")",
supplementaryViewDisplay: .header(registrationType: .class(identifier: UITableViewHeaderFooterView.self)))
```

Supplementary view type registration is automatically handled by the section. You can use the same cell type for both header and footer views just so long as you provide unique reuse identifiers for each.

In the event your section will only display a single supplementary view, the other supplementary view type provided in the generic class declaration will be ignored.

You can set a static height of a supplementary view by calling `setHeight` with either a CGFloat value or closure:

```swift
section.setHeight(for: .header, value: 50)

section.setHeight(for: .header) { (model) -> CGFloat in
return model.text == "Sample Model" ? 100 : 50
}
```

In the event a height is not provided for a supplementary view, the liaison will assume the view is self sizing and return `UITableViewAutomaticDimension`.

The `TableViewSection` can be customized using `func setHeader(command: TableViewSectionCommand, with closure: ((Header, Model, _ section: Int) -> Void)?)` at all the following lifecycle events:

- configuration
- didEndDisplaying
- willDisplay

```swift
section.setHeader(command: .configuration) { (header, model, section) in
header.textLabel?.text = model.text
header.contentView.backgroundColor = .black
}

section.setHeader(command: .willDisplay) { (header, model, section) in
print("Header: \(header) will display for Section: \(section) with Model: \(model)")
}
```

### Rows
`class TableViewRow<Cell: UITableViewCell, Model>`

To add a row for a section, create an instance of `TableViewRow` and pass it to the initializer for a `TableViewSection` or if the row is added after instantiation you can perform that action via the liaison:

```swift
let row = TableViewRow<RowTableViewCell, RowModel>(model: RowModel(text: "Row", type: .small))
let section = PlainTableViewSection(rows: [row])
liaison.append(section: section)
```
or

```swift
let row = TableViewRow<RowTableViewCell, RowModel>(model: RowModel(text: "Row", type: .small))
let section = PlainTableViewSection()
liaison.append(section: section)
liaison.append(row: row)
```

`TableViewRow` heights are similarly configured to `TableViewSection`:

```swift
row.set(height: .height, value: 300)

row.set(height: .height) { (model) -> CGFloat in
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

The `TableViewRow` can be customized using `func set(command: TableViewRowCommand, with closure: ((Cell, Model, IndexPath) -> Void)?) ` at all the following lifecycle events:

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
-  willBeginEditing
-  willDeselect
-  willDisplay
-  willSelect

```swift
row.set(command: .configuration) { (cell, string, indexPath) in
cell.label.text = string
cell.label.font = .systemFont(ofSize: 13)
cell.contentView.backgroundColor = .blue
cell.selectionStyle = .none
}

row.set(command: .didSelect) { (cell, model, indexPath) in
print("Cell: \(cell) selected at IndexPath: \(indexPath)")
}
```

### Pagination
`TableViewLiaison` comes equipped to handle your pagination needs. To configure the liaison for pagination, simply set its `paginationDelegate` to an instance of `TableViewLiaisonPaginationDelegate`.

`TableViewLiaisonPaginationDelegate` declares three methods:

`func isPaginationEnabled() -> Bool`, notifies the liaison if it should show the pagination spinner when the user scrolls past the last cell.

`func paginationStarted(at indexPath: IndexPath)`, passes through the indexPath of the last `TableViewRow` managed by the liaison.

`func paginationEnded(indexPath: IndexPath)`, passes the indexPath of the first new `TableViewRow` appended by the liaison.

To update the liaisons results during pagination, simply use `append(sections: [AbstractTableViewSection])` or `func append(rows: [AnyTableViewRow])` and the liaison will automatically handle the removal of the pagination spinner.

To use a custom pagination spinner, you can pass an instance `AnyTableViewRow` during the initialization of your `TableViewLiaison`. By default it uses `PaginationTableViewRow` provided by the framework. 

### Tips & Tricks 

Because `TableViewSection` and `TableViewRow` utilize generic types and manage view/cell type registration, instantiating multiple different configurations of sections and rows can get verbose. Creating a subclass or utilizing a factory to create your various `TableViewSection`/`TableViewRow` may be useful.

```swift
final class PostTextTableViewRow: TableViewRow<PostTextTableViewCell, String> {
init(text: String) {
super.init(text,
registrationType: .defaultNibRegistration(for: PostTextTableViewCell.self))
}
}
```

```swift
static func contentRow(with image: UIImage, width: CGFloat) -> AnyTableViewRow {
let row = TableViewRow<PostImageContentTableViewCell, UIImage>(image,
registrationType: .defaultNibRegistration(for: PostImageContentTableViewCell.self))

row.set(height: .height) { (image) -> CGFloat in

let ratio = image.size.width / image.size.height

return width / ratio
}

row.set(command: .configuration) { (cell, image, _) in
cell.contentImageView.image = image
cell.contentImageView.contentMode = .scaleAspectFill
}

return row
}
```

## Contribution

`TableViewLiaison` is a framework in its infancy. It's implementation is not perfect. Not all `UITableView` functionality has been `liaised` just yet. If you would like to help bring `TableViewLiaison` to a better place, feel free to make a pull request.

## Authors

✌️ Dylan Shine, dylan@okcupid.com

## License

TableViewLiaison is available under the MIT license. See the LICENSE file for more info.
