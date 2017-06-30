//
//  BaseTabViewController.m
//  Weibo55
//
//  Created by phc on 15/12/1.
//  Copyright (c) 2015年 phc. All rights reserved.
//

#import "BaseTabBarController.h"
#import "SellingGoodsViewController.h"
#import "SupplyGoodsViewController.h"
#import "InformationViewController.h"
#import "MyViewController.h"
#import "BaseNaViewController.h"

@interface BaseTabViewController ()


@property (nonatomic,strong) UIImageView *selectImageV;

@end

@implementation BaseTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTabBarNotification:) name:@"selectTabBarNotification" object:nil];

    /**
     *  1.加载子控制器
     */
    

    [self creactSubC];
    
    [self creactTabBar];
}

- (void)creactSubC{
    
//    SellingGoodsViewController *

    
    
    BaseNaViewController *sellingGoodsVC = [[BaseNaViewController alloc]initWithRootViewController:[[SellingGoodsViewController alloc]init]];
    
    BaseNaViewController *supplyGoodsVC = [[BaseNaViewController alloc]initWithRootViewController:[[SupplyGoodsViewController alloc]init]];

    BaseNaViewController *informationVC = [[BaseNaViewController alloc]initWithRootViewController:[[InformationViewController alloc]init]];

    BaseNaViewController *myVC = [[BaseNaViewController alloc]initWithRootViewController:[[MyViewController alloc]init]];

    
    NSArray *viewC = @[sellingGoodsVC,supplyGoodsVC,informationVC,myVC];
    
   
    self.viewControllers = viewC;
    
    
    
}

- (void)creactTabBar{
    
    
    
    //设置背景
    UIImageView * tabaImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    tabaImg.backgroundColor = [RGBColor colorWithHexString:@"#ffffff"];
    
    [self.tabBar addSubview:tabaImg];
    
    tabaImg.layer.borderColor = [RGBColor colorWithHexString:@"#dddddd"].CGColor;
    tabaImg.layer.borderWidth = 1;
    
    NSArray *imgArr = @[
                        @"卖货黑",
                        @"货源黑",
                        @"信息黑",
                        @"我的黑",
                        ];
    float itemWidth = kScreenWidth/4;
    
    for (int i = 0; i< imgArr.count; i ++) {
        
        NSString *imgName = imgArr[i];
//        NSString *selectImgName = selectImgArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*itemWidth, 2, itemWidth, 45);
//        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:selectImgName] forState:UIControlStateSelected];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tabBar addSubview:button];
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 36, 23)];
        imageV.image = [UIImage imageNamed:imgName];
        imageV.tag = 1100+i;
        imageV.center = button.center;
        [self.tabBar addSubview:imageV];
        if (i == 0) {
            _selectImageV = imageV;
            imageV.image = [UIImage imageNamed:@"卖货红"];
        }
    }
    
    
}

- (void)buttonAction:(UIButton*)bt{
    
    self.selectedIndex = bt.tag-1000;

    NSArray *imgArr = @[
                        @"卖货黑",
                        @"货源黑",
                        @"信息黑",
                        @"我的黑",
                        ];
    NSArray *selectImgArr = @[
                        @"卖货红",
                        @"货源红",
                        @"信息红",
                        @"我的红",
                        ];
    

    UIImageView *imageV = [self.tabBar viewWithTag:bt.tag+100];
    
    if (imageV != _selectImageV) {
        
        imageV.image = [UIImage imageNamed:selectImgArr[bt.tag-1000]];
        _selectImageV.image = [UIImage imageNamed:imgArr[_selectImageV.tag-1100]];
        _selectImageV = imageV;
        
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    [self removeTaBarButton];

}

- (void)removeTaBarButton{
    
    for (UIView *view in self.tabBar.subviews) {
        
        if([view isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            [view removeFromSuperview];
        }
    }
    
}

- (void)selectTabBarNotification:(NSNotification*)noti{
    

    
    NSArray *imgArr = @[
                        @"卖货黑",
                        @"货源黑",
                        @"信息黑",
                        @"我的黑",
                        ];
    
    NSArray *selectImgArr = @[
                              @"卖货红",
                              @"货源红",
                              @"信息红",
                              @"我的红",
                              ];
    
    
    UIImageView *imageV = [self.tabBar viewWithTag:1100 + [[noti object] integerValue]];
    
    if (imageV != _selectImageV) {
        
        imageV.image = [UIImage imageNamed:selectImgArr[[[noti object] integerValue]]];
        _selectImageV.image = [UIImage imageNamed:imgArr[_selectImageV.tag-1100]];
        
        _selectImageV = imageV;
        
    }

}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
