//
//  ScanViewController.m
//  WXMovie
//
//  Created by mR yang on 15/10/28.
//  Copyright (c) 2015年 mR yang. All rights reserved.
//

#import "ScanViewController.h"
#import "ScanCollectionView.h"
#import "EdiitPhotoViewController.h"
#import "ZLPhotoAssets.h"

@interface ScanViewController ()<UIScrollViewDelegate>
{
    ScanCollectionView *scanCollectionV;
    UIButton *rightBtn;
}

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EditPhotoNotification:) name:@"editPhotoNotification" object:nil];
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 35, 30);
    [rightBtn setTitleColor:[RGBColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;

    

    //左边Item
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 10, 19);
    [leftBtn setImage:[UIImage imageNamed:@"返回（20x38）"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    

    
    scanCollectionV=[[ScanCollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth+40, kScreenHeight)];
    
    scanCollectionV.isPhotoSelect = _isPhotoSelect;
//    1.把数组传到scanCollectionV中
    scanCollectionV.backgroundColor = [UIColor whiteColor];
    
    scanCollectionV.imageURLArr= _imageURLArr;

    NSLog(@"%@",_currentIndexPath);
    
    [scanCollectionV scrollToItemAtIndexPath:_currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    [self.view addSubview:scanCollectionV];
    
    
    if (_isDelegate) {
        
        [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
        
    }else if (_isPhotoSelect){
        rightBtn.width = 30;
        
        
        [rightBtn setImage:[UIImage imageNamed:@"ttno@2x"] forState:UIControlStateNormal];
        
        [rightBtn setImage:[UIImage imageNamed:@"ttyes@2x"] forState:UIControlStateSelected];
        
        [scanCollectionV addObserver:self forKeyPath:@"index" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];


    }else{
        rightBtn.width = 70;
        [rightBtn setTitle:@"编辑图片" forState:UIControlStateNormal];
        
    }
    
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    rightBtn.selected = NO;

    if([keyPath isEqualToString:@"index"])
    {
        for (ZLPhotoAssets *asset in self.selectAssets) {
            
            if ([asset isKindOfClass:[ZLPhotoAssets class]] && [asset.asset.defaultRepresentation.url isEqual:[(ZLPhotoAssets *)_imageURLArr[scanCollectionV.index] asset].defaultRepresentation.url]) {
                rightBtn.selected = YES;
            }
        }

    }
}



//删除
- (void)editAction{

    if (_isDelegate) {
        
        NSMutableArray *urlArr = [NSMutableArray arrayWithArray:_imageURLArr];
        
        NSLog(@"%ld",scanCollectionV.index);
        
        [urlArr removeObjectAtIndex:scanCollectionV.index];
        
        _imageURLArr = [urlArr copy];
        
        scanCollectionV.imageURLArr=_imageURLArr;
        
        [scanCollectionV reloadData];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveImageNotification" object:[NSString stringWithFormat:@"%ld",scanCollectionV.index]];
        
        if (_imageURLArr.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (_isPhotoSelect){
        
        
        if (!rightBtn.selected) {
            
            if (_selectAssets.count > 8) {
                
                _returnIndexBlock(scanCollectionV.index);

                return;
            }
        }
        
        rightBtn.selected = ! rightBtn.selected;
        
        NSMutableArray *selectArr = [NSMutableArray arrayWithArray:_selectAssets];
        
        if (rightBtn.selected) {
            
            [selectArr addObject:_imageURLArr[scanCollectionV.index]];
            
        }else{
        
            [selectArr removeObject:_imageURLArr[scanCollectionV.index]];

        }
        
        _returnIndexBlock(scanCollectionV.index);

        _selectAssets = [selectArr copy];
    
    }else{
    
        EdiitPhotoViewController *editPhotoVC = [[EdiitPhotoViewController alloc]init];
        editPhotoVC.share_id = _share_id;
        editPhotoVC.imageURLArr = _imageURLArr;
        [self.navigationController pushViewController:editPhotoVC animated:YES];
    
    }
    

    
}


- (void)returnIndex:(ReturnIndexBlock)block{

    self.returnIndexBlock = block;

}


//返回
- (void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//编辑图片
- (void)EditPhotoNotification:(NSNotification*)noti{
    
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *SYGData  = [defaults objectForKey:@"SYGData"];
    
    
    if (![SYGData[@"type"] isEqualToString:@"2"]) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:SYGData[@"id"] forKey:@"uid"];
        
        
        [DataSeviece requestUrl:change_user_privilegehtml params:params success:^(id result) {
            
            NSLog(@"%@",result);
            
            
            if ([result[@"result"][@"data"][@"status"] isEqualToString:@"enable"]) {
                
                _imageURLArr = [noti object];
                scanCollectionV.imageURLArr=_imageURLArr;
                
                NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
                
                [scanCollectionV scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                
                
            }else{
                
                alertV.message = @"没有权限修改";
                [alertV show];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"%@",error);
            
        }];
        
        
    }else{
        
        NSLog(@"修改图片");
        
        _imageURLArr = [noti object];
        scanCollectionV.imageURLArr=_imageURLArr;
        
        NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
        
        [scanCollectionV scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        
    }


}





- (void)dealloc{


    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [scanCollectionV removeObserver:self forKeyPath:@"index"];


}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //改变导航栏标题的字体颜色和大小
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Default1"] forBarMetrics:UIBarMetricsDefault];

    
    
}
@end
