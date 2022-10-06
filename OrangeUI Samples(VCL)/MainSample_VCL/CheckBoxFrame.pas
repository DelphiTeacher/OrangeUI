unit CheckBoxFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  EasyServiceCommonMaterialDataMoudle_VCL,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  uSkinWindowsControl, uSkinCheckBoxType;

type
  TFrameCheckBox = class(TFrame)
    CheckBox1: TCheckBox;
    SkinWinCheckBox2: TSkinWinCheckBox;
    SkinWinCheckBox3: TSkinWinCheckBox;
    SkinWinCheckBox4: TSkinWinCheckBox;
    SkinWinCheckBox5: TSkinWinCheckBox;
    SkinWinCheckBox6: TSkinWinCheckBox;
    SkinWinCheckBox7: TSkinWinCheckBox;
    SkinWinCheckBox1: TSkinWinCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
