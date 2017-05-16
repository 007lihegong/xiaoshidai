//
//  TextFieldCell.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/29.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "TextFieldCell.h"
#import "UITextField+RYNumberKeyboard.h"

@interface TextFieldCell ()<UITextFieldDelegate>{
    UIView *view;
}
@end
@implementation TextFieldCell
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
    _titleLabel.text = @"真实姓名";
    [_titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_titleLabel setTextColor:UIColorFromRGB(0x333333)];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(16);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.bottom.mas_equalTo(self.contentView).offset(-16);
    }];
    [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

    _textField = [MyControl creatTextFieldWithPlaceholder:@"请输入" Font:15 TextColor:UIColorFromRGB(0x999999) Alignment:NSTextAlignmentRight ClearButtonMode:UITextFieldViewModeWhileEditing];
    _textField.textColor = [UIColor blackColor];
    [_textField addTarget:self action:@selector(textfieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(_titleLabel.mas_right).offset(12);
        make.right.mas_equalTo(self.contentView).offset(-22);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0,_textField.Y+1, kScreen_Width, 1)];
    view.backgroundColor = BorderColor;
    
    _frontImageView = [UIImageView new];
    _frontImageView.image = IMGNAME(@"icn_addpic");
    
    _backImageView = [UIImageView new];
    _backImageView.image = IMGNAME(@"icn_addpic");

}
-(void)setModel:(RealNameInfoModel *)model{
    if ([_titleLabel.text isEqualToString:@"身份证号"]) {
        self.textField.text = model.data.id_number;
        self.textField.ry_inputType = RYIDCardInputType;
    }else if ([_titleLabel.text isEqualToString:@"真实姓名"]){
        self.textField.text = model.data.realname;
    }
}
-(void)UpdateUI{
    [_textField removeFromSuperview];
    [self.contentView addSubview:view];
    [self.contentView addSubview:_frontImageView];
    [self.contentView addSubview:_backImageView];
    
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(16);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.bottom.mas_equalTo(self.contentView).offset(-41);
    }];

}
#pragma mark - private method
- (void)textfieldTextDidChange:(UITextField *)textField
{
    if ([self.titleLabel.text isEqualToString:@"银行卡号"]||[self.titleLabel.text isEqualToString:@"银行账号"]) {
        if (textField.text.length > 19) {
            textField.text = [textField.text substringToIndex:19];
        }
    }
    if ([self.titleLabel.text isEqualToString:@"手机号"]) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    if ([self.titleLabel.text isEqualToString:@"身份证号"]) {
        if (textField.text.length > 18) {
            textField.text = [textField.text substringToIndex:18];
        }
    }
    if (self.block) {
        self.block(self.textField.text);
    }
}
-(void)setTitle:(NSString *)title{
    if ([title isEqualToString:@"贷款金额"]) {
        _textField.rightViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UILabel *label = [UILabel new];
        label.text = @" 万元";
        label.font = [UIFont systemFontOfSize:15];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        _textField.rightView = label;
    }else if([title isEqualToString:@"身份证号"]){
        _textField.ry_inputType = RYIDCardInputType;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
