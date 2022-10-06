unit ListItemStyleFrame_AccountManage;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,

  uSkinCustomListType,
  EasyServiceCommonMaterialDataMoudle,
  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinMaterial;

type
  TFrameListItemStyle_AccountManage = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgHead: TSkinFMXImage;
    lblName: TSkinFMXLabel;
    btnDelete: TSkinFMXButton;
    SkinFMXPanel1: TSkinFMXPanel;
    lblID: TSkinFMXLabel;
    SkinFMXPanel2: TSkinFMXPanel;
    lblCountry: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    pnlCount: TSkinFMXPanel;
    btnContentCount: TSkinFMXButton;
    btnFansCount: TSkinFMXButton;
    btnCommentCount: TSkinFMXButton;
    btnTransferCount: TSkinFMXButton;
    btnViewCount: TSkinFMXButton;
    pnlFunction: TSkinFMXPanel;
    btnPublish: TSkinFMXButton;
    pnlFunctionDevide1: TSkinFMXPanel;
    btnManage: TSkinFMXButton;
    pnlFunctionDevide2: TSkinFMXPanel;
    btnDataDashboard: TSkinFMXButton;
    btnEdit: TSkinFMXButton;
    procedure pnlCountResize(Sender: TObject);
    procedure pnlFunctionResize(Sender: TObject);
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameListItemStyle_AccountManage }

function TFrameListItemStyle_AccountManage.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

procedure TFrameListItemStyle_AccountManage.pnlCountResize(Sender: TObject);
begin
  //
  btnContentCount.Width:=pnlCount.Width / 5;
  btnFansCount.Width:=pnlCount.Width / 5;
  btnCommentCount.Width:=pnlCount.Width / 5;
  btnTransferCount.Width:=pnlCount.Width / 5;
  btnViewCount.Width:=pnlCount.Width / 5;

end;

procedure TFrameListItemStyle_AccountManage.pnlFunctionResize(Sender: TObject);
begin
  //
  Self.btnPublish.Width:=(Self.pnlFunction.Width-3*Self.pnlFunctionDevide1.Width) / 3;
  Self.btnManage.Width:=(Self.pnlFunction.Width-3*Self.pnlFunctionDevide1.Width) / 3;
  Self.btnDataDashboard.Width:=(Self.pnlFunction.Width-3*Self.pnlFunctionDevide1.Width) / 3;
end;

initialization
  RegisterListItemStyle('AccountManage',TFrameListItemStyle_AccountManage);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_AccountManage);

end.
