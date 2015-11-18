//
//  FeedTableViewController.h
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 10/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>
#import "FeedModel.h"
#import "ArticulosTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "SWRevealViewController.h"
#import "WebViewController.h"

@interface FeedTableViewController : UITableViewController

@property (strong, nonatomic) UIRefreshControl * refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) NSString * url_selected;

@end
