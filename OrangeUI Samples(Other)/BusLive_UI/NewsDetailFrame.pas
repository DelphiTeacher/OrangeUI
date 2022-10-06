//convert pas to utf8 by ¥
unit NewsDetailFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  BusLiveCommonSkinMaterialModule,
  uUIFunction,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinButtonType, uSkinPanelType;

type
  TFrameNewsDetail = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;


var
  GlobalNewsDetailFrame:TFrameNewsDetail;

implementation

{$R *.fmx}

end.
