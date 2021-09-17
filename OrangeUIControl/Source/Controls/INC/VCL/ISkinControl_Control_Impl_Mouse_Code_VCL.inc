//控件鼠标消息实现





procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);
begin
  Inherited;
  ISkinControl_CustomMouseDown(Button,Shift,X,Y,False,Self);
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.MouseMove(Shift:TShiftState;X, Y: Integer);
begin
  Inherited;
  ISkinControl_CustomMouseMove(Shift,X,Y,False,Self);
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);
begin
  Inherited;
  ISkinControl_CustomMouseUp(Button,Shift,X,Y,False,Self);
end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;MousePos: TPoint):Boolean;
begin
  Result:=DoMouseWheel(Shift,WheelDelta,MousePos.X,MousePos.Y);
end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;X, Y: Double):Boolean;
begin
  Result:=Inherited DoMouseWheel(Shift,WheelDelta,Point(ControlSize(X),ControlSize(Y)));
  if GetSkinControlType<>nil then
  begin
    Result:=TSkinControlType(GetSkinControlType).CustomMouseWheel(Shift,WheelDelta,ControlSize(X),ControlSize(Y));
  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.CMMouseEnter(var Message: TMessage);
begin
  Inherited;
  ISkinControl_CustomMouseEnter;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.CMMouseLeave(var Message: TMessage);
begin
  Inherited;
  ISkinControl_CustomMouseLeave;
end;











