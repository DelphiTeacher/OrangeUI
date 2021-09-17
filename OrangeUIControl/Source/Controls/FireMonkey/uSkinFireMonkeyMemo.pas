//备注框//
//convert pas to utf8 by ¥
unit uSkinFireMonkeyMemo;

interface
{$I FrameWork.inc}

{$I FMXMemo.inc}


uses
  SysUtils,
  uFuncCommon,
  Classes,
  uBaseLog,
  UITypes,
  Math,
  DB,
  Types,
  FMX.Dialogs,
  FMX.Types,
  FMX.Controls,
  FMX.StdCtrls,
  FMX.Memo,
  FMX.Forms,
  FMX.Styles.Objects,
  FMX.Graphics,
  FMX.Objects,
  FMX.Layouts,

  uLang,
  uSkinItems,
  uSkinPublic,
  uSkinMaterial,
  uComponentType,
  uBasePageStructure,
  uVersion,
  uBaseList,
  uDrawPicture,
  uBinaryTreeDoc,
  uSkinMemoType,
  uDrawEngine,
  uGraphicCommon,
  uDrawCanvas,
//  uSkinPackage,
  uSkinFireMonkeyStyledMemo,

  uSkinFireMonkeyControl,

//  {$IF CompilerVersion >= 29.0}
  FMX.Memo.Style,
  FMX.Controls.Presentation,
  FMX.Presentation.Factory,
//  {$ENDIF}
//  {$IF CompilerVersion >= 30.0}//>=XE10
  FMX.Presentation.Style,
//  {$ENDIF}


  {$IF CompilerVersion >= 30.0}//>=XE10

  {$IFDEF IOS}
  FMX.Memo.iOS,
  FMX.Presentation.iOS,
  uSkinFireMonkeyiOSNativeMemo,
  {$ENDIF}

  {$ENDIF}


  uDrawTextParam,
  uSkinRegManager,
  uSkinPicture,
  uSkinBufferBitmap;


Type
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXCustomMemo=class(TMemo,
                            ISkinMemo,
                            ISkinControl,
                            ISkinControlMaterial,
                            IDirectUIControl,
                            ILangProcess,
                            ICustomListItemEditor,
                            IBindSkinItemTextControl,
                            IBindSkinItemValueControl,
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

    {$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Declare_FMX.inc}
    {$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Declare_FMX.inc}
  protected

    function GetMemoProperties:TMemoProperties;
    procedure SetMemoProperties(Value:TMemoProperties);
  protected
    procedure BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  protected
    FIsInScrollBox:Boolean;
  protected
    procedure EditSetValue(const AValue:String);
    function EditGetValue:String;
    procedure EditMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
    procedure EditMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
    procedure EditMouseMove(Shift: TShiftState; X, Y: Double);

  protected
    FContent: TControl;

  protected

    //背景
    FStyleObj_background: TControl;
    FStyleObj_foreground: TFmxObject;

    procedure ApplyStyle; override;
    procedure FreeStyle; override;
    procedure DoPaintBackGround(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure AdjustFixedSize(const Ref: TControl); override;



  protected
    function DefinePresentationName: string;
//    {$IF CompilerVersion >= 29.0}
    override;
//    {$ENDIF}
    function GetDefaultStyleLookupName: string; override;

  public
    //记录多语言的索引
    procedure RecordControlLangIndex(APrefix:String;ALang:TLang;ACurLang:String);virtual;
    //翻译
    procedure TranslateControlLang(APrefix:String;ALang:TLang;ACurLang:String);virtual;
  public
    //针对页面框架的控件接口
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting):Boolean;virtual;
//    //获取合适的高度
//    function GetSuitDefaultItemHeight:Double;
    //获取与设置自定义属性
    function GetPropJsonStr:String;
    procedure SetPropJsonStr(AJsonStr:String);

    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
    //设置属性
    function GetProp(APropName:String):Variant;
    procedure SetProp(APropName:String;APropValue:Variant);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
//    {$IF CompilerVersion >= 29.0}
    //用于设置自定义的菜单项
    function GetReceiver: TObject;
  public
    function GetStyleEdit: TSkinFMXStyledMemo;
    function GetEditContentMarginsIntf: IEditContentMargins;
//    {$ENDIF}
    function GetText:String;
    function GetMemoMaxLength:Integer;
    procedure SetIsAutoHeight(const Value:Boolean);
    procedure DoAutoHeightMemoChange(Sender:TObject);
    //刷新控件
    procedure Invalidate;
    //是否只读
    function IsReadOnly:Boolean;
  public
    function SelfOwnMaterialToDefault:TSkinMemoDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinMemoDefaultMaterial;
    function Material:TSkinMemoDefaultMaterial;

  public
    //wn

    //是否不显示默认的弹出菜单
    IsHideDefaultMenu:Boolean;

    //是否不显示默认的复制按钮
    IsHideDefaultCopyMenu:Boolean;

    CustomMenu1Caption: String;
    CustomMenu2Caption: String;
    CustomMenu3Caption: String;

    OnCustomMenu1:TNotifyEvent;
    OnCustomMenu2:TNotifyEvent;
    OnCustomMenu3:TNotifyEvent;


  public
    property Prop:TMemoProperties read GetMemoProperties write SetMemoProperties;
  published
    property IsInScrollBox:Boolean read FIsInScrollBox write FIsInScrollBox;
    //属性
    property MemoProperties:TMemoProperties read GetMemoProperties write SetMemoProperties;
    property Properties:TMemoProperties read GetMemoProperties write SetMemoProperties;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXMemo=class(TSkinFMXCustomMemo)
  private
    FIsSetedStyleType:Boolean;
  protected
    procedure Loaded;override;
  end;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinMemo=class(TSkinFMXMemo)
  end;




var
  //统一在项目用原生Memo
  GlobalIsUseNativeMemoOnIOS:Boolean;
  GlobalSkinFMXMemoList:TBaseList;
  SetGlobalMemoListTypeCount:Integer;

procedure SetGlobalMemoListAsStyleType;
procedure RestoreGlobalMemoListAsPlatformType;



implementation



procedure SetGlobalMemoListAsStyleType;
var
  I:Integer;
begin
  {$IFDEF IOS}
//  if GlobalIsUseNativeMemoOnIOS then
//  begin
    FMX.Types.Log.d('OrangeUI SetGlobalMemoListAsStyleType GlobalSkinFMXMemoList.Count '+IntToStr(GlobalSkinFMXMemoList.Count));

    Inc(SetGlobalMemoListTypeCount);
//    if SetGlobalMemoListTypeCount=1 then//去掉这一个判断,避免设置不到
//    begin
      for I := 0 to GlobalSkinFMXMemoList.Count-1 do
      begin
        FMX.Types.Log.d('OrangeUI SetGlobalMemoListAsStyleType GlobalSkinFMXMemoList Name '+TSkinFMXMemo(GlobalSkinFMXMemoList[I]).Name
            +' Type '+IntToStr(Ord(TSkinFMXMemo(GlobalSkinFMXMemoList[I]).ControlType)) );
        if TSkinFMXMemo(GlobalSkinFMXMemoList[I]).ControlType=FMX.Controls.TControlType.Platform then
        begin
            FMX.Types.Log.d('OrangeUI SetGlobalMemoListAsStyleType GlobalSkinFMXMemoList.Count '+IntToStr(I));

            TSkinFMXMemo(GlobalSkinFMXMemoList[I]).FIsSetedStyleType:=True;
            TSkinFMXMemo(GlobalSkinFMXMemoList[I]).ControlType:=FMX.Controls.TControlType.Styled;

        end;
      end;
//    end;
//  end;
  {$ENDIF}
end;


procedure RestoreGlobalMemoListAsPlatformType;
var
  I:Integer;
begin
  {$IFDEF IOS}
//  if GlobalIsUseNativeMemoOnIOS then
//  begin
    Dec(SetGlobalMemoListTypeCount);

    FMX.Types.Log.d('OrangeUI RestoreGlobalMemoListAsPlatformType SetGlobalMemoListTypeCount '+IntToStr(SetGlobalMemoListTypeCount));


    if SetGlobalMemoListTypeCount=0 then
    begin
      for I := 0 to GlobalSkinFMXMemoList.Count-1 do
      begin
        if TSkinFMXMemo(GlobalSkinFMXMemoList[I]).FIsSetedStyleType
          and (TSkinFMXMemo(GlobalSkinFMXMemoList[I]).ControlType=FMX.Controls.TControlType.Styled) then
        begin

            FMX.Types.Log.d('OrangeUI RestoreGlobalMemoListAsPlatformType');
            TSkinFMXMemo(GlobalSkinFMXMemoList[I]).FIsSetedStyleType:=False;
            TSkinFMXMemo(GlobalSkinFMXMemoList[I]).ControlType:=FMX.Controls.TControlType.Platform;

        end;
      end;
    end;
//  end;
  {$ENDIF}
end;


{ TSkinFMXMemo }

//系统自带的
procedure TSkinFMXMemo.Loaded;
begin
  {$IFNDEF IOS}
  if ControlType=FMX.Controls.TControlType.Platform then
  begin
    ControlType:=FMX.Controls.TControlType.Styled;
  end;
  {$ENDIF}
  {$IFDEF IOS}
  if GlobalIsUseNativeMemoOnIOS and (ControlType=FMX.Controls.TControlType.Styled) then
  begin
    StyleLookup:='transparentmemo';
    ControlType:=FMX.Controls.TControlType.Platform;
  end;
  {$ENDIF}

  inherited;

  {$IF CompilerVersion >= 30.0}//>=XE10
  {$IFDEF IOS}
  //设置边距
  if (PresentationProxy<>nil)
    and (PresentationProxy.Receiver<>nil)
    and (PresentationProxy.Receiver is TSkinFMXiOSNativeMemo)
     then
  begin
    TSkinFMXiOSNativeMemo(PresentationProxy.Receiver).ContentMarginsLeft:=FContentMarginsLeft;
    TSkinFMXiOSNativeMemo(PresentationProxy.Receiver).ContentMarginsTop:=FContentMarginsTop;
    TSkinFMXiOSNativeMemo(PresentationProxy.Receiver).ContentMarginsRight:=FContentMarginsRight;
    TSkinFMXiOSNativeMemo(PresentationProxy.Receiver).ContentMarginsBottom:=FContentMarginsBottom;
  end;
  {$ENDIF}
  {$ENDIF}

end;




{ TSkinFMXCustomMemo }

{$I Source\Controls\INC\FMX\ISkinControl_Caption_Impl_Code_FMX.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Code.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Code.inc}
{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Code_FMX.inc}
{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Mouse_Code_FMX.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_DirectUI_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Code.inc}



{$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Edit_Impl_Code_FMX.inc}
{$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Edit_Impl_Code_FMX.inc}


function TSkinFMXCustomMemo.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TMemoProperties;
end;

function TSkinFMXCustomMemo.SelfOwnMaterialToDefault:TSkinMemoDefaultMaterial;
begin
  Result:=TSkinMemoDefaultMaterial(SelfOwnMaterial);
end;

function TSkinFMXCustomMemo.Material:TSkinMemoDefaultMaterial;
begin
  Result:=TSkinMemoDefaultMaterial(SelfOwnMaterial);
end;

procedure TSkinFMXCustomMemo.RecordControlLangIndex(APrefix: String; ALang: TLang;
  ACurLang: String);
begin

  if Self.Prop.HelpText<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.HelpText',ACurLang,Self.Prop.HelpText);
  end;

end;

function TSkinFMXCustomMemo.CurrentUseMaterialToDefault:TSkinMemoDefaultMaterial;
begin
  Result:=TSkinMemoDefaultMaterial(CurrentUseMaterial);
end;

procedure TSkinFMXCustomMemo.AdjustFixedSize(const Ref: TControl);
begin

  if AniCalculations<>nil then
  begin
    Self.AniCalculations.BoundsAnimation:=False;
  end;

end;

function TSkinFMXCustomMemo.GetDefaultStyleLookupName: string;
begin
  Result:='MemoStyle';
end;

function TSkinFMXCustomMemo.DefinePresentationName: string;
begin
//  {$IF CompilerVersion >= 29.0}
//  if GetPresentationSuffix='style' then
//  begin
    Result := 'SkinFMXMemo-' + GetPresentationSuffix;
//  end
//  else
//  begin
//    Result:=Inherited;
//  end;
//  {$ENDIF}
end;

//{$IF CompilerVersion >= 29.0}

function TSkinFMXCustomMemo.GetEditContentMarginsIntf: IEditContentMargins;
begin
  Result:=nil;
  if (PresentationProxy<>nil)
    and (PresentationProxy.Receiver<>nil)
     then
  begin
    PresentationProxy.Receiver.GetInterface(IID_IEditContentMargins,Result);
  end;
end;

function TSkinFMXCustomMemo.GetReceiver: TObject;
begin
  Result:=nil;
  if (PresentationProxy<>nil)
     then
  begin
    Result:=(PresentationProxy.Receiver);
  end;
end;

function TSkinFMXCustomMemo.GetStyleEdit: TSkinFMXStyledMemo;
begin
  Result:=nil;
  if (PresentationProxy<>nil)
    and (PresentationProxy.Receiver<>nil)
    and (PresentationProxy.Receiver is TSkinFMXStyledMemo)
     then
  begin
    Result:=TSkinFMXStyledMemo(PresentationProxy.Receiver);
  end;
end;
//{$ENDIF}

procedure TSkinFMXCustomMemo.Invalidate;
begin
  if FStyleObj_background<>nil then
  begin
    FStyleObj_background.RePaint;
  end;
end;

function TSkinFMXCustomMemo.IsReadOnly:Boolean;
begin
  Result:=ReadOnly;
end;

procedure TSkinFMXCustomMemo.ApplyStyle;
var
  I,J: Integer;
begin
  inherited;

  FContent := TControl(FindStyleResource('content'));
  if (FContent<>nil) and (FContent.Parent<>nil) then
  begin
    if FContentMarginsLeft>0 then
    begin
      TControl(FContent.Parent).Padding.Left:=FContentMarginsLeft;
    end;
    if FContentMarginsTop>0 then
    begin
      TControl(FContent.Parent).Padding.Top:=FContentMarginsTop;
    end;
    if FContentMarginsRight>0 then
    begin
      TControl(FContent.Parent).Padding.Right:=FContentMarginsRight;
    end;
    if FContentMarginsBottom>0 then
    begin
      TControl(FContent.Parent).Padding.Bottom:=FContentMarginsBottom;
    end;
  end;

  if FIsUseDefaultStyle then Exit;


  //去掉背景框
  for I := 0 to Self.ChildrenCount-1 do
  begin

    for J :=  0 to Self.Children[I].ChildrenCount-1  do
    begin

      if Self.Children[I].Children[J].StyleName='background' then
      begin
        //背景
        FStyleObj_background:=TControl(Self.Children[I].Children[J]);
        ClearStyleObjectVisiualElement(FStyleObj_background,'Memo');
//        FStyleObj_background.OnPainting:=Self.DoPaintBackGround;

      end;
    end;
  end;
end;

procedure TSkinFMXCustomMemo.DoPaintBackGround(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
var
  ASkinMaterial:TSkinControlMaterial;
begin
    FCanvas.Prepare(Canvas);

    if (GetSkinControlType<>nil) then
    begin
      ASkinMaterial:=GetSkinControlType.GetPaintCurrentUseMaterial;
    end;

    //绘制
    if GetSkinControlType<>nil then
    begin
      FPaintData:=GlobalNullPaintData;
      FPaintData.IsDrawInteractiveState:=True;
      FPaintData.IsInDrawDirectUI:=False;
      GetSkinControlType.Paint(FCanvas,ASkinMaterial,RectF(0,0,Self.Width,Self.Height),FPaintData);
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
      Canvas.FillText(RectF(0,0,Width,Height),Self.BindItemFieldName,True,0.6,[],TTextAlign.{$IF CompilerVersion >= 34.0}Leading{$ELSE}taLeading{$IFEND},TTextAlign.{$IF CompilerVersion >= 34.0}Leading{$ELSE}taLeading{$IFEND});
    end;

    FCanvas.UnPrepare;

end;

procedure TSkinFMXCustomMemo.FreeStyle;
begin
  FContent:=nil;
  FStyleObj_background:=nil;
  FreeAndNil(FStyleObj_foreground);
  inherited;
end;

constructor TSkinFMXCustomMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  if AniCalculations<>nil then
  begin
    Self.AniCalculations.BoundsAnimation:=False;
  end;

  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Create_Code.inc}


  FIsInScrollBox:=False;


  //创建控件属性
  FProperties:=Self.GetPropertiesClassType.Create(Self);

  FParentMouseEvent:=False;
  FMouseEventTransToParentType:=mettptAuto;

  SetAcceptsControls(True);


  {$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Init_Code_FMX.inc}
  {$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Init_Code_FMX.inc}


  //一定要在OnPainting事件中,
  //不然Text会被背景颜色背景图片覆盖
  Self.OnPainting:=Self.DoPaintBackGround;


  Self.StyledSettings:=Self.StyledSettings-[TStyledSetting.Size];


  GlobalSkinFMXMemoList.Add(Self);



  //wn 测试自定义弹出按钮
//  CustomMenu1Caption:='Custom1';
//  CustomMenu2Caption:='Custom2';
//  CustomMenu3Caption:='Custom3';


end;

destructor TSkinFMXCustomMemo.Destroy;
begin

  GlobalSkinFMXMemoList.Remove(Self,False);


  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Destroy_Code.inc}

  FreeAndNil(FProperties);
  FreeAndNil(FCanvas);
  inherited;
end;

function TSkinFMXCustomMemo.GetMemoProperties: TMemoProperties;
begin
  Result:=TMemoProperties(Self.FProperties);
end;

procedure TSkinFMXCustomMemo.SetMemoProperties(Value: TMemoProperties);
begin
  Self.FProperties.Assign(Value);
end;

function TSkinFMXCustomMemo.LoadFromFieldControlSetting(ASetting:TFieldControlSetting):Boolean;
begin
//  SetMaterialUseKind(TMaterialUseKind.mukRefByStyleName);
//  SetMaterialName(ASetting.ControlStyle);


  Self.Prop.IsDrawHelpWhenFocused:=True;

//  if ASetting.input_format='number' then//:String;//	nvarchar(45)	输入格式要求，保存的时候要使用,相关的控件是edit,comboedit
//  //		number,只允许输入数字
//  //		decimal,只允许输入数字
//  //		email,必须是email
//  //		phone,必须是手机号
//  begin
//    //不带小数
//    Self.FilterChar:='01234567890';
//    Self.KeyboardType:=TVirtualKeyboardType.NumberPad;
//  end
//  else if ASetting.input_format='decimal' then
//  begin
//    //带小数
//    Self.FilterChar:='01234567890.';
//    Self.KeyboardType:=TVirtualKeyboardType.DecimalNumberPad;
//  end
//  else if ASetting.input_format='phone' then
//  begin
//    //手机
//    Self.KeyboardType:=TVirtualKeyboardType.PhonePad;
//  end
//  else
//  begin
//    Self.FilterChar:='';
//    Self.KeyboardType:=TVirtualKeyboardType.Default;
//  end;
  Self.Prop.HelpText:=ASetting.input_prompt;//:String;//	nvarchar(255)	输入提示,比如请输入密码
  Self.MaxLength:=ASetting.input_max_length;//:Integer;//	int	输入字符串的最大长度
  Self.ReadOnly:=(ASetting.input_read_only=1);//:Integer;//	int	是否只读




  Result:=True;
end;

function TSkinFMXCustomMemo.GetPropJsonStr:String;
begin
  Result:=Self.Properties.GetPropJsonStr;
end;

procedure TSkinFMXCustomMemo.SetPropJsonStr(AJsonStr:String);
begin
  Self.Properties.SetPropJsonStr(AJsonStr);
end;

function TSkinFMXCustomMemo.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
begin
  Result:=Self.Text;
end;

procedure TSkinFMXCustomMemo.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
  Text:=AValue;
end;

//设置属性
function TSkinFMXCustomMemo.GetProp(APropName:String):Variant;
begin

end;

procedure TSkinFMXCustomMemo.SetProp(APropName:String;APropValue:Variant);
begin

end;

//function TSkinFMXCustomMemo.GetSuitDefaultItemHeight:Double;
//begin
//  Result:=100;
//end;

procedure TSkinFMXCustomMemo.TranslateControlLang(APrefix: String; ALang: TLang;
  ACurLang: String);
begin

  if GetLangValue(ALang,APrefix+Name+'.HelpText',ACurLang)<>'' then
  begin
    Prop.HelpText:=GetLangValue(ALang,APrefix+Name+'.HelpText',ACurLang);
  end;

end;

function TSkinFMXCustomMemo.GetText:String;
begin
  Result:=Text;
end;

function TSkinFMXCustomMemo.GetMemoMaxLength:Integer;
begin
  Result:=Self.MaxLength;
end;

procedure TSkinFMXCustomMemo.SetIsAutoHeight(const Value:Boolean);
begin
  if Value then
  begin
    Self.OnChange:=DoAutoHeightMemoChange;
    Self.OnChangeTracking:=DoAutoHeightMemoChange;
  end
  else
  begin
    Self.OnChange:=nil;
    Self.OnChangeTracking:=nil;
  end;
end;

procedure TSkinFMXCustomMemo.DoAutoHeightMemoChange(Sender:TObject);
var
  ADrawRect:TRectF;
  ADrawHeight:Double;
  ALineCount:Integer;
  AOneLineHeight:Double;
begin
  ADrawRect:=RectF(0,0,Width,MaxInt);
  ADrawRect.Left:=ADrawRect.Left+Self.FContentMarginsLeft;
  ADrawRect.Top:=ADrawRect.Top+Self.FContentMarginsTop;
  ADrawRect.Right:=ADrawRect.Right-Self.FContentMarginsRight;

  GetGlobalDrawTextParam.FontName:=Self.TextSettings.Font.Family;
  GetGlobalDrawTextParam.FontSize:=Self.TextSettings.Font.Size;
  GetGlobalDrawTextParam.IsWordWrap:=Self.TextSettings.WordWrap;
  ADrawHeight:=uSkinBufferBitmap.GetStringHeight(
                                  Self.Text,
                                  ADrawRect,
                                  GetGlobalDrawTextParam
                                  );

  if Self.Prop.AutoHeightMaxLineCount>0 then
  begin
    //单行高
    AOneLineHeight:=uSkinBufferBitmap.GetStringHeight(
                                  '行',
                                  ADrawRect,
                                  GetGlobalDrawTextParam
                                  );
    ALineCount:=Ceil(ADrawHeight/AOneLineHeight);

    //当前光标在第几行,有时Text只有一行,但光标在第二行
    if Self.CaretPosition.Line+1>ALineCount then
    begin
      ALineCount:=Self.CaretPosition.Line+1;
    end;

    //不能超过最大行
    if ALineCount>Self.Prop.AutoHeightMaxLineCount then
    begin
      ALineCount:=Self.Prop.AutoHeightMaxLineCount;
    end;

    ADrawHeight:=ALineCount*AOneLineHeight
                //单行补
                +10;

  end;

  Self.Height:=ADrawHeight;
end;

procedure TSkinFMXCustomMemo.BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
begin
  Self.MemoProperties.DrawText:=AText;
end;

procedure TSkinFMXCustomMemo.SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
begin
  Self.MemoProperties.DrawText:=AFieldValue;
end;

function TSkinFMXCustomMemo.EditGetValue:String;
begin
  Result:=Self.Text;
end;

procedure TSkinFMXCustomMemo.EditSetValue(const AValue:String);
begin
  Self.Text:=AValue;
end;

procedure TSkinFMXCustomMemo.EditMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
end;

procedure TSkinFMXCustomMemo.EditMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
end;

procedure TSkinFMXCustomMemo.EditMouseMove(Shift: TShiftState; X, Y: Double);
begin
end;





initialization
  SetGlobalMemoListTypeCount:=0;
  GlobalIsUseNativeMemoOnIOS:=False;
  GlobalSkinFMXMemoList:=TBaseList.Create(ooReference);

  {$IF CompilerVersion = 29.0}
  TPresentationProxyFactory.Current.Unregister('SkinFMXMemo-style');
  TPresentationProxyFactory.Current.Register('SkinFMXMemo-style', TSkinFMXStyledMemoProxy);
  {$ENDIF}
  {$IF CompilerVersion >= 30.0}//>=XE10
  TPresentationProxyFactory.Current.Register(TSkinFMXMemo, TControlType.Styled, TStyledPresentationProxy<TSkinFMXStyledMemo>);
  {$ENDIF}

finalization
  {$IF CompilerVersion = 29.0}
  TPresentationProxyFactory.Current.Unregister('SkinFMXMemo-style');
  {$ENDIF}
  {$IF CompilerVersion >= 30.0}//>=XE10
  TPresentationProxyFactory.Current.Unregister(TSkinFMXMemo, TControlType.Styled, TStyledPresentationProxy<TSkinFMXStyledMemo>);
  {$ENDIF}


  FreeAndNil(GlobalSkinFMXMemoList);


end.









