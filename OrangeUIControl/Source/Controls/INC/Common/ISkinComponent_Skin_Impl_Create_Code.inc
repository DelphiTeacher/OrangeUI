//�ؼ��ز�����Ҫ�����Գ�ʼ����




  //������ʱ��,ʹ��Ĭ������
//  Self.FComponentTypeUseKind:=ctukDefault;
  Self.FMaterialUseKind:=mukSelfOwn;
  //����SelfOwnMaterial
  Self.FKeepSelfOwnMaterial:=True;


  {$IFNDEF WinForm}
  {$IFNDEF WinEdit}
  FCanvas:=CreateDrawCanvas(ClassName+'.Create '+Name);
  {$ENDIF}
  {$ENDIF}




  //�����زĸ���֪ͨ����
  FMaterialChangeLink:=TSkinObjectChangeLink.Create;
  FMaterialChangeLink.OnChange:=OnSkinMaterialChange;
  FMaterialChangeLink.OnDestroy:=OnSkinMaterialDestroy;



  //Ĭ��ֵ
//  FBindItemFieldType:=ftString;