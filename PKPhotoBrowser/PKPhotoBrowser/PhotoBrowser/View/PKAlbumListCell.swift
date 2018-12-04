//
//  PKAlbumListCell.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/23.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit
import Photos

/// 相册列表 cell
class PKAlbumListCell: UITableViewCell {
    static let identifier: String = "PKAlbumListCell"
    static let cellHeight: CGFloat = 60
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    
    var data: (assetCollection: PHAssetCollection, assetsFetchResult: PHFetchResult<PHAsset>)? {
        didSet {
            self.dataDidSet()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func dataDidSet() {
        if let asset = data?.assetsFetchResult.lastObject {
            PKImageManager.shared.getThumbnailImage(asset: asset, thumbnailSize: CGSize(width: 200, height: 200), completion: { (image) in
                self.imgView.image = image
            })
            self.numLabel.text = "(\(data?.assetsFetchResult.count ?? 0))"
        }
        self.titleLabel.text = data?.assetCollection.localizedTitle
            }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
