//
//  PKPhotoCollectionCell.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/24.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit
import Photos

protocol PKPhotoCollectionCellDelegate: class  {
    func collectionCell(_ cell: PKPhotoCollectionCell, didSelectItemAt item: Int)
    func collectionCell(_ cell: PKPhotoCollectionCell, didDeselectItemAt item: Int)
}

class PKPhotoCollectionCell: UICollectionViewCell {
    static let identifier: String = "PKPhotoCollectionCell"
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var selectBtn: UIButton!
    
    var representedAssetIdentifier: String!
    var item: Int = 0
    var thumbnailImage: UIImage! {
        didSet {
            self.imgView.image = thumbnailImage
        }
    }
    
    var number: Int? {
        didSet {
            if let num = number {
                self.selectBtn.setTitle("\(num+1)", for: .selected)
                self.selectBtn.isSelected = true
            }
            else {
                self.selectBtn.isSelected = false
            }
        }
    }
    
    weak var delegate: PKPhotoCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let configuration = PKConfiguration.shared
        self.selectBtn.layer.cornerRadius = self.selectBtn.bounds.width/2
        self.selectBtn.layer.masksToBounds = true
        self.selectBtn.setBackgroundImage(configuration.btnUnSelBgImage, for: .normal)
        self.selectBtn.setBackgroundImage(configuration.btnSelBackgroundColor.pkext_image, for: .selected)
    }

    @IBAction func selectBtnDidClick(_ sender: UIButton) {
        if !sender.isSelected {
            self.delegate?.collectionCell(self, didSelectItemAt: self.item)
        }
        else {
            self.delegate?.collectionCell(self, didDeselectItemAt: self.item)
        }
    }
}


extension UIColor {
    var pkext_image: UIImage? {
        let onePixel = 1/UIScreen.main.scale
        return self.pkext_image(size: CGSize(width: onePixel, height: onePixel))
    }
    
    func pkext_image(size: CGSize) -> UIImage? {
        guard size.width > 0 else {return nil}
        guard size.height > 0 else {return nil}
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        self.setFill()
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    static func pkext_rgba(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
}
