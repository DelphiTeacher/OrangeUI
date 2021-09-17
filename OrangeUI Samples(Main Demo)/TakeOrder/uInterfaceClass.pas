//convert pas to utf8 by ¥
unit uInterfaceClass;

interface

uses
  Classes,
  SysUtils,
  Variants,
  DateUtils,
  StrUtils,
  INIFiles,
  uBaseLog,
  IdURI,
//  FMX.Types,

//  uDirectoryPublic,

  uFuncCommon,
  uBaseHttpControl
  ;

type
  TCallAPIEvent=procedure(AHttpControl: THttpControl;AAPIUrl:String) of object;

//调用rest接口,返回数据流
function SimpleGet(API: String;
                    AHttpControl: THttpControl;
                    AInterfaceUrl:String;
                    AUrlParamNames:Array of String;
                    AUrlParamValues:Array of Variant;
                    AResponseStream: TStream):Boolean;overload;

//调用rest接口,返回字符串
function SimpleCallAPI(API: String;
                      AHttpControl: THttpControl;
                      AInterfaceUrl:String;
                      AUrlParamNames:Array of String;
                      AUrlParamValues:Array of Variant): String;overload;



var
  OnCallAPIEvent:TCallAPIEvent;

implementation


function SimpleCallAPI(API: String;
                      AHttpControl:THttpControl;
                      AInterfaceUrl:String;
                      AUrlParamNames:Array of String;
                      AUrlParamValues:Array of Variant): String;
var
  ACallResult:Boolean;
  AResponseStream: TStringStream;
begin
//  FMX.Types.Log.d('SimpleCallAPI '+API+' '+'begin');

  Result:='';

  AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
  try
    ACallResult:=SimpleGet(
                       API,
                       AHttpControl,
                       AInterfaceUrl,
                       AUrlParamNames,
                       AUrlParamValues,
                       AResponseStream
                       );


    if ACallResult then
    begin
        //调用成功

//        //保存成临时文件,用来查日志
//        {$IFDEF MSWINDOWS}
//        AResponseStream.Position:=0;
//        AResponseStream.
//            SaveToFile(GetResponseTempDir
//                        +ReplaceStr(API,'/','_')+' '
//                        +FormatDateTime('YYYY-MM-DD HH-MM-SS-ZZZ',Now)+'.json');
//        {$ENDIF}

        AResponseStream.Position:=0;
        Result:=AResponseStream.DataString;
    end;

  finally
    uFuncCommon.FreeAndNil(AResponseStream);
  end;

//  FMX.Types.Log.d('SimpleCallAPI '+API+' '+'end');
end;

function SimpleGet(API: String;
                  AHttpControl:THttpControl;
                  AInterfaceUrl:String;
                  AUrlParamNames:Array of String;
                  AUrlParamValues:Array of Variant;
                  AResponseStream: TStream): Boolean;
var
  I:Integer;
  AStrValue:String;
  AParamsStr:String;
  ABefore:TDateTime;
begin
    ABefore:=Now;
//    FMX.Types.Log.d('SimplePost'+' '+'begin'+' '+FormatDateTime('HH:MM:SS',ABefore));

    AParamsStr:='';
    for I:=0 to Length(AUrlParamNames)-1 do
    begin
      AStrValue:=AUrlParamValues[I];
      if AParamsStr<>'' then
      begin
        AParamsStr:=AParamsStr+'&'+AUrlParamNames[I]+'='+AStrValue;
      end
      else
      begin
        AParamsStr:=AUrlParamNames[I]+'='+AStrValue;
      end;
    end;

    if Assigned(OnCallAPIEvent) then
    begin
      OnCallAPIEvent(AHttpControl,AInterfaceUrl+API+'?'+AParamsStr);
    end;

//    if AHttpControl.ClassName='TIdHttpControl' then
//    begin
//      Result:=AHttpControl.Get(
//          TIdURI.URLEncode(AInterfaceUrl+API+'?'+AParamsStr),
//          AResponseStream);
//    end
//    else
//    begin
      Result:=AHttpControl.Get(
          TIdURI.URLEncode(AInterfaceUrl+API+'?'+AParamsStr),
          AResponseStream);
//    end;


    uBaseLog.OutputDebugString('SimpleGet'+' '+'end'+' '+'耗时'+IntToStr(DateUtils.SecondsBetween(ABefore,Now)));

end;



end.






