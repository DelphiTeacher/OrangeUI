unit ListItemStyle_ContactInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  Graphics, Controls, Forms, Dialogs, uSkinLabelType,
  uSkinImageType, uSkinWindowsControl, uSkinItemDesignerPanelType,
  ImgList, uDrawPicture, uSkinImageList, uSkinMaterial;

type
  TFrameListItemStyle_ContactInfo = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinWinItemDesignerPanel;
    lblItemCaption: TSkinWinLabel;
    lblItemDetail: TSkinWinLabel;
    lblEmailHint: TSkinWinLabel;
    lblPhoneHint: TSkinWinLabel;
    lblWhatsAppHint: TSkinWinLabel;
    lblItemDetail1: TSkinWinLabel;
    lblItemDetail2: TSkinWinLabel;
    lblItemDetail3: TSkinWinLabel;
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFrameListItemStyle_ContactInfo }

function TFrameListItemStyle_ContactInfo.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;


initialization
  RegisterListItemStyle('ContactInfo',TFrameListItemStyle_ContactInfo);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_ContactInfo);

end.
