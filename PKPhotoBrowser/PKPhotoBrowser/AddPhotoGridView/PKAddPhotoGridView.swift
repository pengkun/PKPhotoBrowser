//
//  PKAddPhotoGridView.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/12/5.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit

protocol PKAddPhotoGridViewDelegate: class {
    func addGridViewAddDidSelect()
    func addGridView(didSelect item: Int)
}

class PKAddPhotoGridView: UIView {

    //MARK: - ui
    fileprivate var addCollectionView: UICollectionView?
    
    //MARK: - property
    weak var delegate: PKAddPhotoGridViewDelegate?
    
    private var isFirstLoad: Bool = true
    var maxCount: Int = 9
    var selectModel: PKSelectPhotosModel!
    fileprivate var lineCount: Int {
        return PKConfiguration.shared.addGridLineCount
    }
    
    deinit {
        debugPrint("\(type(of:self)) deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.isFirstLoad {
            self.isFirstLoad = false
            self.setup()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let shape: CGFloat = 5
        let layoutWidth = (self.bounds.width-shape*CGFloat(self.lineCount-1))/CGFloat(self.lineCount)
        if self.selectModel.selectPhotos.count < self.lineCount {
            return CGSize(width: CGFloat(UIView.noIntrinsicMetric), height: layoutWidth == 0 ? 90 : layoutWidth)
        }
        else {
            let count = Double(self.selectModel.selectPhotos.count == self.maxCount ? self.selectModel.selectPhotos.count : self.selectModel.selectPhotos.count+1)
            return CGSize(width: CGFloat(UIView.noIntrinsicMetric), height: (layoutWidth+shape)*CGFloat(ceil(count/Double(self.lineCount))))
        }
    }
    
    func refreshImages() {
        self.addCollectionView?.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}

// MARK: - UI初始化
private extension PKAddPhotoGridView {
    func setup() {
        self.setupViews()
        self.setupConstraints()
    }
    
    func setupViews() {
        let shape: CGFloat = 5
        let layoutWidth = (self.bounds.width-shape*CGFloat(self.lineCount-1))/CGFloat(self.lineCount)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: layoutWidth, height: layoutWidth)
        flowLayout.minimumLineSpacing = shape
        flowLayout.minimumInteritemSpacing = shape
//        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: shape, right: shape)
        
        self.addCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.addCollectionView?.backgroundColor = UIColor.clear
        self.addCollectionView?.delegate = self
        self.addCollectionView?.dataSource = self
        self.addCollectionView?.showsVerticalScrollIndicator = false
        self.addCollectionView?.register(UINib(nibName: "PKAddPhotoGridCell", bundle: nil), forCellWithReuseIdentifier: PKAddPhotoGridCell.identifier)
        self.addSubview(self.addCollectionView!)
        
        //添加拖拽手势
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
//        self.addCollectionView.addGestureRecognizer(panGesture)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture))
        self.addCollectionView?.addGestureRecognizer(longGesture)
//        longGesture.require(toFail: panGesture)
        
        if self.bounds.size.height != layoutWidth {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    func setupConstraints() {
        self.addCollectionView?.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}

extension PKAddPhotoGridView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectModel.selectPhotos.count == self.maxCount ? self.selectModel.selectPhotos.count : self.selectModel.selectPhotos.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PKAddPhotoGridCell.identifier, for: indexPath) as! PKAddPhotoGridCell
        if indexPath.item < self.selectModel.selectPhotos.count {
            cell.imgView.image = self.selectModel.selectPhotos[indexPath.item]
        }
        else {
            cell.imgView.image = UIImage(named: "add")
        }
        
        return cell
    }
    
    
}

extension PKAddPhotoGridView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if indexPath.item < self.selectModel.selectPhotos.count {
            self.delegate?.addGridView(didSelect: indexPath.item)
        }
        else {
            self.delegate?.addGridViewAddDidSelect()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
 
        let tempSource = self.selectModel.selectPhotos[sourceIndexPath.row]
        self.selectModel.selectPhotos.remove(at: sourceIndexPath.row)
        self.selectModel.selectPhotos.insert(tempSource, at: destinationIndexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if self.selectModel.selectPhotos.count != self.maxCount {
            if proposedIndexPath == IndexPath(row: self.selectModel.selectPhotos.count,section: 0) {//最后一个不能动
                return originalIndexPath
            }
        }
        return proposedIndexPath
    }
}

extension PKAddPhotoGridView {
    //拖动移动位置
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case UIGestureRecognizer.State.began:
            guard let selectedIndexPath = self.addCollectionView?.indexPathForItem(at: gesture.location(in: self.addCollectionView)) else {
                break
            }
            
            // 移动
            if self.selectModel.selectPhotos.count != self.maxCount {
                if selectedIndexPath == IndexPath(row: self.selectModel.selectPhotos.count,section: 0) {//最后一个不能动
                    break
                }
            }
            self.addCollectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
            
            // item 放大
            let cell = self.addCollectionView?.cellForItem(at: selectedIndexPath)
            cell?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        case UIGestureRecognizer.State.changed:
            self.addCollectionView?.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizer.State.ended:
            self.addCollectionView?.endInteractiveMovement()
            
            // 还原大小
            guard let selectedIndexPath = self.addCollectionView?.indexPathForItem(at: gesture.location(in: self.addCollectionView)) else {
                break
            }
            let cell = self.addCollectionView?.cellForItem(at: selectedIndexPath)
            cell?.transform = CGAffineTransform.identity
            
        default:
            self.addCollectionView?.cancelInteractiveMovement()
            break
        }
    }
}
