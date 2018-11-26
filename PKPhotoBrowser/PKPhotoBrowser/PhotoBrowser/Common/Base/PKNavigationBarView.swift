//
//  PKNavigationBarView.swift
//  CoinTiger
//
//  Created by pengkun on 2017/12/25.
//  Copyright © 2017年 pk. All rights reserved.
//

import UIKit

class PKNavigationBarView: UIView {
    
    fileprivate let titleLabel: UILabel = UILabel()
    fileprivate let backButton: UIButton = UIButton()
    fileprivate let lineShadow: UIView = UIView()
    
    var rightItemView: UIView? {
        willSet {self.rightItemView?.removeFromSuperview()}
        didSet {self.didSetRightItemView()}
    }
    
    var titleLabelTopOffset: CGFloat = 0 {
        didSet {self.didSetTitleLabelTopOffset()}
    }
    var titleLabelAlpha: CGFloat = 1.0 {
        didSet { self.titleLabel.alpha = titleLabelAlpha}
    }

    /// 是否隐藏底部线
    var isHiddenShadowView: Bool = true {
        didSet {
            self.lineShadow.isHidden = isHiddenShadowView
        }
    }
    /// 是否隐藏返回按钮
    var isHiddenBackButton: Bool {
        get {return self.backButton.isHidden}
        set {self.backButton.isHidden = newValue}
    }
    var backButtonClickBlock: (() -> Void)?
    
    var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackButtonWhiteImage() {
        self.backButton.setImage(UIImage(named: "common_nav_back_white")!, for: .normal)
    }
    func setupBackButtonBlackImage() {
        self.backButton.setImage(UIImage(named: "common_nav_back_black")!, for: .normal)
    }
    
}
extension PKNavigationBarView {
    // MARK: - 内部宽高
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let contentSize = self.intrinsicContentSize
        return CGSize(width: kPKScreenWidth, height: contentSize.height)
    }
    override var intrinsicContentSize: CGSize {
        var height: CGFloat = kPKNavigationBarHeight // 自身高度
        height += pkStatusBarHeight()
        return CGSize(width: CGFloat(UIView.noIntrinsicMetric), height: height)
    }
}
private extension PKNavigationBarView {
    func setup() {
        self.setupViews()
        self.setupConstraints()
    }
    func setupViews() {
        let configuration = PKConfiguration.shared
        self.backgroundColor = configuration.navBarBackgroundColor
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.backButton)
        
        self.titleLabel.font = configuration.navTitleFont
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.textAlignment = .center
        
        self.backButton.setImage(configuration.navBackBtnImage, for: .normal)
        self.backButton.addTarget(self, action: #selector(backButtonDidClick), for: .touchUpInside)
        self.backButton.contentHorizontalAlignment = .left
        
        self.addSubview(self.lineShadow)
        self.lineShadow.isHidden = true
        self.lineShadow.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.lineShadow.layer.shadowColor = UIColor.black.cgColor
        self.lineShadow.layer.shadowRadius = 3
        self.lineShadow.layer.shadowOpacity = 0.3

    }
    func setupConstraints() {
        self.backButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-4)
            make.left.equalTo(self).offset(15)
            make.height.equalTo(40)
            make.width.equalTo(50)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.backButton)
            make.centerX.equalTo(self)
            make.right.equalTo(self.snp.right).offset(-80)
            make.left.equalTo(self.snp.left).offset(80)
        }
        self.lineShadow.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(-1)
            make.height.equalTo(0.5)
        }
    }
    
    func didSetRightItemView() {
        guard let newView = self.rightItemView else {return}
        self.addSubview(newView)
        newView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.backButton)
            make.right.equalTo(self).offset(-18)
            make.width.equalTo(newView.bounds.size.width)
            make.height.equalTo(newView.bounds.size.height)
        }
    }
    
    @objc func backButtonDidClick() {
        self.backButtonClickBlock?()
    }
    
    func didSetTitleLabelTopOffset() {
        self.titleLabel.snp.updateConstraints { (make) in
            make.centerY.equalTo(self.backButton).offset(self.titleLabelTopOffset)
        }
    }
}

