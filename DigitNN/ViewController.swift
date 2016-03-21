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

    var X = Matrix<Double>(rows: 0, columns: 0)
    var y = Matrix<Double>(rows: 0, columns: 0)
    var Theta1 = Matrix<Double>(rows: 0, columns: 0)
    var Theta2 = Matrix<Double>(rows: 0, columns: 0)
    
    @IBAction func load(sender: AnyObject) {
        let tempX = loadArrayFromJson("X", fileName: "X.json")
        let tempy = loadArrayFromJson("y", fileName: "y.json")
        let tempTheta1 = loadArrayFromJson("Theta1", fileName: "Theta1.json")
        let tempTheta2 = loadArrayFromJson("Theta2", fileName: "Theta2.json")

        //convert Theta1 and Theta2
        Theta1 = Matrix<Double>(tempTheta1 as! [[Double]])
        Theta2 = Matrix<Double>(tempTheta2 as! [[Double]])
        
        //convert X and Y
        X = Matrix<Double>(tempX as! [[Double]])
        y = Matrix<Double>(tempy as! [[Double]])

        for i in 0..<y.rows {
            if y[i,0] == 10 {
                y[i,0] = 0
            }
        }
        
        print("X(\(X.rows),\(X.columns))")
        print("y(\(y.rows),\(y.columns))")
        print("Theta1(\(Theta1.rows),\(Theta1.columns))")
        print("Theta2(\(Theta2.rows),\(Theta2.columns))")
        
        print("y[0,0] = ", y[0,0])
    }
    
    func predict_one_digit(x: ValueArray<Double>) -> Int {

        //a1 = [1; x];
        let a1 = ValueArray<Double>(capacity: x.count + 1)
        a1.append(1.0)
        a1.appendContentsOf(x)
        
        //a2 = [1; sigmoid(Theta1 * a1)];
        //g = 1.0 ./ (1.0 + exp(-z));
        let prod: Matrix<Double> = Theta1 * a1.toColumnMatrix()
        let sigmoid = prod.elements.map({ 1.0 / (1.0 + exp(-$0)) })
        
        let a2 = ValueArray<Double>(capacity: sigmoid.count + 1)
        a2.append(1.0)
        a2.appendContentsOf(sigmoid)
        
        //a3 = sigmoid(Theta2 * a2);
        let prod2: Matrix<Double> = Theta2 * a2.toColumnMatrix()
        
        let sigmoid2 = prod2.elements.map({ 1.0 / (1.0 + exp(-$0)) })
        
        //[prob, pi] = max(a3);
        let m = max(sigmoid2)
        
        var idx = sigmoid2.indexOf(m)! + 1
        
        if idx == 10 {
            idx = 0
        }
        
        return idx
    }
    
    @IBAction func predict(sender: AnyObject) {

        var miss = 0
        
        for i in 0..<X.rows {
            let x = ValueArray(X.row(i))
            let digit: Int = predict_one_digit(x)
            //print("\(i). digit = \(digit), y=\(y[i,0])")
            
            if digit != Int(y[i,0]) {
                miss++;
            }
        }
        print("NN prediction accuracy \(Double(X.rows - miss)/Double(X.rows))")
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

