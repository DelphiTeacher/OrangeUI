unit ListItemStyle_CompanyInfo;

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
  TFrameListItemStyle_CompanyInfo = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinWinItemDesignerPanel;
    lblItemCaption: TSkinWinLabel;
    lblEmailHint: TSkinWinLabel;
    lblPhoneHint: TSkinWinLabel;
    lblItemDetail1: TSkinWinLabel;
    lblItemDetail2: TSkinWinLabel;
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFrameListItemStyle_CompanyInfo }

function TFrameListItemStyle_CompanyInfo.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;


initialization
  RegisterListItemStyle('CompanyInfo',TFrameListItemStyle_CompanyInfo);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_CompanyInfo);

end.
