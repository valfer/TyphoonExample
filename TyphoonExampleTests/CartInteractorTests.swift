//
//  CartInteractorTests.swift
//  TyphoonExample
//
//  Created by Valerio Ferrucci on 30/07/18.
//  Copyright (c) 2018 Valerio Ferrucci. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import TyphoonExample
import XCTest

class CartInteractorTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: CartInteractor!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupCartInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupCartInteractor()
  {
    sut = CartInteractor()
  }
  
  // MARK: Test doubles
  
  class CartPresentationLogicSpy: CartPresentationLogic
  {
    func presentCurrentCart(response: CartModels.CurrentCart.Response) {
        presentCurrentCartCalled = true
    }
    
    var presentCurrentCartCalled = false
    
  }
  
  // MARK: Tests
  
  func testLoadCurrentCart()
  {
    // Given
    let spy = CartPresentationLogicSpy()
    sut.presenter = spy
    let request = CartModels.CurrentCart.Request()
    
    // When
    sut.loadCurrenCart(request: request)
    
    // Then
    XCTAssertTrue(spy.presentCurrentCartCalled, "loadCurrenCart(request:) should ask the presenter to format the result")
  }
}
