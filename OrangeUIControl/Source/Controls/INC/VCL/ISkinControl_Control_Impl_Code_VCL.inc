//ISkinControl控件接口基本方法实现




function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetParent: TWinControl;
begin
  Result:=Self.Parent;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetHeight(const Value: Integer);
begin
  Height:=Value;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetHeightInt(const Value: Integer);
begin
  Height:=Value;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetParent(const Value: TParentControl);
begin
  Parent:=Value;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetWidth(const Value: Integer);
begin
  Width:=Value;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetWidthInt(const Value: Integer);
begin
  Width:=Value;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetLeft(const Value: Integer);
begin
  Left:=Value;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetTop(const Value: Integer);
begin
  Top:=Value;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetVisible(const Value: Boolean);
begin
  Visible:=Value;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetLeft: Integer;
begin
  Result:=Self.Left;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetTop: Integer;
begin
  Result:=Self.Top;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetVisible: Boolean;
begin
  Result:=Self.Visible;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetWidth: TControlSize;
begin
  Result:=Self.Width;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetHeight: TControlSize;
begin
  Result:=Self.Height;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetWidthInt: Integer;
begin
  Result:=Self.Width;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetHeightInt: Integer;
begin
  Result:=Self.Height;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetEnabled:Boolean;
begin
  Result:=Self.Enabled;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetFocused:Boolean;
begin
  Result:=False;

  {$IFDEF VCL}
  if Self is TWinControl then
  begin
    Result:=TWinControl(Self).Focused;
  end;
  {$ENDIF}

//  {$IFDEF WinControl}
//  if Self is TWinControl then
//  begin
//    Result:=TWinControl(Self).Focused;
//  end;
//  {$ENDIF}
//
//  {$IFDEF WinEdit}
//  if Self is TWinControl then
//  begin
//    Result:=TWinControl(Self).Focused;
//  end;
//  {$ENDIF}
//  {$IFDEF WinMemo}
//  if Self is TWinControl then
//  begin
//    Result:=TWinControl(Self).Focused;
//  end;
//  {$ENDIF}
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetFocused(const Value: Boolean);
begin
//  if Self is TWinControl then
//  begin
//    if TWinControl(Self).CanFocus then TWinControl(Self).SetFocus;
//  end;
end;



