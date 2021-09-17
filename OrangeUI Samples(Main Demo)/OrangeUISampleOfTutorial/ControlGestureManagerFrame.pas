//convert pas to utf8 by ¥

unit ControlGestureManagerFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uBaseLog,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinControlGestureManager,
  uSkinControlPanDragGestureManager, FMX.Controls.Presentation,
  uBaseSkinControl, uSkinPanelType;

type
  TFrameControlGestureManager = class(TFrame)
    pnlVert: TSkinFMXPanel;
    VertControlGestureManager: TSkinControlGestureManager;
    pnlNeedCheckVert: TSkinFMXPanel;
    HorzControlGestureManager: TSkinControlGestureManager;
    pnlHorz: TSkinFMXPanel;
    pnlNeedCheckHorz: TSkinFMXPanel;
    pnlLeftToRightPanDrag: TSkinFMXPanel;
    pnlLeftPanel: TSkinFMXPanel;
    pnlRightPanel: TSkinFMXPanel;
    pnlRightToLeftPanDrag: TSkinFMXPanel;
    RightToLeftPanDragGestureManager1: TSkinControlPanDragGestureManager;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    pnlVertPosition: TSkinFMXPanel;
    pnlHorzPosition: TSkinFMXPanel;
    Button5: TButton;
    LeftToRightPanDragGestureManager1: TSkinControlPanDragGestureManager;
    procedure pnlVertMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure pnlVertMouseLeave(Sender: TObject);
    procedure pnlVertMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure pnlVertMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure pnlVertMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure pnlVertMouseEnter(Sender: TObject);
    procedure pnlHorzMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure pnlHorzMouseLeave(Sender: TObject);
    procedure pnlHorzMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure pnlHorzMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure pnlHorzMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure pnlHorzMouseEnter(Sender: TObject);
    procedure VertControlGestureManagerPositionChange(Sender: TObject);
    procedure VertControlGestureManagerStartDrag(Sender: TObject);
    procedure VertControlGestureManagerStopDrag(Sender: TObject);
    procedure VertControlGestureManagerScrollToInitialAnimateBegin(
      Sender: TObject);
    procedure VertControlGestureManagerScrollToInitialAnimateEnd(
      Sender: TObject);
    procedure VertControlGestureManagerInertiaScrollAnimateBegin(
      Sender: TObject);
    procedure VertControlGestureManagerInertiaScrollAnimateEnd(Sender: TObject;
      var CanStartScrollToInitial: Boolean);
    procedure VertControlGestureManagerCalcInertiaScrollDistance(
      Sender: TObject; var InertiaDistance: Double;
      var CanInertiaScroll: Boolean);
    procedure VertControlGestureManagerPrepareDecidedFirstGestureKind(
      Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
      var AIsDecidedFirstGestureKind: Boolean;
      var ADecidedFirstGestureKind:TGestureKind);
    procedure HorzControlGestureManagerPositionChange(Sender: TObject);
    procedure HorzControlGestureManagerStartDrag(Sender: TObject);
    procedure HorzControlGestureManagerStopDrag(Sender: TObject);
    procedure HorzControlGestureManagerScrollToInitialAnimateBegin(
      Sender: TObject);
    procedure HorzControlGestureManagerScrollToInitialAnimateEnd(
      Sender: TObject);
    procedure HorzControlGestureManagerInertiaScrollAnimateBegin(
      Sender: TObject);
    procedure HorzControlGestureManagerInertiaScrollAnimateEnd(Sender: TObject;
      var CanStartScrollToInitial: Boolean);
    procedure HorzControlGestureManagerCalcInertiaScrollDistance(
      Sender: TObject; var InertiaDistance: Double;
      var CanInertiaScroll: Boolean);
    procedure HorzControlGestureManagerPrepareDecidedFirstGestureKind(
      Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
      var AIsDecidedFirstGestureKind: Boolean;
      var ADecidedFirstGestureKind:TGestureKind);
    procedure pnlLeftToRightPanDragMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure pnlLeftToRightPanDragMouseEnter(Sender: TObject);
    procedure pnlLeftToRightPanDragMouseLeave(Sender: TObject);
    procedure pnlLeftToRightPanDragMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure pnlLeftToRightPanDragMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure pnlLeftToRightPanDragMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure LeftToRightPanDragGestureManager1PositionChange(Sender: TObject);
    procedure RightToLeftPanDragGestureManager1PositionChange(Sender: TObject);
    procedure pnlRightToLeftPanDragMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure pnlRightToLeftPanDragMouseEnter(Sender: TObject);
    procedure pnlRightToLeftPanDragMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure pnlRightToLeftPanDragMouseWheel(Sender: TObject;
      Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
    procedure pnlRightToLeftPanDragMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Single);
    procedure pnlRightToLeftPanDragMouseLeave(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure LeftToRightPanDragGestureManager1PanDragGo(Sender: TObject);
    procedure LeftToRightPanDragGestureManager1PanDragBack(Sender: TObject);
    procedure pnlLeftPanelClick(Sender: TObject);
    procedure pnlRightPanelClick(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;

    { Public declarations }
  end;

//var
//  GlobalControlGestureManagerFrame:TFrameControlGestureManager;

implementation

{$R *.fmx}



procedure TFrameControlGestureManager.Button1Click(Sender: TObject);
begin
//  LeftToRightPanDragGestureManager1.StartPanDrag;
end;

procedure TFrameControlGestureManager.Button2Click(Sender: TObject);
begin
//  LeftToRightPanDragGestureManager1.StopPanDrag;
end;

procedure TFrameControlGestureManager.Button3Click(Sender: TObject);
begin
//  RightToLeftPanDragGestureManager1.StartPanDrag;
end;

procedure TFrameControlGestureManager.Button4Click(Sender: TObject);
begin
//  RightToLeftPanDragGestureManager1.StopPanDrag;
end;

constructor TFrameControlGestureManager.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TFrameControlGestureManager.VertControlGestureManagerCalcInertiaScrollDistance(
  Sender: TObject; var InertiaDistance: Double; var CanInertiaScroll: Boolean);
begin
  uBaseLog.OutputDebugString('计算惯性滚动距离');
end;

procedure TFrameControlGestureManager.VertControlGestureManagerInertiaScrollAnimateBegin(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('开始惯性滚动');
end;

procedure TFrameControlGestureManager.VertControlGestureManagerInertiaScrollAnimateEnd(
  Sender: TObject; var CanStartScrollToInitial: Boolean);
begin
  uBaseLog.OutputDebugString('结束惯性滚动');
end;

procedure TFrameControlGestureManager.VertControlGestureManagerPositionChange(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('位置更改'+FloatToStr(Self.VertControlGestureManager.Position));
  pnlVertPosition.Top:=Self.VertControlGestureManager.Position;
end;

procedure TFrameControlGestureManager.VertControlGestureManagerPrepareDecidedFirstGestureKind(
  Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
  var AIsDecidedFirstGestureKind: Boolean;
  var ADecidedFirstGestureKind:TGestureKind);
begin
  if PtInRect(
              RectF(pnlNeedCheckVert.Left,pnlNeedCheckVert.Top,pnlNeedCheckVert.Left+pnlNeedCheckVert.Width,pnlNeedCheckVert.Top+pnlNeedCheckVert.Height),
              PointF(AMouseMoveX,AMouseMoveY)
              ) then
  begin
    //在检测区域内

  end
  else
  begin
    //不在检测区域内
    //直接判断结束，也就是不判断
    AIsDecidedFirstGestureKind:=True;
    ADecidedFirstGestureKind:=VertControlGestureManager.Kind;
  end;
end;

procedure TFrameControlGestureManager.VertControlGestureManagerScrollToInitialAnimateBegin(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('开始滚动到初始');
end;

procedure TFrameControlGestureManager.VertControlGestureManagerScrollToInitialAnimateEnd(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('停止滚动到初始');

end;

procedure TFrameControlGestureManager.VertControlGestureManagerStartDrag(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('开始拖动');
end;

procedure TFrameControlGestureManager.VertControlGestureManagerStopDrag(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('停止拖动');
end;

procedure TFrameControlGestureManager.pnlVertMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  VertControlGestureManager.MouseDown(Button,Shift,X,Y);
end;

procedure TFrameControlGestureManager.pnlVertMouseEnter(Sender: TObject);
begin
  VertControlGestureManager.MouseEnter;
end;

procedure TFrameControlGestureManager.pnlVertMouseLeave(Sender: TObject);
begin
  VertControlGestureManager.MouseLeave;
end;

procedure TFrameControlGestureManager.pnlVertMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
  VertControlGestureManager.MouseMove(Shift,X,Y);
end;

procedure TFrameControlGestureManager.pnlVertMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  VertControlGestureManager.MouseUp(Button,Shift,X,Y);
end;

procedure TFrameControlGestureManager.pnlVertMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  VertControlGestureManager.MouseWheel(Shift,WheelDelta,0,0);
end;





procedure TFrameControlGestureManager.RightToLeftPanDragGestureManager1PositionChange(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('位置更改'+FloatToStr(Self.RightToLeftPanDragGestureManager1.Position));
  Self.pnlRightPanel.Left:=
    pnlRightToLeftPanDrag.Left+Self.pnlRightToLeftPanDrag.Width
    -RightToLeftPanDragGestureManager1.Position;

end;

procedure TFrameControlGestureManager.LeftToRightPanDragGestureManager1PanDragBack(
  Sender: TObject);
begin
//  uBaseLog.OutputDebugString('位置更改'+FloatToStr(Self.LeftToRightPanDragGestureManager1.Position));
//  Self.pnlLeftPanel.Left:=
//    LeftToRightPanDragGestureManager1.Max
//    -LeftToRightPanDragGestureManager1.Position;

end;

procedure TFrameControlGestureManager.LeftToRightPanDragGestureManager1PanDragGo(
  Sender: TObject);
begin
//  uBaseLog.OutputDebugString('位置更改'+FloatToStr(Self.LeftToRightPanDragGestureManager1.Position));
//  Self.pnlLeftPanel.Left:=
//    LeftToRightPanDragGestureManager1.Max
//    -LeftToRightPanDragGestureManager1.Position;

end;

procedure TFrameControlGestureManager.LeftToRightPanDragGestureManager1PositionChange(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('位置更改'+FloatToStr(Self.LeftToRightPanDragGestureManager1.Position));
  Self.pnlLeftPanel.Left:=
    LeftToRightPanDragGestureManager1.Max
    -LeftToRightPanDragGestureManager1.Position;
end;

procedure TFrameControlGestureManager.pnlLeftPanelClick(Sender: TObject);
begin
//  LeftToRightPanDragGestureManager1.StopPanDrag;

end;

procedure TFrameControlGestureManager.pnlLeftToRightPanDragMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  LeftToRightPanDragGestureManager1.MouseDown(Button,Shift,X,Y);
end;

procedure TFrameControlGestureManager.pnlLeftToRightPanDragMouseEnter(Sender: TObject);
begin
  LeftToRightPanDragGestureManager1.MouseEnter;

end;

procedure TFrameControlGestureManager.pnlLeftToRightPanDragMouseLeave(Sender: TObject);
begin
  LeftToRightPanDragGestureManager1.MouseLeave;

end;

procedure TFrameControlGestureManager.pnlLeftToRightPanDragMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
  LeftToRightPanDragGestureManager1.MouseMove(Shift,X,Y);

end;

procedure TFrameControlGestureManager.pnlLeftToRightPanDragMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  LeftToRightPanDragGestureManager1.MouseUp(Button,Shift,X,Y);

end;

procedure TFrameControlGestureManager.pnlLeftToRightPanDragMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  LeftToRightPanDragGestureManager1.MouseWheel(Shift,WheelDelta,0,0);

end;

procedure TFrameControlGestureManager.pnlRightPanelClick(Sender: TObject);
begin
//  RightToLeftPanDragGestureManager1.StopPanDrag;

end;

procedure TFrameControlGestureManager.pnlRightToLeftPanDragMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  RightToLeftPanDragGestureManager1.MouseDown(Button,Shift,X,Y);
end;

procedure TFrameControlGestureManager.pnlRightToLeftPanDragMouseEnter(
  Sender: TObject);
begin
  RightToLeftPanDragGestureManager1.MouseEnter;

end;

procedure TFrameControlGestureManager.pnlRightToLeftPanDragMouseLeave(
  Sender: TObject);
begin
  RightToLeftPanDragGestureManager1.MouseLeave;

end;

procedure TFrameControlGestureManager.pnlRightToLeftPanDragMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  RightToLeftPanDragGestureManager1.MouseMove(Shift,X,Y);

end;

procedure TFrameControlGestureManager.pnlRightToLeftPanDragMouseUp(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  RightToLeftPanDragGestureManager1.MouseUp(Button,Shift,X,Y);

end;

procedure TFrameControlGestureManager.pnlRightToLeftPanDragMouseWheel(
  Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
  var Handled: Boolean);
begin
  RightToLeftPanDragGestureManager1.MouseWheel(Shift,WheelDelta,0,0);

end;

procedure TFrameControlGestureManager.HorzControlGestureManagerCalcInertiaScrollDistance(
  Sender: TObject; var InertiaDistance: Double; var CanInertiaScroll: Boolean);
begin
  uBaseLog.OutputDebugString('计算惯性滚动距离');
end;

procedure TFrameControlGestureManager.HorzControlGestureManagerInertiaScrollAnimateBegin(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('开始惯性滚动');
end;

procedure TFrameControlGestureManager.HorzControlGestureManagerInertiaScrollAnimateEnd(
  Sender: TObject; var CanStartScrollToInitial: Boolean);
begin
  uBaseLog.OutputDebugString('结束惯性滚动');
end;

procedure TFrameControlGestureManager.HorzControlGestureManagerPositionChange(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('位置更改'+FloatToStr(Self.HorzControlGestureManager.Position));
  pnlHorzPosition.Left:=HorzControlGestureManager.Position;
end;

procedure TFrameControlGestureManager.HorzControlGestureManagerPrepareDecidedFirstGestureKind(
  Sender: TObject; AMouseMoveX, AMouseMoveY: Double;
  var AIsDecidedFirstGestureKind: Boolean;
  var ADecidedFirstGestureKind:TGestureKind);
begin
  if PtInRect(
              RectF(pnlNeedCheckHorz.Left,pnlNeedCheckHorz.Top,pnlNeedCheckHorz.Left+pnlNeedCheckHorz.Width,pnlNeedCheckHorz.Top+pnlNeedCheckHorz.Height),
              PointF(AMouseMoveX,AMouseMoveY)
              ) then
  begin
    //在检测区域内

  end
  else
  begin
    //不在检测区域内
    //直接判断结束，也就是不判断
    AIsDecidedFirstGestureKind:=True;
    ADecidedFirstGestureKind:=HorzControlGestureManager.Kind;
  end;
end;

procedure TFrameControlGestureManager.HorzControlGestureManagerScrollToInitialAnimateBegin(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('开始滚动到初始');
end;

procedure TFrameControlGestureManager.HorzControlGestureManagerScrollToInitialAnimateEnd(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('停止滚动到初始');

end;

procedure TFrameControlGestureManager.HorzControlGestureManagerStartDrag(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('开始拖动');
end;

procedure TFrameControlGestureManager.HorzControlGestureManagerStopDrag(
  Sender: TObject);
begin
  uBaseLog.OutputDebugString('停止拖动');
end;

procedure TFrameControlGestureManager.pnlHorzMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  HorzControlGestureManager.MouseDown(Button,Shift,X,Y);
end;

procedure TFrameControlGestureManager.pnlHorzMouseEnter(Sender: TObject);
begin
  HorzControlGestureManager.MouseEnter;
end;

procedure TFrameControlGestureManager.pnlHorzMouseLeave(Sender: TObject);
begin
  HorzControlGestureManager.MouseLeave;
end;

procedure TFrameControlGestureManager.pnlHorzMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
  HorzControlGestureManager.MouseMove(Shift,X,Y);
end;

procedure TFrameControlGestureManager.pnlHorzMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  HorzControlGestureManager.MouseUp(Button,Shift,X,Y);
end;

procedure TFrameControlGestureManager.pnlHorzMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  HorzControlGestureManager.MouseWheel(Shift,WheelDelta,0,0);
end;

end.
