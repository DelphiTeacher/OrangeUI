unit Unit12;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uUIFunction,
  TestAddPictureListSubFrame,

  StrUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox,
  uSkinFireMonkeyControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListBoxType, uSkinFireMonkeyListBox,
  uSkinButtonType, uSkinFireMonkeyButton;

type
  TForm12 = class(TForm)
    btnAddPictureList: TSkinFMXButton;
    procedure btnAddPictureListClick(Sender: TObject);
    { Private declarations }
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

{$R *.fmx}


procedure TForm12.btnAddPictureListClick(Sender: TObject);
begin
  ShowFrame(TFrame(GlobalTestAddPictureListSubFrame),TFrameTestAddPictureListSub);
end;

end.
