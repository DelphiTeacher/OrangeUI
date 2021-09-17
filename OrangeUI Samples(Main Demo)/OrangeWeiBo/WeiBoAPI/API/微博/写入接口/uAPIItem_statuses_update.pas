//http://open.weibo.com/wiki/2/statuses/update
unit uAPIItem_statuses_update;

interface

uses
  Classes,
  SysUtils,
  XSuperObject,
  uFuncCommon,
  uDataStructure,
  uOpenPlatform;

type
  TAPIResponse_statuses_update=class(TAPIResponse)
  protected
    function ParseDataStructure:Boolean;override;
  public
    status:Tstatus;
    constructor Create;
    destructor Destroy;override;
  end;

  TAPIItem_statuses_update=class(TAPIItem)
  protected
    procedure Init;override;
  end;

implementation

{ TAPIItem_statuses_update }

procedure TAPIItem_statuses_update.Init;
begin
  inherited;
  Name:='statuses/update';
  Descrip:='����һ����΢��';
  Url:='https://api.weibo.com/2/statuses/update.json';
  HttpRequestMethods:=[hrmPost];
  ResponseDataType:=rdtData;
  ResponseDataFormat:=rdfJson;
  NeedLogin:=True;

  Self.ParamList.Add('source',false,'string','����OAuth��Ȩ��ʽ����Ҫ�˲�����������Ȩ��ʽΪ�����������ֵΪӦ�õ�AppKey��  ');
  Self.ParamList.Add('access_token',false,'string','����OAuth��Ȩ��ʽΪ���������������Ȩ��ʽ����Ҫ�˲�����OAuth��Ȩ���á�  ');
  Self.ParamList.Add('status',true,'string','Ҫ������΢���ı����ݣ�������URLencode�����ݲ�����140�����֡�  ').NeedUrlEncord:=True;
  Self.ParamList.Add('visible',false,'int','΢���Ŀɼ��ԣ�0���������ܿ���1�����Լ��ɼ���2�����ѿɼ���3��ָ������ɼ���Ĭ��Ϊ0��  ');
  Self.ParamList.Add('list_id',false,'string','΢���ı���Ͷ��ָ������ID��ֻ�е�visible����Ϊ3ʱ��Ч�ұ�ѡ��  ');
  Self.ParamList.Add('lat',false,'float','γ�ȣ���Ч��Χ��-90.0��+90.0��+��ʾ��γ��Ĭ��Ϊ0.0��  ');
  Self.ParamList.Add('long',false,'float','���ȣ���Ч��Χ��-180.0��+180.0��+��ʾ������Ĭ��Ϊ0.0��  ');
  Self.ParamList.Add('annotations',false,'string','Ԫ���ݣ���Ҫ��Ϊ�˷��������Ӧ�ü�¼һЩ�ʺ����Լ�ʹ�õ���Ϣ��ÿ��΢�����԰���һ�����߶��Ԫ���ݣ�������json�ִ�����ʽ�ύ���ִ����Ȳ�����512���ַ����������ݿ����Զ���  ');
  Self.ParamList.Add('rip',false,'string','�������ϱ��Ĳ����û���ʵIP�����磺211.156.0.1��  ');

  //�������η�����΢���������ظ���
  //�ǻ�Ա������΢���������Ա�����200��
end;

{ TAPIResponse_statuses_update }

constructor TAPIResponse_statuses_update.Create;
begin
end;

destructor TAPIResponse_statuses_update.Destroy;
begin
  FreeAndNil(status);
  inherited;
end;

function TAPIResponse_statuses_update.ParseDataStructure: Boolean;
begin
  Result:=False;

  FreeAndNil(status);

  if RootJson<>nil then
  begin
    status:=Tstatus.Create;
    status.ParseFromJson(RootJson);
  end;

  Result:=True;
end;


initialization
  RegisterAPIItem('statuses/update',TAPIItem_statuses_update);

end.
