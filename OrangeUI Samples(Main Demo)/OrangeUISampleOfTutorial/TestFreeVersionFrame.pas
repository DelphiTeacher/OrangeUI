//convert pas to utf8 by ¥

unit TestFreeVersionFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 

  uSkinItems,
  uDrawRectParam,
  uDrawPathParam,
  uDrawPictureParam,
  uGraphicCommon,
  uDrawTextParam,
  uSkinControlGestureManager,
  uSkinVirtualGridType,
  uSkinScrollControlType,
  uSkinItemGridType,
  uSkinFireMonkeyItemGrid,
  uSkinFireMonkeyImage,
  uVersion,

  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyCustomList,
  uSkinFireMonkeyVirtualGrid, FMX.Edit, uBaseSkinControl, uSkinCustomListType,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinImageType, uDrawCanvas, uSkinVirtualListType, uSkinListBoxType,
  uSkinFireMonkeyListBox, uSkinListViewType, uSkinFireMonkeyListView,
  uSkinPageControlType, uSkinFireMonkeyPageControl;

type
  TFrameTestFreeVersion = class(TFrame)
    SkinFMXItemGrid1: TSkinFMXItemGrid;
    Button1: TButton;
    lbDemos: TSkinFMXListBox;
    Button2: TButton;
    SkinFMXListView1: TSkinFMXListView;
    Button3: TButton;
    SkinFMXPageControl1: TSkinFMXPageControl;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameTestFreeVersion }

procedure TFrameTestFreeVersion.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to 100 do
  begin
    Self.SkinFMXItemGrid1.Prop.Items.Add;
  end;
end;

procedure TFrameTestFreeVersion.Button2Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to 1000 do
  begin
    Self.lbDemos.Prop.Items.Add;
  end;
end;

procedure TFrameTestFreeVersion.Button3Click(Sender: TObject);
begin
  Self.SkinFMXListView1.Prop.ViewType:=lvtWaterfall;
end;

procedure TFrameTestFreeVersion.Button4Click(Sender: TObject);
begin
  Self.SkinFMXPageControl1.Prop.CanGesutreSwitch:=True;
end;

constructor TFrameTestFreeVersion.Create(AOwner: TComponent);
begin
  inherited;


  ShowMessage(uVersion.OrangeUIControl_Version);

end;

end.
