//convert pas to utf8 by ¥

unit uLanguage;

interface
{$I FrameWork.inc}


uses
  //uVersion,
  uLang;


const
  Langs_UseRefMaterial : array[Low(TLangKind)..High(TLangKind)] of string =
      ('使用RefMaterial模式','Use RefMaterial Mode','');
  Langs_SaveRefMaterialToSelfOwnMaterial : array[Low(TLangKind)..High(TLangKind)] of string =
      ('复制RefMaterial给SelfOwnMaterial','Copy RefMaterial to SelfOwnMaterial','');
  Langs_BindAs : array[Low(TLangKind)..High(TLangKind)] of string =
      ('绑定为列表项的','Bind as','');
  Langs_EditPackageMaterial : array[Low(TLangKind)..High(TLangKind)] of string =
      ('打开皮肤包编辑器编辑此Material','Open SkinPackageEditor To Edit Material','');
  Langs_SaveSelfOwnMaterialToPackage : array[Low(TLangKind)..High(TLangKind)] of string =
      ('保存SelfOwnMaterial到皮肤包','Save SelfOwnMaterial To SkinPackage','');
  Langs_SavePackageMaterialToSelfOwnMaterial : array[Low(TLangKind)..High(TLangKind)] of string =
      ('复制皮肤包Material给SelfOwnMaterial','Copy Material in SkinPackage to SelfOwnMaterial ','');


  Langs_MaterialUseKindNotIsmukName : array[Low(TLangKind)..High(TLangKind)] of string =
      ('MaterialUseKind不是mukName','MaterialUseKind is not mukName','');
  Langs_MaterialNameIsEmpty : array[Low(TLangKind)..High(TLangKind)] of string =
      ('MaterialName为空','MaterialName is empty','');
  Langs_SkinPackageIsEmpty : array[Low(TLangKind)..High(TLangKind)] of string =
      ('SkinPackage为空','SkinPackage is empty','');
  Langs_MaterialNameIsNotExistInSkinPackage : array[Low(TLangKind)..High(TLangKind)] of string =
      ('皮肤包中不存在此MaterialName','MaterialName is not exist in SkinPackage','');
  Langs_SelfOwnMaterialIsNull : array[Low(TLangKind)..High(TLangKind)] of string =
      ('SelfOwnMaterial为空','SelfOwnMaterial is null','');



  Langs_SetPicture : array[Low(TLangKind)..High(TLangKind)] of string =
      ('设置图片...','Set Picture...','');


  Langs_NewTabSheet : array[Low(TLangKind)..High(TLangKind)] of string =
      ('创建一个新标签页','New TabSheet','');
  Langs_SwitchTabSheet : array[Low(TLangKind)..High(TLangKind)] of string =
      ('切换到','Switch to ','');

  Langs_NewItem : array[Low(TLangKind)..High(TLangKind)] of string =
      ('创建新项','New Item','');
  Langs_ItemsEditor : array[Low(TLangKind)..High(TLangKind)] of string =
      ('项目编辑器','Items Editor','');
  Langs_GridColumnsEditor : array[Low(TLangKind)..High(TLangKind)] of string =
      ('表格列编辑器','Grid Columns Editor','');

  Langs_AddItem : array[Low(TLangKind)..High(TLangKind)] of string =
      ('添加项目','Add Item','');
  Langs_InsertItem : array[Low(TLangKind)..High(TLangKind)] of string =
      ('插入项目','Insert Item','');
  Langs_AddChildItem : array[Low(TLangKind)..High(TLangKind)] of string =
      ('添加子项目','Add Child Item','');
  Langs_DeleteItem : array[Low(TLangKind)..High(TLangKind)] of string =
      ('删除项目','Delete Item','');
  Langs_ClearAllItems : array[Low(TLangKind)..High(TLangKind)] of string =
      ('清除所有项目','Clear All Items','');


  Langs_SkinPackageEditor : array[Low(TLangKind)..High(TLangKind)] of string =
      ('皮肤包编辑器','SkinPackage Editor','');

  Langs_PictureListEditor : array[Low(TLangKind)..High(TLangKind)] of string =
      ('图片列表编辑器','PictureList Editor','');
  Langs_PictureListCount : array[Low(TLangKind)..High(TLangKind)] of string =
      ('(%d张图片)','(%d Pictures)','');

  Langs_NewButton : array[Low(TLangKind)..High(TLangKind)] of string =
      ('创建一个新按钮','New Button','');
  Langs_InsertFront : array[Low(TLangKind)..High(TLangKind)] of string =
      ('在前面插入一个新按钮','Insert Button(Front)','');
  Langs_InsertBehind : array[Low(TLangKind)..High(TLangKind)] of string =
      ('在后面插入一个新按钮','Insert Button(Behind)','');

  Langs_Forward : array[Low(TLangKind)..High(TLangKind)] of string =
      ('前进','Forward','');
  Langs_Backward : array[Low(TLangKind)..High(TLangKind)] of string =
      ('后退','Backward','');
  Langs_Pause : array[Low(TLangKind)..High(TLangKind)] of string =
      ('暂停','Pause','');
  Langs_Continue : array[Low(TLangKind)..High(TLangKind)] of string =
      ('继续','Continue','');

  Langs_Stop : array[Low(TLangKind)..High(TLangKind)] of string =
      ('停止','Stop','');
  Langs_PictureEmpty : array[Low(TLangKind)..High(TLangKind)] of string =
      ('(空)','(Empty)','');
//  Langs_HowToSetPicture : array[Low(TLangKind)..High(TLangKind)] of string =
//      ('双击选择图片','DblClick To Select Pic','');
  Langs_PictureSize : array[Low(TLangKind)..High(TLangKind)] of string =
      ('(%d*%d)','(%d*%d)','');

  Langs_OK : array[Low(TLangKind)..High(TLangKind)] of string =
      ('确定','OK','');
  Langs_Cancel : array[Low(TLangKind)..High(TLangKind)] of string =
      ('取消','Cancel','');
  Langs_Add : array[Low(TLangKind)..High(TLangKind)] of string =
      ('添加','Add','');
  Langs_AddEmpty : array[Low(TLangKind)..High(TLangKind)] of string =
      ('添加空图','Add Empty','');
  Langs_Replace : array[Low(TLangKind)..High(TLangKind)] of string =
      ('替换','Replace','');
  Langs_Delete : array[Low(TLangKind)..High(TLangKind)] of string =
      ('删除','Delete','');
  Langs_Export : array[Low(TLangKind)..High(TLangKind)] of string =
      ('导出','Export','');
  Langs_Clear : array[Low(TLangKind)..High(TLangKind)] of string =
      ('清除','Clear','');
  Langs_ExportAll : array[Low(TLangKind)..High(TLangKind)] of string =
      ('全部导出','Export All','');
  Langs_Save : array[Low(TLangKind)..High(TLangKind)] of string =
      ('保存','Save','');


  Langs_CurImageIndex : array[Low(TLangKind)..High(TLangKind)] of string =
      ('当前选中图片下标:','Selected ImageIndex:','');
  Langs_CurImageName : array[Low(TLangKind)..High(TLangKind)] of string =
      ('当前选中图片名称:','Selected ImageName:','');
  Langs_CurImagePath : array[Low(TLangKind)..High(TLangKind)] of string =
      ('当前选中图片路径:','Selected FileName:','');
  Langs_CurImageResource : array[Low(TLangKind)..High(TLangKind)] of string =
      ('当前选中图片资源名称:','Selected ResourceName:','');
  Langs_CurImageUrl : array[Low(TLangKind)..High(TLangKind)] of string =
      ('当前选中图片链接:','Selected Url:','');

  Langs_OnlySetFilePath : array[Low(TLangKind)..High(TLangKind)] of string =
      ('添加图片时只设置路径:','Set FileName When Add','');


  Langs_MaterialName : array[Low(TLangKind)..High(TLangKind)] of string =
      ('素材名称','Material Name','');
  Langs_ColIndex : array[Low(TLangKind)..High(TLangKind)] of string =
      ('列下标','Col Index','');
  Langs_RowIndex : array[Low(TLangKind)..High(TLangKind)] of string =
      ('行下标','Row Index','');
  Langs_Set : array[Low(TLangKind)..High(TLangKind)] of string =
      ('设置','Set','');



  Langs_PictureEditor : array[Low(TLangKind)..High(TLangKind)] of string =
      ('图片编辑器','Picture Editor','');
  Langs_Open : array[Low(TLangKind)..High(TLangKind)] of string =
      ('打开...','Open...','');
  Langs_SaveAs : array[Low(TLangKind)..High(TLangKind)] of string =
      ('另存为...','SaveAs...','');
  Langs_ConfigResourceSearchPath : array[Low(TLangKind)..High(TLangKind)] of string =
      ('配置资源图片设计时搜索路径...','Config Resource Picture Search Path...','');

  Langs_UseCellPicture : array[Low(TLangKind)..High(TLangKind)] of string =
      ('使用子图片','Use Cell Picture','');
  Langs_RowCount : array[Low(TLangKind)..High(TLangKind)] of string =
      ('行数:','RowCount:','');
  Langs_ColCount : array[Low(TLangKind)..High(TLangKind)] of string =
      ('列数:','ColCount:','');
  Langs_SameGroupMaterialPicture : array[Low(TLangKind)..High(TLangKind)] of string =
      ('同分组的素材图片:','Same Group Material Picture:','');

  Langs_CurrentPicture : array[Low(TLangKind)..High(TLangKind)] of string =
      ('(当前图片)','(Cur Picture)','');





//var
//  LangKind:TLangKind;


implementation



//initialization
//  //赋值
//  //english
//  LangKind:=TLangKind.lkEN;
//
//
//
//  if GetWindowsLanguage='中文(简体，中国)' then
//  begin
//    //chinese
//    LangKind:=TLangKind.lkZH;
//  end;





end.
