//convert pas to utf8 by ¥
unit GoTalkRoomFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  BusLiveCommonSkinMaterialModule,
  uUIFunction,
  TalkFrame,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyLabel, uSkinLabelType, uSkinButtonType, uSkinPanelType;

type
  TFrameGoTalkRoom = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    btnComeIn: TSkinFMXButton;
    btnGetOut: TSkinFMXButton;
    SkinFMXLabel1: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnGetOutClick(Sender: TObject);
    procedure btnComeInClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalGoTalkRoomFrame:TFrameGoTalkRoom;

implementation

{$R *.fmx}

uses
  MainForm;


procedure TFrameGoTalkRoom.btnComeInClick(Sender: TObject);
begin
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalTalkFrame),TFrameTalk,frmMain,nil,nil,nil,Application);
//  GlobalTalkFrame.FrameHistroy:=CurrentFrameHistroy;

end;

procedure TFrameGoTalkRoom.btnGetOutClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);

end;

procedure TFrameGoTalkRoom.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);

end;

end.
