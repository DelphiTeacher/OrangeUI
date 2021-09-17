//convert pas to utf8 by ¥

unit MainFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uBaseLog,
  uTimerTask,
  XSuperObject,
  XSuperJson,
  uManager,

  MyFrame,
  SpiritFrame,
  WaterfallSpiritFrame,

  uUIFunction,
  uFuncCommon,


  ClientModuleUnit1,


  MessageBoxFrame,


  uSkinFireMonkeyPageControl, uSkinFireMonkeyControl,
  uSkinFireMonkeySwitchPageListPanel, uDrawPicture, uSkinImageList,
  System.Notification, uSkinPageControlType, uBaseSkinControl,
  uSkinSwitchPageListPanelType;

type
  TFrameMain = class(TFrame)
    pcMain: TSkinFMXPageControl;
    tsSpirit: TSkinFMXTabSheet;
    tsMy: TSkinFMXTabSheet;
    tsWaterfall: TSkinFMXTabSheet;
    procedure pcMainChange(Sender: TObject);
  public
    //朋友圈
    FSpiritFrame:TFrameSpirit;
    FWaterfallSpiritFrame:TFrameWaterfallSpirit;
    //我的
    FMyFrame:TFrameMy;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalMainFrame:TFrameMain;


implementation

uses
//  UpdateFrame,
  MainForm;


{$R *.fmx}

{ TFrameMain }

destructor TFrameMain.Destroy;
begin

  inherited;
end;

procedure TFrameMain.pcMainChange(Sender: TObject);
var
  IsFirstCreate:Boolean;
begin

  if Self.pcMain.Prop.ActivePage=tsSpirit then
  begin
    IsFirstCreate:=FSpiritFrame=nil;
    ShowFrame(TFrame(FSpiritFrame),TFrameSpirit,Self.tsSpirit,nil,nil,nil,Self,False,True,ufsefNone);
    if IsFirstCreate then FSpiritFrame.Load;
  end;

  if Self.pcMain.Prop.ActivePage=tsWaterfall then
  begin
    IsFirstCreate:=FWaterfallSpiritFrame=nil;
    ShowFrame(TFrame(FWaterfallSpiritFrame),TFrameWaterfallSpirit,Self.tsWaterfall,nil,nil,nil,Self,False,True,ufsefNone);
    if IsFirstCreate then FWaterfallSpiritFrame.Load;
  end;

  if Self.pcMain.Prop.ActivePage=tsMy then
  begin
    IsFirstCreate:=FMyFrame=nil;
    ShowFrame(TFrame(FMyFrame),TFrameMy,Self.tsMy,nil,nil,nil,Self,False,True,ufsefNone);
    if IsFirstCreate then FMyFrame.Load;
  end;


end;

end.
