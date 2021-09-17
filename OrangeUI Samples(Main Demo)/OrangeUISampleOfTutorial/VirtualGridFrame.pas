//convert pas to utf8 by ¥

unit VirtualGridFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 

  uSkinItems,
  uDrawTextParam,
  uSkinScrollControlType,
  uSkinVirtualGridType,
  uSkinFireMonkeyVirtualGrid,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls;

type
  TFrameVirtualGrid = class(TFrame)
  private
    { Private declarations }
  public
    FVirtualGrid:TSkinFMXVirtualGrid;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameVirtualGrid }

constructor TFrameVirtualGrid.Create(AOwner: TComponent);
var
  AColumn:TSkinVirtualGridColumn;
  ARow:TBaseSkinItem;
begin
  inherited;

  FVirtualGrid:=TSkinFMXVirtualGrid.Create(Self);
  FVirtualGrid.Parent:=Self;
  FVirtualGrid.Align:=TAlignLayout.Client;
  FVirtualGrid.SkinControlType;
  FVirtualGrid.SelfOwnMaterial;
  FVirtualGrid.VertScrollBar;
  FVirtualGrid.HorzScrollBar;

  FVirtualGrid.SelfOwnMaterialToDefault.DrawGridCellDevideMaterial.IsDrawRowLine:=True;
  FVirtualGrid.SelfOwnMaterialToDefault.DrawColumnMaterial.DrawCaptionParam.FontVertAlign:=fvaCenter;
  FVirtualGrid.SelfOwnMaterialToDefault.DrawColumnMaterial.DrawCaptionParam.FontHorzAlign:=fhaCenter;
  FVirtualGrid.SelfOwnMaterialToDefault.DrawColumnMaterial.DrawCellTextParam.FontVertAlign:=fvaCenter;
  FVirtualGrid.SelfOwnMaterialToDefault.DrawColumnMaterial.DrawCellTextParam.FontHorzAlign:=fhaCenter;

  FVirtualGrid.Prop.VertScrollBarShowType:=TScrollBarShowType.sbstAutoCoverShow;
  FVirtualGrid.Prop.ItemHeight:=30;
  FVirtualGrid.Prop.FooterRowCount:=1;

  //添加表格行
  FVirtualGrid.Prop.Items.BeginUpdate;
  try
    ARow:=FVirtualGrid.Prop.Items.Add;

    ARow:=FVirtualGrid.Prop.Items.Add;

    ARow:=FVirtualGrid.Prop.Items.Add;
  finally
    FVirtualGrid.Prop.Items.EndUpdate;
  end;


  //添加表格列
  FVirtualGrid.Prop.Columns.BeginUpdate;
  try
    AColumn:=FVirtualGrid.Prop.Columns.Add;
    AColumn.Caption:='列1';

    AColumn:=FVirtualGrid.Prop.Columns.Add;
    AColumn.Caption:='列2';

    AColumn:=FVirtualGrid.Prop.Columns.Add;
    AColumn.Caption:='列3';

    AColumn:=FVirtualGrid.Prop.Columns.Add;
    AColumn.Caption:='列4';

    AColumn:=FVirtualGrid.Prop.Columns.Add;
    AColumn.Caption:='列5';
  finally
    FVirtualGrid.Prop.Columns.EndUpdate;
  end;

end;

end.
