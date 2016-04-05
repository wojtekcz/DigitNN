//
//  CollectionViewController.swift
//  DigitNN
//
//  Created by Wojciech Czarnowski on 05.04.2016.
//  Copyright © 2016 JATAR. All rights reserved.
//

import Cocoa

class DigitCollectionViewController: NSViewController, NSCollectionViewDataSource {

    @IBOutlet weak var collectionView: NSCollectionView!

    var images = [NSImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(NSNib(nibNamed: "DigitCollectionViewItem", bundle: nil), forItemWithIdentifier: "digit")
        collectionView.registerClass(DigitCollectionViewItem.self, forItemWithIdentifier: "digit")
    }
    
    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        let item: DigitCollectionViewItem = collectionView.makeItemWithIdentifier("digit", forIndexPath: indexPath) as! DigitCollectionViewItem
        //item.representedObject = indexPath.item
        item.digit = indexPath.item
        item.image = images[indexPath.item]
        item.update()
        return item
    }
}
