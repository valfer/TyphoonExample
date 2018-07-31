//
//  AppAssembler.swift
//  TyphoonExample
//
//  Created by Valerio Ferrucci on 31/07/18.
//  Copyright © 2018 Valerio Ferrucci. All rights reserved.
//

import Foundation

class AppAssembler {
    
    static func getCartManager() -> CartManagerProtocol {
        
        return CartManagerSingleton.shared()
    }
    
}


