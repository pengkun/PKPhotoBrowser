//
//  PKPreviewController.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/26.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit
import Photos

class PKPreviewController: UIViewController {

    //MARK: - ui
    fileprivate let navigationBar: PKNavigationBarView = PKNavigationBarView()
    fileprivate var photoCollectionView: UICollectionView!
    fileprivate let bottomView: PKPreviewBottomView = PKPreviewBottomView()
    fileprivate let rightBtn: UIButton = UIButton()
    fileprivate let flowLayout = UICollectionViewFlowLayout()
    //MARK: - property
    /// 选中的照片集合
    var selectAssetsModel: PKSelectPhotosModel?
    /// 只预览选中的照片时，只操作selectAssetsModel里的对象，selectAssets只用来显示
    fileprivate var selectAssets: [PHAsset] = []
    /// 所有照片集合
    var fetchResult: PHFetchResult<PHAsset>?
    /// 上一级选中的item(根据fetchResult不为空)
    var gridSelectItem: Int?
    
    deinit {
        debugPrint("\(type(of:self)) deinit")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = false
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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let item = self.gridSelectItem {
            self.photoCollectionView.setContentOffset(CGPoint(x: self.flowLayout.itemSize.width*CGFloat(item), y: 0), animated: false)
            self.gridSelectItem = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UI初始化
private extension PKPreviewController {
    func setup() {
        self.setupViews()
        self.setupConstraints()
        self.updateBottomSelectStatus()
    }
    
    func setupViews() {
        self.automaticallyAdjustsScrollViewInsets = false

        let shape: CGFloat = 0
        self.flowLayout.itemSize = CGSize(width: kPKScreenWidth, height: kPKScreenHeight)
        self.flowLayout.scrollDirection = .horizontal
        self.flowLayout.minimumLineSpacing = shape
        self.flowLayout.minimumInteritemSpacing = shape
        self.flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        self.photoCollectionView.backgroundColor = UIColor.black
        self.photoCollectionView.dataSource = self
        self.photoCollectionView.delegate = self
        self.photoCollectionView.isPagingEnabled = true
        self.photoCollectionView.register(PKPreviewCell.self, forCellWithReuseIdentifier: PKPreviewCell.identifier)
        self.view.addSubview(self.photoCollectionView)
        
        self.navigationBar.backButtonClickBlock = { [weak self] in
            _ = self?.navigationController?.popViewController(animated: true)
        }
        self.view.addSubview(self.navigationBar)

        let configuration = PKConfiguration.shared
        self.rightBtn.bounds.size = configuration.previewRightBarItemSize
        self.rightBtn.setTitleColor(UIColor.white, for: .normal)
        self.rightBtn.layer.cornerRadius = self.rightBtn.bounds.width/2
        self.rightBtn.layer.masksToBounds = true
        self.rightBtn.setBackgroundImage(configuration.btnUnSelBgImage, for: .normal)
        self.rightBtn.setBackgroundImage(configuration.btnSelBackgroundColor.pkext_image, for: .selected)
        self.rightBtn.addTarget(self, action: #selector(rightBtnDidClick), for: .touchUpInside)
        self.navigationBar.rightItemView = self.rightBtn
        
        self.view.addSubview(self.bottomView)
    }
    
    func setupConstraints() {
        self.navigationBar.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
        }
        
        self.photoCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        self.bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    func updateBottomSelectStatus() {
        if self.fetchResult != nil, let item = self.gridSelectItem {
            let asset = self.fetchResult![item]
            let filterArray = self.selectAssetsModel!.selectAssets.filter({ (phasset) -> Bool in
                return asset.localIdentifier == phasset.localIdentifier
            })
            if filterArray.count > 0 {
                self.bottomView.newAsset = asset
                self.setRightBtnTitle(asset: asset)
            }
        }
        else if self.selectAssetsModel != nil {
            self.selectAssets = self.selectAssetsModel!.selectAssets
            self.bottomView.newAsset = self.selectAssetsModel!.selectAssets[0]
            self.setRightBtnTitle(asset: self.selectAssetsModel!.selectAssets[0])
        }
        
        self.bottomView.selectAssetsModel = self.selectAssetsModel
    }
}

// MARK: - 按钮点击
private extension PKPreviewController {
    @objc func rightBtnDidClick(sender: UIButton) {
        let x = self.photoCollectionView.contentOffset.x
        let page = Int(x / kPKScreenWidth)
        let asset = self.getAsset(index: page)
        
        if sender.isSelected {
            if let index = self.selectAssetsModel?.selectAssets.index(of: asset) {
                self.selectAssetsModel?.selectAssets.remove(at: index)
                self.bottomView.deleteItem(item: index)
            }
        }
        else {
            self.selectAssetsModel?.selectAssets.append(asset)
            self.bottomView.insertAsset(asset: asset)
        }
        self.setRightBtnTitle(asset: asset)
    }
    
    func setRightBtnTitle(asset: PHAsset) {
        if let index = self.selectAssetsModel?.selectAssets.index(of: asset) {
            self.rightBtn.setTitle("\(index+1)", for: .selected)
            self.rightBtn.isSelected = true
            self.bottomView.scrollToItem(asset: asset)
        }
        else {
            self.rightBtn.isSelected = false
        }
    }
    
    func oneTapClick() {
        if self.navigationBar.isHidden {
            self.navigationBar.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationBar.snp.updateConstraints { (update) in
                    update.top.equalTo(self.view.snp.top)
                }
                self.bottomView.snp.updateConstraints { (update) in
                    update.bottom.equalTo(self.view.snp.bottom)
                }
                self.view.layoutSubviews()
            }) { (_) in
                
            }
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationBar.snp.updateConstraints { (update) in
                    update.top.equalTo(self.view.snp.top).offset(-self.navigationBar.intrinsicContentSize.height)
                }
                self.bottomView.snp.updateConstraints { (update) in
                    update.bottom.equalTo(self.view.snp.bottom).offset(self.bottomView.intrinsicContentSize.height)
                }
                self.view.layoutSubviews()
            }) { (_) in
                self.navigationBar.isHidden = true
            }
        }
    }
}

extension PKPreviewController {
    func getAsset(index: Int) -> PHAsset {
        var asset: PHAsset!
        if self.fetchResult != nil {
            asset = self.fetchResult![index]
        }
        else {
            asset = self.selectAssets[index]
        }
        return asset
    }
}

// MARK: - UICollectionViewDataSource
extension PKPreviewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.fetchResult == nil {
            return self.selectAssets.count
        }
        return self.fetchResult!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PKPreviewCell.identifier, for: indexPath) as! PKPreviewCell

        let asset = self.getAsset(index: indexPath.item)
        
        cell.representedAssetIdentifier = asset.localIdentifier
        // 先从缓存里加载缩略图
        PKImageManager.shared.getThumbnailImage(asset: asset, thumbnailSize: PKConfiguration.shared.thumbnailSize, completion: { (image) in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.photoImage = image
            }
        })
        
        let scale = UIScreen.main.scale
        // 再获取预览图
        PKImageManager.shared.getPreviewImage(asset: asset, targetSize: CGSize(width: kPKScreenWidth*scale, height: kPKScreenHeight*scale), progressHandler: nil) { (image) in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.photoImage = image
            }
        }
        
        cell.oneTapClick = {[weak self] in
            self?.oneTapClick()
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension PKPreviewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let page = Int(x / kPKScreenWidth)

        let asset = self.getAsset(index: page)
        
        // 页面滚动更新底部和右上角按钮选中状态
        self.rightBtn.isSelected = self.selectAssetsModel?.selectAssets.contains(asset) ?? false
        self.setRightBtnTitle(asset: asset)
        
        debugPrint("page = \(page)")
    }
}
