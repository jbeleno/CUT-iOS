//
//  ConsultasViewController.h
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 17/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AFHTTPRequestOperationManager.h"


@interface ConsultasViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *correo;
@property (weak, nonatomic) IBOutlet UITextView *consulta;
@property (weak, nonatomic) IBOutlet UIButton *btnEnviar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)enviar:(id)sender;

@end
