//
//  ModifyUserViewController+handlers.swift
//  Efimerum
//
//  Created by Charles Moncada on 15/03/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import Foundation
import PKHUD

extension ModifyUserViewController {
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        if let text = textField.text {
            if text != "" {
                textChanged = true
            } else {
                textChanged = false
            }
            
            if textChanged || imageChanged {
                infoChanged = true
            } else {
                infoChanged = false
            }
            
        }
          
    }
    
    func handleSaveChanges() {
        
        var newImage: UIImage?
        var newName: String?
        
        if imageChanged {
            newImage = profileImageView.image
        }
        
        if textChanged {
            newName = nameTextField.text!
        }
        
        HUD.show(.label("Modifying User..."))
        
        output.updateUserInfo(withNewName: newName, newImage: newImage) { (sucess) in
            print("cambie los datos del usuario")
            let _ = self.navigationController?.popViewController(animated: false)
            self.didFinish()
        }
        
    }
}

// MARK: UIImagePickerControllerDelegate
extension ModifyUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            imageChanged = true
            infoChanged = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension ModifyUserViewController: UITextFieldDelegate {
    
    
    
}
