unit GridSwitchPageFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, Types,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, uSkinWindowsControl,
  uSkinButtonType, Vcl.ExtCtrls, uSkinWindowsEdit, uManager, uOpenClientCommon,
  uJsonToDataset, XSuperObject, System.StrUtils,


  uWaitingForm,
  EasyServiceCommonMaterialDataMoudle_VCL,

  //kbmMemTable,
  uRestInterfaceCall, DateUtils, Data.Win.ADODB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, uRestIntfMemTable, dxGDIPlusClasses, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit,
  dxSkinsCore, cxLabel, dxSkinsDefaultPainters, cxTextEdit, cxMaskEdit,
  cxDropDownEdit;

type
  TFrameGridSwitchPage = class(TFrame)
    btnFirstPage: TSkinWinButton;
    btnRefresh: TSkinWinButton;
    btnLastPage: TSkinWinButton;
    btnNextPage: TSkinWinButton;
    btnPriorPage: TSkinWinButton;
    Label1: TLabel;
    edtPageIndex: TcxTextEdit;
    Label2: TLabel;
    cmbPageSize: TcxComboBox;
    Label3: TLabel;
    lblPageCount: TLabel;
    Label5: TLabel;
    pnlClient: TPanel;
    procedure btnFirstPageClick(Sender: TObject);
    procedure btnPriorPageClick(Sender: TObject);
    procedure btnNextPageClick(Sender: TObject);
    procedure btnLastPageClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure edtPageIndexKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FRestMemTable1: TRestMemTable;
    procedure DoRestMemTableChange(Sender:TObject);

//    procedure DoRestMemTableExecuteBegin(Sender:TObject);
//    procedure DoRestMemTableExecuteEnd(Sender:TObject);

    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    procedure Load(ARestMemTable1: TRestMemTable);
    { Public declarations }
  end;

implementation

//uses
//  HomeForm;

{$R *.dfm}

{ TFrameGridSwitchPage }

procedure TFrameGridSwitchPage.btnFirstPageClick(Sender: TObject);
begin
  FRestMemTable1.GetFirstPage;
end;

procedure TFrameGridSwitchPage.btnLastPageClick(Sender: TObject);
begin
  FRestMemTable1.GetLastPage;

end;

procedure TFrameGridSwitchPage.btnNextPageClick(Sender: TObject);
begin
  FRestMemTable1.GetNextPage;

end;

procedure TFrameGridSwitchPage.btnPriorPageClick(Sender: TObject);
begin
  FRestMemTable1.GetPriorPage;

end;

procedure TFrameGridSwitchPage.btnRefreshClick(Sender: TObject);
begin
  FRestMemTable1.Refresh;

end;

constructor TFrameGridSwitchPage.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TFrameGridSwitchPage.Destroy;
begin

  inherited;
end;

procedure TFrameGridSwitchPage.DoRestMemTableChange(Sender: TObject);
begin
  Self.edtPageIndex.Text:=IntToStr(FRestMemTable1.PageIndex);
  Self.lblPageCount.Caption:=IntToStr(FRestMemTable1.PageCount);
  Self.cmbPageSize.Text:=IntToStr(FRestMemTable1.PageSize);

//  if Self.FRestMemTable1.PageCount=0 then
//  begin
//    Self.btnFirstPage.Enabled:=False;
//    Self.btnPriorPage.Enabled:=False;
//    Self.btnNextPage.Enabled:=False;
//    Self.btnLastPage.Enabled:=False;
//  end
//  else
//  begin
//
//  end;


end;
//
//procedure TFrameGridSwitchPage.DoRestMemTableExecuteBegin(Sender: TObject);
//begin
//  ShowWaitingFrame(nil,'Мгдижа');
//end;
//
//procedure TFrameGridSwitchPage.DoRestMemTableExecuteEnd(Sender: TObject);
//begin
//  HideWaitingFrame;
//end;

procedure TFrameGridSwitchPage.edtPageIndexKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=13 then
  begin
    FRestMemTable1.PageIndex:=StrToInt(Self.edtPageIndex.Text);
    FRestMemTable1.Refresh;
  end;
end;

procedure TFrameGridSwitchPage.Load(ARestMemTable1: TRestMemTable);
begin
  FRestMemTable1:=ARestMemTable1;
  FRestMemTable1.OnChange:=DoRestMemTableChange;
//  FRestMemTable1.OnExecuteBegin:=DoRestMemTableExecuteBegin;
//  FRestMemTable1.OnExecuteEnd:=DoRestMemTableExecuteEnd;

end;

end.

