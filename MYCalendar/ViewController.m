//
//  ViewController.m
//  MYCalendar
//
//  Created by cerastes on 14-10-15.
//  Copyright (c) 2014年 cerastes. All rights reserved.
//

#import "ViewController.h"
#import "CJCalendarView.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CJCalendarView *c = [[CJCalendarView alloc]initWithFrame:CGRectMake(10 , 50 , self.view.width-80, 300)];
    [self.view addSubview:c];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
