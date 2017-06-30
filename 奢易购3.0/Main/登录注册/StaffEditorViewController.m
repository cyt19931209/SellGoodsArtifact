//
//  StaffEditorViewController.m
//  奢易购3.0
//
//  Created by Andy on 16/9/12.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import "StaffEditorViewController.h"

@interface StaffEditorViewController (){

    UIView *selectView;
    UIView *passwordView;
    UITextField *passwordTextField;
}


@end

@implementation StaffEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //设置标题
    self.navigationItem.title = @"人员资料编辑";
        
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //改变导航栏标题的字体颜色和大小
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [RGBColor colorWithHexString:@"f1f2fa"];
    
    
    //左边Item
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 10, 19);
    [leftBtn setImage:[UIImage imageNamed:@"返回（20x38）"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    //右边Item
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 35, 30);
    rightBtn.tag = 100;
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    _nameTextField.text = _model.user_name;
    
    _phoneTextField.text = _model.mobile;
    
    [self passwordView];

    
    if ([_model.type isEqualToString:@"1"]) {
        _iconImageV.image = [UIImage imageNamed:@"老板（64x64）"];
        _typeLabe.text = @"老板";
        passwordView.hidden = NO;
    }else if ([_model.type isEqualToString:@"2"]){
        _iconImageV.image = [UIImage imageNamed:@"主帐号（64x64）"];
        _typeLabe.text = @"主帐号";
    }else if ([_model.type isEqualToString:@"3"]){
        _iconImageV.image = [UIImage imageNamed:@"店员（64x64）"];
        _typeLabe.text = @"店员";
    }
    
    selectView = [[UIView alloc]initWithFrame:CGRectMake(100, 132, kScreenWidth-150, 88)];
    selectView.backgroundColor = [UIColor whiteColor];
    selectView.hidden = YES;
    [self.view addSubview:selectView];
    
    NSArray *arr = @[@"老板",@"店员"];
    NSArray *imgArr = @[@"老板（64x64）",@"店员（64x64）"];

    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 44*i, selectView.width, 44);
        
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;
        
        [selectView addSubview:button];
        
        UIImageView *typeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 6+i*44, 32, 32)];
        [selectView addSubview:typeImageV];
        
        UILabel *typelabel = [[UILabel alloc]initWithFrame:CGRectMake(48, 15+i*44, 50, 14)];
        typelabel.textColor = [RGBColor colorWithHexString:@"#666666"];
        typelabel.font = [UIFont systemFontOfSize:15];
        [selectView addSubview:typelabel];

        typelabel.text = arr[i];
        typeImageV.image = [UIImage imageNamed:imgArr[i]];
    }
    
    
}

//左边返回按钮
- (void)leftBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    [params setObject:_nameTextField.text forKey:@"user_name"];
    [params setObject:_phoneTextField.text forKey:@"mobile"];
    
    if ([_typeLabe.text isEqualToString:@"老板"]) {
        [params setObject:@"1" forKey:@"type"];
        
        if ([passwordTextField.text isEqualToString:@""]) {
            
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alertV show];
            
            return;
        }
        
        [params setObject:passwordTextField.text forKey:@"password"];
    }else if([_model.type isEqualToString:@"2"]){
        [params setObject:@"2" forKey:@"type"];
    }else{
        [params setObject:@"3" forKey:@"type"];
    }
    [params setObject:_model.personelId forKey:@"id"];
    
    
    [DataSeviece requestUrl:edit_userhtml params:params success:^(id result) {
        NSLog(@"%@",result[@"result"][@"msg"]);
        if ([result[@"result"][@"code"] isEqualToString:@"1"]) {
            if ([_typeLabe.text isEqualToString:@"老板"]) {

                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:SYGData];
                if ([_model.personelId isEqualToString:SYGData[@"id"]]) {
                    [dic setObject:passwordTextField.text forKey:@"password"];
                    [dic setObject:@"1" forKey:@"type"];

                }
                [defaults setObject:dic forKey:@"SYGData"];
                
                [defaults synchronize];

            }else if([_model.type isEqualToString:@"2"]){
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:SYGData];
                if ([_model.personelId isEqualToString:SYGData[@"id"]]) {

                [dic setObject:@"2" forKey:@"type"];
                }
                [defaults setObject:dic forKey:@"SYGData"];
                
                [defaults synchronize];
            }else{
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:SYGData];
                if ([_model.personelId isEqualToString:SYGData[@"id"]]) {

                [dic setObject:@"3" forKey:@"type"];
                }
                [defaults setObject:dic forKey:@"SYGData"];
                [defaults synchronize];
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationPOP" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示"  message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertV.message = result[@"result"][@"msg"];
            [alertV show];
        }
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 2) {
        if (![_model.type isEqualToString:@"2"]) {
            selectView.hidden = NO;
        }
    }
}

//选择类型
- (void)selectAction:(UIButton*)bt{

    NSArray *arr = @[@"老板",@"店员"];
    NSArray *imgArr = @[@"老板（64x64）",@"店员（64x64）"];

    _typeLabe.text = arr[bt.tag-100];
    _iconImageV.image = [UIImage imageNamed:imgArr[bt.tag-100]];
    selectView.hidden = YES;
    
    if (bt.tag == 100) {
        
        passwordView.hidden = NO;
    }else{
    
        passwordView.hidden = YES;

    }
    
}


- (void)passwordView{

    
    passwordView = [[UIView alloc]initWithFrame:CGRectMake(0, 44*3, kScreenWidth, 44)];
    
    passwordView.backgroundColor = [RGBColor colorWithHexString:@"#ffffff"];
    passwordView.hidden = YES;
    [self.view addSubview:passwordView];
    
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    
    lineV.backgroundColor = [RGBColor colorWithHexString:@"#d9d9d9"];
    
    [passwordView addSubview:lineV];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 11, 71, 21)];
    
    titleLabel.textColor = [RGBColor colorWithHexString:@"#666666"];
    
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    titleLabel.text = @"密码";
    
    [passwordView addSubview:titleLabel];
    
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 7, 200, 30)];
    
    passwordTextField.textColor = [RGBColor colorWithHexString:@"#666666"];
    
    passwordTextField.font = [UIFont systemFontOfSize:15];
    
    passwordTextField.placeholder = @"请输入密码";
    
    [passwordView addSubview:passwordTextField];

}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}






@end
