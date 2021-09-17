unit ItemGridFrame_DiffOddAndEvenRowColor;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualGridType, uSkinItemGridType, uSkinFireMonkeyItemGrid, uDrawCanvas,
  uSkinItems, uSkinVirtualListType, uSkinListBoxType;

type
  TFrameItemGrid_DiffOddAndEvenRowColor = class(TFrame)
    SkinFMXItemGrid1: TSkinFMXItemGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
