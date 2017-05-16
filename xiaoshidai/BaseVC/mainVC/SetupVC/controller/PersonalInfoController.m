//
//  PersonalInfoController.m
//  xiaoshidai
//
//  Created by XSD on 2016/11/22.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "PersonalInfoController.h"
#import "SingleChatController.h"
#import "MyListController.h"
#import "BaseNavigationController.h"
@interface PersonalInfoController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partLabel;
@property (weak, nonatomic) IBOutlet UIButton *phonrButton;
@property (weak, nonatomic) IBOutlet UIButton *toConversationButton;

@end

@implementation PersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"详细资料";
    if (self.model) {
        [self initUI];
    }
}
-(void)initUI{
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.portrait_uri]placeholderImage:IMGNAME(@"userimg")];
    _nameLabel.text = _model.display_name;
    _partLabel.text = _model.department_name;
    [_phonrButton setTitle:StrFormatTW(@"手机号码: ", _model.phone) forState:(UIControlStateNormal)];
    _phonrButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_phonrButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [_phonrButton addTarget:self action:@selector(call:) forControlEvents:(UIControlEventTouchUpInside)];
    [_toConversationButton addTarget:self action:@selector(gotoConversation:) forControlEvents:(UIControlEventTouchUpInside)];
}
-(void)call:(UIButton *)button{
    [self backAction];
}
-(void)backAction{
    if ([XYString isBlankString:_model.phone]) {
        _model.phone = @"";
    }
    NSString *string = [NSString stringWithFormat:@"tel://%@",avoidNullStr(_model.phone)];
    UIApplication *app = [UIApplication sharedApplication];
    if (IOS10_2LATER) {
        [app openURL:[NSURL URLWithString:string]options:@{} completionHandler:^(BOOL success) {
            NSLog(@"%@",@(success));
        }];
    }else{
        NSString *title = avoidNullStr(_model.phone);
        NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"呼叫", nil);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"%@",cancelButtonTitle);
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *string = [NSString stringWithFormat:@"tel://%@",avoidNullStr(_model.phone)];
            UIApplication *app = [UIApplication sharedApplication];
            [app openURL:[NSURL URLWithString:string]];
            NSLog(@"%@",otherButtonTitle);
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)gotoConversation:(UIButton *)button{
    SingleChatController *controller = [[SingleChatController alloc] init];
    controller.conversationType = ConversationType_PRIVATE;
    controller.targetId = _model.user_id;
    controller.title = _model.display_name;
    controller.needPopToRootView = YES;
    [self.tabBarController.childViewControllers enumerateObjectsUsingBlock:^(__kindof BaseNavigationController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.childViewControllers[0] isKindOfClass:[MyListController class]]) {
            [self.tabBarController.childViewControllers[idx] pushViewController:controller animated:YES];
            [self.tabBarController setSelectedIndex:idx];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
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
