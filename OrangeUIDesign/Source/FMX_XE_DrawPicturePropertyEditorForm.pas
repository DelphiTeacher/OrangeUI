//convert pas to utf8 by ¥

unit FMX_XE_DrawPicturePropertyEditorForm;

interface
{$I FrameWork.inc}



{$DEFINE MSWINDOWS}


uses
  System.SysUtils,
  System.Classes,
  System.Types,
  System.UITypes,
  System.Math,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Types,
  FMX.Controls,
  FMX.Layouts,
  FMX.Objects,
  FMX.Edit,
  FMX.Platform,
  FMX.Effects,
  FMX.StdCtrls,
  FMX.SpinBox,

  uLang,
  uDrawEngine,
  uDrawCanvas,
  uBaseList,
  uSkinGIFImage,
  uLanguage,
  uSkinMaterial,
  uDrawPictureParam,
  uDrawPicture,

  FMX.Controls.Presentation, FMX.EditBox;

type
  TfrmDrawPicturePropertyEditor = class(TForm)
    pnlClient: TPanel;
    ScrollBox1: TScrollBox;
    Preview: TPaintBox;
    SaveDialog1: TSaveDialog;
    btnOpen: TButton;
    btnSaveAs: TButton;
    btnOk: TButton;
    btnCancel: TButton;
    btnClear: TButton;
    Button1: TButton;
    Button2: TButton;
    btnPaste: TButton;
    btnCopy: TButton;
    btnGenerateGIFImageList: TButton;
    OpenDialog: TOpenDialog;
    edtDevide: TEdit;
    procedure btnOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PreviewPaint(Sender: TObject; const Canvas: TCanvas);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnGenerateGIFImageListClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
    FDrawPicture: TDrawPicture;
    FFileName: string;
    procedure DrawPictureChange;
    procedure SetDrawPicture(const Value: TDrawPicture);
  public
    { Public declarations }
    property FileName: string read FFileName write FFileName;
    property DrawPicture: TDrawPicture read FDrawPicture write SetDrawPicture;
  end;



var
  ClipbrdDrawPicture:TDrawPicture;
  frmDrawPicturePropertyEditor: TfrmDrawPicturePropertyEditor;
  frmSkinItemsPropertyEditor:TForm;


implementation


//uses
//  FMX_XE_SkinItemsPropertyeditorForm;



{$R *.fmx}

procedure TfrmDrawPicturePropertyEditor.FormCreate(Sender: TObject);
begin
  FDrawPicture := CreateCurrentEngineDrawPicture('','');

  //翻译
  Self.Caption:=Langs_PictureEditor[LangKind];

  btnOpen.Text:=Langs_Open[LangKind];
  btnSaveAs.Text:=Langs_SaveAs[LangKind];
  btnOK.Text:=Langs_OK[LangKind];
  btnCancel.Text:=Langs_Cancel[LangKind];
  btnClear.Text:=Langs_Clear[LangKind];

end;

procedure TfrmDrawPicturePropertyEditor.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FDrawPicture);
end;

procedure TfrmDrawPicturePropertyEditor.FormHide(Sender: TObject);
begin
  //当前是在编辑ListBox的列表项,
  //所以图标编辑窗体隐藏之后就要显示列表项的编辑器
  if (frmSkinItemsPropertyEditor<>nil)
    and (Not frmSkinItemsPropertyEditor.Visible) then
  begin
    frmSkinItemsPropertyEditor.Visible:=True;
  end;
end;

procedure TfrmDrawPicturePropertyEditor.FormKeyUp(Sender: TObject;
  var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if KeyChar=#27 then
  begin
    Close;
  end;
end;

procedure TfrmDrawPicturePropertyEditor.FormShow(Sender: TObject);
begin
  //当前是在编辑ListBox的列表项,
  //所以要先隐藏列表项的编辑器
  if (frmSkinItemsPropertyEditor<>nil)
    and (frmSkinItemsPropertyEditor.Visible) then
  begin
    frmSkinItemsPropertyEditor.Visible:=False;
  end;
end;

procedure TfrmDrawPicturePropertyEditor.btnOpenClick(Sender: TObject);
var
  D: TOpenDialog;
begin
  //加载
  D := TOpenDialog.Create(Application);
  try

    D.Filter := TBitmapCodecManager.GetFilterString;
    D.DefaultExt:='.png';

    if D.Execute then
    begin
      FileName := D.FileName;
      FDrawPicture.LoadFromFile(D.FileName);
      DrawPictureChange;
      btnOk.Enabled := true;
      Self.btnOk.SetFocus;
    end;
  finally
    D.Free;
  end;
end;

procedure TfrmDrawPicturePropertyEditor.btnPasteClick(Sender: TObject);
begin
  if ClipbrdDrawPicture<>nil then
  begin
    Self.FDrawPicture.Assign(ClipbrdDrawPicture);
    DrawPictureChange;
    btnOk.Enabled := true;
    Self.btnOk.SetFocus;
  end;
end;

procedure TfrmDrawPicturePropertyEditor.PreviewPaint(Sender: TObject; const Canvas: TCanvas);
begin
  if Not Self.FDrawPicture.IsEmpty then
  begin
    {$IFDEF FMX}
    Canvas.DrawBitmap(Self.FDrawPicture,
                  RectF(0,0,FDrawPicture.Width,FDrawPicture.Height),
                  RectF(0,0,FDrawPicture.Width,FDrawPicture.Height),1);
    {$ENDIF FMX}

    //绘制设计时框线
    Canvas.Stroke.Dash:=TStrokeDash.Dot;
    Canvas.Stroke.Color:=TAlphaColorRec.Black;

  end;
end;

procedure TfrmDrawPicturePropertyEditor.SetDrawPicture(const Value: TDrawPicture);
begin
  FDrawPicture.Assign(Value);

  DrawPictureChange;

end;

procedure TfrmDrawPicturePropertyEditor.btnCopyClick(Sender: TObject);
begin
  if ClipbrdDrawPicture=nil then
  begin
    ClipbrdDrawPicture := CreateCurrentEngineDrawPicture('','');
  end;
  ClipbrdDrawPicture.Assign(FDrawPicture);
end;

procedure TfrmDrawPicturePropertyEditor.btnOkClick(Sender: TObject);
begin
  //保存
  ModalResult := mrOk;
end;

procedure TfrmDrawPicturePropertyEditor.btnCancelClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfrmDrawPicturePropertyEditor.btnClearClick(Sender: TObject);
begin
  Self.FDrawPicture.Clear;
  Preview.Repaint;
end;

procedure TfrmDrawPicturePropertyEditor.DrawPictureChange;
begin

  Preview.Width := FDrawPicture.CurrentPictureDrawWidth;
  Preview.Height := FDrawPicture.CurrentPictureDrawHeight;

  Preview.Repaint;

end;

procedure TfrmDrawPicturePropertyEditor.btnSaveAsClick(Sender: TObject);
begin
  //另存为
  SaveDialog1.Filter := TBitmapCodecManager.GetFilterString;
  SaveDialog1.DefaultExt := '.png';
  SaveDialog1.FileName := FFileName;
  if SaveDialog1.Execute then
  begin
    FDrawPicture.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure SizePicture(AOriginPicture:TBitmap;AWidth,AHeight:Integer;ASaveDir:String;DevideChar:String);
var
  ATempBitmap:TBitmap;
begin

  {$IFDEF FMX}
  ATempBitmap:=TBitmap.Create(AWidth,AHeight);
  ATempBitmap.Canvas.BeginScene();
  ATempBitmap.Canvas.Clear(0);
  ATempBitmap.Canvas.DrawBitmap(AOriginPicture,
      RectF(0,0,AOriginPicture.Width,AOriginPicture.Height),
      RectF(0,0,AWidth,AHeight),
      1);
  ATempBitmap.Canvas.EndScene;

  //x
  if ExtractFileName(ASaveDir)='' then
  begin
    ATempBitmap.SaveToFile(ASaveDir+IntToStr(AWidth)+DevideChar+IntToStr(AHeight)+'.png');
  end
  else
  begin
    System.SysUtils.ForceDirectories(ExtractFilePath(ASaveDir));
    ATempBitmap.SaveToFile(ASaveDir);
  end;


  ATempBitmap.Free;
  {$ENDIF FMX}
end;

procedure TfrmDrawPicturePropertyEditor.Button1Click(Sender: TObject);
begin
  {$IFDEF FMX}
  //生成图标
  SizePicture(Self.FDrawPicture.CurrentPicture,29,29,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,36,36,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,40,40,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,48,48,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,50,50,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,57,57,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,58,58,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,60,60,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,72,72,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,76,76,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,80,80,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,87,87,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,96,96,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,100,100,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,114,114,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,120,120,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,144,144,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,152,152,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,180,180,'C:\',Self.edtDevide.Text);


  //微信需要
  SizePicture(Self.FDrawPicture.CurrentPicture,28,28,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,108,108,'C:\',Self.edtDevide.Text);

  //Windows需要
  SizePicture(Self.FDrawPicture.CurrentPicture,44,44,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,150,150,'C:\',Self.edtDevide.Text);



//  //生成2.08老版的个推推送图标
//  SizePicture(Self.FDrawPicture.CurrentPicture,96,96,'C:\drawable-hdpi\demo.png',Self.edtDevide.Text);
//  SizePicture(Self.FDrawPicture.CurrentPicture,48,48,'C:\drawable-hdpi\icon.png',Self.edtDevide.Text);
//  SizePicture(Self.FDrawPicture.CurrentPicture,96,96,'C:\drawable-hdpi\push.png',Self.edtDevide.Text);
//
//  SizePicture(Self.FDrawPicture.CurrentPicture,48,48,'C:\drawable-ldpi\demo.png',Self.edtDevide.Text);
//  SizePicture(Self.FDrawPicture.CurrentPicture,48,48,'C:\drawable-ldpi\icon.png',Self.edtDevide.Text);
//  SizePicture(Self.FDrawPicture.CurrentPicture,48,48,'C:\drawable-ldpi\push.png',Self.edtDevide.Text);
//
//  SizePicture(Self.FDrawPicture.CurrentPicture,72,72,'C:\drawable-mdpi\demo.png',Self.edtDevide.Text);
//  SizePicture(Self.FDrawPicture.CurrentPicture,48,48,'C:\drawable-mdpi\icon.png',Self.edtDevide.Text);
//  SizePicture(Self.FDrawPicture.CurrentPicture,72,72,'C:\drawable-mdpi\push.png',Self.edtDevide.Text);


  //生成2.10.2版的个推推送图标
  SizePicture(Self.FDrawPicture.CurrentPicture,96,96,'C:\drawable-hdpi\push.png',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,36,36,'C:\drawable-hdpi\push_small.png',Self.edtDevide.Text);

  SizePicture(Self.FDrawPicture.CurrentPicture,48,48,'C:\drawable-ldpi\push.png',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,18,18,'C:\drawable-ldpi\push_small.png',Self.edtDevide.Text);

  SizePicture(Self.FDrawPicture.CurrentPicture,64,64,'C:\drawable-mdpi\push.png',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,24,24,'C:\drawable-mdpi\push_small.png',Self.edtDevide.Text);

  SizePicture(Self.FDrawPicture.CurrentPicture,128,128,'C:\drawable-xhdpi\push.png',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,48,48,'C:\drawable-xhdpi\push_small.png',Self.edtDevide.Text);

  SizePicture(Self.FDrawPicture.CurrentPicture,192,192,'C:\drawable-xxhdpi\push.png',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,72,72,'C:\drawable-xxhdpi\push_small.png',Self.edtDevide.Text);

  {$ENDIF FMX}

end;

procedure TfrmDrawPicturePropertyEditor.Button2Click(Sender: TObject);
begin
  {$IFDEF FMX}
  SizePicture(Self.FDrawPicture.CurrentPicture,320,480,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,426,320,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,470,320,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,640,960,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,640,480,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,640,1136,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,750,1334,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,960,720,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,1242,2208,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,2208,1242,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,2048,1536,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,2048,1496,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,1536,2048,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,1496,2048,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,1536,2008,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,1024,768,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,1024,748,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,768,1024,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,768,1004,'C:\',Self.edtDevide.Text);

  SizePicture(Self.FDrawPicture.CurrentPicture,1136,640,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,1334,750,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,828,1792,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,1792,828,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,1125,2436,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,2436,1125,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,1242,2688,'C:\',Self.edtDevide.Text);

  SizePicture(Self.FDrawPicture.CurrentPicture,2688,1242,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,1668,2224,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,2224,1668,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,1668,2388,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,2388,1668,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,2048,2732,'C:\',Self.edtDevide.Text);
  SizePicture(Self.FDrawPicture.CurrentPicture,2732,2048,'C:\',Self.edtDevide.Text);

  {$ENDIF FMX}
end;

procedure TfrmDrawPicturePropertyEditor.btnGenerateGIFImageListClick(Sender: TObject);
var
  I: Integer;
  AFilePath:String;
  AFileName:String;
  AExistFilePath:String;

  ASkinGIFImage:TSkinGIFImage;
begin
  OpenDialog.Title := Langs_Add[LangKind];
  OpenDialog.Options:=OpenDialog.Options+[TOpenOption.ofAllowMultiSelect];
  if OpenDialog.Execute then
  begin
    AExistFilePath:=ExtractFilePath(OpenDialog.FileName);;
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
      //在XP下有问题,最后一个文件夹没有带
      AFileName:=OpenDialog.Files[I];

      AFileName:=AExistFilePath+Copy(AFileName,Length(AExistFilePath),MaxInt);


      ASkinGIFImage:=uSkinGIFImage.TSkinGIFImage.Create;
      try
        ASkinGIFImage.LoadFromFile(AFileName);


        AFileName:=Copy(AFileName,Length(AExistFilePath),MaxInt);
        ASkinGIFImage.Bitmap.SaveToFile(
                  'C:\'+
                  Copy(AFileName,1,Length(AFileName)-4)
                  +'.png');
      finally
        FreeAndNil(ASkinGIFImage);
      end;


    end;
  end;

end;

initialization


finalization
  FreeAndNil(ClipbrdDrawPicture);



end.
