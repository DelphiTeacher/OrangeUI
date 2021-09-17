  protected


    FNeedHitTest:Boolean;


    FHitTestValue: Integer;



    //DirectUI模式下是否显示
    FDirectUIVisible:Boolean;



    //用于点击的时候判断是哪个控件
    //DirectUI父控件接口,接管控件的更新
    FDirectUIParentIntf: IDirectUIParent;
    procedure SetDirectUIParentIntf(Value:IDirectUIParent);

    //位置矩形
    function GetAutoSizeWidth:Double;
    function GetAutoSizeHeight:Double;
    function GetNeedHitTest:Boolean;
    function GetHitTestValue:Integer;
    function AutoSizeBoundsRect:TRectF;


    function GetDirectUIVisible:Boolean;



    //DirectUI父控件接口，接管它的绘制和更新
    property DirectUIParentIntf:IDirectUIParent read FDirectUIParentIntf write SetDirectUIParentIntf;
  published
    property DirectUIVisible:Boolean read GetDirectUIVisible write FDirectUIVisible;

