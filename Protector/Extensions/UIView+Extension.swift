//
//  UIView+Extension.swift
//  Protector
//
//  Created by BusranurOK on 29.01.2023.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        
        get { return self.cornerRadius }
        set { self.layer.cornerRadius = newValue }
        
    }
    
}
