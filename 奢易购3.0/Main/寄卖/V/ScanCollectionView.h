//
//  ScanCollectionView.h
//  WXMovie
//
//  Created by mR yang on 15/10/28.
//  Copyright (c) 2015年 mR yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property(nonatomic,strong)NSArray *imageURLArr;
@property(nonatomic,strong)NSArray *photosIdArr;

@end
