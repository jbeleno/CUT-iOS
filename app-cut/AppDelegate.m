//
//  AppDelegate.m
//  app-cut
//
//  Created by Juan Sebastián Beleño Díaz on 10/10/15.
//  Copyright © 2015 Juan Sebastián Beleño Díaz. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse setApplicationId:@"NNDYlzEjebRiXmZEn0y6g7lqQGk8JAIX5BpxOGKw"
                  clientKey:@"4GesTkbyJ9TGH8U0GrFqbN1uFziwHS8SNENxefou"];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    // Se configura la app de twitter
    [Fabric with:@[[Twitter class]]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *deviceTokenParse = [defaults objectForKey:@"deviceToken"];
    NSLog(@"TOKEN = %@",deviceTokenParse);
    
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    
    // copia de un 1doc3
    if(launchOptions != nil)
    { // LaunchOptions con contenido (viene de notificacion)
        NSDictionary *userInfo = nil;
        userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
        if (userInfo != nil) {
            [self manageNotification:userInfo];
        }
        else
        { // No viene de notificacion
            self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        }
    }
    else
    { // LaunchOptions null
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    }
    /*
    //Si se recibe una notificación se redirige a la vista adecuada
    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    if(apsInfo) {
        NSString *vista = [userInfo objectForKey:@"vista"];
        NSString *identificador = [userInfo objectForKey:@"id"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navController;
        SWRevealViewController *reveal = (SWRevealViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Reveal"];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

        
        if([vista isEqualToString:@"evento"]){
            
            self.window.rootViewController = reveal;
            [self.window makeKeyAndVisible];
            
            navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navEventos"];
            
            EventoViewController *eventoController = (EventoViewController*) [storyboard instantiateViewControllerWithIdentifier:@"vistaEvento"];
            eventoController.idEvento = identificador;
            
            [navController pushViewController:eventoController animated:YES];

            
            [reveal setFrontViewController:navController];
            [reveal setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
        }else if ([vista isEqualToString:@"noticia"]){
            self.window.rootViewController = reveal;
            [self.window makeKeyAndVisible];
            
            navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navNoticias"];
            
            WebViewController *eventoController = (WebViewController*) [storyboard instantiateViewControllerWithIdentifier:@"vistaNoticia"];
            eventoController.url = identificador;
            
            [navController pushViewController:eventoController animated:YES];
            
            
            [reveal setFrontViewController:navController];
            [reveal setFrontViewPosition: FrontViewPositionLeft animated: YES];
        }
    }*/

    
    
    return YES;
}

-(void)manageNotification:(NSDictionary*)apsInfo{
    NSString *vista = [apsInfo objectForKey:@"vista"];
    NSString *identificador = [apsInfo objectForKey:@"id"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController;
    SWRevealViewController *reveal = (SWRevealViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Reveal"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    if([vista isEqualToString:@"evento"]){
        
        self.window.rootViewController = reveal;
        [self.window makeKeyAndVisible];
        
        navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navEventos"];
        
        EventoViewController *eventoController = (EventoViewController*) [storyboard instantiateViewControllerWithIdentifier:@"vistaEvento"];
        eventoController.idEvento = identificador;
        
        [navController pushViewController:eventoController animated:YES];
        
        
        [reveal setFrontViewController:navController];
        [reveal setFrontViewPosition: FrontViewPositionLeft animated: YES];
        
    }else if ([vista isEqualToString:@"noticia"]){
        self.window.rootViewController = reveal;
        [self.window makeKeyAndVisible];
        
        navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"navNoticias"];
        
        WebViewController *eventoController = (WebViewController*) [storyboard instantiateViewControllerWithIdentifier:@"vistaNoticia"];
        eventoController.url = identificador;
        
        [navController pushViewController:eventoController animated:YES];
        
        
        [reveal setFrontViewController:navController];
        [reveal setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:devToken forKey:@"deviceToken"];
    [defaults synchronize];
    
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    NSLog(@"TOKEN = %@",currentInstallation.installationId
          );
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"Se recibió algo");
    [PFPush handlePush:userInfo];
}

@end
