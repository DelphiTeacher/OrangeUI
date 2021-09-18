//convert pas to utf8 by ¥
unit ListItemStyleFrame_PetchipServiceShop;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uGraphicCommon,
  uSkinItems,
  uSkinBufferBitmap,
  uSkinCustomListType,
  BaseListItemStyleFrame,
  ListItemStyleFrame_Base,

  uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinButtonType, uSkinFireMonkeyButton,
  uDrawPicture, uSkinImageList;

type
  TFramePetchipServiceShopListItemStyle = class(TFrameBaseListItemStyleBase,IFrameBaseListItemStyle)
    imgItemIcon: TSkinFMXImage;
    lblItemDetail: TSkinFMXLabel;
    lblItemDetail1: TSkinFMXLabel;
    pnlDevide: TSkinFMXPanel;
    btnCall: TSkinFMXButton;
    SkinFMXPanel2: TSkinFMXPanel;
    lblItemDetail4: TSkinFMXLabel;
    imgItem: TSkinFMXImage;
    pnlClient: TSkinFMXPanel;
    SkinImageList1: TSkinImageList;
    procedure ItemDesignerPanelResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.fmx}

procedure TFramePetchipServiceShopListItemStyle.ItemDesignerPanelResize(
  Sender: TObject);
begin
  inherited;

  Self.imgItemIcon.Width:=
    Self.imgItemIcon.Height;
  Self.lblItemCaption.Position.X:=
    Self.pnlClient.Margins.Left
    +Self.imgItemIcon.Position.X
    +Self.imgItemIcon.Width
    +5;
end;

initialization
  RegisterListItemStyle('PetchipServiceShop',TFramePetchipServiceShopListItemStyle);


finalization
  UnRegisterListItemStyle(TFramePetchipServiceShopListItemStyle);

end.
