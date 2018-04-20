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
    
    func test_setHeader_properlySetsHeaderCommandClosure() {
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
    
    func test_removeHeader_properlyRemovesHeaderCommandClosure() {
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
    
    func test_setFooter_properlySetsFooterCommandClosure() {
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
    
    func test_removeFooter_properlyRemovesFooterCommandClosure() {
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
    
    func test_setHeight_properlySetsHeightOfSupplementaryViews() {
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()
        let section3 = TestTableViewSection()
        
        section1.setHeight(for: .header) { _ -> CGFloat in
            return 100
        }
        
        section1.setHeight(for: .footer) { _ -> CGFloat in
            return 100
        }
        
        section2.setHeight(for: .header, value: 200)
        section2.setHeight(for: .footer, value: 200)

        let section1HeaderHeight = section1.calculateHeight(for: .header)
        let section1FooterHeight = section1.calculateHeight(for: .footer)
        let section2HeaderHeight = section2.calculateHeight(for: .header)
        let section2FooterHeight = section2.calculateHeight(for: .footer)
        let section3HeaderHeight = section3.calculateHeight(for: .header)
        let section3FooterHeight = section3.calculateHeight(for: .footer)

        XCTAssertEqual(section1HeaderHeight, 100)
        XCTAssertEqual(section1FooterHeight, 100)
        XCTAssertEqual(section2HeaderHeight, 200)
        XCTAssertEqual(section2FooterHeight, 200)
        XCTAssertEqual(section3HeaderHeight, UITableViewAutomaticDimension)
        XCTAssertEqual(section3FooterHeight, UITableViewAutomaticDimension)
    }
    
    func test_removeHeight_properlyRemovesHeightOfSupplementaryViews() {
        let section = TestTableViewSection()

        section.setHeight(for: .header, value: 200)
        section.setHeight(for: .footer, value: 200)
        
        section.removeHeight(for: .header)
        section.removeHeight(for: .footer)
        
        XCTAssertEqual(section.calculateHeight(for: .header), UITableViewAutomaticDimension)
        
        XCTAssertEqual(section.calculateHeight(for: .footer), UITableViewAutomaticDimension)

    }
    
    func test_appendRows_properlyAppendsNewRowsToSection() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        
        section.append(rows: [row1, row2])
        
        XCTAssertEqual(section.rows.count, 2)
        XCTAssert(section.rows.first === row1)
        XCTAssert(section.rows.last === row2)
    }
    
    func test_appendRow_properlyAppendsRowToSection() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        
        section.append(row: row)
        
        XCTAssertEqual(section.rows.count, 1)
        XCTAssert(section.rows.first === row)
    }
    
    func test_headerForTableView_returnsConfiguredHeaderForSection() {
        let tableView = UITableView()
        let section = TestTableViewSection.create()
        
        // This is the internal format of how Header Section views are registered to the TableView
        let reuseIdentifier = "\(OKTableViewSectionSupplementaryView.header.identifer)\(String(describing: UITableViewHeaderFooterView.self))"
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
        
        // This is the internal format of how Footer Section views are registered to the TableView
        let reuseIdentifier = "\(OKTableViewSectionSupplementaryView.footer.identifer)\(String(describing: UITableViewHeaderFooterView.self))"
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
        
        let string = "Test"
        section.setFooter(command: .configuration) { (footer, _, section) in
            footer.accessibilityIdentifier = string
        }
        
        let footer = section.view(supplementaryView: .footer, for: tableView, in: 0)
        
        XCTAssertEqual(footer?.accessibilityIdentifier, string)
        XCTAssert(footer is UITableViewHeaderFooterView)
    }
    
    func test_perform_properlyPerformsCommands() {
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
