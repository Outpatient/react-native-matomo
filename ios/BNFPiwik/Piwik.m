//
//  Piwik.m
//

#import "Piwik.h"
#import "PiwikTracker.h"

#if DEBUG
#if __has_include(<React/RCTLog.h>)
#import <React/RCTLog.h>
#elif __has_include("RCTLog.h")
#import "RCTLog.h"
#elif __has_include("React/RCTLog.h")
#import "React/RCTLog.h"   // Required when used as a Pod in a Swift project
#endif
#endif

@implementation Piwik

static NSString * const PiwikAppTrackingKey = @"@@Piwik-tracking-version@@";

+ (NSString *)appTrackId {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appDisplayName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"%@-%@-(%@)", appDisplayName, majorVersion, minorVersion];
}
+ (float)appVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue];
}

- (instancetype)init
{
    if ((self = [super init])) {
    }
    return self;

}

- (void)dealloc
{
    [[PiwikTracker sharedInstance] dispatch];
}


RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(initTracker: (NSString*)url id:(NSNumber* _Nonnull) id)
{
#if DEBUG
    RCTLogInfo(@"Initing tracker");
#endif
    [PiwikTracker sharedInstanceWithSiteID:[id stringValue] baseURL:[NSURL URLWithString: url]];
}

RCT_EXPORT_METHOD(setAppOptOut:(BOOL)isOptedOut)
{
#if DEBUG
    RCTLogInfo(@"Setting app opt out");
#endif
    [PiwikTracker sharedInstance].optOut = isOptedOut;
}

RCT_EXPORT_METHOD(setUserId:(NSString* _Nonnull)userID)
{
#if DEBUG
    RCTLogInfo(@"Setting user id");
#endif
    [PiwikTracker sharedInstance].userID = userID;
}

RCT_EXPORT_METHOD(trackScreen: (NSString* _Nonnull)screen title:(NSString*) title)
{
#if DEBUG
    RCTLogInfo(@"Tracking screen");
#endif
    [[PiwikTracker sharedInstance] sendViews:screen, title, nil];
}

RCT_EXPORT_METHOD(trackGoal: (NSUInteger)goal values:(NSDictionary* _Nonnull) values)
{
#if DEBUG
    RCTLogInfo(@"Tracking goal");
#endif
    NSNumber* revenue = [values objectForKey:@"revenue"];
    [[PiwikTracker sharedInstance] sendGoalWithID:goal revenue:revenue];
}

RCT_EXPORT_METHOD(trackEvent: (NSString* _Nonnull)category action:(NSString* _Nonnull) action values:(NSDictionary* _Nonnull) values)
{
#if DEBUG
    RCTLogInfo(@"Tracking event");
#endif
    NSString * name= [values objectForKey:@"name"];
    NSNumber* value = [values objectForKey:@"value"];
    [[PiwikTracker sharedInstance] sendEventWithCategory:category action:action name:name value:value];
}

RCT_EXPORT_METHOD(trackCampaign: (NSString* _Nonnull)campaignName campaignKeyword:(NSString* _Nonnull)campaignKeyword)
{
#if DEBUG
    RCTLogInfo(@"Tracking campaign info");
#endif
    // fake url, only the query parameters are relevant
    NSString * campaignUrl = [NSString stringWithFormat:@"http://outpatient.ai/?pk_campaign=%@&pk_kwd=%@", campaignName, campaignKeyword];
    [[PiwikTracker sharedInstance] sendCampaign:campaignUrl];
}

RCT_EXPORT_METHOD(trackAppDownload)
{
#if DEBUG
    RCTLogInfo(@"Unsupported on iOS");
#endif
    //NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //if ( ![userDefaults valueForKey:PiwikAppTrackingKey] ||
    //    [[NSUserDefaults standardUserDefaults] floatForKey:@"version"] != [Piwik appVersion] ) {
    //    [[PiwikTracker sharedInstance] sendDownload:[Piwik appTrackId]];
    //    [userDefaults setFloat:[Piwik appVersion] forKey:PiwikAppTrackingKey];
    //}
}


@end
