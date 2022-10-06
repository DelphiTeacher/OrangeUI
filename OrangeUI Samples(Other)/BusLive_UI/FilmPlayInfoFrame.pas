//convert pas to utf8 by ¥
unit FilmPlayInfoFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  uUIFunction,
  uSkinItems,
  PlayVideoFrame,
  FilmActorInfoFrame,
  BusLiveCommonSkinMaterialModule,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinFireMonkeyImage, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListView, uSkinMaterial,
  uSkinScrollControlType, uSkinVirtualListType, uSkinListViewType,
  uSkinFireMonkeyLabel, uSkinButtonType, uDrawPicture, uSkinImageList,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollBox, uSkinScrollBoxContentType, uSkinLabelType,
  uSkinCustomListType, uSkinScrollBoxType, uSkinPanelType, uDrawCanvas;

type
  TFrameFilmPlayInfo = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    lbActor: TSkinFMXListView;
    lvList: TSkinFMXListView;
    pnlListItemDefaultDevide: TSkinFMXPanel;
    pnlTop: TSkinFMXPanel;
    lblCaption: TSkinFMXLabel;
    btnCache: TSkinFMXButton;
    btnFavor: TSkinFMXButton;
    btnShare: TSkinFMXButton;
    pnlPlay: TSkinFMXPanel;
    btnList: TSkinFMXButton;
    lblContent: TSkinFMXLabel;
    lblInfo: TSkinFMXLabel;
    btnComment: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure lbActorClickItem(Sender: TSkinItem);
  private
    FPlayVideoFrame:TFramePlayVideo;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalFilmPlayInfoFrame:TFrameFilmPlayInfo;

implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameFilmPlayInfo.btnReturnClick(Sender: TObject);
begin
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);

end;

constructor TFrameFilmPlayInfo.Create(AOwner: TComponent);
begin
  inherited;
  FPlayVideoFrame:=TFramePlayVideo.Create(Self);
  FPlayVideoFrame.Align:=TAlignLayout.Top;
  FPlayVideoFrame.Parent:=Self.pnlPlay;
  FPlayVideoFrame.Position.Y:=0;
end;

destructor TFrameFilmPlayInfo.Destroy;
begin
  FreeAndNil(FPlayVideoFrame);
  inherited;
end;

procedure TFrameFilmPlayInfo.lbActorClickItem(Sender: TSkinItem);
begin
  //明星简介
  HideFrame;//(Self);
  ShowFrame(TFrame(GlobalFilmActorInfoFrame),TFrameFilmActorInfo,frmMain,nil,nil,nil,Application);
//  GlobalFilmActorInfoFrame.FrameHistroy:=CurrentFrameHistroy;

end;

end.
