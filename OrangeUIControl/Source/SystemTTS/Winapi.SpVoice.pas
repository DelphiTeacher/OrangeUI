unit Winapi.SpVoice;

interface

{$IFDEF MSWINDOWS}

{$SCOPEDENUMS ON}
procedure RegisterSpeakVoiceService;
procedure UnRegisterSpeakVoiceService;


{$ENDIF MSWINDOWS}

implementation




{$IFDEF MSWINDOWS}
uses
  System.SysUtils, FMX.Platform, SpeechLib_TLB, TextToSpeak;

type
  TWinSpeakVoiceServer = class(TSpeakVoiceServer)
    function DoCreateSpeakVoice: ISpeakVoice; override;
  end;

  TWinSpeakVoice = class(TInterfacedObject, ISpeakVoice)
  private
    FText:string;
    //速度 0 是正常速度
    FRate:Integer;
//    SpVoice:TSpVoice;
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
  SVService: TWinSpeakVoiceServer;

procedure RegisterSpeakVoiceService;
begin
  SVService := TWinSpeakVoiceServer.Create;
  TPlatformServices.Current.AddPlatformService(ISpeakVoiceServer, SVService);
end;
procedure UnRegisterSpeakVoiceService;
begin
  TPlatformServices.Current.RemovePlatformService(ISpeakVoice);
end;

{ TWinSpeakVoiceServer }

function TWinSpeakVoiceServer.DoCreateSpeakVoice: ISpeakVoice;
begin
  Result:=TWinSpeakVoice.Create
end;

{ TWinSpeakVoice }

constructor TWinSpeakVoice.Create;
begin
//  SpVoice:=TSpVoice.Create(nil);
end;

destructor TWinSpeakVoice.Destoye;
begin
//  FreeAndNil(SpVoice);
end;

function TWinSpeakVoice.GetRate: Integer;
begin
  Result:=FRate;
end;

function TWinSpeakVoice.GetText: String;
begin
  Result:=FText;
end;

procedure TWinSpeakVoice.SetRate(ARate: Integer);
begin
  FRate:=ARate;
end;

procedure TWinSpeakVoice.SetText(AText: String);
begin
  FText:=AText;
end;

procedure TWinSpeakVoice.SpeakText;
begin
//  if FText='' then
//    raise Exception.Create('文本不能为空!');
//  SpVoice.Rate:=FRate;
//  SpVoice.Speak(FText,SVSFlagsAsync);
end;

procedure TWinSpeakVoice.StopSpeakText;
begin
//  if SpVoice.Status.RunningState=SRSEIsSpeaking then
//    SpVoice.Speak('', SVSFPurgeBeforeSpeak);
end;

{$ENDIF MSWINDOWS}

end.
