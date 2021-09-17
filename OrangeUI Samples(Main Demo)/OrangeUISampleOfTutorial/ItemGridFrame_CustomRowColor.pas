unit ItemGridFrame_CustomRowColor;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualGridType, uSkinItemGridType, uSkinFireMonkeyItemGrid, uDrawCanvas,
  uSkinItems, uSkinVirtualListType, uSkinListBoxType;

type
  TFrameItemGrid_CustomRowColor = class(TFrame)
    SkinFMXItemGrid1: TSkinFMXItemGrid;
    procedure SkinFMXItemGrid1PrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItem: TBaseSkinItem; AItemDrawRect: TRect);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameItemGrid_CustomRowColor.SkinFMXItemGrid1PrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas; AItem: TBaseSkinItem;
  AItemDrawRect: TRect);
begin
  if TSkinItem(AItem).Caption='ÀîËÄ' then
  begin
    Self.SkinFMXItemGrid1.Material.RowBackColor:=TAlphaColorRec.Red;
  end
  else
  begin
    Self.SkinFMXItemGrid1.Material.RowBackColor:=TAlphaColorRec.White;
  end;

end;

end.
