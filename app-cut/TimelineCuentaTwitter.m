//
//  TimelineCuentaTwitter.m
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 12/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import "TimelineCuentaTwitter.h"

static NSString * const analyticsViewName = @"Timeline Cuenta Twitter";

@implementation TimelineCuentaTwitter

/**
 * Se muestra el timeline de una cuenta de twitter, 
 * además se pone funcionalidad del botón del menú
 */
 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@", _cuenta];
    
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    TWTRUserTimelineDataSource *userTimelineDataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:_cuenta APIClient:client];
    self.dataSource = userTimelineDataSource;
    
    //Se le agrega funcionalidad al toggle del menú
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:analyticsViewName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

@end
