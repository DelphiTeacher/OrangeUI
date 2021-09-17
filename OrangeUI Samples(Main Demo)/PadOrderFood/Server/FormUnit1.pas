unit FormUnit1;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,

  uConfig,
  StrUtils,

  uDataBaseConfig,
  DataBaseConfigForm,

  uBaseDBHelper,
  uADODBHelper,

  XSuperObject,
  XSuperJson,
  ServerMethodsUnit1,

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
    IdHTTPServer1: TIdHTTPServer;
    btnConfigDataBase: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure btnConfigDataBaseClick(Sender: TObject);
  private
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
  frmDataBaseConfig.Init(GlobalDBHelper);
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
  IdHTTPServer1.Active:=False;

  //停止数据库连接
  if GetGlobalSQLDBHelper.Connection<>nil then
  begin
    GetGlobalSQLDBHelper.Connection.Connected:=False;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);

  StartServer;
end;


//function CreateGUIDString:String;
//var
//  guid:TGUID;
//begin
//  CreateGUID(guid);
//  Result:=GUIDToString(guid);
//  Result:=ReplaceStr(Result,'{','');
//  Result:=ReplaceStr(Result,'}','');
//  Result:=ReplaceStr(Result,'-','');
//end;


procedure TForm1.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  LFilename: string;
  LPathname: string;

  ADataJson:ISuperObject;
  ATempFileDir:String;
  ATempFileName:String;
  APostStream:TMemoryStream;
begin
  //浏览器请求http://127.0.0.1:8008/index.html?a=1&b=2
  //ARequestInfo.Document  返回    /index.html
  //ARequestInfo.QueryParams 返回  a=1b=2
  //ARequestInfo.Params.Values['name']   接收get,post过来的数据
  ////webserver发文件
  ///
  LFilename := ARequestInfo.Document;

  if SameText(LFilename,'/Upload') then
  begin
    //上传文件
    //将数据流保存成临时文件

    ATempFileName:=ARequestInfo.Params.Values['FileName'];


//    if ARequestInfo.Params.Values['UploadType']='SpiritTempPic' then
//    begin
//      ATempFileDir:=GlobalConfig.GetWWWRootDir+'Upload\Spirit\Temp\';
//    end
//
//
//    else
//    if ARequestInfo.Params.Values['UploadType']='GoodsThumbPic' then
//    begin
//      ATempFileDir:=GlobalConfig.GetWWWRootDir+'Upload\Goods\ThumbPic\';
//    end
//    else
    if ARequestInfo.Params.Values['UploadType']='Goods' then
    begin
      ATempFileDir:=GlobalConfig.GetWWWRootDir+'Upload\Goods\'+ARequestInfo.Params.Values['FID']+'\';
    end
    ;

//    else
//    if ARequestInfo.Params.Values['UploadType']='BookPic' then
//    begin
//      ATempFileDir:=GlobalConfig.GetWWWRootDir+'Upload\Books\Pic\';
//    end
//    else
//    if ARequestInfo.Params.Values['UploadType']='BookDesc' then
//    begin
//      ATempFileDir:=GlobalConfig.GetWWWRootDir+'Upload\Books\'+ARequestInfo.Params.Values['FID']+'\BookDesc\';
//    end
//    else
//    if ARequestInfo.Params.Values['UploadType']='Book' then
//    begin
//      ATempFileDir:=GlobalConfig.GetWWWRootDir+'Upload\Books\'+ARequestInfo.Params.Values['FID']+'\';
//    end;


    System.SysUtils.ForceDirectories(ATempFileDir);



    //Spirit
    APostStream:=TMemoryStream.Create;
    ARequestInfo.PostStream.Position:=0;
    APostStream.CopyFrom(ARequestInfo.PostStream,ARequestInfo.PostStream.Size);
    APostStream.SaveToFile(ATempFileDir+ATempFileName);
    APostStream.Free;

    ADataJson:=TSuperObject.Create;
    ADataJson.S['FileName']:=ATempFileName;
    AResponseInfo.ContentText:=ReturnJson(SUCC,'保存成功',ADataJson).AsJSON;



  end
//  else
//  if SameText(LFilename,'/Upload') then
//  begin
//    //上传文件
//
//    ATempFileName:=ARequestInfo.Params.Values['FileName'];
//    ATempFileDir:=ARequestInfo.Params.Values['FileDir'];
//
//    APostStream:=TMemoryStream.Create;
//    ARequestInfo.PostStream.Position:=0;
//    APostStream.CopyFrom(ARequestInfo.PostStream,ARequestInfo.PostStream.Size);
//    ATempFileDir:=GlobalConfig.GetWWWRootDir+'Upload'+'\'+ATempFileDir;
//    //'Upload\Goods\'+ARequestInfo.Params.Values['FID']+'\';
//    APostStream.SaveToFile(ATempFileDir+ATempFileName);
//    APostStream.Free;
//
//    ADataJson:=TSuperObject.Create;
//    ADataJson.S['FileName']:=ATempFileName;
//    AResponseInfo.ContentText:=ReturnJson(SUCC,'保存成功',ADataJson).AsJSON;
//
//
//
//  end
  else
  begin
    //请求文件
    if LFilename = '/' then
    begin
      LFilename := 'index.html';
    end;
    LFilename:=ReplaceStr(LFilename,'/','\');

    if LFilename[1]='\' then
    begin
      LFilename:=Copy(LFilename,2,MaxInt);
    end;

    LPathname := GlobalConfig.GetWWWRootDir + LFilename;
    if FileExists(LPathname) then
    begin
      AResponseInfo.ContentStream := TFileStream.Create(LPathname, fmOpenRead + fmShareDenyWrite);//发文件
    end
    else
    begin
      AResponseInfo.ResponseNo := 404;
      AResponseInfo.ContentText := '找不到' + ARequestInfo.Document;
    end;

  end;




   //发html文件
   {AResponseInfo.ContentEncoding:='utf-8';
   AResponseInfo.ContentType :='text/html';
   AResponseInfo.ContentText:='<html><body>好</body></html>'; }

   //发xml文件
   {AResponseInfo.ContentType :='text/xml';
   AResponseInfo.ContentText:='<?xml version="1.0" encoding="utf-8"?>'
   +'<students>'
   +'<student sex = "male"><name>'+AnsiToUtf8('陈')+'</name><age>14</age></student>'
   +'<student sex = "female"><name>bb</name><age>16</age></student>'
   +'</students>';}

   //下载文件时，直接从网页打开而没有弹出保存对话框的问题解决
//AResponseInfo.CustomHeaders.Values['Content-Disposition'] :='attachment; filename="'+文件名+'"';
//替换 IIS
  {AResponseInfo.Server:='IIS/6.0';
  AResponseInfo.CacheControl:='no-cache';
  AResponseInfo.Pragma:='no-cache';
  AResponseInfo.Date:=Now;}
end;

procedure TForm1.StartServer;
begin
  if not FServer.Active then
  begin


    //启动DataSnap
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;

    //启动HTTP
    IdHTTPServer1.Active:=True;

    //连接SQL

    if GlobalConfig.GetDBOSAuthentication then
    begin
      GetGlobalSQLDBHelper.ConnectionString:=
          'Provider=SQLOLEDB.1;'
          +'Integrated Security=SSPI;Persist Security Info=False;'
          +'Initial Catalog='+GlobalConfig.GetDBDataBaseName+';'
          +'Data Source='+GlobalConfig.GetDBHostName;
    end
    else
    begin
      GetGlobalSQLDBHelper.ConnectionString:=
          'Provider=SQLOLEDB.1;'
          +'Persist Security Info=True;'
          +'Password='+GlobalConfig.GetDBPassword+';'
          +'User ID='+GlobalConfig.GetDBUserName+';'
          +'Initial Catalog='+GlobalConfig.GetDBDataBaseName+';'
          +'Data Source='+GlobalConfig.GetDBHostName;
    end;
//    GetGlobalSQLDBHelper.ReCreateConnection;
//    GetGlobalSQLDBHelper.ReConnected;

    FreeGlobalSQLDBHelper;
    GetGlobalSQLDBHelper.Connection.Connected:=True;

    Self.Caption:='MobilePos服务端'+' 启动成功';
  end;
end;

end.
