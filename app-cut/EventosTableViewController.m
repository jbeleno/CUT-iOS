//
//  EventosTableViewController.m
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 16/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import "EventosTableViewController.h"
static NSString * const eventoCellIdentifier = @"celdaEvento";

static NSString * const analyticsViewName = @"Eventos";


@interface EventosTableViewController ()

@property (strong, nonatomic) EventosModel * modelo;

@end

@implementation EventosTableViewController

// Por alguna razón esto es necesario para que funcione el loader de cargar nuevos
// eventos
@dynamic refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    _modelo = [[EventosModel alloc] init];
    [_modelo populateDataSource:self.tableView inView:self.view];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor colorWithRed:244.0/255.0 green:67.0/255.0 blue:54.0/255.0 alpha:1.0];
    [self.refreshControl addTarget:self
                            action:@selector(ultimosEventos)
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

-(void)viewWillAppear:(BOOL)animated{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:analyticsViewName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

/*
 * Este método para el refreshControl y limpia el contenido de la tabla para cargar los
 * últimos eventos
 */
-(void) ultimosEventos{
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
- (EventoTableViewCell *) celdaEventoAtIndexPath:(NSIndexPath *)indexPath{
    EventoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:eventoCellIdentifier forIndexPath:indexPath];
    [self configurarCeldaEvento:cell atIndexPath:indexPath];
    return cell;
}

/*
 * Se toma el item que pertenence a esa posición según el indexPath y se llenan los datos de la celda
 * evento, finalmente se le agrega a la celda un evento en caso de touch paa ir a ver en detalle el
 * evento en detalle.
 */
- (void) configurarCeldaEvento:(EventoTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataSourceItem = [_modelo.dataSource objectAtIndex:indexPath.row];
    
    //Se redondea los bordes de la vista
    // border radius
    [cell.contenedor.layer setCornerRadius:2.0f];
    
    // border
    [cell.contenedor.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [cell.contenedor.layer setBorderWidth:0.5f];
    
    NSURL * urlImg = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataSourceItem objectForKey:@"imagen"]]];
    cell.imagen.image = nil;
    [cell.imagen setImageWithURL:urlImg];
    
    cell.titulo.text = [dataSourceItem valueForKey:@"titulo"];
    cell.descripcion.text = [dataSourceItem valueForKey:@"descripcion"];
    cell.tiempo.text = [dataSourceItem valueForKey:@"tiempo"];
    
    cell.tag = [[dataSourceItem valueForKey:@"id"] integerValue];
    [cell setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapEvento = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvento:)];
    [cell addGestureRecognizer:tapEvento];
}

/**
 * Se envía al evento indicado
 */
-(void) tapEvento:(UIGestureRecognizer *)sender{
    _idEvento = [NSString stringWithFormat: @"%ld", (long)sender.view.tag];
    [self performSegueWithIdentifier:@"segue_evento" sender:self];
}

/**
 * Se calcula la altura de una celda evento según los datos que contenga
 */
- (CGFloat)heightForEventoCellAtIndexPath:(NSIndexPath *)indexPath {
    static EventoTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:eventoCellIdentifier];
    });
    [self configurarCeldaEvento:sizingCell atIndexPath:indexPath];
    
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
    return [self heightForEventoCellAtIndexPath:indexPath];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [_modelo.dataSource count] - 1)
    {
        [_modelo populateDataSource:self.tableView inView:self.view];
    }
    
    return [self celdaEventoAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"segue_evento"]){
        EventoViewController *vista = (EventoViewController*) [segue destinationViewController];
        vista.idEvento = _idEvento;
    }
}

@end
