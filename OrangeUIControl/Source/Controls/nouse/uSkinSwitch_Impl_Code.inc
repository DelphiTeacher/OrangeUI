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
  uSkinSwitchType,
  {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassUnit.inc},
  uDrawEngine,
  uDrawPicture,
  uSkinPicture,
  uDrawTextParam,
  uSkinRegManager,
  uDrawPictureParam;

type
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}=class({$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc},ISkinSwitch,IBindSkinItemBoolControl)
  private
//    FStoredCaption:String;
//    FStoredChecked:Boolean;
    function GetSwitchProperties:TSwitchProperties;
    procedure SetSwitchProperties(Value:TSwitchProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
  public
    //在点击事件中设置是否勾选属性
    procedure Click;override;
  protected
//    procedure StorePropertyWhenEnabledDesignTimePreviewBinding;override;
//    procedure ReStorePropertyWhenDisabledDesignTimePreviewBinding;override;
//    function SupportBindingItemProperty(BindingItemProperty:TBindingItemProperty):Boolean;
//    procedure BindingItemText(const AName:String;const AText:String;AIsDrawItemInteractiveState:Boolean);
    procedure BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
//    procedure BindingItemIcon(AIcon:TDrawPicture;AImageList:TObject;AImageIndex:Integer;ARefPicture:TSkinPicture;AIsDrawItemInteractiveState:Boolean);
  public
    function SelfOwnMaterialToDefault:TSkinSwitchDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinSwitchDefaultMaterial;
    function Material:TSkinSwitchDefaultMaterial;
  public
    property Prop:TSwitchProperties read GetSwitchProperties write SetSwitchProperties;
  published
    //属性
    property Properties:TSwitchProperties read GetSwitchProperties write SetSwitchProperties;
  end;




implementation




{ TSkinSwitch }

function {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.Material:TSkinSwitchDefaultMaterial;
begin
  Result:=TSkinSwitchDefaultMaterial(SelfOwnMaterial);
end;

function {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.SelfOwnMaterialToDefault:TSkinSwitchDefaultMaterial;
begin
  Result:=TSkinSwitchDefaultMaterial(SelfOwnMaterial);
end;

function {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.CurrentUseMaterialToDefault:TSkinSwitchDefaultMaterial;
begin
  Result:=TSkinSwitchDefaultMaterial(CurrentUseMaterial);
end;

procedure {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.Click;
begin
  GetSwitchProperties.Checked:=Not GetSwitchProperties.Checked;
  inherited;
end;

function {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TSwitchProperties;
end;

function {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.GetSwitchProperties: TSwitchProperties;
begin
  Result:=TSwitchProperties(Self.FProperties);
end;

procedure {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.SetSwitchProperties(Value: TSwitchProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetSwitchProperties.AdjustAutoSizeBounds;
  end;
  Inherited;
end;

//procedure {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.StorePropertyWhenEnabledDesignTimePreviewBinding;
//begin
//  Inherited;
//  FStoredCaption:=Caption;
//  FStoredChecked:=Self.GetSwitchProperties.Checked;
//end;
//
//procedure {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.ReStorePropertyWhenDisabledDesignTimePreviewBinding;
//begin
//  if Self.FIsStoredPropertyWhenEnabledDesignTimePreviewBinding then
//  begin
//    StaticCaption:=FStoredCaption;
//    Self.GetSwitchProperties.Checked:=FStoredChecked;
//  end;
//  Inherited;
//end;

//function {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.SupportBindingItemProperty(BindingItemProperty:TBindingItemProperty):Boolean;
//begin
//  Result:=(BindingItemProperty=bipItemText) or (BindingItemProperty=bipItemBool);
//end;

//procedure {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.BindingItemText(const AName:String;const AText:String;AIsDrawItemInteractiveState:Boolean);
//begin
//  StaticCaption:=AText;
//end;

procedure {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
begin
  Self.GetSwitchProperties.Checked:=ABool;
end;

//procedure {$I Source\Controls\uSkinSwitch_Impl_ClassName.inc}.BindingItemIcon(AIcon:TDrawPicture;AImageList:TObject;AImageIndex:Integer;ARefPicture:TSkinPicture;AIsDrawItemInteractiveState:Boolean);
//begin
//
//end;


end.
