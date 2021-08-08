//�б�����ʽ����
unit uDownloadListItemStyleManager;

interface

{$IF DEFINED(ANDROID) OR DEFINED(IOS) OR DEFINED(MACOS) }
  {$DEFINE FMX}
{$IFEND}



//���ڹ����·���FrameWork.inc
//�����ڹ�������������FMX����ָ��
//�ſ�����������˵�Ԫ
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


//    procedure Init( //����
//                      const AUrl:String;
//                      //ͼƬ
//                      const ADataObject:TObject=nil;
//                      //��������
//                      const AData:Pointer=nil;
//                      //ͼƬ��������ļ�·��
//                      const ASavedFilePath:String='';
//                      //�ļ���׺
//                      const AFileExt:String='';
//                      const ALogCaption:String='';
//                      //�ص��¼�
//                      AOnDownloadStateChange:TDownloadProgressStateChangeEvent=nil
////                              //�Ƿ���س�Բ��
////                              AIsClipRound:Boolean=False;
////                              AClipRoundXRadis:Double=0;
////                              AClipRoundYRadis:Double=0
//                      );override;

    //����ͼƬ
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
  //�����б�����ʽ�Ĺ���
  GlobalDownloadListItemStyleManager:TBaseDownloadListItemStyleManager;

function GetGlobalDownloadListItemStyleManager:TBaseDownloadListItemStyleManager;

//��ȡ���ӵ��б�����ʽע��
procedure GetUrlListItemStyleReg(AListItemTypeStyleSetting:TListItemTypeStyleSetting;AOnDownloadStateChange:TDownloadProgressStateChangeEvent);


implementation



//��ȡ���ӵ��б�����ʽע��
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
    //Ĭ�ϵķ���
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



    //ע��Ϊ�б�����ʽ
    //�ж��Ƿ��Ѿ�����,�������,����ȡ��ע��
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
