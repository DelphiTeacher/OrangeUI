protected


    //鼠标事件(系统自带的)(用于支持DirectUI)
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single);overload;override;
    procedure MouseWheel(Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);override;
    //鼠标进入消息处理
    procedure DoMouseEnter;override;
    //鼠标离开
    procedure DoMouseLeave;override;



