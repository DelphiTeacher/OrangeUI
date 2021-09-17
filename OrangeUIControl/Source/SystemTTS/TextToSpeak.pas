unit TextToSpeak;

interface

type
  ISpeakVoice =  interface(IInterface)
    ['{A8DCB06B-AFC6-4258-8CBC-34536655943E}']
    procedure SetText(AText:String);
    function GetText:String;
    procedure SetRate(ARate:Integer);
    function GetRate:Integer;
    procedure StopSpeakText;
    procedure SpeakText; overload;
  end;

  ISpeakVoiceServer = interface(IInterface)
    ['{59445BD0-F70A-4692-9F53-11AD2A6CBB43}']
    function CreateSpeakVoice:ISpeakVoice;
  end;

  TSpeakVoice = class(TObject)
  private
    FSpeakVoice:ISpeakVoice;
    {ISpeakVoice}
    //-10-0-10
    procedure SetText(AText:String);
    function GetText:String;
    procedure SetRate(ARate:Integer);
    function GetRate:Integer;
  public
    procedure StopSpeakText;
    procedure SpeakText; overload;
    procedure SpeakText(const AText:String; const ARate:Integer); overload;
    constructor Create;
    destructor Destoye;
  published
    property Text:string read GetText write SetText;
    property Rate:Integer read GetRate write SetRate;
  end;

  TSpeakVoiceServer = class abstract(TInterfacedObject,ISpeakVoiceServer)

  protected
    function DoCreateSpeakVoice: ISpeakVoice; virtual; abstract;
  public
    {ISpeakVoiceServer}
    function CreateSpeakVoice: ISpeakVoice;
  end;



implementation


uses
{$IFDEF ANDROID}
  Android.SpeechTTS,
{$ENDIF ANDROID}

{$IF DEFINED(IOS) or DEFINED(MACOS)}
  {$IFDEF IOS}
    iOSapi.AVSpeechSynthesis,
  {$ELSE}
    Macapi.SpeechSynthesis,
  {$ENDIF IOS}
{$ENDIF IOS or MACOS}

{$IFDEF MSWINDOWS}
  Winapi.SpVoice,
{$ENDIF MSWINDOWS}
 FMX.Platform;

{ TSpeakVoiceServer }

function TSpeakVoiceServer.CreateSpeakVoice: ISpeakVoice;
begin
  Result:=DoCreateSpeakVoice;
end;

{ TSpeakVoice }

constructor TSpeakVoice.Create;
var
  SpeakVoiceServer:ISpeakVoiceServer;
begin
  if TPlatformServices.Current.SupportsPlatformService(ISpeakVoiceServer, SpeakVoiceServer) then
  begin
    FSpeakVoice:=SpeakVoiceServer.CreateSpeakVoice;
  end;

end;

destructor TSpeakVoice.Destoye;
begin
  FSpeakVoice:=nil;
end;

function TSpeakVoice.GetRate: Integer;
begin
  Result:=FSpeakVoice.GetRate;
end;

function TSpeakVoice.GetText: String;
begin
  Result:=FSpeakVoice.GetText;
end;

procedure TSpeakVoice.SetRate(ARate: Integer);
begin
  FSpeakVoice.SetRate(ARate);
end;

procedure TSpeakVoice.SetText(AText: String);
begin
  FSpeakVoice.SetText(AText);
end;

procedure TSpeakVoice.SpeakText(const AText: String; const ARate: Integer);
begin
  SetText(AText);
  SetRate(ARate);
  SpeakText;
end;

procedure TSpeakVoice.StopSpeakText;
begin
  FSpeakVoice.StopSpeakText;
end;

procedure TSpeakVoice.SpeakText;
begin
  FSpeakVoice.SpeakText;
end;

initialization
  RegisterSpeakVoiceService;


end.
