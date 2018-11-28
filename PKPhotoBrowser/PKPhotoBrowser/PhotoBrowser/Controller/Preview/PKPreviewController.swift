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
    //MARK: - property
    var selectAssets: [PHAsset] = []
    var fetchResult: PHFetchResult<PHAsset>?
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
    }
    
    func setupViews() {

        let flowLayout = UICollectionViewFlowLayout()
        let shape: CGFloat = 0
        flowLayout.itemSize = CGSize(width: kPKScreenWidth, height: kPKScreenHeight)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = shape
        flowLayout.minimumInteritemSpacing = shape
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.photoCollectionView.backgroundColor = UIColor.white
        self.photoCollectionView.dataSource = self
        self.photoCollectionView.isPagingEnabled = true
        self.photoCollectionView.register(PKPreviewCell.self, forCellWithReuseIdentifier: PKPreviewCell.identifier)
        self.view.addSubview(self.photoCollectionView)
        
        self.navigationBar.backButtonClickBlock = { [weak self] in
            _ = self?.navigationController?.popViewController(animated: true)
        }
        self.view.addSubview(self.navigationBar)
        
        self.bottomView.selectAssets = self.selectAssets
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
}

// MARK: - UICollectionViewDataSource
extension PKPreviewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PKPreviewCell.identifier, for: indexPath) as! PKPreviewCell

        let asset = self.selectAssets[indexPath.item]
        PKImageManager.shared.getOriginImage(asset: asset, progressHandler: nil) { (image) in
            cell.photoImage = image
        }
        return cell
    }
    
}
