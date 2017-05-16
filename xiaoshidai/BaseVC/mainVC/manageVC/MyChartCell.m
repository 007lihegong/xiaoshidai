//
//  MyChartCell.m
//  xiaoshidai
//
//  Created by XSD on 16/11/1.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "MyChartCell.h"
#import "SCChart.h"
@interface MyChartCell()<SCChartDataSource>
{
    NSIndexPath *path;
    SCChart *chartView;
    NSInteger index;
}
@end
@implementation MyChartCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"服务费",@"放款额",@"进件量",@"成单量",@"成单率",nil];
        //初始化UISegmentedControl
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
        // 设置默认选择项索引
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.tintColor = UIColorFromRGB(0xff7f1a);
        [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:UIColorFromRGB(0xff7f1a)} forState:(UIControlStateNormal)];
        [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:(UIControlStateSelected)];
        
        // segmentedControl.momentary = YES;
        CGFloat width = (kScreen_Width-70)/5;
        [_segmentedControl setTitle:segmentedArray[0] forSegmentAtIndex:0];//设置指定索引的题目
        [_segmentedControl setWidth:width forSegmentAtIndex:0];
        
        [_segmentedControl setTitle:segmentedArray[1] forSegmentAtIndex:1];//设置指定索引的题目
        [_segmentedControl setWidth:width forSegmentAtIndex:1];
        
        [_segmentedControl setTitle:segmentedArray[2] forSegmentAtIndex:2];//设置指定索引的题目
        [_segmentedControl setWidth:width forSegmentAtIndex:2];
        
        [_segmentedControl setTitle:segmentedArray[3] forSegmentAtIndex:3];//设置指定索引的题目
        [_segmentedControl setWidth:width forSegmentAtIndex:3];
        
        [_segmentedControl setTitle:segmentedArray[4] forSegmentAtIndex:4];//设置指定索引的题目
        [_segmentedControl setWidth:width forSegmentAtIndex:4];
        
        [_segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
        [self addSubview:_segmentedControl];

        [_segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(5);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(kScreen_Width-70);
        }];
    }
    return self;
}
-(void)didClicksegmentedControlAction:(UISegmentedControl *)sender{
    NSInteger Index = sender.selectedSegmentIndex;
    index = Index;
    [chartView strokeChart];
    NSLog(@"Index %li", (long)Index);
}
- (void)btnPressed:(id)sender {
    [chartView strokeChart];
}

- (void)configUI:(NSIndexPath *)indexPath {
    if (chartView) {
        [chartView removeFromSuperview];
        chartView = nil;
    }
    path = indexPath;
    chartView = [[SCChart alloc] initwithSCChartDataFrame:CGRectMake(5, (self.frame.size.height-150)/2, [UIScreen mainScreen].bounds.size.width - 10, 150)
                                               withSource:self
                                                withStyle:SCChartLineStyle];
    [chartView showInView:self.contentView];
}

- (NSArray *)getXTitles:(int)num {
    NSMutableArray *xTitles = [NSMutableArray array];
    [xTitles removeAllObjects];
    NSArray * items;
    UILabel *label = (UILabel *)[self viewWithTag:2244];
    if (index == 0) {
        items = self.model.data.service_fee;
    }else if (index == 1){
        items = self.model.data.loan_amount;
    }else if (index == 2){
        items = self.model.data.enter_amount;
        label.text = @"单位:件";
    }else if (index == 3){
        items = self.model.data.deal_amount;
        label.text = @"单位:件";
    }else if (index == 4){
        items = self.model.data.deal_rate;
        label.text = @"单位:%";
    }
    for (TrendLoan_Amount *model in items) {
        if ([XYString isBlankString:model.x_axis ]) {
            model.x_axis = @"错误值";
        }
        [xTitles addObject:model.x_axis];
    }
    //NSLog(@"x_axis = %@",xTitles);
    return xTitles;
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)SCChart_xLableArray:(SCChart *)chart {
    return [self getXTitles:7];
}

//数值多重数组
- (NSArray *)SCChart_yValueArray:(SCChart *)chart {
    switch (path.row) {
        case 0:
        {
            NSMutableArray *ary = [NSMutableArray array];
            [ary removeAllObjects];
            NSArray * items;
            if (index == 0) {
                items = self.model.data.service_fee;
            }else if (index == 1){
                items = self.model.data.loan_amount;
            }else if (index == 2){
                items = self.model.data.enter_amount;
            }else if (index == 3){
                items = self.model.data.deal_amount;
            }else if (index == 4){
                items = self.model.data.deal_rate;
            }
            for (TrendLoan_Amount *model in items) {
                if ([XYString isBlankString:model.x_axis ]) {
                    model.y_axis = @"错误值";
                }
                [ary addObject:model.y_axis];
            }
            return @[ary];
            break;
        }
        case 1:
        {
            NSMutableArray *ary = [NSMutableArray array];
            NSMutableArray *ary2 = [NSMutableArray array];
            for (NSInteger i = 0; i < 7; i++) {
                CGFloat num = arc4random_uniform(1000) / 100;
                NSString *str = [NSString stringWithFormat:@"%f",num];
                [ary addObject:str];
            }
            for (NSInteger i = 0; i < 7; i++) {
                CGFloat num = arc4random_uniform(1000) / 100;
                NSString *str = [NSString stringWithFormat:@"%f",num];
                [ary2 addObject:str];
            }
            return @[ary,ary2];
            break;
        }
        case 2:
        {
            NSMutableArray *ary = [NSMutableArray array];
            NSMutableArray *ary2 = [NSMutableArray array];
            NSMutableArray *ary3 = [NSMutableArray array];
            for (NSInteger i = 0; i < 7; i++) {
                CGFloat num = arc4random_uniform(500);
                NSString *str = [NSString stringWithFormat:@"%f",num];
                [ary addObject:str];
            }
            for (NSInteger i = 0; i < 7; i++) {
                CGFloat num = arc4random_uniform(1000);
                NSString *str = [NSString stringWithFormat:@"%f",num];
                [ary2 addObject:str];
            }
            for (NSInteger i = 0; i < 7; i++) {
                CGFloat num = arc4random_uniform(2000);
                NSString *str = [NSString stringWithFormat:@"%f",num];
                [ary3 addObject:str];
            }
            return @[ary,ary2,ary3];
            break;
        }
        default:
            break;
    }
    return nil;
}

#pragma mark - @optional
//颜色数组
- (NSArray *)SCChart_ColorArray:(SCChart *)chart {
    return @[SCBlue,SCRed,SCGreen];
}

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)SCChartMarkRangeInLineChart:(SCChart *)chart {
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)SCChart:(SCChart *)chart ShowHorizonLineAtIndex:(NSInteger)index {
    return YES;
}

//判断显示最大最小值
- (BOOL)SCChart:(SCChart *)chart ShowMaxMinAtIndex:(NSInteger)index {
    return YES;
}

@end
