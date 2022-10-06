unit EditFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,

  EasyServiceCommonMaterialDataMoudle_VCL,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uSkinWindowsEdit,
  Vcl.StdCtrls;

type
  TFrameEdit = class(TFrame)
    Edit1: TEdit;
    SkinWinEdit1: TSkinWinEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
