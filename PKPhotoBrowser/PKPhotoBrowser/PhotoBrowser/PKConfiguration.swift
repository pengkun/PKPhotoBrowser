//
//  PKConfiguration.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/26.
//  Copyright © 2018 pengkun. All rights reserved.
//

import Foundation
import UIKit

class PKConfiguration {
    static let shared: PKConfiguration = PKConfiguration()
    private init() { }
    
    /// 最多选中数量
    let selectMaxCount: Int = 9
    /// 已经选中的数量
    var selectedCount: Int = 0
    
//MARK: - NavBar
    /// navbar 背景色
    let navBarBackgroundColor: UIColor = UIColor.pkext_rgba(49, 49, 49)
    /// navbar 字体
    let navTitleFont: UIFont = UIFont.systemFont(ofSize: 17)
    /// navbar 字体颜色
    let navTitleColor: UIColor = UIColor.white
    /// navbar 返回按钮图片
    let navBackBtnImage: UIImage? = UIImage(named: "back")
    /// navbar 取消按钮字体颜色
    let navDisBtnTitleColor: UIColor = UIColor.pkext_rgba(42, 127, 249)
    
//MARK: - AssetGridController 照片瀑布流
    let gridShape: CGFloat = 5
    func gridLayoutWidth() -> CGFloat {
        return (kPKScreenWidth-self.gridShape*5)/4
    }
    var thumbnailSize: CGSize {
        return CGSize(width: gridLayoutWidth() * UIScreen.main.scale, height: gridLayoutWidth() * UIScreen.main.scale)
    }
    
//MARK: - PKPhotoCollectionCell 照片瀑布流
    /// 右上按钮
    /// 选中时的背景色
    let btnSelBackgroundColor: UIColor = UIColor.pkext_rgba(42, 127, 249)
    /// 未选中时背景图片
    let btnUnSelBgImage: UIImage? = UIImage(named: "btn_unselected")
    
//MARK: - PKPreviewController 阅览页
    let previewRightBarItemSize: CGSize = CGSize(width: 30, height: 30)
    
//MARK: - PKPreviewBottomView
    /// 预览底部线的颜色
    let lineColor: UIColor = UIColor.gray
}
