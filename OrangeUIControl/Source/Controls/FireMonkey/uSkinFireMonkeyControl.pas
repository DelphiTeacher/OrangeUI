//convert pas to utf8 by ¥
//皮肤控件基类//
unit uSkinFireMonkeyControl;

interface
{$I FrameWork.inc}



{$I FireMonkey.inc}//{$DEFINE FMXControl}


uses
  SysUtils,
  Classes,
  uBaseLog,
  UITypes,
  Math,
  Types,

  DB,
  FMX.Forms,
  FMX.Types,
  FMX.Controls,
  FMX.Graphics,
  FMX.StdCtrls,

  uLang,
  uFuncCommon,
  uSkinPublic,
  uBaseList,
  uSkinMaterial,
  uVersion,
  uBinaryTreeDoc,
  uComponentType,
  uDrawEngine,
  uGraphicCommon,
  uDrawCanvas,
  uDrawPicture,
  uBasePageStructure,
//  uSkinPackage,
  uSkinRegManager,
  uSkinBufferBitmap;


Type
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFireMonkeyControl=class(TControl,
                                ISkinControl,
                                ISkinControlMaterial,
                                ILangProcess,
                                IDirectUIControl,
                                IControlForPageFramework,
                                ISkinItemBindingControl
                                )
  private
    {$I Source\Controls\INC\Common\ISkinControl_Declare.inc}
    {$I Source\Controls\INC\FMX\ISkinControl_Caption_Impl_Declare_FMX.inc}
    {$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Mouse_Declare_FMX.inc}
    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_DirectUI_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Property_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Declare.inc}
  protected

    //控件绘制
    procedure Paint;overload;override;
    //FMX手势操作
    procedure CMGesture(var EventInfo: TGestureEventInfo); override;
  protected


    //鼠标按下是否获得焦点
    FMouseDownFocus:Boolean;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
//    function ScreenToLocal(P: TPointF): TPointF; virtual;
//    function LocalToScreen(P: TPointF): TPointF; virtual;
    function ScreenToLocal({$IF CompilerVersion >= 35.0}const {$ELSE}{$IFEND}P: TPointF): TPointF; override;
    function LocalToScreen({$IF CompilerVersion >= 35.0}const {$ELSE}{$IFEND}P: TPointF): TPointF; override;
  public
    //记录多语言的索引
    procedure RecordControlLangIndex(APrefix:String;ALang:TLang;ACurLang:String);virtual;
    //翻译
    procedure TranslateControlLang(APrefix:String;ALang:TLang;ACurLang:String);virtual;
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
    procedure DoReturnFrame(AFromFrame:TFrame);virtual;
  public
    //刷新控件
    procedure Invalidate;
    property WidthInt:Integer read GetWidthInt write SetWidthInt;
    property HeightInt:Integer read GetHeightInt write SetHeightInt;
  published
    //鼠标按下是否获取焦点
    property MouseDownFocus:Boolean read FMouseDownFocus write FMouseDownFocus ;

  published
    property Action;
    property Align default TAlignLayout.{$IF CompilerVersion >= 35.0}None{$ELSE}alNone{$IFEND};
    property Anchors;
//    property AutoTranslate default True;
//    property Cancel: Boolean read FCancel write FCancel default False;
    property CanFocus;// default True;
    property CanParentFocus;
//    property ControlType;
    property ClipChildren;// default False;
    property ClipParent;// default False;
    property Cursor default crDefault;
//    property Default: Boolean read FDefault write FDefault default False;
//    property DesignVisible default True;
//    property DisableFocusEffect;
    property DragMode default TDragMode.dmManual;
//    property EnableDragHighlight default True;
    property Enabled default True;
//    property Font;
//    property StyledSettings;
    property Height;
    property Hint;
//    property HelpContext;
//    property HelpKeyword;
//    property HelpType;
    property HitTest default True;
//    property IsPressed default False;
    property Locked default False;
    property Padding;
//    property ModalResult default mrNone;
    property Opacity;
    property Margins;
    property PopupMenu;
    property Position;
    property Scale;
    property Size;
//    {$ENDIF}
//    property RepeatClick default False;
    property RotationAngle;
    property RotationCenter;
//    property Scale;
    property ShowHint;
//    property StyleLookup;
    property TabOrder;
//    property Text;
//    property Trimming;
//    property TextAlign default TTextAlign.taCenter;
    property TouchTargetExpansion;
    property Visible default True;
    property Width;
//    pro
//    property WordWrap default False;
//    property OnApplyStyleLookup;
//    property OnGestureLongTap:TOnGestureLongTap read FOnGestureLongTap write FOnGestureLongTap;

    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    property OnKeyDown;
    property OnKeyUp;
    property OnCanFocus;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnPainting;
    property OnPaint;
    property OnResize;
  end;







implementation




{ TSkinFireMonkeyControl }

{$I Source\Controls\INC\FMX\ISkinControl_Caption_Impl_Code_FMX.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Code.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Code.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Control_Properties_Impl_Code.inc}
{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Code_FMX.inc}
{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Mouse_Code_FMX.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_DirectUI_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Code.inc}



procedure TSkinFireMonkeyControl.CMGesture(var EventInfo: TGestureEventInfo);
var
  Handled:Boolean;
begin
  Handled:=False;
  if GetSkinControlType<>nil then
  begin
    GetSkinControlType.Gesture(EventInfo,Handled);
  end;
  if Not Handled then
  begin
    inherited;
  end;
end;

constructor TSkinFireMonkeyControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

//  uBaseLog.HandleException(nil,'OrangeUI','uSkinFireMonkeyControl',Name+' '+ClassName+' '+'TSkinFireMonkeyControl.Create'+' '+IntToStr(Integer(Self)));

  //执行Action
  EnableExecuteAction:=True;

  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Create_Code.inc}

  //创建控件属性
  FProperties:=Self.GetPropertiesClassType.Create(Self);

  //父控件启用DirectUI模式下是否显示
//  Self.FDirectUIVisible:=False;

  //鼠标是否停靠
  FIsMouseOver:=False;

  //是否穿透鼠标消息
  FParentMouseEvent:=False;
  FMouseEventTransToParentType:=mettptAuto;

  //鼠标按下是否获得焦点
  FMouseDownFocus:=False;

//  CanFocus:=True;
//  Self.ClipChildren:=True;
  AutoCapture:=True;
end;

destructor TSkinFireMonkeyControl.Destroy;
begin
//  uBaseLog.HandleException(nil,'OrangeUI','uSkinFireMonkeyControl',Name+' '+ClassName+' '+'TSkinFireMonkeyControl.Destroy'+' '+IntToStr(Integer(Self)));

  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Destroy_Code.inc}


  try
    FreeAndNil(FProperties);
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'OrangeUI','uSkinFireMonkeyControl',Name+' '+ClassName+' '+'FreeAndNil(FProperties);');
    end;
  end;

  try
    FreeAndNil(FCanvas);
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'OrangeUI','uSkinFireMonkeyControl',Name+' '+ClassName+' '+'FreeAndNil(FCanvas);');
    end;
  end;

  try
    inherited;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'OrangeUI','uSkinFireMonkeyControl',Name+' '+ClassName+' '+'inherited');
    end;
  end;


end;

function TSkinFireMonkeyControl.ScreenToLocal({$IF CompilerVersion >= 35.0}const {$ELSE}{$IFEND}P: TPointF): TPointF;
begin
  Result:=Inherited ScreenToLocal(P);
end;

function TSkinFireMonkeyControl.LocalToScreen({$IF CompilerVersion >= 35.0}const {$ELSE}{$IFEND}P: TPointF): TPointF;
begin
  Result:=Inherited LocalToScreen(P);
end;

procedure TSkinFireMonkeyControl.RecordControlLangIndex(APrefix:String;ALang:TLang;ACurLang:String);
begin
  if Caption<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.Caption',ACurLang,Caption);
  end;
end;

procedure TSkinFireMonkeyControl.TranslateControlLang(APrefix:String;ALang:TLang;ACurLang:String);
begin
  if GetLangValue(ALang,APrefix+Name+'.Caption',ACurLang)<>'' then
  begin
    Caption:=GetLangValue(ALang,APrefix+Name+'.Caption',ACurLang);
  end;
end;

function TSkinFireMonkeyControl.LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;
begin
//  SetMaterialUseKind(TMaterialUseKind.mukRefByStyleName);
//  SetMaterialName(ASetting.ControlStyle);
//
//  if ASetting.HasHintLabel=0 then
//  begin
//    Caption:=ASetting.Caption;
//  end;

  Result:=True;
end;

function TSkinFireMonkeyControl.GetPropJsonStr:String;
begin
  Result:=Self.Properties.GetPropJsonStr;
end;

procedure TSkinFireMonkeyControl.SetPropJsonStr(AJsonStr:String);
begin
  Self.Properties.SetPropJsonStr(AJsonStr);
end;

procedure TSkinFireMonkeyControl.DoReturnFrame(AFromFrame:TFrame);
begin
end;

function TSkinFireMonkeyControl.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
begin
  Result:='';//GetCaption;
end;

procedure TSkinFireMonkeyControl.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
  //Caption:='';//AValue;
end;

////设置属性
//function TSkinFireMonkeyControl.GetProp(APropName:String):Variant;
//begin
//
//end;
//
//procedure TSkinFireMonkeyControl.SetProp(APropName:String;APropValue:Variant);
//begin
//
//end;


//function TSkinFireMonkeyControl.GetSuitDefaultItemHeight:Double;
//begin
//  Result:=-1;
//end;

procedure TSkinFireMonkeyControl.Paint;
//var
////  APaintData:TPaintData;
//  BeginTickCount:Cardinal;
//////  BeginTime:TDateTime;
//var
//  ASkinMaterial:TSkinControlMaterial;
begin
//  BeginTickCount:=UIGetTickCount;
////  BeginTime:=Now;
////  try
////  ItemPaintTime:='';
//  uBaseLog.HandleException(nil,'OrangeUI','uSkinFireMonkeyControl',Name+' '+ClassName+' '+'Paint');




    FCanvas.Prepare(Canvas);



    //绘制
//    if (GetSkinControlType<>nil) then
//    begin
//      ASkinMaterial:=GetSkinControlType.GetPaintCurrentUseMaterial;
//    end;

    if (GetSkinControlType<>nil) then
    begin
      FPaintData:=GlobalNullPaintData;
      FPaintData.IsDrawInteractiveState:=True;
      FPaintData.IsInDrawDirectUI:=False;
      GetSkinControlType.Paint(FCanvas,GetSkinControlType.GetPaintCurrentUseMaterial,RectF(0,0,Self.Width,Self.Height),FPaintData);
    end;




    //设计时绘制虚线框和控件名称
    if (csDesigning in Self.ComponentState) then
    begin
      FCanvas.DrawDesigningRect(RectF(0,0,Width,Height),GlobalNormalDesignRectBorderColor);

      FCanvas.DrawDesigningText(RectF(0,0,Width,Height),Self.Name);

      //绘制控件绑定的字段
//      FCanvas.DrawDesigningText(RectF(0,0,Width,Height),Self.BindItemFieldName);
      Canvas.Font.Size:=10;
      Canvas.Fill.Color:=TAlphaColorRec.Black;
      Canvas.FillText(RectF(0,0,Width,Height),Self.BindItemFieldName,True,0.6,[],TTextAlign.{$IF CompilerVersion >= 35.0}Leading{$ELSE}taLeading{$IFEND},TTextAlign.{$IF CompilerVersion >= 35.0}Leading{$ELSE}taLeading{$IFEND});

    end;

    FCanvas.UnPrepare;


//  uBaseLog.OutputDebugString(
//    Self.Name+' Paint TickCount:'+IntToStr(UIGetTickCount-BeginTickCount)
//  //  +ItemPaintTime
//  //  +' Paint Time:'+IntToStr(DateUtils.MilliSecondsBetween(Now,BeginTime))
//    );
//  BeginTickCount:=UIGetTickCount;
end;

procedure TSkinFireMonkeyControl.Invalidate;
var
  ADirectUIParentIntf:IDirectUIParent;
begin
  if (SkinControlInvalidateLocked>0)
    and (Self.FProperties.FIsChanging>0)
    or (csLoading in Self.ComponentState)
    or (csReading in Self.ComponentState) then
  begin
    Exit;
  end;


  if Self.FDirectUIParentIntf=nil then
  begin
    if (Self.Parent<>nil) then
    begin
      //有区域更新接口
      //比如ItemDesignerPanel
      if Self.Parent.GetInterface(IID_IDirectUIParent,ADirectUIParentIntf) then
      begin
        //如果在设计模式下,不管什么情况自己都要重绘一下,给用户看效果。
        if csDesigning in Self.ComponentState then
        begin
          RePaint;
        end;
        ADirectUIParentIntf.UpdateChild(Self,Self as IDirectUIControl);
      end
      else
      begin
        RePaint;
      end;
    end
    else
    begin
      RePaint;
    end;
  end
  else
  begin
    Self.FDirectUIParentIntf.UpdateChild(Self,Self as IDirectUIControl);
  end;


end;




end.




