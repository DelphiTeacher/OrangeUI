unit MemoFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  EasyServiceCommonMaterialDataMoudle_VCL,

  uSkinWindowsMemo;

type
  TFrameMemo = class(TFrame)
    SkinWinMemo1: TSkinWinMemo;
    Memo1: TMemo;
    SkinWinMemo2: TSkinWinMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
