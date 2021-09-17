//convert pas to utf8 by ¥
unit SystemNotificationInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uManager, uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uUIFunction, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo,EasyServiceCommonMaterialDataMoudle,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyLabel, uSkinLabelType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinButtonType, uSkinPanelType;

type
  TFrameSystemNotificationInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbNoticeInfo: TSkinFMXScrollBox;
    sbNoticeInfoCon: TSkinFMXScrollBoxContent;
    pnlAddr: TSkinFMXPanel;
    memContent: TSkinFMXMemo;
    pnlArea: TSkinFMXPanel;
    lblTitle: TSkinFMXLabel;
    lblTime: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
//    FrameHistroy:TFrameHistroy;
    procedure Load(AToolBarTitle:String;ANotice:TNotice);
  end;

var
  GlobalSystemNotificationInfoFrame:TFrameSystemNotificationInfo;

implementation

{$R *.fmx}

{ TFrameSystemNotificationInfo }

procedure TFrameSystemNotificationInfo.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameSystemNotificationInfo.Load(AToolBarTitle:String;ANotice: TNotice);
begin
  Self.pnlToolBar.Caption:=AToolBarTitle;

  Self.lblTitle.Text:=ANotice.caption;
  Self.memContent.Text:=ANotice.content;
  Self.lblTime.Text:=ANotice.createtime;

  Self.sbNoticeInfo.Height:=GetSuitScrollContentHeight(Self.sbNoticeInfoCon);
end;

end.
