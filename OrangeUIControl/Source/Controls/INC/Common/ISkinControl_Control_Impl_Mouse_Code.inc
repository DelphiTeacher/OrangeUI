

//自已写的
procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.ISkinControl_CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double;const AIsChildMouseEvent:Boolean;const AChild:TObject);
var
  AParentControlIntf:ISkinControl;
begin

  if FSkinControlType<>nil then
  begin
      FSkinControlType.FCurrentMouseEventIsChildOwn:=AIsChildMouseEvent;
      FSkinControlType.FCurrentMouseEventChild:=AChild;
      FSkinControlType.CustomMouseDown(Button,Shift,X,Y);

      {$IFDEF FMX}
      if Not AIsChildMouseEvent then
      begin
        //调用全局的鼠标事件
        if Assigned(GlobalMouseDownEvent) then
        begin
          FSkinControlType.FMouseDownScreenPt:=Self.LocalToScreen(FSkinControlType.FMouseDownPt);
          GlobalMouseDownEvent(Self,Button,Shift,
                                    FSkinControlType.FMouseDownScreenPt.X,
                                    FSkinControlType.FMouseDownScreenPt.Y);
        end;
      end;
      {$ENDIF}


  end;



  if (      FParentMouseEvent                         //传递给Parent
        or (FMouseEventTransToParentType=mettptTrans) //传递给Parent


        //根据ScrollBox,如果父控件是ScrollBox,那么需要传递
        or (FMouseEventTransToParentType=mettptAuto)
            and (
                //从GetParentIsScrollBoxContent中获取,就不用再计算
                Self.FParentIsScrollBox
                //如果父控件是ScrollBox,自动传递鼠标消息给ScrollBox,让它能滑动
                or GetParentIsScrollBoxContent(Self,Self.FParentIsScrollBox,Self.FParentScrollBox)
                )


        //根据CanGesutrePageControl,如果父控件是CanGesutrePageControl,那么需要传递
        or (FMouseEventTransToParentType=mettptAuto)
            and (
                //从GetParentIsCanGesturePageControl中获取,就不用再计算
                Self.FParentIsCanGesutrePageControl
                //如果父控件是CanGesutrePageControl,自动传递鼠标消息给CanGesutrePageControl,让它能滑动
                or GetParentIsCanGesturePageControl(Self,Self.FParentIsCanGesutrePageControl,Self.FParentCanGesutrePageControl)
                )
        )

    and (Parent<>nil) and (Parent is TControl) then
  begin

      //wn
      if Parent.GetInterface(IID_ISkinControl,AParentControlIntf) then
      begin
          AParentControlIntf.ISkinControl_CustomMouseDown(Button,
                                                            Shift,
                                                            X+Left,
                                                            Y+Top,
                                                            True,
                                                            AChild);
      end
      else
      //是Frame，则调用Frame.Parent
      //但是有个问题就是Frame套Frame就不能再晌应鼠标事件了
      if (Parent is TControl)
        and Parent.Parent.GetInterface(IID_ISkinControl,AParentControlIntf) then
      begin

         AParentControlIntf.ISkinControl_CustomMouseDown(Button,Shift,

                                                            X+Left+GetControlLeft(TControl(Parent)),
                                                            Y+Top+GetControlTop(TControl(Parent)),
                                                            True,
                                                            AChild
                                                            );
      end
      else
      begin

          {$IFDEF FMX}
         if Assigned(TControl(Parent).OnMouseDown) then
         begin
           TControl(Parent).OnMouseDown(Parent,Button,Shift,X+Left,Y+Top);
         end;
          {$ENDIF FMX}

      end;
  end;



end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.ISkinControl_CustomMouseMove(Shift:TShiftState;X, Y: Double;const AIsChildMouseEvent:Boolean;const AChild:TObject);
var
  AParentControlIntf:ISkinControl;
begin
  if FSkinControlType<>nil then
  begin
      FSkinControlType.FCurrentMouseEventIsChildOwn:=AIsChildMouseEvent;
      FSkinControlType.CustomMouseMove(Shift,X,Y);

      {$IFDEF FMX}
      if Not AIsChildMouseEvent then
      begin
        if Assigned(GlobalMouseMoveEvent) then
        begin
          FSkinControlType.FMouseMoveScreenPt:=Self.LocalToScreen(FSkinControlType.FMouseMovePt);
          GlobalMouseMoveEvent(Self,Shift,
                                    FSkinControlType.FMouseMoveScreenPt.X,
                                    FSkinControlType.FMouseMoveScreenPt.Y);
        end;
      end;
      {$ENDIF}




  end;


  if (      FParentMouseEvent                       //传递
        or (FMouseEventTransToParentType=mettptTrans) //传递

        or (FMouseEventTransToParentType=mettptAuto)  //自动
            and
            (
              //从GetParentIsScrollBoxContent中获取,就不用再计算
              Self.FParentIsScrollBox
              //如果父控件是ScrollBox,自动传递鼠标消息给ScrollBox,让它能滑动
              or GetParentIsScrollBoxContent(Self,Self.FParentIsScrollBox,Self.FParentScrollBox)
            )

        or (FMouseEventTransToParentType=mettptAuto)  //自动
            and
            (
              //从GetParentIsCanGesturePageControl中获取,就不用再计算
              Self.FParentIsCanGesutrePageControl
              //如果父控件是CanGesutrePageControl,自动传递鼠标消息给CanGesutrePageControl,让它能滑动
              or GetParentIsCanGesturePageControl(Self,Self.FParentIsCanGesutrePageControl,Self.FParentCanGesutrePageControl)
            )
    )
    and (Parent<>nil) and (Parent is TControl) then
  begin

      //wn
      if Parent.GetInterface(IID_ISkinControl,AParentControlIntf) then
      begin
        AParentControlIntf.ISkinControl_CustomMouseMove(Shift,
                                                        X+Left,
                                                        Y+Top,
                                                        True,
                                                        AChild);
      end
      else
      //是Frame，则调用Frame.Parent
      //但是有个问题就是Frame套Frame就不能再晌应鼠标事件了
      if (Parent is TControl)
        and
        Parent.Parent.GetInterface(IID_ISkinControl,AParentControlIntf) then
      begin


         AParentControlIntf.ISkinControl_CustomMouseMove(Shift,
                                                            X+Left+GetControlLeft(TControl(Parent)),
                                                            Y+Top+GetControlTop(TControl(Parent)),
                                                            True,
                                                            AChild
                                                            );
      end
      else
      begin
          {$IFDEF FMX}
         if Assigned(TControl(Parent).OnMouseMove) then
         begin
           TControl(Parent).OnMouseMove(Parent,Shift,X+Left,Y+Top);
         end;
          {$ENDIF FMX}

      end;

  end;




end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.ISkinControl_CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double;const AIsChildMouseEvent:Boolean;const AChild:TObject);
var
  AParentControlIntf:ISkinControl;
begin

  if FSkinControlType<>nil then
  begin
      FSkinControlType.FCurrentMouseEventIsChildOwn:=AIsChildMouseEvent;
      FSkinControlType.CustomMouseUp(Button,Shift,X,Y);

      {$IFDEF FMX}
      if Not AIsChildMouseEvent then
      begin
        if Assigned(GlobalMouseUpEvent) then
        begin
          FSkinControlType.FMouseUpScreenPt:=Self.LocalToScreen(FSkinControlType.FMouseUpPt);
          GlobalMouseUpEvent(Self,Button,Shift,
                                    FSkinControlType.FMouseUpScreenPt.X,
                                    FSkinControlType.FMouseUpScreenPt.Y);
        end;
      end;
      {$ENDIF}

  end;


  if (      FParentMouseEvent
        or (FMouseEventTransToParentType=mettptTrans)

        or (FMouseEventTransToParentType=mettptAuto)
            and
            (
              Self.FParentIsScrollBox//从GetParentIsScrollBoxContent中获取,就不用再计算
              //如果父控件是ScrollBox,自动传递鼠标消息给ScrollBox,让它能滑动
              or GetParentIsScrollBoxContent(Self,Self.FParentIsScrollBox,Self.FParentScrollBox)
            )


        or (FMouseEventTransToParentType=mettptAuto)
            and
            (
              Self.FParentIsCanGesutrePageControl//从GetParentIsCanGesturePageControl中获取,就不用再计算
              //如果父控件是CanGesutrePageControl,自动传递鼠标消息给CanGesutrePageControl,让它能滑动
              or GetParentIsCanGesturePageControl(Self,Self.FParentIsCanGesutrePageControl,Self.FParentCanGesutrePageControl)
            )


      )
    and (Parent<>nil) and (Parent is TControl) then
  begin

      //wn
      if Parent.GetInterface(IID_ISkinControl,AParentControlIntf) then
      begin
          AParentControlIntf.ISkinControl_CustomMouseUp(Button,Shift,X+Left,Y+Top,True,AChild);
      end
      else
      //是Frame，则调用Frame.Parent
      //但是有个问题就是Frame套Frame就不能再晌应鼠标事件了
      if (Parent is TControl)
        and Parent.Parent.GetInterface(IID_ISkinControl,AParentControlIntf) then
      begin

         AParentControlIntf.ISkinControl_CustomMouseUp(Button,Shift,

                                                            X+Left+GetControlLeft(TControl(Parent)),
                                                            Y+Top+GetControlTop(TControl(Parent)),
                                                            AIsChildMouseEvent,
                                                            AChild
                                                            );
      end
      else
      begin

          {$IFDEF FMX}
         if Assigned(TControl(Parent).OnMouseUp) then
         begin
           TControl(Parent).OnMouseUp(Parent,Button,Shift,X+Left,Y+Top);
         end;
          {$ENDIF FMX}

      end;


  end;



end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.ISkinControl_CustomMouseEnter;
begin
  if FSkinControlType<>nil then
  begin
    FSkinControlType.CustomMouseEnter;

  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.ISkinControl_CustomMouseLeave;
begin
  if FSkinControlType<>nil then
  begin
    FSkinControlType.CustomMouseLeave;

  end;
end;













procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetIsMouseDown(const Value: Boolean);
begin
  Self.FIsMouseDown:=Value;
end;

procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.SetIsMouseOver(const Value: Boolean);
begin
  FIsMouseOver:=Value;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetIsMouseDown: Boolean;
begin
  Result:=FIsMouseDown;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetIsMouseOver: Boolean;
begin
  Result:=FIsMouseOver
        {$IFDEF FMX}
        or (Inherited IsMouseOver)
        {$ENDIF}
        ;
end;










//在点击事件中设置是否勾选属性
procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.StayClick;
begin
  if Assigned(Self.FOnStayClick) then
  begin
    Self.FOnStayClick(Self);
  end;
end;

//在点击事件中设置是否勾选属性
procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.Click;
begin


  if Not GetParentIsScrollBoxContent(Self,Self.FParentIsScrollBox,Self.FParentScrollBox) then
  begin
      //父控件不是ScrollBox,那么直接调用OnClick
      Inherited;
  end;



  if (GetSkinControlType<>nil) then
  begin
    //按下和弹起的距离不超过5,就调用OnStayClick
    if (GetSkinControlType.FMouseDownAbsolutePt.X<>0)
      and (Abs(GetSkinControlType.FMouseDownAbsolutePt.X-GetSkinControlType.FMouseMoveAbsolutePt.X)<5)
      and (Abs(GetSkinControlType.FMouseDownAbsolutePt.Y-GetSkinControlType.FMouseMoveAbsolutePt.Y)<5) then
    begin
        if Self.FParentIsScrollBox
          or GetParentIsScrollBoxContent(Self,Self.FParentIsScrollBox,Self.FParentScrollBox) then
        begin
          //在ScrollBox上面要判断按下和弹起的距离
          Inherited;
        end;




        StayClick;
    end;
  end;



end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetOnCustomMouseDown:TMouseEvent;
begin
  Result:=FOnCustomMouseDown;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetOnCustomMouseUp:TMouseEvent;
begin
  Result:=FOnCustomMouseUp;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetOnCustomMouseMove:TMouseMoveEvent;
begin
  Result:=FOnCustomMouseMove;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetOnCustomMouseEnter:TNotifyEvent;
begin
  Result:=FOnCustomMouseEnter;
end;

function {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.GetOnCustomMouseLeave:TNotifyEvent;
begin
  Result:=FOnCustomMouseLeave;
end;



