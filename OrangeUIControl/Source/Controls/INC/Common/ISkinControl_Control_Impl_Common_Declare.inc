

  protected
    {$IFNDEF WinForm}
    {$IFNDEF WinEdit}
    FCanvas:TDrawCanvas;
    {$ENDIF}
    {$ENDIF}




    FPaintData:TPaintData;

    FParentMouseEvent:Boolean;

    //鼠标事件传递类型-自动,传递,不传递
    FMouseEventTransToParentType:TMouseEventTransToParentType;





    function GetParentMouseEvent:Boolean;
    procedure SetParentMouseEvent(const AValue:Boolean);


    function GetMouseEventTransToParentType:TMouseEventTransToParentType;
    procedure SetMouseEventTransToParentType(const AValue:TMouseEventTransToParentType);

    //设置控件位置和尺寸
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: TControlSize);overload;
    procedure SetBounds(ABoundsRect:TRectF);overload;


    //获取父控件的子控件
    function GetParentChildControlCount:Integer;
    function GetParentChildControl(Index:Integer):TChildControl;


    //获取子控件
    function GetChildControlCount:Integer;
    function GetChildControl(Index:Integer):TChildControl;
  public
    //鼠标手势消息传递
    FParentIsCanGesutrePageControl:Boolean;
    FParentCanGesutrePageControl:TControl;
  public
    //在Edit的IsInScrollBox功能中需要使用
    FParentIsScrollBox:Boolean;
    FParentScrollBox:TControl;
    function GetParentIsScrollBox:Boolean;
    function GetParentScrollBox:TControl;
  protected

    //控件大小更改
    procedure Resize;override;

    //控件加载完毕
    procedure Loaded;override;

    procedure DoEnter;override;
    procedure DoExit;override;

    //处理子控件释放消息
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;



    {$IFDEF FMX}
  public
    property Left:TControlSize read GetLeft write SetLeft;
    property Top:TControlSize read GetTop write SetTop;
    {$ENDIF}

  public
    //调用Parent的鼠标事件
    property MouseEventTransToParentType:TMouseEventTransToParentType read GetMouseEventTransToParentType write SetMouseEventTransToParentType;


  published
    //调用Parent的鼠标事件
    property ParentMouseEvent:Boolean read GetParentMouseEvent write SetParentMouseEvent;



  protected
    //DataJson.S[FieldName],AStringList.Value[FieldName]
    FBindItemFieldName:String;
//    //String,Boolean,Integer,Float....
//    FBindItemFieldType:TFieldType;
    //ItemCaption,ItemDetail,ItemDetail1
//    FBindItemDataTypeName:String;

    //DataJson.S[FieldName],AStringList.Value[FieldName]
    function GetBindItemFieldName:String;
    procedure SetBindItemFieldName(AValue:String);
//    //String,Boolean,Integer,Float....
//    function GetBindItemFieldType:TFieldType;
    //ItemCaption,ItemDetail,ItemDetail1
//    function GetBindItemDataTypeName:String;
  published
    property BindItemFieldName:String read GetBindItemFieldName write FBindItemFieldName;
//    property BindItemFieldType:TFieldType read GetBindItemFieldType write FBindItemFieldType;
//    property BindItemDataTypeName:String read GetBindItemDataTypeName write FBindItemDataTypeName;



