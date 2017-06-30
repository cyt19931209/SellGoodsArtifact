//
//  ScanCollectionView.m
//  WXMovie
//
//  Created by mR yang on 15/10/28.
//  Copyright (c) 2015年 mR yang. All rights reserved.
//

#import "ScanCollectionView.h"
#import "ScanCell.h"
@implementation ScanCollectionView

-(instancetype)initWithFrame:(CGRect)frame{
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    
    layout.minimumLineSpacing=0;
    
    if (self=[super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.dataSource=self;
        
        self.delegate=self;
        
        self.pagingEnabled=YES;
        
        [self registerClass:[ScanCell class] forCellWithReuseIdentifier:@"ScanCell"];
        
    }
    
    return self;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _imageURLArr.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ScanCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ScanCell" forIndexPath:indexPath];
    
//    2.把数组传到cell中
    cell.imageURL=_imageURLArr[indexPath.item];
    cell.photosId = _photosIdArr[indexPath.item];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.width, self.height);
    
}

//cell已经消失的时候会调用
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ScanCell *scanCell=(ScanCell*)cell;
    
    //让所有看不到的cell上面的scrollView缩放比例为1
    
}

@end
