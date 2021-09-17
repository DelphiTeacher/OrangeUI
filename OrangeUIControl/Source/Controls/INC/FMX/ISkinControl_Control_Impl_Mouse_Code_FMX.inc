//系统自带的



procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.MouseWheel(Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  Inherited MouseWheel(Shift,WheelDelta,Handled);
  if FSkinControlType<>nil then
  begin
    Handled:=TSkinControlType(FSkinControlType).CustomMouseWheel(Shift,WheelDelta,0,0);
  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
begin
  GlobalIsMouseDown:=True;

  {$IFDEF FMXControl}
  if Self.FMouseDownFocus then
  begin
    if Self.CanFocus then
    begin
      Self.SetFocus;
    end;
  end;
  {$ENDIF}

  Inherited MouseDown(Button,Shift,X,Y);

  ISkinControl_CustomMouseDown(Button,Shift,X,Y,False,Self);
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.MouseMove(Shift:TShiftState;X, Y: Single);
begin
  Inherited MouseMove(Shift,X,Y);

  ISkinControl_CustomMouseMove(Shift,X,Y,False,Self);
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
begin
  GlobalIsMouseDown:=False;

  Inherited MouseUp(Button,Shift,X,Y);

  ISkinControl_CustomMouseUp(Button,Shift,X,Y,False,Self);
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.DoMouseEnter;
begin
  Inherited;

  ISkinControl_CustomMouseEnter;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.DoMouseLeave;
begin
  Inherited;

  ISkinControl_CustomMouseLeave;
end;







