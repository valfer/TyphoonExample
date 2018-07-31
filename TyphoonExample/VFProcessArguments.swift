//
//  ProcessArguments.swift
//  iDoctors
//
//  Created by Valerio Ferrucci on 08/02/17.
//  Copyright © 2017 Tabasoft. All rights reserved.
//

import Foundation

class VFProcessArguments : NSObject {
    
    func UseMockClassesForTests() -> Bool {
        
        return existsArgumentWithName("UseMockClassesForTests")
    }
    
    fileprivate func existsArgumentWithName(_ name: String) -> Bool {
        
        let arguments = ProcessInfo.processInfo.arguments
        for argument in arguments {
            
            switch argument {
            case name:
                return true
            default:
                break
            }
        }
        return false
    }
}
