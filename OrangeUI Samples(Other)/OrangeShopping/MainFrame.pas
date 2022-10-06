//convert pas to utf8 by ¥

unit MainFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinPageControlType, uSkinFireMonkeyPageControl,
  HomeFrame,
  MyFrame,
  ClassifyFrame,
  ShoppingCartFrame,
  uSkinFireMonkeyNotifyNumberIcon, uSkinFireMonkeyControl,
  uSkinFireMonkeySwitchPageListPanel,uUIFunction, uSkinButtonType,
  uSkinNotifyNumberIconType;

type
  TFrameMain = class(TFrame)
    pcMain: TSkinFMXPageControl;
    nniCartCount: TSkinFMXNotifyNumberIcon;
    tsClassify: TSkinFMXTabSheet;
    tsShoppingCart: TSkinFMXTabSheet;
    tsMy: TSkinFMXTabSheet;
    tsHome: TSkinFMXTabSheet;
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

  Self.pcMain.Properties.ActivePageIndex:=0;

  ShowFrame(TFrame(GlobalHomeFrame),TFrameHome,tsHome,nil,nil,nil,Application,False,True,ufsefNone);
  ShowFrame(TFrame(GlobalClassifyFrame),TFrameClassify,tsClassify,nil,nil,nil,Application,False,True,ufsefNone);
  ShowFrame(TFrame(GlobalShoppingCartFrame),TFrameShoppingCart,tsShoppingCart,nil,nil,nil,Application,False,True,ufsefNone);
  ShowFrame(TFrame(GlobalMyFrame),TFrameMy,tsMy,nil,nil,nil,Application,False,True,ufsefNone);

end;

end.
