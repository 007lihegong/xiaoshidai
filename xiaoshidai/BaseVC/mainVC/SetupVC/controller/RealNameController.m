//
//  RealNameController.m
//  xiaoshidai
//
//  Created by XSD on 2016/12/29.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "RealNameController.h"
#import "TextFieldCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "RealNameModel.h"
#import "AddPicCell.h"
#import "RealNameInfoModel.h"
#import "UITextField+RYNumberKeyboard.h"

@interface RealNameController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIButton *_currentButton ;
    NSString *_nameStr;
    NSString *_idStr;
    NSString *_frontStr;
    NSString *_backStr;
    //MBProgressHUD *hud;
}
@property (nonatomic) UITableView * tableView;
@property (nonatomic) NSMutableArray * dataArray;
@property (nonatomic) NSMutableArray * sectionArray;
@property (nonatomic) NSMutableArray * titlesArray;
@property (nonatomic) UIButton *button ;
@property (nonatomic) RealNameInfoModel *model ;

@end

@implementation RealNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataArray];
    [self tableView];
    [self button];
    [self post];
}
-(void)post{
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    NSString * operator_id = [USER_DEFAULT objectForKey:login_Operation];
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    [param setObject:[self setRSAencryptString:operator_id] forKey:@"operator_id"];
    [LCProgressHUD showLoading:nil];
    [self post:SYSSET_REALNAME_INFO parameters:param success:^(id dict) {
        if ([dict[@"code"] isEqualToString:@"0"]) {
            [LCProgressHUD showSuccess:dict[@"msg"]];
            _model  = [RealNameInfoModel mj_objectWithKeyValues:dict];
            [_tableView reloadData];
        }else{
            [LCProgressHUD showSuccess:dict[@"info"]];
        }
    } failure:^(NSError * error) {
        
    }];

}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"真实姓名",@"身份证号", nil];//,@"电话号码"
    }
    return _dataArray;
}
-(NSMutableArray *)titlesArray{
    if (!_titlesArray) {
        _titlesArray = [NSMutableArray arrayWithObjects:@"身份证照", nil];
    }
    return _titlesArray;
}
-(NSMutableArray *)sectionArray{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray arrayWithObjects:self.dataArray,self.titlesArray, nil];
    }
    return _sectionArray;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-64-49) style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
        [_tableView registerClass:[TextFieldCell class] forCellReuseIdentifier:@"TextFieldCellID"];
        [_tableView registerClass:[AddPicCell class] forCellReuseIdentifier:@"AddPicCellID"];
        //[_tableView setTableFooterView:[self button]];
        [self.view addSubview:_tableView];
        _nameStr = [NSString string];
        _idStr = [NSString string];
        _frontStr = [NSString string];
        _backStr = [NSString string];
    }
    return _tableView;
}
-(UIButton *)button{
    _button  = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_button setTitle:avoidNullStr(self.buttonStr) forState:(UIControlStateNormal)];
    [_button setBackgroundColor:mainHuang];
    [_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_button setFrame:CGRectMake(0, kScreen_Height -49-64, kScreen_Width, 49)];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_button];
    return _button;
}
-(void)buttonClick:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    [LCProgressHUD showLoading:@"请稍等..."];
    @try {
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        NSString *urlstring;
        if ([sender.titleLabel.text isEqualToString:@"重新提交"]) {
            [param setObject:[self setRSAencryptString:_nameStr] forKey:@"realname"];
            [param setObject:[self setRSAencryptString:_idStr] forKey:@"id_number"];
            [param setObject:[self setRSAencryptString:_frontStr] forKey:@"card_pic_front"];
            [param setObject:[self setRSAencryptString:_backStr] forKey:@"card_pic_back"];
            [param setObject:[self setRSAencryptString:_model.data.approve_id] forKey:@"approve_id"];

            NSArray *array = [NSMutableArray arrayWithObjects:@{@"price":@"realname",@"vaule":StrFormatTW(@"realname", _nameStr)},
                              @{@"price":@"id_number",@"vaule":StrFormatTW(@"id_number", _idStr)},
                              @{@"price":@"card_pic_front",@"vaule":StrFormatTW(@"card_pic_front", _frontStr)},
                              @{@"price":@"card_pic_back",@"vaule":StrFormatTW(@"card_pic_back", _backStr)},
                              @{@"price":@"approve_id",@"vaule":StrFormatTW(@"approve_id", _model.data.approve_id)},
                              nil];
            [param setObject:[self setUserTokenStr:array] forKey:@"token"];
            urlstring = REALNAME_MODIFY;
        }else if ([sender.titleLabel.text isEqualToString:@"提交"]){
            [param setObject:[self setRSAencryptString:_nameStr] forKey:@"realname"];
            [param setObject:[self setRSAencryptString:_idStr] forKey:@"id_number"];
            [param setObject:[self setRSAencryptString:_frontStr] forKey:@"card_pic_front"];
            [param setObject:[self setRSAencryptString:_backStr] forKey:@"card_pic_back"];
            NSArray *array = [NSMutableArray arrayWithObjects:@{@"price":@"realname",@"vaule":StrFormatTW(@"realname", _nameStr)},
                              @{@"price":@"id_number",@"vaule":StrFormatTW(@"id_number", _idStr)},
                              @{@"price":@"card_pic_front",@"vaule":StrFormatTW(@"card_pic_front", _frontStr)},
                              @{@"price":@"card_pic_back",@"vaule":StrFormatTW(@"card_pic_back", _backStr)},
                              nil];
            [param setObject:[self setUserTokenStr:array] forKey:@"token"];
            urlstring = NEWREC;
        }

        [BaseRequest post:urlstring parameters:param success:^(id dict) {
            if ([dict[@"code"] intValue]==0) {
                [LCProgressHUD showSuccess:dict[@"data"]];
                appdelegate.refresh = 2;
                UIViewController *controller = self.navigationController.childViewControllers[1];
                [self.navigationController popToViewController:controller animated:YES];
            } else{
                NSString *msg = dict[@"info"];
                if (![XYString isBlankString:msg]) {
                    [LCProgressHUD showInfoMsg:msg];
                }else {
                    [LCProgressHUD hide];
                }
            }
        } failure:^(NSError *error) {
            [LCProgressHUD showInfoMsg:@"获取失败"];
        }];
    } @catch (NSException *exception) {
        [LCProgressHUD showInfoMsg:exception.description];
    } @finally {
    }
}
#pragma mark - tableView 代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectionArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = _sectionArray[section];
    if (array.count) {
        return array.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     __weak __typeof__(self) weakSelf = self;
    if (indexPath.section == 1) {
        AddPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPicCellID"];
        if (!cell) {
            cell = [[AddPicCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"AddPicCellID"];
        }
        cell.titleLabel.text = _sectionArray[indexPath.section][indexPath.row];
        [cell.frontImageView addTarget:self action:@selector(frontImage:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.frontImageView.tag = 1000;
        [cell.backImageView addTarget:self action:@selector(backImage:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.backImageView.tag = 1001;
        cell.model = _model;
        return cell;
    }else{
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCellID"];
        if (!cell) {
            cell = [[TextFieldCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"TextFieldCellID"];
        }
        cell.titleLabel.text = _sectionArray[indexPath.section][indexPath.row];
        if ([cell.titleLabel.text isEqualToString:@"身份证号"]) {
            cell.textField.ry_inputType = RYIDCardInputType;
        }
        [cell setBlock:^(NSString * str) {
            if (indexPath.row == 0) {
                _nameStr = str;
                weakSelf.model.data.realname = str;
            }else if (indexPath.row == 1){
                _idStr = str;
                weakSelf.model.data.id_number = str;
            }
            NSLog(@"%@",str);
        }];
        if (self.model) {
            _nameStr = self.model.data.realname;
            _idStr = self.model.data.id_number;
            cell.model = _model;
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height ;
    if (indexPath.section == 1) {
        height = [tableView fd_heightForCellWithIdentifier:@"AddPicCellID" configuration:^(id cell) { }];
    }else{
        height = [tableView fd_heightForCellWithIdentifier:@"TextFieldCellID" configuration:^(id cell) { }];
    }
    return height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 100;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
#pragma mark - 添加图片
-(void)frontImage:(UIButton *)button{
    _currentButton = button;
    NSLog(@"%ld",(long)_currentButton.tag);
    [self selectImage];
}
-(void)backImage:(UIButton *)button{
    _currentButton = button;
    NSLog(@"%zd",_currentButton.tag);
    [self selectImage];
}
#pragma mark - 选择照片来源
-(void)selectImage{
    NSString *title = @"请选择图片来源";
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"拍照", nil);
    NSString *otherButtonTitle1 = NSLocalizedString(@"相册", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
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
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [alertController addAction:otherAction1];
    [self presentViewController:alertController animated:YES completion:nil];
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
-(void)loadImage:(UIImage *)image {
    //[_currentButton setImage:image forState:(UIControlStateNormal)];

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[self setApiTokenStr] forKey:@"token"];
    [LCProgressHUD showMessage:@"上传中,请稍等..."];
    [self postImg:UPIMG parameters:param sendImage:image success:^(id success){
        NSLog(@"success=%@",success);
        
        if ([success[@"code"] isEqualToString:@"0"]) {
            [LCProgressHUD hide];
            [_currentButton setImage:image forState:(UIControlStateNormal)];
            if (_currentButton.tag == 1000) {
                _frontStr =  success[@"data"];
            }else if (_currentButton.tag == 1001){
                _backStr = success[@"data"];
            }
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
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    NSLog(@"saved..");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
