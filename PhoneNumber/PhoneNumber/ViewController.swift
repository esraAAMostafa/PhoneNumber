//
//  ViewController.swift
//  PhoneNumber
//
//  Created by Esraa on 12/5/18.
//  Copyright © 2018 example. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var setPhoneNumber: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var phone: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumber.delegate = self
    }
    
    @IBAction func showPhoneNumber(_ sender: UIButton) {
        setPhoneNumber.text = phoneNumber.text
    }
    
    var editingState: EditingState?

    func phoneNumberValidation(_ phoneText: String?, _ string: String, _ range: NSRange) -> (result: Bool, newString: String) {
        
        let toBeTF = (phoneText as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        let language: Language = phoneText?.prefix(1) == "1" ? .english : .arabic
        
        if phoneText == "" {
            checkEditingState(.start(string))
            if (string == "1" ||  string == "١" ) {
                return (true, "")
            } else {
                return (false, "")
            }
        } else if (phoneText?.count)! < 10 && string != "" {
            checkEditingState(.edit)
            if toBeTF.count == 10 {
                
                if allowedNumber(toBeTF, language) {
                    checkEditingState(.doneAllawed(string,range))
                } else {
                    checkEditingState(.doneNotAllawd)
                    return (false, "")
                }
            }
            return (true, toBeTF)
        } else if ((phoneText?.count)! >= 10) && (string != "") {
            checkEditingState(.editAfterDone)
            return (false, "")
        } else {
            checkEditingState(.delete)
            return (true, toBeTF)
        }
    }
    
    enum Language {
        case english
        case arabic
    }
    
    func allowedNumber(_ number: String,_ language: Language) -> Bool {
        
        let allowedCharacterSet = language == .english ? CharacterSet.init(charactersIn: "0123456789") : CharacterSet.init(charactersIn: "٠١٢٣٤٥٦٧٨٩")
        let textCharacterSet = CharacterSet.init(charactersIn: number)
        return allowedCharacterSet.isSuperset(of: textCharacterSet)
    }
    
    enum  EditingState {
        case start(String)
        case edit
        case doneAllawed(String, NSRange)
        case doneNotAllawd
        case editAfterDone
        case delete
    }
    
    func checkEditingState(_ editingState: EditingState) {
        switch  editingState {
        case .start(let string):
            if ( string == "0" || string == "٠") {
                // do nothing
            } else if !(string == "1" ||  string == "١" ) {
                print("error")
                //            self.alert(title: "Alert", message: SystemMessages.wrongPhoneNumber, actions: [("ok", .default)])
            }
            nextButton.isHidden = true
        case .edit:
            nextButton.isHidden = true
        //            mainSignup.updateState(signupState: .enterPhone)
        case .doneAllawed(let string, let range):
            nextButton.isHidden = false
        //                mainSignup.updateState(signupState: .next)
            phone = (phoneNumber.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        case .doneNotAllawd:
            print("error")
        //                    self.alert(title: "Alert", message: SystemMessages.wrongPhoneNumber, actions: [("ok", .default)])
            phoneNumber.text = ""
        case .editAfterDone:
            phoneNumber.resignFirstResponder()
        case .delete:
            nextButton.isHidden = true
            //            mainSignup.updateState(signupState: .enterPhone)

        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let(result, newString) = isValidPhone(textField, string, range)
        let(result, newString) = phoneNumberValidation(textField.text, string, range)
        if newString.count == 10 {
            textField.text = newString
            textField.resignFirstResponder()
            return false
        }
        return result
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneNumber {
            if nextButton.isHidden {
                //                mainSignup.updateState(signupState: .enterPhone)
            } else {
                //                mainSignup.updateState(signupState: .next)
            }
        }
    }
    
    
}

