//
//  PayCell.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/20.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "PayCell.h"

@implementation PayCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)fillCellWithModel:(PayData *)model{
    UILabel *payStatus      = (UILabel *)[self viewWithTag:100];
    UILabel *nameLabel      = (UILabel *)[self viewWithTag:101];
    UILabel *channelLabel   = (UILabel *)[self viewWithTag:102];
    UILabel *itemLabel      = (UILabel *)[self viewWithTag:103];
    UILabel *moneyLabel     = (UILabel *)[self viewWithTag:104];

    payStatus.text = model.pay_status_txt;
    nameLabel.text = StrFormatTW(@"客户：", model.realname_client) ;
    channelLabel.text = StrFormatTW(@"渠道：", model.channel_name);
    itemLabel.text = StrFormatTW(@"支付类目：", model.item_type_txt);
    moneyLabel.text = StrFormatTW(@"支付金额：￥", model.money);
    //支付状态1待支付 2待审核 3已驳回 4支付失败 5已完成
    if ([model.pay_status isEqualToString:@"1"]||[model.pay_status isEqualToString:@"3"]||[model.pay_status isEqualToString:@"4"]) {
        UIButton *editButton    = (UIButton *)[self  viewWithTag:105];
        UIButton *payButton     = (UIButton *)[self viewWithTag:106];
        UIButton *offlineButton = (UIButton *)[self viewWithTag:107];
        [editButton addTarget:self action:@selector(buttonCilck:) forControlEvents:(UIControlEventTouchUpInside)];
        [payButton addTarget:self action:@selector(buttonCilck:) forControlEvents:(UIControlEventTouchUpInside)];
        [offlineButton addTarget:self action:@selector(buttonCilck:) forControlEvents:(UIControlEventTouchUpInside)];
    }else if ([model.pay_status isEqualToString:@"5"]) {
        UILabel *operatorLabel     = (UILabel *)[self viewWithTag:108];
        operatorLabel.text = StrFormatTW(@"收取人：", model.operator_name_pay);
    }
}
-(void)buttonCilck:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"编辑"]) {
        
    }else if ([button.titleLabel.text isEqualToString:@"直接支付"]){
    
    }else if([button.titleLabel.text isEqualToString:@"线下支付"]){
    
    }
    if (self.buttonClickBlock) {
        self.buttonClickBlock(button.titleLabel.text);
    }
}
+(instancetype)setupCellWith:(UITableView*)tableView Model:(PayData *)model{
    NSString  *identifier=@"PayCellID";
    NSInteger index=0;
    if([model.pay_status isEqualToString:@"1"]||[model.pay_status isEqualToString:@"3"]){
        // 1待支付 3已驳回
    }else if([model.pay_status isEqualToString:@"2"]){
        // 2待审核
        index = 1;
        identifier=@"PayCellID1";
        
    }else if([model.pay_status isEqualToString:@"4"]){
        // 4支付失败
    }else if([model.pay_status isEqualToString:@"5"]){
        //  5已完成
        identifier=@"PayCellID2";
        index = 2;
    }
    PayCell *cell= (PayCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"PayCell" owner:nil options:nil] objectAtIndex:index];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
+(CGFloat)cellHeight:(PayData *)model{

//    NSString  *identifier=@"PayCellID";
//    NSInteger index=0;
//    if([model.pay_status isEqualToString:@"1"]||[model.pay_status isEqualToString:@"3"]){
//        // 1待支付 3已驳回
//    }else if([model.pay_status isEqualToString:@"2"]){
//        // 2待审核
//        index = 1;
//        identifier=@"PayCellID1";
//        
//    }else if([model.pay_status isEqualToString:@"4"]){
//        // 4支付失败
//    }else if([model.pay_status isEqualToString:@"5"]){
//        //  5已完成
//        identifier=@"PayCellID2";
//        index = 2;
//    }
//    PayCell *cell;
//    if (cell==nil) {
//        cell=[[[NSBundle mainBundle]loadNibNamed:@"PayCell" owner:nil options:nil] objectAtIndex:index];
//    }
   // UILabel *channelLabel   = (UILabel *)[cell.contentView viewWithTag:102];
    UILabel *channelLabel = [UILabel new];
    channelLabel.text = StrFormatTW(@"渠道：", model.channel_name);
    CGSize size = [channelLabel.text boundingRectWithSize:CGSizeMake(kScreen_Width-155, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil].size;

    
   // NSLog(@"%.f %@",size.height,channelLabel.text);
    if([model.pay_status isEqualToString:@"1"]||[model.pay_status isEqualToString:@"3"]){
        // 1待支付 3已驳回
        return 159+size.height - 18 ;
    }else if([model.pay_status isEqualToString:@"2"]){
        // 2待审核
        return 109+size.height - 18;
    }else if([model.pay_status isEqualToString:@"4"]){
        // 4支付失败
        return 159+size.height - 18;
    }else if([model.pay_status isEqualToString:@"5"]){
        //  5已完成
        return 130+size.height - 18;
    }else{
        return 159+size.height - 18;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
