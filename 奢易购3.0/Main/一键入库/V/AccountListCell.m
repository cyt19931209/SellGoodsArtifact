//
//  AccountListCell.m
//  奢易购3.0
//
//  Created by Andy on 2016/11/4.
//  Copyright © 2016年 cyt. All rights reserved.
//

#import "AccountListCell.h"

@implementation AccountListCell


- (void)setDic:(NSDictionary *)dic{

    _dic = dic;

    _titleLabel.text = _dic[@"phone"];
    
    if ([_dic[@"select"] isEqualToString:@"1"]) {
        
        [_selectButton setImage:[UIImage imageNamed:@"ch"] forState:UIControlStateNormal];

    }else{
        
        [_selectButton setImage:[UIImage imageNamed:@"noch"] forState:UIControlStateNormal];

    }
    
    if (![_dic[@"type"] isEqualToString:@"sae"]) {
        
        _delectButton.hidden = YES;
        
    }else{
        
        _delectButton.hidden = NO;

    }
    
}

- (IBAction)delectAction:(id)sender {
    
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:SYGData[@"id"] forKey:@"uid"];
    [params setObject:_dic[@"id"] forKey:@"id"];
    [DataSeviece requestUrl:delete_share_accounthtml params:params success:^(id result) {
        
        NSLog(@"%@",result);
        
        if ([result[@"result"][@"code"] isEqualToString:@"1"]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountNotification" object:nil];

        }else{
            alertV.message = result[@"result"][@"msg"];
            [alertV show];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];

    
    
}

- (IBAction)selectButtonAction:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSDictionary *SYGData = [defaults objectForKey:@"SYGData"];

    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:[NSString stringWithFormat:@"%@share",SYGData[@"id"]]]];
    
    [dic setObject:_dic forKey:_dic[@"type" ]];
    
    [defaults setObject:dic forKey:[NSString stringWithFormat:@"%@share",SYGData[@"id"]]];
    
    [defaults synchronize];
                                
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AccountNotification" object:nil];
    
}


@end
