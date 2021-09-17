//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     链接图片
///   </para>
///   <para>
///     ??
///   </para>
/// </summary>
unit uUrlPicture;



{$I FrameWork.inc}


{$IFDEF FMX}
//是否需要SystemHttpControl,因为有时候会导致单元冲突
//FMX_XE_ConfigDrawPictureSearchPathForm.pas(17):
//F2051 Unit uBaseHttpControl was compiled
//with a different version of System.Net.HttpClientComponent.TNetHTTPClientHelper
{$DEFINE NEED_SystemHttpControl}
{$ENDIF}


interface


uses
  Classes,
  SysUtils,
  IOUtils,
  Math,
  Types,


  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Graphics,
  {$ENDIF}

  MD5_OrangeUI,

  uBinaryTreeDoc,
  uFuncCommon,
  uBaseLog,
  uBaseHttpControl,
  uBaseList,
  DateUtils,
  uBinaryObjectList,
  uTimerTask,
  uFileCommon,
  uSkinPicture;





type
  TDefaultDownloadManager=class;
  TUrlCacheItem=class;
  TUrlPicture=class;


  //下载进度状态
  TDownloadProgressState=(
                          dpsNone,
                          dpsWaitDownload,
                          dpsDownloading,
                          dpsDownloadSucc,
                          dpsDownloadFail,
                          dpsDownloadImageInvalid
                          );



  //下载进度状态通知事件
  TDownloadProgressStateChangeEvent=procedure(Sender:TObject;AUrlCacheItem:TUrlCacheItem) of object;


  TDownloadProgressStateNotifyEventItem=class
  public
    FDataObject:TObject;
    FOnDownloadStateChange:TDownloadProgressStateChangeEvent;
  end;
  TDownloadProgressStateNotifyEventList=class(TBaseList)
  private
    function GetItem(Index: Integer): TDownloadProgressStateNotifyEventItem;
  public
    function Add(ADataObject:TObject;AOnDownloadStateChange:TDownloadProgressStateChangeEvent):TDownloadProgressStateNotifyEventItem;
    procedure Del(ADataObject:TObject);
    property Items[Index:Integer]:TDownloadProgressStateNotifyEventItem read GetItem;default;
  end;






  /// <summary>
  ///   <para>
  ///     链接图片
  ///   </para>
  ///   <para>
  ///     Url picture
  ///   </para>
  /// </summary>
  TUrlCacheItem=class(TBinaryObject)
  private
  protected
    FManager:TDefaultDownloadManager;
    procedure DoNotifyDownloadStateChange(AIsDownloadFinished:Boolean);
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    /// <summary>
    ///   <para>
    ///     GUID,唯一标识(用做文件名)
    ///   </para>
    ///   <para>
    ///     GUID,identification(same as file name)
    ///   </para>
    /// </summary>
    GUID:String;



    /// <summary>
    ///   <para>
    ///     链接
    ///   </para>
    ///   <para>
    ///     Link
    ///   </para>
    /// </summary>
    Url:String;




    /// <summary>
    ///   <para>
    ///     当前状态(等待下载,正在下载,下载失败,内容非法)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    State:TDownloadProgressState;




    /// <summary>
    ///   <para>
    ///     文件后缀名
    ///   </para>
    ///   <para>
    ///     File suffix name
    ///   </para>
    /// </summary>
    FileExt:String;



    /// <summary>
    ///   <para>
    ///     自定义保存的文件路径(自定义保存的文件夹和文件名)
    ///   </para>
    ///   <para>
    ///     File path(can be saved in customized folder and file name)
    ///   </para>
    /// </summary>
    SavedFilePath:String;



    /// <summary>
    ///   <para>
    ///     所关联的DrawPicture列表
    ///   </para>
    ///   <para>
    ///     Associated DrawPicture list
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   多个DrawPicture会使用同一个UrlPicture来显示,UrlPicture下载完成会通知它们进行加载并重绘界面
    ///  Mutiple DrawPicture will use same UrlPicture to display,When UrlPicture finish downloading , it will notify them to load and to redraw interface
    /// </remarks>
//    DrawPictureList:TList;
    FDownloadItemStateNotifyEventList:TDownloadProgressStateNotifyEventList;

//    //是否剪载成圆形
//    FIsClipRound:Boolean;
//    FClipRoundXRadis:Double;
//    FClipRoundYRadis:Double;
//    {$IFDEF FMX}
//    FClipRoundCorners: TCorners;
//    {$ENDIF FMX}


    /// <summary>
    ///   <para>
    ///     附加数据
    ///   </para>
    ///   <para>
    ///     Additional data
    ///   </para>
    /// </summary>
    Data:Pointer;

    DataStr:String;

    //上次使用时间,如果长时间不使用,那么释放
    LastUseTime:TDateTime;
    function IsLoaded:Boolean;virtual;abstract;
    procedure Load;virtual;
//    procedure Init( //链接
//                      const AUrl:String;
//                      //图片
//                      const ADataObject:TObject=nil;
//                      //附加数据
//                      const AData:Pointer=nil;
//                      //图片所保存的文件路径
//                      const ASavedFilePath:String='';
//                      //文件后缀
//                      const AFileExt:String='';
//                      const ALogCaption:String='';
//                      //回调事件
//                      AOnDownloadStateChange:TDownloadProgressStateChangeEvent=nil
////                              //是否剪载成圆形
////                              AIsClipRound:Boolean=False;
////                              AClipRoundXRadis:Double=0;
////                              AClipRoundYRadis:Double=0
//                      );virtual;
  public
    constructor Create(AManager:TDefaultDownloadManager);virtual;
    destructor Destroy;override;
  public
//    procedure DoDrawPictureListChanage(Sender:TObject);
    /// <summary>
    ///   <para>
    ///     源文件路径
    ///   </para>
    ///   <para>
    ///     Original file path
    ///   </para>
    /// </summary>
    function GetOriginFilePath:String;

    procedure DeleteStateNotifyEvent(AOnDownloadStateChange:TDownloadProgressStateChangeEvent);

    /// <summary>
    ///   <para>
    ///     图片下载管理者
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property Manager:TDefaultDownloadManager read FManager;

  end;






  /// <summary>
  ///   <para>
  ///     链接图片列表
  ///   </para>
  ///   <para>
  ///     List of urlpicture
  ///   </para>
  /// </summary>
  TUrlCacheItemList=class(TBinaryObjectList)
  private
//    procedure SetItem(Index:Integer; const Value: TUrlCacheItem);
  protected
    FManager:TDefaultDownloadManager;
    function GetItem(Index:Integer): TUrlCacheItem;

    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
    function CanSaveToDocNode(ABinaryObject:TInterfacedPersistent):Boolean;override;
  public
    function Find(AUrl:String): TUrlCacheItem;
    property Items[Index:Integer]:TUrlCacheItem read GetItem;default;// write SetItem;default;
  end;







  /// <summary>
  ///   <para>
  ///     下载图片失败的事件
  ///   </para>
  ///   <para>
  ///     Event of download picture failed
  ///   </para>
  /// </summary>
  TDownloadItemErrorEvent=procedure(Sender:TObject;AUrlCacheItem:TUrlCacheItem) of object;
  /// <summary>
  ///   <para>
  ///     下载图片成功的事件
  ///   </para>
  ///   <para>
  ///     Event of download pictue succeded
  ///   </para>
  /// </summary>
  TDownloadItemSuccEvent=procedure(Sender:TObject;AUrlCacheItem:TUrlCacheItem) of object;



  TBaseDownloadManager=class(TComponent)
  private
    //分组名称
    FGroupName:String;
  protected
    //设置分组名
    procedure SetGroupName(const Value: String);virtual;abstract;
  public
    function Download( //链接
                      const AUrl:String;
                      //图片
                      const ADrawItem:TObject=nil;
                      //附加数据
                      const AData:Pointer=nil;
                      //图片所保存的文件路径
                      const ASavedFilePath:String='';
                      //文件后缀
                      const AFileExt:String='';
                      const ALogCaption:String='';
                      AOnDownloadStateChange:TDownloadProgressStateChangeEvent=nil;
                      //是否需要检测是否最新
                      AIsNeedCheckNew:Boolean=False
//                              //是否剪载成圆形
//                              AIsClipRound:Boolean=False;
//                              AClipRoundXRadis:Double=0;
//                              AClipRoundYRadis:Double=0
                      ):TUrlCacheItem;virtual;abstract;
    function Find(const AUrl:String):TUrlCacheItem;virtual;abstract;
  published
    /// <summary>
    ///   <para>
    ///     分组名(图片下载到以分组名命名的目录下)(设置之后重新加载缓存)
    ///   </para>
    ///   <para>
    ///     Group name(download picture to directory which is named by GroupName)
    ///   </para>
    /// </summary>
    property GroupName:String read FGroupName write SetGroupName;
  end;








  {$I ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     下载图片管理组件
  ///   </para>
  ///   <para>
  ///     Download picture manage component
  ///   </para>
  /// </summary>
  TDefaultDownloadManager=class(TBaseDownloadManager)
  private
    //下载目录
    FDownloadDir:String;



    //下载线程
    FDownloadItemThread:TTimerThread;




    //下载的链接图片列表
    FUrlCacheItemList:TUrlCacheItemList;



    //下载失败事件
    FOnDownloadError: TDownloadItemErrorEvent;
    //下载成功事件
    FOnDownloadSucc: TDownloadItemSuccEvent;


    //设置下载根目录
    procedure SetDownloadDir(const Value: String);

    //检测图片文件是否存在
    procedure CheckFileExist;


    //下载网络图片
    procedure DoDownloadItem(ATimerTask:TObject);
    procedure DoDownloadItemExecuteEnd(ATimerTask:TObject);


    //通知图片下载结束
    procedure DoDownloadManagerDownloadedEvent(AUrlCacheItem:TUrlCacheItem);
  protected

    //是否需要在线程中加载图片
    FIsLoadItemInThread:Boolean;

    procedure DoCustomDownloadedStream(AUrlCacheItem:TUrlCacheItem;AResponseStream:TStream;var AIsValidResponse:Boolean);virtual;
    procedure DoCustomLoadFromDownloadedStream(AUrlCacheItem:TUrlCacheItem;AResponseStream:TStream;AOriginFilePath:String);virtual;
    //不下载网络图片(用于延迟加载)
    //在线程中加载本地缓存图片
    procedure DoLoadItemInThread(ATimerTask:TObject);virtual;
//    procedure DoLoadPictureInThreadExecuteEnd(ATimerTask:TObject);
    //设置分组名
    procedure SetGroupName(const Value: String);override;
  public
    function CreateUrlCacheItemList:TUrlCacheItemList;virtual;
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public


    //下载图片的Http控件
    FDownloadItemHttpControl:THttpControl;

    /// <summary>
    ///   <para>
    ///     下载网络图片
    ///   </para>
    ///   <para>
    ///     Download url picture
    ///   </para>
    /// </summary>
    /// <param name="Url">
    ///   图片链接
    /// </param>
    /// <param name="DrawPicture">
    ///   所关联的DrawPictureReleated DrawPicture
    /// </param>
    /// <param name="Data">
    ///   附加数据 additional data
    /// </param>
    /// <param name="SavedFilePath">
    ///   图片所保存的文件路径 Picture stored path
    /// </param>
    /// <param name="FileExt">
    ///   文件后缀 File suffix
    /// </param>
    function Download( //链接
                      const AUrl:String;
                      //图片
                      const ADataObject:TObject=nil;
                      //附加数据
                      const AData:Pointer=nil;
                      //图片所保存的文件路径
                      const ASavedFilePath:String='';
                      //文件后缀
                      const AFileExt:String='';
                      const ALogCaption:String='';
                      //回调事件
                      AOnDownloadStateChange:TDownloadProgressStateChangeEvent=nil;
                      //是否需要检测是否最新
                      AIsNeedCheckNew:Boolean=False
//                              //是否剪载成圆形
//                              AIsClipRound:Boolean=False;
//                              AClipRoundXRadis:Double=0;
//                              AClipRoundYRadis:Double=0
                      ):TUrlCacheItem;override;
    //通知UrlPicture的DrawPictureList状态更改
//    procedure DoNotifyDownloadStateChange(AUrlPicture:TUrlPicture);




    /// <summary>
    ///   <para>
    ///     保存含有图片下载历史的数据文件
    ///   </para>
    ///   <para>
    ///     Save data file with downloaded picture history
    ///   </para>
    /// </summary>
    procedure SaveUrlCacheItemListDataFile;

    /// <summary>
    ///   <para>
    ///     下载的链接图片列表
    ///   </para>
    ///   <para>
    ///     downloaded Picture list
    ///   </para>
    /// </summary>
    property UrlCacheItemList:TUrlCacheItemList read FUrlCacheItemList;
    /// <summary>
    ///   <para>
    ///     获取下载目录
    ///   </para>
    ///   <para>
    ///     Get download directory
    ///   </para>
    /// </summary>
    function GetDownloadDir:String;
    /// <summary>
    ///   <para>
    ///     停止下载
    ///   </para>
    ///   <para>
    ///     Stop download
    ///   </para>
    /// </summary>
    procedure StopDownloadItems;
    /// <summary>
    ///   <para>
    ///     查找链接图片
    ///   </para>
    ///   <para>
    ///     Find url picture
    ///   </para>
    /// </summary>
    //function FindUrlPicture(const AUrl:String):TUrlPicture;override;
    function Find(const AUrl:String):TUrlCacheItem;override;
//  public
//    //把本地临时文件保存到缓存中
//    function AddToUrlCacheItemList(//自己指定GUID,可以是文件名,也可以调用CreateGUID
//                              const AGUID:String;
//                              //链接
//                              const AUrl:String;
//                              //图片的文件路径
//                              const ALocalFilePath:String;
//                              //图片所保存的文件路径
//                              const ASavedFilePath:String='';
//                              //文件后缀
//                              const AFileExt:String=''
//                              ):TUrlCacheItem;

  published
    /// <summary>
    ///   <para>
    ///     下载目录(设置之后重新加载缓存)
    ///   </para>
    ///   <para>
    ///     Download directory
    ///   </para>
    /// </summary>
    property DownloadDir:String read FDownloadDir write SetDownloadDir;


    /// <summary>
    ///   <para>
    ///     下载失败事件
    ///   </para>
    ///   <para>
    ///     Event of download failed
    ///   </para>
    /// </summary>
    property OnDownloadError:TDownloadItemErrorEvent read FOnDownloadError write FOnDownloadError;
    /// <summary>
    ///   <para>
    ///     下载成功事件
    ///   </para>
    ///   <para>
    ///     Event of download succeed
    ///   </para>
    /// </summary>
    property OnDownloadSucc:TDownloadItemSuccEvent read FOnDownloadSucc write FOnDownloadSucc;
  end;





  TUrlPicture=class(TUrlCacheItem)
  public
    /// <summary>
    ///   <para>
    ///     原图片
    ///   </para>
    ///   <para>
    ///     Original picture
    ///   </para>
    /// </summary>
    Picture:TSkinPicture;
    ClipRoundPicture:TSkinPicture;

    //加载图片
    function IsLoaded:Boolean;override;
    procedure LoadPictureDownloaded;
    procedure LoadPictureDownloadedStream(AStream:TStream);
  public
    destructor Destroy;override;
  end;




  TUrlPictureList=class(TUrlCacheItemList)
  private
    function GetItem(Index:Integer): TUrlPicture;
//    procedure SetItem(Index:Integer; const Value: TUrlCacheItem);
  protected
    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
  public
    property Items[Index:Integer]:TUrlPicture read GetItem;default;// write SetItem;default;
  end;






  TBaseDownloadPictureManager=class(TDefaultDownloadManager)
  private
    //决定保存成什么后缀
    procedure DoCustomDownloadedStream(AUrlCacheItem:TUrlCacheItem;AResponseStream:TStream;var AIsValidResponse:Boolean);override;
    procedure DoCustomLoadFromDownloadedStream(AUrlCacheItem:TUrlCacheItem;AResponseStream:TStream;AOriginFilePath:String);override;
    //不下载网络图片(用于延迟加载)
    procedure DoLoadItemInThread(ATimerTask:TObject);override;
  public
    function CreateUrlCacheItemList:TUrlCacheItemList;override;
    //释放超过几秒没有再使用过的图片
    procedure FreeNoUsePicture(ASecondsBetween:Integer);
    /// <summary>
    ///   <para>
    ///     查找链接图片
    ///   </para>
    ///   <para>
    ///     Find url picture
    ///   </para>
    /// </summary>
    //function FindUrlPicture(const AUrl:String):TUrlPicture;override;
    function FindUrlPicture(const AUrl:String):TUrlPicture;
    function DownloadPicture( //链接
                              const AUrl:String;
                              //图片
                              const ADrawPicture:TObject=nil;
                              //附加数据
                              const AData:Pointer=nil;
                              //图片所保存的文件路径
                              const ASavedFilePath:String='';
                              //文件后缀
                              const AFileExt:String='';
                              //
                              const ALogCaption:String='';
                              //
                              AOnDownloadStateChange:TDownloadProgressStateChangeEvent=nil;
                              //是否需要检测是否最新
                              AIsNeedCheckNew:Boolean=False
//                              //是否剪载成圆形
//                              AIsClipRound:Boolean=False;
//                              AClipRoundXRadis:Double=0;
//                              AClipRoundYRadis:Double=0
                              ):TUrlPicture;
  end;
  TDefaultDownloadPictureManager=class(TBaseDownloadPictureManager)
  end;


























var
  /// <summary>
  ///   <para>
  ///     图片下载所使用的Http控件类(没有用)
  ///   </para>
  ///   <para>
  ///     Used Http control class when download picture
  ///   </para>
  /// </summary>
  DownloadItemHttpControlClass:THttpControlClass;




implementation




uses
//  uDownloadItemManager,
//  uDrawEngine,
  uDrawPicture;


{ TDefaultDownloadManager }

//function TDefaultDownloadManager.AddToUrlCacheItemList(
//  const AGUID,
//  AUrl,
//  ALocalFilePath,
//  ASavedFilePath,
//  AFileExt: String):TUrlCacheItem;
//var
//  AFileName:String;
//  ADestFileName:String;
//begin
//
//  //如AFilePath:=C:\Users\Administrator\Documents\8F898D2E3D154C53A3E77E4E2C934670.jpg
//
//  //先判断有无下载好的
//  Result:=Find(AUrl);
//
//
//  if (Result=nil) then
//  begin
//    //此链接无缓存
//
//
//    //8F898D2E3D154C53A3E77E4E2C934670.jpg
//    AFileName:=ExtractFileName(ALocalFilePath);
//
//
//    //判断文件是否已经存在于缓存目录
//    if Not FileExists(Self.GetDownloadDir+AFileName) then
//    begin
//
//      //把本地文件移动到缓存目录
//      IOUtils.TFile.Move(ALocalFilePath,Self.GetDownloadDir+AFileName);
//
//      //移动成功
//      if FileExists(Self.GetDownloadDir+AFileName) then
//      begin
//
//          //添加到缓存列表
//          Result:=TUrlCacheItem.Create(Self);
//          Result.GUID:=AGUID;
//          Result.Url:=AUrl;
//          Result.SavedFilePath:=ASavedFilePath;
//          Result.FileExt:=AFileExt;
//
//          Result.State:=dpsDownloadSucc;
//          Self.FUrlCacheItemList.Add(Result);
//
//      end;
//
//    end;
//
//  end;
//
//end;

procedure TDefaultDownloadManager.CheckFileExist;
var
  I: Integer;
begin
  for I := Self.FUrlCacheItemList.Count-1 downto 0 do
  begin
    if Not FileExists(Self.FUrlCacheItemList[I].GetOriginFilePath) then
    begin
//      uBaseLog.OutputDebugString(Self.FUrlCacheItemList[I].GetOriginFilePath+' Not Exists!');
      Self.FUrlCacheItemList.Delete(I);
    end;
  end;
end;

constructor TDefaultDownloadManager.Create(AOwner:TComponent);
begin
  Inherited;


  //创建下载线程
  FDownloadItemThread:=TTimerThread.Create(False);
//  //延时低一点
//  FDownloadItemThread.TaskSleep:=10;

  if DownloadItemHttpControlClass=nil then
  begin
    raise Exception.Create('DownloadItemHttpControlClass can not be nil');
    Exit;
  end;

  FDownloadItemHttpControl:=//TSystemHttpControl.Create;
          //建议在这里使用DownloadItemHttpControlClass,以便后面可以扩展,
          //如使用IdHttp可以跟踪到下载进度
          DownloadItemHttpControlClass.Create;


  //设置图片分组名称的初始值
  FGroupName:=CreateGUIDString;


  FUrlCacheItemList:=CreateUrlCacheItemList;
  FUrlCacheItemList.FManager:=Self;



  FIsLoadItemInThread:=True;
end;

function TDefaultDownloadManager.CreateUrlCacheItemList: TUrlCacheItemList;
begin
  Result:=TUrlCacheItemList.Create;
end;

destructor TDefaultDownloadManager.Destroy;
begin
  //保存图片下载历史数据文件
  SaveUrlCacheItemListDataFile;


  try
    //下载控件
    FreeAndNil(FDownloadItemHttpControl);
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'Base','uUrlPicture','TDefaultDownloadManager.Destroy FreeAndNil(FDownloadItemHttpControl)');
    end;
  end;

  try
    //下载线程
    FDownloadItemThread.Terminate;
    FDownloadItemThread.WaitFor;
    FreeAndNil(FDownloadItemThread);
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'Base','uUrlPicture','TDefaultDownloadManager.Destroy FreeAndNil(FDownloadItemThread)');
    end;
  end;

  //图片列表
  FreeAndNil(FUrlCacheItemList);

  inherited;
end;

procedure TDefaultDownloadManager.DoCustomDownloadedStream(
  AUrlCacheItem: TUrlCacheItem; AResponseStream: TStream;var AIsValidResponse:Boolean);
begin

end;

procedure TDefaultDownloadManager.DoCustomLoadFromDownloadedStream(
  AUrlCacheItem:TUrlCacheItem;AResponseStream: TStream;AOriginFilePath:String);
begin

end;

procedure TDefaultDownloadManager.DoDownloadItem(ATimerTask: TObject);
var
  AUrlCacheItem:TUrlCacheItem;
  AResponseStream:TStream;
  AIsValidResponse:Boolean;
begin
  //如果DownloadItemManager释放,FDownloadItemThread会为nil
  if FDownloadItemThread=nil then Exit;


  //下载图片
  AUrlCacheItem:=TUrlCacheItem(TTimerTask(ATimerTask).TaskObject);




  //使用内存流
  AResponseStream:=TMemoryStream.Create;
  try


      //标记正在下载
      AUrlCacheItem.State:=dpsDownloading;


      //刷新DrawPicture,线程里面不能通知
//      DoDrawPictureListChanage(AUrlCacheItem);


      //下载图片
      if FDownloadItemHttpControl.Get(AUrlCacheItem.Url,AResponseStream) then
      begin
//          uBaseLog.OutputDebugString('TDefaultDownloadManager.DownloadItem 下载成功');


              //保存成文件



//              try

                //决定使用什么图片文件后缀
                AIsValidResponse:=True;
                DoCustomDownloadedStream(AUrlCacheItem,AResponseStream,AIsValidResponse);

                //如果不是图片,则算下载失败

                if AIsValidResponse then
                begin
                  //保存原图,直接使用文件流
                  AResponseStream.Position:=0;
                  //保存原图
                  //创建目录
                  CreateFileDir(AUrlCacheItem.GetOriginFilePath);
                  TMemoryStream(AResponseStream).SaveToFile(AUrlCacheItem.GetOriginFilePath);


                  AUrlCacheItem.State:=dpsDownloadSucc;



                  //wn
                  AResponseStream.Position:=0;

                  DoCustomLoadFromDownloadedStream(AUrlCacheItem,AResponseStream,AUrlCacheItem.GetOriginFilePath);

                end;

//              except
//                on E:Exception do
//                begin
//                  uBaseLog.HandleException(E,'TDefaultDownloadManager.DownloadItem SaveToFile');
//                end;
//              end;



//            //刷新DrawPicture,线程里面不能通知
//          DoDrawPictureListChanage(AUrlCacheItem);

      end
      else
      begin
          //下载失败
          AUrlCacheItem.State:=dpsDownloadFail;

          //下载失败的原因,是否需要重新下载
          //uBaseLog.OutputDebugString('TDefaultDownloadManager.DownloadItem 下载失败');


          //刷新DrawPicture
  //        DoDrawPictureListChanage(AUrlCacheItem);

      end;


  finally
    FreeAndNil(AResponseStream);
  end;



  //最后一个图片文件下载完成,需要保存一下临时文件
  if (FDownloadItemThread<>nil)
    and (FDownloadItemThread.TimerTaskList.Count=0) then
  begin
      SaveUrlCacheItemListDataFile;
  end;

end;


procedure TDefaultDownloadManager.DoLoadItemInThread(ATimerTask: TObject);
begin
end;

procedure TDefaultDownloadManager.DoDownloadItemExecuteEnd(ATimerTask: TObject);
var
  AUrlCacheItem:TUrlCacheItem;
  AOldUrlCacheItem:TUrlCacheItem;
begin
  //下载结束
  AUrlCacheItem:=TUrlCacheItem(TTimerTask(ATimerTask).TaskObject);


  //加载
  if (AUrlCacheItem.State=dpsDownloadSucc) and (not AUrlCacheItem.IsLoaded) then
  begin
    AUrlCacheItem.Load;
  end;





  if TTimerTask(ATimerTask).TaskOtherInfo.Values['IsCheckNew']='1' then
  begin


    AOldUrlCacheItem:=Self.FUrlCacheItemList.Find(AUrlCacheItem.Url);
    //判断内容是否一致
    if not MD5Match(MD5File(AOldUrlCacheItem.GetOriginFilePath),MD5File(AUrlCacheItem.GetOriginFilePath)) then
    begin
      Self.FUrlCacheItemList.Remove(AOldUrlCacheItem);
      Self.FUrlCacheItemList.Add(AUrlCacheItem);

      SaveUrlCacheItemListDataFile;
    end;

  end;




  //通知DrawPicture列表
  //uBaseLog.OutputDebugString('TDefaultDownloadManager.DownloadItem 通知对象 个数'+IntToStr(AUrlCacheItem.DrawPictureList.Count));
  AUrlCacheItem.DoNotifyDownloadStateChange(True);



  //调用DownloadItemManager的下载结束事件
  DoDownloadManagerDownloadedEvent(AUrlCacheItem);


end;


//procedure TDefaultDownloadManager.DoLoadPictureInThreadExecuteEnd(ATimerTask: TObject);
//var
//  I:Integer;
//  AUrlPicture:TUrlPicture;
//  ADrawPicture:TDrawPicture;
//begin
//  //下载结束
//  AUrlPicture:=TUrlPicture(TTimerTask(ATimerTask).TaskObject);
//
//
//  //通知DrawPicture列表
//  //uBaseLog.OutputDebugString('TDefaultDownloadManager.DownloadItem 通知对象 个数'+IntToStr(AUrlPicture.DrawPictureList.Count));
//  for I := 0 to AUrlPicture.DrawPictureList.Count-1 do
//  begin
//    //判断图片没有被释放
//    ADrawPicture:=TDrawPicture(AUrlPicture.DrawPictureList[I]);
//
//    //其实,如果图片没有正在被绘制,是不需要通知它们加载的
//    ADrawPicture.DoUrlPictureDownloaded(AUrlPicture);
//  end;
//
//
//end;
//
//
//procedure TDefaultDownloadManager.DoNotifyDownloadStateChange(AUrlPicture:TUrlPicture);
//var
//  I: Integer;
//  ADrawPicture:TDrawPicture;
//begin
//
//    for I := 0 to AUrlPicture.DrawPictureList.Count-1 do
//    begin
//      //判断图片没有被释放
//      ADrawPicture:=TDrawPicture(AUrlPicture.DrawPictureList[I]);
//
//      //加载过了就不需要再加载了
//
//      try
//          //其实,如果图片没有正在被绘制,是不需要通知它们加载的
//          //也就是将图片文件加载到AUrlPicture.Picture
//          ADrawPicture.LoadDownloadedUrlPicture(AUrlPicture);
//      except
//        on E:Exception do
//        begin
//          uBaseLog.HandleException(E,'TDefaultDownloadManager.DoNotifyDownloadStateChange ADrawPicture.DoUrlPictureDownloaded');
//        end;
//      end;
//
//
//    end;
//
//end;

procedure TDefaultDownloadManager.DoDownloadManagerDownloadedEvent(AUrlCacheItem: TUrlCacheItem);
begin
  //uBaseLog.OutputDebugString('TDefaultDownloadManager.DownloadItem 下载结束 ');

  try
    if AUrlCacheItem.State=dpsDownloadSucc then
    begin
        //通知下载成功
        if Assigned(Self.FOnDownloadSucc) then
        begin
          Self.FOnDownloadSucc(Self,AUrlCacheItem);
        end;
    end
    else
    begin
        //通知下载失败
        if Assigned(FOnDownloadError) then
        begin
          FOnDownloadError(Self,AUrlCacheItem);
        end;
    end;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'TDefaultDownloadManager.DoDownloadManagerDownloadedEvent ');
    end;
  end;

end;

procedure TDefaultDownloadManager.SaveUrlCacheItemListDataFile;
begin
//  uBaseLog.OutputDebugString('TDefaultDownloadManager.SaveUrlCacheItemListDataFile '
//                            +GetDownloadDir+'UrlCacheItemList.dat '
//                            +'FUrlCacheItemList.Count:'+IntToStr(FUrlCacheItemList.Count));

//  try
    //保存下载的图片列表数据
    CreateFileDir(GetDownloadDir+'UrlCacheItemList.dat');
    FUrlCacheItemList.SaveToFile(GetDownloadDir+'UrlCacheItemList.dat');
//  except
//    on E:Exception do
//    begin
//      uBaseLog.HandleException(E,'TDefaultDownloadManager.SaveUrlCacheItemListDataFile ');
//    end;
//  end;
end;

procedure TDefaultDownloadManager.SetDownloadDir(const Value: String);
begin
  if FDownloadDir<>Value then
  begin
    FDownloadDir := Value;

    if FileExists(GetDownloadDir+'UrlCacheItemList.dat') then
    begin

//      try
        FUrlCacheItemList.LoadFromFile(GetDownloadDir+'UrlCacheItemList.dat');
        CheckFileExist;
//      except
//        on E:Exception do
//        begin
//          uBaseLog.HandleException(E,'TDefaultDownloadManager.SetGroupName Load '+GetDownloadDir+'UrlCacheItemList.dat');
//        end;
//      end;

    end;

  end;
end;

procedure TDefaultDownloadManager.SetGroupName(const Value: String);
begin
  if (FGroupName<>Value) and (Trim(Value)<>'') then
  begin
    FGroupName := Value;

    //uBaseLog.OutputDebugString('TDefaultDownloadManager.SetGroupName '+GetDownloadDir+'UrlCacheItemList.dat');


    if FileExists(GetDownloadDir+'UrlCacheItemList.dat') then
    begin
//      uBaseLog.OutputDebugString('TDefaultDownloadManager.SetGroupName Load '+GetDownloadDir+'UrlCacheItemList.dat');
//
//      try
        FUrlCacheItemList.LoadFromFile(GetDownloadDir+'UrlCacheItemList.dat');
        CheckFileExist;
//      except
//        on E:Exception do
//        begin
//          uBaseLog.HandleException(E,'TDefaultDownloadManager.SetGroupName Load '+GetDownloadDir+'UrlCacheItemList.dat');
//        end;
//      end;

    end;

  end;
end;

procedure TDefaultDownloadManager.StopDownloadItems;
begin
  try
    if FDownloadItemThread<>nil then
    begin
      FDownloadItemThread.TimerTaskList.Clear(True);
    end;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'Main','uInterfaceManager','StopDownloadItems 停止下载图片');
    end;
  end;
end;

function TDefaultDownloadManager.Download(const AUrl:String;
                                          const ADataObject:TObject;
                                          const AData:Pointer;
                                          const ASavedFilePath:String;
                                          const AFileExt:String;
                                          const ALogCaption:String;
                                          //回调事件
                                          AOnDownloadStateChange:TDownloadProgressStateChangeEvent;
                                          //
                                          AIsNeedCheckNew:Boolean
//                                                      //是否剪载成圆形
//                                                      AIsClipRound:Boolean;
//                                                      AClipRoundXRadis:Double;
//                                                      AClipRoundYRadis:Double
                                          ):TUrlCacheItem;
var
  ATimerTask:TTimerTask;
  AIsNeedReDownload:Boolean;
begin
  Result:=nil;


  if (AUrl='') then Exit;



//  uBaseLog.OutputDebugString('TDefaultDownloadManager.DownloadItem 开始 '+AUrl);

//  if (Self.FGroupName='') then
//  begin
//    ShowException('Please Set TDefaultDownloadManager.GroupName!');
//  end;



  ATimerTask:=nil;
  AIsNeedReDownload:=False;

  //先判断有无下载好的
  Result:=Find(AUrl);



  if (Result<>nil) then
  begin
        //别的DrawPicture也使用该url,未下载\正在下载或者已经下载完



        //已经下载好了,但还没有加载，放在线程中加载，防止卡顿
        if (Result.State=dpsDownloadSucc)
              and FileExists(Result.GetOriginFilePath)
              and (Result.IsLoaded)

              then
        begin
            uBaseLog.OutputDebugString('TDefaultDownloadManager.DownloadItem '+ALogCaption+' 已下载成功 直接加载 '+AUrl);
            if Assigned(AOnDownloadStateChange) then
            begin
              AOnDownloadStateChange(Result,Result);
            end;
            Exit;

        end;





        //添加到需要通知的DrawPicture图片列表
  //      if (ADrawPicture<>nil) and (Result.DrawPictureList.IndexOf(ADrawPicture)=-1) then
  //      begin
  //        Result.DrawPictureList.Add(ADrawPicture);
  //      end;
         //添加事件通知
         if Assigned(AOnDownloadStateChange) then
         begin
           Result.FDownloadItemStateNotifyEventList.Add(ADataObject,AOnDownloadStateChange);
         end;
       





  //      if
  //           //如果没有下载成功,那么重试下载
  //           (Result.State=dpsDownloadFail)
  //        or (Result.State=dpsDownloadImageInvalid)
  //
  //        //如果下载成功,但是文件被删除了,也需要重新下载
  //        or (Result.State=dpsDownloadSucc) and Not FileExists(Result.GetOriginFilePath) then
  //      begin
  //
  //
  //
  //          uBaseLog.OutputDebugString('TDefaultDownloadManager.DownloadItem '+ALogCaption+' Has not Downloaded 尚未下载 '+AUrl);
  //          uBaseLog.OutputDebugString('TDefaultDownloadManager.DownloadItem '+ALogCaption+' 准备下载 '+AUrl);
  //
  //
  //          //执行下载线程
  //          ATimerTask:=TTimerTask.Create(0);
  //          ATimerTask.TaskName:='DownloadItem';
  //
  //          Result.State:=dpsWaitDownload;
  //          Result.Data:=AData;
  //          Result.LastUseTime:=Now;
  //
  //
  //
  //          //下载图片
  //          ATimerTask.OnExecute:=Self.DoDownloadItem;
  //          ATimerTask.OnExecuteEnd:=Self.DoDownloadItemExecuteEnd;
  //
  //          ATimerTask.TaskObject:=Result;
  //
  //
  //
  //      end






        //已经下载好了,但还没有加载，放在线程中加载，防止卡顿
  //      else
       if (Result.State=dpsDownloadSucc)
              and FileExists(Result.GetOriginFilePath)
              //已经下载好了,但还没有加载，放在线程中加载，防止卡顿
              and not (Result.IsLoaded)//为了让DrawPicture都响应一下DoDownloadItemExecuteEnd
              then
        begin
            uBaseLog.OutputDebugString('TDefaultDownloadManager.DownloadItem '+ALogCaption+' LastTime Download Succ 上次下载成功 直接在线程中从文件加载 '+AUrl);


            //Result.State:=dpsWaitDownload;
            Result.Data:=AData;
            Result.LastUseTime:=Now;


            //延时加载,如果DrawPicture绘制的时候，图片下载成功，不直接加载
            //图片加载多的时候，不会造成卡顿
            ATimerTask:=TTimerTask.Create(0);
            ATimerTask.TaskName:='LoadItem';

            //不用下载图片,而是在线程中加载
            ATimerTask.OnExecute:=Self.DoLoadItemInThread;
            ATimerTask.OnExecuteEnd:=Self.DoDownloadItemExecuteEnd;

            ATimerTask.TaskObject:=Result;



            if not FIsLoadItemInThread then
            begin
              DoLoadItemInThread(ATimerTask);
              DoDownloadItemExecuteEnd(ATimerTask);
              FreeAndNil(ATimerTask);
            end;



            //第一次加载需要
            //检测更新
            if AIsNeedCheckNew then
            begin
              AIsNeedReDownload:=True;
            end;




  //          //不延时加载,如果DrawPicture绘制的时候，图片下载成功，直接加载
  //          //但是图片加载多的时候，会造成卡顿
  //          DoNotifyDownloadStateChange(Result);
  //
  //          //不赋值,也就是不执行下载,图片文件已经存在
  //          Self.DoDownloadManagerDownloadedEvent(Result);


            if ATimerTask<>nil then
            begin
              FDownloadItemThread.RunTask(ATimerTask);
            end;


        end
        else
        begin
            uBaseLog.OutputDebugString('TDefaultDownloadManager.DownloadItem '+ALogCaption+' 正在下载中... '+AUrl);
            //正在下载,或者已经下载并加载完成
            Exit;
        end;


  end
  else
  begin
        //没有下载过
        AIsNeedReDownload:=True;
  end;




  if AIsNeedReDownload then
  begin
        uBaseLog.OutputDebugString('TDefaultDownloadManager.DownloadItem '+ALogCaption+' Has not Downloaded 尚未下载 '+AUrl);


        //执行下载线程
        ATimerTask:=TTimerTask.Create(0);
        ATimerTask.TaskName:='DownloadItem';


        if Result<>nil then
        begin
          ATimerTask.TaskOtherInfo.Values['IsCheckNew']:='1';
        end;


        //Result:=TUrlPicture.Create(Self);
        Result:=TUrlCacheItem(Self.FUrlCacheItemList.CreateBinaryObject);
        Result.GUID:=CreateGUIDString;
        Result.Url:=AUrl;
        Result.SavedFilePath:=ASavedFilePath;
        Result.FileExt:=AFileExt;
        Result.LastUseTime:=Now;


        //后缀为空
        if AFileExt='' then
        begin
            //取Url的后缀
            Result.FileExt:=ExtractFileExt(AUrl);
            //判断后缀是否合法
            if GetValidFileName(Result.FileExt)<>Result.FileExt then
            begin
              //默认后缀
              Result.FileExt:='.png';
            end;
        end;

        Result.State:=dpsWaitDownload;
        Result.Data:=AData;




        if ATimerTask.TaskOtherInfo.Values['IsCheckNew']<>'1' then
        begin
          //更新暂不添加到列表
          Self.FUrlCacheItemList.Add(Result);
        end;





        //下载图片
        ATimerTask.OnExecute:=Self.DoDownloadItem;
        ATimerTask.OnExecuteEnd:=Self.DoDownloadItemExecuteEnd;

        ATimerTask.TaskObject:=Result;



//        //添加到需要通知的图片列表
//        if (ADrawPicture<>nil) and (Result.DrawPictureList.IndexOf(ADrawPicture)=-1) then
//        begin
//          Result.DrawPictureList.Add(ADrawPicture);
//        end;
        if Assigned(AOnDownloadStateChange) then
        begin
          Result.FDownloadItemStateNotifyEventList.Add(ADataObject,AOnDownloadStateChange);
        end;



        if ATimerTask<>nil then
        begin
          FDownloadItemThread.RunTask(ATimerTask);
        end;

  end;









//  //刷新DrawPicture
//  //Change->WebUrlPicture->DownloadItem->Change死循环了
//  DoDrawPictureListChanage(Result);



end;

function TDefaultDownloadManager.Find(const AUrl: String): TUrlCacheItem;
var
  I:Integer;
begin
  Result:=nil;
  for I := Self.FUrlCacheItemList.Count-1 downto 0 do
  begin
    if SameText(Self.FUrlCacheItemList[I].Url,AUrl) then
    begin
      Result:=FUrlCacheItemList[I];
      Result.LastUseTime:=Now;
      //已经找到了,正在下载或下载结束,那么退出
      Exit;
    end;
  end;
end;

function TDefaultDownloadManager.GetDownloadDir: String;
begin
  if FDownloadDir='' then
  begin

//    if (Self.FGroupName='') then
//    begin
//      ShowException('Please Set TDefaultDownloadManager.GroupName!');
//    end;

    Result:=GetApplicationPath+'OrangeUIDownloadItems'+PathDelim+FGroupName+PathDelim;
  end
  else
  begin
    Result:=FDownloadDir;
  end;
end;






{ TUrlCacheItem }

constructor TUrlCacheItem.Create(AManager:TDefaultDownloadManager);
begin


  FManager:=AManager;

//  DrawPictureList:=TList.Create;
  FDownloadItemStateNotifyEventList:=TDownloadProgressStateNotifyEventList.Create();



  //GUID
  GUID:='';
  //链接
  Url:='';


  State:=dpsNone;

//  //图片
//  Picture:=nil;

end;

procedure TUrlCacheItem.DeleteStateNotifyEvent(AOnDownloadStateChange: TDownloadProgressStateChangeEvent);
begin

end;

destructor TUrlCacheItem.Destroy;
begin


//  FreeAndNil(DrawPictureList);
  FreeAndNil(FDownloadItemStateNotifyEventList);

  inherited;
end;

//procedure TUrlPicture.DoDrawPictureListChanage(Sender: TObject);
//var
//  I: Integer;
//  ADrawPicture:TDrawPicture;
//begin
//  for I := 0 to Self.DrawPictureList.Count-1 do
//  begin
//    //判断图片没有被释放
//    ADrawPicture:=TDrawPicture(Self.DrawPictureList[I]);
//
//    try
//        //其实,如果图片没有正在被绘制,是不需要通知它们加载的
//        ADrawPicture.DoChange;
//    except
//      on E:Exception do
//      begin
//        uBaseLog.HandleException(E,'TUrlPicture.DoDrawPictureListChanage ADrawPicture.DoChange');
//      end;
//    end;
//  end;
//
//end;

function TUrlCacheItem.GetOriginFilePath: String;
begin
  if SavedFilePath<>'' then
  begin
    Result:=SavedFilePath;
  end
  else
  begin
    Result:=Self.FManager.GetDownloadDir+GUID+FileExt;
  end;
end;

//procedure TUrlCacheItem.Init(const AUrl: String; const ADataObject: TObject;
//  const AData: Pointer; const ASavedFilePath, AFileExt, ALogCaption: String;
//  AOnDownloadStateChange: TDownloadProgressStateChangeEvent);
//begin
//
//end;

procedure TUrlCacheItem.Load;
begin

end;

function TUrlCacheItem.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I:Integer;
  ABTNode:TBTNode20;
begin
//  uBaseLog.OutputDebugString('TUrlPicture.LoadFromDocNode Begin');
  Result:=False;


  State:=dpsDownloadSucc;



  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];



    if ABTNode.NodeName='GUID' then
    begin
      GUID:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Url' then
    begin
      Url:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='FileExt' then
    begin
      FileExt:=ABTNode.ConvertNode_WideString.Data;
//      uBaseLog.OutputDebugString('TUrlPicture.LoadFromDocNode FileExt:'+FileExt);
    end
    else if ABTNode.NodeName='SavedFilePath' then
    begin
      SavedFilePath:=ABTNode.ConvertNode_WideString.Data;

//      uBaseLog.OutputDebugString('TUrlPicture.LoadFromDocNode SavedFilePath:'+SavedFilePath);
    end
    ;

  end;


  Result:=True;
//  uBaseLog.OutputDebugString('TUrlPicture.LoadFromDocNode End');
end;



procedure TUrlCacheItem.DoNotifyDownloadStateChange(AIsDownloadFinished:Boolean);
var
  I: Integer;
  //ADrawPicture:TDrawPicture;
begin

    for I := Self.FDownloadItemStateNotifyEventList.Count-1 downto 0 do
    begin
      //判断图片没有被释放
      //ADrawPicture:=TDrawPicture(AUrlPicture.DrawPictureList[I]);

      //加载过了就不需要再加载了

      try
          //其实,如果图片没有正在被绘制,是不需要通知它们加载的
          //也就是将图片文件加载到AUrlPicture.Picture
          FDownloadItemStateNotifyEventList[I].FOnDownloadStateChange(Self,Self);

          if AIsDownloadFinished then
          begin
            FDownloadItemStateNotifyEventList.Delete(I);
          end;

      except
        on E:Exception do
        begin
          uBaseLog.HandleException(E,'TDefaultDownloadManager.DoNotifyDownloadStateChange ADrawPicture.DoUrlPictureDownloaded');
        end;
      end;

    end;

end;


function TUrlCacheItem.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
//  uBaseLog.OutputDebugString('TUrlPicture.SaveToDocNode Begin');


  Result:=False;

  //保存类类型
  ADocNode.ClassName:='TUrlCacheItem';




  //保存名称
  ABTNode:=ADocNode.AddChildNode_WideString('GUID');//,'');
  ABTNode.ConvertNode_WideString.Data:=GUID;

  ABTNode:=ADocNode.AddChildNode_WideString('Url');//,'');
  ABTNode.ConvertNode_WideString.Data:=Url;

  ABTNode:=ADocNode.AddChildNode_WideString('FileExt');//,'');
  ABTNode.ConvertNode_WideString.Data:=FileExt;




  if SavedFilePath<>'' then
  begin
    ABTNode:=ADocNode.AddChildNode_WideString('SavedFilePath');//,'');
    ABTNode.ConvertNode_WideString.Data:=SavedFilePath;
  end;
//  uBaseLog.OutputDebugString('TUrlPicture.SaveToDocNode SavedFilePath:'+SavedFilePath+' FileExt:'+FileExt);



  Result:=True;

//  uBaseLog.OutputDebugString('TUrlPicture.SaveToDocNode End');
end;


{ TUrlPicture }

procedure TUrlPicture.LoadPictureDownloadedStream(AStream: TStream);
begin


  //用到的时候再加载
  if //(Self.State=dpsDownloadSucc)
      //文件没有加载过
      //and
      (Self.Picture=nil)//万一Url换了呢?
      //如果下载成功
      //文件存在,而且文件内容大于0
      and FileExists(Self.GetOriginFilePath)
    then
  begin
        //加载图片
//        Self.Picture:=uDrawEngine.CreateCurrentEngineSkinPicture;
        Self.Picture:=TSkinPicture.Create;
        Self.Picture.DirectLoadFromStream(AStream);

  end;


end;


destructor TUrlPicture.Destroy;
begin
  FreeAndNil(Picture);
  FreeAndNil(ClipRoundPicture);

  inherited;
end;

function TUrlPicture.IsLoaded: Boolean;
begin
  Result:=(Picture<>nil);
end;

procedure TUrlPicture.LoadPictureDownloaded;
begin
  //用到的时候再加载
  if //(Self.State=dpsDownloadSucc)
      //文件没有加载过
      //and
      (Self.Picture=nil)//万一Url换了呢?
      //如果下载成功
      //文件存在,而且文件内容大于0
      and FileExists(Self.GetOriginFilePath)
    then
  begin
        //加载图片
//        Self.Picture:=uDrawEngine.CreateCurrentEngineSkinPicture;
        Self.Picture:=TSkinPicture.Create;

//            if IsCheckGIFWhenLoad then
//            begin
//                //检查是否是GIF图片
//                //检查是否是GIF,会比较耗时
//                Self.Picture.LoadFromFile(Self.GetOriginFilePath);
//
//            end
//            else
//            begin

                //不检查是否是GIF图片,直接加载
                Self.Picture.DirectLoadFromFile(Self.GetOriginFilePath);


//                {$IFDEF FMX}
//                //剪裁成圆形
//                if Self.FIsClipRound then
//                begin
//                  AUrlPicture.ClipRoundPicture:=RoundSkinPicture(AUrlPicture.Picture,
//                                                                  Self.FClipRoundXRadis,
//                                                                  Self.FClipRoundYRadis,
//                                                                  Self.FClipRoundCorners);
//                end;
//                {$ENDIF FMX}
//
//
//                //加载下载的图片到自己
//                if IsLoadUrlPictureToSelf then
//                begin
//                  Self.DirectLoadFromFile(AUrlPicture.GetOriginFilePath);
//                end;

//            end;
  end;
end;


{ TUrlCacheItemList }

function TUrlCacheItemList.CanSaveToDocNode(ABinaryObject: TInterfacedPersistent): Boolean;
begin
  Result:=(TUrlCacheItem(ABinaryObject).State=dpsDownloadSucc);
end;

function TUrlCacheItemList.CreateBinaryObject(const AClassName:String=''): TInterfacedPersistent;
begin
  Result:=TUrlCacheItem.Create(FManager);
end;

function TUrlCacheItemList.Find(AUrl: String): TUrlCacheItem;
var
  I:Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if SameText(Self[I].Url,AUrl) then
    begin
      Result:=Items[I];
      Result.LastUseTime:=Now;
      //已经找到了,正在下载或下载结束,那么退出
      Exit;
    end;
  end;
end;

function TUrlCacheItemList.GetItem(Index:Integer): TUrlCacheItem;
begin
  Result:=TUrlCacheItem(Inherited Items[Index]);
end;

//procedure TUrlCacheItemList.SetItem(Index:Integer; const Value: TUrlCacheItem);
//begin
//  Inherited Items[Index]:=Value;
//end;



{ TDownloadProgressStateNotifyEventList }

function TDownloadProgressStateNotifyEventList.Add(ADataObject:TObject;AOnDownloadStateChange:TDownloadProgressStateChangeEvent):TDownloadProgressStateNotifyEventItem;
begin
  //
  Result:=TDownloadProgressStateNotifyEventItem.Create;
  Result.FDataObject:=ADataObject;
  Result.FOnDownloadStateChange:=AOnDownloadStateChange;
  Inherited Add(Result);
end;

procedure TDownloadProgressStateNotifyEventList.Del(ADataObject:TObject);
var
  I: Integer;
begin
  for I := 0 to Self.Count-1 do
  begin
    if Items[I].FDataObject=ADataObject then
    begin
      Delete(I);
      Exit;
    end;
  end;
end;

function TDownloadProgressStateNotifyEventList.GetItem(
  Index: Integer): TDownloadProgressStateNotifyEventItem;
begin
  Result:=TDownloadProgressStateNotifyEventItem(Inherited Items[Index]);
end;


{ TBaseDownloadPictureManager }

function TBaseDownloadPictureManager.CreateUrlCacheItemList: TUrlCacheItemList;
begin
  Result:=TUrlPictureList.Create;
end;

procedure TBaseDownloadPictureManager.DoCustomDownloadedStream(
  AUrlCacheItem: TUrlCacheItem; AResponseStream: TStream;var AIsValidResponse:Boolean);
var
  AFileHeaderBytes:Array [0..4] of Byte;
begin
  AIsValidResponse:=True;

  AResponseStream.Position:=0;

  //下载成功
  AResponseStream.Position:=0;
  AResponseStream.Read(AFileHeaderBytes[0],Length(AFileHeaderBytes));
  AResponseStream.Position:=0;


  //比对是否是图片文件
//    if Copy(ImageExt,1,2)='BM' then
  if (AFileHeaderBytes[0]=Ord('B'))
    and (AFileHeaderBytes[1]=Ord('M')) then
  begin
      //if AUrlCacheItem.FileExt='' then
      AUrlCacheItem.FileExt:='.bmp';
  end
  else
  if (AFileHeaderBytes[0]=Ord('G'))
    and (AFileHeaderBytes[1]=Ord('I'))
    and (AFileHeaderBytes[2]=Ord('F')) then
//    else if Copy(ImageExt,1,3)='GIF' then
  begin
      //if AUrlCacheItem.FileExt='' then
      AUrlCacheItem.FileExt:='.gif';
  end
  else
  if (AFileHeaderBytes[1]=Ord('P'))
    and (AFileHeaderBytes[2]=Ord('N'))
    and (AFileHeaderBytes[3]=Ord('G')) then
//    else if Copy(ImageExt,2,3)='PNG' then
  begin
      //if AUrlCacheItem.FileExt='' then
      AUrlCacheItem.FileExt:='.png';
  end
  else
  if (AFileHeaderBytes[0]=255)
    and (AFileHeaderBytes[1]=216) then
//    else if (Copy(ImageExt,1,1)=#255) and (Copy(ImageExt,2,1)=#216) then
  begin
      //0xff,0xd8
      //if AUrlCacheItem.FileExt='' then
      AUrlCacheItem.FileExt:='.jpg';
  end
  else
  begin
      //文件内容出错
      //uBaseLog.OutputDebugString('TDefaultDownloadManager.DownloadItem 文件内容出错');
      AUrlCacheItem.State:=dpsDownloadImageInvalid;
      AIsValidResponse:=False;
  end;
  ;




end;

procedure TBaseDownloadPictureManager.DoCustomLoadFromDownloadedStream(
  AUrlCacheItem:TUrlCacheItem;AResponseStream: TStream;AOriginFilePath:String);
begin

  //检测图片流是否正确
  if AUrlCacheItem.State<>dpsDownloadImageInvalid then
  begin


        //  {$IFDEF MSWINDOWS}
          TThread.Synchronize(nil,procedure
          begin
        //  {$ENDIF MSWINDOWS}


            //在线程中加载图片
            TUrlPicture(AUrlCacheItem).LoadPictureDownloadedStream(AResponseStream);


        //  {$IFDEF MSWINDOWS}
          end);
        //  {$ENDIF MSWINDOWS}


  end;

end;

procedure TBaseDownloadPictureManager.DoLoadItemInThread(ATimerTask: TObject);
var
  AUrlPicture:TUrlPicture;
begin

  //下载图片
  AUrlPicture:=TUrlPicture(TTimerTask(ATimerTask).TaskObject);

  //标记正在下载
  //AUrlPicture.State:=dpsDownloading;


  //在Windows下面不能在线程中加载图片,而Android/IOS下可以
//  {$IFDEF MSWINDOWS}
  TThread.Synchronize(nil,procedure
  begin
//  {$ENDIF MSWINDOWS}


    //在线程中加载图片
    AUrlPicture.LoadPictureDownloaded;


//  {$IFDEF MSWINDOWS}
  end);
//  {$ENDIF MSWINDOWS}



//  //下载
//  if DelayLoadFileExistPictureMillionSecond>0 then
//  begin
//    Sleep(DelayLoadFileExistPictureMillionSecond);
//  end;


  //下载结束
  //AUrlPicture.State:=dpsDownloadSucc;

end;

function TBaseDownloadPictureManager.DownloadPicture(const AUrl: String;
  const ADrawPicture: TObject; const AData: Pointer; const ASavedFilePath,
  AFileExt, ALogCaption: String;
  AOnDownloadStateChange: TDownloadProgressStateChangeEvent;
  AIsNeedCheckNew:Boolean): TUrlPicture;
begin
  Result:=TUrlPicture(Download(AUrl,
                               ADrawPicture,
                               AData,
                               ASavedFilePath,
                               AFileExt,
                               ALogCaption,
                               AOnDownloadStateChange,
                               AIsNeedCheckNew
                                ));
end;

function TBaseDownloadPictureManager.FindUrlPicture(
  const AUrl: String): TUrlPicture;
begin
  Result:=TUrlPicture(Find(AUrl));
end;

procedure TBaseDownloadPictureManager.FreeNoUsePicture(
  ASecondsBetween: Integer);
var
  I: Integer;
begin
  for I := 0 to Self.FUrlCacheItemList.Count-1 do
  begin
    if (TUrlPicture(Self.FUrlCacheItemList[I]).Picture<>nil)
      and (DateUtils.SecondsBetween(Now,Self.FUrlCacheItemList[I].LastUseTime)>ASecondsBetween) then
    begin
      FreeAndNil(TUrlPicture(Self.FUrlCacheItemList[I]).Picture);
      FreeAndNil(TUrlPicture(Self.FUrlCacheItemList[I]).ClipRoundPicture);
    end;
  end;

end;

{ TUrlPictureList }

function TUrlPictureList.CreateBinaryObject(
  const AClassName: String): TInterfacedPersistent;
begin
  Result:=TUrlPicture.Create(FManager);
end;

function TUrlPictureList.GetItem(Index: Integer): TUrlPicture;
begin
  Result:=TUrlPicture(Inherited Items[Index]);
end;

initialization
  {$IFDEF NEED_SystemHttpControl}
  DownloadItemHttpControlClass:=TSystemHttpControl;
  {$ENDIF FMX}



end.


