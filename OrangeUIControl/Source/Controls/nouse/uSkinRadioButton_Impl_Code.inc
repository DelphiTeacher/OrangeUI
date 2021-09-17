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
  uSkinRadioButtonType,
  {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassUnit.inc},
  uDrawEngine,
  uDrawPicture,
  uDrawTextParam,
  uSkinRegManager,
  uDrawPictureParam;

type
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  {$I Source\Controls\uSkinRadioButton_Impl_ClassName.inc}=class({$I Source\Controls\INC\Common\ISkinControl_Control_Impl_ClassName.inc},
                            ISkinRadioButton,
                            IBindSkinItemBoolControl)
  private
    function GetRadioButtonProperties:TRadioButtonProperties;
    procedure SetRadioButtonProperties(Value:TRadioButtonProperties);
  protected
    //��ȡ�ؼ�������
    function GetPropertiesClassType:TPropertiesClassType;override;
    //Ƥ���زĸ���֪ͨ�¼�
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
  public
    //�ڵ���¼��������Ƿ�ѡ����
    procedure StayClick;override;
  protected
    procedure BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
  public
    function SelfOwnMaterialToDefault:TSkinRadioButtonDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinRadioButtonDefaultMaterial;
    function Material:TSkinRadioButtonDefaultMaterial;
  public
    property Prop:TRadioButtonProperties read GetRadioButtonProperties write SetRadioButtonProperties;
  published
    //����
    property Caption;
    property Text;
    //����
    property Properties:TRadioButtonProperties read GetRadioButtonProperties write SetRadioButtonProperties;
  end;


implementation

{ TSkinRadioButton }

function {$I Source\Controls\uSkinRadioButton_Impl_ClassName.inc}.Material:TSkinRadioButtonDefaultMaterial;
begin
  Result:=TSkinRadioButtonDefaultMaterial(SelfOwnMaterial);
end;

function {$I Source\Controls\uSkinRadioButton_Impl_ClassName.inc}.SelfOwnMaterialToDefault:TSkinRadioButtonDefaultMaterial;
begin
  Result:=TSkinRadioButtonDefaultMaterial(SelfOwnMaterial);
end;

function {$I Source\Controls\uSkinRadioButton_Impl_ClassName.inc}.CurrentUseMaterialToDefault:TSkinRadioButtonDefaultMaterial;
begin
  Result:=TSkinRadioButtonDefaultMaterial(CurrentUseMaterial);
end;

procedure {$I Source\Controls\uSkinRadioButton_Impl_ClassName.inc}.StayClick;
begin
  if GetRadioButtonProperties.IsAutoChecked and Not GetRadioButtonProperties.Checked then
  begin
    GetRadioButtonProperties.Checked:=Not GetRadioButtonProperties.Checked;
  end;
  inherited;
end;

function {$I Source\Controls\uSkinRadioButton_Impl_ClassName.inc}.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TRadioButtonProperties;
end;

function {$I Source\Controls\uSkinRadioButton_Impl_ClassName.inc}.GetRadioButtonProperties: TRadioButtonProperties;
begin
  Result:=TRadioButtonProperties(Self.FProperties);
end;

procedure {$I Source\Controls\uSkinRadioButton_Impl_ClassName.inc}.SetRadioButtonProperties(Value: TRadioButtonProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure {$I Source\Controls\uSkinRadioButton_Impl_ClassName.inc}.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetRadioButtonProperties.AdjustAutoSizeBounds;
  end;
  Inherited;
end;

procedure {$I Source\Controls\uSkinRadioButton_Impl_ClassName.inc}.BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
begin
  Self.GetRadioButtonProperties.StaticChecked:=ABool;
end;



end.