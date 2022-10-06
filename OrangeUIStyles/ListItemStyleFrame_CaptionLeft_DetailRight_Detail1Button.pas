//convert pas to utf8 by ¥
unit ListItemStyleFrame_CaptionLeft_DetailRight_Detail1Button;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uDrawCanvas,
  uSkinItems,
  uSkinBufferBitmap,
  uSkinVirtualListType,
  uSkinCustomListType,
  EasyServiceCommonMaterialDataMoudle,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinImageType,
  uSkinFireMonkeyImage, uDrawPicture, uSkinImageList, uSkinButtonType,
  uSkinFireMonkeyButton, uSkinPanelType, uSkinFireMonkeyPanel;


type
  TFrameListItemStyle_CaptionLeft_DetailRight_Detail1Button = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
    imglistExpanded: TSkinImageList;
    lblAutoSizeTag: TSkinFMXLabel;
    SkinFMXPanel1: TSkinFMXPanel;
    btnDetail1: TSkinFMXButton;
    procedure ItemDesignerPanelPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRectF);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;


implementation

{$R *.fmx}



{ TFrameBaseListItemStyle }

constructor TFrameListItemStyle_CaptionLeft_DetailRight_Detail1Button.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_CaptionLeft_DetailRight_Detail1Button.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

procedure TFrameListItemStyle_CaptionLeft_DetailRight_Detail1Button.ItemDesignerPanelPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel;
  AItem: TSkinItem;
  AItemDrawRect: TRectF);
var
  ACaptionWidth:Double;
  AItemDetailDrawRect:TRectF;
  AContentHeight:Double;
begin
  ACaptionWidth:=uSkinBufferBitmap.GetStringWidth(AItem.Caption,AItemDrawRect,Self.lblCaption.Material.DrawCaptionParam);
  Self.lblCaption.Width:=ACaptionWidth+10;//补计算误差


  //留给明细的空间
  AItemDetailDrawRect:=AItemDrawRect;
  AItemDetailDrawRect.Left:=Self.lblCaption.Left
                            +Self.lblCaption.Width;


  Self.lblDetail.Align:=TAlignLayout.Client;
  AItemDetailDrawRect.Right:=AItemDetailDrawRect.Right-Self.lblDetail.Margins.Right;
//  if Self.imgAccessory.Visible then
//  begin
    AItemDetailDrawRect.Right:=AItemDetailDrawRect.Right-Self.btnDetail1.Width;
//  end;
  Self.lblDetail.Width:=AItemDetailDrawRect.Width;

  //需要这个事件所处在的类型,是在绘制过程中还是在计算尺寸过程中
  if (Sender=nil) and (ACanvas=nil) then
  begin
    //在计算绘制的过程中

    //因为在绘制的过程中，右边为了绘制全一个汉字，会空出些许,所以要-10
    AItemDetailDrawRect.Right:=AItemDetailDrawRect.Right-20;
    AItemDetailDrawRect.Bottom:=MaxInt;

    AContentHeight:=uSkinBufferBitmap.GetStringHeight(AItem.Detail,
                                                          AItemDetailDrawRect,
                                                          Self.lblDetail.Material.DrawCaptionParam
                                                          );
    if AContentHeight>25 then
    begin
      //多行的情况下补一下高度
      AContentHeight:=AContentHeight+10;
    end;
    lblAutoSizeTag.Top:=AContentHeight;
  end;


end;

initialization
  RegisterListItemStyle('CaptionLeft_DetailRight_Detail1Button',TFrameListItemStyle_CaptionLeft_DetailRight_Detail1Button);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_CaptionLeft_DetailRight_Detail1Button);

end.
