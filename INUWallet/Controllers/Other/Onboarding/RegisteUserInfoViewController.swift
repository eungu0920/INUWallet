//
//  RegisteUserInfoViewController.swift
//  INUWallet
//
//  Created by Gray on 2023/03/17.
//

import UIKit

class RegisteUserInfoViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var studentIDTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var gradeTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
//    @IBOutlet weak var pickerView: UIPickerView!
    
    let pickerView = UIPickerView()
    let list = DepartmentsData.list
    var firstPickerRow: Int = 0
    var major: (college: String?, department: String?)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        nameTextField.layer.cornerRadius = 8.0
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        nameTextField.leftViewMode = .always
        nameTextField.borderStyle = .none
        nameTextField.autocorrectionType = .no
        
        studentIDTextField.layer.borderWidth = 1.0
        studentIDTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        studentIDTextField.layer.cornerRadius = 8.0
        studentIDTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        studentIDTextField.leftViewMode = .always
        studentIDTextField.borderStyle = .none
        studentIDTextField.autocorrectionType = .no
        
        departmentTextField.layer.borderWidth = 1.0
        departmentTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        departmentTextField.layer.cornerRadius = 8.0
        departmentTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        departmentTextField.leftViewMode = .always
        departmentTextField.borderStyle = .none
        departmentTextField.autocorrectionType = .no
        
        majorTextField.layer.borderWidth = 1.0
        majorTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        majorTextField.layer.cornerRadius = 8.0
        majorTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        majorTextField.leftViewMode = .always
        majorTextField.borderStyle = .none
        majorTextField.autocorrectionType = .no
        
        gradeTextField.layer.borderWidth = 1.0
        gradeTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        gradeTextField.layer.cornerRadius = 8.0
        gradeTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        gradeTextField.leftViewMode = .always
        gradeTextField.borderStyle = .none
        gradeTextField.autocorrectionType = .no
        
        doneButton.layer.cornerRadius = 8.0
        
        configPickerView()
    }
    
    @IBAction func didTapButton(_ sender: Any) {
        DatabaseManager.shared.insertUserInfo(name: nameTextField.text!, studentID: studentIDTextField.text!, department: departmentTextField.text!, major: majorTextField.text!, grade: gradeTextField.text!)
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateWalletViewController") else { return }
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
}

extension RegisteUserInfoViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func configPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        departmentTextField.tintColor = .clear
        majorTextField.tintColor = .clear
        
        departmentTextField.inputView = pickerView
        majorTextField.inputView = pickerView
        
        configToolBar()
    }
    
    func configToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.secondaryLabel
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePickerView))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPickerView))
        
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        departmentTextField.inputAccessoryView = toolBar
        majorTextField.inputAccessoryView = toolBar
    }
    
    @objc func donePickerView() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        let secondeRow = self.pickerView.selectedRow(inComponent: 1)
        
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        self.departmentTextField.text = self.list[row].college.rawValue
        self.majorTextField.text = self.list[row].department[secondeRow]
        self.departmentTextField.resignFirstResponder()
        self.majorTextField.resignFirstResponder()
    }
    
    @objc func cancelPickerView() {
        self.departmentTextField.text = nil
        self.majorTextField.text = nil
        self.departmentTextField.resignFirstResponder()
        self.majorTextField.resignFirstResponder()
    }
    
    // PickerView 안에 몇 개의 선택 가능한 리스트를 표시할 것인지.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // PickerView에 표시될 항목의 개수를 반환
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return list.count
        case 1:
            return list[firstPickerRow].department.count
        default:
            return 0
        }
    }
    
    // PickerView 내에서 특정한 위치(row)를 가리키게 될 때, 그 위치에 해당하는 문자열을 반환
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.pickerView {
            switch component {
            case 0:
                return list[row].college.rawValue
            case 1:
                return list[firstPickerRow].department[row]
            default:
                return nil
            }
        } else {
            return "-"
        }
    }
    
    // PickerView에서 특정 row가 focus되었을 때 어떤 행동을 할지 정의하는 메소드
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            firstPickerRow = row
            let selectedItem = list[firstPickerRow]
            let college = selectedItem.college.rawValue
            major = (college, nil)
            self.pickerView.reloadAllComponents()
        case 1:
            let selectedItem = list[firstPickerRow]
            major.department = selectedItem.department[row]
        default:
            return
        }
        
        departmentTextField.text = "\(major.college ?? "")"
        majorTextField.text = "\(major.department ?? "")"
    }
    
    
}
