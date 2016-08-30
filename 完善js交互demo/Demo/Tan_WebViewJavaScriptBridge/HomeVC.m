//
//  HomeVC.m
//  Tan_WebViewJavaScriptBridge
//


#import "HomeVC.h"
#import "WebViewJavascriptBridge.h"
#import "LoginVC.h"

@interface HomeVC () <UIAlertViewDelegate,LoginVCDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) WebViewJavascriptBridge *bridge;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWebView]; //初始化webView
}

/** 给webView加载页面 */
- (void)initWebView{
    
    
    
    
    
    
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView handler:^(id data, WVJBResponseCallback responseCallback) {}];
    
    //WebView加载数据
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"Home" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [_webView loadHTMLString:appHtml baseURL:baseURL];
    
    //bridge注册js调用去领奖方法
    [_bridge registerHandler:@"js_Call_Objc_Prize" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //js给oc的data，用这个data去判断有没有登录
        NSLog(@"data:%@",data);
        //模拟判断是否登录
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        
        //这里是模拟情况，很好理解就是第一次进来的时候是没有登录注册的，第一次就不会满足userName，所以首先会去运行下边的提示框代码，如果是用js传过来的data，也可以用来判断，不过这时候就要求js端提供data里边有可以用来判断是否登录的接口，  首先还是要回到第一次没有注册登录的情况，还是要先去注册，先走下边提示框的代码，第一次走了下边的提示框了，就已经注册好了，在注册好的时候，就应该已经把注册的消息给了js，然后服务器就保存起来，然后注册有账号的用户，就直接登录账号，这个要求服务器提供接口，可以让oc或者 比如data带个用户的消息字段：name：MyName，
        if (userName){
            //已登录, 领奖次数加1
            static NSInteger prizeNum = 0;
            prizeNum++;
            
           
            //调用js，把最新的值传到js去:objc_Call_JS_UpdateNum
            [_bridge callHandler:@"objc_Call_JS_UpdateNum" data:@{@"num": @(prizeNum)} responseCallback:^(id response) {
            }];

            return;
        }
        
        //没登录，去登陆
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"不好意思，还没登录呢，是否马上去登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    
    //注册js调用退出事件
    [_bridge registerHandler:@"js_Call_Objc_Logout" handler:^(id data, WVJBResponseCallback responseCallback) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"]; //删除登录信息
        
        //没登录
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"退出成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1){
        
        
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginVC *vc = [sb instantiateViewControllerWithIdentifier:@"LoginVCXM"];
        
        if (vc){
            
            vc.delegate=self;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

-(void)sendData:(LoginVC *)loginvc data:(NSString *)dataStr
{
    
    
    NSLog(@"dataStr=======%@",dataStr);
    
    id data = @{ @"helloFromObjc": @"你好, JS, 我来自Objc!   datastr=注册后传递账号消息，js自己做保存！！！！！" };
    
    //调用js方法objc_Call_JS_Func
    [_bridge callHandler:@"objc_Call_JS_Func_useInFo" data:data responseCallback:^(id response) {
        
        NSLog(@"response====%@",response);
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
