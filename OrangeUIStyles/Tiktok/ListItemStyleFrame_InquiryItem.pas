unit ListItemStyleFrame_InquiryItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,

  uDrawCanvas,
  uSkinItems,
  uSkinBufferBitmap,

  uSkinCustomListType,
  EasyServiceCommonMaterialDataMoudle,
  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinMaterial;

type
  TFrameListItemStyle_InquiryItem = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    pnlTitle: TSkinFMXPanel;
    labKeyWord: TSkinFMXLabel;
    labKeyWordContent: TSkinFMXLabel;
    pnlUser: TSkinFMXPanel;
    pnlPostContainer: TSkinFMXPanel;
    labIntendWord: TSkinFMXLabel;
    labIntendWordContent: TSkinFMXLabel;
    imgUserHead: TSkinFMXImage;
    SkinFMXPanel2: TSkinFMXPanel;
    btnHome: TSkinFMXButton;
    labUserName: TSkinFMXLabel;
    labGetTime: TSkinFMXLabel;
    labComment: TSkinFMXLabel;
    pnlVideo: TSkinFMXPanel;
    imgVideoHead: TSkinFMXImage;
    lblVideoContent: TSkinFMXLabel;
    lblUnread: TSkinFMXLabel;
    procedure ItemDesignerPanelPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRectF);
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameListItemStyle_InquiryItem }

function TFrameListItemStyle_InquiryItem.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

//计算关键词，意向词宽度
procedure TFrameListItemStyle_InquiryItem.ItemDesignerPanelPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRectF);
var
  ASurplusWidth:Double;//除去未读后的剩余宽度
  AKeyWordWidth:Double;
  AIntendWordWidth:Double;
begin
  ASurplusWidth:=(Self.pnlTitle.Width-Self.lblUnread.Width-10)/2;

  //计算关键词宽度，背景按钮宽75
  AKeyWordWidth:=uSkinBufferBitmap.GetStringWidth(Self.labKeyWordContent.Caption,AItemDrawRect,Self.labKeyWordContent.Material.DrawCaptionParam);
  if (AKeyWordWidth + 75) > ASurplusWidth then
  begin
    Self.labKeyWord.Width:=ASurplusWidth;
  end
  else
  begin
    Self.labKeyWord.Width:= AKeyWordWidth + 75;
  end;

  //计算意向词宽度
  AIntendWordWidth:=uSkinBufferBitmap.GetStringWidth(Self.labIntendWordContent.Caption,AItemDrawRect,Self.labIntendWordContent.Material.DrawCaptionParam);
  if (AIntendWordWidth + 75) > ASurplusWidth then
  begin
    Self.labIntendWord.Width:=ASurplusWidth;
  end
  else
  begin
    Self.labIntendWord.Width:= AIntendWordWidth + 75;
  end;

end;

initialization
  RegisterListItemStyle('InquiryItem',TFrameListItemStyle_InquiryItem);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_InquiryItem);

end.
