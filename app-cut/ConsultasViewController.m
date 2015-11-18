//
//  ConsultasViewController.m
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 17/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import "ConsultasViewController.h"
#define URL_CONSULTAR @"http://52.27.16.14/cut/consultas/nueva"

static NSString * const analyticsViewName = @"Consultas";

@interface ConsultasViewController ()

@property CGPoint svos;

@end

@implementation ConsultasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Cuando se da touch en la vista se baja el teclado
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(bajarTeclado)];
    
    [self.view addGestureRecognizer:tap];
    
    // Se le pone bordes a las cajas de texto
    [self initUI];
    
    //Se le agrega funcionalidad al toggle del menú
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // Se cambia el texto de la tecla return a Send
    _correo.returnKeyType = UIReturnKeySend;
    _consulta.returnKeyType = UIReturnKeySend;
}

-(void)viewWillAppear:(BOOL)animated{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:analyticsViewName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

/**
 * Le quita el foco a los editables y baja el teclado
 */
-(void)bajarTeclado{
    [self.view endEditing:YES];
    [_scrollView setContentOffset:_svos animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * Se envia la consulta si dan en el botón enviar del teclado
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self enviar:self];
    return NO;
}

/**
 * Se envia la consulta si dan en el botón enviar del teclado
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self enviar:self];
        return NO;
    }
    
    return YES;
}

/*
 * Si el textfield toma el foco el scrollView se sube
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _svos = (CGPoint) _scrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:_scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [_scrollView setContentOffset:pt animated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    _svos = (CGPoint) _scrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:_scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [_scrollView setContentOffset:pt animated:YES];
    
    //Se simula el comportamiento de un placeholder en un textView
    if ([textView.text isEqualToString:@"Escribe aquí tu consulta acerca de temas laborales, sindicales, etc."]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    //Se simula el comportamiento de un placeholder en un textView
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Escribe aquí tu consulta acerca de temas laborales, sindicales, etc.";
    }
}


/**
 * Pone color a los bordes de las cajas de texto y los redondea a 2px
 */
-(void) initUI{
    _correo.layer.cornerRadius=2.0f;
    _correo.layer.masksToBounds=YES;
    _correo.layer.borderColor=[[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]CGColor];
    _correo.layer.borderWidth= 1.0f;
    
    _consulta.layer.cornerRadius=2.0f;
    _consulta.layer.masksToBounds=YES;
    _consulta.layer.borderColor=[[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]CGColor];
    _consulta.layer.borderWidth= 1.0f;
}


/**
 * Bloquea el botón de enviar mientras envía la consulta al correo que la CUT especifique
 */
- (IBAction)enviar:(id)sender {
    [_btnEnviar setEnabled:NO];
    
    NSMutableDictionary *parametros = [ [ NSMutableDictionary alloc ] init ];
    [parametros setObject:_correo.text forKey:@"correo"];
    [parametros setObject:_consulta.text forKey:@"mensaje"];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST: URL_CONSULTAR
       parameters:parametros
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [_btnEnviar setEnabled:YES];
              
              NSLog(@"%@", responseObject);
              
              NSDictionary * datos = (NSDictionary *)responseObject;
              if([[datos objectForKey:@"status"] isEqualToString:@"OK"]){
                  
                  [_consulta setText:@""];
                  [_correo setText:@""];
                  
                  UIAlertView * enviada = [[UIAlertView alloc] initWithTitle:@"CUT" message:@"Tu consulta ha sido enviada, pronto la CUT  te contactará por el correo que proporcionaste." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                  [enviada show];
                  
              }else if([[datos objectForKey:@"status"] isEqualToString:@"BAD"]){
                  UIAlertView * error = [[UIAlertView alloc] initWithTitle:@"CUT" message:@"Ha ocurrido un error en el envío de tu consulta, revisa los datos antes antes de enviarlos e intenta más tarde." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                  [error show];
              }else{
                  UIAlertView * error = [[UIAlertView alloc] initWithTitle:@"CUT" message:@"Ha ocurrido un error en el envío de tu consulta, por favor intenta más tarde." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                  [error show];
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [_btnEnviar setEnabled:YES];
              
              UIAlertView * errorMsj = [[UIAlertView alloc] initWithTitle:@"CUT" message:@"Ha ocurrido un error en el envío de tu consulta, por favor verifica tu conexión a internet o intenta más tarde." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
              [errorMsj show];
          }];
}
@end
