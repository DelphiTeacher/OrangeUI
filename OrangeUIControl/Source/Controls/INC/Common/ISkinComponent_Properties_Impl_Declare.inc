//控件属性声明

protected

  //属性
  FProperties:TSkinControlProperties;

  function GetProperties:TSkinControlProperties;
  procedure SetProperties(const Value:TSkinControlProperties);
protected
  //获取控件属性类
  function GetPropertiesClassType:TPropertiesClassType;virtual;


  {$IFDEF WinControl}
public
  //属性
  property Properties:TSkinControlProperties read GetProperties write SetProperties;
  {$ENDIF}

  {$IFDEF FMXControl}
public
  //属性
  property Properties:TSkinControlProperties read GetProperties write SetProperties;
  {$ENDIF}
