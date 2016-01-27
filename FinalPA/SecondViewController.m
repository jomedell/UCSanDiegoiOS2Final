//
//  SecondViewController.m
//  FinalPA
//
//  Created by Jorge Medellin on 9/9/15.
//  Copyright © 2015 Grupo Cascadia. All rights reserved.
//

#import "SecondViewController.h"
@import AVFoundation;

@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myTimerCountLabel;
@property (weak, nonatomic) IBOutlet UISwitch *myTimerEnableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *myBackgroundEnableSwitch;
@property (weak, nonatomic) IBOutlet UIButton *myDownloadFileButton;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@property int myTimerCount;
@property NSTimer *myTimer;
@property UIBackgroundTaskIdentifier myBackgroundTaskID;

@property AVAudioPlayer *myAudioPlayer;

@end

@implementation SecondViewController

- (IBAction)doDownloadFile:(id)sender {
    // macro to determine iOS version
    
    NSURLSessionConfiguration *sc;
    //
    //    NSLog(@"%i", __IPHONE_OS_VERSION_MIN_REQUIRED);
    //    NSLog(@"%i", __IPHONE_7_1);
    //    NSLog(@"%i", __IPHONE_8_0);
    //
    //#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
    //    sc = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.grupocascadia.session"];
    //#else
    //    sc = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.grupocascadia.session"];
    //#endif
    
    sc.sessionSendsLaunchEvents = YES;
    sc.discretionary = YES;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sc delegate:self delegateQueue:nil];
    NSURL *myUrl = [NSURL URLWithString:@"http://www.apple.com"];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:myUrl];
    
    [downloadTask resume];
    self.myTextView.text = [downloadTask description];
}

-(void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    
    NSLog(@"session: %@", session);
    NSLog(@"location: %@", location);
    NSLog(@"downloadTask: %@", downloadTask);
    
    // read the file into a string
    NSError *myError = nil;
    NSString *s = [NSString stringWithContentsOfFile:location.path encoding:NSUTF8StringEncoding error:&myError];
    
    // must do this on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        self.myTextView.text = s;
    });
}

- (IBAction)doStartStopAudio:(id)sender {
    if (self.myAudioPlayer.isPlaying) {
        [self.myAudioPlayer pause];
    }
    else {
        [self.myAudioPlayer play];
    }
}

-(void)displayApplicationState {
    switch ([UIApplication sharedApplication].applicationState) {
        case UIApplicationStateActive:
            NSLog(@"UIApplicationStateActive");
            break;
        case UIApplicationStateBackground:
            NSLog(@"UIApplicationStateBackground");
            break;
        case UIApplicationStateInactive:
            NSLog(@"UIApplicationStateInactive");
            break;
    }
}

-(void)doTimer:(NSTimer *)timer {
    self.myTimerCount++;
    NSString *s = [NSString stringWithFormat:@"Timer Count: %i", _myTimerCount];
    self.myTimerCountLabel.text = s;
    NSLog(@"timeRemaining: %f", [UIApplication sharedApplication].backgroundTimeRemaining);
    [self displayApplicationState];
    NSLog(@"%@", s);
}

- (IBAction)doTimerEnableSwitch:(id)sender {
    UISwitch *swtch = sender;
    if (swtch.on) {
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(doTimer:) userInfo:nil repeats:YES];
    }
    else {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}

- (IBAction)doBackgroundEnableSwitch:(UISwitch *)swtch {
    if (swtch.on) {
        self.myBackgroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            // todo
            NSLog(@"time out!");
        }];
    }
    else {
        [[UIApplication sharedApplication] endBackgroundTask:self.myBackgroundTaskID];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTextView.text = @"";
    self.myTextView.editable = NO;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"02 Black Magic Woman copy" withExtension:@"mp3"];
    NSError *myError = nil;
    self.myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&myError];
    if (myError) {
        NSLog(@"error");
    }
    else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
    }
    
    self.myTimerEnableSwitch.on = NO;
    self.myBackgroundEnableSwitch.on = NO;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        // code goes here
        int count = 0;
        while (1) {
            count++;
            sleep(5);
            NSLog(@"%s, %i", __func__, count);
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
