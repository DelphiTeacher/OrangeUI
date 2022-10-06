//---------------------------------------------------------------------------

// This software is Copyright (c) 2015 Embarcadero Technologies, Inc.
// You may only use this software if you are an authorized licensee
// of an Embarcadero developer tools product.
// This software is considered a Redistributable as defined under
// the software license agreement that comes with the Embarcadero Products
// and is subject to that software license agreement.

//---------------------------------------------------------------------------

unit ImageZoomU;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Graphics,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Objects,
  FMX.Gestures, FMX.Controls.Presentation, FMX.Layouts;

type
  TPinchZoom = class(TForm)
    ToolBar1: TToolBar;
    Label1: TLabel;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Button2: TButton;
    Button1: TButton;
    procedure FormGesture(Sender: TObject; const EventInfo: TGestureEventInfo;
      var Handled: Boolean);
    procedure FormTouch(Sender: TObject; const Touches: TTouches;
      const Action: TTouchAction);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Image1Paint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLastDistance: Integer;
  PinchZoom: TPinchZoom;
var
  gFormTouch1:TPointF;
  gFormTouch2:TPointF;

  gImageControlTouch1:TPointF;
  gImageControlTouch2:TPointF;
  gImageControlTouchCenter:TPointF;

  //中心点占图片宽度的百分比
  gImageControlTouchCenterWidthRate:Double;
  //中心点占图片高度的百分比
  gImageControlTouchCenterHeightRate:Double;


implementation

{$R *.fmx}

uses
  System.Math;

procedure TPinchZoom.Button1Click(Sender: TObject);
var
  Handled:Boolean;
  EventInfo: TGestureEventInfo;
begin

  //模拟放大80个像素
  EventInfo.GestureID := igiZoom;
  EventInfo.Distance:=20;
  EventInfo.Flags:=[];
  EventInfo.Location:=gFormTouch1;
  FormGesture(Self,EventInfo,Handled);

  //模拟结束缩放
  EventInfo.GestureID := igiZoom;
  EventInfo.Distance:=0;
  EventInfo.Flags:=[TInteractiveGestureFlag.gfEnd];
  EventInfo.Location:=gFormTouch1;
  FormGesture(Self,EventInfo,Handled);

end;

procedure TPinchZoom.Button2Click(Sender: TObject);
var
  Handled:Boolean;
  EventInfo: TGestureEventInfo;
begin
  //模拟两根手指的位置
  //它们的中心点需要对准美女头上那朵花
  gFormTouch1.X:=Self.Image1.Position.X+120-30;
  gFormTouch1.Y:=Self.ToolBar1.Height+Self.Image1.Position.Y+45;

  gFormTouch2.X:=Self.Image1.Position.X+120+30;
  gFormTouch2.Y:=Self.ToolBar1.Height+Self.Image1.Position.Y+45;


  //模拟手势缩放开始
  EventInfo.GestureID := igiZoom;
  EventInfo.Distance:=0;
  EventInfo.Flags:=[TInteractiveGestureFlag.gfBegin];
  EventInfo.Location:=gFormTouch1;
  Self.FormGesture(Self,EventInfo,Handled);


  Self.Invalidate;

end;

procedure TPinchZoom.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  LObj: IControl;
  LImage: TImage;
  LImageCenter: TPointF;
begin
  if EventInfo.GestureID = igiZoom then
  begin
    //获取当前手指所在的控件
    LObj := Self.ObjectAtPoint(ClientToScreen(EventInfo.Location));
    //如果控件是图片控件
    if LObj is TImage then
    begin
      { zoom the image }
      LImage := TImage(LObj.GetObject);
//      LImage:=Image1;

      //在手势缩放开始的时候,记录下缩放中心点
      if (TInteractiveGestureFlag.gfBegin in EventInfo.Flags) then
      begin
        //转换为图片控件内部的坐标
        gImageControlTouch1:=LImage.AbsoluteToLocal(gFormTouch1);
        gImageControlTouch2:=LImage.AbsoluteToLocal(gFormTouch2);

        //计算出缩放中心点
        gImageControlTouchCenter.X:=gImageControlTouch1.X+(gImageControlTouch2.X-gImageControlTouch1.X)/2;
        gImageControlTouchCenter.Y:=gImageControlTouch1.Y+(gImageControlTouch2.Y-gImageControlTouch1.Y)/2;

        //中心点所占的比例
        gImageControlTouchCenterWidthRate:=gImageControlTouchCenter.X/LImage.Width;
        gImageControlTouchCenterHeightRate:=gImageControlTouchCenter.Y/LImage.Height;

      end;


      //并且当前的手势是正在缩放中的，不是缩放开始也不是绽放结束
      if (not(TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and
        (not(TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
      begin

        //将图片控件的尺寸缩放，也就宽度和高度都加上手势的距离
        LImage.Width := Max(LImage.Width + (EventInfo.Distance - FLastDistance), 10);
        LImage.Height := Max(LImage.Height + (EventInfo.Distance - FLastDistance), 10);


        //再设置图片控件的位置,让缩放中心点的物体不偏移
        LImage.Position.X := LImage.Position.X
                            - (EventInfo.Distance - FLastDistance)*gImageControlTouchCenterWidthRate;
        LImage.Position.Y := LImage.Position.Y
                            - (EventInfo.Distance - FLastDistance)*gImageControlTouchCenterHeightRate;


      end;



      FLastDistance := EventInfo.Distance;
    end;
  end;
end;

procedure TPinchZoom.FormTouch(Sender: TObject; const Touches: TTouches;
  const Action: TTouchAction);
begin

  //可能是放大缩小的手势
  if (Length(Touches)=2) then
  begin
    gFormTouch1:=Touches[0].Location;
    gFormTouch2:=Touches[1].Location;
  end;

end;

procedure TPinchZoom.Image1Paint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
var
  AImageCenterRect:TRectF;
begin
  //画出图片控件的边框
  Canvas.Stroke.Color:=TAlphaColorRec.Red;
  Canvas.Stroke.Kind:=TBrushKind.Solid;
  Canvas.DrawRect(ARect,0,0,[],1);

  //画出缩放中心点
  AImageCenterRect.Left:=gImageControlTouchCenterWidthRate*ARect.Width-2;
  AImageCenterRect.Top:=gImageControlTouchCenterHeightRate*ARect.Height-2;
  AImageCenterRect.Right:=gImageControlTouchCenterWidthRate*ARect.Width+2;
  AImageCenterRect.Bottom:=gImageControlTouchCenterHeightRate*ARect.Height+2;
  Canvas.DrawRect(AImageCenterRect,0,0,[],1);

end;

end.
