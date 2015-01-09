//
//  NSDate+Components.m
//  NSDate+Calendar
//
//  Created by Belkevich Alexey on 3/28/12.
//  Copyright (c) 2012 okolodev. All rights reserved.
//

#import "NSDate+Components.h"

@implementation NSDate (Components)

#pragma mark - public

- (NSDateComponents *)dateComponentsTime
{
    NSUInteger components = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
    return [self dateComponents:components];
}

- (NSDateComponents *)dateComponentsDate
{
    NSUInteger components = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    return [self dateComponents:components];
}

- (NSDateComponents *)dateComponentsWeek
{
    NSUInteger components = (NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfMonth |
                             NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitYear |
                             NSCalendarUnitYearForWeekOfYear);
    return [self dateComponents:components];
}

- (NSDateComponents *)dateComponentsWeekday
{
    NSUInteger components = (NSCalendarUnitDay | NSWeekCalendarUnit | NSWeekdayCalendarUnit |
                             NSCalendarUnitMonth | NSCalendarUnitYear);
    return [self dateComponents:components];
}

- (NSDateComponents *)dateComponentsDateTime
{
    NSUInteger components = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |
                             NSCalendarUnitHour | NSMinuteCalendarUnit | NSCalendarUnitSecond);
    return [self dateComponents:components];
}

- (NSDateComponents *)dateComponentsWeekTime
{
    NSUInteger components = (NSWeekCalendarUnit | NSWeekdayCalendarUnit |
                             NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit |
                             NSCalendarUnitYear | NSYearForWeekOfYearCalendarUnit |
                             NSCalendarUnitHour | NSMinuteCalendarUnit | NSCalendarUnitSecond);
    return [self dateComponents:components];
}

#pragma mark - private

- (NSDateComponents *)dateComponents:(NSUInteger)components
{
    return [[NSCalendar currentCalendar] components:components fromDate:self];
}

@end
