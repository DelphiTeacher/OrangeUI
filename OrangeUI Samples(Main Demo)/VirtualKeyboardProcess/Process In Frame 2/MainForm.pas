unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  uUIFunction,
  uComponentType,
  LoginFrame,
  uBaseLog,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel;

type
  TfrmMain = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

procedure TfrmMain.FormShow(Sender: TObject);
var
  ALoginFrame:TFrameLogin;
begin
//
//  //ÐÞ¸´AndroidÏÂµÄÐéÄâ¼üÅÌÒþ²ØºÍÏÔÊ¾
//  GetGlobalVirtualKeyboardFixer.StartSync(Self);

  ALoginFrame:=TFrameLogin.Create(Self);
  ALoginFrame.Parent:=Self;
  ALoginFrame.Align:=TAlignLayout.Client;
end;

procedure TfrmMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
begin
//  uBaseLog.OutputDebugString('TfrmMain.FormVirtualKeyboardHidden');
//  CallSubFrameVirtualKeyboardHidden(Sender,Self,KeyboardVisible,Bounds);
end;

procedure TfrmMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
begin
//  uBaseLog.OutputDebugString('TfrmMain.FormVirtualKeyboardShown');
//  CallSubFrameVirtualKeyboardShown(Sender,Self,KeyboardVisible,Bounds);
end;

end.
