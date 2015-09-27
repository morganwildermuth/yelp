//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Morgan Wildermuth on 9/26/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

// protocol named as Classname + Delegate
@objc protocol FiltersViewControllerDelegate {
    // thing that fires event as function name with first parameter the thing firing event and the second parameter as some kind of action that just occured (didWhatever)
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: FiltersViewControllerDelegate?
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String : AnyObject]()
        for (row, isSelected) in switchStates {
            var selectedCategories = [String]()
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
            if selectedCategories.count > 0 {
                filters["categories"] = selectedCategories
            }
        }
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }

    var categories: [[String:String]]!
    var switchStates = [Int: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        //normally in initializer
        categories = yelpCategories()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //since we manually set categories below, we know it will always have a value
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        cell.switchLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        
        
//        if switchStates[indexPath.row] != nil {
//            cell.onSwitch.on = switchStates[indexPath.row]!
//        } else {
//            cell.onSwitch.on = false
//        }
        
        // short hand ternary operator, same as above
        cell.onSwitch.on = switchStates[indexPath.row] ?? false
        return cell
        
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        switchStates[indexPath.row] = value
    }
    
    func yelpCategories() -> [[String:String]] {
        return [["name" : "Afghan", "code" : "afghani"],
            ["name" : "African", "code": "african"],
            ["name" : "American, New", "code" : "newamerican"],
            ["name" : "American Traditional", "code" : "tradamerican"],
            ["name" : "Arabian", "code" : "arabian"],
            ["name" : "Argentine", "code" : "argentine"],
            ["name" : "Armenian", "code" : "armenian"],
            ["name" : "Asian Fusion", "code" : "asianfusion"],
            ["name" : "Asturian", "code" : "asturian"]
        ]
    }
}
