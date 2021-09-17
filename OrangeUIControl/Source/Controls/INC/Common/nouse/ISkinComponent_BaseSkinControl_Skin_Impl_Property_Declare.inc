  //素材属性声明



  public
    //控件逻辑类型
    property SkinControlType:TSkinControlType read FSkinControlType;
    //当前使用的素材
    property CurrentUseMaterial:TSkinControlMaterial read GetCurrentUseMaterial;
  public
    //皮肤素材
    property Material:TSkinControlMaterial read FMaterial;
  published

    //素材使用类型
    property MaterialUseKind:TMaterialUseKind read FMaterialUseKind write SetMaterialUseKind;


    //皮肤包里指定的素材名称
    property MaterialName:String read FMaterialName write SetMaterialName;



    //引用的皮肤素材
    property RefMaterial:TSkinControlMaterial read FRefMaterial write SetRefMaterial;





