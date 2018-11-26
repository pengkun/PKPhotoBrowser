//
//  PKAlbumListController.swift
//  PKPhotoBrowser
//
//  Created by pengkun on 2018/11/23.
//  Copyright © 2018 pengkun. All rights reserved.
//

import UIKit
import Photos

class PKAlbumListController: PKBaseViewController {

    //MARK: - ui
    fileprivate let listView: UITableView = UITableView()
    //MARK: - property
    fileprivate let imageManager: PHImageManager = PHImageManager()
    fileprivate var collections: [(assetCollection:PHAssetCollection, assetsFetchResult: PHFetchResult<PHAsset>)] = []
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UI初始化
private extension PKAlbumListController {
    func setup() {
        self.initDatas()
        self.setupViews()
        self.setupConstraints()
    }
    
    func setupViews() {
        self.navigationItem.title = "相册"
        
        self.listView.delegate = self
        self.listView.dataSource = self
        self.listView.register(UINib(nibName: "PKAlbumListCell", bundle: nil), forCellReuseIdentifier: PKAlbumListCell.identifier)
        self.view.addSubview(self.listView)
        
        let cancelItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelItemDidClick))
        self.navigationItem.rightBarButtonItem = cancelItem
    }
    
    func setupConstraints() {
        self.listView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: kPKViewTopOffset, left: 0, bottom: 0, right: 0))
        }
    }
    
    func initDatas() {
        self.ldt_loadingCountAdd()
        PKAsync.async(serial: true) {

            let fetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
            fetchResult.enumerateObjects({ [weak self] (assetCollection, index, nil) in
                guard let strongSelf = self else {return}
                let allOptions = PHFetchOptions()
                allOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: true)]
                let assetsFetchResult = PHAsset.fetchAssets(in: assetCollection, options: allOptions)
                guard assetsFetchResult.count <= 0 else {
                    let assetItem = (assetCollection, assetsFetchResult)
//                    if assetCollection.assetCollectionSubtype == .smartAlbumVideos || assetCollection.assetCollectionSubtype == .smartAlbumSlomoVideos {
//                        return
//                    }
                    if assetCollection.assetCollectionSubtype == .smartAlbumUserLibrary {
                        strongSelf.collections.insert(assetItem, at: 0)
                    } else {
                        strongSelf.collections.append(assetItem)
                    }
                    return
                }
            })
            PKAsync.main {
                self.listView.reloadData()
                self.ldt_loadingCountReduce()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension PKAlbumListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PKAlbumListCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PKAlbumListCell.identifier) as! PKAlbumListCell
        
        cell.data = self.collections[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PKAlbumListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let gridVC = PKAssetGridViewController()
        gridVC.fetchResult = self.collections[indexPath.row].assetsFetchResult
        gridVC.navigationItem.title = self.collections[indexPath.row].assetCollection.localizedTitle
        self.navigationController?.pushViewController(gridVC, animated: true)
    }
}

// MARK: - 按钮点击事件
extension PKAlbumListController {
    @objc func cancelItemDidClick() {
        self.dismiss(animated: true, completion: nil)
    }
}
