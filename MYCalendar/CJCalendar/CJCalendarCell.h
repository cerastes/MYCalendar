//
//  Cell.h
//  MYCalendar
//
//  Created by cerastes on 14-10-15.
//  Copyright (c) 2014年 cerastes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJCalendarCellData.h"

@interface CJCalendarCell : UICollectionViewCell
{
    CJCalendarCellData *_data;
}
@property (nonatomic) CJCalendarCellData *data;

@property (nonatomic) bool isCurrentMonth;


@property IBOutlet UILabel *dayLabel;

@end
