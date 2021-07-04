//
//  FSCalendarStaticHeader.m
//  FSCalendar
//
//  Created by dingwenchao on 9/17/15.
//  Copyright (c) 2015 Wenchao Ding. All rights reserved.
//

#import "FSCalendarStickyHeader.h"
#import "FSCalendar.h"
#import "FSCalendarWeekdayView.h"
#import "FSCalendarExtensions.h"
#import "FSCalendarConstants.h"
#import "FSCalendarDynamicHeader.h"

@interface FSCalendarStickyHeader ()

@property (weak  , nonatomic) UIView  *contentView;
@property (weak  , nonatomic) UIView  *bottomBorder;
@property (weak  , nonatomic) FSCalendarWeekdayView *weekdayView;

@end

@implementation FSCalendarStickyHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *view;
        view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        self.contentView = view;

        UIView *titleView;
        UILabel *titleLabel;
        UILabel *subtitleLabel;

        titleView = [[UIView alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:titleView];
        self.titleView = titleView;

        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        [titleView addSubview:titleLabel];
        self.titleLabel = titleLabel;

        subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.numberOfLines = 0;
        [titleView addSubview:subtitleLabel];
        self.subtitleLabel = subtitleLabel;
        
        view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = FSCalendarStandardLineColor;
        [_contentView addSubview:view];
        self.bottomBorder = view;
        
        FSCalendarWeekdayView *weekdayView = [[FSCalendarWeekdayView alloc] init];
        [self.contentView addSubview:weekdayView];
        self.weekdayView = weekdayView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _contentView.frame = self.bounds;

    CGFloat weekdayHeight = _calendar.preferredWeekdayHeight;
    CGFloat weekdayMargin = self.calendar.appearance.weekdayBottomMargin;
    
    self.weekdayView.frame = CGRectMake(0, _contentView.fs_height-weekdayHeight-weekdayMargin, self.contentView.fs_width, weekdayHeight);

    CGFloat titleHeight = [@"1" sizeWithAttributes:@{NSFontAttributeName:self.calendar.appearance.headerTitleFont}].height;
    CGFloat subtitleHeight = [@"1" sizeWithAttributes:@{NSFontAttributeName:self.calendar.appearance.headerSubtitleFont}].height;
    titleHeight = MAX(titleHeight, subtitleHeight);
    
    _bottomBorder.frame = CGRectMake(0, _contentView.fs_height-weekdayMargin, _contentView.fs_width, 1.0);

    CGPoint titleHeaderOffset = self.calendar.appearance.headerTitleOffset;
    _titleView.frame = CGRectMake(titleHeaderOffset.x, titleHeaderOffset.y+(_contentView.fs_height / 2)-(titleHeight / 2)-(weekdayHeight / 2), _contentView.fs_width, titleHeight);
    _titleLabel.frame = CGRectMake(self.calendar.appearance.headerTitleLeftMargin, 0, _contentView.fs_width / 2 - self.calendar.appearance.headerTitleLeftMargin, titleHeight);

    if (self.calendar.appearance.hasHeaderSubtitle) {
        _subtitleLabel.frame = CGRectMake(_contentView.fs_width / 2, 0, _contentView.fs_width / 2 - self.calendar.appearance.headerSubtitleRightMargin, titleHeight);
    } else {
        _subtitleLabel.frame = CGRectMake(0, 0, 0, 0);
    }
}

#pragma mark - Properties

- (void)setCalendar:(FSCalendar *)calendar
{
    if (![_calendar isEqual:calendar]) {
        _calendar = calendar;
        _weekdayView.calendar = calendar;
        [self configureAppearance];
    }
}

#pragma mark - Private methods

- (void)configureAppearance
{
    _titleLabel.font = self.calendar.appearance.headerTitleFont;
    _titleLabel.textColor = self.calendar.appearance.headerTitleColor;
//    _titleLabel.textAlignment = self.calendar.appearance.headerTitleAlignment;
    _titleLabel.textAlignment = NSTextAlignmentLeft;

    _subtitleLabel.font = self.calendar.appearance.headerSubtitleFont;
    _subtitleLabel.textColor = self.calendar.appearance.headerSubtitleColor;
    _subtitleLabel.textAlignment = NSTextAlignmentRight;

    _bottomBorder.backgroundColor = self.calendar.appearance.headerSeparatorColor;
    [self.weekdayView configureAppearance];
}

- (void)setMonth:(NSDate *)month
{
    _month = month;
    _calendar.formatter.dateFormat = self.calendar.appearance.headerDateFormat;
    BOOL usesUpperCase   = (self.calendar.appearance.caseOptions & 15) == FSCalendarCaseOptionsHeaderUsesUpperCase;
    BOOL usesCapitalized = (self.calendar.appearance.caseOptions & 15) == FSCalendarCaseOptionsHeaderUsesCapitalized;

    NSString *text = [_calendar.formatter stringFromDate:_month];
    if (usesUpperCase) {
        text = text.uppercaseString;
    } else if (usesCapitalized) {
        text = text.capitalizedString;
    }
    self.titleLabel.text = text;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = self.calendar.appearance.headerSubDateFormat;
    NSString *subtext = [formatter stringFromDate:month];
    self.subtitleLabel.text = subtext;
}

@end


