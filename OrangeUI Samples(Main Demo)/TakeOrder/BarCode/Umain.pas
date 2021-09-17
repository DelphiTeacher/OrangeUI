unit Umain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Rtti, System.Messaging,

  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Memo,
  FMX.platform,
  FMX.Platform.Android,
  FMX.Helpers.Android,
  FMX.Controls.Presentation,
  FMX.Edit,

  Androidapi.JNI.Net,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  Androidapi.Helpers,
  Androidapi.JNI.App, FMX.Objects, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions ;


type
  TForm1 = class(TForm)
    Button1: TButton;
    edit1:tedit;
    Edit2: TEdit;
    Label1: TLabel;


    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    const ScanRequestCode = 0;
    var FMessageSubscriptionID: Integer;
    function OnActivityResult(RequestCode, ResultCode: Integer; Data: JIntent): Boolean;
    procedure HandleActivityMessage(const Sender: TObject; const M: TMessage);


  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure LaunchQRScanner(RequestCode: Integer);
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init;
  Intent.setClassName(SharedActivityContext, StringToJString('com.google.zxing.client.android.CaptureActivity'));
  //如果要预定扫描格式，UnComment 下面文字
  //Intent.putExtra(StringToJString('SCAN_MODE'), StringToJString('QR_CODE_MODE'));
  SharedActivity.startActivityForResult(Intent, RequestCode);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  LIntent: JIntent;
begin
  FMessageSubscriptionID := TMessageManager.DefaultManager.SubscribeToMessage(TMessageResultNotification,HandleActivityMessage);
  LaunchQRScanner(ScanRequestCode);
end;

procedure TForm1.HandleActivityMessage(const Sender: TObject;const M: TMessage);
begin
  if M is TMessageResultNotification then
    OnActivityResult(TMessageResultNotification(M).RequestCode, TMessageResultNotification(M).ResultCode,
      TMessageResultNotification(M).Value);
end;

function TForm1.OnActivityResult(RequestCode, ResultCode: Integer;Data: JIntent): Boolean;
var
  ScanContent, ScanFormat: string;
begin
  Result := False;

  TMessageManager.DefaultManager.Unsubscribe(TMessageResultNotification, FMessageSubscriptionID);
  FMessageSubscriptionID := 0;

  if RequestCode = ScanRequestCode then
  begin
    if ResultCode = TJActivity.JavaClass.RESULT_OK then
    begin
      if Assigned(Data) then
      begin
        ScanContent := JStringToString(Data.getStringExtra(StringToJString('SCAN_RESULT')));
        ScanFormat := JStringToString(Data.getStringExtra(StringToJString('SCAN_RESULT_FORMAT')));
        edit1.Text:= ScanFormat;
        edit2.Text:= ScanContent;
        Label1.Text:= '扫描成功';
      end;
    end
    else if ResultCode = TJActivity.JavaClass.RESULT_CANCELED then
    begin
      Label1.Text:= '扫描取消';
    end;
    Result := True;
  end;
end;



end.
