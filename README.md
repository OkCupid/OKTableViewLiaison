<p align="center">
  <img src="https://raw.githubusercontent.com/OkCupid/OKTableViewLiaison/master/Resources/logo.png" width=500 />
</p>

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
&#128036; | Written in Swift 4.2

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

By liaising your tableView with the liaison, the liaison becomes its `UITableViewDataSource`, `UITableViewDelegate`, and `UITableViewDataSourcePrefetching`.
In the event you would like to remove the tableView from the liaison, simply invoke `liaison.detach()`.

OKTableViewLiaison populates sections and rows using two main types:

### Section
`struct OKTableViewSection`

To create a section for our tableView, create an instance of `OKTableViewSection` and add it to the liaison.

```swift
let section = OKTableViewSection()

let liaison = OKTableViewLiaison(sections: [section])
```
or

```swift
let section = OKTableViewSection()

liaison.append(sections: [section])
```

### Supplementary Section Views
To notify the liaison that your `OKTableViewSection` will display a header and/or footer view, you must provide an instance of `OKTableViewSectionComponentDisplayOption` during initialization.

`OKTableViewSectionComponentDisplayOption` is an enumeration that notfies the liaison which supplementary views should be displayed for a given section. A header/footer view is represented by:

`class OKTableViewSectionComponent<View: UITableViewHeaderFooterView, Model>`

```swift
let header = OKTableViewSectionComponent<UITableViewHeaderFooterView, User>(.dylan)
let section = OKTableViewSection(componentDisplayOption: .header(component: header))
```

You can set a static height of a section component by using either a CGFloat value or closure:

```swift
header.set(height: .height, 55)

header.set(height: .height) { user -> CGFloat in
    return user.username == "dylan" ? 100 : 75
}

header.set(height: .estimatedHeight, 125)
```

In the event a height is not provided for a section component, the liaison will assume the supplementary view is self sizing and return a `.height` of `UITableView.automaticDimension`. Make sure you provide an `.estimatedHeight` to avoid layout complications.

The `OKTableViewSectionComponent ` views can be customized using `func set(command: OKTableViewSectionComponentCommand, with closure: @escaping (View, Model, Int) -> Void)` at all the following lifecycle events:

- configuration
- didEndDisplaying
- willDisplay

```swift
header.set(command: .configuration) { view, user, section in
    view.textLabel?.text = user.username
}

header.set(command: .willDisplay) { view, user, section in
    print("Header: \(view) will display for Section: \(section) with User: \(user)")
}
```

### Rows
`class OKTableViewRow<Cell: UITableViewCell, Model>`

To add a row for a section, create an instance of `OKTableViewRow` and pass it to the initializer for a `OKTableViewSection` or if the row is added after instantiation you can perform that action via the liaison:

```swift
let row = OKTableViewRow<RowTableViewCell, RowModel>(model: RowModel(type: .small))
let section = OKTableViewSection(rows: [row])
liaison.append(section: section)
```
or

```swift
let row = OKTableViewRow<RowTableViewCell, RowModel>(model: RowModel(type: .small))
let section = OKTableViewSection()
liaison.append(section: section)
liaison.append(row: row)
```

`OKTableViewRow` heights are similarly configured to `OKTableViewSection`:

```swift
row.set(height: .height, 300)

row.set(height: .estimatedHeight, 210)

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

In the event a height is not provided, the liaison will assume the cell is self sizing and return `UITableView.automaticDimension`.

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

`OKTableViewRow` can also utilize `UITableViewDataSourcePrefetching` by using `func set(prefetchCommand: OKTableViewPrefetchCommand, with closure: @escaping (Model, IndexPath) -> Void)`

```swift
row.set(prefetchCommand: .prefetch) { model, indexPath in
	model.downloadImage()
}

row.set(prefetchCommand: .cancel) { model, indexPath in
    model.cancelImageDownload()
}
```

### Cell/View Registration
`OKTableViewLiaison` handles cell & view registration for `UITableView` view reuse on your behalf utilizing your sections/rows `OKTableViewRegistrationType<T>`.

`OKTableViewRegistrationType` tells the liaison whether your reusable view should be registered via a `Nib` or `Class`.

By default, `OKTableViewRow` is instantiated with `OKTableViewRegistrationType<Cell>.defaultClassType`.

`OKTableViewSection` supplementary view registration is encapsulated by its`OKTableViewSectionComponentDisplayOption`. By default, `OKTableViewSection` `componentDisplayOption` is instantiated with `.none`.

### Pagination
`OKTableViewLiaison` comes equipped to handle your pagination needs. To configure the liaison for pagination, simply set its `paginationDelegate` to an instance of `OKTableViewLiaisonPaginationDelegate`.

`OKTableViewLiaisonPaginationDelegate` declares three methods:

`func isPaginationEnabled() -> Bool`, notifies the liaison if it should show the pagination spinner when the user scrolls past the last cell.

`func paginationStarted(indexPath: IndexPath)`, passes through the indexPath of the last `OKTableViewRow` managed by the liaison.

`func paginationEnded(indexPath: IndexPath)`, passes the indexPath of the first new `OKTableViewRow` appended by the liaison.

To update the liaisons results during pagination, simply use `append(sections: [OKAnyTableViewSection])` or `func append(rows: [OKAnyTableViewRow])` and the liaison will automatically handle the removal of the pagination spinner.

To use a custom pagination spinner, you can pass an instance `OKAnyTableViewRow` during the initialization of your `OKTableViewLiaison`. By default it uses `OKPaginationTableViewRow` provided by the framework.

### Tips & Tricks

Because `OKTableViewSection` and `OKTableViewRow` utilize generic types and manage view/cell type registration, instantiating multiple different configurations of sections and rows can get verbose. Creating a subclass or utilizing a factory to create your various `OKTableViewRow`/`OKTableViewSectionComponent` types may be useful.

```swift
final class TextTableViewRow: OKTableViewRow<PostTextTableViewCell, String> {
	init(text: String) {
		super.init(text,
		registrationType: .defaultNibType)
	}
}
```

```swift
static func imageRow(with image: UIImage) -> AnyTableViewRow {
	let row = OKTableViewRow<ImageTableViewCell, UIImage>(image)

	row.set(height: .height, 225)

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
