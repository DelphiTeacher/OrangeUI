//convert pas to utf8 by ¥
unit CarDistanceHintFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uUIFunction,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyButton, uSkinFireMonkeyLabel, uSkinFireMonkeyPanel,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl, uSkinFireMonkeyScrollBox,
  FMX.ListBox, uSkinFireMonkeyComboBox, uSkinMaterial, uSkinComboBoxType,
  uSkinButtonType, uSkinLabelType, uSkinPanelType, uSkinScrollBoxContentType,
  uSkinScrollControlType, uSkinScrollBoxType;

type
  TFrameCarDistanceHint = class(TFrame)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlPickTime: TSkinFMXPanel;
    SkinFMXLabel1: TSkinFMXLabel;
    SkinFMXPanel2: TSkinFMXPanel;
    SkinFMXLabel3: TSkinFMXLabel;
    edtGoodName: TSkinFMXEdit;
    SkinFMXPanel7: TSkinFMXPanel;
    SkinFMXLabel6: TSkinFMXLabel;
    SkinFMXPanel12: TSkinFMXPanel;
    SkinFMXLabel16: TSkinFMXLabel;
    SkinFMXPanel13: TSkinFMXPanel;
    SkinFMXLabel17: TSkinFMXLabel;
    edtSender: TSkinFMXEdit;
    SkinFMXPanel14: TSkinFMXPanel;
    SkinFMXLabel19: TSkinFMXLabel;
    SkinFMXPanel15: TSkinFMXPanel;
    SkinFMXLabel21: TSkinFMXLabel;
    btnSend: TSkinFMXButton;
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXLabel2: TSkinFMXLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    SkinFMXComboBox1: TSkinFMXComboBox;
    SkinFMXComboBox2: TSkinFMXComboBox;
    SkinFMXComboBox3: TSkinFMXComboBox;
    SkinFMXComboBox4: TSkinFMXComboBox;
    SkinFMXLabel4: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure SkinFMXButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalCarDistanceHintFrame:TFrameCarDistanceHint;


implementation

{$R *.fmx}

procedure TFrameCarDistanceHint.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);

end;

procedure TFrameCarDistanceHint.btnSendClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);


end;

procedure TFrameCarDistanceHint.SkinFMXButton1Click(Sender: TObject);
begin
  //返回
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);


end;

end.
