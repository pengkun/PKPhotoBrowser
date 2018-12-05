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
    let selectModol: PKSelectPhotosModel = PKSelectPhotosModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.addGridView.selectModel = self.selectModol
        self.addGridView.delegate = self
        self.view.addSubview(self.addGridView)
        
        self.addGridView.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.right.equalTo(self.view.snp.right).offset(-25)
            make.top.equalTo(100)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addGridView.refreshImages()
    }
    
    @IBAction func albumDidClick(_ sender: Any) {
        let nav = PKAlbumNavViewController(delegate: self)
        self.navigationController?.present(nav, animated: true , completion: nil)
    }
    
    func albumController(didFinishPickingPhotos photos: [UIImage]) {
        debugPrint("photos = \(photos.count)")
        self.selectModol.selectPhotos.append(contentsOf: photos)
        self.addGridView.refreshImages()
    }
}

extension ViewController: PKAddPhotoGridViewDelegate {
    func addGridViewAddDidSelect() {
        let nav = PKAlbumNavViewController(delegate: self)
        self.navigationController?.present(nav, animated: true , completion: nil)
    }
    
    func addGridView(didSelect item: Int) {
        let previewVC = PKPreviewDeleteController(model: self.selectModol)
        previewVC.gridSelectItem = item
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
}

