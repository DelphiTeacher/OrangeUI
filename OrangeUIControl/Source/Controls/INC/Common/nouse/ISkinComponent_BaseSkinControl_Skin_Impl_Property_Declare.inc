  //�ز���������



  public
    //�ؼ��߼�����
    property SkinControlType:TSkinControlType read FSkinControlType;
    //��ǰʹ�õ��ز�
    property CurrentUseMaterial:TSkinControlMaterial read GetCurrentUseMaterial;
  public
    //Ƥ���ز�
    property Material:TSkinControlMaterial read FMaterial;
  published

    //�ز�ʹ������
    property MaterialUseKind:TMaterialUseKind read FMaterialUseKind write SetMaterialUseKind;


    //Ƥ������ָ�����ز�����
    property MaterialName:String read FMaterialName write SetMaterialName;



    //���õ�Ƥ���ز�
    property RefMaterial:TSkinControlMaterial read FRefMaterial write SetRefMaterial;




