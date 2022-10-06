//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     画布基类
///   </para>
///   <para>
///     Base class of canvas
///   </para>
/// </summary>
unit uDrawCanvas;

interface
{$I FrameWork.inc}

uses
  Classes,
  Math,
  SysUtils,

  {$IF CompilerVersion>=30.0}
  Types,//定义了TRectF
  {$IFEND}

  {$IFDEF VCL}
  Windows,
  Messages,
  Controls,
  Graphics,
  {$ENDIF}


  {$IFDEF FMX}
  UITypes,
  FMX.Types,
//  FMX.Graphics,
  FMX.Graphics,
  FMX.Platform,
//  Types,
//  FMX.Types,
  FMX.Objects,
//  FMX.Graphics,
//  FMX.Platform,
  {$ENDIF}


  uBaseLog,
  uBasePathData,
  uFuncCommon,
  uSkinPicture,
  uGraphicCommon,
  uDrawPicture,
  uDrawParam,
  uDrawTextParam,
  uDrawRectParam,
  uDrawLineParam,
  uDrawPathParam,
  uDrawPictureParam;


const
  //如果不加偏移,在移动平台上绘制的时候一个像素的线会画成两个像素
  Const_DrawLineOffset=0.5;


type
  /// <summary>
  ///   <para>
  ///     计算绘制尺寸的类型
  ///   </para>
  ///   <para>
  ///     Calculate draw size type
  ///   </para>
  /// </summary>
  TCalcDrawSizeType=(
                      /// <summary>
                      ///   计算绘制高度和宽度
                      ///   <para>
                      ///     Calculate draw height and width
                      ///   </para>
                      /// </summary>
                      cdstBoth,
                      /// <summary>
                      ///   只计算绘制宽度
                      ///   <para>
                      ///     Only Calculate draw width
                      ///   </para>
                      /// </summary>
                      cdstWidth,
                      /// <summary>
                      ///   只计算绘制高度
                      ///   <para>
                      ///   Only Calculate draw height
                      ///   </para>
                      /// </summary>
                      cdstHeight

                     );








  /// <summary>
  ///   <para>
  ///     画布基类
  ///   </para>
  ///   <para>
  ///     Base class of canvas
  ///   </para>
  /// </summary>
  TDrawCanvas=class
  protected
    function CustomPrepare:Boolean;virtual;abstract;
    function CustomUnPrepare:Boolean;virtual;abstract;
  public
    FName:String;
    {$IFDEF VCL}
    //绘制句柄
    FHandle:HDC;
    {$ENDIF}
    {$IFDEF FMX}
    {$ENDIF}
  public


    /// <summary>
    ///   <para>
    ///     画布
    ///   </para>
    ///   <para>
    ///     Canvas
    ///   </para>
    /// </summary>
    FCanvas:TCanvas;

    //Canvas是自己创建的
    FCanvasIsOwn:Boolean;
    function GetCanvas: TCanvas;
  public

    /// <summary>
    ///   <para>
    ///     开始绘制
    ///   </para>
    ///   <para>
    ///     Begin draw
    ///   </para>
    /// </summary>
    function BeginDraw:Boolean;virtual;
    /// <summary>
    ///   <para>
    ///     结束绘制
    ///   </para>
    ///   <para>
    ///     End draw
    ///   </para>
    /// </summary>
    procedure EndDraw;virtual;




    /// <summary>
    ///   <para>
    ///     设置剪裁区域
    ///   </para>
    ///   <para>
    ///     Set clip area
    ///   </para>
    /// </summary>
    procedure SetClip(const AClipRect:TRectF);virtual;abstract;
    /// <summary>
    ///   <para>
    ///     取消剪裁区域
    ///   </para>
    ///   <para>
    ///     Cancel clip area
    ///   </para>
    /// </summary>
    procedure ResetClip;virtual;abstract;





    /// <summary>
    ///   <para>
    ///     绘制设计时控件的矩形
    ///   </para>
    ///   <para>
    ///     Draw rectangle of Control at designing time
    ///   </para>
    /// </summary>
    function DrawDesigningRect(const ADrawRect:TRectF;const ABorderColor:TDelphiColor):Boolean;virtual;abstract;

    /// <summary>
    ///   <para>
    ///     绘制设计时控件的文本
    ///   </para>
    ///   <para>
    ///     Draw text of Control at desigining time
    ///   </para>
    /// </summary>
    function DrawDesigningText(const ADrawRect:TRectF;const AText:String):Boolean;virtual;abstract;




    /// <summary>
    ///   <para>
    ///     绘制Path
    ///   </para>
    ///   <para>
    ///     Draw Path
    ///   </para>
    /// </summary>
    function DrawPathData(ADrawPathData:TBaseDrawPathData):Boolean;virtual;
    function FillPathData(ADrawPathParam:TDrawPathParam;ADrawPathData:TBaseDrawPathData):Boolean;virtual;
    function DrawPath(ADrawPathParam:TDrawPathParam;const ADrawRect:TRectF;APathActions:TPathActionCollection):Boolean;virtual;


    /// <summary>
    ///   <para>
    ///     计算文本绘制的尺寸
    ///   </para>
    ///   <para>
    ///     Calculate DrawSize of text
    ///   </para>
    /// </summary>
    /// <param name="ADrawTextParam">
    ///   文本绘制参数
    ///  <para>
    ///  Parameters of DrawText
    ///  </para>
    /// </param>
    /// <param name="AText">
    ///   文本
    ///  <para>
    ///    Text
    ///  </para>
    /// </param>
    /// <param name="ADrawRect">
    ///   绘制矩形
    ///  <para>
    ///  Draw rectangle
    ///  </para>
    /// </param>
    /// <param name="ADrawWidth">
    ///   返回的绘制宽度
    ///  <para>
    ///  Returned DrawWidth
    ///  </para>
    /// </param>
    /// <param name="ADrawHeight">
    ///   返回的绘制高度 <br />
    ///  <para>
    ///  Returned DrawHeight
    ///  </para>
    /// </param>
    /// <param name="ACalcDrawSizeType">
    ///   尺寸计算的类型
    ///  <para>
    ///  Size of calculate type
    ///  </para>
    /// </param>
    function CalcTextDrawSize(const ADrawTextParam:TDrawTextParam;
                              const AText:String;
                              const ADrawRect:TRectF;
                              var ADrawWidth:TControlSize;
                              var ADrawHeight:TControlSize;
                              const ACalcDrawSizeType:TCalcDrawSizeType):Boolean;virtual;abstract;



    /// <summary>
    ///   <para>
    ///     绘制文本
    ///   </para>
    ///   <para>
    ///     Draw text
    ///   </para>
    /// </summary>
    /// <param name="ADrawTextParam">
    ///   文本绘制参数
    ///  <para>
    ///  Draw parameters of text
    ///  </para>
    /// </param>
    /// <param name="AText">
    ///   文本
    ///  <para>
    ///  Text
    ///  </para>
    /// </param>
    /// <param name="ADrawRect">
    ///   绘制矩形
    ///  <para>
    ///  Draw rectangle
    ///  </para>
    /// </param>
    /// <param name="AColorTextList">
    ///   多颜色文本列表
    ///  <para>
    ///  Multi color text list
    ///  </para>
    /// </param>
    function DrawText(const ADrawTextParam:TDrawTextParam;
                      const AText:String;
                      const ADrawRect:TRectF;
                      const AColorTextList:IColorTextList=nil):Boolean;virtual;abstract;



    /// <summary>
    ///   <para>
    ///     计算文本的绘制矩形
    ///   </para>
    ///   <para>
    ///     Calculate drawing rectangle of text
    ///   </para>
    /// </summary>
    /// <param name="ADrawTextParam">
    ///   文本绘制参数
    ///  <para>
    ///  Text draw parameter
    ///  </para>
    ///  <para>
    ///  Text
    ///  </para>
    /// </param>
    /// <param name="AText">
    ///   文本
    ///  <para>
    ///  Text
    ///  </para>
    /// </param>
    /// <param name="ADrawRect">
    ///   绘制矩形
    ///  <para>
    ///  Draw rectangle
    ///  </para>
    /// </param>
    /// <param name="ATextDrawRect">
    ///   返回的文本绘制矩形
    ///  <para>
    ///  Returned text draw rectangle
    ///  </para>
    /// </param>
    function CalcTextDrawRect(const ADrawTextParam:TDrawTextParam;
                              const AText:String;
                              const ADrawRect:TRectF;
                              var ATextDrawRect:TRectF):Boolean;virtual;


    /// <summary>
    ///   <para>
    ///     绘制图片
    ///   </para>
    ///   <para>
    ///     Draw picture
    ///   </para>
    /// </summary>
    /// <param name="ADrawPictureParam">
    ///   图片绘制参数
    ///  <para>
    ///   Picture draw parameter
    ///  </para>
    /// </param>
    /// <param name="ADrawPicture">
    ///   图片
    ///  <para>
    ///  Picture
    ///  </para>
    /// </param>
    /// <param name="ADrawRect">
    ///   绘制矩形
    ///  <para>
    ///  Draw rectangle
    ///  </para>
    /// </param>
    function DrawPicture(const ADrawPictureParam:TDrawPictureParam;
                        const ADrawPicture:TBaseDrawPicture;
                        const ADrawRect:TRectF
                        ):Boolean;


    /// <summary>
    ///   <para>
    ///     绘制图片
    ///   </para>
    ///   <para>
    ///     Draw picture
    ///   </para>
    /// </summary>
    /// <param name="ADrawPictureParam">
    ///   图片绘制参数
    ///  <para>
    ///  Picture draw parameter
    ///  </para>
    /// </param>
    /// <param name="ASkinPicture">
    ///   图片
    ///  <para>
    ///  picture
    ///  </para>
    /// </param>
    /// <param name="ADrawRect">
    ///   绘制矩形
    ///  <para>
    ///  Draw rectangle
    ///  </para>
    /// </param>
    /// <param name="AIsUseSrcRectAndDestDrawRect">
    ///   是否使用图片源矩形
    ///  <para>
    ///  Whether use picture original rectangle
    ///  </para>
    /// </param>
    /// <param name="AImageSrcRect">
    ///   图片源矩形
    ///  <para>
    ///  Picture original rectangle
    ///  </para>
    /// </param>
    /// <param name="AImageDestDrawRect">
    ///   图片目标矩形
    ///  <para>
    ///  picture target rectangle
    ///  </para>
    /// </param>
    function DrawSkinPicture(const ADrawPictureParam:TDrawPictureParam;
                            const ASkinPicture:TSkinPicture;
                            const ADrawRect:TRectF;
                            const AIsUseSrcRectAndDestDrawRect:Boolean;
                            const AImageSrcRect:TRectF;
                            const AImageDestDrawRect:TRectF
                            ):Boolean;virtual;abstract;


    /// <summary>
    ///   <para>
    ///     绘制矩形
    ///   </para>
    ///   <para>
    ///     Draw rectangle
    ///   </para>
    /// </summary>
    /// <param name="ADrawRectParam">
    ///   矩形绘制参数
    ///  <para>
    ///  Rectangle draw parameter
    ///  </para>
    /// </param>
    /// <param name="ADrawRect">
    ///   绘制矩形
    ///  <para>
    ///  Draw rectangle
    ///  </para>
    /// </param>
    function DrawRect(const ADrawRectParam:TDrawRectParam;
                      const ADrawRect:TRectF):Boolean;virtual;abstract;




    /// <summary>
    ///   <para>
    ///     绘制直线
    ///   </para>
    ///   <para>
    ///     Draw line
    ///   </para>
    /// </summary>
    /// <param name="ADrawLineParam">
    ///   直线绘制参数
    ///  <para>
    ///  Draw parameter of line
    ///  </para>
    /// </param>
    /// <param name="X1">
    ///   坐标
    ///  <para>
    ///   Coordinate
    ///  </para>
    /// </param>
    /// <param name="Y1">
    ///   坐标 <br />
    ///  <para>
    ///  Coordinate
    ///  </para>
    /// </param>
    /// <param name="X2">
    ///   坐标 <br />
    ///  <para>
    ///  Coordinate
    ///  </para>
    /// </param>
    /// <param name="Y2">
    ///   坐标 <br />
    ///  <para>
    ///  Coornadite
    ///  </para>
    /// </param>
    function DrawLine(const ADrawLineParam:TDrawLineParam;
                       X1:Double;
                       Y1:Double;
                       X2:Double;
                       Y2:Double):Boolean;virtual;abstract;
    function DrawRectLine(const ADrawLineParam:TDrawLineParam;
                          const ADrawRect:TRectF;
                          ALinePosition:TDRPLinePosition):Boolean;virtual;

  public


    constructor Create;virtual;
    destructor Destroy;override;


  public

    {$IFDEF VCL}
    //绘制句柄,在绘制到窗体上的时候需要
    property Handle:HDC read FHandle;
    {$ENDIF}


    /// <summary>
    ///   <para>
    ///     画布
    ///   </para>
    ///   <para>
    ///     Canvas
    ///   </para>
    /// </summary>
    property Canvas:TCanvas read GetCanvas;




    //函数//
    //准备DC,一般用于初始绘制引擎
    function Prepare(const Canvas:TCanvas):Boolean;{$IFDEF VCL}overload;{$ENDIF}
    {$IFDEF VCL}
    function Prepare(const DC:HDC):Boolean;overload;
    {$ENDIF}
    //反准备DC,一般用于释放绘制引擎
    function UnPrepare:Boolean;





    /// <summary>
    ///   <para>
    ///     计算文本绘制的宽度
    ///   </para>
    ///   <para>
    ///     Calculate draw width of text
    ///   </para>
    /// </summary>
    function CalcTextDrawWidth(const ADrawTextParam:TDrawTextParam;
                                const AText:String;
                                const ADrawRect:TRectF;
                                var ADrawWidth:TControlSize):Boolean;
    /// <summary>
    ///   <para>
    ///     计算文本绘制的高度
    ///   </para>
    ///   <para>
    ///    Calculate text DrawHeight
    ///   </para>
    /// </summary>
    function CalcTextDrawHeight(const ADrawTextParam:TDrawTextParam;
                                const AText:String;
                                const ADrawRect:TRectF;
                                var ADrawHeight:TControlSize):Boolean;

  end;






  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     画布设置类
  ///   </para>
  ///   <para>
  ///     class of setting canvas
  ///   </para>
  /// </summary>
  TDrawCanvasSetting=class(TComponent)
  private
    function GetIsDrawDesigningRect: Boolean;
    procedure SetIsDrawDesigningRect(const Value: Boolean);
    function GetIsDrawDesigningName: Boolean;
    procedure SetIsDrawDesigningName(const Value: Boolean);
    function GetIsUseDefaultFontFamily: Boolean;
    procedure SetIsUseDefaultFontFamily(const Value: Boolean);
    function GetDefaultFontFamily: TFontName;
    procedure SetDefaultFontFamily(const Value: TFontName);
  published
    /// <summary>
    ///   <para>
    ///     是否使用默认的字体
    ///   </para>
    ///   <para>
    ///     Whether use default font
    ///   </para>
    /// </summary>
    property IsUseDefaultFontFamily:Boolean read GetIsUseDefaultFontFamily write SetIsUseDefaultFontFamily;
    property DefaultFontFamily:TFontName read GetDefaultFontFamily write SetDefaultFontFamily;

    /// <summary>
    ///   <para>
    ///     是否在设计时绘制控件的矩形
    ///   </para>
    ///   <para>
    ///     Whether draw rectangle of control at desigining time
    ///   </para>
    /// </summary>
    property IsDrawDesigningRect:Boolean read GetIsDrawDesigningRect write SetIsDrawDesigningRect;
    /// <summary>
    ///   <para>
    ///     是否在设计时绘制控件的Name
    ///   </para>
    ///   <para>
    ///     Whether draw name of control at designing time
    ///   </para>
    /// </summary>
    property IsDrawDesigningName:Boolean read GetIsDrawDesigningName write SetIsDrawDesigningName;

  end;










{$IFDEF VCL}
var
  //VCL程序里用做绘制界面时要用到的临时变量
  GlobalClientRect:TRectF;
  GlobalClientPRect:PRectF;
  GlobalWindowRect:TRectF;
  GlobalWindowPRect:PRectF;
{$ENDIF}




var
  /// <summary>
  ///   <para>
  ///     是否在设计时绘制控件的矩形边框
  ///   </para>
  ///   <para>
  ///     Whether draw control's rectangle at designing time
  ///   </para>
  /// </summary>
  GlobalIsDrawDesigningRect:Boolean;
  /// <summary>
  ///   <para>
  ///     是否在设计时绘制控件的Name
  ///   </para>
  ///   <para>
  ///     Whether draw control's name at designing time
  ///   </para>
  /// </summary>
  GlobalIsDrawDesigningName:Boolean;

//  GlobalCanvasNameList:TList;



//计算图片绘制的矩形
function CalcImageDrawRect(const ADrawPictureParam:TDrawPictureParam;
                            const ADrawPictureWidth:Integer;
                            const ADrawPictureHeight:Integer;
                            ACalcedDrawRect:TRectF;
                            var AImageDrawRect:TRectF
                            ):Boolean;

//计算图片合适的绘制尺寸
function AutoFitPictureDrawRect(const ADrawPictureWidth:Integer;
                                const ADrawPictureHeight:Integer;
                                const AImageDrawMaxWidth:Double;
                                const AImageDrawMaxHeight:Double):TSizeF;

function AutoFillPictureDrawRect(const ADrawPictureWidth:Integer;
                                const ADrawPictureHeight:Integer;
                                const AImageDrawMaxWidth:Double;
                                const AImageDrawMaxHeight:Double):TSizeF;



{$IFDEF FMX}
function GetDrawingShapeRectAndSetThickness(
          const AStrokeThickness:Double;
          ADrawRect:TRectF;
        //  const Fit: Boolean;
          FillShape, DrawShape: Boolean;
          var StrokeThicknessRestoreValue: Single): TRectF;
{$ENDIF FMX}



var
  //缓存位图默认缩放比例
  Const_BufferBitmapScale:Single;


implementation

{$IFDEF FMX}
var
  ScreenSrv: IFMXScreenService;
{$ENDIF}




{$IFDEF FMX}
function GetDrawingShapeRectAndSetThickness(
  const AStrokeThickness:Double;
  ADrawRect:TRectF;
//  const Fit: Boolean;
  FillShape, DrawShape: Boolean;
  var StrokeThicknessRestoreValue: Single): TRectF;
const
  MinRectAreaSize = 0.01;
begin
//  FillShape := (AShape.FFill <> nil) and (AShape.FFill.Kind <> TBrushKind.None);
//  DrawShape := True;//(AStroke <> nil) and (AStroke.Kind <> TBrushKind.None);

//  if Fit then
//    Result := TRectF.Create(0, 0, 1, 1).FitInto(AShape.LocalRect)
//  else
//    Result := AShape.LocalRect;

  Result:=ADrawRect;

  if DrawShape then
  begin
    if Result.Width < AStrokeThickness then
    begin
      StrokeThicknessRestoreValue := AStrokeThickness;
      FillShape := False;
//      AStrokeThickness := Min(Result.Width, Result.Height);
      Result.Left := (Result.Right + Result.Left) * 0.5;
      Result.Right := Result.Left + MinRectAreaSize;
    end
    else
      Result.Inflate(-AStrokeThickness * 0.5, 0);

    if Result.Height < AStrokeThickness then
    begin
      if StrokeThicknessRestoreValue < 0.0 then
        StrokeThicknessRestoreValue := AStrokeThickness;
      FillShape := False;
//      AStrokeThickness := Min(Result.Width, Result.Height);
      Result.Top := (Result.Bottom + Result.Top) * 0.5;
      Result.Bottom := Result.Top + MinRectAreaSize;
    end
    else
      Result.Inflate(0, -AStrokeThickness * 0.5);
  end;
end;
{$ENDIF FMX}



function AutoFitPictureDrawRect(const ADrawPictureWidth:Integer;
                                const ADrawPictureHeight:Integer;
                                const AImageDrawMaxWidth:Double;
                                const AImageDrawMaxHeight:Double):TSizeF;
begin
  Result.cx:=ADrawPictureWidth;
  Result.cy:=ADrawPictureHeight;

  //自适应尺寸绘制图片(在矩形内以合适的尺寸全部显示出来)

  if ADrawPictureWidth/ADrawPictureHeight<=AImageDrawMaxWidth/AImageDrawMaxHeight then
  begin

      if ADrawPictureHeight>AImageDrawMaxHeight then
      begin
        Result.cy:=AImageDrawMaxHeight;
        Result.cx:=ADrawPictureWidth/ADrawPictureHeight*AImageDrawMaxHeight;
      end
      else
      begin
        Result.cy:=ADrawPictureHeight;
        Result.cx:=ADrawPictureWidth;
      end;
  end
  else
  begin
      if ADrawPictureWidth>AImageDrawMaxWidth then
      begin
        Result.cx:=AImageDrawMaxWidth;
        Result.cy:=ADrawPictureHeight/ADrawPictureWidth*AImageDrawMaxWidth;
      end
      else
      begin
        Result.cx:=ADrawPictureWidth;
        Result.cy:=ADrawPictureHeight;
      end;
  end;

end;

function AutoFillPictureDrawRect(const ADrawPictureWidth:Integer;
                                const ADrawPictureHeight:Integer;
                                const AImageDrawMaxWidth:Double;
                                const AImageDrawMaxHeight:Double):TSizeF;
begin
  Result.cx:=ADrawPictureWidth;
  Result.cy:=ADrawPictureHeight;

  if ADrawPictureWidth/ADrawPictureHeight<=AImageDrawMaxWidth/AImageDrawMaxHeight then
  begin
    Result.cx:=AImageDrawMaxWidth;
    Result.cy:=ADrawPictureHeight*AImageDrawMaxWidth/ADrawPictureWidth;
  end
  else
  begin
    Result.cy:=AImageDrawMaxHeight;
    Result.cx:=ADrawPictureWidth*AImageDrawMaxHeight/ADrawPictureHeight;
  end;

end;

function CalcImageDrawRect(const ADrawPictureParam:TDrawPictureParam;
                            const ADrawPictureWidth:Integer;
                            const ADrawPictureHeight:Integer;
                            ACalcedDrawRect:TRectF;
                            var AImageDrawRect:TRectF
                            ):Boolean;
var
  AImageWidth:Double;
  AImageHeight:Double;
  AImageDrawWidth:Double;
  AImageDrawHeight:Double;
  AImageDrawMaxWidth:Double;
  AImageDrawMaxHeight:Double;
begin

  Result:=False;


  AImageWidth:=ADrawPictureWidth;
  AImageHeight:=ADrawPictureHeight;


  if ADrawPictureParam.IsStretch then
  begin

      //如果是缩放,那么使用原矩形
      AImageDrawRect:=ACalcedDrawRect;

      if ADrawPictureParam.IsAutoFit then
      begin
          //自适应缩放,按照比例来
          //计算需要伸缩的长和宽


          //自适应尺寸绘制图片(在矩形内以合适的尺寸全部显示出来)
          AImageDrawMaxWidth:=RectWidthF(ACalcedDrawRect);
          AImageDrawMaxHeight:=RectHeightF(ACalcedDrawRect);
          //64*64   140*117
          if AImageWidth/AImageHeight<=AImageDrawMaxWidth/AImageDrawMaxHeight then
          begin
            AImageDrawHeight:=AImageDrawMaxHeight;
            AImageDrawWidth:=AImageWidth*AImageDrawMaxHeight/AImageHeight;
          end
          else
          begin
            AImageDrawWidth:=AImageDrawMaxWidth;
            AImageDrawHeight:=AImageHeight*AImageDrawMaxWidth/AImageWidth;
          end;


          //缩放
          AImageDrawWidth:=AImageDrawWidth*ADrawPictureParam.Scale;
          AImageDrawHeight:=AImageDrawHeight*ADrawPictureParam.Scale;





          //水平对齐
          case ADrawPictureParam.PictureHorzAlign of
            phaLeft: AImageDrawRect.Left:=ACalcedDrawRect.Left;
            phaCenter:
            begin
              if (RectWidthF(ACalcedDrawRect)-AImageDrawWidth)>0 then
              begin
                AImageDrawRect.Left:=ACalcedDrawRect.Left+(RectWidthF(ACalcedDrawRect)-AImageDrawWidth) / 2;
              end
              else
              begin
                AImageDrawRect.Left:=ACalcedDrawRect.Left;
              end;
            end;
            phaRight: AImageDrawRect.Left:=ACalcedDrawRect.Right-AImageDrawWidth;
          end;



          //垂直对齐
          case ADrawPictureParam.PictureVertAlign of
            pvaTop: AImageDrawRect.Top:=ACalcedDrawRect.Top;
            pvaCenter:
            begin
              if (RectHeightF(ACalcedDrawRect)-AImageDrawHeight)>0 then
              begin
                AImageDrawRect.Top:=ACalcedDrawRect.Top+(RectHeightF(ACalcedDrawRect)-AImageDrawHeight) / 2;
              end
              else
              begin
                AImageDrawRect.Top:=ACalcedDrawRect.Top;
              end;
            end;
            pvaBottom: AImageDrawRect.Top:=ACalcedDrawRect.Bottom-AImageDrawHeight;
          end;

          AImageDrawRect.Right:=AImageDrawRect.Left+AImageDrawWidth;
          AImageDrawRect.Bottom:=AImageDrawRect.Top+AImageDrawHeight;

      end
      else
      begin
        AImageDrawRect.Right:=AImageDrawRect.Left+AImageDrawRect.Width*ADrawPictureParam.Scale;
        AImageDrawRect.Bottom:=AImageDrawRect.Top+AImageDrawRect.Height*ADrawPictureParam.Scale;
      end;

  end
  else
  begin


      if ADrawPictureParam.IsAutoFit then
      begin

          //自适应尺寸绘制图片(在矩形内以合适的尺寸全部显示出来)
          AImageDrawMaxWidth:=RectWidthF(ACalcedDrawRect);
          AImageDrawMaxHeight:=RectHeightF(ACalcedDrawRect);

          if (AImageWidth<=AImageDrawMaxWidth) and (AImageHeight<=AImageDrawMaxHeight) then
          begin
              //图片显示的下
              AImageDrawWidth:=AImageWidth;
              AImageDrawHeight:=AImageHeight;
          end
          else if AImageWidth/AImageHeight<=AImageDrawMaxWidth/AImageDrawMaxHeight then
          begin
              //图片显示不下
              AImageDrawHeight:=AImageDrawMaxHeight;
              if AImageHeight>AImageDrawMaxHeight then
              begin
                AImageDrawWidth:=AImageWidth*AImageDrawMaxHeight/AImageHeight;
              end
              else
              begin
                AImageDrawWidth:=AImageWidth*AImageHeight/AImageDrawMaxHeight;
              end;
              //加了Ceil,避免宽度有小数点,而在Windows上绘制不足
              //wn
  //            AImageDrawWidth:=Ceil(AImageDrawWidth);
          end
          else
          begin
              //图片显示不下
              AImageDrawWidth:=AImageDrawMaxWidth;
              if AImageWidth>AImageDrawMaxWidth then
              begin
                AImageDrawHeight:=AImageHeight*AImageDrawMaxWidth/AImageWidth;
              end
              else
              begin
                AImageDrawHeight:=AImageHeight*AImageWidth/AImageDrawMaxWidth;
              end;
          end;

      end
      else
      begin

          AImageDrawWidth:=AImageWidth;
          AImageDrawHeight:=AImageHeight;

      end;


      //缩放
      AImageDrawWidth:=AImageDrawWidth*ADrawPictureParam.Scale;
      AImageDrawHeight:=AImageDrawHeight*ADrawPictureParam.Scale;



      //水平对齐
      case ADrawPictureParam.PictureHorzAlign of
        phaLeft: AImageDrawRect.Left:=ACalcedDrawRect.Left;
        phaCenter:
        begin
          if (RectWidthF(ACalcedDrawRect)-AImageDrawWidth)>0 then
          begin
            AImageDrawRect.Left:=ACalcedDrawRect.Left+(RectWidthF(ACalcedDrawRect)-AImageDrawWidth) / 2;
          end
          else
          begin
            AImageDrawRect.Left:=ACalcedDrawRect.Left;
          end;
        end;
        phaRight: AImageDrawRect.Left:=ACalcedDrawRect.Right-AImageDrawWidth;
      end;



      //垂直对齐
      case ADrawPictureParam.PictureVertAlign of
        pvaTop: AImageDrawRect.Top:=ACalcedDrawRect.Top;
        pvaCenter:
        begin
          if (RectHeightF(ACalcedDrawRect)-AImageDrawHeight)>0 then
          begin
            AImageDrawRect.Top:=ACalcedDrawRect.Top+(RectHeightF(ACalcedDrawRect)-AImageDrawHeight) / 2;
          end
          else
          begin
            AImageDrawRect.Top:=ACalcedDrawRect.Top;
          end;
        end;
        pvaBottom: AImageDrawRect.Top:=ACalcedDrawRect.Bottom-AImageDrawHeight;
      end;


      AImageDrawRect.Right:=AImageDrawRect.Left+AImageDrawWidth;
      AImageDrawRect.Bottom:=AImageDrawRect.Top+AImageDrawHeight;

  end;


  Result:=True;
end;




{ TDrawCanvas }

function TDrawCanvas.CalcTextDrawHeight(const ADrawTextParam: TDrawTextParam;
                                      const AText: String;
                                      const ADrawRect:TRectF;
                                      var ADrawHeight: TControlSize): Boolean;
var
  ADrawWidth:TControlSize;
begin
  Result:=Self.CalcTextDrawSize(ADrawTextParam,AText,ADrawRect,ADrawWidth,ADrawHeight,cdstHeight);
end;

function TDrawCanvas.CalcTextDrawWidth(const ADrawTextParam: TDrawTextParam;
                                        const AText: String;
                                        const ADrawRect:TRectF;
                                        var ADrawWidth: TControlSize): Boolean;
var
  ADrawHeight:TControlSize;
begin
  Result:=Self.CalcTextDrawSize(ADrawTextParam,AText,ADrawRect,ADrawWidth,ADrawHeight,cdstWidth);
end;

constructor TDrawCanvas.Create;
begin
  FCanvasIsOwn:=False;

//  GlobalCanvasNameList.Add(Self);
end;

destructor TDrawCanvas.Destroy;
begin
  UnPrepare;

//  if GlobalCanvasNameList<>nil then
//  begin
//    GlobalCanvasNameList.Remove(Self);
//  end;

  inherited;
end;

{$IFDEF VCL}
function TDrawCanvas.Prepare(const DC:HDC): Boolean;
begin
  FHandle:=DC;
  CustomPrepare;
  Result:=True;
end;
{$ENDIF}

function TDrawCanvas.UnPrepare: Boolean;
begin



  {$IFDEF VCL}
  FHandle:=0;
  if FCanvasIsOwn and (FCanvas<>nil) then
  begin
    FCanvasIsOwn:=False;
    FCanvas.Handle:=0;
    SysUtils.FreeAndNil(FCanvas);
  end;
  {$ELSE}
  FCanvas:=nil;
  {$ENDIF}


  CustomUnPrepare;

  Result:=True;
end;

//procedure TDrawCanvas.SetClip(const AClipRect:TRectF);
//begin
//  uBaseLog.ShowException('Have Not Implement TDrawCanvas.SetClip');
//end;

//procedure TDrawCanvas.ResetClip;
//begin
//  uBaseLog.ShowException('Have Not Implement TDrawCanvas.ResetClip');
//end;

//function TDrawCanvas.CalcTextDrawSize(const ADrawTextParam:TDrawTextParam;
//                                      const AText:String;
//                                      const ADrawRect:TRectF;
//                                      var ADrawWidth:TControlSize;
//                                      var ADrawHeight:TControlSize;
//                                      const ACalcDrawSizeType:TCalcDrawSizeType):Boolean;
//begin
//  uBaseLog.ShowException('Have Not Implement TDrawCanvas.CalcTextDrawSize');
//end;

//function TDrawCanvas.DrawText(const ADrawTextParam:TDrawTextParam;
//                              const AText:String;
//                              const ADrawRect:TRectF;
//                              const AColorTextList:IColorTextList=nil):Boolean;
//begin
//  uBaseLog.ShowException('Have Not Implement TDrawCanvas.DrawText');
//end;

procedure TDrawCanvas.EndDraw;
begin

end;

function TDrawCanvas.FillPathData(ADrawPathParam:TDrawPathParam;ADrawPathData: TBaseDrawPathData): Boolean;
begin
  Result:=True;
end;

function TDrawCanvas.GetCanvas: TCanvas;
begin
  {$IFDEF VCL}
  if (FCanvas=nil) and (FHandle<>0) then
  begin
    FCanvas:=TCanvas.Create;
    FCanvas.Handle:=FHandle;
    FCanvasIsOwn:=True;
  end;
  {$ENDIF}
  Result:=FCanvas;
end;

function TDrawCanvas.Prepare(const Canvas: TCanvas): Boolean;
begin
  {$IFDEF VCL}
  FHandle:=Canvas.Handle;
  {$ENDIF}
  FCanvas:=Canvas;

  CustomPrepare;
  Result:=True;
end;

function TDrawCanvas.CalcTextDrawRect(const ADrawTextParam:TDrawTextParam;
                                      const AText:String;
                                      const ADrawRect:TRectF;
                                      var ATextDrawRect:TRectF):Boolean;
var
  ATextDrawWidth:TControlSize;
  ATextDrawHeight:TControlSize;
begin

  Result:=False;



  //计算需要绘制的长和宽
  Self.CalcTextDrawSize(ADrawTextParam,AText,ADrawRect,ATextDrawWidth,ATextDrawHeight,cdstBoth);



  case ADrawTextParam.FontHorzAlign of
    fhaLeft: ATextDrawRect.Left:=ADrawRect.Left;
    fhaCenter: ATextDrawRect.Left:=ADrawRect.Left+(RectWidthF(ADrawRect)-ATextDrawWidth) / 2;
    fhaRight: ATextDrawRect.Left:=ADrawRect.Right-ATextDrawWidth;
  end;

  case ADrawTextParam.FontVertAlign of
    fvaTop: ATextDrawRect.Top:=ADrawRect.Top;
    fvaCenter: ATextDrawRect.Top:=ADrawRect.Top+(RectHeightF(ADrawRect)-ATextDrawHeight) / 2;
    fvaBottom: ATextDrawRect.Top:=ADrawRect.Bottom-ATextDrawHeight;
  end;


  ATextDrawRect.Right:=ATextDrawRect.Left+ATextDrawWidth;
  ATextDrawRect.Bottom:=ATextDrawRect.Top+ATextDrawHeight;



  Result:=True;
end;

function TDrawCanvas.BeginDraw: Boolean;
begin
  Result:=True;
end;


function TDrawCanvas.DrawPath(ADrawPathParam: TDrawPathParam;const ADrawRect: TRectF;APathActions:TPathActionCollection): Boolean;
begin
  Result:=True;
end;

function TDrawCanvas.DrawPathData(ADrawPathData: TBaseDrawPathData):Boolean;
begin
  Result:=True;
end;

function TDrawCanvas.DrawPicture(const ADrawPictureParam:TDrawPictureParam;
                                 const ADrawPicture:TBaseDrawPicture;
                                 const ADrawRect:TRectF
                                  ):Boolean;
var
  AClacDrawRect:TRectF;
  AImageSrcRect:TRectF;
  AImageDestDrawRect:TRectF;
begin
  Result:=True;

  if ADrawPicture=nil then Exit;
  

  if (RectWidthF(ADrawRect)<=0) or (RectHeightF(ADrawRect)<=0) then Exit;

  AClacDrawRect:=ADrawPictureParam.CalcDrawRect(ADrawRect);

  ADrawPicture.CurrentEffectImageIndex:=ADrawPictureParam.CurrentEffectImageIndex(ADrawPicture.ImageIndex);
  ADrawPicture.CurrentEffectImageName:=ADrawPictureParam.CurrentEffectImageName;

  if ADrawPicture.CurrentPictureIsEmpty then Exit;


  //计算最终绘制的矩形
  CalcImageDrawRect(ADrawPictureParam,
                        ADrawPicture.CurrentPictureDrawWidth,
                        ADrawPicture.CurrentPictureDrawHeight,
                        AClacDrawRect,
                        AImageDestDrawRect
                        );


  AImageSrcRect:=RectF(0,0,ADrawPicture.CurrentPictureWidth,ADrawPicture.CurrentPictureHeight);


    {$IFDEF VCL}
  if (ADrawPicture.RowCount>=1)
  and (ADrawPicture.ColCount>1)
  and (ADrawPicture.RowIndex>-1) and (ADrawPicture.RowIndex<ADrawPicture.RowCount)
  and (ADrawPicture.ColIndex>-1) and (ADrawPicture.ColIndex<ADrawPicture.ColCount) then
  begin
    AImageSrcRect.Left:=ADrawPicture.CurrentPictureDrawLeft;
    AImageSrcRect.Top:=ADrawPicture.CurrentPictureDrawTop;
    AImageSrcRect.Right:=AImageSrcRect.Left+ADrawPicture.CurrentPictureDrawWidth;
    AImageSrcRect.Bottom:=AImageSrcRect.Top+ADrawPicture.CurrentPictureDrawHeight;
  end;
    {$ENDIF}


  DrawSkinPicture(ADrawPictureParam,
                  ADrawPicture.CurrentPicture,
                  ADrawRect,
                  True,
                  AImageSrcRect,
                  AImageDestDrawRect);

end;

//function TDrawCanvas.DrawSkinPicture(const ADrawPictureParam:TDrawPictureParam;
//                                      const ASkinPicture:TSkinPicture;
//                                      const ADrawRect:TRectF;
//                                      const AIsUseSrcRectAndDestDrawRect:Boolean;
//                                      const AImageSrcRect:TRectF;
//                                      const AImageDestDrawRect:TRectF
//                                      ):Boolean;
//begin
//  uBaseLog.ShowException('Have Not Implement TDrawCanvas.DrawSkinPicture');
//end;

//function TDrawCanvas.DrawRect(const ADrawRectParam:TDrawRectParam;
//                              const ADrawRect:TRectF):Boolean;
//begin
//  uBaseLog.ShowException('Have Not Implement TDrawCanvas.DrawRect');
//end;

//function TDrawCanvas.DrawDesigningRect(const ADrawRect: TRectF;
//                                        const ABorderColor:TDelphiColor): Boolean;
//begin
//  uBaseLog.ShowException('Have Not Implement TDrawCanvas.DrawDesigningRect');
//end;
//
//function TDrawCanvas.DrawDesigningText(const ADrawRect: TRectF;const AText: String): Boolean;
//begin
//  uBaseLog.ShowException('Have Not Implement TDrawCanvas.DrawDesigningText');
//end;

function TDrawCanvas.DrawRectLine(const ADrawLineParam:TDrawLineParam;
                      const ADrawRect:TRectF;
                      ALinePosition:TDRPLinePosition
                      ):Boolean;
var
  BDrawRect:TRectF;
var
  APt1, APt2: TPointF;
begin

  //根据DrawRectSetting返回需要绘制的实际矩形
  BDrawRect:=ADrawLineParam.CalcDrawRect(ADrawRect);

  //修复位置，补0.5
  case ALinePosition of
    lpLeft:
    begin
      APt1:=PointF(AdjustDrawLinePos(BDrawRect.Left),BDrawRect.Top);
      APt2:=PointF(AdjustDrawLinePos(BDrawRect.Left),BDrawRect.Bottom);
    end;
    lpTop:
    begin
      APt1:=PointF(BDrawRect.Left,AdjustDrawLinePos(BDrawRect.Top));
      APt2:=PointF(BDrawRect.Right,AdjustDrawLinePos(BDrawRect.Top));
    end;
    lpRight:
    begin
      APt1:=PointF(AdjustDrawLinePos(BDrawRect.Right,-Const_DrawLineOffset),BDrawRect.Top);
      APt2:=PointF(AdjustDrawLinePos(BDrawRect.Right,-Const_DrawLineOffset),BDrawRect.Bottom);
    end;
    lpBottom:
    begin
      APt1:=PointF(BDrawRect.Left,AdjustDrawLinePos(BDrawRect.Bottom,-Const_DrawLineOffset));
      APt2:=PointF(BDrawRect.Right,AdjustDrawLinePos(BDrawRect.Bottom,-Const_DrawLineOffset));
    end;
  end;


  Self.DrawLine(ADrawLineParam,APt1.X,APt1.Y,APt2.X,APt2.Y);

end;

//function TDrawCanvas.DrawLine(const ADrawLineParam:TDrawLineParam;
//                              const X1:Double;
//                              const Y1:Double;
//                              const X2:Double;
//                              const Y2:Double):Boolean;
//begin
//  uBaseLog.ShowException('Have Not Implement TDrawCanvas.DrawLine');
//end;
//
//function TDrawCanvas.CustomPrepare: Boolean;
//begin
//  uBaseLog.ShowException('Have Not Implement TDrawCanvas.CustomPrepare');
//end;
//
//function TDrawCanvas.CustomUnPrepare: Boolean;
//begin
//  uBaseLog.ShowException('Have Not Implement TDrawCanvas.CustomUnPrepare');
//end;







{ TDrawCanvasSetting }


function TDrawCanvasSetting.GetIsDrawDesigningRect: Boolean;
begin
  Result:=GlobalIsDrawDesigningRect;
end;

function TDrawCanvasSetting.GetDefaultFontFamily: TFontName;
begin
  Result:=GlobalDefaultFontFamily;
end;

function TDrawCanvasSetting.GetIsDrawDesigningName: Boolean;
begin
  Result:=GlobalIsDrawDesigningName;
end;

function TDrawCanvasSetting.GetIsUseDefaultFontFamily: Boolean;
begin
  Result:=GlobalIsUseDefaultFontFamily;
end;

procedure TDrawCanvasSetting.SetIsDrawDesigningRect(const Value: Boolean);
begin
  GlobalIsDrawDesigningRect:=Value;
end;

procedure TDrawCanvasSetting.SetDefaultFontFamily(const Value: TFontName);
begin
  GlobalDefaultFontFamily:=Value;
end;

procedure TDrawCanvasSetting.SetIsDrawDesigningName(const Value: Boolean);
begin
  GlobalIsDrawDesigningName:=Value;
end;

procedure TDrawCanvasSetting.SetIsUseDefaultFontFamily(const Value: Boolean);
begin
  GlobalIsUseDefaultFontFamily:=Value;
end;







initialization
  GlobalIsDrawDesigningRect:=True;
  GlobalIsDrawDesigningName:=False;
{$IFDEF VCL}
  GlobalClientRect:=RectF(0,0,0,0);
  GlobalClientPRect:=@GlobalClientRect;
  GlobalWindowRect:=RectF(0,0,0,0);
  GlobalWindowPRect:=@GlobalWindowRect;
{$ENDIF}



  //获取缩放比
  {$IFDEF FMX}
    Const_BufferBitmapScale:=1;
    if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, ScreenSrv) then
    begin
      Const_BufferBitmapScale := ScreenSrv.GetScreenScale;
      OutputDebugString('IFMXScreenService Get Scale:'+FloatToStr(Const_BufferBitmapScale));
    end
    else
    begin
      OutputDebugString('IFMXScreenService Get Error');
    end;
  {$ENDIF}
  {$IFDEF VCL}
    Const_BufferBitmapScale:=GetScreenScaleRate;
    OutputDebugString('Const_BufferBitmapScale:'+FloatToStr(Const_BufferBitmapScale));
  {$ENDIF}


//  GlobalCanvasNameList:=TList.Create;

finalization
//  FreeAndNil(GlobalCanvasNameList);


end.



