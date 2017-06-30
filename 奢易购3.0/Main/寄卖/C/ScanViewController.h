//
//  ScanViewController.h
//  WXMovie
//
//  Created by mR yang on 15/10/28.
//  Copyright (c) 2015年 mR yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController


@property(nonatomic,strong)NSIndexPath *currentIndexPath;//点击的单元格索引

@property(nonatomic,strong)NSArray *imageURLArr;

@property(nonatomic,strong)NSArray *photosIdArr;
@end
