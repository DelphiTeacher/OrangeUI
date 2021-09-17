//convert pas to utf8 by ¥

//
/// <summary>
///   <para>
///     图片基类
///   </para>
///   <para>
///     Base class of pictures
///   </para>
/// </summary>
unit uSkinPicture;

interface
{$I FrameWork.inc}



uses
  Classes,
  SysUtils,
  Math,


  {$IFDEF VCL}
  Types,
  Graphics,
  Dialogs,
//  uGraphicCommon,
  {$ENDIF}
  {$IFDEF FMX}
  Types,
  UITypes,
  FMX.Types,
  FMX.Graphics,
  uSkinGIFImage,
  FMX.Surfaces,
  {$ENDIF}

  {$IFDEF ANDROID}
  Androidapi.JNI.GraphicsContentViewText,
  FMX.Graphics.Android,
  FMX.Helpers.Android,
  {$ENDIF}

  uBitmapOperation,
  uBaseList,
  uBaseLog,
  uFuncCommon,
  uGraphicCommon,
  uDrawPictureParam,
  uBinaryTreeDoc;




type
  TSkinPicture=class;
  TSkinPictureEngine=class;





  /// <summary>
  ///   <para>
  ///     图片引擎
  ///   </para>
  ///   <para>
  ///     Picture engine
  ///   </para>
  /// </summary>
  TSkinPictureEngine=class
  protected
    FSkinPicture:TSkinPicture;
    function GetCurrentIsGIF: Boolean;virtual;
  public
    procedure Clear;virtual;
    constructor Create(ASkinPicture:TSkinPicture);virtual;
    destructor Destroy;override;
  public
    //是否是GIF图片
    property CurrentIsGIF:Boolean read GetCurrentIsGIF;
    //图片
    property SkinPicture:TSkinPicture read FSkinPicture;
  end;









  /// <summary>
  ///   <para>
  ///     GIF图片引擎基类
  ///   </para>
  ///   <para>
  ///     Base class of GIF picture engine
  ///   </para>
  /// </summary>
  TSkinBaseGIFPictureEngine=class(TSkinPictureEngine)
  protected
    FAnimated:Boolean;
    FAnimateSpeed:Double;
    FGIFDelayExp: Integer;
    procedure SetGIFDelayExp(const Value: Integer);
    function GetCurrentIsGIF: Boolean;override;
    procedure SetAnimated(Value:Boolean);
    procedure SetAnimateSpeed(const Value: Double);
    procedure AnimateSpeedChanged(const Value: Double);virtual;
    procedure Clear;override;
    //是否启动了动画
    function IsStarted:Boolean;virtual;
    //当前帧
    function CurrentAnimateFrame:TSkinPicture;virtual;
    procedure DoAnimateRePaint(Sender:TObject);virtual;
  public
    constructor Create(ASkinPicture:TSkinPicture);override;
  public
    procedure StartAnimate;virtual;
    procedure StopAnimate;virtual;
    procedure DrawToCanvas(Canvas:TObject;
                            ADrawPictureParam:TDrawPictureParam;
                            ADrawRect:TRectF);virtual;
  public
    //动画延迟间隔
    property GIFDelayExp:Integer read FGIFDelayExp write SetGIFDelayExp;

    //动画
    property Animated:Boolean read FAnimated write SetAnimated;
    //动画速度
    property AnimateSpeed:Double read FAnimateSpeed write SetAnimateSpeed;
  end;

















  TPlatformPicture={$IFDEF VCL}TPicture{$ENDIF}{$IFDEF FMX}TBitmap{$ENDIF};

  /// <summary>
  ///   <para>
  ///     直接从图片继承，双击可以修改
  ///   </para>
  ///   <para>
  ///     Inherit from picture directly,you can alter it by double click
  ///   </para>
  /// </summary>
  TSkinPicture=class(TPlatformPicture,ISupportClassDocNode)
  protected
    //名字
    FImageName:String;
    //附加数据
    FData:Pointer;



    FGIFStream:TMemoryStream;
    FGIFSupport:Boolean;
    FOnAnimateRePaint: TNotifyEvent;

    FIsDoChangeing:Boolean;

    //更改的事件
    FOnChange: TNotifyEvent;



    //是否剪载成圆形
    FIsClipRound:Boolean;
    FClipRoundXRadis:Double;
    FClipRoundYRadis:Double;
    {$IFDEF FMX}
    FClipRoundCorners: TCorners;
    {$ENDIF FMX}


    FSkinThemeColorPicture:TSkinPicture;
    //
    FSkinThemeColor:TDelphiColor;
    FSkinThemeColorChange:Boolean;


    FSkinPictureEngine:TSkinPictureEngine;
    procedure LoadGIFFromStream(Stream: TStream);
  protected
    FIsNoDoPictureChanged:Boolean;
    function GetSkinPictureEngine: TSkinPictureEngine;
    procedure SetGIFSupport(const Value: Boolean);

    {$IFDEF FMX}
    //从TBitmap继续下来的
    procedure BitmapChanged; override;
    {$ENDIF FMX}

    procedure DoPictureChanged;virtual;


    procedure DoClipRound;
  private
    procedure SetIsClipRound(const Value: Boolean);
    procedure SetSkinThemeColorChange(const Value: Boolean);
  private
    {$IFDEF VCL}
    procedure Changed(Sender: TObject); override;
    {$ENDIF}
  protected
    //GIF不断重绘事件
    procedure DoAnimateRePaint(Sender:TObject);
  protected
//    procedure ReadData(Stream: TStream);
//    procedure WriteData(Stream: TStream);
    procedure DefineProperties(Filer: TFiler);override;
    //从DFM中读写属性数据
    procedure ReadGIFData(Stream: TStream);
    procedure WriteGIFData(Stream: TStream);
  public
    {$IFDEF VCL}
    //是否为空
    function IsEmpty:Boolean;
    procedure SetSize(const AWidth:Integer;const AHeight:Integer);
    {$ENDIF}
  public
    constructor Create;virtual;
    destructor Destroy;override;
  public
    //是否更改过了
    IsChanged:Boolean;

    /// <summary>
    ///   <para>
    ///     执行更改事件
    ///   </para>
    ///   <para>
    ///     Execute change event
    ///   </para>
    /// </summary>
    procedure DoChange;
    procedure Clear;overload;virtual;

    /// <summary>
    ///   <para>
    ///     复制
    ///   </para>
    ///   <para>
    ///     Copy
    ///   </para>
    /// </summary>
    procedure Assign(Source: TPersistent);override;
    /// <summary>
    ///   <para>
    ///     从文件加载
    ///   </para>
    ///   <para>
    ///     Load from file
    ///   </para>
    /// </summary>
    procedure LoadFromFile(const FileName: String);
    /// <summary>
    ///   <para>
    ///     直接从文件加载(不判断是否是GIF图片)
    ///   </para>
    ///   <para>
    ///     Load from file directly(not judge whether is GIF picture)
    ///   </para>
    /// </summary>
    procedure DirectLoadFromFile(const FileName: String);
    /// <summary>
    ///   <para>
    ///     从资源名加载
    ///   </para>
    ///   <para>
    ///     Load from resource name
    ///   </para>
    /// </summary>
    procedure LoadFromResource(const ResourceName: String);
    /// <summary>
    ///   <para>
    ///     从流中加载
    ///   </para>
    ///   <para>
    ///     Load from stream
    ///   </para>
    /// </summary>
    procedure LoadFromStream(Stream: TStream);
    /// <summary>
    ///   <para>
    ///     直接从流中加载(不判断是否是GIF图片)
    ///   </para>
    ///   <para>
    ///     Load from stream directly(not judge whether is GIF picture)
    ///   </para>
    /// </summary>
    procedure DirectLoadFromStream(Stream: TStream);
  public
    function CurrentPicture:TSkinPicture;virtual;

    /// <summary>
    ///   <para>
    ///     附加数据
    ///   </para>
    ///   <para>
    ///     Additional data
    ///   </para>
    /// </summary>
    property Data:Pointer read FData write FData;
  public

    /// <summary>
    ///   <para>
    ///     GIF图片的数据
    ///   </para>
    ///   <para>
    ///     GIF file picture
    ///   </para>
    /// </summary>
    property GIFStream:TMemoryStream read FGIFStream;

    /// <summary>
    ///   <para>
    ///     是否有GIF图片的数据
    ///   </para>
    ///   <para>
    ///     Whether have GIF file
    ///   </para>
    /// </summary>
    function HasGIFStream:Boolean;
  public

    /// <summary>
    ///   <para>
    ///     当前是否是GIF图片
    ///   </para>
    ///   <para>
    ///     Whether curent picture is GIF picture
    ///   </para>
    /// </summary>
    function GetCurrentIsGIF:Boolean;virtual;

    /// <summary>
    ///   <para>
    ///     获取当前的GIF数据
    ///   </para>
    ///   <para>
    ///     Current GIF file stream
    ///   </para>
    /// </summary>
    function GetCurrentGIFStream:TMemoryStream;virtual;

    /// <summary>
    ///   <para>
    ///     图片引擎
    ///   </para>
    ///   <para>
    ///     Picture engine
    ///   </para>
    /// </summary>
    property GIFSupport:Boolean read FGIFSupport write SetGIFSupport;

    /// <summary>
    ///   <para>
    ///     重新绘制事件
    ///   </para>
    ///   <para>
    ///     Redraw event
    ///   </para>
    /// </summary>
    property OnAnimateRePaint: TNotifyEvent read FOnAnimateRePaint write FOnAnimateRePaint;



  public

    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;virtual;

    /// <summary>
    ///   <para>
    ///     保存到文档节点
    ///   </para>
    ///   <para>
    ///     Save to document node
    ///   </para>
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;virtual;
    /// <summary>
    ///   <para>
    ///     更改的事件
    ///   </para>
    ///   <para>
    ///     Changed event
    ///   </para>
    /// </summary>
    property OnChange:TNotifyEvent read FOnChange write FOnChange;
  public
    //是否剪裁成圆形
    property IsClipRound:Boolean read FIsClipRound write SetIsClipRound;
    property ClipRoundXRadis:Double read FClipRoundXRadis write FClipRoundXRadis;
    property ClipRoundYRadis:Double read FClipRoundYRadis write FClipRoundYRadis;
    {$IFDEF FMX}
    property ClipRoundCorners: TCorners read FClipRoundCorners write FClipRoundCorners;
    {$ENDIF FMX}



    /// <summary>
    ///   <para>
    ///     图片引擎
    ///   </para>
    ///   <para>
    ///     Picture engine
    ///   </para>
    /// </summary>
    property SkinPictureEngine:TSkinPictureEngine read GetSkinPictureEngine;

    /// <summary>
    ///   <para>
    ///     名称
    ///   </para>
    ///   <para>
    ///     Name
    ///   </para>
    /// </summary>
    property ImageName:String read FImageName write FImageName;


    property SkinThemeColor:TDelphiColor read FSkinThemeColor write FSkinThemeColor;
    //是否跟随主题色更改颜色
    property SkinThemeColorChange:Boolean read FSkinThemeColorChange write SetSkinThemeColorChange;
  end;





var
  GlobalChangedColorBySkinThemePictureList:TBaseList;



{$IFDEF VCL}
function GetGraphicClassByGraphicType(const AGraphicType:String):TGraphicClass;
function GetGraphicTypeByGraphicClass(const AGraphicClass:TGraphicClass):String;
{$ENDIF}

{$IFDEF FMX}
//将位图剪裁成圆形
function RoundSkinPicture(ABitmap:TBitmap;
                          AXRadius:Double=-1;
                          AYRadius:Double=-1;
                          ACorners: TCorners=[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight];
                          const AQuality: TCanvasQuality = TCanvasQuality.SystemDefault):TSkinPicture;
{$ENDIF FMX}


{$IFDEF ANDROID}
function AndroidRoundBitmap(ASourceBitmap:TBitmap;
                          AXRadius:Double=-1;
                          AYRadius:Double=-1):TSkinPicture;
{$ENDIF}


procedure ChangeSkinPictureListColor(ASkinPictureList:TBaseList;
//                                      AOldSkinThemeColor:TDelphiColor;
                                      ANewSkinThemeColor:TDelphiColor);



implementation




uses
  {$IFDEF VCL}
  //新版本
//  Vcl.Imaging.jpeg,
//  Vcl.Imaging.pngimage,
//  Vcl.Imaging.GIFImg,

  //老版本
  Jpeg,
  GIFImg,
  PngImage,
  uGDIPlusDrawCanvas,

  {$ENDIF}

  uDrawCanvas,
  uDrawEngine;




procedure ChangeSkinPictureColor(ASkinPicture:TSkinPicture;AOldSkinThemeColor:TDelphiColor;ANewSkinThemeColor:TDelphiColor);
begin
  if ASkinPicture.FSkinThemeColor<>ANewSkinThemeColor then
  begin
    ASkinPicture.FSkinThemeColor:=ANewSkinThemeColor;


    FreeAndNil(ASkinPicture.FSkinThemeColorPicture);
    ASkinPicture.FSkinThemeColorPicture:=TSkinPicture.Create;
    ASkinPicture.FSkinThemeColorPicture.Assign(ASkinPicture);

    {$IFDEF FMX}
    RGBChange(ASkinPicture.FSkinThemeColorPicture,
              (TAlphaColorRec(ANewSkinThemeColor).R-TAlphaColorRec(AOldSkinThemeColor).R),
              (TAlphaColorRec(ANewSkinThemeColor).G-TAlphaColorRec(AOldSkinThemeColor).G),
              (TAlphaColorRec(ANewSkinThemeColor).B-TAlphaColorRec(AOldSkinThemeColor).B)
              );
    {$ENDIF}
    ASkinPicture.DoChange;
  end;
end;

procedure ChangeSkinPictureListColor(ASkinPictureList:TBaseList;
//                                      AOldSkinThemeColor:TDelphiColor;
                                      ANewSkinThemeColor:TDelphiColor);
var
  I: Integer;
begin

  for I := 0 to ASkinPictureList.Count-1 do
  begin
    ChangeSkinPictureColor(TSkinPicture(ASkinPictureList[I]),TSkinPicture(ASkinPictureList[I]).FSkinThemeColor,ANewSkinThemeColor);
  end;

end;


{$IFDEF ANDROID}
function AndroidRoundBitmap(ASourceBitmap:TBitmap;
                          AXRadius:Double=-1;
                          AYRadius:Double=-1):TSkinPicture;
var
  ASourceSurface: TBitmapSurface;
  ADestSurface: TBitmapSurface;

  ASourceJBitmap: JBitmap;
  ADestJBitmap:JBitmap;

  AJCanvas:JCanvas;
  AJPaint:JPaint;
  AJBitmapShader:JBitmapShader;
  AJRectF:JRectF;
begin
  Result:=nil;



  //-1表示剪裁成圆形
  if IsSameDouble(AXRadius,-1) then
  begin
    AXRadius := ASourceBitmap.Width / 2;
  end
  else if (AXRadius<1) then
  begin
    //小数,表示百分比
    AXRadius := ASourceBitmap.Width * AXRadius;
  end;

  if IsSameDouble(AYRadius,-1) then
  begin
    AYRadius := ASourceBitmap.Height / 2;
  end
  else if (AYRadius<1) then
  begin
    //小数,表示百分比
    AYRadius := ASourceBitmap.Height * AYRadius;
  end;



  FMX.Types.Log.d('OrangeUI AndroidRoundBitmap Begin');



  AJPaint := TJPaint.Create;
  ASourceSurface := TBitmapSurface.Create;
  ADestSurface := TBitmapSurface.Create;
  ASourceJBitmap := TJBitmap.JavaClass.createBitmap(ASourceBitmap.Width, ASourceBitmap.Height, TJBitmap_Config.JavaClass.ARGB_8888);
  ADestJBitmap := TJBitmap.JavaClass.createBitmap(ASourceBitmap.Width, ASourceBitmap.Height, TJBitmap_Config.JavaClass.ARGB_8888);
  Result:=TSkinPicture.Create;
  Result.SetSize(ASourceBitmap.Width,ASourceBitmap.Height);
  try
    ASourceSurface.Assign(ASourceBitmap);

    if not SurfaceToJBitmap(ASourceSurface, ASourceJBitmap) then
    begin
      Exit;
    end;


    //Canvas canvas = new Canvas(result);
    AJCanvas:=TJCanvas.JavaClass.init(ADestJBitmap);
    //Paint paint = new Paint();
    AJBitmapShader:=TJBitmapShader.JavaClass.init(ASourceJBitmap,
                                                  TJShader_TileMode.JavaClass.CLAMP,
                                                  TJShader_TileMode.JavaClass.CLAMP);
    //paint.setShader(new BitmapShader(source, BitmapShader.TileMode.CLAMP, BitmapShader.TileMode.CLAMP));
    AJPaint.setShader(AJBitmapShader);
    //paint.setAntiAlias(true);
    AJPaint.setAntiAlias(True);
    //RectF AJRectF = new RectF(0f, 0f, source.getWidth(), source.getHeight());
    AJRectF:=TJRectF.JavaClass.init(0,0,ASourceBitmap.Width,ASourceBitmap.Height);
    //canvas.drawRoundRect(AJRectF, radius, radius, paint);
    AJCanvas.drawRoundRect(AJRectF,AXRadius,AYRadius,AJPaint);



    //再将ADestJBitmap保存成TBitmap
    if not JBitmapToSurface(ADestJBitmap,ADestSurface) then
    begin
      Exit;
    end;

    Result.Assign(ADestSurface);

  finally
    ASourceJBitmap.recycle;
    ADestJBitmap.recycle;;

    FreeAndNil(ASourceSurface);
    FreeAndNil(ADestSurface);

    AJCanvas:=nil;
    AJBitmapShader:=nil;
    AJPaint:=nil;
  end;
  FMX.Types.Log.d('OrangeUI AndroidRoundBitmap End');
end;


{$ENDIF}


{$IFDEF FMX}
function RoundSkinPicture(ABitmap:TBitmap;
                          AXRadius:Double;
                          AYRadius:Double;
                          ACorners: TCorners;
                          const AQuality: TCanvasQuality):TSkinPicture;
var
  ABrush:TBrush;
  ResultCanvas:TCanvas;
var
  Radius: Single;
begin
  Result:=nil;









  //-1表示剪裁成圆形
  if IsSameDouble(AXRadius,-1) then
  begin
    AXRadius := ABitmap.Width / 2;
  end
  else if (AXRadius<1) then
  begin
    //小数,表示百分比
    AXRadius := ABitmap.Width * AXRadius;
  end;

  if IsSameDouble(AYRadius,-1) then
  begin
    AYRadius := ABitmap.Height / 2;
  end
  else if (AYRadius<1) then
  begin
    //小数,表示百分比
    AYRadius := ABitmap.Height * AYRadius;
  end;


  {$IFDEF ANDROID}
  Result:=AndroidRoundBitmap(ABitmap,AXRadius,AYRadius);
  {$ELSE}
  Result:=TSkinPicture.Create;
  if not ABitmap.IsEmpty then
  begin
      Result.SetSize(ABitmap.Width,ABitmap.Height);
      ResultCanvas:=TCanvasManager.CreateFromBitmap(Result,AQuality);
      ResultCanvas.BeginScene();
      try
        ResultCanvas.Clear(0);


        ResultCanvas.Fill.Bitmap.Bitmap.Assign(ABitmap);
        ResultCanvas.Fill.Kind:=TBrushKind.Bitmap;





        ResultCanvas.FillRect(
                                Rect(0,0,ABitmap.Width,ABitmap.Height),
                                AXRadius,
                                AYRadius,
                                ACorners,
                                1);

      finally
        ResultCanvas.EndScene;
        FreeAndNil(ResultCanvas);
      end;
  end;
  {$ENDIF}
end;
{$ENDIF FMX}


//const
//  // GIF Error messages
//  sOutOfData		= 'Premature end of data';

type
  TGIFVersionRec = array[0..2] of byte;
  TGIFHeaderRec = packed record
    Signature: array[0..2] of Byte; { contains 'GIF' }
    Version: TGIFVersionRec;   { '87a' or '89a' }
  end;

procedure ReadCheck(Stream: TStream; var Buffer; Size: LongInt);
var
  ReadSize		: integer;
begin
  ReadSize := Stream.Read(Buffer, Size);
//  if (ReadSize <> Size) then
//    Error(sOutOfData);
end;

function TGIFHeader_Check(Stream: TStream): Boolean;
var
  GifHeader		: TGIFHeaderRec;
//  ColorCount		: integer;
  Position		: integer;
begin
  Result:=False;

  Position := Stream.Position;

  ReadCheck(Stream, GifHeader, sizeof(GifHeader));
//  if (uppercase(GifHeader.Signature) <> 'GIF') then
    if Not (((GifHeader.Signature[0] = Ord('G'))
        or (GifHeader.Signature[0] = Ord('g')))
    and ((GifHeader.Signature[1] = Ord('I'))
        or (GifHeader.Signature[1] = Ord('i')))
    and ((GifHeader.Signature[2] = Ord('F'))
        or (GifHeader.Signature[2] = Ord('f'))))
  then
  begin
    // Attempt recovery in case we are reading a GIF stored in a form by rxLib
    Stream.Position := Position;
    // Seek past size stored in stream
    Stream.Seek(sizeof(longInt), TSeekOrigin.soCurrent);
    // Attempt to read signature again
    ReadCheck(Stream, GifHeader, sizeof(GifHeader));
//    if (uppercase(GifHeader.Signature) <> 'GIF') then
    if (((GifHeader.Signature[0] = Ord('G'))
        or (GifHeader.Signature[0] = Ord('g')))
    and ((GifHeader.Signature[1] = Ord('I'))
        or (GifHeader.Signature[1] = Ord('i')))
    and ((GifHeader.Signature[2] = Ord('F'))
        or (GifHeader.Signature[2] = Ord('f'))))
    then
    begin
      Result:=True;
    end;
  end
  else
  begin
    Result:=True;
  end;

  Stream.Position:=Position;

end;



{$IFDEF VCL}

function GetGraphicTypeByGraphicClass(const AGraphicClass:TGraphicClass):String;
begin
  Result:='';
  if AGraphicClass=TBitmap then
  begin
    Result:='Bmp';
  end
  else if AGraphicClass=TIcon then
  begin
    Result:='Ico';
  end
  else if AGraphicClass=TPngImage then
  begin
    Result:='Png';
  end
  else if AGraphicClass=TJpegImage then
  begin
    Result:='Jpg';
  end
  else if AGraphicClass=//GifImg.
        TGifImage then
  begin
    Result:='Gif';
  end;
end;

function GetGraphicClassByGraphicType(const AGraphicType:String):TGraphicClass;
begin
  Result:=nil;
  if AGraphicType='Bmp' then
  begin
    Result:=TBitmap;
  end
  else if AGraphicType='Ico' then
  begin
    Result:=TIcon;
  end
  else if AGraphicType='Png' then
  begin
    Result:=TPngImage;
  end
  else if AGraphicType='Jpg' then
  begin
    Result:=TJpegImage;
  end
  else if AGraphicType='Gif' then
  begin
    Result:=//GifImg.
            TGifImage;
  end;
end;
{$ENDIF}


function TSkinPicture.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I:Integer;
  ABTNode:TBTNode20;
  AGraphicType:String;
  {$IFDEF VCL}
  AGraphic:TGraphic;
  AGraphicClass:TGraphicClass;
  {$ENDIF}
  AGraphicStream:TMemoryStream;
  AGIFFileDataStream:TMemoryStream;
begin
  Result:=False;

  AGraphicType:='';
  AGraphicStream:=TMemoryStream.Create;
  AGIFFileDataStream:=TMemoryStream.Create;

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='ImageName' then
    begin
      FImageName:=ABTNode.ConvertNode_WideString.Data;
    end
//    else if ABTNode.NodeName='Caption' then
//    begin
//      FCaption:=ABTNode.ConvertNode_WideString.Data;
//    end
//    else if ABTNode.NodeName='Group' then
//    begin
//      FGroup:=ABTNode.ConvertNode_WideString.Data;
//    end

//    else if ABTNode.NodeName='SkinThemeColorChange' then
//    begin
//      SkinThemeColorChange:=ABTNode.ConvertNode_Bool32.Data;
//    end
//    else if ABTNode.NodeName='SkinThemeColor' then
//    begin
//      FSkinThemeColor:=ABTNode.ConvertNode_Int32.Data;
//    end


//  ABTNode:=ADocNode.AddChildNode_Bool32('SkinThemeColorChange');
//  ABTNode.ConvertNode_Bool32.Data:=FSkinThemeColorChange;
//
//  ABTNode:=ADocNode.AddChildNode_Bool32('SkinThemeColor');
//  ABTNode.ConvertNode_Int32.Data:=FSkinThemeColor;




    else if ABTNode.NodeName='GraphicType' then
    begin
      //加载图片类型
      AGraphicType:=ABTNode.ConvertNode_WideString.Data;
    end
    else if Copy(ABTNode.NodeName,1,Length('GraphicData'))='GraphicData' then
    begin
      //加载图片
      ABTNode.ConvertNode_Binary.SaveToStream(AGraphicStream);
    end
    else if Copy(ABTNode.NodeName,1,Length('GIFFileData'))='GIFFileData' then
    begin
      //加载GIF图片
      ABTNode.ConvertNode_Binary.SaveToStream(AGIFFileDataStream);
    end
    ;
  end;


  //加载GIF
  AGIFFileDataStream.Position:=0;
  Self.FGIFStream.LoadFromStream(AGIFFileDataStream);


  //加载图片
  if (AGraphicType<>'') and (AGraphicStream.Size>0) then
  begin
    {$IFDEF VCL}
    AGraphicClass:=GetGraphicClassByGraphicType(AGraphicType);
    if (AGraphicClass<>nil) then
    begin
      AGraphic:=AGraphicClass.Create;
      AGraphicStream.Position:=0;
      AGraphic.LoadFromStream(AGraphicStream);
      Self.Assign(AGraphic);
      FreeAndNil(AGraphic);
    end;
    {$ENDIF}
    {$IFDEF FMX}
    AGraphicStream.Position:=0;
    Inherited LoadFromStream(AGraphicStream);
    {$ENDIF}
  end
  else
  begin
    //清空图片
    Self.Assign(nil);
  end;

  FreeAndNil(AGraphicStream);
  FreeAndNil(AGIFFileDataStream);

  Result:=True;
end;

function TSkinPicture.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
  AGraphicType:String;
  AGraphicExt:String;
  AGraphicStream:TMemoryStream;
  {$IFDEF VCL}
  APngImage:TPngImage;
  {$ENDIF}
begin
  Result:=False;

  //保存类类型
  ADocNode.ClassName:='TSkinPicture';



  //保存名称
  ABTNode:=ADocNode.AddChildNode_WideString('ImageName');//,'名称');
  ABTNode.ConvertNode_WideString.Data:=FImageName;

//  ABTNode:=ADocNode.AddChildNode_WideString('Caption','标题');
//  ABTNode.ConvertNode_WideString.Data:=FCaption;
//
//  ABTNode:=ADocNode.AddChildNode_WideString('Group','分组');
//  ABTNode.ConvertNode_WideString.Data:=FGroup;


//  //保存名称
//  ABTNode:=ADocNode.AddChildNode_WideString('Name',FName);
//  ABTNode.ConvertNode_WideString.Data:=FName;

  AGraphicType:='';
  if (Not Self.IsEmpty) then
  begin
    //保存图片类型
    AGraphicExt:='';
    {$IFDEF VCL}
    //VCL要保存图片类型，因为每个图片用不同的类型
    AGraphicType:=GetGraphicTypeByGraphicClass(TGraphicClass(Self.Graphic.ClassType));
    if AGraphicType<>'' then
    begin
      ABTNode:=ADocNode.AddChildNode_WideString('GraphicType');//,'图片类型');
      ABTNode.ConvertNode_WideString.Data:=AGraphicType;
      AGraphicExt:='.'+Graphics.GraphicExtension(TGraphicClass(Self.Graphic.ClassType));
    end
    else
    begin
      APngImage:=TPngImage.Create;
      AGraphicStream:=TMemoryStream.Create;
      try
        Self.Graphic.SaveToStream(AGraphicStream);
        AGraphicStream.Position:=0;
        APngImage.LoadFromStream(AGraphicStream);

        Self.Assign(APngImage);
        AGraphicType:=GetGraphicTypeByGraphicClass(TGraphicClass(Self.Graphic.ClassType));
        if AGraphicType<>'' then
        begin
          ABTNode:=ADocNode.AddChildNode_WideString('GraphicType');//,'图片类型');
          ABTNode.ConvertNode_WideString.Data:=AGraphicType;
          AGraphicExt:='.'+Graphics.GraphicExtension(TPngImage);
        end;
      finally
        FreeAndNil(APngImage);
        FreeAndNil(AGraphicStream);
      end;
    end;
    {$ENDIF}
    {$IFDEF FMX}
    //FMX不用处理图片类型
    ABTNode:=ADocNode.AddChildNode_WideString('GraphicType');//,'图片类型');
    AGraphicType:='Png';
    ABTNode.ConvertNode_WideString.Data:=AGraphicType;
    AGraphicExt:='.'+'Png'
    {$ENDIF}
  end;


  if (AGraphicType<>'') and (Not Self.IsEmpty) then
  begin
    //保存图片数据
    ABTNode:=ADocNode.AddChildNode_Binary('GraphicData'+AGraphicExt);//,'图片数据');
    AGraphicStream:=TMemoryStream.Create;
    {$IFDEF VCL}
    Self.Graphic.SaveToStream(AGraphicStream);
    {$ENDIF}
    {$IFDEF FMX}
    Self.SaveToStream(AGraphicStream);
    {$ENDIF}
    AGraphicStream.Position:=0;
    ABTNode.ConvertNode_Binary.LoadFromStream(AGraphicStream);
    FreeAndNil(AGraphicStream);
  end;



  //保存GIF图片数据
  ABTNode:=ADocNode.AddChildNode_Binary('GIFFileData'+AGraphicExt);//,'GIF图片数据');
  ABTNode.ConvertNode_Binary.LoadFromStream(FGIFStream);


//  ABTNode:=ADocNode.AddChildNode_Bool32('SkinThemeColorChange');
//  ABTNode.ConvertNode_Bool32.Data:=FSkinThemeColorChange;
//
//  ABTNode:=ADocNode.AddChildNode_Int32('SkinThemeColor');
//  ABTNode.ConvertNode_Int32.Data:=FSkinThemeColor;


  Result:=True;
end;


{ TSkinPicture }

procedure TSkinPicture.Assign(Source: TPersistent);
begin
  if (Source<>nil) and (Source is TSkinPicture) then
  begin
      Self.FImageName:=TSkinPicture(Source).FImageName;


      Self.FSkinThemeColor:=TSkinPicture(Source).FSkinThemeColor;
      Self.SkinThemeColorChange:=TSkinPicture(Source).FSkinThemeColorChange;


      //GIFFile赋值,GIF图片需要把流保存起来
      TSkinPicture(Source).FGIFStream.Position:=0;
      Self.FGIFStream.LoadFromStream(TSkinPicture(Source).FGIFStream);
      TSkinPicture(Source).FGIFStream.Position:=0;
  end
  else
  begin
      Clear;
  end;


  {$IFDEF FMX}
  //Source为TBitmapSurface用于LoadFromStream,LoadFromFile,
  //Source为TBitmap用于设计器时的Assign(TBitmap)
  if (Source<>nil) and (not (Source is TBitmapSurface)) then
  begin
    //在设计时改过
    IsChanged:=True;
  end;
  {$ENDIF}


  inherited Assign(Source);

  DoPictureChanged;
end;

procedure TSkinPicture.DoChange;
begin
  if Not FIsDoChangeing then
  begin
    FIsDoChangeing:=True;
    try
      if Assigned(FOnChange) then
      begin
        FOnChange(Self);
      end;
    finally
      FIsDoChangeing:=False;
    end;
  end
  else
  begin
    uBaseLog.OutputDebugString('TBaseDrawPicture.DoChange DoChangeing');
  end;
end;

{$IFDEF FMX}
procedure TSkinPicture.BitmapChanged;
begin
  inherited;

//  DoPictureChanged;//可能会死循环

  DoChange;
end;
{$ENDIF FMX}

procedure TSkinPicture.Clear;
begin

end;

constructor TSkinPicture.Create;
begin
  {$IFDEF VCL}
  Inherited Create;
  {$ENDIF}
  {$IFDEF FMX}
  Inherited Create(0,0);
  {$ENDIF}



  FGIFStream:=TMemoryStream.Create;




  Self.FClipRoundXRadis:=-1;
  Self.FClipRoundYRadis:=-1;

  {$IFDEF FMX}
  FClipRoundCorners:=[TCorner.TopLeft, TCorner.TopRight, TCorner.BottomLeft, TCorner.BottomRight];
  {$ENDIF}

end;

function TSkinPicture.CurrentPicture: TSkinPicture;
begin

  if FSkinThemeColorPicture=nil then
  begin
    Result:=Self;
  end
  else
  begin
    Result:=FSkinThemeColorPicture;
  end;
end;

function TSkinPicture.GetCurrentGIFStream: TMemoryStream;
begin
  Result:=FGIFStream;
end;

function TSkinPicture.GetCurrentIsGIF: Boolean;
begin
  Result:=HasGIFStream;
end;

destructor TSkinPicture.Destroy;
begin
  FreeAndNil(FSkinPictureEngine);
  FreeAndNil(FGIFStream);

  FreeAndNil(FSkinThemeColorPicture);
  inherited;
end;

procedure TSkinPicture.DirectLoadFromFile(const FileName: String);
begin

  inherited LoadFromFile(FileName);


  DoPictureChanged;
end;

procedure TSkinPicture.DirectLoadFromStream(Stream: TStream);
begin
  Stream.Position:=0;
  inherited LoadFromStream(Stream);

  DoPictureChanged;

end;

procedure TSkinPicture.DoAnimateRePaint(Sender: TObject);
begin
  if Assigned(Self.FOnAnimateRePaint) then
  begin
    FOnAnimateRePaint(Sender);
  end;
end;

procedure TSkinPicture.DoClipRound;
    {$IFDEF FMX}
var
  ARoundBitmap:TBitmap;
    {$ENDIF FMX}
    {$IFDEF VCL}
var
  ARoundBitmap:TSkinPicture;
    {$ENDIF VCL}
begin
  if not Self.IsEmpty then
  begin
    {$IFDEF FMX}
    ARoundBitmap:=RoundSkinPicture(Self,
                                  Self.FClipRoundXRadis,
                                  Self.FClipRoundYRadis,
                                  Self.FClipRoundCorners);
    try
      //必须用CopyBitmap,不然会花屏
      CopyBitmap(ARoundBitmap,Self);
      //Inherited Assign(ARoundBitmap);
    finally
      FreeAndNil(ARoundBitmap);
    end;
    {$ENDIF FMX}
    {$IFDEF VCL}
    ARoundBitmap:=RoundSkinPicture(Self,
                                  Self.FClipRoundXRadis,
                                  Self.FClipRoundYRadis);
    try
      Inherited Assign(ARoundBitmap);
    finally
      FreeAndNil(ARoundBitmap);
    end;
    {$ENDIF VCL}
  end;

end;

function TSkinPicture.GetSkinPictureEngine: TSkinPictureEngine;
begin
  if Self.FSkinPictureEngine=nil then
  begin
    FSkinPictureEngine:=uDrawEngine.CreateCurrentEngineSkinPictureEngine(Self,Self.GIFSupport);
  end;
  Result:=FSkinPictureEngine;
end;

function TSkinPicture.HasGIFStream: Boolean;
begin
  Result:=(Self.FGIFStream<>nil) and (Self.FGIFStream.Size>0);
end;

procedure TSkinPicture.LoadFromFile(const FileName: String);
{$IFDEF FMX}
var
  ASkinGIFImage:TSkinGIFImage;
{$ENDIF}
var
  AFileStream:TFileStream;
begin



  //加载GIF
  AFileStream:=TFileStream.Create(FileName,fmOpenRead or fmShareDenyNone);
  try
    Self.LoadGIFFromStream(AFileStream);
  finally
    FreeAndNil(AFileStream);
  end;



  {$IFDEF FMX}
  //判断是否是GIF
  if {$IFDEF MSWINDOWS}False and {$ENDIF}
      Self.HasGIFStream then
  begin
      //移动平台下面
      //加载第一帧
      //保持比例
      //GIF图片
      ASkinGIFImage:=uSkinGIFImage.TSkinGIFImage.Create;
      try
        FGIFStream.Position:=0;
        ASkinGIFImage.LoadFromStream(FGIFStream);
        Self.Assign(ASkinGIFImage.Bitmap);
      finally
        FreeAndNil(ASkinGIFImage);
      end;
  end
  else
  begin
      try
        inherited LoadFromFile(FileName);
      except
        on E:Exception do
        begin
          uBaseLog.HandleException(E,'OrangeUIGraphic','uSkinPicture','TSkinPicture.LoadFromFile'+FileName);
        end;
      end;
  end;
  {$ENDIF}





  {$IFDEF VCL}
  inherited LoadFromFile(FileName);
  {$ENDIF}


  DoPictureChanged;
end;

procedure TSkinPicture.LoadFromResource(const ResourceName: String);
var
  S: TResourceStream;
begin
  {$IFDEF FMX}
  if (System.FindResource(HInstance, PWideChar(ResourceName), RT_RCDATA)<>0) then
  begin
    S := TResourceStream.Create(HInstance,ResourceName, RT_RCDATA);
    try
      S.Position:=0;
      Self.LoadFromStream(S);
    finally
      FreeAndNil(S);
    end;
  end;
  {$ENDIF}
end;

procedure TSkinPicture.LoadFromStream(Stream: TStream);
begin
  Stream.Position:=0;
  Self.LoadGIFFromStream(Stream);

  DirectLoadFromStream(Stream);
end;

procedure TSkinPicture.LoadGIFFromStream(Stream: TStream);
var
  Position:Integer;
begin
  if (Stream=nil) or (Stream.Size=0) then
  begin
    FGIFStream.Size:=0;
  end
  else
  begin
    Position:=Stream.Position;

    if TGIFHeader_Check(Stream) then
    begin
      Stream.Position:=Position;
      FGIFStream.LoadFromStream(Stream);
      Stream.Position:=Position;
    end;

  end;
end;

procedure TSkinPicture.DoPictureChanged;
begin
  FreeAndNil(FSkinPictureEngine);


  if FIsNoDoPictureChanged then Exit;

  //要重新设置IsClipRound
  FIsNoDoPictureChanged:=True;
  try
    //将图片裁剪成圆形
    if Self.FIsClipRound and not Self.IsEmpty then
    begin
      DoClipRound;
    end;
  finally
    FIsNoDoPictureChanged:=False;
  end;


end;



{$IFDEF VCL}
function TSkinPicture.IsEmpty:Boolean;
begin
  Result:=(Graphic=nil) or (Graphic.Empty);
end;

procedure TSkinPicture.SetSize(const AWidth:Integer;const AHeight:Integer);
begin
  Bitmap.Width:=AWidth;
  Bitmap.Height:=AHeight;
end;
{$ENDIF}



{$IFDEF VCL}
procedure TSkinPicture.Changed(Sender: TObject);
begin
  //更改之后要清除
  if FSkinPictureEngine<>nil then
  begin
    Self.FSkinPictureEngine.Clear;
  end;
  inherited Changed(Sender);


  DoPictureChanged();
end;
{$ENDIF}

//type
//  TProtectedGraphic=class(TGraphic)
//
//  end;
//
////  TProtectedPicture=class(TPicture)
////
////  end;
//
//procedure TSkinPicture.ReadData(Stream: TStream);
//var
//  NewGraphic: TGraphic;
//  GraphicClass: TGraphicClass;
//  LClassName: string;
//  LBytes: TBytes;
//  LNameLen: Byte;
//begin
//  Stream.Read(LNameLen, 1);
//  SetLength(LBytes, LNameLen);
//  Stream.Read(LBytes{$IFNDEF CLR}[0]{$ENDIF}, LNameLen);
//  LClassName := TEncoding.UTF8.GetString(LBytes);
//
//  //GraphicClass := FileFormats.FindClassName(LClassName);
////  Add('wmf', SVMetafiles, 0, TMetafile);
////  Add('emf', SVEnhMetafiles, 0, TMetafile);
////  Add('ico', SVIcons, 0, TIcon);
////  Add('tiff', SVTIFFImages, 0, TWICImage);
////  Add('tif', SVTIFFImages, 0, TWICImage);
////  Add('bmp', SVBitmaps, 0, TBitmap);
//  GraphicClass:=nil;
//  if LClassName='TBitmap' then
//  begin
//    GraphicClass:=TBitmap;
//  end;
//  if LClassName='TIcon' then
//  begin
//    GraphicClass:=TIcon;
//  end;
//  if LClassName='TWICImage' then
//  begin
//    GraphicClass:=TWICImage;
//  end;
//  if LClassName='TMetafile' then
//  begin
//    GraphicClass:=TMetafile;
//  end;
//  if LClassName='TPngImage' then
//  begin
//    GraphicClass:=TPngImage;
//  end;
//  if LClassName='TJpegImage' then
//  begin
//    GraphicClass:=TJpegImage;
//  end;
//
//  NewGraphic := nil;
//  if GraphicClass <> nil then
//  begin
//    NewGraphic := GraphicClass.Create;
//    try
//      TProtectedGraphic(NewGraphic).ReadData(Stream);
//    except
//      NewGraphic.Free;
//      raise;
//    end;
//  end;
//  Graphic.Free;
//  Graphic := NewGraphic;
//  if NewGraphic <> nil then
//  begin
//    NewGraphic.OnChange := Changed;
//    NewGraphic.OnProgress := Progress;
//  end;
//  Changed(Self);
//end;
//
//procedure TSkinPicture.WriteData(Stream: TStream);
//var
//  LClassName: string;
//  LBytes: TBytes;
//  LNameLen: Integer;
//begin
//  with Stream do
//  begin
//    if Graphic <> nil then
//      LClassName := Graphic.ClassName
//    else
//      LClassName := '';
//    LBytes := TEncoding.UTF8.GetBytes(LClassName);
//    LNameLen := Length(LBytes);
//    Write(LNameLen, 1);  // Only write 1 byte (length of string)
//    Write(LBytes{$IFNDEF CLR}[0]{$ENDIF}, LNameLen);
//
//    if Graphic <> nil then
//      TProtectedGraphic(Graphic).WriteData(Stream);
//  end;
//end;


procedure TSkinPicture.DefineProperties(Filer: TFiler);
begin

  inherited;


//  function DoWrite: Boolean;
//  var
//    Ancestor: TPicture;
//  begin
//    if Filer.Ancestor <> nil then
//    begin
//      Result := True;
//      if Filer.Ancestor is TPicture then
//      begin
//        Ancestor := TPicture(Filer.Ancestor);
//        Result := not ((Graphic = Ancestor.Graphic) or
//          ((Graphic <> nil) and (Ancestor.Graphic <> nil) and
//          Graphic.Equals(Ancestor.Graphic)));
//      end;
//    end
//    else Result := Graphic <> nil;
//  end;
//
//begin
//  uBaseLog.HandleException(nil,'TSkinPicture.DefineProperties Begin ');
//  Filer.DefineBinaryProperty('Data', ReadData, WriteData, DoWrite);

  Filer.DefineBinaryProperty('GIFFileData', ReadGIFData, WriteGIFData,(FGIFStream<>nil) and (FGIFStream.Size>0));

end;

procedure TSkinPicture.ReadGIFData(Stream: TStream);
begin
//  uBaseLog.HandleException(nil,'TSkinPicture.ReadGIFData Begin');

  LoadGIFFromStream(Stream);

//  uBaseLog.HandleException(nil,'TSkinPicture.ReadGIFData End');
end;

procedure TSkinPicture.WriteGIFData(Stream: TStream);
begin
//  uBaseLog.HandleException(nil,'TSkinPicture.WriteGIFData Begin');

  if (FGIFStream<>nil) and (FGIFStream.Size>0) then
  begin
    FGIFStream.Position:=0;
    Stream.CopyFrom(Self.FGIFStream,FGIFStream.Size);
  end;

//  uBaseLog.HandleException(nil,'TSkinPicture.WriteGIFData End');

end;

procedure TSkinPicture.SetGIFSupport(const Value: Boolean);
begin
  if FGIFSupport<>Value then
  begin
    FGIFSupport := Value;
    FreeAndNil(Self.FSkinPictureEngine);
  end;
end;

procedure TSkinPicture.SetSkinThemeColorChange(const Value: Boolean);
begin
  if FSkinThemeColorChange<>Value then
  begin
    FSkinThemeColorChange := Value;

    if FSkinThemeColorChange then
    begin
      GlobalChangedColorBySkinThemePictureList.Add(Self);


    end
    else
    begin
      GlobalChangedColorBySkinThemePictureList.Remove(Self,False);
      FreeAndNil(FSkinThemeColorPicture);
    end;
  end;
end;

procedure TSkinPicture.SetIsClipRound(const Value: Boolean);
begin
  if FIsClipRound<>Value then
  begin
    FIsClipRound := Value;

    if FIsClipRound then
    begin
      DoClipRound;
    end;
  end;
end;

{ TSkinPictureEngine }


procedure TSkinPictureEngine.Clear;
begin
end;

constructor TSkinPictureEngine.Create(ASkinPicture:TSkinPicture);
begin
  FSkinPicture:=ASkinPicture;
end;

destructor TSkinPictureEngine.Destroy;
begin
  Clear;
  inherited;
end;

function TSkinPictureEngine.GetCurrentIsGIF: Boolean;
begin
  Result:=False;
end;





{ TSkinBaseGIFPictureEngine }

procedure TSkinBaseGIFPictureEngine.AnimateSpeedChanged(const Value: Double);
begin

end;

procedure TSkinBaseGIFPictureEngine.Clear;
begin
  StopAnimate;
end;

constructor TSkinBaseGIFPictureEngine.Create(ASkinPicture: TSkinPicture);
begin
  inherited Create(ASkinPicture);
  {$IFDEF FAST_AS_HELL}
    FGIFDelayExp:= 10;		// Delay multiplier in mS.
  {$ELSE}
    FGIFDelayExp:= 12;		// Delay multiplier in mS. Tweaked.
  {$ENDIF}
  Self.FAnimateSpeed:=10;
end;

function TSkinBaseGIFPictureEngine.CurrentAnimateFrame: TSkinPicture;
begin
  Result:=Self.FSkinPicture;
  //如果没有启动，那么启动
end;

procedure TSkinBaseGIFPictureEngine.DoAnimateRePaint(Sender: TObject);
begin
  if Assigned(Self.FSkinPicture.OnAnimateRePaint) then
  begin
    Self.FSkinPicture.OnAnimateRePaint(Sender);
  end;
end;

procedure TSkinBaseGIFPictureEngine.DrawToCanvas(
                                  Canvas: TObject;
                                  ADrawPictureParam: TDrawPictureParam;
                                  ADrawRect: TRectF);
begin
  TDrawCanvas(Canvas).DrawSkinPicture(ADrawPictureParam,Self.CurrentAnimateFrame,ADrawRect,False,RectF(0,0,0,0),RectF(0,0,0,0));
end;

function TSkinBaseGIFPictureEngine.GetCurrentIsGIF: Boolean;
begin
  Result:=Self.FSkinPicture.GetCurrentIsGIF;
end;

function TSkinBaseGIFPictureEngine.IsStarted: Boolean;
begin
  Result:=True;
end;

procedure TSkinBaseGIFPictureEngine.SetAnimated(Value: Boolean);
begin
  if Animated<>Value then
  begin
    FAnimated:=Value;
    if FAnimated then
    begin
      StartAnimate;
    end
    else
    begin
      StopAnimate;
    end;
  end;
end;

procedure TSkinBaseGIFPictureEngine.SetAnimateSpeed(const Value: Double);
begin
  if FAnimateSpeed<>Value then
  begin
    FAnimateSpeed := Value;
    AnimateSpeedChanged(FAnimateSpeed);
  end;
end;

procedure TSkinBaseGIFPictureEngine.SetGIFDelayExp(const Value: Integer);
begin
  if FGIFDelayExp<>Value then
  begin
    FGIFDelayExp := Value;
    AnimateSpeedChanged(FAnimateSpeed);
  end;
end;

procedure TSkinBaseGIFPictureEngine.StartAnimate;
begin
end;

procedure TSkinBaseGIFPictureEngine.StopAnimate;
begin
end;

initialization
  GlobalChangedColorBySkinThemePictureList:=TBaseList.Create(ooReference);

finalization
  GlobalChangedColorBySkinThemePictureList.Free;

end.






