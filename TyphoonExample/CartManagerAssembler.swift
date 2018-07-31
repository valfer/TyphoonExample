//
//  CartManagerAssembler.swift
//  TyphoonExample
//
//  Created by Valerio Ferrucci on 31/07/18.
//  Copyright © 2018 Valerio Ferrucci. All rights reserved.
//

import Foundation

protocol CartManagerAssembler {
    func resolve() -> CartManagerProtocol
}

extension CartManagerAssembler {
    func resolve() -> CartManagerProtocol {
        return CartManagerSingleton()
    }
}
