//
//  ViewController.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/23.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, PKAlbumNavViewControllerDelegate {

    let addGridView: PKAddPhotoGridView = PKAddPhotoGridView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.addGridView.delegate = self
        self.view.addSubview(self.addGridView)
        
        self.addGridView.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.right.equalTo(self.view.snp.right).offset(-25)
            make.top.equalTo(100)
        }
        
    }
    
    @IBAction func albumDidClick(_ sender: Any) {
        let nav = PKAlbumNavViewController(delegate: self)
        self.navigationController?.present(nav, animated: true , completion: nil)
    }
    
    func albumController(didFinishPickingPhotos photos: [UIImage]) {
        debugPrint("photos = \(photos.count)")
        self.addGridView.addImages(imgs: photos)
    }
}

extension ViewController: PKAddPhotoGridViewDelegate {
    func addGridViewAddDidSelect() {
        let nav = PKAlbumNavViewController(delegate: self)
        self.navigationController?.present(nav, animated: true , completion: nil)
    }
    
    func addGridView(didSelect item: Int, images: [UIImage]) {
        let previewVC = PKPreviewDeleteController()
        previewVC.gridSelectItem = item
        previewVC.images = images
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
}

