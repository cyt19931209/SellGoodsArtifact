//
//  ScanViewController.m
//  WXMovie
//
//  Created by mR yang on 15/10/28.
//  Copyright (c) 2015年 mR yang. All rights reserved.
//

#import "ScanViewController.h"
#import "ScanCollectionView.h"



@interface ScanViewController ()
{
    ScanCollectionView *scanCollectionV;
}

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
//       NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barTintColor = qMYRGB(242,61, 67);
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) image:@"icon_40_40_back@2x" highImage:@"icon_40_40_back@2x"];
    
    scanCollectionV=[[ScanCollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth+40, ScreenHeight)];
    
//    1.把数组传到scanCollectionV中
    scanCollectionV.backgroundColor = [UIColor whiteColor];
    scanCollectionV.imageURLArr=_imageURLArr;
    scanCollectionV.photosIdArr = _photosIdArr;
    [scanCollectionV scrollToItemAtIndexPath:_currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

    [self.view addSubview:scanCollectionV];

}

//返回
- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
