//
//  TTICalendar.H
//  TeamTTI
//
//  Created by Deepak Sharma on 27.11.18.
//  Copyright © 2018 TeamTTI. All rights reserved.

#import <Foundation/Foundation.h>
#import <FSCalendar/FSCalendar.h>

@protocol TTICalendarDelegate<NSObject>

-(void)selectedDate:(NSDate *)date;

@end

@interface TTICalendar : FSCalendar<FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance>

-(instancetype)initWithFrame:(CGRect)frame withCalendarThemeColor:(UIColor *)themeColor;

@property(nonatomic,strong) UIColor *headerTextColor;
@property(nonatomic,strong) UIColor *weekDaysTextColor;
@property(nonatomic, weak)id<TTICalendarDelegate> caldelegate;
@property(nonatomic, copy) NSDate *dueDate;



@end
