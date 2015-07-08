//
//  Item.swift
//  Makestagram
//
//  Created by Aaron Brown on 7/1/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse
import Bond

class Item : PFObject, PFSubclassing {
    
    @NSManaged var imageFile: PFFile?
    @NSManaged var productName: String
    @NSManaged var isCompostable: String
    @NSManaged var Description: String
    
    var image: Dynamic<UIImage?> = Dynamic(nil)
    
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
    
    func downloadImage() {
        // if image is not downloaded yet, get it
        if (image.value == nil) {
            imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    self.image.value = image
                }
            }
        }
    }

}