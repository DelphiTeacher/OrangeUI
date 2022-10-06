unit Unit12;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDrawCanvas, uSkinItems,
  Math,

  uDrawParam,
  uGraphicCommon,
  uDrawTextParam,
  uDrawPictureParam,
  ListItemStyle_IconTop_CaptionBottom,
  uSkinItemDesignerPanelType,

  uLang,

  uSkinWindowsControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListViewType, uSkinPanelType, Vcl.StdCtrls;

type
  TForm12 = class(TForm)
    lvMainMenu: TSkinWinListView;
    pnlToolbar: TSkinWinPanel;
    pnlBottomBar: TSkinWinPanel;
    lblDate: TLabel;
    lblTime: TLabel;
    procedure lvMainMenuPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRect);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

{$R *.dfm}

procedure TForm12.FormCreate(Sender: TObject);
begin

  //1280*1024
  Width:=1280;
  Height:=1024;

  GlobalDefaultFontFamily:='微软雅黑';
  GlobalIsUseDefaultFontFamily:=True;



  //英文
  Self.Caption:='Smart medical self-service platform';
  Self.pnlToolbar.Caption:=Self.Caption;

  Self.lvMainMenu.Prop.Items.FindItemByCaption('预约签到').Caption:='Sign in by appointment';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('门诊缴费').Caption:='Outpatient payment';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('挂号预约').Caption:='Register an appointment';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('化验单打印').Caption:='Test report printing';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('门诊预存').Caption:='Outpatient pre-storage';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('门诊明细').Caption:='Outpatient details';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('多功能查询').Caption:='Multi-function query';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('凭条补打').Caption:='Receipt make up';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('医后付签约').Caption:='Signing a post-medical payment';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('挂号取消').Caption:='Cancellation';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('住院功能').Caption:='Hospitalization function';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('满意度调查').Caption:='satisfaction survey';

end;

procedure TForm12.FormResize(Sender: TObject);
var
  AContentWidth:Double;
  AContentHeight:Double;
  ADefualtItemHeight:Integer;
  AFooterItemHeight:Integer;
  I: Integer;
  AFooterItemCount:Integer;
begin
  //先计算给ListView的剩余区域
  AContentHeight:=ClientHeight
                -Self.pnlToolbar.Height
                -Self.pnlBottomBar.Height
                -Self.lvMainMenu.Margins.Top
                -Self.lvMainMenu.Margins.Bottom
                -Self.lvMainMenu.Prop.ItemSpace*2
                ;
  AContentWidth:=ClientWidth
                -Self.lvMainMenu.Margins.Left
                -Self.lvMainMenu.Margins.Right;

  Self.lvMainMenu.Prop.Items.BeginUpdate;
  try
    ADefualtItemHeight:=Ceil(AContentHeight*0.4);
    Self.lvMainMenu.Prop.ItemHeight:=ADefualtItemHeight;

    //第一行按钮
    Self.lvMainMenu.Prop.Items[0].Width:=Floor((AContentWidth-2*Self.lvMainMenu.Prop.ItemSpace)*0.25);
    Self.lvMainMenu.Prop.Items[1].Width:=Floor((AContentWidth-2*Self.lvMainMenu.Prop.ItemSpace)*0.5);
    Self.lvMainMenu.Prop.Items[2].Width:=Floor((AContentWidth-2*Self.lvMainMenu.Prop.ItemSpace)*0.25);
    Self.lvMainMenu.Prop.Items[2].Height:=Floor(AContentHeight*0.8)+Self.lvMainMenu.Prop.ItemSpace+2;

    //第二行按钮
    Self.lvMainMenu.Prop.Items[3].Width:=Floor((AContentWidth-3*Self.lvMainMenu.Prop.ItemSpace)*0.25);
    Self.lvMainMenu.Prop.Items[4].Width:=Floor((AContentWidth-3*Self.lvMainMenu.Prop.ItemSpace)*0.25);
    Self.lvMainMenu.Prop.Items[5].Width:=Floor((AContentWidth-3*Self.lvMainMenu.Prop.ItemSpace)*0.25);


    //底部小按钮的高度
    AFooterItemCount:=0;
    AFooterItemHeight:=Floor(AContentHeight*0.2);
    for I := 0 to Self.lvMainMenu.Prop.Items.Count-1 do
    begin
      if Self.lvMainMenu.Prop.Items[I].ItemType=sitFooter then
      begin
        Self.lvMainMenu.Prop.Items[I].Height:=AFooterItemHeight;
        Inc(AFooterItemCount);
      end;
    end;

    //底部小按钮的宽度
    for I := 0 to Self.lvMainMenu.Prop.Items.Count-1 do
    begin
      if Self.lvMainMenu.Prop.Items[I].ItemType=sitFooter then
      begin
        Self.lvMainMenu.Prop.Items[I].Width:=(AContentWidth-AFooterItemCount*Self.lvMainMenu.Prop.ItemSpace) / AFooterItemCount;
      end;
    end;


  finally
    Self.lvMainMenu.Prop.Items.EndUpdate();
  end;


end;

procedure TForm12.lvMainMenuPrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRect);
var
  AFrameListItemStyle_IconTop_CaptionBottom:TFrameListItemStyle_IconTop_CaptionBottom;
begin
  //大按钮
  if (AItem.ItemType=sitDefault) and (AItemDesignerPanel.Parent is TFrameListItemStyle_IconTop_CaptionBottom) then
  begin
    AFrameListItemStyle_IconTop_CaptionBottom:=TFrameListItemStyle_IconTop_CaptionBottom(AItemDesignerPanel.Parent);
    AFrameListItemStyle_IconTop_CaptionBottom.ItemDesignerPanel.Material.BackColor.IsRound:=True;
    AFrameListItemStyle_IconTop_CaptionBottom.ItemDesignerPanel.Material.BackColor.RoundWidth:=3;
    AFrameListItemStyle_IconTop_CaptionBottom.ItemDesignerPanel.Material.BackColor.RoundHeight:=3;
    //设置设计面板上Label的字体
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemCaption.Material.DrawCaptionParam.FontColor:=clWhite;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemCaption.Material.DrawCaptionParam.FontSize:=16;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemCaption.Height:=AItemDrawRect.Height div 3;
    //设置设计面板上图标的边距
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Enabled:=True;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.SizeType:=TDPSizeType.dpstPixel;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Top:=20;
//    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Bottom:=20;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Left:=20;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Right:=20;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.PictureVertAlign:=TPictureVertAlign.pvaBottom;
  end;

  //小按钮
  if (AItem.ItemType=sitFooter) and (AItemDesignerPanel.Parent is TFrameListItemStyle_IconTop_CaptionBottom) then
  begin
    AFrameListItemStyle_IconTop_CaptionBottom:=TFrameListItemStyle_IconTop_CaptionBottom(AItemDesignerPanel.Parent);
    AFrameListItemStyle_IconTop_CaptionBottom.ItemDesignerPanel.Material.BackColor.IsRound:=True;
    AFrameListItemStyle_IconTop_CaptionBottom.ItemDesignerPanel.Material.BackColor.RoundWidth:=3;
    AFrameListItemStyle_IconTop_CaptionBottom.ItemDesignerPanel.Material.BackColor.RoundHeight:=3;
    //设置设计面板上Label的字体
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemCaption.Material.DrawCaptionParam.FontColor:=clBlack;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemCaption.Material.DrawCaptionParam.FontSize:=12;
    //设置设计面板上图标的边距
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Enabled:=True;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.SizeType:=TDPSizeType.dpstPixel;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Top:=10;
//    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Bottom:=20;
  end;

end;

end.
