//
//  FirstViewController.m
//  CarouselTables
//
//  Created by xnw on 2021/10/28.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)nextPageAction:(id)sender {
    
    SecondViewController *second = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:second animated:YES];
}



@end
