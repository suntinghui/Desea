//
//  NewsDetailViewController.m
//  Desea
//
//  Created by wenbin on 14-1-18.
//  Copyright (c) 2014年 wenbin. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "ShowContentViewController.h"

#define HEIGHTLIMIT 48000

#define Action_Tag_Content  100
#define Action_Tag_Attach   101

@interface NewsDetailViewController ()
{
    UIWebView *mainWebView;
    float webHeight;
}
@end

@implementation NewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        webHeight = 100;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"信息详情";
    mainWebView = [[UIWebView alloc]initWithFrame:CGRectMake(5, 5, 310, self.view.frame.size.height)];
    mainWebView.delegate = self;
    mainWebView.scrollView.delegate = self;
    mainWebView.backgroundColor = [UIColor clearColor];
    mainWebView.opaque = NO;
    mainWebView.dataDetectorTypes = UIDataDetectorTypeNone;
//    mainWebView.userInteractionEnabled = NO;
    mainWebView.scalesPageToFit = YES; //取消了高度自适应 变成可缩放的方式
    
    [StaticTools setExtraCellLineHidden:self.listTableView];
    

    [self getNewsDetail];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark--功能函数
/**
 *	@brief	获取图片在cell里展示的最佳frame  图片宽大于高时：长度最大为tableview的宽度 高度为其对应缩放
 图片高大于宽时：最大高度为480 宽度为其对应缩放
 *
 *	@param 	image 	图片数据
 *
 *	@return
 */
- (CGRect)getRectWithImage:(UIImage*)image

{
    CGRect rect = CGRectMake(150, 150, 10, 10);
    float maxHeight;
    if (image.size.width>image.size.height)
    {
        maxHeight = 300;
    }
    else
    {
        maxHeight = 480;
    }
    
    CGRect frame = CGRectMake(10, 0, 300, maxHeight);
    //图片尺寸比view小 按原图尺寸显示
    if (image.size.width<frame.size.width&&image.size.height<maxHeight)
    {
        rect = CGRectMake((frame.size.width-image.size.width)/2, 5,
                          image.size.width, image.size.height);
    }
    else
    {
        CGRect showRect = CGRectMake(0, 0, frame.size.width ,maxHeight);
        float rate = image.size.width/image.size.height;
        
        float rateBox = showRect.size.width/(showRect.size.height);
        if(rate > rateBox){
            rect.size.width = frame.size.width;
            rect.size.height = frame.size.width/rate;
        }else{
            rect.size.height = showRect.size.height;
            rect.size.width = (showRect.size.height)*rate;
        }
        
        rect.origin.x= (frame.size.width-rect.size.width)/2;
        rect.origin.y = 5;
    }
    
    return rect;
}

#pragma mark-
#pragma mark--HTTP请求
- (void)getNewsDetail
{
    NSString *methodName;
    if (self.pageType == 0) //通知信息
    {
        methodName = @"GetTZ";
    }
    else if(self.pageType == 1||self.pageType==2) //集团新闻 ||集团公告
    {
        methodName = @"GetXX";
    }
    NSDictionary *dict = @{kMethodName:methodName,
                           kWebServiceName:@"WebService.asmx",
                           kParamName:@{@"InfoId":self.InfoId,
                                        @"sUserId":ShareManager.userId}};
    
    
    AFHTTPRequestOperation *operation = [[Transfer sharedTransfer] TransferWithRequestDic:dict
                                                                                   prompt:nil
                                                                                  success:^(id obj)
                                         {
                                             if ([obj isKindOfClass:[NSDictionary class]])
                                             {
                                                 self.resultDict = [NSDictionary dictionaryWithDictionary:(NSDictionary*)obj];
                                                 
                                                  NSArray *attach = self.resultDict[@"attachments"];
                                                 if (attach.count>0)
                                                 {
                                                     self.contentBtn.hidden = NO;
                                                     self.attachBtn.hidden = NO;
                                                 }
                                                 else
                                                 {
                                                     self.contentBtn.hidden = YES;
                                                     self.attachBtn.hidden = YES;
                                                 }
                                            
                                                 [mainWebView loadHTMLString:self.resultDict[@"content"] baseURL:nil];
                                                 if ([StaticTools isEmptyString:self.resultDict[@"imgurl"]])
                                                 {
                                                     AFImageRequestOperation* operation = [AFImageRequestOperation imageRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dict[@"url"]]] success:^(UIImage *image) {
                                                         
                                                         NSLog(@"下载图片完成 %@",dict[@"url"]);
                                                         self.detailImg = image;
                                                         [self.listTableView reloadData];
                                                         
                                                     }];
                                                     
                                                     [operation start];

                                                 }
                                                 [self.listTableView reloadData];
                                                 
                                             }
                                             
                                         }
                                                                                  failure:^(NSString *errMsg)
                                         {
                                             [SVProgressHUD showErrorWithStatus:@"加载失败，请稍后再试!"];
                                             
                                         }];
    
    [[Transfer sharedTransfer] doQueueByTogether:[NSArray arrayWithObjects:operation, nil] prompt:@"正在加载..." completeBlock:^(NSArray *operations) {
    }];
    
    
}


#pragma mark - 按钮点击
- (IBAction)buttonClickHandle:(id)sender
{
    
    UIButton *button  = (UIButton*)sender;
    switch (button.tag)
    {
        case Action_Tag_Content:
        {
            [self.listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
            break;
        case Action_Tag_Attach:
        {
             [self.listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.contentBtn.hidden = YES;
    self.attachBtn.hidden = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSArray *attach = self.resultDict[@"attachments"];
    if (attach.count>0)
    {
        self.contentBtn.hidden = NO;
        self.attachBtn.hidden = NO;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSArray *attach = self.resultDict[@"attachments"];
    if (attach.count>0)
    {
        self.contentBtn.hidden = NO;
        self.attachBtn.hidden = NO;
    }
    
}
#pragma mark-
#pragma mark--TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *attach = self.resultDict[@"attachments"];
    if (attach.count>0)
    {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    if (self.detailImg==nil)
//    {
//        return 1;
//    }
//    else
//    {
//        return 2;
//    }
    
    NSArray *attach = self.resultDict[@"attachments"];
    if (attach.count>0)
    {
        if (section==0)
        {
            return 1;
        }
        else if(section==1)
        {
            return attach.count;
        }
    }
    else
    {
        return 1;
    }
    
    return 0;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *attach = self.resultDict[@"attachments"];
    if (attach.count>0)
    {
        if (indexPath.section==0)
        {
            return self.view.frame.size.height;
        }
        else if(indexPath.section==1)
        {
            return 40;
        }
        
    }
    else
    {
        return self.view.frame.size.height  ;
    }
    
    return 40;
    
//    NSArray *pics = self.resultDict[@"pics"];
//    
//    if(indexPath.row == pics.count) //正文
//    {
//        return self.view.frame.size.height;
////        return webHeight+5;
//    }
//    
//    
//    //图片下载完成时返回图片的适应大小  图片未下载完完返回10
//    if (self.detailImg!=nil)
//    {
//        return [self getRectWithImage:self.detailImg].size.height+10;
//    }
//    else
//    {
//        return 10;
//    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *attach = self.resultDict[@"attachments"];
    if (attach.count==0)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (![cell.contentView.subviews containsObject:mainWebView])
        {
            mainWebView.frame = self.view.frame;
            [mainWebView loadHTMLString:self.resultDict[@"content"]  baseURL:Nil];
            [cell.contentView addSubview:mainWebView];
        }
        
    }
    else
    {
        if (indexPath.section==0)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (![cell.contentView.subviews containsObject:mainWebView])
            {
                mainWebView.frame = self.view.frame;
                [mainWebView loadHTMLString:self.resultDict[@"content"]  baseURL:Nil];
                [cell.contentView addSubview:mainWebView];
            }
            
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.text =  [NSString stringWithFormat:@"%@",attach[indexPath.row][@"title"]];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = UILineBreakModeCharacterWrap;
        }
    }
    
//    NSArray *pics = self.resultDict[@"pics"];
//    
//  if(indexPath.row == pics.count)
//    {
//        if (![cell.contentView.subviews containsObject:mainWebView])
//        {
//            mainWebView.frame = self.view.frame;
//            [mainWebView loadHTMLString:self.resultDict[@"content"]  baseURL:Nil];
//            [cell.contentView addSubview:mainWebView];
//        }
//        
//    }
//    else
//    {
//        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, tableView.frame.size.width-20, 180)];
//        if (self.detailImg!=nil)
//        {
//            
//            imgView.image =  self.detailImg;
//            CGRect rect = [self getRectWithImage: self.detailImg];
//            imgView.frame = CGRectMake(rect.origin.x+10, rect.origin.y, rect.size.width, rect.size.height);
//        }
//        [cell.contentView addSubview:imgView];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        NSArray *attachments  = self.resultDict[@"attachments"];
        NSDictionary *attachment = attachments[indexPath.row];
        
        ShowContentViewController *vc = [[ShowContentViewController alloc] initWithFileName:attachment[@"title"] AttachId:attachment[@"Id"]];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark
#pragma mark webView delegate

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
  
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
//    webHeight= [[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollHeight"]] floatValue];
//    float webWith= [[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.clientWidth "]] floatValue];
//    NSLog(@"webWith %f",webWith);
// 
//    webHeight=webHeight>HEIGHTLIMIT?HEIGHTLIMIT:webHeight;
//    NSLog(@"height %f\n",webHeight);
//    [webView setFrame:CGRectMake(5, 5, mainWebView.frame.size.width,webHeight-3)];
//
//    [self.listTableView reloadData];
}
@end
