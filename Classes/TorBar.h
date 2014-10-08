//
//  TorBar.h
//  TorBarExample
//


#import <Foundation/Foundation.h>
#import <TorServerKit/TorServerKit.h>
#import <SystemInfoKit/SystemInfoKit.h>
#import "NetworkMonitor.h"

@interface TorBar : NSObject

@property (strong) NSStatusItem *statusItem;
@property (strong) NSImage *menuIcon;
@property (strong) TorProcess *torProcess;
@property (strong) SINetworkMonitor *networkMonitor;
@property (strong) NSTimer *updateTimer;
@property (strong) NSMenuItem *toggleMenuItem;

@end
