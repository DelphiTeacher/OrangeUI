//convert pas to utf8 by ¥

unit ScrollBarFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyScrollBar,
  System.Math.Vectors, FMX.Controls3D, FMX.Layers3D, FMX.Controls.Presentation,
  uBaseSkinControl, uSkinScrollBarType;

type
  TFrameScrollBar = class(TFrame)
    sbMobileNormal: TSkinFMXScrollBar;
    SkinFMXScrollBar2: TSkinFMXScrollBar;
    SkinFMXScrollBar1: TSkinFMXScrollBar;
    SkinFMXScrollBar3: TSkinFMXScrollBar;
    SkinFMXScrollBar4: TSkinFMXScrollBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
