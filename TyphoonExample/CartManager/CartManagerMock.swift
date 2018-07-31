//
//  CartManagerMock.swift
//  TyphoonExample
//
//  Created by Valerio Ferrucci on 28/07/18.
//  Copyright © 2018 Valerio Ferrucci. All rights reserved.
//

import UIKit

class CartManagerMock: CartManagerProtocol {
    
    // MARK: - Properties
    
    private static var sharedNetworkManager: CartManagerMock = {
        let networkManager = CartManagerMock()
        return CartManagerMock()
    }()
    
    // Initialization
    
    // MARK: - Accessors
    
    class func shared() -> CartManagerMock {
        return sharedNetworkManager
    }
    
    func currentCart() -> Cart
    {
        return Cart(id: "0", created: Date())
    }

}
