    //�ز������ͷŴ���
    UnUseCurrentUseMaterial;

    //�ͷ�Ƥ���زĺͿؼ�����
    FreeAndNil(FMaterialChangeLink);


    FreeAndNil(FSkinControlType);



    //ȥ����ǰ�زĵ�����
    UnUseCurrentUseMaterial;


    //���SelfOwnMaterial
    ClearSelfOwnMaterial;



    if FIsOwnDataObject and (FDataObject<>nil) then
    begin
      FreeAndNil(FDataObject);
    end;

