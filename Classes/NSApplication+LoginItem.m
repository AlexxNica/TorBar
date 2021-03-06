//
//  NSApplication+LoginItem.m
//  TorBar
//
//  Created by Steve Dekorte on 10/8/14.
//
//

#import "NSApplication+LoginItem.h"

@implementation NSApplication (LoginItem)

- (BOOL)launchesOnLogin
{
    return [NSUserDefaults.standardUserDefaults boolForKey:@"launchesOnLogin"];
}

- (void)setLaunchesOnLogin:(BOOL)aBool
{
    [NSUserDefaults.standardUserDefaults setBool:aBool forKey:@"launchesOnLogin"];
    [NSUserDefaults.standardUserDefaults synchronize];
    
    if (aBool)
    {
        [self addAppAsLoginItem];
    }
    else
    {
        [self deleteAppFromLoginItem];
    }
}

- (void)addAppAsLoginItem
{
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    
    // This will retrieve the path for the application
    // For example, /Applications/test.app
    CFURLRef url = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:appPath]);
    
    // Create a reference to the shared file list.
    // We are adding it to the current user only.
    // If we want to add it all users, use
    // kLSSharedFileListGlobalLoginItems instead of
    //kLSSharedFileListSessionLoginItems
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
                                                            kLSSharedFileListSessionLoginItems, NULL);
    if (loginItems)
    {
        //Insert an item to the list.
        LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems,
                                                                     kLSSharedFileListItemLast, NULL, NULL,
                                                                     url, NULL, NULL);
        if (item)
        {
            CFRelease(item);
        }
    }
    
    CFRelease(loginItems);
}

- (void)deleteAppFromLoginItem
{
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    
    // This will retrieve the path for the application
    // For example, /Applications/test.app
    CFURLRef url = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:appPath]);
    
    // Create a reference to the shared file list.
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
                                                            kLSSharedFileListSessionLoginItems, NULL);
    
    if (loginItems)
    {
        UInt32 seedValue;
        //Retrieve the list of Login Items and cast them to
        // a NSArray so that it will be easier to iterate.
        NSArray  *loginItemsArray = (NSArray *)CFBridgingRelease(LSSharedFileListCopySnapshot(loginItems, &seedValue));
        
        for(int i = 0; i< [loginItemsArray count]; i++)
        {
            LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)CFBridgingRetain([loginItemsArray
                                                                                         objectAtIndex:i]);
            //Resolve the item with URL
            if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &url, NULL) == noErr)
            {
                NSString * urlPath = [(NSURL*)CFBridgingRelease(url) path];
                if ([urlPath compare:appPath] == NSOrderedSame){
                    LSSharedFileListItemRemove(loginItems,itemRef);
                }
            }
        }
    }
}

@end
