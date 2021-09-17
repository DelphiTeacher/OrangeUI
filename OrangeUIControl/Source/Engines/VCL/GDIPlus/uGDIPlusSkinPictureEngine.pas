unit uGDIPlusSkinPictureEngine;

interface

uses
  Windows,
  Classes,
  SysUtils,
  uSkinGdiPlus,
  ActiveX,
  Math,
  Graphics,
  ExtCtrls,
  uSkinPicture;

type
  TCFStreamAdapter = class(TStreamAdapter)

  //老版本
//  public
//    function Stat(out statstg:TStatStg; grfStatFlag:Longint):HResult; override; stdcall;

  end;


  TGDIPlusSkinPictureEngine=class(TSkinPictureEngine)
  private
    FBitmap:IGPBitmap;
    procedure Prepare;virtual;
    function GetBitmap: IGPBitmap;
  protected
    procedure Clear;override;
  public
    //图片
    property Bitmap:IGPBitmap read GetBitmap;
  end;



  TSkinGIFPictureEngine_GDIPlus=class(TSkinBaseGIFPictureEngine)//TSkinGIFPictureEngine)
  private
    FBitmap:IGPBitmap;
    procedure Prepare;virtual;
    function GetBitmap: IGPBitmap;
  protected
    procedure Clear;override;
  public
    //图片
    property Bitmap:IGPBitmap read GetBitmap;
  end;






  TGDIPlusSkinGIFPictureEngine=class(TSkinBaseGIFPictureEngine)
  private
    FBitmap:IGPBitmap;
    procedure Prepare;
    function GetBitmap: IGPBitmap;
  private
    FPropertyItem: IGPPropertyItem;
    FFrameCount: Integer;
    FFrameIndex: Integer;
    FFrameTimeArr: array of Cardinal;

    FDrawTimer: TTimer;
    FWaitTime: Integer;

    procedure InitAnimate;
    procedure OnDrawTimer(Sender: TObject);
    function SelectActiveFrame(const DimensionID: TGUID;const FrameIndex: Cardinal): Boolean;
  protected
    procedure Clear;override;
    procedure StartAnimate;override;
    procedure StopAnimate;override;
    //是否启动了动画
    function IsStarted:Boolean;override;
    //当前帧
    function CurrentAnimateFrame:TSkinPicture;override;
  public
    constructor Create(ASkinPicture:TSkinPicture);override;
    destructor Destroy;override;
  public
    //图片
    property Bitmap:IGPBitmap read GetBitmap;
  end;



implementation






//{ TCFStreamAdapter }
//
//function TCFStreamAdapter.Stat(out statstg:TStatStg;grfStatFlag:Integer):HResult;
//begin
//  Result:=inherited Stat(statstg, grfStatFlag);
//  //TStatStg结构下面2个属性在TStreamAdapter.Stat里并没有初始化
//  statstg.pwcsName:=nil;
//  statstg.reserved:=0;
//end;





{ TGDIPlusSkinPictureEngine }

function TGDIPlusSkinPictureEngine.GetBitmap: IGPBitmap;
begin
  if (FBitmap=nil) then
  begin
    if (Self.SkinPicture.Graphic<>nil) and Not Self.SkinPicture.Graphic.Empty then
    begin
      Prepare;
    end;
  end;
  Result:=FBitmap;
end;

procedure TGDIPlusSkinPictureEngine.Prepare;
var
  AStream:TMemoryStream;
  AAdapter:IStream;
  ABitmap:IGPBitmap;
  AGraphics:IGPGraphics;
begin
  FBitmap:=nil;
  if (Self.SkinPicture.Graphic<>nil) and Not Self.SkinPicture.Graphic.Empty then
  begin
    AStream:=TMemoryStream.Create;
    try
      Self.SkinPicture.Graphic.SaveToStream(AStream);
      if (AStream.Size > 0) then
      begin
        AStream.Position:=0;
        AAdapter:=TCFStreamAdapter.Create(AStream, soReference);
        ABitmap:=TGPBitmap.Create(AAdapter, True);
        ABitmap.Pixels[0, 0]:=ABitmap.Pixels[0, 0];
        if (ABitmap <> nil) then
        begin
          FBitmap:=TGPBitmap.Create(ABitmap.Width, ABitmap.Height,PixelFormat32bppARGB);
          AGraphics:=TGPGraphics.Create(FBitmap);
          AGraphics.DrawImage(ABitmap, TGPRect_Create(0, 0, ABitmap.Width,ABitmap.Height));
        end;
      end;
    finally
      FreeAndNil(AStream);
    end;
  end;
end;

procedure TGDIPlusSkinPictureEngine.Clear;
begin
  Inherited;
  FBitmap:=nil;
end;

{ TSkinGIFPictureEngine_GDIPlus }

function TSkinGIFPictureEngine_GDIPlus.GetBitmap: IGPBitmap;
begin
  if (FBitmap=nil) then
  begin
    if (Self.SkinPicture.Graphic<>nil) and Not Self.SkinPicture.Graphic.Empty then
    begin
      Prepare;
    end;
  end;
  Result:=FBitmap;
end;

procedure TSkinGIFPictureEngine_GDIPlus.Prepare;
var
  AStream:TMemoryStream;
  AAdapter:IStream;
  ABitmap:IGPBitmap;
  AGraphics:IGPGraphics;
begin
  FBitmap:=nil;
  if (Self.SkinPicture.Graphic<>nil) and Not Self.SkinPicture.Graphic.Empty then
  begin
    AStream:=TMemoryStream.Create;
    try
      Self.SkinPicture.Graphic.SaveToStream(AStream);
      if (AStream.Size > 0) then
      begin
        AStream.Position:=0;
        AAdapter:=TCFStreamAdapter.Create(AStream, soReference);
        ABitmap:=TGPBitmap.Create(AAdapter, True);
        ABitmap.Pixels[0, 0]:=ABitmap.Pixels[0, 0];
        if (ABitmap <> nil) then
        begin
          FBitmap:=TGPBitmap.Create(ABitmap.Width, ABitmap.Height,PixelFormat32bppARGB);
          AGraphics:=TGPGraphics.Create(FBitmap);
          AGraphics.DrawImage(ABitmap, TGPRect_Create(0, 0, ABitmap.Width,ABitmap.Height));
        end;
      end;
    finally
      FreeAndNil(AStream);
    end;
  end;
end;

procedure TSkinGIFPictureEngine_GDIPlus.Clear;
begin
  Inherited;
  FBitmap:=nil;
end;

{ TGDIPlusSkinGIFPictureEngine }

constructor TGDIPlusSkinGIFPictureEngine.Create(ASkinPicture: TSkinPicture);
begin
  inherited Create(ASkinPicture);
end;

function TGDIPlusSkinGIFPictureEngine.CurrentAnimateFrame: TSkinPicture;
begin
  Result:=Inherited CurrentAnimateFrame;
  if CurrentIsGIF and Self.FAnimated and Not Self.IsStarted then
  begin
    StartAnimate;
  end;
end;

procedure TGDIPlusSkinGIFPictureEngine.OnDrawTimer(Sender: TObject);
var
  millisecond: Integer;
begin
  Inc(FWaitTime, 10);
  //标准速度为10，调小可加快播放速度，调小可减慢播放速度
  millisecond := FFrameTimeArr[FFrameIndex] * Ceil(AnimateSpeed);
  if FWaitTime >= millisecond then
  begin
    FWaitTime := 0;
    FFrameIndex := (FFrameIndex + 1) mod FFrameCount;
    if not SelectActiveFrame(FrameDimensionTime, FFrameIndex) then
    begin
      Self.FDrawTimer.Enabled := False;
    end
    else
    begin
      DoAnimateRePaint(Self);
    end;
  end;
end;

procedure TGDIPlusSkinGIFPictureEngine.Prepare;
var
  AStream:TMemoryStream;
  AAdapter:IStream;
  ABitmap:IGPBitmap;
  AGraphics:IGPGraphics;
begin
  FBitmap:=nil;

  if CurrentIsGIF then
  begin
    AAdapter:=TCFStreamAdapter.Create(Self.FSkinPicture.GIFStream, soReference);
    FBitmap:=TGPBitmap.Create(AAdapter, True);
  end
  else
  begin
    if (Self.SkinPicture.Graphic<>nil) and Not Self.SkinPicture.Graphic.Empty then
    begin
      AStream:=TMemoryStream.Create;
      try
        Self.SkinPicture.Graphic.SaveToStream(AStream);
        if (AStream.Size > 0) then
        begin

          AStream.Position:=0;
          AAdapter:=TCFStreamAdapter.Create(AStream, soReference);
          ABitmap:=TGPBitmap.Create(AAdapter, True);


          ABitmap.Pixels[0, 0]:=ABitmap.Pixels[0, 0];
          if (ABitmap <> nil) then
          begin
            FBitmap:=TGPBitmap.Create(ABitmap.Width, ABitmap.Height,PixelFormat32bppARGB);
            AGraphics:=TGPGraphics.Create(FBitmap);
            AGraphics.DrawImage(ABitmap, TGPRect_Create(0, 0, ABitmap.Width,ABitmap.Height));
          end;

        end;
      finally
        FreeAndNil(AStream);//如果释放，GIF选帧会出错
      end;

    end;
  end;

end;

function TGDIPlusSkinGIFPictureEngine.SelectActiveFrame(const DimensionID: TGUID;
  const FrameIndex: Cardinal): Boolean;
begin
  Result := True;
  FBitmap.SelectActiveFrame(DimensionID, FrameIndex);
end;

procedure TGDIPlusSkinGIFPictureEngine.StartAnimate;
begin
  inherited;

  InitAnimate;

  if CurrentIsGIF and (FFrameCount>0) then
  begin
    if FDrawTimer=nil then
    begin
      FDrawTimer := TTimer.Create(nil);
      FDrawTimer.Enabled := False;
      FDrawTimer.Interval := 10;
      FDrawTimer.OnTimer := OnDrawTimer;
    end;
    FDrawTimer.Enabled := True;
  end;
end;

procedure TGDIPlusSkinGIFPictureEngine.StopAnimate;
begin
  inherited;
  if (FDrawTimer<>nil) then
  begin
    FDrawTimer.Enabled := False;
  end;
end;

procedure TGDIPlusSkinGIFPictureEngine.Clear;
begin
  Inherited;

  FBitmap := nil;

  FFrameCount := 0;
  FFrameIndex := 0;
end;

destructor TGDIPlusSkinGIFPictureEngine.Destroy;
begin
  FreeAndNil(FDrawTimer);
  inherited;
end;


function TGDIPlusSkinGIFPictureEngine.GetBitmap: IGPBitmap;
begin
  if (FBitmap=nil) then
  begin
    if (Self.SkinPicture.Graphic<>nil) and Not Self.SkinPicture.Graphic.Empty then
    begin
      Prepare;
    end;
  end;
  Result:=FBitmap;
end;

procedure TGDIPlusSkinGIFPictureEngine.InitAnimate;
//var
//  i: Integer;
begin

  FFrameCount := 0;
  FFrameIndex := 0;

  FWaitTime := 0;


  if FDrawTimer<>nil then
  begin
    FDrawTimer.Enabled := False;
  end;

  if (GetBitmap <> nil) then
  begin
    if not IsEqualGUID(FBitmap.RawFormat, ImageFormatGIF) then Exit;

    FFrameCount := 0;
    FFrameIndex := 0;

    { 获取 Gif 动画的时间属性, 这是一个 Cardinal 数组 }
    FPropertyItem := FBitmap.GetPropertyItem(PropertyTagFrameDelay);
    { 帧总数 }
    FFrameCount := FPropertyItem.Length div 4;

    { 复制到需要的数组 }
    SetLength(FFrameTimeArr, FFrameCount);
    CopyMemory(FFrameTimeArr, FPropertyItem.Value, FPropertyItem.Length);
//    for i := 0 to FFrameCount - 1 do
//    begin
//      if FFrameTimeArr[i] < 10 then FFrameTimeArr[i] := 10;
//    end;

    if not SelectActiveFrame(FrameDimensionTime, FFrameIndex) then Exit;

    FWaitTime := 0;

  end;

end;

function TGDIPlusSkinGIFPictureEngine.IsStarted: Boolean;
begin
  Result:=(FDrawTimer<>nil) and FDrawTimer.Enabled;
end;



end.