protected
    //����Ƿ��ڿؼ���
    FIsMouseOver:Boolean;
    //����Ƿ���
    FIsMouseDown:Boolean;


    //ԭ�ص���¼�
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
    //����Ƿ���
    property IsMouseDown:Boolean read GetIsMouseDown write SetIsMouseDown;
    //����Ƿ��ڿؼ���
    property IsMouseOver:Boolean read GetIsMouseOver write SetIsMouseOver;


    //����¼�(ISkinControl)
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
    //ԭ�ص���¼�
    procedure StayClick;virtual;
    //�ڵ���¼��������Ƿ�ѡ����
    procedure Click;{$IFNDEF WinForm}override;{$ENDIF}
  published
    //ԭ�ص���¼�
    property OnStayClick:TNotifyEvent read FOnStayClick write FOnStayClick;
