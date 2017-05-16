//
//  orderDetailVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/9/23.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "orderDetailVC.h"
#import "ordDetailModel.h"
#import "ordRelyCell.h"
#import "SubmittedVC.h"
#import "relyVC.h"
#import "HMDatePickView.h"
#import "LTPickerView.h"
#import "channelVC.h"
#import "endOrderVC.h"
#import "forwardingVC.h"
#import "imgLayoutvView.h"
#import "permissionsModel.h"
#import "MJRefresh.h"
#import "OrderDetailModel.h"
#import "AddOrderController.h"
#import "BaseInfoController.h"
#import "AssetController.h"
#import "CreditInfoController.h"
#import "TZPopInputView.h"
#import "PayListViewController.h"

#import "TagsCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "TZTestCell.h"
//#import <AssetsLibrary/AssetsLibrary.h>
//#import <Photos/Photos.h>
//#import "TZImagePickerController.h"
#import "SDPhotoBrowser.h"
@interface orderDetailVC () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate,SDPhotoBrowserDelegate>
{
    UIView *lineV;
    NSMutableArray *dataChannelArr;//渠道数组
    NSMutableArray *dataReplyArr;//进度数组
    NSMutableArray *planArr;
    
    UIView *footV;
    UIView *toolV;
    NSString *ordNum;
    //行高
    CGFloat cellHeight;
    //渠道状态用
    UIView *backV;
    NSString *channelStr;
    NSString *operatorIdStr;
    //订单操作权限
    permissionsModel *limModel;
    //判断刷新
    BOOL stauseStar;
    NSString *stauseStarStr;
    //判断订单是否属于自己
    BOOL myself;
    
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    CGFloat _itemWH;
    CGFloat _margin;
}
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *productidArr;
//基本资料（图片）
@property (nonatomic,strong) NSMutableArray *imgArr;
//
@property (nonatomic,strong) NSMutableDictionary  *orderDetailDict;
//
//@property (nonatomic, strong) TZPopInputView *inputView;
@property (strong, nonatomic)  UICollectionView *collectionView;

@end

@implementation orderDetailVC

-(void)backAction{
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [pushJudge setObject:nil forKey:@"push"];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
        [self setBack:@""];
    }
    self.title = @"订单详情";
    [self setTitleV];
    [self setTableView];
    [self setRequest:YES];
    
    limModel = [[permissionsModel alloc] init];
    for (NSString *str in [self getPermissionsArr]) {
        if ([str isEqualToString:@"order/solution/"]) {
            limModel.lim_Submitted = YES;
        }
        if ([str isEqualToString:@"order/accept/"]) {
            limModel.lim_receiveOrder = YES;
        }
        if ([str isEqualToString:@"order/channel/"]) {
            limModel.lim_channel = YES;
        }
        if ([str isEqualToString:@"order/newchannel/"]) {
            limModel.lim_addChannel = YES;
        }
        if ([str isEqualToString:@"order/terminate/"]) {
            limModel.lim_stopOrder = YES;
        }
        if ([str isEqualToString:@"order/transfer/"]) {
            limModel.lim_forwarding = YES;
        }
        if ([str isEqualToString:@"order/finish/"]) {
            limModel.lim_endOrder = YES;
        }
        if ([str isEqualToString:@"order/reply/"]) {
            limModel.lim_reply = YES;
        }
        if ([str isEqualToString:@"order/newrec/"]) {
            limModel.lim_addOrder = YES;
        }
        if ([str isEqualToString:@"order/modifyrec/"]) {
            limModel.lim_editorOrder = YES;
        }
        if ([str isEqualToString:@"order/dispatch/"]) {
            limModel.lim_assigned = YES;
        }
        if ([str isEqualToString:@"order/cancel/"]) {
            limModel.lim_undo = YES;
        }
    }
    
}/*
  之前是用懒加载的方式初始化inputView和datePicker，发现会有一定时间的延迟，约60ms，故将初始化方法在这里调用，这样则一点击按钮控件就能弹出来。
  */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   // if (!_inputView)  self.inputView = [[TZPopInputView alloc] init];
}

/** 一定要记得在这里移除，因为是加在window上的，否则会造成内存泄露  */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
  //  if (_inputView)  [self.inputView removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (appdelegate.refresh==2) {
        [self setRequest:YES];
        appdelegate.refresh = 0;
    }
}
- (NSMutableArray *)titleArr {
    if (_titleArr==nil) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}
- (NSMutableArray *)productidArr {
    if (_productidArr==nil) {
        _productidArr = [NSMutableArray array];
    }
    return _productidArr;
}
- (NSMutableArray *)imgArr {
    if (_imgArr==nil) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}
#pragma mark -- 标题选项
- (void)setTitleV {
    
    myself = YES;
    dataChannelArr = [NSMutableArray array];
    dataReplyArr = [NSMutableArray array];
    planArr = [NSMutableArray array];
    
    _mainSV.contentSize = CGSizeMake(ScreenWidth*2, ScreenHeight-149);
    _mainSV.delegate = self;
    _mainOneTV.frame = CGRectMake(0, 0, ScreenWidth, _mainSV.height);
    _mainTV.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, _mainSV.height);
    
    for (int i=0; i<2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*ScreenWidth/2, 0, ScreenWidth/2, 35)];
        button.tag = 1000+i;
        [button setTitle:@[@"订单明细",@"订单进度"][i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:colorValue(0x111111, 1) forState:UIControlStateNormal];
        [button setTitleColor:mainHuang forState:UIControlStateSelected];
        [button addTarget:self action:@selector(planAfterAction:) forControlEvents:UIControlEventTouchUpInside];
        [_titleV addSubview:button];
        if (i==0) {
            button.selected = YES;
        }
    }
    [self PixeH:CGPointMake(0, 34) lenght:ScreenWidth add:_titleV];
    lineV = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth/2-120)/2, 33, 120, 2)];
    lineV.backgroundColor = mainHuang;
    [_titleV addSubview:lineV];
    //下拉刷新
    __weak __typeof(&*self)weakSelf = self;
    
    _mainOneTV.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf setRequest:NO];
    }];
    
}
- (void)planAfterAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    for (int i=0; i<2; i++) {
        UIButton *button = (UIButton *)[_titleV viewWithTag:1000+i];
        button.selected = NO;
    }
    sender.selected = YES;
    if (sender.tag==1000) {
        [UIView animateWithDuration:0.2 animations:^{
            lineV.x = (ScreenWidth/2-120)/2;
        }];
        [_mainSV setContentOffset:CGPointMake(ScreenWidth*(sender.tag-1000), 0) animated:NO];
    }else {
        [UIView animateWithDuration:0.2 animations:^{
            lineV.x = (ScreenWidth/2-120)/2+ScreenWidth/2;
        }];
        [_mainSV setContentOffset:CGPointMake(ScreenWidth*(sender.tag-1000), 0) animated:NO];
    }
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)setTableView {
    
    _mainTV.delegate = self;
    _mainTV.dataSource = self;
    _mainTV.backgroundColor = [UIColor clearColor];
    _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _mainOneTV.delegate = self;
    _mainOneTV.dataSource = self;
    _mainOneTV.backgroundColor = [UIColor clearColor];
    if ([_mainOneTV respondsToSelector:@selector(setSeparatorInset:)]) {
        [_mainOneTV setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_mainOneTV respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mainOneTV setLayoutMargins:UIEdgeInsetsZero];
    }
    //_mainOneTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mainOneTV registerClass:[TagsCell class] forCellReuseIdentifier:@"TagsCell"];
    [self PixeHead:CGPointMake(0, 10) lenght:ScreenWidth add:_headV];
    [self PixeH:CGPointMake(0, 49) lenght:ScreenWidth add:_headV];
    footV = [[UIView alloc] init];
    footV.backgroundColor = BackGroundColor;
    //
    toolV = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-114, ScreenWidth, 50)];
    toolV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:toolV];
    
    backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    backV.backgroundColor = color(0, 0, 0, 0.6);
    backV.alpha = 0;
    [self.view addSubview:backV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenBackAction)];
    [backV addGestureRecognizer:tap];
    _whyView.frame = CGRectMake(0, ScreenHeight+1000, ScreenWidth, 230);
    _lendingView.frame = CGRectMake(0, ScreenHeight+1000, ScreenWidth, 230);
    _serviceView.frame = CGRectMake(0, ScreenHeight+1000, ScreenWidth, 260);
    
    UITextView *textMoney = (UITextView *)[_lendingView viewWithTag:111];
    UITextView *interestV = (UITextView *)[_lendingView viewWithTag:112];
    textMoney.keyboardType = UIKeyboardTypeDecimalPad;
    interestV.keyboardType = UIKeyboardTypeDecimalPad;
    
    UITextField *textTF1 = (UITextField *)[_serviceView viewWithTag:111];
    UITextField *textTF3 = (UITextField *)[_serviceView viewWithTag:113];
    UITextField *textTF4 = (UITextField *)[_serviceView viewWithTag:114];
    textTF1.keyboardType = UIKeyboardTypeDecimalPad;
    textTF3.keyboardType = UIKeyboardTypeDecimalPad;
    textTF4.keyboardType = UIKeyboardTypeDecimalPad;

    [self PixeH:CGPointMake(0, 43) lenght:ScreenWidth add:_lendingView];
    [self PixeH:CGPointMake(0, 87) lenght:ScreenWidth add:_lendingView];
    [self PixeH:CGPointMake(0, 131) lenght:ScreenWidth add:_lendingView];
    [self PixeH:CGPointMake(0, 43) lenght:ScreenWidth add:_serviceView];
    [self PixeH:CGPointMake(0, 87) lenght:ScreenWidth add:_serviceView];
    [self PixeH:CGPointMake(0, 131) lenght:ScreenWidth add:_serviceView];
    //[self PixeH:CGPointMake(0, 175) lenght:ScreenWidth add:_serviceView];
    
    [self setYuan:_submitBT1 size:6];
    [self setYuan:_submitBT2 size:6];
    [self setYuan:_submitBT3 size:6];
    [self.view addSubview:_whyView];
    [self.view addSubview:_lendingView];
    [self.view addSubview:_serviceView];
    UITextView *textV = (UITextView *)[_whyView viewWithTag:112];
    [self setYuan:textV size:3];
}
- (void)hidenBackAction {
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.view endEditing:YES];
        _whyView.y = ScreenHeight-64;
        _lendingView.y = ScreenHeight-64;
        _serviceView.y = ScreenHeight-64;
        backV.alpha = 0;
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==_mainOneTV) {
       // NSLog(@"行数1＝%ld",dataChannelArr.count);
        return dataChannelArr.count;
    }else {
       // NSLog(@"行数2＝%ld",dataReplyArr.count);
        return dataReplyArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_mainOneTV) {
        ordDetailModel *model = dataChannelArr[indexPath.row];
        if (model.channel_status.intValue == 6) {
            CGFloat height = [tableView fd_heightForCellWithIdentifier:@"TagsCell" configuration:^(id cell) {
            }];
            return height;
        }
        return 101;
    }else {
        ordRelyCell *cell = (ordRelyCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell setHeaght];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==_mainOneTV) {
        ordDetailModel *model = dataChannelArr[indexPath.row];
        if (model.channel_status.intValue==7) {
            static NSString *ID = @"cell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"orderDeCell1" owner:nil options:nil][0];
            }
           // [self PixeH:CGPointMake(0, 85) lenght:ScreenWidth add:cell.contentView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSDictionary *dics = model.channel_extinfo;
            ordDetailModel *model2 = [ordDetailModel mj_objectWithKeyValues:dics];
            UILabel *companyLB = (UILabel *)[cell.contentView viewWithTag:110];
            companyLB.text = model.channel_name;
            //
            UILabel *tag1LB = (UILabel *)[cell.contentView viewWithTag:112];
            UILabel *tag2LB = (UILabel *)[cell.contentView viewWithTag:113];
            UILabel *tag3LB = (UILabel *)[cell.contentView viewWithTag:114];
            UILabel *tag4LB = (UILabel *)[cell.contentView viewWithTag:115];
            UILabel *tag5LB = (UILabel *)[cell.contentView viewWithTag:116];
            NSString *str1 = [NSString stringWithFormat:@"放款额:%@万",[XYString changeFloatWithString:model2.loan_amount]];
            NSString *str2 = [NSString stringWithFormat:@"放款利率:%@％",[XYString changeFloatWithString:model2.loan_rate]];
            NSString *str3 = [NSString stringWithFormat:@"服务费:%@元",[XYString changeFloatWithString:model2.service_fee]];
            tag1LB.text = str1;
            tag2LB.text = str2;
            tag3LB.text = str3;
            CGFloat W1 = [XYString WidthForString:str1 withSizeOfFont:12];
            CGFloat W2 = [XYString WidthForString:str2 withSizeOfFont:12];
            CGFloat W3 = [XYString WidthForString:str3 withSizeOfFont:12];
            [self setYuan:tag1LB size:9];
            [self setYuan:tag2LB size:9];
            [self setYuan:tag3LB size:9];
            [self setBorder:tag1LB size:1 withColor:colorValue(0xdddddd, 1)];
            [self setBorder:tag2LB size:1 withColor:colorValue(0xdddddd, 1)];
            [self setBorder:tag3LB size:1 withColor:colorValue(0xdddddd, 1)];
            tag1LB.width = W1+8;
            tag2LB.width = W2+8;
            tag3LB.width = W3+8;
            tag2LB.x = CGRectGetMaxX(tag1LB.frame)+10;
            tag3LB.x = CGRectGetMaxX(tag2LB.frame)+10;
            if (model2.return_fee.doubleValue>0) {
                tag4LB.hidden = NO;
                NSString *str4 = [NSString stringWithFormat:@"返点费:%@元",[XYString changeFloatWithString:model2.return_fee]];
                tag4LB.text = str4;
                CGFloat W4 = [XYString WidthForString:str4 withSizeOfFont:12];
                [self setYuan:tag4LB size:9];
                [self setBorder:tag4LB size:1 withColor:colorValue(0xdddddd, 1)];
                tag4LB.width = W4+8;
                tag4LB.x = CGRectGetMaxX(tag3LB.frame)+10;
                if (CGRectGetMaxX(tag4LB.frame)>ScreenWidth-12) {
                    tag1LB.y = 41; tag2LB.y = 41; tag3LB.y = 41;
                    tag4LB.x = 12; tag4LB.y = 68;
                }
            }
            if (model2.pack_fee.doubleValue>0) {
                tag5LB.hidden = NO;
                NSString *str5 = [NSString stringWithFormat:@"其他费用:%@元",[XYString changeFloatWithString:model2.pack_fee]];
                tag5LB.text = str5;
                CGFloat W5 = [XYString WidthForString:str5 withSizeOfFont:12];
                [self setYuan:tag5LB size:9];
                [self setBorder:tag5LB size:1 withColor:colorValue(0xdddddd, 1)];
                tag5LB.width = W5+8;
                if (tag4LB.hidden == YES) {
                    tag5LB.x = CGRectGetMaxX(tag3LB.frame)+10;
                    if (CGRectGetMaxX(tag4LB.frame)>ScreenWidth-12) {
                        tag1LB.y = 41; tag2LB.y = 41; tag3LB.y = 41;
                        tag5LB.x = 12; tag5LB.y = 68;
                    }
                }else {
                    tag5LB.x = CGRectGetMaxX(tag4LB.frame)+10;
                    if (tag4LB.y==51) {
                        if (CGRectGetMaxX(tag5LB.frame)>ScreenWidth-12) {
                            tag1LB.y = 41; tag2LB.y = 41; tag3LB.y = 41; tag4LB.y=41;
                            tag5LB.x = 12; tag5LB.y = 68;
                        }
                    }else {
                        tag5LB.y = 68;
                    }
                }
            }
            return cell;
        }else if(model.channel_status.intValue==6){
            static NSString *ID = @"TagsCell";
            TagsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[TagsCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
            }
            cell.companyLabel.text = model.channel_name;
            NSDictionary *dics = model.channel_extinfo;
            ordDetailModel *model2 = [ordDetailModel mj_objectWithKeyValues:dics];
            NSMutableArray *labelArray = [NSMutableArray array];
            NSString *str1 = [NSString stringWithFormat:@"放款额:%@万",[XYString changeFloatWithString:model2.loan_amount]];
            NSString *str2 = [NSString stringWithFormat:@"放款利率:%@％",[XYString changeFloatWithString:model2.loan_rate]];
            [labelArray addObject:str1];
            [labelArray addObject:str2];
            if (model2.service_fee.doubleValue>0) {
                NSString *str3;
                if ([model2.is_pay_service isEqualToString:@"1"]) {
                    str3 = [NSString stringWithFormat:@"待收服务费:%@元",[XYString changeFloatWithString:model2.service_fee]];
                }else if ([model2.is_pay_service isEqualToString:@"2"]){
                    str3 = [NSString stringWithFormat:@"已收服务费:%@元",[XYString changeFloatWithString:model2.service_fee]];
                }else{
                    str3 = [NSString stringWithFormat:@"服务费:%@元",[XYString changeFloatWithString:model2.service_fee]];
                }
                [labelArray addObject:str3];
            }
            if (model2.return_fee.doubleValue>0) {
                NSString *str4 ;
                if ([model2.is_pay_return isEqualToString:@"1"]) {
                    str4 = [NSString stringWithFormat:@"待收返点费:%@元",[XYString changeFloatWithString:model2.return_fee]];
                }else if ([model2.is_pay_return isEqualToString:@"2"]){
                    str4 = [NSString stringWithFormat:@"已收返点费:%@元",[XYString changeFloatWithString:model2.return_fee]];
                }else{
                    str4 = [NSString stringWithFormat:@"返点费:%@元",[XYString changeFloatWithString:model2.return_fee]];
                }
                [labelArray addObject:str4];
            }
            if (model2.pack_fee.doubleValue>0) {
                NSString *str5;
                if ([model2.is_pay_pack isEqualToString:@"1"]) {
                    str5 = [NSString stringWithFormat:@"待收其他费用:%@元",[XYString changeFloatWithString:model2.pack_fee]];
                }else if ([model2.is_pay_pack isEqualToString:@"2"]){
                    str5 = [NSString stringWithFormat:@"已收其他费用:%@元",[XYString changeFloatWithString:model2.pack_fee]];
                }else{
                    str5 = [NSString stringWithFormat:@"其他费用:%@元",[XYString changeFloatWithString:model2.pack_fee]];
                }
                [labelArray addObject:str5];
            }
            cell.payButton.tag = 300+indexPath.row;
            cell.editButton.tag = 300+indexPath.row;
            [cell.payButton addTarget:self action:@selector(stauseAction:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.editButton addTarget:self action:@selector(stauseAction:) forControlEvents:(UIControlEventTouchUpInside)];

            [cell fillCellWithArray:labelArray];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
//            cellHeight = 86;
            static NSString *ID = @"cell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (!cell) {
                cell = [[NSBundle mainBundle] loadNibNamed:@"orderDeCell1" owner:nil options:nil][1];
            }
            [self PixeH:CGPointMake(0, 85) lenght:ScreenWidth add:cell.contentView];
            
            UILabel *companyLB = (UILabel *)[cell viewWithTag:110];
            UILabel *stauseLB = (UILabel *)[cell viewWithTag:111];
            companyLB.text = model.channel_name;
            stauseLB.text = model.channel_status_txt;
            
            if ([self getroleClass]==2) {
                NSArray *buttonArr;
                if (model.channel_status.intValue==1) {
                    buttonArr=@[@"进件",@"终止"];
                }else if (model.channel_status.intValue==2) {
                    buttonArr=@[@"同意",@"驳回",@"终止"];
                }else if (model.channel_status.intValue==3) {
                    buttonArr = @[@"签合同",@"驳回",@"终止"];
                }else if (model.channel_status.intValue==5) {
                    buttonArr = @[@"放款",@"驳回",@"终止"];
                }else if (model.channel_status.intValue==6) {
                    if (myself) {
                        UIButton *stauseBT = (UIButton *)[cell viewWithTag:112];
                        stauseBT.hidden = NO;
                        stauseBT.tag = 300+indexPath.row;
                        [self setYuan:stauseBT size:12];
                        [stauseBT addTarget:self action:@selector(stauseAction:) forControlEvents:UIControlEventTouchUpInside];
                    }
                    NSDictionary *dics = model.channel_extinfo;
                    ordDetailModel *model2 = [ordDetailModel mj_objectWithKeyValues:dics];
                    UILabel *moneyLB = (UILabel *)[cell viewWithTag:113];
                    UILabel *interestLB = (UILabel *)[cell viewWithTag:114];
                    moneyLB.hidden = NO;
                    interestLB.hidden = NO;
                    NSString *str1 = [NSString stringWithFormat:@"放款额:%@万",[XYString changeFloatWithString:model2.loan_amount]];
                    NSString *str2 = [NSString stringWithFormat:@"放款利率:%@％",[XYString changeFloatWithString:model2.loan_rate]];
                    NSLog(@"====%@",str1);
                    CGFloat W1 = [XYString WidthForString:str1 withSizeOfFont:12];
                    CGFloat W2 = [XYString WidthForString:str2 withSizeOfFont:12];
                    moneyLB.text = str1;
                    interestLB.text = str2;
                    [self setYuan:moneyLB size:9];
                    [self setYuan:interestLB size:9];
                    [self setBorder:moneyLB size:1 withColor:colorValue(0xdddddd, 1)];
                    [self setBorder:interestLB size:1 withColor:colorValue(0xdddddd, 1)];
                    moneyLB.width = W1+8;
                    interestLB.width = W2+8;
                    interestLB.x = CGRectGetMaxX(moneyLB.frame)+10;
                }
                if (myself == YES) {
                    for (int i=0; i<buttonArr.count; i++) {
                        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-buttonArr.count*60-5)+i*60, 50, 50, 20)];
                        button.backgroundColor = mainHuang;
                        button.tag = 300+indexPath.row;
                        
                        [button setTitle:buttonArr[i] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        button.titleLabel.font = [UIFont systemFontOfSize:13];
                        [button addTarget:self action:@selector(stauseAction:) forControlEvents:UIControlEventTouchUpInside];
                        [self setYuan:button size:5];
                        [cell.contentView addSubview:button];
                    }
                }

            }else if ([self getroleClass]==1) {
                NSDictionary *dics = model.channel_extinfo;
                ordDetailModel *model2 = [ordDetailModel mj_objectWithKeyValues:dics];
                UILabel *moneyLB = (UILabel *)[cell viewWithTag:113];
                UILabel *interestLB = (UILabel *)[cell viewWithTag:114];
                moneyLB.hidden = NO;
                interestLB.hidden = NO;
                NSString *str1 = [NSString stringWithFormat:@"放款额:%@万",[XYString changeFloatWithString:model2.loan_amount]];
                NSString *str2 = [NSString stringWithFormat:@"放款利率:%@％",[XYString changeFloatWithString:model2.loan_rate]];
                NSLog(@"====%@",str1);
                CGFloat W1 = [XYString WidthForString:str1 withSizeOfFont:12];
                CGFloat W2 = [XYString WidthForString:str2 withSizeOfFont:12];
                moneyLB.text = str1;
                interestLB.text = str2;
                [self setYuan:moneyLB size:9];
                [self setYuan:interestLB size:9];
                [self setBorder:moneyLB size:1 withColor:colorValue(0xdddddd, 1)];
                [self setBorder:interestLB size:1 withColor:colorValue(0xdddddd, 1)];
                moneyLB.width = W1+8;
                interestLB.width = W2+8;
                interestLB.x = CGRectGetMaxX(moneyLB.frame)+10;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else {
        
        ordRelyCell *cell = [[ordRelyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

        ordDetailModel *model = dataReplyArr[indexPath.row];
        cell.count = dataReplyArr.count;
        if ([model.reply_type_small isEqualToString:@"3"]) {
            [planArr removeAllObjects];
            NSArray *arr = model.reply_solution;
            for (NSDictionary *dics in arr) {
                ordDetailModel *model1 = [[ordDetailModel alloc] init];
                [model1 setValuesForKeysWithDictionary:dics];
                [planArr addObject:model1];
            }
            cell.modelArr = planArr;
        }
        cell.indx = indexPath.row;
        cell.model = model;
        cell.userInteractionEnabled = NO;
        return cell;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    UIButton *button1 = (UIButton *)[_titleV viewWithTag:1000];
    UIButton *button2 = (UIButton *)[_titleV viewWithTag:1001];
    if (scrollView==_mainSV) {
        if (scrollView.contentOffset.x==0) {
            button1.selected = YES;
            button2.selected = NO;
            [UIView animateWithDuration:0.2 animations:^{
                lineV.x = (ScreenWidth/2-120)/2;
            }];
        }else {
            button1.selected = NO;
            button2.selected = YES;
            [UIView animateWithDuration:0.2 animations:^{
                lineV.x = (ScreenWidth/2-120)/2+ScreenWidth/2;
            }];
        }
    }
}
#pragma mark -- 网络接口
- (void)setRequest:(BOOL)show {
  
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[self setRSAencryptString:_order_nid] forKey:@"order_nid"];
    NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",_order_nid]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    if (show==YES) {
        [LCProgressHUD showLoading:nil];
    }
    [self post:@"/order/detail/" parameters:param success:^(id dic) {
        [_mainOneTV.mj_header endRefreshing];
        if ([dic[@"code"] intValue]==0) {
            self.orderDetailDict = dic;

            [LCProgressHUD hide];
            //渠道数组
            NSArray *channelArr = dic[@"data"][@"channel_info"];
            //订单信息
            NSDictionary *ordDic = dic[@"data"][@"order_info"];
            //进度信息
            NSArray *replyArr = dic[@"data"][@"reply_info"];
            //资产资料
            NSDictionary *assetsDic = dic[@"data"][@"user_assets_info"];
            //基本资料
            NSDictionary *baseDic = dic[@"data"][@"user_base_info"];
            //征信资料
            NSDictionary *creditDic = dic[@"data"][@"user_credit_info"];
            [dataReplyArr removeAllObjects];
            [dataChannelArr removeAllObjects];

            [footV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [toolV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            if (replyArr.count) {
                for (NSDictionary *dics in replyArr) {
                    ordDetailModel *model = [ordDetailModel mj_objectWithKeyValues:dics];
                    [dataReplyArr addObject:model];
                }
                [_mainTV reloadData];
            }
            //赋值
            ordDetailModel *model = [[ordDetailModel alloc] init];
            [model mj_setKeyValues:ordDic];
            [model mj_setKeyValues:assetsDic];
            [model mj_setKeyValues:baseDic];
            [model mj_setKeyValues:creditDic];
            
            [self setBase_info:model];
            [self setAssets_info:model];
            [self setCredit_info:model];
            [self setOrder_info:model];
            [self setToolView:model];
        
            if (channelArr.count) {
                for (NSDictionary *dics in channelArr) {
                    ordDetailModel *model = [ordDetailModel mj_objectWithKeyValues:dics];
                    [dataChannelArr addObject:model];
                }
                _mainOneTV.tableHeaderView = _headV;
                [_mainOneTV reloadData];
            }
            
        }else {
            NSString *msg = dic[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {
       [_mainOneTV.mj_header endRefreshing];
    }];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _margin = 10;
        _itemWH = (kScreen_Width-100 - 3 * _margin ) / 3 ;
        layout.itemSize = CGSizeMake(_itemWH, _itemWH);
        layout.minimumInteritemSpacing = _margin;
        layout.minimumLineSpacing = _margin;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 184) collectionViewLayout:layout];
        CGFloat rgb = 244 / 255.0;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor DisplayP3Red:rgb green:rgb blue:rgb alpha:1.0];
        _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _collectionView;
    
}
#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%zd", _selectedPhotos.count + 1);
    //collectionView.height = (4+ _itemWH)*((_selectedPhotos.count + 1)/5+1);
    return self.imgArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imgArr[indexPath.row]] placeholderImage:IMGNAME(@"Placeholder")options:(SDWebImageRefreshCached)];
   // cell.imageView.image = _selectedPhotos[indexPath.row];
    cell.asset = self.imgArr[indexPath.row];
    cell.deleteBtn.hidden = YES;
    cell.gifLable.hidden = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = self.imgArr.count;
    photoBrowser.sourceImagesContainerView = _collectionView;
    [photoBrowser show];
}
#pragma mark  SDPhotoBrowserDelegate

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    TZTestCell *cell = (TZTestCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    return cell.imageView.image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = self.imgArr[index];
    return [NSURL URLWithString:urlStr];
}
#pragma mark -- 布局基本资料
- (void)setBase_info:(ordDetailModel *)model {
    
    NSMutableArray *titleArr = [[NSMutableArray alloc] initWithObjects:@"真实姓名",@"身份证号",@"客户电话",@"本地户口",@"婚姻状况",@"接单部门",@"客户来源", nil];
    if ([model.is_local isEqualToString:@"1"]) {
        model.is_local = @"是";
    }else if ([model.is_local isEqualToString:@"2"]) {
        model.is_local = @"否";
    }else {
        model.is_local = @"";
    }
    if ([model.marriage isEqualToString:@"1"]) {
        model.marriage = @"已婚";
    }else if ([model.marriage isEqualToString:@"2"]) {
        model.marriage = @"未婚";
    }else if ([model.marriage isEqualToString:@"3"]) {
        model.marriage = @"离异";
    }else if ([model.marriage isEqualToString:@"4"]) {
        model.marriage = @"丧偶";
    }else {
        model.marriage = @"";
    }
    if ([model.client_source isEqualToString:@"1"]) {
        model.client_source = @"上门咨询";
    }else if ([model.client_source isEqualToString:@"2"]) {
        model.client_source = @"电销";
    }else if ([model.client_source isEqualToString:@"3"]) {
        model.client_source = @"客户转介绍";
    }else if ([model.client_source isEqualToString:@"4"]) {
        model.client_source = @"同行转介绍";
    }else if ([model.client_source isEqualToString:@"5"]) {
        model.client_source = @"网销";
    }else if ([model.client_source isEqualToString:@"6"]) {
        model.client_source = @"外出展业";
    }else {
        model.client_source = @"其他";
    }
    NSMutableArray *valueArr = [[NSMutableArray alloc] initWithObjects:avoidNullStr(model.realname),avoidNullStr(model.id_number),avoidNullStr(model.phone),avoidNullStr(model.is_local),avoidNullStr(model.marriage),avoidNullStr(model.department_name_to),avoidNullStr(model.client_source), nil];
    if (![XYString isBlankString:model.apply_amount]) {
        [titleArr addObject:@"资金需求"];
        [valueArr addObject:[NSString stringWithFormat:@"%@万",model.apply_amount]];
    }
    if (![XYString isBlankString:model.apply_rate]) {
        [titleArr addObject:@"利率要求"];
        [valueArr addObject:model.apply_rate];
    }
    [titleArr addObject:@"建议类型"];
    if (model.loan_type.intValue==1) {
        [valueArr addObject:@"信用"];
    }else if (model.loan_type.intValue==2) {
        [valueArr addObject:@"车抵"];
    }else if (model.loan_type.intValue==3) {
        [valueArr addObject:@"房抵"];
    }else {
        [valueArr addObject:@"无"];
    }
    
    [_footuser.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:_footuser];
    [self PixeH:CGPointMake(0, 39) lenght:ScreenWidth add:_footuser];
    
    UIImageView *logImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 20, 20)];
    logImg.image = [UIImage imageNamed:@"nav_icon_accou"];
    [_footuser addSubview:logImg];
    
    UILabel *valueLB = [MyControl customLabelWithFrame:CGRectMake(42, 10, 80, 20) text:@"基本资料" textColor:colorValue(0x111111, 1) textFont:14];
    [_footuser addSubview:valueLB];
    
    for (int i=0; i<titleArr.count; i++) {
        
        UILabel *titleLB = [MyControl creatLabelWithFrame:CGRectMake(20, 50+i*30, 62, 20) text:titleArr[i]];
        titleLB.tag = 2000+i;
        [_footuser addSubview:titleLB];
        
        UILabel *valueLB = [MyControl customLabelWithFrame:CGRectMake(100, 50+i*30, ScreenWidth-115, 20) text:valueArr[i] textColor:colorValue(0x111111, 1) textFont:15];
        valueLB.tag = 2100+i;
        [_footuser addSubview:valueLB];
    }
    UILabel *endLB = (UILabel *)[_footuser viewWithTag:1999+titleArr.count];
    //处理图片
    [self.imgArr removeAllObjects];
    if ([model.other_pic_show count] >0) {
        for (NSDictionary *dics in model.other_pic_show) {
            [self.imgArr addObject:dics[@"path"]];
        }
    }
    if (self.imgArr.count) {
        UILabel *imgTitle = [MyControl creatLabelWithFrame:CGRectMake(20, CGRectGetMaxY(endLB.frame)+10, 62, 20) text:@"图片资料"];
        [_footuser addSubview:imgTitle];
        
       // imgLayoutvView *imgV = [[imgLayoutvView alloc] init];
        //imgV.x = 100; imgV.y = CGRectGetMaxY(endLB.frame)+10;
        //imgV.picPathStringsArray = self.imgArr;
       // [_footuser addSubview:imgV];
        
        [self collectionView];
        [_footuser addSubview:_collectionView];
        [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
        if (self.imgArr.count >3 && self.imgArr.count <=6) {
            [_collectionView setFrame:CGRectMake(100, CGRectGetMaxY(endLB.frame)+10, kScreen_Width-100, _itemWH*2+18)];
        }else if(self.imgArr.count >6){
            [_collectionView setFrame:CGRectMake(100, CGRectGetMaxY(endLB.frame)+10, kScreen_Width-100, _itemWH*3+28)];
        }else{
            [_collectionView setFrame:CGRectMake(100, CGRectGetMaxY(endLB.frame)+10, kScreen_Width-100, _itemWH+8)];
        }
        //判断是否有备注
        if ([XYString isBlankString:model.notes]) {
            _footuser.frame = CGRectMake(0, 10, ScreenWidth, CGRectGetMaxY(_collectionView.frame)+10);
            [footV addSubview:_footuser];
        }else {
            UILabel *notesTitle = [MyControl creatLabelWithFrame:CGRectMake(20, CGRectGetMaxY(_collectionView.frame)+10, 62, 20) text:@"备注"];
            [_footuser addSubview:notesTitle];
            
            UILabel *valueLB = [MyControl customLabelWithFrame:CGRectMake(100, CGRectGetMaxY(_collectionView.frame)+10, ScreenWidth-115, 20) text:model.notes textColor:colorValue(0x111111, 1) textFont:15];
            [_footuser addSubview:valueLB];
            valueLB.numberOfLines = 0;
            [valueLB sizeToFit];
            
            _footuser.frame = CGRectMake(0, 10, ScreenWidth, CGRectGetMaxY(valueLB.frame)+10);
            [footV addSubview:_footuser];
        }
    }else {
        //判断是否有备注
        if ([XYString isBlankString:model.notes]) {
            _footuser.frame = CGRectMake(0, 10, ScreenWidth, CGRectGetMaxY(endLB.frame)+10);
            [footV addSubview:_footuser];
        }else {
            UILabel *notesTitle = [MyControl creatLabelWithFrame:CGRectMake(20, CGRectGetMaxY(endLB.frame)+10, 62, 20) text:@"备注"];
            [_footuser addSubview:notesTitle];
            
            UILabel *valueLB = [MyControl customLabelWithFrame:CGRectMake(100, CGRectGetMaxY(endLB.frame)+10, ScreenWidth-115, 20) text:model.notes textColor:colorValue(0x111111, 1) textFont:15];
            [_footuser addSubview:valueLB];
            valueLB.numberOfLines = 0;
            [valueLB sizeToFit];
            
            _footuser.frame = CGRectMake(0, 10, ScreenWidth, CGRectGetMaxY(valueLB.frame)+10);
            [footV addSubview:_footuser];
        }
    }
}
#pragma mark -- 布局资产信息
- (void)setAssets_info:(ordDetailModel *)model {
    
    if ([model.car_buyonce isEqualToString:@"1"]) {
        model.car_buyonce = @"是";
    }else if ([model.car_buyonce isEqualToString:@"2"]) {
        model.car_buyonce = @"否";
    }
    if ([model.house_togather isEqualToString:@"1"]) {
        model.house_togather = @"是";
    }else if ([model.house_togather isEqualToString:@"2"]) {
        model.house_togather = @"否";
    }
    if ([model.house_paperwork isEqualToString:@"1"]) {
        model.house_paperwork = @"双证齐全";
    }else if ([model.house_paperwork isEqualToString:@"2"]) {
        model.house_paperwork = @"有产权证无土地证";
    }else if ([model.house_paperwork isEqualToString:@"3"]) {
        model.house_paperwork = @"有土地证无产权证";
    }
    if ([model.house_kind isEqualToString:@"1"]) {
        model.house_kind = @"商品房";
    }else if ([model.house_kind isEqualToString:@"2"]) {
        model.house_kind = @"经适房";
    }else if ([model.house_kind isEqualToString:@"3"]) {
        model.house_kind = @"小产权房";
    }else if ([model.house_kind isEqualToString:@"4"]) {
        model.house_kind = @"其他";
    }
    if ([model.house_style isEqualToString:@"1"]) {
        model.house_style = @"公寓";
    }else if ([model.house_style isEqualToString:@"2"]) {
        model.house_style = @"商铺";
    }else if ([model.house_style isEqualToString:@"3"]) {
        model.house_style = @"别墅";
    }else if ([model.house_style isEqualToString:@"4"]) {
        model.house_style = @"写字楼";
    }else if ([model.house_style isEqualToString:@"5"]) {
        model.house_style = @"厂房";
    }else if ([model.house_style isEqualToString:@"6"]) {
        model.house_style = @"其他";
    }
    if ([model.house_mortgage isEqualToString:@"1"]) {
        model.house_mortgage = @"是";
    }else if ([model.house_mortgage isEqualToString:@"2"]) {
        model.house_mortgage = @"否";
    }
    model.house_price = [NSString stringWithFormat:@"%@万",model.house_price];
    model.car_nudeprice = [NSString stringWithFormat:@"%@万",model.car_nudeprice];
    NSArray *titleArr;
    NSArray *valueArr;
    if ([model.has_house isEqualToString:@"1"]&&[model.has_car isEqualToString:@"1"]) {
        titleArr = @[@"房产共有",@"房产证件",@"房产性质",@"房屋类型",@"房贷有否",@"购买价格",@"购买时间",@"房屋位置",@"车辆型号",@"裸车价格",@"是否全款",@"购买时间"];
        valueArr = @[avoidNullStr(model.house_togather),avoidNullStr(model.house_paperwork),avoidNullStr(model.house_kind),avoidNullStr(model.house_style),avoidNullStr(model.house_mortgage),avoidNullStr(model.house_price),avoidNullStr(model.house_buytime),avoidNullStr(model.house_district),avoidNullStr(model.car_brand),avoidNullStr(model.car_nudeprice),avoidNullStr(model.car_buyonce),avoidNullStr(model.car_buytime)];
    }else if ([model.has_house isEqualToString:@"1"]&&[model.has_car isEqualToString:@"2"]) {
        titleArr = @[@"房产共有",@"房产证件",@"房产性质",@"房屋类型",@"房贷有否",@"购买价格",@"购买时间",@"房屋位置"];
        valueArr = @[avoidNullStr(model.house_togather),avoidNullStr(model.house_paperwork),avoidNullStr(model.house_kind),avoidNullStr(model.house_style),avoidNullStr(model.house_mortgage),avoidNullStr(model.house_price),avoidNullStr(model.house_buytime),avoidNullStr(model.house_district)];
    }else if ([model.has_house isEqualToString:@"2"]&&[model.has_car isEqualToString:@"1"]) {
        titleArr = @[@"车辆型号",@"裸车价格",@"是否全款",@"购买时间"];
        valueArr = @[avoidNullStr(model.car_brand),avoidNullStr(model.car_nudeprice),avoidNullStr(model.car_buyonce),avoidNullStr(model.car_buytime)];
    }
    [_footcarHous.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:_footcarHous];
    [self PixeH:CGPointMake(0, 39) lenght:ScreenWidth add:_footcarHous];
    
    UIImageView *logImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 20, 20)];
    logImg.image = [UIImage imageNamed:@"nav_icon_money"];
    [_footcarHous addSubview:logImg];
    
    UILabel *valueLB = [MyControl customLabelWithFrame:CGRectMake(42, 10, 80, 20) text:@"资产资料" textColor:colorValue(0x111111, 1) textFont:14];
    [_footcarHous addSubview:valueLB];
    
    for (int i=0; i<titleArr.count; i++) {
        UILabel *titleLB = [MyControl creatLabelWithFrame:CGRectMake(20, 50+i*30, 62, 20) text:titleArr[i]];
        titleLB.tag = 2000+i;
        [_footcarHous addSubview:titleLB];
        
        UILabel *valueLB = [MyControl customLabelWithFrame:CGRectMake(100, 50+i*30, ScreenWidth-115, 20) text:valueArr[i] textColor:colorValue(0x111111, 1) textFont:15];
        valueLB.tag = 2100+i;
        [_footcarHous addSubview:valueLB];
    }
    if (titleArr.count) {
        UILabel *endLB = (UILabel *)[_footcarHous viewWithTag:1999+titleArr.count];
        _footcarHous.frame = CGRectMake(0, CGRectGetMaxY(_footuser.frame)+10, ScreenWidth, CGRectGetMaxY(endLB.frame)+10);
        [footV addSubview:_footcarHous];
    }
}
#pragma mark -- 布局征信资料
- (void)setCredit_info:(ordDetailModel *)model {
    
    if ([model.agency_type isEqualToString:@"1"]) {
        model.agency_type = @"无信用卡，或贷款";
    }else if ([model.agency_type isEqualToString:@"2"]) {
        model.agency_type = @"信用良好，无预期";
    }else if ([model.agency_type isEqualToString:@"3"]) {
        model.agency_type = @"一年逾期少于3次，少于90天";
    }else if ([model.agency_type isEqualToString:@"4"]) {
        model.agency_type = @"一年逾期超过3次，超过90天";
    }else {
        model.agency_type = @"情况不明";
    }
    
    NSMutableArray *titleArr = [[NSMutableArray alloc] initWithObjects:@"征信情况",@"查询次数", nil];
    NSMutableArray *valueArr = [[NSMutableArray alloc] initWithObjects:avoidNullStr(model.agency_type),avoidNullStr(model.agency_querytimes), nil];
    
    if ([model.job_type isEqualToString:@"1"]) {
        model.job_type = @"上班族";
        if ([model.company_type isEqualToString:@"1"]) {
            model.company_type = @"公务员／事业单位";
        }else if ([model.company_type isEqualToString:@"2"]) {
            model.company_type = @"国企单位";
        }else if ([model.company_type isEqualToString:@"3"]) {
            model.company_type = @"世界500强企业";
        }else if ([model.company_type isEqualToString:@"4"]) {
            model.company_type = @"上市企业";
        }else if ([model.company_type isEqualToString:@"5"]) {
            model.company_type = @"普通企业";
        }else {
            model.company_type = @"不详";
        }
        if ([model.salary_type isEqualToString:@"1"]) {
            model.salary_type = @"现金工资";
        }else if ([model.salary_type isEqualToString:@"2"]) {
            model.salary_type = @"打卡工资";
        }else {
            model.salary_type = @"不详";
        }
        model.salary_money = [NSString stringWithFormat:@"%@元",model.salary_money];
        [titleArr addObject:@"职业身份"];
        [titleArr addObject:@"工作单位"];
        [titleArr addObject:@"工资形式"];
        [titleArr addObject:@"工资金额"];
        [valueArr addObject:model.job_type];
        [valueArr addObject:model.company_type];
        [valueArr addObject:model.salary_type];
        [valueArr addObject:model.salary_money];
        //这些只针对上班族才有
        if ([model.has_social_security isEqualToString:@"1"]) {
            [titleArr addObject:@"社保"];
            [titleArr addObject:@"社保形式"];
            [titleArr addObject:@"社保金额"];
            [valueArr addObject:@"有"];
            if ([model.social_security_contribute isEqualToString:@"1"]) {
                [valueArr addObject:@"单位缴纳"];
            }else if ([model.social_security_contribute isEqualToString:@"2"]) {
                [valueArr addObject:@"自己缴纳"];
            }else {
                [valueArr addObject:@"无"];
            }
            [valueArr addObject:[NSString stringWithFormat:@"%@元",model.social_security_money]];
        }else if ([model.has_social_security isEqualToString:@"2"]) {
            [titleArr addObject:@"社保"];
            [valueArr addObject:@"无"];
        }
        if ([model.has_house_fund isEqualToString:@"1"]) {
            [titleArr addObject:@"公积金"];
            [titleArr addObject:@"公积金额"];
            [valueArr addObject:@"有"];
            [valueArr addObject:[NSString stringWithFormat:@"%@元",model.house_fund_money]];
        }else if ([model.has_house_fund isEqualToString:@"2"]) {
            [titleArr addObject:@"公积金"];
            [valueArr addObject:@"无"];
        }
    }else if ([model.job_type isEqualToString:@"2"]) {
        [titleArr addObject:@"职业身份"];
        [valueArr addObject:@"企业主"];
        [titleArr addObject:@"从事行业"];
        [valueArr addObject:avoidNullStr(model.industry)];
        [titleArr addObject:@"生意流水"];
        [valueArr addObject:[NSString stringWithFormat:@"%@元",model.month_money]];
    }else if ([model.job_type isEqualToString:@"3"]) {
        model.salary_money = [NSString stringWithFormat:@"%@元",model.salary_money];
        [titleArr addObject:@"职业身份"];
        [valueArr addObject:@"无固定职业"];
        [titleArr addObject:@"工资金额"];
        [valueArr addObject:model.salary_money];
    }
    if ([model.has_guarantee_slip isEqualToString:@"1"]) {
        [titleArr addObject:@"保单"];
        [titleArr addObject:@"投保公司"];
        [titleArr addObject:@"购保时间"];
        [titleArr addObject:@"保险年限"];
        [titleArr addObject:@"年缴金额"];
        [valueArr addObject:@"有"];
        [valueArr addObject:avoidNullStr(model.guarantee_company)];
        [valueArr addObject:avoidNullStr(model.guarantee_buytime)];
        [valueArr addObject:[NSString stringWithFormat:@"%@年",model.guarantee_years]];
        [valueArr addObject:[NSString stringWithFormat:@"%@元",model.guarantee_money]];
    }else if ([model.has_guarantee_slip isEqualToString:@"2"]) {
        [titleArr addObject:@"保单"];
        [valueArr addObject:@"无"];
    }
    if ([model.has_debt isEqualToString:@"1"]) {
        [titleArr addObject:@"负债有否"];
        [titleArr addObject:@"负债类型"];
        [titleArr addObject:@"负债金额"];
        [valueArr addObject:@"有"];
        if ([model.debt_type isEqualToString:@"1"]) {
            [valueArr addObject:@"抵押贷款"];
        }else if ([model.debt_type isEqualToString:@"2"]) {
            [valueArr addObject:@"按揭贷款"];
        }else if ([model.debt_type isEqualToString:@"3"]) {
            [valueArr addObject:@"信用卡贷款"];
        }else {
            [valueArr addObject:@"无"];
        }
        [valueArr addObject:[NSString stringWithFormat:@"%@万元",model.debt_money]];
    }else if ([model.has_debt isEqualToString:@"2"]) {
        [titleArr addObject:@"负债有否"];
        [valueArr addObject:@"无"];
    }
    
    [_footletter.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:_footletter];
    [self PixeH:CGPointMake(0, 39) lenght:ScreenWidth add:_footletter];
    
    UIImageView *logImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 20, 20)];
    logImg.image = [UIImage imageNamed:@"nav_icon_trust"];
    [_footletter addSubview:logImg];
    
    UILabel *valueLB = [MyControl customLabelWithFrame:CGRectMake(42, 10, 80, 20) text:@"征信资料" textColor:colorValue(0x111111, 1) textFont:14];
    [_footletter addSubview:valueLB];
    
    for (int i=0; i<titleArr.count; i++) {
        UILabel *titleLB = [MyControl creatLabelWithFrame:CGRectMake(20, 50+i*30, 62, 20) text:titleArr[i]];
        titleLB.tag = 2000+i;
        [_footletter addSubview:titleLB];
        
        UILabel *valueLB = [MyControl customLabelWithFrame:CGRectMake(100, 50+i*30, ScreenWidth-115, 20) text:valueArr[i] textColor:colorValue(0x111111, 1) textFont:15];
        valueLB.tag = 2100+i;
        [_footletter addSubview:valueLB];
    }
    CGFloat Y = CGRectGetMaxY(_footcarHous.frame)+10;
    if ([model.has_house isEqualToString:@"2"]&&[model.has_car isEqualToString:@"2"]) {
        Y = CGRectGetMaxY(_footuser.frame)+10;
    }else if ([XYString isBlankString:model.has_house]&&[XYString isBlankString:model.has_car]) {
        Y = CGRectGetMaxY(_footuser.frame)+10;
    }
    UILabel *endLB = (UILabel *)[_footletter viewWithTag:1999+titleArr.count];
    _footletter.frame = CGRectMake(0, Y, ScreenWidth, CGRectGetMaxY(endLB.frame)+10);
    [footV addSubview:_footletter];
}
#pragma mark -- 布局订单信息
- (void)setOrder_info:(ordDetailModel *)model {
    
    
    if (stauseStar) {
        if (![stauseStarStr isEqualToString:model.order_status]) {
            appdelegate.refresh = 3;
        }
    }else {
        stauseStar = YES;
        stauseStarStr = model.order_status;
    }
    NSMutableArray *titleArr = [[NSMutableArray alloc] initWithObjects:@"订单号",@"订单状态",@"订单来源", nil];
    NSMutableArray *valueArr = [[NSMutableArray alloc] initWithObjects:avoidNullStr(model.order_nid),avoidNullStr(model.order_status_txt),avoidNullStr(model.operator_id_author_txt), nil];
    if ([self getroleClass]==1) {
        if (![avoidNullStr(model.operator_id_author) isEqualToString:appdelegate.OperationStr]) {
            myself = NO;
        }
    }else {
        if (model.order_status.integerValue>=3) {
            if (![avoidNullStr(model.operator_id_solution) isEqualToString:appdelegate.OperationStr]) {
                myself = NO;
            }
        }
    }
    if (model.order_status.intValue>=3) {
        [titleArr addObject:@"接单人"];
        [valueArr addObject:avoidNullStr(model.operator_id_solution_txt)];
    }
    if ([model.order_status isEqualToString:@"7"]||[model.order_status isEqualToString:@"8"]||[model.order_status isEqualToString:@"9"]) {
        [titleArr addObject:@"实际放款"];
        [valueArr addObject:[NSString stringWithFormat:@"%@万",model.loan_amount]];
    }
    if ([model.order_status isEqualToString:@"8"]||[model.order_status isEqualToString:@"9"]) {
        [titleArr addObject:@"服务费用"];
        [valueArr addObject:[NSString stringWithFormat:@"%@元",model.service_fee]];
    }
    if ([model.order_status isEqualToString:@"9"]) {
        [titleArr addObject:@"是否准时"];
        [titleArr addObject:@"利率变更"];
        [valueArr addObject:avoidNullStr(model.is_intime)];
        [valueArr addObject:avoidNullStr(model.is_change_rate)];
    }
    [_footorder.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:_footorder];
    [self PixeH:CGPointMake(0, 39) lenght:ScreenWidth add:_footorder];
    
    UIImageView *logImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 20, 20)];
    logImg.image = [UIImage imageNamed:@"nav_icon_order"];
    [_footorder addSubview:logImg];
    
    UILabel *valueLB = [MyControl customLabelWithFrame:CGRectMake(42, 10, 80, 20) text:@"订单信息" textColor:colorValue(0x111111, 1) textFont:14];
    [_footorder addSubview:valueLB];
    
    ordNum = model.order_nid;
    for (int i=0; i<titleArr.count; i++) {
        UILabel *titleLB = [MyControl creatLabelWithFrame:CGRectMake(20, 50+i*30, 62, 20) text:titleArr[i]];
        titleLB.tag = 2000+i;
        [_footorder addSubview:titleLB];
        
        UILabel *valueLB = [MyControl customLabelWithFrame:CGRectMake(100, 50+i*30, ScreenWidth-115, 20) text:valueArr[i] textColor:colorValue(0x111111, 1) textFont:15];
        valueLB.tag = 2100+i;
        [_footorder addSubview:valueLB];
    }
    UILabel *endLB = (UILabel *)[_footorder viewWithTag:1999+titleArr.count];
    _footorder.frame = CGRectMake(0, CGRectGetMaxY(_footletter.frame)+10, ScreenWidth, CGRectGetMaxY(endLB.frame)+10);
    [footV addSubview:_footorder];
    //布局底部视图
    footV.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(_footorder.frame)+20);
    _mainOneTV.tableFooterView = footV;
}
#pragma mark -- 布局底部按钮选项
- (void)setToolView:(ordDetailModel *)model {
    NSArray *titleArr;

    if (myself==NO) {
        titleArr = @[@"回复"];
    }else {
        if ([self getroleClass]==1) {
            if (model.order_status.intValue==1) {
                titleArr = @[@"编辑",@"撤销",@"回复",@"指派订单"];
            }else if (model.order_status.intValue==2) {
                titleArr = @[@"指派订单",@"编辑",@"撤销",@"回复"];
            }else if (model.order_status.integerValue==12) {
                titleArr = @[@"重新提交",@"回复"];
            }else {
                if (model.order_status.integerValue==9 ||model.order_status.integerValue == 11) {
                    titleArr = @[@"回复"];
                }else{
                    titleArr = @[@"回复",@"指派订单"];
                }
            }
        }else {
            if (model.order_status.intValue==1) {
                titleArr = @[@"提交方案",@"回复",@"撤销"];
            }else if (model.order_status.intValue==2) {
                titleArr = @[@"接单",@"提交方案",@"回复",@"撤销"];
            }else if (model.order_status.intValue==3||model.order_status.intValue==4||model.order_status.intValue==5||model.order_status.intValue==6||model.order_status.intValue==7) {
                titleArr = @[@"新增渠道",@"回复",@"转发"];
            }else if (model.order_status.intValue==8) {
                titleArr = @[@"新增渠道",@"回复",@"转发",@"结单"];
            }else if (model.order_status.intValue==9||model.order_status.intValue==11||model.order_status.intValue==12) {
                titleArr = @[@"回复"];
            }else if (model.order_status.intValue==10) {
                titleArr = @[@"新增渠道",@"回复",@"转发",@"终止订单"];
            }
        }
    }
    //布局下部选项
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:toolV];
    
    for (int i=0; i<titleArr.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*ScreenWidth/titleArr.count, 0, ScreenWidth/titleArr.count, 50)];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:colorValue(0x111111, 1) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolV addSubview:button];
        if (i!=0) {
            [self PixeV:CGPointMake(i*ScreenWidth/titleArr.count, 10) lenght:30 add:toolV];
        }
    }
}
#pragma mark - 提示信息
-(void)alertWithStr:(NSString *)text status:(NSString *)str sender:(UIButton *)sender{
    NSString *title = @"确认是否操作";
    NSString *message = NSLocalizedString(StrFormatTW(@"确认", text), nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"否", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"是", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"%@",cancelButtonTitle);
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"%@",otherButtonTitle);
        if ([str isEqualToString:@"1"]) {
            if ([text isEqualToString:@"提交方案"]) {
                SubmittedVC *MVC = [[SubmittedVC alloc] init];
                MVC.ordNum = ordNum;
                [self.navigationController pushViewController:MVC animated:YES];
            }
            if ([text isEqualToString:@"回复"]) {
                relyVC *MVC = [[relyVC alloc] init];
                MVC.ordNum = ordNum;
                [self.navigationController pushViewController:MVC animated:YES];
            }
            if ([text isEqualToString:@"接单"]) {
                [self acceptOrderRequest];
            }
            if ([text isEqualToString:@"新增渠道"]) {
                channelVC *MVC = [[channelVC alloc] init];
                MVC.ordID = _order_nid;
                [self.navigationController pushViewController:MVC animated:YES];
            }
            if ([text isEqualToString:@"结单"]) {
                [self statement];
            }
            if ([text isEqualToString:@"终止订单"]) {
                endOrderVC *MVC = [[endOrderVC alloc] init];
                MVC.ordNum = _order_nid;
                MVC.titleStr = @"订单终止";
                [self.navigationController pushViewController:MVC animated:YES];
            }
            if ([text isEqualToString:@"转发"]) {
                forwardingVC *MVC = [[forwardingVC alloc] init];
                MVC.ordNum = _order_nid;
                MVC.titleStr = @"订单转发";
                [self.navigationController pushViewController:MVC animated:YES];
            }
            if ([text isEqualToString:@"指派订单"]) {
                forwardingVC *MVC = [[forwardingVC alloc] init];
                MVC.ordNum = _order_nid;
                MVC.titleStr = @"订单指派";
                [self.navigationController pushViewController:MVC animated:YES];
            }
            if ([text isEqualToString:@"编辑"]) {
                AddOrderController *controller = [[AddOrderController alloc] init];
                controller.title = LocalizationNotNeeded(@"编辑订单");
                if (self.orderDetailDict) {
                    controller.model = [OrderDetailModel mj_objectWithKeyValues: self.orderDetailDict];
                }
                [self.navigationController pushViewController:controller animated:YES];
                [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
            }
            if ([text isEqualToString:@"重新提交"]) {
                AddOrderController *controller = [[AddOrderController alloc] init];
                controller.title = LocalizationNotNeeded(@"重新提交");
                if (self.orderDetailDict) {
                    controller.model = [OrderDetailModel mj_objectWithKeyValues: self.orderDetailDict];
                }
                [self.navigationController pushViewController:controller animated:YES];
                [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
            }
            if ([text isEqualToString:@"撤销"]) {
                endOrderVC *MVC = [[endOrderVC alloc] init];
                MVC.ordNum = _order_nid;
                MVC.titleStr = @"订单撤销";
                [self.navigationController pushViewController:MVC animated:YES];
                [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
            }

        }else{
             NSString *staName = @"";
            if ([text isEqualToString:@"进件"]) {
                staName = @"access";
            }
            if ([text isEqualToString:@"同意"]) {
                staName = @"agree";

            }
            if ([text isEqualToString:@"签合同"]) {
                staName = @"contract";

            }
            ordDetailModel *model = dataChannelArr[sender.tag-300];
            [self ChannelOperations:model.channel_id stause:staName];
        }
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -- 订单操作
- (void)operationAction:(UIButton *)sender {
 
    if ([sender.titleLabel.text isEqualToString:@"提交方案"]) {
        if (limModel.lim_Submitted==NO) {
            [LCProgressHUD showMessage:@"无权限进行当前操作"];
            return;
        }
        [self alertWithStr:sender.titleLabel.text status:@"1" sender:sender];
    }else if ([sender.titleLabel.text isEqualToString:@"回复"]) {
        if (limModel.lim_reply==NO) {
            [LCProgressHUD showMessage:@"无权限进行当前操作"];
            return;
        }
        [self alertWithStr:sender.titleLabel.text status:@"1"  sender:sender];
    }else if ([sender.titleLabel.text isEqualToString:@"接单"]) {
        if (limModel.lim_receiveOrder==NO) {
            [LCProgressHUD showMessage:@"无权限进行当前操作"];
            return;
        }
        [self alertWithStr:sender.titleLabel.text status:@"1"  sender:sender];
    }else if ([sender.titleLabel.text isEqualToString:@"新增渠道"]) {
        if (limModel.lim_addChannel==NO) {
            [LCProgressHUD showMessage:@"无权限进行当前操作"];
            return;
        }
        [self alertWithStr:sender.titleLabel.text status:@"1"  sender:sender];
    }else if ([sender.titleLabel.text isEqualToString:@"结单"]) {
        if (limModel.lim_endOrder==NO) {
            [LCProgressHUD showMessage:@"无权限进行当前操作"];
            return;
        }
        [self alertWithStr:sender.titleLabel.text status:@"1" sender:sender];
    }else if ([sender.titleLabel.text isEqualToString:@"终止订单"]) {
        if (limModel.lim_stopOrder==NO) {
            [LCProgressHUD showMessage:@"无权限进行当前操作"];
            return;
        }
        [self alertWithStr:sender.titleLabel.text status:@"1" sender:sender];
    }else if ([sender.titleLabel.text isEqualToString:@"转发"]) {
        if (limModel.lim_forwarding==NO) {
            [LCProgressHUD showMessage:@"无权限进行当前操作"];
            return;
        }
        [self alertWithStr:sender.titleLabel.text status:@"1" sender:sender];
    }else if ([sender.titleLabel.text isEqualToString:@"指派订单"]) {
        if (limModel.lim_assigned==NO) {
            [LCProgressHUD showMessage:@"无权限进行当前操作"];
            return;
        }
        [self alertWithStr:sender.titleLabel.text status:@"1" sender:sender];
    }else if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        [self alertWithStr:sender.titleLabel.text status:@"1" sender:sender];
    }else if ([sender.titleLabel.text isEqualToString:@"重新提交"]) {
        [self alertWithStr:sender.titleLabel.text status:@"1" sender:sender];

    }else if ([sender.titleLabel.text isEqualToString:@"撤销"]) {
        if (limModel.lim_undo==NO) {
            [LCProgressHUD showMessage:@"无权限进行当前操作"];
            return;
        }
        [self alertWithStr:sender.titleLabel.text status:@"1" sender:sender];
    }
}
- (void)stauseAction:(UIButton *)sender {
    ordDetailModel *model = dataChannelArr[sender.tag-300];
    if ([sender.titleLabel.text isEqualToString:@"进件"]) {
        [self alertWithStr:sender.titleLabel.text status:@"2" sender:sender];
    }else if ([sender.titleLabel.text isEqualToString:@"终止"]) {
        channelStr = model.channel_id;
        UILabel *titleLB = (UILabel *)[_whyView viewWithTag:111];
        titleLB.text = LocalizationNotNeeded(@"终止原因：");
        [UIView animateWithDuration:0.35 animations:^{
            _whyView.y = ScreenHeight-294;
            [self.view endEditing:YES];
            backV.alpha = 0.6;
        }];
        return;
    }else if ([sender.titleLabel.text isEqualToString:@"同意"]) {
        [self alertWithStr:sender.titleLabel.text status:@"2" sender:sender];
    }else if ([sender.titleLabel.text isEqualToString:@"驳回"]) {
        channelStr = model.channel_id;
        UILabel *titleLB = (UILabel *)[_whyView viewWithTag:111];
        titleLB.text = LocalizationNotNeeded(@"驳回原因：");
        [UIView animateWithDuration:0.35 animations:^{
            _whyView.y = ScreenHeight-294;
            [self.view endEditing:YES];
            backV.alpha = 0.6;
        }];
        return;
    }else if ([sender.titleLabel.text isEqualToString:@"签合同"]) {
        [self alertWithStr:sender.titleLabel.text status:@"2" sender:sender];
    }else if ([sender.titleLabel.text isEqualToString:@"放款"]) {
        channelStr = model.channel_id;
        [UIView animateWithDuration:0.35 animations:^{
            _lendingView.y = ScreenHeight-294;
            [self.view endEditing:YES];
            backV.alpha = 0.6;
        }];
        return;
    }else if ([sender.titleLabel.text isEqualToString:@"输入金额"]) {
        channelStr = model.channel_id;
        ordDetailModel * channelInfo = [ordDetailModel mj_objectWithKeyValues:model.channel_extinfo];
        [UIView animateWithDuration:0.35 animations:^{
            _serviceView.y = ScreenHeight-281;//217高度
            UITextField *textTF1 = (UITextField *)[_serviceView viewWithTag:111];
            UITextField *textTF3 = (UITextField *)[_serviceView viewWithTag:113];
            UITextField *textTF4 = (UITextField *)[_serviceView viewWithTag:114];
            if ([channelInfo.is_pay_service isEqualToString:@"1"]) {
                textTF1.userInteractionEnabled = NO;
            }else{
                textTF1.userInteractionEnabled = YES;
            }
            if ([channelInfo.is_pay_return isEqualToString:@"1"]) {
                textTF3.userInteractionEnabled = NO;
            }else{
                textTF3.userInteractionEnabled = YES;
            }
            if ([channelInfo.is_pay_pack isEqualToString:@"1"]) {
                textTF4.userInteractionEnabled = NO;
            }else{
                textTF4.userInteractionEnabled = YES;
            }
            textTF1.text = ([channelInfo.service_fee floatValue]>0.0)?channelInfo.service_fee  :nil;
            textTF3.text = ([channelInfo.return_fee floatValue]>0.0) ?channelInfo.return_fee   :nil;
            textTF4.text = ([channelInfo.pack_fee floatValue]>0.0)   ?channelInfo.pack_fee     :nil;
            [self.view endEditing:YES];
            backV.alpha = 0.6;
        }];
    }else if ([sender.titleLabel.text isEqualToString:@"支付"]) {
        PayListViewController *controller = [[PayListViewController alloc] init];
        controller.title = @"待支付列表";
        controller.channel_id = model.channel_id;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"收取服务费"]) {
        channelStr = model.channel_id;
        [UIView animateWithDuration:0.35 animations:^{
            _serviceView.y = ScreenHeight-324;
            [self.view endEditing:YES];
            backV.alpha = 0.6;
        }];
        return;
    }else{
        return;
    }
    //[self ChannelOperations:model.channel_id stause:staName];
}
#pragma mark -- 提交原因按钮
- (IBAction)submitWhyAction {
    [self.view endEditing:YES];
    UILabel *titleLB = (UILabel *)[_whyView viewWithTag:111];
    UITextView *textV = (UITextView *)[_whyView viewWithTag:112];
    if (textV.text.length) {
        NSString *name = @"";
        NSString *keyStr = @"";
        if ([titleLB.text isEqualToString:@"终止原因："]) {
            name = @"over";
            keyStr = @"over_reason";
        }else if ([titleLB.text isEqualToString:@"驳回原因："]){
            name = @"deny";
            keyStr = @"deny_reason";
        }
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[self setRSAencryptString:ordNum] forKey:@"order_nid"];
        [param setObject:[self setRSAencryptString:name] forKey:@"channel_action"];
        [param setObject:[self setRSAencryptString:channelStr] forKey:@"channel_id"];
        [param setObject:[self setRSAencryptString:textV.text] forKey:keyStr];
        NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",ordNum]},
                              @{@"price":@"channel_action",@"vaule":[NSString stringWithFormat:@"channel_action%@",name]},
                              @{@"price":@"channel_id",@"vaule":[NSString stringWithFormat:@"channel_id%@",channelStr]},
                              @{@"price":keyStr,@"vaule":[NSString stringWithFormat:@"%@%@",keyStr,textV.text]}];
        [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
        
        [LCProgressHUD showLoading:nil];
        [self post:@"/order/channel/" parameters:param success:^(id dic) {
            if ([dic[@"code"] intValue]==0) {
                [LCProgressHUD showSuccess:@"操作成功"];
                
                [UIView animateWithDuration:0.35 animations:^{
                    backV.alpha = 0;
                    [self.view endEditing:YES];
                    _whyView.y = ScreenHeight-64;
                }];
                [self setRequest:NO];
            }else {
                NSString *msg = dic[@"info"];
                if (![XYString isBlankString:msg]) {
                    [LCProgressHUD showMessage:msg];
                }else {
                    [LCProgressHUD hide];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }else {
        [LCProgressHUD showInfoMsg:@"请填写原因"];
    }
}
#pragma mark -- 选择放款时间按钮
- (IBAction)seleTimeAction:(id)sender {
    /** 自定义日期选择器 */
    [self.view endEditing:YES];
    HMDatePickView *datePickVC = [[HMDatePickView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    //距离当前日期的年份差（设置最大可选日期）
    datePickVC.maxYear = -10;
    //设置最小可选日期(年分差)
    datePickVC.minYear = 0;
    datePickVC.date = [NSDate date];
    //设置字体颜色
    datePickVC.fontColor = [UIColor blackColor];
    //日期回调
    datePickVC.completeBlock = ^(NSString *selectDate) {
        UILabel *timeLB = (UILabel *)[_lendingView viewWithTag:113];
        timeLB.text = selectDate;
    };
    //配置属性
    [datePickVC configuration];
    
    [self.view addSubview:datePickVC];
}

#pragma mark -- 提交放款按钮
- (IBAction)submintLendAction {
    [self.view endEditing:YES];
    UITextView *textMoney = (UITextView *)[_lendingView viewWithTag:111];
    UITextView *interestV = (UITextView *)[_lendingView viewWithTag:112];
    UILabel *timeLB = (UILabel *)[_lendingView viewWithTag:113];
    if (textMoney.text.length&&interestV.text.length&&timeLB.text.length) {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[self setRSAencryptString:ordNum] forKey:@"order_nid"];
        [param setObject:[self setRSAencryptString:@"loan"] forKey:@"channel_action"];
        [param setObject:[self setRSAencryptString:channelStr] forKey:@"channel_id"];
        [param setObject:[self setRSAencryptString:textMoney.text] forKey:@"loan_amount"];
        [param setObject:[self setRSAencryptString:interestV.text] forKey:@"loan_rate"];
        [param setObject:[self setRSAencryptString:timeLB.text] forKey:@"loan_time"];
        NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",ordNum]},
                              @{@"price":@"channel_action",@"vaule":[NSString stringWithFormat:@"channel_action%@",@"loan"]},
                              @{@"price":@"channel_id",@"vaule":[NSString stringWithFormat:@"channel_id%@",channelStr]},
                              @{@"price":@"loan_amount",@"vaule":[NSString stringWithFormat:@"loan_amount%@",textMoney.text]},
                              @{@"price":@"loan_rate",@"vaule":[NSString stringWithFormat:@"loan_rate%@",interestV.text]},
                              @{@"price":@"loan_time",@"vaule":[NSString stringWithFormat:@"loan_time%@",timeLB.text]}];
        [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
        
        [LCProgressHUD showLoading:nil];
        [self post:@"/order/channel/" parameters:param success:^(id dic) {
            if ([dic[@"code"] intValue]==0) {
                [LCProgressHUD showSuccess:@"操作成功"];
                
                [UIView animateWithDuration:0.35 animations:^{
                    _lendingView.y = ScreenHeight-64;
                    [self.view endEditing:YES];
                    backV.alpha = 0;
                }];
                [self setRequest:NO];
            }else {
                NSString *msg = dic[@"info"];
                if (![XYString isBlankString:msg]) {
                    [LCProgressHUD showMessage:msg];
                }else {
                    [LCProgressHUD hide];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }else {
        [LCProgressHUD showInfoMsg:@"请完善信息"];
    }
}
#pragma mark -- 提交服务费按钮
- (IBAction)submitServiceAction {
    [self.view endEditing:YES];
    UITextField *textTF1 = (UITextField *)[_serviceView viewWithTag:111];
    //UIButton *textBT2 = (UIButton *)[_serviceView viewWithTag:112];
    UITextField *textTF3 = (UITextField *)[_serviceView viewWithTag:113];
    UITextField *textTF4 = (UITextField *)[_serviceView viewWithTag:114];
    
    if (textTF1.text.length) {//&&![textBT2.titleLabel.text isEqualToString:@"请选择收费人"]
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:[self setRSAencryptString:ordNum] forKey:@"order_nid"];
        [param setObject:[self setRSAencryptString:@"fee"] forKey:@"channel_action"];
        [param setObject:[self setRSAencryptString:channelStr] forKey:@"channel_id"];
        [param setObject:[self setRSAencryptString:textTF1.text] forKey:@"service_fee"];
        //[param setObject:[self setRSAencryptString:operatorIdStr] forKey:@"operator_id_accept"];
        [param setObject:[self setRSAencryptString:textTF3.text] forKey:@"return_fee"];
        [param setObject:[self setRSAencryptString:textTF4.text] forKey:@"pack_fee"];
        NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",ordNum]},
                              @{@"price":@"channel_action",@"vaule":[NSString stringWithFormat:@"channel_action%@",@"fee"]},
                              @{@"price":@"channel_id",@"vaule":[NSString stringWithFormat:@"channel_id%@",channelStr]},
                              @{@"price":@"service_fee",@"vaule":[NSString stringWithFormat:@"service_fee%@",textTF1.text]},
                              //@{@"price":@"operator_id_accept",@"vaule":[NSString stringWithFormat:@"operator_id_accept%@",operatorIdStr]},
                              @{@"price":@"return_fee",@"vaule":[NSString stringWithFormat:@"return_fee%@",textTF3.text]},
                              @{@"price":@"pack_fee",@"vaule":[NSString stringWithFormat:@"pack_fee%@",textTF4.text]}];
        [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
        
        [LCProgressHUD showLoading:nil];
        [self post:@"/order/channel/" parameters:param success:^(id dic) {
            if ([dic[@"code"] intValue]==0) {
                [LCProgressHUD showSuccess:@"操作成功"];
              
                [UIView animateWithDuration:0.35 animations:^{
                    _serviceView.y = ScreenHeight-64;
                    [self.view endEditing:YES];
                    backV.alpha = 0;
                }];
                [self setRequest:NO];
            }else {
                NSString *msg = dic[@"info"];
                if (![XYString isBlankString:msg]) {
                    [LCProgressHUD showMessage:msg];
                }else {
                    [LCProgressHUD hide];
                }
            }
        } failure:^(NSError *error) {
            
        }];
    }else {
        [LCProgressHUD showInfoMsg:@"请完善信息"];
    }
}

#pragma mark -- 接单的网络请求
- (void)acceptOrderRequest {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:ordNum] forKey:@"order_nid"];
    NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",ordNum]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/order/accept/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:@"成功接单"];
            [self setRequest:NO];
        }else {
            NSString *msg = dic[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showMessage:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 渠道操作的网络请求
- (void)ChannelOperations:(NSString *)channelId stause:(NSString *)name {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setRSAencryptString:ordNum] forKey:@"order_nid"];
    [param setObject:[self setRSAencryptString:name] forKey:@"channel_action"];
    [param setObject:[self setRSAencryptString:channelId] forKey:@"channel_id"];
    NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",ordNum]},
                          @{@"price":@"channel_action",@"vaule":[NSString stringWithFormat:@"channel_action%@",name]},
                          @{@"price":@"channel_id",@"vaule":[NSString stringWithFormat:@"channel_id%@",channelId]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/order/channel/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD showMessage:@"操作成功"];
            [self setRequest:NO];
        }else {
            NSString *msg = dic[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showMessage:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (IBAction)collectorAction:(UIButton *)sender {
    [self setpersonRequest:sender];
}

#pragma mark -- 获取收费人
- (void)setpersonRequest:(UIButton *)button {
    [self.view endEditing:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[self setRSAencryptString:ordNum] forKey:@"order_nid"];
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/sysset/acceptfee/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD hide];
            NSArray *arr = dic[@"data"];
            [self.titleArr removeAllObjects];
            [self.productidArr removeAllObjects];
            for (NSDictionary *dics in arr) {
                [self.titleArr addObject:dics[@"operator_name"]];
                [self.productidArr addObject:dics[@"operator_id"]];
            }
            LTPickerView* pickerView = [LTPickerView new];
            pickerView.dataSource = self.titleArr;
            [pickerView show];//显示
            //回调block
            pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
                //obj:LTPickerView对象
                //str:选中的字符串
                //num:选中了第几行
                [button setTitle:str forState:UIControlStateNormal];
                operatorIdStr = self.productidArr[num];
            };
        }else {
            NSString *msg = dic[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showMessage:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 结单网络请求
- (void)statement {

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[self setRSAencryptString:ordNum] forKey:@"order_nid"];
    NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",ordNum]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/order/finish/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:@"结单成功"];
            [self setRequest:NO];
        }else {
            NSString *msg = dic[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showMessage:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 订单终止网络请求
- (void)TerminationOrder {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[self setRSAencryptString:ordNum] forKey:@"order_nid"];
    NSArray *tokenArr = @[@{@"price":@"order_nid",@"vaule":[NSString stringWithFormat:@"order_nid%@",ordNum]}];
    [param setObject:[self setUserTokenStr:tokenArr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
    [self post:@"/order/finish/" parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD showSuccess:@"终止成功"];
            [self setRequest:NO];
        }else {
            NSString *msg = dic[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showMessage:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 控制器销毁
- (void)dealloc {
    NSLog(@"%s",__func__);
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
