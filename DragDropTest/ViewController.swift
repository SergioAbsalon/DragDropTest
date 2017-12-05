//
//  ViewController.swift
//  DragDropTest
//
//  Created by Sergio Absalon Sanchez Flores on 12/5/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var table2: NSTableView!
    @IBOutlet weak var table1: NSTableView!
    var arrayTable1 = ["Uno", "Dos", "Tres", "Cuatro", "Cinco", "Seis"]
    var arrayTable2 = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        table1.setDraggingSourceOperationMask(.link, forLocal: false)
        table1.setDraggingSourceOperationMask(.move, forLocal: true)
        table1.registerForDraggedTypes([NSPasteboard.PasteboardType.string])
        
        table2.setDraggingSourceOperationMask(.link, forLocal: false)
        table2.setDraggingSourceOperationMask(.move, forLocal: true)
        table2.registerForDraggedTypes([NSPasteboard.PasteboardType.string])
        table1.dataSource = self
        table2.dataSource = self
        
        table1.reloadData()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == table1 {
            return arrayTable1.count
        }
        else {
            return arrayTable2.count
        }
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if tableView == table1 {
            return arrayTable1[row] as String
        }
        else {
            return arrayTable2[row] as String
        }
    }
    
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        if tableView == table1 || tableView == table2 {
            let data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
            pboard.declareTypes([NSPasteboard.PasteboardType.string], owner: self)
            pboard.setData(data, forType: NSPasteboard.PasteboardType.string)
            return true
        }
        return false
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        return NSDragOperation.every
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        let data = info.draggingPasteboard().data(forType: NSPasteboard.PasteboardType.string)
        let rowIndexes = NSKeyedUnarchiver .unarchiveObject(with: data!) as! IndexSet
        
        //REORDERING IN THE SAME TABLE VIEW BY DRAG & DROP
        if (info.draggingSource() as! NSTableView) == table2 && tableView == table2 {
            let tArr = (arrayTable2 as! NSMutableArray).objects(at: rowIndexes)
            (arrayTable2 as! NSMutableArray).removeObjects(at: rowIndexes)
            
            if row > arrayTable2.count {
                arrayTable2.insert(tArr[0] as! String, at: row-1)
            }
            else {
                arrayTable2.insert(tArr[0] as! String, at: row)
            }
            table2.reloadData()
            table2.deselectAll(nil)
        }
        
        //DRAG AND DROP ACROSS THE TABLES
        else if (info.draggingSource() as! NSTableView) == table1 && tableView == table2 {
            let tArr = (arrayTable1 as! NSMutableArray).objects(at: rowIndexes)
            (arrayTable1 as! NSMutableArray).removeObjects(at: rowIndexes)
            arrayTable2.append(tArr[0] as! String)
            table1.reloadData()
            table1.deselectAll(nil)
            table2.reloadData()
        }
        
        return true
    }
    
}

