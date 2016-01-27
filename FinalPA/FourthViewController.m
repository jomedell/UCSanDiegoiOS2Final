//
//  FourthViewController.m
//  FinalPA
//
//  Created by Jorge Medellin on 9/9/15.
//  Copyright © 2015 Grupo Cascadia. All rights reserved.
//

#import "FourthViewController.h"

@import Social;

@interface FourthViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myStatusLabel;

@end

@implementation FourthViewController

- (IBAction)doActivityViewController:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://grupocascadia.com"];
    NSArray *array = @[url];
    
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
    vc.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *error) {
        NSLog(@"activityType: %@", activityType);
        NSLog(@"completed: %i", completed);
        NSLog(@"returnedItems: %@", returnedItems);
        NSLog(@"erorr: %@", [error description]);
    };
    
    [self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)doPostToTwitter:(id)sender {
    if (NO == [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        self.myStatusLabel.text = @"Cannot post to Twitter";
        return;
    }
    
    SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    vc.completionHandler = ^(SLComposeViewControllerResult result) {
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                self.myStatusLabel.text = @"SLComposeViewControllerResultCancelled";
                break;
            case SLComposeViewControllerResultDone:
                self.myStatusLabel.text = @"SLComposeViewControllerResultDone";
                break;
        }
    };
    [vc setInitialText:@"Hello Twitter"];
    [vc addURL:[NSURL URLWithString:@"http://grupocascadia.com"]];
    //    [vc addImage:[UIImage imageNamed:@"demo"]];
    
    [self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)doPostToFacebook:(id)sender {
    if (NO == [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        self.myStatusLabel.text = @"Cannot post to Facebook";
        return;
    }
    
    SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    vc.completionHandler = ^(SLComposeViewControllerResult result) {
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                self.myStatusLabel.text = @"SLComposeViewControllerResultCancelled";
                break;
            case SLComposeViewControllerResultDone:
                self.myStatusLabel.text = @"SLComposeViewControllerResultDone";
                break;
        }
    };
    [vc setInitialText:@"Hello Facebook"];
    [vc addURL:[NSURL URLWithString:@"http://grupocascadia.com"]];
    //    [vc addImage:[UIImage imageNamed:@"demo"]];
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
