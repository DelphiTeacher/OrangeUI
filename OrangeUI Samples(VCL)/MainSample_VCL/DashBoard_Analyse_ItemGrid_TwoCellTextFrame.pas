unit DashBoard_Analyse_ItemGrid_TwoCellTextFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDrawCanvas, uSkinItems,

  //�����ز�ģ��
  EasyServiceCommonMaterialDataMoudle_VCL,

  uSkinWindowsControl, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualGridType, uSkinItemGridType, uSkinPanelType, Vcl.StdCtrls,
  uSkinButtonType;

type
  TFrameItemGrid_TwoCellText = class(TFrame)
    gridData: TSkinWinItemGrid;
    pnlClient: TSkinWinPanel;
    lblCaption: TLabel;
    SkinWinButton1: TSkinWinButton;
    procedure gridDataResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrameItemGrid_TwoCellText.gridDataResize(Sender: TObject);
begin
  //���������ǰ�������,��ôÿ���϶��ߴ�,��Ҫ���¼���
  Self.gridData.Prop.Columns.GetListLayoutsManager.DoItemSizeChange(nil);
end;

end.
