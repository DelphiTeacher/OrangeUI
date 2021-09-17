//convert pas to utf8 by ¥

unit RollLabelFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl,
  FMX.Objects, FMX.Controls.Presentation,
  uBaseSkinControl, uSkinLabelType;

type
  TFrameRollLabel = class(TFrame)
    lblAbout: TSkinFMXRollLabel;
    lblLink: TSkinFMXRollLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
