interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  uFuncCommon,
  Types,
  uGraphicCommon,
  uBinaryTreeDoc,
  uBufferBitmap,
  uDrawCanvas,
  uComponentType,
  uSkinRoundRectType,
  Math,
  {$IFDEF FMX}
  FMX.Controls,
  FMX.Types,
  {$ENDIF}

  {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassUnit.inc},
  uDrawEngine,
  uDrawPicture,
  uDrawTextParam,
  uSkinRegManager,
  uDrawPictureParam;




type
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  {$I Source\Controls\uSkinRoundRect_Impl_ClassName.inc}=class({$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc},ISkinRoundRect)
  private
    function GetRoundRectProperties:TRoundRectProperties;
    procedure SetRoundRectProperties(Value:TRoundRectProperties);
  protected

    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    function SelfOwnMaterialToDefault:TSkinRoundRectDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinRoundRectDefaultMaterial;
    function Material:TSkinRoundRectDefaultMaterial;
  public
    property Prop:TRoundRectProperties read GetRoundRectProperties write SetRoundRectProperties;
  published
    //属性
    property Properties:TRoundRectProperties read GetRoundRectProperties write SetRoundRectProperties;
  end;


implementation



{ TSkinRoundRect }

function {$I Source\Controls\uSkinRoundRect_Impl_ClassName.inc}.Material:TSkinRoundRectDefaultMaterial;
begin
  Result:=TSkinRoundRectDefaultMaterial(SelfOwnMaterial);
end;

function {$I Source\Controls\uSkinRoundRect_Impl_ClassName.inc}.SelfOwnMaterialToDefault:TSkinRoundRectDefaultMaterial;
begin
  Result:=TSkinRoundRectDefaultMaterial(SelfOwnMaterial);
end;

function {$I Source\Controls\uSkinRoundRect_Impl_ClassName.inc}.CurrentUseMaterialToDefault:TSkinRoundRectDefaultMaterial;
begin
  Result:=TSkinRoundRectDefaultMaterial(CurrentUseMaterial);
end;

function {$I Source\Controls\uSkinRoundRect_Impl_ClassName.inc}.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TRoundRectProperties;
end;

function {$I Source\Controls\uSkinRoundRect_Impl_ClassName.inc}.GetRoundRectProperties: TRoundRectProperties;
begin
  Result:=TRoundRectProperties(Self.FProperties);
end;

procedure {$I Source\Controls\uSkinRoundRect_Impl_ClassName.inc}.SetRoundRectProperties(Value: TRoundRectProperties);
begin
  Self.FProperties.Assign(Value);
end;

//procedure {$I Source\Controls\uSkinRoundRect_Impl_ClassName.inc}.Loaded;
//begin
//  Inherited;
//  Self.Properties.SyncToolBar;
//end;




end.
