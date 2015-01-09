//
//  MyCalendar.m
//  MYCalendar
//
//  Created by cerastes on 14-10-15.
//  Copyright (c) 2014年 cerastes. All rights reserved.
//

#import "CJCalendarView.h"
#import "CJCalendarCell.h"
#import "CJCalendarDate.h"
#import "CJCalendarCellData.h"

@implementation CJCalendarView
static NSString *reuseIdentifier = @"CJCalendarCellIdentify";

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];

        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, self.width-2, 42)];
        dateLabel.text = @"2014年11月23号";
        dateLabel.backgroundColor = [UIColor whiteColor];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dateLabel];
        
        NSArray *weekArry = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        for (int i = 0 ; i<weekArry.count ;i++) {
            UILabel *weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*self.width/7., 44, self.width/7., 25)];
            if (i == 0) {
                weekLabel.frame = CGRectMake(i*self.width/7.+1, 44, self.width/7-1., 25);
            }
            if (i == 6) {
                weekLabel.frame = CGRectMake(i*self.width/7., 44, self.width/7-1., 25);
            }
            weekLabel.backgroundColor = [UIColor whiteColor];
            weekLabel.text = [weekArry objectAtIndex:i];
            weekLabel.textColor = [UIColor blackColor];
            if (i == 0 || i == 6) {
                weekLabel.textColor = [UIColor redColor];
            }
            weekLabel.textAlignment = NSTextAlignmentCenter;
            weekLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:weekLabel];
        }
        _currentMonthDate = [NSDate date];
        _monthDays = [CJCalendarDate datesArrayOfDate:_currentMonthDate];

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(1, 70, self.width-2, self.height-71) collectionViewLayout:flowLayout];
        [_collectionView registerNib:[UINib nibWithNibName:@"CJCalendarCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_collectionView];
        [_collectionView reloadData];
        self.backgroundColor = [UIColor lightGrayColor];
        
    
//        dateLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 22)];
//        dateLable.backgroundColor = [UIColor redColor];
//        [self addSubview:dateLable];
        
        UIButton *former = [UIButton buttonWithType:UIButtonTypeCustom];
        former.frame = CGRectMake(10, 10, 25, 25);
        [former setBackgroundImage:[UIImage imageNamed:@"former.png"] forState:UIControlStateNormal];
        [former addTarget:self action:@selector(formerDate) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:former];
        
        UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
        next.frame = CGRectMake(self.width-35, 10, 25, 25);
        [next setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
        [next addTarget:self action:@selector(nextDate) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:next];
    }
    return self;
}

-(void)formerDate{
    NSDate *date = [_currentMonthDate dateMonthStart];
    _currentMonthDate = [NSDate dateWithTimeInterval:-2*24*60*60 sinceDate:date];
    _monthDays = [CJCalendarDate datesArrayOfDate:_currentMonthDate];
    [_collectionView reloadData];
}

-(void)nextDate{
    NSDate *date = [_currentMonthDate dateMonthEnd];
    _currentMonthDate = [NSDate dateWithTimeInterval:2*24*60*60 sinceDate:date];
    _monthDays = [CJCalendarDate datesArrayOfDate:_currentMonthDate];
    [_collectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _monthDays.count/7;;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CJCalendarCell *cell = [cv dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSLog(@"index = %ld",((indexPath.section)*7+indexPath.row));
    CJCalendarCellData *data = [_monthDays objectAtIndex:((indexPath.section)*7+indexPath.row)];
    cell.data = data;
    if ([_currentMonthDate month] == data.month) {
        cell.isCurrentMonth = YES;
    }
    else
    {
        cell.isCurrentMonth = NO;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_collectionView.bounds.size.width/7., _collectionView.bounds.size.width/7.);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CJCalendarCellData *data = [_monthDays objectAtIndex:((indexPath.section)*7+indexPath.row)];
    NSLog(@"day = %ld",data.day);
    NSLog(@"day = %@",data.date);
    dateLable.text = [NSString stringWithFormat:@"%@",data.date];
    dateLable.textColor = [UIColor blackColor];
}
//-(UIView*)
@end
