//convert pas to utf8 by ¥

unit ClassifyFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, uSkinFireMonkeyPanel,
  uSkinItems,
  uUIFunction,
  ClassifyProductListFrame,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox,
  uSkinFireMonkeyListView, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyCustomList, uDrawCanvas,
  uSkinLabelType, uSkinItemDesignerPanelType, uSkinListViewType, uSkinImageType,
  uSkinPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType;

type
  TFrameClassify = class(TFrame)
    lbClassify: TSkinFMXListBox;
    pnlToolBar: TSkinFMXPanel;
    lvSubClassify: TSkinFMXListView;
    imgSearch: TSkinFMXImage;
    ItemDefault: TSkinFMXItemDesignerPanel;
    imgMenuIcon: TSkinFMXImage;
    lblMenuCaption: TSkinFMXLabel;
    procedure ItemDefaultResize(Sender: TObject);
    procedure lvSubClassifyClickItem(Sender: TSkinItem);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;

    { Public declarations }
  end;

var
  GlobalClassifyFrame:TFrameClassify;

implementation

{$R *.fmx}

uses
  MainForm,MainFrame;

{ TFrameClassify }

constructor TFrameClassify.Create(AOwner: TComponent);
begin
  inherited;
  Self.lbClassify.Properties.SelectedItem:=
    Self.lbClassify.Properties.Items[0];
end;

procedure TFrameClassify.ItemDefaultResize(Sender: TObject);
begin
  Self.imgMenuIcon.Left:=(Self.ItemDefault.WidthInt-Self.imgMenuIcon.WidthInt) div 2;
end;

procedure TFrameClassify.lvSubClassifyClickItem(Sender: TSkinItem);
begin
  HideFrame;//(GlobalMainFrame,hfcttBeforeShowFrame);

  //显示产品列表界面
  ShowFrame(TFrame(GlobalClassifyProductListFrame),TFrameClassifyProductList,frmMain,nil,nil,nil,Application);
//  GlobalClassifyProductListFrame.FrameHistroy:=CurrentFrameHistroy;
end;

end.
