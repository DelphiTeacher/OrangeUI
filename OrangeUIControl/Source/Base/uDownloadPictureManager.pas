//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     图片下载管理者
///   </para>
///   <para>
///     Download picture manager
///   </para>
/// </summary>
unit uDownloadPictureManager;




interface
{$I FrameWork.inc}



uses
  Classes,
  SysUtils,
  Math,
  Types,


  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Graphics,
  {$ENDIF}

  uFuncCommon,
  uBaseLog,
  uBaseHttpControl,
  uBaseList,
  uBinaryObjectList,
  uTimerTask,
  uBinaryTreeDoc,
//  uDrawEngine,

  uFileCommon,
  uUrlPicture,
  uDrawPicture;





type
  TDownloadPictureManager=class;



  {$I ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     下载图片管理组件
  ///   </para>
  ///   <para>
  ///     Download picture manage component
  ///   </para>
  /// </summary>
  TDownloadPictureManager=class(TDefaultDownloadPictureManager)
  private
    FDownloadingPicture: TDrawPicture;
    FDownloadFailPicture: TDrawPicture;
    FWaitDownloadPicture: TDrawPicture;
    FImageInvalidPicture: TDrawPicture;



    procedure SetDownloadFailPicture(const Value: TDrawPicture);
    procedure SetWaitDownloadPicture(const Value: TDrawPicture);
    procedure SetDownloadingPicture(const Value: TDrawPicture);
    procedure SetImageInvalidPicture(const Value: TDrawPicture);

  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    /// <summary>
    ///   <para>
    ///     等待下载状态的图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DownloadingPicture:TDrawPicture read FDownloadingPicture write SetDownloadingPicture;
    /// <summary>
    ///   <para>
    ///     正在下载状态的图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property WaitDownloadPicture:TDrawPicture read FWaitDownloadPicture write SetWaitDownloadPicture;
    /// <summary>
    ///   <para>
    ///     下载失败状态的图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DownloadFailPicture:TDrawPicture read FDownloadFailPicture write SetDownloadFailPicture;
    /// <summary>
    ///   <para>
    ///     图片非法状态的图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property ImageInvalidPicture:TDrawPicture read FImageInvalidPicture write SetImageInvalidPicture;

  end;












var
  //全局图片下载管理者
  //可以调用GetGlobalDownloadPictureManager来自动创建,
  //也可以在窗体中拖放然后在代码中设置,
  //以便可以设置一些事件和属性
  GlobalDownloadPictureManager:TBaseDownloadPictureManager;




/// <summary>
///   <para>
///     全局的下载图片的管理对象
///   </para>
///   <para>
///    Global manager of downloaded picture
///   </para>
/// </summary>
function GetGlobalDownloadPictureManager:TBaseDownloadPictureManager;


/// <summary>
///   <para>
///     释放全局的下载图片的管理对象
///   </para>
///   <para>
///      Release manager of global downloaded picture
///   </para>
/// </summary>
procedure FreeGlobalDownloadPictureManager;





implementation





function GetGlobalDownloadPictureManager:TBaseDownloadPictureManager;
begin
  //需要放在线程中加载,不然第一次加载会卡顿
  if GlobalDownloadPictureManager=nil then
  begin
    GlobalDownloadPictureManager:=TDownloadPictureManager.Create(nil);
    //默认的分组
    GlobalDownloadPictureManager.GroupName:='Default';
  end;
  Result:=GlobalDownloadPictureManager;
end;

procedure FreeGlobalDownloadPictureManager;
begin
  FreeAndNil(GlobalDownloadPictureManager);
end;


{ TDownloadPictureManager }


constructor TDownloadPictureManager.Create(AOwner:TComponent);
begin
  Inherited;

  FWaitDownloadPicture:=TDrawPicture.Create('WaitDownloadPicture','等待下载状态的图片','');
  FDownloadingPicture:=TDrawPicture.Create('DownloadingPicture','正在下载状态的图片','');
  FDownloadFailPicture:=TDrawPicture.Create('DownloadFailPicture','下载失败状态的图片','');
  FImageInvalidPicture:=TDrawPicture.Create('ImageInvalidPicture','图片非法状态的图片','');
end;

destructor TDownloadPictureManager.Destroy;
begin
  FreeAndNil(Self.FWaitDownloadPicture);
  FreeAndNil(Self.FDownloadingPicture);
  FreeAndNil(Self.FDownloadFailPicture);
  FreeAndNil(Self.FImageInvalidPicture);

  inherited;
end;

procedure TDownloadPictureManager.SetDownloadFailPicture(const Value: TDrawPicture);
begin
  FDownloadFailPicture.Assign(Value);
end;

procedure TDownloadPictureManager.SetDownloadingPicture(const Value: TDrawPicture);
begin
  FDownloadingPicture.Assign(Value);
end;

procedure TDownloadPictureManager.SetImageInvalidPicture(const Value: TDrawPicture);
begin
  FImageInvalidPicture.Assign(Value);
end;

procedure TDownloadPictureManager.SetWaitDownloadPicture(const Value: TDrawPicture);
begin
  FWaitDownloadPicture.Assign(Value);
end;




initialization


finalization
  FreeGlobalDownloadPictureManager;


end.


