unit Macapi.SpeechSynthesis;

interface

{$IFDEF _MACOS}
uses
  Macapi.CoreFoundation, Macapi.CocoaTypes, Macapi.Foundation;

type
  SpeechChannelRecord = record
    data:integer;
  end;
  SpeechChannel= ^SpeechChannelRecord;

  VoiceSpec =record
    creator:OSType;
    id:OSType;
  end;
  VoiceSpecPtr = ^VoiceSpec;

const
  libAVFoundation = '/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/SpeechSynthesis.framework/Versions/A/SpeechSynthesis';
  kAudioUnitProperty_SpeechChannel = 3331;

// exported single consts
function kSpeechRateProperty:Pointer;

//
function SetSpeechProperty(chan:SpeechChannel;Str:CFStringRef;Value:CFTypeRef): OSErr; cdecl; external libAVFoundation name _PU + 'SetSpeechProperty';
function GetIndVoice(index:SInt16;var voice:VoiceSpec): OSErr; cdecl; external libAVFoundation name _PU + 'GetIndVoice';
function NewSpeechChannel(var voice:VoiceSpec;var chan:SpeechChannel): OSErr; cdecl; external libAVFoundation name _PU + 'NewSpeechChannel';
function DisposeSpeechChannel(chan:SpeechChannel): OSErr; cdecl; external libAVFoundation name _PU + 'DisposeSpeechChannel';
function SpeakString(textToBeSpoken:ConstStr255Param): OSErr; cdecl; external libAVFoundation name _PU + 'SpeakString';
function GetSpeechRate(chan:SpeechChannel;var rate:Cardinal): OSErr; cdecl; external libAVFoundation name _PU + 'GetSpeechRate';
function SetSpeechRate(chan:SpeechChannel;rate:Cardinal): OSErr; cdecl; external libAVFoundation name _PU + 'SetSpeechRate';
function StopSpeech(chan:SpeechChannel):OSErr; cdecl; external libAVFoundation name _PU + 'StopSpeech';

{$SCOPEDENUMS ON}
procedure RegisterSpeakVoiceService;
procedure UnRegisterSpeakVoiceService;


{$ENDIF _MACOS}


implementation


{$IFDEF _MACOS}


uses
  System.SysUtils, FMX.Platform, TextToSpeak;

type
  TMacSpeakVoiceServer = class(TSpeakVoiceServer)
    function DoCreateSpeakVoice: ISpeakVoice; override;
  end;

  TMacSpeakVoice = class(TInterfacedObject, ISpeakVoice)
  private
    FText:string;
    //速度 100 是正常速度
    FRate:Integer;
    Channel:SpeechChannel;
    Voice:VoiceSpec;
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
  SVService: TMacSpeakVoiceServer;

function kSpeechRateProperty:Pointer;
begin
  Result := CocoaPointerConst(libAVFoundation, 'kSpeechRateProperty');
end;

procedure RegisterSpeakVoiceService;
begin
  SVService := TMacSpeakVoiceServer.Create;
  TPlatformServices.Current.AddPlatformService(ISpeakVoiceServer, SVService);
end;

procedure UnRegisterSpeakVoiceService;
begin
  TPlatformServices.Current.RemovePlatformService(ISpeakVoice);
end;

{ TiOSSpeakVoiceServer }

function TMacSpeakVoiceServer.DoCreateSpeakVoice: ISpeakVoice;
begin
  Result:=TMacSpeakVoice.Create
end;

{ TiOSSpeakVoice }

constructor TMacSpeakVoice.Create;
begin
  GetIndVoice(1, Voice);
  NewSpeechChannel(Voice, Channel);

end;

destructor TMacSpeakVoice.Destoye;
begin
  DisposeSpeechChannel(Channel);
end;

function TMacSpeakVoice.GetRate: Integer;
begin
  Result:=FRate;
end;

function TMacSpeakVoice.GetText: String;
begin
  Result:=FText;
end;

procedure TMacSpeakVoice.SetRate(ARate: Integer);
begin
  FRate:=ARate;
end;

procedure TMacSpeakVoice.SetText(AText: String);
begin
  FText:=AText;
end;

procedure TMacSpeakVoice.SpeakText;
var
  cfstr:CFStringRef;
  pstr:Str255;
  i:OSErr;
  rate:Cardinal;
  D:double;
begin
  if FText='' then
    raise Exception.Create('文本不能为空!');
  SetSpeechRate(Channel,rate);
  cfstr := CFStringCreateWithCString(nil,MarshaledAString(AnsiString(FText)), kCFStringEncodingMacRoman);
  CFStringGetPascalString(cfstr, @pstr, 255, kCFStringEncodingMacRoman);
  SpeakString(@pstr);
end;

procedure TMacSpeakVoice.StopSpeakText;
begin
  StopSpeech(Channel);
end;
{$ENDIF _MACOS}

end.
