//
//  CartInteractor.swift
//  TyphoonExample
//
//  Created by Valerio Ferrucci on 28/07/18.
//  Copyright (c) 2018 Valerio Ferrucci. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

//import UIKit

protocol CartBusinessLogic
{
  func configure(cart: Cart.Something.Request)
}

protocol CartDataStore
{
  //var name: String { get set }
}

class CartInteractor: CartBusinessLogic, CartDataStore
{
  var presenter: CartPresentationLogic?
  var worker: CartWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: Cart.Something.Request)
  {
    worker = CartWorker()
    worker?.doSomeWork()
    
    let response = Cart.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
