//
//  OneButtonPublishingViewController.h
//  奢易购3.0
//
//  Created by Andy on 2016/10/25.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneButtonPublishingViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIButton *PHButton;
@property (weak, nonatomic) IBOutlet UIImageView *PHImageV;
@property (weak, nonatomic) IBOutlet UILabel *PHLabel;
@property (weak, nonatomic) IBOutlet UIButton *ADMButton;
@property (weak, nonatomic) IBOutlet UIImageView *ADMImageV;
@property (weak, nonatomic) IBOutlet UILabel *ADMLabel;
@property (weak, nonatomic) IBOutlet UIButton *WBButton;
@property (weak, nonatomic) IBOutlet UIImageView *WBImageV;
@property (weak, nonatomic) IBOutlet UILabel *WBLabel;

@property (weak, nonatomic) IBOutlet UITextField *brandTextField;
@property (weak, nonatomic) IBOutlet UITextField *sortTextField;
@property (weak, nonatomic) IBOutlet UITextField *gradeTextField;
@property (weak, nonatomic) IBOutlet UITextField *expectedTextField;

@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *publicPriceTextField;
@property (weak, nonatomic) IBOutlet UITextView *describeTextView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *tureButton;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (nonatomic,assign) BOOL isAgain;

@property (nonatomic,strong) NSDictionary *againDic;

@property (nonatomic,strong) NSDictionary *oldDic;


@end
