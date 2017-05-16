//
//  UserInfoModel.m
//  xiaoshidai
//
//  Created by XSD on 16/11/15.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
+ (NSDictionary *)objectClassInArray{
    return @{@"userInfo" : [UserInfo class]};
}
@end


@implementation UserInfo

- (id) initWithCoder: (NSCoder *)coder
{
    self = [[UserInfo alloc] init];
    if (self != nil)
    {
        self.portrait_uri       = [coder decodeObjectForKey:@"portrait_uri"];
        self.display_name       = [coder decodeObjectForKey:@"display_name"];
        self.phone              = [coder decodeObjectForKey:@"phone"];
        self.department_name    = [coder decodeObjectForKey:@"department_name"];
        self.user_name          = [coder decodeObjectForKey:@"user_name"];
        self.user_id            = [coder decodeObjectForKey:@"user_id"];
        self.userId             = [coder decodeObjectForKey:@"userId"];
        self.name               = [coder decodeObjectForKey:@"name"];
        self.portraitUri        = [coder decodeObjectForKey:@"portraitUri"];
        
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.portrait_uri forKey:@"portrait_uri"];
    [coder encodeObject:self.display_name forKey:@"display_name"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.department_name forKey:@"department_name"];
    [coder encodeObject:self.user_name forKey:@"user_name"];
    [coder encodeObject:self.user_id  forKey:@"user_id"];
    [coder encodeObject:self.userId forKey:@"userId"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.portraitUri forKey:@"portraitUri"];
}
@end


