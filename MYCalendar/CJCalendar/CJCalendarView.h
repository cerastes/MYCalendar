//
//  MyCalendar.h
//  MYCalendar
//
//  Created by cerastes on 14-10-15.
//  Copyright (c) 2014年 cerastes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJCalendarView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
    NSArray          *_monthDays;
    UILabel          *dateLable;
    NSDate           *_currentMonthDate;
}
@end
