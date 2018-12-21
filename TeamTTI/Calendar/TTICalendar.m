//
//  TTICalendar.m
//  TeamTTI
//
//  Created by Deepak Sharma on 27.11.18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

#import "TTICalendar.h"

@interface TTICalendar() {
    UIColor *_calendarThemeColor;
    UIView *dueDateView;
    UILabel *dueText;
}
@end

@implementation TTICalendar


-(instancetype)initWithFrame:(CGRect)frame withCalendarThemeColor:(UIColor *)themeColor {
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _calendarThemeColor = themeColor;
        self.appearance.todayColor = [UIColor lightGrayColor];
        self.appearance.headerTitleColor = self.headerTextColor ? self.headerTextColor : themeColor;
        self.appearance.weekdayTextColor = self.weekDaysTextColor ? self.weekDaysTextColor : themeColor;
        self.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
        
    }
    return self;
    
}

#pragma matk- Setter methods

-(void)setHeaderTextColor:(UIColor *)headerTextColor {
    _headerTextColor = headerTextColor;
    self.appearance.headerTitleColor = _headerTextColor;
}

-(void)setWeekDaysTextColor:(UIColor *)weekDaysTextColor {
    _weekDaysTextColor = weekDaysTextColor;
    self.appearance.weekdayTextColor = _weekDaysTextColor;
}


#pragma matk- FSCalendarDelegate methods

-(NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
    
    return [NSDate date];
}

-(NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
    
    return calendar.maximumDate;
} 

-(BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    //disable forbidden days and next month date
    return  !([self shouldDisableDate:date] || monthPosition != FSCalendarMonthPositionCurrent) ;
}

-(void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
     NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:_dueDate];
    
    if ([cell.subviews containsObject:dueDateView]) {
        [dueDateView removeFromSuperview];
    }
    
    if ([cell.subviews containsObject:dueText]) {
        [dueText removeFromSuperview];
    }
    
    
    if ((components1.day == components2.day
        && components1.month == components2.month
        && components1.year == components2.year) && monthPosition == FSCalendarMonthPositionCurrent) {
        
        dueDateView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, cell.frame.size.width - 20, cell.frame.size.height - 15)];
        
        dueDateView.layer.borderWidth = 1.0;
        dueDateView.layer.borderColor = [[UIColor redColor] CGColor];
        
        //due to
        dueText = [[UILabel alloc] initWithFrame:CGRectMake(12, cell.frame.size.height - 20, cell.frame.size.width, cell.frame.size.height)];
        [dueText setFont:[UIFont fontWithName:@"Avenir-Book" size:10]];
        [dueText setText:@"Due"];
        [dueText setTextColor:[UIColor redColor]];
        
       
        [cell addSubview:dueDateView];
        [cell addSubview:dueText];

    }
    //geryed out disable date
    if ([self shouldDisableDate:date]) {
        cell.titleLabel.textColor = [UIColor lightGrayColor];
    } else if (calendar.selectedDate == date) {
        cell.titleLabel.textColor = [UIColor whiteColor];
    }
    
//    if(calendar.today == calendar.selectedDate) {
//        if ([date compare:calendar.minimumDate] == NSOrderedAscending) {
//            cell.titleLabel.textColor = [UIColor blackColor];
//        } else {
//            //self.appearance.todayColor = [UIColor whiteColor];
//            cell.titleLabel.textColor = [UIColor blackColor];
//        }
//    }
    
    //hide previous and next month days
    if (monthPosition != FSCalendarMonthPositionCurrent) {
        cell.titleLabel.text = @"";
        if (cell.isSelected) {
            //remove circle layer from previous selected date
            cell.preferredFillSelectionColor = [UIColor whiteColor];
            cell.preferredFillDefaultColor = [UIColor whiteColor];
            cell.preferredTitleSelectionColor = [UIColor whiteColor];
            [cell configureAppearance];
        }
    }
}
 
-(void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    [self.caldelegate selectedDate:date];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition; {
    if(calendar.today == date)  {
        //calendar.appearance.todaySelectionColor = [UIColor whiteColor];
    }
}



#pragma matk- FSCalendarDelegateAppearance methods

//set fill circle color
-(UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date {
    return _calendarThemeColor;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillColorForDate:(NSDate *)date {
    return [UIColor whiteColor];
}


-(BOOL)shouldDisableDate:(NSDate *)date {
    
    return false;
}

-(NSArray *)mapForbiddenWeeks:(NSArray *)forbiddenWeeks {
    NSMutableArray *dayIntArray = [[NSMutableArray alloc] init];
    for (NSString *day in forbiddenWeeks) {
        if ([day isEqualToString:@"sun"]) {
            [dayIntArray addObject:[NSNumber numberWithInt:0]];
        } else if ([day isEqualToString:@"mon"]) {
            [dayIntArray addObject:[NSNumber numberWithInt:1]];
        }
        else if ([day isEqualToString:@"tue"]) {
            [dayIntArray addObject:[NSNumber numberWithInt:2]];
        }
        else if ([day isEqualToString:@"wed"]) {
            [dayIntArray addObject:[NSNumber numberWithInt:3]];
        }
        else if ([day isEqualToString:@"thu"]) {
            [dayIntArray addObject:[NSNumber numberWithInt:4]];
        } else if ([day isEqualToString:@"fri"]) {
            [dayIntArray addObject:[NSNumber numberWithInt:5]];
        } else if ([day isEqualToString:@"sat"]) {
            [dayIntArray addObject:[NSNumber numberWithInt:6]];
        }else {
            [dayIntArray addObject:[NSNumber numberWithInt:999]];
        }
    }
    
    return [dayIntArray copy];
}

@end
