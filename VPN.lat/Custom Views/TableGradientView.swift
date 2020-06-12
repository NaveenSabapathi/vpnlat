//
//  TableGradientView.swift
//  VPN.lat
//
//  Created by user173177 on 5/30/20.
//  Copyright © 2020 user173177. All rights reserved.
//

import Foundation
import UIKit

class TableGradientView: UITableView {

/*
// Only override draw() if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
override func draw(_ rect: CGRect) {
    // Drawing code
}
*/
@IBInspectable var firstColor: UIColor = UIColor.clear {
   didSet {
       updateView()
    }
 }
 @IBInspectable var secondColor: UIColor = UIColor.clear {
    didSet {
        updateView()
    }
}
    
 @IBInspectable var isHorizontal: Bool = true {
    didSet {
       updateView()
    }
 }

 func updateView() {
  let layer = self.layer as! CAGradientLayer
  layer.colors = [firstColor, secondColor].map{$0.cgColor}
  if (self.isHorizontal) {
     layer.startPoint = CGPoint(x: 0, y: 0.5)
     layer.endPoint = CGPoint (x: 1, y: 0.5)
  } else {
     layer.startPoint = CGPoint(x: 0.5, y: 0)
     layer.endPoint = CGPoint (x: 0.5, y: 1)
  }
 }

override class var layerClass: AnyClass {
   get {
      return CAGradientLayer.self
   }
}
}
