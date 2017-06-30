//
//  PlatformAccountViewController.m
//  奢易购3.0
//
//  Created by Andy on 2016/10/27.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import "PlatformAccountViewController.h"
#import "AccountBindingViewController.h"
#import "AccountListViewController.h"

@interface PlatformAccountViewController ()<WeiboSDKDelegate>
@property (weak, nonatomic) IBOutlet UILabel *ponhuLabel;
@property (weak, nonatomic) IBOutlet UILabel *aidingmaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *weiboLabel;
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;

@property (nonatomic,strong) NSDictionary *dataDic;

@end

@implementation PlatformAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    //改变导航栏标题的字体颜色和大小
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"绑定平台账号";

    //左边Item
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 10, 19);
    [leftBtn setImage:[UIImage imageNamed:@"返回（20x38）"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    NSDictionary *dic1 = [defaults objectForKey:[NSString stringWithFormat:@"%@share",SYGData[@"id"]]][@"ponhu"];
    
    if (dic1) {
        _ponhuLabel.text = dic1[@"phone"];
    }
    
    NSDictionary *dic2 = [defaults objectForKey:[NSString stringWithFormat:@"%@share",SYGData[@"id"]]][@"aidingmao"];
    
    if (dic2) {
        
        _aidingmaoLabel.text = dic2[@"phone"];
    }
    
    NSDictionary *dic3 = [defaults objectForKey:[NSString stringWithFormat:@"%@share",SYGData[@"id"]]][@"sae"];
    
    if (dic3) {
        _weiboLabel.text = dic3[@"phone"];
    }

    
    
}

//左边返回按钮
- (void)leftBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        AccountListViewController *AccountListVC = [[AccountListViewController alloc]init];
        
        AccountListVC.titleStr = @"ponhu";

        
        [self.navigationController pushViewController:AccountListVC animated:YES];

        
    }else if (indexPath.row == 1){
    
        AccountListViewController *AccountListVC = [[AccountListViewController alloc]init];
        
        AccountListVC.titleStr = @"aidingmao";
        
        
        [self.navigationController pushViewController:AccountListVC animated:YES];
        

        
//        AccountBindingViewController *AccountBindingVC = [[AccountBindingViewController alloc]init];
//        if (![_aidingmaoLabel.text isEqualToString:@"去绑定账号"]) {
//            AccountBindingVC.isEdit = YES;
//            for (NSDictionary *dic in _dataDic[@"item"]) {
//                
//                if ([dic[@"type"] isEqualToString:@"aidingmao"]) {
//                    AccountBindingVC.dataDic = dic;
//                }
//            }
//        }
//        AccountBindingVC.type = @"aidingmao";
//        [self.navigationController pushViewController:AccountBindingVC animated:YES];
        
    }else if (indexPath.row == 2){
        
        AccountListViewController *AccountListVC = [[AccountListViewController alloc]init];
        
        AccountListVC.titleStr = @"sae";
        
        
        [self.navigationController pushViewController:AccountListVC animated:YES];
        
        

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 3) {
        
        return 0;
    }

    return 44;
    
}


- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)weiboLoginByResponse:(WBBaseResponse *)response{
    
    NSDictionary *dic = (NSDictionary *) response.requestUserInfo;
    
    NSLog(@"userinfo %@",dic);
    
}



@end
