//convert pas to utf8 by ¥

unit MainFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,
  ClassFrame,
  uSkinPageControlType, uSkinFireMonkeyPageControl, uSkinFireMonkeyControl,
  uSkinFireMonkeySwitchPageListPanel, uDrawPicture, uSkinImageList;

type
  TFrameMain = class(TFrame)
    pcMain: TSkinFMXPageControl;
    tsClass: TSkinFMXTabSheet;
    tsSchool: TSkinFMXTabSheet;
    tsMe: TSkinFMXTabSheet;
    imglistIcons: TSkinImageList;
  private
    { Private declarations }
  public
    FrameHistroy:TFrameHistroy;
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
  ShowFrame(TFrame(GlobalClassFrame),TFrameClass,tsClass,nil,nil,nil,Application,False,True,ufsefNone);
end;

end.
