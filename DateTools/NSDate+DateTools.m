//
//  NSDate+DateTools.m
//  DateToolsExample
//
//  Created by Matthew York on 3/19/14.
//
//

#import "NSDate+DateTools.h"

typedef NS_ENUM(NSUInteger, DTDateComponent){
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

static const unsigned int allCalendarUnitFlags = NSYearCalendarUnit | NSQuarterCalendarUnit | NSMonthCalendarUnit | NSWeekOfYearCalendarUnit | NSWeekOfMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSEraCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit | NSWeekCalendarUnit | NSYearForWeekOfYearCalendarUnit;

@implementation NSDate (DateTools)

#pragma mark - Time Ago

+ (NSString*)timeAgoSinceDate:(NSDate*)date{
    return [[NSDate date] timeAgoSinceDate:date shortformatting:NO];
}

+ (NSString*)shortTimeAgoSinceDate:(NSDate*)date{
    return [[NSDate date] timeAgoSinceDate:date shortformatting:YES];
}

- (NSString*)timeAgoSinceNow{
    return [self timeAgoSinceDate:[NSDate date] shortformatting:NO];
}

- (NSString*)timeAgoSinceDate:(NSDate*)date{
    return [self timeAgoSinceDate:date shortformatting:NO];
}

-(NSString *)shortTimeAgoSinceNow{
    return [self timeAgoSinceDate:[NSDate date] shortformatting:YES];
}

-(NSString *)shortTimeAgoSinceDate:(NSDate *)date{
    return [self timeAgoSinceDate:date shortformatting:YES];
}

-(NSString *)timeAgoSinceDate:(NSDate *)date shortformatting:(BOOL)shortFormatting{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
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
        componentName = (components.month == 1)? NSLocalizedString(@"month", nil):NSLocalizedString(@"months", nil);
    }
    else if (components.week >= 1) {
        componentValue = components.week;
        componentName = (components.week == 1)? NSLocalizedString(@"week", nil):NSLocalizedString(@"weeks", nil);
    }
    else if (components.day >= 1) {
        componentValue = components.day;
        componentName = (components.day == 1)? NSLocalizedString(@"day", nil):NSLocalizedString(@"days", nil);
    }
    else if (components.hour >= 1) {
        componentValue = components.hour;
        componentName = (components.hour == 1)? NSLocalizedString(@"hour", nil):NSLocalizedString(@"hours", nil);
    }
    else if (components.minute >= 1) {
        componentValue = components.minute;
        componentName = (components.minute == 1)? NSLocalizedString(@"minute", nil):NSLocalizedString(@"minutes", nil);
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

- (NSString*)stringForComponentValue:(NSInteger)componentValue withName:(NSString*)name shortFormatting:(BOOL)shortFormatting
{
    //If shortened formatting is requested, drop the "ago" part of the time ago
    if (shortFormatting) {
        return [NSString stringWithFormat:@"%d%@", componentValue, name];
    }
    else {
        return [NSString stringWithFormat:@"%d %@ %@", componentValue, name, NSLocalizedString(@"ago", nil)];
    }
    
}

#pragma mark - Date Components Without Calendar

- (NSInteger)era{
    return [self componentForDate:self type:DTDateComponentEra calendar:nil];
}

- (NSInteger)year{
    return [self componentForDate:self type:DTDateComponentYear calendar:nil];
}

- (NSInteger)month{
    return [self componentForDate:self type:DTDateComponentMonth calendar:nil];
}

- (NSInteger)day{
    return [self componentForDate:self type:DTDateComponentDay calendar:nil];
}

- (NSInteger)hour{
    return [self componentForDate:self type:DTDateComponentHour calendar:nil];
}

- (NSInteger)minute{
    return [self componentForDate:self type:DTDateComponentMinute calendar:nil];
}

- (NSInteger)second{
    return [self componentForDate:self type:DTDateComponentSecond calendar:nil];
}

- (NSInteger)weekday{
    return [self componentForDate:self type:DTDateComponentWeekday calendar:nil];
}

- (NSInteger)weekdayOrdinal{
    return [self componentForDate:self type:DTDateComponentWeekdayOrdinal calendar:nil];
}

- (NSInteger)quarter{
    return [self componentForDate:self type:DTDateComponentQuarter calendar:nil];
}

- (NSInteger)weekOfMonth{
    return [self componentForDate:self type:DTDateComponentWeekOfMonth calendar:nil];
}

- (NSInteger)weekOfYear{
    return [self componentForDate:self type:DTDateComponentWeekOfYear calendar:nil];
}

- (NSInteger)yearForWeekOfYear{
    return [self componentForDate:self type:DTDateComponentYearForWeekOfYear calendar:nil];
}

- (NSInteger)dayOfYear{
    return [self componentForDate:self type:DTDateComponentDayOfYear calendar:nil];
}

- (NSInteger)daysInMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:self];
    return days.length;
}

#pragma mark - Date Components With Calendar

- (NSInteger)eraWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentEra calendar:calendar];
}

- (NSInteger)yearWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentYear calendar:calendar];
}

- (NSInteger)monthWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentMonth calendar:calendar];
}

- (NSInteger)dayWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentDay calendar:calendar];
}

- (NSInteger)hourWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentHour calendar:calendar];
}

- (NSInteger)minuteWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentMinute calendar:calendar];
}

- (NSInteger)secondWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentSecond calendar:calendar];
}

- (NSInteger)weekdayWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentWeekday calendar:calendar];
}

- (NSInteger)weekdayOrdinalWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentWeekdayOrdinal calendar:calendar];
}

- (NSInteger)quarterWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentQuarter calendar:calendar];
}

- (NSInteger)weekOfMonthWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentWeekOfMonth calendar:calendar];
}

- (NSInteger)weekOfYearWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentWeekOfYear calendar:calendar];
}

- (NSInteger)yearForWeekOfYearWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentYearForWeekOfYear calendar:calendar];
}

- (NSInteger)dayOfYearWithCalendar:(NSCalendar *)calendar{
    return [self componentForDate:self type:DTDateComponentDayOfYear calendar:calendar];
}

-(NSInteger)componentForDate:(NSDate *)date type:(DTDateComponent)component calendar:(NSCalendar *)calendar{
    if (!calendar) {
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }

    NSDateComponents *dateComponents = [calendar components:allCalendarUnitFlags fromDate:date];
    
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
- (NSDate *)dateByAddingYears:(NSInteger)years{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeek:weeks];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)days{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingHours:(NSInteger)hours{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hours];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:minutes];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setSecond:seconds];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

#pragma mark Date By Subtracting
- (NSDate *)dateBySubtractingYears:(NSInteger)years{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:-1*years];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingMonths:(NSInteger)months{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:-1*months];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingWeeks:(NSInteger)weeks{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeek:-1*weeks];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingDays:(NSInteger)days{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1*days];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingHours:(NSInteger)hours{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:-1*hours];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingMinutes:(NSInteger)minutes{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:-1*minutes];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateBySubtractingSeconds:(NSInteger)seconds{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setSecond:-1*seconds];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

#pragma mark - Date Comparison
#pragma mark Time From
-(NSInteger)yearsFrom:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComponents = [calendar components:allCalendarUnitFlags fromDate:self];
    NSDateComponents *compareComponents = [calendar components:allCalendarUnitFlags fromDate:date];
    
    return currentComponents.year - compareComponents.year;
}

-(NSInteger)weeksFrom:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComponents = [calendar components:allCalendarUnitFlags fromDate:self];
    NSDateComponents *compareComponents = [calendar components:allCalendarUnitFlags fromDate:date];
    
    if (currentComponents.year == compareComponents.year) {
        return currentComponents.weekOfYear - compareComponents.weekOfYear;
    }
    else {
        NSInteger yearsAway = [self yearsFrom:date];
        
        if ([self isEarlierThan:date]) {
            return yearsAway*52 + currentComponents.weekOfYear - compareComponents.weekOfYear;
        }
        else {
            return yearsAway*52 + (currentComponents.weekOfYear - compareComponents.weekOfYear);
        }
    }
    
    return 0;
}

-(NSInteger)daysFrom:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComponents = [calendar components:allCalendarUnitFlags fromDate:self];
    NSDateComponents *compareComponents = [calendar components:allCalendarUnitFlags fromDate:date];
    
    if (currentComponents.year == compareComponents.year) {
        return [self dayOfYear] - [date dayOfYear];
    }
    else {
        NSInteger yearsAway = [self yearsFrom:date];
        
        if ([self isEarlierThan:date]) {
            return yearsAway*365 + [self dayOfYear] - [date dayOfYear];
        }
        else {
            return yearsAway*365 + ([self dayOfYear] - [date dayOfYear]);
        }
    }
    
    return 0;
}

-(NSInteger)hoursFrom:(NSDate *)date{
    return ([self timeIntervalSinceDate:date])/SECONDS_IN_HOUR;
}

-(NSInteger)secondsFrom:(NSDate *)date{
    return [self timeIntervalSinceDate:date];
}

#pragma mark Time Until
-(NSInteger)yearsUntil{
    return MAX(0, ([self timeIntervalSinceNow])/SECONDS_IN_YEAR);
}

-(NSInteger)weeksUntil{
    return MAX(0, ([self timeIntervalSinceNow])/SECONDS_IN_WEEK);
}

-(NSInteger)daysUntil{
    return MAX(0, ([self timeIntervalSinceNow])/SECONDS_IN_DAY);
}

-(NSInteger)hoursUntil{
    return MAX(0, ([self timeIntervalSinceNow])/SECONDS_IN_HOUR);
}

-(NSInteger)secondsUntil{
    return MAX(0, [self timeIntervalSinceNow]);
}

#pragma mark Time Ago
-(NSInteger)yearsAgo{
    return ABS(MIN(0, ([self timeIntervalSinceNow])/SECONDS_IN_YEAR));
}

-(NSInteger)weeksAgo{
    return ABS(MIN(0, ([self timeIntervalSinceNow])/SECONDS_IN_WEEK));
}

-(NSInteger)daysAgo{
    return ABS(MIN(0, ([self timeIntervalSinceNow])/SECONDS_IN_DAY));
}

-(NSInteger)hoursAgo{
    return ABS(MIN(0, ([self timeIntervalSinceNow])/SECONDS_IN_HOUR));
}

-(NSInteger)secondsAgo{
    return ABS(MIN(0, [self timeIntervalSinceNow]));
}

#pragma mark Earlier Than
-(NSInteger)yearsEarlierThan:(NSDate *)date{
    return ABS(MIN([self timeIntervalSinceDate:date]/SECONDS_IN_YEAR, 0));
}

-(NSInteger)weeksEarlierThan:(NSDate *)date{
    return ABS(MIN([self timeIntervalSinceDate:date]/SECONDS_IN_WEEK, 0));
}

-(NSInteger)daysEarlierThan:(NSDate *)date{
    return ABS(MIN([self timeIntervalSinceDate:date]/SECONDS_IN_DAY, 0));
}

-(NSInteger)hoursEarlierThan:(NSDate *)date{
    return ABS(MIN([self timeIntervalSinceDate:date]/SECONDS_IN_HOUR, 0));
}

-(NSInteger)minutesEarlierThan:(NSDate *)date{
    return ABS(MIN([self timeIntervalSinceDate:date]/SECONDS_IN_MINUTE, 0));
}

-(NSInteger)secondsEarlierThan:(NSDate *)date{
    return ABS(MIN([self timeIntervalSinceDate:date], 0));
}

#pragma mark Later Than
-(NSInteger)yearsLaterThan:(NSDate *)date{
    return MAX([self timeIntervalSinceDate:date]/SECONDS_IN_YEAR, 0);
}

-(NSInteger)weeksLaterThan:(NSDate *)date{
    return MAX([self timeIntervalSinceDate:date]/SECONDS_IN_WEEK, 0);
}

-(NSInteger)daysLaterThan:(NSDate *)date{
    return MAX([self timeIntervalSinceDate:date]/SECONDS_IN_YEAR, 0);
}

-(NSInteger)hoursLaterThan:(NSDate *)date{
    return MAX([self timeIntervalSinceDate:date]/SECONDS_IN_HOUR, 0);
}

-(NSInteger)minutesLaterThan:(NSDate *)date{
    return MAX([self timeIntervalSinceDate:date]/SECONDS_IN_MINUTE, 0);
}

-(NSInteger)secondsLaterThan:(NSDate *)date{
    return MAX([self timeIntervalSinceDate:date], 0);
}


#pragma mark Comparators
-(BOOL)isEarlierThan:(NSDate *)date{
    if ([[self earlierDate:date] isEqualToDate:self]) {
        return YES;
    }
    return NO;
}

-(BOOL)isLaterThan:(NSDate *)date{
    if ([[self laterDate:date] isEqualToDate:self]) {
        return YES;
    }
    return NO;
}

-(BOOL)isEarlierThanOrEqualToDate:(NSDate *)date{
    if ([[self earlierDate:date] isEqualToDate:self] || [self isEqualToDate:date]) {
        return YES;
    }
    return NO;
}

-(BOOL)isLaterOrEqualToDate:(NSDate *)date{
    if ([[self laterDate:date] isEqualToDate:self] || [self isEqualToDate:date]) {
        return YES;
    }
    return NO;
}

#pragma mark - Formatted Dates
#pragma mark Formatted With Style
-(NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:style];
    return [formatter stringFromDate:self];
}

-(NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:style];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:self];
}

-(NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style locale:(NSLocale *)locale{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:style];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

-(NSString *)formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:style];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

#pragma mark Formatted With Format
-(NSString *)formattedDateWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

-(NSString *)formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:self];
}

-(NSString *)formattedDateWithFormat:(NSString *)format locale:(NSLocale *)locale{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

-(NSString *)formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
     [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}
@end