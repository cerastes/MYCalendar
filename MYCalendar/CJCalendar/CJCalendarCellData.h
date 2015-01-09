//
//  CJCalendarCellData.h
//  MYCalendar
//
//  Created by cerastes on 14-10-15.
//  Copyright (c) 2014年 cerastes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJCalendarCellData : NSObject
@property(nonatomic) NSInteger weekday;
@property(nonatomic) NSInteger year;
@property(nonatomic) NSInteger month;
@property(nonatomic) NSInteger day;
@property(nonatomic) NSDate    *date;
@end
