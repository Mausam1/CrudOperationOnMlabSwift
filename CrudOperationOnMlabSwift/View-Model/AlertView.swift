//
//  AlertView.swift
//  CrudOperationOnMlabSwift
//
//  Created by Mausam on 12/22/16.
//  Copyright © 2016 Mausam. All rights reserved.
//

import Foundation
import UIKit

func createAlertWithOnlyOkay(title:String?, msg:String, style:UIAlertControllerStyle, callBackSelf:UIViewController) -> UIAlertController {
    let alertController = UIAlertController(title: title, message: msg, preferredStyle: style)
    
    let cancelAction = UIAlertAction(title: "Okay", style: .cancel) { action in
        callBackSelf.dismiss(animated: true, completion: {
            
        })
    }
    alertController.addAction(cancelAction)
    return alertController
}

