//
//  PKPreviewBottomView.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/26.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit
import Photos

protocol PKPreviewBottomViewDelegate: class  {
    func previewDoneDidClick()
}

/// 预览页底部视图
class PKPreviewBottomView: UIView {

    //MARK: - ui
    fileprivate var photoCollectionView: UICollectionView!
    fileprivate let line: UIView = UIView()
    fileprivate let doneBtn: UIButton = UIButton()
    //MARK: - property
    weak var delegate: PKPreviewBottomViewDelegate?
    fileprivate var thumbnailSize: CGSize!
    /// 选中的assets
    var selectAssetsModel: PKSelectPhotosModel? {
        didSet {
            self.selectModelDidSet()
        }
    }
    /// 第一次进入 或者 最新添加的
    var newAsset: PHAsset?
    /// 固定layout的宽
    fileprivate let layoutWidth = 55
    /// 当前选中的item
    fileprivate var curSelectItem: Int = 0
    
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
        return CGSize(width: kPKScreenWidth, height: 125)
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
        self.thumbnailSize = CGSize(width: cellSize.width * scale * 2, height: cellSize.height * scale * 2)
        
        self.photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.photoCollectionView.backgroundColor = UIColor.clear
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        self.photoCollectionView.register(UINib(nibName: "PKPhotoCollectionCell", bundle: nil), forCellWithReuseIdentifier: PKPhotoCollectionCell.identifier)
        self.addSubview(self.photoCollectionView)
        
        self.line.backgroundColor = configuration.lineColor
        self.addSubview(self.line)
        
        self.doneBtn.setBackgroundImage(configuration.btnSelBackgroundColor.pkext_image, for: .normal)
        self.doneBtn.setBackgroundImage(configuration.btnSelBackgroundColor.withAlphaComponent(0.6).pkext_image, for: .disabled)
        self.doneBtn.setTitleColor(UIColor.white, for: .normal)
        self.doneBtn.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .disabled)
        self.doneBtn.setTitle("完成", for: .disabled)
        self.doneBtn.layer.cornerRadius = 5
        self.doneBtn.layer.masksToBounds = true
        self.doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.doneBtn.addTarget(self, action: #selector(doneBtnDidClick), for: .touchUpInside)
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
            make.right.equalTo(self.snp.right).offset(-15)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
    }
}

extension PKPreviewBottomView {
    func selectModelDidSet() {
        if let new = self.newAsset, let index = self.selectAssetsModel?.selectAssets.index(of: new) {
            self.curSelectItem = index
        }
        
        self.updateDoneStatus()
        self.photoCollectionView.reloadData()
    }
    
    func insertAsset(asset: PHAsset) {
        if let model = self.selectAssetsModel {
            self.updateDoneStatus()
            self.photoCollectionView.insertItems(at: [IndexPath(item: model.selectAssets.count-1, section: 0)])
        }
    }
    
    func deleteItem(item: Int) {
        self.updateDoneStatus()
        self.photoCollectionView.deleteItems(at: [IndexPath(item: item, section: 0)])
        self.curSelectItem = 0
    }
    
    func scrollToItem(asset: PHAsset) {
        if let index = self.selectAssetsModel?.selectAssets.index(of: asset) {
            let preCell = self.photoCollectionView.cellForItem(at: IndexPath(item: self.curSelectItem, section: 0))
            preCell?.contentView.layer.borderWidth = 0
            
            self.curSelectItem = index
            
            let cell = self.photoCollectionView.cellForItem(at: IndexPath(item: self.curSelectItem, section: 0))
            cell?.contentView.layer.borderColor = PKConfiguration.shared.btnSelBackgroundColor.cgColor
            cell?.contentView.layer.borderWidth = 3
        }
        else {
            let preCell = self.photoCollectionView.cellForItem(at: IndexPath(item: self.curSelectItem, section: 0))
            preCell?.contentView.layer.borderWidth = 0
        }
    }
    
    func updateDoneStatus() {
        if let count = self.selectAssetsModel?.selectAssets.count {
            self.doneBtn.isEnabled = count != 0
            self.doneBtn.setTitle("完成(\(count))", for: .normal)
        }
    }
    
    @objc func doneBtnDidClick() {
        self.delegate?.previewDoneDidClick()
    }
}

// MARK: - UICollectionViewDataSource
extension PKPreviewBottomView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectAssetsModel?.selectAssets.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PKPhotoCollectionCell.identifier, for: indexPath) as! PKPhotoCollectionCell
        cell.selectBtn.isHidden = true
        
        if let asset = self.selectAssetsModel?.selectAssets[indexPath.item] {
            if self.newAsset != nil && self.newAsset?.localIdentifier == asset.localIdentifier {
                cell.contentView.layer.borderColor = PKConfiguration.shared.btnSelBackgroundColor.cgColor
                cell.contentView.layer.borderWidth = 3
                self.newAsset = nil
            }
            cell.representedAssetIdentifier = asset.localIdentifier
            
            if asset.editedImage == nil {
                PKImageManager.shared.getThumbnailImage(asset: asset, thumbnailSize: self.thumbnailSize, completion: { (image) in
                    if cell.representedAssetIdentifier == asset.localIdentifier {
                        cell.thumbnailImage = image
                    }
                })
            }
            else {
                cell.thumbnailImage = asset.editedImage
            }
            
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension PKPreviewBottomView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
