//
//  LianPayModel.m
//  xiaoshidai
//
//  Created by XSD on 2017/1/12.
//  Copyright © 2017年 XSD. All rights reserved.
//

#import "LianPayModel.h"

@implementation LianPayModel

@end

@interface LianPaData()
@end
@implementation LianPaData
static LLPayType payType = LLPayTypeQuick;

-(LLOrder *)getLLOrderFrom:(LianPaData *)data{
    LLOrder * model = [[LLOrder alloc] initWithLLPayType:payType];
    //NSString *timeStamp = [LLOrder timeStamp];
    model.oid_partner = data.oid_partner;
    model.sign_type = data.sign_type;
    model.busi_partner = data.busi_partner;
    model.no_order = data.no_order;
    model.dt_order = data.dt_order;
    model.money_order = data.money_order;
    model.notify_url = data.notify_url;
    model.acct_name = data.acct_name;
    model.card_no = data.card_no;
    model.id_no = data.id_no;
    model.risk_item = data.risk_item;
    model.user_id = data.user_id;
    model.name_goods = data.name_goods;
    return model;
}

@end
