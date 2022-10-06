//convert pas to utf8 by ¥

unit ClassFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinItems,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyVirtualList, uSkinFireMonkeyListBox, uSkinFireMonkeyListView,
  uSkinFireMonkeyDirectUIParent, uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollBox, uSkinFireMonkeyButton, uSkinMaterial,
  uSkinScrollControlType, uSkinVirtualListType, uSkinListBoxType,
  uSkinCustomListType, uSkinFireMonkeyCustomList, uDrawCanvas, uSkinButtonType,
  uSkinScrollBoxContentType, uSkinScrollBoxType, uSkinPanelType;

type
  TFrameClass = class(TFrame)
    pnlWeek: TSkinFMXPanel;
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    lbMonday: TSkinFMXListBox;
    lbWeek: TSkinFMXListBox;
    pnlToolBar: TSkinFMXPanel;
    btnMode: TSkinFMXButton;
    btnAdd: TSkinFMXButton;
    lbTuesday: TSkinFMXListBox;
    lbWednesday: TSkinFMXListBox;
    lbThursday: TSkinFMXListBox;
    lbFriday: TSkinFMXListBox;
    lbSaturday: TSkinFMXListBox;
    lbSunday: TSkinFMXListBox;
    lbIndex: TSkinFMXListBox;
    procedure sbClientHorzScrollBarChange(Sender: TObject);
    procedure lbWeekHorzScrollBarChange(Sender: TObject);
    procedure lbIndexVertScrollBarChange(Sender: TObject);
    procedure sbClientVertScrollBarChange(Sender: TObject);
    procedure lbWeekClickItem(Sender: TSkinItem);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalClassFrame:TFrameClass;

implementation

{$R *.fmx}

{ TFrameClass }

constructor TFrameClass.Create(AOwner: TComponent);
begin
  inherited;
  Self.sbClient.Prop.HorzControlGestureManager.IsNeedDecideFirstGestureKind:=True;

end;

procedure TFrameClass.lbWeekClickItem(Sender: TSkinItem);
var
  ListBoxArray:Array[0..6] of TSkinFMXListBox;
  I: Integer;
begin
  ListBoxArray[0]:=Self.lbMonday;
  ListBoxArray[1]:=Self.lbTuesday;
  ListBoxArray[2]:=Self.lbWednesday;
  ListBoxArray[3]:=Self.lbThursday;
  ListBoxArray[4]:=Self.lbFriday;
  ListBoxArray[5]:=Self.lbSaturday;
  ListBoxArray[6]:=Self.lbSunday;

  for I := 0 to Length(ListBoxArray)-1 do
  begin
    //设置选中列表项的ListBox的宽度
    if I=TSkinItem(Sender).Index then
    begin
      ListBoxArray[I].Width:=120;
    end
    else
    begin
      ListBoxArray[I].Width:=60;
    end;
  end;


end;

procedure TFrameClass.lbWeekHorzScrollBarChange(Sender: TObject);
begin
  //星期水平滚动的时候,课也要能水平滚
  if Self.sbClient<>nil then
  begin
    Self.sbClient.HorzScrollBar.OnChange:=nil;
    Self.sbClient.HorzScrollBar.Prop.Position:=Self.lbWeek.HorzScrollBar.Prop.Position;
    Self.sbClient.HorzScrollBar.OnChange:=Self.sbClientHorzScrollBarChange;
  end;
end;

procedure TFrameClass.sbClientHorzScrollBarChange(Sender: TObject);
begin
  //课水平滚动的时候,星期也要能水平滚动
  if Self.lbWeek<>nil then
  begin
    Self.lbWeek.HorzScrollBar.OnChange:=nil;
    Self.lbWeek.HorzScrollBar.Prop.Position:=Self.sbClient.HorzScrollBar.Prop.Position;
    Self.lbWeek.HorzScrollBar.OnChange:=Self.lbWeekHorzScrollBarChange;
  end;
end;

procedure TFrameClass.sbClientVertScrollBarChange(Sender: TObject);
begin
  //课垂直滚动的时候,节也要能垂直滚动
  if Self.lbIndex<>nil then
  begin
    Self.lbIndex.VertScrollBar.OnChange:=nil;
    Self.lbIndex.VertScrollBar.Prop.Position:=Self.sbClient.VertScrollBar.Prop.Position;
    Self.lbIndex.VertScrollBar.OnChange:=Self.lbIndexVertScrollBarChange;
  end;

end;

procedure TFrameClass.lbIndexVertScrollBarChange(Sender: TObject);
begin
  //节垂直滚动的时候,课也要垂直滚
  if Self.sbClient<>nil then
  begin
    Self.sbClient.VertScrollBar.OnChange:=nil;
    Self.sbClient.VertScrollBar.Prop.Position:=Self.lbIndex.VertScrollBar.Prop.Position;
    Self.sbClient.VertScrollBar.OnChange:=Self.sbClientVertScrollBarChange;
  end;
end;

end.
