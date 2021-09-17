  //素材属性声明



  public
    //控件类型
    property SkinControlType:TSkinControlType read GetSkinControlType;
    //当前使用的素材
    property CurrentUseMaterial:TSkinControlMaterial read GetCurrentUseMaterial;
  published
    //保持这个读取顺序
    //控件类型使用类型,不再使用
//    property ComponentTypeUseKind:TComponentTypeUseKind read GetComponentTypeUseKind write SetComponentTypeUseKind;
    property ComponentTypeUseKind:TComponentTypeUseKind read FComponentTypeUseKind write FComponentTypeUseKind;
    //素材使用类型
    property MaterialUseKind:TMaterialUseKind read GetMaterialUseKind write SetMaterialUseKind;
    //保持自身的素材
    property KeepSelfOwnMaterial:Boolean read GetKeepSelfOwnMaterial write SetKeepSelfOwnMaterial;
    //控件类型名称
    property ComponentTypeName:String read GetComponentTypeName write SetComponentTypeName;
    //皮肤包里指定的素材名称
    property MaterialName:String read GetMaterialName write SetMaterialName;



    //皮肤素材
    property SelfOwnMaterial:TSkinControlMaterial read GetSelfOwnMaterial;
    //引用的皮肤素材
    property RefMaterial:TSkinControlMaterial read GetRefMaterial write SetRefMaterial;




