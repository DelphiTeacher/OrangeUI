//convert pas to utf8 by ¥

unit SwitchFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, //uSkinFireMonkeySwitch,
  uSkinFireMonkeyCheckBox, uSkinFireMonkeySwitch, uSkinFireMonkeySwitchBar,
  uBaseSkinControl, uSkinSwitchBarType;

type
  TFrameSwitch = class(TFrame)
    sbTest: TSkinFMXSwitchBar;
    SkinFMXSwitchBar1: TSkinFMXSwitchBar;
    SkinFMXSwitchBar2: TSkinFMXSwitchBar;
    SkinFMXSwitchBar3: TSkinFMXSwitchBar;
    SkinFMXSwitchBar4: TSkinFMXSwitchBar;
    SkinFMXSwitchBar5: TSkinFMXSwitchBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
