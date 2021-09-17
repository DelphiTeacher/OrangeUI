//�ز���������
  private
    //FDataObject�Ƿ��������Լ���
    FIsOwnDataObject:Boolean;
    FDataObject:TObject;
  public
    function CreateOwnDataObject(AClass:TClass):TObject;
    property DataObject:TObject read FDataObject write FDataObject;


  protected

    //�ؼ���������
    FComponentTypeName:String;
    //�ؼ�����ʹ������,����ʹ��
    FComponentTypeUseKind:TComponentTypeUseKind;




    //�ؼ�����
    FSkinControlType:TSkinControlType;



    //Ƥ������ָ�����ز�����
    FMaterialName:String;
    //�ز�ʹ������
    FMaterialUseKind:TMaterialUseKind;




    //���õ��ز�
    //[Weak]
    FRefMaterial:TSkinControlMaterial;
    //�����������ز�
    FKeepSelfOwnMaterial:Boolean;
    //�����Լ���Ƥ���ز�
    FMaterial:TSkinControlMaterial;
    //��ǰ��ʹ�õ�Ƥ���ز�
    FCurrentUseSkinMaterial:TSkinControlMaterial;




    //�زĸ���֪ͨ����
    FMaterialChangeLink:TSkinObjectChangeLink;


    function GetSkinControlTypeClass:TControlTypeClass;virtual;
    function GetMaterialClass:TMaterialClass;virtual;
    //�����ؼ�����
    procedure CreateSkinControlType;virtual;
    //���������Լ���Ƥ���ز�
    procedure CreateSelfOwnMaterial;
    //��ȡ��ǰʹ�õ�Ƥ���ز�
    function GetCurrentUseMaterial:TSkinControlMaterial;
    //��ȡ��ǰʹ�õĿؼ���������
    function GetCurrentUseComponentTypeName:String;


    //��鵱ǰʹ�õ�Ƥ���ز��Ƿ���ؼ�����ƥ��
    procedure CheckCurrentUseMaterial;virtual;
    procedure CheckSelfOwnMaterial;virtual;



    //���Ƥ���ز�
    procedure UnUseCurrentUseMaterial;
    procedure ClearSelfOwnMaterial;


    //��ȡ�ؼ�����
    function GetSkinControlType:TSkinControlType;
    //��ȡ�Լ���Ƥ���ز�
    function GetSelfOwnMaterial:TSkinControlMaterial;
    //�������õ�Ƥ���ز�
    procedure SetRefMaterial(Value:TSkinControlMaterial);
    //�����ز�
    procedure AssignMaterial(ASrcControlIntf:ISkinControlMaterial);
    //�����������ز�
    procedure SetKeepSelfOwnMaterial(const Value:Boolean);
    //���ÿؼ���������
    procedure SetComponentTypeName(const Value: String);
    //�����ز�����
    procedure SetMaterialName(const Value: String);
    //���ÿؼ�����ʹ������
//    procedure SetComponentTypeUseKind(const Value: TComponentTypeUseKind);
    procedure NilSelfOwnMaterial;
    //�����ز�ʹ������
    procedure SetMaterialUseKind(const Value: TMaterialUseKind);




    function GetMaterialName:String;
    function GetComponentTypeName: String;
    function GetRefMaterial:TSkinControlMaterial;
    function GetMaterialUseKind: TMaterialUseKind;
    function GetKeepSelfOwnMaterial:Boolean;
//    function GetComponentTypeUseKind: TComponentTypeUseKind;




    //Ƥ���زĸ���֪ͨ�¼�
    procedure OnSkinMaterialChange(Sender: TObject);virtual;
    procedure DoCustomSkinMaterialChange(Sender: TObject);virtual;

    //Ƥ���ز��ͷ�֪ͨ�¼�
    procedure OnSkinMaterialDestroy(Sender: TObject);virtual;


    function Get_Version:String;

published
    property _Version:String read Get_Version;


