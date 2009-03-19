#import <UIKit/UIKit.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

// To help cover my $99/year dev costs + iPhone hardware
#import "AdMob/AdMobDelegateProtocol.h"
#import "AdMob/AdMobView.h"


#define BUFSIZE 8096

#define STATUS_OFFLINE	0
#define STATUS_ATTEMPT	1
#define STATUS_ONLINE	2

@interface ShareController : UIViewController  <AdMobDelegate>
{
	NSString		*cwd;
	
	int				serverStatus;
	BOOL			isServing;
	int				listenfd;
	int				ntries;
	int				chosenPort;
	int				socketfd;
}
- (void) stopService;
- (BOOL) isServing;
@end
