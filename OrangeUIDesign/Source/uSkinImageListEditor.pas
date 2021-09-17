//convert pas to utf8 by ¥

unit uSkinImageListEditor;

interface
{$I FrameWork.inc}



uses
  Classes,
  SysConst,
  {$IFDEF VCL}
  Windows,
  Forms,
  Graphics,
  Controls,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ExtDlgs,
  ComCtrls,
  ImgList,
  VCL_SkinPictureListPropertyEditorForm,
  CommCtrl,

  PngImage,
  GifImg,
  Jpeg,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX_XE_SkinPictureListPropertyEditorForm,
  {$ENDIF}

  uLang,
  uLanguage,
  uSkinPicture,
  uDrawPicture,
  uSkinImageList,

  DesignIntf,
  DesignEditors;




type
  //TSkinImageList组件编辑器
  TSkinImageListEditor = class(TDefaultEditor)
  public
    FPicDlg: TfrmSkinPictureListPropertyEditor;
    procedure Edit;override;
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;


  //TSkinPictureList属性编辑器
  TSkinPictureListPropertyEditor = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;



  //编辑TSkinPictureList组件弹出窗体
  TSkinPictureListEditorPopupForm = class(TComponent)
  private
    FPicDlg: TfrmSkinPictureListPropertyEditor;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean;
  end;


procedure Register;

implementation




uses
  TypInfo,
  SysUtils;


procedure Register;
begin
  //属性编辑器
  RegisterPropertyEditor(TypeInfo(TSkinPictureList),//属性名称
                          nil,                      //指定类
                          '',                       //指定属性名
                          TSkinPictureListPropertyEditor);//属性编辑器类
  //组件编辑器
  RegisterComponentEditor(TSkinImageList,
                          TSkinImageListEditor);
end;


{ TSkinImageListEditor }

procedure TSkinImageListEditor.Edit;
begin
  ExecuteVerb(0);
end;

procedure TSkinImageListEditor.ExecuteVerb(Index: Integer);
var
  PictureEditor: TSkinPictureListEditorPopupForm;
begin
  case Index of
    0:
    begin
      FPicDlg := TfrmSkinPictureListPropertyEditor.Create(nil);
      FPicDlg.FComponent:=TSkinImageList(Self.Component);
      FPicDlg.FDesigner:=Designer;
//      FPicDlg.FDefaultEditor:=Self;
      FPicDlg.PictureList:=TSkinImageList(Self.Component).PictureList;
      FPicDlg.Show;

//      PictureEditor := TSkinPictureListEditorPopupForm.Create(nil);
//      try
//        PictureEditor.FPicDlg.PictureList:=TSkinImageList(Self.Component).PictureList;
//        if PictureEditor.Execute then
//        begin
//          TSkinImageList(Self.Component).PictureList:=PictureEditor.FPicDlg.PictureList;
//          Designer.Modified;
//        end;
//      finally
//        PictureEditor.Free;
//      end;


    end;
  end;
end;

function TSkinImageListEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := Langs_PictureListEditor[LangKind];
  end;
end;

function TSkinImageListEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;




{ TSkinPictureListPropertyEditor }

procedure TSkinPictureListPropertyEditor.Edit;
var
  ASkinPictureList:TSkinPictureList;
  PictureEditor: TSkinPictureListEditorPopupForm;
begin
  PictureEditor := TSkinPictureListEditorPopupForm.Create(nil);
  try
    ASkinPictureList:=TSkinPictureList(Pointer(GetOrdValue));
    PictureEditor.FPicDlg.PictureList:=ASkinPictureList;
    if PictureEditor.Execute then
    begin
      SetOrdValue(Longint(PictureEditor.FPicDlg.PictureList));
    end;
  finally
    PictureEditor.Free;
  end;
end;

function TSkinPictureListPropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TSkinPictureListPropertyEditor.GetValue: string;
var
  ASkinPictureList: TSkinPictureList;
begin
  ASkinPictureList := TSkinPictureList(GetOrdValue);
  Result:=Format(Langs_PictureListCount[LangKind],[ASkinPictureList.Count]);
end;

procedure TSkinPictureListPropertyEditor.SetValue(const Value: string);
begin
  if Value = '' then
  begin
    SetOrdValue(0);
  end;
end;



{ TSkinPictureListEditorPopupForm }

constructor TSkinPictureListEditorPopupForm.Create(AOwner: TComponent);
begin
  Inherited;
  FPicDlg := TfrmSkinPictureListPropertyEditor.Create(Self);
end;

destructor TSkinPictureListEditorPopupForm.Destroy;
begin
  FPicDlg.Free;
  inherited Destroy;
end;

function TSkinPictureListEditorPopupForm.Execute: Boolean;
begin
  Result := FPicDlg.ShowModal = mrOK;
end;


end.





