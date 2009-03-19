#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

#define ALERT_UTILITY_TAG	2111

#define OPTIONS_ALERT_TAG	5111
#define TEXT_ALERT_TAG		5112
#define LOG_VIEW_TAG		5113

#define LEGAL @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

#define DOCUMENTS_FOLDER	[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define TMP_FOLDER			[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]

#define GPS_LOG		@"gps.txt"
#define WIFI_LOG	@"wifi.txt"
#define GSM_LOG		@"gsm.txt"
#define	LOGS_LOG	@"logs.txt"
#define	POINTS_LOG	@"points.txt"

#define SCAN_TAG	999
#define SHARE_TAG	998
#define FINDME_TAG	997
#define INFO_TAG	996
#define LOGS_TAG	995
#define FTPSETTINGS_TAG	994


@interface Utilities : NSObject 
+ (void) notify: (NSString *) aMessage,...;
+ (NSString *) hostAddyForPort: (int) chosenPort;
+ (NSString *) localIPAddressForPort: (int) chosenPort;
+ (NSString *) localAddressForPort: (int) chosenPort;
+ (BOOL) connectedToNetwork;
+ (BOOL) hostAvailable: (NSString *) theHost;
@end

// Access to private APIs

@interface UIView (extended)
- (void) setOrigin: (CGPoint) aPoint;
@end

@interface UITextView (extended)
- (void)setContentToHTMLString:(NSString *) contentText;
@end

@interface NSDate (extended)
-(NSDate *) dateWithCalendarFormat:(NSString *)format timeZone: (NSTimeZone *) timeZone;
@end


#define CGRectZero	CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)

#define SCAN_DELAY	7.0f