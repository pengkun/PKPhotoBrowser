//
//  PKPreviewDeleteController.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/12/5.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit

class PKPreviewDeleteController: PKBaseViewController {
    
    //MARK: - ui
    fileprivate let navigationBar: PKNavigationBarView = PKNavigationBarView()
    fileprivate var photoCollectionView: UICollectionView!
    fileprivate let rightBtn: UIButton = UIButton()
    fileprivate let flowLayout = UICollectionViewFlowLayout()
    //MARK: - property
    /// 选中的照片集合
    var selectModel: PKSelectPhotosModel!
    /// 上一级选中的item
    var gridSelectItem: Int?
    fileprivate var curItem: Int = 0
    
    deinit {
        debugPrint("\(type(of:self)) deinit")
    }
    
    required init(model: PKSelectPhotosModel) {
        super.init(nibName: nil, bundle: nil)
        self.selectModel = model
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
private extension PKPreviewDeleteController {
    func setup() {
        self.setupViews()
        self.setupConstraints()
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
        
        self.rightBtn.bounds.size = CGSize(width: 60, height: 20)
        self.rightBtn.imageView?.contentMode = .scaleAspectFit
        self.rightBtn.contentHorizontalAlignment = .right
        self.rightBtn.setImage(UIImage(named: "garbage"), for: .normal)
        self.rightBtn.addTarget(self, action: #selector(rightBtnDidClick), for: .touchUpInside)
        self.navigationBar.rightItemView = self.rightBtn
        
        if self.selectModel.selectPhotos.count > 0, let item = self.gridSelectItem {
            self.navigationBar.title = "\(item+1)/\(self.selectModel.selectPhotos.count)"
        }
        
    }
    
    func setupConstraints() {
        self.navigationBar.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
        }
        
        self.photoCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
}

// MARK: - 按钮点击
private extension PKPreviewDeleteController {
    @objc func rightBtnDidClick(sender: UIButton) {
        let alertVC = UIAlertController(title: "要删除这张照片吗？", message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { (_) in
            self.selectModel.selectPhotos.remove(at: self.curItem)
            self.navigationBar.title = "\(self.curItem+1)/\(self.selectModel.selectPhotos.count)"
            self.photoCollectionView.deleteItems(at: [IndexPath(item: self.curItem, section: 0)])
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func oneTapClick() {
        if self.navigationBar.isHidden {
            self.navigationBar.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.navigationBar.snp.updateConstraints { (update) in
                    update.top.equalTo(self.view.snp.top)
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
                self.view.layoutSubviews()
            }) { (_) in
                self.navigationBar.isHidden = true
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension PKPreviewDeleteController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectModel.selectPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PKPreviewCell.identifier, for: indexPath) as! PKPreviewCell
       
        cell.photoImage = self.selectModel.selectPhotos[indexPath.item]
        
        cell.oneTapClick = {[weak self] in
            self?.oneTapClick()
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension PKPreviewDeleteController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let page = Int(x / kPKScreenWidth)
        self.curItem = page
        self.navigationBar.title = "\(page+1)/\(self.selectModel.selectPhotos.count)"
    }
}
