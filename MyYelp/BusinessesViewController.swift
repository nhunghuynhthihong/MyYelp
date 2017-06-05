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
    var myTimer = Timer()
    var searchString = ""
    var filters = Filters()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

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
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        guard let client = YelpClient.sharedInstance else { return}
        client.searchWithTerm(searchString, sort: filters.sortBy, categories: filters.categories, deals: filters.hasDeal, completion: { (business, error) in
            self.businessArr = business
            self.tableView.reloadData()
        })

        refreshControl.endRefreshing()
    }
    // Perform the search.
    fileprivate func doSearch() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        // Perform request to Yelp API to get the list of repositories
        guard let client = YelpClient.sharedInstance else { return}
        client.searchWithTerm(searchString, sort: filters.sortBy, categories: filters.categories, deals: filters.hasDeal, completion: { (business, error) in
            self.businessArr = business
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//      MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let filtersVC = navController.topViewController as! FiltersViewController
        filtersVC.delegate = self
        filtersVC.filterObject = filters
        
    }
}
extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _businessArr = businessArr else {return 0 }
        return _businessArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BusinessesTableViewCell
        guard let _businessArr = businessArr else { return cell }
        cell.business = _businessArr[indexPath.row]
        return cell
    }
}
extension BusinessesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchString = ""
        searchBar.resignFirstResponder()
        doSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchString = searchBar.text!
        searchBar.resignFirstResponder()
        doSearch()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        myTimer.invalidate()
        searchString = searchText
        myTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(BusinessesViewController.searchInTime), userInfo: nil, repeats: false)
    }
    func searchInTime(){
        doSearch()
    }

}

extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewControllerDelegate(_ filtersViewController: FiltersViewController, didSet filters: Filters) {
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
