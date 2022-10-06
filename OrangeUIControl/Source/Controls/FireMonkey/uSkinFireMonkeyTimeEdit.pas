//convert pas to utf8 by ¥
//日期框//
unit uSkinFireMonkeyTimeEdit;

interface
{$I FrameWork.inc}

{$I FMXTimeEdit.inc}


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
  uBasePageStructure,
  uSkinPicture,
  uDrawPicture,
  uBinaryTreeDoc,
  uSkinTimeEditType,
  uDrawEngine,
  uDrawCanvas,
//  uSkinPackage,
  uBaseList,
  FMX.DateTimeCtrls,

  uSkinFireMonkeyControl,

  uSkinRegManager,
  uSkinBufferBitmap;




Type
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXCustomTimeEdit=class(TTimeEdit,
                                ISkinTimeEdit,
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
//    FDateTimePicker: TCustomDateTimePicker;
//    function GetPropertiesClassType: TPropertiesClassType;
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
    FIsShowUpDownButtonAtWindows: Boolean;
    procedure SyncIsShowUpDownButtonAtWindows;
    procedure SetIsShowUpDownButtonAtWindows(const Value: Boolean);
//    //InScrollBox属性实现
//    FIsInScrollBox:Boolean;

    function GetTimeEditProperties:TTimeEditProperties;
    procedure SetTimeEditProperties(Value:TTimeEditProperties);
  protected
    { Style Objects }
    FUpButton: TControl;
    FDownButton: TControl;

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
    //刷新控件
    procedure Invalidate;

    function GetText:String;
    property DateTimePicker: TCustomDateTimePicker read FDateTimePicker;
  public
    function SelfOwnMaterialToDefault:TSkinTimeEditDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinTimeEditDefaultMaterial;
    function Material:TSkinTimeEditDefaultMaterial;
  public
    property Prop:TTimeEditProperties read GetTimeEditProperties write SetTimeEditProperties;
  published
    property IsShowUpDownButtonAtWindows:Boolean read FIsShowUpDownButtonAtWindows write SetIsShowUpDownButtonAtWindows;
    /// <summary>
    ///   是否在滚动框中
    /// </summary>
//    property IsInScrollBox:Boolean read FIsInScrollBox write FIsInScrollBox;
    //属性
    property TimeEditProperties:TTimeEditProperties read GetTimeEditProperties write SetTimeEditProperties;
    property Properties:TTimeEditProperties read GetTimeEditProperties write SetTimeEditProperties;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinTimeEdit=class(TSkinFMXCustomTimeEdit)
  protected
    //InScrollBox属性实现
    //鼠标事件(系统自带的)(用于支持DirectUI)
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single);overload;override;
  end;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXTimeEdit=class(TSkinTimeEdit)
  end;




implementation





{ TSkinFMXCustomTimeEdit }

{$I Source\Controls\INC\FMX\ISkinControl_Caption_Impl_Code_FMX.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Code.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Code.inc}
{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Code_FMX.inc}
{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Mouse_Code_FMX.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_DirectUI_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Code.inc}

{$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Styled_Impl_Code_FMX.inc}


function TSkinFMXCustomTimeEdit.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TTimeEditProperties;
end;

function TSkinFMXCustomTimeEdit.SelfOwnMaterialToDefault:TSkinTimeEditDefaultMaterial;
begin
  Result:=TSkinTimeEditDefaultMaterial(SelfOwnMaterial);
end;

function TSkinFMXCustomTimeEdit.Material:TSkinTimeEditDefaultMaterial;
begin
  Result:=TSkinTimeEditDefaultMaterial(SelfOwnMaterial);
end;
function TSkinFMXCustomTimeEdit.CurrentUseMaterialToDefault:TSkinTimeEditDefaultMaterial;
begin
  Result:=TSkinTimeEditDefaultMaterial(CurrentUseMaterial);
end;

function TSkinFMXCustomTimeEdit.GetDefaultStyleLookupName: string;
begin
  Result:='TimeEditStyle';
end;

procedure TSkinFMXCustomTimeEdit.ApplyStyle;
var
  I,J: Integer;
begin
  inherited;

  if FIsUseDefaultStyle then Exit;



//  if (ArrowButton<>nil) then
//  begin
//    ArrowButton.Visible:=False;
//  end;

  //去掉背景框
  for I := 0 to Self.ChildrenCount-1 do
  begin
    for J := Self.Children[I].ChildrenCount-1 downto 0 do
    begin
      if Self.Children[I].Children[J].StyleName='background' then
      begin

        //背景
        FStyleObj_background:=TControl(Self.Children[I].Children[J]);
        ClearStyleObjectVisiualElement(FStyleObj_background,'TimeEdit');
        FStyleObj_background.OnPainting:=Self.DoPaintBackGround;
      end;
    end;
  end;

  SyncIsShowUpDownButtonAtWindows;

end;

function TSkinFMXCustomTimeEdit.LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;
begin
//  SetMaterialUseKind(TMaterialUseKind.mukRefByStyleName);
//  SetMaterialName(ASetting.ControlStyle);

  Result:=True;
end;

function TSkinFMXCustomTimeEdit.GetPropJsonStr:String;
begin
  Result:=Self.Properties.GetPropJsonStr;
end;

procedure TSkinFMXCustomTimeEdit.SetPropJsonStr(AJsonStr:String);
begin
  Self.Properties.SetPropJsonStr(AJsonStr);
end;


function TSkinFMXCustomTimeEdit.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
begin
  Result:=StdDateTimeToStr(Self.DateTime);
end;

procedure TSkinFMXCustomTimeEdit.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
  if AValue<>'' then
  begin
    DateTime:=StdStrToDateTime(AValue);
  end;
end;

////设置属性
//function TSkinFMXCustomTimeEdit.GetProp(APropName:String):Variant;
//begin
//
//end;
//
//procedure TSkinFMXCustomTimeEdit.SetProp(APropName:String;APropValue:Variant);
//begin
//
//end;

procedure TSkinFMXCustomTimeEdit.DoReturnFrame(AFromFrame:TFrame);
begin

end;

//function TSkinFMXCustomTimeEdit.GetSuitDefaultItemHeight:Double;
//begin
//  Result:=-1;
//end;

procedure TSkinFMXCustomTimeEdit.Paint;
begin
  Inherited;
end;

function TSkinFMXCustomTimeEdit.GetText:String;
begin
  Result:=Text;
end;

procedure TSkinFMXCustomTimeEdit.DoContentPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
begin
end;

procedure TSkinFMXCustomTimeEdit.DoPaintBackGround(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
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

procedure TSkinFMXCustomTimeEdit.AdjustFixedSize(const Ref: TControl);
begin
end;

//procedure TSkinFMXCustomTimeEdit.SetIsUseDefaultStyle(const Value: Boolean);
//begin
//  if FIsUseDefaultStyle<>Value then
//  begin
//    FIsUseDefaultStyle := Value;
//    if not (csReading in Self.ComponentState)
//      and not (csLoading in Self.ComponentState) then
//    begin
//      Self.StyleLookup:='';
//      Self.ApplyStyle;
//    end;
//  end;
//end;

procedure TSkinFMXCustomTimeEdit.FreeStyle;
begin
  FStyleObj_background:=nil;
  inherited;
end;


constructor TSkinFMXCustomTimeEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
//  FIsInScrollBox:=False;

  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Create_Code.inc}


  {$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Init_Code_FMX.inc}


  FIsShowUpDownButtonAtWindows:=True;


  //创建控件属性
  FProperties:=Self.GetPropertiesClassType.Create(Self);

  FParentMouseEvent:=False;
  FMouseEventTransToParentType:=mettptAuto;

end;

destructor TSkinFMXCustomTimeEdit.Destroy;
begin
  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Destroy_Code.inc}

  FreeAndNil(FProperties);
  FreeAndNil(FCanvas);
  inherited;
end;

function TSkinFMXCustomTimeEdit.GetTimeEditProperties: TTimeEditProperties;
begin
  Result:=TTimeEditProperties(Self.FProperties);
end;

procedure TSkinFMXCustomTimeEdit.SetTimeEditProperties(Value: TTimeEditProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinFMXCustomTimeEdit.BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
begin
  Self.TimeEditProperties.DrawText:=AText;
end;

procedure TSkinFMXCustomTimeEdit.SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
begin
  Self.TimeEditProperties.DrawText:=AFieldValue;
end;

procedure TSkinFMXCustomTimeEdit.SetIsShowUpDownButtonAtWindows(
  const Value: Boolean);
begin
  if FIsShowUpDownButtonAtWindows<>Value then
  begin
      FIsShowUpDownButtonAtWindows := Value;

      SyncIsShowUpDownButtonAtWindows;

  end;
end;

procedure TSkinFMXCustomTimeEdit.SyncIsShowUpDownButtonAtWindows;
begin

  { Spin buttons }
  if FindStyleResource<TControl>('upbutton', FUpButton) then
  begin
      FUpButton.Visible:=FIsShowUpDownButtonAtWindows;
//    FUpButton.Cursor := crArrow;
//    FUpButton.TouchTargetExpansion.Bottom := 0;
//    FUpButton.OnClick := DoUpButtonClick;
  end;
  if FindStyleResource<TControl>('downbutton', FDownButton) then
  begin
      FDownButton.Visible:=FIsShowUpDownButtonAtWindows;
//    FDownButton.Cursor := crArrow;
//    FDownButton.TouchTargetExpansion.Top := 0;
//    FDownButton.OnClick := DoDownButtonClick;
  end;

end;

//procedure TSkinFMXCustomTimeEdit.BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
//begin
//
//end;
//
//procedure TSkinFMXCustomTimeEdit.BindingItemIcon(AIcon:TDrawPicture;AImageList:TObject;AImageIndex:Integer;ARefPicture:TSkinPicture;AIsDrawItemInteractiveState:Boolean);
//begin
//
//end;

function TSkinFMXCustomTimeEdit.EditGetValue:String;
begin

end;

procedure TSkinFMXCustomTimeEdit.EditSetValue(const AValue:String);
begin

end;

//procedure TSkinFMXCustomTimeEdit.EditAssignSkin(ABindingControl:TChildControl);
//begin
//end;

procedure TSkinFMXCustomTimeEdit.EditMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
end;

procedure TSkinFMXCustomTimeEdit.EditMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
end;

procedure TSkinFMXCustomTimeEdit.EditMouseMove(Shift: TShiftState; X, Y: Double);
begin
end;

procedure TSkinFMXCustomTimeEdit.Invalidate;
begin
  if FStyleObj_background<>nil then
  begin
    FStyleObj_background.RePaint;
  end;
end;



{ TSkinTimeEdit }

//procedure TSkinTimeEdit.StayClick;
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
procedure TSkinTimeEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
begin

  if CanFocus//Not Self.IsFocused
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

procedure TSkinTimeEdit.MouseMove(Shift:TShiftState;X, Y: Single);
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

procedure TSkinTimeEdit.MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
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





