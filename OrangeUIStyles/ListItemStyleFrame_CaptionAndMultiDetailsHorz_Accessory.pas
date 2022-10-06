//convert pas to utf8 by ¥
unit ListItemStyleFrame_CaptionAndMultiDetailsHorz_Accessory;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  Math,
  uDrawCanvas,
  uSkinItems,
  uSkinBufferBitmap,
  uSkinVirtualListType,
  uSkinCustomListType,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinImageType,
  uSkinFireMonkeyImage, uDrawPicture, uSkinImageList;


type
  TFrameListItemStyle_CaptionAndMultiDetailsHorz_Accessory = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    lblCaption: TSkinFMXLabel;
    imgAccessory: TSkinFMXImage;
    lblDetail: TSkinFMXLabel;
    imglistExpanded: TSkinImageList;
    lblAutoSizeTag: TSkinFMXLabel;
    lblDetail1: TSkinFMXLabel;
    lblDetail2: TSkinFMXLabel;
    lblDetail3: TSkinFMXLabel;
    lblDetail4: TSkinFMXLabel;
    procedure ItemDesignerPanelPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRectF);
    procedure ItemDesignerPanelResize(Sender: TObject);
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

constructor TFrameListItemStyle_CaptionAndMultiDetailsHorz_Accessory.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_CaptionAndMultiDetailsHorz_Accessory.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

procedure TFrameListItemStyle_CaptionAndMultiDetailsHorz_Accessory.ItemDesignerPanelPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel;
  AItem: TSkinItem;
  AItemDrawRect: TRectF);
//var
//  ACaptionWidth:Double;
//  AItemDetailDrawRect:TRectF;
//  AContentHeight:Double;
begin
//  ACaptionWidth:=uSkinBufferBitmap.GetStringWidth(AItem.Caption,AItemDrawRect,Self.lblCaption.Material.DrawCaptionParam);
//  Self.lblCaption.Width:=ACaptionWidth+10;//补计算误差
//
//
//  //留给明细的空间
//  AItemDetailDrawRect:=AItemDrawRect;
//  AItemDetailDrawRect.Left:=Self.lblCaption.Left
//                            +Self.lblCaption.Width;
//
//
//  Self.lblDetail.Align:=TAlignLayout.Client;
//  AItemDetailDrawRect.Right:=AItemDetailDrawRect.Right-Self.lblDetail.Margins.Right;
//  if Self.imgAccessory.Visible then
//  begin
//    AItemDetailDrawRect.Right:=AItemDetailDrawRect.Right-imgAccessory.Width;
//  end;
//  Self.lblDetail.Width:=AItemDetailDrawRect.Width;
//
//  //需要这个事件所处在的类型,是在绘制过程中还是在计算尺寸过程中
//  if (Sender=nil) and (ACanvas=nil) then
//  begin
//    //在计算绘制的过程中
//
//    //因为在绘制的过程中，右边为了绘制全一个汉字，会空出些许,所以要-10
//    AItemDetailDrawRect.Right:=AItemDetailDrawRect.Right-20;
//    AItemDetailDrawRect.Bottom:=MaxInt;
//
//    AContentHeight:=uSkinBufferBitmap.GetStringHeight(AItem.Detail,
//                                                          AItemDetailDrawRect,
//                                                          Self.lblDetail.Material.DrawCaptionParam
//                                                          );
//    if AContentHeight>25 then
//    begin
//      //多行的情况下补一下高度
//      AContentHeight:=AContentHeight+10;
//    end;
//    lblAutoSizeTag.Top:=AContentHeight;
//  end;


end;

procedure TFrameListItemStyle_CaptionAndMultiDetailsHorz_Accessory.ItemDesignerPanelResize(
  Sender: TObject);
var
  ADetailCount:Integer;
  ALeftWidth:Double;
begin
  //Caption占一半
  ALeftWidth:=Ceil(ItemDesignerPanel.width);
  if Self.imgAccessory.Visible then
  begin
    ALeftWidth:=ALeftWidth-imgAccessory.Width-imgAccessory.Margins.Left-imgAccessory.Margins.Right;
  end;
  Self.lblCaption.Width:=ALeftWidth * 2 / 5;
  ALeftWidth:=ALeftWidth-Self.lblCaption.Width;

  ADetailCount:=Ord(Self.lblDetail.Visible)
                +Ord(Self.lblDetail1.Visible)
                +Ord(Self.lblDetail2.Visible)
                +Ord(Self.lblDetail3.Visible)
                +Ord(Self.lblDetail4.Visible);
  if ADetailCount>0 then
  begin
    Self.lblDetail.Width:=ALeftWidth / ADetailCount;
    Self.lblDetail1.Width:=ALeftWidth / ADetailCount;
    Self.lblDetail2.Width:=ALeftWidth / ADetailCount;
    Self.lblDetail3.Width:=ALeftWidth / ADetailCount;
    Self.lblDetail4.Width:=ALeftWidth / ADetailCount;
  end;
end;

initialization
  RegisterListItemStyle('CaptionAndMultiDetailsHorz_Accessory',
                        TFrameListItemStyle_CaptionAndMultiDetailsHorz_Accessory,
                        40);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_CaptionAndMultiDetailsHorz_Accessory);

end.
