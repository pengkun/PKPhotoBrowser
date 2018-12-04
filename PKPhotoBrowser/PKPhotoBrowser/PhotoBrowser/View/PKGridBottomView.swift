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
}

/// grid底部工具栏
class PKGridBottomView: UIView {

    //MARK: - ui
    fileprivate let previewBtn: UIButton = UIButton()
    fileprivate let doneBtn: UIButton = UIButton()
    //MARK: - property
    weak var delegate: PKGridBottomViewDelegate?
    
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
        return CGSize(width: kPKScreenWidth, height: 60)
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
        self.previewBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.previewBtn.setTitle("预览", for: .normal)
        self.previewBtn.addTarget(self, action: #selector(previewBtnDidClick), for: .touchUpInside)
        self.previewBtn.contentHorizontalAlignment = .left
        self.addSubview(self.previewBtn)
        
        self.doneBtn.backgroundColor = configuration.btnSelBackgroundColor
        self.doneBtn.setTitleColor(UIColor.white, for: .normal)
        self.doneBtn.layer.cornerRadius = 5
        self.doneBtn.layer.masksToBounds = true
        self.doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
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
}
