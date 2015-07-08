//
//  ParseHelper.swift
//  Is It Compostable?
//
//  Created by Aaron Brown on 7/2/15.
//  Copyright (c) 2015 Aaron Brown. All rights reserved.
//

import Foundation
import Parse

class ParseHelper: PFObject {
    func searchItems(searchText: String, completionBlock: PFArrayResultBlock) -> PFQuery {
        let query = PFQuery(className: "Item")
        query.whereKey("productName", matchesRegex: searchText, modifiers: "i")
    
        query.orderByAscending("productName")
        query.limit = 20
    
        query.findObjectsInBackgroundWithBlock(completionBlock)
        return query
    }
    
    static func allItems(completionBlock: PFArrayResultBlock) -> PFQuery {
        let query = PFQuery(className: "Item")
        query.orderByAscending("productName")
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
        return query
    }
    
    static func searchRequestforCurrentUser(range: Range<Int>, completionBlock: PFArrayResultBlock) {
        
        // Item Image Query
        let itemsQuery = PFQuery(className: "Item")
        //Other Queries
        let productNameQuery = PFQuery(className: "Item")
        productNameQuery.whereKey("productName", notEqualTo: "")
        
        let query = PFQuery.orQueryWithSubqueries([itemsQuery, productNameQuery])
        // Order Alphabetically
        query.orderByAscending("productName")
        
        // 2
        query.skip = range.startIndex
        // 3
        query.limit = range.endIndex - range.startIndex
        
        query.findObjectsInBackgroundWithBlock(completionBlock)

    }
}
