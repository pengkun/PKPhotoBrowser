//
//  PKAssetGridViewController.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/24.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit
import Photos

/// 照片瀑布流
class PKAssetGridViewController: PKBaseViewController {

    //MARK: - ui
    fileprivate var photoCollectionView: UICollectionView!
    fileprivate let bottomView: PKGridBottomView = PKGridBottomView()
    //MARK: - property
    var fetchResult: PHFetchResult<PHAsset>!
    fileprivate var thumbnailSize: CGSize!
    /// 选中的asset
    fileprivate var selectAssetsModel: PKSelectPhotosModel = PKSelectPhotosModel()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.photoCollectionView.reloadData()
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
        
        let configuration = PKConfiguration.shared
        
        let cancelItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelItemDidClick))
        cancelItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: configuration.navDisBtnTitleColor], for: .normal)
        self.navigationItem.rightBarButtonItem = cancelItem
        
        let backBtn: UIButton = UIButton()
        backBtn.setImage(configuration.navBackBtnImage, for: .normal)
        backBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        backBtn.contentHorizontalAlignment = .left
        backBtn.imageView?.contentMode = .scaleAspectFit
        backBtn.addTarget(self, action: #selector(backItemDidClick), for: .touchUpInside)
        let backItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = backItem
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: configuration.gridLayoutWidth(), height: configuration.gridLayoutWidth())
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = configuration.gridShape
        flowLayout.minimumInteritemSpacing = configuration.gridShape
        flowLayout.sectionInset = UIEdgeInsets(top: configuration.gridShape, left: configuration.gridShape, bottom: 0, right: configuration.gridShape)
        

        self.thumbnailSize = configuration.thumbnailSize
        
        self.photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.photoCollectionView.backgroundColor = UIColor.white
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        self.photoCollectionView.register(UINib(nibName: "PKPhotoCollectionCell", bundle: nil), forCellWithReuseIdentifier: PKPhotoCollectionCell.identifier)
        self.view.addSubview(self.photoCollectionView)
        
        self.bottomView.delegate = self
        self.view.addSubview(self.bottomView)
    }
    
    func setupConstraints() {
        self.photoCollectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.view)
            make.bottom.equalTo(self.bottomView.snp.top)
        }
        
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
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

// MARK: - 按钮点击事件
extension PKAssetGridViewController {
    @objc func cancelItemDidClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backItemDidClick() {
        self.navigationController?.popViewController(animated: true)
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
        cell.number = self.selectAssetsModel.selectAssets.index(of: asset)
        if self.selectAssetsModel.selectAssets.count >= PKConfiguration.shared.selectMaxCount {
            if cell.number == nil {
                cell.isBlurEffectHidden = false
            }
            else {
                cell.isBlurEffectHidden = true
            }
        }
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

        let preVC = PKPreviewController()
        preVC.fetchResult = self.fetchResult
        preVC.selectAssetsModel = self.selectAssetsModel
        preVC.gridSelectItem = indexPath.item
        self.navigationController?.pushViewController(preVC, animated: true)
    }
}

// MARK: - PKPhotoCollectionCellDelegate
extension PKAssetGridViewController: PKPhotoCollectionCellDelegate {
    func collectionCell(_ cell: PKPhotoCollectionCell, didSelectItemAt item: Int) {
        let maxCount = PKConfiguration.shared.selectMaxCount
        if self.selectAssetsModel.selectAssets.count >= maxCount {
            let alertVC = UIAlertController(title: "你最多可以选择\(maxCount)照片", message: nil, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        let asset = self.fetchResult.object(at: item)
        self.selectAssetsModel.selectAssets.append(asset)
        self.photoCollectionView.reloadData()
        
    }
    
    func collectionCell(_ cell: PKPhotoCollectionCell, didDeselectItemAt item: Int) {
        let asset = self.fetchResult.object(at: item)
        if let index = self.selectAssetsModel.selectAssets.index(of: asset) {
            self.selectAssetsModel.selectAssets.remove(at: index)
        }
        self.photoCollectionView.reloadData()
        if self.selectAssetsModel.selectAssets.count == 0 {
            
        }
    }
}

// MARK: - PKGridBottomViewDelegate
extension PKAssetGridViewController: PKGridBottomViewDelegate {
    func gridBottomViewDidClickPreview() {
        let preVC = PKPreviewController()
        preVC.selectAssetsModel = self.selectAssetsModel
        self.navigationController?.pushViewController(preVC, animated: true)
    }
}
