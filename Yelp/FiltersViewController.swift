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
        for (index, options) in switchStates.enumerate(){
            for (row, isSelected) in options {
                switch index {
                case 0:
                    var selectedCategories = [String]()
                    if isSelected {
                        selectedCategories.append(categories[row]["code"]!)
                    }
                    if selectedCategories.count > 0 {
                        filters["categories"] = selectedCategories
                    }
                case 1:
                    if isSelected {
                        filters["searchBy"] = row
                    }
                case 2:
                    if isSelected {
                        filters["radius"] = distanceOptions[row]
                    }
                case 3:
                    if isSelected {
                        filters["dealsStatus"] = true
                    }
                default:
                    print("onSearchButton switch case failure")
                }
            }
        }
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }

    var data: [NSArray]?
    var categories: [[String:String]]!
    var sortByOptions: [String]!
    var dealsOptions: [String]!
    var switchStates = [[Int: Bool](), [Int: Bool](), [Int: Bool](), [Int: Bool]()]
    var distanceOptions = [Float]()
    let HeaderViewIdentifier = "TableViewIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //normally in initializer
        categories = yelpCategories()
        sortByOptions = yelpSortByOptions()
        distanceOptions = yelpDistanceOptions()
        dealsOptions = ["Deals"]
        data = [categories, sortByOptions, distanceOptions, dealsOptions]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //since we manually set categories below, we know it will always have a value
        return data![section].count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        switch indexPath.section {
        case 0:
            cell.switchLabel.text = categories[indexPath.row]["name"]
        case 1:
            cell.switchLabel.text = sortByOptions[indexPath.row]
        case 2:
            cell.switchLabel.text = String(distanceOptions[indexPath.row]) + " Miles"
        case 3:
            cell.switchLabel.text = String(dealsOptions[indexPath.row])
        default:
            cell.switchLabel.text = "No Switch Case"
        }
        cell.delegate = self
        cell.onSwitch.on = switchStates[indexPath.section][indexPath.row] ?? false
        return cell
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderTableViewCell") as! HeaderTableViewCell
        switch section {
        case 0:
            headerCell.headerLabel.text = "Category"
        case 1:
            headerCell.headerLabel.text = "Sort By"
        case 2:
            headerCell.headerLabel.text = "Radius"
        case 3:
            headerCell.headerLabel.text = "Offering a Deal"
        default:
            headerCell.headerLabel.text = "Other"
        }
        return headerCell
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        switch indexPath.section {
        case 0:
            switchStates[0][indexPath.row] = value
        case 1:
            switchStates[1][indexPath.row] = value
        case 2:
            switchStates[2][indexPath.row] = value
        case 3:
            switchStates[3][indexPath.row] = value
        default:
            puts("switch cell function no indexPath.section")
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func yelpDistanceOptions() -> [Float] {
        return [0.3, 1, 5, 20]
    }
    
    func yelpSortByOptions() -> [String] {
        return ["Best Match", "Distance", "Highest Rated"]
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
