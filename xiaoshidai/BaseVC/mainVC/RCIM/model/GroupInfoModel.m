//
//  GroupInfoModel.m
//  xiaoshidai
//
//  Created by XSD on 2016/11/25.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "GroupInfoModel.h"

@implementation GroupInfoModel
+ (NSDictionary *)objectClassInArray{
    return @{@"groupInfo" : [GroupInfo class]};
}
@end

@implementation GroupInfo

- (id) initWithCoder: (NSCoder *)coder
{
    self = [[GroupInfo alloc] init];
    if (self != nil)
    {
        self.group_id       = [coder decodeObjectForKey:@"group_id"];
        self.group_name     = [coder decodeObjectForKey:@"group_name"];
        self.usersStr       = [coder decodeObjectForKey:@"usersStr"];
        self.creatorId      = [coder decodeObjectForKey:@"creatorId"];
        self.creatorTime    = [coder decodeObjectForKey:@"creatorTime"];
        self.isJoin         = [[coder decodeObjectForKey:@"isJoin"] boolValue];
        self.isDismiss      = [coder decodeObjectForKey:@"isDismiss"];
        self.groupId        = [coder decodeObjectForKey:@"groupId"];
        self.groupName      = [coder decodeObjectForKey:@"groupName"];
        self.portraitUri    = [coder decodeObjectForKey:@"portraitUri"];

    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.group_id forKey:@"group_id"];
    [coder encodeObject:self.group_name forKey:@"group_name"];
    [coder encodeObject:self.usersStr forKey:@"usersStr"];
    [coder encodeObject:self.creatorId forKey:@"department_name"];
    [coder encodeObject:self.creatorTime forKey:@"creatorTime"];
    [coder encodeObject:@(self.isJoin)  forKey:@"isJoin"];
    [coder encodeObject:self.isDismiss forKey:@"isDismiss"];
    [coder encodeObject:self.groupId forKey:@"groupId"];
    [coder encodeObject:self.groupName forKey:@"groupName"];
    [coder encodeObject:self.portraitUri forKey:@"portraitUri"];

}
@end
