
//
//  FillinViewCell.m
//  网众
//
//  Created by WZ on 16/4/5.
//  Copyright © 2016年 lihegong. All rights reserved.
//

#import "FillinViewCell.h"
#import "NIDropDown.h"
#import "DepartmentModel.h"
#import "AreaModel.h"
@interface FillinViewCell ()<NIDropDownDelegate>{
    NIDropDown *dropDown;
    NSArray *candidateArray;
    NSString *selfKey;
}
@property (nonatomic,copy) NSString * String;
@end
@implementation FillinViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [UILabel new];
        self.titleLabel.textColor =[UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.titleLabel];
        self.inputTextField = [MyTextField new];
        self.inputTextField.leftView = self.titleLabel;
        
        self.inputTextField.textAlignment = NSTextAlignmentRight;
        self.inputTextField.leftViewMode = UITextFieldViewModeAlways;
        self.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;

        self.inputTextField.font = [UIFont systemFontOfSize:13];
        
        [self addSubview:self.inputTextField];
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(kScreen_Width, self.frame.size.height));
        }];
        _downButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //[_downButton setBackgroundColor:MyBlueColor];
        objc_setAssociatedObject(_downButton, "firstObject", _inputTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [_downButton addTarget:self action:@selector(dropDown:) forControlEvents:(UIControlEventTouchUpInside)];
        [_inputTextField addSubview:_downButton];
        [_downButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_inputTextField.mas_left);
            make.top.mas_equalTo(_inputTextField.mas_top);
            make.width.mas_equalTo(kScreen_Width-5);
            make.height.mas_equalTo(_inputTextField.mas_height);
         }];
        if ([reuseIdentifier isEqualToString:@"Cell011"]) {
            _imgV = [[imgLayoutvView alloc] init];
            _imgV.flag = 1;
            _imgV.tag = 4444;
            [self.contentView addSubview:_imgV];
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(10);
                make.left.mas_equalTo(_titleLabel.mas_right).offset(25);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
                //make.height.mas_equalTo(100);
                make.right.mas_equalTo(self.contentView.mas_right).offset(5);
            }];
        }
        
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setTitle:(NSString *)title{
    _title = title;
     self.inputTextField.tag = 0;
    [self.titleLabel setSize:[self sizeWithString:title fontSize:13]];
    self.titleLabel.text = title;
    NSInteger index = 0 ;
    if ([self.title isEqualToString:@"车辆购买时间"]||[self.title isEqualToString:@"房屋购买时间"]) {
        [self.downButton removeTarget:self action:@selector(dropDown:) forControlEvents:UIControlEventTouchUpInside];
    }

    index = [[NSString stringWithFormat:@"100%ld%ld",(long)_indexPath.section,(long)_indexPath.row] integerValue];
    self.inputTextField.tag = index;
    if ([title isEqualToString:@"个人姓名"]||[title isEqualToString:@"身份证号"]||[title isEqualToString:@"手机号码"]||[title isEqualToString:@"资金需求"]||[title isEqualToString:@"利率要求"]||[title isEqualToString:@"图片"]||[title isEqualToString:@"备注"]||[title isEqualToString:@"车辆型号"]||[title isEqualToString:@"裸车价格"]||[title isEqualToString:@"房屋价格"]||[title isEqualToString:@"小区名字"]||[title isEqualToString:@"查询次数"]||[title isEqualToString:@"工资金额"]||[title isEqualToString:@"社保缴纳金额"]||[title isEqualToString:@"公积金缴纳金额"]||[title isEqualToString:@"投保公司"]||[title isEqualToString:@"保险年限"]||[title isEqualToString:@"年缴纳金额"]||[title isEqualToString:@"从事行业"]||[title isEqualToString:@"生意流水"]||[title isEqualToString:@"负债金额"]) {
        if ([title isEqualToString:@"手机号码"]||[title isEqualToString:@"资金需求"]||[title isEqualToString:@"利率要求"]||[title isEqualToString:@"裸车价格"]||[title isEqualToString:@"房屋价格"]||[title isEqualToString:@"查询次数"]||[title isEqualToString:@"工资金额"]||[title isEqualToString:@"社保缴纳金额"]||[title isEqualToString:@"公积金缴纳金额"]||[title isEqualToString:@"保险年限"]||[title isEqualToString:@"年缴纳金额"]||[title isEqualToString:@"生意流水"]||[title isEqualToString:@"负债金额"]) {
            if([title isEqualToString:@"备注"]){
                [_inputTextField setValue:[UIFont boldSystemFontOfSize:10] forKeyPath:@"_placeholderLabel.font"];
            }
            if ([title isEqualToString:@"手机号码"]||[title isEqualToString:@"查询次数"]) {
                _inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            }else{
                _inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
                _inputTextField.rightViewMode = UITextFieldViewModeAlways;
                _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                UILabel *label = [UILabel new];
                if ([title isEqualToString:@"保险年限"]) {
                    label.text = @"年";
                }else if([title isEqualToString:@"利率要求"]){
                    label.text = @"%";
                }else if([title isEqualToString:@"负债金额"]||[title isEqualToString:@"资金需求"]){
                    label.text = @"万元";
                }else if([title isEqualToString:@"裸车价格"]){
                    label.text = @"万元";
                }else if([title isEqualToString:@"房屋价格"]){
                    label.text = @"万元";
                }else{label.text = @"元";}
                label.font = [UIFont systemFontOfSize:13];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                }];
                _inputTextField.rightView = label;
            }

        }
        [_downButton removeFromSuperview];
        if ([title isEqualToString:@"资金需求"]) {
        }
        if ([title isEqualToString:@"裸车价格"]) {
            self.inputTextField.placeholder = @"请输入裸车价格";
        }
        if ([title isEqualToString:@"房屋价格"]) {
            self.inputTextField.placeholder = @"请输入房屋价格";
        }
        if ([title isEqualToString:@"小区名字"]) {
            self.inputTextField.placeholder = @"请输入小区名字";
        }
        if([title isEqualToString:@"图片"]){
            [_inputTextField removeFromSuperview];
            _titleLabel.text = @"图片";
            self.height = 62.33;
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.centerY.mas_equalTo(self.contentView.mas_centerY);
            }];
            if (!_imgV) {
                if (_imgArr) {
                    _imgV.picPathStringsArray = _imgArr;
                    self.height = _imgV.height+20;
                    //NSLog(@"%f",self.height);
                }
            }else{
                if (_imgArr) {
                    _imgV.picPathStringsArray = _imgArr;
                    self.height = _imgV.height+20;
                    //NSLog(@"%f",self.height);
                }
            }
        }
    }else{
        UIButton *button ;
        UIImage *image= [UIImage   imageNamed:@"nav_icon_more_norm"];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        button.frame = frame;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.backgroundColor= [UIColor clearColor];
        self.accessoryView= button;
    }

    if([title isEqualToString:@"省"]){
        if ([_dataDict objectForKey:@"_areaModel"]) {
            AreaModel *model = [AreaModel mj_objectWithKeyValues:[_dataDict objectForKey:@"_areaModel"]];
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *pro = [AreaData mj_objectArrayWithKeyValuesArray:model.data];
            for (AreaData *str in pro) {
                NSDictionary *dict = @{str.label:str.value};
                [arr addObject:dict];
            }
            model != nil?(candidateArray = arr):(candidateArray = @[@"四川省"]);
            _String == nil?(self.inputTextField.text =  @"四川省"):(self.inputTextField.text = _String);
        }
        selfKey = @"residence_province";
        _String == nil?(self.inputTextField.text = @"四川省"):(self.inputTextField.text = _String);

    }
    if([title isEqualToString:@"市"]){
        selfKey = @"residence_city";
        if ([_dataDict objectForKey:@"_children"]) {
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *pro = [AreaChildren mj_objectArrayWithKeyValuesArray:[_dataDict objectForKey:@"_children"]];
            for (AreaChildren *str in pro) {
                NSDictionary *dict = @{str.label:str.value};
                [arr addObject:dict];
            }
            pro != nil?(candidateArray = arr):(candidateArray = @[@"成都市"]);
            _String == nil?(self.inputTextField.text = [arr[0] allKeys][0]):(self.inputTextField.text = _String);
        }else{
            AreaModel *model = [AreaModel mj_objectWithKeyValues:[_dataDict objectForKey:@"_areaModel"]];
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *pro = [AreaData mj_objectArrayWithKeyValuesArray:model.data];
            if ([_dataDict objectForKey:@"_areaModel"]) {
                AreaData *data = pro[22];
                for (AreaChildren *str in data.children) {
                    NSDictionary *dict = @{str.label:str.value};
                    [arr addObject:dict];
                }
                model != nil?(candidateArray = arr):(candidateArray = @[@"成都市"]);
                _String == nil?(self.inputTextField.text = @"成都市"):(self.inputTextField.text = _String);
            }
            if (_baseModel.residence_city) {
                [arr removeAllObjects];
                AreaData *data = pro[[_baseModel.residence_province integerValue]-1];
                for (AreaChildren *str in data.children) {
                    NSDictionary *dict = @{str.label:str.value};
                    [arr addObject:dict];
                }
                candidateArray = arr ;
                _String == nil?(self.inputTextField.text = @"成都市"):(self.inputTextField.text = _String);
            }
        }
    }
    
    if([title isEqualToString:@"婚姻状况"]){
        selfKey = @"marriage";
        _String == nil?(self.inputTextField.text = @"已婚"):(self.inputTextField.text = _String);
        candidateArray = @[@{@"已婚":@"1"},@{@"未婚":@"2"},@{@"离异":@"3"},@{@"丧偶":@"4"}];
    }
    
    if([title isEqualToString:@"建议类型"]){
        selfKey = @"loan_type";
        candidateArray = @[@{@"信用":@"1"},@{@"车抵":@"2"},@{@"房抵":@"3"},@{@"无":@"4"}];
        _String == nil?(self.inputTextField.text = @"信用"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"接收部门"]){
        if (self.flag == 10) {
            [self.downButton setUserInteractionEnabled:NO];
        }else{
            [self.downButton setUserInteractionEnabled:YES];
        }
        selfKey = @"department_id_to";
        candidateArray = @[@""];
        if (_dataDict) {
            DepartmentModel *model = [DepartmentModel mj_objectWithKeyValues:[_dataDict objectForKey:@"_depModel"]];
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *pro = [DepTs mj_objectArrayWithKeyValuesArray:model.data];
            for (DepTs *str in pro) {
                NSDictionary *dict = @{str.department_name:str.department_id};
                [arr addObject:dict];
            }
            model != nil?(candidateArray = arr):(candidateArray = @[@""]);
            _String == nil?(self.inputTextField.text =  @""):(self.inputTextField.text = _String);
        }
        _String == nil?(self.inputTextField.text =  @""):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"客户来源"]){
        if (self.flag == 10) {
            [self.downButton setUserInteractionEnabled:NO];
        }else{
            [self.downButton setUserInteractionEnabled:YES];
        }
        selfKey = @"client_source";
        candidateArray = @[@{@"上门咨询":@"1"},@{@"电销":@"2"},@{@"客户转介绍":@"3"},@{@"同行转介绍":@"4"},@{@"网销":@"5"},@{@"外出展业":@"6"}];
        _String == nil?(self.inputTextField.text = @"上门咨询"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"是否有车"]){
        selfKey = @"has_car";
        candidateArray = @[@{@"是":@"1"},@{@"否":@"2"}];
        _String == nil?(self.inputTextField.text = @"无"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"是否全款"]){
        selfKey = @"car_buyonce";
        candidateArray = @[@{@"是":@"1"},@{@"否":@"2"}];
        _String == nil?(self.inputTextField.text = @"是"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"车辆购买时间"]){
        selfKey = @"house_buytime";
        candidateArray = @[@"UIPickView",@"UIPickView",@"UIPickView"];
    }
    
    if([title isEqualToString:@"是否有房"]){
        selfKey = @"has_house";
        candidateArray = @[@{@"是":@"1"},@{@"否":@"2"}];
       _String == nil?(self.inputTextField.text = @"无"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"是否共有"]){
        selfKey = @"house_togather";
        candidateArray = @[@{@"是":@"1"},@{@"否":@"2"}];
        _String == nil?(self.inputTextField.text = @"是"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"是否有证"]){
        selfKey = @"house_paperwork";
        candidateArray = @[@{@"双证齐全":@"1"},@{@"有产权证无土地证":@"2"},@{@"有土地证无产权证":@"3"}];
        _String == nil?(self.inputTextField.text = @"双证齐全"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"房产性质"]){
        selfKey = @"house_kind";
        candidateArray = @[@{@"商品房":@"1"},@{@"经适房":@"2"},@{@"小产权房":@"3"},@{@"其他":@"4"}];
        _String == nil?(self.inputTextField.text = @"商品房"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"房屋类型"]){
        selfKey = @"house_style";
        candidateArray = @[@{@"公寓":@"1"},@{@"商铺":@"2"},@{@"别墅":@"3"},@{@"写字楼":@"4"},@{@"厂房":@"5"},@{@"其他":@"6"}];
       _String == nil?(self.inputTextField.text = @"公寓"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"是否有房贷"]){
        selfKey = @"house_mortgage";
        candidateArray = @[@{@"是":@"1"},@{@"否":@"2"}];
        _String == nil?(self.inputTextField.text = @"是"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"房屋购买时间"]){
        selfKey = @"house_buytime";
        candidateArray = @[@"",@"",@"",@"",@""];
    }
    
    if([title isEqualToString:@"征信情况"]){
        selfKey = @"agency_type";
        candidateArray = @[@{@"无信用卡或贷款":@"1"},@{@"信用良好,无逾期":@"2"},@{@"一年内逾期少于三次且少于90天":@"3"},@{@"一年内逾期超过3次或超过90天":@"4"}];
       _String == nil?(self.inputTextField.text = @"无信用卡或贷款"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"职业身份"]){
        selfKey = @"job_type";
        candidateArray = @[@{@"上班族":@"1"},@{@"企业主":@"2"},@{@"无固定职业":@"3"}];
       _String == nil?(self.inputTextField.text = @"上班族"):(self.inputTextField.text = _String);
    }
    
    if([title isEqualToString:@"工作单位"]){
        selfKey = @"company_type";
        candidateArray = @[@{@"公务员/事业单位":@"1"},@{@"国企单位":@"2"},@{@"世界500强企业":@"3"},@{@"上市公司":@"4"},@{@"普通企业":@"5"}];
       _String == nil?(self.inputTextField.text = @"普通企业"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"工资发放"]){
        selfKey = @"salary_type";
        candidateArray = @[@{@"现金工资":@"1"},@{@"打卡工资":@"2"}];
        _String == nil?(self.inputTextField.text = @"打卡工资"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"是否有社保"]){
        selfKey = @"has_guarantee_slip";
        candidateArray = @[@{@"有":@"1"},@{@"无":@"2"}];
        _String == nil?(self.inputTextField.text = @"无"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"社保缴纳形式"]){
        selfKey = @"social_security_contribute";
        candidateArray = @[@{@"单位缴纳":@"1"},@{@"自己缴纳":@"2"}];
       _String == nil?(self.inputTextField.text = @"单位缴纳"):(self.inputTextField.text = _String);

    }
    
    if([title isEqualToString:@"是否有公积金"]||[title isEqualToString:@"是否有保单"]||[title isEqualToString:@"是否有负债"]){
        selfKey = @"has_house_fund";
        candidateArray = @[@{@"有":@"1"},@{@"无":@"2"}];
        _String == nil?(self.inputTextField.text = @"无"):(self.inputTextField.text = _String);
        
    }
    
    if([title isEqualToString:@"是否有保单"]){
        selfKey = @"has_guarantee_slip";
        candidateArray = @[@{@"有":@"1"},@{@"无":@"2"}];
        _String == nil?(self.inputTextField.text = @"无"):(self.inputTextField.text = _String);
        
    }
    
    if([title isEqualToString:@"是否有负债"]){
        selfKey = @"has_debt";
        candidateArray = @[@{@"有":@"1"},@{@"无":@"2"}];
        _String == nil?(self.inputTextField.text = @"无"):(self.inputTextField.text = _String);
        
    }
    
    if([title isEqualToString:@"负债类型"]){
        selfKey = @"debt_type";
        candidateArray = @[@{@"抵押贷款":@"1"},@{@"按揭贷款":@"2"},@{@"信用卡贷款":@"3"}];
    }
    
    if ([[self.baseModel mj_keyValues] objectForKey:selfKey]) {
        //NSLog(@"%@",selfKey);

        if ([selfKey isEqualToString:@"department_id_to"]) {
            _String == nil?(self.inputTextField.text = self.baseModel.department_name_to):(self.inputTextField.text = _String);
        }else{
            if ([selfKey isEqualToString:@"residence_city"]) {
                _String == nil?(self.inputTextField.text = _baseModel.residence_city_name):(self.inputTextField.text = _String);
            }
            NSString *str = [[self.baseModel mj_keyValues] objectForKey:selfKey];
            for (NSDictionary *dict in candidateArray) {
                [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([obj isEqualToString:str]) {
                        self.inputTextField.text = key;
                    }
                }];
            }
        }
    }
    if ([[self.assetsModel mj_keyValues] objectForKey:selfKey]) {
        //NSLog(@"%@",selfKey);
        NSString *str = [[self.assetsModel mj_keyValues] objectForKey:selfKey];
        if (![selfKey isEqualToString:@"house_buytime"]) {
            for (NSDictionary *dict in candidateArray) {
                [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([obj isEqualToString:str]) {
                        self.inputTextField.text = key;
                    }
                }];
            }
        }else{
            self.inputTextField.text = _assetsModel.car_buytime;
            //NSLog(@"%@%@",selfKey,@"值为空");
        }
    }
    if ([[self.creditModel mj_keyValues] objectForKey:selfKey]) {
       // NSLog(@"%@",selfKey);
        NSString *str = [[self.creditModel mj_keyValues] objectForKey:selfKey];
        for (NSDictionary *dict in candidateArray) {
            [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:str]) {
                    self.inputTextField.text = key;
                }
            }];
        }
    }
}

- (CGSize)sizeWithString:(NSString *)str fontSize:(float)fontSize
{
    CGSize constraint = CGSizeMake(self.frame.size.width-40, fontSize+2);
    
    CGSize tempSize;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize retSize = [str boundingRectWithSize:constraint
                                       options:
                      NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attribute
                                       context:nil].size;
    tempSize = retSize;
    return tempSize ;
}
-(void)setBaseModel:(User_Base_Info *)baseModel{
    _baseModel = baseModel;
}
-(void)setAssetsModel:(User_Assets_Info *)assetsModel{
    _assetsModel = assetsModel;
}
-(void)setCreditModel:(User_Credit_Info *)creditModel{
    _creditModel = creditModel;
}

#pragma mark - 给textfield 添加一个下拉列表 以及相关的方法
-(void)dropDown:(UIButton *)button{
    @try {
        [self endEditing:YES];
        //UITextField * textField = objc_getAssociatedObject(button, "firstObject");
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in candidateArray) {
            [arr addObject:dict.allKeys[0]];
        }
        for (UIView* next = [self superview]; next; next = next.superview) {
            UIResponder* nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UITableView class]]) {
                for(NSInteger i=0 ;i< [[(UIView *)nextResponder subviews] count];i++) {
                    UIView *down = [(UIView *)nextResponder subviews][i];
                    if ([[down class] isSubclassOfClass:[NIDropDown class]]) {
                        if ((NIDropDown*)down  == dropDown) {
                        }else{
                            [(NIDropDown*)down removeFromSuperview];
                            down = nil;
                        }
                    }
                }
            }
        }
        if(dropDown == nil) {
            CGFloat f;
            if(arr.count == 0){f=0;}else{
                if(arr.count<4){
                    f = 44 * arr.count;
                }else{
                    f = 44*4;
                }
            }
            dropDown = [[NIDropDown alloc]showDropDown:button :&f :arr :nil :@"down"];
            dropDown.delegate = self;
            __weak __typeof__(self) weakSelf = self;
            [dropDown setBackText:^(NSString *text) {
                __strong __typeof__(weakSelf) sself = weakSelf;
                weakSelf.String = text;
                if (weakSelf.callBackHandler) {
                    for (NSDictionary *dict in sself->candidateArray) {
                        if ([dict objectForKey:text]) {
                            NSDictionary *sub = [NSDictionary dictionaryWithObject:dict forKey:sself->selfKey];
                            weakSelf.callBackHandler(sub);
                        }
                    }
                }
            }];
        }
        else {
            if (dropDown.superview) {
                [dropDown hideDropDown:button];
                
            }else{
                CGFloat f;
                if(arr.count == 0){f=0;}else{
                    if(arr.count>2){f = 160;}else if(arr.count == 1){f = 40;} else{f = 80;}
                    if(arr.count == 3)f=80;
                }
                dropDown = [[NIDropDown alloc]showDropDown:button :&f :arr :nil :@"down"];
                dropDown.delegate = self;
                __weak __typeof__(self) weakSelf = self;
                [dropDown setBackText:^(NSString *text) {
                    weakSelf.String = text;
                    __strong __typeof__(weakSelf) sself = weakSelf;
                    if (weakSelf.callBackHandler) {
                        for (NSDictionary *dict in sself->candidateArray) {
                            if ([dict objectForKey:text]) {
                                NSDictionary *sub = [NSDictionary dictionaryWithObject:dict forKey:sself->selfKey];
                                weakSelf.callBackHandler(sub);
                            }
                        }
                    }
                }];
            }
            //[self rel];
        }

    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
-(void)rel{
    //    [dropDown release];
    [dropDown removeFromSuperview];
    dropDown = nil;
}
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
}
-(NSMutableDictionary *)dataDict{
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)textFieldEditing:(NSIndexPath *)indexPath{
    _indexPath = indexPath  ;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect adjustedFrame = self.accessoryView.frame;
    adjustedFrame.origin.x += 5.0f;
    self.accessoryView.frame = adjustedFrame;
}
+(CGFloat)cellHeightWith:(NSMutableArray *)arr{
    FillinViewCell *cell = [[FillinViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell011"];
    cell.imgV.picPathStringsArray = arr;
    [cell.imgV setNeedsDisplay];
    
    //[cell layoutIfNeeded];
    return cell.imgV.height+20;
}
@end
