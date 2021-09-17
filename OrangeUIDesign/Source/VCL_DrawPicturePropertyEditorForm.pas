unit VCL_DrawPicturePropertyEditorForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, //Vcl.Samples.Spin,
  ExtCtrls,
  uDrawEngine,
  uDrawCanvas,
  Math,
  uBaseList,
//  {$IFDEF VCL}
//  VCL_GroupDrawPictureFrame,
//  {$ENDIF}
  GIFImg,
  PngImage,
  Jpeg,
  uSkinMaterial,
//  uDrawPicture,
  uDrawPictureParam,
  uDrawPicture,
  ExtDlgs;

type
  TfrmDrawPicturePropertyEditor = class(TForm)
    ScrollBox1: TScrollBox;
    Button1: TButton;
    btnSave: TButton;
    btnOk: TButton;
    Button2: TButton;
    Button4: TButton;
    SaveDialog1: TSavePictureDialog;
    PaintBox1: TPaintBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure sbRowCountChange(Sender: TObject);
    procedure sbColCountChange(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    { Private declarations }
    FGroupList:TBaseList;
    FDrawPicture: TDrawPicture;
    FFileName: string;
    FSkinMaterial: TSkinMaterial;
    procedure DrawPictureChange;
    procedure SetDrawPicture(const Value: TDrawPicture);
  public
    { Public declarations }
    property FileName: string read FFileName write FFileName;
    property DrawPicture: TDrawPicture read FDrawPicture write SetDrawPicture;
    property SkinMaterial:TSkinMaterial read FSkinMaterial write FSkinMaterial;
  end;

var
  frmDrawPicturePropertyEditor: TfrmDrawPicturePropertyEditor;

implementation

{$R *.dfm}

procedure TfrmDrawPicturePropertyEditor.FormCreate(Sender: TObject);
begin
  FGroupList:=TBaseList.Create;
  FDrawPicture := CreateCurrentEngineDrawPicture('','');
end;

procedure TfrmDrawPicturePropertyEditor.FormDestroy(Sender: TObject);
begin
  FGroupList.Free;
  FreeAndNil(FDrawPicture);
end;

procedure TfrmDrawPicturePropertyEditor.PaintBox1Paint(Sender: TObject);
var
  I: Integer;
begin

  if Not Self.FDrawPicture.IsEmpty then
  begin

    PaintBox1.Canvas.Draw(0,0,Self.FDrawPicture.Graphic);

    //绘制设计时框线
    PaintBox1.Canvas.Brush.Style:=bsClear;
    PaintBox1.Canvas.Pen.Style:=psDot;
    PaintBox1.Canvas.Pen.Color:=clBlack;



//    //绘制分割线
//    if Self.sbRowCount.Value>1 then
//    begin
//      for I := 2 to Self.sbRowCount.Value do
//      begin
//        PaintBox1.Canvas.MoveTo(0,(Self.FDrawPicture.Height div Self.sbRowCount.Value)*(I-1));
//        PaintBox1.Canvas.LineTo(Self.FDrawPicture.Width,(Self.FDrawPicture.Height div Self.sbRowCount.Value)*(I-1));
//      end;
//    end;
//
//    if Self.sbColCount.Value>1 then
//    begin
//      for I := 2 to Self.sbColCount.Value do
//      begin
//        PaintBox1.Canvas.MoveTo((Self.FDrawPicture.Width div Self.sbColCount.Value)*(I-1),0);
//        PaintBox1.Canvas.LineTo((Self.FDrawPicture.Width div Self.sbColCount.Value)*(I-1),Self.FDrawPicture.Height);
//      end;
//    end;



  end;

end;

procedure TfrmDrawPicturePropertyEditor.Button1Click(Sender: TObject);
var
  D: TOpenDialog;
begin
  //加载
  D := TOpenDialog.Create(Application);
  try
    D.Filter := '';
    if D.Execute then
    begin
      FileName := D.FileName;
      FDrawPicture.LoadFromFile(D.FileName);

      DrawPictureChange;

      btnOk.Enabled := true;
    end;
  finally
    D.Free;
  end;
end;

procedure TfrmDrawPicturePropertyEditor.sbColCountChange(Sender: TObject);
begin
  DrawPictureChange;
end;

procedure TfrmDrawPicturePropertyEditor.sbRowCountChange(Sender: TObject);
begin
  DrawPictureChange;
end;

procedure TfrmDrawPicturePropertyEditor.SetDrawPicture(const Value: TDrawPicture);
var
  I: Integer;
//  GroupDrawPictureFrame:TFrameGroupDrawPicture;
begin
  FDrawPicture.Assign(Value);
  FDrawPicture.Name:=Value.Name;
//  FDrawPicture.Caption:=Value.Caption;
  FDrawPicture.Group:=Value.Group;


//  if (FSkinMaterial<>nil) then//and (Self.FSkinMaterial.DrawPictureList.Count>0) then
//  begin
//    for I := 0 to Self.FSkinMaterial.DrawPictureList.Count-1 do
//    begin
//      if Self.FDrawPicture.Group=TDrawPicture(Self.FSkinMaterial.DrawPictureList[I]).Group then
//      begin
//        GroupDrawPictureFrame:=TFrameGroupDrawPicture.Create(nil);
//        GroupDrawPictureFrame.DesignPicture:=Self.FDrawPicture;
//        GroupDrawPictureFrame.DrawPictrue:=TDrawPicture(Self.FSkinMaterial.DrawPictureList[I]);
//        GroupDrawPictureFrame.Parent:=Self.ScrollBox2;
//        GroupDrawPictureFrame.Left:=GroupDrawPictureFrame.Width*I;
//        FGroupList.Add(GroupDrawPictureFrame);
//      end;
//    end;
//  end;

//  sbRowCount.OnChange:=nil;
//  sbColCount.OnChange:=nil;
//
//  Self.sbRowCount.Value:=FDrawPicture.RowCount;
//  Self.sbRowCount.MinValue:=0;
//  Self.sbColCount.Value:=FDrawPicture.ColCount;
//  Self.sbColCount.MinValue:=0;

  DrawPictureChange;

//  sbRowCount.OnChange:=sbRowCountChange;
//  sbColCount.OnChange:=sbColCountChange;

end;

procedure TfrmDrawPicturePropertyEditor.btnOkClick(Sender: TObject);
begin
  //保存
  ModalResult := mrOk;
end;

procedure TfrmDrawPicturePropertyEditor.Button2Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfrmDrawPicturePropertyEditor.Button4Click(Sender: TObject);
begin
  Self.FDrawPicture.Clear;
  ModalResult := mrOk;
end;

procedure TfrmDrawPicturePropertyEditor.DrawPictureChange;
var
  I: Integer;
begin

//  FDrawPicture.RowCount:=Ceil(Self.sbRowCount.Value);
//  FDrawPicture.ColCount:=Ceil(Self.sbColCount.Value);

  Self.PaintBox1.Width:=Self.FDrawPicture.Width;
  Self.PaintBox1.Height:=Self.FDrawPicture.Height;

//  for I := 0 to Self.FGroupList.Count-1 do
//  begin
//    TFrameGroupDrawPicture(Self.FGroupList[I]).DrawPictureChange;
//  end;

  Self.PaintBox1.Invalidate;

end;

procedure TfrmDrawPicturePropertyEditor.btnSaveClick(Sender: TObject);
begin
  //另存为
  SaveDialog1.FileName := FFileName;
  if SaveDialog1.Execute then
  begin
    FDrawPicture.SaveToFile(SaveDialog1.FileName);
  end;
end;

end.
