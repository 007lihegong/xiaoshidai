//
//  BaseInfoController.m
//  xiaoshidai
//
//  Created by XSD on 16/9/27.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "BaseInfoController.h"
#import "FillinViewCell.h"
#import "NIDropDown.h"
#import "DepartmentModel.h"
#import "AreaModel.h"
#import "AddPictureCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "UITextField+RYNumberKeyboard.h"

@interface BaseInfoController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSString * nameStr;
    NSString * idNumStr;
    NSString * phoneStr;
    NSString * appCountStr;
    NSString * appRateStr;
    NSString * notesStr;
    NSString * picIdStr;
    //多图
    int imgpage;
    NSMutableArray *imgGroupArr;//多图数组
    int moreImgStaus;
    NSString *moreImgStr;

}
@property (nonatomic,strong) NSMutableArray *baseInfoArray;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *placeHolderArray;
@property (nonatomic,strong) DepartmentModel *depModel;
@property (nonatomic,strong) AreaModel *areaModel;
@property (nonatomic,strong) NSArray *children;
@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,strong) NSMutableArray * picIDs;




@end

@implementation BaseInfoController
-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self subDict];
    [self picIDs];
    _picIDs = [NSMutableArray array];
    imgGroupArr = [NSMutableArray array];
    @try {
        if (self.model.other_pic) {
            self.picIDs = [[self.model.other_pic componentsSeparatedByString:@","] mutableCopy];
            [_subDict setObject:[self.picIDs componentsJoinedByString:@","] forKey:@"other_pic"];
            [_subDict setObject:self.model.realname forKey:@"realname"];
            [_subDict setObject:self.model.id_number forKey:@"id_number"];
            [_subDict setObject:self.model.phone forKey:@"phone"];
            [_subDict setObject:self.model.residence_province forKey:@"residence_province"];
            [_subDict setObject:self.model.residence_city forKey:@"residence_city"];
            [_subDict setObject:self.model.marriage forKey:@"marriage"];
            [_subDict setObject:self.model.apply_amount forKey:@"apply_amount"];
            [_subDict setObject:self.model.apply_rate forKey:@"apply_rate"];
            [_subDict setObject:self.model.loan_type forKey:@"loan_type"];
            [_subDict setObject:self.model.department_id_to forKey:@"department_id_to"];
            [_subDict setObject:self.model.client_source forKey:@"client_source"];
            [_subDict setObject:self.model.notes forKey:@"notes"];
        }
    } @catch (NSException *exception) {
        [Window makeToast:exception.description duration:1.0 position:CenterPoint];
    } @finally {
        
    }
    self.view.frame  =CGRectMake(0, 0, kScreen_Width, kScreen_Height);
    NSArray *array =@[@"个人姓名",@"身份证号",@"手机号码",@"省",@"市",@"婚姻状况",@"资金需求",@"利率要求",@"建议类型",
                      @"接收部门",@"客户来源",@"图片",@"备注"];
    NSArray *placeHolders =  @[@"姓名",@"身份证号",@"手机号码",@"省",@"市",@"婚姻状况",@"资金需求",@"请输入月利率", @"建议类型",@"接收部门", @"客户来源",@"图片",@"车辆/房屋月供金额,详细征信情况,亲属是否知晓等"];
    self.placeHolderArray = [NSMutableArray arrayWithArray:placeHolders];
    self.baseInfoArray = [array mutableCopy];
    [self tableView];


}
-(void)getdepartment_id{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    
    [LCProgressHUD showLoading:nil];
 
    [self post:Dispatch parameters:param success:^(id dic) {

        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD hide];
            _depModel = [DepartmentModel mj_objectWithKeyValues:dic];
            NSLog(@"%@",_depModel.msg);
            NSIndexPath *path = [NSIndexPath indexPathForRow:9 inSection:0];

            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationNone)];
        }else {
            NSString *msg = dic[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {

    }];
    [self post:Area parameters:param success:^(id dic) {
        if ([dic[@"code"] intValue]==0) {
            [LCProgressHUD hide];
            _areaModel = [AreaModel mj_objectWithKeyValues:dic];
            NSLog(@"msg --- %@",_areaModel.msg);
            NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];
            NSIndexPath *path1 = [NSIndexPath indexPathForRow:4 inSection:0];
            if (self.model.residence_city) {
                AreaData *citys = _areaModel.data[[self.model.residence_province integerValue]-1];
                _children = citys.children;
            }
            [self.tableView reloadRowsAtIndexPaths:@[path,path1] withRowAnimation:(UITableViewRowAnimationNone)];
        }else {
            NSString *msg = dic[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
-(NSMutableDictionary *)subDict{
    if (!_subDict) {
        _subDict = [NSMutableDictionary dictionary];
    }
    return _subDict;
}
#pragma mark - 创建tableView
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44, kScreen_Width, kScreen_Height-64-44) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        [_tableView registerClass:[FillinViewCell class] forCellReuseIdentifier:@"FillinViewCell"];
        [_tableView registerClass:[FillinViewCell class] forCellReuseIdentifier:@"Cell011"];
        [_tableView registerClass:[AddPictureCell class] forCellReuseIdentifier:@"Cell011"];
        [self.view addSubview:_tableView];
        [self initNextButton];
        [self getdepartment_id];

    }
    return _tableView;
}
-(void)initNextButton{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];

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
        make.top.mas_equalTo(footView.mas_top).offset(-10);
    }];
    self.tableView.tableFooterView = footView;
}
-(void)next:(UIButton *)button{
    [self.view endEditing:YES];
    if (![XYString isBlankString:picIdStr]) {
        [self.subDict setObject:picIdStr forKey:@"other_pic"];
    }
    @try {
        if (!_subDict) {
            [LCProgressHUD showMessage:@"请填写基本信息"];
        }else{
            NSString *str = [NSString new];
            if ([[_subDict objectForKey:@"realname"] length]<=0) {
                str = @"请填写姓名";
                [LCProgressHUD showMessage:str];
            }else if ([[_subDict objectForKey:@"id_number"] length]<=0){
                str = @"请填写身份证号";
                [LCProgressHUD showMessage:str];
            }else if ([[_subDict objectForKey:@"phone"] length]<=0){
                str = @"请填写手机号码";
                [LCProgressHUD showMessage:str];
            }else if ([[_subDict objectForKey:@"department_id_to"] length]<=0){
                    str = @"请选择接收部门";
                    [LCProgressHUD showMessage:str];
            }else{
                if (![_subDict objectForKey:@"residence_province"]){
                    self.model.residence_province == nil?[_subDict  setObject:@"23" forKey:@"residence_province"]:[_subDict setObject:_model.residence_province forKey:@"residence_province"];
                }else{
                    if (![[_subDict objectForKey:@"residence_province"] isEqualToString:@"23"]) {
                        AreaChildren *child = _children[0];
                        [_subDict  setObject:child.value forKey:@"residence_city"];
                        NSLog(@"%@",child);
                    }else{
                        }
                }
                if (![_subDict objectForKey:@"residence_city"]){
                    self.model.residence_city == nil?[_subDict  setObject:@"275" forKey:@"residence_city"]:[_subDict setObject:_model.residence_city forKey:@"residence_city"];
                }else{
                    //AreaChildren *child = _children[[_model.residence_city integerValue]];
                    for ( AreaChildren *child in _children) {
                        if ([child.value isEqualToString:_model.residence_city]) {
                            [_subDict  setObject:child.value forKey:@"residence_city"];
                        }
                    }
                }
                if (![_subDict objectForKey:@"marriage"]){
                    [_subDict  setObject:@"1" forKey:@"marriage"];
                }
                if (![_subDict objectForKey:@"loan_type"]){
                    [_subDict  setObject:@"1" forKey:@"loan_type"];
                }
                if (![_subDict objectForKey:@"client_source"]){
                    [_subDict  setObject:@"1" forKey:@"client_source"];
                }
                NSLog(@"---------------------------------------------");
                NSLog(@"%@",[_subDict mj_JSONString]);
                SCNavTabBarController * nav =  (SCNavTabBarController *)self.parentViewController;
                nav.navTabBar.flag = YES;
                UIButton *sender = nav.navTabBar.items[1];
                UIButton *sender0 = nav.navTabBar.items[0];
                UIButton *sender2 = nav.navTabBar.items[2];
                sender.enabled = YES;
                sender0.enabled = YES;
                sender2.enabled = NO;
                if (!self.isJump) {
                    [nav.navTabBar itemPressed:sender];
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
        [LCProgressHUD showMessage:exception.description];
    } @finally {
        
    }
}
-(NSMutableArray *)baseInfoArray{
    if (!_baseInfoArray) {
        _baseInfoArray = [NSMutableArray array];
    }
    return _baseInfoArray;
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
#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.baseInfoArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak __typeof(&*self)weakSelf = self;
    //__strong __typeof(&*weakSelf)SSelf = weakSelf;
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];//以indexPath来唯一确定cell
    if ([CellIdentifier isEqualToString:@"Cell011"]) {
        AddPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//#warning model未修改
        if (self.model) {
            cell.imgArr = [_model.other_pic_show mutableCopy];
        }
        __weak typeof(cell) weakCell = cell;
        [cell setPidStrBlock:^(NSString * picIds ,NSMutableArray *images, NSMutableArray * ids) {
            NSLog(@"%@",picIds);
            __strong typeof(weakSelf) sself = weakSelf;
            sself->picIdStr = picIds;
            NSMutableArray * array = [NSMutableArray array];
            [images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Other_Pic_Show *model = [[Other_Pic_Show alloc] init];
                model.path = obj;
                model.id = ids[idx];
                [array addObject:model];
            }];
            if (weakSelf.model) {
                weakSelf.model.other_pic_show = [array copy];
            }else{
                weakCell.imgArr = [array copy];
            }
        }];
        return cell;
    }else{
        FillinViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //出列可重用的cell
        if (cell == nil) {
            cell = [[FillinViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.indexPath = indexPath;
            cell.inputTextField.delegate = self;
            cell.inputTextField.placeholder = _placeHolderArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.flag == 10) {
            cell.flag = 10;
        }
        if (_depModel) {
            [cell.dataDict setObject:_depModel forKey:@"_depModel"];
        }
        if (_areaModel) {
            [cell.dataDict setObject:_areaModel forKey:@"_areaModel"];
        }
        if (_children) {
            [cell.dataDict setObject:_children forKey:@"_children"];
        }
        
        if (self.model) {
            cell.baseModel = self.model;
            NSMutableArray *arr = [NSMutableArray array];
            for (Other_Pic_Show *model in _model.other_pic_show) {
                [arr addObject:model.path];
            }
            if ([self.images count]>0) {
                cell.imgArr = self.images;
            }else{
                self.images = arr;
                cell.imgArr = arr;
            }
        }else{
            if (self.images) {
                cell.imgArr = self.images;
            }else{
                cell.imgArr = [@[]mutableCopy];
            }
        }
        cell.title = _baseInfoArray[indexPath.row];
        
        if (self.model) {
            [self fillCell:cell.inputTextField withModel:self.model];
        }
        if ([cell.title isEqualToString:@"身份证号"]||[cell.title isEqualToString:@"手机号码"]) {
            if ([cell.title isEqualToString:@"身份证号"]) {
                cell.inputTextField.ry_inputType = RYIDCardInputType;
            }else{
                cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            }
            [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        //__weak typeof(cell)weakCell = cell;
//        if ([cell.title isEqualToString:@"图片"]) {
//            [cell.imgV setDeleId:^(id obj) {
//                UIButton *btn = (UIButton *)obj;
//                [weakSelf.images removeObjectAtIndex:btn.tag-100];
//                [weakSelf.picIDs removeObjectAtIndex:btn.tag-100];
//                if (weakSelf.images.count == 0) {
//                    weakSelf.model = nil;
//                }
//                NSLog(@"images=%@  cell.img = %@",weakSelf.images,weakSelf.picIDs);
//                [weakSelf.subDict setObject:[weakSelf.picIDs componentsJoinedByString:@","] forKey:@"other_pic"];
//                NSIndexPath *path = [NSIndexPath indexPathForRow:11 inSection:0];
//                [weakSelf.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//                
//                // [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
//            }];
//            [cell.imgV setPresentAlert:^(id s) {
//                [weakSelf tableView:weakSelf.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:11 inSection:0]];
//            }];
//            
//        }
        
        [cell setCallBackHandler:^(NSDictionary *dict) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSDictionary *ddd = [dict allValues][0];
            NSLog(@"*-*-%@-%@-*-*",[ddd allValues][0],[dict allKeys][0]);
            NSString * key = [ddd allKeys][0];
            NSString * value = [ddd allValues][0];
            if ([[dict allKeys][0] isEqualToString:@"residence_province"]) {
                weakSelf.model.residence_province = value;
                weakSelf.model.residence_province_name = key;
            }
            if ([[dict allKeys][0]  isEqualToString:@"residence_city"]) {
                weakSelf.model.residence_city = value;
                weakSelf.model.residence_city_name = key;
            }
            if ([[dict allKeys][0]  isEqualToString:@"marriage"]) {
                weakSelf.model.marriage = value;
            }
            if ([[dict allKeys][0]  isEqualToString:@"loan_type"]) {
                weakSelf.model.loan_type = value;
            }
            if ([[dict allKeys][0]  isEqualToString:@"residence_city"]) {
                weakSelf.model.residence_city = value;
            }
            [weakSelf.subDict setObject:[ddd allValues][0] forKey:[dict allKeys][0]];
            if ([strongSelf->_baseInfoArray[indexPath.row] isEqualToString:@"省"]) {
                NSDictionary *tem = [dict allValues][0];
                [strongSelf updateCityArray:[tem allKeys][0]];
            }
        }];
        return cell;
    }
}
-(void)fillCell:(MyTextField *)textField withModel:(User_Base_Info *)model{
    UILabel *label = (UILabel *)textField.leftView;
    @try {
        if ([label.text isEqualToString:@"个人姓名"]) {
            nameStr == nil?(textField.text = model.realname):(textField.text = nameStr);
            [self.subDict setObject:model.realname forKey:@"realname"];
        }else if ([label.text isEqualToString:@"身份证号"]){
            idNumStr == nil?(textField.text = model.id_number):(textField.text = idNumStr);
            [self.subDict setObject:model.id_number forKey:@"id_number"];
        }else if ([label.text isEqualToString:@"手机号码"]){
            phoneStr == nil?(textField.text = model.phone):(textField.text = phoneStr);
            [self.subDict setObject:model.phone forKey:@"phone"];
        }else if ([label.text isEqualToString:@"资金需求"]){
            appCountStr == nil?(textField.text = model.apply_amount):(textField.text = appCountStr);
            [self.subDict setObject:model.apply_amount forKey:@"apply_amount"];
        }else if ([label.text isEqualToString:@"利率要求"]){
            appRateStr == nil?(textField.text = model.apply_rate):(textField.text = appRateStr);
            [self.subDict setObject:model.apply_rate forKey:@"apply_rate"];
        }else if ([label.text isEqualToString:@"备注"]){
            notesStr == nil?(textField.text = model.notes):(textField.text = notesStr);
            [self.subDict setObject:model.notes forKey:@"notes"];
        }else if ([label.text isEqualToString:@"接收部门"]){
            [self.subDict setObject:model.department_id_to forKey:@"department_id_to"];
        }
    } @catch (NSException *exception) {
        [Window makeToast:exception.description duration:1.0 position:CenterPoint];
    } @finally {
        
    }
}
- (void)textFieldDidChange:(UITextField *)textField
{
    UILabel *labei = (UILabel *)textField.leftView;
    if ([labei.text isEqualToString:@"身份证号"]) {
        if (textField.text.length > 18) {
            textField.text = [textField.text substringToIndex:18];
        }
    }
    if ([labei.text isEqualToString:@"手机号码"]) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
}
-(void)updateCityArray:(NSString *)str{
    for (AreaData *data in _areaModel.data) {
        if ([data.label isEqualToString:str]) {
            _children = data.children;
            AreaChildren *child = _children[0];
            [_subDict setObject:child.value forKey:@"residence_city"];
            NSIndexPath *path = [NSIndexPath indexPathForRow:4 inSection:0];
            self.model.residence_city_name = child.label;
            self.model.residence_city = child.value;
            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationNone)];
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 11) {
        if ([self.images count]>=9) {
            [LCProgressHUD showMessage:@"最多可以上传9张图片"];
            return;
        }
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        NSString *title = @"请选择图片来源";
        NSString *message = NSLocalizedString(@"您可以上传9张图片哦!", nil);
        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"拍照", nil);
        NSString *otherButtonTitle1 = NSLocalizedString(@"相册", nil);
       // NSString *otherButtonTitle2 = NSLocalizedString(@"图片库", nil);
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"%@",cancelButtonTitle);
            
        }];
        //相机
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"%@",otherButtonTitle);
            [self loadImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }];
        //相册
        UIAlertAction *otherAction1 = [UIAlertAction actionWithTitle:otherButtonTitle1 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSLog(@"%@",otherButtonTitle1);
            [self loadImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }];
        //图片库
     //   UIAlertAction *otherAction2 = [UIAlertAction actionWithTitle:otherButtonTitle2 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
         //   NSLog(@"%@",otherButtonTitle2);
        //    [self loadImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
      //  }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [alertController addAction:otherAction1];
       // [alertController addAction:otherAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 11) {
        //return [AddPictureCell cellHeightWith:self.images];
        return [tableView fd_heightForCellWithIdentifier:@"Cell011" configuration:^(id cell) {
            
        } ];
    }else{
        return 44;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row%2==0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else {
        cell.backgroundColor = UIColorWithRGBA(248, 248, 248, 1);
    }
}
#pragma mark - textField 代理方法
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
     UILabel *label = (UILabel *)textField.leftView;
    if ([label.text isEqualToString:@"省"]||[label.text isEqualToString:@"市"]||[label.text isEqualToString:@"婚姻状况"]||[label.text isEqualToString:@"建议类型"]||[label.text isEqualToString:@"接收部门"]||[label.text isEqualToString:@"客户来源"]) {
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    UILabel *label = (UILabel *)textField.leftView;
    @try {
        if ([label.text isEqualToString:@"个人姓名"]) {
            nameStr = textField.text;
            [self.subDict setObject:textField.text forKey:@"realname"];
        }else if ([label.text isEqualToString:@"身份证号"]){
            idNumStr = textField.text;
            [self.subDict setObject:textField.text forKey:@"id_number"];
        }else if ([label.text isEqualToString:@"手机号码"]){
            phoneStr = textField.text;
            [self.subDict setObject:textField.text forKey:@"phone"];
        }else if ([label.text isEqualToString:@"资金需求"]){
            appCountStr = textField.text;
            [self.subDict setObject:textField.text forKey:@"apply_amount"];
        }else if ([label.text isEqualToString:@"利率要求"]){
            appRateStr = textField.text;
            [self.subDict setObject:textField.text forKey:@"apply_rate"];
        }else if ([label.text isEqualToString:@"备注"]){
            notesStr = textField.text;
            [self.subDict setObject:textField.text forKey:@"notes"];
        }
    } @catch (NSException *exception) {
        [Window makeToast:exception.description duration:1.0 position:CenterPoint];
    } @finally {
    
    }
      return YES;
}


-(void)loadImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) { // 如果当前机器支持sourceType(比如拍照，模拟器是不支持的)
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = sourceType;
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            controller.showsCameraControls  = YES;
        }
        //controller.allowsEditing = YES; // 允许imagePickerController内置编辑功能
        controller.delegate = self;
        
        // UIImagePickerController是继承于UINavigationController, 所以它本身是一个导航控制器，不要push它，push导航控制器本身不合理，所以我们一般把它present出来
        // 当我们从系统相册中取出来图片(或者是拍照)的时候，通过代理方法把资源传给我们，所以我们要设置代理并实现代理方法，来获取UIImagePickerController对象给我们的东西，由于UIImagePickerController继承于UINavigationController, 要遵守UINavigationControllerDelegate协议, 不然有警告(其实不理它也没关系)
        [self presentViewController:controller animated:YES completion:nil];
    }
}



#pragma mark - UIImagePickerController 代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    if ([type isEqualToString:(NSString*)kUTTypeImage]&&picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
        //获取照片的原图
        // UIImage* original = [[UIImage alloc] init];
        // original = [info objectForKey:UIImagePickerControllerOriginalImage];
        //获取图片裁剪的图
        UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];
        //获取图片裁剪后，剩下的图
        //UIImage* crop = [[UIImage alloc] init];
        // crop = [info objectForKey:UIImagePickerControllerCropRect];
        //获取图片的url
        //NSURL* url = [[NSURL alloc] init];
        //url = [info objectForKey:UIImagePickerControllerMediaURL];
        //获取图片的metadata数据信息
        //        NSDictionary* metadata = [NSDictionary dictionary];
        //        metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
        //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        [self loadImage:image];
        UIImageWriteToSavedPhotosAlbum(edit, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else{
        [self loadImage:image];
    }
    // 退出图片选择控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    NSLog(@"saved..");
}
-(void)loadImage:(UIImage *)image {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    [LCProgressHUD showMessage:@"上传中,请稍等..."];
    [self postImg:@"/sysset/upimg/" parameters:param sendImage:image success:^(id success){
        NSLog(@"success=%@",success);
        
        if ([success[@"code"] isEqualToString:@"0"]) {
            [self.picIDs addObject:success[@"data"]];
            [_subDict setObject:[_picIDs componentsJoinedByString:@","] forKey:@"other_pic"];
            NSData *data = UIImageJPEGRepresentation(image, 0.1);
            UIImage * image1 = [UIImage imageWithData:data];
            [self.images addObject:image1];
            NSIndexPath *path = [NSIndexPath indexPathForRow:11 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:(UITableViewRowAnimationFade)];
            [LCProgressHUD hide];
        }else{
            NSString *msg = success[@"info"];
            if (![XYString isBlankString:msg]) {
                [LCProgressHUD showInfoMsg:msg];
            }else {
                [LCProgressHUD hide];
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error");
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    NSLog(@"%s",__func__);
}

@end
