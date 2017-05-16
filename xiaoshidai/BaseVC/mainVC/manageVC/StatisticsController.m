//
//  StatisticsController.m
//  xiaoshidai
//
//  Created by XSD on 16/10/25.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "StatisticsController.h"
#import "SCChartCell.h"
#import "SCBarCell.h"
#import "SCCircleCell.h"
#import "SCPieCell.h"
#import "DecorateTableViewCell.h"
#import "LeftView.h"
#import "FirstTrendCell.h"
#import "MyChartCell.h"

#import "CollectModel.h"
#import "TrendModel.h"
#import "DepartmentModel.h"
#define HeadHeight 80.0
@interface StatisticsController ()<UITableViewDelegate,UITableViewDataSource>{
    UIView *headView;
    UIView *dropBackV;
    UITableView *dropV;
    UISegmentedControl *segmentedControl;
    UIButton *_currentBt;
    NSString *_yunyingStr;
    NSString *_mendianStr;
    NSString *_MemStr;
    NSString *_timeStr;
    NSString *_backStr;
    NSMutableDictionary *_param;

}
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSMutableArray *dropDataArray;

@property (nonatomic) TrendModel *trendModel;
@property (nonatomic) NSMutableArray *sectionArray;
@property (nonatomic) NSMutableArray *depOpArray;




@end

@implementation StatisticsController
static NSString *reuseIdentifierChart = @"SCChartCell";
static NSString *reuseIdentifierBar = @"SCBarCell";
static NSString *reuseIdentifierCircle = @"SCCircleCell";
static NSString *reuseIdentifierPie = @"SCPieCell";
static NSString *reuseIdentifierDec = @"DECCell";
static NSString *reuseIdentifierMy = @"MyChartCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
//    @try {
//        NSString *str = nil;
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//        [dic setObject:str forKey:@"1"];
//    } @catch (NSException *exception) {
//        [Bugly reportException:exception];
//    } @finally {
//        
//    }
    _param = [NSMutableDictionary dictionary];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"all" forKey:@"data_scope"];
    [param setObject:@"yesterday" forKey:@"time_scope"];
    [self initDataWithDict:param urlString:CollectSup];
    [self initDataWithDict:param urlString:TrendSup];
    _sectionArray = [NSMutableArray arrayWithObjects:@"概况",@"趋势图", nil];

}
//初始化数据
#pragma mark - 初始化网络请求的内容
-(void)initDataWithDict:(NSMutableDictionary *)dict urlString:(NSString *)urlString{
    @try {
        NSLog(@"参数:%@",dict);
        NSMutableArray *tokenArr = [NSMutableArray array];
        NSMutableDictionary *param  = [NSMutableDictionary dictionary];
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [tokenArr addObject:@{@"price":key,@"vaule":StrFormatTW(key, obj)}];
            [param setObject:[self setRSAencryptString:obj] forKey:key];
        }];
        if ([urlString isEqualToString:DepBk]||[urlString isEqualToString:DepOp]||[urlString isEqualToString:DepSt]||[urlString isEqualToString:DepeMp]) {
            [_dropDataArray removeAllObjects];
            [dropV reloadData];
            [param setObject:[self setApiTokenStr] forKey:@"token"];
        }else{
            [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
        }
        [LCProgressHUD showLoading:@""];
        [self post:urlString parameters:param success:^(id dic) {
            if ([dic[@"code"] intValue]==0) {
                [LCProgressHUD hide];
                if ([urlString isEqualToString:CollectSup]) {
                    CollectModel *collectModel = [CollectModel mj_objectWithKeyValues:dic];
                    self.dataArray = [collectModel.data mutableCopy];
                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:(UITableViewRowAnimationNone)];
                }else if ([urlString isEqualToString:TrendSup]){
                    _trendModel = [TrendModel mj_objectWithKeyValues:dic];
                    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:(UITableViewRowAnimationNone)];

                }else if ([urlString isEqualToString:DepeMp]||[urlString isEqualToString:DepOp] || [urlString isEqualToString:DepSt]||[urlString isEqualToString:DepBk]){
                    DepartmentModel *model = [DepartmentModel mj_objectWithKeyValues:dic];
                    NSMutableDictionary * all = [NSMutableDictionary dictionary];
                    if ([urlString isEqualToString:DepeMp]) {
                        [all setObject:@"" forKey:@"operator_id"];
                        [all setObject:@"全部" forKey:@"operator_name"];
                    }else{
                        [all setObject:@"" forKey:@"department_id"];
                        [all setObject:@"全部" forKey:@"department_name"];
                    }
                    _dropDataArray = [model.data mutableCopy];
                    [_dropDataArray insertObject:all atIndex:0];
                    [dropV reloadData];
                }
            }else {

                [LCProgressHUD showFailure:dic[@"info"]];
            }
        } failure:^(NSError *error) {
            [_dropDataArray removeAllObjects];
            [dropV reloadData];
            [LCProgressHUD showFailure:[error localizedDescription]];
        }];
    } @catch (NSException *exception) {
        
    } @catch (NSException *exception){
        
    } @finally {
        
    }

}
//初始化UI
-(void)initUI{
    [self initSegment];
    [self tableView];
    [self setdropdownView];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HeadHeight, kScreen_Width, kScreen_Height-HeadHeight-64) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        [_tableView registerClass:[SCChartCell class] forCellReuseIdentifier:reuseIdentifierChart];
        [_tableView registerClass:[SCBarCell class] forCellReuseIdentifier:reuseIdentifierBar];
        [_tableView registerClass:[SCCircleCell class] forCellReuseIdentifier:reuseIdentifierCircle];
        [_tableView registerClass:[SCPieCell class] forCellReuseIdentifier:reuseIdentifierPie];
        [_tableView registerClass:[DecorateTableViewCell class] forCellReuseIdentifier:reuseIdentifierDec];
        [_tableView registerClass:[MyChartCell class] forCellReuseIdentifier:reuseIdentifierMy];

        [_tableView registerClass:[FirstTrendCell class] forCellReuseIdentifier:@"FirstTrendCellID"];


        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(void)initSegment{
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, HeadHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"公司",@"前台",@"后台",nil];
    //初始化UISegmentedControl
    segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    // 设置默认选择项索引
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = UIColorFromRGB(0xff7f1a);
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColorFromRGB(0xff7f1a)} forState:(UIControlStateNormal)];
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:(UIControlStateSelected)];
    
    // segmentedControl.momentary = YES;
    CGFloat width = (kScreen_Width-70)/3;
    [segmentedControl setTitle:@"公司" forSegmentAtIndex:0];//设置指定索引的题目
    [segmentedControl setWidth:width forSegmentAtIndex:0];
    
    [segmentedControl setTitle:@"前台" forSegmentAtIndex:1];//设置指定索引的题目
    [segmentedControl setWidth:width forSegmentAtIndex:1];
    
    [segmentedControl setTitle:@"后台" forSegmentAtIndex:2];//设置指定索引的题目
    [segmentedControl setWidth:width forSegmentAtIndex:2];
    
    [segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    [headView addSubview:segmentedControl];
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(10);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(kScreen_Width-70);
    }];
    [self initDropWithArr:@[@"昨天",@"近七天",@"最近15天"]];
}
-(void)initDropWithArr:(NSArray *)array{
    for (UIView *view in headView.subviews) {
        if (![view isKindOfClass:[UISegmentedControl class]]) {
            [view removeFromSuperview];
        }
    }
    for (int i=0; i<[array count]; i++) {
        //布局状态选项
        NSInteger count = [array count];
        CGFloat width = (kScreen_Width - count+1)/count;
        UIButton *stausBT = [[UIButton alloc] initWithFrame:CGRectMake(i*width+i, 45, width, 35)];
        objc_setAssociatedObject(stausBT, "firstObject", array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        stausBT.titleLabel.font = [UIFont systemFontOfSize:13];
        stausBT.tag = 1000+i;
        (i == 0 && segmentedControl.selectedSegmentIndex == 0)?(stausBT.selected = YES):(stausBT.selected = NO );
        [stausBT setTitle:array[i] forState:UIControlStateNormal];
        [stausBT setTitleColor:colorValue(0x111111, 1) forState:UIControlStateNormal];
        [stausBT setTitleColor:colorValue(0xff7f1a, 1) forState:UIControlStateSelected];
        if (segmentedControl.selectedSegmentIndex != 0) {
            [stausBT setImage:[UIImage imageNamed:@"nav_icon_more_norm"] forState:UIControlStateNormal];
            [stausBT setImage:[UIImage imageNamed:@"nav_icon_more_selet"] forState:UIControlStateSelected];
        }
        [stausBT addTarget:self action:@selector(stauseAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i!= count-1) {
            [self PixeV:CGPointMake((i+1)*width, 45) lenght:stausBT.height add:headView];
        }
        CGFloat w = [XYString WidthForString:array[i] withSizeOfFont:13]+2;
        if (segmentedControl.selectedSegmentIndex != 0) {
            [stausBT setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
            [stausBT setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
        }
        [headView addSubview:stausBT];
    }
    [self PixeH:CGPointMake(0, 44) lenght:ScreenWidth add:headView];
}
#pragma mark - 按钮点击
- (void)stauseAction:(UIButton *)sender {
    //单选
    _currentBt = sender;
    NSArray *array = objc_getAssociatedObject(sender, "firstObject");
    for (NSInteger i =0 ;i<array.count;i++){
        UIButton *btn = [headView viewWithTag:1000+i];
        if (btn.tag != sender.tag) {
            btn.selected = NO;
        }
    }
    //弹出或者隐藏下拉的列表
    if (sender.selected) {
        if (segmentedControl.selectedSegmentIndex !=0) {
            sender.selected = NO;
            [UIView animateWithDuration:0.5 animations:^{
                dropV.Y = -kScreen_Height;
                dropBackV.alpha=0;
            }];
        }
    }else {
        sender.selected = YES;
        [self requestNetWithButton:sender];
        if (segmentedControl.selectedSegmentIndex !=0) {
            [UIView animateWithDuration:0.5 animations:^{
                dropV.Y = 80;
                dropBackV.alpha=1;
            }];
        }
    }
    segmentedControl.selectedSegmentIndex == 0?[self requestNetWithButton:sender]:@"1";
}
-(void)requestNetWithButton:(UIButton *)sender{
    @try {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        if (segmentedControl.selectedSegmentIndex == 0) {
            if ([sender.titleLabel.text isEqualToString:@"昨天"]) {
                [param setObject:@"all" forKey:@"data_scope"];
                [param setObject:@"yesterday" forKey:@"time_scope"];
                [self initDataWithDict:param urlString:CollectSup];
                [self initDataWithDict:param urlString:TrendSup];
                
            }else if ([sender.titleLabel.text isEqualToString:@"近七天"]){
                [param setObject:@"all" forKey:@"data_scope"];
                [param setObject:@"day7" forKey:@"time_scope"];
                [self initDataWithDict:param urlString:CollectSup];
                [self initDataWithDict:param urlString:TrendSup];
            }else if ([sender.titleLabel.text isEqualToString:@"最近15天"]){
                [param setObject:@"all" forKey:@"data_scope"];
                [param setObject:@"day15" forKey:@"time_scope"];
                [self initDataWithDict:param urlString:CollectSup];
                [self initDataWithDict:param urlString:TrendSup];
            }
        }
        
        if (segmentedControl.selectedSegmentIndex == 1 && sender.tag == 1000) {
            [self initDataWithDict:param urlString:DepOp];
        }else if (segmentedControl.selectedSegmentIndex == 1 && sender.tag == 1001) {
            if (_yunyingStr) {
                [param setObject:_yunyingStr forKey:@"parent_id"];
            }else{
                [param setObject:@"" forKey:@"parent_id"];
            }
            [self initDataWithDict:param urlString:DepSt];
        }else if (segmentedControl.selectedSegmentIndex == 1 && sender.tag == 1002) {
            if (_mendianStr) {
                [param setObject:_mendianStr forKey:@"department_id"];
            }else{
                [param setObject:@"" forKey:@"department_id"];
            }
            [self initDataWithDict:param urlString:DepeMp];
        }else if (segmentedControl.selectedSegmentIndex == 1 && sender.tag == 1003) {
            _dropDataArray = [@[@"昨天",@"近七天",@"最近15天"]mutableCopy];
            [dropV reloadData];
        }
        
        if (segmentedControl.selectedSegmentIndex == 2 && sender.tag == 1000) {
            [self initDataWithDict:param urlString:DepBk];
        }else if (segmentedControl.selectedSegmentIndex == 2 && sender.tag == 1001) {
            if (_backStr) {
                [param setObject:_backStr forKey:@"department_id"];
            }else{
                [param setObject:@"" forKey:@"department_id"];
            }
            [self initDataWithDict:param urlString:DepeMp];
        }else if (segmentedControl.selectedSegmentIndex == 2 && sender.tag == 1002) {
            _dropDataArray = [@[@"昨天",@"近七天",@"最近15天"]mutableCopy];
            [dropV reloadData];
        }

    } @catch (NSException *exception) {
        [LCProgressHUD showFailure:[exception description]];
    } @finally {
        
    }
}

#pragma mark -- 下拉tableView
- (void)setdropdownView {
    
    dropBackV = [[UIView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, ScreenHeight-35)];
    dropBackV.backgroundColor = color(0, 0, 0, 0.6);
    dropBackV.alpha = 0;
    [self.view addSubview:dropBackV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [dropBackV addGestureRecognizer:tap];
    
    dropV = [[UITableView alloc] initWithFrame:CGRectMake(0, -kScreen_Height, ScreenWidth, kScreen_Height-150-113) style:UITableViewStylePlain];
    [dropV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    dropV.delegate = self;
    dropV.dataSource = self;
    [self.view addSubview:dropV];
    
}
#pragma mark -- 背景的点击手势
- (void)tapAction {
    [UIView animateWithDuration:0.5 animations:^{
        dropV.Y = -kScreen_Height;
        dropBackV.alpha=0;
        _currentBt.selected = NO;
    }];
}
#pragma mark - segment 点击事件
-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    _yunyingStr = nil;
    _mendianStr = nil;
    _MemStr     = nil;
    _timeStr    = nil;
    _backStr = @"";
    if (dropV.Y != -1500) {
        [UIView animateWithDuration:0.3 animations:^{
            dropV.Y = -1500;
            dropBackV.alpha=0;
            _currentBt.selected = NO;
        }];
    }
    [_param removeAllObjects];
    switch (Index) {
        case 0:
            [self initDropWithArr:@[@"昨天",@"近七天",@"最近15天"]];
            [param setObject:@"all" forKey:@"data_scope"];
            [param setObject:@"yesterday" forKey:@"time_scope"];
            [self initDataWithDict:param urlString:CollectSup];
            [self initDataWithDict:param urlString:TrendSup];
            break;
        case 1:
            [self initDropWithArr:@[@"运营",@"门店",@"人员",@"昨天"]];
            [param setObject:@"front" forKey:@"data_scope"];
            [param setObject:@"yesterday" forKey:@"time_scope"];
            [self initDataWithDict:param urlString:CollectSup];
            [self initDataWithDict:param urlString:TrendSup];
            break;
        case 2:
            [self initDropWithArr:@[@"后台部门",@"人员",@"昨天"]];
            [param setObject:@"back" forKey:@"data_scope"];
            [param setObject:@"yesterday" forKey:@"time_scope"];
            [self initDataWithDict:param urlString:CollectSup];
            [self initDataWithDict:param urlString:TrendSup];
            break;
        case 3:
            break;
        default:
            break;
    }
}
#pragma mark tableView  代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return _sectionArray.count;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                return 1;
                break;
//            case 1:
//                return 3;
//                break;
//            case 2:
//                return 2;
//                break;
//            case 3:
//                return 1;
//                break;
//            case 4:
//                return 1;
//                break;
            default:
                return 0;
                break;
        }
    }else{
        return _dropDataArray.count ==0?0:_dropDataArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableView == tableView) {
        switch (indexPath.section) {
            case 0:
            {
                DecorateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDec forIndexPath:indexPath];
                if (!cell) {
                    cell = [[DecorateTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifierChart];
                }
                cell.indexPath = indexPath;
                if (_dataArray.count > 0) {
                    cell.dataArray = _dataArray ;
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
//            case 10:
//            {
//                FirstTrendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstTrendCellID" forIndexPath:indexPath];
//                if (!cell) {
//                    cell = [[FirstTrendCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FirstTrendCellID"];
//                }
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                return cell;
//            }
//                break;
            case 1:
            {
                MyChartCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMy forIndexPath:indexPath];
                if (!cell) {
                    cell = [[MyChartCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifierMy];
                }
                if (_trendModel) {
                    cell.model = _trendModel;
                }
                [cell configUI:indexPath];
                [cell.segmentedControl setSelectedSegmentIndex:0];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
//
//            case 2:
//            {
//                SCBarCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierBar forIndexPath:indexPath];
//                if (!cell) {
//                    cell = [[SCBarCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifierBar];
//                }
//                [cell configUI:indexPath];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                return cell;
//            }
//                break;
//                
//            case 3:
//            {
//                SCChartCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCircle forIndexPath:indexPath];
//                if (!cell) {
//                    cell = [[SCChartCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifierCircle];
//                }
//                [cell configUI:indexPath];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                return cell;
//            }
//                break;
//                
//            case 4:
//            {
//                SCPieCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierPie forIndexPath:indexPath];
//                if (!cell) {
//                    cell = [[SCPieCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifierPie];
//                }
//                [cell configUI:indexPath];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                return cell;
//            }
//                break;
//                
            default:
                break;
        }
        return nil;
    }else{
        UITableViewCell *cell;
        if (!cell) {
            cell = [dropV dequeueReusableCellWithIdentifier:@"cellID"];
            DepTs *model = [DepTs mj_objectWithKeyValues:_dropDataArray[indexPath.row]];
            NSString *text;
            if (model) {
                text = model.department_name == nil?model.operator_name:model.department_name;
            }else{
                text = _dropDataArray[indexPath.row];
            }
            cell.textLabel.text = text;
            //cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableView == tableView) {
        if (indexPath.section == 0) {
            return 255;
        }else{
            return 200;
        }
    }else{
        return 44;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_tableView == tableView) {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 30);
        LeftView *view = [[LeftView alloc] initWithFrame:frame];
        view.title.textAlignment = NSTextAlignmentLeft;
        view.title.text = _sectionArray[section];
//        switch (section) {
//            case 0:
//                view.title.text = @"概况";
//                break;
//            case 1:
//                view.title.text = @"折线图";
//                break;
//            case 2:
//                view.title.text = @"柱状图";
//                break;
//            case 3:
//                view.title.text = @"圆形图";
//                break;
//            case 4:
//                view.title.text = @"圆饼图";
//                break;
//            default:
//                break;
//        }
        return view;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_tableView == tableView) {
        return 30;
    }else{
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_tableView == tableView) {
        return 0.1;
    }else{
        return 0;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == dropV) {
        NSLog(@"%@",_dropDataArray[indexPath.row]);
        DepTs *model = [DepTs mj_objectWithKeyValues:_dropDataArray[indexPath.row]];
        NSString *text;
        if (model) {
            text = model.department_name == nil?model.operator_name:model.department_name;
        }else{
            text = _dropDataArray[indexPath.row];
        }
        [_currentBt setTitle:text forState:(UIControlStateNormal)];
        CGFloat w = [XYString WidthForString:text withSizeOfFont:14]+2;
        [_currentBt setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
        [_currentBt setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
        [UIView animateWithDuration:0.3 animations:^{
            dropV.Y = -1500;
            dropBackV.alpha=0;
            _currentBt.selected = NO;
        }];
        UIButton *button1 = [headView viewWithTag:1001];
        UIButton *button2 = [headView viewWithTag:1002];

        @try {
            switch (segmentedControl.selectedSegmentIndex) {
                case 1:
                {   if (_currentBt.tag == 1000) {
                    _yunyingStr = model.department_id;
                    [_param setObject:model.department_id forKey:@"department_id_op"];
                    [button1 setTitle:@"门店" forState:(UIControlStateNormal)];
                    [button2 setTitle:@"人员" forState:(UIControlStateNormal)];
                    CGFloat w = [XYString WidthForString:@"人员" withSizeOfFont:13]+2;
                    [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
                    [button1 setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
                    [button2 setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
                    [button2 setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
                    _mendianStr = @"";
                    _MemStr = @"";
                    [_param setObject:@"" forKey:@"department_id_st"];
                    [_param setObject:@"" forKey:@"operator_id_st"];
                }
                    if (_currentBt.tag == 1001) {
                        _mendianStr = model.department_id;
                        [_param setObject:model.department_id forKey:@"department_id_st"];
                        [button2 setTitle:@"人员" forState:(UIControlStateNormal)];
                        CGFloat w = [XYString WidthForString:@"人员" withSizeOfFont:13]+2;
                        [button2 setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
                        [button2 setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
                        _MemStr = @"";
                        [_param setObject:@"" forKey:@"operator_id_st"];
                    }
                    if (_currentBt.tag == 1002) {
                        _MemStr = model.operator_id;
                        [_param setObject:model.operator_id forKey:@"operator_id_st"];
                    }
                    if (_currentBt.tag == 1003) {
                        _timeStr = [text  isEqual: @"昨天"]?@"yesterday":([text  isEqual: @"近七天"]?@"day7":@"day15");
                        [_param setObject:_timeStr forKey:@"time_scope"];
                    }
                    [_param setObject:@"front" forKey:@"data_scope"];
                }
                    break;
                case 2:
                {
                    if (_currentBt.tag == 1000) {
                        _backStr = model.department_id;
                        [_param setObject:model.department_id forKey:@"department_id_bk"];
                        [button1 setTitle:@"人员" forState:(UIControlStateNormal)];
                        CGFloat w = [XYString WidthForString:@"人员" withSizeOfFont:13]+2;
                        [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 12)];
                        [button1 setImageEdgeInsets:UIEdgeInsetsMake(0, w, 0, -w)];
                        _MemStr = @"";
                        [_param setObject:@"" forKey:@"operator_id_bk"];
                    }
                    if (_currentBt.tag == 1001) {
                        _MemStr = model.operator_id;
                        [_param setObject:model.operator_id forKey:@"operator_id_bk"];
                    }
                    if (_currentBt.tag == 1002) {
                        _timeStr = [text  isEqual: @"昨天"]?@"yesterday":([text  isEqual: @"近七天"]?@"day7":@"day15");
                        [_param setObject:_timeStr forKey:@"time_scope"];
                    }
                    [_param setObject:@"back" forKey:@"data_scope"];
                    
                }
                    break;
                    
                default:
                    break;
            }

        } @catch (NSException *exception) {
            [LCProgressHUD showFailure:[exception description]];
        } @finally {
            
        }
        if (![_param objectForKey:@"data_scope"]) {
            [_param setObject:@"front" forKey:@"data_scope"];
        }
        if (![_param objectForKey:@"time_scope"]) {
            [_param setObject:@"yesterday" forKey:@"time_scope"];
        }
        [self initDataWithDict:_param urlString:CollectSup];
        [self initDataWithDict:_param urlString:TrendSup];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
