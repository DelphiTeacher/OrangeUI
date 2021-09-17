//素材方法实现



function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetMaterialClass:TMaterialClass;
begin
  Result:=GlobalControlTypeRegManager.FindMaterialClassByControlTypeName(
                      Self.FProperties.GetComponentClassify,
                      GetCurrentUseComponentTypeName);
end;


procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.CreateSelfOwnMaterial;
var
  AMaterialClass:TMaterialClass;
begin
      //创建皮肤素材

      //控件风格和控件分类
      if (Self.FMaterial=nil)
        and (Self.GetCurrentUseComponentTypeName<>'')
        and (Self.FProperties.GetComponentClassify<>'') then
      begin
        //创建一个属于自己的皮肤素材
        AMaterialClass:=GetMaterialClass;//GlobalControlTypeRegManager.FindMaterialClassByControlTypeName(
//                            Self.FProperties.GetComponentClassify,
//                            GetCurrentUseComponentTypeName);
        if (AMaterialClass<>nil) then
        begin
          //创建皮肤素材对象
          Self.FMaterial:=AMaterialClass.Create(Self);
          //设置皮肤素材名
          Self.FMaterial.Name:='Material';
          //设置为子控件
          Self.FMaterial.SetSubComponent(True);
          //设置释放通知
          FMaterial.FreeNotification(Self);
        end;

    end;

end;


function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetSkinControlTypeClass:TControlTypeClass;
begin
  Result:=GlobalControlTypeRegManager.FindControlTypeClassByControlTypeName(
                              Self.FProperties.GetComponentClassify,
                              GetCurrentUseComponentTypeName);
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.CreateSkinControlType;
var
  AControlTypeClass:TControlTypeClass;
begin

    //创建属于自己的控件类型,指定ComponentTypeName
    if (FSkinControlType=nil)
      and (Self.FProperties<>nil)
      and (Self.FProperties.GetComponentClassify<>'')
      and (GetCurrentUseComponentTypeName<>'') then
    begin
        //获取控件类型类
        AControlTypeClass:=GetSkinControlTypeClass;//GlobalControlTypeRegManager.FindControlTypeClassByControlTypeName(
                              //Self.FProperties.GetComponentClassify,
                              //GetCurrentUseComponentTypeName);
        if (AControlTypeClass<>nil) then
        begin

            FSkinControlType:=TSkinControlType(AControlTypeClass.Create(TControl(Self)));
            //将风格的组件设置为自己
//            FSkinControlType.SkinControl:=TControl(Self);
            //判断素材类型是否和风格注册的类型相同
            Self.CheckCurrentUseMaterial;
            Self.CheckSelfOwnMaterial;

        end
        else
        begin
            uBaseLog.OutputDebugString(
                        'Name:'+Name
                        +' ClassName:'+ClassName
                        +' ComponentTypeName:'+ComponentTypeName
                        +' CreateSkinControlType Can Not Find ControlTypeClass');
        end;
    end;

end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.CheckCurrentUseMaterial;
var
  AMaterialClass:TMaterialClass;
begin
    if (Self.FCurrentUseSkinMaterial<>nil)
      and (Self.FProperties.GetComponentClassify<>'')
      and (GetCurrentUseComponentTypeName<>'') then
    begin
        AMaterialClass:=GetMaterialClass;//GlobalControlTypeRegManager.FindMaterialClassByControlTypeName(Self.FProperties.GetComponentClassify,Self.GetCurrentUseComponentTypeName);
        //如果类型不匹配,那么清除皮肤素材
        if (AMaterialClass<>Self.FCurrentUseSkinMaterial.ClassType) then
        begin
          UnUseCurrentUseMaterial;
        end;
    end;
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

    //这里如果没有释放掉,那么IOS下面再次创建将会出现重名的问题
    //重命名一下
    FMaterial.Name:='';
    Self.FMaterial.SetSubComponent(False);
    FreeAndNil(FMaterial);


//    if not (csReading in Self.ComponentState)
//      and not (csLoading in Self.ComponentState) then
//    begin
//      Self.Invalidate;
//    end;


  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.CheckSelfOwnMaterial;
var
  AMaterialClass:TMaterialClass;
begin
    if (Self.FMaterial<>nil)
      and (Self.FProperties.GetComponentClassify<>'')
      and (GetCurrentUseComponentTypeName<>'') then
    begin
        AMaterialClass:=GetMaterialClass;//GlobalControlTypeRegManager.FindMaterialClassByControlTypeName(Self.FProperties.GetComponentClassify,Self.GetCurrentUseComponentTypeName);
        //如果类型不匹配,那么清除皮肤素材
        if (AMaterialClass<>Self.FMaterial.ClassType) then
        begin
          ClearSelfOwnMaterial;
        end;
    end;
end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetCurrentUseMaterial: TSkinControlMaterial;
var
  AControlTypeName:String;
begin
  if FCurrentUseSkinMaterial=nil then
  begin
        case Self.FMaterialUseKind of
          mukSelfOwn:
          begin
            //使用自已的皮肤素材
            FCurrentUseSkinMaterial:=Self.SelfOwnMaterial;
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
              //根据StyleName从GlobalMaterialStyleList中找到合适的素材
              if (FMaterialName<>'') then
              begin
                  FCurrentUseSkinMaterial:=FindGlobalMaterialByStyleName(
                                                            Self.FProperties.GetComponentClassify,
                                                            FMaterialName,
                                                            AControlTypeName
                                                            );
              end
              else
              begin
                  FCurrentUseSkinMaterial:=FindGlobalMaterialByStyleName(
                                                            Self.FProperties.GetComponentClassify,
                                                            'Default',
                                                            AControlTypeName
                                                            );
                  if FCurrentUseSkinMaterial<>nil then
                  begin
                    //避免重复创建,因为FMaterialName=''时,当赋Default给它是会重建
                    FMaterialName:='Default';
                  end;
              end;

              if FCurrentUseSkinMaterial=nil then
              begin
                uBaseLog.OutputDebugString('Name:'+Name
                                          +' ClassName:'+ClassName
                                          +' GetCurrentUseMaterial Can Not Find Material By StyleName '+FMaterialName
                                          );
              end;
              ComponentTypeName:=AControlTypeName;
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

//function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetStaticCurrentUseMaterial: TSkinControlMaterial;
//begin
//  Result:=Self.FCurrentUseSkinMaterial;
//end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetCurrentUseComponentTypeName: String;
begin
  Result:=FComponentTypeName;
  if Trim(FComponentTypeName)='' then
  begin
    Result:=Const_Default_ComponentType;
  end;
  
//  case FComponentTypeUseKind of
//    ctukName:
//    begin
//      Result:=FComponentTypeName;
//    end;
//    ctukDefault:
//    begin
//      //获取默认的控件类型名称
//      Result:=GlobalControlTypeRegManager.FindDefaultControlTypeName(
//                Self.FProperties.GetComponentClassify);
//    end;
//  end;
end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetSelfOwnMaterial:TSkinControlMaterial;
begin
  if (FMaterial=nil)
    and (
        FKeepSelfOwnMaterial
        or (Not FKeepSelfOwnMaterial) and (FMaterialUseKind=mukSelfOwn)
        ) then
  begin
    Self.CreateSelfOwnMaterial;
  end;
  Result:=FMaterial;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.SetKeepSelfOwnMaterial(const Value:Boolean);
begin
  if FKeepSelfOwnMaterial<>Value then
  begin
    if Not Value then
    begin
      //不保存自已的素材
      if (FMaterialUseKind<>mukSelfOwn) then
      begin
        ClearSelfOwnMaterial;
      end;
    end;
    FKeepSelfOwnMaterial:=Value;
  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.AssignMaterial(
ASrcControlIntf:ISkinControlMaterial);
begin
//  Self.SetComponentTypeUseKind(ASrcControlIntf.GetComponentTypeUseKind);
  Self.SetComponentTypeName(ASrcControlIntf.GetComponentTypeName);

  Self.SetMaterialUseKind(ASrcControlIntf.GetMaterialUseKind);
  Self.SetMaterialName(ASrcControlIntf.GetMaterialName);

  Self.SetRefMaterial(ASrcControlIntf.GetRefMaterial);
  Self.SetKeepSelfOwnMaterial(ASrcControlIntf.GetKeepSelfOwnMaterial);

  if (Self.SelfOwnMaterial<>nil) and (ASrcControlIntf.GetSelfOwnMaterial<>nil) then
  begin
    Self.SelfOwnMaterial.Assign(ASrcControlIntf.GetSelfOwnMaterial);
  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.SetRefMaterial(Value:TSkinControlMaterial);
var
  AMaterialClass:TMaterialClass;
begin
  if FRefMaterial<>Value then
  begin

    if (Self.GetCurrentUseComponentTypeName<>'') and (Self.FProperties.GetComponentClassify<>'') then
    begin
      //获取素材类
      AMaterialClass:=GetMaterialClass;//GlobalControlTypeRegManager.FindMaterialClassByControlTypeName(Self.FProperties.GetComponentClassify,GetCurrentUseComponentTypeName);
      if (AMaterialClass<>nil) then
      begin


        if (Value<>nil) then
        begin
          //判断类是否符合
          if (Value.ClassType=AMaterialClass) then
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



      end;
    end;

  end;
end;

//function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetSkinComponentType:TSkinControlType;
//begin
//  if FSkinControlType=nil then
//  begin
//    Self.CreateSkinControlType;
//  end;
//  Result:=FSkinControlType;
//end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetSkinControlType:TSkinControlType;
begin
  if FSkinControlType=nil then
  begin
    Self.CreateSkinControlType;
  end;
  if FSkinControlType<>nil then
  begin
    Result:=FSkinControlType;
  end
  else
  begin
//    uBaseLog.OutputDebugString('Name:'+Name
//                +' ClassName:'+ClassName
//                +' ComponentTypeName:'+ComponentTypeName
//                +' GetSkinControlType is nil');
    Result:=nil;
  end;
end;


function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetRefMaterial:TSkinControlMaterial;
begin
  Result:=FRefMaterial;
end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetMaterialUseKind: TMaterialUseKind;
begin
  Result:=FMaterialUseKind;
end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetKeepSelfOwnMaterial:Boolean;
begin
  Result:=FKeepSelfOwnMaterial;
end;

//function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetComponentTypeUseKind: TComponentTypeUseKind;
//begin
//  Result:=FComponentTypeUseKind;
//end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetComponentTypeName: String;
begin
  Result:=FComponentTypeName;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.SetComponentTypeName(const Value: String);
var
  AControlTypeClass:TControlTypeClass;
begin

  if FComponentTypeName<>Value then
  begin
    //设置名称
    FComponentTypeName:=Value;
  end;

  //如果当前使用的是组件类型名称
//  if Self.FComponentTypeUseKind=ctukName then
//  begin
    if FSkinControlType<>nil then
    begin
          AControlTypeClass:=GetSkinControlTypeClass;
            //GlobalControlTypeRegManager.FindControlTypeClassByControlTypeName(
                //Self.FProperties.GetComponentClassify,
                //GetCurrentUseComponentTypeName);
          if AControlTypeClass<>nil then
          begin
              if (AControlTypeClass<>FSkinControlType.ClassType) then
              begin
                  //先释放
                  FreeAndNil(FSkinControlType);
                  //自动创建
                  //自动创建
                  CreateSkinControlType;
              end
              else
              begin
                  //相同,则不处理
              end;
          end
          else
          begin
              uBaseLog.OutputDebugString(
                          'Name:'+Name
                          +' ClassName:'+ClassName
                          +' SetComponentTypeName AControlTypeClass Is Nil '
                          );
          end;
    end
    else
    begin
          //自动创建
          //要自动创建,不然SelfOwnMaterial会报错
          //比如原来ComponentTypeName为空表示Default
          //后面改为了Color,但是SelfOwnMaterial还是DefaultMaterial类型，而不是ColorMaterial类型，
          //导致属性读取错误
          CreateSkinControlType;
    end;
//  end;
end;

//procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.SetComponentTypeUseKind(const Value: TComponentTypeUseKind);
//var
//  AControlTypeClass:TControlTypeClass;
//begin
//  if (FComponentTypeUseKind<>Value)
//   or ((FComponentTypeUseKind=Value) and (FSkinControlType=nil)) then
//  begin
//    FComponentTypeUseKind:=Value;
//    case FComponentTypeUseKind of
//      ctukName:
//      begin
//        //创建指定名称的控件类型
//        SetComponentTypeName(FComponentTypeName);
//      end;
//      ctukDefault:
//      begin
//        //如果之前不使用默认风格
//        //那么判断之前使用的默认风格是否是默认的风格
//        //如果风格不相同,那么清除,否则保留
//        AControlTypeClass:=GlobalControlTypeRegManager.FindControlTypeClassByControlTypeName(Self.FProperties.GetComponentClassify,GetCurrentUseComponentTypeName);
//        if (FSkinControlType<>nil) then
//        begin
//          if (AControlTypeClass<>FSkinControlType.ClassType) then
//          begin
//            //先释放
//            FreeAndNil(FSkinControlType);
//            //自动创建
//            CreateSkinControlType;
//          end
//          else
//          begin
//            //相同,则不处理
//          end;
//        end
//        else
//        begin
//          //为空,则创建
//          CreateSkinControlType;
//        end;
//      end;
//    end;
//  end;
//end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetMaterialName: String;
begin
  Result:=FMaterialName;
end;

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

procedure  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.NilSelfOwnMaterial;
begin
  FMaterial:=nil;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.SetMaterialUseKind(const Value: TMaterialUseKind);
begin

  if (FMaterialUseKind<>Value) and (Not FKeepSelfOwnMaterial) then
  begin
      //不保存自已的素材
      if (Value<>mukSelfOwn) then
      begin
        ClearSelfOwnMaterial;
      end;
  end;


  if (FMaterialUseKind<>Value)
    or (FMaterialUseKind=Value) and (FCurrentUseSkinMaterial=nil) then
  begin
      FMaterialUseKind := Value;
      case FMaterialUseKind of
        mukSelfOwn:
        begin
            //自己拥有的
            //先释放
            Self.UnUseCurrentUseMaterial;
            //再创建
            Self.CreateSelfOwnMaterial;
            //再获取当前使用的
            Self.GetCurrentUseMaterial;
        end;
        mukDefault:
        begin
            //皮肤包默认的
            //先释放
            Self.UnUseCurrentUseMaterial;
            //再获取当前使用的
            Self.GetCurrentUseMaterial;
        end;
        mukName:
        begin
            //皮肤包指定名称
            //先释放
            Self.UnUseCurrentUseMaterial;
            //再获取当前使用的
            Self.GetCurrentUseMaterial;
        end;
        mukRef,mukRefOnly:
        begin
            //皮肤包指定名称
            //先释放
            Self.UnUseCurrentUseMaterial;
            //再获取当前使用的
            Self.GetCurrentUseMaterial;
        end;
        mukRefByStyleName:
        begin
            //皮肤包指定名称
            //先释放
            Self.UnUseCurrentUseMaterial;
            //再获取当前使用的
            Self.GetCurrentUseMaterial;
        end;
      end;


      if not (csReading in Self.ComponentState)
        and not (csLoading in Self.ComponentState) then
      begin
        Self.Invalidate;
      end;

  end;
end;

////通知
//procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.Notification(AComponent:TComponent;Operation:TOperation);
//begin
//  inherited Notification(AComponent,Operation);
//end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.DoCustomSkinMaterialChange(Sender: TObject);
begin
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.OnSkinMaterialChange(Sender: TObject);
begin
  //在设计时要即时查看效果
  if (SkinControlInvalidateLocked=0)
    and not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState)
    //在设计时要即时查看效果,但是会闪的厉害
    or (csDesigning in Self.ComponentState)
    then
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













//
//function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.Get_Author: String;
//begin
//  Result:=OrangeUIControl_Author;//TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_Author')).ConvertNode_WideString.Data;
//end;
//
//function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.Get_AuthorQQ: String;
//begin
//  Result:=OrangeUIControl_AuthorQQ;//TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_Author')).ConvertNode_WideString.Data;
//end;
//
//function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.Get_AuthorEmail: String;
//begin
//  Result:=OrangeUIControl_AuthorEmail;//TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_Author')).ConvertNode_WideString.Data;
//end;
//
//function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.Get_AuthorMobile: String;
//begin
//  Result:=OrangeUIControl_AuthorMobile;//TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_Author')).ConvertNode_WideString.Data;
//end;
//
////function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.Get_ChargeType: String;
////begin
////  //是否是收费情况
////  if FIsFreeControl then
////  begin
////    Result:='免费控件';
////  end
////  else
////  begin
////    Result:='付费控件';
////  end;
////end;
////
////function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.IsFreeControl: Boolean;
////begin
////  //是否是收费情况
////  Result:=FIsFreeControl;
////end;
//
////{$IFNDEF FREE}
////function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.Get_LicensedTo: String;
////begin
////  Result:=TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_LicensedTo')).ConvertNode_WideString.Data;
//////  Result:=TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_VersionType')).ConvertNode_WideString.Data;
////end;
////{$ENDIF}

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.Get_Version: String;
begin
  Result:=OrangeUIControl_Version;
end;


function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.CreateOwnDataObject(AClass: TClass): TObject;
begin
  if FIsOwnDataObject and (FDataObject<>nil) then
  begin
    FreeAndNil(Self.FDataObject);
  end;

  FIsOwnDataObject:=True;

  Self.FDataObject:=AClass.Create;
  Result:=FDataObject;
end;

