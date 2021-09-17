//控件素材所需要的属性初始代码




  //创建的时候,使用默认设置
//  Self.FComponentTypeUseKind:=ctukDefault;
  Self.FMaterialUseKind:=mukSelfOwn;
  //保留SelfOwnMaterial
  Self.FKeepSelfOwnMaterial:=True;


  {$IFNDEF WinForm}
  {$IFNDEF WinEdit}
  FCanvas:=CreateDrawCanvas(ClassName+'.Create '+Name);
  {$ENDIF}
  {$ENDIF}




  //创建素材更改通知链接
  FMaterialChangeLink:=TSkinObjectChangeLink.Create;
  FMaterialChangeLink.OnChange:=OnSkinMaterialChange;
  FMaterialChangeLink.OnDestroy:=OnSkinMaterialDestroy;



  //默认值
//  FBindItemFieldType:=ftString;
