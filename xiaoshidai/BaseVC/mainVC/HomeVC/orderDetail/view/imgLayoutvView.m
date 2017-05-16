//
//  imgLayoutvView.m
//  xiaoshidai
//
//  Created by 名侯 on 16/10/10.
//  Copyright © 2016年 XSD. All rights reserved.
//

#import "imgLayoutvView.h"
#import "UIView+SDAutoLayout.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
@interface imgLayoutvView () <SDPhotoBrowserDelegate>{
    NSUInteger cIdx;
}

@property (nonatomic, strong) NSMutableArray *imageViewsArray;

@end

@implementation imgLayoutvView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        @autoreleasepool {
            UIImageView *imageView = [UIImageView new];
            [self addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tap];
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.tag = 100+i;
            [button setHidden:YES];
            [button setImage:IMGNAME(@"head_icon_samlldelet") forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(delete:) forControlEvents:(UIControlEventTouchUpInside)];
            [imageView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(imageView.mas_top);
                make.right.mas_equalTo(imageView.mas_right);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [temp addObject:imageView];
        }
    }
    self.imageViewsArray = [temp mutableCopy];
}

-(void)add:(UITapGestureRecognizer *)tap{
    if (self.presentAlert) {
        self.presentAlert(@1);
    }
    NSLog(@"11111");
}
- (void)setPicPathStringsArray:(NSMutableArray *)picPathStringsArray
{
    if (self.flag ==1) {
        picPathStringsArray =[picPathStringsArray mutableCopy];
        if ([picPathStringsArray count]<9) {
            if (![picPathStringsArray containsObject:IMGNAME(@"nav_icon_add")]) {
                [picPathStringsArray addObject:IMGNAME(@"nav_icon_add")];
            }
        }
    }
    _picPathStringsArray = picPathStringsArray;
    if ([_picPathStringsArray containsObject:IMGNAME(@"nav_icon_add")] && self.flag ==1) {
        UIImageView *imageV = self.imageViewsArray[[_picPathStringsArray count]-1];
        [ self.imageViewsArray.lastObject removeGestureRecognizer:imageV.gestureRecognizers[0]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(add:)];
        [imageV addGestureRecognizer:tap];
    }
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.height = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = 0;

    itemH = itemW;
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin = 10;
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        if (self.flag == 1) {
            UIButton *button = (UIButton *)[self viewWithTag:idx+100];
            if ( [_picPathStringsArray containsObject:IMGNAME(@"nav_icon_add")]) {
                if (idx == _picPathStringsArray.count-1) {
                    button.hidden = YES;
                }else{
                    button.hidden = NO;
                }
            }else{
                button.hidden = NO;
            }
        }
        if ([obj isKindOfClass:[NSString class]]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:IMGNAME(@"Placeholder")completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

            }];;
        }else if([obj isKindOfClass:[UIImage class]]){
            @autoreleasepool {
                NSData *data = UIImageJPEGRepresentation(obj, 0.5);
                UIImage *img = [UIImage imageWithData:data];
                [imageView sd_setImageWithURL:nil placeholderImage:img];
            }
        }else{
            PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
            [imageManager requestImageForAsset:obj targetSize:CGSizeMake(75, 75) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
                [imageView setImage:result];
            }];
        }
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;

    self.width = w;
    self.height = h;
    self.fixedHeight = @(h);
    self.fixedWith = @(w);
}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
-(void)delete:(UIButton *)sender{
    [_picPathStringsArray removeObjectAtIndex:sender.tag-100];
    if (self.deleId) {
        self.deleId(sender);
    }
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //[self removeFromSuperview];
    [self setPicPathStringsArray:_picPathStringsArray];
}
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    if ([self.picPathStringsArray containsObject:IMGNAME(@"nav_icon_add")]) {
        [self.picPathStringsArray removeLastObject];
    }
    browser.imageCount = self.picPathStringsArray.count;
    browser.delegate = self;
    [browser show];
}

//返回图片的宽度
- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
//    if (array.count == 1) {
//        return 120;
//    } else {
//        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? 80 : 70;
//        return w;
//    }
    CGFloat w;
    if (self.flag== 1) {
        w = (kScreen_Width-100-30)/3;
    }else{
        w = ([UIScreen mainScreen].bounds.size.width-130)/3;
    }
    return w;
}
//返回列数
- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
    if (array.count <= 3) {
        return array.count;
    } else if (array.count <= 4) {
        return 3;
    } else {
        return 3;
    }
}


#pragma mark - SDPhotoBrowserDelegate

- (id)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageName = self.picPathStringsArray[index];
    if ([imageName isKindOfClass:[NSString class]]) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:imageName withExtension:nil];
        return url;
    }else if([imageName isKindOfClass:[UIImage class]]){
        return nil;
    }else{
        return imageName;
    }
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}
-(void)dealloc{
    [self removeFromSuperview];
    NSLog(@"%s",__func__);
}
@end
