//�ؼ���������

protected

  //����
  FProperties:TSkinControlProperties;

  function GetProperties:TSkinControlProperties;
  procedure SetProperties(const Value:TSkinControlProperties);
protected
  //��ȡ�ؼ�������
  function GetPropertiesClassType:TPropertiesClassType;virtual;


  {$IFDEF WinControl}
public
  //����
  property Properties:TSkinControlProperties read GetProperties write SetProperties;
  {$ENDIF}

  {$IFDEF FMXControl}
public
  //����
  property Properties:TSkinControlProperties read GetProperties write SetProperties;
  {$ENDIF}