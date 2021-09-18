//convert pas to utf8 by ¥
unit ListItemStyleFrame_IconCaption_BottomDetail_Service_Item_Book;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,


  BaseListItemStyleFrame, uSkinImageType, uSkinFireMonkeyImage, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinPanelType, uSkinFireMonkeyPanel;

type
  TFrameIconCaption_BottomDetail_Service_Item_BookListItemStyle = class(TFrameBaseListItemStyle)
    imgItemIcon: TSkinFMXImage;
    lblItemDetail: TSkinFMXLabel;
    lblItemDetail1: TSkinFMXLabel;
    pnlClient: TSkinFMXPanel;
    procedure ItemDesignerPanelResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.fmx}

//uses
//  uSkinCustomListType;



procedure TFrameIconCaption_BottomDetail_Service_Item_BookListItemStyle.ItemDesignerPanelResize(
  Sender: TObject);
begin
  inherited;

  //图标的尺寸保持正方形
  //Self.imgItemIcon.Width:=Self.imgItemIcon.Height;
end;

initialization
  RegisterListItemStyle('IconCaption_BottomDetail_Service_Item_Book',TFrameIconCaption_BottomDetail_Service_Item_BookListItemStyle);

finalization
  UnRegisterListItemStyle(TFrameIconCaption_BottomDetail_Service_Item_BookListItemStyle);


end.
