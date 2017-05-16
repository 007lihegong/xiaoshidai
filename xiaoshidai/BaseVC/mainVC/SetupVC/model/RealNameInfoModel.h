//
//  RealNameInfoModel.h
//  xiaoshidai
//
//  Created by XSD on 2017/1/10.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RealNamaInfo;

@interface RealNameInfoModel : NSObject
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) RealNamaInfo * data;
@property (nonatomic , copy) NSString              * code;
@end

@interface RealNamaInfo :NSObject 
@property (nonatomic , copy) NSString              * card_pic_back;
@property (nonatomic , copy) NSString              * card_pic_front_show;
@property (nonatomic , copy) NSString              * approve_id;
@property (nonatomic , copy) NSString              * card_pic_back_show;
@property (nonatomic , copy) NSString              * realname;
@property (nonatomic , copy) NSString              * card_pic_front;
@property (nonatomic , copy) NSString              * id_number;
@end
