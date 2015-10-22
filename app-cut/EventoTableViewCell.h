//
//  EventoTableViewCell.h
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 16/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagen;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *tiempo;
@property (weak, nonatomic) IBOutlet UIView *contenedor;
@property (weak, nonatomic) IBOutlet UILabel *descripcion;

@end
