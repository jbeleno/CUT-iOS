//
//  InformacionViewController.m
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 16/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import "InformacionViewController.h"

@interface InformacionViewController ()

@end

@implementation InformacionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Se le agrega funcionalidad al toggle del menú
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

@end
