//
//  AllUsersVC.swift
//  CrudOperationOnMlabSwift
//
//  Created by Mausam on 12/17/16.
//  Copyright © 2016 Mausam. All rights reserved.
//

import UIKit

class AllUsersVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action:#selector(AllUsersVC.refreshAction(sender:)), for: UIControlEvents.valueChanged)
        self.mainTableView.addSubview(refreshControl)
        getAllTheEmployees()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
        self.title = "Emplpyees"
        let rightButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addBarButtonAction(barButton:)))
        navigationItem.rightBarButtonItem = rightButton
        mainTableView.reloadData()
    }

    func refreshAction(sender:AnyObject) {
        getAllTheEmployees()
        refreshControl.endRefreshing()
    }
    
    private func getAllTheEmployees(){
        progressBarDisplayer(allEmployeeIndicatorMsg, removing: false, superView: self.view)
        EmployeeService.getAllEmployees(baseUrlWithKey) {[weak weakSelf = self]
            (error,result,data) -> () in
            DispatchQueue.main.async {
                progressBarDisplayer("", removing: true, superView: self.view)
                if (weakSelf?.refreshControl.isRefreshing)!
                {
                    weakSelf?.refreshControl.endRefreshing()
                }
                if (error == nil && result == true){
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as! NSArray
                        allEmployees.removeAll()
                        
                        for i in 0..<jsonResult.count {
                            print(i)
                            if let dictEmployee = jsonResult.object(at: i) as? [String:Any] {
                                if let dictId = dictEmployee["_id"] as? [String:Any] {
                                    let emp = Employee(name: dictEmployee["name"] as! String!, contactNumber: dictEmployee["contactNumber"] as! Int?, salary: dictEmployee["salary"] as! Int?, designation: dictEmployee["designation"] as! String!)
                                    
                                    let tempDict = ["id":dictId["$oid"],"object":emp]
                                    allEmployees.append(newElement: tempDict as AnyObject)
                                }
                            }
                        }
                        allEmployees.getAll()
                        weakSelf?.mainTableView.reloadData()
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        self.present(createAlertWithOnlyOkay(title: "Error", msg: error.localizedDescription, style: .alert, callBackSelf: self), animated: true) {
                        }
                    }
                }
                else
                {
                    print(error?.localizedDescription ?? errorMessage)
                    allEmployees.getAll()
                    weakSelf?.mainTableView.reloadData()
                    self.present(createAlertWithOnlyOkay(title: "Error", msg: error?.localizedDescription ?? errorMessage, style: .alert, callBackSelf: self), animated: true) {
                    }
                }
            }
            
        }
    }
    
    @objc private func addBarButtonAction(barButton:UIBarButtonItem) {
        let obj = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmployeeVC") as! EmployeeVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
    // MARK: - UITableViewDelegate Methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.mainTableView.dequeueReusableCell(withIdentifier: "cell")!
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, indexPath:NSIndexPath){
        if let tmp = allEmployees[indexPath.row].value(forKey: "object") as? Employee{
            cell.textLabel?.text = tmp.name
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("id:\(allEmployees[indexPath.row].value(forKey: "id")!)")
        let obj = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmployeeVC") as! EmployeeVC
        obj.currentEmployee = allEmployees[indexPath.row].value(forKey: "object") as? Employee
        obj.employeeId = allEmployees[indexPath.row].value(forKey: "id") as? String
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            deleteEmployeeById(id: allEmployees[indexPath.row].value(forKey: "id") as! String, indexPath: indexPath, tableView: tableView)
        }
    }
    
    private func deleteEmployeeById(id:String, indexPath:IndexPath, tableView:UITableView){
        progressBarDisplayer(deleteExistingEmployeeIndicatorMsg, removing: false, superView: self.view)
        EmployeeService.deleteExistingEmployee(baseUrl, id: id, httpMethod: "DELETE") {(error, result, resultData) in
            DispatchQueue.main.async {
                progressBarDisplayer("", removing: true, superView: self.view)
                
                if (error == nil && result == true){
                    allEmployees.removeAtIndex(index: indexPath.row)
                    tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
                }
                else
                {
                    print(error?.localizedDescription ?? errorMessage)
                    self.present(createAlertWithOnlyOkay(title: "Error", msg: (error?.localizedDescription)!, style: .alert, callBackSelf: self), animated: true) {
                    }
                }
            }
            
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
