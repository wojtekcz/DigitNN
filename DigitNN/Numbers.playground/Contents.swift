//: Playground - noun: a place where people can play

import Cocoa

//var str = "  1.00000000e+01 "
//str = str.stringByTrimmingCharactersInSet(
//    NSCharacterSet.whitespaceAndNewlineCharacterSet())
//var y0 = Double(str)

let str = "{\"y\": [[10],[10],[9]]}"

let data = str.dataUsingEncoding(NSUTF8StringEncoding)

let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
print(json)
let y = json["y"]!

let y2: [Double] = y[0] as! [Double]


//let y2 = y[0].map({
//    (n: [Double]) -> _ in
//    return n[0]
//})

