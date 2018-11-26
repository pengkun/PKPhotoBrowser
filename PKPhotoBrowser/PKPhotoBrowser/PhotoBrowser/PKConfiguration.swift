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
    
    /// 最多选中数量
    let selectMaxCount: Int = 9
    /// 已经选中的数量
    var selectedCount: Int = 0
    
    //MARK: - NavBar
    let navBarBackgroundColor: UIColor = UIColor.pkext_rgba(49, 49, 49)
    let navTitleFont: UIFont = UIFont.systemFont(ofSize: 17)
    let navBackBtnImage: UIImage? = UIImage(named: "back")
    
    //MARK: - PKPhotoCollectionCell
    /// 右上按钮
    /// 选中时的背景色
    let btnSelBackgroundColor: UIColor = UIColor.pkext_rgba(42, 127, 249)
    /// 未选中时背景图片
    let btnUnSelBgImage: UIImage? = UIImage(named: "btn_unselected")
}
