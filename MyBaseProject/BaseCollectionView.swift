//
//  BaseCollectionView.swift
//  MyBaseProject
//
//  Created by DuongLD on 11/3/16.
//  Copyright © 2016 DuongLD. All rights reserved.
//

import UIKit

class BaseCollectionView: UIView {
  
  lazy var collectionView:UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    let cv = UICollectionView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height), collectionViewLayout: layout)
    cv.delegate = self
    cv.dataSource = self
    return cv
  }()
  
  var dataContentsForBaseCollectionView:[AnyObject]? {
    didSet{
      collectionView.reloadData()
    }
  }
  
  var registerClassForCell:[(nameClass: AnyClass, indentify: String)]? {
    didSet {
      for item:(nameClass: AnyClass,indentify: String) in (self.registerClassForCell)! {
        collectionView.registerClass(item.nameClass, forCellWithReuseIdentifier: item.indentify)
      }
    }
  }
  
  var dataSizesForCell:[CGSize]?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(collectionView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

class BaseCollectionViewCell: UICollectionViewCell {
  func setupData(data: AnyObject){}
}

extension BaseCollectionView: UICollectionViewDelegate {
  
}

extension BaseCollectionView: UICollectionViewDelegateFlowLayout {
  
}

extension BaseCollectionView: UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    guard let infoClassForCell:(nameClass: AnyClass ,indentify: String) = registerClassForCell![indexPath.section] else{
      return UICollectionViewCell()
    }
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(infoClassForCell.indentify, forIndexPath: indexPath) as! BaseCollectionViewCell
    guard let data = dataContentsForBaseCollectionView?[indexPath.section][indexPath.row] else{
      return UICollectionViewCell()
    }
    cell.setupData(data)
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
  {
    guard let size = dataSizesForCell?[indexPath.section] else{
      return CGSizeMake(0,0)
    }
    return size
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    return 5
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let count:Int = dataContentsForBaseCollectionView![section].count else {
      return 0
    }
    return count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    guard let count: Int = dataContentsForBaseCollectionView?.count else {
      return 0
    }
    return count
  }
}







