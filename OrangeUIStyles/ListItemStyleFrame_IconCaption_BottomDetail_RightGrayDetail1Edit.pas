//convert pas to utf8 by ¥
unit ListItemStyleFrame_IconCaption_BottomDetail_RightGrayDetail1Edit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,


  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,
  EasyServiceCommonMaterialDataMoudle,


  BaseListItemStyleFrame, uSkinImageType, uSkinFireMonkeyImage, uSkinLabelType,
  uSkinFireMonkeyLabel, uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit;

type
  TFrameIconCaption_BottomDetail_RightGrayDetail1EditListItemStyle = class(TFrameBaseListItemStyle)
    imgItemIcon: TSkinFMXImage;
    lblItemDetail: TSkinFMXLabel;
    edtItemDetail1: TSkinFMXEdit;
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



procedure TFrameIconCaption_BottomDetail_RightGrayDetail1EditListItemStyle.ItemDesignerPanelResize(
  Sender: TObject);
begin
  inherited;

  //图标的尺寸保持正方形
  Self.imgItemIcon.Width:=Self.imgItemIcon.Height;

  //平分
  Self.lblItemCaption.Height:=Self.ItemDesignerPanel.Height/2;
end;

initialization
  RegisterListItemStyle('IconCaption_BottomDetail_RightGrayDetail1Edit',TFrameIconCaption_BottomDetail_RightGrayDetail1EditListItemStyle);

finalization
  UnRegisterListItemStyle(TFrameIconCaption_BottomDetail_RightGrayDetail1EditListItemStyle);


end.
