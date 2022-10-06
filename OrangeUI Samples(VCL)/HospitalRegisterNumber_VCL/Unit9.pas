unit Unit9;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uDrawCanvas, uSkinItems,

  EasyServiceCommonMaterialDataMoudle_VCL,
  ListItemStyle_HospitalDoctorForRegisterNumber,
  ListItemStyle_ClassifyHasSelectedEffect,
  ListItemStyle_TreeMainMenu,
  ListItemStyle_TreeMainMenuItem,


  uSkinListViewType, uSkinWindowsControl, uSkinScrollControlType,
  uSkinCustomListType, uSkinVirtualListType, uSkinTreeViewType, uSkinLabelType,
  uSkinItemDesignerPanelType, Vcl.ExtCtrls, 
  uSkinButtonType, Vcl.StdCtrls, uSkinPanelType, uSkinListBoxType;

type
  TForm9 = class(TForm)
    trvwMenu: TSkinWinTreeView;
    lbDoctors: TSkinWinListView;
    SkinWinPanel1: TSkinWinPanel;
    Label1: TLabel;
    Label2: TLabel;
    lblPageCount: TLabel;
    Label5: TLabel;
    btnFirstPage: TSkinWinButton;
    btnRefresh: TSkinWinButton;
    btnLastPage: TSkinWinButton;
    btnNextPage: TSkinWinButton;
    btnPriorPage: TSkinWinButton;
    Button1: TButton;
    SkinWinButton1: TSkinWinButton;
    SkinWinTreeView1: TSkinWinListBox;
    Button3: TButton;
    SkinWinTreeView2: TSkinWinTreeView;
    procedure FormCreate(Sender: TObject);
    procedure trvwMenuClickItem(AItem: TSkinItem);
    procedure lbDoctorsClickItem(AItem: TSkinItem);
    procedure Button1Click(Sender: TObject);
    procedure trvwMenuClick(Sender: TObject);
    procedure SkinWinButton1Click(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form9: TForm9;

implementation

{$R *.dfm}

procedure TForm9.btnLoginClick(Sender: TObject);
begin
//  ShowMessage('Hello');

end;

procedure TForm9.Button1Click(Sender: TObject);
begin
//  ShowMessage('Hello');
end;

procedure TForm9.FormCreate(Sender: TObject);
var
  ASkinItem:TSkinItem;
  I: Integer;
begin
//  Self.lbDoctors.Prop.Items[0].SubItems.Values['ҽ������']:='����';
//  Self.lbDoctors.Prop.Items[0].IsBufferNeedChange:=True;

  //��ʹ�û���,ֻ��һ������
//  Self.lbDoctors.Prop.FDefaultItemStyleSetting.IsUseCache:=False;
//  Self.trvwMenu.Prop.FDefaultItemStyleSetting.IsUseCache:=False;
//  Self.SkinWinTreeView1.Prop.FDefaultItemStyleSetting.IsUseCache:=False;

//  Self.lbDoctors.Visible:=False;
//  Self.trvwMenu.Visible:=False;
//  Self.SkinWinTreeView1.Visible:=False;



//  SkinWinTreeView2.Prop.FDefaultItemStyleSetting.IsUseCache:=False;
//  SkinWinTreeView2.Prop.FParentItemStyleSetting.IsUseCache:=False;
//  SkinWinTreeView2.Prop.ParentTypeItemStyle:='TreeMainMenuItem';




  Self.lbDoctors.Prop.Items.BeginUpdate;
  try
    Self.lbDoctors.Prop.Items.Clear(True);


    lbDoctors.Prop.Item1ItemStyle:='TreeMainMenuItem';
    ASkinItem:=Self.lbDoctors.Prop.Items.Add;
//    ASkinItem.ItemType:=sitItem1;

    ASkinItem.SubItems.Values['ҽ������']:='����ǿ'+IntToStr(-1);
    ASkinItem.SubItems.Values['ְ��']:='ר��';
    ASkinItem.SubItems.Values['���']:='24.00';
    ASkinItem.SubItems.Values['�ѹ��˴�']:='15';
    ASkinItem.SubItems.Values['ʣ���˴�']:='35';
    ASkinItem.SubItems.Values['����ʱ��']:='����';



    for I := 0 to 10000 do
    begin
      ASkinItem:=Self.lbDoctors.Prop.Items.Add;

      ASkinItem.SubItems.Values['ҽ������']:='����ǿ'+IntToStr(I);
      ASkinItem.SubItems.Values['ְ��']:='ר��';
      ASkinItem.SubItems.Values['���']:='24.00';
      ASkinItem.SubItems.Values['�ѹ��˴�']:='15';
      ASkinItem.SubItems.Values['ʣ���˴�']:='35';
      ASkinItem.SubItems.Values['����ʱ��']:='����';
    end;

  finally
    Self.lbDoctors.Prop.Items.EndUpdate();
  end;


  Self.trvwMenu.Prop.Items.BeginUpdate;
  try
    Self.trvwMenu.Prop.Items.Clear(True);
    for I := 0 to 10000 do
    begin
      ASkinItem:=Self.trvwMenu.Prop.Items.Add;
      ASkinItem.Caption:='����'+IntToStr(I);
    end;


  finally
    Self.trvwMenu.Prop.Items.EndUpdate();
  end;


  Self.SkinWinTreeView1.Prop.Items.BeginUpdate;
  try
    Self.SkinWinTreeView1.Prop.Items.Clear(True);
    for I := 0 to 10000 do
    begin
      ASkinItem:=Self.SkinWinTreeView1.Prop.Items.Add;
      ASkinItem.Caption:='����'+IntToStr(I);
    end;


  finally
    Self.SkinWinTreeView1.Prop.Items.EndUpdate();
  end;

end;

procedure TForm9.lbDoctorsClickItem(AItem: TSkinItem);
begin
  ShowMessage(AItem.SubItems.Values['ҽ������']);

end;

procedure TForm9.SkinWinButton1Click(Sender: TObject);
begin
  ShowMessage('Hello');

end;

procedure TForm9.trvwMenuClick(Sender: TObject);
begin
//  ShowMessage('trvwMenuClick');
end;

procedure TForm9.trvwMenuClickItem(AItem: TSkinItem);
begin
//  ShowMessage(AItem.Caption);
end;

end.
