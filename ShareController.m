/*
 *    ShareController:
 *    Copyright 2008, Erica Sadun
 *
 *    All rights are retained. This code remains the trade secret and intellectual property of Erica Sadun.
 */

#import "ShareController.h"
#import "Utilities.h"
#import "MIMEHelper.h"
#import "NuZip.h"

@implementation ShareController 

- (id) init
{
	if (!(self = [super init])) return self;
	self.title = @"Share Data";
	serverStatus = STATUS_OFFLINE;
	return self;
}

- (void) pleaseConnectToNetwork
{
	NSMutableString *riz = [[NSMutableString alloc] init];
	[riz appendString:@"<h2>Service could not be established</h2>"];
	[riz appendString:@"<p>You are not connected to a network.</p>"];
 	[riz appendString:@"<br /><br />"];
	[(UITextView *)self.view setContentToHTMLString:[riz autorelease]];
}


- (void) serviceWasEstablished
{
	[(UITextView *)self.view setContentToHTMLString:[NSString stringWithFormat:@"<h2>Success!</h2><p>Your iPhone can now serve files over HTTP. To access this service, launch a browser from another computer or iPhone on the same network and navigate to the following address(es):</p><p>%@%@</p><p>This service remains active until you quit from this application.</p><p>Ports are random and you are assigned a new one each time you run this program.</p>",
									  [Utilities localAddressForPort:chosenPort] ? [Utilities localAddressForPort:chosenPort]: @"", 
									  [Utilities localIPAddressForPort:chosenPort] ? [Utilities localIPAddressForPort:chosenPort] : @"" ]];
}

- (void) couldNotEstablishService
{
	[(UITextView *)self.view setContentToHTMLString:@"<h2>Service could not be established</h2><p>This application could not establish the HTTP server at this time. Please try again later.</p><br /><br />"];
}

- (void) tryingToEstablishService
{
	[(UITextView *)self.view setContentToHTMLString:@"<h2>Attempting to Establish Service</h2><p>Please wait.</p><br /><br />"];
}

- (void) stoppingService
{
	[(UITextView *)self.view setContentToHTMLString:@"<h2>You stopped service.</h2><p>The HTTP server is no longer active.</p><br /><br />"];
}

- (void) youCanStartService
{
	[(UITextView *)self.view setContentToHTMLString:@"<h2>Web Server</h2><p>Press <b>Start Service</b> to begin serving files from your iPhone to web browsers on your local network.</p><br /><br/>"];
}

- (NSString *) css
{
	return @"<style>/* based on iui.css (c) 2007 by iUI Project Members */ body {     margin: 0;     font-family: Helvetica;     background: #FFFFFF;     color: #000000;     overflow-x: hidden;     -webkit-user-select: none;     -webkit-text-size-adjust: none; }  body > *:not(.toolbar) {     display: none;     position: absolute;     margin: 0;     padding: 0;     left: 0;     top: 45px;     width: 100%;     min-height: 372px; }  body > *[selected=\"true\"] {     display: block; }  a[selected], a:active {     background-color: #194fdb !important;     background-repeat: no-repeat, repeat-x;     background-position: right center, left top;     color: #FFFFFF !important; }  body > .toolbar {     box-sizing: border-box;     -moz-box-sizing: border-box;     -webkit-box-sizing: border-box;     border-bottom: 1px solid #2d3642;     border-top: 1px solid #6d84a2;     padding: 10px;     height: 45px;     background: #6d84a2 repeat-x; }  .toolbar > h1 {     position: absolute;     overflow: hidden;     font-size: 20px;     text-align: center;     font-weight: bold;     text-shadow: rgba(0, 0, 0, 0.4) 0px -1px 0;     text-overflow: ellipsis;     white-space: nowrap;     color: #FFFFFF;      margin: 1px 0 0 -120px;     left: 50%;     width: 240px;     height: 45px; }  body > ul > li {     position: relative;     margin: 0;     border-bottom: 1px solid #E0E0E0;     padding: 8px 0 8px 10px;     font-size: 20px;     font-weight: bold;     list-style: none; }  body > ul > li > a {      margin: -8px 0 -8px -10px;     padding: 8px 32px 8px 10px;     text-decoration: none;     color: inherit; }  a[target=\"_replace\"] {     box-sizing: border-box;     -webkit-box-sizing: border-box;     padding-top: 25px;     padding-bottom: 25px;     font-size: 18px;     color: cornflowerblue;     background-color: #FFFFFF;     background-image: none; }  body > .dialog {     top: 0;     width: 100%;     min-height: 417px;     z-index: 2;     background: rgba(0, 0, 0, 0.8);     padding: 0;     text-align: right; }  .dialog > fieldset {     box-sizing: border-box;     -webkit-box-sizing: border-box;     width: 100%;     margin: 0;     border: none;     border-top: 1px solid #6d84a2;     padding: 10px 6px;     background: #7388a5 repeat-x; }  .dialog > fieldset > h1 {     margin: 0 10px 0 10px;     padding: 0;     font-size: 20px;     font-weight: bold;     color: #FFFFFF;     text-shadow: rgba(0, 0, 0, 0.4) 0px -1px 0;     text-align: center; }  .dialog > fieldset > label {     position: absolute;     margin: 16px 0 0 6px;     font-size: 14px;     color: #999999; }  p {     font-family: Helvetica;     background: #FFFFFF;     color: #000000;     padding:15px;     font-size: 20px;     margin-left: 15%;     margin-right: 15%;     text-align: center; }  </style>";
}

- (NSString *) createindex
{
	NSMutableString *outdata = [[NSMutableString alloc] init];
	
	
	[outdata appendString:@"<html>"];
	[outdata appendFormat:@"<head><title>%@</title>\n", cwd];
	[outdata appendString:@"<meta name=\"viewport\" content=\"width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/>"];
	[outdata appendString:[self css]];
	[outdata appendString:@"<script type=\"application/x-javascript\">"];
	[outdata appendString:@"window.onload = function() { setTimeout(function() {window.scrollTo(0,1);), 100); }"];
	[outdata appendString:@"</script>"];
	[outdata appendString:@"</head><body>"];
	
	[outdata appendFormat:@"<div class=\"toolbar\">	<h1 id=\"pageTitle\">%@</h1>	<a id=\"backButton\" class=\"button\" href=\"#\"></a>    </div>", [cwd lastPathComponent]];
	[outdata appendString:@"<ul id=\"home\" title=\"Files\" selected=\"true\">"];
	
	if (![cwd isEqualToString:@"/"])
	{
		NSString *nwd = [cwd stringByDeletingLastPathComponent];
		if (![nwd isEqualToString:@"/"])
			[outdata appendFormat:@"<li><a href=\"%@/\">Parent Directory/</a></li>\n", nwd];
		else
			[outdata appendFormat:@"<li><a href=\"%@\">Parent Directory/</a></li>\n", nwd];
	}
	
	// Read in the strings
	NSString *wd;
	wd = cwd;
	for (NSString *fname in [[NSFileManager defaultManager] directoryContentsAtPath:wd])
	{
		BOOL isDir;
		NSString *cpath = [wd stringByAppendingPathComponent:fname];
		[[NSFileManager defaultManager] fileExistsAtPath:cpath isDirectory:&isDir];
		[outdata appendFormat:@"<li><a href=\"%@%@\">%@%@</a>%@</li>\n", 
		 cpath, 
		 isDir ? @"/" : @"",
		 fname,
		 isDir ? @"/" : @"", 
		 isDir ? [NSString stringWithFormat:@"<a href=\"zzzzip%@.zip\">[zip]</a>", cpath] : @""
		 ];
		[cpath release];
	}
	[outdata appendString:@"</ul>"];
	[outdata appendString:@"</body></html>\n"];
	return outdata;
}

- (void) produceError: (NSString *) errorString forFD: (int) fd
{
	NSString *outcontent = [NSString stringWithFormat:@"HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n"];
	write (fd, [outcontent UTF8String], [outcontent length]);
	[outcontent release];
	
	NSMutableString *outdata = [[NSMutableString alloc] init];
	[outdata appendString:@"<html>"];
	[outdata appendString:@"<head><title>Error</title>\n"];
	[outdata appendString:@"<meta name=\"viewport\" content=\"width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/>"];
	[outdata appendString:[self css]];
	[outdata appendString:@"</head><body>"];
	[outdata appendString:@"<div class=\"toolbar\">	<h1 id=\"pageTitle\">Error</h1>	<a id=\"backButton\" class=\"button\" href=\"#\"></a>    </div>"];
	[outdata appendFormat:@"<p id=\"ErrorPara\" selected=\"true\"><br />%@<br /><br />Return to <a  href=\"upload.html\">upload page</a> or <a href=\"/\">Main browser</a></p>", errorString];
	[outdata appendString:@"</body></html>\n"];
	
	write (fd, [outdata UTF8String], [outdata length]);
	close(fd);
	[outdata release];
}

// Serve files to GET requests
- (void) handleWebRequest:(int) fd
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	static char buffer[BUFSIZE+1];
	
	int len = read(fd, buffer, BUFSIZE); 	
	buffer[len] = '\0';
	
	NSString *request = [NSString stringWithCString:buffer];
	NSArray *reqs = [request componentsSeparatedByString:@"\n"];
	NSString *getreq = [[reqs objectAtIndex:0] substringFromIndex:4];
	NSRange range = [getreq rangeOfString:@"HTTP/"];
	if (range.location == NSNotFound)
	{
		printf("Error: GET request was improperly formed\n");
		close(fd);
		return;
	}
	
	NSString *filereq = [[getreq substringToIndex:range.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	if ([filereq isEqualToString:@"/"]) 
	{
		cwd = filereq;
		NSString *outcontent = [NSString stringWithFormat:@"HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n"];
		write(fd, [outcontent UTF8String], [outcontent length]);
		
		NSString *outdata = [self createindex];
		write(fd, [outdata UTF8String], [outdata length]);
		close(fd);
		return;
	}
	
	if ([filereq isEqualToString:@"/favicon.ico"])
	{
		NSString *outcontent = [NSString stringWithFormat:@"HTTP/1.0 200 OK\r\nContent-Type: %@\r\n\r\n", @"image/vnd.microsoft.icon"];
		write (fd, [outcontent UTF8String], [outcontent length]);
		NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"favicon" ofType:@"ico"]];
		if (!data)
		{
			printf("Error: favicon.ico not found.\n");
			return;
		}
		write(fd, [data bytes], [data length]);
		close(fd);
		return;
	}
	
	filereq = [filereq stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	// Primary index.html
	if ([filereq hasSuffix:@"/"]) 
	{
		cwd = filereq;
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:filereq])
		{
			printf("Error: folder not found.\n");
			[self produceError:@"Requested folder was not found." forFD:fd];
			return;
		}
		
		NSString *outcontent = [NSString stringWithFormat:@"HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n"];
		write(fd, [outcontent UTF8String], [outcontent length]);
		
		NSString *outdata = [self createindex];
		write(fd, [outdata UTF8String], [outdata length]);
		close(fd);
		return;
	}
	
	NSString *mime = [MIMEHelper mimeForExt:[filereq pathExtension]];
	if (!mime)
	{
		printf("Error recovering mime type.\n");
		[self produceError:@"Sorry. This file type is not supported." forFD:fd];
		return;
	}
	
	NSRange r = [filereq rangeOfString:@"zzzzip"];
 	if (r.location != NSNotFound)
	{
		NSString *path1 = [filereq substringFromIndex:r.location + 6];
		NSString *path = [path1 substringToIndex:[path1 length] - 4];
		printf("Zip request: %s\n", [path UTF8String]);
		
		NSString *zipRequest = @"zip -o archive.zip";
		NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
		
		NSString *eachFile;
		while (eachFile = [direnum nextObject])
		{
			BOOL isDir;
			NSString *fpath = [path stringByAppendingPathComponent:eachFile];
			[[NSFileManager defaultManager] fileExistsAtPath:fpath isDirectory:&isDir];
			if (!isDir) zipRequest = [zipRequest stringByAppendingFormat:@" %@",
						  [fpath stringByReplacingOccurrencesOfString:@" " withString: @"\\ "]];
		}
			
		// CFShow(zipRequest);
		chdir([DOCUMENTS_FOLDER UTF8String]);
		[NuZip zip:zipRequest];
		
		// Output the file
		NSString *outcontent = @"HTTP/1.0 200 OK\r\nContent-Type:application/x-compressed\r\n\r\n";
		write (fd, [outcontent UTF8String], [outcontent length]);
		NSData *data = [NSData dataWithContentsOfFile:@"archive.zip"];
		if (!data)
		{
			printf("Error: file not found.\n");
			[self produceError:@"File was not found. Please check the requested path and try again." forFD:fd];
			return;
		}
		printf("Writing %d bytes from file\n", [data length]);
		write(fd, [data bytes], [data length]);
		close(fd);

		return;
	}
	
	// Output the file
	NSString *outcontent = [NSString stringWithFormat:@"HTTP/1.0 200 OK\r\nContent-Type: %@\r\n\r\n", mime];
	write (fd, [outcontent UTF8String], [outcontent length]);
	NSData *data = [NSData dataWithContentsOfFile:filereq];
	if (!data)
	{
		printf("Error: file not found.\n");
		[self produceError:@"File was not found. Please check the requested path and try again." forFD:fd];
		return;
	}
	printf("Writing %d bytes from file\n", [data length]);
	write(fd, [data bytes], [data length]);
	close(fd);
	
	[pool release];
}

// Begin serving data -- this is a private method called by startService
- (BOOL) isServing
{
	return isServing;
}

// Shut down service
- (void) stopService
{
	printf("Shutting down service\n");
	[self stoppingService];
	isServing = NO;
	close(listenfd);
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Start Service" 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(startService)] autorelease];
}


// Server
- (void) listenForRequests
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	static struct	sockaddr_in cli_addr; 
	socklen_t		length = sizeof(cli_addr);
	
	while (1 > 0) {
		
		if (!isServing) return;
		
		if ((socketfd = accept(listenfd, (struct sockaddr *)&cli_addr, &length)) < 0)
		{
			isServing = NO;
			return;
		}
		
		[self handleWebRequest:socketfd];
	}
	
	[pool release];
}

// Begin serving data -- this is a private method called by startService
- (void) startServer
{
	static struct	sockaddr_in serv_addr;
	
	// Set up socket
	if((listenfd = socket(AF_INET, SOCK_STREAM,0)) < 0)	
	{
		isServing = NO;
		[self couldNotEstablishService];
		return;
	}
	
    // Serve to a random port
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	serv_addr.sin_port = 0;
	
	// Bind
	if(bind(listenfd, (struct sockaddr *)&serv_addr,sizeof(serv_addr)) <0)	
	{
		isServing = NO;
		[self couldNotEstablishService];
		return;
	}
	
	// Find out what port number was chosen.
	int namelen = sizeof(serv_addr);
	if (getsockname(listenfd, (struct sockaddr *)&serv_addr, (void *) &namelen) < 0) {
		close(listenfd);
		isServing = NO;
		return;
	}
	chosenPort = ntohs(serv_addr.sin_port);
	
	// Listen
	if(listen(listenfd, 64) < 0)	
	{
		isServing = NO;
		return;
	} 
	
	self.navigationItem.rightBarButtonItem = NULL;
	[self serviceWasEstablished];
	
	[NSThread detachNewThreadSelector:@selector(listenForRequests) toTarget:self withObject:NULL];
}

- (void) showServiceAvailable
{
	[self youCanStartService];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Start Service" 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(startService)] autorelease];
}

/*
 *
 *  Establish service
 *
 */

// Start service
- (void) startService
{
	if (isServing)
	{
		printf("Error: Already Serving!\n");
		return;
	}
	
	isServing = NO;
	close(listenfd);
	
	if (![Utilities connectedToNetwork])
	{
		[self pleaseConnectToNetwork];
		return;
	}
	
	self.navigationItem.rightBarButtonItem = NULL;
	[self tryingToEstablishService];
	ntries = 0;
	isServing = YES;
	[self startServer];
}

- (UIColor *)adBackgroundColor {
	return [UIColor colorWithRed:0.271 green:0.271 blue:0.271 alpha:1.0f]; 
}

// All revenue helps support my iPhone hardware and dev membership
- (NSString *) publisherId
{
	return @"a149c2995526aa7";
}

- (BOOL)useTestAd {
	return NO;
}

- (void)loadView
{
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 372.0f)];
	[textView setEditable:NO];
	[textView setFont:[UIFont systemFontOfSize:14.0f]];

	AdMobView *ad = [AdMobView requestAdWithDelegate:self]; 
    ad.frame = CGRectMake(0, 432, 320, 48); 
	ad.center = CGPointMake(160.0f, 416.0f - 24.0f);
	[textView addSubview:ad];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
	label.backgroundColor = [UIColor clearColor];
	label.center = CGPointMake(160.04, 416.0f - 45.0f - 25.0f);
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor lightGrayColor];
 	label.font = [UIFont boldSystemFontOfSize:14.0f];
	label.numberOfLines = 2;
	label.text = @"Ad revenues underwrite my iPhone\nhardware and $99/year dev membership";
	[textView addSubview:label];
	[label release];

	self.view = textView;
	[textView release];
	
	[self showServiceAvailable];
	
	isServing = NO;
	cwd = @"/";
}

@end