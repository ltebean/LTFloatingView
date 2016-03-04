//
//  ViewController.m
//  LTFloatingView
//
//  Created by ltebean on 16/3/4.
//  Copyright © 2016年 ltebean. All rights reserved.
//

#import "ViewController.h"
#import "LTFloatingView.h"

@interface ViewController ()<LTFloatingViewDelegate>
@property (weak, nonatomic) IBOutlet LTFloatingView *floatingView;
@property (nonatomic) NSInteger counter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.floatingView registerViewClass:[UILabel class]];
    self.floatingView.stayingSeconds = 4;
    self.floatingView.viewSpacing = 5;
    self.floatingView.delegate = self;
}

- (void)configureView:(UIView *)view withData:(id)data
{
    UILabel *label = (UILabel *)view;
    NSString *text = (NSString *)data;
    
    label.frame = CGRectMake(10, 0, 150, 30);
    label.textColor = [UIColor whiteColor];
    view.backgroundColor = [UIColor blackColor];
    label.text = text;
}

- (IBAction)pushButtonPressed:(id)sender {
    self.counter++;
    [self.floatingView pushDataToLast:[NSString stringWithFormat:@"  %ld", self.counter]];
}

- (IBAction)speedChanged:(UISlider *)sender {
    self.floatingView.stayingSeconds = sender.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
