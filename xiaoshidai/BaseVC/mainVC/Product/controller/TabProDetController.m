//
//  TabProDetController.m
//  xiaoshidai
//
//  Created by XSD on 2017/2/9.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "TabProDetController.h"
#import "XOrederController.h"
#import "XOrderAddController.h"
#import "IntroduceCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface TabProDetController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray * dataArray;
@property (nonatomic) NSMutableArray * titleAttay;

@end

@implementation TabProDetController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataArray];
    [self titleAttay];
    [self tableView];
    [self initBottomButton];
    
}

-(NSMutableArray *)titleAttay{
    if (!_titleAttay) {
        _titleAttay = [NSMutableArray arrayWithObjects:@"产品详情",@"进件标准",@"进件材料",@"使用城市", nil];
    }
    return _titleAttay;
}
-(void)initBottomButton{
    UIButton *button  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"立即申请" forState:(UIControlStateNormal)];
    [button setBackgroundColor:mainHuang];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [button setFrame:CGRectMake(10, kScreen_Height - 64 - 49 -20, kScreen_Width-20, 49)];
    [button.layer setCornerRadius:7.0];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}
-(void)buttonClick:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    //XOrederController * controller = [[XOrederController alloc] init];
    //controller.title = @"小时贷产品申请";
    XOrderAddController* controller = [[XOrderAddController alloc] init];
    controller.title = self.title;
    [self.navigationController pushViewController:controller animated:YES];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        if (self.flag == 0) {
            _dataArray = [NSMutableArray arrayWithObjects:
                          @"1、一抵单笔授信100万，商铺最高可达300万（借款人可以是第三方自然人）\n2、先息后本，2%履约保证金（有收据，结清可退）\n3、12个月，可以续贷\n4、先息后本：月1.2%；3%放款手续费\n5、资料齐全3天内，一般情况3-5个工作日放款\n6、一抵=房屋认定价值×抵押率（60-80%）；\n二抵=（房屋认定价值－第一顺位抵押贷款余额）×抵押率（60-80%）",
                          @"1、年龄：20-60岁；工薪族现单位半年以上;自雇人士营业执照1年以上\n2、抵押物：大成都范围的房产：A、房产的性质可以是住宅、商铺；B、不接受县级以下房屋（县政府驻地建制镇除外）；C、不接受宅基地、5年内经济适用房等产权非个人性质房；D、借款年限加房屋年限在30年内 ",
                          @"1、借款人身份证；\n2、借款人婚姻证明（已婚共有才提供）；\n3、借款人房产证；\n4、房屋信息摘要；\n5、借款人1年的收入流水；\n6、借款人本人的银行卡。\n备注：A.如已婚需提供配偶身份证复印件；B.银行卡预留电话必须与申请贷款号码一致,且申请贷款的手机号码必须是本人的名字；C.调查费用标准：适当收取（300元以内）",
                          @"大成都范围", nil];
        }else if (self.flag == 1){
            _dataArray = [NSMutableArray arrayWithObjects:
                          @"1、二抵单笔授信20万，最高可贷100万\n2、先息后本，2%履约保证金（有收据，结清可退）\n3、12个月，可以续贷\n4、先息后本：月1.2%；3%放款手续费\n5、资料齐全3天内，一般情况3-5个工作日放款\n6、一抵=房屋认定价值×抵押率（60-80%）；\n二抵=（房屋认定价值－第一顺位抵押贷款余额）×抵押率（60-80%）",
                          @"1、年龄：20-60岁；工薪族现单位半年以上;自雇人士营业执照1年以上\n2、抵押物：大成都范围的房产：A、房产的性质可以是住宅、商铺；B、不接受县级以下房屋（县政府驻地建制镇除外）；C、不接受宅基地、5年内经济适用房等产权非个人性质房；D、借款年限加房屋年限在30年内 ",
                          @"1、借款人身份证；\n2、借款人婚姻证明（已婚共有才提供）；\n3、借款人房产证；\n4、房屋信息摘要；\n5、借款人1年的收入流水；\n6、借款人本人的银行卡。\n备注：A.如已婚需提供配偶身份证复印件；B.银行卡预留电话必须与申请贷款号码一致,且申请贷款的手机号码必须是本人的名字；C.调查费用标准：适当收取（300元以内）",
                          @"大成都范围", nil];
        }else if (self.flag == 2){
            _dataArray = [NSMutableArray arrayWithObjects:
                          @"1、先息后本，2%履约保证金（有收据，结清可退）\n2、12个月，可以续贷\n3、先息后本：月1.4%；3%放款手续费\n4、资料齐全3天内，一般情况3-5个工作日放款\n5、一抵=房屋认定价值×抵押率（60-80%）；\n二抵=（房屋认定价值－第一顺位抵押贷款余额）×抵押率（60-80%）",
                          @"1、年龄22-60岁具有完全民事行为能力的中国大陆居民\n2、个人征信上有房屋贷款体现，且贷款剩余期限不能低于1年。\n3、房产必须为商品房，且在征信上体现为银行抵押\n4、房屋市场价必须大于3000元/平米\n5、区域限制：大成都（锦江、成华、武侯、青羊、高新、金牛、天府新区成都直管区域、双流、龙泉、温江、郫县、新都）\n6、如果借款人只有一套房产在本地，户籍，工作单位均在外地，则需要提供本地户籍的共同借款人，共同借款人必须有稳定的收入来源。",
                          @"1、身份证、户口薄、结婚证（如有），离婚证（如有）\n2、购房合同、按揭合同/公证书、房屋调档信息/房产证复印件\n3、按揭还款流水（需要提供）、个人银行流水（如果有尽量提供）\n4、工作证明（公积金显示单位名称可以不提供，直接公积金切图就可以了）\n5、详版征信\n6、已交房客户，小区大门、单元门及室内照片至少各一张",
                          nil];
        }
    }
    return _dataArray;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-79) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"IntroduceCell" bundle:nil] forCellReuseIdentifier:@"IntroduceCellID"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_dataArray.count) {
        return _dataArray.count;
    }else{
        return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntroduceCellID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"IntroduceCell" owner:nil options:nil] lastObject];;
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (void)configureCell:(IntroduceCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    cell.contentLabel.text = _dataArray[indexPath.section];
    cell.titleLabel.text = _titleAttay[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"IntroduceCellID" configuration:^(IntroduceCell * cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    return  height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
