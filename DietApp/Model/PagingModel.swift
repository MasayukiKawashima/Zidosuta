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
//TopPageのページング先のインスタンス生成処理
  func topVCInstantiate(for topPageViewController: TopPageViewController, direction: Direction)-> TopViewController {
    //渡されてきたPageViewControllerから現在のViewControllerを取得
    let currentTopVC = topPageViewController.viewControllers?.first as! TopViewController
    //現在のViewControllerのindexを取得
    let currentPageIndex = currentTopVC.index
    
    let stroyBoard = UIStoryboard(name: "Main", bundle: nil)
    let topVC = stroyBoard.instantiateViewController(withIdentifier: "TopVC") as! TopViewController
    
    
    switch direction {
    case .next:
      let nextPageIndex = currentPageIndex + 1
      topVC.index = nextPageIndex
      return topVC
    case .previous:
      let nextPageIndex = currentPageIndex - 1
      topVC.index = nextPageIndex
      return topVC
    }
  }
  //GraphPageのページング先のインスタンス生成処理
  func graphVCInstantiate(for graphPageViewController: GraphPageViewController, direction: Direction)-> GraphViewController {
    //渡されてきたPageViewControllerから現在のViewControllerを取得
    let currentTopVC = graphPageViewController.controllers.first! as! GraphViewController
    //現在のViewControllerのindexを取得
    let currentPageIndex = currentTopVC.index
    
    let stroyBoard = UIStoryboard(name: "Main", bundle: nil)
    let graphVC = stroyBoard.instantiateViewController(withIdentifier: "GraphVC") as! GraphViewController
    
    switch direction {
    case .next:
      let nextPageIndex = currentPageIndex + 1
      graphVC.index = nextPageIndex
      return graphVC
    case .previous:
      let previosPageIndex = currentPageIndex - 1
      graphVC.index = previosPageIndex
      return graphVC
    }
  }
}
