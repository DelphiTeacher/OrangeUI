//convert pas to utf8 by ¥
unit ListItemStyleFrame_ContentCommentDetail;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  BaseListItemStyleFrame, uSkinMultiColorLabelType,
  uSkinFireMonkeyMultiColorLabel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinScrollControlType, uSkinListViewType, uSkinRegExTagLabelViewType,
  uSkinButtonType, uSkinFireMonkeyButton;

type
  TFrameContentCommentDetailListItemStyle = class(TFrameBaseListItemStyle)
    imgItemIcon: TSkinFMXImage;
    lblItemDetail3: TSkinFMXLabel;
    lblComment: TSkinRegExTagLabelView;
    btnLikeComment: TSkinFMXButton;
    lblDeleteComment: TSkinFMXLabel;
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



procedure TFrameContentCommentDetailListItemStyle.ItemDesignerPanelResize(
  Sender: TObject);
begin
  inherited;


//  //图标的尺寸保持正方形
//  Self.imgItemIcon.Width:=Self.imgItemIcon.Height;
end;



initialization
  RegisterListItemStyle('ContentCommentDetail',TFrameContentCommentDetailListItemStyle);

finalization
  UnRegisterListItemStyle(TFrameContentCommentDetailListItemStyle);

end.
