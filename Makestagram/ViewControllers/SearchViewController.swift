//
//  SearchViewController.swift
//  Makestagram
//
//  Created by Aaron Brown on 7/1/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var items: [Item] = []
    //var selectedItem: Item?
    
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
                //searchBar.resignFirstResponder()
                searchBar.text = ""
                searchBar.showsCancelButton = false
            case .SearchMode:
                let searchText = searchBar?.text ?? ""
                searchBar.setShowsCancelButton(true, animated: true)
                //items = searchItems(searchText)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        // Item Image Query
        let itemsQuery = PFQuery(className: "Item")
        //Other Queries
        let productNameQuery = PFQuery(className: "Item")
        productNameQuery.whereKey("productName", notEqualTo: "")
        
        let query = PFQuery.orQueryWithSubqueries([itemsQuery, productNameQuery])
        query.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            // MARK: Need to take results as an array of Items?
            self.items = result as? [Item] ?? []
                
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

// MARK: Extensions

extension SearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemTableViewCell
        
        let item = items[indexPath.row]
        item.downloadImage()
        cell.itemLabel!.text = item.productName
        cell.isCompostableLabel.text = item.isCompostable
        cell.item = item
        
        return cell
    }
    
    /*func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }*/
}

extension SearchViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemTableViewCell
        //let item = items[indexPath.row]
        self.performSegueWithIdentifier("ShowItem", sender: self)
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //ParseHelper.searchItems(searchText, completionBlock:updateList)
    }
}
