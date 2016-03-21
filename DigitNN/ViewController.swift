//
//  ViewController.swift
//  DigitNN
//
//  Created by Wojciech Czarnowski on 21.03.2016.
//  Copyright © 2016 JATAR. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        load(self)
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func loadArrayFromJson(arrayName: String, fileName: String) -> [AnyObject] {
        
        let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: nil)
        let jsonStr = try! NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding)
        let jsonData = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
        
        let dict = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
        
        let array: [AnyObject] = dict[arrayName]! as! [AnyObject]
        
        return array
    }
    
    @IBAction func load(sender: AnyObject) {
        let X = loadArrayFromJson("X", fileName: "X.json")
        let y = loadArrayFromJson("y", fileName: "y.json")
        let Theta1 = loadArrayFromJson("Theta1", fileName: "Theta1.json")
        let Theta2 = loadArrayFromJson("Theta2", fileName: "Theta2.json")
        
        print("X.count = ", X.count)
        print("X[0].count = ", X[0].count)
        print("y.count = ", y.count)
        print("y[0].count = ", y[0].count)
        print("Theta1.count = ", Theta1.count)
        print("Theta1[0].count = ", Theta1[0].count)
        print("Theta2.count = ", Theta2.count)
        print("Theta2[0].count = ", Theta2[0].count)
        
        print("y[0][0] = ", y[1000][0])
    }
}

