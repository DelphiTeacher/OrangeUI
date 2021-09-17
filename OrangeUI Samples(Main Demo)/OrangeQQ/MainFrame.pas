//convert pas to utf8 by ¥

unit MainFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  uUIFunction,
  MessageFrame,
  StateFrame,
  SettingFrame,
  ContactorFrame,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinPageControlType, uSkinFireMonkeyPageControl,
  uSkinFireMonkeyNotifyNumberIcon, uSkinFireMonkeyControl,
  uSkinFireMonkeySwitchPageListPanel, uSkinButtonType, uSkinNotifyNumberIconType;

type
  TFrameMain = class(TFrame)
    pcMain: TSkinFMXPageControl;
    nniState: TSkinFMXNotifyNumberIcon;
    nniMessage: TSkinFMXNotifyNumberIcon;
    tsState: TSkinFMXTabSheet;
    tsContactor: TSkinFMXTabSheet;
    tsMessage: TSkinFMXTabSheet;
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;


var
  GlobalMainFrame:TFrameMain;

implementation

{$R *.fmx}

{ TFrameMain }

constructor TFrameMain.Create(AOwner: TComponent);
begin
  inherited;

  Self.pcMain.Properties.ActivePage:=tsMessage;

  //显示消息界面
  ShowFrame(TFrame(GlobalMessageFrame),TFrameMessage,tsMessage,nil,nil,nil,Application,False,True,ufsefNone);

  //显示联系人界面
  ShowFrame(TFrame(GlobalContactorFrame),TFrameContactor,tsContactor,nil,nil,nil,Application,False,True,ufsefNone);

  //显示动态界面
  ShowFrame(TFrame(GlobalStateFrame),TFrameState,tsState,nil,nil,nil,Application,False,True,ufsefNone);

end;

end.
