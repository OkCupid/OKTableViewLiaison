//
//  OKTableViewRow+UnitTests.swift
//  OKTableViewLiaisonTests
//
//  Created by Dylan Shine on 3/27/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import XCTest
@testable import OKTableViewLiaison

final class OKTableViewRow_UnitTests: XCTestCase {

    func test_registerCellTypeWithTableView_registersCellForRow() {
        let tableView = UITableView()
        
        let row = TestTableViewRow.create()
        
        row.registerCellType(with: tableView)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier)
        
        XCTAssert(cell != nil)
    }
    
    func test_setCommand_properlySetsCommandClosure() {
        let row = TestTableViewRow.create()
        
        var set = false
        row.set(command: .configuration) { (_, _, _) in
            set = true
        }
       
        row.perform(command: .configuration, for: UITableViewCell(), at: IndexPath())
        
        XCTAssertEqual(set, true)
    }
    
    func test_removeCommand_properlyRemovesCommand() {
        let row = TestTableViewRow.create()
        
        var set = false
        row.set(command: .configuration) { (_, _, _) in
            set = true
        }
        
        row.remove(command: .configuration)
        row.perform(command: .configuration, for: UITableViewCell(), at: IndexPath())
        
        XCTAssertEqual(set, false)
    }
    
    func test_setHeight_properlySetsHeightWithClosure() {
        let row = TestTableViewRow.create()

        row.set(height: .height) { (_) -> CGFloat in
            return 100
        }
        
        XCTAssertEqual(row.height, 100)
    }
    
    func test_setHeight_properlySetsHeightWithValue() {
        let row = TestTableViewRow.create()
        
        row.set(height: .height, value: 100)
        
        XCTAssertEqual(row.height, 100)
    }
    
    func test_editable_returnsIfRowIsEditable() {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Action", handler: { (action, indexPath) in
            print("This action is being invoked")
        })
        
        let row1 = TestTableViewRow(editingStyle: .delete)
        let row2 = TestTableViewRow(editingStyle: .insert)
        let row3 = TestTableViewRow(editActions: [editAction])
        let row4 = TestTableViewRow()
        
        XCTAssertEqual(row1.editable, true)
        XCTAssertEqual(row2.editable, true)
        XCTAssertEqual(row3.editable, true)
        XCTAssertEqual(row4.editable, false)
    }
    
    func test_reuseIdentifier_returnsCorrectReuseIdentifierForRegistrationType() {
        let row1 = TestTableViewRow(registrationType: .defaultNibRegistration(for: TestTableViewCell.self))
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow(registrationType: .class(identifier: "Test"))
        
        XCTAssertEqual(row1.reuseIdentifier, String(describing: TestTableViewCell.self))
        XCTAssertEqual(row2.reuseIdentifier, String(describing: UITableViewCell.self))
        XCTAssertEqual(row3.reuseIdentifier, "Test")
    }
    
    func test_cellForTableViewAt_returnsConfiguredCellForRow() {
        
        let row = TestTableViewRow.create()
        let string = "Test"
        row.set(command: .configuration) { (cell, _, indexPath) in
            cell.accessibilityIdentifier = string
        }
        
        let tableView = UITableView()
        row.registerCellType(with: tableView)
        
        let cell = row.cell(for: tableView, at: IndexPath())
        
        XCTAssertEqual(cell.accessibilityIdentifier, string)
    }
    
    func test_perform_properlyPerformsCommands() {
        let row = TestTableViewRow.create()
        var configured = false
        
        row.set(command: .configuration) { (_, _, _) in
            configured = true
        }
        
        row.perform(command: .configuration, for: UITableViewCell(), at: IndexPath())
        
        XCTAssertEqual(configured, true)
    }
    
    func test_perform_ignoresCommandPerformanceForIncorrectCellType() {
        let row = OKTableViewRow<TestTableViewCell, Void>()
        var configured = false
        
        row.set(command: .configuration) { (_, _, _) in
            configured = true
        }
            
        row.perform(command: .configuration, for: UITableViewCell(), at: IndexPath())
        
        XCTAssertEqual(configured, false)
    }
    
    func test_calculateHeight_returnsCorrectHeightForRow() {
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow()

        row1.set(height: .height) { (_) -> CGFloat in
            return 100
        }
        
        row1.set(height: .estimatedHeight) { (_) -> CGFloat in
            return 100
        }
        
        row2.set(height: .height, value: 200)
        row2.set(height: .estimatedHeight, value: 200)
        
        XCTAssertEqual(row1.height, 100)
        XCTAssertEqual(row1.estimatedHeight, 100)
        XCTAssertEqual(row2.height, 200)
        XCTAssertEqual(row2.estimatedHeight, 200)
        XCTAssertEqual(row3.height, UITableViewAutomaticDimension)
        XCTAssertEqual(row3.estimatedHeight, UITableViewAutomaticDimension)
    }
    
}
