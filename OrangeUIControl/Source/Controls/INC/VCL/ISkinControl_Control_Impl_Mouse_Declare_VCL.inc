//控件鼠标消息声明





protected

  //鼠标进入消息处理
  procedure CMMouseEnter(var Message:TMessage);message CM_MOUSEENTER;
  //鼠标离开
  procedure CMMouseLeave(var Message:TMessage);message CM_MOUSELEAVE;




  //鼠标事件(用于支持DirectUI)
  procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);override;
  procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);override;
  procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
  function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;MousePos: TPoint): Boolean; overload;override;
  function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;X, Y: Double): Boolean;overload;



