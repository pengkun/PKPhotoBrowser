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
    var images: [UIImage] = []
    /// 上一级选中的item
    var gridSelectItem: Int?
    
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
        
        let configuration = PKConfiguration.shared
        self.rightBtn.bounds.size = configuration.previewRightBarItemSize
        self.rightBtn.setImage(UIImage(named: "garbage"), for: .normal)
        self.rightBtn.addTarget(self, action: #selector(rightBtnDidClick), for: .touchUpInside)
        self.navigationBar.rightItemView = self.rightBtn
        
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
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PKPreviewCell.identifier, for: indexPath) as! PKPreviewCell
       
        cell.photoImage = self.images[indexPath.item]
        
        cell.oneTapClick = {[weak self] in
            self?.oneTapClick()
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension PKPreviewDeleteController: UICollectionViewDelegate {
    
}
