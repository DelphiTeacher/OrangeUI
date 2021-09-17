//convert pas to utf8 by ¥

unit FrameImageFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyFrameImage,
  uSkinFireMonkeyImage, uSkinFireMonkeyRoundImage, uBaseSkinControl,
  uSkinImageType, uSkinFrameImageType;

type
  TFrameFrameImage = class(TFrame)
    SkinFMXFrameImage2: TSkinFMXFrameImage;
    SkinFMXFrameImage1: TSkinFMXFrameImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
