//弹出框//
//convert pas to utf8 by ¥
unit uSkinFireMonkeyPopup;

interface
{$I FrameWork.inc}

{$I FMXPopup.inc}


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
  FMX.Forms,
  FMX.Styles.Objects,
  FMX.Graphics,
  uSkinPublic,
  uSkinMaterial,
  uComponentType,
  uVersion,
  uBinaryTreeDoc,
  uSkinPopupType,
  uDrawEngine,
  uBasePageStructure,
  uDrawCanvas,
//  uSkinPackage,
  uBaseList,
  FMX.DateTimeCtrls,

  uSkinFireMonkeyControl,

  uSkinRegManager,
  uSkinBufferBitmap;




Type
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXPopup=class(TPopup,
                      ISkinPopup,
                      ISkinControl,
                      ISkinControlMaterial,
                      ISkinItemBindingControl
                      )
  private
    {$I Source\Controls\INC\Common\ISkinControl_Declare.inc}
    {$I Source\Controls\INC\FMX\ISkinControl_Caption_Impl_Declare_FMX.inc}
    {$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Mouse_Declare_FMX.inc}
    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Property_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Declare.inc}
  protected
    function GetPopupProperties:TPopupProperties;
    procedure SetPopupProperties(Value:TPopupProperties);
  protected

    //控件绘制
    procedure Paint;overload;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    //刷新控件
    procedure Invalidate;

    function GetText:String;
  public
    property Prop:TPopupProperties read GetPopupProperties write SetPopupProperties;
  published
    //属性
    property PopupProperties:TPopupProperties read GetPopupProperties write SetPopupProperties;
    property Properties:TPopupProperties read GetPopupProperties write SetPopupProperties;
  end;






implementation





{ TSkinFMXPopup }

{$I Source\Controls\INC\FMX\ISkinControl_Caption_Impl_Code_FMX.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Code.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Code.inc}
{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Code_FMX.inc}
{$I Source\Controls\INC\FMX\ISkinControl_Control_Impl_Mouse_Code_FMX.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Code.inc}

function TSkinFMXPopup.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TPopupProperties;
end;

//function TSkinFMXPopup.GetSuitDefaultItemHeight:Double;
//begin
//  Result:=100;
//end;

procedure TSkinFMXPopup.Paint;
var
  ASkinMaterial:TSkinControlMaterial;
begin
    FCanvas.Prepare(Canvas);

    if (GetSkinControlType<>nil) then
    begin
      ASkinMaterial:=GetSkinControlType.GetPaintCurrentUseMaterial;
    end;


//    //绘制父控件背景
//    if (Self.GetCurrentUseMaterial<>nil) then
//    begin
//      if Not TSkinControlMaterial(Self.GetCurrentUseMaterial).IsTransparent then
//      begin
//        FCanvas.DrawRect(TSkinControlMaterial(Self.GetCurrentUseMaterial).BackColor,
//                          RectF(0,0,Width,Height));
//      end;
//    end;


    //绘制
    if Self.GetSkinControlType<>nil then
    begin
      FPaintData:=GlobalNullPaintData;
      FPaintData.IsDrawInteractiveState:=True;
      FPaintData.IsInDrawDirectUI:=False;
      Self.GetSkinControlType.Paint(FCanvas,ASkinMaterial,RectF(0,0,Self.Width,Self.Height),FPaintData);
    end;


    FCanvas.UnPrepare;

end;

function TSkinFMXPopup.GetText:String;
begin
  Result:=Text;
end;

constructor TSkinFMXPopup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Create_Code.inc}


  //创建控件属性
  FProperties:=Self.GetPropertiesClassType.Create(Self);

  FParentMouseEvent:=False;
  FMouseEventTransToParentType:=mettptAuto;


  Visible := True;

  AutoCapture := True;
  Self.SetAcceptsControls(True);
end;

destructor TSkinFMXPopup.Destroy;
begin
  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Destroy_Code.inc}
  FreeAndNil(FProperties);
  FreeAndNil(FCanvas);
  inherited;
end;

function TSkinFMXPopup.GetPopupProperties: TPopupProperties;
begin
  Result:=TPopupProperties(Self.FProperties);
end;

procedure TSkinFMXPopup.SetPopupProperties(Value: TPopupProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinFMXPopup.Invalidate;
begin
  Repaint;
end;


end.



