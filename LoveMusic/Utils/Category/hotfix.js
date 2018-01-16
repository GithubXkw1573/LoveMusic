
require('TXHttpClient, UIApplication')
defineClass('xxxxxxx',{
            //实例方法
            
            currentNavigateController: function(){
                var appDelegate = UIApplication.sharedApplication().delegate();
                var array = appDelegate.MainTab().viewController();
                var currIndex = appDelegate.MainTab().selectedIndex();
                var nav = array.objectAtIndex(currIndex);
                //把这个nav 作为Umshareview 的最后一个参数
            },
            
            },{
            //静态方法
            requestForSpecialPlaneTickets_CompleteBlock_failureBlock: function(parameters, succBlock, failBlock){
                    var url = 'http://www.baidu.com' + '/train/booking/jsPiao_getMinPriceByStationName.services';
                    var succBlk = function(succ, respObj, msg){
                        var resultDic = respObj;
                        if(succ && resultDic.objectForKey('status')().containSttring('success')() && resultDic.objectForKey('content')().floatValue()>=0){
                            succBlock(1,respObj);
                        }else{
                            succBlock(0,respObj);
                        }
                    };
                    TXHttpClient.shared().asynchronousPostRequest_parameters_withMask_NeedHandleCook_successBlock(url,parameters,0,1, block("BOOL, id, NSString *",succBlk));
                },
            })