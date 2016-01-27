//
//  FirstViewController.m
//  FinalPA
//
//  Created by Jorge Medellin on 9/9/15.
//  Copyright © 2015 Grupo Cascadia. All rights reserved.
//

#import "FirstViewController.h"


@interface FirstViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myWorkInProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *myWorkCompletedLabel;

@property int myWorkInProgressCount;
@property int myWorkCompletedCount;

@end

@implementation FirstViewController



-(void)doWork {
    
    // each thread has separate autorelease pool
    @autoreleasepool {
        
        sleep(5); // simulate 5 seconds of work
        
        self.myWorkCompletedCount++;
        // Version 1 - Main Thread
        //[self updateGUI];
        
        // Version 2 - NSObject
        [self performSelectorOnMainThread:@selector(updateGUI) withObject:nil waitUntilDone:NO];
        
    }
    
}

-(void)updateGUI {
    self.myWorkInProgressLabel.text = [NSString stringWithFormat:@"Work In Progress: %i", _myWorkInProgressCount];
    self.myWorkCompletedLabel.text = [NSString stringWithFormat:@"Work Completed: %i", _myWorkCompletedCount];
}



- (IBAction)doSubmitWork:(id)sender {
    
    self.myWorkInProgressCount++;
    [self updateGUI];
    
    
    // Version 1 - Main Thread
    //[self doWork];
    
    // Version 2 - NSObject
    //[self performSelectorInBackground:@selector(doWork) withObject:nil];
    
    // Version 3 - NSThread
    //[NSThread detachNewThreadSelector:@selector(doWork) toTarget:self withObject:nil];
    
    // Version 4 - NSThread
    //NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(doWork) object:nil];
    //[thread start];
    
    // Version 5 - NSOperationQueue
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [self doWork];
    }];
    
    // Version 6 - Grand Central Dispatch (GDC)
    //    dispatch_queue_t queue = dispatch_queue_create("com.grupocascadia.myq", 0);
    //    dispatch_async(queue, ^{
    //        [self doWork];
    //    });

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
