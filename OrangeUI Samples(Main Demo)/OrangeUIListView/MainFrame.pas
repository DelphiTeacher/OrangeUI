//convert pas to utf8 by ¥

unit MainFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,



  uBaseLog,
  uSkinItems,
  uUIFunction,


  uSkinFireMonkeyPanel, uSkinFireMonkeyLabel, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyCustomList,
  uSkinPanelType, uSkinLabelType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uDrawCanvas;

type
  TFrameMain = class(TFrame)
    lvOrangeUIControlDemo: TSkinFMXListBox;
    pnlToolBar: TSkinFMXPanel;
    ItemMenu: TSkinFMXItemDesignerPanel;
    lblItemMenuCaption: TSkinFMXLabel;
    ItemHeader: TSkinFMXItemDesignerPanel;
    lblHeaderCaption: TSkinFMXLabel;
    pnlItemHeaderSign: TSkinFMXPanel;
    lblItemHeaderDetail: TSkinFMXLabel;
    lblItemMenuDetail: TSkinFMXLabel;
    procedure lvOrangeUIControlDemoClickItem(Sender: TSkinItem);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;


var
  GlobalMainFrame:TFrameMain;

implementation

uses
  MainForm,
  ListViewDemoViewFrame;

{$R *.fmx}

constructor TFrameMain.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TFrameMain.lvOrangeUIControlDemoClickItem(Sender: TSkinItem);
begin
  if Sender.Caption='' then Exit;
  if Sender.ItemType<>sitDefault then Exit;

  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalListViewDemoViewFrame),TFrameListViewDemoView,frmMain,nil,nil,nil,frmMain,True,True,ufsefDefault);
  GlobalListViewDemoViewFrame.ShowDemo(Sender.Caption,Sender.Detail);


end;

end.
