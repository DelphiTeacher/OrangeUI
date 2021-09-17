//素材方法实现





function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetMaterialClass:TMaterialClass;
begin
  Result:=TSkinControlMaterial;
end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetControlTypeClass:TControlTypeClass;
begin
  Result:=TSkinControlType;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.UnUseCurrentUseMaterial;
begin
  if (Self.FCurrentUseSkinMaterial<>nil) then
  begin
    if FCurrentUseSkinMaterial=FRefMaterial then
    begin
      FRefMaterial:=nil;
    end;

    //去除释放通知
    FCurrentUseSkinMaterial.RemoveFreeNotification(Self);

    //去除更改通知
    FCurrentUseSkinMaterial.UnRegisterChanges(FMaterialChangeLink);

    FCurrentUseSkinMaterial:=nil;
  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.ClearSelfOwnMaterial;
begin
  if (Self.FMaterial<>nil) then
  begin

    //去除释放通知
    FMaterial.RemoveFreeNotification(Self);

    //去除更改通知
    FMaterial.UnRegisterChanges(FMaterialChangeLink);

    uFuncCommon.FreeAndNil(FMaterial);


//    if not (csReading in Self.ComponentState)
//      and not (csLoading in Self.ComponentState) then
//    begin
//      Self.Invalidate;
//    end;


  end;
end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetCurrentUseMaterial: TSkinControlMaterial;
begin
  if FCurrentUseSkinMaterial=nil then
  begin
        case Self.FMaterialUseKind of
          mukSelfOwn:
          begin
            //使用自已的皮肤素材
            FCurrentUseSkinMaterial:=Self.FMaterial;
          end;
          mukDefault:
          begin
            //使用皮肤包的默认分类素材
    //        FCurrentUseSkinMaterial:=GetGlobalSkinPackage.FindDefaultMaterial(Self.FProperties.GetComponentClassify,Self.GetCurrentUseComponentTypeName);
          end;
          mukName:
          begin
    //        //皮肤包指定名称的素材
    //        if (FMaterialName<>'')
    //          and (GlobalSkinManager<>nil)
    //          and (GlobalSkinManager.CurrentSkinPackage<>nil) then
    //        begin
    //          FCurrentUseSkinMaterial:=GlobalSkinManager.CurrentSkinPackage.FindMaterialByName(Self.FProperties.GetComponentClassify,Self.GetCurrentUseComponentTypeName,Self.FMaterialName);
    //
    //
    //          //加入释放通知
    //          if FCurrentUseSkinMaterial<>nil then
    //          begin
    ////            uBaseLog.HandleException(nil,'OrangeUI','uSkinPackage','GetCurrentUseMaterial GlobalSkinManager'+' '+IntToStr(Integer(GlobalSkinManager)));
    //            Self.FCurrentUseSkinMaterial.FreeNotification(Self);
    //          end;
    //        end
    ////        else
    ////        begin
    ////          //使用皮肤包的默认分类素材
    ////          FCurrentUseSkinMaterial:=GetGlobalSkinPackage.FindDefaultMaterial(Self.FProperties.GetComponentClassify,Self.GetCurrentUseComponentTypeName);
    ////        end
    //        ;
          end;
          mukRef,mukRefOnly:
          begin
            //使用引用的皮肤素材
            FCurrentUseSkinMaterial:=Self.FRefMaterial;
          end;
          mukRefByStyleName:
          begin
//            if (FMaterialName<>'') then
//            begin
//              FCurrentUseSkinMaterial:=FindGlobalMaterialByStyleName(
//                                          Self.FProperties.GetComponentClassify,
//                                          GetCurrentUseComponentTypeName,
//                                          FMaterialName
//                                          );
//            end;
          end;
        end;

        if FCurrentUseSkinMaterial<>nil then
        begin
          //加入更改通知
          Self.FCurrentUseSkinMaterial.RegisterChanges(FMaterialChangeLink);
        end;


  end;
  Result:=Self.FCurrentUseSkinMaterial;
end;

//function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetSelfOwnMaterial:TSkinControlMaterial;
//begin
//  Result:=FMaterial;
//end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.AssignMaterial(ASrcControlIntf:ISkinControlMaterial);
begin
//  Self.SetComponentTypeUseKind(ASrcComponentIntf.GetComponentTypeUseKind);
//  Self.SetComponentTypeName(ASrcComponentIntf.GetComponentTypeName);
//
//  Self.SetMaterialUseKind(ASrcComponentIntf.GetMaterialUseKind);
//  Self.SetMaterialName(ASrcComponentIntf.GetMaterialName);
//
//  Self.SetRefMaterial(ASrcComponentIntf.GetRefMaterial);
//  Self.SetKeepSelfOwnMaterial(ASrcComponentIntf.GetKeepSelfOwnMaterial);
//
//  if (Self.FMaterial<>nil) and (ASrcComponentIntf.GetSelfOwnMaterial<>nil) then
//  begin
//    Self.FMaterial.Assign(ASrcComponentIntf.GetSelfOwnMaterial);
//  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.SetRefMaterial(Value:TSkinControlMaterial);
//var
//  AMaterialClass:TMaterialClass;
begin
  if FRefMaterial<>Value then
  begin

//    if (Self.GetCurrentUseComponentTypeName<>'') and (Self.FProperties.GetComponentClassify<>'') then
//    begin
//      //获取素材类
//      AMaterialClass:=GlobalControlTypeRegManager.FindMaterialClassByComponentTypeName(Self.FProperties.GetComponentClassify,GetCurrentUseComponentTypeName);
//      if (AMaterialClass<>nil) then
//      begin


        if (Value<>nil) then
        begin
          //判断类是否符合
          if (Value.ClassType=GetMaterialClass) then
          begin
            //相符,就不再使用当前的素材
            UnUseCurrentUseMaterial;
          end
          else
          begin
            //不相符
            ShowException(Value.Name+'与此控件或此ComponentType匹配的Material类型不符');
            Exit;
          end;
        end;



        //删除释放通知
        if FRefMaterial<>nil then
        begin
          Self.FRefMaterial.RemoveFreeNotification(Self);
          //去除更改通知
          FRefMaterial.UnRegisterChanges(FMaterialChangeLink);
        end;


        FRefMaterial:=Value;


        //加入释放通知
        if FRefMaterial<>nil then
        begin
          Self.FRefMaterial.FreeNotification(Self);
        end;


        //如果是在设计时,那么直接设置MaterialUseKind
        if csDesigning in Self.ComponentState then
        begin
          FMaterialUseKind := mukRef;
        end;



        if not (csReading in Self.ComponentState)
          and not (csLoading in Self.ComponentState) then
        begin
          Self.Invalidate;
        end;



//      end;
//    end;

  end;
end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetSkinControlType:TSkinControlType;
begin
  Result:=FSkinControlType;
end;

//function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetRefMaterial:TSkinControlMaterial;
//begin
//  Result:=FRefMaterial;
//end;

//function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetMaterialUseKind: TMaterialUseKind;
//begin
//  Result:=FMaterialUseKind;
//end;

//function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetMaterialName: String;
//begin
//  Result:=FMaterialName;
//end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.SetMaterialName(const Value: String);
begin
  if (Self.FMaterialName<>Value)
    or ((Self.FMaterialName<>Value) and (FCurrentUseSkinMaterial=nil)) then
  begin
    FMaterialName:=Value;


    //如果当前使用的是皮肤包素材名称
    if Self.FMaterialUseKind=mukName then
    begin
      //先清除
      Self.UnUseCurrentUseMaterial;
      //根据素材名称获取当前使用的皮肤素材
      Self.GetCurrentUseMaterial;
    end;

    //如果当前使用的是皮肤包素材名称
    if Self.FMaterialUseKind=mukRefByStyleName then
    begin
      //先清除
      Self.UnUseCurrentUseMaterial;
      //根据素材名称获取当前使用的皮肤素材
      Self.GetCurrentUseMaterial;
    end;



    if not (csReading in Self.ComponentState)
      and not (csLoading in Self.ComponentState) then
    begin
      Self.Invalidate;
    end;

  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.SetMaterialUseKind(const Value: TMaterialUseKind);
begin


  if (FMaterialUseKind<>Value)
    or (FMaterialUseKind=Value) and (FCurrentUseSkinMaterial=nil) then
  begin

    FMaterialUseKind := Value;


//    case FMaterialUseKind of
//      mukSelfOwn:
//      begin
          //自己拥有的
          //先释放
          Self.UnUseCurrentUseMaterial;
  //        //再创建
  //        Self.CreateSelfOwnMaterial;
          //再获取当前使用的
          Self.GetCurrentUseMaterial;
//      end;
//      mukDefault:
//      begin
//          //皮肤包默认的
//          //先释放
//          Self.UnUseCurrentUseMaterial;
//          //再获取当前使用的
//          Self.GetCurrentUseMaterial;
//      end;
//      mukName:
//      begin
//          //皮肤包指定名称
//          //先释放
//          Self.UnUseCurrentUseMaterial;
//          //再获取当前使用的
//          Self.GetCurrentUseMaterial;
//      end;
//      mukRef,mukRefOnly:
//      begin
//          //先释放
//          Self.UnUseCurrentUseMaterial;
//          //再获取当前使用的
//          Self.GetCurrentUseMaterial;
//      end;
//    end;


    if not (csReading in Self.ComponentState)
      and not (csLoading in Self.ComponentState) then
    begin
      Self.Invalidate;
    end;

  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.DoCustomSkinMaterialChange(Sender: TObject);
begin
  //可以在这里调整AutoSize
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.OnSkinMaterialChange(Sender: TObject);
begin
  //在设计时要即时查看效果
  if (not SkinControlInvalidateLocked)
    and not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState)
    or (csDesigning in Self.ComponentState) then
  begin
    DoCustomSkinMaterialChange(Sender);
    Invalidate;
  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.OnSkinMaterialDestroy(Sender: TObject);
begin
  if (Sender=FCurrentUseSkinMaterial) then
  begin
    UnUseCurrentUseMaterial;
  end;
end;








