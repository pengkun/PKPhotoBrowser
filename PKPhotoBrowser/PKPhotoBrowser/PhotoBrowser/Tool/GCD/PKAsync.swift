//
//  PKAsync.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/23.
//  Copyright © 2018 pengkun. All rights reserved.
//

import Foundation


let serialQueue = DispatchQueue(label: "com.PKPhotoBrowser.serial")

struct PKAsync {
    static func async(serial: Bool = false, closure: @escaping () -> Void) {
        let queue = serial ? serialQueue : DispatchQueue.global()
        queue.async(execute: closure)
    }

    static func main(_ closure: @escaping () -> ()) {
        DispatchQueue.main.async(execute: closure)
    }

    static func after(_ timeInterval: TimeInterval, closure: @escaping () -> ()) {
        let delayTime = DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: closure)
    }
}
