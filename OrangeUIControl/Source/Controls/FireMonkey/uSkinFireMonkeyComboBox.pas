//下拉框//
//convert pas to utf8 by ¥
unit uSkinFireMonkeyComboBox;

interface
{$I FrameWork.inc}

{$I FMXComboBox.inc}


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
  FMX.Objects,
  uLang,
  uGraphicCommon,
  FMX.Forms,
  FMX.Styles.Objects,
  FMX.Graphics,
  uSkinPublic,
  uSkinPicture,
  uSkinMaterial,
  uComponentType,
  uVersion,
  uSkinItems,
  uDrawPicture,
  uBinaryTreeDoc,
  uSkinComboBoxType,
  uDrawEngine,
  uDrawCanvas,
  uBasePageStructure,
//  uSkinPackage,
  uBaseList,
  FMX.ListBox,

  uSkinFireMonkeyControl,

  uSkinRegManager,
  uSkinBufferBitmap;




Type
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXCustomComboBox=class(TComboBox,
                        ISkinComboBox,
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
  private
    {$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Declare_FMX.inc}
  private
    FContent: TControl;
    FValues:TStringList;
    procedure SetValues(const AValue:TStringList);
  protected
    procedure BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
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
  protected
    function GetComboBoxProperties:TComboBoxProperties;
    procedure SetComboBoxProperties(Value:TComboBoxProperties);
  protected
    FIsAutoEditInItem:Boolean;
    //背景
    FStyleObj_background: TControl;

    //获取皮肤对象
    procedure ApplyStyle; override;
    procedure FreeStyle; override;
    function GetDefaultStyleLookupName: string; override;

    procedure AdjustFixedSize(const Ref: TControl); override;
    procedure DoPaintBackGround(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);

    procedure DoContentPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF); override;
  public
    //语录多语言的标记
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
    /// <summary>
    ///   刷新控件
    /// </summary>
    procedure Invalidate;

    /// <summary>
    ///   获取文本
    /// </summary>
    function GetText:String;
    procedure SetText(const Value:String);
    function GetValue:String;
    procedure SetValue(const Value:String);
  public
    function SelfOwnMaterialToDefault:TSkinComboBoxDefaultMaterial;
    function Material:TSkinComboBoxDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinComboBoxDefaultMaterial;
  public
    property Text:String read GetText write SetText;
    property Value:String read GetValue write SetValue;
    property Prop:TComboBoxProperties read GetComboBoxProperties write SetComboBoxProperties;
  published
    //值列表,用于页面框架
    property Values:TStringList read FValues write SetValues;
    //在列表项中自动启动编辑
    property IsAutoEditInItem:Boolean read FIsAutoEditInItem write FIsAutoEditInItem;

    //属性
    property ComboBoxProperties:TComboBoxProperties read GetComboBoxProperties write SetComboBoxProperties;
    property Properties:TComboBoxProperties read GetComboBoxProperties write SetComboBoxProperties;
  end;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinComboBox=class(TSkinFMXCustomComboBox)
  protected
    //InScrollBox属性实现
    //鼠标事件(系统自带的)(用于支持DirectUI)
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single);overload;override;
  end;

  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXComboBox=class(TSkinComboBox)
  end;





implementation



{$I Source\Controls\INC\FMX\ISkinControl_Caption_Impl_Code_FMX.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Code.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Code.inc}
{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Code_FMX.inc}
{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Mouse_Code_FMX.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_DirectUI_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Code.inc}

{$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Styled_Impl_Code_FMX.inc}


{ TSkinFMXCustomComboBox }


function TSkinFMXCustomComboBox.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TComboBoxProperties;
end;

function TSkinFMXCustomComboBox.GetDefaultStyleLookupName: string;
begin
  Result:='ComboBoxStyle';
end;

function TSkinFMXCustomComboBox.SelfOwnMaterialToDefault:TSkinComboBoxDefaultMaterial;
begin
  Result:=TSkinComboBoxDefaultMaterial(SelfOwnMaterial);
end;

function TSkinFMXCustomComboBox.Material:TSkinComboBoxDefaultMaterial;
begin
  Result:=TSkinComboBoxDefaultMaterial(SelfOwnMaterial);
end;

procedure TSkinFMXCustomComboBox.RecordControlLangIndex(APrefix: String; ALang: TLang;
  ACurLang: String);
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

procedure TSkinFMXCustomComboBox.TranslateControlLang(APrefix: String; ALang: TLang;
  ACurLang: String);
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

function TSkinFMXCustomComboBox.LoadFromFieldControlSetting(ASetting:TFieldControlSetting):Boolean;
begin
  Self.Values.CommaText:=ASetting.options_value;
  Self.Items.CommaText:=ASetting.options_caption;

  Self.ItemIndex:=-1;
//  SetMaterialUseKind(TMaterialUseKind.mukRefByStyleName);
//  SetMaterialName(ASetting.ControlStyle);

  Result:=True;
end;

//function TSkinFMXCustomComboBox.GetSuitDefaultItemHeight:Double;
//begin
//  Result:=-1;
//end;

function TSkinFMXCustomComboBox.GetPropJsonStr:String;
begin
  Result:=Self.Properties.GetPropJsonStr;
end;

procedure TSkinFMXCustomComboBox.SetPropJsonStr(AJsonStr:String);
begin
  Self.Properties.SetPropJsonStr(AJsonStr);
end;

procedure TSkinFMXCustomComboBox.SetValues(const AValue:TStringList);
begin
  FValues.Assign(AValue);
end;

function TSkinFMXCustomComboBox.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                                            var AErrorMessage:String):Variant;
begin
  //有Values用Value
  if (Self.ItemIndex<>-1) and (Self.ItemIndex<Self.FValues.Count) then
  begin
    //内部值,比如分类fid
    Result:=Self.FValues[Self.ItemIndex];
  end
  else
  begin
    //标题,比如职业
    Result:=GetText;
  end;
end;

procedure TSkinFMXCustomComboBox.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
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

//设置属性
function TSkinFMXCustomComboBox.GetProp(APropName:String):Variant;
begin

end;

procedure TSkinFMXCustomComboBox.SetProp(APropName:String;APropValue:Variant);
begin

end;

function TSkinFMXCustomComboBox.CurrentUseMaterialToDefault:TSkinComboBoxDefaultMaterial;
begin
  Result:=TSkinComboBoxDefaultMaterial(CurrentUseMaterial);
end;

procedure TSkinFMXCustomComboBox.ApplyStyle;
var
  I,J: Integer;
begin
  inherited;

  if FIsUseDefaultStyle then Exit;
  
  //去掉背景框
  for I := 0 to Self.ChildrenCount-1 do
  begin
    for J := Self.Children[I].ChildrenCount-1 downto 0 do
    begin
      if Self.Children[I].Children[J].StyleName='background' then
      begin
        //背景
        FStyleObj_background:=TControl(Self.Children[I].Children[J]);
        ClearStyleObjectVisiualElement(FStyleObj_background,'ComboBox');
        FStyleObj_background.OnPainting:=Self.DoPaintBackGround;
      end;
    end;
  end;
end;

function TSkinFMXCustomComboBox.GetText:String;
begin
  Result:='';
  if (Self.Count>0) and (Self.ItemIndex<>-1) then
  begin
    Result:=Self.Items[Self.ItemIndex];
  end;
end;

function TSkinFMXCustomComboBox.GetValue:String;
begin
  Result:='';
  if (Self.Count>0) and (Self.ItemIndex<>-1) then
  begin
    Result:=Self.Values[Self.ItemIndex];
  end;
end;

procedure TSkinFMXCustomComboBox.SetText(const Value:String);
begin
  Self.ItemIndex:=Self.Items.Indexof(Value);
end;

procedure TSkinFMXCustomComboBox.SetValue(const Value:String);
begin
  Self.ItemIndex:=Self.Values.Indexof(Value);
end;

procedure TSkinFMXCustomComboBox.DoContentPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
begin

end;

procedure TSkinFMXCustomComboBox.DoPaintBackGround(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
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
    Self.GetSkinControlType.Paint(FCanvas,ASkinMaterial,RectF(0,0,Self.Width,Self.Height),FPaintData);
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

end;

procedure TSkinFMXCustomComboBox.AdjustFixedSize(const Ref: TControl);
begin
end;

procedure TSkinFMXCustomComboBox.FreeStyle;
begin
  FContent:=nil;
  FStyleObj_background:=nil;
  inherited;
end;

constructor TSkinFMXCustomComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FValues:=TStringList.Create;


  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Create_Code.inc}

  //创建控件属性
  FProperties:=Self.GetPropertiesClassType.Create(Self);

  FParentMouseEvent:=False;
  FMouseEventTransToParentType:=mettptAuto;
  
  AutoCapture := True;

  {$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Init_Code_FMX.inc}

  SetAcceptsControls(True);
end;

destructor TSkinFMXCustomComboBox.Destroy;
begin
  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Destroy_Code.inc}

  FreeAndNil(FValues);

  FreeAndNil(FProperties);
  FreeAndNil(FCanvas);
  inherited;
end;

function TSkinFMXCustomComboBox.GetComboBoxProperties: TComboBoxProperties;
begin
  Result:=TComboBoxProperties(Self.FProperties);
end;

procedure TSkinFMXCustomComboBox.SetComboBoxProperties(Value: TComboBoxProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinFMXCustomComboBox.Invalidate;
begin
  if FStyleObj_background<>nil then
  begin
    FStyleObj_background.RePaint;
  end;
end;

procedure TSkinFMXCustomComboBox.BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
begin
  Self.ComboBoxProperties.DrawText:=AText;
end;

procedure TSkinFMXCustomComboBox.SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
begin
  Self.ComboBoxProperties.DrawText:=AFieldValue;
end;

function TSkinFMXCustomComboBox.EditGetValue:String;
begin
  Result:=GetText;
end;

procedure TSkinFMXCustomComboBox.EditSetValue(const AValue:String);
begin
  Self.ItemIndex:=Self.Items.IndexOf(AValue);
end;

procedure TSkinFMXCustomComboBox.EditMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
end;

procedure TSkinFMXCustomComboBox.EditMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
  DropDown;
end;

procedure TSkinFMXCustomComboBox.EditMouseMove(Shift: TShiftState; X, Y: Double);
begin
end;


{ TSkinComboBox }

//系统自带的
procedure TSkinComboBox.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
begin

  if CanFocus
    //Not Self.IsFocused
    //and
    //Self.IsInScrollBox
    and GetParentIsScrollBoxContent(Self,Self.FParentIsScrollBox,Self.FParentScrollBox)
    //and not Self.FIsMouseDownCanFocus
    then
  begin
      //滚动
      Self.ISkinControl_CustomMouseDown(Button,Shift,X,Y,False,Self);
  end
  else
  begin
      Inherited MouseDown(Button,Shift,X,Y);
  end;
end;

procedure TSkinComboBox.MouseMove(Shift:TShiftState;X, Y: Single);
begin

  if CanFocus
    //Not Self.IsFocused
    //and
//    Self.IsInScrollBox
    and GetParentIsScrollBoxContent(Self,Self.FParentIsScrollBox,Self.FParentScrollBox)
    //and not Self.FIsMouseDownCanFocus
    then
  begin
      //滚动
      Self.ISkinControl_CustomMouseMove(Shift,X,Y,False,Self);
  end
  else
  begin
      Inherited MouseMove(Shift,X,Y);
  end;
end;

procedure TSkinComboBox.MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
begin

  if CanFocus
    //Not Self.IsFocused
    //and
//    Self.IsInScrollBox
    and GetParentIsScrollBoxContent(Self,Self.FParentIsScrollBox,Self.FParentScrollBox)
//    and not Self.FIsMouseDownCanFocus
    then
  begin
      //滚动
      Self.ISkinControl_CustomMouseUp(Button,Shift,X,Y,False,Self);

      if (Self.SkinControlType.FMouseDownAbsolutePt.X<>0)
        and (Abs(Self.SkinControlType.FMouseDownAbsolutePt.X
          -Self.SkinControlType.FMouseMoveAbsolutePt.X)<Const_CanCallClickEventDistance)
        and (Abs(Self.SkinControlType.FMouseDownAbsolutePt.Y
          -Self.SkinControlType.FMouseMoveAbsolutePt.Y)<Const_CanCallClickEventDistance) then
      begin
          //执行点击

          //在DoEditStay
//          FIsMouseDownCanFocus:=True;//点击能获得焦点

          Inherited MouseDown(TMouseButton.mbLeft,[ssLeft],Self.SkinControlType.FMouseDownPt.X,Self.SkinControlType.FMouseDownPt.Y);
          Inherited MouseMove([ssLeft],Self.SkinControlType.FMouseDownPt.X,Self.SkinControlType.FMouseDownPt.Y);
          Inherited MouseUp(TMouseButton.mbLeft,[ssLeft],Self.SkinControlType.FMouseDownPt.X,Self.SkinControlType.FMouseDownPt.Y);

//          FIsMouseDownCanFocus:=False;


//          {$IFDEF MSWINDOWS}
//          //因为在Windows下面不会自己弹出来,所以在这里加一句
//          if Not Self.DateTimePicker.IsShown then
//          begin
//        //    Self.DateTimePicker.Show;
//            Self.OpenPicker;
//          end;
//          {$ENDIF}


      end;

  end
  else
  begin
      Inherited MouseUp(Button,Shift,X,Y);


//      {$IFDEF MSWINDOWS}
//      //因为在Windows下面不会自己弹出来,所以在这里加一句
//      if Not Self.DateTimePicker.IsShown then
//      begin
//    //    Self.DateTimePicker.Show;
//        Self.OpenPicker;
//      end;
//      {$ENDIF}


  end;
end;



end.



