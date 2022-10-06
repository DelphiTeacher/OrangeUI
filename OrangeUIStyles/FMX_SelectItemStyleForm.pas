unit FMX_SelectItemStyleForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uDrawCanvas,

  uUIFunction,
  uSkinItems, uSkinFireMonkeyControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinListViewType,
  uSkinFireMonkeyListView;

type
  TfrmSelectItemStyle = class(TForm)
    lvData: TSkinFMXListView;
  private
    { Private declarations }
  public
    procedure Load(AListControl:TSkinCustomList;AItem:TBaseSkinItem);
    { Public declarations }
  end;

var
  frmSelectItemStyle: TfrmSelectItemStyle;

implementation

{$R *.fmx}

{ TfrmSelectItemStyle }

procedure TfrmSelectItemStyle.Load(AListControl:TSkinCustomList;AItem: TBaseSkinItem);
var
  I: Integer;
  ACaptionItem:TSkinItem;
  ASkinItem:TSkinItem;
  AListItemStyleFrame:TFrame;
  AListItemStyleReg:TListItemStyleReg;
begin

  if AListControl<>nil then
  begin
    Self.lvData.Prop.Assign(AListControl.Prop);
  end;


  Self.lvData.Prop.Items.BeginUpdate;
  try
    Self.lvData.Prop.Items.Clear;

    for I := 0 to GetGlobalListItemStyleRegList.Count-1 do
    begin
      AListItemStyleReg:=GetGlobalListItemStyleRegList[I];
      //ÃÌº”±ÍÃ‚
      ACaptionItem:=Self.lvData.Prop.Items.Add;
      ACaptionItem.Caption:=AListItemStyleReg.Name;
      ACaptionItem.Detail:=AListItemStyleReg.FrameClass.ClassName;
      ACaptionItem.Color:=TAlphaColorRec.Orange;

      if AItem<>nil then
      begin
//        ASkinItem:=TSkinItem(AItem.ClassType.Create);
        ASkinItem:=Self.lvData.Prop.Items.Add;
        ASkinItem.Assign(AItem);
        Self.lvData.Prop.Items.Add(ASkinItem);
      end
      else
      begin
        ASkinItem:=Self.lvData.Prop.Items.Add;
      end;


      AListItemStyleFrame:=AListItemStyleReg.FrameClass.Create(Self);
      SetFrameName(AListItemStyleFrame);
      ASkinItem.ItemType:=sitUseDrawItemDesignerPanel;
      ASkinItem.FDrawItemDesignerPanel:=(AListItemStyleFrame as IFrameBaseListItemStyle).ItemDesignerPanel;
      ASkinItem.Height:=ASkinItem.FDrawItemDesignerPanel.Height;
    end;
  finally
    Self.lvData.Prop.Items.EndUpdate();
  end;
end;

end.
