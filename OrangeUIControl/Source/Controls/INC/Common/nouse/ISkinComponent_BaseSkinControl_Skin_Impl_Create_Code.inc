//�ؼ��ز�����Ҫ�����Գ�ʼ����



  //������ʱ��,ʹ��Ĭ������
  Self.FMaterialUseKind:=mukSelfOwn;



  {$IFNDEF WinForm}
  {$IFNDEF WinEdit}
  //��������
  FCanvas:=CreateDrawCanvas;
  {$ENDIF}
  {$ENDIF}




  //�����Լ��Ŀؼ��߼�
  FSkinControlType:=TSkinControlType(GetControlTypeClass.Create);
  //�������������Ϊ�Լ�
  FSkinControlType.SkinControl:=Self;




  //�������ѵ��ز�
  //����Ƥ���زĶ���
  Self.FMaterial:=GetMaterialClass.Create(Self);
  //����Ƥ���ز���
  Self.FMaterial.Name:='Material';
  //����Ϊ�ӿؼ�
  Self.FMaterial.SetSubComponent(True);
  //�����ͷ�֪ͨ
  FMaterial.FreeNotification(Self);




  //�����زĸ���֪ͨ����
  FMaterialChangeLink:=TSkinObjectChangeLink.Create;
  FMaterialChangeLink.OnChange:=OnSkinMaterialChange;
  FMaterialChangeLink.OnDestroy:=OnSkinMaterialDestroy;
