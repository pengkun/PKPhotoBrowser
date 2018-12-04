//
//  PKImageManager.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/23.
//  Copyright © 2018 pengkun. All rights reserved.
//

import Foundation
import Photos

class PKImageManager: PHCachingImageManager {
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
    
    func getPreviewImage(asset: PHAsset, targetSize: CGSize, progressHandler: PHAssetImageProgressHandler?, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        _ = self.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, dic) in
            completion(image)
        }
    }
    
    func getOriginImage(asset: PHAsset, progressHandler: PHAssetImageProgressHandler?, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.resizeMode = .none
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = progressHandler
        
        _ = self.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (image, dic) in
            completion(image)
        }
    }
}
