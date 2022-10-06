unit FrameParentForm_VCL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,

  uFrameContext,

  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TfrmFrameParent = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFrameParent: TfrmFrameParent;

implementation

{$R *.dfm}


procedure TfrmFrameParent.FormCreate(Sender: TObject);
begin
  //
end;

initialization
  GlobalFrameParentFormClass:=TfrmFrameParent;

end.
