//
//  CartManagerMock.swift
//  TyphoonExample
//
//  Created by Valerio Ferrucci on 28/07/18.
//  Copyright © 2018 Valerio Ferrucci. All rights reserved.
//

import UIKit

class CartManagerMock: CartManagerProtocol {
    
    func currentCart() -> Cart
    {
        return Cart(id: "0", created: Date())
    }

}
