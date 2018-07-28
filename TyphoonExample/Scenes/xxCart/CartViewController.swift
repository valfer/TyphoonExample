//
//  CartViewController.swift
//  TyphoonExample
//
//  Created by Valerio Ferrucci on 28/07/18.
//  Copyright (c) 2018 Valerio Ferrucci. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CartDisplayLogic: class
{
    func displayCart(viewModel: CartModels.ConfigureForCurrentCart.ViewModel)
}

class CartViewController: UIViewController, CartDisplayLogic
{
    @IBOutlet weak var cartName: UILabel!
    var interactor: CartBusinessLogic?
  
    // MARK: View lifecycle
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        interactor.configureForCurrentCart()
    }
  
    // MARK: Actions
    
    @IBAction func releaseCart(_ sender: Any) {
    }
    
    // MARK: CartDisplayLogic
    
    func displayCart(viewModel: CartModels.ConfigureForCurrentCart.ViewModel) {
        cartName.text = viewModel.name
    }
}
