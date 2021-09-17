//�زķ���ʵ��





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

    //ȥ���ͷ�֪ͨ
    FCurrentUseSkinMaterial.RemoveFreeNotification(Self);

    //ȥ������֪ͨ
    FCurrentUseSkinMaterial.UnRegisterChanges(FMaterialChangeLink);

    FCurrentUseSkinMaterial:=nil;
  end;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.ClearSelfOwnMaterial;
begin
  if (Self.FMaterial<>nil) then
  begin

    //ȥ���ͷ�֪ͨ
    FMaterial.RemoveFreeNotification(Self);

    //ȥ������֪ͨ
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
            //ʹ�����ѵ�Ƥ���ز�
            FCurrentUseSkinMaterial:=Self.FMaterial;
          end;
          mukDefault:
          begin
            //ʹ��Ƥ������Ĭ�Ϸ����ز�
    //        FCurrentUseSkinMaterial:=GetGlobalSkinPackage.FindDefaultMaterial(Self.FProperties.GetComponentClassify,Self.GetCurrentUseComponentTypeName);
          end;
          mukName:
          begin
    //        //Ƥ����ָ�����Ƶ��ز�
    //        if (FMaterialName<>'')
    //          and (GlobalSkinManager<>nil)
    //          and (GlobalSkinManager.CurrentSkinPackage<>nil) then
    //        begin
    //          FCurrentUseSkinMaterial:=GlobalSkinManager.CurrentSkinPackage.FindMaterialByName(Self.FProperties.GetComponentClassify,Self.GetCurrentUseComponentTypeName,Self.FMaterialName);
    //
    //
    //          //�����ͷ�֪ͨ
    //          if FCurrentUseSkinMaterial<>nil then
    //          begin
    ////            uBaseLog.HandleException(nil,'OrangeUI','uSkinPackage','GetCurrentUseMaterial GlobalSkinManager'+' '+IntToStr(Integer(GlobalSkinManager)));
    //            Self.FCurrentUseSkinMaterial.FreeNotification(Self);
    //          end;
    //        end
    ////        else
    ////        begin
    ////          //ʹ��Ƥ������Ĭ�Ϸ����ز�
    ////          FCurrentUseSkinMaterial:=GetGlobalSkinPackage.FindDefaultMaterial(Self.FProperties.GetComponentClassify,Self.GetCurrentUseComponentTypeName);
    ////        end
    //        ;
          end;
          mukRef,mukRefOnly:
          begin
            //ʹ�����õ�Ƥ���ز�
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
          //�������֪ͨ
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
//      //��ȡ�ز���
//      AMaterialClass:=GlobalControlTypeRegManager.FindMaterialClassByComponentTypeName(Self.FProperties.GetComponentClassify,GetCurrentUseComponentTypeName);
//      if (AMaterialClass<>nil) then
//      begin


        if (Value<>nil) then
        begin
          //�ж����Ƿ����
          if (Value.ClassType=GetMaterialClass) then
          begin
            //���,�Ͳ���ʹ�õ�ǰ���ز�
            UnUseCurrentUseMaterial;
          end
          else
          begin
            //�����
            ShowException(Value.Name+'��˿ؼ����ComponentTypeƥ���Material���Ͳ���');
            Exit;
          end;
        end;



        //ɾ���ͷ�֪ͨ
        if FRefMaterial<>nil then
        begin
          Self.FRefMaterial.RemoveFreeNotification(Self);
          //ȥ������֪ͨ
          FRefMaterial.UnRegisterChanges(FMaterialChangeLink);
        end;


        FRefMaterial:=Value;


        //�����ͷ�֪ͨ
        if FRefMaterial<>nil then
        begin
          Self.FRefMaterial.FreeNotification(Self);
        end;


        //����������ʱ,��ôֱ������MaterialUseKind
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


    //�����ǰʹ�õ���Ƥ�����ز�����
    if Self.FMaterialUseKind=mukName then
    begin
      //�����
      Self.UnUseCurrentUseMaterial;
      //�����ز����ƻ�ȡ��ǰʹ�õ�Ƥ���ز�
      Self.GetCurrentUseMaterial;
    end;

    //�����ǰʹ�õ���Ƥ�����ز�����
    if Self.FMaterialUseKind=mukRefByStyleName then
    begin
      //�����
      Self.UnUseCurrentUseMaterial;
      //�����ز����ƻ�ȡ��ǰʹ�õ�Ƥ���ز�
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
          //�Լ�ӵ�е�
          //���ͷ�
          Self.UnUseCurrentUseMaterial;
  //        //�ٴ���
  //        Self.CreateSelfOwnMaterial;
          //�ٻ�ȡ��ǰʹ�õ�
          Self.GetCurrentUseMaterial;
//      end;
//      mukDefault:
//      begin
//          //Ƥ����Ĭ�ϵ�
//          //���ͷ�
//          Self.UnUseCurrentUseMaterial;
//          //�ٻ�ȡ��ǰʹ�õ�
//          Self.GetCurrentUseMaterial;
//      end;
//      mukName:
//      begin
//          //Ƥ����ָ������
//          //���ͷ�
//          Self.UnUseCurrentUseMaterial;
//          //�ٻ�ȡ��ǰʹ�õ�
//          Self.GetCurrentUseMaterial;
//      end;
//      mukRef,mukRefOnly:
//      begin
//          //���ͷ�
//          Self.UnUseCurrentUseMaterial;
//          //�ٻ�ȡ��ǰʹ�õ�
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
  //�������������AutoSize
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.OnSkinMaterialChange(Sender: TObject);
begin
  //�����ʱҪ��ʱ�鿴Ч��
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







