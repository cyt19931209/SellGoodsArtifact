//
//  AccountListViewController.m
//  奢易购3.0
//
//  Created by Andy on 2016/11/4.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import "AccountListViewController.h"
#import "AccountListCell.h"
#import "AccountBindingViewController.h"

@interface AccountListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UITableView *myTableView;


@end

@implementation AccountListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArr = [NSMutableArray array];
    //改变导航栏标题的字体颜色和大小
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WBNoti) name:@"AccountNotification" object:nil];

    
    if ([_titleStr isEqualToString:@"ponhu"]) {
        
        self.navigationItem.title = @"胖虎";

    }else if ([_titleStr isEqualToString:@"aidingmao"]){
        
        self.navigationItem.title = @"爱丁猫";

    }else if ([_titleStr isEqualToString:@"sae"]){
        self.navigationItem.title = @"微博";

    }
    

    //左边Item
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 10, 19);
    [leftBtn setImage:[UIImage imageNamed:@"返回（20x38）"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    self.view.backgroundColor = [RGBColor colorWithHexString:@"#f1f2fa"];
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    
    _myTableView.delegate = self;
    
    _myTableView.dataSource = self;
    
    _myTableView.backgroundColor = [RGBColor colorWithHexString:@"#f1f2fa"];
    
    [self.view addSubview:_myTableView];

    [_myTableView registerNib:[UINib nibWithNibName:@"AccountListCell" bundle:nil] forCellReuseIdentifier:@"AccountListCell"];

    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 72)];
    
    footView.backgroundColor = [RGBColor colorWithHexString:@"#f1f2fa"];
    
    UIButton *footButton  =[UIButton buttonWithType:UIButtonTypeCustom];
    
    footButton.frame = CGRectMake(kScreenWidth/2 - 145, 24, 290, 48);
    
    footButton.backgroundColor = [RGBColor colorWithHexString:@"#787fc6"];
    
    [footButton addTarget:self action:@selector(footButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [footButton setTitle:@"添加新账号" forState:UIControlStateNormal];
    
    footButton.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [footButton setTitleColor:[RGBColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    
    [footView addSubview:footButton];
    
    _myTableView.tableFooterView = footView;
    


}

//加载
- (void)loadData{
    
    [_dataArr removeAllObjects];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    
    [params setObject:_titleStr forKey:@"type"];
    
    [DataSeviece requestUrl:Shareget_share_accounthtml params:params success:^(id result) {
        
        NSLog(@"%@ %@",result,result[@"result"][@"msg"]);
        
        NSArray *arr = result[@"result"][@"data"][@"item"];
        
        for (NSDictionary *dic in arr) {
            
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithDictionary:dic];

            NSDictionary *dic2 = [defaults objectForKey:[NSString stringWithFormat:@"%@share",SYGData[@"id"]]][_titleStr];
            
            if (dic2) {
                if ([dic2[@"id"] isEqualToString:dic[@"id"]]) {
                  
                    [dic1 setObject:@"1" forKey:@"select"];
                    
                }else{
                
                    [dic1 setObject:@"0" forKey:@"select"];

                }
                
            }
            
            [_dataArr addObject:[dic1 copy]];
        }
        
        [_myTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


- (void)footButtonAction{
    if (![_titleStr isEqualToString:@"sae"]) {

        AccountBindingViewController *AccountBindingVC = [[AccountBindingViewController alloc]init];
        
        AccountBindingVC.dataDic = @{@"type":_titleStr};
        
        [self.navigationController pushViewController:AccountBindingVC animated:YES];
        
        
    }else{
        
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kRedirectURI;
        request.scope = @"all";
        request.userInfo = nil;
        [WeiboSDK sendRequest:request];
        
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _dataArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AccountListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountListCell" forIndexPath:indexPath];
    

    if (![_titleStr isEqualToString:@"sae"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    
    cell.dic = _dataArr[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (![_titleStr isEqualToString:@"sae"]) {
        
        AccountBindingViewController *AccountBindingVC = [[AccountBindingViewController alloc]init];
        
        AccountBindingVC.dataDic = _dataArr[indexPath.row];
        
        [self.navigationController pushViewController:AccountBindingVC animated:YES];
        
 
    }
    
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 48;
}

- (void)WBNoti{
    
    [self loadData];

    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self loadData];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

//左边返回按钮
- (void)leftBtnAction{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountNotification" object:nil];

    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
