unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,

  ImageIndyHttpServerModule,

  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm5 = class(TForm)
    Label1: TLabel;
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.ButtonStartClick(Sender: TObject);
begin

  //Æô¶¯HTTP
  dmImageIndyHttpServer.WWWRootDir:=ExtractFilePath(Application.ExeName);
  dmImageIndyHttpServer.IdImageHTTPServer.DefaultPort:=StrToInt(Self.EditPort.Text);

  dmImageIndyHttpServer.IdImageHTTPServer.Active:=True;

  Self.ButtonStart.Enabled:=False;
end;

procedure TForm5.ButtonStopClick(Sender: TObject);
begin

  //Í£Ö¹HTTP
  dmImageIndyHttpServer.IdImageHTTPServer.Active:=False;

  Self.ButtonStart.Enabled:=True;
end;

procedure TForm5.FormShow(Sender: TObject);
begin
  ButtonStartClick(Sender);
end;

end.
