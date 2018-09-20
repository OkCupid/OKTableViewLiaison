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
    
    func test_setCommand_setsCommandClosure() {
        let row = TestTableViewRow()
        
        var set = false
        row.set(command: .configuration) { (_, _, _) in
            set = true
        }
       
        row.perform(command: .configuration, for: UITableViewCell(), at: IndexPath())
        
        XCTAssertTrue(set)
    }
    
    func test_removeCommand_removesCommand() {
        let row = TestTableViewRow()
        
        var set = false
        row.set(command: .configuration) { (_, _, _) in
            set = true
        }
        
        row.remove(command: .configuration)
        row.perform(command: .configuration, for: UITableViewCell(), at: IndexPath())
        
        XCTAssertFalse(set)
    }
    
    func test_setHeight_setsHeightWithClosure() {
        let row = TestTableViewRow()

        row.set(height: .height) { (_) -> CGFloat in
            return 100
        }
        
        XCTAssertEqual(row.height, 100)
    }
    
    func test_setHeight_setsHeightWithValue() {
        let row = TestTableViewRow()
        
        row.set(height: .height, 100)
        
        XCTAssertEqual(row.height, 100)
    }
    
    func test_setHeight_returnsAutomaticDimensionForSelfSizingRow() {
        let row = TestTableViewRow()
        XCTAssertEqual(row.height, UITableView.automaticDimension)
        XCTAssertEqual(row.estimatedHeight, UITableView.automaticDimension)
    }
    
    func test_removeHeight_removesAPreviouslySetHeight() {
        let row = TestTableViewRow()
        
        row.set(height: .height, 100)
        row.set(height: .estimatedHeight, 100)
        
        row.remove(height: .height)
        row.remove(height: .estimatedHeight)
        
        XCTAssertEqual(row.height, UITableView.automaticDimension)
        XCTAssertEqual(row.estimatedHeight, UITableView.automaticDimension)
    }
    
    func test_setPrefetchCommand_setPrefetchCommandClosure() {
        let row = TestTableViewRow()
        
        var prefetch = false
        row.set(prefetchCommand: .prefetch) { _, _ in
            prefetch = true
        }
        
        var cancel = false
        row.set(prefetchCommand: .cancel) { _, _ in
            cancel = true
        }
        
        row.perform(prefetchCommand: .prefetch, for: IndexPath())
        row.perform(prefetchCommand: .cancel, for: IndexPath())

        XCTAssertTrue(prefetch)
        XCTAssertTrue(cancel)
    }
    
    func test_removePrefetchCommand_removesPreviouslySetPrefetchCommands() {
        let row = TestTableViewRow()
        
        var prefetch = false
        row.set(prefetchCommand: .prefetch) { _, _ in
            prefetch = true
        }
        
        var cancel = false
        row.set(prefetchCommand: .cancel) { _, _ in
            cancel = true
        }
        
        row.remove(prefetchCommand: .prefetch)
        row.remove(prefetchCommand: .cancel)
        
        row.perform(prefetchCommand: .prefetch, for: IndexPath())
        row.perform(prefetchCommand: .cancel, for: IndexPath())
        
        XCTAssertFalse(prefetch)
        XCTAssertFalse(cancel)
    }
    
    func test_editable_returnsIfRowIsEditable() {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Action", handler: { (action, indexPath) in
            print("This action is being invoked")
        })
        
        let row1 = TestTableViewRow(editingStyle: .delete)
        let row2 = TestTableViewRow(editingStyle: .insert)
        let row3 = TestTableViewRow(editActions: [editAction])
        let row4 = TestTableViewRow()
        
        XCTAssertTrue(row1.editable)
        XCTAssertTrue(row2.editable)
        XCTAssertTrue(row3.editable)
        XCTAssertFalse(row4.editable)
    }
    
    func test_reuseIdentifier_returnsCorrectReuseIdentifierForRegistrationType() {
        let row1 = TestTableViewRow(registrationType: .defaultClassType)
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow(registrationType: .class(reuseIdentifier: "Test"))
        
        XCTAssertEqual(row1.reuseIdentifier, String(describing: UITableViewCell.self))
        XCTAssertEqual(row2.reuseIdentifier, String(describing: UITableViewCell.self))
        XCTAssertEqual(row3.reuseIdentifier, "Test")
    }
    
    func test_register_registersCellForRow() {
        let row = TestTableViewRow(registrationType: .class(reuseIdentifier: "Test"))
        let tableView = UITableView()
        
        row.register(with: tableView)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Test")
        
        XCTAssertNotNil(cell)
    }
    
    func test_cellForTableViewAt_returnsConfiguredCellForRow() {
        let row = TestTableViewRow()
        let string = "Test"
        row.set(command: .configuration) { (cell, _, indexPath) in
            cell.accessibilityIdentifier = string
        }
        
        let tableView = UITableView()
        
        row.register(with: tableView)
        
        let cell = row.cell(for: tableView, at: IndexPath())
        
        XCTAssertEqual(cell.accessibilityIdentifier, string)
    }
    
    func test_perform_ignoresCommandPerformanceForIncorrectCellType() {
        let row = OKTableViewRow<TestTableViewCell, Void>()
        var configured = false
        
        row.set(command: .configuration) { _, _, _ in
            configured = true
        }
            
        row.perform(command: .configuration, for: UITableViewCell(), at: IndexPath())
        
        XCTAssertFalse(configured)
    }

}
