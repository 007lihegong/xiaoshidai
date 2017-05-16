//
//  MyChartCell.h
//  xiaoshidai
//
//  Created by XSD on 16/11/1.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "SCChartCell.h"
@interface MyChartCell : SCChartCell
- (void)configUI:(NSIndexPath *)indexPath;
@property (nonatomic) UISegmentedControl *segmentedControl;

@end
