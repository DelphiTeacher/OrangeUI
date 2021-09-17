//convert pas to utf8 by ¥
unit uSkinFireMonkeyButton;

//{$I FireMonkey.inc}
//
//{$I Source\Controls\uSkinButton_Impl_Code.inc}



interface
{$I FrameWork.inc}

uses
  Classes,
  uSkinButtonType;

type
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXButton=class(TBaseSkinButton)
  private
    aa:Integer;
  end;

  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXButtonGroup=class(TBaseSkinButtonGroup)
  end;

implementation


end.


