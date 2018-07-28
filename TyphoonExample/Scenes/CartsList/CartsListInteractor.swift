//
//  CartsListInteractor.swift
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

protocol CartsListBusinessLogic
{
  func doSomething(request: CartsList.Something.Request)
}

protocol CartsListDataStore
{
    var carts: [Cart] { get set }
}

class CartsListInteractor: CartsListBusinessLogic, CartsListDataStore
{
  var presenter: CartsListPresentationLogic?
  var worker: CartsListWorker?
  //var name: String = ""
  
  // MARK: Do something
  
  func doSomething(request: CartsList.Something.Request)
  {
    worker = CartsListWorker()
    worker?.doSomeWork()
    
    let response = CartsList.Something.Response()
    presenter?.presentSomething(response: response)
  }
}
