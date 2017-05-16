//
//  AssetController.m
//  xiaoshidai
//
//  Created by XSD on 16/9/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "AssetController.h"
#import "FillinViewCell.h"
#import "NIDropDown.h"

@interface AssetController ()<LJKDatePickerDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    int flag[5] ; // 0 0 0 0 0
    NSString *tempStr;
    NSArray *carArray;
    NSArray *houseArray;
    NSArray *carPlaceHolders;
    NSArray *housePlaceHolders;
    BOOL houseOK;
    BOOL carOK;
    BOOL house;
    BOOL car;
    NSString * carBrandStr;
    NSString * carPriceStr;
    NSString * carBuyTimeStr;
    NSString * housePriceStr;
    NSString * houseBuyTimeStr;
    NSString * disNameStr;
}
@property (nonatomic,strong) NSMutableArray *assetInfoArray;
@property (nonatomic) LJKDatePicker    *datePicker;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *placeHolderArray;
@property (nonatomic,copy )  NSString *dateString;
@property (nonatomic )  UITextField * currentTextField;

@end

@implementation AssetController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.frame  =CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    carArray =@[@"是否有车",@"车辆型号",@"裸车价格",@"是否全款",@"车辆购买时间"];
    houseArray = @[@"是否有房",@"是否共有",@"是否有证",@"房产性质",@"房屋类型",@"是否有房贷",@"房屋价格",
                            @"房屋购买时间",@"小区名字"];

    carPlaceHolders =  @[@"是否有车",@"如:丰田15款卡罗拉",@"请输入裸车价格",@"是否全款",@"车辆购买时间"];
    housePlaceHolders = @[@"是否有房",@"是否共有",@"是否有证",@"房产性质",@"房屋类型",@"是否有房贷",@"请输入房屋的购买价格",@"房屋购买时间",@"小区名字"];
    [self.dataArray addObject:carArray];
    [self.dataArray addObject:houseArray];
    self.placeHolderArray = [NSMutableArray array];
    [_placeHolderArray  addObject:carPlaceHolders];
    [_placeHolderArray addObject:housePlaceHolders];
    
    [self tableView];
    [self subDict];
    _datePicker=[[LJKDatePicker alloc]initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width,200)];
    _datePicker.delegate=self;
    [self.view  addSubview:_datePicker];
    [self.view bringSubviewToFront:_datePicker];
    [_datePicker setHidden:YES];
}

#pragma mark - 创建tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44, kScreen_Width, kScreen_Height-64-44) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        [_tableView registerClass:[FillinViewCell class] forCellReuseIdentifier:@"FillinViewCell"];
        [self.view addSubview:_tableView];
        [self initNextButton];
        self.tableView.sectionHeaderHeight = 44;

    }
    return _tableView;
}
-(void)initNextButton{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width,70)];
    
    _nextButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_nextButton setTitle:@"下一步" forState:(UIControlStateNormal)];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_nextButton setBackgroundColor:[UIColor orangeColor]];
    [_nextButton addTarget:self action:@selector(next:) forControlEvents:(UIControlEventTouchUpInside)];

    _nextButton.layer.cornerRadius = 5.0f;
    [footView addSubview:_nextButton];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(footView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width-30, 40));
        make.top.mas_equalTo(footView.mas_top).offset(10);
    }];
    self.tableView.tableFooterView = footView;
}
-(void)next:(UIButton *)button{
    [self.view endEditing:YES];
    @try {
         house = NO;
         car = NO;
        if (houseOK) {
            if ([[_subDict objectForKey:@"has_house"] isEqualToString:@"1"]) {
                if ([[_subDict objectForKey:@"house_togather"] length]<=0) {
                    [_subDict setObject:@"1" forKey:@"house_togather"];
                }
                if ([[_subDict objectForKey:@"house_paperwork"] length]<=0){
                    [_subDict setObject:@"1" forKey:@"house_paperwork"];
                }
                if ([[_subDict objectForKey:@"house_kind"] length]<=0){
                    [_subDict setObject:@"1" forKey:@"house_kind"];
                }
                if ([[_subDict objectForKey:@"house_style"] length]<=0){
                    [_subDict setObject:@"1" forKey:@"house_style"];
                }
                if ([[_subDict objectForKey:@"house_mortgage"] length]<=0){
                    [_subDict setObject:@"1" forKey:@"house_mortgage"];
                }
                if (([[_subDict objectForKey:@"house_togather"] length]<=0)
                    || ([[_subDict objectForKey:@"house_paperwork"] length]<=0)
                    || ([[_subDict objectForKey:@"house_kind"] length]<=0)
                    || ([[_subDict objectForKey:@"house_style"] length]<=0)
                    || ([[_subDict objectForKey:@"house_mortgage"] length]<=0)) {
                    [LCProgressHUD showMessage:@"完善房屋信息"];
                }else{
                    house = YES;
                }
            }else{
                house = YES;
            }
        }
        if (carOK){
            if ([[_subDict objectForKey:@"has_car"] isEqualToString:@"1"]) {
                //有车 依赖必选
                if ([[_subDict objectForKey:@"car_buyonce"] length]<=0) {
                    [_subDict setObject:@"1" forKey:@"car_buyonce"];
                }
                if ([[_subDict objectForKey:@"car_buyonce"] length]<=0) {
                    [LCProgressHUD showMessage:@"完善车辆信息"];
                }else{
                    car = YES;
                }
            }else{
                car = YES;
            }
        }
        if (car && house) {
            NSLog(@"%@",[_subDict mj_JSONString]);
            SCNavTabBarController * nav =  (SCNavTabBarController *)self.parentViewController;
            nav.navTabBar.flag = YES;
            UIButton *sender = nav.navTabBar.items[1];
            UIButton *sender0 = nav.navTabBar.items[0];
            UIButton *sender2 = nav.navTabBar.items[2];
            sender.enabled = YES;
            sender0.enabled = YES;
            sender2.enabled = YES;
            if (!self.isJump) {
                [nav.navTabBar itemPressed:sender2];
            }
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
        [LCProgressHUD showMessage:exception.description];
    } @finally {
    }
}
-(NSMutableArray *)assetInfoArray{
    if (!_assetInfoArray) {
        _assetInfoArray = [NSMutableArray array];
    }
    return _assetInfoArray;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)placeHolderArray{
    if (!_placeHolderArray) {
        _placeHolderArray = [NSMutableArray array];
    }
    return _placeHolderArray;
}
-(NSMutableDictionary *)subDict{
    if (!_subDict) {
        _subDict = [NSMutableDictionary dictionary];
    }
    return _subDict;
}
#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = _dataArray[section];
    if ([self.model.has_car isEqualToString:@"1"]&& section == 0) {
        return array.count-1;
    }
    if ([self.model.has_house isEqualToString:@"1"] && section == 1) {
        return array.count-1;
    }
    return flag[section] == 0? 0 : array.count-1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak __typeof(&*self)weakSelf = self;
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];//以indexPath来唯一确定cell
    FillinViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
    if (cell == nil) {
        cell = [[FillinViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.indexPath = indexPath;
        //NSArray *arr = [NSArray array];
        cell.inputTextField.delegate = self;
        cell.inputTextField.placeholder = _placeHolderArray[indexPath.section][indexPath.row+1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    if (self.model) {
        cell.assetsModel = self.model;
    }
    cell.title = _dataArray[indexPath.section][indexPath.row+1];

    if ([cell.title isEqualToString:@"车辆购买时间"]||[cell.title isEqualToString:@"房屋购买时间"]) {
        objc_setAssociatedObject(cell.downButton, "firstObject", cell.inputTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [cell.downButton addTarget:self action:@selector(selectDate:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    [cell setCallBackHandler:^(NSDictionary *dict) {
        //__strong __typeof(weakSelf)strongSelf = weakSelf;
        NSDictionary *ddd = [dict allValues][0];
        NSLog(@"*-*-%@-%@-*-*",[ddd allValues][0],[dict allKeys][0]);
        [weakSelf.subDict setObject:[ddd allValues][0] forKey:[dict allKeys][0]];
        //NSString * key = [ddd allKeys][0];
        NSString * value = [ddd allValues][0];
        if ([[dict allKeys][0] isEqualToString:@"car_nudeprice"]) {
            weakSelf.model.car_nudeprice = value;
        }
        if ([[dict allKeys][0] isEqualToString:@"house_togather"]) {
            weakSelf.model.house_togather = value;
        }
        if ([[dict allKeys][0] isEqualToString:@"house_paperwork"]) {
            weakSelf.model.house_paperwork = value;
        }
        if ([[dict allKeys][0] isEqualToString:@"house_kind"]) {
            weakSelf.model.house_kind = value;
        }
        if ([[dict allKeys][0] isEqualToString:@"house_mortgage"]) {
            weakSelf.model.house_mortgage = value;
        }
        if ([[dict allKeys][0] isEqualToString:@"car_nudeprice"]) {
            weakSelf.model.car_nudeprice = value;
        }

    }];
    if (self.model) {
        [self fillCell:cell.inputTextField withModel:_model];
    }
    return cell;
}
-(void)fillCell:(MyTextField *)textField withModel:(User_Assets_Info *)model{
    UILabel *label = (UILabel *)textField.leftView;
    @try {
        if ([label.text isEqualToString:@"车辆型号"]) {
            carBrandStr == nil?(textField.text = model.car_brand):(textField.text = carBrandStr);
            [self.subDict setObject:model.car_brand forKey:@"car_brand"];
        }else if ([label.text isEqualToString:@"裸车价格"]){
            carPriceStr == nil?(textField.text = model.car_nudeprice):(textField.text = carPriceStr);
            [self.subDict setObject:model.car_nudeprice forKey:@"car_nudeprice"];
        }else if ([label.text isEqualToString:@"房屋价格"]){
            housePriceStr == nil?(textField.text = model.house_price):(textField.text = housePriceStr);
            [self.subDict setObject:model.house_price forKey:@"house_price"];
        }else if ([label.text isEqualToString:@"小区名字"]){
            disNameStr == nil?(textField.text = model.house_district):(textField.text = disNameStr);
            [self.subDict setObject:model.house_district forKey:@"house_district"];
        }else if ([label.text isEqualToString:@"车辆购买时间"]){
            carBuyTimeStr == nil?(textField.text = model.car_buytime):(textField.text = carBuyTimeStr);
            [self.subDict setObject:model.car_buytime forKey:@"car_buytime"];
        }else if ([label.text isEqualToString:@"房屋购买时间"]){
            houseBuyTimeStr == nil?(textField.text = model.house_buytime):(textField.text = houseBuyTimeStr);
            [self.subDict setObject:model.house_buytime forKey:@"house_buytime"];
        }
    } @catch (NSException *exception) {
        [Window makeToast:exception.description duration:1.0 position:CenterPoint];
    } @finally {
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else {
        cell.backgroundColor = UIColorWithRGBA(248, 248, 248, 1);
    }
}
// tableView头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];

    UIButton *button1 ;
    UIImage *image= [UIImage   imageNamed:@"nav_icon_more_norm"];
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(kScreen_Width-16-image.size.width, 0.0, image.size.width, image.size.height);
    button1.frame = frame;
    [button1 setBackgroundImage:image forState:UIControlStateNormal];
    button1.backgroundColor= [UIColor clearColor];
    [headView addSubview:button1];
    button1.centerY = headView.centerY;
    
    
    MyTextField *textField = [MyTextField new];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = [UIFont systemFontOfSize:13];
    textField.delegate = self;
    if (self.model.has_car && section == 0) {
        if ([[_subDict objectForKey:@"has_car"] length]<=0) {
            if ([self.model.has_car isEqualToString:@"1"]) {
                tempStr = @"是";
            }else{
                tempStr = @"否";
            }
        }else{
            if ([[_subDict objectForKey:@"has_car"] isEqualToString:@"1"]) {
                tempStr = @"是";
            }else{
                tempStr = @"否";
            }
        }
    }
    if (self.model.has_house && section == 1) {
        if ([[_subDict objectForKey:@"has_house"] length]<=0) {
            if ([self.model.has_house isEqualToString:@"1"]) {
                tempStr = @"是";
            }else{
                tempStr = @"否";
            }
        }else{
            if ([[_subDict objectForKey:@"has_house"] isEqualToString:@"1"]) {
                tempStr = @"是";
            }else{
                tempStr = @"否";
            }
        }

    }
    tempStr == nil ?(textField.text = @"否" ):(textField.text = tempStr);

    UILabel * titleLabel = [UILabel new];
    titleLabel.textColor =[UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:13];
    
    textField.leftView = titleLabel;
    titleLabel.text = _dataArray[section][0];

    if ([titleLabel.text isEqualToString:@"是否有车"]) {
        if (!tempStr) {
            [_subDict setObject:@"2" forKey:@"has_car"];
            carOK = YES;
        }else{
            if ([tempStr isEqualToString:@"是"]) {
                [_subDict setObject:@"1" forKey:@"has_car"];
            }else{
                [_subDict setObject:@"2" forKey:@"has_car"];
            }
            carOK = YES;
        }
    }
    if ([titleLabel.text isEqualToString:@"是否有房"]) {
        if (!tempStr) {
            [_subDict setObject:@"2" forKey:@"has_house"];
            houseOK = YES;
        }else{
            if ([tempStr isEqualToString:@"是"]) {
                [_subDict setObject:@"1" forKey:@"has_house"];
            }else{
                [_subDict setObject:@"2" forKey:@"has_house"];
            }
            houseOK = YES;
        }
    }
    
    [headView addSubview:textField];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headView);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width, headView.frame.size.height));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    headView.tag = 100 + section; // tag 值关联哪个section

    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
    [textField addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textField.mas_top);
        make.left.mas_equalTo(textField.mas_left).offset(0);
        make.right.mas_equalTo(textField.mas_right).offset(0);
        make.height.mas_equalTo(textField.mas_height);
    }];
    objc_setAssociatedObject(button, "firstObject", textField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(button, "secondObject", headView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return headView;
}
-(void)click:(UIButton *)buttton{
    
    UITextField * textField = objc_getAssociatedObject(buttton, "firstObject");
    UIView *headView =  objc_getAssociatedObject(buttton, "secondObject");
    UILabel *label = (UILabel *)textField.leftView;
    NSString *title = label.text;
    NSString *message = NSLocalizedString(@"请选择您的信息", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"是", nil);
    NSString *otherButtonTitle1 = NSLocalizedString(@"否", nil);

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"%@",cancelButtonTitle);
    }];

    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"%@",otherButtonTitle);
        textField.text = tempStr = otherButtonTitle;
        NSInteger section = headView.tag - 100;
        flag[section] = 1; // 1->0 0->1
        if ([title isEqualToString:@"是否有车"]) {
            self.model.has_car = @"1";
            [_subDict setObject:@"1" forKey:@"has_car"];
        }
        if ([title isEqualToString:@"是否有房"]) {
            self.model.has_house = @"1";
            [_subDict setObject:@"1" forKey:@"has_house"];
        }
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];

    }];
    UIAlertAction *otherAction1 = [UIAlertAction actionWithTitle:otherButtonTitle1 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"%@",otherButtonTitle1);
        if ([title isEqualToString:@"是否有车"]) {
            self.model.has_car = @"2";

            [_subDict setObject:@"2" forKey:@"has_car"];
        }
        if ([title isEqualToString:@"是否有房"]) {
            self.model.has_house = @"2";
            [_subDict setObject:@"2" forKey:@"has_house"];
        }

        textField.text = tempStr = otherButtonTitle1;
        NSInteger section = headView.tag - 100;
        flag[section] = 0; // 1->0 0->1
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];

    }];
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [alertController addAction:otherAction1];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)tap:(UITapGestureRecognizer *)tap {
    // 获取点击的是哪个分区的头视图
    NSInteger section = tap.view.tag - 100;
    flag[section] ^= 1; // 1->0 0->1
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - textField 代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UILabel *label = (UILabel *)textField.leftView;
    if ([label.text isEqualToString:@"是否有车"]||[label.text isEqualToString:@"是否全款"]||[label.text isEqualToString:@"车辆购买时间"]||[label.text isEqualToString:@"是否有房"]||[label.text isEqualToString:@"是否共有"]||[label.text isEqualToString:@"是否有证"]||[label.text isEqualToString:@"房产性质"]||[label.text isEqualToString:@"房屋类型"]||[label.text isEqualToString:@"是否有房贷"]||[label.text isEqualToString:@"房屋购买时间"]) {
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    UILabel *label = (UILabel *)textField.leftView;
    NSLog(@"%@ %@",label.text,textField.text);
    @try {
        if ([label.text isEqualToString:@"车辆型号"]) {
            carBrandStr = textField.text;
            [self.subDict setObject:textField.text forKey:@"car_brand"];
        }else if ([label.text isEqualToString:@"裸车价格"]){
            carPriceStr = textField.text;
            [self.subDict setObject:textField.text forKey:@"car_nudeprice"];
        }else if ([label.text isEqualToString:@"房屋价格"]){
            housePriceStr = textField.text;
            [self.subDict setObject:textField.text forKey:@"house_price"];
        }else if ([label.text isEqualToString:@"小区名字"]){
            disNameStr = textField.text;
            [self.subDict setObject:textField.text forKey:@"house_district"];
        }
    } @catch (NSException *exception) {
        [Window makeToast:exception.description duration:1.0 position:CenterPoint];
    } @finally {
        
    }
    return YES;
}

#pragma mark - datepicker 代理方法
-(void)selectDate:(UIButton *)button{

    _currentTextField = objc_getAssociatedObject(button, "firstObject");
    
    [self freechoseTime];
}
-(void)ljkBtnClick:(UIButton *)button{
    if (button==_datePicker.lconfirm) {
        [UIView   animateWithDuration:0.8 animations:^{
            [_datePicker   setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 200)];
        }];
       _currentTextField.text = [NSString stringWithFormat:@"%@-%@-%@",_datePicker.year,_datePicker.month,_datePicker.day];
        UILabel *label = (UILabel *)_currentTextField.leftView;
        if ([label.text isEqualToString:@"车辆购买时间"]) {
            carBuyTimeStr = _currentTextField.text;
            [_subDict setObject: _currentTextField.text forKey:@"car_buytime"];
        }
        if ([label.text isEqualToString:@"房屋购买时间"]) {
            houseBuyTimeStr = _currentTextField.text;
            [_subDict setObject: _currentTextField.text forKey:@"house_buytime"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_datePicker  setHidden:YES];
        });
    }
    
}
//选择时间
-(void)freechoseTime{
    [_datePicker  setHidden:NO];
    [self.view endEditing:YES];
    [UIView   animateWithDuration:0.8 animations:^{
        [_datePicker   setFrame:CGRectMake(0, kScreen_Height-200-64-0.08*kScreen_Height, kScreen_Width,200)];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
