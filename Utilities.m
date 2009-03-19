/*
 *    Utilities
 *    Copyright 2008, Erica Sadun
 *
 *    All rights are retained. This code remains the trade secret and intellectual property of Erica Sadun.
 */

#import "Utilities.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <netdb.h>

@implementation Utilities
// Return the hostname.local address for the iPhone
+ (NSString *) localAddressForPort: (int) chosenPort
{
	char baseHostName[255];
	gethostname(baseHostName, 255);
	return [NSString stringWithFormat:@"http://%@%@:%d", [NSString stringWithCString:baseHostName], 
			[[NSString stringWithCString:baseHostName] hasSuffix:@"local"] ? @"" : @".local",
			chosenPort];
}

+ (BOOL) connectedToNetwork
{
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);	
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags) 
	{
		printf("Error. Could not recover network reachability flags\n");
		return 0;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	return (isReachable && !needsConnection) ? YES : NO;
}


// Return the iPhone's IP address
+ (NSString *) localIPAddressForPort: (int) chosenPort
{
	char baseHostName[255];
	gethostname(baseHostName, 255);
	
	char hn[255];
	sprintf(hn, "%s.local", baseHostName);
	struct hostent *host = gethostbyname(hn);
    if (host == NULL)
	{
        herror("resolv");
		return NULL;
	}
    else {
        struct in_addr **list = (struct in_addr **)host->h_addr_list;
        return [NSString stringWithFormat:@"<br /><i>or</i><br />http://%@:%d", [NSString stringWithCString:inet_ntoa(*list[0])], chosenPort];
    }
	
	return NULL;
}

// Return the full host address
+ (NSString *) hostAddyForPort: (int) chosenPort
{
	return [NSString stringWithFormat:@"http://%@:%d/", [Utilities localIPAddressForPort:chosenPort], chosenPort];
}


+ (void) notify: (NSString *) formatstring,...
{
	va_list arglist;
	if (formatstring)
	{
		va_start(arglist, formatstring);
		id outstring = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
		UIAlertView *baseAlert = [[UIAlertView alloc] initWithTitle:@"" message:outstring delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
		[baseAlert setTag:ALERT_UTILITY_TAG];
		[baseAlert show];
		va_end(arglist);
		[outstring release];
	}
}

+ (NSString *) getIPAddressForHost: (NSString *) theHost
{
	struct hostent *host = gethostbyname([theHost UTF8String]);
	
    if (host == NULL) {
        herror("resolv");
		return NULL;
	}
	
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0])];
	return addressString;
}

// Direct from Apple. Thank you Apple
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address
{
	if (!IPAddress || ![IPAddress length]) {
		return NO;
	}
	
	memset((char *) address, sizeof(struct sockaddr_in), 0);
	address->sin_family = AF_INET;
	address->sin_len = sizeof(struct sockaddr_in);
	
	int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
	if (conversionResult == 0) {
		NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
		return NO;
	}
	
	return YES;
}

+ (BOOL) hostAvailable: (NSString *) theHost
{
	
	NSString *addressString = [self getIPAddressForHost:theHost];
	if (!addressString) 
	{
		printf("Error recovering IP address from host name\n");
		return NO;
	}
	
	struct sockaddr_in address;
	BOOL gotAddress = [self addressFromString:addressString address:&address];
	
	if (!gotAddress)
	{
		printf("Error recovering sockaddr address from %s\n", [addressString UTF8String]);
		return NO;
	}
	
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags) 
	{
		printf("Error. Could not recover network reachability flags\n");
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	return (isReachable && !needsConnection) ? YES : NO;
}

@end
