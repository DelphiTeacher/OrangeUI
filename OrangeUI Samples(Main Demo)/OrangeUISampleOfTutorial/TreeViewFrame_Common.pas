//convert pas to utf8 by ¥

unit TreeViewFrame_Common;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uLang,
  uFrameContext,
  uBaseLog,
  uSkinButtonType,
  uDrawPicture,
  uSkinImageList,

  uDrawCanvas,
  uSkinTreeViewType,
  uSkinItems,

  uSkinFireMonkeyLabel, uSkinFireMonkeyImage, uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyListBox, uSkinFireMonkeyTreeView,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyButton,
  FMX.Controls.Presentation, FMX.Edit, uSkinFireMonkeyEdit,
  uSkinFireMonkeyVirtualList, FMX.TabControl, uSkinFireMonkeyCustomList,
  uSkinLabelType, uSkinImageType, uSkinItemDesignerPanelType,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uBaseSkinControl, uSkinPanelType;

type
  TFrameTreeView_Common = class(TFrame,IFrameChangeLanguageEvent)
    imglistHead: TSkinImageList;
    imglistExpanded: TSkinImageList;
    imglistNetworkState: TSkinImageList;
    pnlBottomBar: TSkinFMXPanel;
    btnInsert: TSkinFMXButton;
    btnAdd: TSkinFMXButton;
    pnlClient: TSkinFMXPanel;
    tvContactor: TSkinFMXTreeView;
    ItemContactor: TSkinFMXItemDesignerPanel;
    imgMessageHead: TSkinFMXImage;
    lblMessageNickName: TSkinFMXLabel;
    lblMessageDetail: TSkinFMXLabel;
    imgMessageNetworkState: TSkinFMXImage;
    ItemGroup: TSkinFMXItemDesignerPanel;
    imgGroupExpanded: TSkinFMXImage;
    lblGroupName: TSkinFMXLabel;
    lblGroupFriendCount: TSkinFMXLabel;
    pnlBottomBar1: TSkinFMXPanel;
    btnClear: TSkinFMXButton;
    btnDelete: TSkinFMXButton;
    btnExpand: TSkinFMXButton;
    btnCollapse: TSkinFMXButton;
    btnChangeParent: TSkinFMXButton;
    procedure btnExpandClick(Sender: TObject);
    procedure btnCollapseClick(Sender: TObject);
    procedure tvContactorPrepareDrawItem(Sender: TObject; Canvas: TDrawCanvas;
      ItemDesignerPanel: TSkinFMXItemDesignerPanel; Item: TSkinItem;
      ItemRect: TRect);
    procedure imgGroupExpandedClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnChangeParentClick(Sender: TObject);
    procedure pnlBottomBarResize(Sender: TObject);
    procedure pnlBottomBar1Resize(Sender: TObject);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameTreeView }

procedure TFrameTreeView_Common.btnClearClick(Sender: TObject);
begin
  Self.tvContactor.Properties.Items.BeginUpdate;
  try
    Self.tvContactor.Properties.Items.Clear(True);
  finally
    Self.tvContactor.Properties.Items.EndUpdate;
  end;
end;

procedure TFrameTreeView_Common.btnCollapseClick(Sender: TObject);
begin
  Self.tvContactor.Properties.Items.CollapseAll();
end;

procedure TFrameTreeView_Common.btnDeleteClick(Sender: TObject);
var
  DepartGroupItem:TSkinTreeViewItem;
begin
  //模式一:直接释放
  Self.tvContactor.Properties.Items.FindItemByCaption('Customer service').Free;


//  //模式二:节点列表的Delete或Remove
//  DepartGroupItem:=Self.tvContactor.Properties.Items.FindItemByCaption('Customer service');
//  if DepartGroupItem<>nil then
//  begin
//    DepartGroupItem.Childs.Delete(0);
//  end;
end;

procedure TFrameTreeView_Common.btnExpandClick(Sender: TObject);
begin
  Self.tvContactor.Properties.Items.ExpanedAll();
end;

procedure TFrameTreeView_Common.btnInsertClick(Sender: TObject);
var
  EmpItem:TSkinTreeViewItem;
begin
  //插入模式一:设置Parent
  EmpItem:=TSkinTreeViewItem.Create;//(nil);
  EmpItem.Caption:='Staff';
  EmpItem.Detail:='Mode1:set Parent';
  EmpItem.Icon.ImageIndex:=4;
  EmpItem.Parent:=Self.tvContactor.Properties.Items.FindItemByCaption('Customer service');


  //插入模式二:Childs.Add
  EmpItem:=Self.tvContactor.Properties.Items.FindItemByCaption('Customer service').Childs.Add;
  EmpItem.Caption:='Staff';
  EmpItem.Detail:='Mode2:Childs.Add';
  EmpItem.Icon.ImageIndex:=4;
end;

procedure TFrameTreeView_Common.btnAddClick(Sender: TObject);
var
  DepartGroupItem:TSkinTreeViewItem;
  DepartItem:TSkinTreeViewItem;
  EmpItem:TSkinTreeViewItem;
  I: Integer;
begin
  Self.tvContactor.Properties.Items.BeginUpdate;
  try

    Self.tvContactor.Properties.Items.Clear(True);

    DepartGroupItem:=Self.tvContactor.Properties.Items.Add;
    DepartGroupItem.Caption:='My Company';
    DepartGroupItem.IsParent:=True;
    DepartGroupItem.Expanded:=True;

    EmpItem:=DepartGroupItem.Childs.Add;
    EmpItem.Caption:='Boss';
    EmpItem.Detail:='I''m Boss!';
    EmpItem.Icon.ImageIndex:=1;


    DepartItem:=DepartGroupItem.Childs.Add;
    DepartItem.Caption:='Marketing';
    DepartItem.Expanded:=True;
    DepartItem.IsParent:=True;


    EmpItem:=DepartItem.Childs.Add;
    EmpItem.Caption:='Salesman1';
    EmpItem.Detail:='Study hard!';
    EmpItem.Icon.ImageIndex:=4;

    EmpItem:=DepartItem.Childs.Add;
    EmpItem.Caption:='Salesman2';
    EmpItem.Detail:='Hi,Market!';
    EmpItem.Icon.ImageIndex:=3;


    DepartItem:=DepartGroupItem.Childs.Add;
    DepartItem.Caption:='Development';
    DepartItem.Expanded:=True;
    DepartItem.IsParent:=True;

    EmpItem:=DepartItem.Childs.Add;
    EmpItem.Caption:='Programmer1';
    EmpItem.Detail:='Hello world！';
    EmpItem.Icon.ImageIndex:=4;


    EmpItem:=DepartItem.Childs.Add;
    EmpItem.Caption:='Programmer2';
    EmpItem.Detail:='Hello delphi!';
    EmpItem.Icon.ImageIndex:=3;


    DepartItem:=DepartGroupItem.Childs.Add;
    DepartItem.Caption:='Customer service';
    DepartItem.Expanded:=True;
    DepartItem.IsParent:=True;

    EmpItem:=DepartItem.Childs.Add;
    EmpItem.Caption:='Staff1';
    EmpItem.Detail:='Glad to serve you！';
    EmpItem.Icon.ImageIndex:=4;

    DepartItem:=DepartGroupItem.Childs.Add;
    DepartItem.Caption:='TestDepart';
    DepartItem.Expanded:=True;
    DepartItem.IsParent:=True;

    for I := 1 to 100 do
    begin
      EmpItem:=TSkinTreeViewItem.Create;//(nil);
      EmpItem.Caption:='Tester'+' '+IntToStr(I);
      EmpItem.Detail:='Hi！';
      EmpItem.Icon.ImageIndex:=4;
      EmpItem.Parent:=Self.tvContactor.Properties.Items.FindItemByCaption('TestDepart');
    end;


  finally
    Self.tvContactor.Properties.Items.EndUpdate;
  end;

end;

procedure TFrameTreeView_Common.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.btnAdd.Text:=GetLangString(Self.btnAdd.Name,ALangKind);
  Self.btnDelete.Text:=GetLangString(Self.btnDelete.Name,ALangKind);
  Self.btnInsert.Text:=GetLangString(Self.btnInsert.Name,ALangKind);
  Self.btnChangeParent.Text:=GetLangString(Self.btnChangeParent.Name,ALangKind);

  Self.btnClear.Text:=GetLangString(Self.btnClear.Name,ALangKind);
  Self.btnExpand.Text:=GetLangString(Self.btnExpand.Name,ALangKind);
  Self.btnCollapse.Text:=GetLangString(Self.btnCollapse.Name,ALangKind);
end;

constructor TFrameTreeView_Common.Create(AOwner: TComponent);
begin
  inherited;

  if LangKind=lkEN then
  begin
    //清空列表
    Self.tvContactor.Prop.Items.Clear(True);
    Self.btnAdd.Click;
  end;


  //初始多语言
  RegLangString(Self.btnAdd.Name,[Self.btnAdd.Text,'Add']);
  RegLangString(Self.btnDelete.Name,[Self.btnDelete.Text,'Del']);
  RegLangString(Self.btnInsert.Name,[Self.btnInsert.Text,'Insert']);
  RegLangString(Self.btnChangeParent.Name,[Self.btnChangeParent.Text,'ChangeParent']);

  RegLangString(Self.btnClear.Name,[Self.btnClear.Text,'Clear']);
  RegLangString(Self.btnExpand.Name,[Self.btnExpand.Text,'Expand']);
  RegLangString(Self.btnCollapse.Name,[Self.btnCollapse.Text,'Collapse']);


  Self.tvContactor.Prop.ListLayoutsManager.GetVisibleItemsCount;

end;


procedure TFrameTreeView_Common.imgGroupExpandedClick(Sender: TObject);
begin
  Self.tvContactor.Properties.InteractiveItem.Expanded:=
    not  Self.tvContactor.Properties.InteractiveItem.Expanded;
end;

procedure TFrameTreeView_Common.pnlBottomBarResize(Sender: TObject);
begin
  Self.btnAdd.Width:=Self.pnlBottomBar.Width/5;
  Self.btnDelete.Width:=Self.pnlBottomBar.Width/5;
  Self.btnInsert.Width:=Self.pnlBottomBar.Width/5;
  Self.btnChangeParent.Width:=Self.pnlBottomBar.Width/5*2;
end;

procedure TFrameTreeView_Common.pnlBottomBar1Resize(Sender: TObject);
begin
  Self.btnClear.Width:=Self.pnlBottomBar1.Width/3;
  Self.btnCollapse.Width:=Self.pnlBottomBar1.Width/3;
  Self.btnExpand.Width:=Self.pnlBottomBar1.Width/3;

end;

procedure TFrameTreeView_Common.btnChangeParentClick(Sender: TObject);
begin
  //改父节点
  Self.tvContactor.Properties.Items[0].Childs[1].Childs[0].Parent:=
    Self.tvContactor.Properties.Items[0];
end;

procedure TFrameTreeView_Common.tvContactorPrepareDrawItem(Sender: TObject;
  Canvas: TDrawCanvas; ItemDesignerPanel: TSkinFMXItemDesignerPanel;
  Item: TSkinItem; ItemRect: TRect);
begin

  if Item.Caption='Boss' then
  begin
    //如果节点的标题是老板,那么红色字体
    Self.lblMessageNickName.SelfOwnMaterialToDefault.DrawCaptionParam.DrawFont.FontColor.Color:=TAlphaColorRec.Red;
  end
  else
  begin
    Self.lblMessageNickName.SelfOwnMaterialToDefault.DrawCaptionParam.DrawFont.FontColor.Color:=TAlphaColorRec.Black;
  end;

end;

end.
