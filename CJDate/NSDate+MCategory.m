//
// Created by wangwei on 7/29/14.
// Copyright (c) 2014 com.qianxs. All rights reserved.
//

#import "NSDate+MCategory.h"


typedef NS_ENUM(NSUInteger, DTDateComponent) {
    DTDateComponentEra,
    DTDateComponentYear,
    DTDateComponentMonth,
    DTDateComponentDay,
    DTDateComponentHour,
    DTDateComponentMinute,
    DTDateComponentSecond,
    DTDateComponentWeekday,
    DTDateComponentWeekdayOrdinal,
    DTDateComponentQuarter,
    DTDateComponentWeekOfMonth,
    DTDateComponentWeekOfYear,
    DTDateComponentYearForWeekOfYear,
    DTDateComponentDayOfYear
};

/**
*  Constant describing the desired length of the string for a shortened time ago unit
*  Example: If 1 is provided then "week" becomes "w" for the shortenedTimeAgoString
*/
static const NSUInteger SHORT_TIME_AGO_STRING_LENGTH = 1;

static const unsigned int allCalendarUnitFlags = NSYearCalendarUnit | NSQuarterCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekOfMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSEraCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekCalendarUnit;


@implementation NSDate (MCategory)
+ (long long)longFromDate:(NSDate *)date {
    return [date timeIntervalSince1970] * 1000;
}

+ (NSDate *)dateFromLong:(long long)msSince1970 {
    return [NSDate dateWithTimeIntervalSince1970:msSince1970 / 1000];
}


+ (NSDate *)now {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    NSLog(@"now: %@", localeDate);
    return localeDate;
}

- (NSDate *)localeformat {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: self];
    return  [self  dateByAddingTimeInterval: interval];
}


+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *components = [self dateComponentsWith:year month:month day:day];
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                    hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSDateComponents *components = [self dateComponentsWith:year month:month day:day];
    components.hour = hour;
    components.minute = minute;
    components.second = second;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

#pragma mark - private

+ (NSDateComponents *)dateComponentsWith:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    return components;
}

#pragma mark - Time Ago

/**
*  Takes in a date and returns a string with the most convenient unit of time representing
*  how far in the past that date is from now.
*
*  @param NSDate - Date to be measured from now
*
*  @return NSString - Formatted return string
*/
+ (NSString *)timeAgoSinceDate:(NSDate *)date {
    return [date timeAgoSinceDate:[NSDate date] shortformatting:NO];
}

/**
*  Takes in a date and returns a shortened string with the most convenient unit of time representing
*  how far in the past that date is from now.
*
*  @param NSDate - Date to be measured from now
*
*  @return NSString - Formatted return string
*/
+ (NSString *)shortTimeAgoSinceDate:(NSDate *)date {
    return [date timeAgoSinceDate:[NSDate date] shortformatting:YES];
}

/**
*  Returns a string with the most convenient unit of time representing
*  how far in the past that date is from now.
*
*  @return NSString - Formatted return string
*/
- (NSString *)timeAgoSinceNow {
    return [self timeAgoSinceDate:[NSDate date] shortformatting:NO];
}

/**
*  Returns a shortened string with the most convenient unit of time representing
*  how far in the past that date is from now.
*
*  @return NSString - Formatted return string
*/
- (NSString *)shortTimeAgoSinceNow {
    return [self timeAgoSinceDate:[NSDate date] shortformatting:YES];
}

- (NSString *)timeAgoSinceDate:(NSDate *)date shortformatting:(BOOL)shortFormatting {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSSecondCalendarUnit;
    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSDateComponents *components = [calendar components:unitFlags fromDate:earliest toDate:latest options:0];

    NSString *componentName = @"";
    NSInteger componentValue = 0;

    if (components.year >= 1) {
        return NSLocalizedString(@"over a year ago", nil);
    }
    else if (components.month >= 1) {
        componentValue = components.month;
        componentName = (components.month == 1) ? NSLocalizedString(@"month", nil) : NSLocalizedString(@"months", nil);
    }
    else if (components.week >= 1) {
        componentValue = components.week;
        componentName = (components.week == 1) ? NSLocalizedString(@"week", nil) : NSLocalizedString(@"weeks", nil);
    }
    else if (components.day >= 1) {
        componentValue = components.day;
        componentName = (components.day == 1) ? NSLocalizedString(@"day", nil) : NSLocalizedString(@"days", nil);
    }
    else if (components.hour >= 1) {
        componentValue = components.hour;
        componentName = (components.hour == 1) ? NSLocalizedString(@"hour", nil) : NSLocalizedString(@"hours", nil);
    }
    else if (components.minute >= 1) {
        componentValue = components.minute;
        componentName = (components.minute == 1) ? NSLocalizedString(@"minute", nil) : NSLocalizedString(@"minutes", nil);
    }
    else if (components.second >= 3) {
        componentValue = components.second;
        componentName = (components.second == 1) ? NSLocalizedString(@"second", nil) : NSLocalizedString(@"seconds", nil);
    }
    else {
        if (shortFormatting) {
            return NSLocalizedString(@"now", nil);
        }
        else {
            return NSLocalizedString(@"just now", nil);
        }
    }

    //If short formatting is requested, only take the first character of your string
    if (shortFormatting) {
        //Make sure that the provided substring length is not too long for the component name
        if (SHORT_TIME_AGO_STRING_LENGTH < componentName.length) {
            componentName = [componentName substringToIndex:SHORT_TIME_AGO_STRING_LENGTH];
        }
        else {
            componentName = [componentName substringToIndex:1];
        }
    }

    return [self stringForComponentValue:componentValue withName:componentName shortFormatting:shortFormatting];
}

- (NSString *)stringForComponentValue:(NSInteger)componentValue withName:(NSString *)name shortFormatting:(BOOL)shortFormatting {
    //If shortened formatting is requested, drop the "ago" part of the time ago
    if (shortFormatting) {
        return [NSString stringWithFormat:@"%ld%@", (long) componentValue, name];
    }
    else {
        return [NSString stringWithFormat:@"%ld %@ %@", (long) componentValue, name, NSLocalizedString(@"ago", nil)];
    }

}

#pragma mark - Date Components Without Calendar

/**
*  Returns the era of the receiver. (0 for BC, 1 for AD for Gregorian)
*
*  @return NSInteger
*/
- (NSInteger)era {
    return [self componentForDate:self type:DTDateComponentEra calendar:nil];
}

/**
*  Returns the year of the receiver.
*
*  @return NSInteger
*/
- (NSInteger)year {
    return [self componentForDate:self type:DTDateComponentYear calendar:nil];
}

/**
*  Returns the month of the year of the receiver.
*
*  @return NSInteger
*/
- (NSInteger)month {
    return [self componentForDate:self type:DTDateComponentMonth calendar:nil];
}

/**
*  Returns the day of the month of the receiver.
*
*  @return NSInteger
*/
- (NSInteger)day {
    return [self componentForDate:self type:DTDateComponentDay calendar:nil];
}

/**
*  Returns the hour of the day of the receiver. (0-24)
*
*  @return NSInteger
*/
- (NSInteger)hour {
    return [self componentForDate:self type:DTDateComponentHour calendar:nil];
}

/**
*  Returns the minute of the receiver. (0-59)
*
*  @return NSInteger
*/
- (NSInteger)minute {
    return [self componentForDate:self type:DTDateComponentMinute calendar:nil];
}

/**
*  Returns the second of the receiver. (0-59)
*
*  @return NSInteger
*/
- (NSInteger)second {
    return [self componentForDate:self type:DTDateComponentSecond calendar:nil];
}

/**
*  Returns the day of the week of the receiver.
*
*  @return NSInteger
*/
- (NSInteger)weekday {
    return [self componentForDate:self type:DTDateComponentWeekday calendar:nil];
}

/**
*  Returns the ordinal for the day of the week of the receiver.
*
*  @return NSInteger
*/
- (NSInteger)weekdayOrdinal {
    return [self componentForDate:self type:DTDateComponentWeekdayOrdinal calendar:nil];
}

/**
*  Returns the quarter of the receiver.
*
*  @return NSInteger
*/
- (NSInteger)quarter {
    return [self componentForDate:self type:DTDateComponentQuarter calendar:nil];
}

/**
*  Returns the week of the month of the receiver.
*
*  @return NSInteger
*/
- (NSInteger)weekOfMonth {
    return [self componentForDate:self type:DTDateComponentWeekOfMonth calendar:nil];
}

/**
*  Returns the week of the year of the receiver.
*
*  @return NSInteger
*/
- (NSInteger)weekOfYear {
    return [self componentForDate:self type:DTDateComponentWeekOfYear calendar:nil];
}

/**
*  I honestly don't know much about this value...
*
*  @return NSInteger
*/
- (NSInteger)yearForWeekOfYear {
    return [self componentForDate:self type:DTDateComponentYearForWeekOfYear calendar:nil];
}

/**
*  Returns how many days are in the month of the receiver.
*
*  @return NSInteger
*/
- (NSInteger)daysInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit
                                  inUnit:NSMonthCalendarUnit
                                 forDate:self];
    return days.length;
}

/**
*  Returns the day of the year of the receiver. (1-365 or 1-366 for leap year)
*
*  @return NSInteger
*/
- (NSInteger)dayOfYear {
    return [self componentForDate:self type:DTDateComponentDayOfYear calendar:nil];
}

/**
*  Returns how many days are in the year of the receiver.
*
*  @return NSInteger
*/
- (NSInteger)daysInYear {
    if (self.isInLeapYear) {
        return 366;
    }

    return 365;
}

/**
*  Returns whether the receiver falls in a leap year.
*
*  @return NSInteger
*/
- (BOOL)isInLeapYear {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *dateComponents = [calendar components:allCalendarUnitFlags fromDate:self];

    if (dateComponents.year % 400 == 0) {
        return YES;
    }
    else if (dateComponents.year % 100 == 0) {
        return NO;
    }
    else if (dateComponents.year % 4 == 0) {
        return YES;
    }

    return NO;
}

#pragma mark - Date Components With Calendar

/**
*  Returns the era of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the era (0 for BC, 1 for AD for Gregorian)
*/
- (NSInteger)eraWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentEra calendar:calendar];
}

/**
*  Returns the year of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the year as an integer
*/
- (NSInteger)yearWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentYear calendar:calendar];
}

/**
*  Returns the month of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the month as an integer
*/
- (NSInteger)monthWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentMonth calendar:calendar];
}

/**
*  Returns the day of the month of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the day of the month as an integer
*/
- (NSInteger)dayWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentDay calendar:calendar];
}

/**
*  Returns the hour of the day of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the hour of the day as an integer
*/
- (NSInteger)hourWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentHour calendar:calendar];
}

/**
*  Returns the minute of the hour of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the minute of the hour as an integer
*/
- (NSInteger)minuteWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentMinute calendar:calendar];
}

/**
*  Returns the second of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the second as an integer
*/
- (NSInteger)secondWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentSecond calendar:calendar];
}

/**
*  Returns the weekday of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the weekday as an integer
*/
- (NSInteger)weekdayWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentWeekday calendar:calendar];
}

/**
*  Returns the weekday ordinal of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the weekday ordinal as an integer
*/
- (NSInteger)weekdayOrdinalWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentWeekdayOrdinal calendar:calendar];
}

/**
*  Returns the quarter of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the quarter as an integer
*/
- (NSInteger)quarterWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentQuarter calendar:calendar];
}

/**
*  Returns the week of the month of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the week of the month as an integer
*/
- (NSInteger)weekOfMonthWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentWeekOfMonth calendar:calendar];
}

/**
*  Returns the week of the year of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the week of the year as an integer
*/
- (NSInteger)weekOfYearWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentWeekOfYear calendar:calendar];
}

/**
*  Returns the year for week of the year (???) of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the year for week of the year as an integer
*/
- (NSInteger)yearForWeekOfYearWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentYearForWeekOfYear calendar:calendar];
}

/**
*  Returns the day of the year of the receiver from a given calendar
*
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - represents the day of the year as an integer
*/
- (NSInteger)dayOfYearWithCalendar:(NSCalendar *)calendar {
    return [self componentForDate:self type:DTDateComponentDayOfYear calendar:calendar];
}

/**
*  Takes in a date, calendar and desired date component and returns the desired NSInteger
*  representation for that component
*
*  @param date      NSDate - The date to be be mined for a desired component
*  @param component DTDateComponent - The desired component (i.e. year, day, week, etc)
*  @param calendar  NSCalendar - The calendar to be used in the processing (Defaults to Gregorian)
*
*  @return NSInteger
*/
- (NSInteger)componentForDate:(NSDate *)date type:(DTDateComponent)component calendar:(NSCalendar *)calendar {
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    }

    unsigned int unitFlags = 0;

    if (component == DTDateComponentYearForWeekOfYear) {
        unitFlags = NSYearCalendarUnit | NSQuarterCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekOfMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSEraCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekCalendarUnit | NSYearForWeekOfYearCalendarUnit;
    }
    else {
        unitFlags = allCalendarUnitFlags;
    }

    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];

    switch (component) {
        case DTDateComponentEra:
            return [dateComponents era];
        case DTDateComponentYear:
            return [dateComponents year];
        case DTDateComponentMonth:
            return [dateComponents month];
        case DTDateComponentDay:
            return [dateComponents day];
        case DTDateComponentHour:
            return [dateComponents hour];
        case DTDateComponentMinute:
            return [dateComponents minute];
        case DTDateComponentSecond:
            return [dateComponents second];
        case DTDateComponentWeekday:
            return [dateComponents weekday];
        case DTDateComponentWeekdayOrdinal:
            return [dateComponents weekdayOrdinal];
        case DTDateComponentQuarter:
            return [dateComponents quarter];
        case DTDateComponentWeekOfMonth:
            return [dateComponents weekOfMonth];
        case DTDateComponentWeekOfYear:
            return [dateComponents weekOfYear];
        case DTDateComponentYearForWeekOfYear:
            return [dateComponents yearForWeekOfYear];
        case DTDateComponentDayOfYear:
            return [calendar ordinalityOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:date];
        default:
            break;
    }

    return 0;
}

#pragma mark - Date Editing
#pragma mark Date By Adding

/**
*  Returns a date representing the receivers date shifted later by the provided number of years.
*
*  @param years NSInteger - Number of years to add
*
*  @return NSDate - Date modified by the number of desired years
*/
- (NSDate *)dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/**
*  Returns a date representing the receivers date shifted later by the provided number of months.
*
*  @param years NSInteger - Number of months to add
*
*  @return NSDate - Date modified by the number of desired months
*/
- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/**
*  Returns a date representing the receivers date shifted later by the provided number of weeks.
*
*  @param years NSInteger - Number of weeks to add
*
*  @return NSDate - Date modified by the number of desired weeks
*/
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeek:weeks];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/**
*  Returns a date representing the receivers date shifted later by the provided number of days.
*
*  @param years NSInteger - Number of days to add
*
*  @return NSDate - Date modified by the number of desired days
*/
- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/**
*  Returns a date representing the receivers date shifted later by the provided number of hours.
*
*  @param years NSInteger - Number of hours to add
*
*  @return NSDate - Date modified by the number of desired hours
*/
- (NSDate *)dateByAddingHours:(NSInteger)hours {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hours];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/**
*  Returns a date representing the receivers date shifted later by the provided number of minutes.
*
*  @param years NSInteger - Number of minutes to add
*
*  @return NSDate - Date modified by the number of desired minutes
*/
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:minutes];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/**
*  Returns a date representing the receivers date shifted later by the provided number of seconds.
*
*  @param years NSInteger - Number of seconds to add
*
*  @return NSDate - Date modified by the number of desired seconds
*/
- (NSDate *)dateByAddingSeconds:(NSInteger)seconds {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setSecond:seconds];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

#pragma mark Date By Subtracting

/**
*  Returns a date representing the receivers date shifted earlier by the provided number of years.
*
*  @param years NSInteger - Number of years to subtract
*
*  @return NSDate - Date modified by the number of desired years
*/
- (NSDate *)dateBySubtractingYears:(NSInteger)years {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:-1 * years];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/**
*  Returns a date representing the receivers date shifted earlier by the provided number of months.
*
*  @param years NSInteger - Number of months to subtract
*
*  @return NSDate - Date modified by the number of desired months
*/
- (NSDate *)dateBySubtractingMonths:(NSInteger)months {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:-1 * months];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/**
*  Returns a date representing the receivers date shifted earlier by the provided number of weeks.
*
*  @param years NSInteger - Number of weeks to subtract
*
*  @return NSDate - Date modified by the number of desired weeks
*/
- (NSDate *)dateBySubtractingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeek:-1 * weeks];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/**
*  Returns a date representing the receivers date shifted earlier by the provided number of days.
*
*  @param years NSInteger - Number of days to subtract
*
*  @return NSDate - Date modified by the number of desired days
*/
- (NSDate *)dateBySubtractingDays:(NSInteger)days {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1 * days];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/**
*  Returns a date representing the receivers date shifted earlier by the provided number of hours.
*
*  @param years NSInteger - Number of hours to subtract
*
*  @return NSDate - Date modified by the number of desired hours
*/
- (NSDate *)dateBySubtractingHours:(NSInteger)hours {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:-1 * hours];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/**
*  Returns a date representing the receivers date shifted earlier by the provided number of minutes.
*
*  @param years NSInteger - Number of minutes to subtract
*
*  @return NSDate - Date modified by the number of desired minutes
*/
- (NSDate *)dateBySubtractingMinutes:(NSInteger)minutes {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:-1 * minutes];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

/**
*  Returns a date representing the receivers date shifted earlier by the provided number of seconds.
*
*  @param years NSInteger - Number of seconds to subtract
*
*  @return NSDate - Date modified by the number of desired seconds
*/
- (NSDate *)dateBySubtractingSeconds:(NSInteger)seconds {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setSecond:-1 * seconds];

    return [calendar dateByAddingComponents:components toDate:self options:0];
}

#pragma mark - Date Comparison
#pragma mark Time From

/**
*  Returns an NSInteger representing the amount of time in years between the receiver and the provided date.
*  If the receiver is earlier than the provided date, the returned value will be negative.
*  Uses the default Gregorian calendar
*
*  @param date NSDate - The provided date for comparison
*
*  @return NSInteger - The NSInteger representation of the years between receiver and provided date
*/
- (NSInteger)yearsFrom:(NSDate *)date {
    return [self yearsFrom:date calendar:nil];
}

/**
*  Returns an NSInteger representing the amount of time in months between the receiver and the provided date.
*  If the receiver is earlier than the provided date, the returned value will be negative.
*  Uses the default Gregorian calendar
*
*  @param date NSDate - The provided date for comparison
*
*  @return NSInteger - The NSInteger representation of the years between receiver and provided date
*/
- (NSInteger)monthsFrom:(NSDate *)date {
    return [self monthsFrom:date calendar:nil];
}

/**
*  Returns an NSInteger representing the amount of time in weeks between the receiver and the provided date.
*  If the receiver is earlier than the provided date, the returned value will be negative.
*  Uses the default Gregorian calendar
*
*  @param date NSDate - The provided date for comparison
*
*  @return NSInteger - The double representation of the weeks between receiver and provided date
*/
- (NSInteger)weeksFrom:(NSDate *)date {
    return [self weeksFrom:date calendar:nil];
}

/**
*  Returns an NSInteger representing the amount of time in days between the receiver and the provided date.
*  If the receiver is earlier than the provided date, the returned value will be negative.
*  Uses the default Gregorian calendar
*
*  @param date NSDate - The provided date for comparison
*
*  @return NSInteger - The double representation of the days between receiver and provided date
*/
- (NSInteger)daysFrom:(NSDate *)date {
    return [self daysFrom:date calendar:nil];
}

/**
*  Returns an NSInteger representing the amount of time in hours between the receiver and the provided date.
*  If the receiver is earlier than the provided date, the returned value will be negative.
*
*  @param date NSDate - The provided date for comparison
*
*  @return double - The double representation of the hours between receiver and provided date
*/
- (double)hoursFrom:(NSDate *)date {
    return ([self timeIntervalSinceDate:date]) / SECONDS_IN_HOUR;
}

/**
*  Returns an NSInteger representing the amount of time in minutes between the receiver and the provided date.
*  If the receiver is earlier than the provided date, the returned value will be negative.
*
*  @param date NSDate - The provided date for comparison
*
*  @return double - The double representation of the minutes between receiver and provided date
*/
- (double)minutesFrom:(NSDate *)date {
    return ([self timeIntervalSinceDate:date]) / SECONDS_IN_MINUTE;
}

/**
*  Returns an NSInteger representing the amount of time in seconds between the receiver and the provided date.
*  If the receiver is earlier than the provided date, the returned value will be negative.
*
*  @param date NSDate - The provided date for comparison
*
*  @return double - The double representation of the seconds between receiver and provided date
*/
- (double)secondsFrom:(NSDate *)date {
    return [self timeIntervalSinceDate:date];
}

#pragma mark Time From With Calendar

/**
*  Returns an NSInteger representing the amount of time in years between the receiver and the provided date.
*  If the receiver is earlier than the provided date, the returned value will be negative.
*
*  @param date     NSDate - The provided date for comparison
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - The double representation of the years between receiver and provided date
*/
- (NSInteger)yearsFrom:(NSDate *)date calendar:(NSCalendar *)calendar {
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    }

    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [calendar components:NSYearCalendarUnit fromDate:earliest toDate:latest options:0];
    return multiplier * components.year;
}

/**
*  Returns an NSInteger representing the amount of time in months between the receiver and the provided date.
*  If the receiver is earlier than the provided date, the returned value will be negative.
*
*  @param date     NSDate - The provided date for comparison
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - The double representation of the months between receiver and provided date
*/
- (NSInteger)monthsFrom:(NSDate *)date calendar:(NSCalendar *)calendar {
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    }

    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [calendar components:allCalendarUnitFlags fromDate:earliest toDate:latest options:0];
    return multiplier * (components.month + 12 * components.year);
}

/**
*  Returns an NSInteger representing the amount of time in weeks between the receiver and the provided date.
*  If the receiver is earlier than the provided date, the returned value will be negative.
*
*  @param date     NSDate - The provided date for comparison
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - The double representation of the weeks between receiver and provided date
*/
- (NSInteger)weeksFrom:(NSDate *)date calendar:(NSCalendar *)calendar {
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    }

    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [calendar components:NSWeekCalendarUnit fromDate:earliest toDate:latest options:0];
    return multiplier * components.week;
}

/**
*  Returns an NSInteger representing the amount of time in days between the receiver and the provided date.
*  If the receiver is earlier than the provided date, the returned value will be negative.
*
*  @param date     NSDate - The provided date for comparison
*  @param calendar NSCalendar - The calendar to be used in the calculation
*
*  @return NSInteger - The double representation of the days between receiver and provided date
*/
- (NSInteger)daysFrom:(NSDate *)date calendar:(NSCalendar *)calendar {
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:[NSDate defaultCalendar]];
    }

    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:earliest toDate:latest options:0];
    return multiplier * components.day;
}

- (int)differDays:(NSDate *)another {
    double intervalTime = [self timeIntervalSinceReferenceDate] - [another timeIntervalSinceReferenceDate];
    long lTime = (long) intervalTime;
    return lTime / 60 / 60 / 24;
}

- (int)differMinutes:(NSDate *)another {
    double intervalTime = [self timeIntervalSinceReferenceDate] - [another timeIntervalSinceReferenceDate];
    long lTime = (long) intervalTime;
    return (lTime / 60) % 60;
}

- (int)differSeconds:(NSDate *)another {
    double intervalTime = [self timeIntervalSinceReferenceDate] - [another timeIntervalSinceReferenceDate];
    long lTime = (long) intervalTime;
    return lTime % 60;
}


#pragma mark Time Until

/**
*  Returns the number of years until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
*
*  @return NSInteger representiation of years
*/
- (NSInteger)yearsUntil {
    return [self yearsLaterThan:[NSDate date]];
}

/**
*  Returns the number of months until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
*
*  @return NSInteger representiation of months
*/
- (NSInteger)monthsUntil {
    return [self monthsLaterThan:[NSDate date]];
}

/**
*  Returns the number of weeks until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
*
*  @return NSInteger representiation of weeks
*/
- (NSInteger)weeksUntil {
    return [self weeksLaterThan:[NSDate date]];
}

/**
*  Returns the number of days until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
*
*  @return NSInteger representiation of days
*/
- (NSInteger)daysUntil {
    return [self daysLaterThan:[NSDate date]];
}

/**
*  Returns the number of hours until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
*
*  @return double representiation of hours
*/
- (double)hoursUntil {
    return [self hoursLaterThan:[NSDate date]];
}

/**
*  Returns the number of minutes until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
*
*  @return double representiation of minutes
*/
- (double)minutesUntil {
    return [self minutesLaterThan:[NSDate date]];
}

/**
*  Returns the number of seconds until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
*
*  @return double representiation of seconds
*/
- (double)secondsUntil {
    return [self secondsLaterThan:[NSDate date]];
}

#pragma mark Time Ago

/**
*  Returns the number of years the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
*
*  @return NSInteger representiation of years
*/
- (NSInteger)yearsAgo {
    return [self yearsEarlierThan:[NSDate date]];
}

/**
*  Returns the number of months the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
*
*  @return NSInteger representiation of months
*/
- (NSInteger)monthsAgo {
    return [self monthsEarlierThan:[NSDate date]];
}

/**
*  Returns the number of weeks the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
*
*  @return NSInteger representiation of weeks
*/
- (NSInteger)weeksAgo {
    return [self weeksEarlierThan:[NSDate date]];
}

/**
*  Returns the number of days the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
*
*  @return NSInteger representiation of days
*/
- (NSInteger)daysAgo {
    return [self daysEarlierThan:[NSDate date]];
}

/**
*  Returns the number of hours the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
*
*  @return double representiation of hours
*/
- (double)hoursAgo {
    return [self hoursEarlierThan:[NSDate date]];
}

/**
*  Returns the number of minutes the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
*
*  @return double representiation of minutes
*/
- (double)minutesAgo {
    return [self minutesEarlierThan:[NSDate date]];
}

/**
*  Returns the number of seconds the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
*
*  @return double representiation of seconds
*/
- (double)secondsAgo {
    return [self secondsEarlierThan:[NSDate date]];
}

#pragma mark Earlier Than

/**
*  Returns the number of years the receiver's date is earlier than the provided comparison date.
*  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return NSInteger representing the number of years
*/
- (NSInteger)yearsEarlierThan:(NSDate *)date {
    return ABS(MIN([self yearsFrom:date], 0));
}

/**
*  Returns the number of months the receiver's date is earlier than the provided comparison date.
*  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return NSInteger representing the number of months
*/
- (NSInteger)monthsEarlierThan:(NSDate *)date {
    return ABS(MIN([self monthsFrom:date], 0));
}

/**
*  Returns the number of weeks the receiver's date is earlier than the provided comparison date.
*  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return NSInteger representing the number of weeks
*/
- (NSInteger)weeksEarlierThan:(NSDate *)date {
    return ABS(MIN([self weeksFrom:date], 0));
}

/**
*  Returns the number of days the receiver's date is earlier than the provided comparison date.
*  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return NSInteger representing the number of days
*/
- (NSInteger)daysEarlierThan:(NSDate *)date {
    return ABS(MIN([self daysFrom:date], 0));
}

/**
*  Returns the number of hours the receiver's date is earlier than the provided comparison date.
*  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return double representing the number of hours
*/
- (double)hoursEarlierThan:(NSDate *)date {
    return ABS(MIN([self hoursFrom:date], 0));
}

/**
*  Returns the number of minutes the receiver's date is earlier than the provided comparison date.
*  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return double representing the number of minutes
*/
- (double)minutesEarlierThan:(NSDate *)date {
    return ABS(MIN([self minutesFrom:date], 0));
}

/**
*  Returns the number of seconds the receiver's date is earlier than the provided comparison date.
*  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return double representing the number of seconds
*/
- (double)secondsEarlierThan:(NSDate *)date {
    return ABS(MIN([self secondsFrom:date], 0));
}

#pragma mark Later Than

/**
*  Returns the number of years the receiver's date is later than the provided comparison date.
*  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return NSInteger representing the number of years
*/
- (NSInteger)yearsLaterThan:(NSDate *)date {
    return MAX([self yearsFrom:date], 0);
}

/**
*  Returns the number of months the receiver's date is later than the provided comparison date.
*  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return NSInteger representing the number of months
*/
- (NSInteger)monthsLaterThan:(NSDate *)date {
    return MAX([self monthsFrom:date], 0);
}

/**
*  Returns the number of weeks the receiver's date is later than the provided comparison date.
*  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return NSInteger representing the number of weeks
*/
- (NSInteger)weeksLaterThan:(NSDate *)date {
    return MAX([self weeksFrom:date], 0);
}

/**
*  Returns the number of days the receiver's date is later than the provided comparison date.
*  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return NSInteger representing the number of days
*/
- (NSInteger)daysLaterThan:(NSDate *)date {
    return MAX([self daysFrom:date], 0);
}

/**
*  Returns the number of hours the receiver's date is later than the provided comparison date.
*  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return double representing the number of hours
*/
- (double)hoursLaterThan:(NSDate *)date {
    return MAX([self hoursFrom:date], 0);
}

/**
*  Returns the number of minutes the receiver's date is later than the provided comparison date.
*  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return double representing the number of minutes
*/
- (double)minutesLaterThan:(NSDate *)date {
    return MAX([self minutesFrom:date], 0);
}

/**
*  Returns the number of seconds the receiver's date is later than the provided comparison date.
*  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
*
*  @param date NSDate - Provided date for comparison
*
*  @return double representing the number of seconds
*/
- (double)secondsLaterThan:(NSDate *)date {
    return MAX([self secondsFrom:date], 0);
}


#pragma mark Comparators

/**
*  Returns a YES if receiver is earlier than provided comparison date, otherwise returns NO
*
*  @param date NSDate - Provided date for comparison
*
*  @return BOOL representing comparison result
*/
- (BOOL)isEarlierThan:(NSDate *)date {
    if (self.timeIntervalSince1970 < date.timeIntervalSince1970) {
        return YES;
    }
    return NO;
}

/**
*  Returns a YES if receiver is later than provided comparison date, otherwise returns NO
*
*  @param date NSDate - Provided date for comparison
*
*  @return BOOL representing comparison result
*/
- (BOOL)isLaterThan:(NSDate *)date {
    if (self.timeIntervalSince1970 > date.timeIntervalSince1970) {
        return YES;
    }
    return NO;
}

/**
*  Returns a YES if receiver is earlier than or equal to the provided comparison date, otherwise returns NO
*
*  @param date NSDate - Provided date for comparison
*
*  @return BOOL representing comparison result
*/
- (BOOL)isEarlierThanOrEqualTo:(NSDate *)date {
    if (self.timeIntervalSince1970 <= date.timeIntervalSince1970) {
        return YES;
    }
    return NO;
}

/**
*  Returns a YES if receiver is later than or equal to provided comparison date, otherwise returns NO
*
*  @param date NSDate - Provided date for comparison
*
*  @return BOOL representing comparison result
*/
- (BOOL)isLaterThanOrEqualTo:(NSDate *)date {
    if (self.timeIntervalSince1970 >= date.timeIntervalSince1970) {
        return YES;
    }
    return NO;
}

#pragma mark - Formatted Dates
#pragma mark Formatted With Style

/**
*  Convenience method that returns a formatted string representing the receiver's date formatted to a given style
*
*  @param style NSDateFormatterStyle - Desired date formatting style
*
*  @return NSString representing the formatted date string
*/
- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:style];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

/**
*  Convenience method that returns a formatted string representing the receiver's date formatted to a given style and time zone
*
*  @param style    NSDateFormatterStyle - Desired date formatting style
*  @param timeZone NSTimeZone - Desired time zone
*
*  @return NSString representing the formatted date string
*/
- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:style];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:self];
}

/**
*  Convenience method that returns a formatted string representing the receiver's date formatted to a given style and locale
*
*  @param style  NSDateFormatterStyle - Desired date formatting style
*  @param locale NSLocale - Desired locale
*
*  @return NSString representing the formatted date string
*/
- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:style];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

/**
*  Convenience method that returns a formatted string representing the receiver's date formatted to a given style, time zone and locale
*
*  @param style    NSDateFormatterStyle - Desired date formatting style
*  @param timeZone NSTimeZone - Desired time zone
*  @param locale   NSLocale - Desired locale
*
*  @return NSString representing the formatted date string
*/
- (NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:style];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

#pragma mark Formatted With Format

/**
*  Convenience method that returns a formatted string representing the receiver's date formatted to a given date format
*
*  @param format NSString - String representing the desired date format
*
*  @return NSString representing the formatted date string
*/
- (NSString *)formattedDateWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

/**
*  Convenience method that returns a formatted string representing the receiver's date formatted to a given date format and time zone
*
*  @param format   NSString - String representing the desired date format
*  @param timeZone NSTimeZone - Desired time zone
*
*  @return NSString representing the formatted date string
*/
- (NSString *)formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:self];
}

/**
*  Convenience method that returns a formatted string representing the receiver's date formatted to a given date format and locale
*
*  @param format NSString - String representing the desired date format
*  @param locale NSLocale - Desired locale
*
*  @return NSString representing the formatted date string
*/
- (NSString *)formattedDateWithFormat:(NSString *)format locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

/**
*  Convenience method that returns a formatted string representing the receiver's date formatted to a given date format, time zone and locale
*
*  @param format   NSString - String representing the desired date format
*  @param timeZone NSTimeZone - Desired time zone
*  @param locale   NSLocale - Desired locale
*
*  @return NSString representing the formatted date string
*/
- (NSString *)formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

#pragma mark - Helpers

/**
*  Class method that returns whether the given year is a leap year for the Gregorian Calendar
*  Returns YES if year is a leap year, otherwise returns NO
*
*  @param year NSInteger - Year to evaluate
*
*  @return BOOL evaluation of year
*/
+ (BOOL)isLeapYear:(NSInteger)year {
    if (year * 400) {
        return YES;
    }
    else if (year % 100) {
        return NO;
    }
    else if (year % 4) {
        return YES;
    }

    return NO;
}

/**
*  The default calendar used for all non-calendar-specified operations
*
*  @return NSString - NSCalendarIdentifier
*/
+ (NSString *)defaultCalendar {
    return NSGregorianCalendar;
}

@end