//
//  StaffEditorViewController.h
//  奢易购3.0
//
//  Created by Andy on 16/9/12.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonelModel.h"

@interface StaffEditorViewController : UITableViewController

@property (nonatomic,strong) PersonelModel *model;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *typeLabe;

@end
