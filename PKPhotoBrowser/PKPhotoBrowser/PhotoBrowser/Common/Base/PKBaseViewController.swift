//
//  PKBaseViewController.swift
//  CoinTiger
//
//  Created by pengkun on 2017/12/25.
//  Copyright © 2017年 pk. All rights reserved.
//

import UIKit
import Photos

class PKBaseViewController: UIViewController {
    
    //MARK: - ui
    fileprivate var loadingView: PKLoadingView?
    //MARK: - property
    weak var pickDelegate: PKAlbumNavViewControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
//        self.edgesForExtendedLayout = []
    }
    
    func photosHandler(assets: [PHAsset]) {
        self.loading()
        var images: [UIImage] = []
        var loadCount = assets.count
        let scale = UIScreen.main.scale
        for asset in assets {
            PKImageManager.shared.getPreviewImage(asset: asset, targetSize: CGSize(width: kPKScreenWidth*scale, height: kPKScreenHeight*scale), progressHandler: nil) {[weak self] (image) in
                if let index = assets.index(of: asset), let img = image {
                    if index <= images.count {
                        images.insert(img, at: index)
                    }
                    else {
                        images.append(img)
                    }
                }
                loadCount -= 1
                if loadCount == 0 {
                    self?.loadingHide()
                    self?.pickDelegate?.albumController(didFinishPickingPhotos: images)
                    self?.dismiss(animated: true , completion: nil)
                }
            }
        }
    }
    
    
    func loading() {
        guard self.loadingView == nil else {return}
        let loadingView = PKLoadingView.addTo(self.view)
        self.loadingView = loadingView
    }
    
    func loadingHide() {
        guard self.loadingView == nil else {return}
        self.loadingView?.removeFromSuperview()
        self.loadingView = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
