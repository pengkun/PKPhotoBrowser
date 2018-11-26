//
//  Constants.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/23.
//  Copyright © 2018 pengkun. All rights reserved.
//

import Foundation
import UIKit

let kPKScreenWidth: CGFloat = UIScreen.main.bounds.width
let kPKScreenHeight: CGFloat = UIScreen.main.bounds.height

/// 状态条的高度
func pkStatusBarHeight() -> CGFloat {
    var height: CGFloat = 0
    if #available(iOS 11.0, *) {
        // iPhoneX
        if abs(UIScreen.main.bounds.size.height - CGFloat(812)) < CGFloat.leastNormalMagnitude {
            height = 44
        } else {
            height = 20
        }
    } else {
        height = 20
    }
    return height
}
/// 导航条高度
let kPKNavigationBarHeight: CGFloat = 44
/// 画面中视图的起始位置 适配iPhone X
let kPKViewTopOffset = pkStatusBarHeight() + kPKNavigationBarHeight

/// 系统导航条的高度
let kPKStatusBarHeight = pkStatusBarHeight()

/// tabbar的高度
func pkTabBarHeight() -> CGFloat {
    var height: CGFloat = 0
    if #available(iOS 11.0, *) {
        // iPhoneX
        if abs(UIScreen.main.bounds.size.height - CGFloat(812)) < CGFloat.leastNormalMagnitude {
            height = 83
        } else {
            height = 49
        }
    } else {
        height = 49
    }
    return height
}
let kPKTabBarHeight: CGFloat = pkTabBarHeight()
/// iphoneX 的 homeIdicator(下面的 home 键代替品) 的高度 如果没有 homeIdicator 则 为 0
let kPKHomeIdicatorHeight: CGFloat = kPKTabBarHeight == 49 ? 0 : 16
