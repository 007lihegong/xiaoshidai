//
//  AddPicCell.m
//  xiaoshidai
//
//  Created by XSD on 2017/1/3.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "AddPicCell.h"
#import "UIButton+WebCache.h"
@interface AddPicCell (){
    UIView *view;
}
@end
@implementation AddPicCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}
-(void)initUI{
    
    _titleLabel = [UILabel new];
    _titleLabel.text = @"身份证照";
    [_titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_titleLabel setTextColor:UIColorFromRGB(0x333333)];
    [self.contentView addSubview:_titleLabel];
    
    view = [UIView new];
    view.backgroundColor = BorderColor;
    [self.contentView addSubview:view];
    
    _frontImageView = [UIButton new];
    [_frontImageView setImage:IMGNAME(@"icn_addpic") forState:(UIControlStateNormal)];
    [self.contentView addSubview:_frontImageView];
    _frontImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _backImageView = [UIButton new];
    [_backImageView setImage:IMGNAME(@"icn_addpic") forState:(UIControlStateNormal)];
    [self.contentView addSubview:_backImageView];
    _backImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _frontImageView.clipsToBounds = YES;
    _backImageView.clipsToBounds = YES;
    [_frontImageView.layer setCornerRadius:7.0];
    [_backImageView.layer setCornerRadius:7.0];
    
   // _textField = [MyControl creatTextFieldWithPlaceholder:@"请输入" Font:15 TextColor:UIColorFromRGB(0x999999) Alignment:NSTextAlignmentRight ClearButtonMode:UITextFieldViewModeWhileEditing];
  //  [self.contentView addSubview:_textField];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(16);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.bottom.mas_equalTo(view).offset(-16);
    }];
    [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    

   // [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
   //     make.top.mas_equalTo(_titleLabel);
  //      make.left.mas_equalTo(_titleLabel.mas_right).offset(12);
   //     make.right.mas_equalTo(self.contentView).offset(-22);
  //      make.bottom.mas_equalTo(_titleLabel);
   // }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];

    NSArray * array = [NSArray arrayWithObjects:_frontImageView,_backImageView, nil];
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:20 tailSpacing:15];
    [array mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(15);
        make.height.mas_equalTo((kScreen_Width-50)/2*(30.0/49));
        make.bottom.mas_equalTo(self.contentView).offset(-31);
    }];
    UILabel *front = [UILabel new];
    front.text = @"正面";
    [front setFont:[UIFont systemFontOfSize:12]];
    [front setTextColor:UIColorFromRGB(0x333333)];
    [self.contentView addSubview:front];
    [front mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_frontImageView.mas_bottom).offset(7);
        make.centerX.mas_equalTo(_frontImageView.mas_centerX);
    }];
    UILabel *back = [UILabel new];
    back.text = @"反面";
    [back setFont:[UIFont systemFontOfSize:12]];
    [back setTextColor:UIColorFromRGB(0x333333)];
    [self.contentView addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backImageView.mas_bottom).offset(7);
        make.centerX.mas_equalTo(_backImageView.mas_centerX);
    }];
    
}
-(void)setModel:(RealNameInfoModel *)model{
    NSLog(@"%s",__func__);
    [_frontImageView sd_setImageWithURL:[NSURL URLWithString:model.data.card_pic_front_show] forState:(UIControlStateNormal)placeholderImage:IMGNAME(@"icn_addpic")];
     [_backImageView sd_setImageWithURL:[NSURL URLWithString:model.data.card_pic_back_show] forState:(UIControlStateNormal)placeholderImage:IMGNAME(@"icn_addpic")];
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
