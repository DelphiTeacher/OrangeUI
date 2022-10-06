//convert pas to utf8 by ¥
unit FilmActorInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uUIFunction,
  uSkinItems,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyImage, uSkinMaterial, uSkinButtonType, uSkinFireMonkeyLabel,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView, uSkinCustomListType,
  uSkinVirtualListType, uSkinListViewType, uSkinLabelType, uSkinImageType,
  uSkinScrollBoxContentType, uSkinScrollControlType, uSkinScrollBoxType,
  uSkinPanelType, uDrawCanvas;

type
  TFrameFilmActorInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    imgBack: TSkinFMXImage;
    imgHead: TSkinFMXImage;
    pnlName: TSkinFMXPanel;
    btnJob: TSkinFMXButton;
    btnArea: TSkinFMXButton;
    btnBirth: TSkinFMXButton;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXButton2: TSkinFMXButton;
    lbActor: TSkinFMXListView;
    SkinFMXButton3: TSkinFMXButton;
    SkinFMXListView1: TSkinFMXListView;
    procedure btnReturnClick(Sender: TObject);
    procedure lbActorClickItem(Sender: TSkinItem);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalFilmActorInfoFrame:TFrameFilmActorInfo;

implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameFilmActorInfo.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);

end;

procedure TFrameFilmActorInfo.lbActorClickItem(Sender: TSkinItem);
begin
  //明星简介
  HideFrame;////(Self);
  ShowFrame(TFrame(GlobalFilmActorInfoFrame),TFrameFilmActorInfo,frmMain,nil,nil,nil,Application);
//  GlobalFilmActorInfoFrame.FrameHistroy:=CurrentFrameHistroy;

end;

end.
