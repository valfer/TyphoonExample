//
//  CartPresenter.swift
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

protocol CartPresentationLogic
{
  func presentSomething(response: Cart.Something.Response)
}

class CartPresenter: CartPresentationLogic
{
  weak var viewController: CartDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Cart.Something.Response)
  {
    let viewModel = Cart.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
