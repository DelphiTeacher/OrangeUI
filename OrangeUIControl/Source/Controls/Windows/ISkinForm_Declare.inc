

//    //获取图标
//    function GetIcon:TIcon;
    //获取标题
    function GetCaption:String;

//    //是否当前激活的窗口
//    function GetActive:Boolean;
//    //获取按钮
//    function GetBorderIcons:TBorderIcons;

    //设置标题
    procedure SetCaption(const Value:String);






    //设置及排列窗体的窗体控件列表
    procedure SyncSystemControls;


//    //添加窗体控件
//    procedure AddSystemControl(ASystemControl:TControl);
//    //移除窗体控件
//    procedure RemoveSystemControl(ASystemControl:TControl);
//    //获取窗体的窗体控件列表
//    function GetSystemControls:TSkinControlList;







    //刷新子控件(如果窗体大小改变,那么有些透明控件是需要重绘的)
    procedure InvalidateSubControls;





    //更新窗体非客户区
    procedure UpdateWindowNotClient(const AUpdateWindowRect:PRectF=nil;//更新区域
                                    EnableBuffer:Boolean=True//是否启用缓冲,背景透明需要缓存
                                    );
    //更新窗体客户区
    procedure UpdateWindowClient(AWindowClientCanvas:TDrawCanvas;
                                  const AUpdateClientRect:PRectF=nil;//更新区域
                                  const AUpdateWindowRect:PRectF=nil;
                                  EnableBuffer:Boolean=True//是否启用缓冲,背景透明需要缓存
                                  );


