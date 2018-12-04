//
//  PKGridBottomView.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/12/3.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit

protocol PKGridBottomViewDelegate: class  {
    func gridBottomViewDidClickPreview()
    func gridBottomViewDoneDidClick()
}

/// grid底部工具栏
class PKGridBottomView: UIView {

    //MARK: - ui
    fileprivate let previewBtn: UIButton = UIButton()
    fileprivate let doneBtn: UIButton = UIButton()
    //MARK: - property
    weak var delegate: PKGridBottomViewDelegate?
    var selectCount: Int = 0 {
        didSet {
            self.selectCountDidSet()
        }
    }
    
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
        return CGSize(width: kPKScreenWidth, height: 50)
    }
}

// MARK: - UI初始化
private extension PKGridBottomView {
    func setup() {
        self.setupViews()
        self.setupConstraints()
    }
    
    func setupViews() {
        let configuration = PKConfiguration.shared
        self.backgroundColor = configuration.navBarBackgroundColor
        
        self.previewBtn.setTitleColor(UIColor.white, for: .normal)
        self.previewBtn.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .disabled)
        self.previewBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.previewBtn.setTitle("预览", for: .normal)
        self.previewBtn.addTarget(self, action: #selector(previewBtnDidClick), for: .touchUpInside)
        self.previewBtn.contentHorizontalAlignment = .left
        self.addSubview(self.previewBtn)
        
        self.doneBtn.setBackgroundImage(configuration.btnSelBackgroundColor.pkext_image, for: .normal)
        self.doneBtn.setBackgroundImage(configuration.btnSelBackgroundColor.withAlphaComponent(0.6).pkext_image, for: .disabled)
        self.doneBtn.setTitleColor(UIColor.white, for: .normal)
        self.doneBtn.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .disabled)
        self.doneBtn.setTitle("完成", for: .disabled)
        self.doneBtn.layer.cornerRadius = 5
        self.doneBtn.layer.masksToBounds = true
        self.doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.doneBtn.addTarget(self, action: #selector(doneBtnDidClick), for: .touchUpInside)
        self.addSubview(self.doneBtn)
    }
    
    func setupConstraints() {
        self.previewBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(15)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        self.doneBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self.snp.right).offset(-15)
            make.height.equalTo(30)
            make.width.equalTo(70)
        }
    }
}

extension PKGridBottomView {
    @objc func previewBtnDidClick() {
        self.delegate?.gridBottomViewDidClickPreview()
    }

    @objc func doneBtnDidClick() {
        self.delegate?.gridBottomViewDoneDidClick()
    }
    
    func selectCountDidSet() {
        self.previewBtn.isEnabled = self.selectCount != 0
        self.doneBtn.isEnabled = self.selectCount != 0
        
        self.doneBtn.setTitle("完成(\(self.selectCount))", for: .normal)
    }
}
