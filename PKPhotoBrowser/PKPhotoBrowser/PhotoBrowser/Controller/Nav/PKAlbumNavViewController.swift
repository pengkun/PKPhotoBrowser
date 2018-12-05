//
//  PKAlbumNavViewController.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/24.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit
import Photos

protocol PKAlbumNavViewControllerDelegate: class {
    func albumController(didFinishPickingPhotos photos: [UIImage])
}

class PKAlbumNavViewController: UINavigationController {

    //MARK: - ui
    fileprivate let assetGridVC = PKAssetGridViewController()
    //MARK: - property
    
    deinit {
        debugPrint("\(type(of:self)) deinit")
    }
    
    required init(delegate: PKAlbumNavViewControllerDelegate) {
        let listVC = PKAlbumListController()
        listVC.pickDelegate = delegate
        super.init(rootViewController: listVC)
        
        self.assetGridVC.pickDelegate = delegate
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

