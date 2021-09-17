//convert pas to utf8 by ¥

unit CustomListFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 

  uBaseLog,
  uSkinItems,
  uDrawCanvas,

  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyCustomList, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uSkinFireMonkeyPanel, FMX.ScrollBox, FMX.Memo,
  uSkinFireMonkeyMemo, uSkinPanelType, uBaseSkinControl, uSkinScrollControlType,
  uSkinCustomListType;

type
  TFrameCustomList = class(TFrame)
    SkinFMXCustomList1: TSkinFMXCustomList;
    SkinFMXPanel1: TSkinFMXPanel;
    Button1: TButton;
    SkinFMXEdit1: TSkinFMXEdit;
    Edit1: TEdit;
    Button2: TButton;
    SkinFMXMemo1: TSkinFMXMemo;
    Button3: TButton;
    Memo1: TMemo;
    Button4: TButton;
    Label1: TLabel;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SkinFMXCustomList1StartEditingItem(Sender: TObject;
      AItem: TBaseSkinItem; AEditControl: TFmxObject);
    procedure SkinFMXCustomList1StopEditingItem(Sender: TObject;
      AItem: TBaseSkinItem; AEditControl: TFmxObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrame1 }

procedure TFrameCustomList.Button1Click(Sender: TObject);
begin
  //用FMXEdit来编辑
  Self.SkinFMXCustomList1.Prop.StartEditingItem(
            Self.SkinFMXCustomList1.Prop.Items[1],
            Self.SkinFMXEdit1,
            RectF(100,10,200,40),
            'abc',
            0,0
            );
end;

procedure TFrameCustomList.Button2Click(Sender: TObject);
begin
  //用TEdit来编辑
  Self.SkinFMXCustomList1.Prop.StartEditingItem(
            Self.SkinFMXCustomList1.Prop.Items[2],
            Self.Edit1,
            RectF(100,10,200,40),
            'def',
            0,0
            );
end;

procedure TFrameCustomList.Button3Click(Sender: TObject);
begin
  //用FMXMemo来编辑
  Self.SkinFMXCustomList1.Prop.StartEditingItem(
            Self.SkinFMXCustomList1.Prop.Items[0],
            Self.SkinFMXMemo1,
            RectF(10,10,300,50),
            'hijk',
            0,0
            );
end;

procedure TFrameCustomList.Button4Click(Sender: TObject);
begin
  //用TMemo来编辑
  Self.SkinFMXCustomList1.Prop.StartEditingItem(
            Self.SkinFMXCustomList1.Prop.Items[0],
            Self.Memo1,
            RectF(10,10,300,50),
            'opq',
            0,0
            );
end;

procedure TFrameCustomList.Button5Click(Sender: TObject);
begin
  //用TLabel来编辑
  Self.SkinFMXCustomList1.Prop.StartEditingItem(
            Self.SkinFMXCustomList1.Prop.Items[0],
            Self.Label1,
            RectF(10,10,300,50),
            'opq',
            0,0
            );
end;

constructor TFrameCustomList.Create(AOwner: TComponent);
var
  I: Integer;
  ABaseSkinItem:TBaseSkinItem;
begin
  inherited;

  Self.SkinFMXCustomList1.Prop.Items.BeginUpdate;
  try
    //测试CustomList自定义列表控件
    for I := 0 to 20 do
    begin
      ABaseSkinItem:=TBaseSkinItem(Self.SkinFMXCustomList1.Prop.Items.Add);
      ABaseSkinItem.Height:=60;
    end;
  finally
    Self.SkinFMXCustomList1.Prop.Items.EndUpdate();
  end;

end;

procedure TFrameCustomList.SkinFMXCustomList1StartEditingItem(
  Sender: TObject;
  AItem: TBaseSkinItem;
  AEditControl: TFmxObject);
begin
  uBaseLog.OutputDebugString('SkinFMXCustomList1 Start EditingItem');
end;

procedure TFrameCustomList.SkinFMXCustomList1StopEditingItem(Sender: TObject;
  AItem: TBaseSkinItem; AEditControl: TFmxObject);
begin
  uBaseLog.OutputDebugString('SkinFMXCustomList1 Stop EditingItem');
end;

end.
