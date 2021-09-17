//convert pas to utf8 by ¥

unit FormUnit1;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  StrUtils,

  XSuperObject,
  XSuperJson,


  uDataBaseConfig,
  DataBaseConfigForm,

  uBaseDBHelper,
  uADODBHelper,

  ServerMethodsUnit1,
  ImageIndyHttpServerModule,



  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, Web.HTTPApp, Data.DBXMSSQL,
  Data.DB, Data.SqlExpr, Data.FMTBcd, IdContext, IdCustomHTTPServer,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdHTTPServer;



type
  TForm1 = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    ButtonOpenBrowser: TButton;
    btnConfigDataBase: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure btnConfigDataBaseClick(Sender: TObject);
  private
    FDatabaseConfig:TDatabaseConfig;
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  WinApi.Windows, Winapi.ShellApi, Datasnap.DSSession;

procedure TForm1.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
end;

procedure TForm1.btnConfigDataBaseClick(Sender: TObject);
var
  frmDataBaseConfig: TfrmDataBaseConfig;
begin
  frmDataBaseConfig:=TfrmDataBaseConfig.Create(Application);
  frmDataBaseConfig.Init(GlobalDBHelper,FDatabaseConfig);
  frmDataBaseConfig.Show;

end;

procedure TForm1.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  StartServer;
  LURL := Format('http://localhost:%s', [EditPort.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TForm1.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TForm1.ButtonStopClick(Sender: TObject);
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;


  //停止HTTP
  dmImageIndyHttpServer.IdImageHTTPServer.Active:=False;


  //停止数据库连接
  if GetGlobalSQLDBHelper.Connection<>nil then
  begin
    GetGlobalSQLDBHelper.Connection.Connected:=False;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  FDatabaseConfig:=TDatabaseConfig.Create;

  GlobalDBHelper:=TADODBHelper.Create();
  FDatabaseConfig.Load();

  StartServer;
end;

procedure TForm1.StartServer;
begin
  if not FServer.Active then
  begin

    //启动DataSnap
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;


    //文件或图片的根目录
    ServerMethodsUnit1.WWWRootDir:=ExtractFilePath(Application.ExeName);
    //启动HTTP
    dmImageIndyHttpServer.WWWRootDir:=ExtractFilePath(Application.ExeName);
    dmImageIndyHttpServer.IdImageHTTPServer.DefaultPort:=StrToInt(Self.EditPort.Text)+1;

    dmImageIndyHttpServer.IdImageHTTPServer.Active:=True;



    //连接SQL
    GetGlobalSQLDBHelper.Connect(FDatabaseConfig);

//    GetGlobalSQLDBHelper.ConnectionString:=
//        'Provider=SQLOLEDB.1;'
//        +'Persist Security Info=True;'
//        +'Password='+GlobalDataBaseConfig.FDBPassword+';'
//        +'User ID='+GlobalDataBaseConfig.FDBUserName+';'
//        +'Initial Catalog='+GlobalDataBaseConfig.FDBDataBaseName+';'
//        +'Data Source='+GlobalDataBaseConfig.FDBHostName;
//
//
//    FreeGlobalSQLDBHelper;
//    GetGlobalSQLDBHelper.Connection.Connected:=True;

  end;
end;

end.
