//
//  Item.swift
//  Makestagram
//
//  Created by Aaron Brown on 7/1/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse

class Item : PFObject, PFSubclassing {
    
    @NSManaged var imageFile: PFFile?
    @NSManaged var productName: PFObject?
    @NSManaged var isCompostable: PFObject?
    
    var image: UIImage?
    
    static func parseClassName() -> String {
        return "Item"
    }
    
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }

}