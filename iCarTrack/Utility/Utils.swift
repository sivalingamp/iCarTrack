//
//  Utils.swift
//  iCarTrack
//
//  Created by siva lingam on 16/5/21.
//

import Foundation
import UIKit

class Utils {
    
    static func displayAlert(title: String, message: String, in vc:UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
