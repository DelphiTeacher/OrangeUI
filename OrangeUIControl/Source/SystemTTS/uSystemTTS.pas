unit uSystemTTS;

interface


uses
  SysUtils,
  Classes,
  uBaseLog,
  SyncObjs,
  FMX.Types,
  FMX.Dialogs,

  TextToSpeak,



  {$IFDEF SKIN_SUPEROBJECT}
  uSkinSuperObject,
  {$ELSE}
  XSuperObject,
  XSuperJson,
  {$ENDIF}


  uComponentType,
  uBaseList,
  uBasePageStructure,


//  TextToSpeak,

  {$IFDEF ANDROID}
  //��Ҫ����ĵ�Ԫ
  FMX.Helpers.Android,
  Androidapi.Helpers,
  Androidapi.JNIBridge,
  Androidapi.Jni.JavaTypes,
  Androidapi.JNI.TTS,
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  SpeechLib_TLB,
  ActiveX,
  {$ENDIF}

  StrUtils;

type
  TSystemTTS=class;


  TSpeakText=class
    Text:String;
    Delay:Integer;
    Times:Integer;
    constructor Create;
  end;
  TSpeakTextList=class(TBaseList)
  private
    function GetItem(Index: Integer): TSpeakText;
  public
    property Items[Index:Integer]:TSpeakText read GetItem;default;
  end;


  
  //���������߳�
  TPlayerThread=class(TThread)
  protected
    FSystemTTS:TSystemTTS;
    procedure Execute;override;
  end;



  {$IFDEF ANDROID}
  //������
  TttsOnInitListener = class(TJavaLocal, JTextToSpeech_OnInitListener)
  private
    FSystemTTS: TSystemTTS;
  public
    constructor Create(ASystemTTS: TSystemTTS);
  public
    procedure onInit(status: Integer); cdecl;
  end;
  {$ENDIF}



  TSystemTTS=class(TComponent,
                    IControlForPageFramework,
                    ISkinItemBindingControl)
  private
    FPlayerThread:TPlayerThread;

    //���Ŵ���
    FRepeatTimes:Integer;

    //Ҫ���ŵ��ı�
    FTextListLock:TCriticalSection;
    FTextList:TSpeakTextList;

    FText: String;
    procedure SetText(const Value: String);
  private
    {$IFDEF ANDROID}
    FTtsListener: TttsOnInitListener;//������˽�ж���
    FTTS: JTextToSpeech;//����TO����
    {$ENDIF}
  private
    {$IFDEF MSWINDOWS}
    FSpeechVoice:ISpeechVoice;
    {$ENDIF}
  private
    {$IFDEF IOS}
    FSpeechVoice:TSpeakVoice;
    {$ENDIF}
  protected
    //���ҳ���ܵĿؼ��ӿ�
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting):Boolean;
    //��ȡ�������Զ�������
    function GetPropJsonStr:String;
    procedure SetPropJsonStr(AJsonStr:String);
    //��ȡ�ύ��ֵ
    function GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
    //����ֵ
    procedure SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //Ҫ���ö��ֵ,�����ֶεļ�¼
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
    //��������
    function GetProp(APropName:String):Variant;
    procedure SetProp(APropName:String;APropValue:Variant);

  protected
    FBindItemFieldName:String;
    function GetBindItemFieldName:String;
    procedure SetBindItemFieldName(AValue:String);

  public
    function Init:Boolean;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public

    function IsSpeaking:Boolean;
    function Play(AText:String;
                  ADelay:Integer=0;
                  ATimes:Integer=1):Boolean;
    function DirectPlay(AText:String):Boolean;

  published
    property Text:String read FText write SetText;
    property RepeatTimes:Integer read FRepeatTimes write FRepeatTimes;
    property BindItemFieldName:String read GetBindItemFieldName write SetBindItemFieldName;
  end;





  TTTS=class(TSystemTTS)

  end;





//var
//  GlobalSystemTTS:TSystemTTS;


implementation



{$IFDEF ANDROID}

{ TttsOnInitListener }

constructor TttsOnInitListener.Create(ASystemTTS: TSystemTTS);
begin
  Inherited Create;

  FSystemTTS:=ASystemTTS;
end;

procedure TttsOnInitListener.onInit(status: Integer);
var
  Result: Integer;
begin
  uBaseLog.HandleException(nil,'TttsOnInitListener.onInit');

  if (status = TJTextToSpeech.JavaClass.SUCCESS) then
  begin
      try
          Result := FSystemTTS.FTTS.setLanguage(TJLocale.JavaClass.US); // ����ָ��������
          if (Result = TJTextToSpeech.JavaClass.LANG_MISSING_DATA) or
            (Result = TJTextToSpeech.JavaClass.LANG_NOT_SUPPORTED) then
          begin
            //������XE10.1����ʾ��ֻ�������߳���ʹ�ô���ʾ��
          end
          else
          begin
      //      ShowMessage('��ʼ���ɹ���')
          end;
      except
        on E:Exception do
        begin
          uBaseLog.HandleException(E,'TttsOnInitListener.onInit');
        end;
      end;
  end
  else
  begin
//    ShowMessage('��ʼ��ʧ�ܣ�');
  end;


end;
{$ENDIF}

{ TSystemTTS }

constructor TSystemTTS.Create(AOwner:TComponent);
begin
  Inherited;

  {$IFDEF ANDROID}
  FTtsListener := TttsOnInitListener.Create(self);
  {$ENDIF}

  FTextListLock:=TCriticalSection.Create;
  FTextList:=TSpeakTextList.Create;




  FRepeatTimes:=1;
end;

destructor TSystemTTS.Destroy;
begin

  if FPlayerThread<>nil then
  begin
    FPlayerThread.Terminate;
    FPlayerThread.WaitFor;
    FreeAndNil(FPlayerThread);
  end;


  {$IFDEF ANDROID}
  try
      if Assigned(FTTS) then
      begin
        FTTS.stop;
        FTTS.shutdown;
        FTTS := nil;
      end;
      FTtsListener := nil;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'FormDestroy FTTS');
    end;
  end;
  {$ENDIF}


  {$IFDEF IOS}
  FreeAndNil(FSpeechVoice);
  {$ENDIF}


  FreeAndNil(FTextList);
  FreeAndNil(FTextListLock);

  inherited;
end;


function TSystemTTS.DirectPlay(AText: String): Boolean;
begin
//  {$IFDEF FREE_VERSION}
//  ShowMessage('����SDK��Ѱ�����');
//  {$ENDIF}



  Result:=False;

  if not Init then Exit;


  {$IFDEF ANDROID}
  if FTTS<>nil then
  begin
    uBaseLog.HandleException(nil,'SpeakOut FTTS.speak '+AText);
    Self.FTTS.speak(StringToJString(AText), TJTextToSpeech.JavaClass.QUEUE_FLUSH, nil);
  end;
  {$ENDIF}


  {$IFDEF MSWINDOWS}
  if FSpeechVoice<>nil then
  begin
//    FSpeechVoice.Volume
    try
      FSpeechVoice.Speak(AText,0);
    except

    end;
  end;
  {$ENDIF}



  {$IFDEF IOS}
  FSpeechVoice.Text:=AText;
  FSpeechVoice.SpeakText;
  {$ENDIF}


  Result:=True;
end;

function TSystemTTS.GetPropJsonStr:String;
var
  ASuperObject:ISuperObject;
begin
  ASuperObject:=TSuperObject.Create;

  ASuperObject.I['RepeatTimes']:=RepeatTimes;

  Result:=ASuperObject.AsJson;
  if Result='{}' then
  begin
    Result:='';
  end;
end;

procedure TSystemTTS.SetPropJsonStr(AJsonStr:String);
var
  ASuperObject:ISuperObject;
begin
  ASuperObject:=TSuperObject.Create(AJsonStr);

  if ASuperObject.Contains('RepeatTimes') then RepeatTimes:=ASuperObject.I['RepeatTimes'];
end;

function TSystemTTS.GetBindItemFieldName: String;
begin
  Result:=FBindItemFieldName;
end;

function TSystemTTS.GetPostValue(ASetting:TFieldControlSetting;APageDataDir: String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String): Variant;
begin
  Result:=FText;
end;

function TSystemTTS.Init:Boolean;
begin
  Result:=False;

  {$IFDEF ANDROID}
  if FTTS=nil then
  begin
    try
      FTTS := TJTextToSpeech.JavaClass.init(SharedActivityContext, FTtsListener);
      Result:=True;
    except
      on E:Exception do
      begin
        uBaseLog.HandleException(E,'Init FTTS init');
      end;
    end;
  end
  else
  begin
    Result:=True;
  end;
  {$ENDIF}


  {$IFDEF MSWINDOWS}
  if FSpeechVoice=nil then
  begin
    try
      FSpeechVoice:=CoSpVoice.Create;
      Result:=True;
    except
      on E:Exception do
      begin
        uBaseLog.HandleException(E,'Init FTTS init');
      end;
    end;
  end
  else
  begin
    Result:=True;
  end;
  {$ENDIF}



  {$IFDEF IOS}
  if FSpeechVoice=nil then
  begin
      try
        FSpeechVoice:=TSpeakVoice.Create;
        FSpeechVoice.Rate:=50;
  //    FSpeechVoice.
        Result:=True;
      except
        on E:Exception do
        begin
          uBaseLog.HandleException(E,'Init FTTS init');
        end;
      end;
  end
  else
  begin
      Result:=True;
  end;
  {$ENDIF}


end;

function TSystemTTS.IsSpeaking: Boolean;
begin
  Result:=False;

  {$IFDEF ANDROID}
  ReSult:=(Self.FTTS<>nil) and Self.FTTS.isSpeaking;
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  Result:=(FSpeechVoice<>nil) and (FSpeechVoice.Status.RunningState=SRSEIsSpeaking);
  {$ENDIF}
end;

function TSystemTTS.LoadFromFieldControlSetting(ASetting: TFieldControlSetting): Boolean;
begin

end;

function TSystemTTS.Play(AText: String;
                  ADelay:Integer=0;
                  ATimes:Integer=1): Boolean;
var
  ASpeakText:TSpeakText;
begin
  Result:=False;

  if Trim(AText)='' then Exit;

  ASpeakText:=TSpeakText.Create;
  ASpeakText.Text:=AText;
  ASpeakText.Delay:=ADelay;
  ASpeakText.Times:=ATimes;


  FTextList.Add(ASpeakText);

  
  if not Init then
  begin
    ShowMessage('���������ʼʧ��!');
    Exit;
  end;


  if FPlayerThread=nil then
  begin
    Self.FPlayerThread:=TPlayerThread.Create(True);
    Self.FPlayerThread.FSystemTTS:=Self;
    Self.FPlayerThread.Start;
  end;

  Result:=True;
end;

procedure TSystemTTS.SetBindItemFieldName(AValue: String);
begin
  FBindItemFieldName:=AValue;
end;

procedure TSystemTTS.SetControlValue(ASetting:TFieldControlSetting;APageDataDir, AImageServerUrl: String;AValue: Variant;AValueCaption:String;
                            //Ҫ���ö��ֵ,�����ֶεļ�¼
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
  Text:=AValue;
end;

//��������
function TSystemTTS.GetProp(APropName:String):Variant;
begin

end;

procedure TSystemTTS.SetProp(APropName:String;APropValue:Variant);
begin

end;

procedure TSystemTTS.SetText(const Value: String);
begin
  if FText<>Value then
  begin
    FText := Value;

    Self.Play(FText);
  end;
end;

{ TPlayerThread }

procedure TPlayerThread.Execute;
var
  I:Integer;
  ARemind:TSpeakText;
begin

  {$IFDEF MSWINDOWS}
  CoInitialize(nil);
  {$ENDIF}
  try
      while Not Self.Terminated do
      begin
        try



            //ȡ��һ��֪ͨ
            ARemind:=nil;
            FSystemTTS.FTextListLock.Enter;
            try
              if FSystemTTS.FTextList.Count>0 then
              begin
                ARemind:=FSystemTTS.FTextList[0];
                FSystemTTS.FTextList.Delete(0,False);
              end;
            finally
              FSystemTTS.FTextListLock.Leave;
            end;


        
            if ARemind<>nil then
            begin
                //�ظ�����һ���Ĵ���
                FMX.Types.Log.d('OrangeUI --speaking--FRepeatTimes'+IntToStr(FSystemTTS.FRepeatTimes));
                for I := 0 to FSystemTTS.FRepeatTimes-1 do
                begin

                    try

                        if ARemind.Delay>0 then
                        begin
                          Sleep(ARemind.Delay);
                        end;



                        FSystemTTS.DirectPlay(ARemind.Text);

                        //ֱ��Sleep�Ļ�  �����ı���2���ڶ�����  �ͻ�Ͼ�
                        while FSystemTTS.IsSpeaking do
                        begin
                          Sleep(1000);
                        end;


                        Sleep(1000);

                    except
                      on E:Exception do
                      begin
                        uBaseLog.HandleException(E,'SpeakOut FTTS.speak');
                        Sleep(1000);
                      end;
                    end;

                end;

                FreeAndNil(ARemind);
            end;


            if FSystemTTS.FTextList.Count=0 then
            begin
              Sleep(1000);
            end;

        except
          on E:Exception do
          begin
            uBaseLog.HandleException(E,'TPlayerThread.Execute');
            Sleep(1000);
          end;
        end;
      end;
  finally
    {$IFDEF MSWINDOWS}
    CoUnInitialize();
    {$ENDIF}
  end;
end;



{ TSpeakTextList }

function TSpeakTextList.GetItem(Index: Integer): TSpeakText;
begin
  Result:=TSpeakText(Inherited Items[Index]);
end;



{ TSpeakText }

constructor TSpeakText.Create;
begin
  Times:=1;
end;

initialization
  GetGlobalFrameworkComponentTypeClasses.Add('tts',TTTS,'��������');


end.
