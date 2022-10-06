//convert pas to utf8 by ¥
//下拉编辑框//
unit uSkinFireMonkeyComboEdit;

interface
{$I FrameWork.inc}

{$I FMXComboEdit.inc}


uses
  SysUtils,
  uFuncCommon,
  Classes,
  uBaseLog,
  UITypes,
  Math,
  Types,
  uLang,
  DB,
  FMX.Dialogs,
  FMX.Types,
  FMX.Controls,
  FMX.StdCtrls,
  FMX.Edit,
  uSkinItems,
  uDrawPicture,
  uGraphicCommon,
  FMX.Forms,
  FMX.Styles.Objects,
  FMX.Graphics,
  uSkinPublic,
  uSkinMaterial,
  uComponentType,
  uVersion,
  uSkinPicture,
  uBinaryTreeDoc,
  uSkinComboEditType,
  uDrawEngine,
  uDrawCanvas,
  uBasePageStructure,
//  uSkinPackage,
  uBaseList,
  FMX.Text,
  FMX.Objects,
  FMX.ComboEdit,
  uSkinFireMonkeyStyledComboEdit,

  uSkinFireMonkeyControl,

  FMX.ComboEdit.Style,
  FMX.Controls.Presentation,
  FMX.Presentation.Factory,
  {$IF CompilerVersion >= 30.0}//>=XE10
  FMX.Presentation.Style,
  {$ENDIF}
  uSkinRegManager,
  uSkinBufferBitmap;






Type
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXCustomComboEdit=class(TComboEdit,
                          ISkinComboEdit,
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
  private
    FValues:TStringList;
    procedure SetValues(const AValue:TStringList);
    function GetValue:String;
    procedure SetValue(const Value:String);
  protected
    procedure BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  protected
    procedure EditSetValue(const AValue:String);
    function EditGetValue:String;
    procedure EditMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
    procedure EditMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
    procedure EditMouseMove(Shift: TShiftState; X, Y: Double);
  protected
    function GetComboEditProperties:TComboEditProperties;
    procedure SetComboEditProperties(Value:TComboEditProperties);
  protected
    function GetDefaultStyleLookupName: string; override;
    function DefinePresentationName: string;override;
  protected
    //InScrollBox属性实现
    FIsInScrollBox:Boolean;


    //在ListBox中的Item时点击自动编辑列表项
    FIsAutoEditInItem:Boolean;
    procedure AdjustFixedSize(const Ref: TControl); override;
  public
    //语录多语言的标记
    procedure RecordControlLangIndex(APrefix:String;ALang:TLang;ACurLang:String);virtual;
    //翻译
    procedure TranslateControlLang(APrefix:String;ALang:TLang;ACurLang:String);virtual;
  public
    //针对页面框架的控件接口
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;virtual;
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
//    //设置属性
//    function GetProp(APropName:String):Variant;
//    procedure SetProp(APropName:String;APropValue:Variant);
    procedure DoReturnFrame(AFromFrame:TFrame);virtual;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    function GetStyleEdit: TSkinFMXStyledComboEdit;
    function GetEditContentMarginsIntf: IEditContentMargins;
  public
    //刷新控件
    procedure Invalidate;

    /// <summary>
    ///   获取文本
    /// </summary>
    function GetText:String;
    //是否只读
    function IsReadOnly:Boolean;
  public
    function SelfOwnMaterialToDefault:TSkinComboEditDefaultMaterial;
    function Material:TSkinComboEditDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinComboEditDefaultMaterial;
  public
    property Value:String read GetValue write SetValue;
    property Prop:TComboEditProperties read GetComboEditProperties write SetComboEditProperties;
  published
    /// <summary>
    ///   是否在文本框中
    /// </summary>
    property IsInScrollBox:Boolean read FIsInScrollBox write FIsInScrollBox;
    //在列表项中自动启动编辑
    property IsAutoEditInItem:Boolean read FIsAutoEditInItem write FIsAutoEditInItem;
  published
    property Values:TStringList read FValues write SetValues;
    //属性
    property ComboEditProperties:TComboEditProperties read GetComboEditProperties write SetComboEditProperties;
    property Properties:TComboEditProperties read GetComboEditProperties write SetComboEditProperties;
  end;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinComboEdit=class(TSkinFMXCustomComboEdit)
  private
    FIsSetedStyleType:Boolean;
  public
    procedure StayClick;override;
  end;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXComboEdit=class(TSkinComboEdit)
  end;

implementation





{ TSkinFMXCustomComboEdit }

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

function TSkinFMXCustomComboEdit.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TComboEditProperties;
end;

function TSkinFMXCustomComboEdit.SelfOwnMaterialToDefault:TSkinComboEditDefaultMaterial;
begin
  Result:=TSkinComboEditDefaultMaterial(SelfOwnMaterial);
end;

function TSkinFMXCustomComboEdit.Material:TSkinComboEditDefaultMaterial;
begin
  Result:=TSkinComboEditDefaultMaterial(SelfOwnMaterial);
end;

procedure TSkinFMXCustomComboEdit.RecordControlLangIndex(APrefix: String; ALang: TLang; ACurLang: String);
var
  I: Integer;
begin

  for I := 0 to Self.Items.Count-1 do
  begin
    if Self.Items[I]<>'' then
    begin
      RecordLangIndex(ALang,APrefix+Name+'.Items['+IntToStr(I)+']',ACurLang,Self.Items[I]);
    end;
  end;

  if Self.Prop.HelpText<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.HelpText',ACurLang,Self.Prop.HelpText);
  end;

end;

function TSkinFMXCustomComboEdit.CurrentUseMaterialToDefault:TSkinComboEditDefaultMaterial;
begin
  Result:=TSkinComboEditDefaultMaterial(CurrentUseMaterial);
end;

function TSkinFMXCustomComboEdit.DefinePresentationName: string;
begin
  if GetPresentationSuffix='style' then
  begin
    Result := 'SkinFMXCustomComboEdit-' + GetPresentationSuffix;
  end
  else
  begin
    Result:=Inherited;
  end;
end;

function TSkinFMXCustomComboEdit.GetDefaultStyleLookupName: string;
begin
  Result:='ComboEditStyle';
end;

function TSkinFMXCustomComboEdit.GetText:String;
begin
  Result:=Text;
end;

procedure TSkinFMXCustomComboEdit.SetValue(const Value:String);
begin
  Self.ItemIndex:=Self.Values.Indexof(Value);
end;

function TSkinFMXCustomComboEdit.GetValue:String;
begin
  Result:='';
  if (Self.Count>0) and (Self.ItemIndex<>-1) then
  begin
    Result:=Self.Values[Self.ItemIndex];
  end;
end;

function TSkinFMXCustomComboEdit.IsReadOnly:Boolean;
begin
  Result:=ReadOnly;
end;

procedure TSkinFMXCustomComboEdit.AdjustFixedSize(const Ref: TControl);
begin
end;

procedure TSkinFMXCustomComboEdit.Invalidate;
begin
  RePaint;
end;

constructor TSkinFMXCustomComboEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FValues:=TStringList.Create;


  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Create_Code.inc}


  FIsInScrollBox:=False;

  //创建控件属性
  FProperties:=Self.GetPropertiesClassType.Create(Self);

  FParentMouseEvent:=False;
  FMouseEventTransToParentType:=mettptAuto;


  SetAcceptsControls(True);



  {$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Init_Code_FMX.inc}
  {$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Init_Code_FMX.inc}


  //ComboEdit和StyledComboEdit两边要同步起来
  FContentMarginsRight:=30;//右边空出来,才能让用户点击出来
end;

destructor TSkinFMXCustomComboEdit.Destroy;
begin
  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Destroy_Code.inc}
  FreeAndNil(FProperties);
  FreeAndNil(FCanvas);
  FreeAndNil(FValues);
  inherited;
end;

procedure TSkinFMXCustomComboEdit.SetValues(const AValue:TStringList);
begin
  FValues.Assign(AValue);
end;

function TSkinFMXCustomComboEdit.GetComboEditProperties: TComboEditProperties;
begin
  Result:=TComboEditProperties(Self.FProperties);
end;

procedure TSkinFMXCustomComboEdit.SetComboEditProperties(Value: TComboEditProperties);
begin
  Self.FProperties.Assign(Value);
end;

function TSkinFMXCustomComboEdit.LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;
begin
  Self.Values.CommaText:=ASetting.options_value;
  Self.Items.CommaText:=ASetting.options_caption;




  Self.Prop.IsDrawHelpWhenFocused:=True;

  if ASetting.input_format='number' then//:String;//	nvarchar(45)	输入格式要求，保存的时候要使用,相关的控件是edit,comboedit
  //		number,只允许输入数字
  //		decimal,只允许输入数字
  //		email,必须是email
  //		phone,必须是手机号
  begin
    //不带小数
    Self.FilterChar:='01234567890';
    Self.KeyboardType:=TVirtualKeyboardType.NumberPad;
  end
  else if ASetting.input_format='decimal' then
  begin
    //带小数
    Self.FilterChar:='01234567890.';
    //Self.KeyboardType:=TVirtualKeyboardType.DecimalNumberPad;
  end
  else if ASetting.input_format='phone' then
  begin
    //手机
    Self.KeyboardType:=TVirtualKeyboardType.PhonePad;
  end
  else
  begin
    Self.FilterChar:='';
    Self.KeyboardType:=TVirtualKeyboardType.Default;
  end;
  Self.Prop.HelpText:=ASetting.input_prompt;//:String;//	nvarchar(255)	输入提示,比如请输入密码
  Self.MaxLength:=ASetting.input_max_length;//:Integer;//	int	输入字符串的最大长度
  Self.ReadOnly:=(ASetting.input_read_only=1);//:Integer;//	int	是否只读




//  SetMaterialUseKind(TMaterialUseKind.mukRefByStyleName);
//  SetMaterialName(ASetting.ControlStyle);

  Result:=True;
end;

function TSkinFMXCustomComboEdit.GetPropJsonStr:String;
begin
  Result:=Self.Properties.GetPropJsonStr;
end;

procedure TSkinFMXCustomComboEdit.SetPropJsonStr(AJsonStr:String);
begin
  Self.Properties.SetPropJsonStr(AJsonStr);
end;


function TSkinFMXCustomComboEdit.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
begin
  //有Values用Value
  if (Self.ItemIndex<>-1) and (Self.ItemIndex<Self.FValues.Count) then
  begin
    Result:=Self.FValues[Self.ItemIndex];
  end
  else
  begin
    Result:=GetText;
  end;
end;

procedure TSkinFMXCustomComboEdit.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
//  Text:=AValue;
//  if (ASetting.options_caption_field_name='') or (AGetDataIntfResultFieldValueIntf=nil) then
//  begin
//    Text:=AValue;
//  end
//  else
//  begin
    //标题
    Text:=AValueCaption;//AGetDataIntfResultFieldValueIntf.GetFieldValue(ASetting.options_caption_field_name);
    //内部ID
    Value:=AValue;
//  end;
end;

////设置属性
//function TSkinFMXCustomComboEdit.GetProp(APropName:String):Variant;
//begin
//
//end;
//
//procedure TSkinFMXCustomComboEdit.SetProp(APropName:String;APropValue:Variant);
//begin
//
//end;

procedure TSkinFMXCustomComboEdit.DoReturnFrame(AFromFrame:TFrame);
begin

end;

//function TSkinFMXCustomComboEdit.GetSuitDefaultItemHeight:Double;
//begin
//
//  Result:=-1;
//end;

procedure TSkinFMXCustomComboEdit.TranslateControlLang(APrefix: String;
  ALang: TLang; ACurLang: String);
var
  I: Integer;
begin

  for I := 0 to Self.Items.Count-1 do
  begin
    if GetLangValue(ALang,APrefix+Name+'.Items['+IntToStr(I)+']',ACurLang)<>'' then
    begin
      Self.Items[I]:=GetLangValue(ALang,APrefix+Name+'.Items['+IntToStr(I)+']',ACurLang);
    end;
  end;

  if GetLangValue(ALang,APrefix+Name+'.HelpText',ACurLang)<>'' then
  begin
    Prop.HelpText:=GetLangValue(ALang,APrefix+Name+'.HelpText',ACurLang);
  end;

end;

function TSkinFMXCustomComboEdit.GetEditContentMarginsIntf: IEditContentMargins;
begin
  Result:=nil;
  if (PresentationProxy<>nil)
    and (PresentationProxy.Receiver<>nil)
     then
  begin
    PresentationProxy.Receiver.GetInterface(IID_IEditContentMargins,Result);
  end;
end;

function TSkinFMXCustomComboEdit.GetStyleEdit: TSkinFMXStyledComboEdit;
begin
  Result:=nil;
  if (PresentationProxy<>nil)
    and (PresentationProxy.Receiver<>nil)
    and (PresentationProxy.Receiver is TSkinFMXStyledComboEdit)
     then
  begin
    Result:=TSkinFMXStyledComboEdit(PresentationProxy.Receiver);
  end;
end;

procedure TSkinFMXCustomComboEdit.BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
begin
  Self.ComboEditProperties.DrawText:=AText;
end;

procedure TSkinFMXCustomComboEdit.SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
begin
  Self.ComboEditProperties.DrawText:=AFieldValue;
end;

function TSkinFMXCustomComboEdit.EditGetValue:String;
begin
  Result:=Self.Text;
end;

procedure TSkinFMXCustomComboEdit.EditSetValue(const AValue:String);
begin
  Self.Text:=AValue;
end;

procedure TSkinFMXCustomComboEdit.EditMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
  GetStyleEdit.MouseDown(Button,Shift,X,Y);
end;

procedure TSkinFMXCustomComboEdit.EditMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
  GetStyleEdit.MouseUp(Button,Shift,X,Y);

end;

procedure TSkinFMXCustomComboEdit.EditMouseMove(Shift: TShiftState; X, Y: Double);
begin
  GetStyleEdit.MouseMove(Shift,X,Y);
end;




{ TSkinComboEdit }

procedure TSkinComboEdit.StayClick;
var
  AMouseDownPt:TPointF;
begin
  inherited;

  AMouseDownPt:=Self.Prop.SkinControlIntf.GetSkinControlType.FMouseDownPt;
  if (AMouseDownPt.X>Self.Width-Self.ContentMarginsRight)
    and (AMouseDownPt.X<Self.Width) then
  begin
    Self.DropDown;
  end;

end;



initialization
  {$IF CompilerVersion < 30.0}
  TPresentationProxyFactory.Current.Unregister('SkinFMXComboEdit-style');
  TPresentationProxyFactory.Current.Register('SkinFMXComboEdit-style', TSkinFMXStyledComboEditProxy);
  {$ENDIF}
  {$IF CompilerVersion >= 30.0}//>=XE10
  TPresentationProxyFactory.Current.Register(TSkinComboEdit, TControlType.Styled, TStyledPresentationProxy<TSkinFMXStyledComboEdit>);
  TPresentationProxyFactory.Current.Register(TSkinFMXComboEdit, TControlType.Styled, TStyledPresentationProxy<TSkinFMXStyledComboEdit>);
  TPresentationProxyFactory.Current.Register(TSkinFMXCustomComboEdit, TControlType.Styled, TStyledPresentationProxy<TSkinFMXStyledComboEdit>);
  {$ENDIF}

finalization
  {$IF CompilerVersion < 30.0}
  TPresentationProxyFactory.Current.Unregister('SkinFMXComboEdit-style');
  {$ENDIF}
  {$IF CompilerVersion >= 30.0}//>=XE10
  TPresentationProxyFactory.Current.Unregister(TSkinComboEdit, TControlType.Styled, TStyledPresentationProxy<TSkinFMXStyledComboEdit>);
  TPresentationProxyFactory.Current.Unregister(TSkinFMXComboEdit, TControlType.Styled, TStyledPresentationProxy<TSkinFMXStyledComboEdit>);
  TPresentationProxyFactory.Current.Unregister(TSkinFMXCustomComboEdit, TControlType.Styled, TStyledPresentationProxy<TSkinFMXStyledComboEdit>);
  {$ENDIF}


end.






