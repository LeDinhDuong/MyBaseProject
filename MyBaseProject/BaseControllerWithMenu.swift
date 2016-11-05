//
//  BaseControllerWithMenu.swift
//  MyBaseProject
//
//  Created by DuongLD on 11/6/16.
//  Copyright © 2016 DuongLD. All rights reserved.
//

import UIKit

class BaseControllerWithMenu: UIViewController{
  var backgroundMainView:UIView?
  var backgroundLeftView:UIView?
  var blackLeftView:UIView?
  var leftView:UIView?
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupEvents()
  }
  
  func setupViews(){
    // View contain content of mainView
    backgroundMainView = {
      let v = UIView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height))
      return v
    }()
    self.view.addSubview(backgroundMainView!)
    
    // View contain content of menuView
    backgroundLeftView = {
      let v = UIView(frame: CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height))
      return v
    }()
    self.view.addSubview(backgroundLeftView!)
    
    // Black background of menuView
    // When tapped it, the menu will be closed
    blackLeftView = {
      let v = UIView(frame: CGRect(x: 0, y: 0, width: backgroundLeftView!.frame.width, height: backgroundLeftView!.frame.height))
      v.backgroundColor = UIColor(white: 0, alpha: 0.5)
      v.addGestureRecognizer(UITapGestureRecognizer(target: self,action: #selector(closeMenu)))
      return v
    }()
    backgroundLeftView!.addSubview(blackLeftView!)
  }
  
  func setupEvents(){
    // Setup dragging on menuView to close or open menu
    let panMenuView = UIPanGestureRecognizer(target: self, action: #selector(leftViewPanGestureRecognizer(_:)))
    panMenuView.minimumNumberOfTouches = 1
    panMenuView.maximumNumberOfTouches = 1
    self.backgroundLeftView!.addGestureRecognizer(panMenuView)
    
    // Setup dragging on mainView to close or open menu
    let panMainView = UIPanGestureRecognizer(target: self, action: #selector(mainViewPanGestureRecognizer(_:)))
    panMainView.minimumNumberOfTouches = 1
    panMainView.maximumNumberOfTouches = 1
    self.backgroundMainView!.addGestureRecognizer(panMainView)
  }
  
  // Setup content for mainView from controller
  func setupMainView(mainView: UIView){
    self.backgroundMainView!.addSubview(mainView)
  }
  
  // Setup content for menuView from controller
  func setupLeftView(leftView: UIView) {
    self.leftView = leftView
    self.backgroundLeftView!.addSubview(leftView)
  }
  
  // Handle open Menu
  func openMenu(){
    self.backgroundLeftView!.alpha = 1
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
      self.blackLeftView!.alpha = 1
      self.leftView!.frame.origin.x = 0
    }) {(completed :Bool) in
      
    }
  }
  
  // Handle close Menu
  func closeMenu(){
    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: {
      self.blackLeftView!.alpha = 0
      self.leftView!.frame.origin.x = -self.leftView!.frame.width
    }) {(completed :Bool) in
      self.backgroundLeftView!.alpha = 0
    }
  }
  
  // Handle drag on MenuView
  var currentX:CGFloat?
  func leftViewPanGestureRecognizer(rec:UIPanGestureRecognizer) {
    let p:CGPoint = rec.locationInView(self.backgroundLeftView)
    switch rec.state {
    case .Began:
      currentX = p.x
      break
    case .Changed:
      if currentX < p.x
      {
        self.leftView!.frame.origin.x = 0
      }
      else if self.leftView!.frame.width < (currentX! - p.x)
      {
        self.leftView!.frame .origin.x = self.leftView!.frame.width
      }
      else
      {
        self.leftView!.frame.origin.x = -(currentX! - p.x)
        self.blackLeftView!.alpha = 1 - (currentX! - p.x)/self.leftView!.frame.width
      }
      break
    case .Ended:
      if (currentX! - p.x) < (self.leftView!.frame.width / 2) {
        openMenu()
      }
      else
      {
        closeMenu()
      }
      break
    default:
      break
    }
  }
  
  // Handle drag on MainView
  func mainViewPanGestureRecognizer(rec: UIPanGestureRecognizer){
    let p:CGPoint = rec.locationInView(self.backgroundMainView!)
    switch rec.state {
    case .Began:
      currentX = p.x
      if currentX < 30 {
        self.backgroundLeftView!.alpha = 1
      }
      break
    case .Changed:
      if p.x < currentX {
        self.leftView!.frame.origin.x = -self.leftView!.frame.width
        self.blackLeftView!.alpha = 0
      }
      else if self.leftView!.frame.width < (p.x - currentX!)
      {
        self.leftView!.frame.origin.x = 0
        self.blackLeftView!.alpha = 1
      }
      else {
        let d = -self.leftView!.frame.width + p.x - currentX!
        self.leftView!.frame.origin.x = d
        self.blackLeftView!.alpha = (p.x - currentX!)/self.leftView!.frame.width
      }
      break
    case .Ended:
      if currentX < 30 {
        if self.leftView!.frame.width/2 < (p.x - currentX!){
          openMenu()
        }
        else
        {
          closeMenu()
        }
      }
      else {
        closeMenu()
      }
      break
    default:
      break
    }
  }
}
