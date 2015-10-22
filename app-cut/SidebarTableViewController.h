//
//  SidebarTableViewController.h
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 12/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
#import "TimelineCuentaTwitter.h"
#import "TimelineHashtagTwitter.h"

@interface SidebarTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) NSString * etiqueta;
@property (strong, nonatomic) NSString * tipo;

@end
