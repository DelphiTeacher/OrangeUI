  //�ز���������



  public
    //�ؼ�����
    property SkinControlType:TSkinControlType read GetSkinControlType;
    //��ǰʹ�õ��ز�
    property CurrentUseMaterial:TSkinControlMaterial read GetCurrentUseMaterial;
  published
    //���������ȡ˳��
    //�ؼ�����ʹ������,����ʹ��
//    property ComponentTypeUseKind:TComponentTypeUseKind read GetComponentTypeUseKind write SetComponentTypeUseKind;
    property ComponentTypeUseKind:TComponentTypeUseKind read FComponentTypeUseKind write FComponentTypeUseKind;
    //�ز�ʹ������
    property MaterialUseKind:TMaterialUseKind read GetMaterialUseKind write SetMaterialUseKind;
    //�����������ز�
    property KeepSelfOwnMaterial:Boolean read GetKeepSelfOwnMaterial write SetKeepSelfOwnMaterial;
    //�ؼ���������
    property ComponentTypeName:String read GetComponentTypeName write SetComponentTypeName;
    //Ƥ������ָ�����ز�����
    property MaterialName:String read GetMaterialName write SetMaterialName;



    //Ƥ���ز�
    property SelfOwnMaterial:TSkinControlMaterial read GetSelfOwnMaterial;
    //���õ�Ƥ���ز�
    property RefMaterial:TSkinControlMaterial read GetRefMaterial write SetRefMaterial;



