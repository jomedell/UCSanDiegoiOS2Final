//
//  ThirdViewController.m
//  FinalPA
//
//  Created by Jorge Medellin on 9/9/15.
//  Copyright © 2015 Grupo Cascadia. All rights reserved.
//

#import "ThirdViewController.h"

#define LONG_RUNNING_WORK_COMPLETE_NOTIFICATION @"LongRunningWorkCompleteNotification"

@interface ThirdViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myLongRunningOpsInProgressCount;
@property (weak, nonatomic) IBOutlet UILabel *myLongRunningOpsCompleteCount;
@property (weak, nonatomic) IBOutlet UISwitch *myDebugModeSwitch;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@property NSMutableString *ms;
@property int myOpsInProgressCount;
@property int myOpsCompleteCount;

@end

@implementation ThirdViewController

-(void)updateDisplay
{
    self.myLongRunningOpsInProgressCount.text = [NSString stringWithFormat:@"Ops in progress: %i", self.myOpsInProgressCount];
    self.myLongRunningOpsCompleteCount.text = [NSString stringWithFormat:@"Ops complete: %i", self.myOpsCompleteCount];
    
}

- (IBAction)doStartLongRunningButton:(id)sender {
    self.myOpsInProgressCount++;
    [self updateDisplay];
    
    // Start the ling running ops
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        // simulate a long operation
        sleep(5);
        dispatch_async(dispatch_get_main_queue(), ^{
            //send notification that we are done
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:LONG_RUNNING_WORK_COMPLETE_NOTIFICATION object:nil];
        });
    });
}

#define KEY_DEBUG_SWITCH @"DebugSwitch"

- (IBAction)doDebugSwitch:(id)sender {
    // just save the state for demo purposes
    [[NSUserDefaults standardUserDefaults] setBool:self.myDebugModeSwitch.on forKey:KEY_DEBUG_SWITCH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)updateTextView:(NSString *)msg {
    [self.ms appendFormat:@"%@\n", msg];
    self.myTextView.text = self.ms;
}

-(void)doDidEnterBackground:(NSNotification *)notification
{
    [self updateTextView:UIApplicationDidEnterBackgroundNotification];
}

-(void)doUserDefaultsChanged:(NSNotification *)notification
{
    [self updateTextView:NSUserDefaultsDidChangeNotification];
    // read new value of debug switch
    self.myDebugModeSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_DEBUG_SWITCH];
}

-(void)doLongRunningOpComplete:(NSNotification *)notification
{
    [self updateTextView:@"Long Running Op Complete!"];
    // update competion count
    self.myOpsCompleteCount++;
    [self updateDisplay];
}


- (IBAction)doSendLocalNotification:(id)sender {
    // create the notification
    static int count;
    count++;
    
    UILocalNotification *lc = [[UILocalNotification alloc] init];
    
    lc.fireDate = [NSDate dateWithTimeIntervalSinceNow:15.0]; // 15 seconds
    
    NSString *s = [NSString stringWithFormat:@"alertBody %i", count];
    lc.alertBody = s;
    lc.hasAction = YES;
    
    lc.soundName = UILocalNotificationDefaultSoundName;
    
    lc.category = @"myCategory";
    
    [[UIApplication sharedApplication] scheduleLocalNotification:lc];
}


- (IBAction)doRegisterForLocalNotification:(id)sender {
    // step 1 - create some actions
    UIMutableUserNotificationAction *nAccept = [[UIMutableUserNotificationAction alloc] init];
    nAccept.identifier = @"accept";
    nAccept.title = @"Accept";
    nAccept.activationMode = UIUserNotificationActivationModeBackground;
    nAccept.authenticationRequired = NO;
    nAccept.destructive = NO;
    
    UIMutableUserNotificationAction *nDeny = [[UIMutableUserNotificationAction alloc] init];
    nDeny.identifier = @"deny";
    nDeny.title = @"Deny";
    nDeny.activationMode = UIUserNotificationActivationModeBackground;
    nDeny.authenticationRequired = NO;
    nDeny.destructive = YES;
    
    // step 2 - put into category
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"myCategory";
    [category setActions:@[nAccept, nDeny] forContext:UIUserNotificationActionContextMinimal];
    
    // step 3 - notification types
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    
    NSSet *categories = [NSSet setWithObjects:category, nil];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    // replaced when adding Mutable User Notification Action
    //    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    //
    //    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    //
    //    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // keep track of events here
    self.ms = [NSMutableString stringWithFormat:@"%@\n---\n", self.myTextView.text];
    
    // initialize the switch to last value
    self.myDebugModeSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_DEBUG_SWITCH];
    
    
    // Receive notification when app going into background
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(doDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    // Register to receive notification when user-defaults change
    [nc addObserver:self selector:@selector(doUserDefaultsChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
    
    // Register to receive a notification when long-running operation complete
    [nc addObserver:self selector:@selector(doLongRunningOpComplete:) name:LONG_RUNNING_WORK_COMPLETE_NOTIFICATION object:nil];
    
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
