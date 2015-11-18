//
//  EventosTableViewController.h
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 16/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventosModel.h"
#import "EventoTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "SWRevealViewController.h"
#import "EventoViewController.h"
#import <Google/Analytics.h>

@interface EventosTableViewController : UITableViewController

@property (strong, nonatomic) UIRefreshControl * refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong,nonatomic) NSString * idEvento;

@end
