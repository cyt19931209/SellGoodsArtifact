//
//  ReleaseCompleteViewController.m
//  奢易购3.0
//
//  Created by Andy on 2016/10/28.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import "ReleaseCompleteViewController.h"
#import "OneButtonPublishingViewController.h"
#import "MBProgressHUD.h"
#import "SharedItem.h"
#import "AppDelegate.h"

@interface ReleaseCompleteViewController ()<UITableViewDelegate,UITableViewDataSource>{

    UIView *bgView;
    UIView *errorView;

}

@property (nonatomic,strong) NSMutableArray *errorArr;



@end

@implementation ReleaseCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _errorArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //左边Item
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 10, 19);
    [leftBtn setImage:[UIImage imageNamed:@"Back Chevron@2x"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    
    
    if (!_isCopy && !_isUpData) {
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, 75, 28);
        
        
        [rightBtn setTitle:@"再发一件" forState:UIControlStateNormal];
        
        [rightBtn setTitleColor:[RGBColor colorWithHexString:@"#949dff"] forState:UIControlStateNormal];
        
        [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem * rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        
        self.navigationItem.rightBarButtonItem = rightButtonItem;

    }
    


    [self createUI];

}

- (void)rightBtnAction{

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    
    NSArray *typeArr = @[@"ponhu",@"aidingmao",@"vdian",@"luxusj",@"newshang",@"shopuu",@"alaying",@"aidingmaopro",@"aidingmaomer",@"jiuai",@"kongkonghu",@"xiaohongshu"];
    
    NSArray *selectTypeArr = [defaults objectForKey:[NSString stringWithFormat:@"%@Type",SYGData[@"id"]]];
    
    OneButtonPublishingViewController *OneButtonPublishingVC = [[UIStoryboard storyboardWithName:@"AddNew" bundle:nil] instantiateViewControllerWithIdentifier:@"OneButtonPublishingViewController"];
    OneButtonPublishingVC.typeArr = typeArr;
    
    OneButtonPublishingVC.selectTypeArr = selectTypeArr;
    
    OneButtonPublishingVC.isOnePush = YES;
    
    [self.navigationController pushViewController:OneButtonPublishingVC animated:YES];

    
}

//加载视图
- (void)createUI{
    
    UIImageView *topImageV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 35, 50, 70, 70)];
    
    topImageV.image = [UIImage imageNamed:@"done@2x"];
    
    [self.view addSubview:topImageV];
    
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 -112, topImageV.bottom+20, 224, 50)];
    
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    if (_arr.count == 0) {
        textLabel.text = @"信息已保存至我的商品请选择微博/微信转发";
    }else{
        textLabel.text = @"商品信息已提交至您选择的平台请等待平台审核";
    }

    
    textLabel.numberOfLines = 0;
    
    textLabel.font = [UIFont systemFontOfSize:16];
    
    textLabel.textColor = [RGBColor colorWithHexString:@"#666666"];
    
    [self.view addSubview:textLabel];
    
    
    UILabel *TJLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (kScreenHeight - 64)/566 * 241, kScreenWidth, 20)];
    
    TJLabel.textColor = [RGBColor colorWithHexString:@"#666666"];
    TJLabel.font = [UIFont systemFontOfSize:16];
    TJLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:TJLabel];
    
    
    for (NSDictionary *dic in _arr) {
    
        if (![dic[@"isSuccess"] isEqualToString:@"1"]) {
            
            [_errorArr addObject:dic];
        }
    }
    
    if (_arr.count == 0) {
        
        TJLabel.text = @"";
    }else{
        
        TJLabel.text = [NSString stringWithFormat:@"有%ld家平台发送失败",(unsigned long)_errorArr.count];
        
        UIButton *errorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        errorButton.backgroundColor = [RGBColor colorWithHexString:@"#949dff"];
        
        errorButton.frame = CGRectMake(kScreenWidth/2 - 60, TJLabel.bottom+20, 120, 34);
        
        [errorButton setTitle:@"查看失败原因" forState:UIControlStateNormal];
        
        [errorButton setTitleColor:[RGBColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        
        errorButton.titleLabel.font = [UIFont systemFontOfSize:16];
        
        errorButton.layer.cornerRadius = 5;
        errorButton.layer.masksToBounds = YES;
        [errorButton addTarget:self action:@selector(errorButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:errorButton];

        if (_errorArr.count == 0) {
            
            errorButton.hidden = YES;
            
            TJLabel.text = @"您上传的平台全部成功";

        }
        
    }

    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, TJLabel.bottom + 64, kScreenWidth - 40, 1)];
    
    view.backgroundColor = [RGBColor colorWithHexString:@"#d3d3d3"];
    
    [self.view addSubview:view];
    
    if (_arr.count == 0) {
        
        view.hidden = YES;
        
        UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"箭头"]];

        imageV.frame = CGRectMake(kScreenWidth/2 - 20.5 , textLabel.bottom + 30, 41, 48);
        
        [self.view addSubview:imageV];
        
    }else{
        
        view.hidden = NO;
        
    }

   
    //微信
    UIButton *WXButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    WXButton.frame = CGRectMake(35, (kScreenHeight - 64)/566 * 342, kScreenWidth - 70,48);
    
    WXButton.layer.cornerRadius = 4;
    WXButton.layer.masksToBounds = YES;
    
    WXButton.layer.borderWidth = 1;
    WXButton.layer.borderColor = [RGBColor colorWithHexString:@"#3CB034"].CGColor;
    
    [WXButton setTitle:@"点击发布至朋友圈" forState:UIControlStateNormal];
    
    [WXButton setTitleColor:[RGBColor colorWithHexString:@"#3CB034"] forState:UIControlStateNormal];
    
    WXButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [WXButton addTarget:self action:@selector(WXButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:WXButton];
    
    UIImageView *WXImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"微信@2x"]];
    
    WXImageV.frame = CGRectMake(10, 7, 34, 34);
    
    [WXButton addSubview:WXImageV];
    
    UIImageView *DJWXImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"点击 copy"]];
    
    DJWXImageV.frame = CGRectMake(WXButton.width - 25 - 12, 9, 25, 30);
    
    [WXButton addSubview:DJWXImageV];

    
    //微博
    
    UIButton *WBButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    WBButton.frame = CGRectMake(35, WXButton.bottom + 10, kScreenWidth - 70,48);
    WBButton.layer.cornerRadius = 4;
    WBButton.layer.masksToBounds = YES;
    WBButton.layer.borderWidth = 1;
    WBButton.layer.borderColor = [RGBColor colorWithHexString:@"#FFD236"].CGColor;
    [WBButton setTitle:@"点击发布至微博" forState:UIControlStateNormal];
    
    [WBButton setTitleColor:[RGBColor colorWithHexString:@"#FFD236"] forState:UIControlStateNormal];
    
    WBButton.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [WBButton addTarget:self action:@selector(WBButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:WBButton];
    
    UIImageView *WBImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sina@2x"]];
    
    WBImageV.frame = CGRectMake(10, 7, 34, 34);
    
    [WBButton addSubview:WBImageV];
    
    UIImageView *DJWBImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"点击"]];
    
    DJWBImageV.frame = CGRectMake(WBButton.width - 25 - 12, 9, 25, 30);
    
    [WBButton addSubview:DJWBImageV];
    


    
    //遮罩视图
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgView.backgroundColor = [RGBColor colorWithHexString:@"#2d2d2d"];
    bgView.alpha = .4;
    bgView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.frame = bgView.frame;
    [bgButton addTarget:self action:@selector(bgButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:bgButton];

    
    errorView = [[UIView alloc]initWithFrame:CGRectMake(20, kScreenHeight/2 - 200 , kScreenWidth - 40, 350)];
    errorView.backgroundColor = [UIColor whiteColor];
    errorView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:errorView];

    UITableView *myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, 290) style:UITableViewStylePlain];
    
    myTableView.delegate = self;
    
    myTableView.dataSource = self;
    
    [errorView addSubview:myTableView];
    
    myTableView.tableFooterView = [[UIView alloc]init];
    
    UIButton *ZDLButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    ZDLButton.frame = CGRectMake(errorView.width/2 - 17, 300, 72, 34);
    
    [ZDLButton setTitle:@"知道了" forState:UIControlStateNormal];
    
    [ZDLButton setTitleColor:[RGBColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    
    ZDLButton.titleLabel.font = [UIFont systemFontOfSize:18];
    
    ZDLButton.layer.cornerRadius = 5;
    
    ZDLButton.layer.masksToBounds = YES;
    
    ZDLButton.layer.borderColor = [RGBColor colorWithHexString:@"#666666"].CGColor;
    
    ZDLButton.layer.borderWidth = 1;
    
    [ZDLButton addTarget:self action:@selector(ZDLButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [errorView addSubview:ZDLButton];
    
}

- (void)bgButtonAction{

    bgView.hidden = YES;
    errorView.hidden = YES;

}

- (void)ZDLButtonAction{

    bgView.hidden = YES;
    errorView.hidden = YES;

}

- (void)errorButtonAction{
    
    
    if (_errorArr.count != 0) {
        
        bgView.hidden = NO;
        errorView.hidden = NO;

    }
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _errorArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ErrorCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ErrorCell"];
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 34, 34)];
        
        imageV.tag = 100;
        
        [cell.contentView addSubview:imageV];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, 14, kScreenWidth - 80, 20)];
        
        label.textColor = [RGBColor colorWithHexString:@"#666666"];
        
        label.font = [UIFont systemFontOfSize:14];
        
        label.tag = 101;
        
        [cell.contentView addSubview:label];

    }
    
    UIImageView *imageV = [cell.contentView viewWithTag:100];
    
    UILabel *label = [cell.contentView viewWithTag:101];
    
    imageV.image = [UIImage imageNamed:_errorArr[indexPath.row][@"img"]];

    label.text = _errorArr[indexPath.row][@"msg"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 48;
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

//微博发送
- (void)WBButtonAction{

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    [params setObject:_goods_id forKey:@"goods_id"];
    
    [params setObject:@"weibo" forKey:@"type"];
    
    [DataSeviece requestUrl:add_share_loghtml params:params success:^(id result) {
        NSLog(@"%@ %@",result,result[@"rsult"][@"msg"]);
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBMessageObject *message = [WBMessageObject message];
    WBImageObject *image = [WBImageObject object];
    
    //    image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_dic[@"img"][0][@"href"]]];
    NSData *data = UIImageJPEGRepresentation([self addImage], .5);

    
    image.imageData = data;
    
    message.imageObject = image;
    
    message.text = NSLocalizedString(_dataDic[@"goods_description"], nil);
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:myDelegate.wbtoken];
    
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    [WeiboSDK sendRequest:request];
    
    
    
}

- (UIImage *)addImage{
    
    NSInteger height = 0;
    
    NSArray *imageArr = _dataDic[@"imageArr"];
    
    for (int i = 0; i < imageArr.count; i++) {
        
        UIImage *image = _dataDic[@"imageArr"][i];


        height = height +image.size.height;
    }
    UIImage *image = _dataDic[@"imageArr"][0];
    
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width, height));
    
    
    NSInteger height1 = 0;
    
    for (int i = 0; i < imageArr.count; i++) {
        
        UIImage *image = _dataDic[@"imageArr"][i];
        
        image = [self scaleFromImage:image scaledToSize:CGSizeMake(image.size.width, image.size.height)];
        
        [image drawInRect:CGRectMake(0, height1, image.size.width,image.size.height)];
        
        height1 = height1 +image.size.height;
        
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
    
}

//微信发送
- (void)WXButtonAction{
    
    
    NSMutableArray *urlArr = [NSMutableArray array];
    
    NSMutableArray *imageArr = [NSMutableArray array];
    
//    for (NSString *str in _dataDic[@"img"]) {
//        
//        if (![str isEqualToString:@""]) {
//            
//            [urlArr addObject:str];
//            
//        }
//        
//    }
//
    
    NSDictionary *imageDic = _dataDic[@"img"];
    
    for (int i = 0; i < imageDic.count; i++) {
        
        [urlArr addObject:imageDic[[NSString stringWithFormat:@"%d",i]]];
    }
    
    __block NSInteger item = 0;
    __block NSInteger item1 = 0;

    
    for (int i = 0 ; i < urlArr.count; i++) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];

        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgUrl,urlArr[i]]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSLog(@"");
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            item++;
            [hud hide:YES];
            
            if (item == urlArr.count) {
                
                for (int i = 0 ; i < urlArr.count; i++) {
                    
                    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgUrl,urlArr[i]]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        NSLog(@"");
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        item1++;
                        if (error) {
                            
                        }
                        if (image) {
                         
                            [imageArr addObject:image];
                            
                        }
                        
                        if (item1 == urlArr.count) {
                            
                            [self WXpush:imageArr];
                        }
                    }];
                }
            }
        }];
    }
}


- (void)WXpush:(NSArray*)imageArr{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    [params setObject:_goods_id forKey:@"goods_id"];
    
    [params setObject:@"wechat" forKey:@"type"];
    
    [DataSeviece requestUrl:add_share_loghtml params:params success:^(id result) {
        NSLog(@"%@ %@",result,result[@"rsult"][@"msg"]);
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _dataDic[@"goods_description"];
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    NSLog(@"%@",imageArr);
    
    for (int i = 0; i < imageArr.count; i++) {
        
        UIImage *imagerang = imageArr[i];
        
        //        imagerang = [self scaleFromImage:imagerang scaledToSize:CGSizeMake(500, 500)];
        
        NSLog(@"%lf %lf",imagerang.size.width,imagerang.size.height);
        
        NSString *path_sandox = NSHomeDirectory();
        
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/ShareWX%d.jpg",i]];
        [UIImagePNGRepresentation(imagerang) writeToFile:imagePath atomically:YES];
        
        NSURL *shareobj = [NSURL fileURLWithPath:imagePath];
        
        /** 这里做个解释 imagerang : UIimage 对象  shareobj:NSURL 对象 这个方法的实际作用就是 在吊起微信的分享的时候 传递给他 UIimage对象,在分享的时候 实际传递的是 NSURL对象 达到我们分享九宫格的目的 */
        
        SharedItem *item = [[SharedItem alloc] initWithData:imagerang andFile:shareobj];
        
        [array addObject:item];
        
    }
    
    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:array
                                                                                        applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypeAirDrop];
    
    [self presentViewController:activityViewController animated:TRUE completion:nil];
    
    
}


- (UIImage*)scaleFromImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if (width <= newSize.width && height <= newSize.height){
        return image;
    }
    
    if (width == 0 || height == 0){
        return image;
    }
    
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor<heightFactor?widthFactor:heightFactor);
    
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//重新发布
//- (void)againPush{
//    
//    OneButtonPublishingViewController *OneButtonPublishingVC = [[UIStoryboard storyboardWithName:@"AddNew" bundle:nil] instantiateViewControllerWithIdentifier:@"OneButtonPublishingViewController"];
//    
//    OneButtonPublishingVC.isAgain = YES;
//    OneButtonPublishingVC.againDic = _errorDic;
//    OneButtonPublishingVC.recordDic = _dataDic;
//    
//    [self.navigationController pushViewController:OneButtonPublishingVC animated:YES];
//    
//}

- (void)leftBtnAction{
    
    if (_isCopy||_isUpData) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpDataNotification" object:nil];

        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];

    }else{
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    if (_isUpData) {
        self.navigationItem.title = @"更新完成";
    }else{
        self.navigationItem.title = @"发布完成";
    }
    //改变导航栏标题的字体颜色和大小
    UIImage *image = [UIImage imageNamed:@"navbar@2x"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[RGBColor colorWithHexString:@"#787fc6"]}];
    
    
}



@end
