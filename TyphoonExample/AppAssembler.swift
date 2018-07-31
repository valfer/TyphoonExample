//
//  AppAssembler.swift
//  TyphoonExample
//
//  Created by Valerio Ferrucci on 31/07/18.
//  Copyright © 2018 Valerio Ferrucci. All rights reserved.
//

import Foundation

class AppAssembler {

    var testing = false
    
    static let shared = AppAssembler()

    init() {
        let processArguments = VFProcessArguments()
        testing = processArguments.UseMockClassesForTests()
    }

    // MARK: - DI

    func getCartManager() -> CartManagerProtocol {
        if testing {
            return CartManagerMock.shared
        } else {
            return CartManagerSingleton.shared
        }
    }
    
}


