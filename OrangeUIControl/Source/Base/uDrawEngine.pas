//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     绘制引擎管理,用于管理多个绘制引擎
///   </para>
///   <para>
///     Drawing engine manager,used for manage several drawing engines
///   </para>
/// </summary>
unit uDrawEngine;





interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  uBaseLog,
  uBaseList,
  uBasePathData,
  uDrawCanvas,
  uFuncCommon,
  uDrawPicture,
  uSkinPicture;




type
  TDrawCanvasCalss=class of TDrawCanvas;
  TSkinPictureClass=class of TSkinPicture;
  TSkinPictureEngineClass=class of TSkinPictureEngine;






/// <summary>
///   <para>
///     创建画布
///   </para>
///   <para>
///     Create canvas
///   </para>
/// </summary>
function CreateDrawCanvas(AName:String):TDrawCanvas;
/// <summary>
///   <para>
///     创建图片
///   </para>
///   <para>
///     Create picture
///   </para>
/// </summary>
function CreateCurrentEngineSkinPicture:TSkinPicture;
/// <summary>
///   <para>
///     创建图片引擎
///   </para>
///   <para>
///     Create picture engine
///   </para>
/// </summary>
function CreateCurrentEngineSkinPictureEngine(
                                              ASkinPicture:TSkinPicture;
                                              GIFSupport:Boolean=False
                                              ):TSkinPictureEngine;
/// <summary>
///   <para>
///     创建图片
///   </para>
///   <para>
///     Create picture
///   </para>
/// </summary>
function CreateCurrentEngineDrawPicture(
                              const AName:String;
                              const ACaption:String;
                              const AGroup:String=''
                              ):TDrawPicture;








var

  /// <summary>
  ///   全局的画布类
  /// </summary>
  GlobalDrawCanvasClass:TDrawCanvasCalss;


  /// <summary>
  ///   全局的图片类
  /// </summary>
  GlobalSkinPictureClass:TSkinPictureClass;


  /// <summary>
  ///   全局的图片引擎类
  /// </summary>
  GlobalSkinPictureEngineClass:TSkinPictureEngineClass;


  /// <summary>
  ///   全局的GIF图片引擎类
  /// </summary>
  GlobalSkinGIFPictureEngineClass:TSkinPictureEngineClass;


  /// <summary>
  ///   全局的Path类
  /// </summary>
  GlobalDrawPathDataClass:TDrawPathDataClass;



implementation


uses
  {$IFDEF VCL}
  uGDIPlusSkinPictureEngine,
  uGDIPlusDrawCanvas,
  {$ENDIF}
  {$IFDEF FMX}
  uFireMonkeySkinPictureEngine,
  uFireMonkeyDrawCanvas,
  {$ENDIF}
  uSkinBufferBitmap;


//创建画布
function CreateDrawCanvas(AName:String):TDrawCanvas;
begin
  Result:=GlobalDrawCanvasClass.Create;
  Result.FName:=AName;
end;

//创建图片
function CreateCurrentEngineSkinPicture:TSkinPicture;
begin
  Result:=GlobalSkinPictureClass.Create;
end;

//创建图片
function CreateCurrentEngineSkinPictureEngine(ASkinPicture:TSkinPicture;GIFSupport:Boolean=False):TSkinPictureEngine;
begin
  if Not GIFSupport then
  begin
    Result:=GlobalSkinPictureEngineClass.Create(ASkinPicture);
  end
  else
  begin
    Result:=GlobalSkinGIFPictureEngineClass.Create(ASkinPicture);
  end;
end;

function CreateCurrentEngineDrawPicture(
                                        const AName:String;
                                        const ACaption:String;
                                        const AGroup:String
                                        ):TDrawPicture;
begin
  Result:=TDrawPicture.Create(
        AName,
        ACaption,
        AGroup
        );
end;



initialization


  {$IFDEF VCL}
  GlobalDrawCanvasClass:=TGDIPlusDrawCanvas;
  GlobalSkinPictureClass:=TSkinPicture;
  GlobalSkinPictureEngineClass:=TGDIPlusSkinPictureEngine;
  GlobalSkinGIFPictureEngineClass:=TGDIPlusSkinGIFPictureEngine;
  GlobalDrawPathDataClass:=TGDIPlusDrawPathData;
  {$ENDIF}

  {$IFDEF FMX}
  GlobalDrawCanvasClass:=TFireMonkeyDrawCanvas;
  GlobalSkinPictureClass:=TSkinPicture;
  GlobalSkinPictureEngineClass:=TFireMonkeySkinPictureEngine;
  GlobalSkinGIFPictureEngineClass:=TFireMonkeySkinGIFPictureEngine;
  GlobalDrawPathDataClass:=TFireMonkeyDrawPathData;
  {$ENDIF}



end.

