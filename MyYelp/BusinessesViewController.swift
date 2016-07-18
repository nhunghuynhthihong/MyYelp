//
//  BusinessesViewController.swift
//  MyYelp
//
//  Created by Nhung Huynh on 7/15/16.
//  Copyright © 2016 Nhung Huynh. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var businessArr: [Business]? = nil
    
    var searchBar: UISearchBar!
    var myTimer = NSTimer()
    var searchString = ""
    var filters = Filters()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        doSearch()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        guard let client = YelpClient.sharedInstance else { return}
        client.searchWithTerm(searchString, sort: filters.sortBy, categories: filters.categories, deals: filters.hasDeal, completion: { (business, error) in
            self.businessArr = business
            self.tableView.reloadData()
        })

        refreshControl.endRefreshing()
    }
    // Perform the search.
    private func doSearch() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        // Perform request to Yelp API to get the list of repositories
        guard let client = YelpClient.sharedInstance else { return}
        client.searchWithTerm(searchString, sort: filters.sortBy, categories: filters.categories, deals: filters.hasDeal, completion: { (business, error) in
            self.businessArr = business
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//      MARK: - Navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navController = segue.destinationViewController as! UINavigationController
        let filtersVC = navController.topViewController as! FiltersViewController
        filtersVC.delegate = self
        filtersVC.filterObject = filters
        
    }
}
extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _businessArr = businessArr else {return 0 }
        return _businessArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! BusinessesTableViewCell
        guard let _businessArr = businessArr else { return cell }
        cell.business = _businessArr[indexPath.row]
        return cell
    }
}
extension BusinessesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchString = ""
        searchBar.resignFirstResponder()
        doSearch()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchString = searchBar.text!
        searchBar.resignFirstResponder()
        doSearch()
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        myTimer.invalidate()
        searchString = searchText
        myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(BusinessesViewController.searchInTime), userInfo: nil, repeats: false)
    }
    func searchInTime(){
        doSearch()
    }

}

extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewControllerDelegate(filtersViewController: FiltersViewController, didSet filters: Filters) {
        self.filters = filters
        doSearch()
    }
}
// Model class that represents the user's search settings
@objc class YelpSearchInfo: NSObject {
    var searchString: String?
    override init() {
        searchString = ""
    }
    
}
