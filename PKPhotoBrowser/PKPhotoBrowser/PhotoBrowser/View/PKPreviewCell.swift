//
//  PKPreviewCell.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/26.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit

/// 预览页 整屏的cell
class PKPreviewCell: UICollectionViewCell {
    
    static let identifier: String = "PKPreviewCell"
    
    fileprivate let zoomView: PKPhotoZoomView = PKPhotoZoomView()
    typealias OneTapClick = () -> Void
    var oneTapClick: OneTapClick?
    // 图片设置
    var photoImage: UIImage? {
        didSet {
            self.zoomView.image = photoImage
        }
    }
    var representedAssetIdentifier: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.zoomView.frame = self.bounds
        self.zoomView.tapDelegate = self
        self.addSubview(self.zoomView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PKPreviewCell: PKPhotoZoomViewDelegate {
    func zoomViewOneTapClick() {
        self.oneTapClick?()
    }
}
