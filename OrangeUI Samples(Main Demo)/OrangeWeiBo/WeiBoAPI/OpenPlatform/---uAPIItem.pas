unit uAPIItem;

interface

uses
//  Windows,
  uBaseList;

type
  //֧�ֵ�HTTP���󷽷�
  THTTPRequestMethod=(hrmGet,hrmPost);
  THTTPRequestMethods=set of THTTPRequestMethod;
  //�������ݸ�ʽ
  TReponseDataFormat=(rdfUrl,rdfJson,rdfXml);
  //�ӿ���Ҫ�ķ��ʼ���
  TAccessLevel=(alNormal);
  //������������
  TResponseDataType=(rdtRedirectUrl,rdtData);

  TValueScope=class
  public
    //����ȡֵ
    Value:Variant;
    //����˵��
    Descrip:String;
  end;

  TValueScopeList=class(TBaseList)
  private
    function GetItem(Index: Integer): TValueScope;
  public
    function Add(const Value:Variant;const Descrip:String):TValueScope;
    property Items[Index:Integer]:TValueScope read GetItem;
  end;

  TAPIParam=class
  public
    //������
    Name:String;
    //��ѡ
    Need:Boolean;
    //���ͼ���Χ
    Kind:String;
    //˵��
    Descrip:String;
    //����ֵ
    Value:Variant;
    //������Χ
    ValueScoptList:TValueScopeList;
  public
    constructor Create;
    destructor Destroy;override;
  end;

  TAPIParamList=class(TBaseList)
  private
    function GetItem(Index: Integer): TAPIParam;
    function GetItemByName(const Name: String): TAPIParam;
  public
    //���API�����б��ֵ
    procedure ClearValue;
    property Items[Index:Integer]:TAPIParam read GetItem;
    property ItemByName[const Name:String]:TAPIParam read GetItemByName;
    //����ֵ
    function Add( const Name:String;
                  const Need:Boolean;
                  const Kind:String;
                  const Descrip:String
                  ):TAPIParam;
  end;

  TAPIItem=class
  public
    //API����
    Name:String;
    //����
    Descrip:String;
    //URL
    URL:String;
    //������������
    ResponseDataType:TResponseDataType;
    //�������ݸ�ʽ
    ResponseDataFormat:TReponseDataFormat;
    //HTTP����ʽ
    HttpRequestMethods:THTTPRequestMethods;
    //�Ƿ���Ҫ��¼
    NeedLogin:Boolean;
    //������Ȩ����
    //���ʼ���
    AccessLevel:TAccessLevel;
    //Ƶ������
    TimesLimit:Boolean;
    //�����б�
    ParamList:TAPIParamList;
  protected
    procedure Init;virtual;abstract;
  public
    constructor Create;
    destructor Destroy;override;
  end;

  TAPIList=class(TBaseList)
  private
    function GetItem(Index: Integer): TAPIItem;
  public
    property Items[Index:Integer]:TAPIItem read GetItem;
  end;

implementation

{ TValueScopeList }

function TValueScopeList.Add(const Value: Variant;
                              const Descrip: String): TValueScope;
begin
  Result:=TValueScope.Create;
  Result.Value:=Value;
  Result.Descrip:=Descrip;
end;

function TValueScopeList.GetItem(Index: Integer): TValueScope;
begin
  Result:=TValueScope(Inherited Items[Index]);
end;

{ TAPIParam }

constructor TAPIParam.Create;
begin
  ValueScoptList:=TValueScopeList.Create;
end;

destructor TAPIParam.Destroy;
begin
  ValueScoptList.Clear(True);
  ValueScoptList.Free;
  inherited;
end;

{ TAPIItem }

constructor TAPIItem.Create;
begin
  ParamList:=TAPIParamList.Create;
end;

destructor TAPIItem.Destroy;
begin
  ParamList.Clear(True);
  ParamList.Free;
  inherited;
end;

{ TAPIParamList }

function TAPIParamList.Add(const Name: String;
                            const Need: Boolean;
                            const Kind: String;
                            const Descrip: String): TAPIParam;
begin
  Result:=TAPIParam.Create;
  Result.Name:=Name;
  Result.Need:=Need;
  Result.Kind:=Kind;
  Result.Descrip:=Descrip;
end;

procedure TAPIParamList.ClearValue;
var
  I:Integer;
begin
  For I:=0 to Self.Count-1 do
  begin
    //varEmpty��varNUll
    Items[I].Value:=varNUll;
  end;
end;

function TAPIParamList.GetItem(Index: Integer): TAPIParam;
begin
  Result:=TAPIParam(Inherited Items[Index]);
end;

function TAPIParamList.GetItemByName(const Name: String): TAPIParam;
var
  I:Integer;
begin
  Result:=nil;
  For I:=0 to Self.Count-1 do
  begin
    if Items[I].Name=Name then
    begin
      Result:=Items[I];
    end;
  end;
end;

{ TAPIList }

function TAPIList.GetItem(Index: Integer): TAPIItem;
begin
  Result:=TAPIItem(inherited Items[Index]);
end;

end.


