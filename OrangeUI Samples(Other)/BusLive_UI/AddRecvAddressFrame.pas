//convert pas to utf8 by ¥
unit AddRecvAddressFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uUIFunction,
  BusLiveCommonSkinMaterialModule,
  uSkinFireMonkeyButton,
  uSkinFireMonkeyLabel,
  uSkinFireMonkeyPanel,
  uSkinFireMonkeyDirectUIParent,
  uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyComboBox,
  FMX.ListBox,
  uSkinMaterial,
  uSkinComboBoxType,
  uSkinFireMonkeyCheckBox, uSkinButtonType, uSkinCheckBoxType, uSkinLabelType,
  uSkinPanelType, uSkinScrollBoxContentType, uSkinScrollControlType,
  uSkinScrollBoxType;

type
  TFrameAddRecvAddress = class(TFrame)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    pnlName: TSkinFMXPanel;
    lblNameHint: TSkinFMXLabel;
    edtName: TSkinFMXEdit;
    pnlProvince: TSkinFMXPanel;
    lblProvinceHint: TSkinFMXLabel;
    pnlTel: TSkinFMXPanel;
    lblTelHint: TSkinFMXLabel;
    edtTel: TSkinFMXEdit;
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    edtProvince: TSkinFMXEdit;
    pnlAddress: TSkinFMXPanel;
    lblAddressHint: TSkinFMXLabel;
    edtAddress: TSkinFMXEdit;
    pnlPost: TSkinFMXPanel;
    lblPostHint: TSkinFMXLabel;
    edtPost: TSkinFMXEdit;
    pnlDefaultAddress: TSkinFMXPanel;
    chkDefaultAddress: TSkinFMXCheckBox;
    btnSave: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    { Public declarations }
  end;

var
  GlobalAddRecvAddressFrame:TFrameAddRecvAddress;


implementation

{$R *.fmx}

procedure TFrameAddRecvAddress.btnReturnClick(Sender: TObject);
begin
  //返回
  HideFrame;//(Self);
  ReturnFrame;//(FrameHistroy);

end;

procedure TFrameAddRecvAddress.btnSaveClick(Sender: TObject);
begin
  //返回
  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);


end;

end.
