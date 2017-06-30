//
//  ReleaseCompleteViewController.h
//  奢易购3.0
//
//  Created by Andy on 2016/10/28.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReleaseCompleteViewController : UIViewController



@property (nonatomic,strong)NSArray *arr;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,assign) BOOL isUpData;

@property (nonatomic,copy) NSString *goods_id;


@property (nonatomic,assign) BOOL isCopy;


@property (nonatomic,strong) NSDictionary *selectDic;

@end
