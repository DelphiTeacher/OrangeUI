unit VCL_GroupDrawPictureFrame;

interface



uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.ExtCtrls,
  ActiveX,
  uSkinGdiPlus,
  PngImage,
  uGraphicCommon,
  uGDIPlusDrawCanvas,
//  GdiSkinHelper,
  uDrawCanvas,
  uBaseList,
  uGDIPlusSkinPictureEngine,
  uDrawPictureParam,
  uDrawPicture,
  uDrawEngine;

type
  TFrameGroupDrawPicture = class(TFrame)
    Label6: TLabel;
    Button1: TButton;
    ScrollBox1: TScrollBox;
    PaintBox1: TPaintBox;
    procedure Button1Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure sbRowIndexChange(Sender: TObject);
    procedure sbColIndexChange(Sender: TObject);
  private
    FDrawPicture: TDrawPicture;
    FDesignPicture: TDrawPicture;
    procedure SetDrawPicture(const Value: TDrawPicture);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure DrawPictureChange;
    property DesignPicture:TDrawPicture read FDesignPicture write FDesignPicture;
    property DrawPictrue:TDrawPicture read FDrawPicture write SetDrawPicture;
    { Public declarations }
  end;

implementation

{$R *.dfm}

{ TFrameGroupDrawPicture }

procedure TFrameGroupDrawPicture.Button1Click(Sender: TObject);
var
  DrawCanvas:TDrawCanvas;
  TempBitmap:IGPBitmap;
  TempBitmapGraphics:IGPGraphics;
var
  AStream:TMemoryStream;
  AAdapter:IStream;
  PngImage:TPngImage;
  OldRowIndex:Integer;
  OldColIndex:Integer;
begin
  TempBitmap:=TGPBitmap.Create(Self.PaintBox1.Width,Self.PaintBox1.Height);
  TempBitmapGraphics:=TGPGraphics.Create(TempBitmap);


  if FDrawPicture.Name=Self.FDesignPicture.Name then
  begin

    Exit;
  end;
  

  //ShowMessage('1');
  DrawCanvas:=uDrawEngine.CreateDrawCanvas;
  if DrawCanvas is TGDIPlusDrawCanvas then
  begin
    TGDIPlusDrawCanvas(DrawCanvas).FGraphics:=TempBitmapGraphics;

  //ShowMessage('2');

    DrawCanvas.DrawPicture(GlobalDrawPictureParam,
                            FDesignPicture,
                            RectF(0,0,Self.PaintBox1.Width,Self.PaintBox1.Height)
                            );

  //ShowMessage('3');



    AStream:=TMemoryStream.Create;
    AAdapter:=TCFStreamAdapter.Create(AStream, soReference);
  //ShowMessage('4');
    uSkinGDIPlus.TGPImageFormat_InitializeCodecs;
    TempBitmap.Save(AAdapter,FPng);
  //ShowMessage('5');
    AStream.Position:=0;
    //ShowMessage(IntToStr(AStream.Size));
    PngImage:=TPngImage.Create;
  //ShowMessage('6');
    PngImage.LoadFromStream(AStream);
    //PngImage.SaveToFile('c:\'+DrawPictrue.Name+IntToStr(sbRowIndex.Value)+IntToStr(sbColIndex.Value)+'.png');
    FDrawPicture.Assign(PngImage);
  //ShowMessage('7');
    PngImage.Free;
//    AAdapter.Free;


  end;
  DrawCanvas.Free;
  //FDrawPicture.
//  FDrawPicture.Width:=





end;

constructor TFrameGroupDrawPicture.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TFrameGroupDrawPicture.Destroy;
begin
  inherited;
end;

procedure TFrameGroupDrawPicture.DrawPictureChange;
begin


  Self.sbRowIndex.MaxValue:=Self.FDesignPicture.RowCount-1;
  Self.sbColIndex.MaxValue:=Self.FDesignPicture.ColCount-1;

  if (FDesignPicture.ColCount>=1) and (FDesignPicture.RowCount>=1) then
  begin
    PaintBox1.Width:=Self.FDesignPicture.Width div FDesignPicture.ColCount;
    PaintBox1.Height:=Self.FDesignPicture.Height div FDesignPicture.RowCount;
  end;

  PaintBox1.Invalidate;
end;

procedure TFrameGroupDrawPicture.PaintBox1Paint(Sender: TObject);
var
  ADrawCanvas:TDrawCanvas;
  ADrawPictureParam:TDrawPictureParam;
begin
  ADrawPictureParam:=TDrawPictureParam.Create('','');

  ADrawCanvas:=uDrawEngine.CreateDrawCanvas;
  ADrawCanvas.Prepare(PaintBox1.Canvas.Handle);

  if (sbRowIndex.Value<>-1)
    and (sbColIndex.Value<>-1) then
  begin
    Self.FDesignPicture.RowIndex:=sbRowIndex.Value;
    Self.FDesignPicture.ColIndex:=sbColIndex.Value;
    ADrawCanvas.DrawPicture(ADrawPictureParam,
                            FDesignPicture,
                            RectF(0,0,PaintBox1.Width,PaintBox1.Height)
                            );
  end;

  PaintBox1.Canvas.Brush.Style:=bsClear;
  PaintBox1.Canvas.Pen.Style:=psDot;
  PaintBox1.Canvas.Pen.Color:=clGray;
  PaintBox1.Canvas.Rectangle(Rect(0,0,PaintBox1.Width,PaintBox1.Height));


  ADrawCanvas.Free;
  ADrawPictureParam.Free;


end;

procedure TFrameGroupDrawPicture.sbColIndexChange(Sender: TObject);
begin
  DrawPictureChange;
end;

procedure TFrameGroupDrawPicture.sbRowIndexChange(Sender: TObject);
begin
  DrawPictureChange;
end;

procedure TFrameGroupDrawPicture.SetDrawPicture(const Value: TDrawPicture);
begin
  FDrawPicture:=Value;

  Self.sbRowIndex.OnChange:=nil;
  Self.sbColIndex.OnChange:=nil;

  Self.sbRowIndex.Value:=FDrawPicture.RowIndex;
  Self.sbColIndex.Value:=FDrawPicture.ColIndex;

  Self.sbRowIndex.OnChange:=Self.sbRowIndexChange;
  Self.sbColIndex.OnChange:=Self.sbColIndexChange;

  Self.Label6.Caption:=Self.FDrawPicture.Caption;

  if FDesignPicture.Name=FDrawPicture.Name then
  begin
    Self.Label6.Caption:=Self.FDrawPicture.Caption+'(µ±Ç°ËØ²Ä)';
  end;
end;

end.
