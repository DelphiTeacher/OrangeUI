//convert pas to utf8 by ¥
unit NewsListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  BusLiveCommonSkinMaterialModule,
  uUIFunction,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListView, uSkinMaterial, uSkinScrollControlType,
  uSkinVirtualListType, uSkinListViewType, uSkinCustomListType, uSkinButtonType,
  uSkinPanelType, uDrawCanvas, uSkinItems;

type
  TFrameNewsList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    SkinFMXListView1_Material: TSkinListViewDefaultMaterial;
    SkinFMXListView1: TSkinFMXListView;
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalNewsListFrame:TFrameNewsList;

implementation

{$R *.fmx}

procedure TFrameNewsList.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

end.
