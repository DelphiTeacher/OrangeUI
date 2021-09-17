//
// Created by the DataSnap proxy generator.
// 2016-10-20 9:14:10
//

unit ClientClassesUnit1;

interface

uses System.JSON, Datasnap.DSProxyRest, Datasnap.DSClientRest, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect;

type
  TServerMethods1Client = class(TDSAdminRestClient)
  private
    FEchoStringCommand: TDSRestCommand;
    FReverseStringCommand: TDSRestCommand;
    FCheckNewVersionCommand: TDSRestCommand;
    FGetGoodsCategoryCommand: TDSRestCommand;
    FGetGoodsListCommand: TDSRestCommand;
    FBuyGoodsCommand: TDSRestCommand;
  public
    constructor Create(ARestConnection: TDSRestConnection); overload;
    constructor Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function EchoString(Value: string; const ARequestFilter: string = ''): string;
    function ReverseString(Value: string; const ARequestFilter: string = ''): string;
    function CheckNewVersion(const ARequestFilter: string = ''): string;
    function GetGoodsCategory(const ARequestFilter: string = ''): string;
    function GetGoodsList(const ARequestFilter: string = ''): string;
    function BuyGoods(ARoomNO: string; AWaitorNO: string; AGoodsListJsonStr: string; AMoney: Double; const ARequestFilter: string = ''): string;
  end;

const
  TServerMethods1_EchoString: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_ReverseString: array [0..1] of TDSRestParameterMetaData =
  (
    (Name: 'Value'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_CheckNewVersion: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_GetGoodsCategory: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_GetGoodsList: array [0..0] of TDSRestParameterMetaData =
  (
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

  TServerMethods1_BuyGoods: array [0..4] of TDSRestParameterMetaData =
  (
    (Name: 'ARoomNO'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'AWaitorNO'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'AGoodsListJsonStr'; Direction: 1; DBXType: 26; TypeName: 'string'),
    (Name: 'AMoney'; Direction: 1; DBXType: 7; TypeName: 'Double'),
    (Name: ''; Direction: 4; DBXType: 26; TypeName: 'string')
  );

implementation

function TServerMethods1Client.EchoString(Value: string; const ARequestFilter: string): string;
begin
  if FEchoStringCommand = nil then
  begin
    FEchoStringCommand := FConnection.CreateCommand;
    FEchoStringCommand.RequestType := 'GET';
    FEchoStringCommand.Text := 'TServerMethods1.EchoString';
    FEchoStringCommand.Prepare(TServerMethods1_EchoString);
  end;
  FEchoStringCommand.Parameters[0].Value.SetWideString(Value);
  FEchoStringCommand.Execute(ARequestFilter);
  Result := FEchoStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.ReverseString(Value: string; const ARequestFilter: string): string;
begin
  if FReverseStringCommand = nil then
  begin
    FReverseStringCommand := FConnection.CreateCommand;
    FReverseStringCommand.RequestType := 'GET';
    FReverseStringCommand.Text := 'TServerMethods1.ReverseString';
    FReverseStringCommand.Prepare(TServerMethods1_ReverseString);
  end;
  FReverseStringCommand.Parameters[0].Value.SetWideString(Value);
  FReverseStringCommand.Execute(ARequestFilter);
  Result := FReverseStringCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.CheckNewVersion(const ARequestFilter: string): string;
begin
  if FCheckNewVersionCommand = nil then
  begin
    FCheckNewVersionCommand := FConnection.CreateCommand;
    FCheckNewVersionCommand.RequestType := 'GET';
    FCheckNewVersionCommand.Text := 'TServerMethods1.CheckNewVersion';
    FCheckNewVersionCommand.Prepare(TServerMethods1_CheckNewVersion);
  end;
  FCheckNewVersionCommand.Execute(ARequestFilter);
  Result := FCheckNewVersionCommand.Parameters[0].Value.GetWideString;
end;

function TServerMethods1Client.GetGoodsCategory(const ARequestFilter: string): string;
begin
  if FGetGoodsCategoryCommand = nil then
  begin
    FGetGoodsCategoryCommand := FConnection.CreateCommand;
    FGetGoodsCategoryCommand.RequestType := 'GET';
    FGetGoodsCategoryCommand.Text := 'TServerMethods1.GetGoodsCategory';
    FGetGoodsCategoryCommand.Prepare(TServerMethods1_GetGoodsCategory);
  end;
  FGetGoodsCategoryCommand.Execute(ARequestFilter);
  Result := FGetGoodsCategoryCommand.Parameters[0].Value.GetWideString;
end;

function TServerMethods1Client.GetGoodsList(const ARequestFilter: string): string;
begin
  if FGetGoodsListCommand = nil then
  begin
    FGetGoodsListCommand := FConnection.CreateCommand;
    FGetGoodsListCommand.RequestType := 'GET';
    FGetGoodsListCommand.Text := 'TServerMethods1.GetGoodsList';
    FGetGoodsListCommand.Prepare(TServerMethods1_GetGoodsList);
  end;
  FGetGoodsListCommand.Execute(ARequestFilter);
  Result := FGetGoodsListCommand.Parameters[0].Value.GetWideString;
end;

function TServerMethods1Client.BuyGoods(ARoomNO: string; AWaitorNO: string; AGoodsListJsonStr: string; AMoney: Double; const ARequestFilter: string): string;
begin
  if FBuyGoodsCommand = nil then
  begin
    FBuyGoodsCommand := FConnection.CreateCommand;
    FBuyGoodsCommand.RequestType := 'GET';
    FBuyGoodsCommand.Text := 'TServerMethods1.BuyGoods';
    FBuyGoodsCommand.Prepare(TServerMethods1_BuyGoods);
  end;
  FBuyGoodsCommand.Parameters[0].Value.SetWideString(ARoomNO);
  FBuyGoodsCommand.Parameters[1].Value.SetWideString(AWaitorNO);
  FBuyGoodsCommand.Parameters[2].Value.SetWideString(AGoodsListJsonStr);
  FBuyGoodsCommand.Parameters[3].Value.SetDouble(AMoney);
  FBuyGoodsCommand.Execute(ARequestFilter);
  Result := FBuyGoodsCommand.Parameters[4].Value.GetWideString;
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection);
begin
  inherited Create(ARestConnection);
end;

constructor TServerMethods1Client.Create(ARestConnection: TDSRestConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ARestConnection, AInstanceOwner);
end;

destructor TServerMethods1Client.Destroy;
begin
  FEchoStringCommand.DisposeOf;
  FReverseStringCommand.DisposeOf;
  FCheckNewVersionCommand.DisposeOf;
  FGetGoodsCategoryCommand.DisposeOf;
  FGetGoodsListCommand.DisposeOf;
  FBuyGoodsCommand.DisposeOf;
  inherited;
end;

end.

