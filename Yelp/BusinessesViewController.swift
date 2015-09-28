//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CCInfiniteScrolling

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, UIScrollViewDelegate{

    var businesses: [Business]!
    var filteredBusinesses: [Business]?
    var categories: [String]?
    var searchBy: Int?
    var dealsStatus: Bool?
    var radius: Int?
    var radiusInMiles: Float?
    var yelpSortMode = YelpSortMode.BestMatched
    var offset = 0
    var limit = 20
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.addBottomInfiniteScrollingWithActionHandler({
            if self.businesses.count != 40 || (self.yelpSortMode.rawValue == 0) {
                self.loadMoreResults()
            } else {
                self.tableView.infiniteScrollingDisabled = true
            }
        })
        // necessary so scroll will be estimated
        tableView.estimatedRowHeight = 120
        
        Business.searchWithTerm("Restaurants", sort: .Distance, radius: Int(), categories: [], deals: false, offset: Int(), limit: self.limit) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTap(sender: AnyObject) {
        self.searchBar.endEditing(true)
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredBusinesses = businesses.filter({
                let currentBusiness = $0
                if let currentBusinessName = currentBusiness.name {
                    return (currentBusinessName.rangeOfString(searchText) != nil)
                } else {
                    return false
                }
            })
            if filteredBusinesses!.count == 0{
                searchActive = false;
            }
        } else {
            searchActive = false;
            filteredBusinesses = []
        }
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        if (searchActive) {
            cell.business = filteredBusinesses![indexPath.row]
        } else {
            cell.business = businesses[indexPath.row]
        }     
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredBusinesses!.count
        } else {
            if businesses != nil {
                return businesses!.count
            } else {
                return 0
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        categories = filters["categories"] as? [String]
        searchBy = filters["searchBy"] as? Int
        dealsStatus = filters["dealsStatus"] as? Bool
        let radiusInMiles = filters["radius"] as? Float
        
        if let yelpSortModeRawValue = searchBy {
            yelpSortMode = YelpSortMode(rawValue: yelpSortModeRawValue)!
        }
        if let radiusInMiles = radiusInMiles {
            radius = Int(radiusInMiles * 1609.344)
        } else {
            radius = nil
        }

        Business.searchWithTerm("Restaurant", sort: yelpSortMode, radius: radius, categories: categories, deals: dealsStatus, offset: offset, limit: limit)
            {(businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
        }
    }
    
    func loadMoreResults(){
        self.offset += 20
        Business.searchWithTerm("Restaurant", sort: yelpSortMode, radius: radius, categories: categories, deals: dealsStatus, offset: self.offset, limit: self.limit)
            {(businesses: [Business]!, error: NSError!) -> Void in
                let allBusinesses = self.businesses + businesses
                self.businesses = allBusinesses
                self.tableView.reloadData()
            }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
