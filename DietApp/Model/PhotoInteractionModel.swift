//
//  PhotoInteractionModel.swift
//  DietApp
//
//  Created by 川島真之 on 2023/06/28.
//

import UIKit

class PhotoInteractionModel {
  //アクションシートの表示
   func showPhotoSelectionActionSheet(from viewController: UIViewController) {
    let actionSheet = UIAlertController(title: "写真の選択", message: nil, preferredStyle: .actionSheet)
    
    let cameraAction = UIAlertAction(title: "カメラ", style: .default) { action in
      self.showImagePicker(sourceType: .camera, from: viewController)
    }
    
    let photoLibraryAction = UIAlertAction(title: "フォトライブラリ", style: .default) { action in
      self.showImagePicker(sourceType: .photoLibrary, from: viewController)
    }
    
    let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
    
    actionSheet.addAction(cameraAction)
    actionSheet.addAction(photoLibraryAction)
    actionSheet.addAction(cancelAction)
    
    viewController.present(actionSheet, animated: true, completion: nil)
  }
  //ImagePickerControllerの表示
  func showImagePicker(sourceType: UIImagePickerController.SourceType, from viewController: UIViewController) {
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = sourceType
      if let delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate {
        imagePicker.delegate = delegate
      }else{
        print("UIImagePickerControllerDelegateとUINavigationControllerDelegateのうち少なくとも一つが準拠されていないVCが引数として渡されました")
      }
      viewController.present(imagePicker, animated: true, completion: nil)
    }
  }
}
