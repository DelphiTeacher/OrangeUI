unit ListItemStyleFrame_HeaderInfo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel;

type
  TFrameListItemStyle_HeaderInfo = class(TFrame)
    idpHeader: TSkinFMXItemDesignerPanel;
    imgHeader: TSkinFMXImage;
    lblName: TSkinFMXLabel;
    lblDetail: TSkinFMXLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
