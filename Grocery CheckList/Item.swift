//
//  Item.swift
//  Grocery CheckList
//
//  Created by sagar vadapalli on 6/8/17.
//  Copyright © 2017 sagar vadapalli. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {

    var uuid: String = UUID().uuidString
    var name: String = ""
    var price: Float = 0.0
    var inShoppingList = false

    // MARK: -
    // MARK: Initialization
    init(name: String, price: Float) {
        super.init()
        
        self.name = name
        self.price = price
    }

    // MARK: -
    // MARK: NSCoding Protocol
    required init?(coder decoder: NSCoder) {
        super.init()
        
        if let archivedUuid = decoder.decodeObject(forKey: "uuid") as? String {
            uuid = archivedUuid
        }
        
        if let archivedName = decoder.decodeObject(forKey: "name") as? String {
            name = archivedName
        }
        
        price = decoder.decodeFloat(forKey: "price")
        inShoppingList = decoder.decodeBool(forKey: "inShoppingList")
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(uuid, forKey: "uuid")
        coder.encode(name, forKey: "name")
        coder.encode(price, forKey: "price")
        coder.encode(inShoppingList, forKey: "inShoppingList")
    }

}
