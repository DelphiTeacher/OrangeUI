//皮肤控件基类//
unit uSkinWindowsControl;

interface
{$I FrameWork.inc}

{$I Source\Controls\Windows\WinControl.inc}


uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Forms,
  Math,
  uLang,
  Graphics,

  {$IF CompilerVersion>=30.0}
  Types,//定义了TRectF
  {$IFEND}

  Controls,
  uBaseLog,
  uBaseList,
  uBinaryTreeDoc,
  uSkinPublic,
  uGraphicCommon,
  uSkinMaterial,
  uComponentType,
  uDrawEngine,
  uDrawCanvas,
  uFuncCommon,
  uVersion,
//  uSkinPackage,
  uBasePageStructure,
  uSkinRegManager,
  uSkinBufferBitmap;


Type
//  {$Region 'Windows皮肤控件'}
  TSkinWindowsControl=class(TWinControl,
      ISkinControl,
      ISkinControlMaterial,
      IDirectUIControl,
      ISkinItemBindingControl,
      IControlForPageFramework
      )
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
    //标题
    function GetCaption:String;
    procedure SetCaption(const Value:String);
  protected
    //缓存位图
    FBufferBitmap:TBufferBitmap;
    //缓存位图
    function GetBufferBitmap: TBufferBitmap;
    //缓存位图
    property BufferBitmap:TBufferBitmap read GetBufferBitmap;
  public
    //记录多语言的索引
    procedure RecordControlLangIndex(APrefix:String;ALang:TLang;ACurLang:String);virtual;
    //翻译
    procedure TranslateControlLang(APrefix:String;ALang:TLang;ACurLang:String);virtual;

  protected
    //鼠标按下是否获得焦点
    FMouseDownFocus:Boolean;

    procedure Invalidate;

    procedure WMLButtonDown(var Message:TWMLButtonDown);message WM_LBUTTONDOWN;

    //处理绘制消息
    procedure WMPaint(var Message:TWMPaint);message WM_PAINT;
    //清除背景
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd);message WM_ERASEBKGND;
    //改变大小
    procedure WMSize(var Message:TWMSize);message WM_SIZE;
    //在父控件更改大小时重绘
    procedure CMInvalidateInParentWMSize(var Message:TMessage);message CM_InvalidateInParentWMSize;
    //标题更改事件
    procedure CMTextChanged(var Message: TMessage);message CM_TextChanged;

    //清除背景过程
    procedure EraseBackGnd(DC:HDC);virtual;
    //控件绘制方法
    procedure PaintWindow(DC: HDC);override;
    //控件绘制
    procedure Paint(DC:HDC;EnableBuffer:Boolean=True);
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
    //非客户区点击测试值
    property HitTestValue:Integer read GetHitTestValue write FHitTestValue;
  published
    property HitTest:Boolean read GetNeedHitTest write FNeedHitTest;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;

    property StaticCaption:String read GetCaption write SetCaption;
    property StaticText:String read GetCaption write SetCaption;

    //标题
    property Caption:String read GetCaption write SetCaption;
    property Text:String read GetCaption write SetCaption;

    property WidthInt:Integer read GetWidthInt write SetWidthInt;
    property HeightInt:Integer read GetHeightInt write SetHeightInt;

    //DirectUI模式下是否显示
//    property DirectUIVisible:Boolean read FDirectUIVisible write FDirectUIVisible;
  published
    property MouseDownFocus:Boolean read FMouseDownFocus write FMouseDownFocus;
    //双击事件
    property OnDblClick;

    property Align;
    property Anchors;
    property Visible;


    property Action;
    property Constraints;
//    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
//    property ParentBiDiMode;
//    property ParentDoubleBuffered;
//    property ParentFont;
//    property ParentShowHint;
    property PopupMenu;
    property Padding;
    property ShowHint;
    property TabOrder;
    property TabStop;




    property OnResize;
    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
//    property OnDropDownClick;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
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
//  {$EndRegion}


implementation

{ TSkinWindowsControl }

{$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Code.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Code.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Control_Properties_Impl_Code.inc}
{$I Source\Controls\INC\VCL\ISkinControl_Control_Impl_Code_VCL.inc}
{$I Source\Controls\INC\VCL\ISkinControl_Control_Impl_Mouse_Code_VCL.inc}
{$I Source\Controls\INC\VCL\ISkinControl_Control_Impl_Key_Code_VCL.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_DirectUI_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Code.inc}



constructor TSkinWindowsControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Create_Code.inc}

  FMouseDownFocus:=False;

//  FDirectUIVisible:=False;


  //创建控件属性
  FProperties:=Self.GetPropertiesClassType.Create(Self);

//  {$IFDEF VCL}
  //接受子控件
  ControlStyle:=ControlStyle+[csAcceptsControls];
//  {$ENDIF}
end;

destructor TSkinWindowsControl.Destroy;
begin
//  uBaseLog.HandleException(nil,'TSkinWindowsControl.Destroy Begin '+Name);

  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Destroy_Code.inc}

  Sysutils.FreeAndNil(FCanvas);

  Sysutils.FreeAndNil(FBufferBitmap);


  Sysutils.FreeAndNil(FProperties);
  inherited;

//  uBaseLog.HandleException(nil,'TSkinWindowsControl.Destroy End '+Name);

end;


function TSkinWindowsControl.LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;
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

function TSkinWindowsControl.GetPropJsonStr:String;
begin
  Result:=Self.Properties.GetPropJsonStr;
end;

procedure TSkinWindowsControl.SetPropJsonStr(AJsonStr:String);
begin
  Self.Properties.SetPropJsonStr(AJsonStr);
end;

////设置属性
//function TSkinWindowsControl.GetProp(APropName:String):Variant;
//begin
//  Result:='';
//end;
//
//procedure TSkinWindowsControl.SetProp(APropName:String;APropValue:Variant);
//begin
//end;



function TSkinWindowsControl.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                                          var AErrorMessage:String):Variant;
begin
  Result:='';//GetCaption;
end;

procedure TSkinWindowsControl.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                                              //要设置多个值,整个字段的记录
                                              AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
  //Caption:='';//AValue;
end;

procedure TSkinWindowsControl.DoReturnFrame(AFromFrame:TFrame);
begin

end;


procedure TSkinWindowsControl.Paint(DC: HDC;EnableBuffer: Boolean);
var
  ACanvas:TDrawCanvas;
begin
//    OutputDebugString('TSkinWindowsControl.Paint '+ClassName+' '+Name);

    if EnableBuffer
      and
      (GetBufferBitmap<>nil) then
    begin

      if (Self.GetBufferBitmap.Width<>Self.Width)
        or (Self.GetBufferBitmap.Height<>Self.Height) then
      begin
        Self.GetBufferBitmap.CreateBufferBitmap(Self.Width,Self.Height);
      end;
      ACanvas:=Self.FBufferBitmap.DrawCanvas;

    end
    else
    begin

      if FCanvas=nil then
      begin
        FCanvas:=CreateDrawCanvas('TSkinWindowsControl.Paint '+ClassName+' '+Name);
      end;

      if FCanvas<>nil then
      begin
        FCanvas.Prepare(DC);
      end;

      ACanvas:=FCanvas;
    end;




      //绘制父控件背景
      if (Self.GetCurrentUseMaterial<>nil) then
      begin
        if TSkinControlMaterial(Self.GetCurrentUseMaterial).IsTransparent then
        begin
          DrawParent(Self,ACanvas.Handle,
                              0,0,Self.Width,Self.Height,
                              0,0);
        end;
      end;



      if (GetSkinControlType<>nil) then
      begin
        //绘制
        FPaintData:=GlobalNullPaintData;
        FPaintData.IsDrawInteractiveState:=True;
        FPaintData.IsInDrawDirectUI:=False;
        TSkinControlType(Self.GetSkinControlType).Paint(ACanvas,
                            GetSkinControlType.GetPaintCurrentUseMaterial,
                            RectF(0,0,Self.Width,Self.Height)
                            ,FPaintData);
      end;




      //设计时绘制虚线框和控件名称
      if csDesigning in Self.ComponentState then
      begin
        ACanvas.DrawDesigningRect(RectF(0,0,Self.Width,Self.Height),GlobalNormalDesignRectBorderColor);
        ACanvas.DrawDesigningText(RectF(0,0,Width,Height),Self.Name);
      end;




      if EnableBuffer
        and
        (GetBufferBitmap<>nil) then
      begin
        //绘制到界面上
        Bitblt(DC,0,0,
               Self.FBufferBitmap.Width,
               Self.FBufferBitmap.Height,
               ACanvas.Handle,
               0,0,
               SRCCOPY);
      end
      else
      begin
        ACanvas.UnPrepare;
      end;



end;

procedure TSkinWindowsControl.PaintWindow(DC: HDC);
begin
  Paint(DC
          ,True
//          ,False
          );
end;

//procedure TSkinWindowsControl.Resize;
//begin
//  inherited;
//  if GetSkinControlType<>nil then
//  begin
//    TSkinControlType(GetSkinControlType).SizeChanged;
//  end;
//end;

procedure TSkinWindowsControl.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
//  Inherited;

  //自己处理
//  if Not (csDesigning in Self.ComponentState) then
//  begin
    Message.Result:=1;
    EraseBackGnd(Message.DC);
//  end;
end;

procedure TSkinWindowsControl.WMLButtonDown(var Message:TWMLButtonDown);
begin
  if Self.FMouseDownFocus then
  begin
    if Self.CanFocus then
    begin
      Self.SetFocus;
    end;
  end;
  Inherited;
end;

procedure TSkinWindowsControl.WMPaint(var Message: TWMPaint);
begin
  Self.ControlState:=Self.ControlState+[csCustomPaint];
  inherited;
  Self.ControlState:=Self.ControlState-[csCustomPaint];
end;

procedure TSkinWindowsControl.WMSize(var Message: TWMSize);
begin
  Inherited;
  Invalidate;
end;

procedure TSkinWindowsControl.Invalidate;
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


//  uBaseLog.HandleException(nil,'TSkinWindowsControl.Invalidate '+Self.Name);

  if Self.FDirectUIParentIntf=nil then
  begin

//    if (Self.Parent<>nil) then
//    begin
//      //有区域更新接口
//      if Self.Parent.GetInterface(IID_IDirectUIParent,ADirectUIParentIntf) then
//      begin
//        ADirectUIParentIntf.UpdateDirectUIControl(Self,Self as IDirectUIControl);
//      end
//      else
//      begin
//        Inherited Invalidate;
//      end;
//    end
//    else
//    begin
      Inherited Invalidate;
//    end;
  end
  else
  begin
    Self.FDirectUIParentIntf.UpdateChild(Self,Self as IDirectUIControl);
  end;
end;


procedure TSkinWindowsControl.EraseBackGnd(DC: HDC);
begin
end;


procedure TSkinWindowsControl.RecordControlLangIndex(APrefix:String;ALang:TLang;ACurLang:String);
begin
  if Caption<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.Caption',ACurLang,Caption);
  end;
end;

procedure TSkinWindowsControl.TranslateControlLang(APrefix:String;ALang:TLang;ACurLang:String);
begin
  if GetLangValue(ALang,APrefix+Name+'.Caption',ACurLang)<>'' then
  begin
    Caption:=GetLangValue(ALang,APrefix+Name+'.Caption',ACurLang);
  end;
end;

function TSkinWindowsControl.GetBufferBitmap: TBufferBitmap;
begin
  if (FBufferBitmap=nil) then
  begin
    FBufferBitmap:=TBufferBitmap.Create;
  end;
  Result:=Self.FBufferBitmap;
end;

procedure TSkinWindowsControl.CMInvalidateInParentWMSize(var Message: TMessage);
begin
  Inherited;
  Invalidate;
end;

procedure TSkinWindowsControl.CMTextChanged(var Message: TMessage);
begin
  Inherited;
  if GetSkinControlType<>nil then
  begin
    TSkinControlType(GetSkinControlType).TextChanged;
  end;
end;


procedure TSkinWindowsControl.SetCaption(const Value:String);
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

function TSkinWindowsControl.GetCaption:String;
begin
  Result:=Inherited Caption;
end;

//function TSkinWindowsControl.GetHitTestValue:Integer;
//begin
//  Result:=FHitTestValue;
//end;
//
//function TSkinWindowsControl.GetNeedHitTest:Boolean;
//begin
//  Result:=FNeedHitTest;
//end;


end.


