//
//  CartManagerSingleton.swift
//  TyphoonExample
//
//  Created by Valerio Ferrucci on 28/07/18.
//  Copyright © 2018 Valerio Ferrucci. All rights reserved.
//

import UIKit

class CartManagerSingleton: CartManagerProtocol {
    
    // MARK: - Properties
    
    private static var sharedNetworkManager: CartManagerSingleton = {
        let networkManager = CartManagerSingleton()
        return CartManagerSingleton()
    }()
    
    // Initialization
    
    // MARK: - Accessors
    
    class func shared() -> CartManagerSingleton {
        return sharedNetworkManager
    }
    
    func currentCart() -> Cart
    {
        return Cart(id: "1001", created: Date())
    }
}
