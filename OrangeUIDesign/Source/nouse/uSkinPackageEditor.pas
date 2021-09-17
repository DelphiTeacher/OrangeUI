unit uSkinPackageEditor;


interface
{$I FrameWork.inc}

uses
  SysUtils,
  Classes,
  uLanguage,
  uSkinPackage,
  {$IFDEF FMX}
  FMX.Dialogs,
  FMX.Forms,
  FMX_XE_SkinPackageEditorForm,
  {$ENDIF}
  Windows,
  DesignIntf,
  DesignEditors;


type
  TSkinPackageEditor = class( TDefaultEditor )
  public
    procedure Edit; override;
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;

procedure Register;


implementation


procedure Register;
begin
  RegisterComponentEditor(TSkinPackage,TSkinPackageEditor);
end;


{ TSkinPackageEditor }

procedure TSkinPackageEditor.Edit;
var
  APackage: TSkinPackage;
begin
  APackage := TSkinPackage(Component);
  if APackage <> nil then
  begin

    {$IFDEF FMX}
    //µ¯³öÆ¤·ô±à¼­Æ÷
    if frmSkinPackageEditor=nil then
    begin
      frmSkinPackageEditor:=TfrmSkinPackageEditor.Create(Application);
    end;
    frmSkinPackageEditor.LoadSkinPackage(Designer,APackage);
    frmSkinPackageEditor.Show;
    {$ENDIF}

  end;
end;

procedure TSkinPackageEditor.ExecuteVerb(Index: Integer);
var
  APackage: TSkinPackage;
begin
  APackage := TSkinPackage(Component);
  if APackage <> nil then
  begin
    case Index of
      0:
      begin
        Edit;
      end;
    end;
  end;
end;

function TSkinPackageEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := Langs_SkinPackageEditor[LangKind];
  end;
end;

function TSkinPackageEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


end.

