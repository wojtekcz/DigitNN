//
//  ViewController.swift
//  DigitNN
//
//  Created by Wojciech Czarnowski on 21.03.2016.
//  Copyright © 2016 JATAR. All rights reserved.
//

import Cocoa
import Upsurge

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

    var X = []
    var y = []
    var Theta1 = []
    var Theta2 = []
    
    @IBAction func load(sender: AnyObject) {
        X = loadArrayFromJson("X", fileName: "X.json")
        y = loadArrayFromJson("y", fileName: "y.json")
        Theta1 = loadArrayFromJson("Theta1", fileName: "Theta1.json")
        Theta2 = loadArrayFromJson("Theta2", fileName: "Theta2.json")
        
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
    
    func predict_one_digit(x: [AnyObject]) -> Double {
        print("predict_one_digit(x.count=", x.count, ")")
        //function [pi] = predict_one_digit(x)
        //a1 = [1; x];
        //a2 = [1; sigmoid(Theta1 * a1)];
        //a3 = sigmoid(Theta2 * a2);
        //[prob, pi] = max(a3);
        
        return -1
    }
    
    @IBAction func predict(sender: AnyObject) {
        let x = X[0] as! [AnyObject]
        let pi = predict_one_digit(x)
        print("pi = ", pi)
    }
    
    @IBAction func testMatrixMultiplication(sender: AnyObject) {
        print("testMatrixMultiplication()")
        
        let A = Matrix<Double>([
            [1, 2, 3],
            [4, 5, 6]
            ])
        let B = Matrix<Double>([
            [1],
            [2],
            [3]
            ])

        let r = A*B
        print("A =")
        print(A)
        print("B =")
        print(B)
        print("r =")
        print(r)
        
        let c = Upsurge.transpose(r)
        print("c =")
        print(c)
    }
}

