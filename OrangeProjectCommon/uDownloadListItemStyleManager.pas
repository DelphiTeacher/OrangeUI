//列表项样式下载
unit uDownloadListItemStyleManager;

interface

{$IF DEFINED(ANDROID) OR DEFINED(IOS) OR DEFINED(MACOS) }
  {$DEFINE FMX}
{$IFEND}



//请在工程下放置FrameWork.inc
//或者在工程设置中配置FMX编译指令
//才可以正常编译此单元
{$IFNDEF FMX}
  {$IFNDEF VCL}
    {$I FrameWork.inc}
  {$ENDIF}
{$ENDIF}

uses
  Classes,
  SysUtils,
  uBaseLog,
  uPageStructure,
  uSkinCustomListType,

  {$IFDEF FMX}
  ListItemStyleFrame_Page,
  {$ENDIF FMX}


  uUrlPicture;



type
  TUrlListItemStyle=class(TBaseUrlListItemStyle)
  public
    FPage:TPage;


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
//                      );override;

    //加载图片
    function IsLoaded:Boolean;override;
    procedure Load;override;
//    procedure LoadPictureDownloaded;
//    procedure LoadPictureDownloadedStream(AStream:TStream);
  public
    constructor Create(AManager:TDefaultDownloadManager);override;
    destructor Destroy;override;
  end;



  TUrlListItemStyleList=class(TUrlCacheItemList)
  private
    function GetItem(Index:Integer): TUrlListItemStyle;
//    procedure SetItem(Index:Integer; const Value: TUrlCacheItem);
  protected
    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
  public
    property Items[Index:Integer]:TUrlListItemStyle read GetItem;default;// write SetItem;default;
  end;







  TBaseDownloadListItemStyleManager=class(TDefaultDownloadManager)
  public
    function CreateUrlCacheItemList:TUrlCacheItemList;override;
  public
    constructor Create(AOwner:TComponent);override;
  end;







var
  //下载列表项样式的管理
  GlobalDownloadListItemStyleManager:TBaseDownloadListItemStyleManager;

function GetGlobalDownloadListItemStyleManager:TBaseDownloadListItemStyleManager;

//获取链接的列表项样式注册
procedure GetUrlListItemStyleReg(AListItemTypeStyleSetting:TListItemTypeStyleSetting;AOnDownloadStateChange:TDownloadProgressStateChangeEvent);


implementation



//获取链接的列表项样式注册
procedure GetUrlListItemStyleReg(AListItemTypeStyleSetting:TListItemTypeStyleSetting;AOnDownloadStateChange:TDownloadProgressStateChangeEvent);
var
  AUrlListItemStyle:TUrlListItemStyle;
begin
//  Result:=nil;

  AUrlListItemStyle:=TUrlListItemStyle(GetGlobalDownloadListItemStyleManager.Download(AListItemTypeStyleSetting.StyleRootUrl+AListItemTypeStyleSetting.Style+'.json',
                                                                                     AListItemTypeStyleSetting,
                                                                                     nil,
                                                                                     '',
                                                                                     '.json',
                                                                                     '',
                                                                                     AOnDownloadStateChange,
                                                                                     True
                                                                                     ));

//  if AUrlListItemStyle=nil then
//  begin
//    Exit;
//  end;
//
//
//  if AUrlListItemStyle.State<>dpsDownloadSucc then
//  begin
//    Exit;
//  end;
//
//  Result:=AUrlListItemStyle.FListItemStyleReg;

end;




function GetGlobalDownloadListItemStyleManager:TBaseDownloadListItemStyleManager;
begin
  if GlobalDownloadListItemStyleManager=nil then
  begin
    GlobalDownloadListItemStyleManager:=TBaseDownloadListItemStyleManager.Create(nil);
    //默认的分组
    GlobalDownloadListItemStyleManager.GroupName:='ListItemStyle';
  end;
  Result:=GlobalDownloadListItemStyleManager;
end;




{ TUrlListItemStyle }

//destructor TUrlListItemStyle.Destroy;
//begin
//
//  inherited;
//end;

constructor TUrlListItemStyle.Create(AManager: TDefaultDownloadManager);
begin
  inherited;
end;

destructor TUrlListItemStyle.Destroy;
begin
  FreeAndNil(FPage);
  inherited;
end;

function TUrlListItemStyle.IsLoaded: Boolean;
begin
  Result:=(FListItemStyleReg<>nil);
end;

procedure TUrlListItemStyle.Load;
var
  AListItemStyleReg:TListItemStyleReg;
begin
  if Self.IsLoaded then
  begin
    Exit;
  end;

  if Self.FPage=nil then
  begin
    Self.FPage:=TPage.Create(nil);
  end;
  try
    Self.FPage.LoadFromFile(Self.GetOriginFilePath);



    //注册为列表项样式
    //判断是否已经存在,如果存在,则先取消注册
    UnRegisterListItemStyle(FPage.Name);
    FListItemStyleReg:=RegisterListItemStyle(//'CustomListItemStyle_ProcessTaskOrder',
                                              FPage.Name,
                                              TFrameListItemStyle_Page,
                                              FPage.list_item_style_default_height,
                                              (FPage.list_item_style_autosize=1),
                                              FPage
                                              );

  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'TUrlListItemStyle.Load');
    end;

  end;

//  TThread.Synchronize(nil,procedure
//  begin
//    Self.lvOrderList.Prop.DefaultItemStyle:=FPage.Name;
//              //'CustomListItemStyle_ProcessTaskOrder';
//  end);


end;

{ TUrlListItemStyleList }

function TUrlListItemStyleList.CreateBinaryObject(
  const AClassName: String): TInterfacedPersistent;
begin
  Result:=TUrlListItemStyle.Create(FManager);
end;

function TUrlListItemStyleList.GetItem(Index: Integer): TUrlListItemStyle;
begin
  Result:=TUrlListItemStyle(Inherited Items[Index]);
end;

{ TBaseDownloadListItemStyleManager }

constructor TBaseDownloadListItemStyleManager.Create(AOwner: TComponent);
begin
  inherited;

  FIsLoadItemInThread:=False;

end;

function TBaseDownloadListItemStyleManager.CreateUrlCacheItemList: TUrlCacheItemList;
begin
  Result:=TUrlListItemStyleList.Create;
end;



initialization
  uSkinCustomListType.GlobalOnGetUrlListItemStyleReg:=GetUrlListItemStyleReg;


finalization
  FreeAndNil(GlobalDownloadListItemStyleManager);


end.
