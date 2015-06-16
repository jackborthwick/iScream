//
//  flavorViewController.m
//  iScream
//
//  Created by Jack Borthwick on 6/8/15.
//  Copyright (c) 2015 VizNetwork. All rights reserved.
//

#import "flavorViewController.h"

@interface flavorViewController ()

@property (nonatomic, strong) IBOutlet UILabel *flavorNameLabel;

@end

@implementation flavorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _flavorNameLabel.text = _flavorNameString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
