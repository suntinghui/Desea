//
//  ShowFileContentViewController.m
//  LKOA4iPhone
//
//  Created by  STH on 7/31/13.
//  Copyright (c) 2013 DHC. All rights reserved.
//

#import "ShowContentViewController.h"
#import "NSString+change.h"
#import "SSZipArchive.h"
#import "URKArchive.h"
#import "ShowZipContentViewController.h"

@interface ShowContentViewController ()

@end

@implementation ShowContentViewController

@synthesize webView = _webView;
@synthesize tableView = _tableView;
@synthesize progressInd = _progressInd;
@synthesize fileName = _fileName;
@synthesize link = _link;
@synthesize htmlStr = _htmlStr;
@synthesize zipFileArray = _zipFileArray;

-(id) initWithFileName:(NSString *) fileName
{
    if (self = [super init]) {
        _fileName = fileName;
        _link = nil;
        _htmlStr = nil;
        _zipFileArray = nil;
    }
    
    return self;
}

-(id) initWithUrl:(NSString *) url
{
    if (self = [super init]) {
        _link = url;
        _fileName = nil;
        _htmlStr = nil;
        _zipFileArray = nil;
    }
    
    return self;
}

-(id) initWithHtmlString:(NSString *) htmlStr
{
    if (self = [super init]) {
        _htmlStr = htmlStr;
        _link = nil;
        _fileName = nil;
        _zipFileArray = nil;
    }
    
    return self;
}

-(id) initWithFileName:(NSString *)fileName AttachId:(NSString*)attachId
{
    if (self = [super init]) {
        _fileName = fileName;
        _link = nil;
        _htmlStr = nil;
        _zipFileArray = nil;
        _attachmentId = attachId;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"big_bg"]]];
    float height = 416.0f;
    if (IsIPhone5) {
        height = 504.0f;
    }
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    [self.webView setUserInteractionEnabled:YES];
    // YES, 初始太小，但是可以放大；NO，初始可以，但是不再支持手势。 FUCK！！！
    self.webView.scalesPageToFit = YES; // 设置网页和屏幕一样大小，使支持缩放操作
    [self.webView setDelegate:self];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, height) style:UITableViewStylePlain];
    self.tableView.delegate = self; //代理
    self.tableView.dataSource = self;
    
    
    // 这是一种取巧的方案，先设置成scalesPageToFit ＝ NO，两秒后再设置成scalesPageToFit ＝ YES。但是实际效果是PDF可以实现预计的效果，其他的不行。
    // [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(setScalesPageToFit) userInfo:nil repeats:NO];
    
    if (self.link) {
        [self showWithUrl:self.link];
    } else if (self.fileName&&!self.attachmentId) {
        [self showWithFileName:self.fileName];
    } else if (self.htmlStr) {
        [self showWithHtmlString:self.htmlStr];
    }
    else if(self.attachmentId)
    {
        self.navigationItem.title = self.fileName;
        [self getattachmentContent];
    }
}

- (void) setScalesPageToFit
{
    [self.webView setScalesPageToFit:YES];
}

-(void) showWithFileName:(NSString *) fileName
{
    // 如果在跳转时设置了title的名字，则不会再以文件的名字作为标题
    if (!self.navigationItem.title) {
        self.navigationItem.title = fileName;
    }
    
    [self getattachmentContent];
  
    
}

-(void) showWithUrl:(NSString *) url
{
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

-(void) showWithHtmlString:(NSString *) html
{
    [self.webView loadHTMLString:html baseURL:nil];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '500%'"];//通过 javaScript的语言进行大小的控制
    [self.view addSubview:self.webView];
}

/**
 *  根据附件id获取附件内容
 */
- (void)getattachmentContent
{
    
    NSDictionary *dict = @{kMethodName:@"GetAtt",
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"AttId":self.attachmentId,
                                        @"sUserId":ShareManager.userId}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
         
         if ([obj isKindOfClass:[NSString class]])
         {
             NSString *url = (NSString*)obj;
             NSString *host = [UserDefaults objectForKey:kHostAddress];
             [[Transfer sharedTransfer] downloadFileWithName:self.fileName
                                                        link:[NSString stringWithFormat:@"%@%@",host,url]
                                              viewController:self
                                                     success:^(id obj) {
                                                         NSLog(@"文件下载完成，尝试打开或解压文件。。。");
                                                         
                                                   
                                                         NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                         NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:self.fileName];
                                                         
                                                         NSLog(@"filePath:%@", filePath);
                                                         NSLog(@"fileName:%@", self.fileName);
                                                         
                                                         NSString *exStr = [self.fileName pathExtension];
                                                         NSString *unzipPath = [self tempUnzipPath];
                                                         if ([exStr isEqualToString:@"zip"]) {
                                                             
                                                             BOOL success = [SSZipArchive unzipFileAtPath:filePath
                                                                                            toDestination:unzipPath
                                                                                                overwrite:YES
                                                                                                 password:nil
                                                                                                    error:nil];
                                                             if (!success) {
                                                                 NSLog(@"No success");
                                                                 return;
                                                             }
                                                             NSError *error = nil;
                                                             self.zipFileArray = [[[NSFileManager defaultManager]
                                                                                                   contentsOfDirectoryAtPath:unzipPath
                                                                                                   error:&error] mutableCopy];
                                                             if (error) {
                                                                 return;
                                                             }
                                                             
                                                             
                                                             [self.view addSubview:self.tableView];
                                                             
                                                         } else if ([exStr isEqualToString:@"rar"]) {
                                                             NSError *archiveError = nil;
                                                             URKArchive *archive = [[URKArchive alloc] initWithPath:filePath error:&archiveError];
                                                             NSError *error = nil;
                                                             
                                                             self.zipFileArray = [NSMutableArray arrayWithArray:[archive listFilenames:&error]];
                                                             
                                                 
                                                             [archive extractFilesTo:unzipPath overwrite:YES progress:^(URKFileInfo * _Nonnull currentFile, CGFloat percentArchiveDecompressed) {
                                                                 
                                                             } error:&error];
                                                    
                                                            
                                                             
                                                             [self.view addSubview:self.tableView];
                                                             
                                                         } else {
                                                             NSURL *url = [NSURL fileURLWithPath:filePath];
                                                             NSURLRequest *request = [NSURLRequest requestWithURL:url];
                                                             [self.webView loadRequest:request];
                                                             
                                                             [self.view addSubview:self.webView];
                                                         }
                                                     
                                                     }
                                                     failure:^(NSString *errMsg) {
                                                         
                                                     }];

         }
         else
         {
             [SVProgressHUD showErrorWithStatus:@"加载失败，请稍后再试!"];
         }


                             
     }
                                              failure:^(NSString *errMsg)
     {
         [SVProgressHUD showErrorWithStatus:@"加载失败，请稍后再试!"];
         
     }];

    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"获取下载地址..." completeBlock:^(NSArray *operations) {
    }];
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    // 测试发现，当为EXCEL文件时（即扩展名为xls或xlsx),则一直在屏幕上显示加载不消失，故采用如下特殊处理之。
    if (self.fileName && [[self.fileName pathExtension] rangeOfString:@"xls"].location != NSNotFound) {
        return ;
    }
    
    [self showWaiting];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    /***
     
     // http://blog.csdn.net/kmyhy/article/details/7198920
     // http://www.icab.de/blog/2010/12/27/changing-the-range-of-the-zoom-factor-for-uiwebview-objects/
     
    NSString *path = [[NSBundle mainBundle] pathForResource:@"IncreaseZoomFactor" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCode];
    [self.webView stringByEvaluatingJavaScriptFromString:@"increaseMaxZoomFactor()"];
    ***/
    [self hideWaiting];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件打开失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//显示进度滚轮指示器
-(void)showWaiting {
    _progressInd=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
//    _progressInd.center=CGPointMake(self.view.center.x,240);
    _progressInd.center = self.view.center;
    [_progressInd setColor:[UIColor blackColor]];
    [self.view addSubview:_progressInd];
    [_progressInd startAnimating];
}

//消除滚动轮指示器
-(void)hideWaiting
{
    [_progressInd stopAnimating];
}

- (NSString *)tempUnzipPath {
    NSString *path = [NSString stringWithFormat:@"%@/\%@",
                      NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
                      self.fileName];
    NSLog(@"unzip path:%@", path);
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtURL:url
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    if (error) {
        return nil;
    }
    return url.path;
}

#pragma mark - 数据源方法
// 返回行数
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.zipFileArray == nil)
        return 0;
    
    return [self.zipFileArray count];
}

// 设置cell
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text=[self.zipFileArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - 代理方法
/**
 *  设置行高
 */
- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 40;
}


// 选中某行cell时会调用
- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self tempUnzipPath],[self.zipFileArray objectAtIndex:indexPath.row]];
    NSLog(@"%@", path);
    ShowZipContentViewController *viewController = [[ShowZipContentViewController alloc] initWithPath:path];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    // 删除文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self tempUnzipPath] error:nil];
    
    [self hideWaiting];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end
