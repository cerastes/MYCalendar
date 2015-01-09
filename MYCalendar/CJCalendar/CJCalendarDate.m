//
//  CJCalendarDate.m
//  MYCalendar
//
//  Created by cerastes on 14-10-15.
//  Copyright (c) 2014年 cerastes. All rights reserved.
//

#import "CJCalendarDate.h"
#import "CJCalendarCellData.h"
@implementation CJCalendarDate
+(NSArray *)datesArrayOfDate:(NSDate *)date1{
    NSDate *monthStartDate = [date1 dateMonthStart];
    NSDate *monthEndDate   = [date1 dateMonthEnd];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *monthStart = [[NSDateComponents alloc] init];
    NSDateComponents *monthEnd   = [[NSDateComponents alloc] init];

    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    
    monthStart = [calendar components:unitFlags fromDate:monthStartDate];
    monthEnd   = [calendar components:unitFlags fromDate:monthEndDate];
    
    NSInteger sweek  = [monthStart weekday];

    NSDate *firstDay;
    NSDate *endDay;
    if (sweek != 0) {
        firstDay = [NSDate dateWithTimeInterval:-(sweek-1)*24*60*60 sinceDate:monthStartDate];
    }
    else
    {
        firstDay = monthStartDate;
    }
    NSInteger eweek  = [monthEnd weekday];
    endDay = [NSDate dateWithTimeInterval:(7-eweek)*24*60*60 sinceDate:monthEndDate];


    NSMutableArray *dates = [[NSMutableArray alloc]init];
    NSDate *addTOArr = firstDay;
    while ([addTOArr timeIntervalSinceDate:endDay]<= 0) {
        NSDateComponents *com   = [[NSDateComponents alloc] init];
        com = [calendar components:unitFlags fromDate:addTOArr];

        CJCalendarCellData *data = [[CJCalendarCellData alloc]init];
        data.weekday = [com weekday];
        data.year = [com year];
        data.month = [com month];
        data.day = [com day];
        data.date = addTOArr;
        [dates addObject:data];
        addTOArr = [NSDate dateWithTimeInterval:24*60*60 sinceDate:addTOArr];
    }
    
    return dates;
}

-(NSDate *)nextMonth:(NSDate *)date{
    return nil;
}
@end
