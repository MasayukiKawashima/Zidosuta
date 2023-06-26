//
//  PagingModel.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/26.
//

import Foundation
import UIKit

class PagingModel {
  enum Direction {
    case next
    case previous
  }
  
  enum identifier {
    case topVC
    case graphVC
  }
  //6.26　一応遷移方向によって分岐させている
  func instantiate(Identifier: identifier,direction: Direction) -> UIViewController {
    let stroyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    switch Identifier {
    case .topVC:
      let viewController = stroyBoard.instantiateViewController(withIdentifier: "TopVC") as! TopViewController
      switch direction {
      case .next:
        return viewController
      case .previous:
        return viewController
      }
      
    case .graphVC:
      let viewController = stroyBoard.instantiateViewController(withIdentifier: "GraphVC") as! GraphViewController
      switch direction {
      case .next:
        return viewController
      case .previous:
        return viewController
      }
    }
  }
}
