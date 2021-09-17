protected
    //鼠标是否在控件中
    FIsMouseOver:Boolean;
    //鼠标是否按下
    FIsMouseDown:Boolean;


    //原地点击事件
    FOnStayClick:TNotifyEvent;



    FOnCustomMouseDown:TMouseEvent;
    FOnCustomMouseUp:TMouseEvent;
    FOnCustomMouseMove:TMouseMoveEvent;
    FOnCustomMouseEnter:TNotifyEvent;
    FOnCustomMouseLeave:TNotifyEvent;


    function GetOnCustomMouseDown:TMouseEvent;
    function GetOnCustomMouseUp:TMouseEvent;
    function GetOnCustomMouseMove:TMouseMoveEvent;
    function GetOnCustomMouseEnter:TNotifyEvent;
    function GetOnCustomMouseLeave:TNotifyEvent;

  public
    //鼠标是否按下
    property IsMouseDown:Boolean read GetIsMouseDown write SetIsMouseDown;
    //鼠标是否在控件中
    property IsMouseOver:Boolean read GetIsMouseOver write SetIsMouseOver;


    //鼠标事件(ISkinControl)
    procedure ISkinControl_CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double;const AIsChildMouseEvent:Boolean;const AChild:TObject);overload;virtual;
    procedure ISkinControl_CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double;const AIsChildMouseEvent:Boolean;const AChild:TObject);overload;virtual;
    procedure ISkinControl_CustomMouseMove(Shift: TShiftState; X, Y: Double;const AIsChildMouseEvent:Boolean;const AChild:TObject);overload;virtual;
    procedure ISkinControl_CustomMouseEnter;virtual;
    procedure ISkinControl_CustomMouseLeave;virtual;
  published
    property OnCustomMouseDown:TMouseEvent read GetOnCustomMouseDown write FOnCustomMouseDown;
    property OnCustomMouseUp:TMouseEvent read GetOnCustomMouseUp write FOnCustomMouseUp;
    property OnCustomMouseMove:TMouseMoveEvent read GetOnCustomMouseMove write FOnCustomMouseMove;
    property OnCustomMouseEnter:TNotifyEvent read GetOnCustomMouseEnter write FOnCustomMouseEnter;
    property OnCustomMouseLeave:TNotifyEvent read GetOnCustomMouseLeave write FOnCustomMouseLeave;

  public
    //原地点击事件
    procedure StayClick;virtual;
    //在点击事件中设置是否勾选属性
    procedure Click;{$IFNDEF WinForm}override;{$ENDIF}
  published
    //原地点击事件
    property OnStayClick:TNotifyEvent read FOnStayClick write FOnStayClick;

