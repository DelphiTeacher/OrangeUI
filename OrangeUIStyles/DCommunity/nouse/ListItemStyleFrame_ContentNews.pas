unit ListItemStyleFrame_ContentNews;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  ListItemStyleFrame_DelphiContent,

  uSkinMaterial, uSkinButtonType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType, uSkinRegExTagLabelViewType, uSkinPanelType,
  uSkinFireMonkeyPanel, uSkinFireMonkeyButton, uSkinMultiColorLabelType,
  uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyImage, uSkinImageType,
  uSkinRoundImageType, uSkinFireMonkeyRoundImage, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel;

type
  TFrameListItemStyle_ContentNews = class(TFrameDelphiContentListItemStyle)
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  FrameListItemStyle_ContentNews: TFrameListItemStyle_ContentNews;

implementation

{$R *.fmx}


{ TFrameListItemStyle_ContentNews }

constructor TFrameListItemStyle_ContentNews.Create(AOwner: TComponent);
begin
  inherited;
  Self.ItemDesignerPanel.Prop.ItemCaptionBindingControl:=nil;
  Self.ItemDesignerPanel.Prop.ItemDetailBindingControl:=nil;

  Self.ItemDesignerPanel.Material.BackColor.DrawRectSetting.Enabled:=False;

  Self.imgItemBigPic.Material.ClipRoundWidth:=3;
  Self.imgItemBigPic.Material.ClipRoundHeight:=3;

  Self.btnComment.Margins.Top:=3;
  Self.btnComment.Margins.Bottom:=3;

  Self.lblItemCaption.Width:=Self.lblItemCaption.Width-10;
  Self.lblItemCaption.BindItemFieldName:='caption';
  Self.btnReadCount.BindItemFieldName:='read_count';
  Self.btnComment.BindItemFieldName:='comment_count';
  Self.lblItemDetail.Prop.Name1:='user_name';

  Self.lblItemDetail.Prop.Color1:=TAlphaColorRec.gray;

end;

initialization
  RegisterListItemStyle('ContentNews',TFrameListItemStyle_ContentNews);


finalization
  UnRegisterListItemStyle(TFrameListItemStyle_ContentNews);

end.
