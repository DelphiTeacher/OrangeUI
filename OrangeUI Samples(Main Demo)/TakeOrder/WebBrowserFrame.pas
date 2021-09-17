//convert pas to utf8 by ¥

//convert pas to utf8 by ¥
unit WebBrowserFrame;

interface

uses
  System.SysUtils,uFuncCommon, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uFileCommon,
  uUIFunction,
  uComponentType,
  EasyServiceCommonMaterialDataMoudle,
  uInterfaceClass,
  uFrameContext,

  FMX.WebBrowser, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinFireMonkeyPanel, uSkinButtonType, uSkinPanelType;

type
  TFrameWebBrowser = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    pnlClient: TSkinFMXPanel;
    btnSync: TSkinFMXButton;
    btnReturn: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnSyncClick(Sender: TObject);
  private
    FWebBrowser: TWebBrowser;
    procedure DoWebBrowserDidFinishLoad(Sender:TObject);
    procedure DoShow;
    procedure DoHide;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    constructor Create(AOwner:TComponent);override;
    Destructor Destroy;override;
  public
    FUrl:String;
    procedure LoadUrl(AUrl:String);
    procedure LoadBodyHtml(ABodyHtml:String;ATempFileName:String);
    { Public declarations }
  end;

var
  GlobalWebBrowserFrame:TFrameWebBrowser;

implementation

{$R *.fmx}

{ TFrameNewsDetail }

procedure TFrameWebBrowser.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameWebBrowser.btnSyncClick(Sender: TObject);
begin
  LoadUrl(FUrl);
end;

constructor TFrameWebBrowser.Create(AOwner: TComponent);
begin
  inherited;
  FWebBrowser:=nil;
end;

destructor TFrameWebBrowser.Destroy;
begin
  FreeAndNil(FWebBrowser);

  inherited;
end;

procedure TFrameWebBrowser.DoHide;
begin

end;

procedure TFrameWebBrowser.DoShow;
begin
  //创建WebBrowser
  if FWebBrowser=nil then
  begin
    FWebBrowser:=TWebBrowser.Create(Self);
    FWebBrowser.Align:=TAlignLayout.{$IF CompilerVersion >= 35.0}Client{$ELSE}alClient{$IFEND};
    FWebBrowser.Parent:=Self.pnlClient;
    FWebBrowser.OnDidFinishLoad:=DoWebBrowserDidFinishLoad;
  end;

  FWebBrowser.Visible:=True;
end;

procedure TFrameWebBrowser.LoadBodyHtml(ABodyHtml:String;ATempFileName:String);
var
  AHtmlSource:TStringList;
  AHtmlLocalFileCodePath:String;
begin

  //把保存成html,然后用WebBrowser加载

  AHtmlSource:=TStringList.Create;
  try

    AHtmlSource.Add(''
      +#13#10+'<html>  '
      +#13#10+'<head>  '
      +#13#10+'<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />   '
      +#13#10+'<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />'
      +#13#10+'</head> '
      +#13#10+'<body>  '

      +ABodyHtml

      +#13#10+'</body> '
      +#13#10+'</html> ');


    //保存HTML文件
    AHtmlLocalFileCodePath:=uFileCommon.GetApplicationPath+ATempFileName;

    AHtmlSource.SaveToFile(AHtmlLocalFileCodePath,TEncoding.UTF8);

    //加载HTML文件
    LoadUrl('file://'+AHtmlLocalFileCodePath);

  finally
    uFuncCommon.FreeAndNil(AHtmlSource);
  end;

end;

procedure TFrameWebBrowser.LoadUrl(AUrl:String);
begin

  FUrl:=AUrl;

  //创建WebBrowser
  DoShow;

  //浏览网页
  Self.FWebBrowser.Navigate(FUrl);

  WebBrowserRealign;


  if uComponentType.IsAndroidIntelCPU and (Self.FWebBrowser.Align=TAlignLayout.Client) then
  begin
    Self.FWebBrowser.Align:=TAlignLayout.None;
    Self.FWebBrowser.Position.Y:=-uComponentType.SystemStatusBarHeight;
  end;
end;

procedure TFrameWebBrowser.DoWebBrowserDidFinishLoad(Sender: TObject);
begin
  //网页加载结束,隐藏滚动框
end;


end.
