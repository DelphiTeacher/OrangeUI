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

  GlobalDefaultFontFamily:='΢���ź�';
  GlobalIsUseDefaultFontFamily:=True;



  //Ӣ��
  Self.Caption:='Smart medical self-service platform';
  Self.pnlToolbar.Caption:=Self.Caption;

  Self.lvMainMenu.Prop.Items.FindItemByCaption('ԤԼǩ��').Caption:='Sign in by appointment';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('����ɷ�').Caption:='Outpatient payment';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('�Һ�ԤԼ').Caption:='Register an appointment';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('���鵥��ӡ').Caption:='Test report printing';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('����Ԥ��').Caption:='Outpatient pre-storage';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('������ϸ').Caption:='Outpatient details';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('�๦�ܲ�ѯ').Caption:='Multi-function query';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('ƾ������').Caption:='Receipt make up';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('ҽ��ǩԼ').Caption:='Signing a post-medical payment';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('�Һ�ȡ��').Caption:='Cancellation';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('סԺ����').Caption:='Hospitalization function';
  Self.lvMainMenu.Prop.Items.FindItemByCaption('����ȵ���').Caption:='satisfaction survey';

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
  //�ȼ����ListView��ʣ������
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

    //��һ�а�ť
    Self.lvMainMenu.Prop.Items[0].Width:=Floor((AContentWidth-2*Self.lvMainMenu.Prop.ItemSpace)*0.25);
    Self.lvMainMenu.Prop.Items[1].Width:=Floor((AContentWidth-2*Self.lvMainMenu.Prop.ItemSpace)*0.5);
    Self.lvMainMenu.Prop.Items[2].Width:=Floor((AContentWidth-2*Self.lvMainMenu.Prop.ItemSpace)*0.25);
    Self.lvMainMenu.Prop.Items[2].Height:=Floor(AContentHeight*0.8)+Self.lvMainMenu.Prop.ItemSpace+2;

    //�ڶ��а�ť
    Self.lvMainMenu.Prop.Items[3].Width:=Floor((AContentWidth-3*Self.lvMainMenu.Prop.ItemSpace)*0.25);
    Self.lvMainMenu.Prop.Items[4].Width:=Floor((AContentWidth-3*Self.lvMainMenu.Prop.ItemSpace)*0.25);
    Self.lvMainMenu.Prop.Items[5].Width:=Floor((AContentWidth-3*Self.lvMainMenu.Prop.ItemSpace)*0.25);


    //�ײ�С��ť�ĸ߶�
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

    //�ײ�С��ť�Ŀ��
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
  //��ť
  if (AItem.ItemType=sitDefault) and (AItemDesignerPanel.Parent is TFrameListItemStyle_IconTop_CaptionBottom) then
  begin
    AFrameListItemStyle_IconTop_CaptionBottom:=TFrameListItemStyle_IconTop_CaptionBottom(AItemDesignerPanel.Parent);
    AFrameListItemStyle_IconTop_CaptionBottom.ItemDesignerPanel.Material.BackColor.IsRound:=True;
    AFrameListItemStyle_IconTop_CaptionBottom.ItemDesignerPanel.Material.BackColor.RoundWidth:=3;
    AFrameListItemStyle_IconTop_CaptionBottom.ItemDesignerPanel.Material.BackColor.RoundHeight:=3;
    //������������Label������
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemCaption.Material.DrawCaptionParam.FontColor:=clWhite;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemCaption.Material.DrawCaptionParam.FontSize:=16;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemCaption.Height:=AItemDrawRect.Height div 3;
    //������������ͼ��ı߾�
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Enabled:=True;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.SizeType:=TDPSizeType.dpstPixel;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Top:=20;
//    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Bottom:=20;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Left:=20;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Right:=20;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.PictureVertAlign:=TPictureVertAlign.pvaBottom;
  end;

  //С��ť
  if (AItem.ItemType=sitFooter) and (AItemDesignerPanel.Parent is TFrameListItemStyle_IconTop_CaptionBottom) then
  begin
    AFrameListItemStyle_IconTop_CaptionBottom:=TFrameListItemStyle_IconTop_CaptionBottom(AItemDesignerPanel.Parent);
    AFrameListItemStyle_IconTop_CaptionBottom.ItemDesignerPanel.Material.BackColor.IsRound:=True;
    AFrameListItemStyle_IconTop_CaptionBottom.ItemDesignerPanel.Material.BackColor.RoundWidth:=3;
    AFrameListItemStyle_IconTop_CaptionBottom.ItemDesignerPanel.Material.BackColor.RoundHeight:=3;
    //������������Label������
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemCaption.Material.DrawCaptionParam.FontColor:=clBlack;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemCaption.Material.DrawCaptionParam.FontSize:=12;
    //������������ͼ��ı߾�
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Enabled:=True;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.SizeType:=TDPSizeType.dpstPixel;
    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Top:=10;
//    AFrameListItemStyle_IconTop_CaptionBottom.imgItemIcon.Material.DrawPictureParam.DrawRectSetting.Bottom:=20;
  end;

end;

end.
