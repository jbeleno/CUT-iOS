//
//  FeedModel.m
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 10/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import "FeedModel.h"
#define URL_FEED @"http://52.27.16.14/cut/feed/ver"

@implementation FeedModel

-(id) init{
    _offset = 0;
    _mensajes = [[Mensajes alloc] init];
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _lblError = [[UILabel alloc] init];
    return self;
}

/**
 *   Este método inicializa la fuente de datos en caso de no existir o la devuelve cuando existe
 */
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

/**
 * Este método llena la fuente de datos del feed con diferentes tipos de publicaciones, hasta el
 * momento sólo se está usando artículo como único tipo de publicación
 *
 * Parametros
 * tabla:  Es el valor por referencia de la tabla del feed de publicaciones, se usa para que se
 * actualicen las publicaciones apenas se llena la fuente de los datos
 *
 * view: Es el valor por referencia de la vista de la tabla, se usa para mostrar los errores que
 * puedan aparecer o para mostrar la vista de cargando...
 */
- (void) populateDataSource:(UITableView *)tabla inView:(UIView *)view{
    
    if(_offset == 0){
        [_mensajes cargando:view withIndicator:_indicator];
    }
    
    //Este caso se dá cuando ya no existen más elementos para mostrar en el feed
    if (_offset==-1) {
        [_indicator stopAnimating];
        return;
    }
    NSMutableDictionary *parametros = [ [ NSMutableDictionary alloc ] init ];
    [parametros setObject:[NSNumber numberWithInteger:_offset] forKey:@"offset"];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST: URL_FEED
       parameters:parametros
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [_indicator stopAnimating];
              if(_offset == 0){
                  [_lblError setHidden:YES];
              }
              
              NSLog(@"Datos: %@", responseObject);
              
              NSDictionary * datos = (NSDictionary *)responseObject;
              if([[datos objectForKey:@"status"] isEqualToString:@"OK"]){
                  NSDictionary * items = [datos objectForKey:@"publicaciones"];
                  for(NSDictionary * item in items){
                      [_dataSource addObject:item];
                  }
                  if([items count]==0){
                      if(_offset==0){
                          [_mensajes errorConexion:@"Aún no has enviado ninguna pregunta, envíala ahora en el botón \"Preguntar\"." inView:view withLabel:_lblError];
                      }else{
                          _offset = -1;
                      }
                  }else{
                      _offset++;
                  }
                  [tabla reloadData];
              }else if([[datos objectForKey:@"status"] isEqualToString:@"BAD"]){
                  if(_offset == 0){
                      [_mensajes errorConexion:@"Ocurrió un error cargando las publicaciones de la CUT." inView:view withLabel:_lblError];
                  }
              }else{
                  if(_offset == 0){
                      [_mensajes errorConexion:@"Ocurrió un error cargando las publicaciones de la CUT." inView:view withLabel:_lblError];
                  }
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [_indicator stopAnimating];
              
              if(_offset == 0){
                  [_lblError setHidden:YES];
                  [_mensajes errorConexion:@"Hay problemas con la conexión a internet :(" inView:view withLabel:_lblError];
              }
          }];
}

/**
 * Este método hace un reset al valor del desplazamiento para que muestre de nuevo los valores desde
 * el inicio y se llama al método populateDataSource para cargar las publicaciones actuales
 *
 * Parametros
 * tabla:  Es el valor por referencia de la tabla del feed de publicaciones, se usa para que se
 * actualicen las publicaciones apenas se llena la fuente de los datos
 *
 * view: Es el valor por referencia de la vista de la tabla, se usa para mostrar los errores que
 * puedan aparecer o para mostrar la vista de cargando...
 */
-(void)clearTable:(UITableView *)tabla inView:(UIView *)view{
    _offset = 0;
    [_dataSource removeAllObjects];
    [tabla reloadData];
    [self populateDataSource:tabla inView:view];
}

@end
