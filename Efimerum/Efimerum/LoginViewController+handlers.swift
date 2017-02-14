//
//  LoginViewController+handlers.swift
//  Efimerum
//
//  Created by Charles Moncada on 12/02/17.
//  Copyright © 2017 mibarbou. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PKHUD

extension LoginViewController {
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        
        present(picker, animated: true, completion: nil)
    }
    
    func handleLoginCancel() {
        self.didFinish()
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
            print("Form is not Valid")
            return
        }
        
        HUD.show(.label("Autenticando Usuario..."))
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                HUD.flash(.label(error?.localizedDescription), delay: 1)
                return
            }
            
            HUD.flash(.success, delay: 1.0)
            self.didFinish()
        })
    }
    
    func handleRegister() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not Valid")
            return
        }
        
        HUD.show(.progress)
        
        if let _ = FIRAuth.auth()?.currentUser?.isAnonymous {
            let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)
            
            FIRAuth.auth()?.currentUser?.link(with: credential, completion: { (user, error) in
                
                self.registerUserIntoFirebase(user, withName: name, email: email, error: error)
                
            })
        } else {
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                
                self.registerUserIntoFirebase(user, withName: name, email: email, error: error)
                
            })
        }
        
        
        
    }
    
    private func registerUserIntoFirebase(_ user: FIRUser?, withName name: String, email: String, error: Error?) {
        
        if error != nil {
            HUD.flash(.label(error?.localizedDescription), delay: 1)
            return
        }
        
        guard let uid = user?.uid else {
            return
        }
        
        // Success
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    HUD.flash(.label(error?.localizedDescription), delay: 1)
                    return
                }
                
                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                    let values = ["name": name, "email": email, "profileImageURL": profileImageURL]
                    
                    self.registerUserIntoDatabaseWithUID(uid, values: values)
                }
                
            })
        }

    }
    
    private func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                HUD.flash(.label(err?.localizedDescription), delay: 1)
                return
            }
            HUD.flash(.success, delay: 1.0)
            self.didFinish()
            
        })
    }
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //Disable imageView user interacction
        profileImageView.isUserInteractionEnabled = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? false : true
        
        // Recover logo image when we select login
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            tempImage = profileImageView.image!
            profileImageView.image = UIImage(named: "flame")
        } else {
            profileImageView.image = tempImage
        }
        
        // change height of inputContainerView
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change height
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        //nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        //nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? true : false
        passwordTextFieldHeightAnchor?.isActive = true
        
    }

}

// MARK: UIImagePickerControllerDelegate
extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
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
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
