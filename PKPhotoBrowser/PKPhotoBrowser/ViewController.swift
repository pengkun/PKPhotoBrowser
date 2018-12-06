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
        
        let configuration = PKConfiguration.shared
        configuration.selectMaxCount = 9
        
        configuration.addGridLineCount = 4
        
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
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .restricted || status == .denied {
                self.privacyAlert()
            }
            else {
                let configuration = PKConfiguration.shared
                configuration.selectedCount = self.selectModol.selectPhotos.count
                let nav = PKAlbumNavViewController(delegate: self)
                self.navigationController?.present(nav, animated: true , completion: nil)
            }
        }
    }
    
    func addGridView(didSelect item: Int) {
        let previewVC = PKPreviewDeleteController(model: self.selectModol)
        previewVC.gridSelectItem = item
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    // 提示
    func privacyAlert() {
        let vc = UIAlertController(title: "提示", message: "没有权限", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        vc.addAction(cancelAction)
        let goAction = UIAlertAction(title: "去设置", style: .default) { (_) in
            self.openAppPrivacySetting()
        }
        vc.addAction(goAction)
        self.present(vc, animated: true, completion: nil)
    }
    
    // 跳转到app隐私权限页面
    func openAppPrivacySetting() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {return}
        
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

