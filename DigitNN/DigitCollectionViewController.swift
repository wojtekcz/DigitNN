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
        
        collectionView.register(NSNib(nibNamed: "DigitCollectionViewItem", bundle: nil), forItemWithIdentifier: "digit")
        collectionView.register(DigitCollectionViewItem.self, forItemWithIdentifier: "digit")
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item: DigitCollectionViewItem = collectionView.makeItem(withIdentifier: "digit", for: indexPath as IndexPath) as! DigitCollectionViewItem
        //item.representedObject = indexPath.item
        item.digit = indexPath.item
        item.image = images[indexPath.item]
        item.update()
        return item
    }
}
