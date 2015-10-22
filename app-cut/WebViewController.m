//
//  WebViewController.m
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 17/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Eliminar los 64px de espacio extra en el bottom
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Se carga la web
    [self loadWeb:_url];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) loadWeb: (NSString *) urlAddress{
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Request Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [_web loadRequest:requestObj];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title = [_web stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
