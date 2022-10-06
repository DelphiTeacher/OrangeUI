//convert pas to utf8 by ¥
unit CityListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uUIFunction,
  uSkinItems,
  uSkinListBoxType,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinButtonType, uSkinPanelType, uDrawCanvas;

type
  TFrameCityList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    lbCityList: TSkinFMXListBox;
    pnlTop: TSkinFMXPanel;
    edtCityName: TSkinFMXEdit;
    btnLocationCity: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnLocationCityClick(Sender: TObject);
    procedure lbCityListClickItem(Sender: TSkinItem);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;


var
  GlobalCityListFrame:TFrameCityList;

implementation

{$R *.fmx}

procedure TFrameCityList.btnLocationCityClick(Sender: TObject);
begin
  //选中定位城市
  Self.lbCityList.Properties.SelectedItem:=TSkinListBoxItem(Self.lbCityList.Properties.Items.FindItemByCaption('南宁市'));
  //选中定位城市
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameCityList.btnReturnClick(Sender: TObject);
begin
//  FrameHistroy.OnReturnFrame:=nil;
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameCityList.lbCityListClickItem(Sender: TSkinItem);
begin
  //选中定位城市
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

end.
