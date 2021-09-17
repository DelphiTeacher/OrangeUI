//convert pas to utf8 by ¥

unit LabelFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyLabel,
  uSkinFireMonkeyMultiColorLabel, FMX.Objects, FMX.Controls.Presentation,
  uBaseSkinControl, uSkinLabelType;

type
  TFrameLabel = class(TFrame)
    lblLink: TSkinFMXLabel;
    lblAbout: TSkinFMXLabel;
    lblVertStyle: TSkinFMXLabel;
    Label1: TLabel;
    Text1: TText;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
