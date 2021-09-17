

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetLeft: TControlSize;
begin
  Result:=Self.Position.X;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetTop: TControlSize;
begin
  Result:=Self.Position.Y;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetWidth: TControlSize;
begin
  Result:=Self.Width;
end;


function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetHeight: TControlSize;
begin
  Result:=Self.Height;
end;








procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetLeft(const Value: TControlSize);
begin
  Self.Position.X:=Value;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetTop(const Value: TControlSize);
begin
  Self.Position.Y:=Value;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetHeight(const Value: TControlSize);
begin
  Height:=Value;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetWidth(const Value: TControlSize);
begin
  Width:=Value;
end;









function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetWidthInt: Integer;
begin
  Result:=Ceil(Width);
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetHeightInt: Integer;
begin
  Result:=Ceil(Height);
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetWidthInt(const Value: Integer);
begin
  Width:=Value;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetHeightInt(const Value: Integer);
begin
  Height:=Value;
end;







function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetParent: TParentControl;
begin
  Result:=TParentControl(Self.Parent);
end;


procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetParent(const Value: TParentControl);
begin
  Parent:=Value;
end;







procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetVisible(const Value: Boolean);
begin
  Visible:=Value;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetVisible: Boolean;
begin
  Result:=Self.Visible;
end;





function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetEnabled:Boolean;
begin
  Result:=Self.Enabled;
end;




function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetFocused:Boolean;
begin
  Result:=Self.IsFocused;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetFocused(const Value: Boolean);
begin
  {$IFDEF WinControl}
  inherited SetFocus;
  {$ENDIF}
  {$IFDEF FmxControl}
  DoEnter;
  {$ENDIF}
end;



