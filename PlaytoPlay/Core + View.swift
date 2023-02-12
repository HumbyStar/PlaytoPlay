//
//  ConnectionCore.swift
//  PlaytoPlay
//
//  Created by Humberto Rodrigues on 16/12/22.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
