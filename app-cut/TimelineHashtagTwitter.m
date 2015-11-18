//
//  TimelineHashtagTwitter.m
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 12/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import "TimelineHashtagTwitter.h"

static NSString * const analyticsViewName = @"Timeline Hashtag Twitter";

@interface TimelineHashtagTwitter ()

@end

@implementation TimelineHashtagTwitter

/**
 * Se muestra el timeline de un hashtag y se habilita el botón del 
 * menú.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@", _hashtag];
    
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    TWTRSearchTimelineDataSource *searchTimelineDataSource = [[TWTRSearchTimelineDataSource alloc] initWithSearchQuery:_hashtag APIClient:client];
    self.dataSource = searchTimelineDataSource;
    
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
