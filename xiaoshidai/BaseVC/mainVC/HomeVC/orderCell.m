//
//  orderCell.m
//  xiaoshidai
//
//  Created by 名侯 on 16/10/17.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "orderCell.h"
#import "homeTagV.h"

@implementation orderCell
{
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"orderCell" owner:nil options:nil] lastObject];
        [self setup];
    }
    return self;
}

- (void)setup {
    
    for (int i=0; i<4; i++) {
        
        homeTagV *titleLB = [[homeTagV alloc] initWithFrame:CGRectMake(12, 127, 100, 12)];
        titleLB.tag=800+i;
        titleLB.type = i+1;
        [self.contentView addSubview:titleLB];
    }
}

- (void)setTitleArr:(NSArray *)titleArr {
    _titleArr = titleArr;
    
    homeTagV *jin = (homeTagV *)[self.contentView viewWithTag:800];
    homeTagV *zican = (homeTagV *)[self.contentView viewWithTag:801];
    homeTagV *bao = (homeTagV *)[self.contentView viewWithTag:802];
    homeTagV *yu = (homeTagV *)[self.contentView viewWithTag:803];
    if (titleArr.count==3) {
        jin.hidden = YES;
        zican.title = titleArr[0];
        bao.x = CGRectGetMaxX(zican.frame)+10;
        bao.title = titleArr[1];
        yu.x = CGRectGetMaxX(bao.frame)+10;
        yu.title = titleArr[2];
    }else {
        jin.title = titleArr[0];
        zican.x = CGRectGetMaxX(jin.frame)+10;
        zican.title = titleArr[1];
        bao.x = CGRectGetMaxX(zican.frame)+10;
        bao.title = titleArr[2];
        yu.x = CGRectGetMaxX(bao.frame)+10;
        yu.title = titleArr[3];
    }
}

@end
