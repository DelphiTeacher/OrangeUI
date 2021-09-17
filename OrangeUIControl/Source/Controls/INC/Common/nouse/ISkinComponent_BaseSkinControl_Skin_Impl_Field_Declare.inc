//素材属性声明


  protected



    //控件类型
    FSkinControlType:TSkinControlType;



    //皮肤包里指定的素材名称
    FMaterialName:String;
    //素材使用类型
    FMaterialUseKind:TMaterialUseKind;




    //引用的素材
    FRefMaterial:TSkinControlMaterial;
    //属于自己的皮肤素材
    FMaterial:TSkinControlMaterial;
    //当前所使用的皮肤素材
    FCurrentUseSkinMaterial:TSkinControlMaterial;




    //素材更改通知链接
    FMaterialChangeLink:TSkinObjectChangeLink;



    function GetMaterialClass:TMaterialClass;virtual;


    function GetControlTypeClass:TControlTypeClass;virtual;


    //获取当前使用的皮肤素材
    function GetCurrentUseMaterial:TSkinControlMaterial;
    //清除皮肤素材
    procedure UnUseCurrentUseMaterial;
    procedure ClearSelfOwnMaterial;



    //获取控件类型
    function GetSkinControlType:TSkinControlType;



    //复制素材
    procedure AssignMaterial(ASrcControlIntf:ISkinControlMaterial);



    //设置引用的皮肤素材
    procedure SetRefMaterial(Value:TSkinControlMaterial);



    //设置素材名称
    procedure SetMaterialName(const Value: String);
    //设置素材使用类型
    procedure SetMaterialUseKind(const Value: TMaterialUseKind);


    //获取自己的皮肤素材
//    function GetSelfOwnMaterial:TSkinControlMaterial;
//    function GetMaterialName:String;
//    function GetRefMaterial:TSkinControlMaterial;
//    function GetMaterialUseKind: TMaterialUseKind;


    //皮肤素材更改通知事件
    procedure OnSkinMaterialChange(Sender: TObject);virtual;
    procedure DoCustomSkinMaterialChange(Sender: TObject);virtual;



    //皮肤素材释放通知事件
    procedure OnSkinMaterialDestroy(Sender: TObject);virtual;




