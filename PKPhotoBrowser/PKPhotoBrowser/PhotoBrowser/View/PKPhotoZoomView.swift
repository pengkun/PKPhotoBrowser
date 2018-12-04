//
//  PKPhotoZoomView.swift
//  Scroll
//
//  Created by pengkun on 2018/11/27.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit

protocol PKPhotoZoomViewDelegate: class {
    func zoomViewOneTapClick()
}

/// 放大缩小
class PKPhotoZoomView: UIScrollView {

    //MARK: - ui
    fileprivate let imageView: UIImageView = UIImageView()
    //MARK: - property
    var image: UIImage? {
        didSet {
            self.imageDidSet()
        }
    }
    weak var tapDelegate: PKPhotoZoomViewDelegate?
    
    deinit {
        debugPrint("\(type(of:self)) deinit")
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI初始化
private extension PKPhotoZoomView {
    func setup() {
        self.setupViews()
    }
    
    func setupViews() {
        self.backgroundColor = UIColor.black
        
        self.delegate = self
        self.minimumZoomScale = 1.0
        self.maximumZoomScale = 3.5
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.scrollsToTop = false
        
        self.imageView.backgroundColor = UIColor.orange
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.isUserInteractionEnabled = true
        self.addSubview(self.imageView)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapClick))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(oneTapClick))
        oneTap.numberOfTapsRequired = 1
        oneTap.require(toFail: doubleTap)
        self.addGestureRecognizer(oneTap)
    }
    
    func imageDidSet() {
        guard let img = self.image else { return }
        
        if img.size.width > self.bounds.width {
            self.imageView.bounds.size = CGSize(width: self.bounds.width, height: img.size.height/img.size.width*self.bounds.width)
        }
        else {
            self.imageView.bounds.size = img.size
        }
        self.imageView.image = img
        self.imageView.center = self.center
    }
}

// MARK: - 点击事件
extension PKPhotoZoomView {
    @objc func doubleTapClick(sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        
        if self.zoomScale > 1 {
            self.setZoomScale(1.0, animated: true)
        }
        else {
            self.zoom(to: CGRect(origin: point, size: CGSize(width: 10, height: 10)), animated: true)
        }
    }
    
    @objc func oneTapClick() {
        self.tapDelegate?.zoomViewOneTapClick()
    }
}

// MARK: - UIScrollViewDelegate
extension PKPhotoZoomView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        debugPrint("content size = \(scrollView.contentSize)")
        self.imageView.center.y = self.bounds.height > self.contentSize.height ? self.bounds.height/2 : self.contentSize.height/2
        self.imageView.center.x = self.bounds.width > self.contentSize.width ? self.bounds.width/2 : self.contentSize.width/2
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        debugPrint("scrollViewDidEndZooming scale = \(scale)")
        if scale <= scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
        else if scale >= scrollView.maximumZoomScale {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
        else {
            scrollView.setZoomScale(scale, animated: false)
        }
    }
}
