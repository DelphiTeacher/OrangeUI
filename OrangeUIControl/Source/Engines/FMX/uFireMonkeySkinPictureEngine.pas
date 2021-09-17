//convert pas to utf8 by ¥
//------------------------------------------------------------------
//
//                 OrangeUI Source Files
//
//  Module: OrangeGraphic
//  Unit: uFireMonkeySkinPictureEngine
//  Description: FMX图片引擎
//
//  Copyright: delphiteacher
//  CodeBy: delphiteacher
//  Email: ggggcexx@163.com
//  Writing: 2012-2014
//
//------------------------------------------------------------------




//FMX图片引擎
unit uFireMonkeySkinPictureEngine;

interface

uses
  Classes,
  SysUtils,
  Types,
  Math,
  uFuncCommon,
  uGraphicCommon,
  uDrawPictureParam,
  uSkinGIFImage,
  uSkinPicture;

type
  TFireMonkeySkinPictureEngine=class(TSkinPictureEngine)
  end;


  /// <summary>
  ///   GIF图片引擎
  /// </summary>
  TSkinGIFPictureEngine=class(TSkinBaseGIFPictureEngine)
  protected
    FSkinGIFImage:TSkinGIFImage;
    FGIFPainter:TGIFPainter;
    procedure CreateGIFImage;
    procedure StopAnimate;override;

    procedure AnimateSpeedChanged(const Value: Double);override;
    //是否启动了动画
    function IsStarted:Boolean;override;
  public
    procedure Clear;override;
    constructor Create(ASkinPicture:TSkinPicture);override;
  public
    //当前帧
    function CurrentAnimateFrame:TSkinPicture;override;
    procedure StartAnimate;override;
    procedure DrawToCanvas(Canvas:TObject;ADrawPictureParam:TDrawPictureParam;ADrawRect:TRectF);override;
  end;

  TFireMonkeySkinGIFPictureEngine=class(TSkinGIFPictureEngine)
  end;





implementation



{ TFireMonkeyDrawPicture }



{ TSkinGIFPictureEngine }

procedure TSkinGIFPictureEngine.Clear;
begin
  inherited;
  FreeAndNil(FSkinGIFImage);
  FGIFPainter:=nil;
end;

constructor TSkinGIFPictureEngine.Create(ASkinPicture: TSkinPicture);
begin
  inherited Create(ASkinPicture);
end;

procedure TSkinGIFPictureEngine.CreateGIFImage;
begin
  if CurrentIsGIF and (FSkinGIFImage=nil) then
  begin
    FSkinGIFImage:=uSkinGIFImage.TSkinGIFImage.Create;
    FSkinGIFImage.OnPaint:=Self.DoAnimateRePaint;
    Self.FSkinPicture.GetCurrentGIFStream.Position:=0;
    FSkinGIFImage.LoadFromStream(Self.FSkinPicture.GetCurrentGIFStream);
  end;
  if FSkinGIFImage<>nil then
  begin
    FSkinGIFImage.GIFDelayExp:=GIFDelayExp;
    FSkinGIFImage.AnimationSpeed:=Ceil(Self.FAnimateSpeed);
  end;
end;

function TSkinGIFPictureEngine.CurrentAnimateFrame: TSkinPicture;
begin
  Result:=Inherited CurrentAnimateFrame;
  //启动
  if CurrentIsGIF and Self.FAnimated and Not IsStarted then
  begin
    CreateGIFImage;
    StartAnimate;
  end;

  if (FSkinGIFImage<>nil)
    and (FGIFPainter<>nil)
    and (FGIFPainter.ActiveImage>=0)
    and (FGIFPainter.ActiveImage<FSkinGIFImage.Images.Count-1) then
  begin
    Result:=TSkinPicture(FSkinGIFImage.Images[FGIFPainter.ActiveImage].SkinPicture);
  end;

end;


procedure TSkinGIFPictureEngine.DrawToCanvas(Canvas:TObject;
                            ADrawPictureParam:TDrawPictureParam;
                            ADrawRect:TRectF);
begin
  if FGIFPainter<>nil then
  begin
    // Paint the image
    if (FGIFPainter.BackupBuffer <> nil) then
    begin
      FGIFPainter.DoPaintFrame(Canvas,ADrawPictureParam,ADrawPictureParam.CalcDrawRect(ADrawRect));
    end
    else
    begin
      FGIFPainter.DoPaint(Canvas,ADrawPictureParam,ADrawPictureParam.CalcDrawRect(ADrawRect));
    end;
  end
  else
  begin
    Inherited;
  end;
end;

function TSkinGIFPictureEngine.IsStarted: Boolean;
begin
  Result:=(FGIFPainter<>nil);
end;

procedure TSkinGIFPictureEngine.AnimateSpeedChanged(const Value: Double);
begin
  if FSkinGIFImage<>nil then
  begin
    FSkinGIFImage.AnimationSpeed:=Ceil(Self.FAnimateSpeed);
    FSkinGIFImage.GIFDelayExp:=GIFDelayExp;
  end;
end;

procedure TSkinGIFPictureEngine.StartAnimate;
begin
  inherited;
  if CurrentIsGIF then
  begin
    Self.CreateGIFImage;
    FGIFPainter:=Self.FSkinGIFImage.Paint(Self,GIFImageDefaultDrawOptions);
  end;
end;

procedure TSkinGIFPictureEngine.StopAnimate;
begin
  inherited;
  if //CurrentIsGIF(在DrawPicture释放的时候，CurrentIsGIF会获取一次CurrentPicture，避免再次加载)
    //and
    (FSkinGIFImage<>nil)
    and (FGIFPainter<>nil) then
  begin
    FGIFPainter.Stop;
  end;
end;



end.
//------------------------------------------------------------------
//
//                 OrangeUI Source Files
//
//  Module: OrangeGraphic
//  Unit: uFireMonkeySkinPictureEngine
//  Description: FMX图片引擎
//
//  Copyright: delphiteacher
//  CodeBy: delphiteacher
//  Email: ggggcexx@163.com
//  Writing: 2012-2014
//
//------------------------------------------------------------------
