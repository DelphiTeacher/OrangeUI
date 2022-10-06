unit VCL_SkinPictureListPropertyEditorForm;

interface

uses
  Windows,
  Classes,
  Graphics,
  Forms,
  SysUtils,
  Controls,
  Dialogs,
  Buttons,
  Types,
  PngImage,
  GifImg,
  Jpeg,
  uBaseLog,
  uSkinImageList,
  DesignConst,
  DesignIntf,
  DesignEditors,
  uSkinPicture,
  uDrawPicture,
  StdCtrls,
  ExtCtrls,
  ExtDlgs,
  ComCtrls,

//  System.ImageList,

  ImgList, System.ImageList;

type
  TfrmSkinPictureListPropertyEditor = class(TForm)
    SaveDialog: TSavePictureDialog;
    OKButton: TButton;
    CancelButton: TButton;
    GroupBox1: TGroupBox;
    Add: TButton;
    Delete: TButton;
    Clear: TButton;
    Replace: TButton;
    ExportPicture: TButton;
    OpenDialog: TOpenPictureDialog;
    ListView1: TListView;
    ImageList1: TImageList;
    edtImageIndex: TEdit;
    lblImageIndex: TLabel;
    lblImageName: TLabel;
    edtImageName: TEdit;
    lblFileName: TLabel;
    edtFileName: TEdit;
    lblResourceName: TLabel;
    edtResourceName: TEdit;
    edtUrl: TEdit;
    lblUrl: TLabel;
    SaveSelected: TButton;
    chkIsClipRound: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure ListView1AdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure ReplaceClick(Sender: TObject);
    procedure ExportPictureClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure SaveSelectedClick(Sender: TObject);
  private
    FPictureList: TSkinPictureList;
    procedure SetSkinPictureList(const Value: TSkinPictureList);
  public
    FDesigner:IDesigner;
    FComponent:TComponent;
    property PictureList: TSkinPictureList read FPictureList write SetSkinPictureList;
  end;




implementation


{$R *.dfm}

{ TfrmSkinPictureListEdtior }

procedure TfrmSkinPictureListPropertyEditor.FormCreate(Sender: TObject);
begin
  FPictureList := TSkinPictureList.Create;
end;

procedure TfrmSkinPictureListPropertyEditor.FormDestroy(Sender: TObject);
begin
  ListView1.Free;
  FPictureList.Free;
end;

procedure TfrmSkinPictureListPropertyEditor.ReplaceClick(Sender: TObject);
var
  ASkinPicture:TSkinPicture;
begin
  if Self.ListView1.Selected<>nil then
  begin
    OpenDialog.Title := '替换图片';
    OpenDialog.Options:=OpenDialog.Options-[ofAllowMultiSelect];
    if OpenDialog.Execute then
    begin
      FPictureList.ReplacePictureFile(Self.ListView1.Selected.Index,OpenDialog.Filename);
      Self.ListView1.Invalidate;

      Replace.Enabled:=True;
      Delete.Enabled:=True;
      ExportPicture.Enabled:=True;
    end;
  end;
end;


procedure TfrmSkinPictureListPropertyEditor.AddClick(Sender: TObject);
var
  ListItem:TListItem;
  I: Integer;
  AFileName:String;
//  ASkinPicture:TDrawPicture;
begin
  OpenDialog.Title := '添加图片';
  OpenDialog.Options:=OpenDialog.Options+[ofAllowMultiSelect];
  if OpenDialog.Execute then
  begin
    for I := 0 to OpenDialog.Files.Count - 1 do
    begin
      FPictureList.AddPictureFile(OpenDialog.Files[I]);
//      ASkinPicture:=FPictureList[FPictureList.Count-1];
//      ASkinPicture.Caption:=Extract;
      ListItem:=ListView1.Items.Add;
      ListItem.Selected:=True;
      Replace.Enabled:=True;
      Delete.Enabled:=True;
      ExportPicture.Enabled:=True;

      //把文件名当做ImageName
      AFileName:=ExtractFileName(OpenDialog.Files[I]);
      AFileName:=Copy(AFileName,1,Length(AFileName)-Length(ExtractFileExt(AFileName)));
      FPictureList[FPictureList.Count-1].ImageName:=AFileName;


      ListView1Click(nil);

    end;
  end;
end;

procedure TfrmSkinPictureListPropertyEditor.DeleteClick(Sender: TObject);
var
  SelectedIndex:Integer;
begin
  if Self.ListView1.Selected<>nil then
  begin
    SelectedIndex:=Self.ListView1.Selected.Index;
    Self.ListView1.DeleteSelected;
    Self.FPictureList.Delete(SelectedIndex,True);
    Self.ListView1.Invalidate;
  end;
end;

procedure TfrmSkinPictureListPropertyEditor.ExportPictureClick(Sender: TObject);
var
  ASkinPicture:TSkinPicture;
  SelectedIndex:Integer;
begin
  if Self.ListView1.Selected<>nil then
  begin
    SelectedIndex:=Self.ListView1.Selected.Index;
    ASkinPicture:=Self.FPictureList[SelectedIndex];
    if ASkinPicture.Graphic <> nil then
    begin
      SaveDialog.Title := '导出图片';
      with SaveDialog do
      begin
        DefaultExt := GraphicExtension(TGraphicClass(ASkinPicture.Graphic.ClassType));
        Filter := GraphicFilter(TGraphicClass(ASkinPicture.Graphic.ClassType));
        if Execute then ASkinPicture.SaveToFile(Filename);
      end;
    end;
  end;
end;

procedure TfrmSkinPictureListPropertyEditor.ListView1AdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var
  DrawRect: TRect;
  ItemDrawRect: TRect;
  DestDrawRect:TRect;
  ASkinPicture:TSkinPicture;
begin
  DefaultDraw:=False;
  DrawRect:=Item.DisplayRect(drBounds);
  ItemDrawRect:=DrawRect;
  DestDrawRect:=ItemDrawRect;
  if Item.Selected then
  begin
    with Self.ListView1.Canvas do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(ItemDrawRect);
    end;
  end;
  ASkinPicture:=Self.FPictureList[Item.Index];
  with DestDrawRect do
  begin
    if (Right - Left>ASkinPicture.Width) and (Bottom - Top>ASkinPicture.Height) then
    begin
      Bottom:=Top+ASkinPicture.Height;
      Right:=Left+ASkinPicture.Width;
    end
    else
    begin
      if ASkinPicture.Width > ASkinPicture.Height then
        Bottom := Top + MulDiv(ASkinPicture.Height, Right - Left, ASkinPicture.Width)
      else
        Right := Left + MulDiv(ASkinPicture.Width, Bottom - Top, ASkinPicture.Height);
    end;
  end;
  //居中绘制
  ItemDrawRect.Left:=ItemDrawRect.Left+(RectWidth(ItemDrawRect)-RectWidth(DestDrawRect)) div 2;
  ItemDrawRect.Right:=ItemDrawRect.Left+RectWidth(DestDrawRect);
  ItemDrawRect.Top:=ItemDrawRect.Top+(RectHeight(ItemDrawRect)-RectHeight(DestDrawRect)) div 2;
  ItemDrawRect.Bottom:=ItemDrawRect.Top+RectHeight(DestDrawRect);
  //Draw
  Self.ListView1.Canvas.StretchDraw(ItemDrawRect, ASkinPicture.Graphic);
  //绘制下标
  Self.ListView1.Canvas.Brush.Style:=bsClear;
  Self.ListView1.Canvas.TextOut(DrawRect.Left+RectWidth(DrawRect),
                                DrawRect.Bottom-15,
                                IntToStr(Item.Index)+'('+IntToStr(ASkinPicture.Width)+'*'+IntToStr(ASkinPicture.Height)+')');
end;

procedure TfrmSkinPictureListPropertyEditor.ListView1Click(Sender: TObject);
begin
  //
  if Self.ListView1.Selected=nil then Exit;

  //点击图片
  Self.edtImageIndex.Text:=IntToStr(Self.ListView1.Selected.Index);
  Self.edtImageName.Text:=FPictureList[Self.ListView1.Selected.Index].ImageName;
  Self.edtFileName.Text:=FPictureList[Self.ListView1.Selected.Index].FileName;
  Self.edtResourceName.Text:=FPictureList[Self.ListView1.Selected.Index].ResourceName;
  Self.edtUrl.Text:=FPictureList[Self.ListView1.Selected.Index].Url;
  Self.chkIsClipRound.Checked:=FPictureList[Self.ListView1.Selected.Index].IsClipRound;

end;

procedure TfrmSkinPictureListPropertyEditor.OKButtonClick(Sender: TObject);
begin
  TSkinImageList(Self.FComponent).PictureList:=Self.PictureList;
//  Designer.Modified;
  Close;
end;

procedure TfrmSkinPictureListPropertyEditor.SaveSelectedClick(Sender: TObject);
begin
  //
  if Self.ListView1.Selected=nil then Exit;

  //点击图片
//  Self.ListView1.Selected.Index:=StrToInt(Self.edtImageIndex.Text);
  FPictureList[Self.ListView1.Selected.Index].ImageName:=Self.edtImageName.Text;
  FPictureList[Self.ListView1.Selected.Index].FileName:=Self.edtFileName.Text;
  FPictureList[Self.ListView1.Selected.Index].ResourceName:=Self.edtResourceName.Text;
  FPictureList[Self.ListView1.Selected.Index].Url:=Self.edtUrl.Text;
  FPictureList[Self.ListView1.Selected.Index].IsClipRound:=Self.chkIsClipRound.Checked;


end;

procedure TfrmSkinPictureListPropertyEditor.SetSkinPictureList(
  const Value: TSkinPictureList);
var
  ListItem:TListItem;
  I: Integer;
begin
  FPictureList.Assign(Value);

  Self.ListView1.Items.Clear;

  for I := 0 to FPictureList.Count - 1 do
  begin
    ListItem:=ListView1.Items.Add;
    ListItem.Selected:=True;
    Replace.Enabled:=True;
    Delete.Enabled:=True;
    ExportPicture.Enabled:=True;
  end;

end;

procedure TfrmSkinPictureListPropertyEditor.ClearClick(Sender: TObject);
begin
  Self.ListView1.Items.Clear;
  FPictureList.Clear(True);
  Replace.Enabled := False;
  Delete.Enabled := False;
  Clear.Enabled := False;
  ExportPicture.Enabled := False;
end;



end.
