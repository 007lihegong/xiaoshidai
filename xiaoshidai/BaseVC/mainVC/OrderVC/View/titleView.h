//
//  titleView.h
//  xiaoshidai
//
//  Created by 名侯 on 16/10/10.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class titleView;
@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (titleView *) sender;
@end

@interface titleView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
}



@property(nonatomic, strong) UITableView *table;
@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString *animationDirection;



-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b :(CGFloat *)height :(NSArray *)arr :(NSArray *)imgArr :(NSString *)direction;

@end
