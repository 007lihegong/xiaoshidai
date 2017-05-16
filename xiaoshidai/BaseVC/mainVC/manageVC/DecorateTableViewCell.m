//
//  DecorateTableViewCell.m
//  网众
//
//  Created by WZ on 16/5/14.
//  Copyright © 2016年 lihegong. All rights reserved.
//
#import "DecorateTableViewCell.h"
#import "CollectionViewCell.h"
#import "CollectModel.h"
@implementation DecorateTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
//        self.leftline = [UIView new];
//        self.leftline.backgroundColor = UIColorFromRGB(0xff7f1a);
//        [self addSubview:self.leftline];
//        [self.leftline mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(8);
//            make.left.mas_equalTo(10);
//            make.size.mas_equalTo(CGSizeMake(3, 15));
//        }];
//        self.title = [UILabel new];
//        self.title.font = [UIFont systemFontOfSize:13];
//        [self addSubview: self.title];
//        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(8);
//            make.left.mas_equalTo(self.leftline.mas_right).with.offset(10);
//        }];

        [self collectionView];
    }
    return self;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 10, 10) collectionViewLayout:layout];
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewCell"];
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self);
            //make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH,130));
            make.right.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
        }];
    }
    return _collectionView;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}
+ (CGFloat)cellHeight{
    DecorateTableViewCell *cell = [[DecorateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    [cell layoutIfNeeded];
    CGRect frame = cell.collectionView.frame;
    return frame.origin.y+frame.size.height+18+10;
}
- (void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = [NSMutableArray array];

        //_dataArray = dataArray ;
        _dataArray = dataArray;
    CGSize size;
    switch (_indexPath.section) {
        case 0:
            _title.text = LocalizationNotNeeded(@"概况");
            size = CGSizeMake((kScreen_Width)/3.0, 85);
            [_collectionView setSize:size];
            break;
        default:
            break;
    }
    _cellSize = size;
    [_collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 2 && [_dataArray count]%3!=0) {
        return [_dataArray count]%3;
    }
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell;
    if (!cell) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCell" forIndexPath:indexPath];
        cell.layer.borderColor= UIColorWithRGBA(232, 232, 232, 1.0).CGColor;
        cell.layer.borderWidth= 0.41;
    }
    CollectInfo *model = [CollectInfo mj_objectWithKeyValues:_dataArray[indexPath.section*3+indexPath.row]];
    NSString *str = StrFormatTh(model.collect_value,@"\n", model.collect_title);
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range;
    if (indexPath.section*3+indexPath.row >= 5) {
        range = NSMakeRange(0, model.collect_value.length);
    }else{
        range = NSMakeRange(0, model.collect_value.length-1);
    }
    if ([model.collect_value isEqualToString:@"--"]||[model.collect_title isEqualToString:@"最佳销售"]) {
        range = NSMakeRange(0, model.collect_value.length);
    }

    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                          NSForegroundColorAttributeName:UIColorFromRGB(0x111111)} range:range];
    [attr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x666666)} range:NSMakeRange(range.length, str.length-range.length)];
    cell.name.attributedText = attr;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellSize;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0,0);
}
- (void)collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    if (_designButtonClickBlock) {
        _designButtonClickBlock(indexPath.item);
    }
}

- (void)dealloc{
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}
@end
