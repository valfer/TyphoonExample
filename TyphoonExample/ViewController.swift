//
//  ViewController.swift
//  TyphoonExample
//
//  Created by Valerio Ferrucci on 28/07/18.
//  Copyright © 2018 Valerio Ferrucci. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var cartManager : CartManagerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let cartManager = CartManagerSingleton()
        
        print(cartManager)
    }


}

