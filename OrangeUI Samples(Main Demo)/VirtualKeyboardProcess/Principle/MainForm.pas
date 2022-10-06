unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyControl,
  uUIFunction,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyPanel, uSkinFireMonkeyEdit;

type
  TfrmMain = class(TForm)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlVirtualKeyboard: TSkinFMXPanel;
    SkinFMXEdit1: TSkinFMXEdit;
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Self.pnlVirtualKeyboard.Height:=0;


end;

procedure TfrmMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
begin
  Self.pnlVirtualKeyboard.Height:=0;
end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
begin
  Self.pnlVirtualKeyboard.Height:=Bounds.Height;
  Self.sbClient.VertScrollBar.Prop.Position:=
    Self.SkinFMXEdit1.Top
      -(Self.Height-Bounds.Height)
      +Self.SkinFMXEdit1.Height;
end;

end.
