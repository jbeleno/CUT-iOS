//
//  Utiles.m
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 10/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import "Mensajes.h"

@implementation Mensajes

/**
 * Este método muestra un loader en la vista
 *
 * Parametros
 * view: Es el valor por referencia de la vista del controlador actual, se usa para sobreponer el
 * loader por encima de esta programaticamente.
 *
 * indicator: Es el valor por referencia del loader que se va a mostrar en la vista
 */
-(void) cargando:(UIView *) view withIndicator:(UIActivityIndicatorView *)indicator{
    indicator.hidesWhenStopped = YES;
    indicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                   UIViewAutoresizingFlexibleRightMargin |
                                   UIViewAutoresizingFlexibleTopMargin |
                                   UIViewAutoresizingFlexibleBottomMargin);
    CGRect viewBounds = view.bounds;
    indicator.center = CGPointMake(CGRectGetMidX(viewBounds), CGRectGetMidY(viewBounds));
    indicator.frame = view.frame;
    indicator.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    [view addSubview:indicator];
    [indicator startAnimating];
}

/**
 * Este método muestra un error en la vista
 *
 * Parametros
 * view: Es el valor por referencia de la vista del controlador actual, se usa para sobreponer el
 * loader por encima de esta programaticamente.
 *
 * lblError: Es el valor por referencia del label que va a contener el mensaje de error a mostrar.
 */
-(void)errorConexion:(NSString *) texto inView:(UIView *) view withLabel:(UILabel *)lblError{
    lblError.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                  UIViewAutoresizingFlexibleRightMargin |
                                  UIViewAutoresizingFlexibleTopMargin |
                                  UIViewAutoresizingFlexibleBottomMargin);
    lblError.frame = CGRectMake(0.0, 0.0, view.frame.size.width, view.frame.size.height);
    lblError.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    lblError.textAlignment = NSTextAlignmentCenter;
    lblError.text = texto;
    lblError.numberOfLines = 0;
    lblError.textColor = [UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0];
    
    [view addSubview:lblError];
    [lblError setHidden:NO];
}

@end
