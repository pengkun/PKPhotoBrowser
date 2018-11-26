//
//  PKPhotoCollectionCell.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/24.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit

class PKPhotoCollectionCell: UICollectionViewCell {
    static let identifier: String = "PKPhotoCollectionCell"
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var selectBtn: UIButton!
    
    var representedAssetIdentifier: String!
    var thumbnailImage: UIImage! {
        didSet {
            self.imgView.image = thumbnailImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func selectBtnDidClick(_ sender: UIButton) {
    }
}
