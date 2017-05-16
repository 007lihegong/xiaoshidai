//
//  MyBankCardCell.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/29.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "MyBankCardCell.h"

@implementation MyBankCardCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}
-(void)initUI{
    _headImageView = [[UIImageView alloc] init];
    _headImageView.layer.cornerRadius = 22.5f;
    //_headImageView.backgroundColor = mainHuang;
    [_headImageView setImage:IMGNAME(@"img_hengfeng")];
    [self.contentView addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(self.contentView).offset(8);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    _bankNameLabel = [UILabel new];
    _bankNameLabel.text = LocalizationNotNeeded(@"中国银行");
    [_bankNameLabel setFont:[UIFont systemFontOfSize:15]];
    [_bankNameLabel setTextColor:UIColorFromRGB(0x333333)];
    [self.contentView addSubview:_bankNameLabel];
    [_bankNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(16);
        make.left.mas_equalTo(_headImageView.mas_right).offset(15);
    }];
    [_bankNameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    _bankCardNumLabel = [UILabel new];
    _bankCardNumLabel.text = @"**** **** **** ***7135";
    [_bankCardNumLabel setFont:[UIFont systemFontOfSize:12]];
    [_bankCardNumLabel setTextColor:UIColorFromRGB(0x666666)];
    [self.contentView addSubview:_bankCardNumLabel];
    [_bankCardNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bankNameLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(_headImageView.mas_right).offset(15);
        make.bottom.mas_equalTo(self.contentView).offset(-16);
        make.width.mas_lessThanOrEqualTo(self.width-100);
    }];
    
    _phoneNumLabel = [UILabel new];
    _phoneNumLabel.text = @"手机尾号1387";
    [_phoneNumLabel setFont:[UIFont systemFontOfSize:12]];
    [_phoneNumLabel setTextColor:UIColorFromRGB(0x333333)];
    [self.contentView addSubview:_phoneNumLabel];
    [_phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-12);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
