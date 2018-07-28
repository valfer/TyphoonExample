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
  func displayCart(viewModel: Cart.Cart.ViewModel)
}

class CartViewController: UIViewController, CartDisplayLogic
{
  var interactor: CartBusinessLogic?
  var router: (NSObjectProtocol & CartRoutingLogic & CartDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = CartInteractor()
    let presenter = CartPresenter()
    let router = CartRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doCart()
  }
  
  // MARK: Do Cart
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doCart()
  {
    let request = Cart.Cart.Request()
    interactor?.doCart(request: request)
  }
  
  func displayCart(viewModel: Cart.Cart.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
}
