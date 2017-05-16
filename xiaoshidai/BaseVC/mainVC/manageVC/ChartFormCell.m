//
//  ChartFormCell.m
//  xiaoshidai
//
//  Created by XSD on 16/10/31.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "ChartFormCell.h"
#import "JHChartHeader.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@interface ChartFormCell(){
    JHTableChart *table;
}
@end
@implementation ChartFormCell

- (void)awakeFromNib {
    [super awakeFromNib];

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){

    }
    return self;
}
-(void)setModel:(TrendModel *)model{
    if (table) {
        [table removeFromSuperview];
        table = nil;
    }
    
    /*        创建对象         */
    table = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 10, k_MainBoundsWidth, 200)];
    /*        表名称         */
    //table.tableTitleString = @"全选jeep自由光";
    /*        每一列的声明 其中第一个如果需要分别显示行和列的说明 可以用‘|’分割行和列         */
    table.colTitleArr = @[@"时间",self.title];
    /*        列的宽度数组 从第一列开始         */
    table.colWidthArr = @[@100.0,@120.0];
    /*        表格体的文字颜色         */
    table.bodyTextColor = [UIColor darkGrayColor];
    /*        最小的方格高度         */
    table.minHeightItems = 30;
    /*        表格的线条颜色         */
    table.tableTitleFont = [UIFont systemFontOfSize:12];
    table.tableChartTitleItemsHeight = 30;

    
    table.lineColor = [UIColor darkGrayColor];
    table.backgroundColor = [UIColor whiteColor];
    /*        数据源数组 按照从上到下表示每行的数据 如果其中一行中某列存在多个单元格 可以再存入一个数组中表示         */
    if ([_title isEqualToString:@"进件量(万元)"]) {
        _title = @"进件量(件)";
    }
    table.colTitleArr = @[@"时间",self.title];

    [table.dataArr removeAllObjects];
    NSMutableArray *datas = [NSMutableArray array];
    for (SerFeeDetail *item in model.data.detail) {
        if ([XYString isBlankString:item.x_axis ]) {
            item.x_axis = @"错误值";
            item.y_axis = @"错误值";
        }
        NSMutableArray * XTitles = [NSMutableArray array];
        [XTitles addObject:item.x_axis];
        [XTitles addObject:item.y_axis];
        [datas addObject:XTitles];
    }
    table.dataArr = datas;
//    table.dataArr = [@[
//                       @[@"2.4L优越版",@"2016皓白标准漆蓝棕"],
//                       @[@"2.4专业版",@"2016皓白标准漆蓝棕"],
//                       @[@"2.4豪华版",@"4"],
//                       @[@"2.4旗舰版",@"6"]
//                       ]mutableCopy];
    /*        显示 无动画效果         */
    [table showAnimation];
    [self addSubview:table];
    /*        设置表格的布局 其中 [table heightFromThisDataSource] 为自动按照当前数据源计算所需高度        */
    table.frame = CGRectMake(0, 10, k_MainBoundsWidth, [table heightFromThisDataSource]);
    self.height = [table heightFromThisDataSource]+20;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
