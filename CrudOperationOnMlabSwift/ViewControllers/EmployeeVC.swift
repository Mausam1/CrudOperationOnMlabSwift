//
//  EmployeeVC.swift
//  CrudOperationOnMlabSwift
//
//  Created by Mausam on 12/18/16.
//  Copyright © 2016 Mausam. All rights reserved.
//

import UIKit

class EmployeeVC: UIViewController,UITextFieldDelegate {
    var currentEmployee:Employee?
    var employeeId:String?
    var saveBarButton:UIBarButtonItem?
    
    @IBOutlet weak var txtfName: UITextField!
    
    @IBOutlet weak var txtfContactNumber: UITextField!
    
    @IBOutlet weak var txtfSalary: UITextField!
    
    @IBOutlet weak var txtfDesignation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveBarButtonAction(barButton:)))
        navigationItem.rightBarButtonItem = saveBarButton
        
        if let temp = currentEmployee{
            setUpExistingEmplyeeDetails(employee: temp)
        }
        else{
            self.title = "New Employee"
        }
        saveBarButton?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //  self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.blue
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
    }
    
    func setUpExistingEmplyeeDetails(employee:Employee) {
        print(employee.name)
        self.title = employee.name
        txtfName.text = employee.name
        txtfContactNumber.text = String(employee.contactNumber ?? 0)
        txtfSalary.text = String(employee.salary ?? 0)
        txtfDesignation.text = employee.designation
    }
    
    func saveBarButtonAction(barButton:UIBarButtonItem) {
        
        if let _ = currentEmployee, let tempId = employeeId{
            progressBarDisplayer(updateExistingEmployeeIndicatorMsg, removing: false, superView: self.view)
            let emp = Employee(name: txtfName.text, contactNumber: Int(txtfContactNumber.text!), salary: Int(txtfSalary.text!), designation: txtfDesignation.text)
            EmployeeService.updateExistingEmployee(baseUrl, id: tempId, employee:emp, httpMethod: "PUT", getBack: { [weak weakSelf = self] (error, result, resultData) in
                DispatchQueue.main.async {
                    progressBarDisplayer("", removing: true, superView: self.view)
                
                if (error == nil && result == true){
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: resultData!, options: []) as! NSDictionary
                        print(jsonResult)
                        if let dictId = jsonResult["_id"] as? [String:Any] {
                            let emp = Employee(name: jsonResult["name"] as! String!, contactNumber: jsonResult["contactNumber"] as! Int?, salary: jsonResult["salary"] as! Int?, designation: jsonResult["designation"] as! String!)
                            
                            for i in (0..<allEmployees.array.count){
                                if allEmployees[i].value(forKey: "id") as! String == (weakSelf?.employeeId!)! as String{
                                    let tempDict = ["id":dictId["$oid"],"object":emp]
                                    allEmployees.setObject(obj: tempDict as AnyObject, index: i)
                                    //allEmployees[i] = tempDict as AnyObject
                                    break
                                }
                            }
                        }
                            _ = weakSelf?.navigationController?.popViewController(animated: true)
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                            self.present(createAlertWithOnlyOkay(title: "Error", msg: error.localizedDescription, style: .alert, callBackSelf: self), animated: true) {
                            }
                    }
                }
                else
                {
                    print(error?.localizedDescription ?? errorMessage)
                        self.present(createAlertWithOnlyOkay(title: "Error", msg: (error?.localizedDescription ?? errorMessage), style: .alert, callBackSelf: self), animated: true) {
                        }
                }
                }
            })
        }
        else{
            progressBarDisplayer(createNewEmployeeIndicatorMsg, removing: false, superView: self.view)
            let emp1 = Employee(name: txtfName.text, contactNumber: Int(txtfContactNumber.text!), salary: Int(txtfSalary.text!), designation: txtfDesignation.text)
            EmployeeService.createNewEmployee(baseUrlWithKey, employee: emp1, httpMethod: "POST") { [weak weakSelf = self] (error, result, resultData) -> () in
                DispatchQueue.main.async {
                    progressBarDisplayer("", removing: true, superView: self.view)
                }
                
                if (error == nil && result == true){
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: resultData!, options: []) as! NSDictionary
                        print(jsonResult)
                        if let dictId = jsonResult["_id"] as? [String:Any] {
                            let emp = Employee(name: jsonResult["name"] as! String!, contactNumber: jsonResult["contactNumber"] as! Int?, salary: jsonResult["salary"] as! Int?, designation: jsonResult["designation"] as! String!)
                            
                            let tempDict = ["id":dictId["$oid"],"object":emp]
                            allEmployees.append(newElement: tempDict as AnyObject)
                        }
                        DispatchQueue.main.async {
                            _ = weakSelf?.navigationController?.popViewController(animated: true)
                        }
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            self.present(createAlertWithOnlyOkay(title: "Error", msg: error.localizedDescription, style: .alert, callBackSelf: self), animated: true) {
                            }
                        }
                    }
                }
                else
                {
                    print(error?.localizedDescription ?? errorMessage)
                    DispatchQueue.main.async {
                        self.present(createAlertWithOnlyOkay(title: "Error", msg: error?.localizedDescription ?? errorMessage, style: .alert, callBackSelf: self), animated: true) {
                        }
                    }
                }
            }
        }
    }
    
    // Mark: - textfield delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            txtfContactNumber.becomeFirstResponder()
        case 2:
            txtfSalary.becomeFirstResponder()
        case 3:
            txtfDesignation.becomeFirstResponder()
        case 4:
            txtfDesignation.resignFirstResponder()
            
        default:
            textField.resignFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender.tag == 1 {
            self.title = sender.text
        }
        
        guard txtfName.text != "" && txtfContactNumber.text != ""  && txtfSalary.text != "" && txtfDesignation.text != "" else {
            saveBarButton?.isEnabled = false
            return
        }
        
        saveBarButton?.isEnabled = true
        
        if let temp = currentEmployee{
            
            guard  temp.name != txtfName.text || String(temp.contactNumber) != txtfContactNumber.text || String(temp.salary) != txtfSalary.text || temp.designation != txtfDesignation.text else {
                saveBarButton?.isEnabled = false
                return
            }
            saveBarButton?.isEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
