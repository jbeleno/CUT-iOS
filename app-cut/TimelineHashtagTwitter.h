//
//  TimelineHashtagTwitter.h
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 12/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>
#import "SWRevealViewController.h"
#import <Google/Analytics.h>

@interface TimelineHashtagTwitter : TWTRTimelineViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) NSString * hashtag;

@end
