//
//  EventoViewController.h
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 17/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+AFNetworking.h"
#import <Google/Analytics.h>

@interface EventoViewController : UIViewController

@property (weak, nonatomic) NSString * idEvento;
@property (weak, nonatomic) IBOutlet UIImageView *imagen;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *descripcion;
@property (weak, nonatomic) IBOutlet UILabel *agenda;

@end
