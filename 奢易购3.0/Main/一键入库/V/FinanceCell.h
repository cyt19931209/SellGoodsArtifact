//
//  FinanceCell.h
//  奢易购3.0
//
//  Created by guest on 16/7/20.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinancialModel.h"
#import "PersonelModel.h"

@interface FinanceCell : UITableViewCell


@property (nonatomic,strong)FinancialModel *model;
@property (nonatomic,strong)PersonelModel *model1;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *personTypeImage;
@end
