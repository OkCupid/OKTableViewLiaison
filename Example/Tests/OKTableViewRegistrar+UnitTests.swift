//
//  OKTableViewRegistrar+UnitTests.swift
//  OKTableViewLiaison_Tests
//
//  Created by Dylan Shine on 8/29/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest

@testable import OKTableViewLiaison

final class OKTableViewRegistrar_UnitTests: XCTestCase {
    var tableView: UITableView!
    var registrar: OKTableViewRegistrar!
    
    override func setUp() {
        super.setUp()
        tableView = UITableView()
        registrar = OKTableViewRegistrar()
        registrar.tableView = tableView
    }
    
    func test_tableView_doesNotStronglyReferenceTableView() {
        let tableView = UITableView()
        let initial = CFGetRetainCount(tableView)
        registrar.tableView = tableView
        let current = CFGetRetainCount(tableView)
        
        XCTAssertEqual(initial, current)
    }
    
    func test_tableView_removesAllRegistrationsWhenTableViewIsSet() {
        let row = TestTableViewRow()
        row.register(with: registrar)
        registrar.tableView = tableView
        
        XCTAssertEqual(registrar.registrations.count, 0)
    }
    
    func test_register_registersViewForSectionComponent() {
        let component = TestTableViewSectionComponent(registrationType: .class(identifier: "Test"))
        component.register(with: registrar)
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Test")
        
        XCTAssert(view != nil)
    }
    
    func test_register_registersCellForRow() {
        let row = TestTableViewRow(registrationType: .class(identifier: "Test"))
        row.register(with: registrar)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Test")
        
        XCTAssert(cell != nil)
    }
    
    func test_register_doesNotDuplicateRegistrationForSameViewWithSameIdentifier() {
        let component = TestTableViewSectionComponent()
        let component2 = OKTableViewSectionComponent<UITableViewHeaderFooterView, Void>()
        
        component.register(with: registrar)
        component2.register(with: registrar)
        
        let registration = OKTableViewRegistrar.Registration(className: "UITableViewHeaderFooterView",
                                                             identifier: "UITableViewHeaderFooterView")
        
        XCTAssertEqual(registrar.registrations.count, 1)
        XCTAssert(registrar.registrations.contains(registration))
    }
    
    func test_register_registersSameViewWithDifferentIdentifiers() {
        let component = TestTableViewSectionComponent(registrationType: .class(identifier: "Test"))
        let component2 = OKTableViewSectionComponent<UITableViewHeaderFooterView, Void>()
        
        component.register(with: registrar)
        component2.register(with: registrar)
        
        let registration1 = OKTableViewRegistrar.Registration(className: "UITableViewHeaderFooterView",
                                                              identifier: "UITableViewHeaderFooterView")
        
        
        let registration2 = OKTableViewRegistrar.Registration(className: "UITableViewHeaderFooterView",
                                                              identifier: "Test")
        
        XCTAssertEqual(registrar.registrations.count, 2)
        XCTAssert(registrar.registrations.contains(registration1))
        XCTAssert(registrar.registrations.contains(registration2))
    }
    
    func test_register_doesNotDuplicateRegistrationForSameCellTypeWithSameIdentifier() {
        let row1 = TestTableViewRow()
        let row2 = OKTableViewRow<UITableViewCell, Void>()
        
        row1.register(with: registrar)
        row2.register(with: registrar)
        
        let registration = OKTableViewRegistrar.Registration(className: "UITableViewCell",
                                                             identifier: "UITableViewCell")
        
        XCTAssertEqual(registrar.registrations.count, 1)
        XCTAssert(registrar.registrations.contains(registration))
    }
    
    func test_register_registersSameCellWithDifferentIdentifiers() {
        let row1 = TestTableViewRow(registrationType: .class(identifier: "Test"))
        let row2 = OKTableViewRow<UITableViewCell, Void>()
        
        row1.register(with: registrar)
        row2.register(with: registrar)
        
        let registration1 = OKTableViewRegistrar.Registration(className: "UITableViewCell",
                                                              identifier: "UITableViewCell")
        
        
        let registration2 = OKTableViewRegistrar.Registration(className: "UITableViewCell",
                                                              identifier: "Test")
        
        XCTAssertEqual(registrar.registrations.count, 2)
        XCTAssert(registrar.registrations.contains(registration1))
        XCTAssert(registrar.registrations.contains(registration2))
    }
    
    func test_register_replacesRegistration() {
        let row1 = TestTableViewRow(registrationType: .class(identifier: "Test"))
        let row2 = OKTableViewRow<TestTableViewCell, Void>(registrationType: .class(identifier: "Test"))
        
        row1.register(with: registrar)
        row2.register(with: registrar)
        
        let registration = OKTableViewRegistrar.Registration(className: "TestTableViewCell",
                                                              identifier: "Test")
        
        XCTAssertEqual(registrar.registrations.count, 1)
        XCTAssert(registrar.registrations.contains(registration))
    }
    
    func test_register_registersAllViewsInSection() {
        let component = TestTableViewSectionComponent()
        let row = TestTableViewRow()
        let row2 = TestTableViewRow()
        
        let section = OKTableViewSection(rows: [row, row2], componentDisplayOption: .header(component: component))
        
        registrar.register(section: section)
        
        let componentRegistration = OKTableViewRegistrar.Registration(className: "UITableViewHeaderFooterView",
                                                                      identifier: "UITableViewHeaderFooterView")
        
        let rowRegistration = OKTableViewRegistrar.Registration(className: "UITableViewCell",
                                                                identifier: "UITableViewCell")
        
        XCTAssertEqual(registrar.registrations.count, 2)
        XCTAssert(registrar.registrations.contains(componentRegistration))
        XCTAssert(registrar.registrations.contains(rowRegistration))
    }
    
    func test_register_registersAllViewsInSections() {
        let component = TestTableViewSectionComponent()
        let row = TestTableViewRow()
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow(registrationType: .class(identifier: "Test"))
        let row4 = TestTableViewRow(registrationType: .class(identifier: "Cool"))

        let section1 = OKTableViewSection(rows: [row, row2], componentDisplayOption: .header(component: component))
        let section2 = OKTableViewSection(rows: [row3, row4])

        registrar.register(sections: [section1, section2])
        
        let componentRegistration = OKTableViewRegistrar.Registration(className: "UITableViewHeaderFooterView",
                                                                      identifier: "UITableViewHeaderFooterView")
        
        let row1And2Registration = OKTableViewRegistrar.Registration(className: "UITableViewCell",
                                                                     identifier: "UITableViewCell")
        
        let row3Registration = OKTableViewRegistrar.Registration(className: "UITableViewCell",
                                                                 identifier: "Test")
        
        let row4Registration = OKTableViewRegistrar.Registration(className: "UITableViewCell",
                                                                 identifier: "Cool")
        
        XCTAssertEqual(registrar.registrations.count, 4)
        XCTAssert(registrar.registrations.contains(componentRegistration))
        XCTAssert(registrar.registrations.contains(row1And2Registration))
        XCTAssert(registrar.registrations.contains(row3Registration))
        XCTAssert(registrar.registrations.contains(row4Registration))
    }
    
}
