//
//  PKAssetGridViewController.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/24.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit
import Photos

class PKAssetGridViewController: PKBaseViewController {

    //MARK: - ui
    fileprivate var photoCollectionView: UICollectionView!
    //MARK: - property
    var fetchResult: PHFetchResult<PHAsset>!
    fileprivate var thumbnailSize: CGSize!
    /// 选中的asset
    fileprivate var selectAssets: [PHAsset] = []
    
    deinit {
        debugPrint("\(type(of:self)) deinit")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UI初始化
private extension PKAssetGridViewController {
    func setup() {
        self.initDatas()
        self.setupViews()
        self.setupConstraints()
    }
    
    func setupViews() {
        self.navigationItem.title = self.navigationItem.title ?? "相机胶卷"
        
        let flowLayout = UICollectionViewFlowLayout()
        let shape: CGFloat = 5
        let layoutWidth = (kPKScreenWidth-shape*5)/4
        flowLayout.itemSize = CGSize(width: layoutWidth, height: layoutWidth)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = shape
        flowLayout.minimumInteritemSpacing = shape
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: shape, bottom: 0, right: shape)
        
        let scale = UIScreen.main.scale
        let cellSize = flowLayout.itemSize
        self.thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        
        self.photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.photoCollectionView.backgroundColor = UIColor.white
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        self.photoCollectionView.register(UINib(nibName: "PKPhotoCollectionCell", bundle: nil), forCellWithReuseIdentifier: PKPhotoCollectionCell.identifier)
        self.view.addSubview(self.photoCollectionView)
        
//        self.photoCollectionView.scrollToItem(at: IndexPath(item: self.fetchResult.count, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: false)
    }
    
    func setupConstraints() {
        self.photoCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: kPKViewTopOffset, left: 0, bottom: 0, right: 0))
        }
    }
    
    func initDatas() {
        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PKAssetGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PKPhotoCollectionCell.identifier, for: indexPath) as! PKPhotoCollectionCell

        let asset = self.fetchResult.object(at: indexPath.item)
        cell.item = indexPath.item
        cell.delegate = self
        cell.representedAssetIdentifier = asset.localIdentifier
        cell.number = self.selectAssets.index(of: asset)
        PKImageManager.shared.getThumbnailImage(asset: asset, thumbnailSize: self.thumbnailSize, completion: { (image) in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension PKAssetGridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension PKAssetGridViewController: PKPhotoCollectionCellDelegate {
    func collectionCell(_ cell: PKPhotoCollectionCell, didSelectItemAt item: Int) {
        let maxCount = PKConfiguration.shared.selectMaxCount
        if self.selectAssets.count >= maxCount {
            let alertVC = UIAlertController(title: "你最多选择\(maxCount)照片", message: nil, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        let asset = self.fetchResult.object(at: item)
        self.selectAssets.append(asset)
        self.photoCollectionView.reloadData()
    }
    
    func collectionCell(_ cell: PKPhotoCollectionCell, didDeselectItemAt item: Int) {
        let asset = self.fetchResult.object(at: item)
        if let index = self.selectAssets.index(of: asset) {
            self.selectAssets.remove(at: index)
        }
        self.photoCollectionView.reloadData()
    }
}
