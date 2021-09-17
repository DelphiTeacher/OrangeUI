

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetNeedHitTest:Boolean;
begin

  {$IFDEF FMX}
  //FMX自带的属性
  Result:=HitTest;// and Assigned(OnClick);
  {$ENDIF}


  {$IFDEF VCL}
  Result:=FNeedHitTest;
  {$ENDIF}


end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetHitTestValue:Integer;
begin
  Result:=FHitTestValue;
end;



function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetDirectUIVisible:Boolean;
begin
  //DirectUI状态下是否显示
  Result:=FDirectUIVisible;

end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetAutoSizeHeight: Double;
begin
  if (Self.GetSkinControlType<>nil) then
  begin
    Result:=TSkinControlType(Self.GetSkinControlType).GetAutoSizeHeight;
    if Result=-1 then
    begin
      Result:=Self.Height;
    end;
  end
  else
  begin
    Result:=Self.Height;
  end;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetAutoSizeWidth: Double;
begin
  if (Self.GetSkinControlType<>nil) then
  begin
    Result:=TSkinControlType(Self.GetSkinControlType).GetAutoSizeWidth;
    if Result=-1 then
    begin
      Result:=Self.Width;
    end;
  end
  else
  begin
    Result:=Self.Width;
  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetDirectUIParentIntf(Value:IDirectUIParent);
begin
  FDirectUIParentIntf:=Value;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.AutoSizeBoundsRect: TRectF;
begin
  Result:=RectF(Self.Left,
                Self.Top,
                Self.Left+Self.GetAutoSizeWidth,
                Self.Top+Self.GetAutoSizeHeight);
end;