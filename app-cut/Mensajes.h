//
//  Utiles.h
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 10/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Mensajes : NSObject

-(void) cargando:(UIView *) view withIndicator:(UIActivityIndicatorView *) indicator;
-(void)errorConexion:(NSString *) texto inView:(UIView *) view withLabel:(UILabel *)lblError;

@end
