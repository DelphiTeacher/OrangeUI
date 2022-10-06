//convert pas to utf8 by ¥

unit FMX_XE_SkinPictureListPropertyEditorForm;

interface
{$DEFINE MSWINDOWS}

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uBaseLog,
  uDrawPicture,
  uSkinPicture,
  uLanguage,
  uSkinImageList,
  DesignEditors,
  DesignIntf,

  uLang,
//  UITypes,
  FMX.Edit,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.ListBox;

type
  TfrmSkinPictureListPropertyEditor = class(TForm)
    OKButton: TButton;
    CancelButton: TButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Add: TButton;
    Replace: TButton;
    Delete: TButton;
    Clear: TButton;
    ExportPicture: TButton;
    edtImageIndex: TEdit;
    lblImageIndex: TLabel;
    ExportAll: TButton;
    lblImageName: TLabel;
    edtImageName: TEdit;
    lblFileName: TLabel;
    edtFileName: TEdit;
    chkOnlySetFilePath: TCheckBox;
    lblResourceName: TLabel;
    edtResourceName: TEdit;
    edtUrl: TEdit;
    lblUrl: TLabel;
    AddEmpty: TButton;
    SaveSelected: TButton;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    chkIsClipRound: TCheckBox;
    btnClear: TButton;
    procedure AddClick(Sender: TObject);
    procedure ReplaceClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure ExportPictureClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtImageIndexKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure ExportAllClick(Sender: TObject);
    procedure edtImageNameKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtFileNameKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtResourceNameKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure edtUrlKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure AddEmptyClick(Sender: TObject);
    procedure SaveSelectedClick(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure ListBox1DragChange(SourceItem, DestItem: TListBoxItem;
      var Allow: Boolean);
    procedure OKButtonClick(Sender: TObject);
    procedure ListBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnClearClick(Sender: TObject);
  private
    FDrawPicturePersistent:TDrawPicturePersistent;
    FPictureList: TSkinPictureList;
    //更新标题、图标等
    procedure SyncListItemInfo(AListItem:TListBoxItem;APictureIndex:Integer);
    procedure SyncListItem(AListItem:TListBoxItem);
    procedure SyncListBox;
    procedure SetSkinPictureList(const Value: TSkinPictureList);
  public
    FDesigner:IDesigner;
    FComponent:TComponent;
//    FDefaultEditor:TDefaultEditor;
    property PictureList: TSkinPictureList read FPictureList write SetSkinPictureList;
    { Public declarations }
  end;

var
  frmSkinPictureListPropertyEditor: TfrmSkinPictureListPropertyEditor;


implementation



{$R *.fmx}

procedure TfrmSkinPictureListPropertyEditor.AddClick(Sender: TObject);
var
  ListItem:TListBoxItem;
  ListItemIndex:Integer;
  I: Integer;
  AFilePath:String;
  AFileName:String;
  AExistFilePath:String;
  ADrawPicture:TDrawPicture;
begin
  OpenDialog.Title := Langs_Add[LangKind];
  OpenDialog.Options:=OpenDialog.Options+[TOpenOption.ofAllowMultiSelect];
  if OpenDialog.Execute then
  begin
      AExistFilePath:=ExtractFilePath(OpenDialog.FileName);
      //如果选择的文件不存在,会有这种异常出现
      //比如我选的是C:\cc\aa.png,然后它返回C:\ccaa.png
      if Not FileExists(OpenDialog.FileName) then
      begin
        //检测路径所在
        AFilePath:=ExtractFilePath(OpenDialog.FileName);
        AFileName:=ExtractFileName(OpenDialog.FileName);

        for I := 1 to Length(AFileName) do
        begin
          if FileExists(AFilePath+Copy(AFileName,1,I)+'\'+Copy(AFileName,I+1,MaxInt)) then
          begin
            AExistFilePath:=AFilePath+Copy(AFileName,1,I)+'\';
            Break;
          end;
        end;

      end;


      for I := 0 to OpenDialog.Files.Count - 1 do
      begin
        //在XP下有问题,最后一个文件夹没有带/
        AFileName:=OpenDialog.Files[I];

        AFileName:=AExistFilePath+Copy(AFileName,Length(AExistFilePath),MaxInt);


        if not chkOnlySetFilePath.IsChecked then
        begin
          FPictureList.AddPictureFile(AFileName);
        end
        else
        begin
          //只设置文件名
          FPictureList.AddFileNameOnly(AFileName);
        end;
        ADrawPicture:=FPictureList[FPictureList.Count-1];

        //把文件名当做ImageName
        AFileName:=ExtractFileName(AFileName);
        AFileName:=Copy(AFileName,1,Length(AFileName)-Length(ExtractFileExt(AFileName)));
        ADrawPicture.ImageName:=AFileName;



        ListItemIndex:=ListBox1.Items.Add('');
        ListItem:=ListBox1.ListItems[ListItemIndex];
        Self.SyncListItem(ListItem);
//        //图标
//        ListItem.ItemData.Bitmap.LoadFromFile(AFileName);
//        //标题
//        ListItem.ItemData.Text:=IntToStr(ListBox1.Items.Count-1)
//                                  +'('+IntToStr(ListItem.ItemData.Bitmap.Width)
//                                  +'*'
//                                  +IntToStr(ListItem.ItemData.Bitmap.Height)+')'
//                                  ;
//        //其他信息
//        ListItem.ItemData.Detail:=FPictureList[FPictureList.Count-1].ImageName
//                                  +#13#10
//                                  +FPictureList[FPictureList.Count-1].FileName
//                                  +#13#10
//                                  +FPictureList[FPictureList.Count-1].Url;



        ListItem.IsSelected:=True;

        Replace.Enabled:=True;
        Delete.Enabled:=True;
        ExportPicture.Enabled:=True;
      end;
  end;
end;

procedure TfrmSkinPictureListPropertyEditor.SaveSelectedClick(Sender: TObject);
var
  Key: Word;
  KeyChar: Char;
begin
  Key:=13;
  KeyChar:=#0;
  //执行保存
  edtImageNameKeyDown(Sender,Key,KeyChar,[]);
  edtFileNameKeyDown(Sender,Key,KeyChar,[]);
  edtResourceNameKeyDown(Sender,Key,KeyChar,[]);
  edtUrlKeyDown(Sender,Key,KeyChar,[]);

  //修改IsClipRound
  if Self.ListBox1.Selected<>nil then
  begin
    Self.FPictureList[Self.ListBox1.Selected.Index].IsClipRound:=Self.chkIsClipRound.IsChecked;
    SyncListItem(Self.ListBox1.Selected);
  end;

  edtImageIndexKeyDown(Sender,Key,KeyChar,[]);
end;

procedure TfrmSkinPictureListPropertyEditor.SetSkinPictureList(const Value: TSkinPictureList);
var
  ListItem:TListBoxItem;
  ListItemIndex:Integer;
  I: Integer;
begin
  FPictureList.Assign(Value);

  Self.ListBox1.Items.Clear;

  for I := 0 to FPictureList.Count - 1 do
  begin
    ListItemIndex:=ListBox1.Items.Add('');
    ListItem:=ListBox1.ListItems[ListItemIndex];
    Replace.Enabled:=True;
    Delete.Enabled:=True;
    ExportPicture.Enabled:=True;
  end;

  Self.SyncListBox;

end;

procedure TfrmSkinPictureListPropertyEditor.SyncListBox;
var
  I: Integer;
begin

  for I := 0 to Self.ListBox1.Items.Count - 1 do
  begin
    SyncListItem(Self.ListBox1.ListItems[I]);
  end;

end;

procedure TfrmSkinPictureListPropertyEditor.SyncListItem(AListItem: TListBoxItem);
begin
  SyncListItemInfo(AListItem,AListItem.Index);
end;

procedure TfrmSkinPictureListPropertyEditor.SyncListItemInfo(AListItem: TListBoxItem; APictureIndex: Integer);
var
  APicture:TDrawPicture;
begin
  APicture:=Self.FPictureList[APictureIndex];

  //图标
  AListItem.ItemData.Bitmap.Assign(APicture.CurrentPicture);
  //标题
  AListItem.ItemData.Text:=IntToStr(APictureIndex)
                            +'('+IntToStr(AListItem.ItemData.Bitmap.Width)
                            +'*'
                            +IntToStr(AListItem.ItemData.Bitmap.Height)+')'
                            ;
  //其他信息
  AListItem.ItemData.Detail:=APicture.ImageName
                            +#13#10
                            +APicture.FileName
        //                      +#13#10
        //                      +APicture.ResourceName
                            +#13#10
                            +APicture.Url;


  //必须有了ItemData.Bitmap,图标才会显示出来
  //所以放在最后
  AListItem.StyleLookup:='listboxitembottomdetail';

end;

procedure TfrmSkinPictureListPropertyEditor.AddEmptyClick(Sender: TObject);
var
  ListItem:TListBoxItem;
  ListItemIndex:Integer;
begin
  //添加一张空图
  FPictureList.Add;

  ListItemIndex:=ListBox1.Items.Add('');
  ListItem:=ListBox1.ListItems[ListItemIndex];
  Self.SyncListItemInfo(ListItem,ListItemIndex);;

  ListItem.IsSelected:=True;
//  ListBox1.Selected:=ListItem;

  Replace.Enabled:=True;
  Delete.Enabled:=True;
  ExportPicture.Enabled:=True;
end;

procedure TfrmSkinPictureListPropertyEditor.btnClearClick(Sender: TObject);
begin
  if Self.ListBox1.Selected<>nil then
  begin
    Self.FDrawPicturePersistent.DrawPicture.ClearPicture;
  end;

end;

procedure TfrmSkinPictureListPropertyEditor.ClearClick(Sender: TObject);
begin
  Self.ListBox1.Items.Clear;
  FPictureList.Clear(True);
  Replace.Enabled := False;
  Delete.Enabled := False;
  Clear.Enabled := False;
  ExportPicture.Enabled := False;
end;

procedure TfrmSkinPictureListPropertyEditor.DeleteClick(Sender: TObject);
var
  SelectedIndex:Integer;
begin
  //删除图片
  if Self.ListBox1.Selected<>nil then
  begin
    SelectedIndex:=Self.ListBox1.Selected.Index;

    Self.ListBox1.Items.Delete(SelectedIndex);

    Self.FPictureList.Delete(SelectedIndex,True);

    Self.SyncListBox;
  end;
end;

procedure TfrmSkinPictureListPropertyEditor.edtFileNameKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  //修改文件名
  if Self.ListBox1.Selected<>nil then
  begin
    Self.FPictureList[Self.ListBox1.Selected.Index].FileName:=Self.edtFileName.Text;
    SyncListItem(Self.ListBox1.Selected);
  end;
end;

procedure TfrmSkinPictureListPropertyEditor.edtImageIndexKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  I:Integer;
  NewIndex:Integer;
  OldIndex:Integer;
  APicture:TSkinPicture;
  ListItem:TListBoxItem;
begin
  //修改下标
  if (Key=13) and (Self.ListBox1.Selected<>nil) then
  begin
    if TryStrToInt(Self.edtImageIndex.Text,NewIndex) then
    begin
      if (NewIndex>=0) and (NewIndex<Self.ListBox1.Items.Count) then
      begin
        OldIndex:=Self.ListBox1.Selected.Index;
        if NewIndex<>OldIndex then
        begin
          APicture:=Self.FPictureList[OldIndex];
          Self.FPictureList.Remove(APicture,False);
          Self.FPictureList.Insert(NewIndex,APicture);

          ListItem:=Self.ListBox1.ListItems[OldIndex];
          ListItem.Index:=NewIndex;

//          Self.ListBox1.Items.Delete(OldIndex);
//          Self.ListBox1.Items.Insert(NewIndex,'');
//          ListItem:=Self.ListBox1.ListItems[NewIndex];

          ListItem.IsSelected:=True;
//          Self.ListBox1.Selected:=ListItem;

          SyncListBox;

        end;
      end;
    end;
  end;
end;

procedure TfrmSkinPictureListPropertyEditor.edtImageNameKeyDown(Sender: TObject;
  var Key: Word;
  var KeyChar: Char;
  Shift: TShiftState);
begin
  //修改ImageName
  if Self.ListBox1.Selected<>nil then
  begin
    Self.FPictureList[Self.ListBox1.Selected.Index].ImageName:=Self.edtImageName.Text;
    SyncListItem(Self.ListBox1.Selected);
  end;
end;

procedure TfrmSkinPictureListPropertyEditor.edtResourceNameKeyDown(
  Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  //修改ResouceName
  if Self.ListBox1.Selected<>nil then
  begin
    Self.FPictureList[Self.ListBox1.Selected.Index].ResourceName:=Self.edtResourceName.Text;
    SyncListItem(Self.ListBox1.Selected);
  end;
end;

procedure TfrmSkinPictureListPropertyEditor.edtUrlKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  //修改URL
  if Self.ListBox1.Selected<>nil then
  begin
    Self.FPictureList[Self.ListBox1.Selected.Index].Url:=Self.edtUrl.Text;
    SyncListItem(Self.ListBox1.Selected);
  end;
end;

procedure TfrmSkinPictureListPropertyEditor.ExportAllClick(Sender: TObject);
var
  I: Integer;
  ASkinPicture:TSkinPicture;
begin
  //导出全部图片
  if Self.ListBox1.Items.Count>0 then
  begin
    SaveDialog.Title := Langs_ExportAll[LangKind];
    SaveDialog.DefaultExt := '.png';
    SaveDialog.Filter := 'PNG (*.png)|*.png';
    if SaveDialog.Execute then
    begin
      for I := 0 to Self.FPictureList.Count-1 do
      begin
        ASkinPicture:=Self.FPictureList[I];
        if Not ASkinPicture.IsEmpty then
        begin
          ASkinPicture.SaveToFile(
                        ExtractFilePath(SaveDialog.Filename)
                        +IntToStr(I)+'_'
                        +ExtractFileName(SaveDialog.FileName)
                        );
        end;
      end;
    end;
  end;
end;

procedure TfrmSkinPictureListPropertyEditor.ExportPictureClick(Sender: TObject);
var
  ASkinPicture:TSkinPicture;
  SelectedIndex:Integer;
begin
  //导出单张图片
  if Self.ListBox1.Selected<>nil then
  begin
    SelectedIndex:=Self.ListBox1.Selected.Index;
    ASkinPicture:=Self.FPictureList[SelectedIndex];
    if Not ASkinPicture.IsEmpty then
    begin
        SaveDialog.Title := Langs_Export[LangKind];
        SaveDialog.DefaultExt := '.png';
        SaveDialog.Filter := 'PNG (*.png)|*.png';
        if SaveDialog.Execute then
        begin
          ASkinPicture.SaveToFile(SaveDialog.FileName);
        end;
    end;
  end;
end;

procedure TfrmSkinPictureListPropertyEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FDesigner.SelectComponent(FComponent);

  Action:=TCloseAction.caFree;
end;

procedure TfrmSkinPictureListPropertyEditor.FormCreate(Sender: TObject);
begin
  Self.ListBox1.Items.Clear;

  FPictureList := TSkinPictureList.Create;


  //翻译
  Self.Caption:=Langs_PictureListEditor[LangKind];

  OKButton.Text:=Langs_OK[LangKind];
  CancelButton.Text:=Langs_Cancel[LangKind];
  Add.Text:=Langs_Add[LangKind];

  AddEmpty.Text:=Langs_AddEmpty[LangKind];
  Replace.Text:=Langs_Replace[LangKind];
  Delete.Text:=Langs_Delete[LangKind];
  ExportPicture.Text:=Langs_Export[LangKind];
  Clear.Text:=Langs_Clear[LangKind];
  ExportAll.Text:=Langs_ExportAll[LangKind];
  SaveSelected.Text:=Langs_Save[LangKind];


  lblImageIndex.Text:=Langs_CurImageIndex[LangKind];
  lblImageName.Text:=Langs_CurImageName[LangKind];
  lblFileName.Text:=Langs_CurImagePath[LangKind];
  lblResourceName.Text:=Langs_CurImageResource[LangKind];
  lblUrl.Text:=Langs_CurImageUrl[LangKind];


  chkOnlySetFilePath.Text:=Langs_OnlySetFilePath[LangKind];
end;

procedure TfrmSkinPictureListPropertyEditor.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FDrawPicturePersistent);
  FPictureList.Free;
end;

procedure TfrmSkinPictureListPropertyEditor.ListBox1Change(Sender: TObject);
begin
  if Self.ListBox1.ItemIndex<>-1 then
  begin
    FreeAndNil(FDrawPicturePersistent);

    FDrawPicturePersistent:=TDrawPicturePersistent.Create(nil);
    FDrawPicturePersistent.DrawPicture:=TDrawPicture(FPictureList[Self.ListBox1.Selected.Index]);
    FDesigner.SelectComponent(FDrawPicturePersistent);
  end;
end;

procedure TfrmSkinPictureListPropertyEditor.ListBox1DragChange(SourceItem,
  DestItem: TListBoxItem; var Allow: Boolean);
var
  ASourcePictureIndex:Integer;
  ADestPictureIndex:Integer;
  ASourcePicture:TDrawPicture;
  ADestPicture:TDrawPicture;
begin
  //拖曳改变顺序

  uBaseLog.OutputDebugString('TfrmSkinPictureListPropertyEditor.ListBox1DragChange');

  ASourcePictureIndex:=SourceItem.Index;
  ADestPictureIndex:=DestItem.Index;

  ASourcePicture:=FPictureList[ASourcePictureIndex];
  ADestPicture:=FPictureList[ADestPictureIndex];

  Self.FPictureList.Remove(ASourcePicture,False);
  Self.FPictureList.Insert(ADestPictureIndex,ASourcePicture);

  SyncListItemInfo(SourceItem,ADestPictureIndex);
  SyncListItemInfo(DestItem,Self.FPictureList.IndexOf(ADestPicture));

end;

procedure TfrmSkinPictureListPropertyEditor.ListBox1ItemClick(
  const Sender: TCustomListBox; const Item: TListBoxItem);
begin
  //点击图片
  Self.edtImageIndex.Text:=IntToStr(Item.Index);
  Self.edtImageName.Text:=FPictureList[Self.ListBox1.Selected.Index].ImageName;
  Self.edtFileName.Text:=FPictureList[Self.ListBox1.Selected.Index].FileName;
  Self.edtResourceName.Text:=FPictureList[Self.ListBox1.Selected.Index].ResourceName;
  Self.edtUrl.Text:=FPictureList[Self.ListBox1.Selected.Index].Url;
  Self.chkIsClipRound.IsChecked:=FPictureList[Self.ListBox1.Selected.Index].IsClipRound;
end;

procedure TfrmSkinPictureListPropertyEditor.OKButtonClick(Sender: TObject);
begin
//  if FComponentEditor=nil then
//  begin
//    ShowMessage('FComponentEditor=nil');
//  end
//  else
//  begin
//    ShowMessage('FComponentEditor<>nil');
//  end;
//
//  if FComponentEditor.Component=nil then
//  begin
//    ShowMessage('FComponentEditor.Component=nil');
//  end
//  else
//  begin
//    ShowMessage('FComponentEditor.Component<>nil');
//  end;

//  ShowMessage(FComponentEditor.Component.Name);



  TSkinImageList(FComponent).PictureList:=Self.PictureList;
//  TSkinImageList(FDefaultEditor.Component).PictureList:=Self.PictureList;
  FDesigner.Modified;



  Close;
end;

procedure TfrmSkinPictureListPropertyEditor.ReplaceClick(Sender: TObject);
var
  ASkinPicture:TSkinPicture;
begin
  if Self.ListBox1.Selected<>nil then
  begin
    OpenDialog.Title := Langs_Replace[LangKind];
    OpenDialog.Options:=OpenDialog.Options-[TOpenOption.ofAllowMultiSelect];
    if OpenDialog.Execute then
    begin

      if not chkOnlySetFilePath.IsChecked then
      begin
        FPictureList.ReplacePictureFile(Self.ListBox1.Selected.Index,OpenDialog.Filename);
      end
      else
      begin
        FPictureList.ReplaceFileNameOnly(Self.ListBox1.Selected.Index,OpenDialog.Filename);
      end;

      SyncListBox;

      Replace.Enabled:=True;
      Delete.Enabled:=True;
      ExportPicture.Enabled:=True;
    end;
  end;
end;

end.
