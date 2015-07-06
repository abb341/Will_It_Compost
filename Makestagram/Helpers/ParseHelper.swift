//
//  ParseHelper.swift
//  Makestagram
//
//  Created by Aaron Brown on 7/2/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse

class ParseHelper: PFObject {
   /* func searchItems(searchText: String, completionBlock: PFArrayResultBlock) -> PFQuery {
        return PFQuery
    }*/
    static func searchRequestforCurrentUser(range: Range<Int>, completionBlock: PFArrayResultBlock) {
        
        // Item Image Query
        let itemsQuery = PFQuery(className: "Item")
        //Other Queries
        let productNameQuery = PFQuery(className: "Item")
        productNameQuery.whereKey("productName", notEqualTo: "")
        
        let query = PFQuery.orQueryWithSubqueries([itemsQuery, productNameQuery])
        //query.orderbyAscending("createdAt")
        
        // 2
        query.skip = range.startIndex
        // 3
        query.limit = range.endIndex - range.startIndex
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        /*query.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
            self.items = result as? [Item] ?? []
            
            self.tableView.reloadData()
        }*/

    }
}
