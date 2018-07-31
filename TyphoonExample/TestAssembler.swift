//
//  TestAssembler.swift
//  TyphoonExample
//
//  Created by Valerio Ferrucci on 31/07/18.
//  Copyright © 2018 Valerio Ferrucci. All rights reserved.
//

import Foundation

class TestAssembler: CartManagerAssembler { }

extension CartManagerAssembler where Self: TestAssembler {
    func resolve() -> CartManagerProtocol {
        return CartManagerMock()
    }
}
