//
//  OAuth1Controller.m
//  Simple-OAuth1
//
//  Created by Christian Hansen on 02/12/12.
//  Copyright (c) 2012 Christian-Hansen. All rights reserved.
//  Edited by Johannes Gnägi on 17-12-2014 (Added Consumer Key and Secret from Withings)
//

#import "OAuth1Controller.h"
#import "NSString+URLEncoding.h"
#include "hmac.h"
#include "Base64Transcoder.h"

typedef void (^WebWiewDelegateHandler)(NSDictionary *oauthParams);

#define OAUTH_CALLBACK       @"http://wbsapi.withings.net/user" //Sometimes this has to be the same as the registered app callback url
#define CONSUMER_KEY         @"813c21935ed454156e8d6954b85e14c8ddf3c8d07b4e5f131c2c625ddc7e9"
#define CONSUMER_SECRET      @"1e13b49093337ceb307bf1d229508c3e44823e0c6986bc73133696d1587290"
#define AUTH_URL             @"https://oauth.withings.com/"
#define REQUEST_TOKEN_URL    @"account/request_token"
#define AUTHENTICATE_URL     @"account/authorize"
#define ACCESS_TOKEN_URL     @"account/access_token"
#define API_URL              @"http://wbsapi.withings.net/"
#define OAUTH_SCOPE_PARAM    @""

#define REQUEST_TOKEN_METHOD @"POST"
#define ACCESS_TOKEN_METHOD  @"POST"

//--- The part below is from AFNetworking---
static NSString * CHPercentEscapedQueryStringPairMemberFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kCHCharactersToBeEscaped = @":/?&=;+!@#$()~";
    static NSString * const kCHCharactersToLeaveUnescaped = @"[].";
    
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kCHCharactersToLeaveUnescaped, (__bridge CFStringRef)kCHCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}

#pragma mark -

@interface CHQueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding;
@end

@implementation CHQueryStringPair
@synthesize field = _field;
@synthesize value = _value;

- (id)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.field = field;
    self.value = value;
    
    return self;
}

- (NSString *)URLEncodedStringValueWithEncoding:(NSStringEncoding)stringEncoding {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return CHPercentEscapedQueryStringPairMemberFromStringWithEncoding([self.field description], stringEncoding);
    } else {
        return [NSString stringWithFormat:@"%@=%@", CHPercentEscapedQueryStringPairMemberFromStringWithEncoding([self.field description], stringEncoding), CHPercentEscapedQueryStringPairMemberFromStringWithEncoding([self.value description], stringEncoding)];
    }
}

@end

#pragma mark -

extern NSArray * CHQueryStringPairsFromDictionary(NSDictionary *dictionary);
extern NSArray * CHQueryStringPairsFromKeyAndValue(NSString *key, id value);

NSString * CHQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding) {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (CHQueryStringPair *pair in CHQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLEncodedStringValueWithEncoding:stringEncoding]];
    }
    
    return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray * CHQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return CHQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSArray * CHQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    
    if([value isKindOfClass:[NSDictionary class]]) {
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        [[[value allKeys] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]] enumerateObjectsUsingBlock:^(id nestedKey, NSUInteger idx, BOOL *stop) {
            id nestedValue = [value objectForKey:nestedKey];
            if (nestedValue) {
                [mutableQueryStringComponents addObjectsFromArray:CHQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
            }
        }];
    } else if([value isKindOfClass:[NSArray class]]) {
        [value enumerateObjectsUsingBlock:^(id nestedValue, NSUInteger idx, BOOL *stop) {
            [mutableQueryStringComponents addObjectsFromArray:CHQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
        }];
    } else {
        [mutableQueryStringComponents addObject:[[CHQueryStringPair alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}


static inline NSDictionary *CHParametersFromQueryString(NSString *queryString)
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (queryString)
    {
        NSScanner *parameterScanner = [[NSScanner alloc] initWithString:queryString];
        NSString *name = nil;
        NSString *value = nil;
        
        while (![parameterScanner isAtEnd]) {
            name = nil;
            [parameterScanner scanUpToString:@"=" intoString:&name];
            [parameterScanner scanString:@"=" intoString:NULL];
            
            value = nil;
            [parameterScanner scanUpToString:@"&" intoString:&value];
            [parameterScanner scanString:@"&" intoString:NULL];
            
            if (name && value)
            {
                [parameters setValue:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                              forKey:[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
    }
    return parameters;
}

//--- The part above is from AFNetworking---

@interface OAuth1Controller ()

@property (nonatomic, weak) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) WebWiewDelegateHandler delegateHandler;

@end

@implementation OAuth1Controller

- (void)loginWithWebView:(UIWebView *)webWiew completion:(void (^)(NSDictionary *oauthTokens, NSError *error))completion
{
    self.webView = webWiew;
    self.webView.delegate = self;
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingIndicator.color = [UIColor grayColor];
    [self.loadingIndicator startAnimating];
    self.loadingIndicator.center = self.webView.center;
    [self.webView addSubview:self.loadingIndicator];
    
    [self obtainRequestTokenWithCompletion:^(NSError *error, NSDictionary *responseParams)
     {
         NSString *oauth_token_secret = responseParams[@"oauth_token_secret"];
         NSString *oauth_token = responseParams[@"oauth_token"];
         if (oauth_token_secret
             && oauth_token)
         { NSLog(@"GUKLL");
             [self authenticateToken:oauth_token withCompletion:^(NSError *error, NSDictionary *responseParams)
              {NSLog(@"GUKLL11");
                  if (!error)
                  {
                     
                      [self requestAccessToken:oauth_token_secret
                                    oauthToken:responseParams[@"oauth_token"]
                                 oauthVerifier:responseParams[@"oauth_verifier"]
                                    completion:^(NSError *error, NSDictionary *responseParams)
                       {
                           completion(responseParams, error);
                       }];
                  }
                  else
                  {
                      completion(responseParams, error);
                  }
              }];
         }
         else
         {
             if (!error) error = [NSError errorWithDomain:@"oauth.requestToken" code:0 userInfo:@{@"userInfo" : @"oauth_token and oauth_token_secret were not both returned from request token step"}];
             completion(responseParams, error);
         }
     }];
}


#pragma mark - Step 1 Obtaining a request token
- (void)obtainRequestTokenWithCompletion:(void (^)(NSError *error, NSDictionary *responseParams))completion
{
    NSString *request_url = [AUTH_URL stringByAppendingString:REQUEST_TOKEN_URL];
    NSString *oauth_consumer_secret = CONSUMER_SECRET;
    
    NSMutableDictionary *allParameters = [self.class standardOauthParameters];
    if ([OAUTH_SCOPE_PARAM length] > 0) [allParameters setValue:OAUTH_SCOPE_PARAM forKey:@"scope"];

    NSString *parametersString = CHQueryStringFromParametersWithEncoding(allParameters, NSUTF8StringEncoding);
    
    NSString *baseString = [REQUEST_TOKEN_METHOD stringByAppendingFormat:@"&%@&%@", request_url.utf8AndURLEncode, parametersString.utf8AndURLEncode];
    NSString *secretString = [oauth_consumer_secret.utf8AndURLEncode stringByAppendingString:@"&"];
    NSString *oauth_signature = [self.class signClearText:baseString withSecret:secretString];
    [allParameters setValue:oauth_signature forKey:@"oauth_signature"];
    
    parametersString = CHQueryStringFromParametersWithEncoding(allParameters, NSUTF8StringEncoding);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request_url]];
    request.HTTPMethod = REQUEST_TOKEN_METHOD;
    
    NSMutableArray *parameterPairs = [NSMutableArray array];
    for (NSString *name in allParameters) {
        NSString *aPair = [name stringByAppendingFormat:@"=\"%@\"", [allParameters[name] utf8AndURLEncode]];
        [parameterPairs addObject:aPair];
    }
    NSString *oAuthHeader = [@"OAuth " stringByAppendingFormat:@"%@", [parameterPairs componentsJoinedByString:@", "]];
    [request setValue:oAuthHeader forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *reponseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               completion(nil, CHParametersFromQueryString(reponseString));
                           }];
}

#pragma mark - Step 2 Show login to the user to authorize our app
- (void)authenticateToken:(NSString *)oauthToken withCompletion:(void (^)(NSError *error, NSDictionary *responseParams))completion
{
    NSString *oauth_callback = OAUTH_CALLBACK;
    NSLog(@"YYYY %@",oauth_callback);
    NSString *authenticate_url = [AUTH_URL stringByAppendingString:AUTHENTICATE_URL];
    authenticate_url = [authenticate_url stringByAppendingFormat:@"?oauth_token=%@", oauthToken];
    authenticate_url = [authenticate_url stringByAppendingFormat:@"&oauth_callback=%@", oauth_callback.utf8AndURLEncode];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:authenticate_url]];
    [request setValue:[NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)] forHTTPHeaderField:@"User-Agent"];
    
    _delegateHandler = ^(NSDictionary *oauthParams) {
        if (oauthParams[@"oauth_verifier"] == nil) {
            NSError *authenticateError = [NSError errorWithDomain:@"com.ideaflasher.oauth.authenticate" code:0 userInfo:@{@"userInfo" : @"oauth_verifier not received and/or user denied access"}];
            completion(authenticateError, oauthParams);
        } else {
            completion(nil, oauthParams);
        }
    };
    NSLog(@"TTTUUUUU");
    [self.webView loadRequest:request];
}



#pragma mark - Webview delegate
#pragma mark Turn off spinner
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loadingIndicator removeFromSuperview];
    self.loadingIndicator = nil;
   // NSLog(@"webViewDidFinishLoad");
}

#pragma mark Used to detect call back in step 2
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (_delegateHandler) {
        // For other Oauth 1.0a service providers than LinkedIn, the call back URL might be part of the query of the URL (after the "?"). In this case use index 1 below. In any case NSLog the request URL after the user taps 'Allow'/'Authenticate' after he/she entered his/her username and password and see where in the URL the call back is. Note for some services the callback URL is set once on their website when registering an app, and the OAUTH_CALLBACK set here is ignored.
        NSString *urlWithoutQueryString = [request.URL.absoluteString componentsSeparatedByString:@"?"][0];
        if ([urlWithoutQueryString rangeOfString:OAUTH_CALLBACK].location != NSNotFound)
        {
            NSString *queryString = [request.URL.absoluteString substringFromIndex:[request.URL.absoluteString rangeOfString:@"?"].location + 1];
            NSDictionary *parameters = CHParametersFromQueryString(queryString);
            parameters = [self removeAppendedSubstringOnVerifierIfPresent:parameters];
            
            _delegateHandler(parameters);
            _delegateHandler = nil;
        }
    }
    return YES;
}

#define FacebookAndTumblrAppendedString @"#_=_"

- (NSDictionary *)removeAppendedSubstringOnVerifierIfPresent:(NSDictionary *)parameters
{
    NSString *oauthVerifier = parameters[@"oauth_verifier"];
    if ([oauthVerifier hasSuffix:FacebookAndTumblrAppendedString]
        && [oauthVerifier length] > FacebookAndTumblrAppendedString.length) {
        NSMutableDictionary *mutableParameters = parameters.mutableCopy;
        mutableParameters[@"oauth_verifier"] = [oauthVerifier substringToIndex:oauthVerifier.length - FacebookAndTumblrAppendedString.length];
        parameters = mutableParameters;
    }
    return parameters;
}


#pragma mark - Step 3 Request access token now that user has authorized the app
- (void)requestAccessToken:(NSString *)oauth_token_secret
                oauthToken:(NSString *)oauth_token
             oauthVerifier:(NSString *)oauth_verifier
                completion:(void (^)(NSError *error, NSDictionary *responseParams))completion
{
    NSString *access_url = [AUTH_URL stringByAppendingString:ACCESS_TOKEN_URL];
    NSString *oauth_consumer_secret = CONSUMER_SECRET;
    
    NSMutableDictionary *allParameters = [self.class standardOauthParameters];
    [allParameters setValue:oauth_verifier forKey:@"oauth_verifier"];
    [allParameters setValue:oauth_token    forKey:@"oauth_token"];
    
    NSString *parametersString = CHQueryStringFromParametersWithEncoding(allParameters, NSUTF8StringEncoding);
    
    NSString *baseString = [ACCESS_TOKEN_METHOD stringByAppendingFormat:@"&%@&%@", access_url.utf8AndURLEncode, parametersString.utf8AndURLEncode];
    NSString *secretString = [oauth_consumer_secret.utf8AndURLEncode stringByAppendingFormat:@"&%@", oauth_token_secret.utf8AndURLEncode];
    NSString *oauth_signature = [self.class signClearText:baseString withSecret:secretString];
    [allParameters setValue:oauth_signature forKey:@"oauth_signature"];
    
    parametersString = CHQueryStringFromParametersWithEncoding(allParameters, NSUTF8StringEncoding);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:access_url]];
    request.HTTPMethod = ACCESS_TOKEN_METHOD;
    
    NSMutableArray *parameterPairs = [NSMutableArray array];
    for (NSString *name in allParameters)
    {
        NSString *aPair = [name stringByAppendingFormat:@"=\"%@\"", [allParameters[name] utf8AndURLEncode]];
        [parameterPairs addObject:aPair];
    }
    NSString *oAuthHeader = [@"OAuth " stringByAppendingFormat:@"%@", [parameterPairs componentsJoinedByString:@", "]];
    [request setValue:oAuthHeader forHTTPHeaderField:@"Authorization"];
     NSLog(@"UELLLL ");
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               NSLog(@"UELLLL%@ ",request);

                               completion(nil, CHParametersFromQueryString(responseString));
                           }];
}


+ (NSMutableDictionary *)standardOauthParameters
{
    NSString *oauth_timestamp = [NSString stringWithFormat:@"%lu", (unsigned long)[NSDate.date timeIntervalSince1970]];
    NSString *oauth_nonce = [NSString getNonce];
    NSString *oauth_consumer_key = CONSUMER_KEY;
    NSString *oauth_signature_method = @"HMAC-SHA1";
    NSString *oauth_version = @"1.0";
    
    NSMutableDictionary *standardParameters = [NSMutableDictionary dictionary];
    [standardParameters setValue:oauth_consumer_key     forKey:@"oauth_consumer_key"];
    [standardParameters setValue:oauth_nonce            forKey:@"oauth_nonce"];
    [standardParameters setValue:oauth_signature_method forKey:@"oauth_signature_method"];
    [standardParameters setValue:oauth_timestamp        forKey:@"oauth_timestamp"];
    [standardParameters setValue:oauth_version          forKey:@"oauth_version"];
    /////new
    [standardParameters setValue:OAUTH_CALLBACK          forKey:@"oauth_callback"];
    
    return standardParameters;
}


#pragma mark build authorized API-requests
+ (NSURLRequest *)preparedRequestForPath:(NSString *)path
                              parameters:(NSDictionary *)queryParameters
                              HTTPmethod:(NSString *)HTTPmethod
                              oauthToken:(NSString *)oauth_token
                             oauthSecret:(NSString *)oauth_token_secret
{
    if (!HTTPmethod
        || !oauth_token) return nil;
    
    NSMutableDictionary *allParameters = [self standardOauthParameters];
    allParameters[@"oauth_token"] = oauth_token;
    if (queryParameters) [allParameters addEntriesFromDictionary:queryParameters];
    
    NSString *parametersString = CHQueryStringFromParametersWithEncoding(allParameters, NSUTF8StringEncoding);
    
    NSString *request_url = API_URL;
    if (path) request_url = [request_url stringByAppendingString:path];
    NSString *oauth_consumer_secret = CONSUMER_SECRET;
    NSString *baseString = [HTTPmethod stringByAppendingFormat:@"&%@&%@", request_url.utf8AndURLEncode, parametersString.utf8AndURLEncode];
    NSString *secretString = [oauth_consumer_secret.utf8AndURLEncode stringByAppendingFormat:@"&%@", oauth_token_secret.utf8AndURLEncode];
    NSString *oauth_signature = [self.class signClearText:baseString withSecret:secretString];
    allParameters[@"oauth_signature"] = oauth_signature;
    
    NSString *queryString;
    
    
    NSLog(@"GGGGG %@",allParameters);
     if (allParameters) queryString = CHQueryStringFromParametersWithEncoding(allParameters, NSUTF8StringEncoding);
    //if (queryParameters) queryString = CHQueryStringFromParametersWithEncoding(queryParameters, NSUTF8StringEncoding);
    if (queryString) request_url = [request_url stringByAppendingFormat:@"?%@", queryString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request_url]];
    request.HTTPMethod = HTTPmethod;
    
    NSMutableArray *parameterPairs = [NSMutableArray array];
    [allParameters removeObjectsForKeys:queryParameters.allKeys];
    for (NSString *name in allParameters) {
        NSString *aPair = [name stringByAppendingFormat:@"=\"%@\"", [allParameters[name] utf8AndURLEncode]];
        [parameterPairs addObject:aPair];
    }
    NSString *oAuthHeader = [@"OAuth " stringByAppendingFormat:@"%@", [parameterPairs componentsJoinedByString:@", "]];
    [request setValue:oAuthHeader forHTTPHeaderField:@"Authorization"];
    if ([HTTPmethod isEqualToString:@"POST"]
        && queryParameters != nil) {
        NSData *body = [queryString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
    }
    NSLog(@"GGGGRRRG %@",request);
    return request;
}


+ (NSString *)URLStringWithoutQueryFromURL:(NSURL *) url
{
    NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"?"];
    return [parts objectAtIndex:0];
}


#pragma mark -
+ (NSString *)signClearText:(NSString *)text withSecret:(NSString *)secret
{
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[20];
    hmac_sha1((unsigned char *)[clearTextData bytes], [clearTextData length], (unsigned char *)[secretData bytes], [secretData length], result);
    
    //Base64 Encoding
    char base64Result[32];
    size_t theResultLength = 32;
    Base64EncodeData(result, 20, base64Result, &theResultLength);
    NSData *theData = [NSData dataWithBytes:base64Result length:theResultLength];
    
    return [NSString.alloc initWithData:theData encoding:NSUTF8StringEncoding];
}

@end