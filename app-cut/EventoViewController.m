//
//  EventoViewController.m
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 17/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import "EventoViewController.h"
#define URL_EVENTO @"http://52.27.16.14/cut/eventos/detalle"

@interface EventoViewController ()

@end

@implementation EventoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self cargarEvento];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 * Carga un evento de la CUT
 */
- (void)cargarEvento{
    
    NSMutableDictionary *parametros = [ [ NSMutableDictionary alloc ] init ];
    [parametros setObject:_idEvento forKey:@"idEvento"];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST: URL_EVENTO
       parameters:parametros
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSLog(@"%@", responseObject);
              
              NSDictionary * datos = (NSDictionary *)responseObject;
              if([[datos objectForKey:@"status"] isEqualToString:@"OK"]){
                  
                  NSDictionary * evento = [datos objectForKey:@"evento"];
                  
                  _titulo.text = [evento objectForKey:@"titulo"];
                  _descripcion.text = [evento objectForKey:@"descripcion"];
                  
                  NSURL * urlImg = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[evento objectForKey:@"imagen"]]];
                  [_imagen setImageWithURL:urlImg];
                  
                  NSString * estilos = @"<style>html, body{font-family: Helvetica, Verdana, Arial;color: #555555; font-size:14px;margin:0; padding:0;}</style>";
                  
                  NSString * htmlString = [NSString stringWithFormat:@"<html>%@<body> %@ </body></html>", estilos, [evento objectForKey:@"agenda"]];
                  NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                  
                  _agenda.attributedText = attrStr;
                  
              }else if([[datos objectForKey:@"status"] isEqualToString:@"BAD"]){
                  _titulo.text = @"Ha ocurrido un error tratando de cargar el evento que estás consultando, por favor intenta más tarde.";
              }else{
                  _titulo.text = @"Ha ocurrido un error tratando de cargar el evento que estás consultando, por favor intenta más tarde.";
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              _titulo.text = @"Ha ocurrido un error tratando de cargar el evento que estás consultando, por favor revisa tu conexión a internet e intenta más tarde.";
          }];
}

@end
