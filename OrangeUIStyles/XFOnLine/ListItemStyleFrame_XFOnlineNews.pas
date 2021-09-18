//convert pas to utf8 by ¥
unit ListItemStyleFrame_XFOnlineNews;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,


  BaseListItemStyleFrame, uSkinImageType, uSkinFireMonkeyImage, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel;

type
  TFrameXFOnlineNewsListItemStyle = class(TFrameBaseListItemStyle)
    imgItemIcon: TSkinFMXImage;
    lblItemDetail1: TSkinFMXLabel;
    SkinFMXLabel1: TSkinFMXLabel;
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



procedure TFrameXFOnlineNewsListItemStyle.ItemDesignerPanelResize(
  Sender: TObject);
begin
  inherited;

//  //图标的尺寸保持正方形
//  Self.imgItemIcon.Width:=Self.imgItemIcon.Height;

end;

initialization
  RegisterListItemStyle('XFOnlineNews',TFrameXFOnlineNewsListItemStyle);

finalization
  UnRegisterListItemStyle(TFrameXFOnlineNewsListItemStyle);


end.
