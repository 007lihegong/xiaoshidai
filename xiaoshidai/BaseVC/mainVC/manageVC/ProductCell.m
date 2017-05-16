//
//  ProductCell.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/2.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "ProductCell.h"
@interface ProductCell() {
    NSMutableDictionary * carDict;
    NSMutableDictionary * agencyDict;
}
@end
@implementation ProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    carDict = [NSMutableDictionary dictionary];
    agencyDict = [NSMutableDictionary dictionary];
    
    [carDict setObject:@"未知" forKey:@"0"];
    [carDict setObject:@"无要求" forKey:@"1"];
    [carDict setObject:@"要求有" forKey:@"2"];
    [carDict setObject:@"要求无" forKey:@"3"];
    
    [agencyDict setObject:@"未知" forKey:@"0"];
    [agencyDict setObject:@"无要求" forKey:@"1"];
    [agencyDict setObject:@"无信用卡或贷款" forKey:@"2"];
    [agencyDict setObject:@"信用良好，无逾期" forKey:@"3"];
    [agencyDict setObject:@"一年内逾期少于三次且少于90天" forKey:@"4"];
    [agencyDict setObject:@"一年内逾期超过3次或超过90天" forKey:@"5"];
}

-(void)setModel:(ProductInfo *)model{
    self.productNameLabel.text = model.product_name;
    [self.productNameLabel setTextColor:mainHuang];
    self.interestRateLabel.text = [NSString stringWithFormat:@"贷款利率:%@%%",[XYString IsNotNull:model.interest_rate]];
    self.moneyLabel.text = [NSString stringWithFormat:@"贷款金额:%@万~%@万",model.money_min,model.money_max];
    NSString * car_limit = [carDict objectForKey:model.car_limit];
    NSString * house_limit = [carDict objectForKey:model.house_limit];
    NSString * agency_limit = [agencyDict objectForKey:model.agency_limit];
    if([model.car_limit integerValue]==0 || [model.car_limit integerValue]==1){
        self.carLimitLabel.text = [NSString stringWithFormat:@"车辆要求:%@",car_limit];
    }else{
        self.carLimitLabel.text = [NSString stringWithFormat:@"车辆要求:%@车",car_limit];
    }
    if([model.house_limit integerValue]==0 || [model.house_limit integerValue]==1){
        self.houseLimitLabel.text = [NSString stringWithFormat:@"房屋要求:%@",house_limit];
    }else{
        self.houseLimitLabel.text = [NSString stringWithFormat:@"房屋要求:%@房",house_limit];
    }
    self.agencyLimitLabel.text = [NSString stringWithFormat:@"征信要求:%@",agency_limit];
}
+ (CGFloat)cellHeight:(ProductInfo *)model{
    ProductCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ProductCell" owner:nil options:nil] lastObject];
    //[cell setModel:model];
    [cell layoutIfNeeded];
    CGRect frame = cell.contentView.frame;
    return frame.size.height;
}

-(CGFloat)cellHeight{
    return self.height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
