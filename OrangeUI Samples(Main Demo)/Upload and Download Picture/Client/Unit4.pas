//convert pas to utf8 by ¥

unit Unit4;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,

  IdURI,


//  uThumbCommon,
  uFileCommon,
  uFuncCommon,
  uUIFunction,
  XSuperObject,
  uBaseHttpControl,
//  uIdHttpControl,
  TakePictureMenuFrame,

  uFireMonkeyDrawCanvas,
//  uSkinPicture,
//  FMX.Surfaces,
//  uDrawRectParam,
//  {$IFDEF ANDROID}
//  Androidapi.JNI.GraphicsContentViewText,
//  FMX.Graphics.Android,
//  FMX.Helpers.Android,
//  Androidapi.Helpers,
//  {$ENDIF}

  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, uSkinFireMonkeyControl,
  uSkinFireMonkeyImage, uUrlPicture, uDownloadPictureManager, uSkinMaterial,
  uSkinImageType, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP;

type
  TForm4 = class(TForm)
    btnSelectPicture: TButton;
    btnUploadPicture: TButton;
    edtFileName: TEdit;
    edtUploadType: TEdit;
    Label4: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    edtServer: TEdit;
    edtPort: TEdit;
    Label3: TLabel;
    imgUploadPicture: TSkinFMXImage;
    btnDownload: TButton;
    DownloadPictureManager1: TDownloadPictureManager;
    imgDownloadPicture: TSkinFMXImage;
    imgDownloadThumbPicture: TSkinFMXImage;
    Label5: TLabel;
    Label6: TLabel;
    btnNativeRoundImage: TButton;
    btnDefaultRoundImage: TButton;
    edtRadius: TEdit;
    procedure btnSelectPictureClick(Sender: TObject);
    procedure btnUploadPictureClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    procedure btnNativeRoundImageClick(Sender: TObject);
    procedure btnDefaultRoundImageClick(Sender: TObject);
  private

    FFileName:String;
    FFileDir:String;
    FServerUrl:String;
    procedure DoAddPictureFromMenu(Sender: TObject; ABitmap: TBitmap);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.fmx}

procedure TForm4.btnDefaultRoundImageClick(Sender: TObject);
var
  ARoundBitmapByDelphi:TBitmap;
begin

  ARoundBitmapByDelphi:=DefaultGenerateColorClipRoundRectBitmap(TAlphaColorRec.Red,
                                                      100,
                                                      100,
                                                      StrToFloat(edtRadius.Text),
                                                      StrToFloat(edtRadius.Text));
  Self.imgDownloadThumbPicture.Prop.Picture.Assign(ARoundBitmapByDelphi);
  FreeAndNil(ARoundBitmapByDelphi);


end;

procedure TForm4.btnDownloadClick(Sender: TObject);
begin
  Self.imgDownloadPicture.Prop.Picture.Url:='http://'+Self.edtServer.Text+':'+Self.edtPort.Text+'/'+Self.edtUploadType.Text+'/'+Self.edtFileName.Text;
  Self.imgDownloadThumbPicture.Prop.Picture.Url:='http://'+Self.edtServer.Text+':'+Self.edtPort.Text+'/'+Self.edtUploadType.Text+'/'+Const_ThumbPrefix+Self.edtFileName.Text;


//  Self.DownloadPictureManager1.DownloadPicture();
end;

procedure TForm4.btnNativeRoundImageClick(Sender: TObject);
var
  ARoundBitmapByDelphi:TBitmap;
begin

  //RoundSkinPicture();
  //使用Delphi做圆角
//  ARoundBitmapByDelphi:=RoundSkinPicture(Self.imgOrigin.Bitmap,100,100,[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight]);

  ARoundBitmapByDelphi:=AndroidGenerateColorClipRoundRectBitmap(TAlphaColorRec.Red,
                                                      100,
                                                      100,
                                                      StrToFloat(edtRadius.Text),
                                                      StrToFloat(edtRadius.Text));
  Self.imgDownloadThumbPicture.Prop.Picture.Assign(ARoundBitmapByDelphi);
  FreeAndNil(ARoundBitmapByDelphi);
end;

procedure TForm4.btnSelectPictureClick(Sender: TObject);
begin
  //拍照
  ShowFrame(TFrame(GlobalTakePictureMenuFrame),TFrameTakePictureMenu,Self,nil,nil,nil,Application,True,False,ufsefNone);
  GlobalTakePictureMenuFrame.OnTakedPicture:=DoAddPictureFromMenu;
  GlobalTakePictureMenuFrame.ShowMenu;

end;

procedure TForm4.btnUploadPictureClick(Sender: TObject);
var
  ABitmapCodecSaveParams:TBitmapCodecSaveParams;
begin
  FFileName:=Self.edtFileName.Text;
  FFileDir:=Self.edtUploadType.Text;
  FServerUrl:='http://'+Self.edtServer.Text+':'+Self.edtPort.Text;

  //压缩比50%
  ABitmapCodecSaveParams.Quality:=70;
  //保存成文件
  Self.imgUploadPicture.Prop.Picture.SaveToFile(
                    GetApplicationPath+FFileName,
                    @ABitmapCodecSaveParams
                    );


  TThread.CreateAnonymousThread(
    procedure
    var
      AResponseStream:TStringStream;
      ASuperObject:ISuperObject;
      AHttpControl:THttpControl;
      APicStream:TFileStream;
    begin
      //上传到服务器
      AHttpControl:=TSystemHttpControl.Create;

      APicStream:=TFileStream.Create(GetApplicationPath+FFileName,fmOpenRead or fmShareDenyNone);
      AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
      try

          TSystemHttpControl(AHttpControl).FNetHTTPClient.ContentType:='application/octet-stream; charset=utf-8';
          if AHttpControl.Post(
                              TIdURI.URLEncode(//对中文进行编码
                                //上传接口
                                FServerUrl
                                +'/Upload'
                                  +'?FileName='+FFileName
                                  +'&FileDir='+FFileDir
                                  )
                                  ,

                                //图片文件
                                APicStream,
                                //返回数据流
                                AResponseStream
                                ) then
          begin
            AResponseStream.Position:=0;


            //ASuperObject:=TSuperObject.ParseStream(AResponseStream);
            //会报错'Access violation at address 004B6C7C in module ''Server.exe''. Read of address 00000000'
            //要从AResponseStream.DataString加载
            ASuperObject:=TSuperObject.Create(AResponseStream.DataString);

            if ASuperObject.I['Code']=200 then
            begin
              TThread.Synchronize(nil,
                procedure
                begin
                  ShowMessage('上传成功');
                end);
            end;

          end
          else
          begin
              TThread.Synchronize(nil,
                procedure
                begin
                  ShowMessage('上传失败');
                end);
          end;

      finally
        uFuncCommon.FreeAndNil(APicStream);
        uFuncCommon.FreeAndNil(AResponseStream);
        uFuncCommon.FreeAndNil(AHttpControl);
      end;
    end).Start;
end;

procedure TForm4.DoAddPictureFromMenu(Sender: TObject;ABitmap:TBitmap);
begin
  //选择图片返回
  Self.imgUploadPicture.Prop.Picture.Assign(ABitmap);

end;

end.
