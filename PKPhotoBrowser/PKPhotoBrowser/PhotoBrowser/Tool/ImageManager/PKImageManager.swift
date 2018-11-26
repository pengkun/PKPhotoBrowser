//
//  PKImageManager.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/23.
//  Copyright © 2018 pengkun. All rights reserved.
//

import Foundation
import Photos

class PKImageManager: PHImageManager {
    static let shared: PKImageManager = PKImageManager()
    
    /// 获取缩略图
    func getThumbnailImage(asset: PHAsset, thumbnailSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let option = PHImageRequestOptions()
        _ = self.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFit, options: option) { (image, dic) in
            completion(image)
        }
    }
    
    private func getThumbnailSize(originSize: CGSize) -> CGSize {
        let thumbnailWidth: CGFloat = (kPKScreenWidth - 5 * 5) / 4 * UIScreen.main.scale
        let pixelScale = CGFloat(originSize.width)/CGFloat(originSize.height)
        let thumbnailSize = CGSize(width: thumbnailWidth, height: thumbnailWidth/pixelScale)
        
        return thumbnailSize
    }
    
    func getOriginImage(asset: PHAsset, progressHandler: PHAssetImageProgressHandler?, completion: @escaping (UIImage?) -> Void) {
        let option = PHImageRequestOptions()
        option.resizeMode = .none
        option.deliveryMode = .highQualityFormat
        option.isNetworkAccessAllowed = true
        option.progressHandler = progressHandler
        
        _ = self.requestImage(for: asset, targetSize: CGSize(), contentMode: .aspectFit, options: option) { (image, dic) in
            completion(image)
        }
    }
}
