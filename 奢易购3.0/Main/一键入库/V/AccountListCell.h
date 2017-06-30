//
//  AccountListCell.h
//  奢易购3.0
//
//  Created by Andy on 2016/11/4.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIButton *delectButton;

@property (nonatomic,strong) NSDictionary *dic;
@end

