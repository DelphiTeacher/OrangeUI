unit uGDIPlusDrawCanvas;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Types,
  Forms,
  Math,
  uSkinGdiPlus,
  Dialogs,
  Graphics,
  ActiveX,
  PngImage,
  uFuncCommon,
  uGraphicCommon,
  uDrawPicture,
  uDrawCanvas,
  uSkinPicture,
  uBasePathData,
  uDrawParam,
  uDrawTextParam,
  uDrawRectParam,
  uDrawLineParam,
  uDrawPathParam,
  uDrawPictureParam,
  uGDIPlusSkinPictureEngine;


type
//  {$Region 'GDIPlus画布'}
  TSide = (Top, Left, Bottom, Right);
  TSides=set of TSide;



  TGPPointArray=array of TGPPoint;
  TByteArray=array of Byte;



  TGDIPlusDrawPathData=class(TBaseDrawPathData)
  public
    OriginX:Double;
    OriginY:Double;
    Path:IGPGraphicsPath;
  public
    constructor Create;override;
    destructor Destroy;override;
  public
    function MoveTo(const X:Double;const Y:Double):Boolean;override;
    function LineTo(const X:Double;const Y:Double):Boolean;override;
  end;




  TGDIPlusDrawCanvas=class(TDrawCanvas)
  private
    function CreateGPFont(ADrawTextParam:TDrawTextParam;var AGPFont:IGPFont):Boolean;
    function CreateGPBrush(ADrawTextParam:TDrawTextParam;var AGPBrush:IGPBrush):Boolean;
    function CreateGPStringFormat(ADrawTextParam:TDrawTextParam;var AGPStringFormat:IGPStringFormat):Boolean;
  public
    FGraphics:IGPGraphics;

    constructor Create;override;
    destructor Destroy;override;

  public


    //函数//
    //准备DC
    function CustomPrepare:Boolean;override;
    //反准备DC
    function CustomUnPrepare:Boolean;override;



    //设置剪裁矩形
    procedure SetClip(const AClipRect:TRectF);override;
    //取消剪裁矩形
    procedure ResetClip;override;


    //绘制设计时矩形
    function DrawDesigningRect(const ADrawRect:TRectF;
                                const ABorderColor:TDelphiColor):Boolean;override;
    //绘制设计时文本
    function DrawDesigningText(const ADrawRect:TRectF;
                                const AText:String):Boolean;override;



    //计算字体绘制尺寸
    function CalcTextDrawSize(const ADrawTextParam:TDrawTextParam;
                              const AText:String;
                              const ADrawRect:TRectF;
                              var ADrawWidth:TControlSize;
                              var ADrawHeight:TControlSize;
                              const ACalcDrawSizeType:TCalcDrawSizeType):Boolean;override;
    //绘制文字
    function DrawText(const ADrawTextParam:TDrawTextParam;
                      const AText:String;
                      const ADrawRect:TRectF;
                      const AColorTextList:IColorTextList=nil):Boolean;override;


    //绘制图片
    function DrawSkinPicture(const ADrawPictureParam:TDrawPictureParam;
                            const ASkinPicture:TSkinPicture;
                            const ADrawRect:TRectF;
                            const AIsUseSrcRectAndDestDrawRect:Boolean;
                            const AImageSrcRect:TRectF;
                            const AImageDestDrawRect:TRectF
                            ):Boolean;override;





    //绘制矩形函数//
    function DrawRect(const ADrawRectParam:TDrawRectParam;
                      const ADrawRect:TRectF):Boolean;override;


    //绘制直线函数//
    function DrawLine(const ADrawLineParam:TDrawLineParam;
                      X1:Double;
                      Y1:Double;
                      X2:Double;
                      Y2:Double):Boolean;override;


    //绘制路径//
    function DrawPathData(ADrawPathData:TBaseDrawPathData):Boolean;override;
    function FillPathData(ADrawPathParam:TDrawPathParam;ADrawPathData:TBaseDrawPathData):Boolean;override;
    //绘制路径
    function DrawPath(ADrawPathParam:TDrawPathParam;const ADrawRect:TRectF):Boolean;override;


  end;
//  {$EndRegion}


//function TGPRect_Create(const Rect: TRectF): TGPRect;overload;
//function TGPRect_Create(const AX, AY, AWidth, AHeight: Single): TGPRect;overload;


var
  GlobalGPTextRenderingHint:TGPTextRenderingHint;

function TGPRectF_Create(const Rect: TRectF): TGPRectF;overload;

//将位图剪裁成圆形
function RoundSkinPicture(ASkinPicture:TSkinPicture;
                          AXRadius:Double=-1;
                          AYRadius:Double=-1//;
//                          ACorners: TCorners=[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight];
//                          const AQuality: TCanvasQuality = TCanvasQuality.SystemDefault
                          ):TSkinPicture;


implementation



//function GetScreenLogPixels:Integer;
//var
//  DC: HDC;
//begin
//  DC := GetDC(0);
//  try
//    Result := GetDeviceCaps(DC, LOGPIXELSY);
//  finally
//    ReleaseDC(0,DC);
//  end;
//end;
//
//
//function ScreenScaleSize(ASize:Single):Single;
//begin
//  Result:=ASize*GetScreenScaleRate;
//end;


//function TGPRect_Create(const AX, AY, AWidth, AHeight: Single): TGPRect;
//begin
//  Result.X:=Ceil(AX);
//  Result.Y:=Ceil(AY);
//  Result.Width:=Ceil(AWidth);
//  Result.Height:=Ceil(AHeight);
//end;

//function TGPRect_Create(const Rect: TRectF): TGPRect;
//begin
//  Result.X:=Ceil(Rect.Left);
//  Result.Y:=Ceil(Rect.Top);
//  Result.Width:=Ceil(Rect.Width);
//  Result.Height:=Ceil(Rect.Height);
//end;

function TGPRectF_Create(const Rect: TRectF): TGPRectF;
begin
  Result.X:=Rect.Left;
  Result.Y:=Rect.Top;
  Result.Width:=Rect.Width;
  Result.Height:=Rect.Height;
end;


{ TGDIPlusDrawCanvas }

function TGDIPlusDrawCanvas.CustomPrepare: Boolean;
begin
  FGraphics:=TGPGraphics.Create(Self.Handle);
end;

function TGDIPlusDrawCanvas.CustomUnPrepare: Boolean;
begin
  Result:=False;
  FGraphics:=nil;
  Result:=True;
end;

procedure TGDIPlusDrawCanvas.SetClip(const AClipRect:TRectF);
begin
  Self.FGraphics.SetClip(TGPRectF_Create(AClipRect));
end;

procedure TGDIPlusDrawCanvas.ResetClip;
begin
  Self.FGraphics.ResetClip;
end;

function RoundSkinPicture(ASkinPicture: TSkinPicture; AXRadius,
  AYRadius: Double): TSkinPicture;
var
  ABitmap:IGPBitmap;
  ARroundBitmap:IGPBitmap;
  AGraphics:IGPGraphics;
  ABrush:IGPBrush;
  AGPImageFormat:TGPImageFormat;
  APngImage:TPngImage;
  AStream:TMemoryStream;
  AAdapter:IStream;
begin
  Result:=nil;

  ABitmap:=nil;
  if ASkinPicture.SkinPictureEngine is TGDIPlusSkinPictureEngine then
  begin
    ABitmap:=TGDIPlusSkinPictureEngine(ASkinPicture.SkinPictureEngine).Bitmap;
  end
  else
  if ASkinPicture.SkinPictureEngine is TGDIPlusSkinGIFPictureEngine then
  begin
    ABitmap:=TGDIPlusSkinGIFPictureEngine(ASkinPicture.SkinPictureEngine).Bitmap;
  end;

  if ABitmap=nil then
  begin
    Exit;
  end;
  ABrush:=TGPTextureBrush.Create(ABitmap);

  ARroundBitmap:=TGPBitmap.Create(ABitmap.Width, ABitmap.Height,PixelFormat32bppARGB);
  AGraphics:=TGPGraphics.Create(ARroundBitmap);
//  AGraphics.DrawImage(ABitmap, TGPRect_Create(0, 0, ABitmap.Width,ABitmap.Height));
  AGraphics.FillEllipse(ABrush,TGPRect_Create(0, 0, ABitmap.Width,ABitmap.Height));


  AGPImageFormat:=TGPImageFormat.Create();

//  ARroundBitmap.Save('C:\round.png',AGPImageFormat.Png);
  AStream:=TMemoryStream.Create;
  AAdapter:=TCFStreamAdapter.Create(AStream, soReference);
  APngImage:=TPngImage.Create;
  try
    ARroundBitmap.Save(AAdapter,AGPImageFormat.Png);
    AStream.Position:=0;

    APngImage.LoadFromStream(AStream);

    Result:=TSkinPicture.Create;
    Result.Assign(APngImage);
  finally
    FreeAndNil(AGPImageFormat);
    FreeAndNil(AStream);
    FreeAndNil(APngImage);
  end;

end;

function TGDIPlusDrawCanvas.CreateGPBrush(ADrawTextParam: TDrawTextParam;var AGPBrush: IGPBrush): Boolean;
var
  AGPColor:TGPColor;
begin
  Result:=False;

  //字体颜色
  AGPColor:=TGPColor_CreateFromColorRef(ADrawTextParam.CurrentEffectFontColor.Color);
  TGPColor_SetAlpha(AGPColor.FArgb,
          Ceil(ADrawTextParam.CurrentEffectFontColor.Alpha
          *ADrawTextParam.DrawAlpha/255)

          );
  AGPBrush:=TGPSolidBrush.Create(AGPColor);

  Result:=True;
end;

function TGDIPlusDrawCanvas.CreateGPStringFormat(ADrawTextParam: TDrawTextParam;var AGPStringFormat:IGPStringFormat): Boolean;
var
  AGPStringFormatFlags:TGPStringFormatFlags;
begin

  Result:=False;

  AGPStringFormatFlags:=[];

//  //确定绘制风格
//  if fftDirectionRightToLeft in ADrawTextParam.FontFormat then
//  begin
//    AGPStringFormatFlags:=AGPStringFormatFlags+[StringFormatFlagsDirectionRightToLeft];
//  end
//  else if fftDirectionVertical in ADrawTextParam.FontFormat then
//  begin
//    AGPStringFormatFlags:=AGPStringFormatFlags+[StringFormatFlagsDirectionVertical];
//  end
//  else if fftDirectionRightToLeft in ADrawTextParam.FontFormat then
//  begin
//    AGPStringFormatFlags:=AGPStringFormatFlags+[StringFormatFlagsDirectionRightToLeft];
//  end
//  else if fftNoFitBlackBox in ADrawTextParam.FontFormat then
//  begin
//    AGPStringFormatFlags:=AGPStringFormatFlags+[StringFormatFlagsNoFitBlackBox];
//  end
//  else if fftDisplayFormatControl in ADrawTextParam.FontFormat then
//  begin
//    AGPStringFormatFlags:=AGPStringFormatFlags+[StringFormatFlagsDisplayFormatControl];
//  end
//  else if fftNoFontFallback in ADrawTextParam.FontFormat then
//  begin
//    AGPStringFormatFlags:=AGPStringFormatFlags+[StringFormatFlagsNoFontFallback];
//  end
//  else if fftMeasureTrailingSpaces in ADrawTextParam.FontFormat then
//  begin
//    AGPStringFormatFlags:=AGPStringFormatFlags+[StringFormatFlagsMeasureTrailingSpaces];
//  end
//  else
  if //(fftNoWrap in ADrawTextParam.FontFormat) or
    not ADrawTextParam.IsWordWrap then
  begin
    AGPStringFormatFlags:=AGPStringFormatFlags+[StringFormatFlagsNoWrap];
  end;
//  else if fftLineLimit in ADrawTextParam.FontFormat then
//  begin
//    AGPStringFormatFlags:=AGPStringFormatFlags+[StringFormatFlagsLineLimit];
//  end
//  else if fftNoClip in ADrawTextParam.FontFormat then
//  begin
//    AGPStringFormatFlags:=AGPStringFormatFlags+[StringFormatFlagsNoClip];
//  end
//  else if fftBypassGDI in ADrawTextParam.FontFormat then
//  begin
//    AGPStringFormatFlags:=AGPStringFormatFlags+[StringFormatFlagsBypassGDI];
//  end;

  AGPStringFormat:=TGPStringFormat.Create(AGPStringFormatFlags);


//type
//  TGPStringTrimming = (
//    StringTrimmingNone              = 0,
//    StringTrimmingCharacter         = 1,
//    StringTrimmingWord              = 2,
//    StringTrimmingEllipsisCharacter = 3,
//    StringTrimmingEllipsisWord      = 4,
//    StringTrimmingEllipsisPath      = 5);
//
//    StringTrimmingNone              = 0,
//    StringTrimmingCharacter         = 1,
//    StringTrimmingWord              = 2,
//    StringTrimmingEllipsisCharacter = 3,
//    StringTrimmingEllipsisWord      = 4,
//    StringTrimmingEllipsisPath      = 5);

  //字体截断
  case ADrawTextParam.FontTrimming of
    fttNone:
    begin
      AGPStringFormat.Trimming:=StringTrimmingNone;
    end;
    fttCharacter:
    begin
      AGPStringFormat.Trimming:=StringTrimmingEllipsisCharacter;
    end;
    fftWord:
    begin
      AGPStringFormat.Trimming:=StringTrimmingEllipsisWord;
    end;
  end;

  //字体水平对齐
  case ADrawTextParam.FontHorzAlign of
    fhaLeft: AGPStringFormat.Alignment:=StringAlignmentNear;
    fhaCenter: AGPStringFormat.Alignment:=StringAlignmentCenter;
    fhaRight: AGPStringFormat.Alignment:=StringAlignmentFar;
  end;

  //字体垂直对齐
  case ADrawTextParam.FontVertAlign of
    fvaTop: AGPStringFormat.LineAlignment:=StringAlignmentNear;
    fvaCenter: AGPStringFormat.LineAlignment:=StringAlignmentCenter;
    fvaBottom: AGPStringFormat.LineAlignment:=StringAlignmentFar;
  end;

  Result:=True;
end;

function TGDIPlusDrawCanvas.CreateGPFont(ADrawTextParam: TDrawTextParam;var AGPFont: IGPFont): Boolean;
var
  AEmSize:Single;
  AGPFontFamily:IGPFontFamily;
  AGPFontStyle:TGPFontStyle;
begin
  Result:=False;

  //确定字体大小
  AEmSize:=Abs(-MulDiv(ADrawTextParam.CurrentEffectFontSize,
                        GetDeviceCaps(Handle,LOGPIXELSY),72))*GetScreenScaleRate;

  //字体风格
  AGPFontStyle:=[];
  if fsBold in ADrawTextParam.CurrentEffectFontStyle then
  begin
    AGPFontStyle:=AGPFontStyle+[FontStyleBold];
  end;
  if fsItalic in ADrawTextParam.CurrentEffectFontStyle then
  begin
    AGPFontStyle:=AGPFontStyle+[FontStyleItalic];
  end;
  if fsUnderline in ADrawTextParam.CurrentEffectFontStyle then
  begin
    AGPFontStyle:=AGPFontStyle+[FontStyleUnderline];
  end;
  if fsStrikeout in ADrawTextParam.CurrentEffectFontStyle then
  begin
    AGPFontStyle:=AGPFontStyle+[FontStyleStrikeout];
  end;

  //创建字体
  if Not GlobalIsUseDefaultFontFamily or (GlobalDefaultFontFamily='') then
  begin
    AGPFontFamily:=TGPFontFamily.Create(ADrawTextParam.CurrentEffectFontName,nil);
  end
  else
  begin
    AGPFontFamily:=TGPFontFamily.Create(GlobalDefaultFontFamily,nil);
  end;
  AGPFont:=TGPFont.Create(AGPFontFamily,AEmSize,AGPFontStyle,UnitPixel);

  Result:=True;
end;

constructor TGDIPlusDrawCanvas.Create;
begin
  inherited;
end;

destructor TGDIPlusDrawCanvas.Destroy;
begin
  inherited;
end;



function TGDIPlusDrawCanvas.DrawDesigningRect(const ADrawRect:TRectF;
                                const ABorderColor:TDelphiColor):Boolean;
var
  AGPPen:IGPPen;
  AGPColor:TGPColor;
begin
  if GlobalIsDrawDesigningRect then
  begin
    AGPColor:=TGPColor_CreateFromColorRef(clGray);
    TGPColor_SetAlpha(AGPColor.FArgb,180);
    AGPPen:=TGPPen.Create(AGPColor);
    AGPPen.DashStyle:=TGPDashStyle.DashStyleDot;
    FGraphics.DrawRectangle(AGPPen,TGPRectF_Create(ADrawRect.Left,ADrawRect.Top,ADrawRect.Width-1,ADrawRect.Height-1));
  end;
end;

function TGDIPlusDrawCanvas.DrawDesigningText(const ADrawRect:TRectF;
                                const AText:String):Boolean;
var
  AGPFont:IGPFont;
  AGPBrush:IGPBrush;
  AGPColor:TGPColor;
  AGPStringFormat:IGPStringFormat;
begin

  if GlobalIsDrawDesigningName then
  begin

    AGPColor:=TGPColor_CreateFromColorRef(clGray);
    TGPColor_SetAlpha(AGPColor.FArgb,180);
    AGPBrush:=TGPSolidBrush.Create(AGPColor);
    AGPStringFormat:=TGPStringFormat.Create();
    AGPFont:=TGPFont.Create('Tahoma',13,[],UnitPixel);
    FGraphics.DrawString(AText,AGPFont,TGPRectF_Create(ADrawRect.Left,ADrawRect.Top,ADrawRect.Width-1,ADrawRect.Height-1),
        AGPStringFormat,AGPBrush);

  end;
end;







//计算字体绘制尺寸
function TGDIPlusDrawCanvas.CalcTextDrawSize(const ADrawTextParam:TDrawTextParam;
                              const AText:String;
                              const ADrawRect:TRectF;
                              var ADrawWidth:TControlSize;
                              var ADrawHeight:TControlSize;
                              const ACalcDrawSizeType:TCalcDrawSizeType):Boolean;
var
  ARect:TGPRectF;
  AGPFont:IGPFont;
  AGPStringFormat:IGPStringFormat;
var
  ADrawRectF:TGPRectF;
begin

  Result:=False;

  CreateGPFont(ADrawTextParam,AGPFont);

  CreateGPStringFormat(ADrawTextParam,AGPStringFormat);


  if Not ADrawTextParam.IsWordWrap then
  begin
      if AText<>'' then
      begin
        ARect:=FGraphics.MeasureString(AText,AGPFont,TGPPointF_Create(0,0),AGPStringFormat);

        ADrawWidth:=Ceil(ARect.Width);
        ADrawHeight:=Ceil(ARect.Height);

      end
      else
      begin
        ARect:=FGraphics.MeasureString('王能',AGPFont,TGPPointF_Create(0,0),AGPStringFormat);

        ADrawWidth:=0;
        ADrawHeight:=Ceil(ARect.Height);

      end;
  end
  else
  begin
      if AText<>'' then
      begin
        ADrawRectF:=TGPRectF_Create(ADrawRect);
        ADrawRectF.Height:=MaxInt;

        ARect:=FGraphics.MeasureString(AText,AGPFont,ADrawRectF,AGPStringFormat);

        ADrawWidth:=Ceil(ARect.Width);
        ADrawHeight:=Ceil(ARect.Height);
      end
      else
      begin
        ARect:=FGraphics.MeasureString('王能',AGPFont,TGPPointF_Create(0,0),AGPStringFormat);

        ADrawWidth:=0;
        ADrawHeight:=Ceil(ARect.Height);
      end;
  end;

  Result:=True;
end;


function TGDIPlusDrawCanvas.DrawLine(const ADrawLineParam:TDrawLineParam;
                                      X1:Double;
                                      Y1:Double;
                                      X2:Double;
                                      Y2:Double):Boolean;
var
  APt1, APt2: TPointF;
  ARectF:TRectF;
var
  AGPPen:IGPPen;
  AGPColor:TGPColor;
begin
  Result:=False;

  if (ADrawLineParam.PenWidth=0)
  then
  begin
    Exit;
  end;


  Result:=True;

  if IsSameDouble(ADrawLineParam.PenWidth,0)
  then
  begin
    Exit;
  end;




  ARectF:=RectF(X1,Y1,X2,Y2);
  ARectF:=ADrawLineParam.CalcDrawRect(ARectF);
  X1:=ARectF.Left;
  Y1:=ARectF.Top;
  X2:=ARectF.Right;
  Y2:=ARectF.Bottom;





  AGPColor:=TGPColor_CreateFromColorRef(ADrawLineParam.Color.Color);
  TGPColor_SetAlpha(AGPColor.FArgb,ADrawLineParam.Color.Alpha);

  AGPPen:=TGPPen.Create(AGPColor, ADrawLineParam.PenWidth);
  FGraphics.DrawLine(AGPPen,X1,Y1,X2,Y2);

  Result:=True;
end;

function TGDIPlusDrawCanvas.DrawPath(ADrawPathParam:TDrawPathParam;const ADrawRect:TRectF):Boolean;
//var
//  AGPPen:IGPPen;
//  AGPColor:TGPColor;
////  AGPPathData:IGPPathData;
////  AGPGraphicsPath:IGPGraphicsPath;
////begin
////  ACanvas.FCanvas.Stroke.Thickness:=ADrawPathData.PenWidth;
////  ACanvas.FCanvas.Stroke.Kind := TBrushKind.Solid;
////  ACanvas.FCanvas.Stroke.Color := ADrawPathData.PenColor.Color;
////  ACanvas.FCanvas.DrawPath(ADrawPathData.PathData,1,ACanvas.FCanvas.Stroke);
//begin
//  Result:=False;
//
////  if (ADrawLineParam.PenWidth=0)
////  then
////  begin
////    Exit;
////  end;
//
//  AGPColor:=TGPColor_CreateFromColorRef(ADrawPathData.PenColor.Color);
//  TGPColor_SetAlpha(AGPColor.FArgb,ADrawPathData.PenColor.Alpha);
//
//  AGPPen:=TGPPen.Create(AGPColor, ADrawPathData.PenWidth);
//
////  AGPPathData:=ADrawPathData.PathData;
////
////  AGPGraphicsPath:=TGPGraphicsPath.Create(
////                     TGPPointArray(AGPPathData.PointPtr),
////                     TByteArray(AGPPathData.TypePtr)
////                     );
//
//  FGraphics.DrawPath(AGPPen,TGDIPlusDrawPathData(ADrawPathData).Path);
//
//  Result:=True;
var
  I: Integer;
  BDrawRect:TRectF;
  APathActionItem:TPathActionItem;
  ADrawPathData:TBaseDrawPathData;
begin
  //根据DrawRectSetting返回需要绘制的实际矩形
  BDrawRect:=ADrawPathParam.CalcDrawRect(ADrawRect);

  ADrawPathData:=TBaseDrawPathData(ADrawPathParam.PathActions.FDrawPathData);

  ADrawPathData.PenWidth:=ADrawPathParam.CurrentEffectPenWidth;
  ADrawPathData.PenColor.Color:=ADrawPathParam.CurrentEffectPenColor.Color;


//  ADrawPathData.Stroke.Thickness:=ADrawPathParam.CurrentEffectPenWidth;
//  ADrawPathData.Stroke.Kind := TBrushKind.Solid;
//  ADrawPathData.Stroke.Color := ADrawPathParam.CurrentEffectPenColor.Color;

//  AGPColor:=TGPColor_CreateFromColorRef(ADrawPathData.PenColor.Color);
//  TGPColor_SetAlpha(AGPColor.FArgb,ADrawPathData.PenColor.Alpha);
//
//  AGPPen:=TGPPen.Create(AGPColor, ADrawPathData.PenWidth);



  ADrawPathData.Clear;
  for I := 0 to ADrawPathParam.PathActions.Count-1 do
  begin
    APathActionItem:=ADrawPathParam.PathActions[I];
    case APathActionItem.ActionType of
      patClear:
      begin
        ADrawPathData.Clear;
      end;
      patMoveTo:
      begin
        ADrawPathData.MoveTo(
                            BDrawRect.Left+(APathActionItem.GetX(BDrawRect)),
                            BDrawRect.Top+(APathActionItem.GetY(BDrawRect))
                            );
      end;
      patCurveTo:
      begin
        ADrawPathData.CurveTo(
                              BDrawRect.Left+APathActionItem.GetX(BDrawRect),
                              BDrawRect.Top+APathActionItem.GetY(BDrawRect),

                              BDrawRect.Left+APathActionItem.GetX1(BDrawRect),
                              BDrawRect.Top+APathActionItem.GetY1(BDrawRect),

                              BDrawRect.Left+APathActionItem.GetX2(BDrawRect),
                              BDrawRect.Top+APathActionItem.GetY2(BDrawRect)
                              );
      end;
      patLineTo:
      begin
        ADrawPathData.LineTo(
                            BDrawRect.Left+(APathActionItem.GetX(BDrawRect)),
                            BDrawRect.Top+(APathActionItem.GetY(BDrawRect))
                            );
      end;
      patDrawPath:
      begin
        if BiggerDouble(ADrawPathParam.CurrentEffectPenWidth,0) then
        begin
//          Self.FGraphics.DrawPath();

          Self.DrawPathData(
                ADrawPathData//,
//                ADrawPathParam.DrawAlpha/255,
//                ADrawPathData.Stroke
                );
        end;
        TGDIPlusDrawPathData(ADrawPathData).Path.Reset;//不然在画CheckBox的勾时,线条会合起来
      end;
      patFillPath:
      begin

          //创建画刷
          FillPathData(ADrawPathParam,ADrawPathData);
//          Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.bkSolid;
//          Self.FCanvas.Fill.Color:=ADrawPathParam.CurrentEffectFillDrawColor.Color;
//
//          Self.FCanvas.FillPath(
//                ADrawPathData.Path,
//                ADrawPathParam.DrawAlpha/255,
//                Self.FCanvas.Fill);

      end;
    end;
  end;
end;

function TGDIPlusDrawCanvas.DrawPathData(ADrawPathData: TBaseDrawPathData): Boolean;
var
  AGPPen:IGPPen;
  AGPColor:TGPColor;
//  AGPPathData:IGPPathData;
//  AGPGraphicsPath:IGPGraphicsPath;
//begin
//  ACanvas.FCanvas.Stroke.Thickness:=ADrawPathData.PenWidth;
//  ACanvas.FCanvas.Stroke.Kind := TBrushKind.Solid;
//  ACanvas.FCanvas.Stroke.Color := ADrawPathData.PenColor.Color;
//  ACanvas.FCanvas.DrawPath(ADrawPathData.PathData,1,ACanvas.FCanvas.Stroke);
begin
  Result:=False;
//  Self.FCanvas.Stroke.Thickness:=ADrawPathData.PenWidth;
//  Self.FCanvas.Stroke.Kind := TBrushKind.Solid;
//  Self.FCanvas.Stroke.Color := ADrawPathData.PenColor.Color;
//  Self.FCanvas.DrawPath(TGDIPlusDrawPathData(ADrawPathData).Path,1,Self.FCanvas.Stroke);

//  if (ADrawLineParam.PenWidth=0)
//  then
//  begin
//    Exit;
//  end;

  AGPColor:=TGPColor_CreateFromColorRef(ADrawPathData.PenColor.Color);
  TGPColor_SetAlpha(AGPColor.FArgb,ADrawPathData.PenColor.Alpha);

  AGPPen:=TGPPen.Create(AGPColor, ADrawPathData.PenWidth);

//  AGPPathData:=ADrawPathData.PathData;
//
//  AGPGraphicsPath:=TGPGraphicsPath.Create(
//                     TGPPointArray(AGPPathData.PointPtr),
//                     TByteArray(AGPPathData.TypePtr)
//                     );

//  TGDIPlusDrawPathData(ADrawPathData).Path.FillMode
  FGraphics.DrawPath(AGPPen,TGDIPlusDrawPathData(ADrawPathData).Path);

  Result:=True;
end;

function TGDIPlusDrawCanvas.DrawSkinPicture(const ADrawPictureParam:TDrawPictureParam;
                            const ASkinPicture:TSkinPicture;
                            const ADrawRect:TRectF;
                            const AIsUseSrcRectAndDestDrawRect:Boolean;
                            const AImageSrcRect:TRectF;
                            const AImageDestDrawRect:TRectF
                            ):Boolean;
var
  ABitmap:IGPBitmap;


  BDrawRect:TRectF;
  BImageDestDrawRect:TRectF;
  BImageSrcRect:TRectF;


  ALargeImageDestDrawRect:TRectF;
  ALargeImageSrcDrawRect:TRectF;
  AGPColorMatrix:TGPColorMatrix;
  AGPImageAttributes:IGPImageAttributes;
begin
  Result:=True;




  ABitmap:=nil;
  if ASkinPicture.SkinPictureEngine is TGDIPlusSkinPictureEngine then
  begin
    ABitmap:=TGDIPlusSkinPictureEngine(ASkinPicture.SkinPictureEngine).Bitmap;
  end
  else
  if ASkinPicture.SkinPictureEngine is TGDIPlusSkinGIFPictureEngine then
  begin
    ABitmap:=TGDIPlusSkinGIFPictureEngine(ASkinPicture.SkinPictureEngine).Bitmap;
  end;

  if ABitmap=nil then
  begin
    Exit;
  end;

  if (RectWidthF(ADrawRect)<=0) or (RectHeightF(ADrawRect)<=0) then Exit;




  BDrawRect:=ADrawPictureParam.CalcDrawRect(ADrawRect);
  BImageDestDrawRect:=AImageDestDrawRect;
  BImageSrcRect:=AImageSrcRect;





  if Not AIsUseSrcRectAndDestDrawRect then
  begin
//    Self.CalcImageDrawRect(ADrawPictureParam,ASkinPicture.Width,ASkinPicture.Height,BDrawRect,AImageDestDrawRect);
    //计算最终绘制的矩形
    CalcImageDrawRect(ADrawPictureParam,
                          ASkinPicture.Width,
                          ASkinPicture.Height,
                          BDrawRect,
                          BImageDestDrawRect
                          );
    BImageSrcRect:=RectF(0,0,ASkinPicture.Width,ASkinPicture.Height);
  end;





  AGPImageAttributes:=nil;

  if //ADrawPictureParam.IsGray or
  (ADrawPictureParam.Alpha<>255) then
  begin

    TGPColorMatrix_SetToIdentity(AGPColorMatrix);

//    if ADrawPictureParam.IsGray then
//    begin
//      AGPColorMatrix.M[0, 0]:=0.3;
//      AGPColorMatrix.M[0, 1]:=0.3;
//      AGPColorMatrix.M[0, 2]:=0.3;
//      AGPColorMatrix.M[1, 0]:=0.59;
//      AGPColorMatrix.M[1, 1]:=0.59;
//      AGPColorMatrix.M[1, 2]:=0.59;
//      AGPColorMatrix.M[2, 0]:=0.11;
//      AGPColorMatrix.M[2, 1]:=0.11;
//      AGPColorMatrix.M[2, 2]:=0.11;
//    end;

    if ADrawPictureParam.Alpha<>255 then
    begin
      AGPColorMatrix.M[3, 3]:=ADrawPictureParam.Alpha / 255;
    end;

    AGPImageAttributes:=TGPImageAttributes.Create;
    AGPImageAttributes.SetColorMatrix(AGPColorMatrix);

  end
  else
  begin
    AGPImageAttributes:=nil;
  end;




  if ADrawPictureParam.IsStretch then
  begin

    case ADrawPictureParam.StretchStyle of
      issThreePartHorz:
      begin
        if (RectWidthF(BImageSrcRect)>=ADrawPictureParam.StretchMargins.Left+ADrawPictureParam.StretchMargins.Right)
          and (RectWidthF(BImageDestDrawRect)>=RectWidthF(BImageSrcRect)) then
        begin
          //DrawLeftSide
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Left,BImageDestDrawRect.Top,ADrawPictureParam.StretchMargins.Left,Ceil(RectHeightF(BImageDestDrawRect))),
                    BImageSrcRect.Left,BImageSrcRect.Top,ADrawPictureParam.StretchMargins.Left,BImageSrcRect.Bottom,
                    UnitPixel);
          //DrawRightSide
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Right-ADrawPictureParam.StretchMargins.Right,BImageDestDrawRect.Top,ADrawPictureParam.StretchMargins.Right,RectHeightF(BImageDestDrawRect)),
                    BImageSrcRect.Right-ADrawPictureParam.StretchMargins.Right,BImageSrcRect.Top,ADrawPictureParam.StretchMargins.Right,BImageSrcRect.Bottom,
                    UnitPixel);

          //DrawCenterBlock
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Left+ADrawPictureParam.StretchMargins.Left,BImageDestDrawRect.Top,RectWidthF(BImageDestDrawRect)-ADrawPictureParam.StretchMargins.Left-ADrawPictureParam.StretchMargins.Right,RectHeightF(BImageDestDrawRect)),
                    BImageSrcRect.Left+ADrawPictureParam.StretchMargins.Left,BImageSrcRect.Top,
                    RectWidthF(BImageSrcRect)-ADrawPictureParam.StretchMargins.Left-ADrawPictureParam.StretchMargins.Right,
                    RectHeightF(BImageSrcRect),
                    UnitPixel);
        end
        else
        begin
          case ADrawPictureParam.PictureTooSmallProcessType of
            itsptTensile:
            begin
              FGraphics.DrawImage(ABitmap,
                                  TGPRectF_Create(BImageDestDrawRect),
                                  BImageSrcRect.Left,BImageSrcRect.Top,RectWidthF(BImageSrcRect),RectHeightF(BImageSrcRect),
                                  UnitPixel,
                                  AGPImageAttributes);
            end;
            itsptPart:
            begin
              //DrawLeftSide
              FGraphics.DrawImage(ABitmap,
                        TGPRectF_Create(BImageDestDrawRect),
                        BImageSrcRect.Left,BImageSrcRect.Top,
                        RectWidthF(BImageDestDrawRect),
                        BImageSrcRect.Bottom,
                        UnitPixel);

            end;
          end;
        end;

      end;
      issThreePartVert:
      begin
        if (RectHeightF(BImageSrcRect)>=ADrawPictureParam.StretchMargins.Top+ADrawPictureParam.StretchMargins.Bottom)
          and (RectHeightF(BImageDestDrawRect)>=RectHeightF(BImageSrcRect)) then
        begin

          //DrawTopSide
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Left,BImageDestDrawRect.Top,
                                  RectWidthF(BImageDestDrawRect),ADrawPictureParam.StretchMargins.Top),
                    BImageSrcRect.Left,BImageSrcRect.Top,
                    RectWidthF(BImageSrcRect),ADrawPictureParam.StretchMargins.Top,
                    UnitPixel);
          //DrawBottomSide
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Left,BImageDestDrawRect.Bottom-ADrawPictureParam.StretchMargins.Bottom,
                                    RectWidthF(BImageDestDrawRect),ADrawPictureParam.StretchMargins.Bottom),
                    BImageSrcRect.Left,BImageSrcRect.Bottom-ADrawPictureParam.StretchMargins.Bottom,
                    RectWidthF(BImageSrcRect),ADrawPictureParam.StretchMargins.Bottom,
                    UnitPixel);

          //DrawCenterBlock
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Left,BImageDestDrawRect.Top+ADrawPictureParam.StretchMargins.Top,RectWidthF(BImageDestDrawRect),RectHeightF(BImageDestDrawRect)-ADrawPictureParam.StretchMargins.Top-ADrawPictureParam.StretchMargins.Bottom),
                                  BImageSrcRect.Left,BImageSrcRect.Top+ADrawPictureParam.StretchMargins.Top,
                    RectWidthF(BImageSrcRect),
                    RectHeightF(BImageSrcRect)-ADrawPictureParam.StretchMargins.Top-ADrawPictureParam.StretchMargins.Bottom,
                    UnitPixel);
        end
        else
        begin
          case ADrawPictureParam.PictureTooSmallProcessType of
            itsptTensile:
            begin
              FGraphics.DrawImage(ABitmap,
                                  TGPRectF_Create(BImageDestDrawRect),
                                  BImageSrcRect.Left,BImageSrcRect.Top,RectWidthF(BImageSrcRect),RectHeightF(BImageSrcRect),
                                  UnitPixel,
                                  AGPImageAttributes);
            end;
            itsptPart:
            begin
              //DrawTopSide
              FGraphics.DrawImage(ABitmap,
                        TGPRectF_Create(BImageDestDrawRect),
                        BImageSrcRect.Left,BImageSrcRect.Top,
                        BImageSrcRect.Right,
                        RectHeightF(BImageDestDrawRect),
                        UnitPixel);

            end;
          end;
        end;

      end;

      issSquare:
      begin

        if (RectWidthF(BImageSrcRect)>=ADrawPictureParam.StretchMargins.Left+ADrawPictureParam.StretchMargins.Right)
        and (RectHeightF(BImageSrcRect)>=ADrawPictureParam.StretchMargins.Top+ADrawPictureParam.StretchMargins.Bottom)
          and ((RectWidthF(BImageDestDrawRect)>=RectWidthF(BImageSrcRect)))
            or ((RectHeightF(BImageDestDrawRect)>=RectHeightF(BImageSrcRect))) then
        begin

          //DrawLeftTopBlock
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Left,BImageDestDrawRect.Top,ADrawPictureParam.StretchMargins.Left,ADrawPictureParam.StretchMargins.Top),
                    BImageSrcRect.Left,BImageSrcRect.Top,ADrawPictureParam.StretchMargins.Left,ADrawPictureParam.StretchMargins.Top,
                    UnitPixel);
          //DrawRightTopBlock
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Right-ADrawPictureParam.StretchMargins.Right,BImageDestDrawRect.Top,ADrawPictureParam.StretchMargins.Right,ADrawPictureParam.StretchMargins.Top),
                    BImageSrcRect.Right-ADrawPictureParam.StretchMargins.Right,BImageSrcRect.Top,ADrawPictureParam.StretchMargins.Right,ADrawPictureParam.StretchMargins.Top,
                    UnitPixel);
          //DrawLeftBottomBlock
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Left,BImageDestDrawRect.Bottom-ADrawPictureParam.StretchMargins.Bottom,ADrawPictureParam.StretchMargins.Left,ADrawPictureParam.StretchMargins.Bottom),
                    BImageSrcRect.Left,BImageSrcRect.Bottom-ADrawPictureParam.StretchMargins.Bottom,ADrawPictureParam.StretchMargins.Left,ADrawPictureParam.StretchMargins.Bottom,
                    UnitPixel);
          //DrawRightBottomBlock
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Right-ADrawPictureParam.StretchMargins.Right,BImageDestDrawRect.Bottom-ADrawPictureParam.StretchMargins.Bottom,ADrawPictureParam.StretchMargins.Right,ADrawPictureParam.StretchMargins.Bottom),
                    BImageSrcRect.Right-ADrawPictureParam.StretchMargins.Right,BImageSrcRect.Bottom-ADrawPictureParam.StretchMargins.Bottom,ADrawPictureParam.StretchMargins.Right,ADrawPictureParam.StretchMargins.Bottom,
                    UnitPixel);

          //DrawTopSide
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Left+ADrawPictureParam.StretchMargins.Left,BImageDestDrawRect.Top,RectWidthF(BImageDestDrawRect)-ADrawPictureParam.StretchMargins.Left-ADrawPictureParam.StretchMargins.Right,ADrawPictureParam.StretchMargins.Top),
                    BImageSrcRect.Left+ADrawPictureParam.StretchMargins.Left,BImageSrcRect.Top,BImageSrcRect.Right-ADrawPictureParam.StretchMargins.Left-ADrawPictureParam.StretchMargins.Right,ADrawPictureParam.StretchMargins.Top,
                    UnitPixel);
          //DrawBottomSide
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Left+ADrawPictureParam.StretchMargins.Left,BImageDestDrawRect.Bottom-ADrawPictureParam.StretchMargins.Bottom,RectWidthF(BImageDestDrawRect)-ADrawPictureParam.StretchMargins.Left-ADrawPictureParam.StretchMargins.Right,ADrawPictureParam.StretchMargins.Bottom),
                    BImageSrcRect.Left+ADrawPictureParam.StretchMargins.Left,BImageSrcRect.Bottom-ADrawPictureParam.StretchMargins.Bottom,BImageSrcRect.Right-ADrawPictureParam.StretchMargins.Left-ADrawPictureParam.StretchMargins.Right,ADrawPictureParam.StretchMargins.Bottom,
                    UnitPixel);

          //DrawLeftSide
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Left,BImageDestDrawRect.Top+ADrawPictureParam.StretchMargins.Top,ADrawPictureParam.StretchMargins.Left,RectHeightF(BImageDestDrawRect)-ADrawPictureParam.StretchMargins.Top-ADrawPictureParam.StretchMargins.Bottom),
                    BImageSrcRect.Left,BImageSrcRect.Top+ADrawPictureParam.StretchMargins.Top,ADrawPictureParam.StretchMargins.Left,BImageSrcRect.Bottom-ADrawPictureParam.StretchMargins.Top-ADrawPictureParam.StretchMargins.Bottom,
                    UnitPixel);
          //DrawRightSide
          FGraphics.DrawImage(ABitmap,
                    TGPRectF_Create(BImageDestDrawRect.Right-ADrawPictureParam.StretchMargins.Right,BImageDestDrawRect.Top+ADrawPictureParam.StretchMargins.Top,ADrawPictureParam.StretchMargins.Right,RectHeightF(BImageDestDrawRect)-ADrawPictureParam.StretchMargins.Top-ADrawPictureParam.StretchMargins.Bottom),
                    BImageSrcRect.Right-ADrawPictureParam.StretchMargins.Right,BImageSrcRect.Top+ADrawPictureParam.StretchMargins.Top,ADrawPictureParam.StretchMargins.Right,BImageSrcRect.Bottom-ADrawPictureParam.StretchMargins.Top-ADrawPictureParam.StretchMargins.Bottom,
                    UnitPixel);



          //DrawCenterBlock
//          if ADrawPictureParam.IsDrawSquareCenterBlock then
//          begin
            FGraphics.DrawImage(ABitmap,
                      TGPRectF_Create(BImageDestDrawRect.Left+ADrawPictureParam.StretchMargins.Left,BImageDestDrawRect.Top+ADrawPictureParam.StretchMargins.Top,RectWidthF(BImageDestDrawRect)-ADrawPictureParam.StretchMargins.Left-ADrawPictureParam.StretchMargins.Right,RectHeightF(BImageDestDrawRect)-ADrawPictureParam.StretchMargins.Top-ADrawPictureParam.StretchMargins.Bottom),
                      BImageSrcRect.Left+ADrawPictureParam.StretchMargins.Left,BImageSrcRect.Top+ADrawPictureParam.StretchMargins.Top,
                      RectWidthF(BImageSrcRect)-ADrawPictureParam.StretchMargins.Left-ADrawPictureParam.StretchMargins.Right,
                      RectHeightF(BImageSrcRect)-ADrawPictureParam.StretchMargins.Top-ADrawPictureParam.StretchMargins.Bottom,
                      UnitPixel);
//          end;


        end
        else
        begin
          FGraphics.DrawImage(ABitmap,
                              TGPRectF_Create(BImageDestDrawRect),
                              BImageSrcRect.Left,BImageSrcRect.Top,RectWidthF(BImageSrcRect),RectHeightF(BImageSrcRect),
                              UnitPixel,
                              AGPImageAttributes);
        end;

      end
      else
      begin
        FGraphics.DrawImage(ABitmap,
                            TGPRectF_Create(BImageDestDrawRect),
                            BImageSrcRect.Left,BImageSrcRect.Top,RectWidthF(BImageSrcRect),RectHeightF(BImageSrcRect),
                            UnitPixel,
                            AGPImageAttributes);
      end;
    end;

  end
  else
  begin

    //没有拉伸,原图比较大
    if
      (
        (RectWidthF(BImageDestDrawRect)>RectWidthF(BDrawRect))
        or (RectHeightF(BImageDestDrawRect)>RectHeightF(BDrawRect))
      )
      and (ADrawPictureParam.PictureTooLargeProcessType=itlptPart) then
    begin
        //(0, 0, 694, 585, (0, 0), (694, 585))
        //超出
        //BDrawRect (-299, -76, 395, 509, (-299, -76), (395, 509))

        //在里面
        //BDrawRect (79, 41, 773, 626, (79, 41), (773, 626))


        //目标矩形(不会超出控件的区域)
        ALargeImageDestDrawRect:=BDrawRect;
        if BDrawRect.Left>=0 then
        begin
          ALargeImageDestDrawRect.Left:=BDrawRect.Left;
          ALargeImageDestDrawRect.Right:=RectWidthF(BDrawRect);
        end
        else
        begin
          ALargeImageDestDrawRect.Left:=0;
          ALargeImageDestDrawRect.Right:=RectWidthF(BDrawRect)-ALargeImageDestDrawRect.Left;
        end;
        if BDrawRect.Top>=0 then
        begin
          ALargeImageDestDrawRect.Top:=BDrawRect.Top;
          ALargeImageDestDrawRect.Bottom:=RectHeightF(BDrawRect);
        end
        else
        begin
          ALargeImageDestDrawRect.Top:=0;
          ALargeImageDestDrawRect.Bottom:=RectHeightF(BDrawRect)-ALargeImageDestDrawRect.Top;
        end;


        //源图片的绘制矩形
        ALargeImageSrcDrawRect:=BDrawRect;
        if BDrawRect.Left>=0 then
        begin
          ALargeImageSrcDrawRect.Left:=0;
          ALargeImageSrcDrawRect.Right:=RectWidthF(BDrawRect)-BDrawRect.Left;
        end
        else
        begin
          ALargeImageSrcDrawRect.Left:=-BDrawRect.Left;
          ALargeImageSrcDrawRect.Right:=ALargeImageSrcDrawRect.Left+RectWidthF(BDrawRect);
        end;
        if BDrawRect.Top>=0 then
        begin
          ALargeImageSrcDrawRect.Top:=0;
          ALargeImageSrcDrawRect.Bottom:=RectHeightF(BDrawRect)-BDrawRect.Top;
        end
        else
        begin
          ALargeImageSrcDrawRect.Top:=-BDrawRect.Top;
          ALargeImageSrcDrawRect.Bottom:=ALargeImageSrcDrawRect.Top+RectHeightF(BDrawRect);
        end;





        //Left,Top小于0的时候,超出范围

        FGraphics.DrawImage(ABitmap,

                            TGPRectF_Create(ALargeImageDestDrawRect),

                            ALargeImageSrcDrawRect.Left,
                            ALargeImageSrcDrawRect.Top,
                            RectWidthF(ALargeImageSrcDrawRect),
                            RectHeightF(ALargeImageSrcDrawRect),
  //                          RectWidthF(BDrawRect),
  //                          RectHeightF(BDrawRect),

                            UnitPixel,
                            AGPImageAttributes);
    end
    else
    begin
      FGraphics.DrawImage(ABitmap,
                          TGPRectF_Create(BImageDestDrawRect),
                          BImageSrcRect.Left,BImageSrcRect.Top,RectWidthF(BImageSrcRect),RectHeightF(BImageSrcRect),
                          UnitPixel,
                          AGPImageAttributes);
    end;

  end;

end;

//function TGDIPlusDrawCanvas.DrawPolygon(ADrawPolygonParam:TDrawPolygonParam;const ADrawPoints: array of TPoint):Boolean;
//var
//  AGPPointF: array of TGPPointF;
//  AGPPath:IGPGraphicsPath;
//  AGPPen:IGPPen;
//  AGPBrush:IGPBrush;
//  AGPFillColor:TGPColor;
//  AGPBorderColor:TGPColor;
//  AGPLinearGradientFillColor1:TGPColor;
//  AGPLinearGradientFillColor2:TGPColor;
//  AGPLinearGradientMode:TGPLinearGradientMode;
//  I: Integer;
//begin
//
//  if Not ADrawPolygonParam.IsFill
//    and (ADrawPolygonParam.CurrentEffectBorderWidth=0)
//  then
//  begin
//    Exit;
//  end;
//
//
//  SetLength(AGPPointF,Length(ADrawPoints));
//  for I := 0 to Length(ADrawPoints) - 1 do
//  begin
//    AGPPointF[I].X:=ADrawPoints[I].X;
//    AGPPointF[I].Y:=ADrawPoints[I].Y;
//  end;
//
//  AGPPath:=TGPGraphicsPath.Create(FillModeAlternate);
//  AGPPath.AddPolygon(AGPPointF);
//
//
//  if ADrawPolygonParam.IsFill then
//  begin
//    //创建画刷
//    if  ADrawPolygonParam.LinearGradientType=lgtNone then
//    begin
//      AGPFillColor:=TGPColor_CreateFromColorRef(ADrawPolygonParam.FillColor.Color);
//      TGPColor_SetAlpha(AGPFillColor.FArgb,ADrawPolygonParam.FillColor.Alpha);
//      AGPBrush:=TGPSolidBrush.Create(AGPFillColor);
//    end
//    else
//    begin
//      AGPLinearGradientFillColor1:=TGPColor_CreateFromColorRef(ADrawPolygonParam.LinearGradientFillColor1.Color);
//      TGPColor_SetAlpha(AGPLinearGradientFillColor1.FArgb,ADrawPolygonParam.LinearGradientFillColor1.Alpha);
//      AGPLinearGradientFillColor2:=TGPColor_CreateFromColorRef(ADrawPolygonParam.LinearGradientFillColor2.Color);
//      TGPColor_SetAlpha(AGPLinearGradientFillColor2.FArgb,ADrawPolygonParam.LinearGradientFillColor2.Alpha);
//      case ADrawPolygonParam.LinearGradientType of
//        lgtVert: AGPLinearGradientMode:=LinearGradientModeVertical;
//        lgtHorz: AGPLinearGradientMode:=LinearGradientModeHorizontal;
//      end;
//    end;
//
//    FGraphics.FillPath(AGPBrush,AGPPath);
//  end;
//
//  if (ADrawPolygonParam.CurrentEffectBorderWidth>0) then
//  begin
//    //创建画笔
//    AGPBorderColor:=TGPColor_CreateFromColorRef(ADrawPolygonParam.BorderColor.Color);
//    TGPColor_SetAlpha(AGPBorderColor.FArgb,ADrawPolygonParam.BorderColor.Alpha);
//    AGPPen:=TGPPen.Create(AGPBorderColor, ADrawPolygonParam.CurrentEffectBorderWidth);
//    AGPPen.Alignment:=PenAlignmentInset;
//
//    FGraphics.DrawPath(AGPPen,AGPPath);
//  end;
//
//  SetLength(AGPPointF,0);
//end;

function TGDIPlusDrawCanvas.DrawRect(const ADrawRectParam:TDrawRectParam;
                      const ADrawRect:TRectF):Boolean;
var
  ASides:TSides;


  AGPPath:IGPGraphicsPath;
  AGPPen:IGPPen;

  BDrawRect:TRectF;
  AFillRect:TRectF;
  ABorderRect:TRectF;
  ARoundDrawRect:TRectF;


  AGPBrush:IGPBrush;
  AGPFillColor:TGPColor;
  AGPBorderColor:TGPColor;
  AGPLinearGradientFillColor1:TGPColor;
  AGPLinearGradientFillColor2:TGPColor;
  AGPLinearGradientMode:TGPLinearGradientMode;

  ALineFix:Integer;
  ADrawRectParam_RoundWidth:Double;
  ADrawRectParam_RoundHeight:Double;
begin
  AGPPath:=nil;

  if Not ADrawRectParam.CurrentEffectIsFill
    and (ADrawRectParam.CurrentEffectBorderWidth=0)
  then
  begin
    Exit;
  end;

  BDrawRect:=ADrawRectParam.CalcDrawRect(ADrawRect);


  AFillRect:=BDrawRect;




  //圆角
  //生成圆角Path
  if ADrawRectParam.IsRound then
  begin
      FGraphics.SetSmoothingMode(TGPSmoothingMode.SmoothingModeHighQuality);


      ARoundDrawRect:=BDrawRect;

      
      ADrawRectParam_RoundWidth:=ADrawRectParam.RoundWidth;
      ADrawRectParam_RoundHeight:=ADrawRectParam.RoundHeight;
      if ADrawRectParam_RoundWidth=-1 then
      begin
        ADrawRectParam_RoundWidth:=AFillRect.Width / 2;
        ADrawRectParam_RoundHeight:=AFillRect.Height / 2;
      end;

      
      //要减一,不然右底边框被会挡住
      ARoundDrawRect.Right:=ARoundDrawRect.Right-1;
      ARoundDrawRect.Bottom:=ARoundDrawRect.Bottom-1;



      AGPPath:=TGPGraphicsPath.Create(FillModeAlternate);



      //左上角
      AGPPath.AddArc(ARoundDrawRect.Left,
                      ARoundDrawRect.Top,
                      ADrawRectParam_RoundWidth*2, ADrawRectParam_RoundHeight*2, 180, 90);
      //右上角
      AGPPath.AddArc(ARoundDrawRect.Right - ADrawRectParam_RoundWidth*2,
                      ARoundDrawRect.Top,
                      ADrawRectParam_RoundWidth*2, ADrawRectParam_RoundHeight*2, 270, 90);
      //右下角，由２改３，因为２不够大
      AGPPath.AddArc(ARoundDrawRect.Right - ADrawRectParam_RoundWidth*3,
                    ARoundDrawRect.Bottom - ADrawRectParam_RoundHeight*3,
                    ADrawRectParam_RoundWidth*3, ADrawRectParam_RoundHeight*3, 0, 90);
      //左下圆角
      AGPPath.AddArc(ARoundDrawRect.Left,
                    ARoundDrawRect.Bottom - ADrawRectParam_RoundHeight*2,
                    ADrawRectParam_RoundWidth*2, ADrawRectParam_RoundHeight*2, 90, 90);


      ALineFix:=1;
  //    //顶部横线
  //    AGPPath.AddLine(ARoundDrawRect.Left+ADrawRectParam_RoundWidth/2-ALineFix,
  //                      ARoundDrawRect.Top,
  //                      ARoundDrawRect.Right-ADrawRectParam_RoundWidth/2+ALineFix,
  //                      ARoundDrawRect.Top);
  //
  //    //右部竖线
  //    AGPPath.AddLine(ARoundDrawRect.Right,
  //                      ARoundDrawRect.Top+ADrawRectParam_RoundHeight/2-ALineFix,
  //                      ARoundDrawRect.Right,
  //                      ARoundDrawRect.Bottom - ADrawRectParam_RoundHeight/2+ALineFix);
  //
  //    //底部横线
  //    AGPPath.AddLine(ARoundDrawRect.Right-ADrawRectParam_RoundWidth/2+ALineFix,
  //                      ARoundDrawRect.Bottom,
  //                      ARoundDrawRect.Left+ADrawRectParam_RoundWidth/2-ALineFix,
  //                      ARoundDrawRect.Bottom
  //                      );

      //左部竖线
      AGPPath.AddLine(ARoundDrawRect.Left,
                        ARoundDrawRect.Bottom - ADrawRectParam_RoundHeight+ALineFix,
                        ARoundDrawRect.Left,
                        ARoundDrawRect.Top+ADrawRectParam_RoundHeight-ALineFix);


  end;



  //当前需要填充
  if ADrawRectParam.CurrentEffectIsFill then
  begin

      //去掉边框
      if ADrawRectParam.CurrentEffectBorderWidth>0 then
      begin
        AFillRect.Left:=BDrawRect.Left+ADrawRectParam.CurrentEffectBorderWidth-1;
        AFillRect.Top:=BDrawRect.Top+ADrawRectParam.CurrentEffectBorderWidth-1;
        AFillRect.Right:=BDrawRect.Right-ADrawRectParam.CurrentEffectBorderWidth;
        AFillRect.Bottom:=BDrawRect.Bottom-ADrawRectParam.CurrentEffectBorderWidth;
      end;


      //创建画刷
      AGPFillColor:=TGPColor_CreateFromColorRef(ADrawRectParam.CurrentEffectFillDrawColor.Color);
      TGPColor_SetAlpha(AGPFillColor.FArgb,ADrawRectParam.CurrentEffectFillDrawColor.Alpha);
      AGPBrush:=TGPSolidBrush.Create(AGPFillColor);

      if Not ADrawRectParam.IsRound then
      begin
        FGraphics.FillRectangle(AGPBrush, TGPRectF_Create(AFillRect));
      end
      else
      begin
      
          if (ADrawRectParam.RoundWidth=-1) and (ADrawRectParam.RoundHeight=-1) then
          begin
            FGraphics.FillEllipse(AGPBrush,TGPRectF_Create(AFillRect));
        
          end
          else
          begin
            //要画边框
            FGraphics.FillPath(AGPBrush,AGPPath);
          end;

//        //测试
//        AGPBorderColor:=TGPColor_CreateFromColorRef(ADrawRectParam.CurrentEffectBorderColor.Color);
//        TGPColor_SetAlpha(AGPBorderColor.FArgb,ADrawRectParam.BorderColor.Alpha);
//        AGPPen:=TGPPen.Create(AGPBorderColor, 1);
//        AGPPen.Alignment:=PenAlignmentInset;
//        FGraphics.DrawPath(AGPPen,AGPPath);
      end;

  end;






  //边
  ASides:=[TSide.Top, TSide.Left, TSide.Bottom, TSide.Right];
  if not (beLeft in ADrawRectParam.BorderEadges) then ASides:=ASides-[TSide.Left];
  if not (beTop in ADrawRectParam.BorderEadges) then ASides:=ASides-[TSide.Top];
  if not (beRight in ADrawRectParam.BorderEadges) then ASides:=ASides-[TSide.Right];
  if not (beBottom in ADrawRectParam.BorderEadges) then ASides:=ASides-[TSide.Bottom];






  //边框
  if (ADrawRectParam.CurrentEffectBorderWidth>0) then
  begin

      //边框做较正
      if ADrawRectParam.CurrentEffectBorderWidth=1 then
      begin
        ABorderRect.Left:=BDrawRect.Left;
        ABorderRect.Top:=BDrawRect.Top;
        ABorderRect.Right:=BDrawRect.Right-1;
        ABorderRect.Bottom:=BDrawRect.Bottom-1;
      end
      else
      begin
        ABorderRect.Left:=BDrawRect.Left;
        ABorderRect.Top:=BDrawRect.Top;
        ABorderRect.Right:=BDrawRect.Right;
        ABorderRect.Bottom:=BDrawRect.Bottom;
      end;



      if ASides=[TSide.Top, TSide.Left, TSide.Bottom, TSide.Right] then
      begin

          //四边都全
          if ADrawRectParam.IsRound then
          begin
//            ABorderRect:=BDrawRect;
//            AGPPath:=TGPGraphicsPath.Create(FillModeAlternate);
//            AGPPath.AddArc(ABorderRect.Left,
//                            ABorderRect.Top,
//                            ADrawRectParam_RoundWidth*2,
//                            ADrawRectParam_RoundHeight*2,
//                            180, 90);
//            AGPPath.AddArc(ABorderRect.Left+RectWidthF(ABorderRect) - ADrawRectParam_RoundWidth*2,
//                            ABorderRect.Top,
//                            ADrawRectParam_RoundWidth*2,
//                            ADrawRectParam_RoundHeight*2,
//                            270, 90);
//            AGPPath.AddArc(ABorderRect.Left+RectWidthF(ABorderRect) - ADrawRectParam_RoundWidth*2,
//                          ABorderRect.Bottom - ADrawRectParam_RoundHeight*2,
//                          ADrawRectParam_RoundWidth*2,
//                          ADrawRectParam_RoundHeight*2, 0, 90);
//            AGPPath.AddArc(ABorderRect.Left,
//                            ABorderRect.Bottom - ADrawRectParam_RoundHeight*2,
//                            ADrawRectParam_RoundWidth*2,
//                            ADrawRectParam_RoundHeight*2,
//                            90, 90);
//            AGPPath.AddLine(ABorderRect.Left,
//                            ABorderRect.Top+ADrawRectParam_RoundHeight,
//                            ABorderRect.Left,
//                            ABorderRect.Bottom - ADrawRectParam_RoundHeight);
          end;


      end
      else
      begin
          //少边
          AGPPath:=TGPGraphicsPath.Create(FillModeAlternate);

//          if ADrawRectParam.IsRound then
//          begin
//
//          end
//          else
//          begin
              if TSide.Left in ASides then
              begin
                AGPPath.AddLine(ABorderRect.Left, ABorderRect.Bottom, ABorderRect.Left, ABorderRect.Top);
              end;
              if TSide.Top in ASides then
              begin
                AGPPath.AddLine(ABorderRect.Left, ABorderRect.Top, ABorderRect.Right, ABorderRect.Top);
              end;
              if TSide.Right in ASides then
              begin
                AGPPath.AddLine(ABorderRect.Right, ABorderRect.Top, ABorderRect.Right, ABorderRect.Bottom);
              end;
              if TSide.Bottom in ASides then
              begin
                AGPPath.AddLine(ABorderRect.Right, ABorderRect.Bottom, ABorderRect.Left, ABorderRect.Bottom);
              end;
//          end;

      end;

      //创建画笔
      AGPBorderColor:=TGPColor_CreateFromColorRef(ADrawRectParam.CurrentEffectBorderColor.Color);
      TGPColor_SetAlpha(AGPBorderColor.FArgb,ADrawRectParam.BorderColor.Alpha);
      AGPPen:=TGPPen.Create(AGPBorderColor, ADrawRectParam.CurrentEffectBorderWidth);
      AGPPen.Alignment:=PenAlignmentInset;



      if AGPPath=nil then
      begin
        FGraphics.DrawRectangle(AGPPen, TGPRectF_Create(ABorderRect));
      end
      else
      begin
        FGraphics.DrawPath(AGPPen,AGPPath);
      end;



  end;




end;

function TGDIPlusDrawCanvas.DrawText(const ADrawTextParam:TDrawTextParam;
                      const AText:String;
                      const ADrawRect:TRectF;
                      const AColorTextList:IColorTextList=nil):Boolean;
var
  AGPFont:IGPFont;
  AGPBrush:IGPBrush;

  BDrawRect:TRectF;

  AGPStringFormat:IGPStringFormat;
begin
  Result:=False;

  if AText='' then Exit;

  BDrawRect:=ADrawTextParam.CalcDrawRect(ADrawRect);



  CreateGPFont(ADrawTextParam,AGPFont);
  CreateGPBrush(ADrawTextParam,AGPBrush);
  CreateGPStringFormat(ADrawTextParam,AGPStringFormat);

//  FGraphics.SetTextRenderingHint(GlobalGPTextRenderingHint);//TGPTextRenderingHint.TextRenderingHintAntiAliasGridFit);
  FGraphics.SetTextRenderingHint(GlobalGPTextRenderingHint);//TGPTextRenderingHint.TextRenderingHintAntiAliasGridFit);
  //绘制文本
  FGraphics.DrawString(AText,
                      AGPFont,
                      TGPRectF_Create(
                                      BDrawRect.Left,
                                      BDrawRect.Top,
                                      RectWidthF(BDrawRect),
                                      RectHeightF(BDrawRect)),
                      AGPStringFormat,
                      AGPBrush);


  Result:=True;
end;

function TGDIPlusDrawCanvas.FillPathData(ADrawPathParam:TDrawPathParam;ADrawPathData: TBaseDrawPathData): Boolean;
var
  AGPBrush:IGPBrush;
  AGPColor:TGPColor;
//  AGPPathData:IGPPathData;
//  AGPGraphicsPath:IGPGraphicsPath;
//begin
//  ACanvas.FCanvas.Stroke.Thickness:=ADrawPathData.PenWidth;
//  ACanvas.FCanvas.Stroke.Kind := TBrushKind.Solid;
//  ACanvas.FCanvas.Stroke.Color := ADrawPathData.PenColor.Color;
//  ACanvas.FCanvas.DrawPath(ADrawPathData.PathData,1,ACanvas.FCanvas.Stroke);
begin
  Result:=False;
//  Self.FCanvas.Stroke.Thickness:=ADrawPathData.PenWidth;
//  Self.FCanvas.Stroke.Kind := TBrushKind.Solid;
//  Self.FCanvas.Stroke.Color := ADrawPathData.PenColor.Color;
//  Self.FCanvas.DrawPath(TGDIPlusDrawPathData(ADrawPathData).Path,1,Self.FCanvas.Stroke);

//  if (ADrawLineParam.PenWidth=0)
//  then
//  begin
//    Exit;
//  end;

  AGPColor:=TGPColor_CreateFromColorRef(ADrawPathParam.CurrentEffectFillDrawColor.Color);
  TGPColor_SetAlpha(AGPColor.FArgb,ADrawPathParam.CurrentEffectFillDrawColor.Alpha);

  AGPBrush:=TGPSolidBrush.Create(AGPColor);

//  AGPPathData:=ADrawPathData.PathData;
//
//  AGPGraphicsPath:=TGPGraphicsPath.Create(
//                     TGPPointArray(AGPPathData.PointPtr),
//                     TByteArray(AGPPathData.TypePtr)
//                     );

  FGraphics.FillPath(AGPBrush,TGDIPlusDrawPathData(ADrawPathData).Path);

  Result:=True;
end;

{ TGDIPlusDrawPathData }

constructor TGDIPlusDrawPathData.Create;
begin
  inherited;
//  Path:=TGPGraphicsPath.Create();
end;

destructor TGDIPlusDrawPathData.Destroy;
begin
  //创建了Path之后，释放会报错
//  Path:=nil;
  inherited;
end;

function TGDIPlusDrawPathData.LineTo(const X:Double;const Y:Double): Boolean;
begin
//  Path.AddLine(OriginX,OriginY,X,Y);
  OriginX:=X;
  OriginY:=Y;
  Result:=True;
end;

function TGDIPlusDrawPathData.MoveTo(const X:Double;const Y:Double): Boolean;
begin
  OriginX:=X;
  OriginY:=Y;
  //Path.

  Result:=True;
end;


initialization
//  TGPTextRenderingHint = (
//    TextRenderingHintSystemDefault = 0,            // Glyph with system default rendering hint
//    TextRenderingHintSingleBitPerPixelGridFit,     // Glyph bitmap with hinting
//    TextRenderingHintSingleBitPerPixel,            // Glyph bitmap without hinting
//    TextRenderingHintAntiAliasGridFit,             // Glyph anti-alias bitmap with hinting
//    TextRenderingHintAntiAlias,                    // Glyph anti-alias bitmap without hinting
//    TextRenderingHintClearTypeGridFit);            // Glyph CT bitmap with hinting

  GlobalGPTextRenderingHint:=TGPTextRenderingHint.TextRenderingHintClearTypeGridFit;


end.
