unit uCountryData;

interface

uses
//  Winapi.Windows,
  System.Types,
  System.SysUtils, System.Variants, System.Classes,

  XSuperObject;



//获取所有州列表
function GetContinentList:TStringList;
//获取国家代码和国家英文名称对应的列表
function GetCountryCodeEnNameMapList:TStringList;
function GetCountryCNNameByCode(ACode:String):String;

function GetCountryListJsonArray:ISuperArray;

function ReadResDataString(const AResName: string): string;
function ReadResDataToFilePath(const AResName: string;AFilePath:String):Boolean;
function VarToStr(AValue:Variant):String;


var
  GlobalCountryListJsonArray:ISuperArray;

implementation


//{$R mxdatas.res}
{$R country_icons.res}

function ReadResDataString(const AResName: string): string;
var
  cRes: TResourceStream;
  cStr: TStringStream;
begin
  Result := '';
  if System.findResource(HInstance, PChar(AResName), RT_RCDATA) = 0 then
    Exit;

  cRes := TResourceStream.Create(HInstance, AResName, RT_RCDATA);
  try
    cStr := TStringStream.Create('', TEncoding.UTF8);
    try
      cStr.LoadFromStream(cRes);
      Result := cStr.DataString;
    finally
      cStr.Free;
    end;
  finally
    cRes.Free;
  end;
end;

function ReadResDataToFilePath(const AResName: string;AFilePath:String):Boolean;
var
  cRes: TResourceStream;
begin
  Result:=False;

//  Result := '';
  if System.findResource(HInstance, PChar(AResName), RT_RCDATA) = 0 then
    Exit;

  cRes := TResourceStream.Create(HInstance, AResName, RT_RCDATA);
  try
//    cStr := TMemoryStream.Create;
//    try
//      cStr.LoadFromStream(cRes);
      ForceDirectories(ExtractFilePath(AFilePath));
      cRes.SaveToFile(AFilePath);

      Result:=True;
//    finally
//      cStr.Free;
//    end;
  finally
    cRes.Free;
  end;
end;

function VarToStr(AValue:Variant):String;
begin
  if VarIsNull(AValue) then
  begin
    Result:='';
  end
  else
  begin
    Result:=AValue;
  end;

end;

//function ReadResDataString(const AResName: string): string;
//var
//  cRes: TResourceStream;
//  cStr: TStringStream;
//begin
//  Result := '';
//  if findResource(HInstance, PChar(AResName), RT_RCDATA) = 0 then
//    Exit;
//
//  cRes := TResourceStream.Create(HInstance, AResName, RT_RCDATA);
//  try
//    cStr := TStringStream.Create('', TEncoding.UTF8);
//    try
//      cStr.LoadFromStream(cRes);
//      Result := cStr.DataString;
//    finally
//      cStr.Free;
//    end;
//  finally
//    cRes.Free;
//  end;
//end;
//
//function VarToStr(AValue:Variant):String;
//begin
//  if VarIsNull(AValue) then
//  begin
//    Result:='';
//  end
//  else
//  begin
//    Result:=AValue;
//  end;
//
//end;

function GetCountryListJsonArray:ISuperArray;
var
  ACountryJson:ISuperObject;
begin
  Result:=GlobalCountryListJsonArray;
  if Result=nil then
  begin
    ACountryJson:=SO(ReadResDataString('CFGJson_countrydata'));
    GlobalCountryListJsonArray:=ACountryJson.A['values'];
    Result:=GlobalCountryListJsonArray;
  end;
end;

function GetContinentList:TStringList;
var
  I:Integer;
  AValuesArray:ISuperArray;
//  AValue:Variant;
  ACaption:String;
//  ACode:String;
//  AItem:TSkinItem;
begin
  //加载所有州
  Result:=TStringList.Create;

//  ACountryJson:=SO(ReadResDataString('CFGJson_countrydata'));
//  AValuesArray:=ACountryJson.A['values'];
  AValuesArray:=GetCountryListJsonArray;
  for I := 0 to AValuesArray.Length - 1 do
  begin
//    ShowMessage(AValuesArray.A[I].S[0] + ' + ' + AValuesArray.A[I].S[3]);
    //["674", "NR", "Nauru", "瑙鲁", "+674", "亚洲", "4:00 AM", "12:00 PM"]
//      APhoneCaption:= VarToStr(AValuesArray.A[I].V[3]) + '(' + VarToStr(AValuesArray.A[I].V[1]) + ')' + '+' + VarToStr(AValuesArray.A[I].V[0]) + ',';
//      APhoneValue:= VarToStr(AValuesArray.A[I].V[0]) + ',';
//      ACaption:= VarToStr(AValuesArray.A[I].V[3]);//+',';
//      ACode:= VarToStr(AValuesArray.A[I].V[1]);//+',';
//      AItem:=lvData.Prop.Items.Add;
//      AItem.Caption:=ACaption;
//      AItem.Name:=ACode;
    ACaption:=VarToStr(AValuesArray.A[I].V[5]);
    if Result.IndexOf(ACaption)=-1 then
    begin
      Result.Add(ACaption);
    end;
  end;

end;

function GetCountryCodeEnNameMapList:TStringList;
var
  I:Integer;
//  ACountryJson:ISuperObject;
  AValuesArray:ISuperArray;
//  AValue:Variant;
  AEnCaption:String;
  ACode:String;
//  AItem:TSkinItem;
begin
  //加载所有州
  Result:=TStringList.Create;

//  ACountryJson:=SO(ReadResDataString('CFGJson_countrydata'));
//  AValuesArray:=ACountryJson.A['values'];
  AValuesArray:=GetCountryListJsonArray;//ACountryJson.A['values'];
  for I := 0 to AValuesArray.Length - 1 do
  begin
//    ShowMessage(AValuesArray.A[I].S[0] + ' + ' + AValuesArray.A[I].S[3]);
    //["674", "NR", "Nauru", "瑙鲁", "+674", "亚洲", "4:00 AM", "12:00 PM"]
//      APhoneCaption:= VarToStr(AValuesArray.A[I].V[3]) + '(' + VarToStr(AValuesArray.A[I].V[1]) + ')' + '+' + VarToStr(AValuesArray.A[I].V[0]) + ',';
//      APhoneValue:= VarToStr(AValuesArray.A[I].V[0]) + ',';
//      ACaption:= VarToStr(AValuesArray.A[I].V[3]);//+',';
//      ACode:= VarToStr(AValuesArray.A[I].V[1]);//+',';
//      AItem:=lvData.Prop.Items.Add;
//      AItem.Caption:=ACaption;
//      AItem.Name:=ACode;
    ACode:=VarToStr(AValuesArray.A[I].V[1]);
    AEnCaption:=VarToStr(AValuesArray.A[I].V[2]);
//    if Result.IndexOf(ACaption)=-1 then
//    begin
//      Result.Add(ACaption);
//    end;
    Result.Values[ACode]:=AEnCaption;

  end;

end;


function GetCountryCNNameByCode(ACode:String):String;
var
  I:Integer;
//  ACountryJson:ISuperObject;
  AValuesArray:ISuperArray;
//  AValue:Variant;
//  ACnCaption:String;
//  ACode:String;
//  AItem:TSkinItem;
begin
  Result:='';

//  ACountryJson:=SO(ReadResDataString('CFGJson_countrydata'));
//  AValuesArray:=ACountryJson.A['values'];
  AValuesArray:=GetCountryListJsonArray;//ACountryJson.A['values'];
  for I := 0 to AValuesArray.Length - 1 do
  begin
//    ShowMessage(AValuesArray.A[I].S[0] + ' + ' + AValuesArray.A[I].S[3]);
    //["674", "NR", "Nauru", "瑙鲁", "+674", "亚洲", "4:00 AM", "12:00 PM"]
//      APhoneCaption:= VarToStr(AValuesArray.A[I].V[3]) + '(' + VarToStr(AValuesArray.A[I].V[1]) + ')' + '+' + VarToStr(AValuesArray.A[I].V[0]) + ',';
//      APhoneValue:= VarToStr(AValuesArray.A[I].V[0]) + ',';
//      ACaption:= VarToStr(AValuesArray.A[I].V[3]);//+',';
//      ACode:= VarToStr(AValuesArray.A[I].V[1]);//+',';
//      AItem:=lvData.Prop.Items.Add;
//      AItem.Caption:=ACaption;
//      AItem.Name:=ACode;
//    ACode:=VarToStr(AValuesArray.A[I].V[1]);
    if SameText(VarToStr(AValuesArray.A[I].V[1]),ACode) then
    begin
      Result:=VarToStr(AValuesArray.A[I].V[3]);
      Exit;
    end;
//    if Result.IndexOf(ACaption)=-1 then
//    begin
//      Result.Add(ACaption);
//    end;
//    Result.Values[ACode]:=AEnCaption;

  end;

end;




end.
