//素材属性声明
  private
    //FDataObject是否是属于自己的
    FIsOwnDataObject:Boolean;
    FDataObject:TObject;
  public
    function CreateOwnDataObject(AClass:TClass):TObject;
    property DataObject:TObject read FDataObject write FDataObject;


  protected

    //控件类型名称
    FComponentTypeName:String;
    //控件类型使用类型,不再使用
    FComponentTypeUseKind:TComponentTypeUseKind;




    //控件类型
    FSkinControlType:TSkinControlType;



    //皮肤包里指定的素材名称
    FMaterialName:String;
    //素材使用类型
    FMaterialUseKind:TMaterialUseKind;




    //引用的素材
    //[Weak]
    FRefMaterial:TSkinControlMaterial;
    //保持自身的素材
    FKeepSelfOwnMaterial:Boolean;
    //属于自己的皮肤素材
    FMaterial:TSkinControlMaterial;
    //当前所使用的皮肤素材
    FCurrentUseSkinMaterial:TSkinControlMaterial;




    //素材更改通知链接
    FMaterialChangeLink:TSkinObjectChangeLink;


    function GetSkinControlTypeClass:TControlTypeClass;virtual;
    function GetMaterialClass:TMaterialClass;virtual;
    //创建控件类型
    procedure CreateSkinControlType;virtual;
    //创建属于自己的皮肤素材
    procedure CreateSelfOwnMaterial;
    //获取当前使用的皮肤素材
    function GetCurrentUseMaterial:TSkinControlMaterial;
    //获取当前使用的控件类型名称
    function GetCurrentUseComponentTypeName:String;


    //检查当前使用的皮肤素材是否与控件类型匹配
    procedure CheckCurrentUseMaterial;virtual;
    procedure CheckSelfOwnMaterial;virtual;



    //清除皮肤素材
    procedure UnUseCurrentUseMaterial;
    procedure ClearSelfOwnMaterial;


    //获取控件类型
    function GetSkinControlType:TSkinControlType;
    //获取自己的皮肤素材
    function GetSelfOwnMaterial:TSkinControlMaterial;
    //设置引用的皮肤素材
    procedure SetRefMaterial(Value:TSkinControlMaterial);
    //复制素材
    procedure AssignMaterial(ASrcControlIntf:ISkinControlMaterial);
    //保持自身的素材
    procedure SetKeepSelfOwnMaterial(const Value:Boolean);
    //设置控件类型名称
    procedure SetComponentTypeName(const Value: String);
    //设置素材名称
    procedure SetMaterialName(const Value: String);
    //设置控件类型使用类型
//    procedure SetComponentTypeUseKind(const Value: TComponentTypeUseKind);
    procedure NilSelfOwnMaterial;
    //设置素材使用类型
    procedure SetMaterialUseKind(const Value: TMaterialUseKind);




    function GetMaterialName:String;
    function GetComponentTypeName: String;
    function GetRefMaterial:TSkinControlMaterial;
    function GetMaterialUseKind: TMaterialUseKind;
    function GetKeepSelfOwnMaterial:Boolean;
//    function GetComponentTypeUseKind: TComponentTypeUseKind;




    //皮肤素材更改通知事件
    procedure OnSkinMaterialChange(Sender: TObject);virtual;
    procedure DoCustomSkinMaterialChange(Sender: TObject);virtual;

    //皮肤素材释放通知事件
    procedure OnSkinMaterialDestroy(Sender: TObject);virtual;


    function Get_Version:String;

published
    property _Version:String read Get_Version;



