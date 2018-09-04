//
//  OKTableViewSectionComponent+UnitTests.swift
//  OKTableViewLiaison_Tests
//
//  Created by Dylan Shine on 5/30/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
@testable import OKTableViewLiaison

final class OKTableViewSectionComponent_UnitTests: XCTestCase {
    
    func test_setCommand_setsCommandClosure() {
        let component = TestTableViewSectionComponent()

        var set = false
        component.set(command: .configuration) { _, _, _ in
            set = true
        }
        
        component.perform(command: .configuration, for: UITableViewHeaderFooterView(), in: 0)
        
        XCTAssertEqual(set, true)
    }
    
    func test_removeCommand_removesCommand() {
        let component = TestTableViewSectionComponent()

        var set = false
        component.set(command: .configuration) { _, _, _ in
            set = true
        }
        
        component.remove(command: .configuration)
        component.perform(command: .configuration, for: UITableViewHeaderFooterView(), in: 0)

        XCTAssertEqual(set, false)
    }
    
    func test_setHeight_setsHeightWithClosure() {
        let component = TestTableViewSectionComponent()

        component.set(height: .height) { _ -> CGFloat in
            return 100
        }
       
        component.set(height: .estimatedHeight) { _ -> CGFloat in
            return 150
        }
        
        XCTAssertEqual(component.height, 100)
        XCTAssertEqual(component.estimatedHeight, 150)
    }
    
    func test_setHeight_setsHeightWithValue() {
        let component = TestTableViewSectionComponent()

        component.set(height: .height, 100)
        component.set(height: .estimatedHeight, 105)
        
        XCTAssertEqual(component.height, 100)
        XCTAssertEqual(component.estimatedHeight, 105)
    }
    
    func test_setHeight_returnsAutomaticDimensionForSelfSizingView() {
        let component = TestTableViewSectionComponent()
        XCTAssertEqual(component.height, UITableViewAutomaticDimension)
        XCTAssertEqual(component.estimatedHeight, 0)
    }
    
    func test_removeHeight_removesAPreviouslySetHeight() {
        let component = TestTableViewSectionComponent()

        component.set(height: .height, 100)
        component.set(height: .estimatedHeight, 100)
        component.remove(height: .height)
        component.remove(height: .estimatedHeight)

        XCTAssertEqual(component.height, UITableViewAutomaticDimension)
        XCTAssertEqual(component.estimatedHeight, 0)
    }
    
    func test_estimatedHeight_estimatedHeightReturnsHeightIfHeightIsSetAndEstimatedHeightIsNot() {
        let component = TestTableViewSectionComponent()
        component.set(height: .height, 100)
        
        XCTAssertEqual(component.estimatedHeight, 100)
    }
    
    func test_register_registersViewForSectionComponent() {
        let component = TestTableViewSectionComponent(registrationType: .class(reuseIdentifier: "Test"))
        let tableView = UITableView()
        
        component.register(with: tableView)
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Test")
        
        XCTAssert(view != nil)
    }

    func test_viewForTableViewInSection_returnsConfiguredViewForComponent() {
        
        let component = TestTableViewSectionComponent()
        let string = "Test"
        component.set(command: .configuration) { view, _, _ in
            view.accessibilityIdentifier = string
        }
        
        let tableView = UITableView()
        component.register(with: tableView)
        
        let view = component.view(for: tableView, in: 0)
        
        XCTAssertEqual(view?.accessibilityIdentifier, string)
    }
    
    func test_perform_ignoresCommandPerformanceForIncorrectViewType() {
        let component = TestTableViewSectionComponent()
        var configured = false
        
        component.set(command: .configuration) { _, _, _ in
            configured = true
        }
        
        component.perform(command: .configuration, for: UIView(), in: 0)
        
        XCTAssertEqual(configured, false)
    }
    
    func test_reuseIdentifier_returnsCorrectReuseIdentifierForRegistrationType() {
        let component1 = TestTableViewSectionComponent(registrationType: .defaultClassType)
        let component2 = TestTableViewSectionComponent()
        let component3 = TestTableViewSectionComponent(registrationType: .class(reuseIdentifier: "Test"))
        
        XCTAssertEqual(component1.reuseIdentifier, String(describing: UITableViewHeaderFooterView.self))
        XCTAssertEqual(component2.reuseIdentifier, String(describing: UITableViewHeaderFooterView.self))
        XCTAssertEqual(component3.reuseIdentifier, "Test")
    }
}
