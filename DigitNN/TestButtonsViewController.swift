//
//  ViewController.swift
//  DigitNN
//
//  Created by Wojciech Czarnowski on 21.03.2016.
//  Copyright © 2016 JATAR. All rights reserved.
//

import Cocoa
import Upsurge

class TestButtonsViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        load(sender: self)
    }

    /*override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }*/
    
    func loadArrayFromJson(arrayName: String, fileName: String) -> [AnyObject] {
        
        let url = Bundle.main.url(forResource: fileName, withExtension: nil)
        let jsonStr = try! NSString(contentsOf: url!, encoding: String.Encoding.utf8.rawValue)
        let jsonData = jsonStr.data(using: String.Encoding.utf8.rawValue)
        
        let dict = try! JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
        
        let array: [AnyObject] = dict[arrayName]! as! [AnyObject]
        
        return array
    }

    var X = Upsurge.Matrix<Double>(rows: 0, columns: 0)
    var y = Upsurge.Matrix<Double>(rows: 0, columns: 0)
    var Theta1 = Upsurge.Matrix<Double>(rows: 0, columns: 0)
    var Theta2 = Upsurge.Matrix<Double>(rows: 0, columns: 0)
    
    @IBAction func load(_ sender: Any) {
        let tempX = loadArrayFromJson(arrayName: "X", fileName: "X.json")
        let tempy = loadArrayFromJson(arrayName:"y", fileName: "y.json")
        let tempTheta1 = loadArrayFromJson(arrayName:"Theta1", fileName: "Theta1.json")
        let tempTheta2 = loadArrayFromJson(arrayName:"Theta2", fileName: "Theta2.json")

        //convert Theta1 and Theta2
        Theta1 = Upsurge.Matrix<Double>(tempTheta1 as! [[Double]])
        Theta2 = Upsurge.Matrix<Double>(tempTheta2 as! [[Double]])
        
        //convert X and Y
        X = Upsurge.Matrix<Double>(tempX as! [[Double]])
        y = Upsurge.Matrix<Double>(tempy as! [[Double]])

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
        let prod: Upsurge.Matrix<Double> = Theta1 * a1.toColumnMatrix()
        let sigmoid = prod.elements.map({ 1.0 / (1.0 + exp(-$0)) })
        
        let a2 = ValueArray<Double>(capacity: sigmoid.count + 1)
        a2.append(1.0)
        a2.appendContentsOf(sigmoid)
        
        //a3 = sigmoid(Theta2 * a2);
        let prod2: Upsurge.Matrix<Double> = Theta2 * a2.toColumnMatrix()
        
        let sigmoid2 = prod2.elements.map({ 1.0 / (1.0 + exp(-$0)) })
        
        //[prob, pi] = max(a3);
        let m = max(sigmoid2)
        
        var idx = sigmoid2.index(of: m)! + 1
        
        if idx == 10 {
            idx = 0
        }
        
        return idx
    }
    
    @IBAction func predict(_ sender: Any) {

        var miss = 0
        
        for i in 0..<X.rows {
            let x = ValueArray(X.row(i))
            let digit: Int = predict_one_digit(x: x)
            //print("\(i). digit = \(digit), y=\(y[i,0])")
            
            if digit != Int(y[i,0]) {
                miss += 1;
            }
        }
        print("NN prediction accuracy \(Double(X.rows - miss)/Double(X.rows))")
    }
    
    @IBAction func testMatrixMultiplication(_ sender: Any) {
        print("testMatrixMultiplication()")
        
        let A = Upsurge.Matrix<Double>([
            [1, 2, 3],
            [4, 5, 6]
            ])
        let B = Upsurge.Matrix<Double>([
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
    
    @IBOutlet var digitView: DigitView!
    
    @IBAction func updateImage(_ sender: Any) {
        
        let i = 100
        let xi = ValueArray(X.row(i))
        
        for y in 0..<digitView.length {
            for x in 0..<digitView.length {
                let idx = y*digitView.length + x
                var xii = xi[idx] * 256
                
                if xii < 0 {
                    xii = 0
                }

                if xii > 255 {
                    xii = 255
                }

                let v = UInt8(255-xii)
                
                let pixel = PixelData(a: 255, r: v, g: v, b: v)
                digitView.pixelData[y*digitView.length + x] = pixel
            }
        }

        digitView.updateImage()
    }
    
    private func outputToLabel(output: [Float]) -> UInt8? {
        guard let max = output.max() else {
            return nil
        }
        
        var out = UInt8(output.index(of: max)!)
        
        switch out {
        case 0...8:
            out += 1
        case 9:
            out = 0
        default:
            return nil
        }
        
        return out
    }
    
    @IBAction func convertWagesToSwiftAI(_ sender: Any) {
        
        print("convertWagesToSwiftAI()")
        
        let network = FFNN(inputs: 400, hidden: 25, outputs: 10, learningRate: 1.0, momentum: 0.5, weights: nil, activationFunction: .Sigmoid, errorFunction: .crossEntropy(average: true))
        
        var weights = network.getWeights()
        
        let e1 = Theta1.elements
        let e2 = Theta2.elements
        
        var idx=0
        for e in e1 {
            weights[idx] = Float(e)
            idx += 1
        }

        for e in e2 {
            weights[idx] = Float(e)
            idx += 1
        }

        try! network.resetWithWeights(weights)
        
        
        // test network with loaded wages
        var correct: Float = 0
        var incorrect: Float = 0
        for i in 0..<X.rows {
            let x = ValueArray(X.row(i))
            
            var float_x: [Float] = []
            for (_, el) in x.enumerated() {
                float_x.append(Float(el))
            }
            
            let outputArray = try! network.update(inputs: float_x)
            if let outputLabel = self.outputToLabel(output: outputArray) {
                if outputLabel == UInt8(self.y[i,0]) {
                    correct += 1
                } else {
                    incorrect += 1
                }
            } else {
                incorrect += 1
            }
        }
        let percent = correct * 100 / (correct + incorrect)
        print("Correct: \(Int(correct))")
        print("Incorrect: \(Int(incorrect))")
        print("Accuracy: \(percent)%")
        
        
        network.writeToFile("handwriting-ffnn")
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDigitCollection" {
            let wc = segue.destinationController as! NSWindowController
            let vc = wc.contentViewController as! DigitCollectionViewController
            var images = [NSImage]()
            
            for i in 0..<X.rows {
                let xi = ValueArray(X.row(i))
                let image = imageFromRow(xi: xi, length: 20)
                images.append(image)
            }
            
            vc.images = images
        }
    }
}

