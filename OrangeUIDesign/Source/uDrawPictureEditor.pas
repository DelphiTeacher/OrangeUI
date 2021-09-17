//convert pas to utf8 by ¥

unit uDrawPictureEditor;

interface
{$I FrameWork.inc}


uses
  Classes,
  uLanguage,


  {$IFDEF VCL}
  Forms,
  Graphics,
  Controls,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ExtDlgs,
  ComCtrls,
  ImgList,
  PngImage,
  GifImg,
  Jpeg,
//  uSkinWindowsImage,
//  uSkinDirectUIImage,
  VCL_DrawPicturePropertyEditorForm,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX_XE_DrawPicturePropertyEditorForm,
  uSkinFireMonkeyImage,
  {$ENDIF}


  SysConst,
  uLang,
  uComponentTypeNameEditor,
  uSkinMaterial,
  uSkinImageType,
  uSkinPicture,
  uDrawPicture,
  uDrawEngine,
  uComponentType,
  uSkinImageList,
  Windows,
  CommCtrl,
  DesignIntf,
  DesignEditors;


type
  //TSkinImage组件编辑器
  TSkinImageEditor = class(TSkinControlComponentEditor)
  public
    procedure Edit;override;
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;



  //TDrawPicture属性编辑器
  TDrawPicturePropertyEditor = class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;



  //编辑TDrawPicture组件
  TDrawPictureEditorPopupForm = class(TComponent)
  private
    FDrawPicture: TDrawPicture;
//    FSkinMaterial:TSkinControlMaterial;
    FPicDlg: TfrmDrawPicturePropertyEditor;
    procedure SetDrawPicture(const Value: TDrawPicture);
  public
    function Execute: Boolean;
    property DrawPicture: TDrawPicture read FDrawPicture write SetDrawPicture;
    //可以列举出当前素材其他的DrawPicture
//    property SkinMaterial:TSkinControlMaterial read FSkinMaterial write FSkinMaterial;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


procedure Register;


implementation

uses
  TypInfo,
  SysUtils;


procedure Register;
begin
  //属性编辑器
  RegisterPropertyEditor(TypeInfo(TBaseDrawPicture),
                          nil,
                          '',
                          TDrawPicturePropertyEditor);
  //组件编辑器
  {$IFDEF FMX}
  RegisterComponentEditor(TSkinFMXImage,TSkinImageEditor);
  {$ENDIF}
  {$IFDEF VCL}
  RegisterComponentEditor(TSkinWinImage,TSkinImageEditor);
  {$ENDIF}
end;




{ TDrawPicturePropertyEditor }

procedure TDrawPicturePropertyEditor.Edit;
var
  ADrawPicture:TDrawPicture;
  PictureEditor: TDrawPictureEditorPopupForm;
//  List: IDesignerSelections;
//  ASkinComponentIntf:ISkinControl;
begin
  PictureEditor := TDrawPictureEditorPopupForm.Create(nil);
  try
    ADrawPicture:=TDrawPicture(Pointer(GetOrdValue));
    PictureEditor.DrawPicture:=ADrawPicture;

//    List := CreateSelectionList;
//    if Designer<>nil then
//    begin
//      Designer.GetSelections(List);
//    end;
//
//
//    if ADrawPicture.SkinMaterial<>nil then
//    begin
//      PictureEditor.SkinMaterial:=TSkinControlMaterial(ADrawPicture.SkinMaterial);
//    end
//    else
//    begin
//      if List[0].GetInterface(IID_ISkinControl,ASkinComponentIntf) then
//      begin
//        PictureEditor.SkinMaterial:=ASkinComponentIntf.GetCurrentUseMaterial;
//      end;
//    end;

    if PictureEditor.Execute then
    begin
      SetOrdValue(Longint(PictureEditor.DrawPicture));
    end;

  finally
    PictureEditor.Free;
  end;
end;

function TDrawPicturePropertyEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited;
end;

function TDrawPicturePropertyEditor.GetValue: string;
var
  ADrawPicture: TDrawPicture;
begin
  ADrawPicture := TDrawPicture(GetOrdValue);
  if ADrawPicture.CurrentPictureIsEmpty then
  begin
    Result := Langs_PictureEmpty[LangKind];
  end
  else
  begin
    Result := Format(Langs_PictureSize[LangKind],
                    [ADrawPicture.CurrentPictureDrawWidth,
                    ADrawPicture.CurrentPictureDrawHeight])
                    ;
  end;
end;

procedure TDrawPicturePropertyEditor.SetValue(const Value: string);
begin
  if Value = '' then
  begin
    SetOrdValue(0);
  end;
end;



{ TDrawPictureEditorPopupForm }

constructor TDrawPictureEditorPopupForm.Create(AOwner: TComponent);
begin
  Inherited;
  FDrawPicture :=uDrawEngine.CreateCurrentEngineDrawPicture('','');
  FPicDlg := TfrmDrawPicturePropertyEditor.Create(Self);
end;

destructor TDrawPictureEditorPopupForm.Destroy;
begin
  FPicDlg.Free;
  FDrawPicture.Free;
  inherited Destroy;
end;

function TDrawPictureEditorPopupForm.Execute: Boolean;
begin
//  FPicDlg.SkinMaterial:=FSkinMaterial;
  FPicDlg.DrawPicture:=FDrawPicture;

  Result := FPicDlg.ShowModal = mrOK;

  if Result then
  begin
    FDrawPicture.Assign(FPicDlg.DrawPicture);
  end;
end;

procedure TDrawPictureEditorPopupForm.SetDrawPicture(const Value: TDrawPicture);
begin
  FDrawPicture.Assign(Value);
end;





{ TSkinImageEditor }

procedure TSkinImageEditor.Edit;
begin
  ExecuteVerb((Inherited GetVerbCount));
end;

procedure TSkinImageEditor.ExecuteVerb(Index: Integer);
var
//  ASkinPictureList:TSkinPictureList;
  PictureEditor: TDrawPictureEditorPopupForm;
  SkinImageIntf:ISkinImage;
//  SkinImageComponentIntf:ISkinControl;
begin
  Inherited ExecuteVerb(Index);
  if Index=(Inherited GetVerbCount)+0 then
  begin

    if Self.Component.GetInterface(IID_ISkinImage,SkinImageIntf)
//      and Self.Component.GetInterface(IID_ISkinControl,SkinImageComponentIntf)
      then
    begin

      PictureEditor := TDrawPictureEditorPopupForm.Create(nil);
      try
//        PictureEditor.SkinMaterial:=SkinImageComponentIntf.GetCurrentUseMaterial;
        PictureEditor.DrawPicture:=SkinImageIntf.Prop.Picture;
        if PictureEditor.Execute then
        begin
          SkinImageIntf.Prop.Picture:=PictureEditor.DrawPicture;
          Designer.Modified;
        end;
      finally
        PictureEditor.Free;
      end;
    end;

  end;
end;

function TSkinImageEditor.GetVerb(Index: Integer): string;
begin
  Result:=Inherited GetVerb(Index);
  if Index=(Inherited GetVerbCount)+0 then
  begin
    Result := Langs_SetPicture[LangKind];
  end;
end;

function TSkinImageEditor.GetVerbCount: Integer;
begin
  Result := (Inherited GetVerbCount)+1;
end;



end.
