//
//  ordRelyCell.m
//  xiaoshidai
//
//  Created by 名侯 on 16/9/29.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "ordRelyCell.h"
#import "UIView+SDAutoLayout.h"
#import "relycellView.h"
#import "Defines.h"
#import "BaseVC.h"
#import "XYString.h"
#import "ordDetailModel.h"

@implementation ordRelyCell
{
    UILabel *_storeLB;
    UILabel *_nameLB;
    UILabel *_timeLB;
    UILabel *_textLB;
    UIView *backV;
    UIView *lineV;
    CGFloat Y;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        self.contentView.backgroundColor = BackGroundColor;
    }
    return self;
}

- (void)setup {
    
    BaseVC *mvc = [[BaseVC alloc] init];
    
    backV = [[UIView alloc] initWithFrame:CGRectMake(30, 15, ScreenWidth-40, 50)];
    backV.backgroundColor = colorValue(0xf8f8f8, 1);
    [mvc setYuan:backV size:5];
    [self.contentView addSubview:backV];
    
    _storeLB = [UILabel new];
    _storeLB.backgroundColor = mainHuang;
    _storeLB.textColor = [UIColor whiteColor];
    _storeLB.textAlignment = NSTextAlignmentCenter;
    _storeLB.font = [UIFont systemFontOfSize:9];
    [mvc setYuan:_storeLB size:3];
    [backV addSubview:_storeLB];
    
    _nameLB = [UILabel new];
    _nameLB.font = [UIFont systemFontOfSize:15];
    _nameLB.textColor = colorValue(0x111111, 1);
    [backV addSubview:_nameLB];
    
    _timeLB = [UILabel new];
    _timeLB.textAlignment = NSTextAlignmentRight;
    _timeLB.textColor = colorValue(0x666666, 1);
    _timeLB.font = [UIFont systemFontOfSize:10];
    [backV addSubview:_timeLB];
    
    _textLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, ScreenWidth-60, 18)];
    _textLB.textColor = colorValue(0x666666, 1);
    _textLB.font = [UIFont systemFontOfSize:12];
    _textLB.numberOfLines = 0;
    [backV addSubview:_textLB];
    
    lineV = [[UIView alloc] init];
    lineV.backgroundColor = mainHuang;
    [self.contentView addSubview:lineV];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(9, 26, 12, 12)];
    imageV.image = [UIImage imageNamed:@"nav_img_label"];
    [self.contentView addSubview:imageV];
    
    _storeLB.sd_layout
    .topSpaceToView(backV,10)
    .leftSpaceToView(backV,10)
    .heightIs(15);
    
    _nameLB.sd_layout
    .topSpaceToView(backV,7)
    .leftSpaceToView(_storeLB,5)
    .widthIs(100)
    .heightIs(21);
    
    _timeLB.sd_layout
    .topSpaceToView(backV,10)
    .rightSpaceToView(backV,10)
    .widthIs(150)
    .heightIs(15);
    
//    _textLB.sd_layout
//    .topSpaceToView(_storeLB,10)
//    .leftSpaceToView(backV,10)
//    .widthIs(200)
//    .heightIs(20);
}

#pragma mark -- 数据赋值
- (void)setModel:(ordDetailModel *)model {
    _model = model;
    
    CGFloat storeW = [XYString WidthForString:model.reply_department withSizeOfFont:9];
    _storeLB.sd_layout.widthIs(storeW+8);
    _storeLB.text = model.reply_department;
    
    _nameLB.text = model.reply_person;
    _timeLB.text = model.reply_time;
    
    if (_modelArr.count) {
        _textLB.hidden = YES;
        for (int i=0; i<_modelArr.count; i++) {
            relycellView *relyV = [[relycellView alloc] initWithFrame:CGRectMake(10, 35+i*110, ScreenWidth-60, 110)];
            relyV.model = _modelArr[i];
            if (i==0) {
                relyV.frame = CGRectMake(10, 35, ScreenWidth-60, [relyV setHeaght]);
                Y = 35+[relyV setHeaght];
            }else {
                relyV.frame = CGRectMake(10, Y, ScreenWidth-60, [relyV setHeaght]);
                Y = Y+[relyV setHeaght];
            }
            [backV addSubview:relyV];
            Y = CGRectGetMaxY(relyV.frame);
        }
        backV.height = Y;
    }else {
        _textLB.text = model.reply_text;
        [_textLB sizeToFit];
        backV.height = CGRectGetMaxY(_textLB.frame)+10;
    }
    CGFloat width = 1/[UIScreen mainScreen].scale;
    CGFloat offset = ((1-[UIScreen mainScreen].scale)/2);
   
    if (self.count>1) {
        if (self.indx==0) {
            lineV.frame = CGRectMake(15 + offset, 30, width, backV.height+30-30);
        }else if(self.indx==self.count-1) {
            lineV.frame = CGRectMake(15 + offset, 0, width, 30);
        }else {
            lineV.frame = CGRectMake(15 + offset, 0, width, backV.height+30);
        }
    }
}
- (void)setModelArr:(NSArray *)modelArr {
    _modelArr = modelArr;
}
- (CGFloat)setHeaght {
    
    return backV.height+30;
}

@end
