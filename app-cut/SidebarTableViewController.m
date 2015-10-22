//
//  SidebarTableViewController.m
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 12/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import "SidebarTableViewController.h"
#define URL_TWITTER @"http://52.27.16.14/cut/twitter/informacion"

@interface SidebarTableViewController ()

@end

@implementation SidebarTableViewController

/**
 * Se establecen por defectos los valores de la cuenta/hashtag de twitter que se va a 
 * usar y se llena el array del menú con los valores de los identificadores de las 
 * celdas de la tabla.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menuItems = @[@"banner", @"noticias", @"eventos", @"redes_sociales", @"consultas", @"informacion"];
    _etiqueta = @"cutcolombia";
    _tipo = @"cuenta";
}

/**
 * Cuando el usuario despliega el menú se cargan las etiquetas de twitter
 */
-(void)viewWillAppear:(BOOL)animated{
    [self loadTwitterData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuItems.count;
}

/**
 * Se toma la celda según el indexPath y se muestra
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [_menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

/**
 * Las celdas del sidebar menú por defecto están en 44 de alto, pero para el logo de la CUT 
 * la celda es de 80 de alto
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 80;
    }
    return 44;
}

/**
 * Si la celda seleccionada es la de redes sociales, se envía a una vista diferente
 * según el tipo que corresponda hashtag o cuenta
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([[_menuItems objectAtIndex:indexPath.row] isEqualToString:@"redes_sociales"]){
        if ([_tipo isEqualToString:@"cuenta"]) {
            [self performSegueWithIdentifier:@"segue_cuenta_twitter" sender:self];
        }else{
            [self performSegueWithIdentifier:@"segue_hashtag_twitter" sender:self];
        }
    }
}

-(void)loadTwitterData{
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST: URL_TWITTER
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSDictionary * datos = (NSDictionary *)responseObject;
              if([[datos objectForKey:@"status"] isEqualToString:@"OK"]){
                  
                  NSDictionary * informacion = [datos objectForKey:@"informacion"];
                  
                  _etiqueta = [informacion objectForKey:@"etiqueta"];
                  _tipo = [informacion objectForKey:@"tipo"];
                  
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
          }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
    if([segue.identifier isEqualToString:@"segue_cuenta_twitter"]){
        TimelineCuentaTwitter * vista = (TimelineCuentaTwitter *) navController.topViewController;
        vista.cuenta = _etiqueta;
    }else if([segue.identifier isEqualToString:@"segue_hashtag_twitter"]){
        TimelineHashtagTwitter * vista = (TimelineHashtagTwitter *) navController.topViewController;
        vista.hashtag = _etiqueta;
    }
}

@end
