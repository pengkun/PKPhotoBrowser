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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    @IBAction func albumDidClick(_ sender: Any) {
        let nav = PKAlbumNavViewController(delegate: self)
        self.navigationController?.present(nav, animated: true , completion: nil)
    }
    
    func albumController(didFinishPickingPhotos photos: [PHAsset]) {
        debugPrint("photos = \(photos.count)")
    }
}

