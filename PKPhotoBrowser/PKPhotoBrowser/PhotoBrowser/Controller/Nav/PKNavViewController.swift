//
//  PKNavViewController.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/24.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit

class PKNavViewController: UINavigationController {

    //MARK: - ui
    fileprivate let assetGridVC = PKAssetGridViewController()
    //MARK: - property
    /// 最多选中张数 
    var maxSelectCount: Int = 9
    
    deinit {
        debugPrint("\(type(of:self)) deinit")
    }
    
    required init() {
        let listVC = PKAlbumListController()
        super.init(rootViewController: listVC)
        
        self.pushViewController(self.assetGridVC, animated: false)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = PKConfiguration.shared
        self.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: configuration.navTitleColor]
        self.navigationBar.setBackgroundImage(configuration.navBarBackgroundColor.pkext_image, for: UIBarMetrics.default)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

