//
//  OKTableViewLiaison+UnitTests.swift
//  OKTableViewLiaisonTests
//
//  Created by Dylan Shine on 3/23/18.
//  Copyright © 2018 Dylan Shine. All rights reserved.
//

import XCTest
@testable import OKTableViewLiaison

final class OKTableViewLiaison_UnitTests: XCTestCase {
    var liaison: OKTableViewLiaison!
    var tableView: UITableView!
    
    override func setUp() {
        super.setUp()
        liaison = OKTableViewLiaison()
        tableView = UITableView()
        liaison.liaise(tableView: tableView)
    }
    
    func test_tableViewRetain_doesNotStronglyReferenceTableView() {
        let tableView = UITableView()
        let initial = CFGetRetainCount(tableView)
        liaison.liaise(tableView: tableView)
        let current = CFGetRetainCount(tableView)
        
        XCTAssertEqual(initial, current)
    }
    
    func test_paginationDelegateRetain_doesNotStronglyReferencePaginationDelegate() {
        let delegate = TestTableViewLiaisonPaginationDelegate()
        let initial = CFGetRetainCount(delegate)
        liaison.paginationDelegate = delegate
        let current = CFGetRetainCount(delegate)
        
        XCTAssertEqual(initial, current)
    }
    
    func test_configure_setsDelegateAndDataSource() {
        XCTAssert(tableView.delegate === liaison)
        XCTAssert(tableView.dataSource === liaison)
    }
    
    func test_detachTableView_removesDelegateAndDataSource() {
        liaison.detachTableView()
        XCTAssert(tableView.delegate == nil)
        XCTAssert(tableView.dataSource == nil)
    }
    
    func test_toggleIsEditing_propleyToggles() {
        tableView.isEditing = true
        liaison.toggleIsEditing()
        
        XCTAssertFalse(tableView.isEditing)
    }
    
    func test_init_properlyInitializesWithSections() {
        let sections = [TestTableViewSection(), TestTableViewSection()]
        let liaison = OKTableViewLiaison(sections: sections)
        liaison.liaise(tableView: tableView)
        XCTAssertEqual(tableView.numberOfSections, 2)
    }
    
    func test_appendSection_addsSectionToTableView() {
        XCTAssertEqual(tableView.numberOfSections, 0)
        
        let section = TestTableViewSection()
        liaison.append(section: section)

        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssert(liaison.sections.first === section)
    }
    
    func test_appendSections_addsSectionsToTableView() {
        XCTAssertEqual(tableView.numberOfSections, 0)
        
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()

        liaison.append(sections: [section1, section2])
        
        XCTAssertEqual(tableView.numberOfSections, 2)
        XCTAssert(liaison.sections.first === section1)
        XCTAssert(liaison.sections.last === section2)

    }
    
    func test_insertSection_insertsSectionIntoTableView() {
        let section1 = TestTableViewSection()
        liaison.append(section: section1)
        XCTAssertEqual(tableView.numberOfSections, 1)
        
        let section2 = TestTableViewSection()
        liaison.insert(section: section2, at: 0)
      
        XCTAssertEqual(tableView.numberOfSections, 2)
        XCTAssert(liaison.sections.first === section2)
    }
    
    func test_deleteSection_removesSectionFromTableView() {
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()
        
        liaison.append(section: section1)
        liaison.append(section: section2)

        liaison.deleteSection(at: 0)
        
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssert(liaison.sections.first === section2)
    }
    
    func test_replaceSection_replacesSectionOfTableView() {
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()
        
        liaison.append(section: section1)

        liaison.replaceSection(at: 0, with: section2)
        XCTAssertEqual(tableView.numberOfSections, 1)
        XCTAssert(liaison.sections.first === section2)
    }
    
    func test_moveSection_moveSectionOfTableView() {
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()
        let section3 = TestTableViewSection()
        
        liaison.append(section: section1)
        liaison.append(section: section2)
        liaison.append(section: section3)

        liaison.moveSection(at: 0, to: 2)
        
        XCTAssert(liaison.sections.first === section2)
        XCTAssert(liaison.sections.last === section1)
    }
    
    func test_reloadSection_reloadsSectionOfTableView() {
        let section = TestTableViewSection.create()
        var capturedHeader: UITableViewHeaderFooterView?
        let string = "Test"
        section.setHeader(command: .configuration) { (header, _, index) in
            header.accessibilityIdentifier = string
            capturedHeader = header
        }
        
        liaison.append(section: section)
        tableView.reloadData()
        
        capturedHeader?.accessibilityIdentifier = "Changed"
        
        liaison.reloadSection(at: 0)
        
        XCTAssertEqual(capturedHeader?.accessibilityIdentifier, string)
    }
    
    func test_clearSections_removesAllSectionsFromTableView() {
        
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()
        let section3 = TestTableViewSection()
        
        liaison.append(sections: [section1, section2, section3])
        liaison.clearSections()
        
        XCTAssertEqual(tableView.numberOfSections, 0)
        XCTAssertEqual(liaison.sections.count, 0)
    }
    
    func test_clearSections_removesAllSectionsFromTableViewAndAppendsNewSections() {
        
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()
        let section3 = TestTableViewSection()
        let section4 = TestTableViewSection()
        let section5 = TestTableViewSection()

        liaison.append(sections: [section1, section2, section3])
        liaison.clearSections(replacedBy: [section4, section5])
        
        XCTAssertEqual(tableView.numberOfSections, 2)
        XCTAssertEqual(liaison.sections.count, 2)
        XCTAssert(liaison.sections.first === section4)
        XCTAssert(liaison.sections.last === section5)
    }
    
    func test_appendRow_appendsRowToSection() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        
        var inserted = false
        var actualIndexPath: IndexPath?
        let expectedIndexPath = IndexPath(row: 0, section: 0)
        row.set(command: .insert) { (_, _, indexPath) in
            inserted = true
            actualIndexPath = indexPath
        }
        
        liaison.append(section: section)
        
        XCTAssert(section.rows.count == 0)
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.append(row: row)
        }
        
        XCTAssert(section.rows.count == 1)
        XCTAssertEqual(inserted, true)
        XCTAssertEqual(actualIndexPath, expectedIndexPath)
    }
    
    func test_appendRows_appendsRowsToSection() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        
        var insertedRow1 = false
        var actualIndexPathRow1: IndexPath?
        let expectedIndexPathRow1 = IndexPath(row: 0, section: 0)
        row1.set(command: .insert) { (_, _, indexPath) in
            insertedRow1 = true
            actualIndexPathRow1 = indexPath
        }
        
        var insertedRow2 = false
        var actualIndexPathRow2: IndexPath?
        let expectedIndexPathRow2 = IndexPath(row: 1, section: 0)
        row2.set(command: .insert) { (_, _, indexPath) in
            insertedRow2 = true
            actualIndexPathRow2 = indexPath
        }

        liaison.append(section: section)
        
        XCTAssert(section.rows.count == 0)
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.append(rows: [row1, row2])
        }
        
        XCTAssert(section.rows.count == 2)
        XCTAssertEqual(insertedRow1, true)
        XCTAssertEqual(insertedRow2, true)
        XCTAssertEqual(actualIndexPathRow1, expectedIndexPathRow1)
        XCTAssertEqual(actualIndexPathRow2, expectedIndexPathRow2)
    }
    
    func test_insertRow_insertsRowIntoSection() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow()
        
        liaison.append(section: section)
        liaison.append(rows: [row1, row2])
        
        let expectedIndexPath = IndexPath(row: 0, section: 0)
        var insertedRow = false
        var actualIndexPathRow: IndexPath?
        
        row3.set(command: .insert) { (_, _, indexPath) in
            insertedRow = true
            actualIndexPathRow = indexPath
        }
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.insert(row: row3, at: expectedIndexPath)
        }
        
        XCTAssert(section.rows.first === row3)
        XCTAssertEqual(insertedRow, true)
        XCTAssertEqual(actualIndexPathRow, expectedIndexPath)
    }
    
    func test_deleteRows_removesRowsFromTableView() {
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow()
        
        let row1IndexPath = IndexPath(row: 0, section: 0)
        var deletedRow1 = false
        var actualIndexPathRow1: IndexPath?
        row1.set(command: .delete) { (_, _, indexPath) in
            deletedRow1 = true
            actualIndexPathRow1 = indexPath
        }
        
        let row3IndexPath = IndexPath(row: 0, section: 1)
        var deletedRow3 = false
        var actualIndexPathRow3: IndexPath?
        row3.set(command: .delete) { (_, _, indexPath) in
            deletedRow3 = true
            actualIndexPathRow3 = indexPath
        }

        liaison.append(sections: [section1, section2])
        liaison.append(rows: [row1, row2])
        liaison.append(row: row3, to: 1)
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.deleteRows(at: [row1IndexPath, row3IndexPath])
        }
        
        XCTAssertEqual(section1.rows.count, 1)
        XCTAssertEqual(section2.rows.count, 0)
        XCTAssertEqual(deletedRow1, true)
        XCTAssertEqual(deletedRow3, true)
        XCTAssertEqual(actualIndexPathRow1, row1IndexPath)
        XCTAssertEqual(actualIndexPathRow3, row3IndexPath)
    }
    
    func test_deleteRow_removesRowFromSection() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        
        let expectedIndexPath = IndexPath(row: 0, section: 0)
        var deletedRow = false
        var actualIndexPathRow: IndexPath?
        row1.set(command: .delete) { (_, _, indexPath) in
            deletedRow = true
            actualIndexPathRow = indexPath
        }

        liaison.append(section: section)
        liaison.append(rows: [row1, row2])
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.deleteRow(at: expectedIndexPath)
        }
        
        XCTAssert(section.rows.count == 1)
        XCTAssert(section.rows.first === row2)
        XCTAssertEqual(deletedRow, true)
        XCTAssertEqual(actualIndexPathRow, expectedIndexPath)
    }
    
    func test_reloadRows_reloadsRowsInSection() {
        let section = TestTableViewSection()
        let row = TestTableViewRow.create()
        
        var reloaded = false
        row.set(command: .reload) { (_, _, _) in
            reloaded = true
        }
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.reloadRows(at: [IndexPath(row: 0, section: 0)])
        }

        let count = tableView.callCounts[.reloadRows]
        
        XCTAssertEqual(count, 1)
        XCTAssertEqual(reloaded, true)

    }
    
    func test_replaceRow_replaceRowInSection() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        
        var deleted = false
        row1.set(command: .delete) { (_, _, _) in
            deleted = true
        }
        
        var inserted = false
        row2.set(command: .insert) { (_, _, _) in
            inserted = true
        }
        
        liaison.append(section: section)
        liaison.append(row: row1)
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.replaceRow(at: IndexPath(row: 0, section: 0), with: row2)
        }
        
        XCTAssert(section.rows.count == 1)
        XCTAssert(section.rows.first === row2)
        XCTAssertEqual(deleted, true)
        XCTAssertEqual(inserted, true)

    }
    
    func test_moveRow_withinSameSection() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow()
        
        var moved = false
        var actualDestination: IndexPath?
        let destination = IndexPath(row: 2, section: 0)
        row1.set(command: .move) { (_, _, indexPath) in
            moved = true
            actualDestination = indexPath
        }

        liaison.append(section: section)
        liaison.append(rows: [row1, row2, row3])
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.moveRow(from: IndexPath(row: 0, section: 0), to: destination)
        }
        
        XCTAssert(section.rows.first === row2)
        XCTAssert(section.rows.last === row1)
        XCTAssertEqual(moved, true)
        XCTAssertEqual(actualDestination, destination)

    }
    
    func test_moveRow_intoDifferentSection() {
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()

        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow()
        let row4 = TestTableViewRow()
        let row5 = TestTableViewRow()
        
        var moved = false
        var actualDestination: IndexPath?
        let destination = IndexPath(row: 2, section: 1)
        row1.set(command: .move) { (_, _, indexPath) in
            moved = true
            actualDestination = indexPath
        }
        
        liaison.append(section: section1)
        liaison.append(section: section2)

        liaison.append(rows: [row1, row2, row3])
        liaison.append(rows: [row4, row5], to: 1)

        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.moveRow(from: IndexPath(row: 0, section: 0), to: destination)
        }
        
        XCTAssert(section1.rows.count == 2)
        XCTAssert(section1.rows.first === row2)
        XCTAssert(section2.rows.count == 3)
        XCTAssert(section2.rows.last === row1)
        XCTAssertEqual(moved, true)
        XCTAssertEqual(actualDestination, destination)
    }
    
    func test_swapRow_withinSameSection() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow()
        
        var sourceMoved = false
        var swappedSourceIndexPath: IndexPath?
        let sourceIndexPath = IndexPath(row: 0, section: 0)
        row1.set(command: .move) { (_, _, indexPath) in
            sourceMoved = true
            swappedSourceIndexPath = indexPath
        }
        
        var destinationMoved = false
        var swappedDestinationIndexPath: IndexPath?
        let destinationIndexPath = IndexPath(row: 2, section: 0)
        row3.set(command: .move) { (_, _, indexPath) in
            destinationMoved = true
            swappedDestinationIndexPath = indexPath
        }
        
        liaison.append(section: section)
        liaison.append(rows: [row1, row2, row3])

        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.swapRow(from: sourceIndexPath, to: destinationIndexPath)
        }
        
        XCTAssert(section.rows.first === row3)
        XCTAssert(section.rows.last === row1)
        XCTAssertEqual(sourceMoved, true)
        XCTAssertEqual(destinationMoved, true)
        XCTAssertEqual(swappedSourceIndexPath, destinationIndexPath)
        XCTAssertEqual(swappedDestinationIndexPath, sourceIndexPath)

    }
    
    func test_swapRow_intoDifferentSection() {
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()
        
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow()
        let row4 = TestTableViewRow()
        
        var sourceMoved = false
        var swappedSourceIndexPath: IndexPath?
        let sourceIndexPath = IndexPath(row: 0, section: 0)
        row1.set(command: .move) { (_, _, indexPath) in
            sourceMoved = true
            swappedSourceIndexPath = indexPath
        }
        
        var destinationMoved = false
        var swappedDestinationIndexPath: IndexPath?
        let destinationIndexPath = IndexPath(row: 1, section: 1)
        row4.set(command: .move) { (_, _, indexPath) in
            destinationMoved = true
            swappedDestinationIndexPath = indexPath
        }
        
        liaison.append(section: section1)
        liaison.append(section: section2)
        
        liaison.append(rows: [row1, row2])
        liaison.append(rows: [row3, row4], to: 1)
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.swapRow(from: sourceIndexPath, to: destinationIndexPath)
        }
        
        XCTAssert(section1.rows.first === row4)
        XCTAssert(section2.rows.last === row1)
        XCTAssertEqual(sourceMoved, true)
        XCTAssertEqual(destinationMoved, true)
        XCTAssertEqual(swappedSourceIndexPath, destinationIndexPath)
        XCTAssertEqual(swappedDestinationIndexPath, sourceIndexPath)
    }
    
    func test_tableViewCellForRow_createsCorrectCellForRow() {
        let section = TestTableViewSection()
        
        let row = TestTableViewRow.create()
        let string = "Test"
        row.set(command: .configuration) { (cell, _, indexPath) in
            cell.accessibilityIdentifier = string
        }
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        let cell = liaison.tableView(tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cell.accessibilityIdentifier, string)
        
    }
    
    func test_numberOfSectionsInTableView_returnsCorrectAmountOfSections() {
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()
        
        liaison.append(section: section1)
        liaison.append(section: section2)
        let count = liaison.numberOfSections(in: tableView)
        
        XCTAssertEqual(count, 2)
    }
    
    func test_tableViewNumberOfRowsInSection_returnsCorrectAmountOfRows() {
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()
        
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow()
        let row4 = TestTableViewRow()
        let row5 = TestTableViewRow()
        
        liaison.append(section: section1)
        liaison.append(section: section2)
        
        liaison.append(rows: [row1, row2])
        liaison.append(rows: [row3, row4, row5], to: 1)
        
        let section1Count = liaison.tableView(tableView, numberOfRowsInSection: 0)
        let section2Count = liaison.tableView(tableView, numberOfRowsInSection: 1)
        
        XCTAssertEqual(section1Count, 2)
        XCTAssertEqual(section2Count, 3)
    }
    
    func test_tableViewCanEditRow_correctlyReturnsWhetherRowIsEditable() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow(editingStyle: .delete)
        let row2 = TestTableViewRow(editingStyle: .insert)
        let row3 = TestTableViewRow()
        
        liaison.append(section: section)
        liaison.append(rows: [row1, row2, row3])
        
        let row1Editable = liaison.tableView(tableView, canEditRowAt: IndexPath(row: 0, section: 0))
        let row2Editable = liaison.tableView(tableView, canEditRowAt: IndexPath(row: 1, section: 0))
        let row3Editable = liaison.tableView(tableView, canEditRowAt: IndexPath(row: 2, section: 0))
        let nonExistentRowEditable = liaison.tableView(tableView, canEditRowAt: IndexPath(row: 3, section: 0))
        
        XCTAssertEqual(row1Editable, true)
        XCTAssertEqual(row2Editable, true)
        XCTAssertEqual(row3Editable, false)
        XCTAssertEqual(nonExistentRowEditable, false)

    }
    
    func test_tableViewCanMoveRow_correctlyReturnsWhetherRowIsMovable() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow(movable: true)
        let row2 = TestTableViewRow()
        
        liaison.append(section: section)
        liaison.append(rows: [row1, row2])
        
        let row1Movable = liaison.tableView(tableView, canMoveRowAt: IndexPath(row: 0, section: 0))
        let row2Movable = liaison.tableView(tableView, canMoveRowAt: IndexPath(row: 1, section: 0))
        let nonExistentRowMovable = liaison.tableView(tableView, canMoveRowAt: IndexPath(row: 2, section: 0))
        
        XCTAssertEqual(row1Movable, true)
        XCTAssertEqual(row2Movable, false)
        XCTAssertEqual(nonExistentRowMovable, false)
    }

    func test_tableViewCommitEditingStyle_performsEditingActionRowForIndexPath() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow(editingStyle: .delete)
        let row2 = TestTableViewRow(editingStyle: .insert)
        var deleted = false
        var inserted = false

        row1.set(command: .delete) { (_, _, _) in
            deleted = true
        }
        
        row2.set(command: .insert) { (_, _, _) in
            inserted = true
        }
        
        liaison.append(section: section)
        liaison.append(rows: [row1, row2])
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.tableView(tableView, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
            liaison.tableView(tableView, commit: .insert, forRowAt: IndexPath(row: 0, section: 0))
        }
        
        XCTAssertEqual(deleted, true)
        XCTAssertEqual(inserted, true)
        XCTAssertEqual(section.rows.count, 1)
    }
    
    func test_moveRowAt_properlyMovesRowFromOneSourceIndexPathToDestinationIndexPath() {
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()
        
        var moved = false
        let row1 = TestTableViewRow()
        row1.set(command: .move) { (_, _, _) in
            moved = true
        }
        
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow()
        
        liaison.append(sections: [section1, section2])
        liaison.append(rows: [row1, row2, row3])
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.tableView(tableView, moveRowAt: IndexPath(row: 0, section: 0), to: IndexPath(row: 0, section: 1))
        }
        
        XCTAssertEqual(moved, true)
        XCTAssertEqual(section1.rows.count, 2)
        XCTAssert(section2.rows.first === row1)

    }
    
    func test_willSelectRow_performsWillSelectCommand() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        var willSelect = false
        
        row.set(command: .willSelect) { (_, _, _) in
            willSelect = true
        }
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        tableView.stubCell = UITableViewCell()
        let expectedIndexPath = IndexPath(row: 0, section: 0)
        var indexPath: IndexPath?
        tableView.performInSwizzledEnvironment {
           indexPath = liaison.tableView(tableView, willSelectRowAt: expectedIndexPath)
        }
        
        XCTAssertEqual(willSelect, true)
        XCTAssertEqual(indexPath, expectedIndexPath)
    }
    
    func test_didSelectRow_performsDidSelectCommand() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        var didSelected = false
        
        row.set(command: .didSelect) { (_, _, _) in
            didSelected = true
        }
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.tableView(tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        }
        
        XCTAssertEqual(didSelected, true)
    }
    
    func test_willDeselectRow_performsWillDeselectCommand() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        var willDeselect = false
        
        row.set(command: .willDeselect) { (_, _, _) in
            willDeselect = true
        }
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        tableView.stubCell = UITableViewCell()
        let expectedIndexPath = IndexPath(row: 0, section: 0)
        var indexPath: IndexPath?
        tableView.performInSwizzledEnvironment {
            indexPath = liaison.tableView(tableView, willDeselectRowAt: expectedIndexPath)
        }
        
        XCTAssertEqual(willDeselect, true)
        XCTAssertEqual(indexPath, expectedIndexPath)
    }
    
    func test_didDeselectRow_performsDidDeselectCommand() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        var didDeselect = false
        
        row.set(command: .didDeselect) { (_, _, _) in
            didDeselect = true
        }
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.tableView(tableView, didDeselectRowAt: IndexPath(row: 0, section: 0))
        }
        
        XCTAssertEqual(didDeselect, true)
    }
    
    func test_targetIndexPathForMoveFromRowToProposed_correctlyMovesRow() {
        let section1 = TestTableViewSection()
        let section2 = TestTableViewSection()
        
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow()
        let row4 = TestTableViewRow()
        let row5 = TestTableViewRow()
        
        liaison.append(section: section1)
        liaison.append(section: section2)
        
        liaison.append(rows: [row1, row2, row3])
        liaison.append(rows: [row4, row5], to: 1)
        
        let destination = liaison.tableView(tableView,
                                            targetIndexPathForMoveFromRowAt: IndexPath(row: 0, section: 0),
                                            toProposedIndexPath: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(section1.rows.count, 2)
        XCTAssertEqual(section2.rows.count, 3)
        XCTAssert(section1.rows.first === row2)
        XCTAssert(section2.rows.first === row1)
        XCTAssertEqual(destination, IndexPath(row: 0, section: 1))
    }
    
    func test_willDisplayCell_performsWillDisplayCommand() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        var willDisplay = false
        
        row.set(command: .willDisplay) { (_, _, _) in
            willDisplay = true
        }
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        let cell = UITableViewCell()
        liaison.tableView(tableView, willDisplay: cell, forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(willDisplay, true)
    } 
    
    func test_willDisplayCell_paginationDelegateGetsCalled() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        let delegate = TestTableViewLiaisonPaginationDelegate()
        
        liaison.paginationDelegate = delegate
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        liaison.tableView(tableView, willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 0, section: 0))
        
        keyValueObservingExpectation(for: delegate, keyPath: "paginationStartedCallCount") { (delegate, json) -> Bool in
            guard let delegate = delegate as? TestTableViewLiaisonPaginationDelegate else {
                return false
            }
            
            return delegate.paginationStartedCallCount == 1 && delegate.isPaginationEnabledCallCount == 1
        }
        
        waitForExpectations(timeout: 0.2, handler: nil)
    }
    
    func test_appendSection_paginationDelegateEndsByAppendingSection() {
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        let section1 = TestTableViewSection(rows: [row1, row2])
        let delegate = TestTableViewLiaisonPaginationDelegate()
        let row3 = TestTableViewRow()
        let section2 = TestTableViewSection(rows: [row3])

        liaison.paginationDelegate = delegate
        liaison.append(section: section1)
        liaison.tableView(tableView, willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 1, section: 0))

        DispatchQueue.main.async {
            self.liaison.append(section: section2)
        }

        keyValueObservingExpectation(for: delegate, keyPath: "paginationEndedCallCount") { (delegate, json) -> Bool in
            guard let delegate = delegate as? TestTableViewLiaisonPaginationDelegate else {
                return false
            }
            
            return delegate.paginationEndedCallCount == 1
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func test_appendRow_paginationDelegateEndsByAppendingRow() {
        let row1 = TestTableViewRow()
        let section = TestTableViewSection(rows: [row1])
        let delegate = TestTableViewLiaisonPaginationDelegate()
        let row2 = TestTableViewRow()

        liaison.paginationDelegate = delegate
        liaison.append(section: section)

        liaison.tableView(tableView, willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 0, section: 0))

        DispatchQueue.main.async {
            self.liaison.append(row: row2)
        }
        
        keyValueObservingExpectation(for: delegate, keyPath: "paginationEndedCallCount") { (delegate, json) -> Bool in
            guard let delegate = delegate as? TestTableViewLiaisonPaginationDelegate else {
                return false
            }
            
            return delegate.paginationEndedCallCount == 1
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func test_didEndDisplayingCell_performsDidEndDisplayingCommand() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        var didEndDisplaying = false
        
        row.set(command: .didEndDisplaying) { (_, _, _) in
            didEndDisplaying = true
        }
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        let cell = UITableViewCell()
        liaison.tableView(tableView, didEndDisplaying: cell, forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(didEndDisplaying, true)
    }
    
    func test_willBeginEditingRow_performsWillBeginEditingCommand() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        var willBeginEditing = false
        
        row.set(command: .willBeginEditing) { (_, _, _) in
            willBeginEditing = true
        }
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.tableView(tableView, willBeginEditingRowAt: IndexPath(row: 0, section: 0))
        }
        
        XCTAssertEqual(willBeginEditing, true)
    }
    
    func test_didEndEditingRow_performsDidEndEditingCommand() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        var didEndEditing = false
        
        row.set(command: .didEndEditing) { (_, _, _) in
            didEndEditing = true
        }
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.tableView(tableView, didEndEditingRowAt: IndexPath(row: 0, section: 0))
        }
        
        XCTAssertEqual(didEndEditing, true)
    }
    
    func test_didHighlightRow_performsDidHighlightRowCommand() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        var didHighlight = false
        
        row.set(command: .didHighlight) { (_, _, _) in
            didHighlight = true
        }
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.tableView(tableView, didHighlightRowAt: IndexPath(row: 0, section: 0))
        }
        
        XCTAssertEqual(didHighlight, true)
    }
    
    func test_didUnhighlightRow_performsDidUnhighlightRowCommand() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        var didUnhighlight = false
        
        row.set(command: .didUnhighlight) { (_, _, _) in
            didUnhighlight = true
        }
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.tableView(tableView, didUnhighlightRowAt: IndexPath(row: 0, section: 0))
        }
        
        XCTAssertEqual(didUnhighlight, true)
    }
    
    func test_viewForHeaderInSection_returnCorrectHeaderForSection() {
        let section1 = TestTableViewSection.create()
        let section2 = TestTableViewSection.create()
        
        section1.setHeader(command: .configuration) { (header, string, section) in
            header.accessibilityIdentifier = "\(section)"
        }
        
        section2.setHeader(command: .configuration) { (header, string, section) in
            header.accessibilityIdentifier = "\(section)"
        }
        
        liaison.append(section: section1)
        liaison.append(section: section2)
        
        let section1Header = liaison.tableView(tableView, viewForHeaderInSection: 0)
        let section2Header = liaison.tableView(tableView, viewForHeaderInSection: 1)
        
        XCTAssertEqual(section1Header?.accessibilityIdentifier, "0")
        XCTAssertEqual(section2Header?.accessibilityIdentifier, "1")
    }
    
    func test_viewForFooterInSection_returnCorrectFooterForSection() {
        let section1 = TestTableViewSection.create()
        let section2 = TestTableViewSection.create()
        
        section1.setFooter(command: .configuration) { (footer, string, section) in
            footer.accessibilityIdentifier = "\(section)"
        }
        
        section2.setFooter(command: .configuration) { (footer, string, section) in
            footer.accessibilityIdentifier = "\(section)"
        }
        
        liaison.append(section: section1)
        liaison.append(section: section2)
        
        let section1Header = liaison.tableView(tableView, viewForFooterInSection: 0)
        let section2Header = liaison.tableView(tableView, viewForFooterInSection: 1)
        
        XCTAssertEqual(section1Header?.accessibilityIdentifier, "0")
        XCTAssertEqual(section2Header?.accessibilityIdentifier, "1")
    }
    
    func test_heightForRow_properlySetsHeightsForRows() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow()

        row1.set(height: .height) { (_) -> CGFloat in
            return 100
        }
        
        row2.set(height: .height, value: 200)
        liaison.append(section: section)
        liaison.append(rows: [row1, row2, row3])
        
        let row1Height = liaison.tableView(tableView, heightForRowAt: IndexPath(row: 0, section: 0))
        let row2Height = liaison.tableView(tableView, heightForRowAt: IndexPath(row: 1, section: 0))
        let row3Height = liaison.tableView(tableView, heightForRowAt: IndexPath(row: 2, section: 0))
        
        XCTAssertEqual(row1Height, 100)
        XCTAssertEqual(row2Height, 200)
        XCTAssertEqual(row3Height, UITableViewAutomaticDimension)
    }
    
    func test_estimatedHeightForRow_properlySetsEstimatedHeightsForRows() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow()
        let row2 = TestTableViewRow()
        let row3 = TestTableViewRow()
        
        row1.set(height: .estimatedHeight) { (_) -> CGFloat in
            return 100
        }
        
        row2.set(height: .estimatedHeight, value: 200)
        liaison.append(section: section)
        liaison.append(rows: [row1, row2, row3])
        
        let row1Height = liaison.tableView(tableView, estimatedHeightForRowAt: IndexPath(row: 0, section: 0))
        let row2Height = liaison.tableView(tableView, estimatedHeightForRowAt: IndexPath(row: 1, section: 0))
        let row3Height = liaison.tableView(tableView, estimatedHeightForRowAt: IndexPath(row: 2, section: 0))
        
        XCTAssertEqual(row1Height, 100)
        XCTAssertEqual(row2Height, 200)
        XCTAssertEqual(row3Height, UITableViewAutomaticDimension)
    }
    
    func test_shouldIndentWhileEditingRow_correctlyReturnsIfRowShouldIndentWhileBeingEdited() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow(indentWhileEditing: true)
        let row2 = TestTableViewRow()
        
        liaison.append(section: section)
        liaison.append(rows: [row1, row2])
        
        let row1ShouldIndent = liaison.tableView(tableView, shouldIndentWhileEditingRowAt: IndexPath(row: 0, section: 0))
        let row2ShouldIndent = liaison.tableView(tableView, shouldIndentWhileEditingRowAt: IndexPath(row: 1, section: 0))
        let nonExistentRowShouldIndent = liaison.tableView(tableView, shouldIndentWhileEditingRowAt: IndexPath(row: 2, section: 0))
        
        XCTAssertEqual(row1ShouldIndent, true)
        XCTAssertEqual(row2ShouldIndent, false)
        XCTAssertEqual(nonExistentRowShouldIndent, false)
    }
    
    func test_editingStyleForRow_correctlyReturnsEditingStyleForRow() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow(editingStyle: .delete)
        let row2 = TestTableViewRow(editingStyle: .insert)
        let row3 = TestTableViewRow()

        liaison.append(section: section)
        liaison.append(rows: [row1, row2, row3])
        
        let row1EditingStyle = liaison.tableView(tableView, editingStyleForRowAt: IndexPath(row: 0, section: 0))
        let row2EditingStyle = liaison.tableView(tableView, editingStyleForRowAt: IndexPath(row: 1, section: 0))
        let row3EditingStyle = liaison.tableView(tableView, editingStyleForRowAt: IndexPath(row: 2, section: 0))
        let nonExistentRowEditingStyle = liaison.tableView(tableView, editingStyleForRowAt: IndexPath(row: 3, section: 0))
        
        XCTAssertEqual(row1EditingStyle, .delete)
        XCTAssertEqual(row2EditingStyle, .insert)
        XCTAssertEqual(row3EditingStyle, .none)
        XCTAssertEqual(nonExistentRowEditingStyle, .none)
    }
    
    func test_editActionsForRow_correctlyReturnsEditActions() {
        let section = TestTableViewSection()
        let editAction = UITableViewRowAction(style: .normal, title: "Action", handler: { (action, indexPath) in
            print("This action is being invoked")
        })
        
        let row1 = TestTableViewRow(editActions: [editAction])
        let row2 = TestTableViewRow()
        
        liaison.append(section: section)
        liaison.append(rows: [row1, row2])
        
        let row1EditActions = liaison.tableView(tableView, editActionsForRowAt: IndexPath(row: 0, section: 0))
        let row2EditActions = liaison.tableView(tableView, editActionsForRowAt: IndexPath(row: 1, section: 0))
        let nonExistentRowEditActions = liaison.tableView(tableView, editActionsForRowAt: IndexPath(row: 2, section: 0))
        XCTAssertEqual(row1EditActions?.first, editAction)
        XCTAssert(row2EditActions == nil)
        XCTAssert(nonExistentRowEditActions == nil)
    }
    
    func test_accessoryButtonTapped_performsAccessoryButtonTappedCommand() {
        let section = TestTableViewSection()
        let row = TestTableViewRow()
        var accessoryButtonTapped = false
        
        row.set(command: .accessoryButtonTapped) { (_, _, _) in
            accessoryButtonTapped = true
        }
        
        liaison.append(section: section)
        liaison.append(row: row)
        
        tableView.stubCell = UITableViewCell()
        tableView.performInSwizzledEnvironment {
            liaison.tableView(tableView, accessoryButtonTappedForRowWith: IndexPath(row: 0, section: 0))
        }
        
        XCTAssertEqual(accessoryButtonTapped, true)
    }
    
    func test_titleForDeleteConfirmationButton_returnsCorrectDeleteConfirmationTitleForRow() {
        let section = TestTableViewSection()
        let row1 = TestTableViewRow(deleteConfirmationTitle: "Delete")
        let row2 = TestTableViewRow()
        
        liaison.append(section: section)
        liaison.append(rows: [row1, row2])
        
        let row1DeleteConfirmationTitle = liaison.tableView(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
        let row2DeleteConfirmationTitle = liaison.tableView(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 1, section: 0))
        let nonExistentRowDeleteConfirmationTitle = liaison.tableView(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 2, section: 0))
        
        XCTAssertEqual(row1DeleteConfirmationTitle, "Delete")
        XCTAssert(row2DeleteConfirmationTitle == nil)
        XCTAssert(nonExistentRowDeleteConfirmationTitle == nil)
    }
    
    func test_heightForHeader_properlySetsHeightsForSectionHeaders() {
        let section1 = TestTableViewSection.create()
        let section2 = TestTableViewSection.create()
        let section3 = TestTableViewSection.create()
    
        section1.setHeight(for: .header) { _ -> CGFloat in
            return 100
        }
        
        section2.setHeight(for: .header, value: 200)
        
        liaison.append(section: section1)
        liaison.append(section: section2)
        liaison.append(section: section3)
        
        let section1Height = liaison.tableView(tableView, heightForHeaderInSection: 0)
        let section2Height = liaison.tableView(tableView, heightForHeaderInSection: 1)
        let section3Height = liaison.tableView(tableView, heightForHeaderInSection: 2)
        
        XCTAssertEqual(section1Height, 100)
        XCTAssertEqual(section2Height, 200)
        XCTAssertEqual(section3Height, UITableViewAutomaticDimension)
    }
    
    func test_heightForFooter_properlySetsHeightsForSectionFooters() {
        let section1 = TestTableViewSection.create()
        let section2 = TestTableViewSection.create()
        let section3 = TestTableViewSection.create()
        
        section1.setHeight(for: .footer) { _ -> CGFloat in
            return 100
        }
        
        section2.setHeight(for: .footer, value: 200)
        
        liaison.append(section: section1)
        liaison.append(section: section2)
        liaison.append(section: section3)
        
        let section1Height = liaison.tableView(tableView, heightForFooterInSection: 0)
        let section2Height = liaison.tableView(tableView, heightForFooterInSection: 1)
        let section3Height = liaison.tableView(tableView, heightForFooterInSection: 2)
        
        XCTAssertEqual(section1Height, 100)
        XCTAssertEqual(section2Height, 200)
        XCTAssertEqual(section3Height, UITableViewAutomaticDimension)
    }
    
    func test_willDisplayHeaderView_performsWillDisplayHeaderViewSectionCommand() {
        let section = TestTableViewSection()
        var willDisplay = false
        
        section.setHeader(command: .willDisplay) { (_, _, _) in
            willDisplay = true
        }
        
        liaison.append(section: section)
        let view = UITableViewHeaderFooterView()
        liaison.tableView(tableView, willDisplayHeaderView: view, forSection: 0)
        
        XCTAssertEqual(willDisplay, true)
    }
    
    func test_willDisplayFooterView_performsWillDisplayFooterViewSectionCommand() {
        let section = TestTableViewSection()
        var willDisplay = false
        
        section.setFooter(command: .willDisplay) { (_, _, _) in
            willDisplay = true
        }
        
        liaison.append(section: section)
        let view = UITableViewHeaderFooterView()
        liaison.tableView(tableView, willDisplayFooterView: view, forSection: 0)
        
        XCTAssertEqual(willDisplay, true)
    }
    
    func test_didEndDisplayingHeaderView_performsDidEndDisplayingHeaderViewSectionCommand() {
        let section = TestTableViewSection()
        var didEndDisplaying = false
        
        section.setHeader(command: .didEndDisplaying) { (_, _, _) in
            didEndDisplaying = true
        }
        
        liaison.append(section: section)
        let view = UITableViewHeaderFooterView()
        liaison.tableView(tableView, didEndDisplayingHeaderView: view, forSection: 0)
        
        XCTAssertEqual(didEndDisplaying, true)
    }
    
    func test_didEndDisplayingFooterView_performsDidEndDisplayingFooterViewSectionCommand() {
        let section = TestTableViewSection()
        var didEndDisplaying = false
        
        section.setFooter(command: .didEndDisplaying) { (_, _, _) in
            didEndDisplaying = true
        }
        
        liaison.append(section: section)
        let view = UITableViewHeaderFooterView()
        liaison.tableView(tableView, didEndDisplayingFooterView: view, forSection: 0)
        
        XCTAssertEqual(didEndDisplaying, true)
    }
    
}
