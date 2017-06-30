//
//  ScanViewController.h
//  WXMovie
//
//  Created by mR yang on 15/10/28.
//  Copyright (c) 2015年 mR yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnIndexBlock)(NSInteger index);


@interface ScanViewController : UIViewController


@property (nonatomic, copy) ReturnIndexBlock returnIndexBlock;


@property(nonatomic,strong)NSIndexPath *currentIndexPath;//点击的单元格索引

@property(nonatomic,strong)NSArray *imageURLArr;

@property (nonatomic,assign) BOOL isDelegate;
@property (nonatomic,assign) BOOL isPhotoSelect;


@property (nonatomic,copy) NSString *share_id;

@property (nonatomic,strong) NSArray *selectAssets;



- (void)returnIndex:(ReturnIndexBlock)block;


@end
