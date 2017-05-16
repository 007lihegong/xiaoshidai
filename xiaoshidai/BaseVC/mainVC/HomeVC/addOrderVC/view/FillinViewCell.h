//
//  FillinViewCell.h
//  网众
//
//  Created by WZ on 16/4/5.
//  Copyright © 2016年 lihegong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imgLayoutvView.h"
#import "OrderDetailModel.h"
@protocol textFieldDelegate <NSObject>
- (void)textFieldEditing:(NSIndexPath *)indexPath;
@end
@interface FillinViewCell : UITableViewCell
@property (assign, nonatomic) id<textFieldDelegate> delegate;
@property (nonatomic ,strong) UILabel *titleLabel;               //标题框
@property (nonatomic ,strong) MyTextField *inputTextField;       //输入框
@property (nonatomic ,copy)   NSString *title;                     //标题文字
@property (nonatomic ,strong) UILabel *prompt;                   //提示
@property (nonatomic ,strong) NSIndexPath *indexPath;
@property (nonatomic ,strong) UIButton * downButton;
@property (nonatomic ,strong) NSMutableDictionary * dataDict;
@property (nonatomic ,copy) void(^callBackHandler)(NSDictionary *dict);
@property (nonatomic) NSMutableArray *imgArr;
@property (nonatomic,strong) imgLayoutvView *imgV;
@property (nonatomic) User_Base_Info *baseModel;
@property (nonatomic) User_Assets_Info *assetsModel;
@property (nonatomic) User_Credit_Info *creditModel;
@property (assign) NSInteger flag;
+(CGFloat)cellHeightWith:(NSMutableArray *)arr;
@end
