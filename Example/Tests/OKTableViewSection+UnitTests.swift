//
//  OKTableViewSection+UnitTests.swift
//  OKTableViewLiaisonTests
//
//  Created by Dylan Shine on 3/26/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import XCTest
@testable import OKTableViewLiaison

final class OKTableViewSection_UnitTests: XCTestCase {
    
    func test_calculateHeight_setsHeightOfSupplementaryViewsWithClosure() {
        
        let header = TestTableViewSectionComponent()
        let footer = TestTableViewSectionComponent()
        
        header.setHeight { _ -> CGFloat in
            return 100
        }
        
        footer.setHeight { _ -> CGFloat in
            return 50
        }
        
        let section = OKTableViewSection(componentDisplayOption: .both(headerComponent: header, footerComponent: footer))
        
        XCTAssertEqual(section.calculateHeight(for: .header), 100)
        XCTAssertEqual(section.calculateHeight(for: .footer), 50)
    }
    
    func test_calculateHeight_setsHeightOfSupplementaryViewsWithValue() {
        
        let header = TestTableViewSectionComponent()
        let footer = TestTableViewSectionComponent()
        
        header.setHeight(125)
        footer.setHeight(75)
        
        let section = OKTableViewSection(componentDisplayOption: .both(headerComponent: header, footerComponent: footer))

        XCTAssertEqual(section.calculateHeight(for: .header), 125)
        XCTAssertEqual(section.calculateHeight(for: .footer), 75)
    }
    
    func test_calculateHeight_returnsAutomaticDimensionForSelfSizingSupplementaryViews() {
        let section = OKTableViewSection(componentDisplayOption: .both(headerComponent: TestTableViewSectionComponent(),
                                                                         footerComponent: TestTableViewSectionComponent()))
        
        XCTAssertEqual(section.calculateHeight(for: .header), UITableViewAutomaticDimension)
        XCTAssertEqual(section.calculateHeight(for: .footer), UITableViewAutomaticDimension)
    }
    
    func test_calculateHeight_returnZeroForHeightOfNonDisplayedSupplementaryViews() {
        let section = OKTableViewSection()
        
        let headerHeight = section.calculateHeight(for: .header)
        let footerHeight = section.calculateHeight(for: .footer)
        
        XCTAssertEqual(headerHeight, .leastNormalMagnitude)
        XCTAssertEqual(footerHeight, .leastNormalMagnitude)
    }
    
    func test_removeHeight_removesHeightOfSupplementaryViews() {
        let header = TestTableViewSectionComponent()
        let footer = TestTableViewSectionComponent()
        
        header.setHeight(40)
        footer.setHeight(40)
        
        let section = OKTableViewSection(componentDisplayOption: .both(headerComponent: header, footerComponent: footer))
        
        header.removeHeight()
        footer.removeHeight()

        XCTAssertEqual(section.calculateHeight(for: .header), UITableViewAutomaticDimension)
        XCTAssertEqual(section.calculateHeight(for: .footer), UITableViewAutomaticDimension)
    }
    
    func test_appendRows_appendsNewRowsToSection() {
        let section = OKTableViewSection()
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        
        section.append(rows: [row1, row2])
        
        XCTAssertEqual(section.rows.count, 2)
        XCTAssert(section.rows.first === row1)
        XCTAssert(section.rows.last === row2)
    }
    
    func test_appendRow_appendsRowToSection() {
        let section = OKTableViewSection()
        let row = TestTableViewRow()
        
        section.append(row: row)
        
        XCTAssertEqual(section.rows.count, 1)
        XCTAssert(section.rows.first === row)
    }
    
    func test_headerForTableView_returnsConfiguredHeaderForSection() {
        let tableView = UITableView()
        let header = TestTableViewSectionComponent()
        
        let reuseIdentifier = String(describing: UITableViewHeaderFooterView.self)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        
        let string = "Test"
        header.set(command: .configuration) { view, _, _ in
            view.accessibilityIdentifier = string
        }
        
        let section = OKTableViewSection(componentDisplayOption: .header(component: header))
        
        let headerView = section.view(componentView: .header, for: tableView, in: 0)
        
        XCTAssertEqual(headerView?.accessibilityIdentifier, string)
        XCTAssert(headerView is UITableViewHeaderFooterView)
    }
    
    func test_footerForTableView_returnsConfiguredFooterForSection() {
        let tableView = UITableView()
        let footer = TestTableViewSectionComponent()

        let reuseIdentifier = String(describing: UITableViewHeaderFooterView.self)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        
        let string = "Test"
        footer.set(command: .configuration) { view, _, _ in
            view.accessibilityIdentifier = string
        }
        
        let section = OKTableViewSection(componentDisplayOption: .footer(component: footer))

        let footerView = section.view(componentView: .footer, for: tableView, in: 0)
        
        XCTAssertEqual(footerView?.accessibilityIdentifier, string)
        XCTAssert(footerView is UITableViewHeaderFooterView)
    }
    
    func test_perform_performsSectionCommands() {
        
        let header = TestTableViewSectionComponent()
        let footer = TestTableViewSectionComponent()
        
        var headerConfiguration = ""
        var headerDidEndDisplaying = ""
        var headerWillDisplay = ""
        var footerConfiguration = ""
        var footerDidEndDisplaying = ""
        var footerWillDisplay = ""
        
        header.set(command: .configuration) { view, string, section in
            headerConfiguration = "Configured!"
        }
        
        header.set(command: .didEndDisplaying) { view, string, section in
            headerDidEndDisplaying = "DidEndDisplaying!"
        }
        
        header.set(command: .willDisplay) { view, string, section in
            headerWillDisplay = "WillDisplay!"
        }
        
        footer.set(command: .configuration) { view, string, section in
            footerConfiguration = "Configured!"
        }
        
        footer.set(command: .didEndDisplaying) { view, string, section in
            footerDidEndDisplaying = "DidEndDisplaying!"
        }
        
        footer.set(command: .willDisplay) { view, string, section in
            footerWillDisplay = "WillDisplay!"
        }
        
        let view = UITableViewHeaderFooterView()
        let section = OKTableViewSection(componentDisplayOption: .both(headerComponent: header, footerComponent: footer))
        
        section.perform(command: .configuration, supplementaryView: .header, for: view, in: 0)
        section.perform(command: .configuration, supplementaryView: .footer, for: view, in: 0)
        section.perform(command: .didEndDisplaying, supplementaryView: .header, for: view, in: 0)
        section.perform(command: .didEndDisplaying, supplementaryView: .footer, for: view, in: 0)
        section.perform(command: .willDisplay, supplementaryView: .header, for: view, in: 0)
        section.perform(command: .willDisplay, supplementaryView: .footer, for: view, in: 0)
        
        XCTAssertEqual(headerConfiguration, "Configured!")
        XCTAssertEqual(footerConfiguration, "Configured!")
        XCTAssertEqual(headerDidEndDisplaying, "DidEndDisplaying!")
        XCTAssertEqual(footerDidEndDisplaying, "DidEndDisplaying!")
        XCTAssertEqual(headerWillDisplay, "WillDisplay!")
        XCTAssertEqual(footerWillDisplay, "WillDisplay!")
    }
    
    func test_perform_ignoresCommandPerformanceForIncorrectSupplementaryViewType() {
        let header = TestTableViewSectionComponent()
        let footer = TestTableViewSectionComponent()

        var headerConfiguration = ""
        var footerConfiguration = ""
        
        header.set(command: .configuration) { view, string, section in
            headerConfiguration = "Configured!"
        }
        
        footer.set(command: .configuration) { view, string, section in
            footerConfiguration = "Configured!"
        }
        
        let view = UIView()
        
        let section = OKTableViewSection(componentDisplayOption: .both(headerComponent: header, footerComponent: footer))
        section.perform(command: .configuration, supplementaryView: .header, for: view, in: 0)
        section.perform(command: .configuration, supplementaryView: .footer, for: view, in: 0)
        
        XCTAssertEqual(headerConfiguration, "")
        XCTAssertEqual(footerConfiguration, "")
    }
    
}
