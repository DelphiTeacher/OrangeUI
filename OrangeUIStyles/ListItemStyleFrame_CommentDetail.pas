//convert pas to utf8 by ¥
unit ListItemStyleFrame_CommentDetail;

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
  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage;

type
  TFrameCommentDetailListItemStyle = class(TFrameBaseListItemStyle)
    lblComment: TSkinFMXMultiColorLabel;
    imgItemIcon: TSkinFMXImage;
    lblItemDetail3: TSkinFMXLabel;
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



procedure TFrameCommentDetailListItemStyle.ItemDesignerPanelResize(
  Sender: TObject);
begin
  inherited;


  //图标的尺寸保持正方形
  Self.imgItemIcon.Width:=Self.imgItemIcon.Height;
end;

initialization
  RegisterListItemStyle('CommentDetail',TFrameCommentDetailListItemStyle);

finalization
  UnRegisterListItemStyle(TFrameCommentDetailListItemStyle);

end.
