//convert pas to utf8 by ¥

unit FriendCircleCommonMaterialDataMoudle;

interface

uses
  System.SysUtils, System.Classes, uSkinPanelType, uSkinMaterial,
  uSkinButtonType, uSkinEditType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinCheckBoxType, uDrawPicture, uSkinImageList, uSkinLabelType,
  uSkinImageType, uSkinFrameImageType;

type
  TdmFriendCircleCommonMaterial = class(TDataModule)
    bdmReturnButton: TSkinButtonDefaultMaterial;
    pnlToolBarMaterial: TSkinPanelDefaultMaterial;
    edtHelpTextMaterial: TSkinEditDefaultMaterial;
    pnlBlackCaptionLeftMarginPanelMaterial: TSkinPanelDefaultMaterial;
    btnBlueColorButtonMaterial: TSkinButtonDefaultMaterial;
    lblNoticeTypeLabelMaterial: TSkinLabelDefaultMaterial;
    sbDefaultColorBackgroundScrollBoxMaterial: TSkinScrollBoxDefaultMaterial;
    btnRedColorButtonMaterial: TSkinButtonDefaultMaterial;
    pnlInputBlackCaptionPanelMaterial: TSkinPanelDefaultMaterial;
    btnOrangeRedBorderWhiteBackButtonMaterial: TSkinButtonDefaultMaterial;
    edtInputEditHasHelpTextMaterial: TSkinEditDefaultMaterial;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmFriendCircleCommonMaterial: TdmFriendCircleCommonMaterial;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
