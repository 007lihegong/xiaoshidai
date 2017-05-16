//
//  TagsCell.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/21.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "TagsCell.h"
#import "HXTagsView.h"
@interface TagsCell ()

@property (nonatomic,strong)  HXTagsView * tagsView;
@end
static float height;

@implementation TagsCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    
        self.contentView.backgroundColor = [UIColor whiteColor];
        //BackGroundColor;
    }
    return self;
}
-(void)initUI{
    _companyLabel = [UILabel new];
    [_companyLabel setFont:[UIFont systemFontOfSize:15]];
    [_companyLabel setTextColor:[UIColor blackColor]];
    [_companyLabel setText:@"阿里巴巴-花呗"];
    [self.contentView addSubview:_companyLabel];
    [_companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(12);
        make.top.mas_equalTo(self.contentView).offset(15);
    }];
    
    _statusLabel = [UILabel new];
    [_statusLabel setFont:[UIFont systemFontOfSize:12]];
    [_statusLabel setTextColor:mainHuang];
    [_statusLabel setText:@"已放款"];
    [self.contentView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.top.mas_equalTo(self.contentView).offset(15);
    }];
    
    _tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50)];
    _tagsView.type = 0;
    _tagsView.titleSize = 12.0;
    _tagsView.cornerRadius = 9.0;
    _tagsView.tagHeight = 21;
    _tagsView.normalBackgroundImage = [self imageWithColor:UIColorFromRGB(0xf8f8f8) size:CGSizeMake(1.0, 1.0)];
    _tagsView.highlightedBackgroundImage = [self imageWithColor:UIColorFromRGB(0xf8f8f8) size:CGSizeMake(1.0, 1.0)];

    //_tagsView.defaultChoice = YES;
    _tagsView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_tagsView];
    [_tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(_companyLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, 50));
    }];
    _payButton  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:_payButton];
    [_payButton setTitle:@"输入金额" forState:(UIControlStateNormal)];
    [_payButton setBackgroundColor:mainHuang];
    [_payButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_payButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_payButton.layer setCornerRadius:7];
    [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tagsView.mas_bottom);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(70, 23));
    }];
    
    _editButton  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.contentView addSubview:_editButton];
    [_editButton setTitle:@"支付" forState:(UIControlStateNormal)];
    [_editButton setBackgroundColor:mainHuang];
    [_editButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_editButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_editButton.layer setCornerRadius:7];
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tagsView.mas_bottom);
        make.right.mas_equalTo(_payButton.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(70, 23));
    }];
}
//颜色生成图片方法
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,
                                   
                                   color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
-(void)fillCellWithArray:(NSMutableArray *)array{
    [_tagsView setTagAry:array delegate:self withTagArray:nil];
    height = _tagsView.height;
    self.height = height + self.companyLabel.height +25;
    [_tagsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(_companyLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, height));
    }];
}
- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.companyLabel sizeThatFits:size].height;
    _tagsView.height = height;
    totalHeight += _tagsView.height;
    totalHeight += 15+5+28; // margins
    return CGSizeMake(size.width, totalHeight);
}

@end
