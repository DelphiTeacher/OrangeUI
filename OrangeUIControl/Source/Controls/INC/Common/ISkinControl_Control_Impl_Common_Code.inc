


procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);

  if (Operation=opRemove) then
  begin


    if (AComponent=Self.FMaterial) then
    begin
      //如果使用的是自己的素材,那么也要清除
      if FCurrentUseSkinMaterial=FMaterial then
      begin
        FCurrentUseSkinMaterial:=nil;
      end;
      FMaterial:=nil;
    end
    else
    if (AComponent=Self.FRefMaterial) then
    begin
      if FCurrentUseSkinMaterial=FRefMaterial then
      begin
        FCurrentUseSkinMaterial:=nil;
      end;
      FRefMaterial:=nil;
    end
    else
    if (AComponent=Self.FCurrentUseSkinMaterial) then
    begin
      FCurrentUseSkinMaterial:=nil;
    end;



  end;
end;


procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.Loaded;
begin
  inherited;

  {$IFNDEF NEWOUI}
  {$IFNDEF OUIBaseFMXControl}
  //加载素材
  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Loaded_Code.inc}
  {$ENDIF}
  {$ENDIF}


  //自动更改大小
  TSkinControlProperties(Self.FProperties).AdjustAutoSizeBounds;




  {$IFDEF FMXPopup}
  if not (csDesigning in Self.ComponentState) then
  begin
    //运行时不显示
    Visible:=False;
  end;
  {$ENDIF}

end;







procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.Resize;
begin
  inherited;

  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState)
    and (GetSkinControlType<>nil) then
  begin
    GetSkinControlType.SizeChanged;
  end;

end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.DoEnter;
begin
  inherited;
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState)
    and (GetSkinControlType<>nil) then
  begin
    GetSkinControlType.FocusChanged;
  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.DoExit;
begin
  inherited;
  if GetSkinControlType<>nil then
  begin
    GetSkinControlType.FocusChanged;
  end;
end;





procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetBounds(ALeft, ATop, AWidth, AHeight: TControlSize);
begin
  Inherited SetBounds(ControlSize(ALeft), ControlSize(ATop), ControlSize(AWidth), ControlSize(AHeight));
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetBounds(ABoundsRect:TRectF);
begin
  Inherited SetBounds(ControlSize(ABoundsRect.Left), ControlSize(ABoundsRect.Top), ControlSize(ABoundsRect.Width), ControlSize(ABoundsRect.Height));
end;




function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetParentChildControlCount:Integer;
begin
  {$IFDEF FMX}
  Result:=Parent.ChildrenCount;
  {$ENDIF}

  {$IFDEF VCL}
  Result:=Parent.ControlCount;
  {$ENDIF}

end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetParentChildControl(Index:Integer):TChildControl;
begin

  {$IFDEF FMX}
  Result:=Self.Parent.Children[Index];
  {$ENDIF}

  {$IFDEF VCL}
  Result:=Parent.Controls[Index];
  {$ENDIF}

end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetChildControlCount:Integer;
begin
  {$IFDEF FMX}
  Result:=Self.ChildrenCount;
  {$ENDIF}

  {$IFDEF VCL}
  Result:=Self.ControlCount;
  {$ENDIF}

end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetChildControl(Index:Integer):TChildControl;
begin
  {$IFDEF FMX}
  Result:=Self.Children[Index];
  {$ENDIF}

  {$IFDEF VCL}
  Result:=Self.Controls[Index];
  {$ENDIF}
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetParentMouseEvent:Boolean;
begin
  {$IFDEF FMX}
  Result:=FParentMouseEvent;
  {$ENDIF}

  {$IFDEF VCL}
  {$ENDIF}
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetParentIsScrollBox:Boolean;
begin
  {$IFDEF FMX}
  Result:=FParentIsScrollBox;
  {$ENDIF}

  {$IFDEF VCL}
  {$ENDIF}

end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetParentScrollBox:TControl;
begin
  {$IFDEF FMX}
  Result:=FParentScrollBox;
  {$ENDIF}

  {$IFDEF VCL}
  {$ENDIF}

end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetMouseEventTransToParentType:TMouseEventTransToParentType;
begin
  {$IFDEF FMX}
  Result:=FMouseEventTransToParentType;
  {$ENDIF}

  {$IFDEF VCL}
  {$ENDIF}
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetParentMouseEvent(const AValue:Boolean);
begin
  {$IFDEF FMX}
  FParentMouseEvent:=AValue;
  {$ENDIF}

  {$IFDEF VCL}
  {$ENDIF}
end;


procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetMouseEventTransToParentType(const AValue:TMouseEventTransToParentType);
begin
  {$IFDEF FMX}
  FMouseEventTransToParentType:=AValue;
  {$ENDIF}

  {$IFDEF VCL}
  {$ENDIF}
end;


function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetBindItemFieldName:String;
begin
  Result:=FBindItemFieldName;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetBindItemFieldName(AValue:String);
begin
  FBindItemFieldName:=AValue;
end;


//function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetBindItemFieldType:TFieldType;
//begin
//  Result:=FBindItemFieldType;
//end;

//function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetBindItemDataTypeName:String;
//begin
//  Result:=FBindItemDataTypeName;
//end;




