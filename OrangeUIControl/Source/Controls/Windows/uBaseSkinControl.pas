//皮肤控件基类//
unit uBaseSkinControl;


interface
{$I FrameWork.inc}

{$I OUIBaseWINControl.inc}


uses
  SysUtils,
  uFuncCommon,
  Classes,
  uBaseLog,

  {$IF CompilerVersion >= 30.0}
  UITypes,
  {$IFEND}

  Math,
  Types,

//  FMX.Forms,
//  FMX.Types,
//  FMX.Controls,
//  FMX.Graphics,
//  FMX.StdCtrls,


  uDrawRectParam,
  uSkinPublic,
  uBaseList,
  uSkinMaterial,
  uVersion,
  uBinaryTreeDoc,
  uComponentType,
  uDrawEngine,
  uGraphicCommon,
  uSkinWindowsControl,
  uDrawCanvas,
  uDrawPicture,
//  uSkinPackage,
  uSkinRegManager,
  uSkinBufferBitmap;





Type
//  TBaseFMXControl=class(TControl,
//                        ISkinControl,
//                        IDirectUIControl,
//                        IControlForPageFramework
//                        )
//  private
//
//    //GetLeft,GetWidth,GetEnabled
//    {$I Source\Controls\INC\Common\ISkinControl_Declare.inc}
//    //Caption,Text
//    {$I Source\Controls\INC\FMX\ISkinControl_Caption_Impl_Declare_FMX.inc}
//    //MouseDown,MouseMove,MouseUp
//    {$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Mouse_Declare_FMX.inc}
//    //Resize,Loaded,SetBounds
//    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Declare.inc}
//    //DirectUI
//    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_DirectUI_Declare.inc}
//    //GetSelfOwnMaterial
//    {$I Source\Controls\INC\Common\ISkinComponent_BaseSkinControl_Skin_Impl_Field_Declare.inc}
//    //SelfOwnMaterial
//    {$I Source\Controls\INC\Common\ISkinComponent_BaseSkinControl_Skin_Impl_Property_Declare.inc}
//    //GetPropertiesClassType
//    {$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Declare.inc}
//    //CustomMouseDown,IsMouseDown,Click
//    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Declare.inc}
//  protected
//    function GetDrawBackColorParam: TDrawRectParam;
//    procedure SetDrawBackColorParam(const Value: TDrawRectParam);
//
//
//    //控件绘制
//    procedure Paint;overload;override;
//    //FMX手势操作
//    procedure CMGesture(var EventInfo: TGestureEventInfo); override;
//  public
//    //针对页面框架的控件接口
//    function LoadFromFieldControlSetting(ASetting:TBaseFieldControlSetting):Boolean;virtual;
//  public
//    constructor Create(AOwner:TComponent);override;
//    destructor Destroy;override;
//  public
//    //把这两个开放出来
//    function ScreenToLocal(P: TPointF): TPointF; override;
//    function LocalToScreen(P: TPointF): TPointF; override;
//  public
//    //刷新控件
//    procedure Invalidate;
//
//  published
//    //背景颜色
//    property DrawBackColorParam:TDrawRectParam read GetDrawBackColorParam write SetDrawBackColorParam;
//
//  published
////    property StaysPressed default False;
//    property Action;
//    property Align default TAlignLayout.alNone;
//    property Anchors;
////    property AutoTranslate default True;
////    property Cancel: Boolean read FCancel write FCancel default False;
//    property CanFocus;// default True;
//    property CanParentFocus;
//    property ClipChildren;// default False;
//    property ClipParent;// default False;
//    property Cursor default crDefault;
////    property Default: Boolean read FDefault write FDefault default False;
////    property DesignVisible default True;
////    property DisableFocusEffect;
//    property DragMode default TDragMode.dmManual;
////    property EnableDragHighlight default True;
//    property Enabled default True;
////    property Font;
////    property StyledSettings;
//    property Height;
////    property HelpContext;
////    property HelpKeyword;
////    property HelpType;
//    property HitTest default True;
////    property IsPressed default False;
//    property Locked default False;
//    property Padding;
////    property ModalResult default mrNone;
//    property Opacity;
//    property Margins;
//    property PopupMenu;
//    property Position;
//    property Scale;
//    property Size;
////    {$ENDIF}
////    property RepeatClick default False;
//    property RotationAngle;
//    property RotationCenter;
////    property Scale;
////    property StyleLookup;
//    property TabOrder;
////    property Text;
////    property Trimming;
////    property TextAlign default TTextAlign.taCenter;
//    property TouchTargetExpansion;
//    property Visible default True;
//    property Width;
////    pro
////    property WordWrap default False;
////    property OnApplyStyleLookup;
////    property OnGestureLongTap:TOnGestureLongTap read FOnGestureLongTap write FOnGestureLongTap;
//
//    property OnDragEnter;
//    property OnDragLeave;
//    property OnDragOver;
//    property OnDragDrop;
//    property OnDragEnd;
//    property OnKeyDown;
//    property OnKeyUp;
//    property OnCanFocus;
//    property OnClick;
//    property OnDblClick;
//    property OnEnter;
//    property OnExit;
//    property OnMouseDown;
//    property OnMouseMove;
//    property OnMouseUp;
//    property OnMouseWheel;
//    property OnMouseEnter;
//    property OnMouseLeave;
////    property OnPainting;
////    property OnPaint;
//    property OnResize;
//  end;
//
//
//  TBaseNewSkinControl=TBaseFMXControl;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TBaseSkinControl=TSkinWindowsControl;





implementation




//{ TBaseFMXControl }
//
////SetCaption,GetCaption
//{$I Source\Controls\INC\FMX\ISkinControl_Caption_Impl_Code_FMX.inc}
////CreateSelfOwnMaterial,GetSelfOwnMaterial
//{$I Source\Controls\INC\Common\ISkinComponent_BaseSkinControl_Skin_Impl_Field_Code.inc}
////GetPropertiesClassType
//{$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Code.inc}
////GetProperties,SetProperties
//{$I Source\Controls\INC\Common\ISkinComponent_Control_Properties_Impl_Code.inc}
////GetLeft,
//{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Code_FMX.inc}
////MouseDown,MouseUp,MouseMove
//{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Mouse_Code_FMX.inc}
////Notification,Loaded,Resize,SetBounds
//{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Code.inc}
////GetNeedHitTest
//{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_DirectUI_Code.inc}
////CustomMouseDown,CustomMouseUp
//{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Code.inc}
//
//
//
//procedure TBaseFMXControl.CMGesture(var EventInfo: TGestureEventInfo);
//var
//  Handled:Boolean;
//begin
//  Handled:=False;
//  if GetSkinControlType<>nil then
//  begin
//    GetSkinControlType.Gesture(EventInfo,Handled);
//  end;
//
//  if Not Handled then
//  begin
//    inherited;
//  end;
//
//end;
//
//function TBaseFMXControl.LoadFromFieldControlSetting(ASetting:TBaseFieldControlSetting):Boolean;
//begin
//  Result:=True;
//end;
//
//constructor TBaseFMXControl.Create(AOwner: TComponent);
//begin
//  inherited Create(AOwner);
//
//  //执行Action
//  EnableExecuteAction:=True;
//
//
//  {$I Source\Controls\INC\Common\ISkinComponent_BaseSkinControl_Skin_Impl_Create_Code.inc}
//
//
//
//
//  //创建控件属性
//  FProperties:=Self.GetPropertiesClassType.Create(Self);
//
//
//  //父控件启用DirectUI模式下是否显示
////  Self.FDirectUIVisible:=False;
//
//
//  //鼠标是否停靠
//  FIsMouseOver:=False;
//
//
//  //是否穿透鼠标消息
//  FParentMouseEvent:=False;
//  FMouseEventTransToParentType:=mettptAuto;
//
//end;
//
//destructor TBaseFMXControl.Destroy;
//begin
//
//  {$I Source\Controls\INC\Common\ISkinComponent_BaseSkinControl_Skin_Impl_Destroy_Code.inc}
//
//  SysUtils.FreeAndNil(FProperties);
//
//  SysUtils.FreeAndNil(FCanvas);
//
//  inherited;
//
//end;
//
//function TBaseFMXControl.GetDrawBackColorParam: TDrawRectParam;
//begin
//  Result:=Self.FMaterial.BackColor;
//end;
//
//function TBaseFMXControl.ScreenToLocal(P: TPointF): TPointF;
//begin
//  Result:=Inherited ScreenToLocal(P);
//end;
//
//procedure TBaseFMXControl.SetDrawBackColorParam(const Value: TDrawRectParam);
//begin
//  Self.FMaterial.DrawBackColorParam.Assign(Value);
//end;
//
//function TBaseFMXControl.LocalToScreen(P: TPointF): TPointF;
//begin
//  Result:=Inherited LocalToScreen(P);
//end;
//
//procedure TBaseFMXControl.Paint;
//begin
//
//  FCanvas.Prepare(Canvas);
//
//
//
//  //绘制
//  if GetSkinControlType<>nil then
//  begin
//    FPaintData:=GlobalNullPaintData;
//    FPaintData.IsDrawInteractiveState:=True;
//    FPaintData.IsInDrawDirectUI:=False;
//    GetSkinControlType.Paint(FCanvas,RectF(0,0,Self.Width,Self.Height),FPaintData);
//  end;
//
//
//
//
//  //设计时绘制虚线框和控件名称
//  if (csDesigning in Self.ComponentState) then
//  begin
//    FCanvas.DrawDesigningRect(RectF(0,0,Width,Height),GlobalNormalDesignRectBorderColor);
//
//    FCanvas.DrawDesigningText(RectF(0,0,Width,Height),Self.Name);
//  end;
//
//  FCanvas.UnPrepare;
//
//end;
//
//procedure TBaseFMXControl.Invalidate;
//begin
//  RePaint;
//end;




end.




