//
//  ido_AppDelegate.m
//  iDoctors
//
//  Created by Tabasoft on 09/08/12.
//  Copyright (c) 2012 Tabasoft. All rights reserved.
//

#import "ido_AppDelegate.h"
#import "ido_Model.h"
#import "ido_MockedModel.h"
#import "iRate.h"
#import "ido_NavigationBar.h"
#import "ido_Notifications.h"
#import "ido_Location.h"

#import "CrashlyticsCrashReport.h"
#import "FlurryInstrumentation.h"

typedef void (^ido_GeocoderCompletion)(double, double, NSString*);

@interface ido_AppDelegate () {
    
    BOOL showDirections;
    float latitudine;
    float longitudine;

    VFProcessArguments *processArguments;
    ido_Model *model;
    id<CrashReport> crashReport;
    id<Instrumentation> instrumentation;
    id<DataSeed> dataSeed;
    id<ido_GeocoderProtocol> geocoder;
    CameraPicker *cameraPicker;
    ido_Sezioni *router;
    Logger *logger;
}

@end

@implementation ido_AppDelegate

#pragma mark - Getters

- (id<Instrumentation>)instrumentation {
    return instrumentation;
}

- (id<DataSeed>)dataSeed {
    return dataSeed;
}

- (ido_Model*)model {
    return model;
}

- (id<ido_GeocoderProtocol>)geocoder {
    return geocoder;
}

- (CameraPicker*)cameraPicker {
    return cameraPicker;
}

- (Logger*)logger {
    return logger;
}


#pragma mark - iRate

+ (void)initialize
{
    [iRate sharedInstance].daysUntilPrompt = 2;
    [iRate sharedInstance].usesUntilPrompt = 2;
    
    // debug mode?
    [iRate sharedInstance].previewMode = NO;
    
    [iRate sharedInstance].message = NSLocalizedString(@"Se trovi utile usare iDoctors, vuoi dedicarci pochi secondi del tuo tempo per esprimere la tua opinione? Grazie per il tuo contributo.", @"iRate message");
}

#pragma mark - Dependencies

- (void)initDependencies {
    
    if ([processArguments UseMockClassesForTests]) {
        
        // === MOCKED
        model = [ido_MockedModel new];
        geocoder = [ido_MockedGeocoder new];
        crashReport = [MockedCrashReport new];
        instrumentation = [MockedInstrumentation new];
        cameraPicker = [MockedCameraPicker new];
        dataSeed = NULL;
        
    } else {
      
        // === REAL
        
#ifdef IDOCTORS_DEBUG_MODE
//        model = [ido_MockedModel new];
        model = [ido_CachedModel new];
        cameraPicker = [CameraPicker new];
#else
        model = [ido_CachedModel new];
        cameraPicker = [CameraPicker new];
#endif

        geocoder = [ido_Geocoder new];
        crashReport = [CrashlyticsCrashReport new];
        instrumentation = [FlurryInstrumentation new];

#ifdef IDOCTORS_DEBUG_MODE
        dataSeed = [DebugDataSeed new];
#else
        dataSeed = NULL;
#endif
       
        logger = [Logger new];
    }
}

#pragma mark - App life cycle

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    // Process arguments & UITests
    processArguments = [VFProcessArguments new];
    if ([processArguments UseMockClassesForTests]) {
        
        [[UIApplication sharedApplication] keyWindow].layer.speed = 100;
        [UIView setAnimationsEnabled:false];
    }
    
    // Init
    [self initDependencies];
    
    // CrashReport & Instrumentation
    [crashReport configure];
    [model setCrashReport: crashReport];
    
    NSString *vers = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *buildNo = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    NSString *appVersion = [NSString stringWithFormat:@"%@-%@", vers, buildNo];
    [instrumentation configure:appVersion api_key:@"4M9KFCJGX7TD4NBYQ2FZ"];
    [model setInstrumentation: instrumentation];

    
    IDO_LOG(@"%@", self.window.rootViewController);
    
    NSString *pushServer = [[model getWSServer] stringByAppendingString:@"/apns"];

    showDirections = NO;
    self.notifications = [[ido_Notifications alloc] initWithServerUrl:pushServer application:application options:launchOptions];
    self.notifications.delegate = self;
    self.locations = [ido_Location new];
    self.locations.delegate = self;

    [self setGlobalAppearance];

    // lanciato da una push?
    [self launchedFromNotif:launchOptions];
    if (self.onLaunchNotificationKey && [model hasKeychainCredentials]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLaunchNotificationObserver:) name:USER_LOGIN_NOTIFICATION object:nil];
    }
    
    // questo serve per usare la app nativa nel login FB
    SEL useNativeSel = sel_getUid("useNativeDialogForDialogName:");
    Class FBSDKServerConfiguration = NSClassFromString(@"FBSDKServerConfiguration");
    Method useNativeMethod = class_getInstanceMethod(FBSDKServerConfiguration, useNativeSel);
    IMP returnYES = imp_implementationWithBlock(^BOOL(id me, id dialogName) {
        return YES;
    });
    method_setImplementation(useNativeMethod, returnYES);
    //
    
    [self registerSettingsBundle];
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)onLaunchNotificationObserver:(NSNotification*)notification
{
    if (self.onLaunchNotificationKey) {
        
        [self.notifications didReceiveRemoteNotification:self.onLaunchNotificationKey];
        self.onLaunchNotificationKey = nil;
    }
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url
{
    //ido_IntroViewController *introViewController = (ido_IntroViewController*)self.window.rootViewController;
    //[introViewController handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                          openURL:url
                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (void)applicationWillResignActive:(UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    // stop asking location
    [self.locations locationStop];
    
    // c'è una richiesta in corso?
    [model cancelCurRequest];
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    application.applicationIconBadgeNumber = 0;
    
    [self.locations locationStart];

    [self wsAPI_willEnterForeground];
    
    // lista delle richieste urgenti da ricaricare
    RU_RichiesteListViewController.needsListReload = YES;
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - USER NOTIFICATION APPLICATION DELEGATE METHODS

// chiamato solo se >= iOS8
- (void)application:(UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings
{
    
    [self.notifications didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)devToken
{
    
    NSString *deviceToken = [self.notifications didRegisterForRemoteNotificationsWithDeviceToken:devToken];
    IDO_LOG(@"deviceToken: %@", deviceToken);
    [model setDeviceToken:deviceToken];

}

/**
 * Failed to Register for Remote Notifications
 */
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    [self.notifications didFailToRegisterForRemoteNotificationsWithError:error];
}

/**
 * Remote Notification Received while application was open.
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
    [self.notifications didReceiveRemoteNotification:userInfo];
}

#pragma mark - ido_NotificationsDelegate

- (void)newNotificationForLatitude:(float)latitude longitude:(float)longitude
{
    
    showDirections = YES;
    latitudine = latitude;
    longitudine = longitude;

    [self.locations locationStop];
    [self.locations locationStart];
}

- (void)newNotificationForThreadId:(int)threadId dest:(NSString*)dest body:(NSString*)body
{
    [self _newNotificationForThreadId:threadId dest:dest body:body];
}

- (void)newNotificationForRichiestaId:(int)richiestaId body:(NSString*)body
{
    [self _newNotificationForRichiestaId:richiestaId body:body];
}

#pragma mark - ido_LocationDelegate

- (void)newLocationUpdate:(CLLocation*)location
{

    IDO_LOG(@"--> new update location");

    [model setUserLocation:location];

    if (showDirections && latitudine && longitudine) {
        showDirections = NO;
        
        NSString *addr = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%1.6f,%1.6f&saddr=%1.6f,%1.6f", latitudine, longitudine, location.coordinate.latitude, location.coordinate.longitude];
        NSURL *url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)newLocationError:(NSError*)error
{
    
    [model setUserLocation:NULL];
}

- (BOOL)isLocationDenied
{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    IDO_LOG(@"isLocationDenied? %d", status);
    
    return status == kCLAuthorizationStatusDenied;
    
}

#pragma mark - locationStartIfNeeded

// chiamata dal primo view controller dopo l'intro per cominiciare le locations (viene deferito perché se presenta l'alwrt di permessi, conflitta con quella eventual di iRate).
- (void)locationStartIfNeeded
{
    
    [self.locations locationStartIfNeeded];
}

#pragma mark - dealloc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Alert if location denied

- (void)temporizedAlertForLocationDenied
{
    CLLocation  *curLoc = [model userLocation];
    
    // Alert solo se utente denied location (no alert se restricted o gps/wifi error)
    if (!curLoc && [self isLocationDenied]) {
        NSComparisonResult  dateComparison;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDate *elencoStudiLastAlert = (NSDate *)[userDefaults objectForKey:@"elencoStudiLastAlert"];
        if (elencoStudiLastAlert) {
            NSDate   *_1hourAgo = [[NSDate date] dateByAddingTimeInterval:-60 * 60];
            dateComparison = [elencoStudiLastAlert compare:_1hourAgo];
        } else {
            dateComparison = NSOrderedAscending;
        }
        
        if (dateComparison == NSOrderedAscending) {
            NSString    *errorTitle = @"Avviso";
            NSString    *errorString = @"Per visualizzare lo specialista più vicino a te abilita la localizzazione dalle impostazioni del tuo iPhone";
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle:errorTitle message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [someError show];
            [userDefaults setObject:[NSDate date] forKey:@"elencoStudiLastAlert"];
            [userDefaults synchronize];
        }
    }
}

#pragma mark - appearance

- (void)setGlobalAppearance
{
    // Navigation bar
    [ido_NavigationBar setNavBarAppearance];
    
    // Bar button in search bar
    id barButtonAppearanceInSearchBar = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    [barButtonAppearanceInSearchBar setTitle:@"Annulla"];
}

@end
