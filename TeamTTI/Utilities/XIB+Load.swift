//
//  XIB+Load.swift
//  TeamTTI
//
//  Created by Deepak Sharma on 27.11.18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import Foundation

/*view and class name should be same*/
protocol XibInstance: class {}

extension XibInstance {
    
    static func instanceFromNib<T>(withOwner: Any? = nil, options: [AnyHashable : Any]? = nil) -> T where T: UIView {
        let bundle = Bundle(for: self)
        let nib = UINib(nibName: "\(self)", bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: withOwner, options: options)[0] as? T else {
            
            fatalError("could not load view from nib file.")
        }
        return view
    }
}
