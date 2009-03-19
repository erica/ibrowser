#import <UIKit/UIKit.h>
#import "ShareController.h"

@interface ShareAppDelegate : NSObject <UIApplicationDelegate> 
@end

@implementation ShareAppDelegate

// On launch, create a basic window
- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[ShareController alloc] init]];
	[window addSubview:nav.view];
	[window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application  {
	// handle any final state matters here
}

- (void)dealloc {
	[super dealloc];
}

@end

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"ShareAppDelegate");
	[pool release];
	return retVal;
}
