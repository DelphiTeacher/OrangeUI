//convert pas to utf8 by ¥

unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit,

  IdURI,
  System.IOUtils,

  //引用接口调用单元
  ClientModuleUnit2,
  ClientClassesUnit2,

  //引用Json解析的单元
  XSuperObject,

  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TForm2 = class(TForm)
    btnCall: TButton;
    edtLoginUser: TEdit;
    edtLoginPass: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    memResponseJsonStr: TMemo;
    Label3: TLabel;
    edtServer: TEdit;
    btnSet: TButton;
    Label4: TLabel;
    btnParse: TButton;
    memData: TMemo;
    Label5: TLabel;
    edtUserName: TEdit;
    edtUserID: TEdit;
    Label6: TLabel;
    btnUpdateUserInfo: TButton;
    rbMale: TRadioButton;
    rbFemale: TRadioButton;
    edtPort: TEdit;
    Image1: TImage;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Button2: TButton;
    Button3: TButton;
    IdHTTP1: TIdHTTP;
    edtHeadPicFileName: TEdit;
    procedure btnSetClick(Sender: TObject);
    procedure btnCallClick(Sender: TObject);
    procedure btnParseClick(Sender: TObject);
    procedure btnUpdateUserInfoClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.btnParseClick(Sender: TObject);
var
  ASuperObject:ISuperObject;
  ADataObject:ISuperObject;
  AUserArray:ISuperArray;
  AUserObject:ISuperObject;
begin
  //创建一个Json对象SuperObject
  //传入Json字符串
  ASuperObject:=TSuperObject.Create(Self.memResponseJsonStr.Text);



  Self.memData.Lines.Clear;
  Self.memData.Lines.Add( '接口调用返回代码:'+IntToStr(ASuperObject.I['Code']) );
  Self.memData.Lines.Add( '接口调用返回描述:'+ASuperObject.S['Desc'] );



  //获取Data数据对象 ASuperObject.O[字段名]
  ADataObject:=ASuperObject.O['Data'];
  //获取User用户信息数组 ASuperObject.A[字段名]
  AUserArray:=ADataObject.A['User'];
  //其中一个用户对象 ASuperArray.O[下标]
  AUserObject:=AUserArray.O[0];


  //AUserObject.S['Name'] AUserObject中名为Name的数据,S表示String,是字符串数据
  Self.memData.Lines.Add( '用户名:'+ AUserObject.S['Name'] );


  //AUserObject.I['FID'] AUserObject中名为FID的数据,I表示Integer,是整型数据
  Self.edtUserID.Text:=IntToStr(AUserObject.I['FID']);
  Self.edtUserName.Text:=AUserObject.S['Name'];

end;

procedure TForm2.btnSetClick(Sender: TObject);
begin
  //设置服务端IP地址
  ClientModule2.DSRestConnection1.Host:=Self.edtServer.Text;
  ClientModule2.DSRestConnection1.Port:=StrToInt(Self.edtPort.Text);
end;

procedure TForm2.btnUpdateUserInfoClick(Sender: TObject);
var
  AResponseJsonStr:String;
  ASuperObject:ISuperObject;
begin
  if Self.edtUserID.Text<>'' then
  begin
      ASuperObject:=TSuperObject.Create;

      //需要修改哪些字段
      ASuperObject.S['Name']:=Self.edtUserName.Text;

      if rbMale.IsChecked then
      begin
        ASuperObject.B['Sex']:=True;
      end
      else
      begin
        ASuperObject.B['Sex']:=False;
      end;


      //调用服务端的UpdateUserInfo接口
      AResponseJsonStr:=ClientModule2.ServerMethods1Client.UpdateUserInfo(
        StrToInt(Self.edtUserID.Text),
        '',
        ASuperObject.AsJSON);

      Self.memResponseJsonStr.Text:=AResponseJsonStr;
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  if Self.OpenDialog1.Execute then
  begin
    Self.Image1.Bitmap.LoadFromFile(Self.OpenDialog1.FileName);
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  I: Integer;
  AFileName:String;
  AFilePath:String;
  AServerUrl:String;
  ABitmapCodecSaveParams:TBitmapCodecSaveParams;
  APicStream:TFileStream;
  AResponseStream:TStringStream;
  ASuperObject:ISuperObject;
begin
  //生成临时文件名
  AFileName:='testhead'+FormatDateTime(' YYYY-MM-DD HH-MM-SS-ZZZ',Now)+'.jpg';
  Self.edtHeadPicFileName.Text:=AFileName;

  //C:\Users\Administrator\Documents\testhead 2017-06-06 08-01-07-603.jpg
  AFilePath:=System.IOUtils.TPath.GetDocumentsPath+PathDelim+AFileName;

  //图片上传接口的url
  AServerUrl:='http://www.orangeui.cn:7041';

  //压缩比70%
  ABitmapCodecSaveParams.Quality:=70;
  Self.Image1.Bitmap.SaveToFile(
                    //保存到文档目录
                    AFilePath,
                    @ABitmapCodecSaveParams
                    );

  //上传到服务器
  APicStream:=TFileStream.Create(AFilePath,fmOpenRead or fmShareDenyNone);
  AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
  try

      try
        Self.IdHTTP1.Post(
                          TIdURI.URLEncode(//对中文进行编码

                            //上传接口
                            AServerUrl
                            +'/Upload'
                              //文件名
                              +'?FileName='+AFileName
                              //文件存放目录
                              +'&FileDir='+'Temp'
                              ),

                            //图片文件的数据流
                            APicStream,
                            //返回数据流
                            AResponseStream
                            );


            AResponseStream.Position:=0;
            //解析返回的Json数据
            ASuperObject:=TSuperObject.Create(AResponseStream.DataString);

            if ASuperObject.I['Code']=200 then
            begin
              ShowMessage('上传成功');
            end;


      except
        ShowMessage('上传失败');
      end;

  finally
    FreeAndNil(APicStream);
    FreeAndNil(AResponseStream);
  end;

end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  //设置用户头像
  ClientModule2.ServerMethods1Client.UpdateUserHead(
        StrToInt(Self.edtUserID.Text),
        '',
        Self.edtHeadPicFileName.Text
        )
end;

procedure TForm2.btnCallClick(Sender: TObject);
var
  AResponseJsonStr:String;
begin
  //调用服务端的登录接口,需要传入三个参数,账号LoginUser,密码LoginPass,APP版本Version
  AResponseJsonStr:=
    ClientModule2.ServerMethods1Client.Login(
        Self.edtLoginUser.Text,
        Self.edtLoginPass.Text,
        '1.0');
  //把返回的Json数据字符串显示到Memo中
  Self.memResponseJsonStr.Text:=AResponseJsonStr;
end;

end.
