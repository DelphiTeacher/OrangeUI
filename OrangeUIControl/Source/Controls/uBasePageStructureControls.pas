unit uBasePageStructureControls;



interface
{$IF DEFINED(ANDROID) OR DEFINED(IOS) OR DEFINED(MACOS) }
  {$DEFINE FMX}
{$IFEND}



//请在工程下放置FrameWork.inc
//或者在工程设置中配置FMX编译指令
//才可以正常编译此单元
{$IFNDEF FMX}
  {$IFNDEF VCL}
    {$I FrameWork.inc}
  {$ENDIF}
{$ENDIF}





uses
  Classes,
  SysUtils,
  Types,
  {$IFDEF FMX}
  FMX.Types,
  FMX.Controls,
  FMX.StdCtrls,
  FMX.Forms,
  FMX.Edit,
  FMX.Memo,
  {$ENDIF FMX}
  {$IFDEF VCL}
  StdCtrls,
  ExtCtrls,
  Messages,
  Menus,
  Windows,
  Graphics,
  Forms,
  {$ENDIF}
//  FMX.Dialogs,
//  FMX.Edit,
//  FMX.ComboEdit,
//  FMX.ListBox,
//  FMX.StdCtrls,
//  FMX.Memo,
//  FMX.Graphics,
//  UITypes,
//  uDrawParam,
//  uGraphicCommon,
//  uSkinItems,
//  uSkinMaterial,
//  uSkinListLayouts,
//  uSkinListViewType,
//  uComponentType,
//  uSkinRegManager,
  uBaseList,
  uBaseLog,
  IdURI,
  Math,
//  FMX.Forms,
//  IniFiles,
//  uBaseSkinControl,
//  uSkinCommonFrames,
//  uDrawTextParam,
//  uDrawPictureParam,
//  uDrawRectParam,
////  MessageBoxFrame,
////  WaitingFrame,
////  uBasePageStructure,
//  uSkinVirtualListType,
//  uDataInterface,
//  uTableCommonRestCenter,
  uLang,
//  uFrameContext,

  {$IF CompilerVersion >= 30.0}
  System.Math.Vectors,
  System.UIConsts,
  System.Net.URLClient,
  {$IFEND}
  uSkinSuperObject,

//  uTimerTask,
//  uTimerTaskEvent,
//  uSkinCommonFrames,
//  uTimerTask,
  DateUtils,
  uDrawPicture,
  uFuncCommon,
  uBasePageStructure,
  uComponentType,




//  {$IFDEF SKIN_SUPEROBJECT}
//  uSkinSuperObject,
//  {$ELSE}
//  XSuperObject,
//  XSuperJson,
//  {$ENDIF}


//  uFuncCommon,
  uFileCommon,
  {$IFDEF FMX}
  uSkinFireMonkeyComboBox,
  {$ENDIF}
//  uBaseHttpControl,
//  uRestInterfaceCall,
//  uPageFrameworkCommon,
  uBaseHttpControl,
  StrUtils
  ;

type
//  {$IFDEF VCL}
  TPageCheckBox=class(TCheckBox,IControlForPageFramework)
  public
    FHelpText:String;
    {$IFDEF VCL}
    //消息处理
    procedure WMPaint(var Message:TWMPaint);message WM_PAINT;
    {$ENDIF}
    //针对页面框架的控件接口
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;
    //获取与设置自定义属性
    function GetPropJsonStr:String;
    procedure SetPropJsonStr(AJsonStr:String);
    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            //可以获取其他字段的值
                            ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            AImageServerUrl:String;
                            AValue:Variant;
                            AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
//    //设置属性
//    function GetProp(APropName:String):Variant;
//    procedure SetProp(APropName:String;APropValue:Variant);
    procedure DoReturnFrame(AFromFrame:TFrame);
  published
    property HelpText:String read FHelpText write FHelpText;
  end;



  {$IFDEF FMX}
  TSkinComboBox=class(TSkinFMXComboBox)
  end;
//  TPageComboBox=class(TSkinComboBox,IControlForPageFramework)
  {$ELSE}
  TSkinComboBox=class(TComboBox)
  end;
  {$ENDIF}

  TPageComboBox=class(TSkinComboBox,IControlForPageFramework,ISkinControlValueChange)
  public
    FValues:TStringList;
//    HelpText:String;
    //消息处理
//    procedure WMPaint(var Message:TWMPaint);message WM_PAINT;
    //针对页面框架的控件接口
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;
    //获取与设置自定义属性
    function GetPropJsonStr:String;
    procedure SetPropJsonStr(AJsonStr:String);
    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            //可以获取其他字段的值
                            ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            AImageServerUrl:String;
                            AValue:Variant;
                            AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
//    //设置属性
//    function GetProp(APropName:String):Variant;
//    procedure SetProp(APropName:String;APropValue:Variant);
    procedure DoReturnFrame(AFromFrame:TFrame);
    procedure SetOnChange(Value:TNotifyEvent);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  end;



  TPageEdit=class(TEdit,IControlForPageFramework)
  public
    //针对页面框架的控件接口
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;
    //获取与设置自定义属性
    function GetPropJsonStr:String;
    procedure SetPropJsonStr(AJsonStr:String);
    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            //可以获取其他字段的值
                            ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            AImageServerUrl:String;
                            AValue:Variant;
                            AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
//    //设置属性
//    function GetProp(APropName:String):Variant;
//    procedure SetProp(APropName:String;APropValue:Variant);
    procedure DoReturnFrame(AFromFrame:TFrame);
  end;



  TPageMemo=class(TMemo,IControlForPageFramework)
  public
    FHelpText:String;
    {$IFDEF VCL}
    //消息处理
    procedure WMPaint(var Message:TWMPaint);message WM_PAINT;
    {$ENDIF}
    //针对页面框架的控件接口
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;
    //获取与设置自定义属性
    function GetPropJsonStr:String;
    procedure SetPropJsonStr(AJsonStr:String);
    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            //可以获取其他字段的值
                            ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            AImageServerUrl:String;
                            AValue:Variant;
                            AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
//    //设置属性
//    function GetProp(APropName:String):Variant;
//    procedure SetProp(APropName:String;APropValue:Variant);
    procedure DoReturnFrame(AFromFrame:TFrame);
  published
    property HelpText:String read FHelpText write FHelpText;
  end;
//  {$ENDIF VCL}





implementation


//{$IFDEF VCL}

{ TPageCheckBox }

function TPageCheckBox.GetPostValue(ASetting: TFieldControlSetting;
  APageDataDir: String; ASetRecordFieldValueIntf: ISetRecordFieldValue;
  var AErrorMessage: String): Variant;
begin
  Result:=Self.{$IFDEF VCL}Checked{$ENDIF}{$IFDEF FMX}IsChecked{$ENDIF};
end;

//function TPageCheckBox.GetProp(APropName: String): Variant;
//begin
//
//end;

function TPageCheckBox.GetPropJsonStr: String;
begin

end;

function TPageCheckBox.LoadFromFieldControlSetting(ASetting: TFieldControlSetting;AFieldControlSettingMap:TObject): Boolean;
begin
//  if ASetting.has_caption_label=0 then
//  begin

  HelpText:=ASetting.input_prompt;

    {$IFDEF FMX}
    Text:=ASetting.field_caption;
    {$ENDIF}
    {$IFDEF VCL}
    Caption:=ASetting.field_caption;
    {$ENDIF}
//  end;

  //标准控件
  Self.{$IFDEF VCL}Checked{$ENDIF}{$IFDEF FMX}IsChecked{$ENDIF}:=SameText(ASetting.value,'True')
                                                                or SameText(ASetting.value,'1');

  Result:=True;
end;

procedure TPageCheckBox.SetControlValue(ASetting: TFieldControlSetting;
  APageDataDir, AImageServerUrl: String; AValue: Variant; AValueCaption: String;
  AGetDataIntfResultFieldValueIntf: IGetDataIntfResultFieldValue);
var
  AValueStr:String;
begin
  AValueStr:=AValue;
  if AValueStr='' then
  begin
    AValue:=False;
  end;
  Self.{$IFDEF VCL}Checked{$ENDIF}{$IFDEF FMX}IsChecked{$ENDIF}:=AValue;


end;

//procedure TPageCheckBox.SetProp(APropName: String; APropValue: Variant);
//begin
//
//end;

procedure TPageCheckBox.SetPropJsonStr(AJsonStr: String);
begin

end;

procedure TPageCheckBox.DoReturnFrame(AFromFrame:TFrame);
begin

end;

{$IFDEF VCL}

procedure TPageCheckBox.WMPaint(var Message: TWMPaint);
var
  ADC:HDC;
  ACanvas:TCanvas;
  AStartX:Integer;
  ATextHeight:Integer;
begin
  Inherited;

  //绘制提示文本
  if //(Text='') and
    (Self.HelpText<>'') then
  begin
      ADC := GetDC(Handle);
      try

        ACanvas:=TCanvas.Create;
        try
          ACanvas.Handle:=ADC;
          ACanvas.Font.Size:=Self.Font.Size;
          ACanvas.Font.Color:=clGray;

          ATextHeight:=ACanvas.TextHeight(Text);
          AStartX:=ACanvas.TextWidth(Text)+50;

          ACanvas.TextOut(AStartX,(Height-ATextHeight) div 2,HelpText);

        finally
          FreeAndNil(ACanvas);
        end;

      finally
        ReleaseDC(Handle,ADC);
      end;

  end;

end;
{$ENDIF}

{ TPageEdit }

function TPageEdit.GetPostValue(ASetting: TFieldControlSetting;
  APageDataDir: String; ASetRecordFieldValueIntf: ISetRecordFieldValue;
  var AErrorMessage: String): Variant;
begin
  Result:=Text;
end;

//function TPageEdit.GetProp(APropName: String): Variant;
//begin
//
//end;

function TPageEdit.GetPropJsonStr: String;
begin

end;

function TPageEdit.LoadFromFieldControlSetting(
  ASetting: TFieldControlSetting;AFieldControlSettingMap:TObject): Boolean;
begin
  {$IFDEF VCL}
  Self.TextHint:=ASetting.input_prompt;
  Self.MaxLength:=ASetting.input_max_length;
  {$ENDIF}
  Result:=True;
end;

procedure TPageEdit.SetControlValue(ASetting: TFieldControlSetting;
  APageDataDir, AImageServerUrl: String; AValue: Variant; AValueCaption: String;
  AGetDataIntfResultFieldValueIntf: IGetDataIntfResultFieldValue);
begin
  Text:=AValue;
end;

procedure TPageEdit.DoReturnFrame(AFromFrame:TFrame);
begin

end;

//procedure TPageEdit.SetProp(APropName: String; APropValue: Variant);
//begin
//
//end;

procedure TPageEdit.SetPropJsonStr(AJsonStr: String);
var
  APropJson:ISuperObject;
begin
//  AFieldControlSetting.PropJson.I['password']:=1;
  APropJson:=SO(AJsonStr);
  if APropJson.Contains('is_password') then
  begin
    if APropJson.I['is_password']=1 then
    begin
      {$IFDEF VCL}
      Self.PasswordChar:='*';
      {$ENDIF}
      {$IFDEF FMX}
      Self.Password:=True;
      {$ENDIF}
    end;
  end;
  if APropJson.Contains('IsPassword') then
  begin
    if APropJson.I['IsPassword']=1 then
    begin
      {$IFDEF VCL}
      Self.PasswordChar:='*';
      {$ENDIF}
      {$IFDEF FMX}
      Self.Password:=True;
      {$ENDIF}
    end;
  end;
  if APropJson.Contains('PasswordChar') then
  begin
//    if APropJson.I['PasswordChar']=1 then
//    begin
      {$IFDEF VCL}
      Self.PasswordChar:=APropJson.S['PasswordChar'][1];
      {$ENDIF}
//    end;
  end;

end;

{ TPageMemo }

function TPageMemo.GetPostValue(ASetting: TFieldControlSetting;
  APageDataDir: String; ASetRecordFieldValueIntf: ISetRecordFieldValue;
  var AErrorMessage: String): Variant;
begin
  Result:=Text;
end;

//function TPageMemo.GetProp(APropName: String): Variant;
//begin
//
//end;

function TPageMemo.GetPropJsonStr: String;
begin

end;

function TPageMemo.LoadFromFieldControlSetting(
  ASetting: TFieldControlSetting;AFieldControlSettingMap:TObject): Boolean;
begin
  Self.MaxLength:=ASetting.input_max_length;

  HelpText:=ASetting.input_prompt;
  {$IFDEF CompilerVersion > 31.0}
  Self.TextHint:=ASetting.input_prompt;
  {$ENDIF}


  Result:=True;
end;

procedure TPageMemo.SetControlValue(ASetting: TFieldControlSetting;
  APageDataDir, AImageServerUrl: String; AValue: Variant; AValueCaption: String;
  AGetDataIntfResultFieldValueIntf: IGetDataIntfResultFieldValue);
begin
  Text:=AValue;
end;

//procedure TPageMemo.SetProp(APropName: String; APropValue: Variant);
//begin
//
//end;

procedure TPageMemo.SetPropJsonStr(AJsonStr: String);
begin

end;

procedure TPageMemo.DoReturnFrame(AFromFrame:TFrame);
begin

end;


{$IFDEF VCL}
procedure TPageMemo.WMPaint(var Message: TWMPaint);
var
  ADC:HDC;
  ACanvas:TCanvas;
//  ACanvas:TDrawCanvas;
begin
  Inherited;

  //绘制提示文本
  if (Text='') and (Self.HelpText<>'') then
  begin
//    Canvas.
//    if Self.GetSkinControlType<>nil then
//    begin
      ADC := GetDC(Handle);
      try

        ACanvas:=TCanvas.Create;
        try
          ACanvas.Handle:=ADC;
          ACanvas.Font.Size:=Self.Font.Size;
          ACanvas.Font.Color:=clGray;
          ACanvas.TextOut(2,2,HelpText);

//        ACanvas:=CreateDrawCanvas('TSkinWinMemo.WMPaint');
//        if ACanvas<>nil then
//        begin
//          try
//            ACanvas.Prepare(DC);
//
//            FPaintData:=GlobalNullPaintData;
//            FPaintData.IsDrawInteractiveState:=True;
//            FPaintData.IsInDrawDirectUI:=False;
//            TSkinMemoDefaultType(Self.GetSkinControlType).CustomPaintHelpText(
//                  ACanvas,
//                  Self.GetCurrentUseMaterial,
//                  RectF(Self.GetClientRect.Left,Self.GetClientRect.Top,Self.GetClientRect.Right,Self.GetClientRect.Bottom),
//                  FPaintData);
//
//          finally
//            FreeAndNil(ACanvas);
//          end;
//        end;
        finally
          FreeAndNil(ACanvas);
        end;

      finally
        ReleaseDC(Handle,ADC);
      end;
//    end;

  end;
end;
{$ENDIF}

{ TPageComboBox }

constructor TPageComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FValues:=TStringList.Create;
end;

destructor TPageComboBox.Destroy;
begin
  FreeAndNil(FValues);
  inherited;
end;

function TPageComboBox.GetPostValue(ASetting: TFieldControlSetting;
  APageDataDir: String; ASetRecordFieldValueIntf: ISetRecordFieldValue;
  var AErrorMessage: String): Variant;
//var
//  AStringList:TStringList;
begin
  if Self.ItemIndex=-1 then
  begin
    Result:='';
    Exit;
  end;

  {$IFDEF FMX}
  Result:=Self.Items[Self.ItemIndex];
  {$ENDIF}
  {$IFDEF VCL}
//      Result:=TComboBox(AFieldControlSettingMap.Component).Text;
//  AStringList:=TStringList.Create;
//  try
//    AStringList.CommaText:=ASetting.options_value;
//    Result:=AStringList[Self.ItemIndex];
//  finally
//    FreeAndNil(AStringList);
//  end;
  Result:=FValues[Self.ItemIndex];
  {$ENDIF}

end;

//function TPageComboBox.GetProp(APropName: String): Variant;
//begin
//
//end;

function TPageComboBox.GetPropJsonStr: String;
begin

end;

function TPageComboBox.LoadFromFieldControlSetting(
  ASetting: TFieldControlSetting;AFieldControlSettingMap:TObject): Boolean;
begin

  //标准控件
//  Self.Items.CommaText:=ASetting.options_caption;

  {$IFDEF FMX}
  Self.Prop.HelpText:=ASetting.input_prompt;
  {$ENDIF}
  {$IFDEF VCL}
  Self.TextHint:=ASetting.input_prompt;
  {$ENDIF}

  Items.Assign(ASetting.FOptionCaptions);

  FValues.Assign(ASetting.FOptionValues);
  Self.ItemIndex:=-1;
  //因为ItemIndex设置为了-1,但是内容没有清空
  Text:='';


//  if ASetting.text_font_size>0 then//高分屏下字体会变很大
//  begin
//    Self.Font.Size:=ASetting.text_font_size;
//  end;


  Result:=True;
end;

procedure TPageComboBox.SetControlValue(ASetting: TFieldControlSetting;
  APageDataDir, AImageServerUrl: String; AValue: Variant; AValueCaption: String;
  AGetDataIntfResultFieldValueIntf: IGetDataIntfResultFieldValue);
//var
//  AStringList:TStringList;
begin
  {$IFDEF FMX}
  Self.ItemIndex:=Self.Items.IndexOf(AValue);
  {$ENDIF}
  {$IFDEF VCL}
  //TComboBox(AFieldControlSettingMap.Component).Text:=AValue;
//  AStringList:=TStringList.Create;
//  try
//    AStringList.CommaText:=ASetting.options_value;
//    Self.ItemIndex:=AStringList.IndexOf(AValue);
//  finally
//    FreeAndNil(AStringList);
//  end;
    Self.ItemIndex:=FValues.IndexOf(AValue);
  {$ENDIF}

end;

procedure TPageComboBox.SetOnChange(Value: TNotifyEvent);
begin
  OnChange:=Value;
end;

//procedure TPageComboBox.SetProp(APropName: String; APropValue: Variant);
//begin
//
//end;

procedure TPageComboBox.SetPropJsonStr(AJsonStr: String);
begin

end;



procedure TPageComboBox.DoReturnFrame(AFromFrame:TFrame);
begin

end;



//procedure TPageComboBox.WMPaint(var Message: TWMPaint);
//var
//  ADC:HDC;
//  ACanvas:TCanvas;
////  ACanvas:TDrawCanvas;
//begin
//  Inherited;
//
//  //绘制提示文本
//  if (Text='') and (Self.HelpText<>'') then
//  begin
////    Canvas.
////    if Self.GetSkinControlType<>nil then
////    begin
//      ADC := GetDC(Handle);
//      try
//
//        ACanvas:=TCanvas.Create;
//        try
//          ACanvas.Handle:=ADC;
//          ACanvas.Font.Size:=Self.Font.Size;
//          ACanvas.Font.Color:=clGray;
//          ACanvas.TextOut(2,0,HelpText);
//
////        ACanvas:=CreateDrawCanvas('TSkinWinMemo.WMPaint');
////        if ACanvas<>nil then
////        begin
////          try
////            ACanvas.Prepare(DC);
////
////            FPaintData:=GlobalNullPaintData;
////            FPaintData.IsDrawInteractiveState:=True;
////            FPaintData.IsInDrawDirectUI:=False;
////            TSkinMemoDefaultType(Self.GetSkinControlType).CustomPaintHelpText(
////                  ACanvas,
////                  Self.GetCurrentUseMaterial,
////                  RectF(Self.GetClientRect.Left,Self.GetClientRect.Top,Self.GetClientRect.Right,Self.GetClientRect.Bottom),
////                  FPaintData);
////
////          finally
////            FreeAndNil(ACanvas);
////          end;
////        end;
//        finally
//          FreeAndNil(ACanvas);
//        end;
//
//      finally
//        ReleaseDC(Handle,ADC);
//      end;
////    end;
//
//  end;
//
//end;

//{$ENDIF VCL}

end.
