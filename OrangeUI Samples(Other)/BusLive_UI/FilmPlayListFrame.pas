//convert pas to utf8 by ¥
unit FilmPlayListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  uUIFunction,
  BusLiveCommonSkinMaterialModule,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FilmPlayInfoFrame,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyImage, uSkinFireMonkeyLabel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView, uSkinMaterial,
  uSkinScrollControlType, uSkinVirtualListType, uSkinListViewType,
  uSkinCustomListType, uSkinLabelType, uSkinImageType, uSkinButtonType,
  uSkinPanelType, uDrawCanvas, uSkinItems;

type
  TFrameFilmPlayList = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlTop: TSkinFMXPanel;
    imgPicture: TSkinFMXImage;
    lblClassify: TSkinFMXLabel;
    btnPlay: TSkinFMXButton;
    lblCaption: TSkinFMXLabel;
    lblActors: TSkinFMXLabel;
    lvList: TSkinFMXListView;
    pnlListItemDefaultDevide: TSkinFMXPanel;
    btnPlayTimes: TSkinFMXButton;
    pnlInfo: TSkinFMXPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    procedure btnReturnClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure imgPictureClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure LoadData(AClassify:String;ACaption:String);
    { Public declarations }
  end;

var
  GlobalFilmPlayListFrame:TFrameFilmPlayList;

implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameFilmPlayList.btnPlayClick(Sender: TObject);
begin
  //显示播放列表
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalFilmPlayInfoFrame),TFrameFilmPlayInfo,frmMain,nil,nil,nil,Application);
//  GlobalFilmPlayInfoFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameFilmPlayList.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameFilmPlayList.imgPictureClick(Sender: TObject);
begin
  //显示播放列表
  HideFrame;////(Self);
  ShowFrame(TFrame(GlobalFilmPlayInfoFrame),TFrameFilmPlayInfo,frmMain,nil,nil,nil,Application);
//  GlobalFilmPlayInfoFrame.FrameHistroy:=CurrentFrameHistroy;
end;

procedure TFrameFilmPlayList.LoadData(AClassify, ACaption: String);
begin
  Self.lvList.Visible:=(AClassify='电视剧');
  Self.pnlToolBar.Caption:=ACaption;

end;

end.
