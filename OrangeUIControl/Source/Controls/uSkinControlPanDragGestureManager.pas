//convert pas to utf8 by ¥
unit uSkinControlPanDragGestureManager;

interface

{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  Types,
  DateUtils,
  Math,

  {$IFDEF VCL}
  Messages,
  ExtCtrls,
  Controls,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Dialogs,
  {$ENDIF}


  uGraphicCommon,
  uFuncCommon,
  uSkinAnimator,
  uBaseList,
  uBaseLog,
  uComponentType,

  uSkinControlGestureManager;


type
//  //平拖的方向
//  TPanDragDirectionType=(
//                        //从右往左平拖
//                        pddtMinToMax,
//                        //从左往右平拖
//                        pddtMaxToMin
//                        );
//
//
//  //列表项是否可以平拖事件
//  TCanPanDragEvent=procedure(Sender:TObject;var AIsCanDrag:Boolean) of object;



  //获取当前页面可以平移切换的方向的事件,有些页面只能左移,有些页面只能右移
  TGetCurrentCanPanDragDirectionsEvent=procedure(Sender:TObject;var ACanPanDragDirections:TGestureDirections) of object;
  //获取当前页面,某个方向可以平拖移动的长度
  TGetCurrentCanPanDragLengthEvent=procedure(Sender:TObject;AGestureDirection:TGestureDirection;var ACurrentLength:Double) of object;

  //平移切换页面结束事件
  TPanDragSwitchEndEvent=procedure(Sender:TObject;AGestureDirection:TGestureDirection) of object;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinControlPanDragGestureManager=class(TSkinControlGestureManager)
  private
    FOnGetCurrentCanPanDragDirections: TGetCurrentCanPanDragDirectionsEvent;
    FOnGetCurrentCanPanDragLength: TGetCurrentCanPanDragLengthEvent;
    FOnPanDragSwitchEnd: TPanDragSwitchEndEvent;
//  private
//    FOnPanDragBack: TNotifyEvent;
//    FOnPanDragGo: TNotifyEvent;
//  protected
//    //平拖控件是否显示了
//    FIsPanDragHasArrived:Boolean;
//
//
//    FIsBeginPanDrag:Boolean;
//
//
//    //平拖的距离
//    FPanDragMax: Double;
//
//
//    //是否启用平拖
//    FEnablePanDrag:Boolean;
//    //允许平拖的方向
//    FPanDragDirection:TPanDragDirectionType;
//
//
//    //是否正在停止平拖
//    FIsStopingPanDrag:Boolean;


//    //准备平拖事件(可以根据Item设置PanDragControl)
//    FOnPreparePanDrag:TNotifyEvent;
//
//
//
//    //平拖滑动的速度
//    FStartPanDragVelocity:Double;


//    //是否可以启用平拖
//    function CanEnablePanDrag:Boolean;virtual;


//    //准备平拖
//    procedure PreparePanDrag;
//
//    //平拖手势鼠标第一次按下,准备平拖
//    procedure DoCustomFirstMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
//
//    //平拖手势位置更改
//    procedure DoCustomPositionChange(Sender:TObject);override;
//
//    //计算惯性滚动所滑动的距离
//    procedure DoCustomCalcInertiaScrollDistance(Sender:TObject;
//                                            var InertiaDistance:Double;  //惯性滚动的距离
//                                            var CanInertiaScroll:Boolean //是否可以惯性滚动
//                                            );override;
//
//    //平拖滚回到初始结束
//    procedure DoScrollToInitialAnimateEnd(Sender:TObject);override;
//
//  public
//    //开始平拖
//    procedure StartPanDrag;
//    //停止平拖
//    procedure StopPanDrag;


    FCurrentPanDragGestureDirection:TGestureDirection;

    FIsStartedPanDrag:Boolean;

    //可以手势切换的距离(小于1的小数为百分比,大于1时为距离)
    FCanGestureSwitchDistance:Double;


//    FMinControl:TControl;
//    FCurrentControl:TControl;
//    FMaxControl:TControl;

//    //当前页面的起点
//    FCurrentStartPos:Double;
//    FCurrentLength:Double;
//    FMaxLength:Double;
//    FMinLength:Double;


    //平移切换的方向,切换好之后确定左右的控件,根据当前是什么控件才能知道
    function GetCurrentCanPanDragDirections:TGestureDirections;virtual;
    //获取当前页面,某个方向可以平拖移动的长度
    function GetCurrentCanPanDragLength(AGestureDirection:TGestureDirection):Double;virtual;

    //切换结束
    procedure DoPanDragSwitchEnd(AGestureDirection:TGestureDirection);virtual;

//    procedure DoOffsetChange();

//    procedure DoInnerPositionChange(Sender:TObject);
    //计算惯性滚动的距离(用于页面切换,判断是否可以切换)
    procedure DoInnerCalcInertiaScrollDistanceEvent(Sender:TObject;
                                              var InertiaDistance:Double;  //惯性滚动的距离
                                              var CanInertiaScroll:Boolean //是否可以惯性滚动
                                              );
    //惯性滚动结束事件(用于下拉刷新)
    procedure DoInnerInertiaScrollAnimateEndEvent(Sender:TObject;
                                            var CanStartScrollToInitial:Boolean;
                                            var AMinOverRangePosValue_Min:Double;
                                            var AMaxOverRangePosValue_Min:Double);

  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    function GetCurrentOffset:Double;
    procedure StartPanDragSwitch(AGestureDirection:TGestureDirection);
  published
    //可以手势切换的距离(小于1的小数为百分比,大于1时为距离)
    property CanGestureSwitchDistance:Double read FCanGestureSwitchDistance write FCanGestureSwitchDistance;

    //当前页面可以平移切换的方向
    property OnGetCurrentCanPanDragDirections:TGetCurrentCanPanDragDirectionsEvent read FOnGetCurrentCanPanDragDirections write FOnGetCurrentCanPanDragDirections;

    //当前页面可以平移拖动的距离
    property OnGetCurrentCanPanDragLength:TGetCurrentCanPanDragLengthEvent read FOnGetCurrentCanPanDragLength write FOnGetCurrentCanPanDragLength;

    //平移切换结束事件
    property OnPanDragSwitchEnd:TPanDragSwitchEndEvent read FOnPanDragSwitchEnd write FOnPanDragSwitchEnd;



    /// <summary>
    ///   <para>
    ///     启用平拖
    ///   </para>
    ///   <para>
    ///     Enable Item PanDrag
    ///   </para>
    /// </summary>
//    property EnablePanDrag:Boolean read FEnablePanDrag write FEnablePanDrag;//SetEnablePanDrag;

//    property OnPanDragGo:TNotifyEvent read FOnPanDragGo write FOnPanDragGo;
//    property OnPanDragBack:TNotifyEvent read FOnPanDragBack write FOnPanDragBack;

    /// <summary>
    ///   <para>
    ///     平拖的方向
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
//    property PanDragDirection:TPanDragDirectionType read FPanDragDirection write FPanDragDirection;

    /// <summary>
    ///   <para>
    ///     平拖的距离
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
//    property PanDragMax: Double read FPanDragMax write FPanDragMax;
  end;




  //切换控件的手势控件
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TBaseSkinSwitchPageGestureManager=class(TSkinControlPanDragGestureManager)
  protected
    //是否移动
    FIsNotMoveMiddleControl:Boolean;

    //不能看到最左边,最右边空白的区域
    FIsNotCanSeeOutOfBoundArea:Boolean;

    //获取基准控件的起点
    function GetBaseControlStartPos:Double;virtual;
    //获取当前页面的下标
    function GetPageIndex:Integer;virtual;abstract;
    //设置当前页面的下标
    procedure SetPageIndex(APageIndex:Integer);virtual;abstract;
    //获取页面个数
    function GetPageCount:Integer;virtual;abstract;
    //获取页面尺寸(宽度或高度)
    function GetPageItemSize(APageIndex:Integer;AGestureKind:TGestureKind;AGestureDirection:TGestureDirection):Double;virtual;abstract;
    //设置页面的位置
    procedure SetPagePos(APageIndex:Integer;AGestureKind:TGestureKind;APos:Double);virtual;abstract;

    procedure DoCustomPositionChange(Sender:TObject);override;

    //平移切换的方向,切换好之后确定左右的控件,根据当前是什么控件才能知道
    function GetCurrentCanPanDragDirections:TGestureDirections;override;
    //获取当前页面,某个方向可以平拖移动的长度
    function GetCurrentCanPanDragLength(AGestureDirection:TGestureDirection):Double;override;

    //切换结束事件
    procedure DoPanDragSwitchEnd(AGestureDirection:TGestureDirection);override;

  end;




  //切换控件的手势控件
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinSwitchPageGestureManager=class(TBaseSkinSwitchPageGestureManager)
  private
    FPageList:TBaseList;
    FPageIndex:Integer;
    FCurrentControlStartPos:Double;
    function GetMiddleControl: TControl;
    function GetNextControl: TControl;
    function GetPriorControl: TControl;
    procedure SetMiddleControl(const Value: TControl);
    procedure SetNextControl(const Value: TControl);
    procedure SetPriorControl(const Value: TControl);
    function GetPageList: TBaseList;
    procedure SyncCurrentControlStartPos;
  protected
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
  protected
    function GetPageIndex:Integer;override;
    procedure SetPageIndex(APageIndex:Integer);override;
    function GetPageCount:Integer;override;
    function GetBaseControlStartPos:Double;override;
    function GetPageItemSize(APageIndex:Integer;AGestureKind:TGestureKind;AGestureDirection:TGestureDirection):Double;override;
    procedure SetPagePos(APageIndex:Integer;AGestureKind:TGestureKind;APos:Double);override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    property MiddleControl:TControl read GetMiddleControl write SetMiddleControl;
    property PriorControl:TControl read GetPriorControl write SetPriorControl;
    property NextControl:TControl read GetNextControl write SetNextControl;

    //是否只移动中间的控件
    property IsNotMoveMiddleControl:Boolean read FIsNotMoveMiddleControl write FIsNotMoveMiddleControl;
    property IsNotCanSeeOutOfBoundArea:Boolean read FIsNotCanSeeOutOfBoundArea write FIsNotCanSeeOutOfBoundArea;
  end;






implementation




{ TSkinControlPanDragGestureManager }


procedure TSkinControlPanDragGestureManager.DoInnerInertiaScrollAnimateEndEvent(Sender: TObject;
  var CanStartScrollToInitial: Boolean;
  var AMinOverRangePosValue_Min:Double;
  var AMaxOverRangePosValue_Min:Double);
begin
  if FIsStartedPanDrag then
  begin
      //直接用惯性滚动切换到下一页了,那就不需要再滚动回初始了
      CanStartScrollToInitial:=False;






//      //确定当前的控件
//      if Self.FCurrentControl=pnlA then
//      begin
//          case FCurrentPanDragGestureDirection of
//            isdScrollToMin:
//            begin
//              FMinControl:=Self.pnlA;
//              FCurrentControl:=Self.pnlB;
//              FMaxControl:=nil;
//            end;
//            isdScrollToMax:
//            begin
//              FMinControl:=nil;
//              FCurrentControl:=Self.pnlC;
//              FMaxControl:=Self.pnlA;
//            end;
//          end;
//      end
//      else
//      if Self.FCurrentControl=pnlC then
//      begin
//          case FCurrentPanDragGestureDirection of
//            isdScrollToMin:
//            begin
//              FMinControl:=Self.pnlC;
//              FCurrentControl:=Self.pnlA;
//              FMaxControl:=Self.pnlB;
//            end;
//            isdScrollToMax:
//            begin
//              FMinControl:=nil;
//              FCurrentControl:=nil;
//              FMaxControl:=Self.pnlC;
//            end;
//          end;
//      end
//      else
//      if Self.FCurrentControl=pnlB then
//      begin
//          case FCurrentPanDragGestureDirection of
//            isdScrollToMin:
//            begin
//              FMinControl:=Self.pnlB;
//              FCurrentControl:=nil;
//              FMaxControl:=nil;
//            end;
//            isdScrollToMax:
//            begin
//              FMinControl:=pnlC;
//              FCurrentControl:=pnlA;
//              FMaxControl:=Self.pnlB;
//            end;
//          end;
//      end;




      Self.MaxOverRangePosValue:=0;
      Self.MinOverRangePosValue:=0;


      DoPanDragSwitchEnd(FCurrentPanDragGestureDirection);




//      FCurrentStartPos:=0;
//      FCurrentLength:=0;
//      FMaxLength:=0;
//      FMinLength:=0;
//      if FCurrentControl<>nil then
//      begin
//        FCurrentStartPos:=Self.FCurrentControl.Position.X;
//        FCurrentLength:=Self.FCurrentControl.Width;
//      end;
//      if FMaxControl<>nil then FMaxLength:=Self.FMaxControl.Width;
//      if FMinControl<>nil then FMinLength:=Self.FMinControl.Width;


  end;

end;

procedure TSkinControlPanDragGestureManager.DoPanDragSwitchEnd(AGestureDirection: TGestureDirection);
begin
  if Assigned(FOnPanDragSwitchEnd) then
  begin
    FOnPanDragSwitchEnd(Self,AGestureDirection);
  end;

end;

procedure TSkinControlPanDragGestureManager.DoInnerCalcInertiaScrollDistanceEvent(Sender: TObject;
  var InertiaDistance: Double;
  var CanInertiaScroll: Boolean);
var
  ACanGestureSwitchDistance:Double;
begin
//  FMX.Types.Log.d('OrangeUI DoInnerCalcInertiaScrollDistanceEvent MaxOverRangePosValue '+FloatToStr(Self.MaxOverRangePosValue));
//  FMX.Types.Log.d('OrangeUI DoInnerCalcInertiaScrollDistanceEvent MinOverRangePosValue '+FloatToStr(Self.MinOverRangePosValue));

  FIsStartedPanDrag:=False;

  //越界超过了一定的距离,就可以切换到下一页,不然就滚回初始
  //往左移,MaxOverrangePosValue越来越大,

  ACanGestureSwitchDistance:=FCanGestureSwitchDistance;
  if (Self.FCanGestureSwitchDistance>0) and (Self.FCanGestureSwitchDistance<1) then
  begin
    ACanGestureSwitchDistance:=Self.FCanGestureSwitchDistance*GetCurrentCanPanDragLength(FCurrentPanDragGestureDirection);
  end;

  if (Self.MaxOverRangePosValue>ACanGestureSwitchDistance)
        and (isdScrollToMin in Self.GetCurrentCanPanDragDirections)
        and (GetCurrentCanPanDragLength(FCurrentPanDragGestureDirection)>0)
    or (Self.MinOverRangePosValue>ACanGestureSwitchDistance)
        and (isdScrollToMax in Self.GetCurrentCanPanDragDirections)
        and (GetCurrentCanPanDragLength(FCurrentPanDragGestureDirection)>0) then
  begin

      if Self.MaxOverRangePosValue>0 then
      begin
        //切换到B
        FCurrentPanDragGestureDirection:=TGestureDirection.isdScrollToMin;

        //B滑出来
        //需要惯性滚动的距离,为负了怎么办?
        InertiaDistance:=(GetCurrentCanPanDragLength(FCurrentPanDragGestureDirection)-Self.CalcMaxOverRangePosValue);


      end
      else
      begin
        //切换到C
        FCurrentPanDragGestureDirection:=TGestureDirection.isdScrollToMax;

        //B滚回去
        InertiaDistance:=(GetCurrentCanPanDragLength(FCurrentPanDragGestureDirection)-Self.CalcMinOverRangePosValue);

      end;
//      FMX.Types.Log.d('OrangeUI DoInnerCalcInertiaScrollDistanceEvent 可以平移了 InertiaDistance '+FloatToStr(InertiaDistance));




      Self.InertiaScrollAnimator.TweenType:=TTweenType.Cubic;
      Self.InertiaScrollAnimator.EaseType:=TEaseType.easeOut;
      Self.InertiaScrollAnimator.d:=10;
      Self.InertiaScrollAnimator.Speed:=Const_Deafult_AnimatorSpeed;
      Self.InertiaScrollAnimator.InitialSpeed:=3;
      Self.InertiaScrollAnimator.MaxSpeed:=3;
      Self.InertiaScrollAnimator.minps:=6;


      //可以切换到下一页了
      FIsStartedPanDrag:=True;

  end;

end;

//procedure TSkinControlPanDragGestureManager.DoInnerPositionChange(Sender: TObject);
//begin
////  DoOffsetChange;
////  FMX.Types.Log.d('OrangeUI DoInnerPositionChange '+FloatToStr(Self.Position));
//end;

//procedure TSkinControlPanDragGestureManager.DoOffsetChange;
//begin
//  if (FMinControl<>nil) and (FMinControl<>pnlA) then Self.FMinControl.Position.X:=FCurrentStartPos-FMinLength+Self.GetCurrentOffset;
//  if (FCurrentControl<>nil) and (FCurrentControl<>pnlA) then Self.FCurrentControl.Position.X:=FCurrentStartPos+Self.GetCurrentOffset;
//  if (FMaxControl<>nil) and (FMaxControl<>pnlA) then Self.FMaxControl.Position.X:=FCurrentStartPos+FCurrentLength+Self.GetCurrentOffset;
//end;

function TSkinControlPanDragGestureManager.GetCurrentCanPanDragDirections: TGestureDirections;
begin

  //默认左右都能移动
  Result:=[isdScrollToMin,isdScrollToMax];
  if Assigned(FOnGetCurrentCanPanDragDirections) then
  begin
    FOnGetCurrentCanPanDragDirections(Self,Result);
  end;

//  if Self.FCurrentControl<>nil then
//  begin
//    if FCurrentControl=pnlA then
//    begin
//      Result:=[isdScrollToMin,isdScrollToMax];
//    end;
//    if FCurrentControl=pnlB then
//    begin
//      //只能往右移了
//      Result:=[isdScrollToMax];
//    end;
//    if FCurrentControl=pnlC then
//    begin
//      //只能往左移了
//      Result:=[isdScrollToMin];
//    end;
//
//  end;
end;

function TSkinControlPanDragGestureManager.GetCurrentCanPanDragLength(AGestureDirection: TGestureDirection): Double;
begin
  Result:=0;
  if Assigned(FOnGetCurrentCanPanDragLength) then
  begin
    FOnGetCurrentCanPanDragLength(Self,AGestureDirection,Result);
  end;

//  Result:=Self.FCurrentLength;
//  if Self.FCurrentControl<>nil then
//  begin
//    if FCurrentControl=Self.pnlA then
//    begin
//      case AGestureDirection of
//        isdScrollToMin: Result:=Self.FMaxLength;
//        isdScrollToMax: Result:=Self.FMinLength;
//      end;
//    end;
//    if FCurrentControl=Self.pnlB then
//    begin
//      case AGestureDirection of
//        isdScrollToMax: Result:=Self.FCurrentLength;
//      end;
//    end;
//    if FCurrentControl=Self.pnlC then
//    begin
//      case AGestureDirection of
//        isdScrollToMin: Result:=Self.FCurrentLength;
//      end;
//    end;
//
//  end;
end;

function TSkinControlPanDragGestureManager.GetCurrentOffset:Double;
begin
  Result:=Self.MinOverRangePosValue-Self.MaxOverRangePosValue;
end;


procedure TSkinControlPanDragGestureManager.StartPanDragSwitch(AGestureDirection: TGestureDirection);
begin

  if not (AGestureDirection in GetCurrentCanPanDragDirections) then
  begin
    Exit;
  end;
  
  FIsStartedPanDrag:=True;
  FCurrentPanDragGestureDirection:=AGestureDirection;

  case AGestureDirection of
    isdScrollToMin:
    begin

      Self.DoInertiaScroll(
                          1000,
                          Self.GetCurrentCanPanDragLength(AGestureDirection));
    end;
    isdScrollToMax:
    begin
      Self.DoInertiaScroll(
                          -1000,
                          Self.GetCurrentCanPanDragLength(AGestureDirection));
    end;
  end;

end;

constructor TSkinControlPanDragGestureManager.Create(AOwner:TComponent);
begin
  Inherited Create(AOwner);

//  FIsPanDragHasArrived:=False;
//
//  //是否启用平拖
//  FEnablePanDrag:=True;
//
//  //启动平拖时的速度
//  FStartPanDragVelocity:=500;
//
//  //平拖的方向
//  FPanDragDirection:=pddtMinToMax;

  FCanGestureSwitchDistance:=0.3;//30;

//  FPanDragMax:=100;

//  FMinControl:=Self.pnlC;
//  FCurrentControl:=Self.pnlA;
//  FMaxControl:=Self.pnlB;


//  FCurrentStartPos:=0;


//  FCurrentStartPos:=Self.FCurrentControl.Position.X;
//  FCurrentLength:=Self.FCurrentControl.Width;
//  if FMaxControl<>nil then FMaxLength:=Self.FMaxControl.Width;
//  if FMinControl<>nil then FMinLength:=Self.FMinControl.Width;



  Self.Kind:=TGestureKind.gmkHorizontal;
  Self.Min:=0;
  Self.Max:=0;
  Self.Position:=0;
  Self.OverRangePosValueStep:=1;

//  Self.OnInnerPositionChange:=DoInnerPositionChange;
  Self.OnInnerCalcInertiaScrollDistance:=DoInnerCalcInertiaScrollDistanceEvent;
  Self.OnInnerInertiaScrollAnimateEnd:=DoInnerInertiaScrollAnimateEndEvent;

end;

//procedure TSkinControlPanDragGestureManager.StopPanDrag;
//begin
//  if (FIsPanDragHasArrived) then
//  begin
//
////      FIsStopingPanDrag:=True;
//      //停止惯性滚动
//      Self.InertiaScrollAnimator.Pause;
//
//
//      case FPanDragDirection of
//        pddtMinToMax:
//        begin
//          Self.DoInertiaScroll(-FStartPanDragVelocity,
//                                        Self.FMax*2);
//        end;
//        pddtMaxToMin:
//        begin
//          Self.DoInertiaScroll(FStartPanDragVelocity,
//                                        Self.FMax*2);
//        end;
//      end;
//  end;
//end;
//
//
//procedure TSkinControlPanDragGestureManager.StartPanDrag;
//begin
//  if CanEnablePanDrag and Not FIsPanDragHasArrived then
//  begin
//
//      FIsPanDragHasArrived:=False;
////      FIsStopingPanDrag:=False;
//      //停止滚回到初始
//      Self.ScrollingToInitialAnimator.Pause;
//
//
//      //准备平拖
//      PreparePanDrag;
//
//
//      OutputDebugString(GetDebugLogID+'手动开始平拖');
//      case FPanDragDirection of
//        pddtMinToMax:
//        begin
//            Self.DoInertiaScroll(
//                                FStartPanDragVelocity,
//                                Self.FMax*2);
//        end;
//        pddtMaxToMin:
//        begin
//            Self.DoInertiaScroll(
//                                -FStartPanDragVelocity,
//                                Self.FMax*2);
//        end;
//      end;
//
//  end;
//end;

//function TSkinControlPanDragGestureManager.CanEnablePanDrag: Boolean;
//begin
//  Result:=False;
//  if
//      Self.FEnablePanDrag          //启用平拖
//    and (Self.FPanDragMax>1)       //存在平拖显示面板
//    then
//  begin
//    Result:=True;
//  end;
//end;

//procedure TSkinControlPanDragGestureManager.PreparePanDrag;
//begin
////
////    if Assigned(FOnPreparePanDrag) then
////    begin
////      FOnPreparePanDrag(Self);
////    end;
////
////
////
////    //控件手势管理
////    case Self.FPanDragDirection of
////      pddtMinToMax:
////      begin
////          //从右往左平拖
////          if Not FIsBeginPanDrag then
////          begin
////            //准备平拖开始
////            //需要判断初始手势方向
////            Self.DecideFirstGestureKindDirections:=[isdScrollToMin];
////
////            //平拖到的最大值
////            Self.FMax:=Self.FPanDragMax;
////
////            FIsBeginPanDrag:=True;
////
////          end;
////
////      end;
////      pddtMaxToMin:
////      begin
////          //从左往右平拖
////          if Not FIsBeginPanDrag then
////          begin
////            //准备平拖开始
////            Self.DecideFirstGestureKindDirections:=[isdScrollToMax];
////
////            //平拖到的最大值
////            Self.FMax:=Self.FPanDragMax;
////
////            Self.FPosition:=Self.StaticMax;
////
////            FIsBeginPanDrag:=True;
////
////          end;
////
////        end;
////    end;
//end;

destructor TSkinControlPanDragGestureManager.Destroy;
begin

  Inherited;
end;

//procedure TSkinControlPanDragGestureManager.DoCustomCalcInertiaScrollDistance(
//  Sender: TObject; var InertiaDistance: Double; var CanInertiaScroll: Boolean);
//begin
//  inherited;
//
//  //计算需要滚动的距离
//
//
//  //惯性滚动的快一点
//  Self.InertiaScrollAnimator.TweenType:=TTweenType.Cubic;
//  Self.InertiaScrollAnimator.EaseType:=TEaseType.easeOut;
//  Self.InertiaScrollAnimator.d:=10;
//  Self.InertiaScrollAnimator.Speed:=3;//10;//Const_Deafult_AnimatorSpeed;
////  Self.InertiaScrollAnimator.InitialSpeed:=3;
////  Self.InertiaScrollAnimator.MaxSpeed:=3;
////  Self.InertiaScrollAnimator.minps:=6;
//
//
//  case FPanDragDirection of
//    pddtMinToMax:
//    begin
//        case Self.MouseMoveDirection of
//          isdScrollToMin:
//          begin
//              //返回
//              //正在停止
//              OutputDebugString(GetDebugLogID+'平拖返回');
//  //            Self.FIsStopingPanDrag:=True;
//              InertiaDistance:=Self.FMax*2;
//          end;
//          isdScrollToMax:
//          begin
//              //往左拖
//              OutputDebugString(GetDebugLogID+'平拖前进');
//              InertiaDistance:=Self.FMax*2;
//          end;
//        end;
//    end;
//    pddtMaxToMin:
//    begin
//        case Self.MouseMoveDirection of
//          isdScrollToMin:
//          begin
//              //往右拖
//              OutputDebugString(GetDebugLogID+'平拖前进');
//              InertiaDistance:=Self.FMax*2;
//          end;
//          isdScrollToMax:
//          begin
//              //返回
//              //正在停止
//              OutputDebugString(GetDebugLogID+'平拖返回');
//  //            Self.FIsStopingPanDrag:=True;
//              InertiaDistance:=Self.FMax*2;
//          end;
//        end;
//    end;
//  end;
//
//end;
//
//procedure TSkinControlPanDragGestureManager.DoCustomPositionChange(Sender: TObject);
//begin
//  Inherited;
//
//  if Not Self.FIsDraging then
//  begin
//
//    if (IsSameDouble(Self.Position,Self.Min))
//      or (IsSameDouble(Self.Position,Self.Max)) then
//    begin
//      DoScrollToInitialAnimateEnd(Sender);
//    end;
//
//  end;
//
//end;
//
//procedure TSkinControlPanDragGestureManager.DoCustomFirstMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
//begin
//  Inherited;
//
//  //准备平拖
//  Self.PreparePanDrag;
//end;
//
//procedure TSkinControlPanDragGestureManager.DoScrollToInitialAnimateEnd(Sender: TObject);
//begin
//    Inherited;
//
//    case Self.FPanDragDirection of
//      pddtMinToMax:
//      begin
//            //如果滚动到了初始位置,那么平拖结束
//            if (IsSameDouble(Self.FPosition,Self.FMax)) then
//            begin
//                if Not FIsPanDragHasArrived then
//                begin
//                    OutputDebugString(GetDebugLogID+'平拖结束');
//                    FIsPanDragHasArrived:=True;
//    //                FIsStopingPanDrag:=False;
//
//                    //准备平拖结束
////                    Self.FIsNeedDecideFirstGestureKind:=False;
//                    //返回的时候,左右都能拖动
//                    Self.DecideFirstGestureKindDirections:=[isdScrollToMin,isdScrollToMax];
//
//                    if Assigned(FOnPanDragGo) then
//                    begin
//                      FOnPanDragGo(Self);
//                    end;
//                end;
//
//            end
//            else
//            if (IsSameDouble(Self.FPosition,Self.FMin)) then
//            begin
//                if FIsPanDragHasArrived then
//                begin
//                    //判断是Max,不需要操作
//                    OutputDebugString(GetDebugLogID+'平拖还原');
//                    FIsPanDragHasArrived:=False;
//                    FIsBeginPanDrag:=False;
//
//                    if Assigned(FOnPanDragBack) then
//                    begin
//                      FOnPanDragBack(Self);
//                    end;
//                end;
//            end
//            else
//            begin
//                  //判断是不是Min还是Max,不能在中间
//                  //判断方向
//                  if FIsPanDragHasArrived then
//                  begin
//                        //返回
//                        OutputDebugString(GetDebugLogID+'平拖返回');
//                        Self.StopPanDrag;
//                  end
//                  else
//                  begin
//                        //往左拖
//                        OutputDebugString(GetDebugLogID+'平拖前进');
//                        Self.StartPanDrag;
//                  end;
//            end;
//
//      end;
//      pddtMaxToMin:
//      begin
//            //如果滚动到了初始位置,那么平拖结束
//            if (IsSameDouble(Self.FPosition,Self.FMin)) then
//            begin
//                if not FIsPanDragHasArrived then
//                begin
//                    OutputDebugString(GetDebugLogID+'平拖结束');
//                    FIsPanDragHasArrived:=True;
//    //                FIsStopingPanDrag:=False;
//
//                    //准备平拖结束
////                    Self.FIsNeedDecideFirstGestureKind:=False;
//                    //返回的时候,左右都能拖动
//                    Self.DecideFirstGestureKindDirections:=[isdScrollToMin,isdScrollToMax];
//
//                    if Assigned(FOnPanDragGo) then
//                    begin
//                      FOnPanDragGo(Self);
//                    end;
//                end;
//
//            end
//            else
//            if (IsSameDouble(Self.FPosition,Self.FMax)) then
//            begin
//                if FIsPanDragHasArrived then
//                begin
//                    //判断是Max,不需要操作
//                    OutputDebugString(GetDebugLogID+'平拖还原');
//                    FIsPanDragHasArrived:=False;
//                    FIsBeginPanDrag:=False;
//
//                    if Assigned(FOnPanDragBack) then
//                    begin
//                      FOnPanDragBack(Self);
//                    end;
//                end;
//
//            end
//            else
//            begin
//                  //判断是不是Min还是Max,不能在中间
//                  //判断方向
//                  if FIsPanDragHasArrived then
//                  begin
//                        //返回
//                        OutputDebugString(GetDebugLogID+'平拖返回');
//                        Self.StopPanDrag;
//                  end
//                  else
//                  begin
//                        //往左拖
//                        OutputDebugString(GetDebugLogID+'平拖前进');
//                        Self.StartPanDrag;
//                  end;
//            end;
//      end;
//    end;
//end;




{ TBaseSkinSwitchPageGestureManager }

procedure TBaseSkinSwitchPageGestureManager.DoCustomPositionChange(Sender: TObject);
var
  APos:Double;
begin
  Inherited;

  //pnlA是不动的
//
//  case Self.FKind of
//    gmkHorizontal:
//    begin

        //左边
        if (GetPageIndex-1>=0)
          and (GetPageIndex-1<GetPageCount)
//          and (GetPageList[GetPageIndex-1]<>nil)
          then
        begin
//          TControl(GetPageList[GetPageIndex-1]).Visible:=True;
//          TControl(GetPageList[GetPageIndex-1]).Position.X:=
//                GetBaseControlStartPos-GetCurrentCanPanDragLength(isdScrollToMin)+Self.GetCurrentOffset;

            APos:=GetBaseControlStartPos-GetCurrentCanPanDragLength(isdScrollToMin)+Self.GetCurrentOffset;
            SetPagePos(GetPageIndex-1,FKind,APos);
        end;


        //中间
//        if TControl(GetPageList[GetPageIndex])<>nil then
//        begin
//      //    TControl(GetPageList[GetPageIndex]).Align:=TAlignLayout.None;
//          TControl(GetPageList[GetPageIndex]).Position.X:=
//                GetBaseControlStartPos+Self.GetCurrentOffset;
//        end;


        //不移动中间的页面
        if not ((GetPageIndex=1) and Self.FIsNotMoveMiddleControl) then
        begin
          APos:=GetBaseControlStartPos+Self.GetCurrentOffset;
          if Self.FIsNotCanSeeOutOfBoundArea and (GetPageIndex=0) then
          begin
            //最左边的页面
            APos:=GetBaseControlStartPos-Self.MaxOverRangePosValue;
          end;
          if Self.FIsNotCanSeeOutOfBoundArea and (GetPageIndex=GetPageCount-1) then
          begin
            //最右边的页面
            APos:=GetBaseControlStartPos+Self.MinOverRangePosValue;
          end;
          SetPagePos(GetPageIndex,FKind,APos);
        end;


        //右边
        if (GetPageIndex+1<GetPageCount)
//          and (GetPageList[GetPageIndex+1]<>nil)
          then
        begin
//          TControl(GetPageList[GetPageIndex+1]).Visible:=True;
//          TControl(GetPageList[GetPageIndex+1]).Position.X:=
//                GetBaseControlStartPos+GetCurrentCanPanDragLength(isdScrollToMin)+Self.GetCurrentOffset;
            APos:=GetBaseControlStartPos+GetCurrentCanPanDragLength(isdScrollToMin)+Self.GetCurrentOffset;
            SetPagePos(GetPageIndex+1,FKind,APos);
        end;




//    end;
//    gmkVertical:
//    begin
//        //左边
//        if (GetPageIndex-1>=0)
//          and (GetPageIndex-1<GetPageCount)
//          and (GetPageList[GetPageIndex-1]<>nil) then
//        begin
//          TControl(GetPageList[GetPageIndex-1]).Visible:=True;
//          TControl(GetPageList[GetPageIndex-1]).Position.Y:=
//                GetBaseControlStartPos-GetCurrentCanPanDragLength(isdScrollToMin)+Self.GetCurrentOffset;
//        end;
//
//        //中间
//        if TControl(GetPageList[GetPageIndex])<>nil then
//        begin
//      //    TControl(GetPageList[GetPageIndex]).Align:=TAlignLayout.None;
//          TControl(GetPageList[GetPageIndex]).Position.Y:=
//                GetBaseControlStartPos+Self.GetCurrentOffset;
//        end;
//
//        //右边
//        if (GetPageIndex+1<GetPageCount)
//          and (GetPageList[GetPageIndex+1]<>nil) then
//        begin
//          TControl(GetPageList[GetPageIndex+1]).Visible:=True;
//          TControl(GetPageList[GetPageIndex+1]).Position.Y:=
//                GetBaseControlStartPos+GetCurrentCanPanDragLength(isdScrollToMin)+Self.GetCurrentOffset;
//        end;
//
//
//    end;
//  end;

end;

procedure TBaseSkinSwitchPageGestureManager.DoPanDragSwitchEnd(AGestureDirection: TGestureDirection);
begin
  Inherited;

  case AGestureDirection of
    isdScrollToMin: SetPageIndex(GetPageIndex+1);
    isdScrollToMax: SetPageIndex(GetPageIndex-1);
  end;
end;

function TBaseSkinSwitchPageGestureManager.GetCurrentCanPanDragDirections: TGestureDirections;
begin
  Result:=[];
  if (GetPageIndex>0)
    and (GetPageIndex<GetPageCount-1) then
  begin
      Result:=[isdScrollToMin,isdScrollToMax];
  end
  else if (GetPageIndex=0) then
  begin
      Result:=[isdScrollToMin];
  end
  else if (GetPageIndex=GetPageCount-1) then
  begin
      Result:=[isdScrollToMax];
  end;
end;

function TBaseSkinSwitchPageGestureManager.GetCurrentCanPanDragLength(AGestureDirection: TGestureDirection): Double;
begin
  Result:=0;
//  case Self.FKind of
//    gmkNone: ;
//    gmkHorizontal:
//    begin
//        if Self.GetPageList[GetPageIndex]<>nil then
//        begin
          Result:=GetPageItemSize(GetPageIndex,FKind,AGestureDirection);
//            //TControl(Self.GetPageList[GetPageIndex]).Width;
//        end;
//    end;
//    gmkVertical:
//    begin
//        if Self.GetPageList[GetPageIndex]<>nil then
//        begin
//          Result:=TControl(Self.GetPageList[GetPageIndex]).Height;
//        end;
//
//    end;
//  end;

//  case AGestureDirection of
//    isdScrollToMin:
//    begin
//      //往左移,切换到下一页
//
//
//    end;
//    isdScrollToMax:
//    begin
//      //往右移,切换到上一页
//    end;
//  end;
end;

function TBaseSkinSwitchPageGestureManager.GetBaseControlStartPos: Double;
begin
  Result:=0;
end;

{ TSkinSwitchPageGestureManager }

constructor TSkinSwitchPageGestureManager.Create(AOwner: TComponent);
begin
  FPageIndex:=1;
  FPageList:=TBaseList.Create(ooReference);
  FPageList.Add(nil);
  FPageList.Add(nil);
  FPageList.Add(nil);


  inherited;


end;

destructor TSkinSwitchPageGestureManager.Destroy;
begin
  FreeAndNil(FPageList);
  inherited;
end;

function TSkinSwitchPageGestureManager.GetBaseControlStartPos: Double;
begin
  Result:=FCurrentControlStartPos;
end;

function TSkinSwitchPageGestureManager.GetMiddleControl: TControl;
begin
  Result:=TControl(FPageList[1]);
end;

function TSkinSwitchPageGestureManager.GetNextControl: TControl;
begin
  Result:=TControl(FPageList[2]);
end;

function TSkinSwitchPageGestureManager.GetPageCount: Integer;
begin
  Result:=Self.FPageList.Count;
end;

function TSkinSwitchPageGestureManager.GetPageIndex: Integer;
begin
  Result:=FPageIndex;
end;

function TSkinSwitchPageGestureManager.GetPageItemSize(APageIndex: Integer;
  AGestureKind: TGestureKind; AGestureDirection: TGestureDirection): Double;
begin
  Result:=0;
  case Self.FKind of
    gmkNone: ;
    gmkHorizontal:
    begin
        if Self.GetPageList[GetPageIndex]<>nil then
        begin
          Result:=TControl(Self.GetPageList[GetPageIndex]).Width;
        end;
    end;
    gmkVertical:
    begin
        if Self.GetPageList[GetPageIndex]<>nil then
        begin
          Result:=TControl(Self.GetPageList[GetPageIndex]).Height;
        end;

    end;
  end;
end;

function TSkinSwitchPageGestureManager.GetPageList: TBaseList;
begin
  Result:=FPageList;
end;

function TSkinSwitchPageGestureManager.GetPriorControl: TControl;
begin
  Result:=TControl(FPageList[0]);
end;

procedure TSkinSwitchPageGestureManager.Notification(AComponent: TComponent;Operation: TOperation);
begin
  inherited;

  if (Operation=opRemove) then
  begin
    if (AComponent=Self.MiddleControl) then
    begin
      SetMiddleControl(nil);
    end;
    if (AComponent=Self.PriorControl) then
    begin
      SetPriorControl(nil);
    end;
    if (AComponent=Self.NextControl) then
    begin
      SetNextControl(nil);
    end;
  end;

end;

procedure TSkinSwitchPageGestureManager.SetMiddleControl(const Value: TControl);
begin
  if FPageList[1]<>Value then
  begin
    if FPageList[1]<>nil then
    begin
      //先清除原来的
      uComponentType.RemoveFreeNotification(TComponent(FPageList[1]),Self);
    end;

    FPageList[1]:=Value;
    SyncCurrentControlStartPos;

    if FPageList[1]<>nil then
    begin
      //先清除原来的
      uComponentType.AddFreeNotification(TComponent(FPageList[1]),Self);
    end;

  end;
end;

procedure TSkinSwitchPageGestureManager.SetNextControl(const Value: TControl);
begin
  if FPageList[2]<>Value then
  begin
    if FPageList[2]<>nil then
    begin
      //先清除原来的
      uComponentType.RemoveFreeNotification(TComponent(FPageList[2]),Self);
    end;

    FPageList[2]:=Value;

    if FPageList[2]<>nil then
    begin
      //先清除原来的
      uComponentType.AddFreeNotification(TComponent(FPageList[2]),Self);
    end;

  end;
end;

procedure TSkinSwitchPageGestureManager.SetPageIndex(APageIndex: Integer);
begin
  FPageIndex:=APageIndex;
end;

procedure TSkinSwitchPageGestureManager.SetPagePos(APageIndex: Integer;
  AGestureKind: TGestureKind; APos: Double);
begin

  if (APageIndex>=0)
    and (APageIndex<Self.GetPageCount)
    and (FPageList[APageIndex]<>nil) then
  begin
    case AGestureKind of
      gmkHorizontal:
      begin
        SetControlLeft(TControl(FPageList[APageIndex]),ControlSize(APos));
      end;
      gmkVertical:
      begin
        SetControlTop(TControl(FPageList[APageIndex]),ControlSize(APos));
      end;
    end;
  end;

end;

procedure TSkinSwitchPageGestureManager.SetPriorControl(const Value: TControl);
begin
  if FPageList[0]<>Value then
  begin
    if FPageList[0]<>nil then
    begin
      //先清除原来的
      uComponentType.RemoveFreeNotification(TComponent(FPageList[0]),Self);
    end;

    FPageList[0]:=Value;

    if FPageList[0]<>nil then
    begin
      //先清除原来的
      uComponentType.AddFreeNotification(TComponent(FPageList[0]),Self);
    end;

  end;
end;

procedure TSkinSwitchPageGestureManager.SyncCurrentControlStartPos;
begin
  FCurrentControlStartPos:=0;
  if FPageList[1]<>nil then
  begin
  case Self.FKind of
    gmkNone: ;
    gmkHorizontal:
    begin
      FCurrentControlStartPos:=GetControlLeft(TControl(FPageList[1]));
    end;
    gmkVertical:
    begin
      FCurrentControlStartPos:=GetControlTop(TControl(FPageList[1]));
    end;
  end;

  end;
end;

end.

