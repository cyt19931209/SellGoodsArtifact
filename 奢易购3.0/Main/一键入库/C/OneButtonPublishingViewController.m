//
//  OneButtonPublishingViewController.m
//  奢易购3.0
//
//  Created by Andy on 2016/10/25.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import "OneButtonPublishingViewController.h"
#import "OneButtonPublishingCell.h"
#import "ZLPhoto.h"
#import "AFNetworking.h"
#import "BrandChoiceViewController.h"
#import "SortConditionViewController.h"
#import "GradeConditionViewController.h"
#import "ReleaseCompleteViewController.h"
#import "AccountBindingViewController.h"
#import "ScanViewController.h"
#import "ExpectedDeliveryType ViewController.h"

@interface OneButtonPublishingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLPhotoPickerViewControllerDelegate,UITextViewDelegate>{

    UIView *bgView;
    
    UIView *feedBackV;
    
    CGFloat angle1;
    CGFloat angle2;
    CGFloat angle3;
    
    BOOL isPHRotate;
    BOOL isADMRotate;
    BOOL isWBRotate;
    
    NSString *PHmsg;
    NSString *ADMmsg;
    NSString *WBmsg;


}

@property (weak, nonatomic) IBOutlet UICollectionView *OnePublishCollectionV;
@property (nonatomic,strong) NSMutableArray *imageArr;
@property (nonatomic,strong) NSMutableArray *imageStrArr;

@property (nonatomic,strong) NSDictionary *brandDic;
@property (nonatomic,strong) NSDictionary *sortDic;
@property (nonatomic,strong) NSDictionary *gradeDic;
@property (nonatomic,strong) NSDictionary *expectedDic;

@property (nonatomic,strong) NSDictionary *dataDic;

@end

@implementation OneButtonPublishingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _imageArr = [NSMutableArray array];
    
    _imageStrArr = [NSMutableArray array];
    
    _describeTextView.delegate = self;
    
    _WBImageV.hidden = YES;
    
    _PHImageV.hidden = YES;
    
    _ADMImageV.hidden = YES;
    
    ADMmsg = @"";
    
    PHmsg = @"";
    
    WBmsg = @"";

    for (int i = 0; i < 9; i++) {
        
        [_imageStrArr addObject:@""];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GradeConditionNotification:) name:@"GradeConditionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BrandChoiceNotification:) name:@"BrandChoiceNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SortConditionNotification:) name:@"SortConditionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AccountNotification) name:@"AccountNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RemoveImageNotification:) name:@"RemoveImageNotification" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ExpectedDeliveryTypeNotification:) name:@"ExpectedDeliveryTypeNotification" object:nil];
    
    //左边Item
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 10, 19);
    [leftBtn setImage:[UIImage imageNamed:@"Back Chevron@2x"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    [_OnePublishCollectionV registerNib:[UINib nibWithNibName:@"OneButtonPublishingCell" bundle:nil] forCellWithReuseIdentifier:@"OneButtonPublishingCell"];
    
    if (_isAgain) {
        [_tureButton setTitle:@"重新发布" forState:UIControlStateNormal];

        _errorLabel.text = _againDic[@"error"];
        
        NSArray *arr = _againDic[@"item"];

        for (NSString *str in arr) {
            
            if ([str isEqualToString:@"1"]) {
                _PHImageV.hidden = NO;
            }else if ([str isEqualToString:@"2"]){
                _ADMImageV.hidden = NO;
            }else if ([str isEqualToString:@"3"]){
                _WBImageV.hidden = NO;
            }
            
        }
        _titleTextField.text = _oldDic[@"goods_name"];
        _brandDic = _oldDic[@"brand"];
        _brandTextField.text = _oldDic[@"brand"][@"brands_name"];
        _sortDic = _oldDic[@"category"];
        _sortTextField.text = _oldDic[@"category"][@"category_name"];
        
        _describeTextView.text = _oldDic[@"goods_description"];
        
        _gradeDic = _oldDic[@"grade"];
        _gradeTextField.text = _oldDic[@"grade"][@"title"];
        _priceTextField.text = _oldDic[@"price"];
        _publicPriceTextField.text = _oldDic[@"market_price"];
        
        NSArray *imageArr = _oldDic[@"img"];
        
        NSLog(@"%@",imageArr);

        for (int i = 0 ; i < imageArr.count; i++) {
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imgUrl,imageArr[i]]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                NSLog(@"");
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (error) {
                    
                    
                }
                if (image) {
                    
                    [_imageArr addObject:image];
                    
                    [_imageStrArr replaceObjectAtIndex:i withObject:imageArr[i]];
                }
                [_OnePublishCollectionV reloadData];
            }];
        }

        
    }else{
        //平台检测
        [self loadData];
        
        _priceTextField.text = _oldDic[@"price"];
        
        _titleTextField.text = _oldDic[@"title"];
        
        NSArray *imageArr = _oldDic[@"img"];
        
        for (int i = 0 ; i < imageArr.count; i++) {
            NSLog(@"%@",imageArr[i]);
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageArr[i]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                NSLog(@"");
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (error) {
                    
                }
                if (image) {
                    [_imageArr addObject:image];
                    if ([BaseUrl isEqualToString:@"http://syg.hpdengshi.com/index.php?s=/Api/"]) {
                        
                        [_imageStrArr replaceObjectAtIndex:i withObject:[imageArr[i] substringFromIndex:23]];
                    }else{
                        
                        [_imageStrArr replaceObjectAtIndex:i withObject:[imageArr[i] substringFromIndex:24]];
                    }

                    
                }
                [_OnePublishCollectionV reloadData];
            }];
        }
        
    }
    
    //隐藏键盘
    UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleAction)];;
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    singleRecognizer.cancelsTouchesInView = NO;
    //给self.view添加一个手势监测；
    [self.tableView addGestureRecognizer:singleRecognizer];
    
    //遮罩视图
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgView.backgroundColor = [RGBColor colorWithHexString:@"#2d2d2d"];
    bgView.alpha = .4;
    bgView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.frame = bgView.frame;
//    [bgButton addTarget:self action:@selector(bgButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:bgButton];
    

}

//隐藏键盘
- (void)singleAction{
    
    [_brandTextField resignFirstResponder];
    [_gradeTextField resignFirstResponder];
    [_sortTextField resignFirstResponder];
    [_titleTextField resignFirstResponder];
    [_publicPriceTextField resignFirstResponder];
    [_priceTextField resignFirstResponder];
    [_describeTextView resignFirstResponder];

}

//平台检测
- (void)loadData{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    
    
    [DataSeviece requestUrl:Shareget_share_accounthtml params:params success:^(id result) {
        
        NSLog(@"%@",result);
        
        _dataDic = result[@"result"][@"data"];
        
        for (NSDictionary *dic in result[@"result"][@"data"][@"item"]) {
            
            if ([dic[@"type"] isEqualToString:@"ponhu"]) {
                
                _PHImageV.hidden = NO;
                
                _PHButton.selected = YES;
            }
            
            if ([dic[@"type"] isEqualToString:@"aidingmao"]) {
                
                _ADMImageV.hidden = NO;
                
                _ADMButton.selected = YES;
                
            }
            
            if ([dic[@"type"] isEqualToString:@"sae"]) {
                
                _WBImageV.hidden = NO;
                
                _WBButton.selected = YES;
                
            }

        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

    

}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    OneButtonPublishingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OneButtonPublishingCell" forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.JBImageV.hidden = YES;
        cell.FMLabel.hidden = YES;
        cell.JBLabel.hidden = YES;
    }else {
        
        cell.JBImageV.hidden = NO;
        cell.JBLabel.hidden = NO;
        cell.JBLabel.text = [NSString stringWithFormat:@"%ld",indexPath.item];
    }
    
    if (indexPath.item == 1) {
        
        cell.FMLabel.hidden = NO;
    }else{
        cell.FMLabel.hidden = YES;

    }
    
    if (indexPath.item == 0) {
        
        cell.imageV.image = [UIImage imageNamed:@"addphoto@2x.png"];
   
        cell.imageV.backgroundColor = [UIColor whiteColor];

    }else{
        
        if (_imageArr.count >=  indexPath.item) {
            
            NSLog(@"%@",_imageArr[indexPath.item-1]);
            
            cell.imageV.backgroundColor = [UIColor whiteColor];

            cell.imageV.image = _imageArr[indexPath.item -1];
            
        }else{
            
            cell.imageV.backgroundColor = [RGBColor colorWithHexString:@"#d8d8d8"];
            
            cell.imageV.image = nil;
            
        }
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.item == 0) {
        
        // 创建控制器
        ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
        // 默认显示相册里面的内容SavePhotos
        // 最多能选9张图片
        pickerVc.topShowPhotoPicker = YES;
        pickerVc.status = PickerViewShowStatusCameraRoll;
        pickerVc.delegate = self;
        [pickerVc showPickerVc:self];
        /**
         *
         传值可以用代理，或者用block来接收，以下是block的传值
         __weak typeof(self) weakSelf = self;
         pickerVc.callBack = ^(NSArray *assets){
         weakSelf.assets = assets;
         [weakSelf.tableView reloadData];
         };
         */
    
    }else{
        
        NSMutableArray *urlArr = [NSMutableArray array];
        
        for (NSString *str in _imageStrArr) {
            if (![str isEqualToString:@""]) {
                [urlArr addObject:[NSString stringWithFormat:@"%@%@",imgUrl,str]];
            }
        }
        
        if (![_imageStrArr[indexPath.item - 1] isEqualToString:@""]) {
            
            NSIndexPath *path = [NSIndexPath indexPathForItem:indexPath.item - 1 inSection:indexPath.section];
            ScanViewController *scanVC = [[ScanViewController alloc]init];
            scanVC.imageURLArr = urlArr;
            scanVC.currentIndexPath = path;
            scanVC.isDelegate = YES;
            [self.navigationController pushViewController:scanVC animated:YES];
            
        }
        
    
    }
    
 
}



#pragma mark - 相册回调
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    
    if (_imageArr.count + assets.count > 9) {
        
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertV.message = @"图片不能超过九张";
        [alertV show];
        return;
    }
    NSMutableArray *imageArr1 = [NSMutableArray array];
    
    NSInteger item = _imageArr.count;
    for (NSInteger i = 0; i <assets.count ; i++) {
        ZLPhotoAssets *asset = assets[i];
        ZLCamera *asset1  = assets[i];
        
        if ([assets[i] isKindOfClass:[ZLCamera class]]) {
            [_imageArr addObject:asset1.photoImage];
            [imageArr1 addObject:asset1.photoImage];
        }else{
            [_imageArr addObject:asset.originImage];
            [imageArr1 addObject:asset.originImage];
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:@{@"uid":SYGData[@"id"]} forKey:@"data"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@",BaseUrl,uploadimghtml] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSData *imgData = UIImageJPEGRepresentation(imageArr1[i], .5);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            [formData appendPartWithFileData:imgData name:@"upfile" fileName:fileName mimeType:@"image/png"];
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            
            [_imageStrArr replaceObjectAtIndex:i +item withObject:responseObject[@"result"][@"data"][@"url"]];
            
            NSLog(@"%@",_imageStrArr);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
    
    [_OnePublishCollectionV reloadData];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if (indexPath.row == 11) {
        
        BrandChoiceViewController *BrandChoiceVC = [[BrandChoiceViewController alloc]init];
        
        [self.navigationController pushViewController:BrandChoiceVC animated:YES];
        
    }else if (indexPath.row == 12){
    
        SortConditionViewController *SortConditionVC = [[SortConditionViewController alloc]init];
    
        [self.navigationController pushViewController:SortConditionVC animated:YES];

    }else if (indexPath.row == 13){
    
        GradeConditionViewController *GradeConditionVC = [[GradeConditionViewController alloc]init];
        [self.navigationController pushViewController:GradeConditionVC animated:YES];

    }else if (indexPath.row == 14){
        
        ExpectedDeliveryType_ViewController *GradeConditionVC = [[ExpectedDeliveryType_ViewController alloc]init];
        [self.navigationController pushViewController:GradeConditionVC animated:YES];
        
    }

}

//成色通知
- (void)GradeConditionNotification:(NSNotification*)noti{

    _gradeDic = [noti object];
    
    _gradeTextField.text = _gradeDic[@"title"];
    
    
}
//发货时间选择通知
- (void)ExpectedDeliveryTypeNotification:(NSNotification*)noti{

    _expectedDic = [noti object];
    
    _expectedTextField.text = _expectedDic[@"title"];
    
}

//类别通知
- (void)SortConditionNotification:(NSNotification*)noti{
    
    _sortDic = [noti object];


    _sortTextField.text = _sortDic[@"category_name"];

}
//品牌通知
- (void)BrandChoiceNotification:(NSNotification*)noti{
    
    _brandDic = [noti object];

    
    _brandTextField.text = _brandDic[@"brands_name"];

}
//绑定返回通知
- (void)AccountNotification{

    [self loadData];
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

//确定按钮

- (IBAction)tureAction:(id)sender {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < 9; i++) {
        
        if (![_imageStrArr[i] isEqualToString:@""]) {
            
            [dic setObject:_imageStrArr[i] forKey:[NSString stringWithFormat:@"%d",i]];
            
        }
    }
    
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    if ([_titleTextField.text isEqualToString:@""]) {
        alertV.message = @"商品标题不能为空";
        [alertV show];
        return;
    }
    
    if (_describeTextView.text.length < 30||_describeTextView.text.length > 144) {
        alertV.message = @"商品描述字数不能小于30或者不能大于144";
        [alertV show];
        return;
    }
    
    if (!_brandDic[@"id"]) {
        alertV.message = @"品牌不能为空";
        [alertV show];
        return;
    }
    
    if (!_sortDic[@"id"]) {
        alertV.message = @"类别不能为空";
        [alertV show];
        return;
    }
    
    if (!_expectedDic[@"id"]) {
        alertV.message = @"发货时间不能为空";
        [alertV show];
        return;
    }


    if ([_priceTextField.text isEqualToString:@""]) {
        alertV.message = @"售价不能为空";
        [alertV show];
        return;
    }
    
    
    
    if ([_publicPriceTextField.text isEqualToString:@""]) {
        alertV.message = @"公价不能为空";
        [alertV show];
        return;
    }

    if ([_priceTextField.text integerValue] > [_publicPriceTextField.text integerValue]) {
       
        alertV.message = @"售价不能大于公价";
        [alertV show];
        return;

    }
    
    if (dic.count < 5) {
        
        alertV.message = @"图片不能小于5张";
        [alertV show];
        return;

    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *SYGData  = [defaults objectForKey:@"SYGData"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    
    [params setObject:_titleTextField.text forKey:@"goods_name"];
    
    [params setObject:_brandDic[@"id"] forKey:@"brand_id"];
    
    [params setObject:_sortDic[@"id"] forKey:@"category_id"];

    [params setObject:_expectedDic[@"id"] forKey:@"expected_delivery_type"];
    
    [params setObject:@"1" forKey:@"fit_people"];
    
    [params setObject:_describeTextView.text forKey:@"goods_description"];
    
    [params setObject:_gradeDic[@"id"] forKey:@"grade"];
    
    [params setObject:_priceTextField.text forKey:@"price"];
    
    [params setObject:_publicPriceTextField.text forKey:@"market_price"];
    
    [params setObject:dic forKey:@"img"];
    
    [DataSeviece requestUrl:goods_sharehtml params:params success:^(id result) {
        
        NSLog(@"%@ %@",result,result[@"result"][@"msg"]);
        
        if ([result[@"result"][@"code"] isEqualToString:@"1"]) {
            
            if (!_PHImageV.hidden) {
                
                NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
                
                [params1 setObject:SYGData[@"id"] forKey:@"uid"];
                
                [params1 setObject:result[@"result"][@"data"][@"id"] forKey:@"id"];
                
                [params1 setObject:@"ponhu" forKey:@"share_platform"];
                
                [DataSeviece requestUrl:share_outhtml params:params1 success:^(id result) {
                    
                    NSLog(@"%@ %@",result,result[@"result"][@"msg"]);
                    
                    isPHRotate = YES;
                    
                    UIImageView *imageV = [feedBackV viewWithTag:101];

                    if ([result[@"result"][@"code"] isEqualToString:@"1"]) {
                        imageV.image = [UIImage imageNamed:@"rt@2x"];
                    }else{
                        imageV.image = [UIImage imageNamed:@"wr@2x"];
                        PHmsg = result[@"result"][@"msg"];
                    }
                    
                    [self pushAction];
                    
                } failure:^(NSError *error) {
                    
                    NSLog(@"%@",error);
                    
                }];
            }
            
            if (!_ADMImageV.hidden) {
                
                NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
                
                [params1 setObject:SYGData[@"id"] forKey:@"uid"];
                
                [params1 setObject:result[@"result"][@"data"][@"id"] forKey:@"id"];
                
                [params1 setObject:@"aidingmao" forKey:@"share_platform"];
                
                [DataSeviece requestUrl:share_outhtml params:params1 success:^(id result) {
                    
                    NSLog(@"%@ %@",result,result[@"result"][@"msg"]);
                    
                    isADMRotate = YES;

                    UIImageView *imageV = [feedBackV viewWithTag:102];
                    
                    
                    if ([result[@"result"][@"code"] isEqualToString:@"1"]) {
                        imageV.image = [UIImage imageNamed:@"rt@2x"];
                    }else{
                        imageV.image = [UIImage imageNamed:@"wr@2x"];
                        ADMmsg = result[@"result"][@"msg"];

                    }
                    
                    [self pushAction];

                } failure:^(NSError *error) {
                    
                    NSLog(@"%@",error);
                    
                }];
                
            }
            
            if (!_WBImageV.hidden) {
                
                NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
                
                [params1 setObject:SYGData[@"id"] forKey:@"uid"];
                
                [params1 setObject:result[@"result"][@"data"][@"id"] forKey:@"id"];
                
                [params1 setObject:@"sae" forKey:@"share_platform"];
                
                [DataSeviece requestUrl:share_outhtml params:params1 success:^(id result) {
                    
                    NSLog(@"%@ %@",result,result[@"result"][@"msg"]);
                    
                    isWBRotate = YES;
                    
                    UIImageView *imageV = [feedBackV viewWithTag:103];
                    
                    
                    if ([result[@"result"][@"code"] isEqualToString:@"1"]) {
                        imageV.image = [UIImage imageNamed:@"rt@2x"];
                    }else{
                        imageV.image = [UIImage imageNamed:@"wr@2x"];
                        WBmsg = result[@"result"][@"msg"];

                    }
                    
                    [self pushAction];
                    
                } failure:^(NSError *error) {
                    
                    NSLog(@"%@",error);
                    
                }];
            }

            bgView.hidden = NO;
            
            feedBackV = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 145, kScreenHeight/2 - 70, 290, 140)];
            feedBackV.backgroundColor = [RGBColor colorWithHexString:@"#ffffff"];
            feedBackV.layer.cornerRadius = 3;
            feedBackV.layer.masksToBounds = YES;
            [[UIApplication sharedApplication].keyWindow addSubview:feedBackV];
            
            UILabel *PHLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            
            [feedBackV addSubview:PHLabel];
            if (!_PHImageV.hidden) {
                
                PHLabel.top = 17;
                PHLabel.left = 20;
                PHLabel.width = 60;
                PHLabel.height = 20;
                PHLabel.textColor = [RGBColor colorWithHexString:@"#666666"];
                PHLabel.font = [UIFont systemFontOfSize:18];
                PHLabel.text = @"胖虎";
                
                UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(feedBackV.width - 20 - 20, PHLabel.top, 20, 20)];
                
                imageV.image = [UIImage imageNamed:@"loading@2x.png"];
                imageV.tag = 101;

                [feedBackV addSubview:imageV];

                [self startAnimation:imageV];
            }
            
            UILabel *ADMLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, PHLabel.bottom, 0, 0)];
            
            [feedBackV addSubview:ADMLabel];
            
            if (!_ADMImageV.hidden) {
                
                ADMLabel.top = PHLabel.bottom+30;
                ADMLabel.left = 20;
                ADMLabel.width = 60;
                ADMLabel.height = 20;
                ADMLabel.textColor = [RGBColor colorWithHexString:@"#666666"];
                ADMLabel.font = [UIFont systemFontOfSize:18];
                ADMLabel.text = @"爱丁猫";
                
                UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(feedBackV.width - 20 - 20, ADMLabel.top, 20, 20)];
                imageV.tag = 102;
                imageV.image = [UIImage imageNamed:@"loading@2x.png"];
                
                [feedBackV addSubview:imageV];
                
                [self startAnimation:imageV];
            }

            UILabel *WBLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ADMLabel.bottom, 0, 0)];
            
            [feedBackV addSubview:WBLabel];

            
            if (!_WBImageV.hidden) {
                
                WBLabel.top = ADMLabel.bottom+30;
                WBLabel.left = 20;
                WBLabel.width = 60;
                WBLabel.height = 20;
                WBLabel.textColor = [RGBColor colorWithHexString:@"#666666"];
                WBLabel.font = [UIFont systemFontOfSize:18];
                WBLabel.text = @"微博";
                
                UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(feedBackV.width - 20 - 20, WBLabel.top, 20, 20)];
                imageV.tag = 103;
                imageV.image = [UIImage imageNamed:@"loading@2x.png"];
                
                [feedBackV addSubview:imageV];
                
                [self startAnimation:imageV];
            }

            feedBackV.height = WBLabel.bottom +20;
        }
        
        if (_WBImageV.hidden&&_ADMImageV.hidden&&_WBImageV.hidden) {
            
            [self pushAction];
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

    
}

- (void)startAnimation:(UIImageView*)imageV
 {
     
     if (imageV.tag == 101) {
        
         CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle1 * (M_PI / 180.0f));
         
         [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
             imageV.transform = endAngle;
         } completion:^(BOOL finished) {
             if (!isPHRotate) {
                 angle1 += 10; [self startAnimation:imageV];
             }else{
                 
                 imageV.transform = CGAffineTransformMakeRotation(0);
             }
         }];
     }
     
     if (imageV.tag == 102) {
         
         CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle2 * (M_PI / 180.0f));
         
         [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
             imageV.transform = endAngle;
         } completion:^(BOOL finished) {
             
             if (!isADMRotate) {
                 angle2 += 10; [self startAnimation:imageV];
             }else{
             
                 imageV.transform = CGAffineTransformMakeRotation(0);
             }
         }];

     }
     
     if (imageV.tag == 103) {
         
         CGAffineTransform endAngle = CGAffineTransformMakeRotation(angle3 * (M_PI / 180.0f));
         
         [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
             imageV.transform = endAngle;
         } completion:^(BOOL finished) {
             
             if (!isWBRotate) {
                 angle3 += 10; [self startAnimation:imageV];
             }else{
                 imageV.transform = CGAffineTransformMakeRotation(0);
             }
         }];
     }
}

- (void)pushAction{

    BOOL isph;
    BOOL isadm;
    BOOL iswb;

    NSMutableArray *arr = [NSMutableArray array];
    
    UIImageView *imageV1 = [feedBackV viewWithTag:101];
    UIImageView *imageV2 = [feedBackV viewWithTag:102];
    UIImageView *imageV3 = [feedBackV viewWithTag:103];

    
    if (!_PHImageV.hidden) {
        isph = isPHRotate;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"panghu@2x" forKey:@"img"];
    
        if ([imageV1.image isEqual:[UIImage imageNamed:@"rt@2x"]]) {
            [dic setObject:@"1" forKey:@"isSuccess"];
        }else{
            [dic setObject:@"0" forKey:@"isSuccess"];
            [dic setObject:PHmsg forKey:@"msg"];
        }
        [arr addObject:dic];
    }else{
        isph = YES;
    }
    
    if (!_ADMImageV.hidden) {
        isadm = isADMRotate;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"aiding@2x" forKey:@"img"];
        
        if ([imageV2.image isEqual:[UIImage imageNamed:@"rt@2x"]]) {
            
            [dic setObject:@"1" forKey:@"isSuccess"];
            
        }else{
            [dic setObject:@"0" forKey:@"isSuccess"];
            [dic setObject:ADMmsg forKey:@"msg"];

        }
        [arr addObject:dic];

    }else{
        isadm = YES;
    }
    
    if (!_WBImageV.hidden) {
        iswb = isWBRotate;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"sina@2x" forKey:@"img"];
        if ([imageV3.image isEqual:[UIImage imageNamed:@"rt@2x"]]) {
            [dic setObject:@"1" forKey:@"isSuccess"];
        }else{
            [dic setObject:@"0" forKey:@"isSuccess"];
            [dic setObject:WBmsg forKey:@"msg"];
            
        }
        [arr addObject:dic];
        
    }else{
        iswb = YES;
    }

    if (isph&&isadm&&iswb) {
        
        bgView.hidden = YES;
        feedBackV.hidden = YES;
        
        ReleaseCompleteViewController *ReleaseCompleteVC = [[ReleaseCompleteViewController alloc]init];
        NSLog(@"%@",arr);
        ReleaseCompleteVC.arr = [arr copy];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:_titleTextField.text forKey:@"goods_name"];
        
        [params setObject:_brandDic forKey:@"brand"];
        
        [params setObject:_sortDic forKey:@"category"];
        
        
        [params setObject:_describeTextView.text forKey:@"goods_description"];
        
        [params setObject:_gradeDic forKey:@"grade"];
        
        [params setObject:_priceTextField.text forKey:@"price"];
        
        [params setObject:_publicPriceTextField.text forKey:@"market_price"];
        
        [params setObject:_imageStrArr forKey:@"img"];

        ReleaseCompleteVC.dataDic = [params copy];
        
        [self.navigationController pushViewController:ReleaseCompleteVC animated:YES];
        
    }
    
}
- (void)leftBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"一键发布";
    
    UIImage *image = [UIImage imageNamed:@"navbar@2x"];
    [self.navigationController.navigationBar setBackgroundImage:image
                                                  forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[RGBColor colorWithHexString:@"#787fc6"]}];
    
    [self.navigationController.navigationBar setShadowImage:nil];
    
}

- (IBAction)PHAction:(UIButton *)sender {
    
    if (sender.selected) {
        sender.selected = NO;
        _PHImageV.hidden = YES;
    }else{
    
        BOOL isponhu = NO;
        for (NSDictionary *dic in _dataDic[@"item"]) {
            
            if ([dic[@"type"] isEqualToString:@"ponhu"]) {

                isponhu = YES;
            }
            
        }
        
        if (isponhu) {
            
            sender.selected = YES;
            _PHImageV.hidden = NO;
            
        }else{
            
            AccountBindingViewController *AccountBindingVC = [[AccountBindingViewController alloc]init];
            AccountBindingVC.type = @"ponhu";
            
            [self.navigationController pushViewController:AccountBindingVC animated:YES];

        }
    }
    
}

- (IBAction)ADMAction:(UIButton *)sender {
    
    if (sender.selected) {
        sender.selected = NO;
        _ADMImageV.hidden = YES;
    }else{
        
        BOOL isaidingmao = NO;
        for (NSDictionary *dic in _dataDic[@"item"]) {
            
            if ([dic[@"type"] isEqualToString:@"aidingmao"]) {
                
                isaidingmao = YES;
            }
            
        }
        
        if (isaidingmao) {
            
            sender.selected = YES;
            _ADMImageV.hidden = NO;
            
        }else{
            
            AccountBindingViewController *AccountBindingVC = [[AccountBindingViewController alloc]init];
            AccountBindingVC.type = @"aidingmao";
            
            [self.navigationController pushViewController:AccountBindingVC animated:YES];
            
        }
    }


}

- (IBAction)WBAction:(UIButton *)sender {
    
    if (sender.selected) {
        sender.selected = NO;
        _WBImageV.hidden = YES;
    }else{
        
        BOOL issae = NO;
        for (NSDictionary *dic in _dataDic[@"item"]) {
            
            if ([dic[@"type"] isEqualToString:@"sae"]) {
                
                issae = YES;
            }
            
        }
        
        if (issae) {
            
            sender.selected = YES;
            _WBImageV.hidden = NO;
            
        }else{
            
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = kRedirectURI;
            request.scope = @"all";
            request.userInfo = nil;
            [WeiboSDK sendRequest:request];

        }
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        if (_isAgain) {
            return 48;
        }else{
            return 0;
        }
    }else if (indexPath.row == 1){
        if (_isAgain) {
            return 0;
        }else{
            return 48;
        }
    }else if (indexPath.row == 2){
        return 10;
    }else if (indexPath.row == 3){
        return 144;
    }else if (indexPath.row == 4){
        return 10;
    }else if (indexPath.row == 5){
        return 65;
    }else if (indexPath.row == 6){
        return 105;
    }else if (indexPath.row == 7){
        return 10;
    }else if (indexPath.row == 8){
        return 48;
    }else if (indexPath.row == 9){
        return 48;
    }else if (indexPath.row == 10){
        return 10;
    }else if (indexPath.row == 11){
        return 48;
    }else if (indexPath.row == 12){
        return 48;
    }else if (indexPath.row == 13){
        return 48;
    }else if (indexPath.row == 14){
        return 48;
    }else if (indexPath.row == 15){
        return 96;
    }

    return 48;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if (textView.text.length > 144) {
        
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"商品描述不能超过144" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
        
        textView.text = [textView.text substringToIndex:144];
        
    }
    
    return YES;
}
//删除图片
- (void)RemoveImageNotification:(NSNotification*)noti{

    NSInteger index = [[noti object] integerValue];
    
    [_imageStrArr replaceObjectAtIndex:index withObject:@""];
    
    [_imageArr removeObjectAtIndex:index];


    for (int i = 0; i < _imageArr.count+2; i++) {
        
        if (_imageArr.count != index) {
            
            if (i > index) {
                
                [_imageStrArr replaceObjectAtIndex:i - 1 withObject:_imageStrArr[i]];
            }
        }
    }
    
    [_OnePublishCollectionV reloadData];
    
    
    NSLog(@"%@ %@",_imageStrArr,_imageArr);
}


@end
