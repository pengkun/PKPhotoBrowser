//
//  PKPreviewBottomView.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/26.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit
import Photos

class PKPreviewBottomView: UIView {

    //MARK: - ui
    fileprivate var photoCollectionView: UICollectionView!
    fileprivate let line: UIView = UIView()
    fileprivate let doneBtn: UIButton = UIButton()
    //MARK: - property
    fileprivate var thumbnailSize: CGSize!
    /// 选中的asset
    var selectAssets: [PHAsset] = []
    fileprivate let layoutWidth = 60
    
    deinit {
        debugPrint("\(type(of:self)) deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: kPKScreenWidth, height: 140)
    }
}

// MARK: - UI初始化
private extension PKPreviewBottomView {
    func setup() {
        self.setupViews()
        self.setupConstraints()
    }
    
    func setupViews() {
        let configuration = PKConfiguration.shared
        self.backgroundColor = configuration.navBarBackgroundColor
        
        let flowLayout = UICollectionViewFlowLayout()
        let shape: CGFloat = 10
        flowLayout.itemSize = CGSize(width: self.layoutWidth, height: self.layoutWidth)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = shape
        flowLayout.minimumInteritemSpacing = shape
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: shape, bottom: 0, right: shape)
        
        let scale = UIScreen.main.scale
        let cellSize = flowLayout.itemSize
        self.thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        
        self.photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.photoCollectionView.backgroundColor = configuration.navBarBackgroundColor
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        self.photoCollectionView.register(UINib(nibName: "PKPhotoCollectionCell", bundle: nil), forCellWithReuseIdentifier: PKPhotoCollectionCell.identifier)
        self.addSubview(self.photoCollectionView)
        
        self.line.backgroundColor = configuration.lineColor
        self.addSubview(self.line)
        
        self.doneBtn.backgroundColor = configuration.btnSelBackgroundColor
        self.doneBtn.setTitleColor(UIColor.white, for: .normal)
        self.doneBtn.layer.cornerRadius = 5
        self.doneBtn.layer.masksToBounds = true
        self.doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.addSubview(self.doneBtn)
    }
    
    func setupConstraints() {
        self.photoCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(0)
            make.right.equalTo(self.snp.right).offset(-10)
            make.height.equalTo(self.layoutWidth)
        }
        
        self.line.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.top.equalTo(self.photoCollectionView.snp.bottom).offset(15)
            make.left.right.equalTo(self)
        }
        
        self.doneBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PKPreviewBottomView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PKPhotoCollectionCell.identifier, for: indexPath) as! PKPhotoCollectionCell
        
        let asset = self.selectAssets[indexPath.item]
        cell.selectBtn.isHidden = true
        cell.representedAssetIdentifier = asset.localIdentifier
        PKImageManager.shared.getThumbnailImage(asset: asset, thumbnailSize: self.thumbnailSize, completion: { (image) in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension PKPreviewBottomView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
