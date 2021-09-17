//convert pas to utf8 by ¥

unit FMX_XE_ConfigDrawPictureSearchPathForm;

interface


uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  uLanguage,
  {$IFDEF VER290}
  FMX.ScrollBox,
  {$ENDIF}
  FMX.Memo,
  FMX.StdCtrls,
  uDrawPicture,
  Windows,
  uLang,
  Registry,
  FMX.Controls.Presentation, FMX.ScrollBox;



type
  TfrmConfigDrawPictureSearchPath = class(TForm)
    memSearchPaths: TMemo;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfigDrawPictureSearchPath: TfrmConfigDrawPictureSearchPath;


implementation

{$R *.fmx}



procedure TfrmConfigDrawPictureSearchPath.btnOKClick(Sender: TObject);
begin
//  WriteFilePictureSearchPathsFromRegistry(Self.memSearchPaths.Lines);
//  FreeAndNil(uDrawPicture.FilePictureSearchPaths);
end;

procedure TfrmConfigDrawPictureSearchPath.FormCreate(Sender: TObject);
//var
//  AStringList:TStringList;
begin
//  AStringList:=TStringList.Create;
//  ReadFilePictureSearchPathsFromRegistry(AStringList);
//  Self.memSearchPaths.Lines.Assign(AStringList);
//  AStringList.Free;

  //翻译
  Self.Caption:=Langs_ConfigResourceSearchPath[LangKind];

  btnOK.Text:=Langs_OK[LangKind];
  btnCancel.Text:=Langs_Cancel[LangKind];
end;

end.
