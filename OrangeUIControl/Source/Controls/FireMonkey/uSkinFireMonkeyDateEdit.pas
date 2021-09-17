//convert pas to utf8 by ¥
//日期框//
unit uSkinFireMonkeyDateEdit;

interface
{$I FrameWork.inc}

{$I FMXDateEdit.inc}


uses
  SysUtils,
  uFuncCommon,
  Classes,
  uBaseLog,
  UITypes,
  Math,
  Types,
  DB,
  DateUtils,
  FMX.Dialogs,
  FMX.Types,
  FMX.Controls,
  FMX.StdCtrls,
  FMX.Objects,
  uGraphicCommon,
  uSkinItems,
  FMX.Forms,
  FMX.Styles.Objects,
  FMX.Graphics,
  FMX.Pickers,
  uSkinPublic,
  uSkinMaterial,
  uComponentType,
  uVersion,
  uDrawPicture,
  uBinaryTreeDoc,
  uSkinDateEditType,
  uDrawEngine,
  uSkinPicture,
  uDrawCanvas,
  uBasePageStructure,
//  uSkinPackage,
  uBaseList,
  FMX.DateTimeCtrls,

  uSkinFireMonkeyControl,

  uSkinRegManager,
  uSkinBufferBitmap;




Type
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXCustomDateEdit=class(TDateEdit,
                              ISkinDateEdit,
                              ISkinControl,
                              ISkinControlMaterial,
                              IDirectUIControl,
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
    function GetDateEditProperties:TDateEditProperties;
    procedure SetDateEditProperties(Value:TDateEditProperties);
  protected
  public
    //InScrollBox属性实现
//    FIsInScrollBox:Boolean;

//    FIsMouseDownCanFocus:Boolean;

  public
    //背景
    FStyleObj_background: TControl;

    procedure ApplyStyle; override;
    procedure FreeStyle; override;
    function GetDefaultStyleLookupName: string; override;

    //XE6需要
    procedure AdjustFixedSize(const Ref: TControl); override;
    procedure DoPaintBackGround(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure DoContentPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF); override;

    //控件绘制
    procedure Paint;overload;override;
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
    //刷新控件
    procedure Invalidate;

    function GetText:String;
    property DateTimePicker: TCustomDateTimePicker read FDateTimePicker;
  public
    function SelfOwnMaterialToDefault:TSkinDateEditDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinDateEditDefaultMaterial;
    function Material:TSkinDateEditDefaultMaterial;
  public
    property Prop:TDateEditProperties read GetDateEditProperties write SetDateEditProperties;
  published
    /// <summary>
    ///   是否在滚动框中
    /// </summary>
//    property IsInScrollBox:Boolean read FIsInScrollBox write FIsInScrollBox;
    //属性
    property DateEditProperties:TDateEditProperties read GetDateEditProperties write SetDateEditProperties;
    property Properties:TDateEditProperties read GetDateEditProperties write SetDateEditProperties;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinDateEdit=class(TSkinFMXCustomDateEdit)
  protected
    //InScrollBox属性实现
    //鼠标事件(系统自带的)(用于支持DirectUI)
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single);overload;override;
//  public
//    procedure StayClick;override;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXDateEdit=class(TSkinDateEdit)
  end;


implementation





{ TSkinFMXCustomDateEdit }

{$I Source\Controls\INC\FMX\ISkinControl_Caption_Impl_Code_FMX.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Code.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Code.inc}
{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Code_FMX.inc}
{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Mouse_Code_FMX.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_DirectUI_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Code.inc}



{$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Styled_Impl_Code_FMX.inc}


function TSkinFMXCustomDateEdit.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TDateEditProperties;
end;

function TSkinFMXCustomDateEdit.SelfOwnMaterialToDefault:TSkinDateEditDefaultMaterial;
begin
  Result:=TSkinDateEditDefaultMaterial(SelfOwnMaterial);
end;

function TSkinFMXCustomDateEdit.Material:TSkinDateEditDefaultMaterial;
begin
  Result:=TSkinDateEditDefaultMaterial(SelfOwnMaterial);
end;

function TSkinFMXCustomDateEdit.CurrentUseMaterialToDefault:TSkinDateEditDefaultMaterial;
begin
  Result:=TSkinDateEditDefaultMaterial(CurrentUseMaterial);
end;

function TSkinFMXCustomDateEdit.GetDefaultStyleLookupName: string;
begin
  Result:='DateEditStyle';
end;

procedure TSkinFMXCustomDateEdit.ApplyStyle;
var
  I,J: Integer;
begin
  inherited;

  if FIsUseDefaultStyle then Exit;

  if (ArrowButton<>nil) then
  begin
    ArrowButton.Visible:=False;
  end;

  //去掉背景框
  for I := 0 to Self.ChildrenCount-1 do
  begin
    for J := Self.Children[I].ChildrenCount-1 downto 0 do
    begin
      if Self.Children[I].Children[J].StyleName='background' then
      begin

        //背景
        FStyleObj_background:=TControl(Self.Children[I].Children[J]);
        ClearStyleObjectVisiualElement(FStyleObj_background,'DateEdit');
        FStyleObj_background.OnPainting:=Self.DoPaintBackGround;
      end;
    end;
  end;
end;

function TSkinFMXCustomDateEdit.LoadFromFieldControlSetting(ASetting:TFieldControlSetting):Boolean;
begin
//  SetMaterialUseKind(TMaterialUseKind.mukRefByStyleName);
//  SetMaterialName(ASetting.ControlStyle);

  Result:=True;
end;

function TSkinFMXCustomDateEdit.GetPropJsonStr:String;
begin
  Result:=Self.Properties.GetPropJsonStr;
end;

procedure TSkinFMXCustomDateEdit.SetPropJsonStr(AJsonStr:String);
begin
  Self.Properties.SetPropJsonStr(AJsonStr);
end;


function TSkinFMXCustomDateEdit.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
begin
  Result:=StdDateTimeToStr(Self.DateTime);
end;

procedure TSkinFMXCustomDateEdit.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
  if AValue<>'' then
  begin
    DateTime:=StdStrToDateTime(AValue);
  end;
end;

//设置属性
function TSkinFMXCustomDateEdit.GetProp(APropName:String):Variant;
begin

end;

procedure TSkinFMXCustomDateEdit.SetProp(APropName:String;APropValue:Variant);
begin

end;

//function TSkinFMXCustomDateEdit.GetSuitDefaultItemHeight:Double;
//begin
//  Result:=-1;
//end;

procedure TSkinFMXCustomDateEdit.Paint;
begin
  Inherited;
end;

function TSkinFMXCustomDateEdit.GetText:String;
begin
  Result:=Text;
end;

procedure TSkinFMXCustomDateEdit.DoContentPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
begin
end;

procedure TSkinFMXCustomDateEdit.DoPaintBackGround(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
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
      Canvas.FillText(RectF(0,0,Width,Height),Self.BindItemFieldName,True,0.6,[],TTextAlign.{$IF CompilerVersion >= 34.0}Leading{$ELSE}taLeading{$IFEND},TTextAlign.{$IF CompilerVersion >= 34.0}Leading{$ELSE}taLeading{$IFEND});
    end;

    FCanvas.UnPrepare;

end;

procedure TSkinFMXCustomDateEdit.AdjustFixedSize(const Ref: TControl);
begin
end;

procedure TSkinFMXCustomDateEdit.FreeStyle;
begin
  FStyleObj_background:=nil;
  inherited;
end;


constructor TSkinFMXCustomDateEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

//  FIsInScrollBox:=False;

  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Create_Code.inc}

  {$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Init_Code_FMX.inc}

  //创建控件属性
  FProperties:=Self.GetPropertiesClassType.Create(Self);

  FParentMouseEvent:=False;
  FMouseEventTransToParentType:=mettptAuto;

end;

destructor TSkinFMXCustomDateEdit.Destroy;
begin
  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Destroy_Code.inc}

  FreeAndNil(FProperties);
  FreeAndNil(FCanvas);
  inherited;
end;

function TSkinFMXCustomDateEdit.GetDateEditProperties: TDateEditProperties;
begin
  Result:=TDateEditProperties(Self.FProperties);
end;

procedure TSkinFMXCustomDateEdit.SetDateEditProperties(Value: TDateEditProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinFMXCustomDateEdit.BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
begin
  Self.DateEditProperties.DrawText:=AText;
end;

procedure TSkinFMXCustomDateEdit.SetControlValueByBindItemField(const AFieldName:String;
                                                                const AFieldValue:Variant;
                                                                ASkinItem:TObject;
                                                                AIsDrawItemInteractiveState:Boolean);
begin
  Self.DateEditProperties.DrawText:=AFieldValue;
end;

function TSkinFMXCustomDateEdit.EditGetValue:String;
begin

end;

procedure TSkinFMXCustomDateEdit.EditSetValue(const AValue:String);
begin

end;

procedure TSkinFMXCustomDateEdit.EditMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
end;

procedure TSkinFMXCustomDateEdit.EditMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
end;

procedure TSkinFMXCustomDateEdit.EditMouseMove(Shift: TShiftState; X, Y: Double);
begin
end;

procedure TSkinFMXCustomDateEdit.Invalidate;
begin
  if FStyleObj_background<>nil then
  begin
    FStyleObj_background.RePaint;
  end;
end;





{ TSkinDateEdit }

//procedure TSkinDateEdit.StayClick;
//begin
//  inherited;
//
//  {$IFDEF MSWINDOWS}
//  //因为在Windows下面不会自己弹出来,所以在这里加一句
//  if Not Self.DateTimePicker.IsShown then
//  begin
////    Self.DateTimePicker.Show;
//    Self.OpenPicker;
//  end;
//  {$ENDIF}
//
//end;


//系统自带的
procedure TSkinDateEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
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

procedure TSkinDateEdit.MouseMove(Shift:TShiftState;X, Y: Single);
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

procedure TSkinDateEdit.MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
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


          {$IFDEF MSWINDOWS}
          //因为在Windows下面不会自己弹出来,所以在这里加一句
          if Not Self.DateTimePicker.IsShown then
          begin
        //    Self.DateTimePicker.Show;
            Self.OpenPicker;
          end;
          {$ENDIF}


      end;

  end
  else
  begin
      Inherited MouseUp(Button,Shift,X,Y);


      {$IFDEF MSWINDOWS}
      //因为在Windows下面不会自己弹出来,所以在这里加一句
      if Not Self.DateTimePicker.IsShown then
      begin
    //    Self.DateTimePicker.Show;
        Self.OpenPicker;
      end;
      {$ENDIF}


  end;
end;




end.



