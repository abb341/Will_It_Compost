//
//  SearchViewController.swift
//  Makestagram
//
//  Created by Aaron Brown on 7/1/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit

class SearchViewController: UIViewController, TimelineComponentTarget{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // stores all the items that match the current search query
    var searchedItems: [Item]? = []
   
    /* // Local Cache of Items
    var items: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    } */
    
    // the current parse query
    var query: PFQuery? {
        didSet {
            // whenever we assign a new query, cancel any previous requests
            oldValue?.cancel()
        }
    }
    
    var selectedItem: Item?
    var timelineComponent: TimelineComponent<Item, SearchViewController>!
    
    let defaultRange = 0...5
    let additionalRangeSize = 6
    
    // In Default Mode all Notes are displayed, in search mode only a filtered subset
    enum State {
        case DefaultMode
        case SearchMode
    }
    
    var state: State = .DefaultMode {
        didSet {
            // update notes and search bar whenever State changes
            switch (state) {
            case .DefaultMode:
                searchBar.text = ""
                searchBar.showsCancelButton = false
                query = ParseHelper.allItems(updateList)
            case .SearchMode:
                let searchText = searchBar?.text ?? ""
                searchBar.showsCancelButton = true
                query = searchItems(searchText, completionBlock: updateList)
            }
        }
    }
    
    // MARK: Update userlist
    
    /**
    Is called as the completion block of all queries.
    As soon as a query completes, this method updates the Table View.
    */
    func updateList(results: [AnyObject]?, error: NSError?) {
        self.searchedItems = results as? [Item] ?? []
        self.tableView.reloadData()
        
        if let error = error {
            ErrorHandling.defaultErrorHandler(error)
        }
    }
    
    // MARK: View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        state = .DefaultMode
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        timelineComponent = TimelineComponent(target: self)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        timelineComponent.loadInitialIfRequired()    }
    
    func loadInRange(range: Range<Int>, completionBlock: ([Item]?) -> Void) {
        // 1
        ParseHelper.searchRequestforCurrentUser(range) {
            (result: [AnyObject]?, error: NSError?) -> Void in
            // 2
            let items = result as? [Item] ?? []
            // 3
            completionBlock(items)
        }
    }
    
    func searchItems(searchText: String, completionBlock: PFArrayResultBlock) -> PFQuery {
        let query = PFQuery(className: "Item")
        query.whereKey("productName", matchesRegex: searchText, modifiers: "i")
        println(searchText)
        
        query.orderByAscending("productName")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        return query
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowItem" {
            var destViewController: ItemDisplayViewController = segue.destinationViewController as! ItemDisplayViewController
            destViewController.labelText = selectedItem!.productName
            //destViewController.descText = selectedItem!.Description
            
        }
    }
    

}

// MARK: Extensions

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if state == .SearchMode {
            return self.searchedItems?.count ?? 0
        }
        else {
            return timelineComponent.content.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemTableViewCell
        
        if state == .SearchMode {
            let item = searchedItems![indexPath.row]
            item.downloadImage()
            cell.itemLabel!.text = item.productName
            cell.isCompostableLabel.text = item.isCompostable
            cell.item = item
        }
        else {
            let item = timelineComponent.content[indexPath.row]
            item.downloadImage()
            cell.itemLabel!.text = item.productName
            cell.isCompostableLabel.text = item.isCompostable
            cell.item = item
        }
        
        return cell
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if state == .SearchMode {
            selectedItem = searchedItems![indexPath.row]
        }
        else {
            selectedItem = timelineComponent.content[indexPath.row]
        }
        self.performSegueWithIdentifier("ShowItem", sender: self)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        timelineComponent.targetWillDisplayEntry(indexPath.row)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        state = .DefaultMode
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // try to find a better way to remove the keyboard but keep the cancel bar
        searchBar.resignFirstResponder()
        state = .SearchMode
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchItems(searchText, completionBlock: updateList)
    }
}
