//文本框//
//convert pas to utf8 by ¥
unit uSkinFireMonkeyEdit;

interface
{$I FrameWork.inc}

{$I FMXEdit.inc}


uses
  SysUtils,
  uFuncCommon,
  Classes,
  uBaseLog,
  UITypes,
  Math,
  Types,
  DB,
  FMX.Dialogs,
  FMX.Types,
  FMX.Controls,
  FMX.StdCtrls,
  FMX.Edit,

  uSkinItems,
  uGraphicCommon,
  uLang,
  FMX.Forms,
  FMX.Styles.Objects,
  FMX.Graphics,
  uSkinPublic,
  uSkinMaterial,
  uComponentType,
  uVersion,
  uBinaryTreeDoc,
  uSkinEditType,
  uDrawEngine,
  uDrawCanvas,
  uSkinPicture,
  uBasePageStructure,
//  uSkinPackage,
  uBaseList,
  FMX.Text,
  FMX.Objects,
  uDrawPicture,
  FMX.Edit.Style,
  uSkinFireMonkeyStyledEdit,

  uSkinFireMonkeyControl,


  FMX.Presentation.Factory,

  {$IF CompilerVersion >= 30.0}//>=XE10
  FMX.Presentation.Style,

    FMX.Controls.Presentation,

  {$IFDEF IOS}
  FMX.Edit.iOS,
  FMX.Presentation.iOS,
  uSkinFireMonkeyiOSNativeEdit,
  {$ENDIF}

  {$ENDIF}


  uSkinRegManager,
  uSkinBufferBitmap;




Type
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXCustomEdit=class(TEdit,
                          ISkinEdit,
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
//    function GetPropertiesClassType: TPropertiesClassType;
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
    function GetEditProperties:TEditProperties;
    procedure SetEditProperties(Value:TEditProperties);
  protected
    function GetDefaultStyleLookupName: string; override;
    function DefinePresentationName: string;override;

    procedure DoPaintBackGround(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);

  protected
    //InScrollBox属性实现
    FIsInScrollBox:Boolean;
    //在ListBox中点击自动编辑
    FIsAutoEditInItem:Boolean;
  protected
    procedure AdjustFixedSize(const Ref: TControl); override;
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
  protected
    //IBindSkinItemTextControl
    procedure BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
    //IBindSkinItemValueControl
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  protected
    //在ListBox中启动编辑时所调用的ICustomListItemEditor
    procedure EditSetValue(const AValue:String);
    function EditGetValue:String;
    procedure EditMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
    procedure EditMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
    procedure EditMouseMove(Shift: TShiftState; X, Y: Double);
  public
    //记录多语言的索引
    procedure RecordControlLangIndex(APrefix:String;ALang:TLang;ACurLang:String);virtual;
    //翻译
    procedure TranslateControlLang(APrefix:String;ALang:TLang;ACurLang:String);virtual;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    function GetStyleEdit: TSkinFMXStyledEdit;
    function GetEditContentMarginsIntf: IEditContentMargins;
  public
    //
    /// <summary>
    ///   刷新控件
    /// </summary>
    procedure Invalidate;

    /// <summary>
    ///   获取文本
    /// </summary>
    function GetText:String;
    //是否只读
    function IsReadOnly:Boolean;
    function GetPasswordChar:Char;
  public
    function SelfOwnMaterialToDefault:TSkinEditDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinEditDefaultMaterial;
    function Material:TSkinEditDefaultMaterial;
  public
    property Prop:TEditProperties read GetEditProperties write SetEditProperties;
  published
    //属性
    property EditProperties:TEditProperties read GetEditProperties write SetEditProperties;
    property Properties:TEditProperties read GetEditProperties write SetEditProperties;
  published
    /// <summary>
    ///   是否在滚动框中
    /// </summary>
    property IsInScrollBox:Boolean read FIsInScrollBox write FIsInScrollBox;
    //在列表项中自动启动编辑
    property IsAutoEditInItem:Boolean read FIsAutoEditInItem write FIsAutoEditInItem;
  end;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinEdit=class(TSkinFMXCustomEdit)
  private
    FIsSetedStyleType:Boolean;
  protected
    procedure Loaded;override;
  public
    //如果Edit在ItemDesigner中自动调用ListBox的编辑功能
//    procedure StayClick;override;
  end;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXEdit=class(TSkinEdit)

  end;



var
  //统一在项目用原生Edit
  GlobalIsUseNativeEditOnIOS:Boolean;
  GlobalSkinFMXEditList:TBaseList;
  SetGlobalEditListTypeCount:Integer;


//设置所有的Edit的ControlType为Styled
procedure SetGlobalEditListAsStyleType;
//还原所有的Edit的ControlType为Platform
procedure RestoreGlobalEditListAsPlatformType;


implementation



procedure SetGlobalEditListAsStyleType;
var
  I:Integer;
begin
  {$IFDEF IOS}
//  if GlobalIsUseNativeEditOnIOS then
//  begin
    Inc(SetGlobalEditListTypeCount);
//    if SetGlobalEditListTypeCount=1 then//去掉这一个判断,避免设置不到
//    begin
      for I := 0 to GlobalSkinFMXEditList.Count-1 do
      begin
        if TSkinFMXEdit(GlobalSkinFMXEditList[I]).ControlType=FMX.Controls.TControlType.Platform then
        begin
          TSkinFMXEdit(GlobalSkinFMXEditList[I]).FIsSetedStyleType:=True;
          TSkinFMXEdit(GlobalSkinFMXEditList[I]).ControlType:=FMX.Controls.TControlType.Styled;
        end;
      end;
//    end;
//  end;
  {$ENDIF}
end;


procedure RestoreGlobalEditListAsPlatformType;
var
  I:Integer;
begin
  {$IFDEF IOS}
//  if GlobalIsUseNativeEditOnIOS then
//  begin
    Dec(SetGlobalEditListTypeCount);
    if SetGlobalEditListTypeCount=0 then
    begin
      for I := 0 to GlobalSkinFMXEditList.Count-1 do
      begin
        if TSkinFMXEdit(GlobalSkinFMXEditList[I]).FIsSetedStyleType
          and (TSkinFMXEdit(GlobalSkinFMXEditList[I]).ControlType=FMX.Controls.TControlType.Styled) then
        begin
          TSkinFMXEdit(GlobalSkinFMXEditList[I]).FIsSetedStyleType:=False;
          TSkinFMXEdit(GlobalSkinFMXEditList[I]).ControlType:=FMX.Controls.TControlType.Platform;
        end;
      end;
    end;
//  end;
  {$ENDIF}
end;


{ TSkinFMXEdit }

//procedure TSkinFMXEdit.StayClick;
//begin
//  Inherited;
//end;

//系统自带的
procedure TSkinEdit.Loaded;
begin
  {$IFNDEF IOS}
  if ControlType=FMX.Controls.TControlType.Platform then
  begin
    ControlType:=FMX.Controls.TControlType.Styled;
  end;
  {$ENDIF}


  {$IFDEF IOS}
  if GlobalIsUseNativeEditOnIOS and (ControlType=FMX.Controls.TControlType.Styled) then
  begin
    //透明Edit
    StyleLookup:='transparentedit';
    ControlType:=FMX.Controls.TControlType.Platform;
  end;
  {$ENDIF}



  inherited;


  Self.StyledSettings:=Self.StyledSettings-[TStyledSetting.Size,TStyledSetting.FontColor];

  {$IF CompilerVersion >= 30.0}//>=XE10
  {$IFDEF IOS}
  //设置边距
  if (PresentationProxy<>nil)
    and (PresentationProxy.Receiver<>nil)
    and (PresentationProxy.Receiver is TSkinFMXiOSNativeEdit)
     then
  begin
    TSkinFMXiOSNativeEdit(PresentationProxy.Receiver).ContentMarginsLeft:=FContentMarginsLeft;
    TSkinFMXiOSNativeEdit(PresentationProxy.Receiver).ContentMarginsTop:=FContentMarginsTop;
    TSkinFMXiOSNativeEdit(PresentationProxy.Receiver).ContentMarginsRight:=FContentMarginsRight;
    TSkinFMXiOSNativeEdit(PresentationProxy.Receiver).ContentMarginsBottom:=FContentMarginsBottom;
  end;
  {$ENDIF}
  {$ENDIF}

end;



{ TSkinFMXCustomEdit }

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

function TSkinFMXCustomEdit.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TEditProperties;
end;

function TSkinFMXCustomEdit.SelfOwnMaterialToDefault:TSkinEditDefaultMaterial;
begin
  Result:=TSkinEditDefaultMaterial(SelfOwnMaterial);
end;

function TSkinFMXCustomEdit.Material:TSkinEditDefaultMaterial;
begin
  Result:=TSkinEditDefaultMaterial(SelfOwnMaterial);
end;

function TSkinFMXCustomEdit.CurrentUseMaterialToDefault:TSkinEditDefaultMaterial;
begin
  Result:=TSkinEditDefaultMaterial(CurrentUseMaterial);
end;

procedure TSkinFMXCustomEdit.DoPaintBackGround(Sender: TObject; Canvas: TCanvas;const ARect: TRectF);
var
  ASkinMaterial:TSkinControlMaterial;
begin

  FCanvas.Prepare(Canvas);


//  //绘制父控件背景
//  if (Self.CurrentUseMaterial<>nil) then
//  begin
//    if Not TSkinControlMaterial(Self.CurrentUseMaterial).IsTransparent then
//    begin
//      FCanvas.DrawRect(TSkinControlMaterial(Self.CurrentUseMaterial).BackColor,
//                        RectF(0,0,Width,Height));
//    end;
//  end;


  if (GetSkinControlType<>nil) then
  begin
    ASkinMaterial:=GetSkinControlType.GetPaintCurrentUseMaterial;
  end;

  //绘制
  if Self.SkinControlType<>nil then
  begin
    FPaintData:=GlobalNullPaintData;
    FPaintData.IsDrawInteractiveState:=True;
    FPaintData.IsInDrawDirectUI:=False;
    Self.SkinControlType.Paint(FCanvas,ASkinMaterial,RectF(0,0,Self.Width,Self.Height),FPaintData);
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


function TSkinFMXCustomEdit.DefinePresentationName: string;
begin
  Result := 'SkinFMXEdit-' + GetPresentationSuffix;
end;

function TSkinFMXCustomEdit.GetDefaultStyleLookupName: string;
begin
  Result:='EditStyle';
end;

function TSkinFMXCustomEdit.GetText:String;
begin
  Result:=Text;
end;

function TSkinFMXCustomEdit.IsReadOnly:Boolean;
begin
  Result:=ReadOnly;
end;

function TSkinFMXCustomEdit.GetPasswordChar:Char;
begin
  Result:=#0;
  if Password then
  begin
    Result:='*';
  end;
end;

procedure TSkinFMXCustomEdit.AdjustFixedSize(const Ref: TControl);
begin
end;

function TSkinFMXCustomEdit.LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;
begin
//  SetMaterialUseKind(TMaterialUseKind.mukRefByStyleName);
//  SetMaterialName(ASetting.ControlStyle);

//  Self.Prop.HelpText:=ASetting.InputPrompt;


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



  Result:=True;
end;

function TSkinFMXCustomEdit.GetPropJsonStr:String;
begin
  Result:=Self.Properties.GetPropJsonStr;
end;

procedure TSkinFMXCustomEdit.SetPropJsonStr(AJsonStr:String);
begin
  Self.Properties.SetPropJsonStr(AJsonStr);
end;


function TSkinFMXCustomEdit.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
begin
  Result:=Self.Text;
end;

procedure TSkinFMXCustomEdit.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
  Text:=AValue;
end;

////设置属性
//function TSkinFMXCustomEdit.GetProp(APropName:String):Variant;
//begin
//
//end;
//
//procedure TSkinFMXCustomEdit.SetProp(APropName:String;APropValue:Variant);
//begin
//
//end;

procedure TSkinFMXCustomEdit.DoReturnFrame(AFromFrame:TFrame);
begin

end;

//function TSkinFMXCustomEdit.GetSuitDefaultItemHeight:Double;
//begin
//  Result:=-1;
//end;

constructor TSkinFMXCustomEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Create_Code.inc}


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

  Self.StyledSettings:=
    Self.StyledSettings-[TStyledSetting.Size,TStyledSetting.FontColor];


  GlobalSkinFMXEditList.Add(Self);
end;

destructor TSkinFMXCustomEdit.Destroy;
begin

  GlobalSkinFMXEditList.Remove(Self,False);


  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Destroy_Code.inc}

  FreeAndNil(FProperties);
  FreeAndNil(FCanvas);
  inherited;
end;

procedure TSkinFMXCustomEdit.EditMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
  if GetStyleEdit<>nil then GetStyleEdit.MouseDown(Button,Shift,X,Y);
end;

procedure TSkinFMXCustomEdit.EditMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
  if GetStyleEdit<>nil then GetStyleEdit.MouseUp(Button,Shift,X,Y);
end;

procedure TSkinFMXCustomEdit.EditMouseMove(Shift: TShiftState; X, Y: Double);
begin
  if GetStyleEdit<>nil then GetStyleEdit.MouseMove(Shift,X,Y);
end;


procedure TSkinFMXCustomEdit.RecordControlLangIndex(APrefix:String;ALang:TLang;ACurLang:String);
begin

  if TextPrompt<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.TextPrompt',ACurLang,TextPrompt);
  end;
  if Self.Prop.HelpText<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.HelpText',ACurLang,Self.Prop.HelpText);
  end;

end;


function TSkinFMXCustomEdit.GetEditProperties: TEditProperties;
begin
  Result:=TEditProperties(Self.FProperties);
end;

procedure TSkinFMXCustomEdit.SetEditProperties(Value: TEditProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinFMXCustomEdit.TranslateControlLang(APrefix: String; ALang: TLang;
  ACurLang: String);
begin
  if GetLangValue(ALang,APrefix+Name+'.TextPrompt',ACurLang)<>'' then
  begin
    TextPrompt:=GetLangValue(ALang,APrefix+Name+'.TextPrompt',ACurLang);
  end;
  if GetLangValue(ALang,APrefix+Name+'.HelpText',ACurLang)<>'' then
  begin
    Prop.HelpText:=GetLangValue(ALang,APrefix+Name+'.HelpText',ACurLang);
  end;
end;

function TSkinFMXCustomEdit.GetEditContentMarginsIntf: IEditContentMargins;
begin
  Result:=nil;
  if (PresentationProxy<>nil)
    and (PresentationProxy.Receiver<>nil)
     then
  begin
    PresentationProxy.Receiver.GetInterface(IID_IEditContentMargins,Result);
  end;
end;

function TSkinFMXCustomEdit.GetStyleEdit: TSkinFMXStyledEdit;
begin
  Result:=nil;
  if (PresentationProxy<>nil)
    and (PresentationProxy.Receiver<>nil)
    and (PresentationProxy.Receiver is TSkinFMXStyledEdit)
     then
  begin
    Result:=TSkinFMXStyledEdit(PresentationProxy.Receiver);
  end;
end;

function TSkinFMXCustomEdit.EditGetValue:String;
begin
  Result:=Self.Text;
end;

procedure TSkinFMXCustomEdit.EditSetValue(const AValue:String);
begin
  Self.Text:=AValue;
end;

procedure TSkinFMXCustomEdit.Invalidate;
var
  ADirectUIParentIntf:IDirectUIParent;
begin
  if Self.FDirectUIParentIntf=nil then
  begin
      if (Self.Parent<>nil) then
      begin
          //有区域更新接口
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


procedure TSkinFMXCustomEdit.BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
begin
  Self.EditProperties.DrawText:=AText;
end;


procedure TSkinFMXCustomEdit.SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
begin
  Self.EditProperties.DrawText:=AFieldValue;
end;





initialization
  SetGlobalEditListTypeCount:=0;
  GlobalIsUseNativeEditOnIOS:=False;
  GlobalSkinFMXEditList:=TBaseList.Create(ooReference);



  {$IF CompilerVersion < 30.0}
  TPresentationProxyFactory.Current.Unregister('SkinFMXEdit-style');
  TPresentationProxyFactory.Current.Register('SkinFMXEdit-style', TSkinFMXStyledEditProxy);
  {$ENDIF}
  {$IF CompilerVersion >= 30.0}//>=XE10
  TPresentationProxyFactory.Current.Unregister(TSkinFMXEdit, TControlType.Styled, TStyledPresentationProxy<TSkinFMXStyledEdit>);
  TPresentationProxyFactory.Current.Register(TSkinFMXEdit, TControlType.Styled, TStyledPresentationProxy<TSkinFMXStyledEdit>);
  {$ENDIF}



finalization
  {$IF CompilerVersion < 30.0}
  TPresentationProxyFactory.Current.Unregister('SkinFMXEdit-style');
  {$ENDIF}
  {$IF CompilerVersion >= 30.0}//>=XE10
  TPresentationProxyFactory.Current.Unregister('SkinFMXEdit-style');
  TPresentationProxyFactory.Current.Unregister(TSkinFMXEdit, TControlType.Styled, TStyledPresentationProxy<TSkinFMXStyledEdit>);
  {$ENDIF}


  FreeAndNil(GlobalSkinFMXEditList);



end.




