//
//  AllEmployee.swift
//  CrudOperationOnMlabSwift
//
//  Created by Mausam on 1/12/17.
//  Copyright © 2017 Mausam. All rights reserved.
//

import Foundation
import CoreData


struct AllEmployeeStruct<T> {
    var array: [T] = []
    
    mutating func append(newElement: T) {
        saveIt(element:newElement)
        self.array.append(newElement)
        print("Element added")
    }
    
    mutating func removeAtIndex(index: Int) {
        print("Removed object \(self.array[index]) at index \(index)")
        removeIt(element: self.array[index])
        self.array.remove(at: index)
    }
    
    mutating func removeAll() {
        print("Removed all")
        removeAllData()
        if self.array.count > 0{
        self.array.removeAll()
        }
        //removeIt(element:)
    }
    
    mutating func getObject(i:Int)->T{
        return array[i]
    }
    
    mutating func setObject(obj:T, index i:Int){
        updateIt(element: obj)
        array[i] = obj
    }
    
    mutating func count()->Int{
        return self.array.count
    }
    
    mutating func getAll(){
        if array.count > 0 {
            self.array.removeAll()
        }
        do {
            let result = try context.fetch(EmployeeData.fetchRequest())
            for empData in result as! [EmployeeData]{
                let tmpnumber = Int(empData.contactNumber)
                let tmpsalary = Int(empData.salary)
                
                let emp = Employee(name: empData.name as String!, contactNumber: tmpnumber, salary:tmpsalary, designation:empData.designation as String!)
                let tempDict = ["id":empData.id ?? "","object":emp] as [String : Any]
                self.array.append(tempDict as! T)
            }
            
        } catch  {
            print(error)
        }
    }
    
    func encodeIt(element:T)->T{
        return element
    }
    
    func decodeIt(element:T)->T{
        return element
    }
    
    func saveIt(element:T){
        let emp = EmployeeData(context:context)
        if let tempDict = element as? Dictionary<String, AnyObject>{
            emp.id = tempDict["id"] as! String?
            if let tempEmployee = tempDict["object"] as? Employee{
                emp.name = tempEmployee.name
                emp.contactNumber = Int64(tempEmployee.contactNumber)
                emp.salary = Int64(tempEmployee.salary)
                emp.designation = tempEmployee.designation
                appDelegate.saveContext()
            }
        }
    }
    
    func updateIt(element:T){
        if let tempDict = element as? Dictionary<String, AnyObject>{
            let id = tempDict["id"] as! String
            let fetchRequest: NSFetchRequest<EmployeeData> = EmployeeData.fetchRequest()
            fetchRequest.predicate = NSPredicate.init(format: "id== %@",id)
            if let result = try? context.fetch(fetchRequest) {
                for object in result {
                    if let tempEmployee = tempDict["object"] as? Employee{
                        object.name = tempEmployee.name
                        object.contactNumber = Int64(tempEmployee.contactNumber)
                        object.salary = Int64(tempEmployee.salary)
                        object.designation = tempEmployee.designation
                        appDelegate.saveContext()
                    }
                }
            }
        }
    }
    
    func removeIt(element:T){
        if let tempDict = element as? Dictionary<String, AnyObject>{
            let id = tempDict["id"] as! String
            let fetchRequest: NSFetchRequest<EmployeeData> = EmployeeData.fetchRequest()
            fetchRequest.predicate = NSPredicate.init(format: "id== %@",id)
            if let result = try? context.fetch(fetchRequest) {
                for object in result {
                    context.delete(object)
                    appDelegate.saveContext()
                }
            }
        }
    }
    
    func removeAllData() {
        do {
            let result = try context.fetch(EmployeeData.fetchRequest())
            for empData in result as! [EmployeeData]{
                context.delete(empData)
                appDelegate.saveContext()
            }
            
        } catch  {
            print(error)
        }
    }
    
    init() {
      //  getAll()
    }
    
    subscript(index: Int) -> T {
        set {
            print("Set object from \(self.array[index]) to \(newValue) at index \(index)")
            self.array[index] = newValue
        }
        get {
            return self.array[index]
        }
    }
}
