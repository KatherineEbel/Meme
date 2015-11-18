//
//  Meme.swift
//  Meme
//
//  Created by Katherine Ebel on 11/16/15.
//  Copyright © 2015 Katherine Ebel. All rights reserved.
//

import Foundation
import UIKit

class Meme {
  var topText: String
  var bottomText: String
  let originalImage: UIImage?
  let memedImage: UIImage?
  
  init(topText: String = "TOP", bottomText: String = "BOTTOM", originalImage: UIImage?, memedImage: UIImage?) {
    self.topText = topText
    self.bottomText = bottomText
    self.originalImage = originalImage
    self.memedImage = memedImage
  }
  
}
