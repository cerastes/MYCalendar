//
//  Cell.m
//  MYCalendar
//
//  Created by cerastes on 14-10-15.
//  Copyright (c) 2014年 cerastes. All rights reserved.
//

#import "CJCalendarCell.h"

@implementation CJCalendarCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setData:(CJCalendarCellData *)adata{
    _data = adata;
    self.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)_data.day];
    [self.dayLabel sizeToFit];
    self.dayLabel.center = self.contentView.center;
}

-(void)setIsCurrentMonth:(bool)isCurrentMonth{
    if (isCurrentMonth) {
        self.userInteractionEnabled = YES;
        self.dayLabel.textColor = [UIColor blackColor];

    }
    else
    {
        self.dayLabel.textColor = [UIColor grayColor];
//        self.dayLabel.text = @"1";
        self.userInteractionEnabled = NO;
    }
}
@end
