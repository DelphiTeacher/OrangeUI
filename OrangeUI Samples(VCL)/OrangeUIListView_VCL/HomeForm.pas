unit HomeForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uSkinWindowsControl,

  uSkinItems,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListViewType, uSkinPanelType, uSkinImageListViewerType, uDrawPicture,
  uSkinImageList, uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uDrawCanvas;

type
  TfrmHome = class(TForm)
    SkinWinListView1: TSkinWinListView;
    SkinWinImageListViewer1: TSkinWinImageListViewer;
    pnlToolBar: TSkinWinPanel;
    SkinImageList1: TSkinImageList;
    procedure SkinWinListView1ClickItem(AItem: TSkinItem);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHome: TfrmHome;

implementation

{$R *.dfm}

procedure TfrmHome.SkinWinListView1ClickItem(AItem: TSkinItem);
begin
  ShowMessage(AItem.Caption);
end;

end.
