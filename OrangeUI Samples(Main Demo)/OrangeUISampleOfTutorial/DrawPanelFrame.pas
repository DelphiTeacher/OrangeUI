//convert pas to utf8 by ¥

unit DrawPanelFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uLang,
  uFrameContext,
  uSkinItems,
  uDrawCanvas,
  uUIFunction,
  uSkinPicture,
  uSkinDrawPanelType,
  uSkinFireMonkeyItemDesignerPanel,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyDrawPanel, uSkinFireMonkeyControl, uSkinFireMonkeyLabel,
  uSkinFireMonkeyPanel, uSkinFireMonkeyButton, FMX.Controls.Presentation,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListView, uSkinMaterial, uSkinButtonType,
  uSkinFireMonkeyCustomList, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListViewType, uSkinPanelType, uBaseSkinControl;

type
  TFrameDrawPanel = class(TFrame,IFrameChangeLanguageEvent)
    dpDraw: TSkinFMXDrawPanel;
    pnlButtons: TSkinFMXPanel;
    lvLineColor: TSkinFMXListView;
    pnlLIneWidth: TSkinFMXPanel;
    tbLineWidth: TTrackBar;
    pnlToolBar: TSkinFMXPanel;
    btnRedo: TSkinFMXButton;
    btnUndo: TSkinFMXButton;
    bdmReturnButton: TSkinButtonDefaultMaterial;
    btnReturn: TSkinFMXButton;
    btnSave: TSkinFMXButton;
    pnlLineSetting: TSkinFMXPanel;
    btnClear: TSkinFMXButton;
    procedure lvLineColorClickItem(Sender: TSkinItem);
    procedure tbLineWidthChange(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnRedoClick(Sender: TObject);
    procedure btnUndoClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    procedure ChangeLanguage(ALangKind:TLangKind);
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
  public
    procedure SyncPen;
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalDrawPanelFrame:TFrameDrawPanel;

implementation

{$R *.fmx}

const
  ColorArray:Array [0..9] of TAlphaColor=
      (TAlphaColorRec.Black,$FFF3C639,$FFFE7322,$FFE92C40,$FFC61317,
      TAlphaColorRec.White,$FF508B17,$FF2595AB,$FF0A5193,$FF4A2E9D)
          ;

procedure TFrameDrawPanel.btnClearClick(Sender: TObject);
begin
  Self.dpDraw.Properties.Clear;
end;

procedure TFrameDrawPanel.btnRedoClick(Sender: TObject);
begin
  Self.dpDraw.Properties.Redo;

end;

procedure TFrameDrawPanel.btnReturnClick(Sender: TObject);
begin
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;
  //返回
  HideFrame;////(CurrentFrame,hfcttBeforeReturnFrame);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameDrawPanel.btnSaveClick(Sender: TObject);
//var
//  ASkinPicture:TSkinPicture;
begin
  //保存
  if Self.dpDraw.Properties.DrawPathDataList.Count>0 then
  begin

//    {$IFDEF MSWINDOWS}
//    ASkinPicture:=TSkinDrawPanelType(Self.dpDraw.SkinControlType).CombinePicture();
//    ASkinPicture.SaveToFile('E:\Test.png');
//    Self.dpDraw.Prop.Picture.Assign(ASkinPicture);
//    FreeAndNil(ASkinPicture);
//    {$ENDIF}

    //修改过了
    //返回
    HideFrame;////(Self,hfcttBeforeReturnFrame);
    ReturnFrame;//(FrameHistroy);
  end
  else
  begin
    btnReturnClick(Sender);
  end;
end;

procedure TFrameDrawPanel.btnUndoClick(Sender: TObject);
begin
  Self.dpDraw.Properties.Undo;
end;

procedure TFrameDrawPanel.ChangeLanguage(ALangKind: TLangKind);
begin
  //翻译
  Self.btnRedo.Text:=GetLangString(Self.btnRedo.Name,ALangKind);
  Self.btnUndo.Text:=GetLangString(Self.btnUndo.Name,ALangKind);
  Self.btnSave.Text:=GetLangString(Self.btnSave.Name,ALangKind);

end;

constructor TFrameDrawPanel.Create(AOwner: TComponent);
begin
  inherited;
  SyncPen;

  Self.btnClear.Visible:=False;

  //初始多语言
  RegLangString(Self.btnRedo.Name,[Self.btnRedo.Text,'Redo']);
  RegLangString(Self.btnUndo.Name,[Self.btnUndo.Text,'Undo']);
  RegLangString(Self.btnSave.Name,[Self.btnSave.Text,'Save']);


end;

procedure TFrameDrawPanel.lvLineColorClickItem(Sender: TSkinItem);
begin
  SyncPen;
end;

procedure TFrameDrawPanel.SyncPen;
begin

  if Self.lvLineColor.Properties.SelectedItem<>nil then
  begin
    Self.pnlLineSetting.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=
      ColorArray[Self.lvLineColor.Properties.SelectedItem.Index];
    Self.dpDraw.SelfOwnMaterialToDefault.DrawLineParam.Color.Color:=
      ColorArray[Self.lvLineColor.Properties.SelectedItem.Index];
  end;

  Self.pnlLineSetting.SelfOwnMaterialToDefault.BackColor.DrawRectSetting.Height:=
    Self.tbLineWidth.Value;
  Self.pnlLineSetting.SelfOwnMaterialToDefault.BackColor.DrawRectSetting.Width:=
    Self.tbLineWidth.Value;
  Self.pnlLineSetting.SelfOwnMaterialToDefault.BackColor.RoundHeight:=
    Self.tbLineWidth.Value/2;
  Self.pnlLineSetting.SelfOwnMaterialToDefault.BackColor.RoundWidth:=
    Self.tbLineWidth.Value/2;
  Self.dpDraw.SelfOwnMaterialToDefault.DrawLineParam.PenWidth:=
    Self.tbLineWidth.Value;
end;

procedure TFrameDrawPanel.tbLineWidthChange(Sender: TObject);
begin
  SyncPen;
end;

end.
