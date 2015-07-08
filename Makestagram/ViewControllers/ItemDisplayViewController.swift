//
//  ItemDisplayViewController.swift
//  Makestagram
//
//  Created by Aaron Brown on 7/2/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class ItemDisplayViewController: UIViewController {
    @IBOutlet weak var selectedItem: UILabel!
    @IBOutlet weak var itemDesc: UILabel!
    
    var labelText = String()
    var descText = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        selectedItem.text = labelText
        //itemDesc.text = descText
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
