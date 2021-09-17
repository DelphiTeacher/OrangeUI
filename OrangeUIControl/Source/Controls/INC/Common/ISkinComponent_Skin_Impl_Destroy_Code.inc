    //素材属性释放代码
    UnUseCurrentUseMaterial;

    //释放皮肤素材和控件类型
    FreeAndNil(FMaterialChangeLink);


    FreeAndNil(FSkinControlType);



    //去除当前素材的引用
    UnUseCurrentUseMaterial;


    //清除SelfOwnMaterial
    ClearSelfOwnMaterial;



    if FIsOwnDataObject and (FDataObject<>nil) then
    begin
      FreeAndNil(FDataObject);
    end;


