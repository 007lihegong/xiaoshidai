//
//  BookCell.m
//  xiaoshidai
//
//  Created by XSD on 16/11/16.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "BookCell.h"

@implementation BookCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.textColor = UIColorFromRGB(0x111111);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- ( void )layoutSubviews {
    [ super layoutSubviews ];
    self.imageView.bounds  = CGRectMake (10,5,34,34);
    self.imageView.frame  = CGRectMake (10,5,34,34);
    self.imageView.contentMode  = UIViewContentModeScaleAspectFit ;
    CGRect tmpFrame = self.textLabel.frame ;
    tmpFrame.origin.x  = 59;
    self.textLabel.frame  = tmpFrame;
    tmpFrame = self.detailTextLabel.frame ;
    tmpFrame.origin.x = 59;
    self.detailTextLabel.frame = tmpFrame;
    self.separatorInset = UIEdgeInsetsMake(self.height, 59, 0, 0);
}
@end
