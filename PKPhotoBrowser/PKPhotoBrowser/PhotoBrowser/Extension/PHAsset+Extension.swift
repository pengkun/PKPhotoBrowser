//
//  PHAsset+Extension.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/28.
//  Copyright © 2018 pengkun. All rights reserved.
//

import Foundation
import Photos

private var kPKEditedImageKey: Void?

extension PHAsset {
    /// 编辑后的图片
    var editedImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &kPKEditedImageKey) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &kPKEditedImageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
