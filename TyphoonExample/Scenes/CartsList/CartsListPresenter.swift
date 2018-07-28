//
//  CartsListPresenter.swift
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

protocol CartsListPresentationLogic
{
  func presentSomething(response: CartsList.Something.Response)
}

class CartsListPresenter: CartsListPresentationLogic
{
  weak var viewController: CartsListDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: CartsList.Something.Response)
  {
    let viewModel = CartsList.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}
