//
//  Network Requester .swift
//  Encreez App
//
//  Created by Razy Tech on 1/13/19.
//  Copyright © 2019 Razy Tech. All rights reserved.
//

import Foundation
import UIKit



struct Global  {
    
    static let baseUrl = "https://encreezapi.azurewebsites.net"
    
    static var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    static func FixIpadActionsheet(alert:UIAlertController,controller:UIViewController){
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = controller.view
            popoverController.sourceRect = CGRect(x: controller.view.bounds.midX, y: controller.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
    }

    
    
    
    static func loadIndicator(view : UIView)
    {
        indicator.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        indicator.center = view.center
        indicator.color = UIColor(red: 93/255, green: 188/255, blue: 210/255 , alpha: 1.0)
        view.addSubview(indicator)
        view.bringSubview(toFront: indicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

      indicator.startAnimating()
    }
    
    static func stopIndicator()
    {
        indicator.stopAnimating()
    }
    
    static func anyColor() -> UIColor {
        return UIColor(red: 93/255, green: 188/255, blue: 210/255 , alpha: 1.0)
    }

    
}
