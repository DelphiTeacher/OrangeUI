//�ز���������


  protected



    //�ؼ�����
    FSkinControlType:TSkinControlType;



    //Ƥ������ָ�����ز�����
    FMaterialName:String;
    //�ز�ʹ������
    FMaterialUseKind:TMaterialUseKind;




    //���õ��ز�
    FRefMaterial:TSkinControlMaterial;
    //�����Լ���Ƥ���ز�
    FMaterial:TSkinControlMaterial;
    //��ǰ��ʹ�õ�Ƥ���ز�
    FCurrentUseSkinMaterial:TSkinControlMaterial;




    //�زĸ���֪ͨ����
    FMaterialChangeLink:TSkinObjectChangeLink;



    function GetMaterialClass:TMaterialClass;virtual;


    function GetControlTypeClass:TControlTypeClass;virtual;


    //��ȡ��ǰʹ�õ�Ƥ���ز�
    function GetCurrentUseMaterial:TSkinControlMaterial;
    //���Ƥ���ز�
    procedure UnUseCurrentUseMaterial;
    procedure ClearSelfOwnMaterial;



    //��ȡ�ؼ�����
    function GetSkinControlType:TSkinControlType;



    //�����ز�
    procedure AssignMaterial(ASrcControlIntf:ISkinControlMaterial);



    //�������õ�Ƥ���ز�
    procedure SetRefMaterial(Value:TSkinControlMaterial);



    //�����ز�����
    procedure SetMaterialName(const Value: String);
    //�����ز�ʹ������
    procedure SetMaterialUseKind(const Value: TMaterialUseKind);


    //��ȡ�Լ���Ƥ���ز�
//    function GetSelfOwnMaterial:TSkinControlMaterial;
//    function GetMaterialName:String;
//    function GetRefMaterial:TSkinControlMaterial;
//    function GetMaterialUseKind: TMaterialUseKind;


    //Ƥ���زĸ���֪ͨ�¼�
    procedure OnSkinMaterialChange(Sender: TObject);virtual;
    procedure DoCustomSkinMaterialChange(Sender: TObject);virtual;



    //Ƥ���ز��ͷ�֪ͨ�¼�
    procedure OnSkinMaterialDestroy(Sender: TObject);virtual;



