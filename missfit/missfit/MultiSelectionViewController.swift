//
//  MultiSelectionViewController.swift
//  missfit
//
//  Created by Hank Liang on 8/1/15.
//  Copyright (c) 2015 Hank Liang. All rights reserved.
//

import UIKit

class MultiSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var components: [String]?
    var selectedIndice = [Int]()
    var onComponentsSelected: ((results: String) -> ())?
    var onlySupportSingleSelection: Bool = false
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        if onComponentsSelected != nil {
            let returnedString = selectedComponentsString()
            onComponentsSelected!(results: returnedString)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func selectedComponentsString() -> String {
        println("selectedIndice: \(selectedIndice)")
        var componentsString = ""
        for(var i = 0; i < selectedIndice.count; i++) {
            componentsString += components![selectedIndice[i]] + "、"
        }
        
        if count(componentsString) > 0 {
           componentsString = componentsString.substringToIndex(advance(componentsString.startIndex, count(componentsString) - 1))
        }
        
        println("componentsString: \(componentsString)")
        return componentsString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if components == nil {
            return 0
        } else {
            return components!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MultiSelectionTableViewCell", forIndexPath: indexPath) as! MultiSelectionTableViewCell
        cell.name.text = components![indexPath.row]
        if contains(selectedIndice, indexPath.row) {
            cell.isCheckboxOn = true
            cell.checkbox.image = UIImage(named: "payment-selected")
        } else {
            cell.isCheckboxOn = false
            cell.checkbox.image = UIImage(named: "payment-unselected")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MultiSelectionTableViewCell
        if cell.isCheckboxOn {
            cell.isCheckboxOn = false
            cell.checkbox.image = UIImage(named: "payment-unselected")
            for(var i = 0; i < selectedIndice.count; i++) {
                if selectedIndice[i] == indexPath.row {
                    selectedIndice.removeAtIndex(i)
                    return
                }
            }
        } else {
            cell.isCheckboxOn = true
            cell.checkbox.image = UIImage(named: "payment-selected")
            if onlySupportSingleSelection {
                selectedIndice.removeAll(keepCapacity: false)
                selectedIndice.append(indexPath.row)
                self.tableView.reloadData()
                backButtonClicked(self)
            } else {
                selectedIndice.append(indexPath.row)
            }
        }
    }

}
