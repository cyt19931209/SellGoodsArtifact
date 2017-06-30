//
//  FinanceViewController.m
//  奢易购3.0
//
//  Created by guest on 16/7/20.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import "FinanceViewController.h"
#import "FinanceCell.h"
#import "FinancialModel.h"
#import "PersonelModel.h"
#import "StaffEditorViewController.h"


@interface FinanceViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{

    BOOL flag;
    UIImageView *typeImageV;
    UILabel *typelabel;
    UITextField *numbelTextField;
    UITextField *nameTextField;
    UITextField *passwordTextField;
    UIView *passwordView;
}

@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) UIView *zzView;
@property (nonatomic,strong) UIView *addView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UITableView *downTableView;
@property (nonatomic,strong) NSArray *downArr;

@end

@implementation FinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popAction) name:@"NSNotificationPOP" object:nil];
    
    _dataArr = [NSMutableArray array];

    
    //设置标题
    if (_isPersonnel) {
        self.navigationItem.title = @"人员账号管理";

    }else{
        self.navigationItem.title = @"财务账号管理";
    }
    
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
    [rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editAction:)];
    
    
    //表示图
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.backgroundColor = [RGBColor colorWithHexString:@"f1f2fa"];

    [self.view addSubview:_myTableView];
    
    [_myTableView registerNib:[UINib nibWithNibName:@"FinanceCell" bundle:nil] forCellReuseIdentifier:@"FinanceCell"];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    
    footerView.backgroundColor = [UIColor clearColor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    if ([SYGData[@"type"] isEqualToString:@"3"]&&_isPersonnel) {
        
        
    }else{

    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(10, 82, kScreenWidth-20, 48);
    [addButton setImage:[UIImage imageNamed:@"添加初始.png"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"添加点击.png"] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addButton];
    _myTableView.tableFooterView = footerView;
    }
    
    //遮罩视图
    _zzView = [[UIView alloc]initWithFrame:CGRectMake(0, -84, kScreenWidth, kScreenHeight+84)];
    _zzView.backgroundColor = [RGBColor colorWithHexString:@"2d2d2d"];
    _zzView.alpha = .4;
    _zzView.hidden = YES;
    [self.view addSubview:_zzView];
    
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.frame = _zzView.frame;
    [bgButton addTarget:self action:@selector(bgButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_zzView addSubview:bgButton];

    
    //添加选项
 
    _addView= [[UIView alloc]initWithFrame:CGRectMake(10, kScreenHeight/2-200+42, kScreenWidth-20, 350)];
    _addView.backgroundColor = [RGBColor colorWithHexString:@"#f7f7fb"];
    _addView.alpha = 1;
    _addView.hidden = YES;
    _addView.layer.cornerRadius = 5;
    _addView.layer.masksToBounds = YES;
    [self.view addSubview:_addView];

    //隐藏键盘
    UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleAction)];;
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    singleRecognizer.cancelsTouchesInView = NO;
    //给self.view添加一个手势监测；
    
    [_addView addGestureRecognizer:singleRecognizer];
    
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_addView.width/2-100, 18, 200, 30)];
    if (_isPersonnel) {
        titleLabel.text = @"添加人员账号";
    }else{
        titleLabel.text = @"添加财务账号";
    }
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [RGBColor colorWithHexString:@"#787fc6"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_addView addSubview:titleLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 55, kScreenWidth-20, 1)];
    line1.backgroundColor = [RGBColor colorWithHexString:@"#999999"];
    [_addView addSubview:line1];
    
    UIView *bgV = [[UIView alloc]initWithFrame:CGRectMake(0, 56, kScreenWidth, 88)];
    bgV.backgroundColor = [UIColor whiteColor];
    [_addView addSubview:bgV];
    
    UIView *bgV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 219, kScreenWidth, 44)];
    bgV1.backgroundColor = [UIColor whiteColor];
    [_addView addSubview:bgV1];

    
    //姓名
    UIImageView *signImageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, line1.bottom+17, 9, 9)];
    signImageV.image = [UIImage imageNamed:@"星标.png"];
    [_addView addSubview:signImageV];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(signImageV.right+10,line1.bottom+14, 80, 16)];
    if (_isPersonnel) {
        nameLabel.text = @"人员姓名:";
    }else{
        nameLabel.text = @"使用者姓名:";
    }
    nameLabel.textColor = [RGBColor colorWithHexString:@"#333333"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    [_addView addSubview:nameLabel];
    
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(nameLabel.right, nameLabel.top, 200, 16)];
    nameTextField.delegate = self;
    [_addView addSubview:nameTextField];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 99, kScreenWidth-20, 1)];
    line2.backgroundColor = [RGBColor colorWithHexString:@"#999999"];
    [_addView addSubview:line2];

    //账号
    UIImageView *signImageV1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, line2.bottom+17, 9, 9)];
    signImageV1.image = [UIImage imageNamed:@"星标.png"];
    [_addView addSubview:signImageV1];
    
    UILabel *numbelLabel = [[UILabel alloc]initWithFrame:CGRectMake(signImageV1.right+10,line2.bottom+14, 80, 16)];
    if (_isPersonnel) {
        numbelLabel.text = @"人员电话:";
    }else{
        numbelLabel.text = @"财务账号:";
    }
    numbelLabel.textColor = [RGBColor colorWithHexString:@"#333333"];
    numbelLabel.font = [UIFont systemFontOfSize:14];
    [_addView addSubview:numbelLabel];
    
    numbelTextField = [[UITextField alloc]initWithFrame:CGRectMake(numbelLabel.right, numbelLabel.top, 200, 16)];
    numbelTextField.delegate = self;
    [_addView addSubview:numbelTextField];

    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 143, kScreenWidth-20, 1)];
    line3.backgroundColor = [RGBColor colorWithHexString:@"#999999"];
    [_addView addSubview:line3];
    
    //密码
    passwordView = [[UIView alloc]initWithFrame:CGRectMake(0, 144, kScreenWidth-20, 44)];
    passwordView.backgroundColor = [UIColor whiteColor];
    passwordView.hidden = YES;
    [_addView addSubview:passwordView];
    
    UIImageView *signImageV2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 17, 9, 9)];
    signImageV2.image = [UIImage imageNamed:@"星标.png"];
    [passwordView addSubview:signImageV2];
    
    UILabel *numbelLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(signImageV2.right+10,14, 75, 16)];
    numbelLabel1.text = @"密码:";
    numbelLabel1.textColor = [RGBColor colorWithHexString:@"#333333"];
    numbelLabel1.font = [UIFont systemFontOfSize:14];
    [passwordView addSubview:numbelLabel1];
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(numbelLabel1.right, numbelLabel1.top, 200, 16)];
    [passwordView addSubview:passwordTextField];
    passwordTextField.delegate = self;
    UIView *line10 = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth-20, 1)];
    line10.backgroundColor = [RGBColor colorWithHexString:@"#999999"];
    [passwordView addSubview:line10];


    if (_isPersonnel) {
        signImageV.hidden = NO;
        signImageV1.hidden = YES;
    }else{
        signImageV.hidden = YES;
        signImageV1.hidden = NO;
    }

    //选择账号类型
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, line3.bottom+50,75 ,15)];
    typeLabel.textColor =  [RGBColor colorWithHexString:@"#999999"];
    typeLabel.text = @"选择账号类型";
    typeLabel.font = [UIFont systemFontOfSize:11];
    [_addView addSubview:typeLabel];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, typeLabel.bottom+10, kScreenWidth-20, 1)];
    line4.backgroundColor = [RGBColor colorWithHexString:@"#999999"];
    [_addView addSubview:line4];

    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, typeLabel.bottom+54, kScreenWidth-20, 1)];
    line5.backgroundColor = [RGBColor colorWithHexString:@"#999999"];
    [_addView addSubview:line5];
    
    UIButton *typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    typeButton.frame = bgV1.bounds;
    [typeButton addTarget:self action:@selector(typeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgV1 addSubview:typeButton];
    
    typeImageV = [[UIImageView alloc]initWithFrame:CGRectMake(_addView.width/2-32, 6, 32, 32)];
    typeImageV.image = [UIImage imageNamed:@"微信.png"];
    [bgV1 addSubview:typeImageV];
    
    typelabel = [[UILabel alloc]initWithFrame:CGRectMake(_addView.width/2+10, 15, 50, 14)];
    typelabel.text = @"微信";
    typelabel.textColor = [RGBColor colorWithHexString:@"#999999"];
    typelabel.font = [UIFont systemFontOfSize:11];
    [bgV1 addSubview:typelabel];
    
    if (_isPersonnel) {
        typeImageV.image = [UIImage imageNamed:@"店员（64x64）"];
        typelabel.text = @"店员";
    }else{
        typeImageV.image = [UIImage imageNamed:@"支付宝.png"];
        typelabel.text = @"支付宝";
    }

    _downTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, kScreenHeight/2-200+42+199+44+20, kScreenWidth-20, 3*44) style:UITableViewStylePlain];
    
    _downTableView.dataSource = self;
    
    _downTableView.delegate = self;
    _downTableView.hidden = YES;
    [self.view addSubview:_downTableView];
    
//    [_downTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DownTableViewCell"];
//
    //帐号类型
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
//    
    [DataSeviece requestUrl:get_account_typehtml params:[@{@"uid":SYGData[@"id"]} mutableCopy] success:^(id result) {
        NSLog(@"%@",result);
        _downArr = result[@"result"][@"data"][@"item"];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

    
    
    //确定按钮
    
    UIButton *tureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tureButton.frame = CGRectMake(10, bgV1.bottom+42, _addView.width-20, 40);
    [tureButton setImage:[UIImage imageNamed:@"添加初始.png"] forState:UIControlStateNormal];
    [tureButton setImage:[UIImage imageNamed:@"添加点击.png"] forState:UIControlStateHighlighted];
    [tureButton addTarget:self action:@selector(tureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_addView addSubview:tureButton];
    
    

    
    if (_isPersonnel) {
        
        [self loadData1];
    }else{
        
        [self loadData];

    }
    
}

- (void)bgButtonAction{

    _zzView.hidden = YES;
    _addView.hidden = YES;
    _downTableView.hidden = YES;
    [nameTextField resignFirstResponder];
    [numbelTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];

}

//加载数据财务管理
- (void)loadData{
    
    //网络加载
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    
    [DataSeviece requestUrl:get_accounthtm_API params:[@{@"uid":SYGData[@"id"]} mutableCopy] success:^(id result) {
        
        NSLog(@"%@",result);
        
        for (NSDictionary *dic in result[@"result"][@"data"][@"item"]) {
            FinancialModel *model = [[FinancialModel alloc]initWithContentsOfDic:[NULLHandle NUllHandle:dic]];
            model.financialId = dic[@"id"];
            [_dataArr addObject:model];
        }
        [_myTableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

//人员管理数据
- (void)loadData1{

    //网络加载
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    
    [DataSeviece requestUrl:get_userhtml params:[@{@"uid":SYGData[@"id"]} mutableCopy] success:^(id result) {
        
        NSLog(@"%@",result);
        NSString *msgStr = result[@"result"][@"msg"];
        NSLog(@"%@",msgStr);
        
        for (NSDictionary *dic in result[@"result"][@"data"][@"item"]) {
            PersonelModel *model = [[PersonelModel alloc]initWithContentsOfDic:[NULLHandle NUllHandle:dic]];
            model.personelId = dic[@"id"];
            [_dataArr addObject:model];
        }
        [_myTableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}


//确定添加
- (void)tureButtonAction{
    
//    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    NSString *url;
    if (_isPersonnel) {
//        if (![self isMobile:numbelTextField.text]) {
//            
//            alertV.message = @"手机号格式不正确";
//            [alertV show];
//            return;
//        }
        

        url = add_userhtml;
        [params setObject:numbelTextField.text forKey:@"mobile"];
        [params setObject:nameTextField.text forKey:@"user_name"];

        NSArray *arr = @[@"老板",@"主帐号",@"店员"];

        for (int i = 0; i<3; i++) {
            if ([arr[i] isEqualToString:typelabel.text]) {
                [params setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"type"];
            }
        }
        [params setObject:passwordTextField.text forKey:@"password"];
    }else{
        url = add_accounthtml;
        [params setObject:nameTextField.text forKey:@"use_name"];

        [params setObject:numbelTextField.text forKey:@"account"];
    for (NSDictionary *dic in _downArr) {
        if ([dic[@"name"] isEqualToString:typelabel.text]) {
            [params setObject:dic[@"id"] forKey:@"type"];
        }
    }
    }
    [DataSeviece requestUrl:url params:params success:^(id result) {
        
        NSLog(@"%@",result);
        
         if ([result[@"result"][@"code"] isEqualToString:@"1"]) {
            _zzView.hidden = YES;
            _addView.hidden = YES;
            [_dataArr removeAllObjects];
            if (_isPersonnel) {
                [self loadData1];
            }else{
               [self loadData];
            }
        }else{
            
            NSString *str = result[@"result"][@"msg"];
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
            NSLog(@"%@",str);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}
//手机号验证
- (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349|77)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    return NO;
}

//选择类型
- (void)typeButtonAction{
    
    
    NSLog(@"11");
    
    _downTableView.hidden = !_downTableView.hidden;
    
    flag = !flag;
    
    [_downTableView reloadData];
    
}

//添加账号
- (void)addButtonAction{
    
    numbelTextField.text = @"";
    nameTextField.text = @"";
    passwordTextField.text = @"";

    _zzView.hidden = NO;
    _addView.hidden = NO;
    
}

//左边返回按钮
- (void)leftBtnAction{
    
    if (_isPersonnel) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SticksNotification" object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//右边编辑按钮
-(void)editAction:(UIButton*)bt{
    
    //当前tableView的是否正在编辑
    BOOL editing = _myTableView.editing;
    
    if (editing) {
        
        [bt setTitle:@"编辑" forState:UIControlStateNormal];
        [_myTableView setEditing:NO animated:YES];
    }else{
        
        [bt setTitle:@"完成" forState:UIControlStateNormal];
        [_myTableView setEditing:YES animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource UITableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _myTableView) {
        return _dataArr.count;
    }else{
        if (flag) {
            if (_isPersonnel) {
                return 2;
            }else{
                return _downArr.count;
            }
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _myTableView) {
        
        FinanceCell *cell = [_myTableView dequeueReusableCellWithIdentifier:@"FinanceCell" forIndexPath:indexPath];
        if (_isPersonnel) {
            cell.model1 = _dataArr[indexPath.row];
        }else{
        
            cell.model = _dataArr[indexPath.row];
        }
        
        return cell;

    }else{
        
        UITableViewCell *cell = [_downTableView dequeueReusableCellWithIdentifier:@"DownTableViewCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DownTableViewCell"];
            UIImageView *typeImageV1 = [[UIImageView alloc]initWithFrame:CGRectMake(_addView.width/2-32, 6, 32, 32)];
            typeImageV1.tag = 2000;
            [cell.contentView addSubview:typeImageV1];
            
            UILabel *typelabel1 = [[UILabel alloc]initWithFrame:CGRectMake(_addView.width/2+10, 15, 50, 14)];
            typelabel1.textColor = [RGBColor colorWithHexString:@"#999999"];
            typelabel1.font = [UIFont systemFontOfSize:11];
            typelabel1.tag = 2001;
            [cell.contentView addSubview:typelabel1];

        }
        
        UIImageView *typeImageV1 = [cell.contentView viewWithTag:2000];
        
        UILabel *typelabel1 = [cell.contentView viewWithTag:2001];
        
        
        if (_isPersonnel) {
            NSArray *arr = @[@"老板",@"店员"];
            NSArray *imgArr = @[@"老板（64x64）",@"店员（64x64）"];
            typelabel1.text = arr[indexPath.row];
            typeImageV1.image = [UIImage imageNamed:imgArr[indexPath.row]];
        }else{
        
            typelabel1.text = _downArr[indexPath.row][@"name"];
            typeImageV1.image = [UIImage imageNamed:_downArr[indexPath.row][@"name"]];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == _downTableView) {
        
        if (_isPersonnel) {
            NSArray *arr = @[@"老板",@"店员"];
            NSArray *imgArr = @[@"老板（64x64）",@"店员（64x64）"];
            typelabel.text = arr[indexPath.row];
            typeImageV.image = [UIImage imageNamed:imgArr[indexPath.row]];

            if (indexPath.row == 1) {
                passwordView.hidden = YES;
            }else{
                passwordView.hidden = NO;
            }
        }else{
            typeImageV.image = [UIImage imageNamed:_downArr[indexPath.row][@"name"]];
            typelabel.text = _downArr[indexPath.row][@"name"];
        }
        flag = NO;
        _downTableView.hidden = YES;
    }else if (tableView == _myTableView){
    
        if (_isPersonnel) {
            StaffEditorViewController *staffVC = [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"StaffEditorViewController"];
            staffVC.model = _dataArr[indexPath.row];
            [self.navigationController pushViewController:staffVC animated:YES];
            
        }
    
    }
    
    

}

//是否可以编辑，如果返回值是no，不可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

//返回每一行编辑的风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row==0) {
//        
//        //可以根据不同的行数返回不同的编辑模式   插入（添加）
//        return UITableViewCellEditingStyleInsert;
//    }
    
    return UITableViewCellEditingStyleDelete;
    //    删除
    //    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
    
}

//具体实现添加或删除，执行的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (indexPath.row == 0) {
        if (_isPersonnel) {

            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"主账号不能删除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
            return;

        }else{
            
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"现金支付不能删除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
            return;
            
        }
        
    }

    
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    NSString *url;
    if (_isPersonnel) {
        
        PersonelModel *model = _dataArr[indexPath.row];
        [params setObject:model.personelId forKey:@"id"];
        url = delete_userhtml;
    }else{
    
        FinancialModel *model = _dataArr[indexPath.row];
    
        [params setObject:model.financialId forKey:@"id"];
        url = delete_accounthtml;
    }
    [DataSeviece requestUrl:url params:params success:^(id result) {
        
        NSLog(@"%@",result);
        if ([result[@"result"][@"code"] isEqualToString:@"1"]) {
            
            [_dataArr removeObjectAtIndex:indexPath.row];
            
            [_myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  
        }else{
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

- (void)singleAction{
    
    [nameTextField resignFirstResponder];
    [numbelTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

- (void)popAction{
    [_dataArr removeAllObjects];
    
    [self loadData1];

}

@end
