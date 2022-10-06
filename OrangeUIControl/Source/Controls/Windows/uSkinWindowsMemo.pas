//皮肤文本框//
unit uSkinWindowsMemo;

interface
{$I FrameWork.inc}

{$I Source\Controls\Windows\WinMemo.inc}

uses
  Windows,
  Classes,
  Controls,
  SysUtils,
  Messages,
  StdCtrls,
  Forms,
  ExtCtrls,
  Graphics,
  uSkinPublic,
  uGraphicCommon,
  uBaseLog,
  uBaseList,
  uVersion,

  {$IF CompilerVersion>=30.0}
  Types,//定义了TRectF
  {$ENDIF}


  uFuncCommon,
//  uCopyRight,
  uBinaryTreeDoc,
//  uSkinPackage,
  uSkinRegManager,
  uSkinBufferBitmap,
  uDrawCanvas,
  uSkinMaterial,
  uComponentType,
  uBasePageStructure,
  uSkinMemoType,
  uDrawEngine,
  uDrawPicture,
  uDrawTextParam,
  uDrawPictureParam;


type
  //皮肤文本框TSkinMemo
  TSkinWinMemo=class(TCustomMemo,
      ISkinMemo,
          ISkinControlMaterial,
    //  ISkinComponent,
      ISkinControl,
      IControlForPageFramework)
  private
    {$I Source\Controls\INC\Common\ISkinControl_Declare.inc}
    {$I Source\Controls\INC\VCL\ISkinControl_Control_Impl_Mouse_Declare_VCL.inc}
    {$I Source\Controls\INC\VCL\ISkinControl_Control_Impl_Key_Declare_VCL.inc}
    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_DirectUI_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Property_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Declare.inc}
  protected
    function GetMemoProperties:TMemoProperties;
    procedure SetMemoProperties(Value:TMemoProperties);
  protected
    //缓存位图
    FBufferBitmap:TBufferBitmap;
    //缓存位图
    function GetBufferBitmap: TBufferBitmap;
    //缓存位图
    property BufferBitmap:TBufferBitmap read GetBufferBitmap;
  protected
    //检测鼠标的定时器
    FCheckMouseStayTimer:TTimer;
    FCheckMouseStayTimerID:Integer;
    procedure CreateCheckMouseStayTimer;
    procedure OnCheckMouseStayTimer(Sender:TObject);
  protected
    //处理透明背景
    FTransparentBrush:TBrush;
    FTransparentBitmap:TBitmap;
    procedure CNCtlColorEdit(var Message:TWMCtlColorEdit);message CN_CTLCOLOREDIT;
  protected
    //消息处理
    procedure WMPaint(var Message:TWMPaint);message WM_PAINT;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd);message WM_ERASEBKGND;
    procedure WMNCCalcSize(var Message:TWMNCCalcSize);message WM_NCCALCSIZE;
    procedure WMNCPaint(var Message:TWMNCPaint);message WM_NCPAINT;
    procedure WMKillFocus(var Message:TMessage);message WM_KILLFOCUS;
    //绘制非客户区
    procedure NCPaintWindow;
    //非客户区绘制
    function NCPaint(ACanvas:TDrawCanvas;const ADrawRect:TRect):Boolean;virtual;

    procedure WMNCHitTest(var Message:TWMNCHitTest);message WM_NCHITTEST;
    procedure WMSize(var Message:TWMSize);message WM_SIZE;
    //在窗体更改尺寸的事件中刷新
    procedure CMInvalidateInParentWMSize(var Message:TMessage);message CM_InvalidateInParentWMSize;
  protected
    function GetMemoMaxLength:Integer;

    procedure SetIsAutoHeight(const Value:Boolean);
    procedure DoAutoHeightMemoChange(Sender:TObject);
    function IsReadOnly:Boolean;

  protected
    //边框边距
    FBorderMargins:TBorderMargins;
    FNCBorderMargins:TBorderMargins;

    procedure SetBorderMargins(const Value: TBorderMargins);
    procedure OnBorderMarginsChangeNotify(Sender:TObject);
  public
    //针对页面框架的控件接口
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;virtual;
//    //获取合适的高度
//    function GetSuitDefaultItemHeight:Double;
    //获取与设置自定义属性
    function GetPropJsonStr:String;virtual;
    procedure SetPropJsonStr(AJsonStr:String);virtual;

    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;virtual;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);virtual;
//    //设置属性
//    function GetProp(APropName:String):Variant;virtual;
//    procedure SetProp(APropName:String;APropValue:Variant);virtual;
    procedure DoReturnFrame(AFromFrame:TFrame);
  published
    //边框扩展边距(在VCL下才有用,FMX下此属性无用)
    property BorderMargins:TBorderMargins read FBorderMargins write SetBorderMargins;


  protected
    //标题
    function GetCaption:String;
    procedure SetCaption(const Value:String);
  protected
    function GetText:String;
//    //控件加载完毕
//    procedure Loaded;override;
//    //通知
//    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
//  public
//    //获取父控件的子控件
//    function GetParentChildControlCount:Integer;
//    function GetParentChildControl(Index:Integer):TChildControl;
//    //获取子控件
//    function GetChildControlCount:Integer;
//    function GetChildControl(Index:Integer):TChildControl;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    property MemoProperties:TMemoProperties read GetMemoProperties write SetMemoProperties;
  published
    property Align;
    property Alignment;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
//    property Ctl3D;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property Lines;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
//    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ScrollBars;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Touch;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordWrap;
//    property StyleElements;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;



implementation

{ TSkinWinMemo }


{$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Code.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Code.inc}
{$I Source\Controls\INC\VCL\ISkinControl_Control_Impl_Code_VCL.inc}
{$I Source\Controls\INC\VCL\ISkinControl_Control_Impl_Mouse_Code_VCL.inc}
{$I Source\Controls\INC\VCL\ISkinControl_Control_Impl_Key_Code_VCL.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_DirectUI_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Code.inc}



//procedure TSkinWinMemo.Loaded;
//begin
//  inherited;
//  {$I Source\Controls\ISkinComponent_Skin_Impl_Loaded_Code.inc}
//end;
//
//procedure TSkinWinMemo.Notification(AComponent: TComponent; Operation: TOperation);
//begin
//  inherited Notification(AComponent,Operation);
//  if (Operation=opRemove) then
//  begin
//
//
//    if (AComponent=Self.FSelfOwnMaterial) then
//    begin
//      //如果使用的是自己的素材,那么也要清除
//      if FCurrentUseSkinMaterial=FSelfOwnMaterial then
//      begin
//        FCurrentUseSkinMaterial:=nil;
//      end;
//      FSelfOwnMaterial:=nil;
//    end
//    else
//    if (AComponent=Self.FRefMaterial) then
//    begin
//      if FCurrentUseSkinMaterial=FRefMaterial then
//      begin
//        FCurrentUseSkinMaterial:=nil;
//      end;
//      FRefMaterial:=nil;
//    end
//    else
//    if (AComponent=Self.FCurrentUseSkinMaterial) then
//    begin
//      FCurrentUseSkinMaterial:=nil;
//    end;
//
//  end;
//end;

constructor TSkinWinMemo.Create(AOwner: TComponent);
begin

  FBorderMargins:=TBorderMargins.Create;
  FBorderMargins.SetBounds(3,3,3,3);

  FNCBorderMargins:=TBorderMargins.Create;
  FNCBorderMargins.SetBounds(2,2,2,2);

  inherited Create(AOwner);
  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Create_Code.inc}
  //创建控件属性
  FProperties:=Self.GetPropertiesClassType.Create(Self);


  FBorderMargins.OnChange:=Self.OnBorderMarginsChangeNotify;


//  Self.AutoSize:=False;
//  Self.BorderStyle:=bsNone;
//  Self.Ctl3D:=False;
//  Self.ParentCtl3D:=False;
//  Self.BevelEdges:=[];
//  Self.BevelInner:=bvNone;
//  Self.BevelKind:=bkNone;
//  Self.BevelOuter:=bvNone;
//  Self.BevelWidth:=1;

end;

destructor TSkinWinMemo.Destroy;
begin
  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Destroy_Code.inc}
  FreeAndNil(FBufferBitmap);
  FreeAndNil(FProperties);

  Sysutils.FreeAndNil(FCanvas);

  FBorderMargins.OnChange:=nil;
  uFuncCommon.FreeAndNil(FBorderMargins);

  FNCBorderMargins.OnChange:=nil;
  uFuncCommon.FreeAndNil(FNCBorderMargins);
  inherited;
end;

procedure TSkinWinMemo.SetBorderMargins(const Value: TBorderMargins);
begin
  FBorderMargins.Assign(Value);
end;

procedure TSkinWinMemo.OnBorderMarginsChangeNotify(Sender: TObject);
begin
end;


function TSkinWinMemo.GetBufferBitmap: TBufferBitmap;
begin
  if (FBufferBitmap=nil) then
  begin
    FBufferBitmap:=TBufferBitmap.Create;
  end;
  Result:=Self.FBufferBitmap;
end;

procedure TSkinWinMemo.CreateCheckMouseStayTimer;
begin
  if FCheckMouseStayTimer=nil then
  begin
    FCheckMouseStayTimer:=TTimer.Create(Self);
    FCheckMouseStayTimer.OnTimer:=OnCheckMouseStayTimer;
    FCheckMouseStayTimer.Interval:=100;
    FCheckMouseStayTimer.Enabled:=False;
  end;
end;


function TSkinWinMemo.LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;
begin
//  SetMaterialUseKind(TMaterialUseKind.mukRefByStyleName);
//  SetMaterialName(ASetting.ControlStyle);
//
//  if ASetting.HasHintLabel=0 then
//  begin
//    Caption:=ASetting.Caption;
//  end;
  Self.MemoProperties.HelpText:=ASetting.input_prompt;
  Self.MaxLength:=ASetting.input_max_length;


  Result:=True;
end;

function TSkinWinMemo.GetPropJsonStr:String;
begin
  Result:=Self.MemoProperties.GetPropJsonStr;
end;

procedure TSkinWinMemo.SetPropJsonStr(AJsonStr:String);
begin
  Self.MemoProperties.SetPropJsonStr(AJsonStr);
end;

////设置属性
//function TSkinWinMemo.GetProp(APropName:String):Variant;
//begin
//  Result:='';
//end;
//
//procedure TSkinWinMemo.SetProp(APropName:String;APropValue:Variant);
//begin
//end;



function TSkinWinMemo.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                                          var AErrorMessage:String):Variant;
begin
  Result:=Text;
end;

procedure TSkinWinMemo.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                                              //要设置多个值,整个字段的记录
                                              AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
  Text:=AValue;
end;


procedure TSkinWinMemo.DoReturnFrame(AFromFrame:TFrame);
begin

end;


procedure TSkinWinMemo.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Inherited;
end;

procedure TSkinWinMemo.CMInvalidateInParentWMSize(var Message: TMessage);
begin
  Inherited;
  Self.NCPaintWindow;
  Self.Invalidate;
end;

procedure TSkinWinMemo.WMPaint(var Message: TWMPaint);
//var
//  DC:HDC;
//  ACanvas:TDrawCanvas;
//begin
//  Inherited;
////  //绘制提示文本
////  if Not Focused and (Text='') and (Self.EditProperties.HelpText<>'') then
////  begin
//    if Self.GetSkinComponentType<>nil then
//    begin
//      DC := GetDC(Handle);
//      try
//        ACanvas:=CreateDrawCanvas;
//        if ACanvas<>nil then
//        begin
//          try
//            ACanvas.Prepare(DC);
//            TSkinMemoDefaultType(Self.GetSkinComponentType).CustomPaintHelpText(ACanvas,Self.ClientRect,True);
//          finally
//            FreeAndNil(ACanvas);
//          end;
//        end;
//      finally
//        ReleaseDC(Handle,DC);
//      end;
//    end;
////  end;
var
  DC:HDC;
  ACanvas:TDrawCanvas;
begin
  Inherited;

  //绘制提示文本
  if (Text='') and (Self.MemoProperties.HelpText<>'') then
  begin
    if Self.GetSkinControlType<>nil then
    begin
      DC := GetDC(Handle);
      try
        ACanvas:=CreateDrawCanvas('TSkinWinMemo.WMPaint');
        if ACanvas<>nil then
        begin
          try
            ACanvas.Prepare(DC);

            FPaintData:=GlobalNullPaintData;
            FPaintData.IsDrawInteractiveState:=True;
            FPaintData.IsInDrawDirectUI:=False;
            TSkinMemoDefaultType(Self.GetSkinControlType).CustomPaintHelpText(
                  ACanvas,
                  Self.GetCurrentUseMaterial,
                  RectF(Self.GetClientRect.Left,Self.GetClientRect.Top,Self.GetClientRect.Right,Self.GetClientRect.Bottom),
                  FPaintData);

          finally
            FreeAndNil(ACanvas);
          end;
        end;
      finally
        ReleaseDC(Handle,DC);
      end;
    end;

  end;
end;

function TSkinWinMemo.NCPaint(ACanvas: TDrawCanvas;const ADrawRect: TRect): Boolean;
begin

    //绘制父控件背景
    if (Self.GetCurrentUseMaterial<>nil) then
    begin
      if TSkinControlMaterial(Self.GetCurrentUseMaterial).IsTransparent then
      begin
        DrawParent(Self,
                    ACanvas.Handle,
                    0,0,Self.Width,Self.Height,
                    0,0);
      end;
    end;



    //绘制
    if (GetSkinControlType<>nil) then
    begin
      FPaintData:=GlobalNullPaintData;
      FPaintData.IsDrawInteractiveState:=True;
      FPaintData.IsInDrawDirectUI:=False;
      TSkinControlType(Self.GetSkinControlType).Paint(ACanvas,
                                                        Self.GetCurrentUseMaterial,
                                                        RectF(0,0,Self.Width,Self.Height),
                                                        FPaintData);
    end;


    //设计时绘制虚线框和控件名称
    if (csDesigning in Self.ComponentState) then
    begin
      ACanvas.DrawDesigningRect(RectF(0,0,Width,Height),GlobalNormalDesignRectBorderColor);

      ACanvas.DrawDesigningText(RectF(0,0,Width,Height),Self.Name);
    end;





//    //如果是运行时，并且是试用版，而且到期，那么显示试用版已到期，请联系作者DelphiTeacher
//    if not (csDesigning in Self.ComponentState)
//        and TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_IsTray')).ConvertNode_Bool32.Data
//        and ((Now-TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_LicensedDate')).ConvertNode_DateTime.Data)
//                  >TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_TrayMonths')).ConvertNode_Int32.Data*31)
//    then
//    begin
//      ACanvas.Canvas.TextOut(0,0,'试用版已到期');
//    end;



//    //绘制父控件背景
//    if (Self.GetCurrentUseMaterial<>nil) then
//    begin
//      if TSkinControlMaterial(Self.GetCurrentUseMaterial).IsTransparent then
//      begin
//        DrawParent(Self,ACanvas.Handle,
//                            0,0,Self.Width,Self.Height,
//                            0,0);
//      end;
//    end;
//
//
//
//    if (GetSkinComponentType<>nil) then
//    begin
//      //绘制
//      TSkinControlType(Self.GetSkinComponentType).Paint(ACanvas,
//                                                              Rect(0,0,Self.Width,Self.Height)
//                                                              ,True);
//    end;
//
//

//    //如果是运行时，并且是试用版，而且到期，那么显示试用版已到期，请联系作者DelphiTeacher
//    if not (csDesigning in Self.ComponentState)
//        and TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_IsTray')).ConvertNode_Bool32.Data
//        and ((Now-TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_LicensedDate')).ConvertNode_DateTime.Data)
//                  >TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_TrayMonths')).ConvertNode_Int32.Data*31)
//    then
//    begin
//      ACanvas.Canvas.TextOut(0,0,'试用版已到期');
//    end;

end;

procedure TSkinWinMemo.NCPaintWindow;
var
  DC:HDC;
begin

  DC:=GetWindowDC(Handle);


  //绘制边框和其他非客户区
  if (Self.BufferBitmap.Width<>Self.Width) or (Self.BufferBitmap.Height<>Self.Height) then
  begin
    Self.BufferBitmap.CreateBufferBitmap(Self.Width,Self.Height);
  end;

  Try
    if Self.BufferBitmap.DrawCanvas<>nil then
    begin

      NCPaint(Self.BufferBitmap.DrawCanvas,Rect(0,0,Self.Width,Self.Height));

      StretchBlt(DC,0,0,
                  Self.Width,Self.FBorderMargins.Top,
                  Self.BufferBitmap.Handle,0,0,
                  Self.Width,Self.FBorderMargins.Top,
                  SRCCOPY);
      StretchBlt(DC,0,Self.Height-Self.FBorderMargins.Bottom,
                  Self.Width,Self.FBorderMargins.Bottom,
                  Self.BufferBitmap.Handle,0,Self.Height-Self.FBorderMargins.Bottom,
                  Self.Width,Self.FBorderMargins.Bottom,
                  SRCCOPY);
      StretchBlt(DC,0,Self.FBorderMargins.Top,
                  Self.FBorderMargins.Left,//+Self.GetCustomWMNCCalcSizeLeftWidth,
                  Self.Height-Self.FBorderMargins.Top-Self.FBorderMargins.Bottom,
                  Self.BufferBitmap.Handle,0,Self.FBorderMargins.Top,
                  Self.FBorderMargins.Left,//+Self.GetCustomWMNCCalcSizeLeftWidth,
                  Self.Height-Self.FBorderMargins.Top-Self.FBorderMargins.Bottom,
                  SRCCOPY);
      StretchBlt(DC,Self.Width-Self.FBorderMargins.Right,//-Self.GetCustomWMNCCalcSizeRightWidth,
                  Self.FBorderMargins.Top,
                  Self.FBorderMargins.Right,//+Self.GetCustomWMNCCalcSizeRightWidth,
                  Self.Height-Self.FBorderMargins.Top-Self.FBorderMargins.Bottom,
                  Self.BufferBitmap.Handle,Self.Width-Self.FBorderMargins.Right,//-Self.GetCustomWMNCCalcSizeRightWidth,
                  Self.FBorderMargins.Top,
                  Self.FBorderMargins.Right,//+Self.GetCustomWMNCCalcSizeRightWidth,
                  Self.Height-Self.FBorderMargins.Top-Self.FBorderMargins.Bottom,
                  SRCCOPY);

    end;
  finally
    ReleaseDC(Handle,DC);
  end;


end;

procedure TSkinWinMemo.CNCtlColorEdit(var Message: TWMCtlColorEdit);
begin
  Inherited;
//  if Not (csDesigning in Self.ComponentState) then
//  begin
    FreeAndNil(FTransparentBitmap);
    FreeAndNil(FTransparentBrush);

    FTransparentBitmap:=TBitmap.Create;
    FTransparentBrush:=TBrush.Create;

    SetBkMode(TWMCtlColorEdit(Message).ChildDC,TRANSPARENT);
    FTransparentBitmap.Width:=Self.Width;
    FTransparentBitmap.Height:=Self.Height;

    DrawParent(Self,
                Self.FTransparentBitmap.Canvas.Handle,
                0,0,
                Self.Width-Self.FBorderMargins.Left-Self.FBorderMargins.Right,
                Self.Height-Self.FBorderMargins.Top-Self.FBorderMargins.Bottom,
                Self.FBorderMargins.Left,
                Self.FBorderMargins.Top);

    if FBufferBitmap<>nil then
    begin
      Bitblt(FTransparentBitmap.Canvas.Handle,
             0,0,FTransparentBitmap.Width,FTransparentBitmap.Height,
             Self.FBufferBitmap.Handle,
             Self.FBorderMargins.Left,
             Self.FBorderMargins.Top,
             SRCCOPY
              );
    end;

    FTransparentBrush.Bitmap:=FTransparentBitmap;

    TWMCtlColorEdit(Message).Result:=FTransparentBrush.Handle;

//  end;
end;

procedure TSkinWinMemo.WMNCCalcSize(var Message: TWMNCCalcSize);
var
  NewWindowRect:TRect;
  OldWindowRect:TRect;
  OldClientRect:TRect;
  NewClientRect:TRect;
  PNewWindowRect:PRect;
  NCCalcSizeParams: PNCCalcSizeParams;
begin
  Inherited;

//
//
////  InflateRect(Message.CalcSize_Params^.rgrc[0], -2, -2);
////  Exit;
//////  Exit;
////  if    //(Self<>nil)
////    //and
//////        (Self.BorderStyle<>bsNone)
//////        and
////        (Self.MemoProperties<>nil)
////    //and Not (csDesigning in Self.ComponentState)
////    and (Self.FBorderMargins<>nil) then
////  begin
////    //自定义边框
////    if TWMNCCalcSize(Message).CalcValidRects then
////    begin
//      NCCalcSizeParams:=TWMNCCalcSize(Message).CalcSize_Params;
//
//      NewWindowRect:=NCCalcSizeParams.rgrc[0];
//      OldWindowRect:=NCCalcSizeParams.rgrc[1];
//      OldClientRect:=NCCalcSizeParams.rgrc[2];
//
//      NewClientRect.Left:=NewWindowRect.Left+Self.FBorderMargins.Left;//+GetCustomWMNCCalcSizeLeftWidth;
//      NewClientRect.Top:=NewWindowRect.Top+Self.FBorderMargins.Top;
//      NewClientRect.Right:=NewWindowRect.Right-Self.FBorderMargins.Right;//-GetCustomWMNCCalcSizeRightWidth;
//      NewClientRect.Bottom:=NewWindowRect.Bottom-Self.FBorderMargins.Bottom;
//
////
////      OldWindowRect.Bottom:=OldWindowRect.Bottom++2;
////      OldClientRect.Bottom:=OldClientRect.Bottom+2;
////      NewWindowRect.Bottom:=OldClientRect.Bottom-Self.FBorderMargins.Bottom;
//
//      NCCalcSizeParams.rgrc[0]:=NewClientRect;
//      NCCalcSizeParams.rgrc[1]:=NewWindowRect;
//      NCCalcSizeParams.rgrc[2]:=OldClientRect;
//
////    end
////    else
////    begin
////
////      PNewWindowRect:=PRect(Pointer(TWMNCCalcSize(Message).CalcSize_Params));
////      PNewWindowRect.Left:=PNewWindowRect.Left+Self.FBorderMargins.Left;//+GetCustomWMNCCalcSizeLeftWidth;
////      PNewWindowRect.Top:=PNewWindowRect.Top+Self.FBorderMargins.Top;
////      PNewWindowRect.Right:=PNewWindowRect.Right-Self.FBorderMargins.Right;//-GetCustomWMNCCalcSizeRightWidth;
////      PNewWindowRect.Bottom:=PNewWindowRect.Bottom-Self.FBorderMargins.Bottom;
////
////
////
////
////    end;
////    Done:=True;
////  end;
//
//


  if
        (Self.MemoProperties<>nil)
    and (Self.FNCBorderMargins<>nil) then
  begin
    //自定义边框
    if TWMNCCalcSize(Message).CalcValidRects then
    begin
      NCCalcSizeParams:=TWMNCCalcSize(Message).CalcSize_Params;

      NewWindowRect:=NCCalcSizeParams.rgrc[0];
      OldWindowRect:=NCCalcSizeParams.rgrc[1];
      OldClientRect:=NCCalcSizeParams.rgrc[2];
      NewClientRect.Left:=NewWindowRect.Left+Self.FNCBorderMargins.Left;//+GetCustomWMNCCalcSizeLeftWidth;
      NewClientRect.Top:=NewWindowRect.Top+Self.FNCBorderMargins.Top;
      NewClientRect.Right:=NewWindowRect.Right-Self.FNCBorderMargins.Right;//-GetCustomWMNCCalcSizeRightWidth;
      NewClientRect.Bottom:=NewWindowRect.Bottom-Self.FNCBorderMargins.Bottom;
      NCCalcSizeParams.rgrc[0]:=NewClientRect;
      NCCalcSizeParams.rgrc[1]:=NewWindowRect;
      NCCalcSizeParams.rgrc[2]:=OldClientRect;

    end
    else
    begin
      PNewWindowRect:=PRect(Pointer(TWMNCCalcSize(Message).CalcSize_Params));
      PNewWindowRect.Left:=PNewWindowRect.Left+Self.FNCBorderMargins.Left;//+GetCustomWMNCCalcSizeLeftWidth;
      PNewWindowRect.Top:=PNewWindowRect.Top+Self.FNCBorderMargins.Top;
      PNewWindowRect.Right:=PNewWindowRect.Right-Self.FNCBorderMargins.Right;//-GetCustomWMNCCalcSizeRightWidth;
      PNewWindowRect.Bottom:=PNewWindowRect.Bottom-Self.FNCBorderMargins.Bottom;
    end;
  end;


end;

procedure TSkinWinMemo.WMNCPaint(var Message: TWMNCPaint);
begin
//  Inherited;
  Message.Result:=1;
  NCPaintWindow;
end;

procedure TSkinWinMemo.WMKillFocus(var Message: TMessage);
begin
  Inherited;
  Invalidate;
  NCPaintWindow;
end;

procedure TSkinWinMemo.OnCheckMouseStayTimer(Sender: TObject);
var
  CursorPos:TPoint;
  WindowRect:TRect;
begin
  case FCheckMouseStayTimerID of
    0://判断鼠标是否在控件中
    begin

      if GetCursorPos(CursorPos) and GetWindowRect(Handle,WindowRect) and Windows.PtInRect(WindowRect,CursorPos) then
      begin
        //鼠标在控件中,刷新
        NCPaintWindow;
        Invalidate;
      end
      else
      begin
        Self.IsMouseOver:=False;
        CreateCheckMouseStayTimer;
        Self.FCheckMouseStayTimer.Enabled:=False;
//        DoCustomMouseLeave;
        NCPaintWindow;
        Invalidate;
      end;
    end;
  end;
end;

procedure TSkinWinMemo.WMNCHitTest(var Message: TWMNCHitTest);
begin
  Inherited;
  if Not (csDesigning in Self.ComponentState) then
  begin

      //设置鼠标进入状态
      if Not Self.IsMouseOver then
      begin
        Self.IsMouseOver:=True;
//        DoCustomMouseEnter;
        CreateCheckMouseStayTimer;
        Self.FCheckMouseStayTimerID:=0;
        Self.FCheckMouseStayTimer.Enabled:=True;
        Invalidate;
        Self.NCPaintWindow;
      end;

  end;
end;

procedure TSkinWinMemo.WMSize(var Message: TWMSize);
begin
  Inherited;
//  if Not (csDesigning in Self.ComponentState) then
//  begin
    Invalidate;
    Self.NCPaintWindow;
//  end;
end;

function TSkinWinMemo.GetMemoProperties: TMemoProperties;
begin
  Result:=TMemoProperties(Self.FProperties);
end;

procedure TSkinWinMemo.SetMemoProperties(Value: TMemoProperties);
begin
  Self.FProperties.Assign(Value);
end;

function TSkinWinMemo.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TMemoProperties;
end;

//function TSkinWinMemo.GetParentChildControlCount:Integer;
//begin
//  Result:=Parent.ControlCount;
//end;
//
//function TSkinWinMemo.GetParentChildControl(Index:Integer):TChildControl;
//begin
//  Result:=Self.Parent.Controls[Index];
//end;
//
//function TSkinWinMemo.GetChildControlCount:Integer;
//begin
//  Result:=Self.ControlCount;
//end;
//
//function TSkinWinMemo.GetChildControl(Index:Integer):TChildControl;
//begin
//  Result:=Self.Controls[Index];
//end;

function TSkinWinMemo.GetText:String;
begin
  Result:=Self.Text;
end;

procedure TSkinWinMemo.SetCaption(const Value:String);
begin
  if Caption<>Value then
  begin
    Inherited Caption:=Value;
    if GetSkinControlType<>nil then
    begin
      TSkinControlType(GetSkinControlType).TextChanged;
    end;
  end;
end;

function TSkinWinMemo.GetCaption:String;
begin
  Result:=Inherited Caption;
end;

function TSkinWinMemo.GetMemoMaxLength:Integer;
begin
end;


procedure TSkinWinMemo.SetIsAutoHeight(const Value:Boolean);
begin
end;

procedure TSkinWinMemo.DoAutoHeightMemoChange(Sender:TObject);
begin
end;

function TSkinWinMemo.IsReadOnly:Boolean;
begin
end;



end.

