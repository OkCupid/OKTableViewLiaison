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
    
    func test_setHeader_setsHeaderCommandClosure() {
        let section = TestTableViewSection()
        
        var headerSet = false
        section.setHeader(command: .configuration) { (_, _, _) in
            headerSet = true
        }
        
        section.perform(command: .configuration,
                        supplementaryView: .header,
                        for: UITableViewHeaderFooterView(),
                        in: 0)
        
        XCTAssertEqual(headerSet, true)
    }
    
    func test_removeHeader_removesHeaderCommandClosure() {
        let section = TestTableViewSection()
        
        var headerSet = false
        section.setHeader(command: .configuration) { (_, _, _) in
            headerSet = true
        }

        section.removeHeader(command: .configuration)
        section.perform(command: .configuration,
                        supplementaryView: .header,
                        for: UITableViewHeaderFooterView(),
                        in: 0)
        
        XCTAssertEqual(headerSet, false)
    }
    
    func test_setFooter_setsFooterCommandClosure() {
        let section = TestTableViewSection()
        
        var footerSet = false
        section.setFooter(command: .configuration) { (_, _, _) in
            footerSet = true
        }
        
        section.perform(command: .configuration,
                        supplementaryView: .footer,
                        for: UITableViewHeaderFooterView(),
                        in: 0)
        
        XCTAssertEqual(footerSet, true)
    }
    
    func test_removeFooter_removesFooterCommandClosure() {
        let section = TestTableViewSection()
        
        var footerSet = false
        section.setFooter(command: .configuration) { (_, _, _) in
            footerSet = true
        }
        
        section.removeFooter(command: .configuration)
        section.perform(command: .configuration,
                        supplementaryView: .header,
                        for: UITableViewHeaderFooterView(),
                        in: 0)
        
        XCTAssertEqual(footerSet, false)
    }
    
    func test_calculateHeight_setsHeightOfSupplementaryViewsWithClosure() {
        let section = TestTableViewSection.create()
        
        section.setHeight(for: .header) { _ -> CGFloat in
            return 100
        }
        
        section.setHeight(for: .footer) { _ -> CGFloat in
            return 50
        }

        XCTAssertEqual(section.calculateHeight(for: .header), 100)
        XCTAssertEqual(section.calculateHeight(for: .footer), 50)
    }
    
    func test_calculateHeight_setsHeightOfSupplementaryViewsWithValue() {
        let section = TestTableViewSection.create()
        
        section.setHeight(for: .header, value: 125)
        section.setHeight(for: .footer, value: 75)

        XCTAssertEqual(section.calculateHeight(for: .header), 125)
        XCTAssertEqual(section.calculateHeight(for: .footer), 75)
    }
    
    func test_calculateHeight_returnsAutomaticDimensionForSelfSizingSupplementaryViews() {
        let section = TestTableViewSection.create()
        
        XCTAssertEqual(section.calculateHeight(for: .header), UITableViewAutomaticDimension)
        XCTAssertEqual(section.calculateHeight(for: .footer), UITableViewAutomaticDimension)
    }
    
    func test_calculateHeight_returnZeroForHeightOfNonDisplayedSupplementaryViews() {
        let section = TestTableViewSection()
        
        let headerHeight = section.calculateHeight(for: .header)
        let footerHeight = section.calculateHeight(for: .footer)
        
        XCTAssertEqual(headerHeight, .leastNormalMagnitude)
        XCTAssertEqual(footerHeight, .leastNormalMagnitude)
    }
    
    func test_removeHeight_removesHeightOfSupplementaryViews() {
        let section = TestTableViewSection.create()
        
        section.setHeight(for: .header, value: 200)
        section.setHeight(for: .footer, value: 200)
        
        section.removeHeight(for: .header)
        section.removeHeight(for: .footer)
        
        XCTAssertEqual(section.calculateHeight(for: .header), UITableViewAutomaticDimension)
        XCTAssertEqual(section.calculateHeight(for: .footer), UITableViewAutomaticDimension)
    }
    
    func test_appendRows_appendsNewRowsToSection() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        
        section.append(rows: [row1, row2])
        
        XCTAssertEqual(section.rows.count, 2)
        XCTAssert(section.rows.first === row1)
        XCTAssert(section.rows.last === row2)
    }
    
    func test_appendRow_appendsRowToSection() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        
        section.append(row: row)
        
        XCTAssertEqual(section.rows.count, 1)
        XCTAssert(section.rows.first === row)
    }
    
    func test_headerForTableView_returnsConfiguredHeaderForSection() {
        let tableView = UITableView()
        let section = TestTableViewSection.create()
        
        let reuseIdentifier = String(describing: UITableViewHeaderFooterView.self)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        
        let string = "Test"
        section.setHeader(command: .configuration) { (header, _, section) in
            header.accessibilityIdentifier = string
        }
        
        let header = section.view(supplementaryView: .header, for: tableView, in: 0)
        
        XCTAssertEqual(header?.accessibilityIdentifier, string)
        XCTAssert(header is UITableViewHeaderFooterView)
    }
    
    func test_footerForTableView_returnsConfiguredFooterForSection() {
        let tableView = UITableView()
        let section = TestTableViewSection.create()
        
        let reuseIdentifier = String(describing: UITableViewHeaderFooterView.self)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        
        let string = "Test"
        section.setFooter(command: .configuration) { (footer, _, section) in
            footer.accessibilityIdentifier = string
        }
        
        let footer = section.view(supplementaryView: .footer, for: tableView, in: 0)
        
        XCTAssertEqual(footer?.accessibilityIdentifier, string)
        XCTAssert(footer is UITableViewHeaderFooterView)
    }
    
    func test_perform_performsSectionCommands() {
        let section = TestTableViewSection()
        var headerConfiguration = ""
        var headerDidEndDisplaying = ""
        var headerWillDisplay = ""
        var footerConfiguration = ""
        var footerDidEndDisplaying = ""
        var footerWillDisplay = ""
        
        section.setHeader(command: .configuration) { (view, string, section) in
            headerConfiguration = "Configured!"
        }
        
        section.setHeader(command: .didEndDisplaying) { (view, string, section) in
            headerDidEndDisplaying = "DidEndDisplaying!"
        }
        
        section.setHeader(command: .willDisplay) { (view, string, section) in
            headerWillDisplay = "WillDisplay!"
        }
        
        section.setFooter(command: .configuration) { (view, string, section) in
            footerConfiguration = "Configured!"
        }
        
        section.setFooter(command: .didEndDisplaying) { (view, string, section) in
            footerDidEndDisplaying = "DidEndDisplaying!"
        }
        
        section.setFooter(command: .willDisplay) { (view, string, section) in
            footerWillDisplay = "WillDisplay!"
        }
        
        let view = UITableViewHeaderFooterView()
        
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
        let section = TestTableViewSection()
        var headerConfiguration = ""
        var footerConfiguration = ""
        
        section.setHeader(command: .configuration) { (view, string, section) in
            headerConfiguration = "Configured!"
        }
        
        section.setFooter(command: .configuration) { (view, string, section) in
            footerConfiguration = "Configured!"
        }
        
        let view = UIView()
        
        section.perform(command: .configuration, supplementaryView: .header, for: view, in: 0)
        section.perform(command: .configuration, supplementaryView: .footer, for: view, in: 0)
        
        XCTAssertEqual(headerConfiguration, "")
        XCTAssertEqual(footerConfiguration, "")
    }
    
}
