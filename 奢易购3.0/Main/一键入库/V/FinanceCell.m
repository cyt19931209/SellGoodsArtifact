//
//  FinanceCell.m
//  奢易购3.0
//
//  Created by guest on 16/7/20.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import "FinanceCell.h"

@implementation FinanceCell



- (void)setModel:(FinancialModel *)model{
    _model = model;

    _nameLabel.text = _model.use_name;

    _accountLabel.text = _model.account;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    
    [DataSeviece requestUrl:get_account_typehtml params:params success:^(id result) {
        NSLog(@"%@",result[@"result"][@"msg"]);
        
        for (NSDictionary *dic in result[@"result"][@"data"][@"item"]) {
            
            if ([_model.type isEqualToString:dic[@"id"]]) {
                _typeImage.image = [UIImage imageNamed:dic[@"name"]];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)setModel1:(PersonelModel *)model1{
    _model1 = model1;

    _nameLabel.text = _model1.user_name;
    _accountLabel.text = _model1.mobile;
    
    if ([_model1.type isEqualToString:@"1"]) {
        _personTypeImage.image = [UIImage imageNamed:@"老板（64x64）"];
        _typeLabel.text = @"老板";
    }else if ([_model1.type isEqualToString:@"2"]){
        _personTypeImage.image = [UIImage imageNamed:@"主帐号（64x64）"];
        _typeLabel.text = @"主帐号";
    }else if ([_model1.type isEqualToString:@"3"]){
        _personTypeImage.image = [UIImage imageNamed:@"店员（64x64）"];
        _typeLabel.text = @"店员";
    }

    
    
}


@end
