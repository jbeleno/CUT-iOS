//
//  FeedTableViewController.m
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 10/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import "FeedTableViewController.h"
static NSString * const articuloCellIdentifier = @"celdaArticulo";

@interface FeedTableViewController ()

@property (strong, nonatomic) FeedModel * modelo;

@end

@implementation FeedTableViewController

// Por alguna razón esto es necesario para que funcione el loader de cargar nuevas
// publicaciones
@dynamic refreshControl;

/*
 * Luego de cargarse la vista se coloca un tamaño dinamico a las celdas dependiendo de su
 * contenido para iOS 8.0+, se inicializa el modelo y se llena la fuente de datos del feed
 * se inicializa el refresh control y cuando se use llamará al método ultimasPublicaciones
 * además Se le agrega funcionalidad al toggle del menú para llamar al sidebar menu
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    _modelo = [[FeedModel alloc] init];
    [_modelo populateDataSource:self.tableView inView:self.view];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:244.0/255.0 green:67.0/255.0 blue:54.0/255.0 alpha:1.0];
    [self.refreshControl addTarget:self
                            action:@selector(ultimasPublicaciones)
                  forControlEvents:UIControlEventValueChanged];
    
    //Se le agrega funcionalidad al toggle del menú
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

/*
 * Este método para el refreshControl y limpia el contenido de la tabla para cargar las
 * últimas publicaciones
 */
-(void) ultimasPublicaciones{
    [self.refreshControl endRefreshing];
    [_modelo clearTable:self.tableView inView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_modelo.dataSource count];
}

/*
 * Se crea una instancia de la celda tipo artículo y se llama la función para configurar la celda
 */
- (ArticulosTableViewCell *) celdaArticuloAtIndexPath:(NSIndexPath *)indexPath{
    ArticulosTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:articuloCellIdentifier forIndexPath:indexPath];
    [self configurarCeldaArticulo:cell atIndexPath:indexPath];
    return cell;
}

/*
 * Se toma el item que pertenence a esa posición según el indexPath y se llenan los datos de la celda
 * artículo, finalmente se le agrega a la celda un evento en caso de touch paa ir a ver en detalle el 
 * artículo.
 */
- (void) configurarCeldaArticulo:(ArticulosTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataSourceItem = [_modelo.dataSource objectAtIndex:indexPath.row];
    
    NSURL * urlImg = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataSourceItem objectForKey:@"imagen"]]];
    cell.imagen.image = nil;
    [cell.imagen setImageWithURL:urlImg];
    
    [cell.imagen.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    
    //Se le agrega el gradiente o sombra en la parte inferior a la imagen
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    gradientMask.frame = cell.imagen.bounds;
    gradientMask.colors = @[(id)[UIColor clearColor].CGColor,
                            (id)[UIColor colorWithWhite:0.0f alpha:0.6f].CGColor,
                            (id)[UIColor colorWithWhite:0.0f alpha:0.75f].CGColor
                            ];
    [cell.imagen.layer insertSublayer:gradientMask atIndex:0];
    
    cell.titulo.text = [dataSourceItem valueForKey:@"titulo"];
    cell.tiempo.text = [dataSourceItem valueForKey:@"tiempo"];
    
    cell.tag = indexPath.row;
    [cell setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapArticulo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapArticulo:)];
    [cell addGestureRecognizer:tapArticulo];
}

/**
 * Se envía a la URL indicada
 */
-(void) tapArticulo:(UIGestureRecognizer *)sender{
    _url_selected = [[_modelo.dataSource objectAtIndex:sender.view.tag] valueForKey:@"url"];
    [self performSegueWithIdentifier:@"segue_web" sender:self];
}


/**
 * Se calcula la altura de una celda artículo según los datos que contenga
 */
- (CGFloat)heightForArticuloCellAtIndexPath:(NSIndexPath *)indexPath {
    static ArticulosTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:articuloCellIdentifier];
    });
    [self configurarCeldaArticulo:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

/**
 * Se calcula la altura de una celda cualquiera reajustando lo que es necesario para que la celda
 * tenga una altura dinamica según el contenido.
 */
- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height; // Add 1.0f for the cell separator height
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self heightForArticuloCellAtIndexPath:indexPath];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [_modelo.dataSource count] - 1)
    {
        [_modelo populateDataSource:self.tableView inView:self.view];
    }
    return [self celdaArticuloAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"segue_web"]){
        WebViewController *vista = (WebViewController*) [segue destinationViewController];
        vista.url = _url_selected;
    }
}

@end
