//
//  CartManagerSingleton.swift
//  TyphoonExample
//
//  Created by Valerio Ferrucci on 28/07/18.
//  Copyright © 2018 Valerio Ferrucci. All rights reserved.
//

import UIKit

class CartManagerSingleton: CartManagerProtocol {
    func currentCart() -> Cart
    {
        return Cart(id: "1001", created: Date())
    }
}
