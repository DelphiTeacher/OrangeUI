//convert pas to utf8 by ¥

unit ListBoxFrame_SortItems;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.StdCtrls,FMX.Controls,  FMX.Forms,
  DateUtils,


  uLang,
  uFrameContext,
  uDrawCanvas,
  uFuncCommon,
  uBaseList,
  uSkinItems,
  uSkinListBoxType,
  uUIFunction,
  uTimerTask,

  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeySwitchBar,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox, uSkinFireMonkeyItemDesignerPanel, uSkinFireMonkeyLabel,
  uSkinFireMonkeyImage, uSkinFireMonkeyPullLoadPanel, FMX.Controls.Presentation,
  uSkinFireMonkeyMultiColorLabel, uSkinFireMonkeyButton, uDrawPicture,
  uSkinImageList, uSkinFireMonkeyCustomList, uSkinImageType, uSkinLabelType,
  uSkinItemDesignerPanelType, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinButtonType, uBaseSkinControl, uSkinPanelType;

type
  TFrameListBox_SortItems = class(TFrame,IFrameChangeLanguageEvent)
    pnlToolBarInner: TSkinFMXPanel;
    imglistFileExtIcon: TSkinImageList;
    lbFileList: TSkinFMXListBox;
    idpFile: TSkinFMXItemDesignerPanel;
    lblFileName: TSkinFMXLabel;
    imgFileIcon: TSkinFMXImage;
    lblFileSize: TSkinFMXLabel;
    lblFileDate: TSkinFMXLabel;
    pnlToolBarCenter: TSkinFMXPanel;
    btnSortBySize: TSkinFMXButton;
    btnSortByDate: TSkinFMXButton;
    btnSortByName: TSkinFMXButton;
    procedure btnSortByNameClick(Sender: TObject);
    procedure btnSortByDateClick(Sender: TObject);
    procedure btnSortBySizeClick(Sender: TObject);
  private
    { Private declarations }
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

implementation



{$R *.fmx}

//按名称升序排序方法
function ListCompareByNameAsc(Item1, Item2: Pointer): Integer;
begin
  Result:=0;
  if TSkinListBoxItem(Item1).Caption>TSkinListBoxItem(Item2).Caption then
  begin
    Result:=1;
  end
  else if TSkinListBoxItem(Item1).Caption<TSkinListBoxItem(Item2).Caption then
  begin
    Result:=-1;
  end;
end;

function ListCompareByDateAsc(Item1, Item2: Pointer): Integer;
begin
  Result:=0;
  if TSkinListBoxItem(Item1).Detail>TSkinListBoxItem(Item2).Detail then
  begin
    Result:=1;
  end
  else if TSkinListBoxItem(Item1).Detail<TSkinListBoxItem(Item2).Detail then
  begin
    Result:=-1;
  end;
end;

function ListCompareBySizeAsc(Item1, Item2: Pointer): Integer;
begin
  Result:=0;
  if TSkinListBoxItem(Item1).Detail1>TSkinListBoxItem(Item2).Detail1 then
  begin
    Result:=1;
  end
  else if TSkinListBoxItem(Item1).Detail1<TSkinListBoxItem(Item2).Detail1 then
  begin
    Result:=-1;
  end;
end;

procedure TFrameListBox_SortItems.btnSortByDateClick(Sender: TObject);
begin
  Self.lbFileList.Properties.Items.Sort(ListCompareByDateAsc);
end;

procedure TFrameListBox_SortItems.btnSortByNameClick(Sender: TObject);
begin
  //按名称排序
  Self.lbFileList.Properties.Items.Sort(ListCompareByNameAsc);
end;

procedure TFrameListBox_SortItems.btnSortBySizeClick(Sender: TObject);
begin
  Self.lbFileList.Properties.Items.Sort(ListCompareBySizeAsc);

end;

procedure TFrameListBox_SortItems.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.btnSortByName.Text:=GetLangString(Self.btnSortByName.Name,ALangKind);
  Self.btnSortByDate.Text:=GetLangString(Self.btnSortByDate.Name,ALangKind);
  Self.btnSortBySize.Text:=GetLangString(Self.btnSortBySize.Name,ALangKind);

end;

constructor TFrameListBox_SortItems.Create(AOwner: TComponent);
begin
  inherited;

  //初始多语言
  RegLangString(Self.btnSortByName.Name,[Self.btnSortByName.Text,'Name']);
  RegLangString(Self.btnSortByDate.Name,[Self.btnSortByDate.Text,'Date']);
  RegLangString(Self.btnSortBySize.Name,[Self.btnSortBySize.Text,'Size']);


end;

end.
