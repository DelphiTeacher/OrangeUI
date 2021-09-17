

//����д��
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
        //����ȫ�ֵ�����¼�
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



  if (      FParentMouseEvent                         //���ݸ�Parent
        or (FMouseEventTransToParentType=mettptTrans) //���ݸ�Parent


        //����ScrollBox,������ؼ���ScrollBox,��ô��Ҫ����
        or (FMouseEventTransToParentType=mettptAuto)
            and (
                //��GetParentIsScrollBoxContent�л�ȡ,�Ͳ����ټ���
                Self.FParentIsScrollBox
                //������ؼ���ScrollBox,�Զ����������Ϣ��ScrollBox,�����ܻ���
                or GetParentIsScrollBoxContent(Self,Self.FParentIsScrollBox,Self.FParentScrollBox)
                )


        //����CanGesutrePageControl,������ؼ���CanGesutrePageControl,��ô��Ҫ����
        or (FMouseEventTransToParentType=mettptAuto)
            and (
                //��GetParentIsCanGesturePageControl�л�ȡ,�Ͳ����ټ���
                Self.FParentIsCanGesutrePageControl
                //������ؼ���CanGesutrePageControl,�Զ����������Ϣ��CanGesutrePageControl,�����ܻ���
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
      //��Frame�������Frame.Parent
      //�����и��������Frame��Frame�Ͳ�������Ӧ����¼���
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


  if (      FParentMouseEvent                       //����
        or (FMouseEventTransToParentType=mettptTrans) //����

        or (FMouseEventTransToParentType=mettptAuto)  //�Զ�
            and
            (
              //��GetParentIsScrollBoxContent�л�ȡ,�Ͳ����ټ���
              Self.FParentIsScrollBox
              //������ؼ���ScrollBox,�Զ����������Ϣ��ScrollBox,�����ܻ���
              or GetParentIsScrollBoxContent(Self,Self.FParentIsScrollBox,Self.FParentScrollBox)
            )

        or (FMouseEventTransToParentType=mettptAuto)  //�Զ�
            and
            (
              //��GetParentIsCanGesturePageControl�л�ȡ,�Ͳ����ټ���
              Self.FParentIsCanGesutrePageControl
              //������ؼ���CanGesutrePageControl,�Զ����������Ϣ��CanGesutrePageControl,�����ܻ���
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
      //��Frame�������Frame.Parent
      //�����и��������Frame��Frame�Ͳ�������Ӧ����¼���
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
              Self.FParentIsScrollBox//��GetParentIsScrollBoxContent�л�ȡ,�Ͳ����ټ���
              //������ؼ���ScrollBox,�Զ����������Ϣ��ScrollBox,�����ܻ���
              or GetParentIsScrollBoxContent(Self,Self.FParentIsScrollBox,Self.FParentScrollBox)
            )


        or (FMouseEventTransToParentType=mettptAuto)
            and
            (
              Self.FParentIsCanGesutrePageControl//��GetParentIsCanGesturePageControl�л�ȡ,�Ͳ����ټ���
              //������ؼ���CanGesutrePageControl,�Զ����������Ϣ��CanGesutrePageControl,�����ܻ���
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
      //��Frame�������Frame.Parent
      //�����и��������Frame��Frame�Ͳ�������Ӧ����¼���
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










//�ڵ���¼��������Ƿ�ѡ����
procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.StayClick;
begin
  if Assigned(Self.FOnStayClick) then
  begin
    Self.FOnStayClick(Self);
  end;
end;

//�ڵ���¼��������Ƿ�ѡ����
procedure {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc}.Click;
begin


  if Not GetParentIsScrollBoxContent(Self,Self.FParentIsScrollBox,Self.FParentScrollBox) then
  begin
      //���ؼ�����ScrollBox,��ôֱ�ӵ���OnClick
      Inherited;
  end;



  if (GetSkinControlType<>nil) then
  begin
    //���º͵���ľ��벻����5,�͵���OnStayClick
    if (GetSkinControlType.FMouseDownAbsolutePt.X<>0)
      and (Abs(GetSkinControlType.FMouseDownAbsolutePt.X-GetSkinControlType.FMouseMoveAbsolutePt.X)<5)
      and (Abs(GetSkinControlType.FMouseDownAbsolutePt.Y-GetSkinControlType.FMouseMoveAbsolutePt.Y)<5) then
    begin
        if Self.FParentIsScrollBox
          or GetParentIsScrollBoxContent(Self,Self.FParentIsScrollBox,Self.FParentScrollBox) then
        begin
          //��ScrollBox����Ҫ�жϰ��º͵���ľ���
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


