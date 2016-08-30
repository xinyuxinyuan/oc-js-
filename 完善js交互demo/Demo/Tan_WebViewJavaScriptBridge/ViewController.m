//
//  ViewController.m
//  Tan_WebViewJavaScriptBridge
//


#import "ViewController.h"
#import "WebViewJavascriptBridge.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) WebViewJavascriptBridge *bridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initWebView]; //初始化webView
}

/** 给webView加载页面 */
- (void)initWebView{
    
    
    //[WebViewJavascriptBridge enableLogging ];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView handler:^(id data, WVJBResponseCallback responseCallback) {}];
    
    //WebView加载数据
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"TestJSBridge" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [_webView loadHTMLString:appHtml baseURL:baseURL];
    
    //bridge注册js回调方法
    [_bridge registerHandler:@"js_Call_Objc_Func" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"data是js给oc的消息: %@", data);
       // NSLog(@"responseCallback: %@", responseCallback);
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"来自js的消息" message:[NSString stringWithFormat:@"%@",data] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }];
    
}

/** 原生调用js方法   向js发送消息  */
- (IBAction)sendMsgToJS:(id)sender {
    id data = @{ @"helloFromObjc": @"你好, JS, 我来自Objc!" };
    
    //调用js方法objc_Call_JS_Func
    [_bridge callHandler:@"objc_Call_JS_Func" data:data responseCallback:^(id response) {
        
        NSLog(@"response====%@",response);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
