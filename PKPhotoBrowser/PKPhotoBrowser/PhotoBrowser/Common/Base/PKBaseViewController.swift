//
//  PKBaseViewController.swift
//  CoinTiger
//
//  Created by pengkun on 2017/12/25.
//  Copyright © 2017年 pk. All rights reserved.
//

import UIKit

class PKBaseViewController: UIViewController {
    
    //MARK: - ui
    
    //MARK: - property
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
//        self.edgesForExtendedLayout = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
