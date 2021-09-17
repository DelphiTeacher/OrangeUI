//控件素材所需要的属性初始代码



  //创建的时候,使用默认设置
  Self.FMaterialUseKind:=mukSelfOwn;



  {$IFNDEF WinForm}
  {$IFNDEF WinEdit}
  //创建画布
  FCanvas:=CreateDrawCanvas;
  {$ENDIF}
  {$ENDIF}




  //创建自己的控件逻辑
  FSkinControlType:=TSkinControlType(GetControlTypeClass.Create);
  //将风格的组件设置为自己
  FSkinControlType.SkinControl:=Self;




  //创建自已的素材
  //创建皮肤素材对象
  Self.FMaterial:=GetMaterialClass.Create(Self);
  //设置皮肤素材名
  Self.FMaterial.Name:='Material';
  //设置为子控件
  Self.FMaterial.SetSubComponent(True);
  //设置释放通知
  FMaterial.FreeNotification(Self);




  //创建素材更改通知链接
  FMaterialChangeLink:=TSkinObjectChangeLink.Create;
  FMaterialChangeLink.OnChange:=OnSkinMaterialChange;
  FMaterialChangeLink.OnDestroy:=OnSkinMaterialDestroy;

