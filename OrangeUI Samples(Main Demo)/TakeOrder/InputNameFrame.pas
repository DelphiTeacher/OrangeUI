//convert pas to utf8 by ¥
unit InputNameFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uUIFunction,

  uManager,
  uTimerTask,
  uInterfaceClass,

  XSuperObject,
  XSuperJson,
  uBaseHttpControl,

  WaitingFrame,
  MessageBoxFrame,
  EasyServiceCommonMaterialDataMoudle,


  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit, uSkinButtonType,
  uSkinPanelType;

type
  TFrameInputName = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    pnlClient: TSkinFMXPanel;
    pnlEmpty: TSkinFMXPanel;
    pnlName: TSkinFMXPanel;
    edtName: TSkinFMXEdit;
    btnOk: TSkinFMXButton;
    procedure btnOkClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure Load(ACaption:String;
                    AHint:String;
                    AHelpText:String;
                    Text:String);
    { Public declarations }
  end;


var
  GlobalInputNameFrame:TFrameInputName;


implementation


{$R *.fmx}

uses
  MainForm;

procedure TFrameInputName.btnOkClick(Sender: TObject);
begin
  HideVirtualKeyboard;

  if Self.edtName.Text='' then
  begin
    ShowMessageBoxFrame(Self,'请输入'+Self.pnlName.Caption+'!','',TMsgDlgType.mtInformation,['确定'],nil);
    Exit;
  end;

  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);

end;

procedure TFrameInputName.btnReturnClick(Sender: TObject);
begin
  //什么也不做
  //清空返回事件,也就是返回的时候不调用它
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;


  HideFrame;////(Self,hfcttBeforeReturnFrame);
  ReturnFrame;//(Self.FrameHistroy);
end;

procedure TFrameInputName.Load(ACaption, AHint, AHelpText, Text: String);
begin
  Self.pnlToolBar.Caption:=ACaption;

  Self.pnlName.Caption:=AHint;
  Self.edtName.TextPrompt:=AHelpText;
  Self.edtName.Text:=Text;

end;

end.
