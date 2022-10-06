//convert pas to utf8 by ¥

//FMX画布
unit uFireMonkeyDrawCanvas;

interface

uses
  SysUtils,
  Classes,
  Types,
  Math,
  FMX.Types,
  UITypes,
  uBaseLog,
  FMX.Controls,
  FMX.Graphics,
  FMX.TextLayout,

  {$IF CompilerVersion >= 27.0}
  System.Math.Vectors,
  {$ENDIF}

//  Math,
  uBaseList,
  FMX.Surfaces,
  FMX.Effects,
  {$IFDEF ANDROID}
  Androidapi.JNI.GraphicsContentViewText,
  FMX.Graphics.Android,
  FMX.Helpers.Android,
  Androidapi.Helpers,
  Androidapi.JNIBridge,
  {$ENDIF}


  uSkinPicture,
  uDrawPicture,
  uDrawCanvas,
  uDrawParam,
  uFuncCommon,
  uSkinBufferBitmap,
  uBasePathData,
  uGraphicCommon,
  uDrawTextParam,
  uDrawRectParam,
  uDrawLineParam,
  uDrawPathParam,
  uDrawPictureParam;



type

  //路径数据
  TFireMonkeyDrawPathData=class(TBaseDrawPathData)
  public
    Path:TPathData;
    Stroke:TStrokeBrush;
  public
    constructor Create;override;
    destructor Destroy;override;
  public
    procedure Clear;override;
    procedure MoveTo(const X:Double;const Y:Double);override;
    procedure CurveTo(const X:Double;const Y:Double;
                    const X1:Double;const Y1:Double;
                    const X2:Double;const Y2:Double);override;
    procedure LineTo(const X:Double;const Y:Double);override;


    //添加一个矩形
    procedure AddRect(const ARect:TRectF);override;
    //添加一个饼图
    procedure AddPie(const ARect:TRectF;
                      AStartAngle, ASweepAngle:Double
                      );override;
    //添加一个圆边
    procedure AddArc(const ARect:TRectF;
                      AStartAngle, ASweepAngle:Double
                      );override;
    //添加一个圆
    procedure AddEllipse(const ARect:TRectF);override;
//    //闭合路径
//    procedure Close;override;
//    //获取区域,用来判断鼠标是否在区域内
//    procedure GetRegion;override;
//    //判断鼠标是否在路径内
//    function IsInRegion(const APoint: TPointF):Boolean;override;
  end;

  TDrawPathData=TFireMonkeyDrawPathData;



  //FireMonkey画布
  TFireMonkeyDrawCanvas=class(TDrawCanvas)
  private
    FCanvasState: TCanvasSaveState;
    function CreateRectF(const X,Y,Width,Height:Double):TRectF;overload;
    function PrepareFont(ADrawTextParam: TDrawTextParam): Boolean;overload;
    function PrepareFont(ADrawFont:TDrawFont;ADrawFontColor:TDrawColor): Boolean;overload;
  public
    constructor Create;override;
    destructor Destroy;override;
  public
    //BeginScene
    function BeginDraw:Boolean;override;
    //EndScene
    procedure EndDraw;override;
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
                              var ADrawWidth:Double;
                              var ADrawHeight:Double;
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

    //绘制路径
    function DrawPathData(ADrawPathData:TBaseDrawPathData):Boolean;override;
    function FillPathData(ADrawPathParam:TDrawPathParam;ADrawPathData:TBaseDrawPathData):Boolean;override;
    //绘制路径
    function DrawPath(ADrawPathParam:TDrawPathParam;const ADrawRect:TRectF;APathActions:TPathActionCollection):Boolean;override;


  end;


  //模拟圆角矩形的缓存位图,使圆角更平滑
  TColorRoundRectBitmap=class
  public
    DrawRectParam:TDrawRectParam;
    Width:Double;
    Height:Double;
    RoundWidth:Double;
    RoundHeight:Double;
    FillColor:TDelphiColor;
    RectCorners:TDRPRectCorners;

    IsClipRound:Boolean;
    Bitmap:TDrawPicture;
  public
    destructor Destroy;override;
  end;

  TColorRoundRectBitmapList=class(TBaseList)
  public
    function GetBitmap(ADrawRectParam:TDrawRectParam;
                        AWidth:Double;
                        AHeight:Double;
                        AXRadius:Double;
                        AYRadius:Double;
                        AIsClipRound:Boolean):TDrawPicture;
  end;



procedure AddRoundRectPath(
  Path: TPathData;
  const ARect: TRectF;
  const XRadius,YRadius: Single;
  const ACorners: TCorners;
//  const AOpacity: Single;
//  const ABrush: TBrush;
  const ACornerType: TCornerType = TCornerType.Round);



//全平台生成圆角矩形
function DefaultGenerateColorRoundRectBitmap(AFillColor:TAlphaColor;
                                  AWidth:Integer;
                                  AHeight:Integer;
                                  AXRadius:Double;
                                  AYRadius:Double;
                                  ACorners:TCorners=[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight]
                                  ): TDrawPicture;
//全平台生成中空的圆角矩形
function DefaultGenerateColorClipRoundRectBitmap(AFillColor:TAlphaColor;
                                  AWidth:Integer;
                                  AHeight:Integer;
                                  AXRadius:Double;
                                  AYRadius:Double;
                                  ACorners:TCorners=[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight]
                                  ): TDrawPicture;


{$IFDEF ANDROID}
//安卓平台生成圆角矩形
function AndroidGenerateColorRoundRectBitmap(
                                      AFillColor:TAlphaColor;
                                      AWidth:Integer;
                                      AHeight:Integer;
                                      AXRadius:Double=-1;
                                      AYRadius:Double=-1):TDrawPicture;
//安卓平台生成中空的圆角矩形
function AndroidGenerateColorClipRoundRectBitmap(
                                      AFillColor:TAlphaColor;
                                      AWidth:Integer;
                                      AHeight:Integer;
                                      AXRadius:Double=-1;
                                      AYRadius:Double=-1):TDrawPicture;
{$ENDIF}

//生成圆角矩形图片
function GenerateColorRoundBitmap(AFillColor:TAlphaColor;
                                  AWidth:Integer;
                                  AHeight:Integer;
                                  AXRadius:Double;
                                  AYRadius:Double;
                                  ACorners:TCorners
                                  ): TDrawPicture;

//生成中空的圆角矩形图片
function GenerateColorClipRoundBitmap(AFillColor:TAlphaColor;
                                  AWidth:Integer;
                                  AHeight:Integer;
                                  AXRadius:Double;
                                  AYRadius:Double;
                                  ACorners:TCorners
                                  ): TDrawPicture;



var
  //是否高速画图
  IsDrawBitmapHignSpeed:Boolean;
  GlobalColorRoundRectBitmapList:TColorRoundRectBitmapList;
  IsDrawRoundRectByBufferOnAndroid:Boolean;

implementation


type
  TLineType=(ltDirect,
            ltRound,
            ltMoveTo
            );
  TPathLine=record
    //所在边
    BorderEadge:TDRPBorderEadge;
    //起点,直线,圆线
    LineType:TLineType;
    //坐标
    Point1,Point2,Point3:TPointF;
    //是否需要绘制
    NeedDraw:Boolean;
  end;


var
  GlobalPathLineArray:array [0..30//11
                    ] of TPathLine;


procedure CanvasDrawRectRoundFix(ACanvas:TCanvas;const ARect: TRectF; const XRadius, YRadius: Single; const ACorners: TCorners; const AOpacity: Single;
  const ABrush: TStrokeBrush; const ACornerType: TCornerType=TCornerType.Round);
var
  Path: TPathData;
  x1, x2, y1, y2: Single;
  R: TRectF;
  Adjust:Double;
  I:Integer;
  LineIndex:Integer;
begin
//  Adjust:=0.5;
  Adjust:=0;

  if ABrush.Kind <> TBrushKind.None then
  begin
    R := ARect;
    if ((XRadius = 0) and (YRadius = 0)) or (ACorners = []) then
    begin
      //直角矩形
      ACanvas.DrawRect(ARect,XRadius,YRadius,ACorners, AOpacity,ABrush,ACornerType);
    end
    else
    begin
      //圆角矩形
      R := ARect;
      x1 := XRadius;
      if RectWidthF(R) - (x1 * 2) < 0 then
        x1 := RectWidthF(R) / 2;
      x2 := XRadius * CurveKappaInv;
      y1 := YRadius;
      if RectHeightF(R) - (y1 * 2) < 0 then
        y1 := RectHeightF(R) / 2;
      y2 := YRadius * CurveKappaInv;


      Path := TPathData.Create;


      //移动到左上角
//      Path.MoveTo(PointF(R.Left, R.Top + y1 ));
      LineIndex:=0;

//      GlobalPathLineArray[LineIndex].LineType:=ltStartPoint;
//      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top + y1 );
//      Inc(LineIndex);

      if TCorner.TopLeft in ACorners then
      begin
//        Path.MoveTo(PointF(R.Left, R.Top + y1 ));

        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top + y1 );
        Inc(LineIndex);


        //圆角
//        case ACornerType of
//          // TCornerType.Round - default
//          TCornerType.Bevel: Path.LineTo(PointF(R.Left + x1, R.Top));
//          TCornerType.InnerRound: Path.CurveTo(PointF(R.Left + x2, R.Top + y1), PointF(R.Left + x1, R.Top + y2), PointF(R.Left + x1, R.Top));
//          TCornerType.InnerLine:
//            begin
//              Path.LineTo(PointF(R.Left + x2, R.Top + y1));
//              Path.LineTo(PointF(R.Left + x1, R.Top + y2));
//              Path.LineTo(PointF(R.Left + x1, R.Top));
//            end;
//        else
//          Path.CurveTo(PointF(R.Left, R.Top + (y2)), PointF(R.Left + x2, R.Top), PointF(R.Left + x1, R.Top));
//        end;

        GlobalPathLineArray[LineIndex].LineType:=ltRound;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top + (y2));
        GlobalPathLineArray[LineIndex].Point2:=PointF(R.Left + x2, R.Top);
        GlobalPathLineArray[LineIndex].Point3:=PointF(R.Left + x1, R.Top);
        Inc(LineIndex);

      end
      else
      begin
//        Path.MoveTo(PointF(R.Left, R.Top ));

        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left-Adjust, R.Top );
        Inc(LineIndex);


        //画左上直转角
        //|
//        Path.LineTo(PointF(R.Left, R.Top));

//        GlobalPathLineArray[LineIndex].BorderEadge:=beLeft;
//        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
//        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top);
//        Inc(LineIndex);



        //-
//        Path.LineTo(PointF(R.Left + x1 +Adjust , R.Top));

        GlobalPathLineArray[LineIndex].BorderEadge:=beTop;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left + x1  , R.Top);
        Inc(LineIndex);
      end;

      //上边
//      Path.LineTo(PointF(R.Right - x1 +Adjust, R.Top));

      GlobalPathLineArray[LineIndex].BorderEadge:=beTop;
      GlobalPathLineArray[LineIndex].LineType:=ltDirect;
      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right - x1 , R.Top);
      Inc(LineIndex);



      if TCorner.TopRight in ACorners then
      begin
//        case ACornerType of
//          // TCornerType.Round - default
//          TCornerType.Bevel: Path.LineTo(PointF(R.Right, R.Top + y1));
//          TCornerType.InnerRound: Path.CurveTo(PointF(R.Right - x1, R.Top + y2), PointF(R.Right - x2, R.Top + y1), PointF(R.Right, R.Top + y1));
//          TCornerType.InnerLine:
//            begin
//              Path.LineTo(PointF(R.Right - x1, R.Top + y2));
//              Path.LineTo(PointF(R.Right - x2, R.Top + y1));
//              Path.LineTo(PointF(R.Right, R.Top + y1));
//            end;
//        else
//          Path.CurveTo(PointF(R.Right - x2, R.Top), PointF(R.Right, R.Top + (y2)), PointF(R.Right, R.Top + y1))
//        end;
        GlobalPathLineArray[LineIndex].LineType:=ltRound;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right - x2, R.Top);
        GlobalPathLineArray[LineIndex].Point2:=PointF(R.Right, R.Top + (y2));
        GlobalPathLineArray[LineIndex].Point3:=PointF(R.Right, R.Top + y1);
        Inc(LineIndex);
      end
      else
      begin
        //画右上直转角
//        Path.LineTo(PointF(R.Right, R.Top));
//        Path.LineTo(PointF(R.Right, R.Top + y1 +Adjust));

        GlobalPathLineArray[LineIndex].BorderEadge:=beTop;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right+Adjust, R.Top);
        Inc(LineIndex);

//        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
//        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Top-Adjust);
//        Inc(LineIndex);

        GlobalPathLineArray[LineIndex].BorderEadge:=beRight;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Top + y1 );
        Inc(LineIndex);

      end;


//      Path.LineTo(PointF(R.Right, R.Bottom - y1-Adjust));
      GlobalPathLineArray[LineIndex].BorderEadge:=beRight;
      GlobalPathLineArray[LineIndex].LineType:=ltDirect;
      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Bottom - y1);
      Inc(LineIndex);



      if TCorner.BottomRight in ACorners then
      begin
//        case ACornerType of
//          // TCornerType.Round - default
//          TCornerType.Bevel: Path.LineTo(PointF(R.Right - x1, R.Bottom));
//          TCornerType.InnerRound: Path.CurveTo(PointF(R.Right - x2, R.Bottom - y1), PointF(R.Right - x1, R.Bottom - y2), PointF(R.Right - x1, R.Bottom));
//          TCornerType.InnerLine:
//            begin
//              Path.LineTo(PointF(R.Right - x2, R.Bottom - y1));
//              Path.LineTo(PointF(R.Right - x1, R.Bottom - y2));
//              Path.LineTo(PointF(R.Right - x1, R.Bottom));
//            end;
//        else
//          Path.CurveTo(PointF(R.Right, R.Bottom - (y2)), PointF(R.Right - x2, R.Bottom), PointF(R.Right - x1, R.Bottom));
          GlobalPathLineArray[LineIndex].LineType:=ltRound;
          GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Bottom - (y2));
          GlobalPathLineArray[LineIndex].Point2:=PointF(R.Right - x2, R.Bottom);
          GlobalPathLineArray[LineIndex].Point3:=PointF(R.Right - x1, R.Bottom);
          Inc(LineIndex);
//        end;
      end
      else
      begin
        //画右下直转角
//        Path.LineTo(PointF(R.Right, R.Bottom));
//        Path.LineTo(PointF(R.Right - x1 -Adjust, R.Bottom));


        GlobalPathLineArray[LineIndex].BorderEadge:=beRight;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Bottom+Adjust);
        Inc(LineIndex);

//        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
//        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right+Adjust, R.Bottom);
//        Inc(LineIndex);

        GlobalPathLineArray[LineIndex].BorderEadge:=beBottom;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right - x1, R.Bottom);
        Inc(LineIndex);

      end;

      //画底边
//      Path.LineTo(PointF(R.Left + x1 -Adjust, R.Bottom));
      GlobalPathLineArray[LineIndex].BorderEadge:=beBottom;
      GlobalPathLineArray[LineIndex].LineType:=ltDirect;
      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left + x1, R.Bottom);
      Inc(LineIndex);




      if TCorner.BottomLeft in ACorners then
      begin
//        case ACornerType of
//          // TCornerType.Round - default
//          TCornerType.Bevel: Path.LineTo(PointF(R.Left, R.Bottom - y1));
//          TCornerType.InnerRound: Path.CurveTo(PointF(R.Left + x1, R.Bottom - y2), PointF(R.Left + x2, R.Bottom - y1), PointF(R.Left, R.Bottom - y1));
//          TCornerType.InnerLine:
//            begin
//              Path.LineTo(PointF(R.Left + x1, R.Bottom - y2));
//              Path.LineTo(PointF(R.Left + x2, R.Bottom - y1));
//              Path.LineTo(PointF(R.Left, R.Bottom - y1));
//            end;
//        else
//          Path.CurveTo(PointF(R.Left + x2, R.Bottom), PointF(R.Left, R.Bottom - (y2)), PointF(R.Left, R.Bottom - y1));
          GlobalPathLineArray[LineIndex].LineType:=ltRound;
          GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left + x2, R.Bottom);
          GlobalPathLineArray[LineIndex].Point2:=PointF(R.Left, R.Bottom - (y2));
          GlobalPathLineArray[LineIndex].Point3:=PointF(R.Left, R.Bottom - y1);
          Inc(LineIndex);
//        end;
      end
      else
      begin
        //画左下直转角
//        Path.LineTo(PointF(R.Left, R.Bottom));
//        Path.LineTo(PointF(R.Left, R.Bottom - y1 -Adjust));

        GlobalPathLineArray[LineIndex].BorderEadge:=beBottom;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left-Adjust, R.Bottom);
        Inc(LineIndex);

//        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
//        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left , R.Bottom+Adjust);
//        Inc(LineIndex);

        GlobalPathLineArray[LineIndex].BorderEadge:=beLeft;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Bottom - y1 );
        Inc(LineIndex);
      end;

//
//      Path.LineTo(PointF(R.Left, R.Top
//        + y1 +1 //-Adjust
//         ));
//
//      Path.LineTo(PointF(R.Left, R.Top
//        + y1 -1//*Adjust
//         ));
      GlobalPathLineArray[LineIndex].BorderEadge:=beLeft;
      GlobalPathLineArray[LineIndex].LineType:=ltDirect;

      {$IFDEF ANDROID}
      if x1=3 then
      begin
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top + y1-1.8);
      end
      else
      begin
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top + y1);
      end;
      {$ELSE}
      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top + y1);
      {$ENDIF}

//      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top + y1-10);
      Inc(LineIndex);






      if not (TCorner.TopLeft in ACorners) then
      begin

//        Path.LineTo(PointF(R.Left, R.Top));
//
        GlobalPathLineArray[LineIndex].BorderEadge:=beLeft;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top-Adjust);
        Inc(LineIndex);


      end;


      //去掉多余的线段,组成直线
      for I := 0 to LineIndex-1 do
      begin
        GlobalPathLineArray[I].NeedDraw:=True;
      end;

//      I:=0;
      for I:=0 to LineIndex-2 do
      begin
        //都是直线
        //都在同一边
        if (GlobalPathLineArray[I].LineType=ltDirect)
          and (GlobalPathLineArray[I].LineType=GlobalPathLineArray[I+1].LineType)
          and (GlobalPathLineArray[I].BorderEadge=GlobalPathLineArray[I+1].BorderEadge) then
        begin
          GlobalPathLineArray[I].NeedDraw:=False;
        end;

//        Inc(I);
      end;

      for I := 0 to LineIndex-1 do
      begin
        if GlobalPathLineArray[I].NeedDraw then
        begin
          case GlobalPathLineArray[I].LineType of
            ltDirect:
            begin
              Path.LineTo(GlobalPathLineArray[I].Point1);
            end;
            ltRound:
            begin
              Path.CurveTo(GlobalPathLineArray[I].Point1,
                          GlobalPathLineArray[I].Point2,
                          GlobalPathLineArray[I].Point3);
            end;
            ltMoveTo:
            begin
              Path.MoveTo(GlobalPathLineArray[I].Point1);
            end;
          end;
        end;
      end;

      Path.ClosePath;

      ACanvas.DrawPath(Path, AOpacity, ABrush);

      FreeAndNil(Path);
    end;
  end;
end;


procedure CanvasDrawRectSidesRoundFix(ACanvas:TCanvas;const ARect: TRectF; const XRadius, YRadius: Single; const ACorners: TCorners;
  const AOpacity: Single; const ASides: TSides; const ABrush: TStrokeBrush; const ACornerType: TCornerType = TCornerType.Round);
var
  Path: TPathData;
  X1, X2, Y1, Y2: Single;
  R: TRectF;
  Adjust:Double;
  I:Integer;
  LineIndex:Integer;
begin
  Adjust:=0.5;


  R := ARect;
  //圆角的半径
  X1 := XRadius;
  if R.Width - (X1 * 2) < 0 then
    if X1 <> 0 then // guard divide by zero
      X1 := (XRadius * (R.Width / (X1 * 2)));
  X2 := X1 / 2;
  Y1 := YRadius;
  if R.Height - (Y1 * 2) < 0 then
    if Y1 <> 0 then // guard divide by zero
      Y1 := (YRadius * (R.Height / (Y1 * 2)));
  Y2 := Y1 / 2;



  Path := TPathData.Create;
  try
    //先把原点定位到左上角

//    Path.MoveTo(PointF(R.Left, R.Top + Y1));
    LineIndex:=0;

    GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
    GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top + y1 );
    Inc(LineIndex);


    if TCorner.TopLeft in ACorners then
    begin

      //存在左上角
      if (TSide.Top in ASides) or (TSide.Left in ASides) or (XRadius > 0) or (YRadius > 0) then
      begin
//        case ACornerType of
//          // TCornerType.Round - default
//          TCornerType.Bevel:
//            Path.LineTo(PointF(R.Left + X1, R.Top));
//          TCornerType.InnerRound:
//            Path.CurveTo(PointF(R.Left + X2, R.Top + Y1),
//              PointF(R.Left + X1, R.Top + Y2),
//              PointF(R.Left + X1, R.Top));
//          TCornerType.InnerLine:
//            begin
//              Path.LineTo(PointF(R.Left + X2, R.Top + Y1));
//              Path.LineTo(PointF(R.Left + X1, R.Top + Y2));
//              Path.LineTo(PointF(R.Left + X1, R.Top));
//            end;
//        else
//          Path.CurveTo(PointF(R.Left, R.Top + (Y2)),
//                        PointF(R.Left + X2, R.Top),
//                         PointF(R.Left + X1,R.Top));

          GlobalPathLineArray[LineIndex].LineType:=ltRound;
          GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top + (y2));
          GlobalPathLineArray[LineIndex].Point2:=PointF(R.Left + x2, R.Top);
          GlobalPathLineArray[LineIndex].Point3:=PointF(R.Left + x1, R.Top);
          Inc(LineIndex);
//        end;
      end
      else
      begin
//        Path.MoveTo(PointF(R.Left + X1, R.Top));
        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left + X1, R.Top);
        Inc(LineIndex);
      end;
    end
    else
    begin

//      GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
//      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top);
//      Inc(LineIndex);

      //不存在左上角
      if TSide.Left in ASides then
      begin
        //这一句转移到最后绘制了
//        Path.LineTo(PointF(R.Left, R.Top));
      end
      else
      begin
//        Path.MoveTo(PointF(R.Left, R.Top));
        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left-Adjust, R.Top);
        Inc(LineIndex);
      end;

      if TSide.Top in ASides then
      begin
//        Path.LineTo(PointF(R.Left + X1 +Adjust, R.Top));
        GlobalPathLineArray[LineIndex].BorderEadge:=beTop;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left + x1  , R.Top);
        Inc(LineIndex);
      end
      else
      begin
//        Path.MoveTo(PointF(R.Left + X1, R.Top));
        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left + X1, R.Top);
        Inc(LineIndex);
      end;

    end;




    //上边
    if not(TSide.Top in ASides) then
    begin
//      Path.MoveTo(PointF(R.Right - X1, R.Top));
      GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right - X1, R.Top);
      Inc(LineIndex);
    end
    else
    begin
//      Path.LineTo(PointF(R.Right - X1 +Adjust{较正} , R.Top));
      GlobalPathLineArray[LineIndex].BorderEadge:=beTop;
      GlobalPathLineArray[LineIndex].LineType:=ltDirect;
      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right - x1 , R.Top);
      Inc(LineIndex);
    end;


    if TCorner.TopRight in ACorners then
    begin
      //存在右上角
      if (TSide.Top in ASides) or (TSide.Right in ASides) or (XRadius > 0) or (YRadius > 0) then
      begin
//        case ACornerType of
//          // TCornerType.Round - default
//          TCornerType.Bevel:
//            Path.LineTo(PointF(R.Right, R.Top + Y1));
//          TCornerType.InnerRound:
//            Path.CurveTo(PointF(R.Right - X1, R.Top + Y2),
//              PointF(R.Right - X2, R.Top + Y1),
//              PointF(R.Right, R.Top + Y1));
//          TCornerType.InnerLine:
//            begin
//              Path.LineTo(PointF(R.Right - X1, R.Top + Y2));
//              Path.LineTo(PointF(R.Right - X2, R.Top + Y1));
//              Path.LineTo(PointF(R.Right, R.Top + Y1));
//            end;
//        else
//          Path.CurveTo(PointF(R.Right - X2, R.Top),
//                        PointF(R.Right, R.Top + (Y2)),
//                        PointF(R.Right, R.Top + Y1));
          GlobalPathLineArray[LineIndex].LineType:=ltRound;
          GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right - x2, R.Top);
          GlobalPathLineArray[LineIndex].Point2:=PointF(R.Right, R.Top + (y2));
          GlobalPathLineArray[LineIndex].Point3:=PointF(R.Right, R.Top + y1);
          Inc(LineIndex);
//        end;
      end
      else
      begin
        //原
//        Path.MoveTo(PointF(R.Right, R.Top + Y1));
        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Top + Y1);
        Inc(LineIndex);
      end;
    end
    else
    begin
      //不存在右上角
      if TSide.Top in ASides then
      begin
//        Path.LineTo(PointF(R.Right, R.Top));
        GlobalPathLineArray[LineIndex].BorderEadge:=beTop;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right+Adjust, R.Top);
        Inc(LineIndex);

        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Top-Adjust);
        Inc(LineIndex);

      end
      else
      begin
//        Path.MoveTo(PointF(R.Right, R.Top));
        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Top);
        Inc(LineIndex);
      end;
      //画右上边
      if TSide.Right in ASides then
      begin
//        Path.LineTo(PointF(R.Right, R.Top + Y1));
        GlobalPathLineArray[LineIndex].BorderEadge:=beRight;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Top + y1 );
        Inc(LineIndex);
      end
      else
      begin
//        Path.MoveTo(PointF(R.Right, R.Top + Y1));
        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Top + Y1);
        Inc(LineIndex);
      end;
    end;


    //画右边
    if not(TSide.Right in ASides) then
    begin
//      Path.MoveTo(PointF(R.Right, R.Bottom - Y1));
      GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Bottom - Y1);
      Inc(LineIndex);
    end
    else
    begin
//      Path.LineTo(PointF(R.Right, R.Bottom - Y1));
      GlobalPathLineArray[LineIndex].BorderEadge:=beRight;
      GlobalPathLineArray[LineIndex].LineType:=ltDirect;
      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Bottom - y1);
      Inc(LineIndex);
    end;



    //右下角
    if TCorner.BottomRight in ACorners then
    begin
      if (TSide.Bottom in ASides) or (TSide.Right in ASides) or (XRadius > 0) or (YRadius > 0) then
      begin
//        case ACornerType of
//          // TCornerType.Round - default
//          TCornerType.Bevel:
//            Path.LineTo(PointF(R.Right - X1, R.Bottom));
//          TCornerType.InnerRound:
//            Path.CurveTo(PointF(R.Right - X2, R.Bottom - Y1),
//              PointF(R.Right - X1, R.Bottom - Y2),
//              PointF(R.Right - X1, R.Bottom));
//          TCornerType.InnerLine:
//            begin
//              Path.LineTo(PointF(R.Right - X2, R.Bottom - Y1));
//              Path.LineTo(PointF(R.Right - X1, R.Bottom - Y2));
//              Path.LineTo(PointF(R.Right - X1, R.Bottom));
//            end;
//        else
//          Path.CurveTo(PointF(R.Right, R.Bottom - (Y2)),
//            PointF(R.Right - X2, R.Bottom),
//            PointF(R.Right - X1,R.Bottom));
          GlobalPathLineArray[LineIndex].LineType:=ltRound;
          GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Bottom - (y2));
          GlobalPathLineArray[LineIndex].Point2:=PointF(R.Right - x2, R.Bottom);
          GlobalPathLineArray[LineIndex].Point3:=PointF(R.Right - x1, R.Bottom);
          Inc(LineIndex);
//        end;
      end
      else
      begin
//        Path.MoveTo(PointF(R.Right - X1, R.Bottom));
        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right - X1, R.Bottom);
        Inc(LineIndex);
      end;
    end
    else
    begin
      //画右下边
      if TSide.Right in ASides then
      begin
//        Path.LineTo(PointF(R.Right, R.Bottom));
        GlobalPathLineArray[LineIndex].BorderEadge:=beRight;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Bottom+Adjust);
        Inc(LineIndex);


        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right+Adjust, R.Bottom);
        Inc(LineIndex);
      end
      else
      begin
//        Path.MoveTo(PointF(R.Right, R.Bottom));
        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right, R.Bottom);
        Inc(LineIndex);
      end;
      //画右底边
      if TSide.Bottom in ASides then
      begin
//        Path.LineTo(PointF(R.Right - X1 - Adjust, R.Bottom));
        GlobalPathLineArray[LineIndex].BorderEadge:=beBottom;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right - x1, R.Bottom);
        Inc(LineIndex);
      end
      else
      begin
//        Path.MoveTo(PointF(R.Right - X1, R.Bottom));
        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Right - X1, R.Bottom);
        Inc(LineIndex);
      end;
    end;



    if not (TSide.Bottom in ASides) then
    begin
//      Path.MoveTo(PointF(R.Left + X1, R.Bottom));
      GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left + X1, R.Bottom);
      Inc(LineIndex);
    end
    else
    begin
//      Path.LineTo(PointF(R.Left + X1, R.Bottom));
      GlobalPathLineArray[LineIndex].BorderEadge:=beBottom;
      GlobalPathLineArray[LineIndex].LineType:=ltDirect;
      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left + x1, R.Bottom);
      Inc(LineIndex);
    end;



    if TCorner.BottomLeft in ACorners then
    begin
      if (TSide.Bottom in ASides) or (TSide.Left in ASides) or (XRadius > 0) or (YRadius > 0) then
      begin
//        case ACornerType of
//          // TCornerType.Round - default
//          TCornerType.Bevel:
//            Path.LineTo(PointF(R.Left, R.Bottom - Y1));
//          TCornerType.InnerRound:
//            Path.CurveTo(PointF(R.Left + X1, R.Bottom - Y2),
//              PointF(R.Left + X2, R.Bottom - Y1),
//              PointF(R.Left, R.Bottom - Y1));
//          TCornerType.InnerLine:
//            begin
//              Path.LineTo(PointF(R.Left + X1, R.Bottom - Y2));
//              Path.LineTo(PointF(R.Left + X2, R.Bottom - Y1));
//              Path.LineTo(PointF(R.Left, R.Bottom - Y1));
//            end;
//        else
//          Path.CurveTo(PointF(R.Left + X2, R.Bottom),
//                      PointF(R.Left, R.Bottom - (Y2)),
//                      PointF(R.Left, R.Bottom - Y1));
          GlobalPathLineArray[LineIndex].LineType:=ltRound;
          GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left + x2, R.Bottom);
          GlobalPathLineArray[LineIndex].Point2:=PointF(R.Left, R.Bottom - (y2));
          GlobalPathLineArray[LineIndex].Point3:=PointF(R.Left, R.Bottom - y1);
          Inc(LineIndex);
//        end;
      end
      else
      begin
//        Path.MoveTo(PointF(R.Left, R.Bottom - Y1));
        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Bottom - Y1);
        Inc(LineIndex);
      end;
    end
    else
    begin
      if TSide.Bottom in ASides then
      begin
//        Path.LineTo(PointF(R.Left, R.Bottom));

        GlobalPathLineArray[LineIndex].BorderEadge:=beBottom;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left-Adjust, R.Bottom);
        Inc(LineIndex);

        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Bottom+Adjust);
        Inc(LineIndex);
      end
      else
      begin
//        Path.MoveTo(PointF(R.Left, R.Bottom));
        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Bottom);
        Inc(LineIndex);
      end;
      if TSide.Left in ASides then
      begin
//        Path.LineTo(PointF(R.Left, R.Bottom - Y1 -Adjust));
        GlobalPathLineArray[LineIndex].BorderEadge:=beLeft;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Bottom - y1 );
        Inc(LineIndex);
      end
      else
      begin
//        Path.MoveTo(PointF(R.Left, R.Bottom - Y1 ));
        GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Bottom - Y1 );
        Inc(LineIndex);
      end;
    end;


    if (TSide.Left in ASides) then
    begin
//      Path.LineTo(PointF(R.Left, R.Top + Y1));
      GlobalPathLineArray[LineIndex].BorderEadge:=beLeft;
      GlobalPathLineArray[LineIndex].LineType:=ltDirect;
      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top + Y1);
      Inc(LineIndex);
    end;



    if TCorner.TopLeft in ACorners then
    begin

//      //存在左上角
//      if (TSide.Top in ASides) or (TSide.Left in ASides) or (XRadius > 0) or (YRadius > 0) then
//      begin
//        Path.MoveTo(PointF(R.Left, R.Top + Y1));
//
////        case ACornerType of
////          // TCornerType.Round - default
////          TCornerType.Bevel:
////            Path.LineTo(PointF(R.Left + X1, R.Top));
////          TCornerType.InnerRound:
////            Path.CurveTo(PointF(R.Left + X2, R.Top + Y1),
////              PointF(R.Left + X1, R.Top + Y2),
////              PointF(R.Left + X1, R.Top));
////          TCornerType.InnerLine:
////            begin
////              Path.LineTo(PointF(R.Left + X2, R.Top + Y1));
////              Path.LineTo(PointF(R.Left + X1, R.Top + Y2));
////              Path.LineTo(PointF(R.Left + X1, R.Top));
////            end;
////        else
//          Path.CurveTo(PointF(R.Left, R.Top + (Y2)),
//                        PointF(R.Left + X2, R.Top),
//                         PointF(R.Left + X1,R.Top));
//
//          GlobalPathLineArray[LineIndex].LineType:=ltRound;
//          GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top + (y2));
//          GlobalPathLineArray[LineIndex].Point2:=PointF(R.Left + x2, R.Top);
//          GlobalPathLineArray[LineIndex].Point3:=PointF(R.Left + x1, R.Top);
//          Inc(LineIndex);
////        end;
//      end
//      else
//      begin
//        Path.MoveTo(PointF(R.Left + X1, R.Top));
//      end;
    end
    else
    begin

//      Path.MoveTo(PointF(R.Left, R.Top));
//      GlobalPathLineArray[LineIndex].LineType:=ltMoveTo;
//      GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top + y1 );
//      Inc(LineIndex);

      //不存在左上角
      if TSide.Left in ASides then
      begin
//        Path.LineTo(PointF(R.Left, R.Top));
        GlobalPathLineArray[LineIndex].BorderEadge:=beLeft;
        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left, R.Top-Adjust);
        Inc(LineIndex);
      end
      else
      begin
//        Path.MoveTo(PointF(R.Left, R.Top));
      end;

//      if TSide.Top in ASides then
//      begin
////        Path.LineTo(PointF(R.Left + X1 +Adjust, R.Top));
//        GlobalPathLineArray[LineIndex].BorderEadge:=beTop;
//        GlobalPathLineArray[LineIndex].LineType:=ltDirect;
//        GlobalPathLineArray[LineIndex].Point1:=PointF(R.Left + x1  , R.Top);
//        Inc(LineIndex);
//      end
//      else
//      begin
//        Path.MoveTo(PointF(R.Left + X1, R.Top));
//      end;
//
    end;





      //去掉多余的线段,组成直线
      for I := 0 to LineIndex-1 do
      begin
        GlobalPathLineArray[I].NeedDraw:=True;
      end;

//      I:=0;
      for  I:=0 to LineIndex-2 do
      begin
        //都是直线
        //都在同一边
        if (GlobalPathLineArray[I].LineType=ltDirect)
          and (GlobalPathLineArray[I].LineType=GlobalPathLineArray[I+1].LineType)
          and (GlobalPathLineArray[I].BorderEadge=GlobalPathLineArray[I+1].BorderEadge) then
        begin
          GlobalPathLineArray[I].NeedDraw:=False;
        end;

//        Inc(I);
      end;

      for I := 0 to LineIndex-1 do
      begin
        if GlobalPathLineArray[I].NeedDraw then
        begin
          case GlobalPathLineArray[I].LineType of
            ltDirect:
            begin
//              if //(I=LineIndex-1) and (GlobalPathLineArray[I].LineType=ltDirect)
//                //or
//                  (I<LineIndex-1)
//                  and (GlobalPathLineArray[I].LineType=ltDirect)
//                  and (GlobalPathLineArray[I].LineType=GlobalPathLineArray[I+1].LineType)
//                  //转弯处
//                  and (GlobalPathLineArray[I].BorderEadge<>GlobalPathLineArray[I+1].BorderEadge)
//                 then
//              begin
//                case GlobalPathLineArray[I].BorderEadge of
//                  beLeft,be
//                end;
//              end
//              else
//              begin
                Path.LineTo(GlobalPathLineArray[I].Point1);
//              end;
            end;
            ltRound:
            begin
              Path.CurveTo(GlobalPathLineArray[I].Point1,
                          GlobalPathLineArray[I].Point2,
                          GlobalPathLineArray[I].Point3);
            end;
            ltMoveTo:
            begin
              Path.MoveTo(GlobalPathLineArray[I].Point1);
            end;
          end;
//          if GlobalPathLineArray[I].LineType=ltDirect then
//          begin
//            Path.LineTo(GlobalPathLineArray[I].Point1);
//          end
//          else
//          if GlobalPathLineArray[I].LineType=ltRound then
//          begin
//            Path.CurveTo(GlobalPathLineArray[I].Point1,
//                        GlobalPathLineArray[I].Point2,
//                        GlobalPathLineArray[I].Point3);
//          end;
        end;
      end;



    ACanvas.DrawPath(Path, AOpacity, ABrush);


  finally
    FreeAndNil(Path);
  end;
end;


procedure AddRoundRectPath(
  Path: TPathData;
  const ARect: TRectF;
  const XRadius,YRadius: Single;
  const ACorners: TCorners;
//  const AOpacity: Single;
//  const ABrush: TBrush;
  const ACornerType: TCornerType = TCornerType.Round);
var

  x1, x2, y1, y2: Single;
  R: TRectF;
begin
  R := ARect;
  x1 := XRadius;
  if RectWidth(R) - (x1 * 2) < 0 then
    x1 := RectWidth(R) / 2;
  x2 := XRadius * CurveKappaInv;
  y1 := YRadius;
  if RectHeight(R) - (y1 * 2) < 0 then
    y1 := RectHeight(R) / 2;
  y2 := YRadius * CurveKappaInv;

//  Path := TPathData.Create;
  Path.MoveTo(PointF(R.Left, R.Top + y1));
  if TCorner.TopLeft in ACorners then
  begin
    case ACornerType of
      // TCornerType.Round - default
      TCornerType.Bevel: Path.LineTo(PointF(R.Left + x1, R.Top));
      TCornerType.InnerRound: Path.CurveTo(PointF(R.Left + x2, R.Top + y1), PointF(R.Left + x1, R.Top + y2), PointF(R.Left + x1, R.Top));
      TCornerType.InnerLine:
        begin
          Path.LineTo(PointF(R.Left + x2, R.Top + y1));
          Path.LineTo(PointF(R.Left + x1, R.Top + y2));
          Path.LineTo(PointF(R.Left + x1, R.Top));
        end;
    else
      Path.CurveTo(PointF(R.Left, R.Top + (y2)), PointF(R.Left + x2, R.Top), PointF(R.Left + x1, R.Top))
    end;
  end
  else
  begin
    Path.LineTo(PointF(R.Left, R.Top));
    Path.LineTo(PointF(R.Left + x1, R.Top));
  end;
  Path.LineTo(PointF(R.Right - x1, R.Top));
  if TCorner.TopRight in ACorners then
  begin
    case ACornerType of
      // TCornerType.Round - default
      TCornerType.Bevel: Path.LineTo(PointF(R.Right, R.Top + y1));
      TCornerType.InnerRound: Path.CurveTo(PointF(R.Right - x1, R.Top + y2), PointF(R.Right - x2, R.Top + y1), PointF(R.Right, R.Top + y1));
      TCornerType.InnerLine:
        begin
          Path.LineTo(PointF(R.Right - x1, R.Top + y2));
          Path.LineTo(PointF(R.Right - x2, R.Top + y1));
          Path.LineTo(PointF(R.Right, R.Top + y1));
        end;
    else
      Path.CurveTo(PointF(R.Right - x2, R.Top), PointF(R.Right, R.Top + (y2)), PointF(R.Right, R.Top + y1))
    end;
  end
  else
  begin
    Path.LineTo(PointF(R.Right, R.Top));
    Path.LineTo(PointF(R.Right, R.Top + y1));
  end;
  Path.LineTo(PointF(R.Right, R.Bottom - y1));
  if TCorner.BottomRight in ACorners then
  begin
    case ACornerType of
      // TCornerType.Round - default
      TCornerType.Bevel: Path.LineTo(PointF(R.Right - x1, R.Bottom));
      TCornerType.InnerRound: Path.CurveTo(PointF(R.Right - x2, R.Bottom - y1), PointF(R.Right - x1, R.Bottom - y2), PointF(R.Right - x1, R.Bottom));
      TCornerType.InnerLine:
        begin
          Path.LineTo(PointF(R.Right - x2, R.Bottom - y1));
          Path.LineTo(PointF(R.Right - x1, R.Bottom - y2));
          Path.LineTo(PointF(R.Right - x1, R.Bottom));
        end;
    else
      Path.CurveTo(PointF(R.Right, R.Bottom - (y2)), PointF(R.Right - x2, R.Bottom), PointF(R.Right - x1, R.Bottom))
    end;
  end
  else
  begin
    Path.LineTo(PointF(R.Right, R.Bottom));
    Path.LineTo(PointF(R.Right - x1, R.Bottom));
  end;
  Path.LineTo(PointF(R.Left + x1, R.Bottom));
  if TCorner.BottomLeft in ACorners then
  begin
    case ACornerType of
      // TCornerType.Round - default
      TCornerType.Bevel: Path.LineTo(PointF(R.Left, R.Bottom - y1));
      TCornerType.InnerRound: Path.CurveTo(PointF(R.Left + x1, R.Bottom - y2), PointF(R.Left + x2, R.Bottom - y1), PointF(R.Left, R.Bottom - y1));
      TCornerType.InnerLine:
        begin
          Path.LineTo(PointF(R.Left + x1, R.Bottom - y2));
          Path.LineTo(PointF(R.Left + x2, R.Bottom - y1));
          Path.LineTo(PointF(R.Left, R.Bottom - y1));
        end;
    else
      Path.CurveTo(PointF(R.Left + x2, R.Bottom), PointF(R.Left, R.Bottom - (y2)), PointF(R.Left, R.Bottom - y1))
    end;
  end
  else
  begin
    Path.LineTo(PointF(R.Left, R.Bottom));
    Path.LineTo(PointF(R.Left, R.Bottom - y1));
  end;
//  Path.ClosePath;

//  Result:=Path;
end;




{ TFireMonkeyDrawCanvas }

function TFireMonkeyDrawCanvas.CustomPrepare: Boolean;
begin
end;

function TFireMonkeyDrawCanvas.CustomUnPrepare: Boolean;
begin
  Result:=False;
  FCanvas:=nil;
  Result:=True;
end;

procedure TFireMonkeyDrawCanvas.SetClip(const AClipRect: TRectF);
begin
  FCanvasState:=FCanvas.SaveState;
  Self.FCanvas.IntersectClipRect(AClipRect);
end;

procedure TFireMonkeyDrawCanvas.ResetClip;
begin
  FCanvas.RestoreState(FCanvasState);
end;

constructor TFireMonkeyDrawCanvas.Create;
begin
  inherited;

end;

function TFireMonkeyDrawCanvas.CreateRectF(const X, Y, Width,Height: Double): TRectF;
begin
  Result:=TRectF.Create(X,Y,X+Width,Y+Height);
end;

function TFireMonkeyDrawCanvas.PrepareFont(ADrawTextParam: TDrawTextParam): Boolean;
begin
  Result:=False;

  FCanvas.Font.Family:=ADrawTextParam.CurrentEffectFontName;

  //一定要加Ceil,如果不加Ceil,在Windows上会出现字体异常
  FCanvas.Font.Size:=Floor(ADrawTextParam.CurrentEffectFontSize);
  FCanvas.Font.Style:=ADrawTextParam.CurrentEffectFontStyle;

  FCanvas.Fill.Color:=ADrawTextParam.CurrentEffectFontColor.Color;
  Result:=True;
end;

destructor TFireMonkeyDrawCanvas.Destroy;
begin

  inherited;
end;

function TFireMonkeyDrawCanvas.DrawDesigningRect(const ADrawRect: TRectF;
                                                const ABorderColor:TDelphiColor): Boolean;
begin
  if GlobalIsDrawDesigningRect then
  begin
    //创建虚线框
    FCanvas.Stroke.Thickness := 1;
    {$IF CompilerVersion >= 35.0}
    FCanvas.Stroke.Dash := TStrokeDash.Dash;
    {$ELSE}
    FCanvas.Stroke.Dash := TStrokeDash.sdDash;
    FCanvas.Stroke.Kind := TBrushKind.bkSolid;
    {$ENDIF}


    FCanvas.Stroke.Color := ABorderColor;
    FCanvas.DrawRect(TRectF.Create(ADrawRect.Left+1,ADrawRect.Top+1,ADrawRect.Right,ADrawRect.Bottom),0,0,[],0.7);
    {$IF CompilerVersion >= 35.0}
    FCanvas.Stroke.Dash := TStrokeDash.Solid;
    {$ELSE}
    FCanvas.Stroke.Dash := TStrokeDash.sdSolid;
    {$ENDIF}
  end;
end;

function TFireMonkeyDrawCanvas.DrawDesigningText(const ADrawRect:TRectF;
                                                  const AText:String):Boolean;
begin
  if GlobalIsDrawDesigningName then
  begin
    FCanvas.Font.Size:=12;
    FCanvas.Fill.Color:=TAlphaColorRec.Black;

    {$IF CompilerVersion >= 35.0}
    FCanvas.FillText(ADrawRect,AText,True,0.6,[],TTextAlign.Leading,TTextAlign.Leading);
    {$ELSE}
    FCanvas.FillText(ADrawRect,AText,True,0.6,[],TTextAlign.taLeading,TTextAlign.taLeading);
    {$ENDIF}

  end;
end;

function TFireMonkeyDrawCanvas.BeginDraw: Boolean;
begin
  Result:=Self.FCanvas.BeginScene;
end;

function TPresentedTextControl_CalcTextObjectSize(ACanvas:TCanvas;
                                                  const ADrawRect: TRectF;
                                                  const ADrawTextParam:TDrawTextParam;
                                                  AText:String;
                                                  var Size: TSizeF): Boolean;
const
  FakeText = 'P|y'; // Do not localize

  function RoundToScale(const Value, Scale: Single): Single;
  begin
    if Scale > 0 then
      Result := Ceil(Value * Scale) / Scale
    else
      Result := Ceil(Value);
  end;

var
  Layout: TTextLayout;
  LScale: Single;
  LText: string;
//  LMaxWidth,
  LWidth: Single;
begin
  Result := False;
  Size.cx:=0;
  Size.cy:=0;
  LWidth:=0;


//  FMX.Types.Log.d('OrangeUI TPresentedTextControl_CalcTextObjectSize Begin '+AText);

//  if (Scene <> nil) and (TextObject <> nil) then
//  begin
//    LMaxWidth := MaxWidth;// - TextObject.Margins.Left - TextObject.Margins.Right;

//    ACanvas.Sc
    LScale := ACanvas.Scale;//Scene.GetSceneScale;
    Layout := TTextLayoutManager.DefaultTextLayout.Create;
    try
//      if TextObject is TText then
//        LText := TText(TextObject).Text
//      else
        LText := AText;//Text;


      Layout.BeginUpdate;
      try
//        try

          if LText.IsEmpty then
            Layout.Text := FakeText
          else
            Layout.Text := LText;

          Layout.Font := ADrawTextParam.DrawFont;
    //      if ADrawTextParam.IsWordWrap and (LMaxWidth > 1) then
    //        Layout.MaxSize := TPointF.Create(LMaxWidth, TTextLayout.MaxLayoutSize.Y);

          Layout.TopLeft := ADrawRect.TopLeft;
          Layout.MaxSize := PointF(ADrawRect.Width, ADrawRect.Height);


          Layout.WordWrap := ADrawTextParam.IsWordWrap;
          Layout.Trimming := TTextTrimming.None;
          Layout.VerticalAlign := TTextAlign.Leading;
          Layout.HorizontalAlign := TTextAlign.Leading;

//        except
//          on E:Exception do
//          begin
//            FMX.Types.Log.d('OrangeUI TPresentedTextControl_CalcTextObjectSize '+E.Message);
//          end;
//        end;

      finally
        Layout.EndUpdate;
      end;

//      if ADrawTextParam.IsWordWrap then
//        Layout.MaxSize := TPointF.Create(LMaxWidth + Layout.TextRect.Left * 2, TTextLayout.MaxLayoutSize.Y);

      if LText.IsEmpty then
        LWidth := 0
//      else if ADrawTextParam.IsWordWrap then
//        LWidth := Layout.MaxSize.X
      else
        LWidth := Layout.Width;


      Size.Width := RoundToScale(LWidth, LScale);// + TextObject.Margins.Left + TextObject.Margins.Right;
      Size.Height := RoundToScale(Layout.Height, LScale);// + TextObject.Margins.Top + TextObject.Margins.Bottom;

      Result := True;
    finally
      Layout.Free;
    end;
//  end;



//  FMX.Types.Log.d('OrangeUI TPresentedTextControl_CalcTextObjectSize End '+FloatToStr(Size.Width)+','+FloatToStr(Size.Height));
end;


function TFireMonkeyDrawCanvas.CalcTextDrawSize(const ADrawTextParam:TDrawTextParam;
                                                const AText:String;
                                                const ADrawRect:TRectF;
                                                var ADrawWidth:Double;
                                                var ADrawHeight:Double;
                                                const ACalcDrawSizeType:TCalcDrawSizeType):Boolean;
//var
//  ADrawRectF:TRectF;
//begin
//  Result:=False;
//  PrepareFont(ADrawTextParam);
//
//
//  if Not ADrawTextParam.IsWordWrap then
//  begin
//      //不换行
//      if AText<>'' then
//      begin
//        ADrawWidth:=FCanvas.TextWidth(AText);
//        ADrawHeight:=FCanvas.TextHeight(AText);
//      end
//      else
//      begin
//        ADrawWidth:=0;
//        ADrawHeight:=FCanvas.TextHeight(' ');
//      end;
//  end
//  else
//  begin
//      //换行
//      if AText<>'' then
//      begin
//        ADrawRectF:=ADrawTextParam.CalcDrawRect(ADrawRect);
//        ADrawRectF.Bottom:=ADrawRectF.Top+MaxInt;
//        FCanvas.MeasureText(ADrawRectF,
//                            AText,
//                            ADrawTextParam.IsWordWrap,
//                            [],
//                            TTextAlign.Leading,
//                            TTextAlign.Leading);
//        ADrawWidth:=ADrawRectF.Right-ADrawRectF.Left;
//        ADrawHeight:=ADrawRectF.Bottom-ADrawRectF.Top;
//      end
//      else
//      begin
//        ADrawWidth:=0;
//        ADrawHeight:=FCanvas.TextHeight(' ');
//      end;
//  end;
//  Result:=True;
var
  I:Integer;
  BDrawRect:TRectF;
  ATextLayout: TTextLayout;
  ASize:TSizeF;
begin

  Result:=True;

  ADrawWidth:=0;
  ADrawHeight:=0;


  if AText='' then
  begin
    Exit;
  end;



  BDrawRect:=ADrawRect;

  //当时为什么要去掉?
  BDrawRect:=ADrawTextParam.CalcDrawRect(ADrawRect);

  if Length(AText)<10 then
  begin
    TPresentedTextControl_CalcTextObjectSize(FCanvas,
                                              BDrawRect,//MaxInt,
                                              ADrawTextParam,
                                              AText+' ',//加上一个空格较正
                                              ASize
                                              );
  end
  else
  begin
    TPresentedTextControl_CalcTextObjectSize(FCanvas,
                                              BDrawRect,//MaxInt,
                                              ADrawTextParam,
                                              AText+'修',//要修正,加上一个字符
                                              ASize
                                              );
  end;
  if AText='' then
  begin
    ADrawWidth:=0;
  end
  else
  begin
    ADrawWidth:=ASize.Width;
  end;
  ADrawHeight:=ASize.Height;



//  ATextLayout := TTextLayoutManager.TextLayoutByCanvas(FCanvas.ClassType).Create(FCanvas);
//  try
//
//      ATextLayout.BeginUpdate;
//      try
//
//        ATextLayout.TopLeft := BDrawRect.TopLeft;
//        ATextLayout.MaxSize := PointF(BDrawRect.Width, BDrawRect.Height);
//
//        ATextLayout.Text := AText;
//
//
//        if Not GlobalIsUseDefaultFontFamily  then
//        begin
//          ATextLayout.Font.Family:=ADrawTextParam.CurrentEffectFontName;
//        end
//        else
//        begin
//          if GlobalDefaultFontFamily<>'' then
//          begin
//            ATextLayout.Font.Family:=GlobalDefaultFontFamily;
//          end
//          else
//          begin
//            //使用系统默认的字体
//          end;
//        end;
//
//
//        FCanvas.Font.Size:=Floor(ADrawTextParam.FontSize);
//        //一定要加Ceil,如果不加Ceil,在Windows上会出现字体异常
//        ATextLayout.Font.Size:=Floor(ADrawTextParam.FontSize);
//
//        ATextLayout.Font.Style:=ADrawTextParam.CurrentEffectFontStyle;
//
//        ATextLayout.WordWrap := ADrawTextParam.IsWordWrap;
//
//      finally
//        ATextLayout.EndUpdate;
//      end;
//
//      ATextLayout.RenderLayout(FCanvas);
//
//      ADrawWidth:=ATextLayout.Width;
//      ADrawHeight:=ATextLayout.Height;
//
//  finally
//    FreeAndNil(ATextLayout);
//  end;

  Result:=True;
end;

function TFireMonkeyDrawCanvas.DrawLine(const ADrawLineParam: TDrawLineParam;
                                         X1: Double;
                                         Y1: Double;
                                         X2: Double;
                                         Y2: Double): Boolean;
var
  APt1, APt2: TPointF;
  ARectF:TRectF;
begin
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



  Self.FCanvas.Stroke.Thickness:=ADrawLineParam.PenWidth;
  Self.FCanvas.Stroke.Kind := TBrushKind.Solid;
  Self.FCanvas.Stroke.Color := ADrawLineParam.PenDrawColor.Color;


  //校正成0.5
  if IsSameDouble(ADrawLineParam.PenWidth,1) and IsSameDouble(X1,X2) then
  begin
    APt1:=TPointF.Create(AdjustDrawLinePos(X1),Y1);
    APt2:=TPointF.Create(AdjustDrawLinePos(X2),Y2);
  end
  else
  if IsSameDouble(ADrawLineParam.PenWidth,1) and IsSameDouble(Y1,Y2) then
  begin
    APt1:=TPointF.Create(X1,AdjustDrawLinePos(Y1));
    APt2:=TPointF.Create(X2,AdjustDrawLinePos(Y2));
  end
  else
  begin
    APt1:=TPointF.Create(X1,Y1);
    APt2:=TPointF.Create(X2,Y2);
  end;

  FCanvas.DrawLine(APt1,APt2,ADrawLineParam.DrawAlpha/255);
end;

function TFireMonkeyDrawCanvas.DrawPath(ADrawPathParam: TDrawPathParam;const ADrawRect: TRectF;APathActions:TPathActionCollection): Boolean;
var
  I: Integer;
  BDrawRect:TRectF;
  APathActionItem:TPathActionItem;
  ADrawPathData:TFireMonkeyDrawPathData;
  ARect:TRectF;
begin
  //根据DrawRectSetting返回需要绘制的实际矩形
  BDrawRect:=ADrawPathParam.CalcDrawRect(ADrawRect);

  ADrawPathData:=TFireMonkeyDrawPathData(APathActions.FDrawPathData);


  ADrawPathData.Stroke.Thickness:=ADrawPathParam.CurrentEffectPenWidth;
  ADrawPathData.Stroke.Kind := TBrushKind.Solid;
  ADrawPathData.Stroke.Color := ADrawPathParam.CurrentEffectPenColor.Color;


  ADrawPathData.Clear;
  for I := 0 to APathActions.Count-1 do
  begin
    APathActionItem:=APathActions[I];
    case APathActionItem.ActionType of
      patClear:
      begin
        ADrawPathData.Clear;
      end;
      patMoveTo:
      begin
        ADrawPathData.MoveTo(
          BDrawRect.Left+APathActionItem.GetX(BDrawRect),
          BDrawRect.Top+APathActionItem.GetY(BDrawRect));
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
          BDrawRect.Left+APathActionItem.GetX(BDrawRect),
          BDrawRect.Top+APathActionItem.GetY(BDrawRect));
      end;
      patDrawPath:
      begin
        if BiggerDouble(ADrawPathParam.CurrentEffectPenWidth,0) then
        begin
          Self.FCanvas.DrawPath(
                ADrawPathData.Path,
                ADrawPathParam.DrawAlpha/255,
                ADrawPathData.Stroke);
        end;
      end;
      patFillPath:
      begin

          //创建画刷
          Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.{$IF CompilerVersion >= 35.0}Solid{$ELSE}bkSolid{$IFEND};
          Self.FCanvas.Fill.Color:=ADrawPathParam.CurrentEffectFillDrawColor.Color;

          Self.FCanvas.FillPath(
                ADrawPathData.Path,
                ADrawPathParam.DrawAlpha/255,
                Self.FCanvas.Fill);

      end;


      patAddRect:
      begin
//        if APathActions.FIsChanged then
//        begin
          ARect:=RectF(
                      BDrawRect.Left+APathActionItem.GetX(BDrawRect),
                      BDrawRect.Top+APathActionItem.GetY(BDrawRect),
                      BDrawRect.Left+APathActionItem.GetX1(BDrawRect),
                      BDrawRect.Top+APathActionItem.GetY1(BDrawRect)
                      );
          ADrawPathData.AddRect(ARect);
//        end;
      end;
      patAddPie:
      begin
//        if APathActions.FIsChanged then
//        begin
          ARect:=RectF(
                      BDrawRect.Left+APathActionItem.GetX(BDrawRect),
                      BDrawRect.Top+APathActionItem.GetY(BDrawRect),
                      BDrawRect.Left+APathActionItem.GetX1(BDrawRect),
                      BDrawRect.Top+APathActionItem.GetY1(BDrawRect)
                      );
          //饼图扇形鼠标移上去要变大
          ARect:=ADrawPathParam.CalcDrawPathRect(ARect);
          ADrawPathData.AddPie(ARect,APathActionItem.StartAngle,APathActionItem.SweepAngle);
//        end;
      end;
      patAddArc:
      begin
//        if APathActions.FIsChanged then
//        begin
          ARect:=RectF(
                      BDrawRect.Left+APathActionItem.GetX(BDrawRect),
                      BDrawRect.Top+APathActionItem.GetY(BDrawRect),
                      BDrawRect.Left+APathActionItem.GetX1(BDrawRect),
                      BDrawRect.Top+APathActionItem.GetY1(BDrawRect)
                      );
          //饼图扇形鼠标移上去要变大
          ARect:=ADrawPathParam.CalcDrawPathRect(ARect);
          ADrawPathData.AddArc(ARect,APathActionItem.StartAngle,APathActionItem.SweepAngle);
//        end;
      end;
      patAddEllipse:
      begin
//        if APathActions.FIsChanged then
//        begin
          ARect:=RectF(
                      BDrawRect.Left+APathActionItem.GetX(BDrawRect),
                      BDrawRect.Top+APathActionItem.GetY(BDrawRect),
                      BDrawRect.Left+APathActionItem.GetX1(BDrawRect),
                      BDrawRect.Top+APathActionItem.GetY1(BDrawRect)
                      );
          ARect:=ADrawPathParam.CalcDrawPathRect(ARect);
          ADrawPathData.AddEllipse(ARect);
//        end;
      end;
//      patGetRegion:
//      begin
//          ADrawPathData.GetRegion;
//      end;


    end;
  end;
end;

function TFireMonkeyDrawCanvas.DrawPathData(ADrawPathData: TBaseDrawPathData): Boolean;
begin
  Self.FCanvas.Stroke.Thickness:=ADrawPathData.PenWidth;
  Self.FCanvas.Stroke.Kind := TBrushKind.Solid;
  Self.FCanvas.Stroke.Color := ADrawPathData.PenColor.Color;
  Self.FCanvas.DrawPath(TFireMonkeyDrawPathData(ADrawPathData).Path,1,Self.FCanvas.Stroke);
end;

function TFireMonkeyDrawCanvas.DrawSkinPicture(const ADrawPictureParam: TDrawPictureParam;
                                              const ASkinPicture:TSkinPicture;
                                              const ADrawRect: TRectF;
                                              const AIsUseSrcRectAndDestDrawRect:Boolean;
                                              const AImageSrcRect:TRectF;
                                              const AImageDestDrawRect:TRectF
                                              ):Boolean;
var
  M, M1, M2,RotMatrix,TranslateMatrix: TMatrix;

  BDrawRect:TRectF;
  BImageDestDrawRect:TRectF;
  BImageSrcRect:TRectF;

  AIsStretch:Boolean;
  AbsoluteMatrix:TMatrix;

  DrawSrcLeft,DrawSrcRight:Double;
  DrawDstLeft,DrawDstRight:Double;

  DrawSrcTop,DrawSrcBottom:Double;
  DrawDstTop,DrawDstBottom:Double;

  ADrawAdjust:Single;
begin
  Result:=True;


  if ASkinPicture.IsEmpty then Exit;

  if (RectWidthF(ADrawRect)<=0) or (RectHeightF(ADrawRect)<=0) then Exit;

  ADrawAdjust:=0;
//  {$IFDEF MSWINDOWS}
//  ADrawAdjust:=0.3;
//  {$ENDIF}

  BDrawRect:=ADrawPictureParam.CalcDrawRect(ADrawRect);
  BImageDestDrawRect:=AImageDestDrawRect;
  BImageSrcRect:=AImageSrcRect;


  if Not AIsUseSrcRectAndDestDrawRect then
  begin

    //计算最终绘制的矩形
    CalcImageDrawRect(ADrawPictureParam,
                          ASkinPicture.Width,
                          ASkinPicture.Height,
                          BDrawRect,
                          BImageDestDrawRect
                          );

    BImageSrcRect:=RectF(0,0,ASkinPicture.Width,ASkinPicture.Height);

  end;









    if ADrawPictureParam.CurrentEffectRotateAngle <> 0 then
    begin

        AbsoluteMatrix:=FCanvas.Matrix;




//        if not SameValue(FRotationAngle, 0.0, TEpsilon.Scale) then
//        begin
//          // scale
//          M := TMatrix.Identity;
//          M.m11 := FScale.X;
//          M.m22 := FScale.Y;
//          FLocalMatrix := M;
          // rotation
//          if FRotationAngle <> 0 then
//          begin
//            M1 := TMatrix.Identity;
//            M1.m31 := -0.5 * BImageDestDrawRect.Width;//FSize.Width * FScale.X;
//            M1.m32 := -0.5 * BImageDestDrawRect.Height;//FSize.Height * FScale.Y;
//            M2 := TMatrix.Identity;
//            M2.m31 := 0.5 * BImageDestDrawRect.Width;//FRotationCenter.X * FSize.Width * FScale.X;
//            M2.m32 := 0.5 * BImageDestDrawRect.Height;//FRotationCenter.Y * FSize.Height * FScale.Y;
//
//            RotMatrix := M1 * (TMatrix.CreateRotation(DegToRad(ADrawPictureParam.CurrentEffectRotateAngle)) * M2);
//            M := M * RotMatrix;
//          end;
          // translate
//          TranslateMatrix := TMatrix.Identity;
//          TranslateMatrix.m31 := BImageDestDrawRect.Left;
//          TranslateMatrix.m32 := BImageDestDrawRect.Top;
//          M := M * TranslateMatrix;
//        end
//        else
//        begin
//          FLocalMatrix := TMatrix.Identity;
//          FLocalMatrix.m31 := FPosition.X;
//          FLocalMatrix.m32 := FPosition.Y;
//          FLocalMatrix.m11 := FScale.X;
//          FLocalMatrix.m22 := FScale.Y;
//        end;

        M := TMatrix.Identity;

//        TranslateMatrix := TMatrix.Identity;
//        TranslateMatrix.m31 := BImageDestDrawRect.Left;
//        TranslateMatrix.m32 := BImageDestDrawRect.Top;
//        M := M * TranslateMatrix;


        M.m31 := -BImageDestDrawRect.Width/2;
        M.m32 := -BImageDestDrawRect.Height/2;


//
//        if (BImageDestDrawRect.Width<>BImageSrcRect.Width)
//          or (BImageDestDrawRect.Height<>BImageSrcRect.Height) then
//        begin
//          if ADrawPictureParam.CurrentEffectRotateAngle=180 then
//          begin
////            M.m31 := M.m31-0.5;
////            M.m32 := M.m32-0.5;
//            M := M * TMatrix.CreateRotation(DegToRad(ADrawPictureParam.CurrentEffectRotateAngle-0.1));
//          end
//          else
//          if ADrawPictureParam.CurrentEffectRotateAngle=360 then
//          begin
////            M.m31 := M.m31+0.5;
////            M.m32 := M.m32+0.5;
//            M := M * TMatrix.CreateRotation(DegToRad(ADrawPictureParam.CurrentEffectRotateAngle-0.1));
//          end
//          else
//          begin
//            M := M * TMatrix.CreateRotation(DegToRad(ADrawPictureParam.CurrentEffectRotateAngle));
//          end;
//        end
//        else
//        begin
          M := M * TMatrix.CreateRotation(DegToRad(ADrawPictureParam.CurrentEffectRotateAngle));
//        end;



//        { calc new size }
//        SetLength(Pts, 4);
//        Pts[0] := PointF(0, 0) * M;
//        Pts[1] := PointF(BImageDestDrawRect.Width, 0) * M;
//        Pts[2] := PointF(BImageDestDrawRect.Width, BImageDestDrawRect.Height) * M;
//        Pts[3] := PointF(0, BImageDestDrawRect.Height) * M;
//        R := NormalizeRectF(Pts);




        { translate }
        M2 := TMatrix.Identity;
        M2.m31 := BImageDestDrawRect.Width/2;
        M2.m32 := BImageDestDrawRect.Height/2;
        M := M * M2;

        M.m31 := M.m31+Ceil(AbsoluteMatrix.m31);
        M.m32 := M.m32+Ceil(AbsoluteMatrix.m32);

        if (BImageDestDrawRect.Width<>BImageSrcRect.Width)
          or (BImageDestDrawRect.Height<>BImageSrcRect.Height) then
        begin
          if ADrawPictureParam.CurrentEffectRotateAngle=180 then
          begin
            M.m31 := M.m31-0.5;
            M.m32 := M.m32-0.5;
          end;
          if ADrawPictureParam.CurrentEffectRotateAngle=360 then
          begin
            M.m31 := M.m31+0.5;
            M.m32 := M.m32+0.5;
          end;
        end;


        { rotate }
        FCanvas.BeginScene;
        FCanvas.SetMatrix(M);


    end;






  if (ADrawPictureParam.IsStretch)
    or (ADrawPictureParam.Scale<>1) then
  begin

    case ADrawPictureParam.StretchStyle of
      issThreePartHorz,issThreePartHorzPro:
      begin
          //水平三分法
          if (ADrawPictureParam.PictureTooSmallProcessType=itsptNone)
            or (RectWidthF(BImageSrcRect)>=ADrawPictureParam.StretchMargins.Left+ADrawPictureParam.StretchMargins.Right)
            and (RectWidthF(BImageDestDrawRect)>=RectWidthF(BImageSrcRect)) then
          begin


            DrawSrcLeft:=ADrawPictureParam.StretchMargins.Left;
            DrawSrcRight:=ADrawPictureParam.StretchMargins.Right;
            DrawDstLeft:=ADrawPictureParam.StretchMargins.Left;
            DrawDstRight:=ADrawPictureParam.StretchMargins.Right;
            if ADrawPictureParam.StretchStyle=issThreePartHorzPro then
            begin
              DrawDstLeft:=ADrawPictureParam.DestDrawStretchMargins.Left;
              DrawDstRight:=ADrawPictureParam.DestDrawStretchMargins.Right;
            end;



            //DrawLeftSide
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Left,BImageSrcRect.Top,DrawSrcLeft,BImageSrcRect.Bottom),
                      CreateRectF(BImageDestDrawRect.Left,BImageDestDrawRect.Top,DrawDstLeft,RectHeightF(BImageDestDrawRect)),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);
            //DrawRightSide
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Right-DrawSrcRight,BImageSrcRect.Top,DrawSrcRight,BImageSrcRect.Bottom),
                      CreateRectF(BImageDestDrawRect.Right-DrawDstRight,BImageDestDrawRect.Top,DrawDstRight,RectHeightF(BImageDestDrawRect)),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);

            //DrawCenterBlock
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Left+DrawSrcLeft,BImageSrcRect.Top,RectWidthF(BImageSrcRect)-DrawSrcLeft-DrawSrcRight,RectHeightF(BImageSrcRect)),
                      CreateRectF(BImageDestDrawRect.Left+DrawDstLeft,BImageDestDrawRect.Top,RectWidthF(BImageDestDrawRect)-DrawDstLeft-DrawDstRight,RectHeightF(BImageDestDrawRect)),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);


          end
          else
          begin
            case ADrawPictureParam.PictureTooSmallProcessType of
              itsptTensile:
              begin
                FCanvas.DrawBitmap(ASkinPicture,
                                    CreateRectF(BImageSrcRect.Left,BImageSrcRect.Top,RectWidthF(BImageSrcRect),RectHeightF(BImageSrcRect)),
                                    BImageDestDrawRect,
                                    ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);
              end;
              itsptPart:
              begin
                //DrawLeftSide
                FCanvas.DrawBitmap(ASkinPicture,
                          CreateRectF(BImageSrcRect.Left,BImageSrcRect.Top,RectWidthF(BImageDestDrawRect),BImageSrcRect.Bottom),
                          BImageDestDrawRect,
                          ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);

              end;
            end;
          end;

      end;
      issThreePartVert,issThreePartVertPro:
      begin
          //垂直三分法
          if (ADrawPictureParam.PictureTooSmallProcessType=itsptNone)
            or (RectHeightF(BImageSrcRect)>=ADrawPictureParam.StretchMargins.Top+ADrawPictureParam.StretchMargins.Bottom)
            and (RectHeightF(BImageDestDrawRect)>=RectHeightF(BImageSrcRect)) then
          begin




            DrawSrcTop:=ADrawPictureParam.StretchMargins.Top;
            DrawSrcBottom:=ADrawPictureParam.StretchMargins.Bottom;
            DrawDstTop:=ADrawPictureParam.StretchMargins.Top;
            DrawDstBottom:=ADrawPictureParam.StretchMargins.Bottom;
            if ADrawPictureParam.StretchStyle=issThreePartVertPro then
            begin
              DrawDstTop:=ADrawPictureParam.DestDrawStretchMargins.Top;
              DrawDstBottom:=ADrawPictureParam.DestDrawStretchMargins.Bottom;
            end;





            //DrawTopSide
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Left,BImageSrcRect.Top,RectWidthF(BImageSrcRect),DrawSrcTop),
                      CreateRectF(BImageDestDrawRect.Left,BImageDestDrawRect.Top,RectWidthF(BImageDestDrawRect),DrawDstTop),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);
            //DrawBottomSide
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Left,BImageSrcRect.Bottom-DrawSrcBottom,RectWidthF(BImageSrcRect),DrawSrcBottom),
                      CreateRectF(BImageDestDrawRect.Left,BImageDestDrawRect.Bottom-DrawDstBottom,RectWidthF(BImageDestDrawRect),DrawDstBottom),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);

            //DrawCenterBlock
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Left,BImageSrcRect.Top+DrawSrcTop,RectWidthF(BImageSrcRect),RectHeightF(BImageSrcRect)-DrawSrcTop-DrawSrcBottom),
                      CreateRectF(BImageDestDrawRect.Left,BImageDestDrawRect.Top+DrawDstTop,RectWidthF(BImageDestDrawRect),RectHeightF(BImageDestDrawRect)-DrawDstTop-DrawDstBottom),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);


          end
          else
          begin
            case ADrawPictureParam.PictureTooSmallProcessType of
              itsptTensile:
              begin
                FCanvas.DrawBitmap(ASkinPicture,
                                    CreateRectF(BImageSrcRect.Left,BImageSrcRect.Top,RectWidthF(BImageSrcRect),RectHeightF(BImageSrcRect)),
                                    BImageDestDrawRect,
                                    ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);
              end;
              itsptPart:
              begin
                //DrawTopSide
                FCanvas.DrawBitmap(ASkinPicture,
                          CreateRectF(BImageSrcRect.Left,BImageSrcRect.Top,BImageSrcRect.Right,RectHeightF(BImageDestDrawRect)),
                          BImageDestDrawRect,
                          ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);

              end;
            end;
          end;

      end;

      issSquare,issSquarePro:
      begin
          //九宫格
          if (ADrawPictureParam.PictureTooSmallProcessType=itsptNone)
            or (RectWidthF(BImageSrcRect)>=ADrawPictureParam.StretchMargins.Left+ADrawPictureParam.StretchMargins.Right)
            and (RectHeightF(BImageSrcRect)>=ADrawPictureParam.StretchMargins.Top+ADrawPictureParam.StretchMargins.Bottom)
            and ((RectWidthF(BImageDestDrawRect)>=RectWidthF(BImageSrcRect)))
              and ((RectHeightF(BImageDestDrawRect)>=RectHeightF(BImageSrcRect))) then
          begin


            DrawSrcLeft:=ADrawPictureParam.StretchMargins.Left;
            DrawSrcRight:=ADrawPictureParam.StretchMargins.Right;
            DrawSrcTop:=ADrawPictureParam.StretchMargins.Top;
            DrawSrcBottom:=ADrawPictureParam.StretchMargins.Bottom;
            DrawDstLeft:=ADrawPictureParam.StretchMargins.Left;
            DrawDstRight:=ADrawPictureParam.StretchMargins.Right;
            DrawDstTop:=ADrawPictureParam.StretchMargins.Top;
            DrawDstBottom:=ADrawPictureParam.StretchMargins.Bottom;
            if ADrawPictureParam.StretchStyle=issSquarePro then
            begin
              DrawDstLeft:=ADrawPictureParam.DestDrawStretchMargins.Left;
              DrawDstRight:=ADrawPictureParam.DestDrawStretchMargins.Right;
              DrawDstTop:=ADrawPictureParam.DestDrawStretchMargins.Top;
              DrawDstBottom:=ADrawPictureParam.DestDrawStretchMargins.Bottom;
            end;




            //DrawLeftTopBlock
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Left,BImageSrcRect.Top,DrawSrcLeft,DrawSrcTop),
                      CreateRectF(BImageDestDrawRect.Left,BImageDestDrawRect.Top,DrawDstLeft,DrawDstTop),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);
            //DrawRightTopBlock
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Right-DrawSrcRight,BImageSrcRect.Top,DrawSrcRight,DrawSrcTop),
                      CreateRectF(BImageDestDrawRect.Right-DrawDstRight,BImageDestDrawRect.Top,DrawDstRight,DrawDstTop),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);
            //DrawLeftBottomBlock
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Left,BImageSrcRect.Bottom-DrawSrcBottom,DrawSrcLeft,DrawSrcBottom),
                      CreateRectF(BImageDestDrawRect.Left,BImageDestDrawRect.Bottom-DrawDstBottom,DrawDstLeft,DrawDstBottom),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);
            //DrawRightBottomBlock
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Right-DrawSrcRight,BImageSrcRect.Bottom-DrawSrcBottom,DrawSrcRight,DrawSrcBottom),
                      CreateRectF(BImageDestDrawRect.Right-DrawDstRight,BImageDestDrawRect.Bottom-DrawDstBottom,DrawDstRight,DrawDstBottom),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);



            //DrawTopSide
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Left+DrawSrcLeft,BImageSrcRect.Top,BImageSrcRect.Right-DrawSrcLeft-DrawSrcRight,DrawSrcTop),
                      CreateRectF(BImageDestDrawRect.Left+DrawDstLeft-ADrawAdjust,
                                  BImageDestDrawRect.Top,
                                  RectWidthF(BImageDestDrawRect)-DrawDstLeft-DrawDstRight+2*ADrawAdjust,
                                  DrawDstTop),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);
            //DrawBottomSide
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Left+DrawSrcLeft,BImageSrcRect.Bottom-DrawSrcBottom,BImageSrcRect.Right-DrawSrcLeft-DrawSrcRight,DrawSrcBottom),
                      CreateRectF(BImageDestDrawRect.Left+DrawDstLeft-ADrawAdjust,
                                  BImageDestDrawRect.Bottom-DrawDstBottom,
                                  RectWidthF(BImageDestDrawRect)-DrawDstLeft-DrawDstRight+2*ADrawAdjust,
                                  DrawDstBottom),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);

            //DrawLeftSide
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Left,BImageSrcRect.Top+DrawSrcTop,DrawSrcLeft,BImageSrcRect.Bottom-DrawSrcTop-DrawSrcBottom),
                      CreateRectF(BImageDestDrawRect.Left,
                                  BImageDestDrawRect.Top+DrawDstTop-ADrawAdjust,
                                  DrawDstLeft,
                                  RectHeightF(BImageDestDrawRect)-DrawDstTop-DrawDstBottom+2*ADrawAdjust),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);
            //DrawRightSide
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Right-DrawSrcRight,BImageSrcRect.Top+DrawSrcTop,DrawSrcRight,BImageSrcRect.Bottom-DrawSrcTop-DrawSrcBottom),
                      CreateRectF(BImageDestDrawRect.Right-DrawDstRight,
                                  BImageDestDrawRect.Top+DrawDstTop-ADrawAdjust,
                                  DrawDstRight,
                                  RectHeightF(BImageDestDrawRect)-DrawDstTop-DrawDstBottom+2*ADrawAdjust),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);


            //DrawCenterBlock
            FCanvas.DrawBitmap(ASkinPicture,
                      CreateRectF(BImageSrcRect.Left+DrawSrcLeft,BImageSrcRect.Top+DrawSrcTop,RectWidthF(BImageSrcRect)-DrawSrcLeft-DrawSrcRight,RectHeightF(BImageSrcRect)-DrawSrcTop-DrawSrcBottom),
                      CreateRectF(BImageDestDrawRect.Left+DrawDstLeft-ADrawAdjust,
                                  BImageDestDrawRect.Top+DrawDstTop-ADrawAdjust,
                                  RectWidthF(BImageDestDrawRect)-DrawDstLeft-DrawDstRight+2*ADrawAdjust,
                                  RectHeightF(BImageDestDrawRect)-DrawDstTop-DrawDstBottom+2*ADrawAdjust),
                      ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);





          end
          else
          begin
            FCanvas.DrawBitmap(ASkinPicture,
                                CreateRectF(BImageSrcRect.Left,BImageSrcRect.Top,RectWidthF(BImageSrcRect),RectHeightF(BImageSrcRect)),
                                BImageDestDrawRect,
                                ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);
          end;

      end;
      issAutoFitFillMax:
      begin
          if BImageSrcRect.Height/BImageSrcRect.Width>BImageDestDrawRect.Height/BImageDestDrawRect.Width then
          begin
              //原图的高比较够,放大,
              BImageSrcRect.Top:=
                    (BImageSrcRect.Height-
                      //需要这么高
                      BImageSrcRect.Width*BImageDestDrawRect.Height/BImageDestDrawRect.Width)/2;
              BImageSrcRect.Bottom:=
                    (BImageSrcRect.Bottom-BImageSrcRect.Top);
          end
          else
          begin
//              if BImageSrcRect.Width>BImageSrcRect.Height then
//              begin
                  //宽>高,那么截取水平中间的部分
                  BImageSrcRect.Left:=
                        (BImageSrcRect.Width-
                          //需要这么宽
                          BImageSrcRect.Height*BImageDestDrawRect.Width/BImageDestDrawRect.Height)/2;
                  BImageSrcRect.Right:=
                        (BImageSrcRect.Right-BImageSrcRect.Left);

//              end
//              else
//              begin
//                  BImageSrcRect.Top:=
//                        (BImageSrcRect.Height-
//                          //需要这么高
//                          BImageSrcRect.Width*BImageDestDrawRect.Height/BImageDestDrawRect.Width)/2;
//                  BImageSrcRect.Bottom:=
//                        (BImageSrcRect.Bottom-BImageSrcRect.Top);
//              end;
          end;
          FCanvas.DrawBitmap(ASkinPicture,
                            BImageSrcRect,
                            BImageDestDrawRect,
                            ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);
      end
      else
      begin
          FCanvas.DrawBitmap(ASkinPicture,
                            CreateRectF(BImageSrcRect.Left,BImageSrcRect.Top,RectWidthF(BImageSrcRect),RectHeightF(BImageSrcRect)),
                            BImageDestDrawRect,
                            ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);
      end;
    end;

  end
  else
  begin

    FCanvas.DrawBitmap(ASkinPicture,
                        BImageSrcRect,
                        BImageDestDrawRect,
                        ADrawPictureParam.DrawAlpha/255,IsDrawBitmapHignSpeed);

  end;



  if ADrawPictureParam.CurrentEffectRotateAngle <> 0 then
  begin
    FCanvas.EndScene;
    FCanvas.SetMatrix(AbsoluteMatrix);
  end;
end;

//function TFireMonkeyDrawCanvas.DrawPolygon(ADrawPolygonParam:TDrawPolygonParam;const ADrawPoints: array of TPoint):Boolean;
//var
//  I: Integer;
//  APolygon: TPolygon;
//begin
//  Result:=True;
//
//  if Not ADrawPolygonParam.IsFill
//    and (ADrawPolygonParam.BorderWidth=0)
//  then
//  begin
//    Exit;
//  end;
//
//
//  SetLength(APolygon,Length(ADrawPoints));
//  for I := 0 to Length(ADrawPoints) - 1 do
//  begin
//    APolygon[I].X:=ADrawPoints[I].X;
//    APolygon[I].Y:=ADrawPoints[I].Y;
//  end;
//
//
//  if ADrawPolygonParam.IsFill then
//  begin
//    //创建画刷
//    if ADrawPolygonParam.LinearGradientType=lgtNone then
//    begin
//      Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.bkSolid;
//      Self.FCanvas.Fill.Color:=ADrawPolygonParam.FillColor.Color;
//    end
//    else
//    begin
//      Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.bkSolid;
//      Self.FCanvas.Fill.Gradient.Color:=ADrawPolygonParam.LinearGradientFillColor1.Color;
//      Self.FCanvas.Fill.Gradient.Color1:=ADrawPolygonParam.LinearGradientFillColor2.Color;
//      case ADrawPolygonParam.LinearGradientType of
//        lgtVert: Self.FCanvas.Fill.Gradient.Style:=FMX.Graphics.TGradientStyle.gsRadial;
//        lgtHorz: Self.FCanvas.Fill.Gradient.Style:=FMX.Graphics.TGradientStyle.gsLinear;
//      end;
//    end;
//    FCanvas.FillPolygon(APolygon,(ADrawPolygonParam.FillColor.Alpha/255)*(ADrawPolygonParam.DrawAlpha/255));
//  end;
//
//  if //ADrawPolygonParam.IsDrawBorder and
//   (ADrawPolygonParam.BorderWidth>0) then
//  begin
//    //创建画笔
//    Self.FCanvas.Stroke.Color:=ADrawPolygonParam.BorderColor.Color;
//    Self.FCanvas.Stroke.Thickness:=ADrawPolygonParam.BorderWidth;
//    Self.FCanvas.Stroke.Kind := TBrushKind.Solid;
//
//    Self.FCanvas.DrawPolygon(APolygon,(ADrawPolygonParam.BorderColor.Alpha/255)*(ADrawPolygonParam.DrawAlpha/255));
//  end;
//
//  SetLength(APolygon,0);
//end;


function TFireMonkeyDrawCanvas.DrawRect(const ADrawRectParam: TDrawRectParam;
                                        const ADrawRect: TRectF): Boolean;
var
  AFillRect:TRectF;
  ADrawBorderRect:TRectF;

  ASides:TSides;
  ACorners:TCorners;

  BDrawRect:TRectF;

  AClipPathData:TPathData;
  AClipRect:TRectF;
  ARoundWidth:Double;
  ARoundHeight:Double;
  AClipRoundWidth:Double;
  AClipRoundHeight:Double;

  ADrawRectParamCurrentEffectIsFill:Boolean;
  ADrawRectParamCurrentEffectBorderWidth:Double;
var
  StrokeThicknessRestoreValue:Single;
var
  APt1, APt2: TPointF;

  ARoundRectBitmap:TDrawPicture;
  AClipRoundRectBitmap:TDrawPicture;
var
  R:TRectF;
begin
  Result:=True;


//  try

  //矩形是否填充
  ADrawRectParamCurrentEffectIsFill:=ADrawRectParam.CurrentEffectIsFill;
  //矩形边框宽度
  ADrawRectParamCurrentEffectBorderWidth:=ADrawRectParam.CurrentEffectBorderWidth;



  if
    //不填充
    Not ADrawRectParamCurrentEffectIsFill
    //不画边框
    and IsSameDouble(ADrawRectParamCurrentEffectBorderWidth,0)
    //不画线
    and not ADrawRectParam.IsLine
    //宽度为0
    or IsSameDouble(RectWidthF(ADrawRect),0)
    //高度为0
    or IsSameDouble(RectHeightF(ADrawRect),0)
  then
  begin
    //不绘制,直接退出
    Exit;
  end;






  //根据DrawRectSetting返回需要绘制的实际矩形
  BDrawRect:=ADrawRectParam.CalcDrawRect(ADrawRect);
  //万一有小于0的
  //(130, 0, 111, 60)

  if
    //不画线,画矩形
    not ADrawRectParam.IsLine
    and BiggerDouble(RectWidthF(BDrawRect),1)
    and BiggerDouble(RectHeightF(BDrawRect),1) then
  begin

      //有边框才需要较正
      BDrawRect:=GetDrawingShapeRectAndSetThickness(
                                                    ADrawRectParamCurrentEffectBorderWidth,
                                                    BDrawRect,
                                                    ADrawRectParamCurrentEffectIsFill,
                                                    Not IsSameDouble(ADrawRectParamCurrentEffectBorderWidth,0),
                                                    StrokeThicknessRestoreValue
                                                    );


      AFillRect:=BDrawRect;


      ARoundWidth:=ADrawRectParam.RoundWidth;
      ARoundHeight:=ADrawRectParam.RoundHeight;
      //如果角半径为-1,那么默认为圆形
      if IsSameDouble(ARoundWidth,-1) or IsSameDouble(ARoundHeight,-1) then
      begin
        ARoundWidth:=AFillRect.Width/2;
        ARoundHeight:=AFillRect.Height/2;
        //圆角保持一致,取最小的半径
        if ARoundWidth<ARoundHeight then
        begin
          ARoundHeight:=ARoundWidth;
        end
        else
        begin
          ARoundWidth:=ARoundHeight;
        end;
      end;


      //角
      ACorners:=[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight];
      if not (rcTopLeft in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.TopLeft];
      if not (rcTopRight in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.TopRight];
      if not (rcBottomLeft in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.BottomLeft];
      if not (rcBottomRight in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.BottomRight];

      //边
      ASides:=[TSide.Top, TSide.Left, TSide.Bottom, TSide.Right];
      if not (beLeft in ADrawRectParam.BorderEadges) then ASides:=ASides-[TSide.Left];
      if not (beTop in ADrawRectParam.BorderEadges) then ASides:=ASides-[TSide.Top];
      if not (beRight in ADrawRectParam.BorderEadges) then ASides:=ASides-[TSide.Right];
      if not (beBottom in ADrawRectParam.BorderEadges) then ASides:=ASides-[TSide.Bottom];


      //填充矩形
      if ADrawRectParamCurrentEffectIsFill then
      begin


          //有阴影
//          ADrawRectParam.ShadowSize:=5;
          if (ADrawRectParam.CurrentEffectShadowSize>0) then
          begin


              //重新处理阴影缓存
              if ADrawRectParam.FShadowEffect=nil then
              begin
                ADrawRectParam.FShadowEffect:=TShadowEffect.Create(nil);
              end;
              //大矩形,加上了阴影部分,比原矩形更大
              ADrawRectParam.FShadowEffectRect := ADrawRectParam.FShadowEffect.GetRect(BDrawRect);


              if (ADrawRectParam.FIsChanged) then
              begin
                  if ADrawRectParam.FShadowEffectBitmap = nil then
                  begin
                    ADrawRectParam.FShadowEffectBitmap := TBitmap.Create(Trunc(ADrawRectParam.FShadowEffectRect.Width), Trunc(ADrawRectParam.FShadowEffectRect.Height));
    //                ADrawRectParam.FShadowEffectBitmap.BitmapScale:=
                  end
                  else if (ADrawRectParam.FShadowEffectBitmap.Width <> Trunc(ADrawRectParam.FShadowEffectRect.Width)) or (ADrawRectParam.FShadowEffectBitmap.Height <> Trunc(ADrawRectParam.FShadowEffectRect.Height)) then
                  begin
                    ADrawRectParam.FShadowEffectBitmap.SetSize(Trunc(ADrawRectParam.FShadowEffectRect.Width), Trunc(ADrawRectParam.FShadowEffectRect.Height));
                  end;
                  //在缓存中间绘制,
                  R := TRectF.Create(ADrawRectParam.FShadowEffect.GetOffset.X,
                                      ADrawRectParam.FShadowEffect.GetOffset.Y,
                                      (ADrawRectParam.FShadowEffect.GetOffset.X + AFillRect.Width),
                                      (ADrawRectParam.FShadowEffect.GetOffset.Y + AFillRect.Height));

                  //生成阴影缓存图
                  ADrawRectParam.FShadowEffectBitmap.Canvas.BeginScene();
                  try
                    ADrawRectParam.FShadowEffectBitmap.Canvas.Clear(0);
                    ADrawRectParam.FShadowEffectBitmap.Canvas.Fill.Kind:=TBrushKind.Solid;
                    ADrawRectParam.FShadowEffectBitmap.Canvas.Fill.Color:=ADrawRectParam.CurrentEffectFillDrawColor.Color;

    //                ADrawRectParam.FShadowEffectBitmap.Canvas.FillRect(R,0,0,[],ADrawRectParam.DrawAlpha/255);
                    ADrawRectParam.FShadowEffectBitmap.Canvas.FillRect(R,
                                                                        ARoundWidth,
                                                                        ARoundHeight,
                                                                        ACorners,
                                                                        ADrawRectParam.DrawAlpha/255);
                  finally
                    ADrawRectParam.FShadowEffectBitmap.Canvas.EndScene;
                  end;
                  ADrawRectParam.FShadowEffect.ProcessEffect(ADrawRectParam.FShadowEffectBitmap.Canvas, ADrawRectParam.FShadowEffectBitmap, 1);
              end;


              FCanvas.DrawBitmap(ADrawRectParam.FShadowEffectBitmap,
                                RectF(0, 0, ADrawRectParam.FShadowEffectBitmap.Width, ADrawRectParam.FShadowEffectBitmap.Height),
                                ADrawRectParam.FShadowEffectRect,
                                1,
                                True);

          end;



//          //创建画刷
//          case ADrawRectParam.BrushKind of
//            drpbkNone: Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.None;
//            drpbkFill: Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.Solid;
//            drpbkGradient: Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.Gradient;
//          end;

          //创建画刷
          case ADrawRectParam.BrushKind of
            drpbkNone:
              Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.None;
            drpbkFill:
              Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.Solid;
            drpbkGradient:
            begin
              Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.Gradient;
              Self.FCanvas.Fill.Gradient.Assign(ADrawRectParam.Gradient);
              Self.FCanvas.Fill.Gradient.Color:=ADrawRectParam.FillColor.Color;
            end;
          end;

          Self.FCanvas.Fill.Color:=ADrawRectParam.CurrentEffectFillDrawColor.Color;

//          //创建画刷
//          case ADrawRectParam.BrushKind of
//            drpbkNone: Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.None;
//            drpbkFill: Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.Solid;
//            drpbkGradient: Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.Gradient;
//          end;

          if ADrawRectParam.FIsClipRound then
          begin

                    //绘制中空圆角矩形


                    AClipRect:=ADrawRectParam.FClipRoundRectSetting.CalcDrawRect(BDrawRect);
                    AClipRoundWidth:=ADrawRectParam.FClipRoundWidth;
                    AClipRoundHeight:=ADrawRectParam.FClipRoundHeight;
                    if IsSameDouble(AClipRoundWidth,-1) or IsSameDouble(AClipRoundHeight,-1) then
                    begin
                      AClipRoundWidth:=AClipRect.Width/2;
                      AClipRoundHeight:=AClipRect.Height/2;
                      //圆角保持一致,取最小的半径
                      if AClipRoundWidth<AClipRoundHeight then
                      begin
                        AClipRoundHeight:=AClipRoundWidth;
                      end
                      else
                      begin
                        AClipRoundWidth:=AClipRoundHeight;
                      end;

                    end;



                      //有圆角
                      AClipRoundRectBitmap:=nil;
                      //10.2以上安桌苹果上绘制圆角钜形会闪,改用图片画
                      {$IFDEF ANDROID}
                          {$IF RTLVersion>=32}// 10.2+
                          if IsDrawRoundRectByBufferOnAndroid then
                          begin
                              //10.2Android需要使用这种模式
                              if
                                   //纯圆形不用图片画
                                   //IsSameDouble(ADrawRectParam.RoundWidth,-1)
                                //or IsSameDouble(ADrawRectParam.RoundHeight,-1)
                                  //渐变不用图片画
                                //or
                                (ADrawRectParam.BrushKind=TDRPBrushKind.drpbkGradient)
                                or (ACorners<>[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight])
    //                              //圆角尺寸比矩形都大的不用图片画
    //                            or (AFillRect.Width<2*ARoundWidth)
    //                            or (AFillRect.Height<2*ARoundHeight)
                                then
                              begin
                                  //不使用图片
                              end
                              else
                              begin
                                  //10.2以上安桌苹果上绘制圆角钜形会闪,改用图片画
                                  AClipRoundRectBitmap:=GlobalColorRoundRectBitmapList.GetBitmap(ADrawRectParam,
                                                                                              AClipRect.Width,
                                                                                              AClipRect.Height,
                                                                                              AClipRoundWidth,
                                                                                              AClipRoundHeight,
                                                                                              True
                                                                                              );
                              end;
                          end;
                          {$ENDIF}
                      {$ENDIF}



                      if AClipRoundRectBitmap<>nil then
                      begin
                          GlobalDrawColorRoundRectBitmapParam.StretchStyle:=issTensile;
                          GlobalDrawColorRoundRectBitmapParam.IsStretch:=True;
//                          //使用的是九宫格绘制
//                          GlobalDrawColorRoundRectBitmapParam.StretchMargins.SetBounds(
//                                Ceil(ARoundWidth*Const_BufferBitmapScale),
//                                Ceil(ARoundHeight*Const_BufferBitmapScale),
//                                Ceil(ARoundWidth*Const_BufferBitmapScale),
//                                Ceil(ARoundHeight*Const_BufferBitmapScale)
//                                );
//                          GlobalDrawColorRoundRectBitmapParam.DestDrawStretchMargins.SetBounds(
//                                Ceil(ARoundWidth),
//                                Ceil(ARoundHeight),
//                                Ceil(ARoundWidth),
//                                Ceil(ARoundHeight)
//                                );
                          GlobalDrawColorRoundRectBitmapParam.DrawAlpha:=ADrawRectParam.DrawAlpha;
                          Self.DrawPicture(GlobalDrawColorRoundRectBitmapParam,AClipRoundRectBitmap,AClipRect);
                      end
                      else
                      begin
                          //用于RoundImage
                          AClipPathData:=TPathData.Create;
                          try
                              if Not ADrawRectParam.IsRound then
                              begin
                                //不是圆角
                                AClipPathData.AddRectangle(AFillRect,0,0,[]);
                              end
                              else
                              begin
                                //有圆角
                                AClipPathData.AddRectangle(AFillRect,ARoundWidth,ARoundHeight,ACorners);
                              end;
                              //圆角矩形
                              //这样更圆,Android平台下会变龟头
                              AddRoundRectPath(AClipPathData,
                                               AClipRect,
                                               AClipRoundWidth,
                                               AClipRoundHeight,
                                               ACorners
                                               );

          //                      //AddRectangle这样不圆的
          //                    AClipPathData.AddRectangle(AClipRect,
          //                                              AClipRoundWidth,
          //                                              AClipRoundHeight,
          //                                              ACorners
          //                                              );


                              //不需要ClosePath,不然会黑屏
                              //AClipPathData.ClosePath;

                              FCanvas.FillPath(AClipPathData,ADrawRectParam.DrawAlpha/255);
                          finally
                            FreeAndNil(AClipPathData);
                          end;
                      end;



          end
          else
          begin
                if Not ADrawRectParam.IsRound then
                begin

                      //不是圆角
                      FCanvas.FillRect(AFillRect,0,0,[],ADrawRectParam.DrawAlpha/255);
                end
                else
                begin

                      //有圆角
                      ARoundRectBitmap:=nil;
                      //10.2以上安桌苹果上绘制圆角钜形会闪,改用图片画
                      {$IFDEF ANDROID}
                          {$IF RTLVersion>=32}// 10.2+
                          if IsDrawRoundRectByBufferOnAndroid then
                          begin
                              //10.2Android需要使用这种模式
                              if
                                   //纯圆形不用图片画
                                   //IsSameDouble(ADrawRectParam.RoundWidth,-1)
                                //or IsSameDouble(ADrawRectParam.RoundHeight,-1)
                                  //渐变不用图片画
                                //or
                                (ADrawRectParam.BrushKind=TDRPBrushKind.drpbkGradient)
                                or (ACorners<>[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight])
    //                              //圆角尺寸比矩形都大的不用图片画
    //                            or (AFillRect.Width<2*ARoundWidth)
    //                            or (AFillRect.Height<2*ARoundHeight)
                                then
                              begin
                                  //不使用图片
                              end
                              else
                              begin
                                  //10.2以上安桌苹果上绘制圆角钜形会闪,改用图片画
                                  ARoundRectBitmap:=GlobalColorRoundRectBitmapList.GetBitmap(ADrawRectParam,
                                                                                              AFillRect.Width,
                                                                                              AFillRect.Height,
                                                                                              ARoundWidth,
                                                                                              ARoundHeight,
                                                                                              False
                                                                                              );
                              end;
                          end;
                          {$ENDIF}
                      {$ENDIF}



                      if ARoundRectBitmap<>nil then
                      begin
                          GlobalDrawColorRoundRectBitmapParam.StretchStyle:=issTensile;
                          GlobalDrawColorRoundRectBitmapParam.IsStretch:=True;
//                          //使用的是九宫格绘制
//                          GlobalDrawColorRoundRectBitmapParam.StretchMargins.SetBounds(
//                                Ceil(ARoundWidth*Const_BufferBitmapScale),
//                                Ceil(ARoundHeight*Const_BufferBitmapScale),
//                                Ceil(ARoundWidth*Const_BufferBitmapScale),
//                                Ceil(ARoundHeight*Const_BufferBitmapScale)
//                                );
//                          GlobalDrawColorRoundRectBitmapParam.DestDrawStretchMargins.SetBounds(
//                                Ceil(ARoundWidth),
//                                Ceil(ARoundHeight),
//                                Ceil(ARoundWidth),
//                                Ceil(ARoundHeight)
//                                );
                          GlobalDrawColorRoundRectBitmapParam.DrawAlpha:=ADrawRectParam.DrawAlpha;
                          Self.DrawPicture(GlobalDrawColorRoundRectBitmapParam,ARoundRectBitmap,AFillRect);
                      end
                      else
                      begin
                          FCanvas.FillRect(AFillRect,
                                            ARoundWidth,
                                            ARoundHeight,
                                            ACorners,
                                            ADrawRectParam.DrawAlpha/255);
                      end;

                end;
          end;

      end;



      //有边框
      if (ADrawRectParamCurrentEffectBorderWidth>0) then
      begin
          //创建画笔
          Self.FCanvas.Stroke.Color:=ADrawRectParam.CurrentEffectBorderColor.Color;
          Self.FCanvas.Stroke.Thickness:=ADrawRectParamCurrentEffectBorderWidth;
          Self.FCanvas.Stroke.Kind:=TBrushKind.Solid;
          Self.FCanvas.Stroke.Dash:=TStrokeDash.{$IF CompilerVersion >= 35.0}Solid{$ELSE}sdSolid{$IFEND};

          ADrawBorderRect:=BDrawRect;


          if ASides=[TSide.Top, TSide.Left, TSide.Bottom, TSide.Right] then
          begin
              //四边俱全
              if Not ADrawRectParam.IsRound then
              begin
                FCanvas.DrawRect(ADrawBorderRect,
                                  0,
                                  0,
                                  [],
                                  ADrawRectParam.DrawAlpha/255);
              end
              else
              begin
                CanvasDrawRectRoundFix(FCanvas,
                                        ADrawBorderRect,
                                        ARoundWidth,
                                        ARoundHeight,
                                        ACorners,
                                        ADrawRectParam.DrawAlpha/255,
                                        Self.FCanvas.Stroke);
//                FCanvas.DrawRect(ADrawBorderRect,
//                                  ARoundWidth,
//                                  ARoundHeight,
//                                  ACorners,
//                                  ADrawRectParam.DrawAlpha/255);
              end;
          end
          else
          begin
              //四边不全
              if Not ADrawRectParam.IsRound then
              begin
                  FCanvas.DrawRectSides(ADrawBorderRect,0,0,ACorners,ADrawRectParam.DrawAlpha/255,ASides);
              end
              else
              begin
                CanvasDrawRectSidesRoundFix(FCanvas,
                                            ADrawBorderRect,
                                            ADrawRectParam.RoundWidth,
                                            ADrawRectParam.RoundHeight,
                                            ACorners,
                                            ADrawRectParam.DrawAlpha/255,
                                            ASides,
                                            FCanvas.Stroke);
              end;
          end;
      end;


  end
  else
  begin


      //宽度或高度为1,或小于1
      Self.FCanvas.Stroke.Thickness:=DefaultPenWidth;
      Self.FCanvas.Stroke.Kind := TBrushKind.Solid;
      Self.FCanvas.Stroke.Color := ADrawRectParam.FillDrawColor.Color;
      Self.FCanvas.Stroke.Dash := TStrokeDash.{$IF CompilerVersion >= 35.0}Solid{$ELSE}sdSolid{$IFEND};


      APt1:=TPointF.Create(0,0);
      APt2:=TPointF.Create(0,0);
      if not ADrawRectParam.IsLine then
      begin
          //修复位置，补0.5
          //宽度<=1
          if SmallerEqualDouble(RectWidthF(BDrawRect),1) then
          begin
            APt1:=TPointF.Create(AdjustDrawLinePos(BDrawRect.Left),BDrawRect.Top);
            APt2:=TPointF.Create(AdjustDrawLinePos(BDrawRect.Left),BDrawRect.Bottom);
          end
          else
          if SmallerEqualDouble(RectHeightF(BDrawRect),1) then
          begin
            APt1:=TPointF.Create(BDrawRect.Left,AdjustDrawLinePos(BDrawRect.Top,-Const_DrawLineOffset));
            APt2:=TPointF.Create(BDrawRect.Right,AdjustDrawLinePos(BDrawRect.Top,-Const_DrawLineOffset));
          end;
      end
      else
      begin
          //修复位置，补0.5
          case ADrawRectParam.LinePosition of
            lpLeft:
            begin
              APt1:=TPointF.Create(AdjustDrawLinePos(BDrawRect.Left),BDrawRect.Top);
              APt2:=TPointF.Create(AdjustDrawLinePos(BDrawRect.Left),BDrawRect.Bottom);
            end;
            lpTop:
            begin
              APt1:=TPointF.Create(BDrawRect.Left,AdjustDrawLinePos(BDrawRect.Top));
              APt2:=TPointF.Create(BDrawRect.Right,AdjustDrawLinePos(BDrawRect.Top));
            end;
            lpRight:
            begin
              APt1:=TPointF.Create(AdjustDrawLinePos(BDrawRect.Right,-Const_DrawLineOffset),BDrawRect.Top);
              APt2:=TPointF.Create(AdjustDrawLinePos(BDrawRect.Right,-Const_DrawLineOffset),BDrawRect.Bottom);
            end;
            lpBottom:
            begin
              APt1:=TPointF.Create(BDrawRect.Left,AdjustDrawLinePos(BDrawRect.Bottom,-Const_DrawLineOffset));
              APt2:=TPointF.Create(BDrawRect.Right,AdjustDrawLinePos(BDrawRect.Bottom,-Const_DrawLineOffset));
            end;
          end;
      end;


      FCanvas.DrawLine(APt1,APt2,ADrawRectParam.DrawAlpha/255);
  end;

  ADrawRectParam.FIsChanged:=False;

//  except
//    on E:Exception do
//    begin
//      FMX.Types.Log.d('OrangeUI TFireMonkeyDrawCanvas.DrawRect '+E.Message)
//    end;
//  end;
end;

function TFireMonkeyDrawCanvas.DrawText(const ADrawTextParam: TDrawTextParam;
                                        const AText: String;
                                        const ADrawRect:TRectF;
                                        const AColorTextList:IColorTextList): Boolean;
var
  I:Integer;
  BText:String;
  BDrawRect:TRectF;
  ADarwStartIndex:Integer;
  ADrawLength:Integer;
  ADrawStartLeft:Double;
  ADrawTextWidth:Double;
  ADrawTextSumWidth:Double;
  AHTextAlign, AVTextAlign: TTextAlign;
  ADrawFont:TDrawFont;
  ADrawFontColor:TDrawColor;
  AColorTextItem:TBaseColorTextItem;
begin

  Result:=True;

  if (AText='') and (AColorTextList=nil) then Exit;

  BDrawRect:=ADrawTextParam.CalcDrawRect(ADrawRect);


  BText:=AText;
  //垂直绘制字体
  if ADrawTextParam.IsDrawVert then
  begin
    BText:='';
    for I := Low(AText) to High(AText) do
    begin
      BText:=BText+AText[I]+#13#10;
    end;
  end;


  //水平对齐
  AHTextAlign:=TTextAlign.{$IF CompilerVersion >= 35.0}Leading{$ELSE}taLeading{$IFEND};
  case ADrawTextParam.FontHorzAlign of
    fhaLeft: AHTextAlign:=TTextAlign.{$IF CompilerVersion >= 35.0}Leading{$ELSE}taLeading{$IFEND};
    fhaCenter: AHTextAlign:=TTextAlign.{$IF CompilerVersion >= 35.0}Center{$ELSE}taCenter{$IFEND};
    fhaRight: AHTextAlign:=TTextAlign.{$IF CompilerVersion >= 35.0}Trailing{$ELSE}taTrailing{$IFEND};
  end;

  //垂直对齐
  AVTextAlign:=TTextAlign.{$IF CompilerVersion >= 35.0}Leading{$ELSE}taLeading{$IFEND};
  case ADrawTextParam.FontVertAlign of
    fvaTop: AVTextAlign:=TTextAlign.{$IF CompilerVersion >= 35.0}Leading{$ELSE}taLeading{$IFEND};
    fvaCenter: AVTextAlign:=TTextAlign.{$IF CompilerVersion >= 35.0}Center{$ELSE}taCenter{$IFEND};
    fvaBottom: AVTextAlign:=TTextAlign.{$IF CompilerVersion >= 35.0}Trailing{$ELSE}taTrailing{$IFEND};
  end;

  {$IFDEF MSWINDOWS}
  if Not ADrawTextParam.IsWordWrap and (AColorTextList<>nil) then
  begin
        //仅用于演示
        //一个字一个字的绘制
        //先计算出宽度
        ADrawTextSumWidth:=0;
        for I := 0 to AColorTextList.GetColorTextCount-1 do
        begin
              AColorTextItem:=AColorTextList.Items[I];

              ADrawFont:=AColorTextItem.FDrawFont;
              ADrawFontColor:=AColorTextItem.FDrawFont.FontColor;
              if AColorTextItem.FIsUseDefaultDrawFont then
              begin
                ADrawFont:=ADrawTextParam.DrawFont;
              end;
              if AColorTextItem.FIsUseDefaultDrawFontColor then
              begin
                ADrawFontColor:=ADrawTextParam.CurrentEffectFontColor;
              end;

              FCanvas.Font.Assign(ADrawFont);
              FCanvas.Fill.Color:=ADrawFontColor.Color;


              AColorTextItem.DrawWidth:=FCanvas.TextWidth(AColorTextItem.FText);
              AColorTextItem.DrawHeight:=FCanvas.TextHeight(AColorTextItem.FText);
              ADrawTextSumWidth:=ADrawTextSumWidth+AColorTextItem.DrawWidth;

              AColorTextItem.DrawTop:=0;
              case ADrawTextParam.FontVertAlign of
                fvaTop: ;
                fvaCenter: AColorTextItem.DrawTop:=(BDrawRect.Height-AColorTextItem.DrawHeight)/2;
                fvaBottom:
                begin
                  AColorTextItem.DrawTop:=BDrawRect.Height-AColorTextItem.DrawHeight;
                  if AColorTextItem.DrawTop<0 then
                  begin
                    AColorTextItem.DrawTop:=0;
                  end;
                end;
              end;

        end;


        //水平居中
        ADrawStartLeft:=0;
        case ADrawTextParam.FontHorzAlign of
          fhaLeft:
          begin
          end;
          fhaCenter:
          begin
            ADrawStartLeft:=(BDrawRect.Width-ADrawTextSumWidth)/2;
          end;
          fhaRight:
          begin
            ADrawStartLeft:=BDrawRect.Width-ADrawTextSumWidth;
          end;
        end;

        for I := 0 to AColorTextList.GetColorTextCount-1 do
        begin
          AColorTextItem:=AColorTextList.Items[I];

          ADrawFont:=AColorTextItem.FDrawFont;
          ADrawFontColor:=AColorTextItem.FDrawFont.FontColor;
          if AColorTextItem.FIsUseDefaultDrawFont then
          begin
            ADrawFont:=ADrawTextParam.DrawFont;
          end;
          if AColorTextItem.FIsUseDefaultDrawFontColor then
          begin
            ADrawFontColor:=ADrawTextParam.CurrentEffectFontColor;
          end;


          FCanvas.Font.Assign(ADrawFont);
          FCanvas.Fill.Color:=ADrawFontColor.Color;


          FCanvas.FillText(RectF(BDrawRect.Left+ADrawStartLeft,
                                 BDrawRect.Top+AColorTextItem.DrawTop,
                                 BDrawRect.Left+ADrawStartLeft+AColorTextItem.DrawWidth,
                                 BDrawRect.Top+AColorTextItem.DrawTop+AColorTextItem.DrawHeight
                                 ),
                                 AColorTextItem.FText,
                                 False,
                                 1,
                                 [],
                                 TTextAlign.{$IF CompilerVersion >= 35.0}Leading{$ELSE}taLeading{$IFEND},
                                 AVTextAlign
                                 );
          ADrawStartLeft:=ADrawStartLeft+AColorTextItem.DrawWidth;
        end;


        Exit;
  end;
  {$ENDIF}


  if ADrawTextParam.FTextLayout=nil then
  begin
    ADrawTextParam.FTextLayout := TTextLayoutManager.TextLayoutByCanvas(FCanvas.ClassType).Create(FCanvas);
  end;


  ADrawTextParam.FTextLayout.BeginUpdate;


  ADrawTextParam.FTextLayout.TopLeft := BDrawRect.TopLeft;
  ADrawTextParam.FTextLayout.MaxSize := PointF(BDrawRect.Width, BDrawRect.Height);

  ADrawTextParam.FTextLayout.Text := BText;

  ADrawTextParam.FTextLayout.Opacity := ADrawTextParam.DrawAlpha/255;

  case ADrawTextParam.FontTrimming of
    fttNone: ADrawTextParam.FTextLayout.Trimming:=TTextTrimming.None;
    fttCharacter: ADrawTextParam.FTextLayout.Trimming:=TTextTrimming.Character;
    fftWord: ADrawTextParam.FTextLayout.Trimming:=TTextTrimming.Word;
  end;


  if Not GlobalIsUseDefaultFontFamily  then
  begin
    ADrawTextParam.FTextLayout.Font.Family:=ADrawTextParam.CurrentEffectFontName;
  end
  else
  begin
    if GlobalDefaultFontFamily<>'' then
    begin
      ADrawTextParam.FTextLayout.Font.Family:=GlobalDefaultFontFamily;
    end
    else
    begin
      //使用系统默认的字体
    end;
  end;


  FCanvas.Font.Size:=Floor(ADrawTextParam.CurrentEffectFontSize);
  //一定要加Ceil,如果不加Ceil,在Windows上会出现字体异常
  ADrawTextParam.FTextLayout.Font.Size:=Floor(ADrawTextParam.CurrentEffectFontSize);
//  uBaseLog.OutputDebugString('CurrentEffectFontSize'+FloatToStr(ADrawTextParam.CurrentEffectFontSize));

  ADrawTextParam.FTextLayout.Font.Style:=ADrawTextParam.CurrentEffectFontStyle;
  ADrawTextParam.FTextLayout.Color:=ADrawTextParam.CurrentEffectFontColor.Color;

  ADrawTextParam.FTextLayout.HorizontalAlign := AHTextAlign;
  ADrawTextParam.FTextLayout.VerticalAlign := AVTextAlign;
  ADrawTextParam.FTextLayout.WordWrap := ADrawTextParam.IsWordWrap;



  if AColorTextList<>nil then
  begin
    {$IFNDEF MSWINDOWS}
    //AColorTextList不能有回车
    ADarwStartIndex:=0;
    ADrawTextParam.FTextLayout.ClearAttributes;
    for I := 0 to AColorTextList.GetColorTextCount-1 do
    begin

      AColorTextItem:=AColorTextList.Items[I];

      ADrawFont:=AColorTextItem.FDrawFont;
      ADrawFontColor:=AColorTextItem.FDrawFont.FontColor;
      if AColorTextItem.FIsUseDefaultDrawFont then
      begin
        ADrawFont:=ADrawTextParam.DrawFont;
      end;
      if AColorTextItem.FIsUseDefaultDrawFontColor then
      begin
        ADrawFontColor:=ADrawTextParam.CurrentEffectFontColor;
      end;


      ADrawLength:=Length(AColorTextItem.FText);
      ADrawTextParam.FTextLayout.AddAttribute(
            TTextRange.Create(ADarwStartIndex,ADrawLength),
            TTextAttribute.Create(ADrawFont,
                                  ADrawFontColor.Color
                                  )
            );
      ADarwStartIndex:=ADarwStartIndex+ADrawLength;
    end;
    {$ENDIF}
  end;


  ADrawTextParam.FTextLayout.EndUpdate;

  ADrawTextParam.FTextLayout.RenderLayout(FCanvas);

  if AColorTextList<>nil then
  begin
    //去除字体引用,不然会释放,引起报错
    for I := 0 to ADrawTextParam.FTextLayout.AttributesCount-1 do
    begin
      ADrawTextParam.FTextLayout.Attributes[I].Attribute.Font:=nil;
    end;
  end;



  Result:=True;
end;

procedure TFireMonkeyDrawCanvas.EndDraw;
begin
  FCanvas.EndScene;
end;

function TFireMonkeyDrawCanvas.FillPathData(ADrawPathParam:TDrawPathParam;ADrawPathData: TBaseDrawPathData): Boolean;
begin
  //创建画刷
  Self.FCanvas.Fill.Kind:=FMX.Graphics.TBrushKind.{$IF CompilerVersion >= 35.0}Solid{$ELSE}bkSolid{$IFEND};
  Self.FCanvas.Fill.Color:=ADrawPathParam.CurrentEffectFillDrawColor.Color;

  Self.FCanvas.FillPath(
        TFireMonkeyDrawPathData(ADrawPathData).Path,
        ADrawPathParam.DrawAlpha/255,
        Self.FCanvas.Fill);

end;

function TFireMonkeyDrawCanvas.PrepareFont(ADrawFont: TDrawFont;ADrawFontColor: TDrawColor): Boolean;
begin
  Result:=False;

  if Not GlobalIsUseDefaultFontFamily then
  begin
    FCanvas.Font.Family:=ADrawFont.Family;
  end
  else
  begin
    if GlobalDefaultFontFamily<>'' then
    begin
      FCanvas.Font.Family:=GlobalDefaultFontFamily;
    end
    else
    begin
      //使用系统默认的字体
    end;
  end;

  FCanvas.Font.Size:=Floor(ADrawFont.Size);
  FCanvas.Font.Style:=ADrawFont.Style;

  FCanvas.Fill.Color:=ADrawFontColor.Color;
  Result:=True;

end;

{ TFireMonkeyDrawPathData }

procedure TFireMonkeyDrawPathData.AddArc(const ARect: TRectF; AStartAngle,
  ASweepAngle: Double);
var
  ACenter:TPointF;
  ARadius:TPointF;
begin
  ACenter.X:=ARect.Left+ARect.Width/2;
  ACenter.Y:=ARect.Top+ARect.Height/2;

  ARadius.X:=ARect.Width/2;
  ARadius.Y:=ARect.Width/2;

  Self.Path.AddArc(ACenter,ARadius,AStartAngle,ASweepAngle);

end;

procedure TFireMonkeyDrawPathData.AddEllipse(const ARect: TRectF);
begin
  Self.Path.AddEllipse(ARect);
end;

procedure TFireMonkeyDrawPathData.AddPie(const ARect: TRectF; AStartAngle,
  ASweepAngle: Double);
var
  ACenter:TPointF;
  ARadius:TPointF;
begin
  ACenter.X:=ARect.Left+ARect.Width/2;
  ACenter.Y:=ARect.Top+ARect.Height/2;

  ARadius.X:=ARect.Width/2;
  ARadius.Y:=ARect.Width/2;


  Self.Path.MoveTo(ACenter);
  Self.Path.LineTo(ACenter);

  Self.Path.AddArc(ACenter,ARadius,AStartAngle,ASweepAngle);
end;

procedure TFireMonkeyDrawPathData.AddRect(const ARect: TRectF);
begin
  Self.Path.AddRectangle(ARect,0,0,[]);

end;

procedure TFireMonkeyDrawPathData.Clear;
begin
  Path.Clear;

end;

constructor TFireMonkeyDrawPathData.Create;
begin
  inherited;
  Path:=TPathData.Create;
  Stroke:=TStrokeBrush.Create(TBrushKind.Solid,BlackColor);

end;

procedure TFireMonkeyDrawPathData.CurveTo(const X, Y, X1, Y1, X2,
  Y2: Double);
begin
  Path.CurveTo(PointF(X,Y),PointF(X1,Y1),PointF(X2,Y2));
end;

destructor TFireMonkeyDrawPathData.Destroy;
begin
  FreeAndNil(Stroke);
  FreeAndNil(Path);
  inherited;
end;

//procedure TFireMonkeyDrawPathData.GetRegion;
//begin
//
//end;
//
//function TFireMonkeyDrawPathData.IsInRegion(const APoint: TPointF): Boolean;
//begin
//  Result:=False;
//end;

procedure TFireMonkeyDrawPathData.LineTo(const X:Double;const Y:Double);
begin
  Path.LineTo(PointF(X,Y));
end;

procedure TFireMonkeyDrawPathData.MoveTo(const X:Double;const Y:Double);
begin
  Path.MoveTo(PointF(X,Y));
end;


{$IFDEF ANDROID}


//// 四个角的x,y半径
//private float[] radiusArray = { 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f };
//private Paint bitmapPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
//
//private Bitmap makeRoundRectFrame(int w, int h) {
//    Bitmap bm = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
//    Canvas c = new Canvas(bm);
//    Path path = new Path();
//    path.addRoundRect(new RectF(0, 0, w, h), radiusArray, Path.Direction.CW);
//    Paint bitmapPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
//    bitmapPaint.setColor(Color.GREEN); // 颜色随意，不要有透明度。
//    c.drawPath(path, bitmapPaint);
//    return bm;
//}

function AndroidGenerateColorClipRoundRectBitmap(
                              AFillColor:TAlphaColor;
                              AWidth:Integer;
                              AHeight:Integer;
                              AXRadius:Double=-1;
                              AYRadius:Double=-1):TDrawPicture;
var
  ADestSurface: TBitmapSurface;

  ADestJBitmap:JBitmap;

  AJCanvas:JCanvas;
  AJPaint:JPaint;
  AJBitmapShader:JBitmapShader;
  AJRectF:JRectF;
  AJPath:JPath;
  AJPath2:JPath;
  radii: TJavaArray<Single>;
begin
  Result:=nil;

  if (AWidth<=0) or (AHeight<=0) then
  begin
    Exit;
  end;

  FMX.Types.Log.d('OrangeUI AndroidGenerateColorClipRoundRectBitmap Begin AXRadius='+FloatToStr(AXRadius)+' AYRadius='+FloatToStr(AYRadius));


//  //-1表示剪裁成圆形
//  if IsSameDouble(AXRadius,-1) then
//  begin
//    AXRadius := AWidth / 2;
//  end
//  else if (AXRadius<1) then
//  begin
//    //小数,表示百分比
//    AXRadius := AWidth * AXRadius;
//  end;
//
//  if IsSameDouble(AYRadius,-1) then
//  begin
//    AYRadius := AHeight / 2;
//  end
//  else if (AYRadius<1) then
//  begin
//    //小数,表示百分比
//    AYRadius := AHeight * AYRadius;
//  end;

  if IsSameDouble(AXRadius,-1) or IsSameDouble(AYRadius,-1) then
  begin
      AXRadius:=AWidth/2;
      AYRadius:=AHeight/2;
      //圆角保持一致,取最小的半径
      if AXRadius<AYRadius then
      begin
        AYRadius:=AXRadius;
      end
      else
      begin
        AXRadius:=AYRadius;
      end;

  end;



  AJPaint := TJPaint.Create;
  ADestSurface := TBitmapSurface.Create;
  ADestJBitmap := TJBitmap.JavaClass.createBitmap(AWidth, AHeight, TJBitmap_Config.JavaClass.ARGB_8888);
  Result:=TDrawPicture.Create;
  Result.SetSize(AWidth,AHeight);
  try

    //Canvas canvas = new Canvas(result);
    AJCanvas:=TJCanvas.JavaClass.init(ADestJBitmap);
    //paint.setAntiAlias(true);
    AJPaint.setAntiAlias(True);



    //填充色
    AJPaint.setColor(TAndroidHelper.AlphaColorToJColor(AFillColor));
    //    AJPaint.setColor(TJColor.JavaClass.BLACK);
    AJPaint.setStyle(TJPaint_Style.JavaClass.FILL);

    AJRectF:=TJRectF.JavaClass.init(0,0,AWidth,AHeight);

    radii:=TJavaArray<Single>.Create(8);


    //    Path path = new Path();
    AJPath:=TJPath.Create;
    //    path.addRoundRect(new RectF(0, 0, w, h), radiusArray, Path.Direction.CW);
    radii[0]:=AXRadius;
    radii[1]:=AYRadius;
    radii[2]:=AXRadius;
    radii[3]:=AYRadius;
    radii[4]:=AXRadius;
    radii[5]:=AYRadius;
    radii[6]:=AXRadius;
    radii[7]:=AYRadius;
    AJPath.addRoundRect(AJRectF,radii,TJPath_Direction.JavaClass.CW);


    AJPath2:=TJPath.Create;
    AJPath2.addRect(AJRectF,TJPath_Direction.JavaClass.CW);


    //取出不重叠的部分
    AJPath2.op(AJPath,TJPath_Op.JavaClass.DIFFERENCE);



    //    //canvas.drawRoundRect(AJRectF, radius, radius, paint);
    //    AJCanvas.drawRoundRect(AJRectF,AXRadius,AYRadius,AJPaint);
    AJCanvas.drawPath(AJPath2,AJPaint);


    //再将ADestJBitmap保存成TBitmap
    if not JBitmapToSurface(ADestJBitmap,ADestSurface) then
    begin
      Exit;
    end;

    Result.Assign(ADestSurface);

  finally
    ADestJBitmap.recycle;;

    FreeAndNil(ADestSurface);

    AJCanvas:=nil;
    AJBitmapShader:=nil;
    AJPaint:=nil;
  end;

  FMX.Types.Log.d('OrangeUI AndroidGenerateColorClipRoundRectBitmap End');

end;


function AndroidGenerateColorRoundRectBitmap(
                              AFillColor:TAlphaColor;
                              AWidth:Integer;
                              AHeight:Integer;
                              AXRadius:Double=-1;
                              AYRadius:Double=-1):TDrawPicture;
var
  ADestSurface: TBitmapSurface;

  ADestJBitmap:JBitmap;

  AJCanvas:JCanvas;
  AJPaint:JPaint;
  AJBitmapShader:JBitmapShader;
  AJRectF:JRectF;
begin
  Result:=nil;


  if (AWidth<=0) or (AHeight<=0) then
  begin
    Exit;
  end;


//  FMX.Types.Log.d('OrangeUI AndroidGenerateColorRoundRectBitmap Begin AXRadius='+FloatToStr(AXRadius)+' AYRadius='+FloatToStr(AYRadius));


  //-1表示剪裁成圆形
//  if IsSameDouble(AXRadius,-1) then
//  begin
//    AXRadius := AWidth / 2;
//  end
//  else if (AXRadius<1) then
//  begin
//    //小数,表示百分比
//    AXRadius := AWidth * AXRadius;
//  end;
//
//  if IsSameDouble(AYRadius,-1) then
//  begin
//    AYRadius := AHeight / 2;
//  end
//  else if (AYRadius<1) then
//  begin
//    //小数,表示百分比
//    AYRadius := AHeight * AYRadius;
//  end;

  if IsSameDouble(AXRadius,-1) or IsSameDouble(AYRadius,-1) then
  begin
      AXRadius:=AWidth/2;
      AYRadius:=AHeight/2;
      //圆角保持一致,取最小的半径
      if AXRadius<AYRadius then
      begin
        AYRadius:=AXRadius;
      end
      else
      begin
        AXRadius:=AYRadius;
      end;

  end;





  AJPaint := TJPaint.Create;
  ADestSurface := TBitmapSurface.Create;
  ADestJBitmap := TJBitmap.JavaClass.createBitmap(AWidth, AHeight, TJBitmap_Config.JavaClass.ARGB_8888);
  Result:=TDrawPicture.Create;
  Result.SetSize(AWidth,AHeight);
  try

    //Canvas canvas = new Canvas(result);
    AJCanvas:=TJCanvas.JavaClass.init(ADestJBitmap);
    //paint.setAntiAlias(true);
    AJPaint.setAntiAlias(True);

    //填充色
    AJPaint.setColor(TAndroidHelper.AlphaColorToJColor(AFillColor));
    //    AJPaint.setColor(TJColor.JavaClass.BLACK);
    AJPaint.setStyle(TJPaint_Style.JavaClass.FILL);

    AJRectF:=TJRectF.JavaClass.init(0,0,AWidth,AHeight);
    //    //canvas.drawRoundRect(AJRectF, radius, radius, paint);
    AJCanvas.drawRoundRect(AJRectF,AXRadius,AYRadius,AJPaint);



    //再将ADestJBitmap保存成TBitmap
    if not JBitmapToSurface(ADestJBitmap,ADestSurface) then
    begin
      Exit;
    end;

    Result.Assign(ADestSurface);

  finally
    ADestJBitmap.recycle;;

    FreeAndNil(ADestSurface);

    AJCanvas:=nil;
    AJBitmapShader:=nil;
    AJPaint:=nil;
  end;

//  FMX.Types.Log.d('OrangeUI AndroidGenerateColorRoundRectBitmap End');
end;
{$ENDIF}



{ TColorRoundRectBitmapList }

function GenerateColorRoundBitmap(AFillColor:TAlphaColor;
                                  AWidth:Integer;
                                  AHeight:Integer;
                                  AXRadius:Double;
                                  AYRadius:Double;
                                  ACorners:TCorners
                                  ): TDrawPicture;
begin

  {$IFDEF ANDROID}
  Result:=AndroidGenerateColorRoundRectBitmap(AFillColor,AWidth,AHeight,AXRadius,AYRadius);
  Exit;
  {$ENDIF}

  //生成圆角图片
  Result:=DefaultGenerateColorRoundRectBitmap(AFillColor,AWidth,AHeight,AXRadius,AYRadius,ACorners);

end;


function GenerateColorClipRoundBitmap(AFillColor:TAlphaColor;
                                  AWidth:Integer;
                                  AHeight:Integer;
                                  AXRadius:Double;
                                  AYRadius:Double;
                                  ACorners:TCorners
                                  ): TDrawPicture;
begin

  {$IFDEF ANDROID}
  Result:=AndroidGenerateColorClipRoundRectBitmap(AFillColor,AWidth,AHeight,AXRadius,AYRadius);
  Exit;
  {$ENDIF}

  //生成圆角图片
  Result:=DefaultGenerateColorClipRoundRectBitmap(AFillColor,AWidth,AHeight,AXRadius,AYRadius,ACorners);

end;

function DefaultGenerateColorRoundRectBitmap(AFillColor:TAlphaColor;
                                  AWidth:Integer;
                                  AHeight:Integer;
                                  AXRadius:Double;
                                  AYRadius:Double;
                                  ACorners:TCorners
                                  ): TDrawPicture;
begin
  Result:=nil;


  if (AWidth<=0) or (AHeight<=0) then
  begin
    Exit;
  end;




//  //-1表示剪裁成圆形
//  if IsSameDouble(AXRadius,-1) then
//  begin
//    AXRadius := AWidth / 2;
//  end
//  else if (AXRadius<1) then
//  begin
//    //小数,表示百分比
//    AXRadius := AWidth * AXRadius;
//  end;
//
//  if IsSameDouble(AYRadius,-1) then
//  begin
//    AYRadius := AHeight / 2;
//  end
//  else if (AYRadius<1) then
//  begin
//    //小数,表示百分比
//    AYRadius := AHeight * AYRadius;
//  end;

  if IsSameDouble(AXRadius,-1) or IsSameDouble(AYRadius,-1) then
  begin
      AXRadius:=AWidth/2;
      AYRadius:=AHeight/2;
      //圆角保持一致,取最小的半径
      if AXRadius<AYRadius then
      begin
        AYRadius:=AXRadius;
      end
      else
      begin
        AXRadius:=AYRadius;
      end;

  end;



  //生成圆角图片
  Result:=TDrawPicture.Create;
  //不要求很大
  Result.SetSize(AWidth,AHeight);
  Result.Canvas.BeginScene();
  try
    Result.Canvas.Clear(0);

    Result.Canvas.Fill.Kind:=TBrushKind.Solid;
    Result.Canvas.Fill.Color:=AFillColor;
    Result.Canvas.FillRect(
                          RectF(0,0,AWidth,AHeight),
                          AXRadius,
                          AYRadius,
                          ACorners,
                          1
                          );
  finally
    Result.Canvas.EndScene;
  end;

end;

function DefaultGenerateColorClipRoundRectBitmap(AFillColor:TAlphaColor;
                                  AWidth:Integer;
                                  AHeight:Integer;
                                  AXRadius:Double;
                                  AYRadius:Double;
                                  ACorners:TCorners
                                  ): TDrawPicture;
var
//  AFillRect:TRectF;
//  ADrawBorderRect:TRectF;
//
//  ASides:TSides;
//  ACorners:TCorners;
//
//  BDrawRect:TRectF;
//
  AClipPathData:TPathData;
//  AClipRect:TRectF;
//  ARoundWidth:Double;
//  ARoundHeight:Double;
//  AClipRoundWidth:Double;
//  AClipRoundHeight:Double;
//
//  ADrawRectParamCurrentEffectIsFill:Boolean;
//  ADrawRectParamCurrentEffectBorderWidth:Double;
//var
//  StrokeThicknessRestoreValue:Single;
//var
//  APt1, APt2: TPointF;
//
//  ARoundRectBitmap:TDrawPicture;
begin
  Result:=nil;


  if (AWidth<=0) or (AHeight<=0) then
  begin
    Exit;
  end;
  FMX.Types.Log.d('OrangeUI DefaultGenerateColorClipRoundRectBitmap Begin AXRadius='+FloatToStr(AXRadius)+' AYRadius='+FloatToStr(AYRadius));


//  //-1表示剪裁成圆形
//  if IsSameDouble(AXRadius,-1) then
//  begin
//    AXRadius := AWidth / 2;
//  end
//  else if (AXRadius<1) then
//  begin
//    //小数,表示百分比
//    AXRadius := AWidth * AXRadius;
//  end;
//
//  if IsSameDouble(AYRadius,-1) then
//  begin
//    AYRadius := AHeight / 2;
//  end
//  else if (AYRadius<1) then
//  begin
//    //小数,表示百分比
//    AYRadius := AHeight * AYRadius;
//  end;

  if IsSameDouble(AXRadius,-1) or IsSameDouble(AYRadius,-1) then
  begin
      AXRadius:=AWidth/2;
      AYRadius:=AHeight/2;
      //圆角保持一致,取最小的半径
      if AXRadius<AYRadius then
      begin
        AYRadius:=AXRadius;
      end
      else
      begin
        AXRadius:=AYRadius;
      end;

  end;



  //生成圆角图片
  Result:=TDrawPicture.Create;
  //不要求很大
  Result.SetSize(AWidth,AHeight);
  Result.Canvas.BeginScene();
  try
    Result.Canvas.Clear(0);

    Result.Canvas.Fill.Kind:=TBrushKind.Solid;
    Result.Canvas.Fill.Color:=AFillColor;
//    Result.Canvas.FillRect(
//                          RectF(0,0,AWidth,AHeight),
//                          AXRadius,
//                          AYRadius,
//                          ACorners,
//                          1
//                          );

                //用于RoundImage
                AClipPathData:=TPathData.Create;
                try
//                    if Not ADrawRectParam.IsRound then
//                    begin
                      //不是圆角
                      AClipPathData.AddRectangle(RectF(0,0,AWidth,AHeight),0,0,[]);
//                    end
//                    else
//                    begin
//                      //有圆角
//                      AClipPathData.AddRectangle(AFillRect,ARoundWidth,ARoundHeight,ACorners);
//                    end;
//
//                    AClipRect:=ADrawRectParam.FClipRoundRectSetting.CalcDrawRect(BDrawRect);
//                    AClipRoundWidth:=ADrawRectParam.FClipRoundWidth;
//                    AClipRoundHeight:=ADrawRectParam.FClipRoundHeight;
//                    if IsSameDouble(AClipRoundWidth,-1) then AClipRoundWidth:=AClipRect.Width/2;
//                    if IsSameDouble(AClipRoundHeight,-1) then AClipRoundHeight:=AClipRect.Height/2;


                    //圆角矩形
                    //这样更圆,Android平台下会变龟头
                    AddRoundRectPath(AClipPathData,
                                     RectF(0,0,AWidth,AHeight),
                                     AXRadius,
                                     AYRadius,
                                     ACorners
                                     );

//                      //AddRectangle这样不圆的
//                    AClipPathData.AddRectangle(AClipRect,
//                                              AClipRoundWidth,
//                                              AClipRoundHeight,
//                                              ACorners
//                                              );


                    //不需要ClosePath,不然会黑屏
                    //AClipPathData.ClosePath;

                    Result.Canvas.FillPath(AClipPathData,1);//ADrawRectParam.DrawAlpha/255);
                finally
                  FreeAndNil(AClipPathData);
                end;




  finally
    Result.Canvas.EndScene;
  end;

end;

function GenerateColorRoundBitmapByParam(ADrawRectParam:TDrawRectParam;
                                          AFillColor:TAlphaColor;
                                          AWidth:Integer;
                                          AHeight:Integer;
                                          AXRadius:Double;
                                          AYRadius:Double
                                          ): TDrawPicture;
var
  ACorners:TCorners;
begin

  //角
  ACorners:=[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight];
  if not (rcTopLeft in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.TopLeft];
  if not (rcTopRight in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.TopRight];
  if not (rcBottomLeft in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.BottomLeft];
  if not (rcBottomRight in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.BottomRight];

  Result:=GenerateColorRoundBitmap(AFillColor,
                                  AWidth,
                                  AHeight,
                                  AXRadius,
                                  AYRadius,
                                  ACorners);
end;

function GenerateColorClipRoundBitmapByParam(ADrawRectParam:TDrawRectParam;
                                            AFillColor:TAlphaColor;
                                            AWidth:Integer;
                                            AHeight:Integer;
                                            AXRadius:Double;
                                            AYRadius:Double
                                            ): TDrawPicture;
var
  ACorners:TCorners;
begin

  //角
  ACorners:=[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight];
  if not (rcTopLeft in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.TopLeft];
  if not (rcTopRight in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.TopRight];
  if not (rcBottomLeft in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.BottomLeft];
  if not (rcBottomRight in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.BottomRight];

  Result:=GenerateColorClipRoundBitmap(AFillColor,
                                  AWidth,
                                  AHeight,
                                  AXRadius,
                                  AYRadius,
                                  ACorners);
end;

function TColorRoundRectBitmapList.GetBitmap(ADrawRectParam:TDrawRectParam;
                                              AWidth:Double;
                                              AHeight:Double;
                                              AXRadius:Double;
                                              AYRadius:Double;
                                              AIsClipRound:Boolean): TDrawPicture;
var
  I: Integer;
  AColorRoundRectBitmap:TColorRoundRectBitmap;
begin
  Result:=nil;


//  //-1表示剪裁成圆形
//  if IsSameDouble(AXRadius,-1) then
//  begin
//    AXRadius := AWidth / 2;
//  end
//  else if (AXRadius<1) then
//  begin
//    //小数,表示百分比
//    AXRadius := AWidth * AXRadius;
//  end;
//
//  if IsSameDouble(AYRadius,-1) then
//  begin
//    AYRadius := AHeight / 2;
//  end
//  else if (AYRadius<1) then
//  begin
//    //小数,表示百分比
//    AYRadius := AHeight * AYRadius;
//  end;




  for I := 0 to Self.Count-1 do
  begin
      AColorRoundRectBitmap:=TColorRoundRectBitmap(Items[I]);

      if    IsSameDouble(AColorRoundRectBitmap.RoundWidth,AXRadius*Const_BufferBitmapScale)
        and IsSameDouble(AColorRoundRectBitmap.RoundHeight,AYRadius*Const_BufferBitmapScale)

        and IsSameDouble(AColorRoundRectBitmap.Width,AWidth*Const_BufferBitmapScale)
        and IsSameDouble(AColorRoundRectBitmap.Height,AHeight*Const_BufferBitmapScale)

        and (AColorRoundRectBitmap.FillColor=ADrawRectParam.CurrentEffectFillDrawColor.Color)
//        {$IFDEF FMX}
        and (AColorRoundRectBitmap.RectCorners=ADrawRectParam.RectCorners)
        and (AColorRoundRectBitmap.IsClipRound=AIsClipRound)
//        {$ENDIF FMX}
         then
      begin
        Result:=AColorRoundRectBitmap.Bitmap;
        Exit;
      end;

  end;

  AColorRoundRectBitmap:=TColorRoundRectBitmap.Create;
  AColorRoundRectBitmap.DrawRectParam:=ADrawRectParam;

  AColorRoundRectBitmap.Width:=AWidth*Const_BufferBitmapScale;
  AColorRoundRectBitmap.Height:=AHeight*Const_BufferBitmapScale;

  AColorRoundRectBitmap.RoundWidth:=AXRadius*Const_BufferBitmapScale;
  AColorRoundRectBitmap.RoundHeight:=AYRadius*Const_BufferBitmapScale;

  AColorRoundRectBitmap.FillColor:=ADrawRectParam.CurrentEffectFillDrawColor.Color;
//  {$IFDEF FMX}
  AColorRoundRectBitmap.RectCorners:=ADrawRectParam.RectCorners;
  AColorRoundRectBitmap.IsClipRound:=AIsClipRound;
//  {$ENDIF FMX}


//  //角
//  ACorners:=[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight];
//  if not (rcTopLeft in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.TopLeft];
//  if not (rcTopRight in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.TopRight];
//  if not (rcBottomLeft in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.BottomLeft];
//  if not (rcBottomRight in ADrawRectParam.RectCorners) then ACorners:=ACorners-[TCorner.BottomRight];


  if not AIsClipRound then
  begin
    //生成圆角图片
    AColorRoundRectBitmap.Bitmap:=GenerateColorRoundBitmapByParam(ADrawRectParam,
                                                                  AColorRoundRectBitmap.FillColor,
                                                                  Ceil(AColorRoundRectBitmap.Width),
                                                                  Ceil(AColorRoundRectBitmap.Height),
                                                                  AColorRoundRectBitmap.RoundWidth,
                                                                  AColorRoundRectBitmap.RoundHeight
                                                                  );
  end
  else
  begin
    //生成中空圆角图片
    AColorRoundRectBitmap.Bitmap:=GenerateColorClipRoundBitmapByParam(ADrawRectParam,
                                                                  AColorRoundRectBitmap.FillColor,
                                                                  Ceil(AColorRoundRectBitmap.Width),
                                                                  Ceil(AColorRoundRectBitmap.Height),
                                                                  AColorRoundRectBitmap.RoundWidth,
                                                                  AColorRoundRectBitmap.RoundHeight
                                                                  );
  end;


//  AColorRoundRectBitmap.Bitmap:=TDrawPicture.Create;
//  AColorRoundRectBitmap.Bitmap.SetSize(100,100);
//  AColorRoundRectBitmap.Bitmap.Canvas.BeginScene();
//  try
//    AColorRoundRectBitmap.Bitmap.Canvas.Clear(0);
//
//    AColorRoundRectBitmap.Bitmap.Canvas.Fill.Kind:=TBrushKind.Solid;
//    AColorRoundRectBitmap.Bitmap.Canvas.Fill.Color:=AColorRoundRectBitmap.FillColor;
//    AColorRoundRectBitmap.Bitmap.Canvas.FillRect(
//          RectF(0,0,AColorRoundRectBitmap.Bitmap.Width,AColorRoundRectBitmap.Bitmap.Height),
//          AColorRoundRectBitmap.RoundWidth,
//          AColorRoundRectBitmap.RoundHeight,
//          ACorners,
//          1
//          );
//  finally
//    AColorRoundRectBitmap.Bitmap.Canvas.EndScene;
//  end;



  Self.Add(AColorRoundRectBitmap);


  Result:=AColorRoundRectBitmap.Bitmap;
end;

{ TColorRoundRectBitmap }

destructor TColorRoundRectBitmap.Destroy;
begin
  FreeAndNil(Bitmap);
  inherited;
end;





initialization
  IsDrawBitmapHignSpeed:=False;
  IsDrawRoundRectByBufferOnAndroid:=True;
  GlobalColorRoundRectBitmapList:=TColorRoundRectBitmapList.Create;

finalization
  FreeAndNil(GlobalColorRoundRectBitmapList);


end.
//------------------------------------------------------------------
//
//                 OrangeUI Source Files
//
//  Module: OrangeGraphic
//  Unit: uFireMonkeyDrawCanvas
//  Description: FMX画布
//
//  Copyright: delphiteacher
//  CodeBy: delphiteacher
//  Email: ggggcexx@163.com
//  Writing: 2012-2014
//
//------------------------------------------------------------------




