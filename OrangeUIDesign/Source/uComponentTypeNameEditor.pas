//convert pas to utf8 by ¥

unit uComponentTypeNameEditor;

interface
 {$I FrameWork.inc}
 {$I Version.inc}

uses
  Classes,
  Math,
  SysConst,

  {$IFDEF FMX}
  uSkinFireMonkeyControl,
  uSkinFireMonkeyEdit,
  uSkinFireMonkeyMemo,
  uSkinFireMonkeyComboBox,
  uSkinFireMonkeyComboEdit,
  uSkinFireMonkeyDateEdit,
  uSkinFireMonkeyPopup,
  FMX.Dialogs,
//  VCLEditors,
  FMX.Forms,
  FMX.Menus,
  FMX.Controls,
//  VCL.Menus,
//  Vcl.Graphics,
//  Vcl.Imaging.JPEG,
  uSkinCommonFrames,
  {$ENDIF}
  {$IFDEF VCL}
  Graphics,
  Dialogs,
  Menus,
  Controls,
  uSkinWindowsControl,
  uSkinWindowsEdit,
  uSkinWindowsMemo,
  uSkinWindowsForm,
  {$ENDIF}
  uBasePageStructure,
  uBasePageStructureControls,

  {$IFDEF MY_PROGRAM_DESIGNER}
  uPageStructure,
  {$ENDIF MY_PROGRAM_DESIGNER}

  TypInfo,
  SysUtils,


  uLang,
  uSkinItemDesignerPanelType,
  uSkinMultiColorLabelType,
  uSkinVirtualListType,
  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  uSkinVirtualGridType,
  uSkinItemGridType,
  {$ENDIF}
  uSkinItems,

  {$IFDEF SKIN_SUPEROBJECT}
  uSkinSuperObject,
  uSkinSuperJson,
  {$ELSE}
  XSuperObject,
    {$IF CompilerVersion >= 30.0}
    XSuperJson,
    {$IFEND}
  {$ENDIF}

//  XSuperObject,
//  {$IF CompilerVersion >= 30.0}
//  XSuperJson,
//  {$IFEND}
//  uDataSetToJson,

  uSkinRegManager,
  uLanguage,
  uSkinMaterial,
  uComponentType,
  Types,



//  Windows,
  uBaseLog,
//  CommCtrl,
  DesignIntf,
  DesignMenus,
  DesignEditors,

  uFuncCommon
  ;


type
  //控件类型属性编辑器,取出该控件所支持的所有类型,
  //比如Default,Color等
  TComponentTypeNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;



  //BindItemFieldName属性编辑器,
  //用于选择Json的key,或者ItemCaption,ItemDetail,ItemIcon等
  TBindItemFieldNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;


  //BindItemFieldName属性编辑器,
  //用于选择Json的key,或者ItemCaption,ItemDetail,ItemIcon等
  TMultiColorLabelNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;


  TItemGridBindItemFieldNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;


//  //素材名称属性编辑器,用于从皮肤包中选择皮肤
//  TMaterialNameProperty = class(TStringProperty)
//  public
//    function GetAttributes: TPropertyAttributes; override;
//    procedure GetValues(Proc: TGetStrProc); override;
//  end;


  //引用素材属性编辑器,用于选择公共素材
  TRefMaterialProperty = class(TComponentProperty)
  private
    procedure AddTempString(const S: string);
  public
    FTempStrings:TStringList;
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;



  //皮肤控件组件编辑器,
  //使用RefMaterial模式、保存RefMaterial到SelfOwnMaterial、绑定列表项
  TSkinControlComponentEditor=class(TDefaultEditor)
  public
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
    procedure PrepareItem(Index: Integer; const AItem: IMenuItem); override;
    procedure DoBindItemAs(Sender:TObject);
  end;


  TMessageBoxSelectionEditor = class(TSelectionEditor)
  public
    procedure RequiresUnits(Proc: TGetStrProc); override;
  end;

  TTimerTaskEventSelectionEditor = class(TSelectionEditor)
  public
    procedure RequiresUnits(Proc: TGetStrProc); override;
  end;



procedure Register;


//共享素材,将素材独立成组件,供其他控件共同使用
procedure UseRefMaterialMode(Component:TComponent;Designer:IDesigner);
//保存RefMaterial到SelfOwnMateirl
procedure SaveRefMaterialToSelfOwnMaterial(Component:TComponent;
                                            Designer:IDesigner);
////编辑皮肤包中的素材(不保存SelfOwnMaterial)
//procedure OpenSkinPackageMaterialEditor(ASkinPackage:TSkinPackage;
//                                        Component:TComponent;
//                                        Designer:IDesigner);
////保存SelfOwnMaterial到皮肤包
//procedure SaveSelfOwnMaterialToSkinPackage(ASkinPackage:TSkinPackage;
//                                            Component:TComponent;
//                                            Designer:IDesigner);
////保存皮肤包Material到SelfOwnMateirl
//procedure SaveSkinPackageMaterialToSelfOwnMaterial(ASkinPackage:TSkinPackage;
//                                                    Component:TComponent;
//                                                    Designer:IDesigner);


//给属性添加可以选择的控件列表
procedure AddPropertySelectValue(AParentControlIntf: ISkinControl;
                                  const IID: TGUID;
                                  out Obj;
                                  Proc: TGetStrProc);

procedure GetParentItemDesignerPanelKeys(AItemDesignerPanel:TSkinItemDesignerPanel;Proc: TGetStrProc);


implementation

{$R OrangeUI.dcr}







//注册属性编辑器
procedure RegisterPropertyEditors(PropertyType: PTypeInfo;
                                  ComponentClasses: Array of TComponentClass;
                                  const PropertyName: string;
                                  EditorClass: TPropertyEditorClass);
var
  I: Integer;
begin
  for I := Low(ComponentClasses) to High(ComponentClasses) do
  begin
    if ComponentClasses[I]<>nil then
    begin
      RegisterPropertyEditorProc(PropertyType, ComponentClasses[I], PropertyName,EditorClass);
    end;
  end;
end;

//注册组件编辑器
procedure RegisterComponentEditors(ComponentClasses:array of TComponentClass;
                                    ComponentEditor: TComponentEditorClass);
var
  I: Integer;
begin
  for I := Low(ComponentClasses) to High(ComponentClasses) do
  begin
    if ComponentClasses[I]<>nil then
    begin
      RegisterComponentEditor(ComponentClasses[I], ComponentEditor);
    end;
  end;
end;



procedure Register;
var
  ComponentClasses: Array of TComponentClass;
begin

  {$IFDEF FMX}
  ComponentClasses:=[TSkinFireMonkeyControl,
                     TSkinFMXEdit,
                     TSkinFMXMemo,
                     TSkinFMXComboBox,
                     TSkinFMXComboEdit,
                     TSkinFMXDateEdit,
                     TSkinFMXPopup,
                     nil];
  {$ENDIF}

  {$IFDEF VCL}
    {$IF CompilerVersion >= 30.0}
    ComponentClasses:=[TSkinWindowsControl,
                        TSkinWinEdit,
                        TSkinWinMemo,
                        TSkinWinForm,
                        nil];
    {$ELSE}
    SetLength(ComponentClasses,4);
    ComponentClasses[0]:=TSkinWindowsControl;
    ComponentClasses[1]:=TSkinWinEdit;
    ComponentClasses[2]:=TSkinWinMemo;
    ComponentClasses[3]:=TSkinWinForm;
    {$IFEND}
    RegisterComponents('OrangeUIConrol',[TPageCheckBox,TPageComboBox,TPageEdit,TPageMemo]);
  {$ENDIF}




  //ComponentTypeName属性编辑器
  RegisterPropertyEditors(TypeInfo(String),
                          ComponentClasses,
                          'ComponentTypeName',
                          TComponentTypeNameProperty);

  //BindItemFieldName属性编辑器
  RegisterPropertyEditors(TypeInfo(String),
                          ComponentClasses,
                          'BindItemFieldName',
                          TBindItemFieldNameProperty);


  //BindItemFieldName属性编辑器
  RegisterPropertyEditor(TypeInfo(String),
                          TColorTextItem,
                          'Name',
                          TMultiColorLabelNameProperty);
  {$IFDEF OPENSOURCE_VERSION}
  //开源版没有ListView,TreeView,Grid
  {$ELSE}
  RegisterPropertyEditor(TypeInfo(String),
                          TSkinItemGridColumn,
                          'BindItemFieldName',
                          TItemGridBindItemFieldNameProperty);
  RegisterPropertyEditor(TypeInfo(String),
                          TSkinItemGridColumn,
                          'BindItemFieldName1',
                          TItemGridBindItemFieldNameProperty);
  {$ENDIF}



//  //MaterialName属性编辑器
//  RegisterPropertyEditors(TypeInfo(String),
//                          ComponentClasses,
//                          'MaterialName',TMaterialNameProperty);

  //RefMaterial属性编辑器
  RegisterPropertyEditors(TypeInfo(TSkinControlMaterial),
                          ComponentClasses,
                          'RefMaterial',
                          TRefMaterialProperty);


  //组件编辑器
  RegisterComponentEditors(ComponentClasses,
                          TSkinControlComponentEditor);


  {$IFDEF FMX}
  RegisterSelectionEditor(TSkinMessageBox,TMessageBoxSelectionEditor);
  {$ENDIF FMX}

end;

////截屏
//function ScreenCap:Vcl.Graphics.TBitmap;
//var
//  iTempWnd,iDC:LongWord;
//  tyRect:TRect;
//  iWidth, iHeight:integer;
//begin
//  iTempWnd:=GetDesktopWindow();
//  iDC:=GetDC(iTempWnd);
//  Result:=Vcl.Graphics.TBitmap.Create;
//  try
//    try
//      GetWindowRect(iTempWnd, tyRect);
//    　iWidth:=tyRect.Right-tyRect.Left;
//    　iHeight:=tyRect.Bottom-tyRect.Top;
//      Result.SetSize(iWidth,iHeight);
//      Bitblt(Result.Canvas.Handle,
//              0, 0, iWidth, iHeight,
//              iDC, tyRect.Left, tyRect.Top,
//              SRCCOPY);
//    except
//      on E:Exception do
//      begin
//        uBaseLog.HandleException(E,'ScreenCap');
//      end;
//    end;
//  finally
//    ReleaseDC(iTempWnd, iDC);
//  end;
//end;
//
//function GetMyStream:TStream;
//var
//  AScreenshot:TBitmap;
//  AJpegImage:TJpegImage;
//begin
//
//  Result:=TMemoryStream.Create;
//
//  AScreenshot:=ScreenCap;
//  AJpegImage:=TJpegImage.Create;
//  try
//    try
//      AJpegImage.Assign(AScreenshot);
//      AJpegImage.CompressionQuality:=30;
//      AJpegImage.SaveToStream(Result);
//    except
//      on E:Exception do
//      begin
//        HandleException(E,'Synchronize');
//      end;
//    end;
//  finally
//    FreeAndNil(AJpegImage);
//    FreeAndNil(AScreenshot);
//  end;
//
//end;

procedure AddPropertySelectValue(AParentControlIntf: ISkinControl;const IID: TGUID; out Obj;Proc: TGetStrProc);
var
  I:Integer;
  ASkinSubControlIntf:ISkinControl;
begin
  for I := 0 to AParentControlIntf.GetChildControlCount-1 do
  begin
    if AParentControlIntf.GetChildControl(I).GetInterface(IID,Obj) then
    begin
      if AParentControlIntf.GetChildControl(I).Name<>'' then
      begin
        Proc(AParentControlIntf.GetChildControl(I).Name);
      end;
    end;
    if AParentControlIntf.GetChildControl(I).GetInterface(IID_ISkinControl,ASkinSubControlIntf) then
    begin
      AddPropertySelectValue(ASkinSubControlIntf,IID,obj,Proc);
    end;
  end;
end;


{$IF CompilerVersion >= 30.0}
function GetJsonCount(AJson:ISuperObject;AFieldList:TStringList;
                            ANoAddName:String):Integer;
CONST
  NOPOST='NoPost_';



var
  ASuperEnumerator:TSuperEnumerator<IJSONPair>;

begin
  Result:=0;
  ASuperEnumerator:=AJson.GetEnumerator;


      while ASuperEnumerator.MoveNext do
      begin
        if Not SameText(
              Copy(ASuperEnumerator.GetCurrent.Name,1,Length(NOPOST)),
              NOPOST)
            and (
                  (AFieldList=nil)
                or (AFieldList<>nil) and (AFieldList.IndexOf(ASuperEnumerator.GetCurrent.Name)<>-1)
                )

           and ((ANoAddName='') or (ANoAddName<>ASuperEnumerator.GetCurrent.Name)) then
        begin
          Inc(Result);
        end;
      end;


end;


function GetJsonNameArray(AJson:ISuperObject;AFieldList:TStringList):TStringDynArray;
CONST
  NOPOST='NoPost_';
var
  I:Integer;

  ASuperEnumerator:TSuperEnumerator<IJSONPair>;

begin

  SetLength(Result,GetJsonCount(AJson,nil,''));

  //遍历所有key
  I:=0;
  ASuperEnumerator:=AJson.GetEnumerator;



      while ASuperEnumerator.MoveNext do
      begin
        if Not SameText(
              Copy(ASuperEnumerator.GetCurrent.Name,1,Length(NOPOST)),
              NOPOST)
            and (
                  (AFieldList=nil)
                or (AFieldList<>nil) and (AFieldList.IndexOf(ASuperEnumerator.GetCurrent.Name)<>-1)
                ) then
        begin
          Result[I]:=ASuperEnumerator.GetCurrent.Name;

          Inc(I);
        end;
      end;



end;
{$IFEND}


procedure GetParentItemDesignerPanelKeys(AItemDesignerPanel:TSkinItemDesignerPanel;Proc: TGetStrProc);
var
  I: Integer;
  ASuperObject:ISuperObject;
  AJsonNames:TStringDynArray;
begin
  if (AItemDesignerPanel<>nil) and (AItemDesignerPanel.Prop.PreviewItem.JsonStr<>'') then
  begin

      {$IF CompilerVersion >= 30.0}
      //如果有Json,那么键值全部从Json中取,一般用于TJsonSkinItem
      ASuperObject:=TSuperObject.Create(AItemDesignerPanel.Prop.PreviewItem.JsonStr);

      //取出所有键值
      AJsonNames:=GetJsonNameArray(ASuperObject,nil);
      for I := 0 to Length(AJsonNames)-1 do
      begin
        Proc(AJsonNames[I]);
      end;
      {$IFEND}

  end
  else
  begin
      //一般用于TRealSkinItem
      Proc('ItemCaption');
      Proc('ItemDetail');
      Proc('ItemDetail1');
      Proc('ItemDetail2');
      Proc('ItemDetail3');
      Proc('ItemDetail4');
      Proc('ItemDetail5');
      Proc('ItemDetail6');
      Proc('ItemIndex');
      Proc('ItemSubItems0');
      Proc('ItemSubItems1');
      Proc('ItemSubItems2');
      Proc('ItemSubItems3');
  end;


  //公共的
  Proc('ItemChecked');
  Proc('ItemSelected');
  Proc('ItemIcon');
  Proc('ItemPic');
  Proc('ItemTag');
  Proc('ItemTag1');
  Proc('ItemExpanded');

  //表格才能使用
  Proc('GridCellValue');
  Proc('GridCellValue1');

end;


//procedure OpenSkinPackageMaterialEditor(ASkinPackage:TSkinPackage;
//                                        Component:TComponent;
//                                        Designer:IDesigner);
//var
//  ASkinControlIntf:ISkinControl;
//  ASkinControlMaterialIntf:ISkinControlMaterial;
//begin
//  Exit;
//
//  //获取当前使用的Material,是否在皮肤包中
//  if Component.GetInterface(IID_ISkinControl,ASkinControlIntf)
//    and Component.GetInterface(IID_ISkinControlMaterial,ASkinControlMaterialIntf)
//    and (ASkinPackage<>nil)
//    and (ASkinControlMaterialIntf.GetMaterialUseKind=TMaterialUseKind.mukName)
//      and ((ASkinControlMaterialIntf.GetMaterialName<>''))
//    then
//  begin
//
//        {$IFDEF FMX}
//        //弹出皮肤编辑器
//        if frmSkinPackageEditor=nil then
//        begin
//          frmSkinPackageEditor:=TfrmSkinPackageEditor.Create(Application);
//        end;
//        frmSkinPackageEditor.LoadSkinPackage(Designer,ASkinPackage);
//        frmSkinPackageEditor.EditMaterial(
//              ASkinControlIntf.Properties.GetComponentClassify,
//              ASkinControlMaterialIntf.GetCurrentUseComponentTypeName,
//              ASkinControlMaterialIntf.GetMaterialName);
//        frmSkinPackageEditor.Show;
//        {$ENDIF}
//
//  end
//  else
//  begin
//
//      if (ASkinControlMaterialIntf.GetMaterialUseKind<>TMaterialUseKind.mukName) then
//      begin
//        ShowMessage(Langs_MaterialUseKindNotIsmukName[LangKind]);
//      end;
//
//      if (ASkinControlMaterialIntf.GetMaterialName='') then
//      begin
//        ShowMessage(Langs_MaterialNameIsEmpty[LangKind]);
//      end;
//
//
//      if (ASkinPackage=nil) then
//      begin
//        ShowMessage(Langs_SkinPackageIsEmpty[LangKind]);
//      end;
//
//  end;
//
//end;
//
//
//procedure SaveSelfOwnMaterialToSkinPackage(ASkinPackage:TSkinPackage;
//                                        Component:TComponent;
//                                        Designer:IDesigner);
//var
//  ASkinControlIntf:ISkinControl;
//  ASkinControlMaterialIntf:ISkinControlMaterial;
//  ASkinPackageMaterial:TSkinControlMaterial;
//  AControlClassifySkinItem:TControlClassifySkinItem;
//  AControlTypeSkinItem:TControlTypeSkinItem;
//  AMaterialSkinItem:TMaterialSkinItem;
//begin
//  Exit;
//
//  //获取当前使用的Material,是否在皮肤包中
//  if Component.GetInterface(IID_ISkinControl,ASkinControlIntf)
//    and Component.GetInterface(IID_ISkinControlMaterial,ASkinControlMaterialIntf)
//    and (ASkinControlMaterialIntf.GetSelfOwnMaterial<>nil)
//    and (ASkinControlMaterialIntf.GetMaterialName<>'')
//    and (ASkinPackage<>nil)
//    then
//  begin
//
//      ASkinPackageMaterial:=ASkinPackage.FindMaterialByName(
//              ASkinControlIntf.Properties.GetComponentClassify,
//              ASkinControlMaterialIntf.GetCurrentUseComponentTypeName,
//              ASkinControlMaterialIntf.GetMaterialName);
//
//
//      if ASkinPackageMaterial=nil then
//      begin
//        //素材不存在,那么新建一个素材，将SelfOwnMaterial复制给Material,再保存
//        AControlClassifySkinItem:=ASkinPackage.ControlClassifySkinList.FindItemByControlClassify(ASkinControlIntf.Properties.GetComponentClassify);
//        AControlTypeSkinItem:=AControlClassifySkinItem.ControlTypeSkinList.FindItemByControlTypeName(ASkinControlMaterialIntf.GetCurrentUseComponentTypeName);
//
//        AMaterialSkinItem:=AControlTypeSkinItem.MaterialSkinList.AddMaterialSkinItem;
//        AMaterialSkinItem.Name:=ASkinControlMaterialIntf.GetMaterialName;
//        ASkinPackageMaterial:=AMaterialSkinItem.Material;
//      end;
//
//      ASkinPackageMaterial.Assign(ASkinControlMaterialIntf.GetSelfOwnMaterial);
//
//
//
//
//      Designer.Modified;
//
//
//
//      //保存成临时文件
//      ASkinPackage.SaveBackupHistroy;
//
//
//      ASkinControlMaterialIntf.NilSelfOwnMaterial;
//      ASkinControlMaterialIntf.SetMaterialUseKind(mukName);
//      ASkinControlMaterialIntf.SetKeepSelfOwnMaterial(False);
//
//  end
//  else
//  begin
//
//      if (ASkinControlMaterialIntf.GetMaterialName='') then
//      begin
//        ShowMessage(Langs_MaterialNameIsEmpty[LangKind]);
//      end;
//
//      if (ASkinPackage=nil) then
//      begin
//        ShowMessage(Langs_SkinPackageIsEmpty[LangKind]);
//      end;
//
//  end;
//
//end;
//
//
//procedure SaveSkinPackageMaterialToSelfOwnMaterial(ASkinPackage:TSkinPackage;
//                                        Component:TComponent;
//                                        Designer:IDesigner);
//var
//  ASkinControlIntf:ISkinControl;
//  ASkinControlMaterialIntf:ISkinControlMaterial;
//  ASkinPackageMaterial:TSkinControlMaterial;
//  AControlClassifySkinItem:TControlClassifySkinItem;
//  AControlTypeSkinItem:TControlTypeSkinItem;
//  AMaterialSkinItem:TMaterialSkinItem;
//begin
//  Exit;
//
//  //获取当前使用的Material,是否在皮肤包中
//  if Component.GetInterface(IID_ISkinControl,ASkinControlIntf)
//    and Component.GetInterface(IID_ISkinControlMaterial,ASkinControlMaterialIntf)
//    and (ASkinControlMaterialIntf.GetMaterialName<>'')
//    and (ASkinControlMaterialIntf.GetMaterialUseKind=TMaterialUseKind.mukName)
//    and (ASkinPackage<>nil)
//    then
//  begin
//
//      ASkinPackageMaterial:=ASkinPackage.FindMaterialByName(
//              ASkinControlIntf.Properties.GetComponentClassify,
//              ASkinControlMaterialIntf.GetCurrentUseComponentTypeName,
//              ASkinControlMaterialIntf.GetMaterialName);
//
//
//      if ASkinPackageMaterial<>nil then
//      begin
//        ASkinControlMaterialIntf.SetKeepSelfOwnMaterial(True);
//        ASkinControlMaterialIntf.SetMaterialUseKind(mukSelfOwn);
//        if (ASkinControlMaterialIntf.GetSelfOwnMaterial<>nil) then
//        begin
//          ASkinControlMaterialIntf.GetSelfOwnMaterial.Assign(ASkinPackageMaterial);
//          Designer.Modified;
//        end
//        else
//        begin
//          ShowMessage(Langs_SelfOwnMaterialIsNull[LangKind]);
//        end;
//      end
//      else
//      begin
//        ShowMessage(Langs_MaterialNameIsNotExistInSkinPackage[LangKind]);
//      end;
//
//
//
//  end
//  else
//  begin
//
//      if (ASkinControlMaterialIntf.GetMaterialUseKind<>TMaterialUseKind.mukName) then
//      begin
//        ShowMessage(Langs_MaterialUseKindNotIsmukName[LangKind]);
//      end;
//
//      if (ASkinControlMaterialIntf.GetMaterialName='') then
//      begin
//        ShowMessage(Langs_MaterialNameIsEmpty[LangKind]);
//      end;
//
//      if (ASkinPackage=nil) then
//      begin
//        ShowMessage(Langs_SkinPackageIsEmpty[LangKind]);
//      end;
//
//  end;
//
//end;

procedure SaveRefMaterialToSelfOwnMaterial(Component:TComponent;
                                            Designer:IDesigner);
var
  ASkinControlIntf:ISkinControl;
  ASkinControlMaterialIntf:ISkinControlMaterial;
  ARefMaterial:TSkinControlMaterial;
begin
  //获取当前使用的Material,是否在皮肤包中
  if Component.GetInterface(IID_ISkinControl,ASkinControlIntf)
    and Component.GetInterface(IID_ISkinControlMaterial,ASkinControlMaterialIntf)
    and (ASkinControlMaterialIntf.GetRefMaterial<>nil)
    and (ASkinControlMaterialIntf.GetMaterialUseKind=TMaterialUseKind.mukRef)
    then
  begin

      ARefMaterial:=ASkinControlMaterialIntf.GetRefMaterial;


      if ARefMaterial<>nil then
      begin
        ASkinControlMaterialIntf.SetKeepSelfOwnMaterial(True);
        ASkinControlMaterialIntf.SetMaterialUseKind(mukSelfOwn);
        if (ASkinControlMaterialIntf.GetSelfOwnMaterial<>nil) then
        begin
          ASkinControlMaterialIntf.GetSelfOwnMaterial.Assign(ARefMaterial);
          Designer.Modified;
        end
        else
        begin
          ShowMessage(Langs_SelfOwnMaterialIsNull[LangKind]);
        end;
      end;
  end;
end;


//procedure UseRefMaterialMode(Component:TComponent;Designer:IDesigner);
//var
//  ASkinControlIntf:ISkinControl;
//  ASkinControlMaterialIntf:ISkinControlMaterial;
//  ASkinMaterial:TSkinControlMaterial;
//  ALongRec:Integer;
//begin
//  //使用RefMaterial模式
//  if Component.GetInterface(IID_ISkinControl,ASkinControlIntf)
//    and Component.GetInterface(IID_ISkinControlMaterial,ASkinControlMaterialIntf)
//    then
//  begin
//    ASkinMaterial:=ASkinControlMaterialIntf.GetSelfOwnMaterial;
//    if ASkinMaterial<>nil then
//    begin
//      //把自身的Material单独作为控件分离出来共享
//      Component.RemoveComponent(ASkinMaterial);
//      ASkinMaterial.SetSubComponent(False);
//      if Designer.Root<>nil then
//      begin
//        Designer.Root.InsertComponent(ASkinMaterial);
//
//        ASkinControlMaterialIntf.NilSelfOwnMaterial;
//        ASkinControlMaterialIntf.SetMaterialUseKind(mukRef);
//        ASkinControlMaterialIntf.SetKeepSelfOwnMaterial(False);
//
//        ASkinMaterial.SetSubComponent(False);
//        ASkinMaterial.Name:=Component.Name+'_'+ASkinMaterial.Name;
//
//        ASkinControlMaterialIntf.SetRefMaterial(ASkinMaterial);
//
//
//
//        //Material的位置设置在控件左上角
//        LongRec(ALongRec).Lo:=Ceil(ASkinControlIntf.Left);
//        LongRec(ALongRec).Hi:=Ceil(ASkinControlIntf.Top);
//
//        ASkinMaterial.DesignInfo:=ALongRec;
//
//        ASkinMaterial.SetSubComponent(False);
//
//
//        ASkinMaterial.DesignInfo:=ALongRec;
//
//        Designer.SelectComponent(ASkinMaterial);
//        ASkinMaterial.DesignInfo:=ALongRec;
//
//        Designer.Modified;
//
//        ASkinMaterial.DesignInfo:=ALongRec;
//
//      end;
//    end
//    else
//    begin
//      ShowMessage(Langs_SelfOwnMaterialIsNull[LangKind]);
//    end;
//  end;
//end;

procedure UseRefMaterialMode(Component:TComponent;Designer:IDesigner);
var
  ASkinControlIntf:ISkinControl;
  ASkinControlMaterialIntf:ISkinControlMaterial;
  ASkinMaterial:TSkinControlMaterial;
  ALongRec:Integer;
begin

  uBaseLog.HandleException(nil,'UseRefMaterialMode Begin');
  uBaseLog.HandleException(nil,'UseRefMaterialMode '+Component.Name);

  //使用RefMaterial模式
  if Component.GetInterface(IID_ISkinControlMaterial,ASkinControlMaterialIntf)
    then
  begin
      uBaseLog.HandleException(nil,'UseRefMaterialMode 1');

      ASkinMaterial:=ASkinControlMaterialIntf.GetSelfOwnMaterial;
      if ASkinMaterial<>nil then
      begin
          uBaseLog.HandleException(nil,'UseRefMaterialMode 2');
          //把自身的Material单独作为控件分离出来共享
          Component.RemoveComponent(ASkinMaterial);
          ASkinMaterial.SetSubComponent(False);
          if Designer.Root<>nil then
          begin
            uBaseLog.HandleException(nil,'UseRefMaterialMode 3');
            Designer.Root.InsertComponent(ASkinMaterial);
            uBaseLog.HandleException(nil,'UseRefMaterialMode 4');

            ASkinControlMaterialIntf.NilSelfOwnMaterial;
            ASkinControlMaterialIntf.SetMaterialUseKind(mukRef);
            ASkinControlMaterialIntf.SetKeepSelfOwnMaterial(False);

            ASkinMaterial.SetSubComponent(False);
            ASkinMaterial.Name:=Component.Name+'_'+ASkinMaterial.Name;

            ASkinControlMaterialIntf.SetRefMaterial(ASkinMaterial);



            //Material的位置设置在控件左上角
            if Component.GetInterface(IID_ISkinControl,ASkinControlIntf) then
            begin
              LongRec(ALongRec).Lo:=Ceil(ASkinControlIntf.Left);
              LongRec(ALongRec).Hi:=Ceil(ASkinControlIntf.Top);
            end
            else
            begin
              LongRec(ALongRec).Lo:=100;
              LongRec(ALongRec).Hi:=100;
            end;




            ASkinMaterial.DesignInfo:=ALongRec;

            ASkinMaterial.SetSubComponent(False);


            ASkinMaterial.DesignInfo:=ALongRec;

            Designer.SelectComponent(ASkinMaterial);
            ASkinMaterial.DesignInfo:=ALongRec;

            Designer.Modified;

            ASkinMaterial.DesignInfo:=ALongRec;

            uBaseLog.HandleException(nil,'UseRefMaterialMode 5');
          end
          else
          begin
            ShowMessage('UseRefMaterialMode Designer.Root=nil');
          end;
      end
      else
      begin
          ShowMessage(Langs_SelfOwnMaterialIsNull[LangKind]);
      end;
  end
  else
  begin
      ShowMessage('UseRefMaterialMode Component is not support ISkinControl');
  end;
end;

{ TComponentTypeNameProperty }

function TComponentTypeNameProperty.GetAttributes: TPropertyAttributes;
begin
  //值列表
  Result := [paValueList];
end;

procedure TComponentTypeNameProperty.GetValues(Proc: TGetStrProc);
var
  I: Integer;
  ASkinComponentIntf:ISkinControl;
  AControlClassifyRegIndex:Integer;
  AControlClassifyReg:TControlClassifyReg;
  List: IDesignerSelections;
begin
  //把每个控件类型的可以ComponentType列出来
  //皮肤组件接口

  List := CreateSelectionList;
  if Designer<>nil then
  begin
    Designer.GetSelections(List);
  end;
  if (List.Count = 0) then
  begin
    inherited GetValues(Proc);
    Exit;
  end;
  if (List.Count > 1) then
  begin
    inherited GetValues(Proc);
    Exit;
  end;



  if List[0].GetInterface(IID_ISkinControl,ASkinComponentIntf) then
  begin
    AControlClassifyRegIndex:=GlobalControlTypeRegManager.FindControlClassifyRegIndex(
                                ASkinComponentIntf.Properties.GetComponentClassify
                                );
    if AControlClassifyRegIndex<>-1 then
    begin
      AControlClassifyReg:=GlobalControlTypeRegManager.ControlClassifyRegList[AControlClassifyRegIndex];
      for I := 0 to AControlClassifyReg.ControlTypeRegList.Count-1 do
      begin
        Proc(AControlClassifyReg.ControlTypeRegList[I].ControlTypeName);
      end;
    end;
  end
  else
  begin
    inherited GetValues(Proc);
  end;

end;

//{ TMaterialNameProperty }
//
//function TMaterialNameProperty.GetAttributes: TPropertyAttributes;
//begin
//  //值列表
//  Result := [paValueList];
//end;
//
//procedure TMaterialNameProperty.GetValues(Proc: TGetStrProc);
//var
//  I: Integer;
//  ASkinControlIntf:ISkinControl;
//  ASkinControlMaterialIntf:ISkinControlMaterial;
//  List: IDesignerSelections;
//
//  AControlClassifySkinItem:TControlClassifySkinItem;
//  AControlTypeSkinItem:TControlTypeSkinItem;
//begin
//  //把每个控件类型的可以ComponentType列出来
//  //皮肤组件接口
//
//  List := CreateSelectionList;
//  if Designer<>nil then
//  begin
//    Designer.GetSelections(List);
//  end;
//  if (List.Count = 0) then
//  begin
//    inherited GetValues(Proc);
//    Exit;
//  end;
//  if (List.Count > 1) then
//  begin
//    inherited GetValues(Proc);
//    Exit;
//  end;
//
//  if List[0].GetInterface(IID_ISkinControl,ASkinControlIntf)
//    and List[0].GetInterface(IID_ISkinControlMaterial,ASkinControlMaterialIntf)
//    and (GlobalSkinManager.CurrentSkinPackage<>nil) then
//  begin
//
//        //素材不存在,那么新建一个素材，将SelfOwnMaterial复制给Material,再保存
//        AControlClassifySkinItem:=GlobalSkinManager.CurrentSkinPackage.ControlClassifySkinList.FindItemByControlClassify(
//              ASkinControlIntf.Properties.GetComponentClassify);
//        AControlTypeSkinItem:=AControlClassifySkinItem.ControlTypeSkinList.FindItemByControlTypeName(
//              ASkinControlMaterialIntf.GetCurrentUseComponentTypeName);
//
//        for I := 0 to AControlTypeSkinItem.MaterialSkinList.Count-1 do
//        begin
//          Proc(AControlTypeSkinItem.MaterialSkinList[I].Name);
//        end;
//
//  end
//  else
//  begin
//    inherited GetValues(Proc);
//  end;
//
//end;



{ TRefMaterialProperty }

function TRefMaterialProperty.GetAttributes: TPropertyAttributes;
begin
  Result := Inherited GetAttributes+[paValueList];
end;

procedure TRefMaterialProperty.AddTempString(const S: string);
begin
  FTempStrings.Add(S);
end;

procedure TRefMaterialProperty.GetValues(Proc: TGetStrProc);
var
  ASkinControlIntf:ISkinControl;
  ASkinControlMaterialIntf:ISkinControlMaterial;
  List: IDesignerSelections;
  AMaterialClass:TMaterialClass;
var
  LComponent: TComponent;
  S: string;
begin

  //获取选中的控件列表
  List := CreateSelectionList;
  if Designer<>nil then
  begin
    Designer.GetSelections(List);
  end;
  if (List.Count = 0) then
  begin
    inherited GetValues(Proc);
    Exit;
  end;

  if List[0].GetInterface(IID_ISkinControl,ASkinControlIntf)
     and List[0].GetInterface(IID_ISkinControlMaterial,ASkinControlMaterialIntf)
    then
  begin
    FTempStrings := TStringList.Create;
    try
      //获取所有控件列表
      Designer.GetComponentNames(GetTypeData(GetPropType), AddTempString);


      for S in FTempStrings do
      begin
        //指定名称的组件
        LComponent := Designer.GetComponent(S) as TComponent;
        //如果控件是素材组件
        if LComponent is TSkinControlMaterial then
        begin

          //判断此素材是否是选中控件对应的素材类
          if (ASkinControlMaterialIntf.GetCurrentUseComponentTypeName<>'')
            and (ASkinControlIntf.Properties.GetComponentClassify<>'') then
          begin
            //获取当前的素材类
            AMaterialClass:=GlobalControlTypeRegManager.FindMaterialClassByControlTypeName(
                                            ASkinControlIntf.Properties.GetComponentClassify,
                                            ASkinControlMaterialIntf.GetCurrentUseComponentTypeName);

            //判断是否符合
            if (AMaterialClass<>nil) and (LComponent.ClassType=AMaterialClass) then
            begin
              Proc(S);
            end;

          end;

        end;
      end;
    finally
      FTempStrings.Free;
    end;
  end
  else
  begin
    inherited GetValues(Proc);
  end;

end;

{ TSkinControlComponentEditor }


procedure TSkinControlComponentEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0:
    begin
      //使用RefMaterial模式
      UseRefMaterialMode(Component,Designer);
    end;
    1:
    begin
      //保存RefMaterial到SelfOwnMaterial
      SaveRefMaterialToSelfOwnMaterial(
              Component,
              Designer);

    end;
//    2:
//    begin
//      //编辑此皮肤包Material
//      if GlobalSkinManager<>nil then OpenSkinPackageMaterialEditor(
//              GlobalSkinManager.CurrentSkinPackage,
//              Component,
//              Designer);
//
//    end;
//    3:
//    begin
//      //保存SelfOwnMaterial到皮肤包
//      if GlobalSkinManager<>nil then SaveSelfOwnMaterialToSkinPackage(
//              GlobalSkinManager.CurrentSkinPackage,
//              Component,
//              Designer);
//
//    end;
//    4:
//    begin
//      //保存皮肤包Material到SelfOwnMaterial
//      if GlobalSkinManager<>nil then SaveSkinPackageMaterialToSelfOwnMaterial(
//              GlobalSkinManager.CurrentSkinPackage,
//              Component,
//              Designer);
//
//    end;
  end;
end;

function TSkinControlComponentEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0:
    begin
      Result:=Langs_UseRefMaterial[LangKind];
    end;
    1:
    begin
      Result:=Langs_SaveRefMaterialToSelfOwnMaterial[LangKind];
    end;
    2:
    begin
      //绑定列表项
      Result:=Langs_BindAs[LangKind];
    end;
//    2:
//    begin
//      Result:=Langs_EditPackageMaterial[LangKind];
//    end;
//    3:
//    begin
//      Result:=Langs_SaveSelfOwnMaterialToPackage[LangKind];
//    end;
//    4:
//    begin
//      Result:=Langs_SavePackageMaterialToSelfOwnMaterial[LangKind];
//    end;
  end;
end;

function TSkinControlComponentEditor.GetVerbCount: Integer;
begin
  Result:=3;
end;

procedure TSkinControlComponentEditor.PrepareItem(Index: Integer;
  const AItem: IMenuItem);
var
  I: Integer;
  MenuItem: IMenuItem;

  ASkinItem:TSkinItem;
  ASkinItemType:TSkinItemType;
  AItemDesignerPanel:TSkinItemDesignerPanel;
  ASkinVirtualList:TSkinVirtualList;
begin
  inherited PrepareItem(Index, AItem);


  //绑定为列表项的
  //添加子菜单
  if Index = 2 then
  begin
      //绑定为列表项的
      ASkinItem:=nil;
      ASkinVirtualList:=nil;
      ASkinItemType:=sitDefault;
      AItemDesignerPanel:=nil;
      if (Component<>nil) and (Component is TChildControl) then
      begin
        AItemDesignerPanel:=GetParentItemDesignerPanel(TChildControl(Component));
        if AItemDesignerPanel<>nil then
        begin
              if AItemDesignerPanel.Parent is TSkinVirtualList then
              begin
                  //取出当前这个ItemDesignerPanel是对应哪个ItemType
                  ASkinVirtualList:=TSkinVirtualList(AItemDesignerPanel.Parent);
                  if ASkinVirtualList<>nil then
                  begin
                      //取出设计面板用于显示哪种列表项,并且从ListBox中获取这种Item
                      if AItemDesignerPanel=ASkinVirtualList.Prop.ItemDesignerPanel then ASkinItemType:=sitDefault;
                      if AItemDesignerPanel=ASkinVirtualList.Prop.Item1DesignerPanel then ASkinItemType:=sitItem1;
                      if AItemDesignerPanel=ASkinVirtualList.Prop.Item2DesignerPanel then ASkinItemType:=sitItem2;
                      if AItemDesignerPanel=ASkinVirtualList.Prop.Item3DesignerPanel then ASkinItemType:=sitItem3;
                      if AItemDesignerPanel=ASkinVirtualList.Prop.Item4DesignerPanel then ASkinItemType:=sitItem4;
                      if AItemDesignerPanel=ASkinVirtualList.Prop.HeaderDesignerPanel then ASkinItemType:=sitHeader;
                      if AItemDesignerPanel=ASkinVirtualList.Prop.FooterDesignerPanel then ASkinItemType:=sitFooter;
                      if AItemDesignerPanel=ASkinVirtualList.Prop.SearchBarDesignerPanel then ASkinItemType:=sitSearchBar;
                      ASkinItem:=ASkinVirtualList.Prop.Items.FindItemByType(ASkinItemType);
                  end;
              end
              else
              begin
                  //直接取设计面板的预览列表项
                  ASkinItem:=AItemDesignerPanel.Prop.PreviewItem;
              end;




              if (ASkinItem=nil) then
              begin
                ASkinItem:=TRealSkinItem.Create;//(nil);
              end;


              if (ASkinItem is TRealSkinItem) or (ASkinItem is TRealSkinTreeViewItem) then
              begin

                  MenuItem:=AItem.AddItem('Caption'+','+ASkinItem.Caption,0,False,True,DoBindItemAs);
                  MenuItem.Tag := 0;
                  MenuItem := nil;

                  MenuItem:=AItem.AddItem('Detail'+','+ASkinItem.Detail,0,False,True,DoBindItemAs);
                  MenuItem.Tag := 1;
                  MenuItem := nil;

                  MenuItem:=AItem.AddItem('Detail1'+','+ASkinItem.Detail1,0,False,True,DoBindItemAs);
                  MenuItem.Tag := 2;
                  MenuItem := nil;

                  MenuItem:=AItem.AddItem('Detail2'+','+ASkinItem.Detail2,0,False,True,DoBindItemAs);
                  MenuItem.Tag := 3;
                  MenuItem := nil;

                  MenuItem:=AItem.AddItem('Detail3'+','+ASkinItem.Detail3,0,False,True,DoBindItemAs);
                  MenuItem.Tag := 4;
                  MenuItem := nil;

                  MenuItem:=AItem.AddItem('Detail4'+','+ASkinItem.Detail4,0,False,True,DoBindItemAs);
                  MenuItem.Tag := 5;
                  MenuItem := nil;

                  MenuItem:=AItem.AddItem('Detail5'+','+ASkinItem.Detail5,0,False,True,DoBindItemAs);
                  MenuItem.Tag := 6;
                  MenuItem := nil;

                  MenuItem:=AItem.AddItem('Detail6'+','+ASkinItem.Detail6,0,False,True,DoBindItemAs);
                  MenuItem.Tag := 7;
                  MenuItem := nil;

              end;

              MenuItem:=AItem.AddItem('Icon',0,False,True,DoBindItemAs);
              MenuItem.Tag := 8;
              MenuItem := nil;

              MenuItem:=AItem.AddItem('Checked',0,False,True,DoBindItemAs);
              MenuItem.Tag := 9;
              MenuItem := nil;

              MenuItem:=AItem.AddItem('Selected',0,False,True,DoBindItemAs);
              MenuItem.Tag := 10;
              MenuItem := nil;

              MenuItem:=AItem.AddItem('Pic',0,False,True,DoBindItemAs);
              MenuItem.Tag := 11;
              MenuItem := nil;

//              MenuItem:=AItem.AddItem('Null',0,False,True,DoBindItemAs);
//              MenuItem.Tag := 12;
//              MenuItem := nil;



        end;
      end;

  end;
end;

procedure TSkinControlComponentEditor.DoBindItemAs(Sender: TObject);
var
  AMenu:TMenuItem;
  AItemDesignerPanel:TSkinItemDesignerPanel;
begin
  if (Sender is TMenuItem) and (Component is TChildControl) then
  begin
    AMenu:=TMenuItem(Sender);

    AItemDesignerPanel:=GetParentItemDesignerPanel(TChildControl(Component));

    if AItemDesignerPanel<>nil then
    begin

      if AMenu.Tag=0 then AItemDesignerPanel.Prop.ItemCaptionBindingControl:=TChildControl(Component);
      if AMenu.Tag=1 then AItemDesignerPanel.Prop.ItemDetailBindingControl:=TChildControl(Component);
      if AMenu.Tag=2 then AItemDesignerPanel.Prop.ItemDetail1BindingControl:=TChildControl(Component);
      if AMenu.Tag=3 then AItemDesignerPanel.Prop.ItemDetail2BindingControl:=TChildControl(Component);
      if AMenu.Tag=4 then AItemDesignerPanel.Prop.ItemDetail3BindingControl:=TChildControl(Component);
      if AMenu.Tag=5 then AItemDesignerPanel.Prop.ItemDetail4BindingControl:=TChildControl(Component);
      if AMenu.Tag=6 then AItemDesignerPanel.Prop.ItemDetail5BindingControl:=TChildControl(Component);
      if AMenu.Tag=7 then AItemDesignerPanel.Prop.ItemDetail6BindingControl:=TChildControl(Component);
      if AMenu.Tag=8 then AItemDesignerPanel.Prop.ItemIconBindingControl:=TChildControl(Component);
      if AMenu.Tag=9 then AItemDesignerPanel.Prop.ItemCheckedBindingControl:=TChildControl(Component);
      if AMenu.Tag=10 then AItemDesignerPanel.Prop.ItemSelectedBindingControl:=TChildControl(Component);
      if AMenu.Tag=11 then AItemDesignerPanel.Prop.ItemPicBindingControl:=TChildControl(Component);



      Designer.Modified;
    end
    else
    begin
      ShowMessage('父控件必须是ItemDesignerPanel'
                  +TChildControl(Component).Parent.ClassName);
    end;
  end
  else
  begin

  end;

end;


{ TBindItemFieldNameProperty }

function TBindItemFieldNameProperty.GetAttributes: TPropertyAttributes;
begin
  //值列表
  Result := [paValueList];

end;

procedure TBindItemFieldNameProperty.GetValues(Proc: TGetStrProc);
var
  AItemDesignerPanel:TSkinItemDesignerPanel;
  List: IDesignerSelections;
{$IFDEF MY_PROGRAM_DESIGNER}
var
  I:Integer;
  APageDesignPanel:TPageDesignPanel;
{$ENDIF MY_PROGRAM_DESIGNER}
begin
  //绑定为列表项的
  List := CreateSelectionList;
  if Designer<>nil then
  begin
    Designer.GetSelections(List);
  end;
  if (List.Count = 0) then
  begin
    inherited GetValues(Proc);
    Exit;
  end;
  if (List.Count > 1) then
  begin
    inherited GetValues(Proc);
    Exit;
  end;


  AItemDesignerPanel:=nil;
  if (List[0] is TChildControl) then
  begin
      AItemDesignerPanel:=GetParentItemDesignerPanel(TChildControl(List[0]));
      if AItemDesignerPanel<>nil then
      begin
        //如果父控件是设计面板,那么从设计面板的JsonStr中获取可选的字段列表
        GetParentItemDesignerPanelKeys(AItemDesignerPanel,Proc);
      end;


      {$IFDEF MY_PROGRAM_DESIGNER}
      //如果是在页面设计器中
      APageDesignPanel:=TPageDesignPanel(GetParentByControlClass(TChildControl(List[0]),TPageDesignPanel));
      if APageDesignPanel<>nil then
      begin
        //加入接口1的字段,默认的字段,不用加前缀
        for I := 0 to APageDesignPanel.DataInterface.FieldNameList.Count-1 do
        begin
          Proc(APageDesignPanel.DataInterface.FieldNameList[I]);
        end;

        //接口1,加前缀
        for I := 0 to APageDesignPanel.DataInterface.FieldNameList.Count-1 do
        begin
          Proc('$data_intf.'+APageDesignPanel.DataInterface.FieldNameList[I]);
        end;

        //接口2,加前缀
        for I := 0 to APageDesignPanel.DataInterface2.FieldNameList.Count-1 do
        begin
          Proc('$data_intf2.'+APageDesignPanel.DataInterface2.FieldNameList[I]);
        end;


        //本地数据源的
        //$local_data_source

      end;
      {$ENDIF MY_PROGRAM_DESIGNER}


  end;





end;

{ TMultiColorLabelNameProperty }

function TMultiColorLabelNameProperty.GetAttributes: TPropertyAttributes;
begin
  //值列表
  Result := [paValueList];
end;

procedure TMultiColorLabelNameProperty.GetValues(Proc: TGetStrProc);
var
  AItemDesignerPanel:TSkinItemDesignerPanel;
  List: IDesignerSelections;
begin
  //绑定为列表项的
  List := CreateSelectionList;
  if Designer<>nil then
  begin
    Designer.GetSelections(List);
  end;
  if (List.Count = 0) then
  begin
    inherited GetValues(Proc);
    Exit;
  end;
  if (List.Count > 1) then
  begin
    inherited GetValues(Proc);
    Exit;
  end;


  AItemDesignerPanel:=nil;
  if (List[0] is TColorTextItem) then
  begin
    AItemDesignerPanel:=GetParentItemDesignerPanel(

        TColorTexts(TColorTextItem(List[0]).Collection).Prop.SkinControl

        );
    if AItemDesignerPanel<>nil then
    begin
      GetParentItemDesignerPanelKeys(AItemDesignerPanel,Proc);
    end;
  end;



end;



//initialization
//  GlobalDoGetStreamEvent:=GetMyStream;

{ TItemGridBindItemFieldNameProperty }

function TItemGridBindItemFieldNameProperty.GetAttributes: TPropertyAttributes;
begin
  //值列表
  Result := [paValueList];
end;

procedure TItemGridBindItemFieldNameProperty.GetValues(Proc: TGetStrProc);
begin
  GetParentItemDesignerPanelKeys(nil,Proc);
end;

{ TMessageBoxSelectionEditor }

procedure TMessageBoxSelectionEditor.RequiresUnits(Proc: TGetStrProc);
begin
//  Add needed used units to the uses clauses of the form where the component is located.
  Proc('MessageBoxFrame');
end;

{ TTimerTaskEventSelectionEditor }

procedure TTimerTaskEventSelectionEditor.RequiresUnits(Proc: TGetStrProc);
begin
//  Add needed used units to the uses clauses of the form where the component is located.
  Proc('uTimerTask');

end;

end.
