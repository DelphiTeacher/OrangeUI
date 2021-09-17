unit Android.SpeechTTS;

interface

{$IFDEF ANDROID}

{$SCOPEDENUMS ON}
procedure RegisterSpeakVoiceService;
procedure UnRegisterSpeakVoiceService;
{$ENDIF ANDROID}

implementation

{$IFDEF ANDROID}


uses
  System.SysUtils, FMX.Platform, TextToSpeak, Androidapi.JNIBridge,
//    Android.speech.tts,
    Androidapi.JNI.TTS,
    Androidapi.Helpers;

type

  TAndroidSpeakVoiceServer = class(TSpeakVoiceServer)
    function DoCreateSpeakVoice: ISpeakVoice; override;
  end;

  TAndroidSpeakVoice = class(TInterfacedObject, ISpeakVoice)
  private
    type
      TOnInitListener = class(TJavaLocal, JTextToSpeech_OnInitListener)
      private
        [weak] SpeakVoice: TAndroidSpeakVoice;
      public
        procedure onInit(Status: Integer); cdecl;
      end;
  private
    FTTSSate:Boolean;
    FText:string;
    //速度 0.5-2.0
    FRate:Integer;
    FOnInitListener: TOnInitListener;
    FTextToSpeech: JTextToSpeech;
  public
    {ISpeakVoice}
    procedure SetText(AText:String);
    function GetText:String;
    procedure SetRate(ARate:Integer);
    function GetRate:Integer;
    procedure StopSpeakText;
    procedure SpeakText;
    constructor Create;
    destructor Destoye;
  end;

var
  SVService: TAndroidSpeakVoiceServer;

procedure RegisterSpeakVoiceService;
begin
  SVService := TAndroidSpeakVoiceServer.Create;
  TPlatformServices.Current.AddPlatformService(ISpeakVoiceServer, SVService);
end;
procedure UnRegisterSpeakVoiceService;
begin
  TPlatformServices.Current.RemovePlatformService(ISpeakVoice);
end;
{ TAndroidSpeakVoiceServer }

function TAndroidSpeakVoiceServer.DoCreateSpeakVoice: ISpeakVoice;
begin
  Result:=TAndroidSpeakVoice.Create
end;

{ TAndroidSpeakVoice }

constructor TAndroidSpeakVoice.Create;
begin
  FOnInitListener := TOnInitListener.Create;
  FOnInitListener.SpeakVoice:=Self;
  FTextToSpeech := TJTextToSpeech.JavaClass.init(SharedActivityContext, FOnInitListener);
end;

destructor TAndroidSpeakVoice.Destoye;
begin
  FTextToSpeech:=nil;
  FreeAndNil(FOnInitListener);
end;

function TAndroidSpeakVoice.GetRate: Integer;
begin
  Result:=FRate;
end;

function TAndroidSpeakVoice.GetText: String;
begin
  Result:=FText;
end;

procedure TAndroidSpeakVoice.SetRate(ARate: Integer);
begin
  FRate:=ARate;
end;

procedure TAndroidSpeakVoice.SetText(AText: String);
begin
  FText:=AText;
end;

procedure TAndroidSpeakVoice.SpeakText;
var
  Rate:Single;
begin
  if not FTTSSate then
    raise Exception.Create('系统TTS加载失败!');
  if FText='' then
    raise Exception.Create('文本不能为空!');
  if FRate>=10 then
    Rate:=(FRate+10)/10
  else
    Rate:=(FRate+20)/20;
  FTextToSpeech.setSpeechRate(FRate);
  FTextToSpeech.speak(StringToJString(FText),  TJTextToSpeech.JavaClass.QUEUE_ADD, nil)
end;

procedure TAndroidSpeakVoice.StopSpeakText;
begin
  if FTextToSpeech.isSpeaking then
    FTextToSpeech.stop;
end;

{ TAndroidSpeakVoice.TOnInitListener }

procedure TAndroidSpeakVoice.TOnInitListener.onInit(Status: Integer);
begin
  if Status = TJTextToSpeech.JavaClass.SUCCESS then
    SpeakVoice.FTTSSate := True
  else
    SpeakVoice.FTTSSate:=False;
end;
{$ENDIF ANDROID}

end.
