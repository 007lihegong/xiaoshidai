//
//  AboutUsVC.m
//  xiaoshidai
//
//  Created by 名侯 on 16/10/17.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()
{
    CGFloat H;
}
@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    //[self setNavRightBtnWithString:@"关闭"];
    [self setUp];
}
#pragma mark -- 设置
- (void)setUp {
    H = 20;
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 500)];
    backV.backgroundColor = [UIColor whiteColor];
    [self PixeHead:CGPointMake(0, 0) lenght:ScreenWidth add:backV];
    [self.view addSubview:backV];
    //标题数组
    NSArray *titleArr = @[@"小时贷愿景：",@"小时贷使命：",@"小时贷精神：",@"小时贷作风："];
    NSArray *valueArr = @[@"让市场没有难贷的款，做中国最大的贷款平台。",@"通过小时贷平台，帮助中小企业以及个人以最快方式、最低的成本拿到贷款，急人所急，让资金为企业与个人添油助力。",@"高效、专注、自强不息。",@"信守承诺，没有借口；绝对服从，勇不言败。"];
    //标题
    for (int i=0; i<4; i++) {
        
        UILabel *valueLB = [[UILabel alloc] initWithFrame:CGRectMake(98, H, ScreenWidth-110, 20)];
        valueLB.font = [UIFont systemFontOfSize:15];
        valueLB.textColor = colorValue(0x666666, 1);
        valueLB.numberOfLines = 0;
        [backV addSubview:valueLB];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:valueArr[i]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:15];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [valueArr[i] length])];
        valueLB.attributedText = attributedString;
        [valueLB sizeToFit];
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(12, H, 86, 20)];
        titleLB.text = titleArr[i];
        titleLB.font = [UIFont boldSystemFontOfSize:14];
        titleLB.textColor = colorValue(0x111111, 1);
        titleLB.numberOfLines = 1;
        [backV addSubview:titleLB];
    
        if (valueLB.height==32.0) {
            H = valueLB.height+H;
        }else {
            H = valueLB.height+15+H;
        }
    }
    backV.height = H;
}
- (void)rightAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
