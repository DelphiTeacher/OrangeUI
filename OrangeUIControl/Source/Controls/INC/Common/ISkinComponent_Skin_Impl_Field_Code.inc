//�زķ���ʵ��



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
      //����Ƥ���ز�

      //�ؼ����Ϳؼ�����
      if (Self.FMaterial=nil)
        and (Self.GetCurrentUseComponentTypeName<>'')
        and (Self.FProperties.GetComponentClassify<>'') then
      begin
        //����һ�������Լ���Ƥ���ز�
        AMaterialClass:=GetMaterialClass;//GlobalControlTypeRegManager.FindMaterialClassByControlTypeName(
//                            Self.FProperties.GetComponentClassify,
//                            GetCurrentUseComponentTypeName);
        if (AMaterialClass<>nil) then
        begin
          //����Ƥ���زĶ���
          Self.FMaterial:=AMaterialClass.Create(Self);
          //����Ƥ���ز���
          Self.FMaterial.Name:='Material';
          //����Ϊ�ӿؼ�
          Self.FMaterial.SetSubComponent(True);
          //�����ͷ�֪ͨ
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

    //���������Լ��Ŀؼ�����,ָ��ComponentTypeName
    if (FSkinControlType=nil)
      and (Self.FProperties<>nil)
      and (Self.FProperties.GetComponentClassify<>'')
      and (GetCurrentUseComponentTypeName<>'') then
    begin
        //��ȡ�ؼ�������
        AControlTypeClass:=GetSkinControlTypeClass;//GlobalControlTypeRegManager.FindControlTypeClassByControlTypeName(
                              //Self.FProperties.GetComponentClassify,
                              //GetCurrentUseComponentTypeName);
        if (AControlTypeClass<>nil) then
        begin

            FSkinControlType:=TSkinControlType(AControlTypeClass.Create(TControl(Self)));
            //�������������Ϊ�Լ�
//            FSkinControlType.SkinControl:=TControl(Self);
            //�ж��ز������Ƿ�ͷ��ע���������ͬ
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
        //������Ͳ�ƥ��,��ô���Ƥ���ز�
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

    //�������û���ͷŵ�,��ôIOS�����ٴδ��������������������
    //������һ��
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
        //������Ͳ�ƥ��,��ô���Ƥ���ز�
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
            //ʹ�����ѵ�Ƥ���ز�
            FCurrentUseSkinMaterial:=Self.SelfOwnMaterial;
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
              //����StyleName��GlobalMaterialStyleList���ҵ����ʵ��ز�
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
                    //�����ظ�����,��ΪFMaterialName=''ʱ,����Default�����ǻ��ؽ�
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
      //�������֪ͨ
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
//      //��ȡĬ�ϵĿؼ���������
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
      //���������ѵ��ز�
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
      //��ȡ�ز���
      AMaterialClass:=GetMaterialClass;//GlobalControlTypeRegManager.FindMaterialClassByControlTypeName(Self.FProperties.GetComponentClassify,GetCurrentUseComponentTypeName);
      if (AMaterialClass<>nil) then
      begin


        if (Value<>nil) then
        begin
          //�ж����Ƿ����
          if (Value.ClassType=AMaterialClass) then
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
    //��������
    FComponentTypeName:=Value;
  end;

  //�����ǰʹ�õ��������������
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
                  //���ͷ�
                  FreeAndNil(FSkinControlType);
                  //�Զ�����
                  //�Զ�����
                  CreateSkinControlType;
              end
              else
              begin
                  //��ͬ,�򲻴���
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
          //�Զ�����
          //Ҫ�Զ�����,��ȻSelfOwnMaterial�ᱨ��
          //����ԭ��ComponentTypeNameΪ�ձ�ʾDefault
          //�����Ϊ��Color,����SelfOwnMaterial����DefaultMaterial���ͣ�������ColorMaterial���ͣ�
          //�������Զ�ȡ����
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
//        //����ָ�����ƵĿؼ�����
//        SetComponentTypeName(FComponentTypeName);
//      end;
//      ctukDefault:
//      begin
//        //���֮ǰ��ʹ��Ĭ�Ϸ��
//        //��ô�ж�֮ǰʹ�õ�Ĭ�Ϸ���Ƿ���Ĭ�ϵķ��
//        //��������ͬ,��ô���,������
//        AControlTypeClass:=GlobalControlTypeRegManager.FindControlTypeClassByControlTypeName(Self.FProperties.GetComponentClassify,GetCurrentUseComponentTypeName);
//        if (FSkinControlType<>nil) then
//        begin
//          if (AControlTypeClass<>FSkinControlType.ClassType) then
//          begin
//            //���ͷ�
//            FreeAndNil(FSkinControlType);
//            //�Զ�����
//            CreateSkinControlType;
//          end
//          else
//          begin
//            //��ͬ,�򲻴���
//          end;
//        end
//        else
//        begin
//          //Ϊ��,�򴴽�
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

procedure  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.NilSelfOwnMaterial;
begin
  FMaterial:=nil;
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.SetMaterialUseKind(const Value: TMaterialUseKind);
begin

  if (FMaterialUseKind<>Value) and (Not FKeepSelfOwnMaterial) then
  begin
      //���������ѵ��ز�
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
            //�Լ�ӵ�е�
            //���ͷ�
            Self.UnUseCurrentUseMaterial;
            //�ٴ���
            Self.CreateSelfOwnMaterial;
            //�ٻ�ȡ��ǰʹ�õ�
            Self.GetCurrentUseMaterial;
        end;
        mukDefault:
        begin
            //Ƥ����Ĭ�ϵ�
            //���ͷ�
            Self.UnUseCurrentUseMaterial;
            //�ٻ�ȡ��ǰʹ�õ�
            Self.GetCurrentUseMaterial;
        end;
        mukName:
        begin
            //Ƥ����ָ������
            //���ͷ�
            Self.UnUseCurrentUseMaterial;
            //�ٻ�ȡ��ǰʹ�õ�
            Self.GetCurrentUseMaterial;
        end;
        mukRef,mukRefOnly:
        begin
            //Ƥ����ָ������
            //���ͷ�
            Self.UnUseCurrentUseMaterial;
            //�ٻ�ȡ��ǰʹ�õ�
            Self.GetCurrentUseMaterial;
        end;
        mukRefByStyleName:
        begin
            //Ƥ����ָ������
            //���ͷ�
            Self.UnUseCurrentUseMaterial;
            //�ٻ�ȡ��ǰʹ�õ�
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

////֪ͨ
//procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.Notification(AComponent:TComponent;Operation:TOperation);
//begin
//  inherited Notification(AComponent,Operation);
//end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.DoCustomSkinMaterialChange(Sender: TObject);
begin
end;

procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.OnSkinMaterialChange(Sender: TObject);
begin
  //�����ʱҪ��ʱ�鿴Ч��
  if (SkinControlInvalidateLocked=0)
    and not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState)
    //�����ʱҪ��ʱ�鿴Ч��,���ǻ���������
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
////  //�Ƿ����շ����
////  if FIsFreeControl then
////  begin
////    Result:='��ѿؼ�';
////  end
////  else
////  begin
////    Result:='���ѿؼ�';
////  end;
////end;
////
////function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.IsFreeControl: Boolean;
////begin
////  //�Ƿ����շ����
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
