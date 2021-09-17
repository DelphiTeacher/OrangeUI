//convert pas to utf8 by ¥

unit MultiColorLabelFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyLabel,
  uSkinFireMonkeyMultiColorLabel, uBaseSkinControl, uSkinMultiColorLabelType;

type
  TFrameMultiColorLabel = class(TFrame)
    SkinFMXMultiColorLabel2: TSkinFMXMultiColorLabel;
    SkinFMXMultiColorLabel3: TSkinFMXMultiColorLabel;
    SkinFMXMultiColorLabel4: TSkinFMXMultiColorLabel;
    lblPriceRightAlign: TSkinFMXMultiColorLabel;
    SkinFMXLabel1: TSkinFMXMultiColorLabel;
    SkinFMXMultiColorLabel1: TSkinFMXMultiColorLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
