//
//  LoginViewController+handlers.swift
//  Efimerum
//
//  Created by Charles Moncada on 12/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit
import PKHUD

extension LoginViewController {
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //Disable imageView user interacction
        profileImageView.isUserInteractionEnabled = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? false : true
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            profileImageView.image = UIImage(named: "flame")
            forgetCredentialsButton.isHidden = false
        } else {
            
            if userImage != nil {
                profileImageView.image = userImage
            } else {
                profileImageView.image = UIImage(named: "default_user_icon")
            }
            
            forgetCredentialsButton.isHidden = true
        }
        
        // change height of inputContainerView
        inputsContainerViewHeightAnchor?.isActive = false
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        inputsContainerViewHeightAnchor?.isActive = true
        
        // change height
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func handleLoginCancel() {
        self.didFinish(false)
    }
    
    func handleForgotCredentials() {
        output.sendPasswordReset(self)
    }
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            HUD.show(.label("The fields cannot be empty"))
            HUD.hide(afterDelay: 1)
            return
        }
        
        if email == "" || password == "" {
            HUD.show(.label("The fields cannot be empty"))
            HUD.hide(afterDelay: 1)
            return
        }
        
        HUD.show(.label("Login user..."))

        output.login(withEmail: email, password: password, inViewController: self) { success in
            
            if success {
               self.didFinish(success)
            }
            
        }
        
    }
    
    func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not Valid")
            return
        }
        
        HUD.show(.progress)
        
        output.register(withEmail: email, password: password, name: name, image: self.userImage) { success in
            if success {
                self.didFinish(success)
            }
        }
    }
}



// MARK: UIImagePickerControllerDelegate
extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            userImage = selectedImage
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
