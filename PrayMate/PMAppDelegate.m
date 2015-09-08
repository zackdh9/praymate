//
//  PMAppDelegate.m
//  PrayMate
//
//  Created by zack on 10/2/14.
//  Copyright (c) 2014 zachary hamblen. All rights reserved.
//

#import "PMAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "PMPersistentTabBorder.h"

@implementation PMAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+(UIColor *)navyColor
{
    return [UIColor colorWithRed:76/255.0f green:149/255.0f blue:197/255.0f alpha:1 ];
}
+(UIColor *)goldColor
{
    return [UIColor colorWithRed:255/255.0f green:173/255.0f blue:28/255.0f alpha:1];
}
+(UIColor *)lightBlueColor
{
    return [UIColor colorWithRed:157/255.0f green:223/255.0f blue:255/255.0f alpha:1];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PMPersistentTabBorder *blueBar = [[PMPersistentTabBorder alloc ] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [blueBar setBackgroundColor:[PMAppDelegate navyColor]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:0.29803992f green:0.58431373f blue:0.77254902f alpha:1]];
    [[UITabBar appearance] addSubview:blueBar];
     
    [Parse setApplicationId:@"4s4JMNcbynUOj3gfg8cDgXrdum7bw2rK6gQRKy40"
                  clientKey:@"Y2AWH4QwFnaDg8x3ktFuIX7GdfOa3Tlfo4Meg3Oi"];
    
   
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Identification" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    NSError *erro;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:&erro];
    if (fetchedObjects == nil) {
        NSLog(@"%@", erro.localizedDescription);
    }
    else if (fetchedObjects.count > 0){
        [token singleton].tokenString = [[fetchedObjects objectAtIndex:0] valueForKey:@"userID"];
        
     
        
        [PFUser logInWithUsernameInBackground:[token singleton].tokenString password:@"1111" block:^(PFUser *user, NSError *error) {
            
            if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
                
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
                [application registerUserNotificationSettings:settings];
                [application registerForRemoteNotifications];
                
                
                
            }
            else
            {
                [application registerForRemoteNotificationTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound)
                 ];
            }
            
        }];
        

    }
    
    
    
    //[token singleton].tokenString =
    
    if ([[token singleton].tokenString isEqualToString:@""]) {
        
        NSString *UUID = [[NSUUID UUID] UUIDString];
        
        [token singleton].tokenString = UUID;
        NSManagedObject *userID = [NSEntityDescription insertNewObjectForEntityForName:@"Identification" inManagedObjectContext:self.managedObjectContext];
        [userID setValue:UUID forKey:@"userID"];
        NSError *error;
        if (![self.managedObjectContext  save:&error]) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
        }
            PFUser *newUser = [[PFUser alloc] init];
            newUser.username = UUID;
            newUser.password = @"1111";
            
            [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [PFUser logInWithUsernameInBackground:[token singleton].tokenString password:@"1111" block:^(PFUser *user, NSError *error) {
                    
                    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
                        
                        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
                        [application registerUserNotificationSettings:settings];
                        [application registerForRemoteNotifications];
                        
                        
                        
                    }
                    else
                    {
                        [application registerForRemoteNotificationTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound)
                         ];
                    }
                    
                }];            }];
            
        
    }
    
    
    
    return YES;
    
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
}
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation setObject:[PFUser currentUser] forKey:@"user"];
    
    currentInstallation.channels = @[@"global", @""];
    [currentInstallation saveInBackground];
    
    
    
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge= 0;
        [currentInstallation saveEventually];
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
           // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PrayMate" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PrayMate.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
       // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
