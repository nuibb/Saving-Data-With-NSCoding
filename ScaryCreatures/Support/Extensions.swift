//
//  AppDelegate.swift
//  ScaryCreatures
//
//  Created by Steve JobsOne on 4/30/19.
//  Copyright © 2019 MobioApp Limited. All rights reserved.
//

import UIKit

extension UIImage {
  func resized(newSize: CGSize) -> UIImage {
    let horizontalRatio = newSize.width / size.width
    let verticalRatio = newSize.height / size.height
    
    let ratio = max(horizontalRatio, verticalRatio)
    
    return resized(ratio: ratio)
  }
  
  func resized(ratio: CGFloat) -> UIImage {
    let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
    UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
    draw(in: CGRect(origin: .zero, size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }
}
