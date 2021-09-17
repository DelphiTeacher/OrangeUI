unit iOSapi.AVSpeechSynthesis;

interface

{$IFDEF IOS}

uses
  Macapi.ObjectiveC, Macapi.Helpers, iOSapi.Foundation, iOSapi.CocoaTypes;

const
  libAVFoundation = '/System/Library/Frameworks/AVFoundation.framework/AVFoundation';

type

{$M+}
  AVSpeechBoundary = (AVSpeechBoundaryImmediate, AVSpeechBoundaryWord);
  AVSpeechUtterance = interface;
  AVSpeechSynthesizer = interface;
  AVSpeechSynthesisVoice = interface;

  AVSpeechSynthesizerClass =interface(NSObjectClass)
    ['{59353C6C-E8EE-4DE0-A70A-09B13B01E69C}']
  end;
  AVSpeechSynthesizer = interface(NSObject)
    ['{9D3365AC-2208-483D-B3C9-33FB2FE9A5FF}']
    procedure speakUtterance(utterance:AVSpeechUtterance); cdecl;
    function stopSpeakingAtBoundary(boundary:AVSpeechBoundary):Boolean; cdecl;
    function pauseSpeakingAtBoundary(boundary:AVSpeechBoundary):Boolean; cdecl;
    function continueSpeaking:boolean; cdecl;
  end;
  TAVSpeechSynthesizer = class(TOCGenericImport<AVSpeechSynthesizerClass, AVSpeechSynthesizer>)
  end;




  AVSpeechSynthesisVoiceClass = interface(NSObjectClass)
    ['{19B464C9-B79C-4F90-863A-BEE391365F54}']
    {class} function currentLanguageCode: NSString; cdecl;
    {class} function speechVoices: NSArray; cdecl;
    {class} function voiceWithIdentifier(identifier: NSString): AVSpeechSynthesisVoice; cdecl;
    {class} function voiceWithLanguage(languageCode: NSString): AVSpeechSynthesisVoice; cdecl;
  end;

  AVSpeechSynthesisVoice = interface(NSObject)
    ['{96A6AE61-71E9-4E73-9F9E-7274D8B2DC59}']
    function identifier: NSString; cdecl;
    function language: NSString; cdecl;
    function name: NSString; cdecl;
//    function quality: AVSpeechSynthesisVoiceQuality; cdecl;
  end;
  TAVSpeechSynthesisVoice = class(TOCGenericImport<AVSpeechSynthesisVoiceClass, AVSpeechSynthesisVoice>) end;



  AVSpeechUtteranceClass =interface(NSObjectClass)
    ['{EAE3128C-F892-4F60-B596-E1E582C6208D}']
    {class} function speechUtteranceWithString(Str:NSString): Pointer; cdecl;
  end;

  AVSpeechUtterance =interface(NSObject)
    function initWithString(Str: NSString): Pointer{instancetype}; cdecl;
    function speechString:NSString; cdecl;
    function rate:Single;cdecl;
    procedure setRate(rate:Single);cdecl;
    function volume:Single;cdecl;
    procedure setVolume(volume:Single);cdecl;
    procedure setVoice(voice: AVSpeechSynthesisVoice); cdecl;
    function voice: AVSpeechSynthesisVoice; cdecl;
  end;
  TAVSpeechUtterance = class(TOCGenericImport<AVSpeechUtteranceClass, AVSpeechUtterance>)
  end;

// exported single consts
function AVSpeechUtteranceMinimumSpeechRate: Single;
function AVSpeechUtteranceMaximumSpeechRate: Single;
function AVSpeechUtteranceDefaultSpeechRate: Single;

{$SCOPEDENUMS ON}
procedure RegisterSpeakVoiceService;
procedure UnRegisterSpeakVoiceService;


{$ENDIF IOS}



implementation

{$IFDEF IOS}

uses
{$IF defined(IOS) and NOT defined(CPUARM)}
//uses
  Posix.Dlfcn,//;
//var
//  AVModule: THandle;
{$ENDIF IOS}
  System.SysUtils, FMX.Platform, TextToSpeak;

type
  TiOSSpeakVoiceServer = class(TSpeakVoiceServer)
    function DoCreateSpeakVoice: ISpeakVoice; override;
  end;

  TiOSSpeakVoice = class(TInterfacedObject, ISpeakVoice)
  private
    SpeechSynthesizer:AVSpeechSynthesizer;
    FText:string;
    //速度 0-1.0
    FRate:Integer;
    procedure SetText(AText: String);
  public
    {ISpeakVoice}
    function GetText:String;
    procedure SetRate(ARate:Integer);
    function GetRate:Integer;
    procedure StopSpeakText;
    procedure SpeakText;
    constructor Create;
    destructor Destoye;
  end;

var
  SVService: TiOSSpeakVoiceServer;

{$IF defined(IOS) and NOT defined(CPUARM)}
//uses
//  Posix.Dlfcn;
var
  AVModule: THandle;
{$ENDIF IOS}


function CocoaFloatConst(const Fwk: string; const ConstStr: string): Single;
var
  Obj: Pointer;
begin
  Obj := CocoaPointerConst(Fwk, ConstStr);
  if Obj <> nil then
    Result := Single(Obj^)
  else
    Result := 0;
end;

function AVSpeechUtteranceMinimumSpeechRate: Single;
begin
  Result := CocoaFloatConst(libAVFoundation, 'AVSpeechUtteranceMinimumSpeechRate');
end;
function AVSpeechUtteranceMaximumSpeechRate: Single;
begin
  Result := CocoaFloatConst(libAVFoundation, 'AVSpeechUtteranceMaximumSpeechRate');
end;
function AVSpeechUtteranceDefaultSpeechRate: Single;
begin
  Result := CocoaFloatConst(libAVFoundation, 'AVSpeechUtteranceDefaultSpeechRate');
end;

procedure RegisterSpeakVoiceService;
begin
  SVService := TiOSSpeakVoiceServer.Create;
  TPlatformServices.Current.AddPlatformService(ISpeakVoiceServer, SVService);
end;

procedure UnRegisterSpeakVoiceService;
begin
  TPlatformServices.Current.RemovePlatformService(ISpeakVoice);
end;

{ TiOSSpeakVoiceServer }

function TiOSSpeakVoiceServer.DoCreateSpeakVoice: ISpeakVoice;
begin
  Result:=TiOSSpeakVoice.Create
end;


{ TiOSSpeakVoice }

constructor TiOSSpeakVoice.Create;
begin
  SpeechSynthesizer:=TAVSpeechSynthesizer.Create;
end;

destructor TiOSSpeakVoice.Destoye;
begin
  SpeechSynthesizer:=nil;
end;

function TiOSSpeakVoice.GetRate: Integer;
begin
  Result:=FRate;
end;

function TiOSSpeakVoice.GetText: String;
begin
  Result:=FText;
end;

procedure TiOSSpeakVoice.SetRate(ARate: Integer);
begin
  FRate:=ARate;
end;

procedure TiOSSpeakVoice.SetText(AText: String);
begin
  FText:=AText;
end;

procedure TiOSSpeakVoice.SpeakText;
var
  SpeechUtterance:AVSpeechUtterance;
//  AVoice:AVSpeechSynthesisVoice;
begin
  if FText='' then
    raise Exception.Create('文本不能为空!');
  SpeechUtterance:=TAVSpeechUtterance.Wrap(TAVSpeechUtterance.OCClass.speechUtteranceWithString(StrToNSStr(FText)));
  SpeechUtterance.setrate(FRate/100);
//  AVoice:=TAVSpeechSynthesisVoice.OCClass.voiceWithLanguage(StrToNSStr('zh-CN'));
  SpeechUtterance.setVoice(TAVSpeechSynthesisVoice.OCClass.voiceWithLanguage(StrToNSStr('zh-CN')));
//29         u.voice=[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置语言
//  SpeechSynthesizer.


  SpeechSynthesizer.speakUtterance(SpeechUtterance);
end;

procedure TiOSSpeakVoice.StopSpeakText;
var
  speechStopped:Boolean;
begin
  speechStopped:=SpeechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.AVSpeechBoundaryImmediate);
  if not speechStopped then
    SpeechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.AVSpeechBoundaryWord);

end;
{$ENDIF IOS}




{$IF defined(IOS) and NOT defined(CPUARM)}

initialization
  AVModule := dlopen(MarshaledAString(libAVFoundation), RTLD_LAZY);

finalization
  dlclose(AVModule);
{$ENDIF IOS}


end.


