//�ؼ������Ϣ����





protected

  //��������Ϣ����
  procedure CMMouseEnter(var Message:TMessage);message CM_MOUSEENTER;
  //����뿪
  procedure CMMouseLeave(var Message:TMessage);message CM_MOUSELEAVE;




  //����¼�(����֧��DirectUI)
  procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);override;
  procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);override;
  procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
  function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;MousePos: TPoint): Boolean; overload;override;
  function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;X, Y: Double): Boolean;overload;


