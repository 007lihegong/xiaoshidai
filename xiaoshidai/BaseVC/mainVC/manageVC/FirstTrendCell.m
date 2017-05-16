//
//  FirstTrendCell.m
//  xiaoshidai
//
//  Created by XSD on 16/10/28.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "FirstTrendCell.h"
#import "JHChartHeader.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@implementation FirstTrendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /*        创建表对象         */
        JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(+5, 10, k_MainBoundsWidth-20, 180) andLineChartType:JHChartLineValueNotForEveryX];
        /* X轴的刻度值 可以传入NSString或NSNumber类型  并且数据结构随折线图类型变化而变化 详情看文档或其他象限X轴数据源示例*/
        lineChart.xLineDataArr = @[@"0",@"1",@"2",@3,@4,@5,@6,@7];
        /* 折线图的不同类型  按照象限划分 不同象限对应不同X轴刻度数据源和不同的值数据源 */
        lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
        /* 数据源 */
        // 远DEMO数据
        // lineChart.valueArr = @[@[@"1",@"12",@"1",@6,@4,@9,@6,@7],@[@"3",@"1",@"2",@16,@2,@3,@5,@10]];
        lineChart.valueArr = @[@[@"1000",@"5700",@"12345",@6000,@4000,@9000,@6000,@7000],@[]];
        
        /* 值折线的折线颜色 默认暗黑色*/
        lineChart.valueLineColorArr =@[ MyBlueColor, [UIColor brownColor]];
        /* 值点的颜色 默认橘黄色*/
        lineChart.pointColorArr = @[[UIColor orangeColor],[UIColor yellowColor]];
        /* X和Y轴的颜色 默认暗黑色 */
        lineChart.xAndYLineColor = [UIColor blackColor];
        /* XY轴的刻度颜色 m */
        lineChart.xAndYNumberColor = [UIColor blueColor];
        /* 坐标点的虚线颜色 */
        lineChart.positionLineColorArr = @[[UIColor clearColor],[UIColor greenColor]];
        /*        设置是否填充内容 默认为否         */
        lineChart.contentFill = YES;
        /*        设置为曲线路径         */
        lineChart.pathCurve = YES;
        
        /*        设置填充颜色数组         */
        lineChart.contentFillColorArr = @[color(151, 218, 248, 0.468),[UIColor DisplayP3Red:0.500 green:0.214 blue:0.098 alpha:0.468]];
        [self addSubview:lineChart];
        /*        开始动画         */
        [lineChart showAnimation];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
