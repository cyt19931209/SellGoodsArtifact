//
//  AccountBindingViewController.m
//  奢易购3.0
//
//  Created by Andy on 2016/10/27.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import "AccountBindingViewController.h"

@interface AccountBindingViewController (){

    UITextField *accountTextField;
    UITextField *passwordTextField;
}

@end

@implementation AccountBindingViewController

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
    
    self.view.backgroundColor = [RGBColor colorWithHexString:@"#f1f2fa"];

    accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 140, 50 +64, 280, 30)];
    
    accountTextField.font = [UIFont systemFontOfSize:18];
    accountTextField.textColor =[RGBColor colorWithHexString:@"#666666"];
    accountTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    if ([_dataDic[@"type"] isEqualToString:@"ponhu"]) {
        accountTextField.placeholder = @"请输入胖虎账号";
    }else{
        accountTextField.placeholder = @"请输入爱丁猫账号";

    }
    
    [self.view addSubview:accountTextField];
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 140, accountTextField.bottom +35, 280, 30)];
    
    passwordTextField.font = [UIFont systemFontOfSize:18];
    passwordTextField.textColor =[RGBColor colorWithHexString:@"#666666"];
    passwordTextField.clearButtonMode = UITextFieldViewModeAlways;

    if ([_dataDic[@"type"] isEqualToString:@"ponhu"]) {
        passwordTextField.placeholder = @"请输入胖虎密码";
    }else{
        passwordTextField.placeholder = @"请输入爱丁猫密码";
    }

    [self.view addSubview:passwordTextField];
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 150, accountTextField.bottom - 10, 1, 10)];
    
    lineV.backgroundColor = [RGBColor colorWithHexString:@"#787fc6"];
    
    [self.view addSubview:lineV];
    
    UIView *lineV1 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 150, accountTextField.bottom , 300, 1)];
    
    lineV1.backgroundColor = [RGBColor colorWithHexString:@"#787fc6"];
    
    [self.view addSubview:lineV1];
    
    UIView *lineV2 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 + 150 -1, accountTextField.bottom - 10, 1, 10)];
    
    lineV2.backgroundColor = [RGBColor colorWithHexString:@"#787fc6"];
    
    [self.view addSubview:lineV2];
    
    UIView *lineV3 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 150, passwordTextField.bottom - 10, 1, 10)];
    
    lineV3.backgroundColor = [RGBColor colorWithHexString:@"#787fc6"];
    
    [self.view addSubview:lineV3];
    
    UIView *lineV4 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 150, passwordTextField.bottom , 300, 1)];
    
    lineV4.backgroundColor = [RGBColor colorWithHexString:@"#787fc6"];
    
    [self.view addSubview:lineV4];
    
    UIView *lineV5 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 + 150 -1, passwordTextField.bottom - 10, 1, 10)];
    
    lineV5.backgroundColor = [RGBColor colorWithHexString:@"#787fc6"];
    
    [self.view addSubview:lineV5];

    
    UIButton *bindingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    bindingButton.backgroundColor = [RGBColor colorWithHexString:@"#787fc6"];

    bindingButton.frame = CGRectMake(kScreenWidth/2 -140, passwordTextField.bottom+30, 280, 48);

    [bindingButton setTitle:@"绑定" forState:UIControlStateNormal];
    
    bindingButton.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [bindingButton addTarget:self action:@selector(bindingButtonAction) forControlEvents:UIControlEventTouchUpInside];
    bindingButton.layer.masksToBounds = YES;
    bindingButton.layer.cornerRadius = 4;
    
    [self.view addSubview:bindingButton];
    
    if (_dataDic[@"id"]) {
        
        UIButton *JCBDButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        JCBDButton.backgroundColor = [RGBColor colorWithHexString:@"#ffffff"];
        
        JCBDButton.frame = CGRectMake(kScreenWidth/2 -140, bindingButton.bottom+20, 280, 48);
        
        [JCBDButton setTitle:@"解绑" forState:UIControlStateNormal];
        [JCBDButton setTitleColor:[RGBColor colorWithHexString:@"#787fc6"] forState:UIControlStateNormal];
        JCBDButton.titleLabel.font = [UIFont systemFontOfSize:20];
        
        [JCBDButton addTarget:self action:@selector(JCBDButtonAction) forControlEvents:UIControlEventTouchUpInside];
        JCBDButton.layer.masksToBounds = YES;
        JCBDButton.layer.cornerRadius = 4;
        
        [self.view addSubview:JCBDButton];
        
        accountTextField.placeholder = _dataDic[@"phone"];

        passwordTextField.placeholder = _dataDic[@"password"];

    }
    
    
    //隐藏键盘
    UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleAction)];;
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    singleRecognizer.cancelsTouchesInView = NO;
    //给self.view添加一个手势监测；
    
    [self.view addGestureRecognizer:singleRecognizer];
    

    
}

- (void)singleAction{

    [passwordTextField resignFirstResponder];
    
    [accountTextField resignFirstResponder];

}

//解除绑定
- (void)JCBDButtonAction{

    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    [params setObject:_dataDic[@"id"] forKey:@"id"];
    [DataSeviece requestUrl:delete_share_accounthtml params:params success:^(id result) {
        
        NSLog(@"%@",result);
        
        if ([result[@"result"][@"code"] isEqualToString:@"1"]) {
            
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            alertV.message = result[@"result"][@"msg"];
            [alertV show];
        }

        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    


}

//绑定
- (void)bindingButtonAction{

    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    
    [params setObject:accountTextField.text forKey:@"phone"];
    
    [params setObject:passwordTextField.text forKey:@"password"];
    
    [params setObject:_dataDic[@"type"] forKey:@"type"];
    
    NSString *url = @"";
    
    if (_dataDic[@"id"]) {
        
        url = edit_share_accounthtml;
        
        [params setObject:_dataDic[@"id"] forKey:@"id"];
        
    }else{
        
        url = Shareadd_share_accounthtml;
        
    }
    
    [DataSeviece requestUrl:url params:params success:^(id result) {
        
        NSLog(@"%@",result);
        
        if ([result[@"result"][@"code"] isEqualToString:@"1"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
 
        }else{
            alertV.message = result[@"result"][@"msg"];
            [alertV show];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}


//左边返回按钮
- (void)leftBtnAction{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}




@end
