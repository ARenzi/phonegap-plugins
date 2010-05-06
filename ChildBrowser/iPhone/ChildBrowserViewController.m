//
//  ChildBrowserViewController.m
//  DeqqApp
//
//  Created by Jesse MacFadyen on 21/07/09.
//  Copyright 2009 Nitobi. All rights reserved.
//

#import "ChildBrowserViewController.h"


@implementation ChildBrowserViewController

@synthesize imageURL;
@synthesize isImage;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


- (ChildBrowserViewController*)initWithScale:(BOOL)enabled
{
    self = [super init];
	
	
	scaleEnabled = enabled;
	
	return self;	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	webView.delegate = self;
	webView.scalesPageToFit = TRUE;
	webView.backgroundColor = [UIColor whiteColor];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {

	webView.delegate = nil;
	
	[webView release];
	[closeBtn release];
	[refreshBtn release];
	[addressLabel release];
	[backBtn release];
	[fwdBtn release];
	[safariBtn release];
	[spinner release];
	
	[super dealloc];
}

-(IBAction) onDoneButtonPress:(id)sender
{
	[ [super parentViewController] dismissModalViewControllerAnimated:YES];
}


-(IBAction) onSafariButtonPress:(id)sender
{
	if(isImage)
	{
		NSURL* pURL = [ [NSURL alloc] initWithString:imageURL ];
		[ [ UIApplication sharedApplication ] openURL:pURL  ];
	}
	else
	{
		NSURLRequest *request = webView.request;
		[[UIApplication sharedApplication] openURL:request.URL];
	}
	 
}


- (void)loadURL:(NSString*)url
{
	NSLog(@"Opening Url : %@",url);
	 
	if( [url hasSuffix:@".png" ]  || 
	    [url hasSuffix:@".jpg" ]  || 
		[url hasSuffix:@".jpeg" ] || 
		[url hasSuffix:@".bmp" ]  || 
		[url hasSuffix:@".gif" ]  )
	{
		[ imageURL release ];
		imageURL = [url copy];
		isImage = YES;
		NSString* htmlText = @"<html><body style='background-color:#333;margin:0px;padding:0px;'><img style='min-height:200px;margin:0px;padding:0px;width:100%;height:auto;' alt='' src='IMGSRC'/></body></html>";
		htmlText = [ htmlText stringByReplacingOccurrencesOfString:@"IMGSRC" withString:url ];

		[webView loadHTMLString:htmlText baseURL:[NSURL URLWithString:@""]];
		
	}
	else
	{
		imageURL = @"";
		isImage = NO;
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
		[webView loadRequest:request];
	}
	webView.hidden = NO;
}


- (void)webViewDidStartLoad:(UIWebView *)sender {
	addressLabel.text = @"Loading...";
	backBtn.enabled = webView.canGoBack;
	fwdBtn.enabled = webView.canGoForward;
	
	[ spinner startAnimating ];
}

- (void)webViewDidFinishLoad:(UIWebView *)sender {
	NSURLRequest *request = webView.request;
	addressLabel.text = request.URL.absoluteString;
	backBtn.enabled = webView.canGoBack;
	fwdBtn.enabled = webView.canGoForward;
	[ spinner stopAnimating ];
	
	
}


@end