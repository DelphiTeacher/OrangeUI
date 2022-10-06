//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     绘制的图片基类
///   </para>
///   <para>
///     Base class of drawing picture
///   </para>
/// </summary>
unit uDrawPicture;



interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  Types,
  DateUtils,
  StrUtils,
  {$IF CompilerVersion>=30.0}
  Zip,
  {$IFEND}

  {$IFDEF VCL}
//  VCL.Graphics,
//  //新版本
//  Vcl.Imaging.jpeg,
//  Vcl.Imaging.pngimage,
//  Vcl.Imaging.GIFImg,
  Graphics,
  PngImage,
  Jpeg,
  GifImg,
  Dialogs,
  {$ENDIF}




  {$IFDEF FMX}
  FMX.Types,
  FMX.Graphics,
  FMX.Forms,
  FMX.Dialogs,
  {$ENDIF}


  Math,
  MD5_OrangeUI,
  uFileCommon,
  uBaseList,
  uBinaryObjectList,
  uBaseLog,
  uFuncCommon,
  uUrlPicture,
  uSkinPicture,
  uBinaryTreeDoc;




type
  TSkinBaseImageList=class;
  TDrawPicture=class;





  /// <summary>
  ///   <para>
  ///     图片绘制的类型
  ///   </para>
  ///   <para>
  ///     Type of drawing picture
  ///   </para>
  /// </summary>
  TPictureDrawType=(
                    /// <summary>
                    ///   自动判断
                    ///  <para>
                    ///     Judge automatically
                    ///   </para>
                    /// </summary>
                    pdtAuto,
                    /// <summary>
                    ///   图片
                    ///  <para>
                    ///     Picture
                    ///   </para>
                    /// </summary>
                    pdtPicture,
                    /// <summary>
                    ///   图片列表和图片下标
                    ///  <para>
                    ///     Image List
                    ///   </para>
                    /// </summary>
                    pdtImageList,
                    /// <summary>
                    ///   图片列表和图片名称
                    ///  <para>
                    ///     Image List
                    ///   </para>
                    /// </summary>
                    pdtImageName,
                    /// <summary>
                    ///   图片引用(SkinPicture的引用)
                    ///  <para>
                    ///     Refrence picture
                    ///   </para>
                    /// </summary>
                    pdtReference,
                    /// <summary>
                    ///   图片引用(DrawPicture的引用)
                    ///  <para>
                    ///     Refrence picture
                    ///   </para>
                    /// </summary>
                    pdtRefDrawPicture,
                    /// <summary>
                    ///   图片文件路径
                    ///  <para>
                    ///     File
                    ///   </para>
                    /// </summary>
                    pdtFile,
                    /// <summary>
                    ///   图片的链接
                    ///  <para>
                    ///     URL
                    ///   </para>
                    /// </summary>
                    pdtUrl,
                    /// <summary>
                    ///   资源ID
                    ///  <para>
                    ///     Resource ID
                    ///   </para>
                    /// </summary>
                    pdtResource,

                    //使用事件来获取图片
                    pdtOnGetPictureEvent
                    );





  TGetSkinImageListEvent=procedure(Sender:TObject;var ASkinImageList:TSkinBaseImageList) of object;
  TGetDownloadPictureManagerEvent=procedure(Sender:TObject;var ADownloadPictureManager:TBaseDownloadPictureManager) of object;
  TGetPictureEvent=procedure(Sender:TObject;var ASkinPicture:TSkinPicture) of object;




  /// <summary>
  ///   <para>
  ///     绘制的图片
  ///   </para>
  ///   <para>
  ///     Drawn picture
  ///   </para>
  /// </summary>
  TBaseDrawPicture=class(TSkinPicture,ISupportClassDocNode)
  private


    //名字
    FName:String;
    //标题
    FCaption:String;
    //图片分组(一组图片表示的意思为:比如按钮背景图片的四个状态图片为一组)
    FGroup:String;




    //图片文件路径
    FFileName:String;
    //需要单独创建一个TSkinPicture对象(DFM保存的时候不至于保存进去)
    FFilePicture:TSkinPicture;
    FIsLoadedFromFile:Boolean;
    FLoadedFilePath:String;




    //图片URL
    FUrl:String;
    FUrlPicture:TUrlPicture;
    //之前的图片URL,用于图片正在下载暂时显示
//    FPriorUrlPicture:TUrlPicture;




    //资源ID
    FResourceName: String;
    FResourcePicture:TSkinPicture;
    FIsLoadedFromResource:Boolean;




    {$IFDEF VCL}
    //行数
    FRowCount:Integer;
    //列数
    FColCount:Integer;
    //行下标
    FRowIndex:Integer;
    //列下标
    FColIndex:Integer;
    {$ENDIF}



    //图片下标
    FImageIndex: Integer;
    //深色主题
    FDrakThemeImageIndex: Integer;


    //图片名称
    FImageName:String;



    //图片引用(TSkinPicture)
    FRefPicture: TSkinPicture;


    //图片引用(TDrawPicture)
    FRefDrawPicture: TDrawPicture;



    //绘制类型
    FPictureDrawType: TPictureDrawType;










    //当前效果的图片下标
    FCurrentEffectImageIndex: Integer;
    //当前效果的图片名称
    FCurrentEffectImageName:String;




    //所属的素材,用于IDE设计时给组件设计器使用
    FSkinMaterial:TObject;



    //图标列表
    FSkinImageList:TSkinBaseImageList;


    //图标列表更改通知链接
    FSkinImageListChangeLink:TSkinObjectChangeLink;



    //获取图片列表的事件(用于ListBox用绑定SkinImageList)
    FOnGetSkinImageList:TGetSkinImageListEvent;
    FOnGetDownloadPictureManager: TGetDownloadPictureManagerEvent;

  private
    FDownloadPictureManager: TBaseDownloadPictureManager;
    FOnChange: TNotifyEvent;
    //FOnChange: TNotifyEvent;

    {$IFDEF VCL}
    function IsColCountStroed: Boolean;
    function IsColIndexStroed: Boolean;
    function IsRowCountStroed: Boolean;
    function IsRowIndexStroed: Boolean;
    {$ENDIF}


    function IsFileNameStroed: Boolean;
    function IsImageIndexStroed: Boolean;
    function IsImageNameStroed: Boolean;
    function IsPictureDrawTypeStroed: Boolean;
    function IsResourceNameStroed: Boolean;
    function IsUrlStroed: Boolean;
  protected

    procedure SetUrl(const Value: String);

    procedure SetResourceName(const Value: String);

    procedure SetImageIndex(const Value: Integer);

    procedure SetImageName(const Value: String);

    procedure SetRefPicture(const Value: TSkinPicture);

    procedure SetRefDrawPicture(const Value: TDrawPicture);

    procedure SetPictureDrawType(const Value: TPictureDrawType);

    procedure SetFileName(const Value: String);

    function GetSkinImageList: TSkinBaseImageList;

    procedure SetSkinImageList(const Value: TSkinBaseImageList);
    procedure SetDownloadPictureManager(const Value: TBaseDownloadPictureManager);

    procedure OnSkinImageListChange(Sender: TObject);
    procedure OnSkinImageListDestroy(Sender: TObject);
//  protected
//    procedure DefineProperties(Filer: TFiler);override;
  public
    /// <summary>
    ///   <para>
    ///     当前图片是否是GIF图片
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetCurrentIsGIF:Boolean;override;
    /// <summary>
    ///   <para>
    ///     如果当前图片是否是GIF,那么返回GIF图片流
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetCurrentGIFStream:TMemoryStream;override;

  public
    /// <summary>
    ///   <para>
    ///     构造函数
    ///   </para>
    ///   <para>
    ///     Construct function
    ///   </para>
    /// </summary>
    /// <param name="AName">
    ///   名字(用于设计时)
    ///  <para>
    ///    Name
    ///   </para>
    /// </param>
    /// <param name="ACaption">
    ///   标题(用于设计时更清楚的给用户看到这个Picture是做什么用的)
    ///  <para>
    ///    Caption
    ///   </para>
    /// </param>
    /// <param name="AGroup">
    ///   图片分组(用于设计时)
    ///  <para>
    ///    Group
    ///   </para>
    /// </param>
    constructor Create(
                        const AName:String='';
                        const ACaption:String='';
                        const AGroup:String=''
                        );virtual;
    destructor Destroy;override;
  public
    /// <summary>
    ///   <para>
    ///   加载的时候是否需要检查GIF图片(不检查GIF图片可以提高加载速度,但在移动平台下就加载不了GIF图片)
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    IsCheckGIFWhenLoad:Boolean;

    //加载链接图片到自己
    IsLoadUrlPictureToSelf:Boolean;


    //可能是用来判断数据是否更改过
    Base64Length:Integer;

    //获取图片的事件
    OnGetPicture:TGetPictureEvent;


    SkinImageListName:String;
    //当Url为空时的默认头像
    DefaultImageName:String;
    DefaultImageIndex:Integer;


    /// <summary>
    ///   <para>
    ///  获取图片下载管理者
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    function GetDownloadPictureManager:TBaseDownloadPictureManager;


    /// <summary>
    ///   <para>
    ///     仅清除图片Bitmap
    ///   </para>
    ///   <para>
    ///     Clear Picture
    ///   </para>
    /// </summary>
    procedure ClearPicture;

    /// <summary>
    ///   <para>
    ///     检查图片是否下载结束,如果下载结束并且下载成功,那么加载图片
    ///   </para>
    ///   <para>
    ///     Check whether picture is downloaded, if it is finished and download succeededly,then load picture
    ///   </para>
    /// </summary>
//    procedure LoadDownloadedUrlPicture(AUrlPicture:TUrlPicture);
    procedure DoDownloadPictureStateChange(Sender:TObject;AUrlPicture:TUrlCacheItem);

    /// <summary>
    ///   <para>
    ///     图片下载结束,DownloadPictureManager在图片下载结束之后会调用此方法来通知图片下载结束
    ///   </para>
    ///   <para>
    ///     Download picture finished,DownloadPictureManager will call this method to notify downloading picture finished after downloading picture
    ///   </para>
    /// </summary>
//    procedure DoUrlPictureDownloaded(AUrlPicture:TUrlPicture);


    /// <summary>
    ///   <para>
    ///     名字
    ///   </para>
    ///   <para>
    ///     Name
    ///   </para>
    /// </summary>
    property Name:String read FName write FName;

    /// <summary>
    ///   <para>
    ///     标题
    ///   </para>
    ///   <para>
    ///     Caption
    ///   </para>
    /// </summary>
    property Caption:String read FCaption write FCaption;

    /// <summary>
    ///   <para>
    ///     分组
    ///   </para>
    ///   <para>
    ///     Group
    ///   </para>
    /// </summary>
    property Group:String read FGroup write FGroup;




    /// <summary>
    ///   <para>
    ///     清除所有内容
    ///   </para>
    ///   <para>
    ///     Clear
    ///   </para>
    /// </summary>
    procedure Clear;overload;override;
    /// <summary>
    ///   <para>
    ///     复制
    ///   </para>
    ///   <para>
    ///     Copy
    ///   </para>
    /// </summary>
    procedure Assign(Source: TPersistent); override;

    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;overload;
    //
    /// <summary>
    ///   保存到文档节点
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;overload;



    /// <summary>
    ///   <para>
    ///     引用的图片
    ///   </para>
    ///   <para>
    ///     Reference picture
    ///   </para>
    /// </summary>
    property RefPicture:TSkinPicture read FRefPicture write SetRefPicture;
    /// <summary>
    ///   <para>
    ///     引用的图片
    ///   </para>
    ///   <para>
    ///     Reference picture
    ///   </para>
    /// </summary>
    property RefDrawPicture:TDrawPicture read FRefDrawPicture write SetRefDrawPicture;



    /// <summary>
    ///   <para>
    ///     更改的事件
    ///   </para>
    ///   <para>
    ///     Changed event
    ///   </para>
    /// </summary>
    //property OnChange:TNotifyEvent read FOnChange write FOnChange;


    /// <summary>
    ///   <para>
    ///     获取当前绘制的图片
    ///   </para>
    ///   <para>
    ///     Get currently draw picture
    ///   </para>
    /// </summary>
    function CurrentPicture:TSkinPicture;override;
    /// <summary>
    ///   <para>
    ///     当前绘制的图片是否为空
    ///   </para>
    ///   <para>
    ///     Whether current draw picture is empty
    ///   </para>
    /// </summary>
    function CurrentPictureIsEmpty:Boolean;


    /// <summary>
    ///   <para>
    ///     当前绘制的图片是否为GIF图片
    ///   </para>
    ///   <para>
    ///     Whether current draw picture is GIF
    ///   </para>
    /// </summary>
    function CurrentPictureIsGIF:Boolean;



    /// <summary>
    ///   <para>
    ///     当前绘制图片的宽度
    ///   </para>
    ///   <para>
    ///     Width of current picture
    ///   </para>
    /// </summary>
    function CurrentPictureWidth:Integer;
    /// <summary>
    ///   <para>
    ///     当前绘制图片的高度
    ///   </para>
    ///   <para>
    ///     Height of current picture
    ///   </para>
    /// </summary>
    function CurrentPictureHeight:Integer;





    /// <summary>
    ///   <para>
    ///     绘制左边距(用于图片分解成多张子图片)
    ///   </para>
    ///   <para>
    ///     Draw left margin
    ///   </para>
    /// </summary>
    function CurrentPictureDrawLeft:Integer;
    /// <summary>
    ///   <para>
    ///     绘制上边距(用于图片分解成多张子图片)
    ///   </para>
    ///   <para>
    ///     Draw top margin
    ///   </para>
    /// </summary>
    function CurrentPictureDrawTop:Integer;
    /// <summary>
    ///   <para>
    ///     绘制宽度(用于图片分解成多张子图片)
    ///   </para>
    ///   <para>
    ///     Draw width
    ///   </para>
    /// </summary>
    function CurrentPictureDrawWidth:Integer;
    /// <summary>
    ///   <para>
    ///     绘制高度(用于图片分解成多张子图片)
    ///   </para>
    ///   <para>
    ///     Draw height
    ///   </para>
    /// </summary>
    function CurrentPictureDrawHeight:Integer;





    /// <summary>
    ///   <para>
    ///     下标图片
    ///   </para>
    ///   <para>
    ///     Index Picture
    ///   </para>
    /// </summary>
    function ImageIndexPicture:TSkinPicture;
    /// <summary>
    ///   <para>
    ///     名称图片
    ///   </para>
    ///   <para>
    ///     Name Picture
    ///   </para>
    /// </summary>
    function ImageNamePicture:TSkinPicture;
    /// <summary>
    ///   <para>
    ///     文件名图片
    ///   </para>
    ///   <para>
    ///     File Name Picture
    ///   </para>
    /// </summary>
    function FileNamePicture:TSkinPicture;
    /// <summary>
    ///   <para>
    ///     资源名图片
    ///   </para>
    ///   <para>
    ///     Resource name picture
    ///   </para>
    /// </summary>
    function ResourceNamePicture:TSkinPicture;
    /// <summary>
    ///   <para>
    ///     网页链接图片
    ///   </para>
    ///   <para>
    ///     Web link picture
    ///   </para>
    /// </summary>
    function WebUrlPicture:TSkinPicture;

    function OnGetPictureEventPicture:TSkinPicture;



    /// <summary>
    ///   <para>
    ///     网页链接图片
    ///   </para>
    ///   <para>
    ///     Web link picture
    ///   </para>
    /// </summary>
    property UrlPicture:TUrlPicture read FUrlPicture;



    //
    /// <summary>
    ///   <para>
    ///     图片所属的素材,用于在设计时列出相同分组的图片
    ///   </para>
    ///   <para>
    ///     Picture material belongs to
    ///   </para>
    /// </summary>
    property SkinMaterial:TObject read FSkinMaterial write FSkinMaterial;




    /// <summary>
    ///   <para>
    ///     静态地设置图片引用
    ///   </para>
    ///   <para>
    ///     Set picture reference staticly
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   静态地设置属性,不会调用OnChange
    ///  <para>
    ///  Set property staticly,not call OnChange
    ///  </para>
    /// </remarks>
    property StaticRefPicture:TSkinPicture read FRefPicture write FRefPicture;
    /// <summary>
    ///   <para>
    ///     静态地设置图片引用
    ///   </para>
    ///   <para>
    ///  Set picture reference staticly
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   静态地设置属性,不会调用OnChange
    ///  <para>
    ///  Set property staticly,not call OnChange
    ///  </para>
    /// </remarks>
    property StaticRefDrawPicture:TDrawPicture read FRefDrawPicture write FRefDrawPicture;

    /// <summary>
    ///   <para>
    ///     静态地设置图片下标
    ///   </para>
    ///   <para>
    ///     Set index staticly
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   静态地设置属性,不会调用OnChange
    ///  <para>
    ///  Set property staticly,not call OnChange
    ///  </para>
    /// </remarks>
    property StaticImageIndex:Integer read FImageIndex write FImageIndex;
    /// <summary>
    ///   <para>
    ///     静态地设置图片名称
    ///   </para>
    ///   <para>
    ///     Set picture name staticly
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   静态地设置属性,不会调用OnChange
    ///  <para>
    ///  Set property staticly,not call OnChange
    ///  </para>
    /// </remarks>
    property StaticImageName:String read FImageName write FImageName;
    /// <summary>
    ///   <para>
    ///     静态地设置图片列表
    ///   </para>
    ///   <para>
    ///     Set list of picture staticly
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   静态地设置属性,不会调用OnChange
    ///  <para>
    ///  Set property staticly,not call OnChange
    ///  </para>
    /// </remarks>
    property StaticSkinImageList:TSkinBaseImageList read FSkinImageList write FSkinImageList;
    /// <summary>
    ///   <para>
    ///     静态地设置绘制类型
    ///   </para>
    ///   <para>
    ///   Set DrawType staticly
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   静态地设置属性,不会调用OnChange
    ///  <para>
    ///  Set property staticly,not call OnChange
    ///  </para>
    /// </remarks>
    property StaticPictureDrawType:TPictureDrawType Read FPictureDrawType write FPictureDrawType;

    /// <summary>
    ///   <para>
    ///     静态地设置URL
    ///   </para>
    ///   <para>
    ///     Set URL staticly
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   静态地设置属性,不会调用OnChange
    ///  <para>
    ///  Set property staticly,not call OnChange
    ///  </para>
    /// </remarks>
    property StaticUrl:String read FUrl write FUrl;



    /// <summary>
    ///   <para>
    ///     获取图片列表组件的事件(在ListBox控件中使用)
    ///   </para>
    ///   <para>
    ///     Get ImageList event(which is used in ListBox)
    ///   </para>
    /// </summary>
    property OnGetSkinImageList:TGetSkinImageListEvent read FOnGetSkinImageList write FOnGetSkinImageList;
    //获取图片下载管理者的事件
    property OnGetDownloadPictureManager:TGetDownloadPictureManagerEvent read FOnGetDownloadPictureManager write FOnGetDownloadPictureManager;



    /// <summary>
    ///   <para>
    ///     当前效果的图片下标
    ///   </para>
    ///   <para>
    ///     Image index of current effect
    ///   </para>
    /// </summary>
    property CurrentEffectImageIndex:Integer read FCurrentEffectImageIndex write FCurrentEffectImageIndex;
    /// <summary>
    ///   <para>
    ///     当前效果的图片名称
    ///   </para>
    ///   <para>
    ///     Image name of current effect
    ///   </para>
    /// </summary>
    property CurrentEffectImageName:String read FCurrentEffectImageName write FCurrentEffectImageName;
    /// <summary>
    ///   <para>
    ///     图片列表组件
    ///   </para>
    ///   <para>
    ///     ImageList component
    ///   </para>
    /// </summary>
    property SkinImageList:TSkinBaseImageList read GetSkinImageList write SetSkinImageList;


  published
    property IsClipRound;

    {$IFDEF VCL}
    /// <summary>
    ///   <para>
    ///     子图片行数
    ///   </para>
    ///   <para>
    ///     Rows of subpicture
    ///   </para>
    /// </summary>
    property RowCount:Integer read FRowCount write FRowCount stored IsRowCountStroed;
    /// <summary>
    ///   <para>
    ///     子图片列数
    ///   </para>
    ///   <para>
    ///     Columns of subpicture
    ///   </para>
    /// </summary>
    property ColCount:Integer read FColCount write FColCount stored IsColCountStroed;
    /// <summary>
    ///   <para>
    ///     子图片行下标
    ///   </para>
    ///   <para>
    ///     Row index of subpicture
    ///   </para>
    /// </summary>
    property RowIndex:Integer read FRowIndex write FRowIndex stored IsRowIndexStroed;
    /// <summary>
    ///   <para>
    ///     子图片列下标
    ///   </para>
    ///   <para>
    ///     Column index of subpicture
    ///   </para>
    /// </summary>
    property ColIndex:Integer read FColIndex write FColIndex stored IsColIndexStroed;
    {$ENDIF}




    /// <summary>
    ///   <para>
    ///     当前显示的图片名称
    ///   </para>
    ///   <para>
    ///     Image name of current display
    ///   </para>
    /// </summary>
    property ImageName:String read FImageName write SetImageName stored IsImageNameStroed;


    /// <summary>
    ///   <para>
    ///     文件路径(分设计时,运行时,IOS,Android,Win,这里是相对路径)
    ///   </para>
    ///   <para>
    ///     File path(design,run,IOS,Android,Win,here is relative path)
    ///   </para>
    /// </summary>
    property FileName:String read FFileName write SetFileName stored IsFileNameStroed;


    /// <summary>
    ///   <para>
    ///     资源ID
    ///   </para>
    ///   <para>
    ///     Resource ID
    ///   </para>
    /// </summary>
    property ResourceName:String read FResourceName write SetResourceName stored IsResourceNameStroed;



  published
    {$IFDEF FMX}

//    property SkinThemeColor;
//    //是否跟随主题色更改颜色
//    property SkinThemeColorChange;

//    property IsClipRound;
    {$ENDIF FMX}

    /// <summary>
    ///   <para>
    ///     指定图片下载管理者
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DownloadPictureManager:TBaseDownloadPictureManager read FDownloadPictureManager write SetDownloadPictureManager;

    /// <summary>
    ///   <para>
    ///     当前显示的图片下标
    ///   </para>
    ///   <para>
    ///     Image index of current display
    ///   </para>
    /// </summary>
    property ImageIndex:Integer read FImageIndex write SetImageIndex stored IsImageIndexStroed;


    /// <summary>
    ///   <para>
    ///     图片的链接
    ///   </para>
    ///   <para>
    ///     URL of picture
    ///   </para>
    /// </summary>
    property Url:String read FUrl write SetUrl stored IsUrlStroed;





    /// <summary>
    ///   <para>
    ///     绘制类型
    ///   </para>
    ///   <para>
    ///     Type of drawing
    ///   </para>
    /// </summary>
    property PictureDrawType:TPictureDrawType Read FPictureDrawType write SetPictureDrawType stored IsPictureDrawTypeStroed;//default pdtAuto;
  end;





  //因为SkinItem.Icon不能在设计时保存SkinImageList,
  //所以SkinItem.Icon:TBaseDrawPicture
  //而Image.Picture可以保存SkinImageList,所以声明为TDrawPicture
  TDrawPicture=class(TBaseDrawPicture)
  published
    property SkinImageList;
  end;





  /// <summary>
  ///   <para>
  ///     图片列表
  ///   </para>
  ///   <para>
  ///     Picture list
  ///   </para>
  /// </summary>
  TDrawPictureList=class(TBinaryObjectList)
  private
    function GetItem(Index: Integer): TDrawPicture;
    function GetItemByName(const AName: String): TDrawPicture;
    procedure SetItem(Index: Integer; const Value: TDrawPicture);
  protected
    //创建图片(保存在FMX或DFM文件中时,加载的时候创建它来读取图片)
    function CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;override;
  public
    {$IFDEF VCL}
    //添加Graphic
    function AddGraphic(AGraphic:TGraphic):Integer;
    //添加Picture
    function AddPicture(APicture:TPicture):Integer;
    {$ENDIF}
  public

    /// <summary>
    ///   <para>
    ///     添加图片文件
    ///   </para>
    ///   <para>
    ///     Add picture file
    ///   </para>
    /// </summary>
    function Add:TDrawPicture;overload;

    /// <summary>
    ///   <para>
    ///     添加图片文件
    ///   </para>
    ///   <para>
    ///     Add picture file
    ///   </para>
    /// </summary>
    function AddPictureFile(const APictureFile:String):Integer;
    /// <summary>
    ///   <para>
    ///     只添加文件名
    ///   </para>
    ///   <para>
    ///     Only add file name
    ///   </para>
    /// </summary>
    /// <param name="AFileName">
    ///   因为文件名可以作为资源名称
    /// </param>
    function AddFileNameOnly(const AFileName:String):Integer;


    /// <summary>
    ///   <para>
    ///     替换图片文件
    ///   </para>
    ///   <para>
    ///     Replace picture file
    ///   </para>
    /// </summary>
    procedure ReplacePictureFile(const AIndex:Integer;const APictureFile:String);
    /// <summary>
    ///   <para>
    ///     替换文件名
    ///   </para>
    ///   <para>
    ///     Replace file name
    ///   </para>
    /// </summary>
    procedure ReplaceFileNameOnly(const AIndex: Integer;const AFileName: String);
  public
    function FindImageNameIndex(AImageName:String):Integer;
    property Items[Index:Integer]:TDrawPicture read GetItem write SetItem;default;
    //使用ImageName
    property ItemsByName[const Name:String]:TDrawPicture read GetItemByName;
  end;
  TSkinPictureList=TDrawPictureList;








  { TSkinBaseImageList }
  {$I ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     图片列表组件的基类
  ///   </para>
  ///   <para>
  ///     Base class of Imagelist
  ///   </para>
  /// </summary>
  TSkinBaseImageList=class(TComponent)
  private
    FSkinObjectChangeManager:TSkinObjectChangeManager;

    //图片列表
    FPictureList:TDrawPictureList;

    procedure DoChange;
    function GetOnChange: TNotifyEvent;
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure SetPictureList(const Value: TSkinPictureList);
    procedure DoPictureListChange(Sender:TObject);
  protected
    /// <summary>
    ///   <para>
    ///     开始更新
    ///   </para>
    ///   <para>
    ///     Begin update
    ///   </para>
    /// </summary>
    procedure BeginUpdate;
    /// <summary>
    ///   <para>
    ///     结束更新
    ///   </para>
    ///   <para>
    ///     End update
    ///   </para>
    /// </summary>
    procedure EndUpdate;
  protected
    //更改的事件
    property OnChange:TNotifyEvent read GetOnChange write SetOnChange;

    property SkinObjectChangeManager:TSkinObjectChangeManager read FSkinObjectChangeManager;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  public
    //
    /// <summary>
    ///   <para>
    ///     图片个数
    ///   </para>
    ///   <para>
    ///     Counts of picture
    ///   </para>
    /// </summary>
    function Count:Integer;

  public
    /// <summary>
    ///   <para>
    ///     注册通知更改的链接
    ///   </para>
    ///   <para>
    ///     Regist link of NotifyChange
    ///   </para>
    /// </summary>
    procedure RegisterChanges(Value: TSkinObjectChangeLink);
    /// <summary>
    ///   <para>
    ///     反注册通知更改的链接
    ///   </para>
    ///   <para>
    ///    Unregist link of NotifyChange
    ///   </para>
    /// </summary>
    procedure UnRegisterChanges(Value: TSkinObjectChangeLink);
  published
    /// <summary>
    ///   <para>
    ///     图片列表
    ///   </para>
    ///   <para>
    ///     Picture list
    ///   </para>
    /// </summary>
    property PictureList:TSkinPictureList read FPictureList write SetPictureList;
  end;





  TDrawPicturePersistent=class(TComponent)
  private
    FDrawPicture: TDrawPicture;
  published
    property DrawPicture:TDrawPicture read FDrawPicture write FDrawPicture;
  end;




  TSkinBaseImageListList=class(TBaseList)
  private
    function GetItem(Index: Integer): TSkinBaseImageList;
  public
    function Find(AComponentName:String):TSkinBaseImageList;
    property Items[Index:Integer]:TSkinBaseImageList read GetItem;default;
  end;



//设置设计时图片根路径的获取
//可以弹出设置,保存在注册表,
//也可以写配置文件,
//也可以写在代码里面写死
//也可以添加搜索路径
//要在设置图片的时候能设置注册表







//{$IFDEF MSWINDOWS}
//procedure ReadFilePictureSearchPathsFromRegistry(AStringList:TStrings);
//procedure WriteFilePictureSearchPathsFromRegistry(AStringList:TStrings);
//{$ENDIF}


var
  GlobalSkinBaseImageListList:TSkinBaseImageListList;

procedure ExtractIconsZip(AIconsZipFilePath:String;AIconsZipExtractDir:String);


implementation





uses
//  uDrawEngine,
  {$IFDEF VCL}
  uGDIPlusDrawCanvas,
  {$ENDIF}
  uDrawCanvas,
  uGraphicCommon,
  uDownloadPictureManager;


procedure ExtractIconsZip(AIconsZipFilePath:String;AIconsZipExtractDir:String);
var
  AIconsMD5:String;
  ALastIconsMD5:String;
begin

  //解压assets\internal\icons.zip中的图标
//  Zlib.DirectoryDecompression()
//  {$IFNDEF MSWINDOWS}
  //在Android上测试，花了169毫秒
  //判断是否需要再次解压
  if FileExists(AIconsZipFilePath) then
  begin

    if not DirectoryExists(AIconsZipExtractDir) then
    begin
      ForceDirectories(AIconsZipExtractDir);
    end;
    

    uBaseLog.HandleException(nil,'ExtractIconsZip '+AIconsZipFilePath+' To '+AIconsZipExtractDir+' Begin ');

    ALastIconsMD5:='';
    if FileExists(AIconsZipFilePath+'.md5') then
    begin
      ALastIconsMD5:=GetStringFromFile(AIconsZipFilePath+'.md5',TEncoding.UTF8);
    end;
    AIconsMD5:=MD5Print(MD5File(AIconsZipFilePath));

    if ALastIconsMD5<>AIconsMD5 then
    begin
      uBaseLog.HandleException(nil,'ExtractIconsZip '+AIconsZipFilePath+' Changed ');

      //icons.zip文件改过了,需要重新解压
      {$IF CompilerVersion>=30.0}
      TZipFile.ExtractZipFile(AIconsZipFilePath,AIconsZipExtractDir);
      {$IFEND}

      SaveStringToFile(AIconsMD5,AIconsZipFilePath+'.md5',TEncoding.UTF8);
    end
    else
    begin
      uBaseLog.HandleException(nil,'ExtractIconsZip '+AIconsZipFilePath+' Same ');

    end;

    uBaseLog.HandleException(nil,'ExtractIconsZip '+AIconsZipFilePath+' To '+AIconsZipExtractDir+' End ');
//    //再删除
//    DeleteFile(GetApplicationPath+'icons.zip');
  end;
//  {$ENDIF}



end;


//{$IFDEF MSWINDOWS}
//procedure ReadFilePictureSearchPathsFromRegistry(AStringList:TStrings);
//var
//  I: Integer;
//  Reg:TRegistry;
//  ABeginIndex:Integer;
//  AEndIndex:Integer;
//  SearchPathStr:String;
//begin
//  //设置注册表
//  Reg:=TRegistry.Create;
//  try
//    Reg.RootKey:=HKEY_CURRENT_USER;
//    if Reg.OpenKey('\Software\OrangeUI\DrawPicture\',False) then
//    begin
//
//      //注册表里有
//      SearchPathStr:=Reg.ReadString('Search Path');
//      if SearchPathStr<>'' then
//      begin
//
//        ABeginIndex:=1;
//        AEndIndex:=Pos(';',SearchPathStr);
//        repeat
//
//          if AEndIndex<=0 then
//          begin
//            AEndIndex:=Length(SearchPathStr);
//          end
//          else
//          begin
//          end;
//
//          AStringList.Add(Copy(SearchPathStr,ABeginIndex,AEndIndex-ABeginIndex));
//
//          ABeginIndex:=AEndIndex+1;
//          AEndIndex:=PosEx(';',SearchPathStr,AEndIndex+1);
//
//        until AEndIndex<=0;
//      end;
//    end;
//  finally
//    FreeAndNil(Reg);
//  end;
//end;
//
//procedure WriteFilePictureSearchPathsFromRegistry(AStringList:TStrings);
//var
//  I: Integer;
//  Reg:TRegistry;
//  SearchPathStr:String;
//begin
//  //设置注册表
//  Reg:=TRegistry.Create;
//  try
//    Reg.RootKey:=HKEY_CURRENT_USER;
//
//
//    if not Reg.KeyExists('\Software\OrangeUI\DrawPicture\') then
//    begin
//      Reg.OpenKey('\Software\OrangeUI\',True);
//      Reg.CreateKey('DrawPicture');
//      Reg.CloseKey;
//      Reg.OpenKey('\Software\OrangeUI\DrawPicture\',True);
//      Reg.CloseKey;
//    end;
//
//    if Reg.OpenKey('\Software\OrangeUI\DrawPicture\',True) then
//    begin
//
//      //注册表里有
//      SearchPathStr:='';
//
//      for I := 0 to AStringList.Count-1 do
//      begin
//        if Trim(AStringList[I])<>'' then
//        begin
//          SearchPathStr:=SearchPathStr+AStringList[I]+';';
//        end;
//      end;
//
//      Reg.WriteString('Search Path',SearchPathStr);
//
//    end;
//  finally
//    FreeAndNil(Reg);
//  end;
//end;
//
//
//{$ENDIF}








{ TDrawPicture }


procedure TBaseDrawPicture.Assign(Source: TPersistent);
var
  SrcObject:TBaseDrawPicture;
  DestObject:TBaseDrawPicture;
begin
  Inherited;

  if (Source <> nil) and (Source is TBaseDrawPicture) then
  begin

    DestObject:=TBaseDrawPicture(Self);
    SrcObject:=TBaseDrawPicture(Source);



    DestObject.FPictureDrawType:=SrcObject.FPictureDrawType;

    DestObject.FName:=SrcObject.FName;
    DestObject.FCaption:=SrcObject.FCaption;
    DestObject.FGroup:=SrcObject.FGroup;


    //图片列表
    DestObject.SetSkinImageList(SrcObject.FSkinImageList);
    DestObject.FImageIndex:=SrcObject.FImageIndex;
    DestObject.FImageName:=SrcObject.FImageName;



    DestObject.FUrl:=SrcObject.FUrl;

    DestObject.FFileName:=SrcObject.FFileName;

    DestObject.FResourceName:=SrcObject.FResourceName;


    //图片引用
    DestObject.FRefPicture:=SrcObject.FRefPicture;
    DestObject.FRefDrawPicture:=SrcObject.FRefDrawPicture;


    {$IFDEF VCL}
    //行数
    DestObject.FRowCount:=SrcObject.FRowCount;
    //列数
    DestObject.FColCount:=SrcObject.FColCount;
    //行下标
    DestObject.FRowIndex:=SrcObject.FRowIndex;
    //列下标
    DestObject.FColIndex:=SrcObject.FColIndex;
    {$ENDIF}


    //变更
    DestObject.DoChange;

  end;
end;

//procedure TBaseDrawPicture.LoadDownloadedUrlPicture(AUrlPicture: TUrlPicture);
//begin
//  //用到的时候再加载
//  if (AUrlPicture.State=dpsDownloadSucc)
//      //文件没有加载过
//      //and (AUrlPicture.Picture=nil)//万一Url换了呢?
//      //如果下载成功
//      //文件存在,而且文件内容大于0
//      and FileExists(AUrlPicture.GetOriginFilePath)
//    then
//  begin
//        if (AUrlPicture.Picture=nil) then//万一Url换了呢?
//        begin
//            //加载图片
//            AUrlPicture.Picture:=uDrawEngine.CreateCurrentEngineSkinPicture;
//
//            try
//
//                if IsCheckGIFWhenLoad then
//                begin
//                    //检查是否是GIF图片
//                    //检查是否是GIF,会比较耗时
//                    AUrlPicture.Picture.LoadFromFile(AUrlPicture.GetOriginFilePath);
//
//                end
//                else
//                begin
//
//                    //不检查是否是GIF图片,直接加载
//                    AUrlPicture.Picture.DirectLoadFromFile(AUrlPicture.GetOriginFilePath);
//
//
//    //                {$IFDEF FMX}
//    //                //剪裁成圆形
//    //                if Self.FIsClipRound then
//    //                begin
//    //                  AUrlPicture.ClipRoundPicture:=RoundSkinPicture(AUrlPicture.Picture,
//    //                                                                  Self.FClipRoundXRadis,
//    //                                                                  Self.FClipRoundYRadis,
//    //                                                                  Self.FClipRoundCorners);
//    //                end;
//    //                {$ENDIF FMX}
//    //
//    //
//    //                //加载下载的图片到自己
//    //                if IsLoadUrlPictureToSelf then
//    //                begin
//    //                  Self.DirectLoadFromFile(AUrlPicture.GetOriginFilePath);
//    //                end;
//
//                end;
//
//
//            finally
//    //          uBaseLog.OutputDebugString('TDownloadPictureManager.DownloadPicture 成功加载图片 end ');//+'耗时'+FloatToStr(DateUtils.MilliSecondsBetween(ABefore,Now)/1000));
//            end;
//        end;
//
//
//
//        {$IFDEF FMX}
//        //剪裁成圆形
//        if Self.FIsClipRound and (AUrlPicture.ClipRoundPicture=nil) then
//        begin
//          AUrlPicture.ClipRoundPicture:=RoundSkinPicture(AUrlPicture.Picture,
//                                                          Self.FClipRoundXRadis,
//                                                          Self.FClipRoundYRadis,
//                                                          Self.FClipRoundCorners);
//        end;
//        {$ENDIF FMX}
//
//
//
//        //加载下载的图片到自己
//        if IsLoadUrlPictureToSelf then
//        begin
//          Self.LoadFromFile(AUrlPicture.GetOriginFilePath);
//        end;
//
//
//
//  end;
//
//
//end;

procedure TBaseDrawPicture.Clear;
begin
  Inherited;



  FPictureDrawType:=pdtAuto;

  FSkinImageList:=nil;

  FRefPicture:=nil;
  FRefDrawPicture:=nil;



  ClearPicture;



  {$IFDEF VCL}
  //行数
  FRowCount:=1;
  //列数
  FColCount:=1;
  //行下标
  FRowIndex:=-1;
  //列下标
  FColIndex:=-1;
  {$ENDIF}



  //当前显示的下标
  FImageIndex:=-1;
  FImageName:='';



  FResourceName:='';
  FreeAndNil(FResourcePicture);
  FIsLoadedFromResource:=False;


  FUrl:='';
  FUrlPicture:=nil;
//  FPriorUrlPicture:=nil;



  FFileName:='';
  FreeAndNil(FFilePicture);
  FIsLoadedFromFile:=False;
  FLoadedFilePath:='';




  //当前效果的图片下标
  FCurrentEffectImageIndex:=-1;
  FCurrentEffectImageName:='';



end;

procedure TBaseDrawPicture.ClearPicture;
begin
  {$IFDEF FMX}
  SetSize(0,0);
  {$ENDIF}
  {$IFDEF VCL}
  Graphic:=nil;
  {$ENDIF}
  //不能清
//  FGIFStream.Clear;
end;

constructor TBaseDrawPicture.Create(const AName:String;
                                    const ACaption:String;
                                    const AGroup: String);
begin
  Inherited Create;

  FName:=AName;

  FGroup:=AGroup;

  FCaption:=ACaption;


  IsCheckGIFWhenLoad:=True;


  {$IFDEF VCL}
  //行数
  FRowCount:=1;
  //列数
  FColCount:=1;
  //行下标
  FRowIndex:=-1;
  //列下标
  FColIndex:=-1;
  {$ENDIF}



  //当前显示的下标
  FImageIndex:=-1;
  FImageName:='';


  FResourceName:='';
  FResourcePicture:=nil;
  FIsLoadedFromResource:=False;


  FUrl:='';
  FUrlPicture:=nil;


  FFileName:='';
  FFilePicture:=nil;
  FIsLoadedFromFile:=False;
  FLoadedFilePath:='';





  //当前效果的图片下标
  FCurrentEffectImageIndex:=-1;
  FCurrentEffectImageName:='';



  DefaultImageIndex:=-1;


  FSkinImageListChangeLink:=TSkinObjectChangeLink.Create;
  FSkinImageListChangeLink.OnChange:=OnSkinImageListChange;
  FSkinImageListChangeLink.OnDestroy:=OnSkinImageListDestroy;

end;


function TBaseDrawPicture.GetCurrentGIFStream: TMemoryStream;
var
  ASkinPicture:TSkinPicture;
begin
  Result:=nil;
  ASkinPicture:=Self.CurrentPicture;
  if ASkinPicture<>nil then
  begin
    Result:=ASkinPicture.GIFStream;
  end;
end;

function TBaseDrawPicture.GetCurrentIsGIF: Boolean;
begin
  Result:=Self.CurrentPictureIsGIF;
end;

function TBaseDrawPicture.GetDownloadPictureManager: TBaseDownloadPictureManager;
begin
  Result:=FDownloadPictureManager;



  //调用事件,获取指定的图片下载管理者
  if Result=nil then
  begin
    if Assigned(Self.FOnGetDownloadPictureManager) then
    begin
      FOnGetDownloadPictureManager(Self,Result);
    end;
  end;

  //如果没有获取到,那么使用全局的图片下载管理者
  if Result=nil then
  begin
    Result:=GetGlobalDownloadPictureManager;
  end;
end;

function TBaseDrawPicture.CurrentPicture: TSkinPicture;
var
  ASkinBaseImageList:TSkinBaseImageList;
begin
  Result:=nil;
  case Self.FPictureDrawType of
    pdtAuto:
    begin
      //自已的图片
      Result:=Inherited CurrentPicture;


      //引用图片
      if (FRefPicture<>nil) and ((Result=nil) or Result.IsEmpty) then
      begin
        Result:=Self.FRefPicture;
      end;


      //引用图片
      if (FRefDrawPicture<>nil) and  ((Result=nil) or Result.IsEmpty) then
      begin
        Result:=Self.FRefDrawPicture.CurrentPicture;
      end;



      //图片列表
      if (Result=nil) or Result.IsEmpty then
      begin
        Result:=ImageIndexPicture;
      end;



      //根据ImageName
      if (Result=nil) or Result.IsEmpty then
      begin
        Result:=ImageNamePicture;
      end;




      //根据文件路径
      if ((Result=nil) or Result.IsEmpty) and (FFileName<>'') then
      begin
        Result:=Self.FileNamePicture;
      end;



      //根据资源ID
      if ((Result=nil) or Result.IsEmpty) and ((FResourceName<>'') or (FFileName<>'')) then
      begin
        Result:=Self.ResourceNamePicture;
      end;




      //根据Url
      if ((Result=nil) or Result.IsEmpty) and (FUrl<>'') then
      begin
        Result:=Self.WebUrlPicture;
      end;


      //使用事件来获取图片
      if ((Result=nil) or Result.IsEmpty) and (FUrl='') then
      begin
        Result:=OnGetPictureEventPicture;
      end;


    end;
    pdtPicture:
    begin
      //自身
      Result:=Self;
    end;
    pdtImageList:
    begin
      //根据图片下标
      Result:=ImageIndexPicture;
    end;
    pdtImageName:
    begin
      //根据图片名称
      Result:=ImageNamePicture;
    end;
    pdtReference:
    begin
      //根据图片引用(TPicture)
      Result:=Self.FRefPicture;
    end;
    pdtRefDrawPicture:
    begin
      //根据图片引用(TDrawPicture)
      Result:=Self.FRefDrawPicture;
      if FRefDrawPicture<>nil then
      begin
        Result:=FRefDrawPicture.CurrentPicture;
      end;
    end;
    pdtFile:
    begin
      //文件图片
      Result:=Self.FileNamePicture;
    end;
    pdtResource:
    begin
      //资源图片
      Result:=Self.ResourceNamePicture;
    end;
    pdtUrl:
    begin
      //网页链接图片
      Result:=Self.WebUrlPicture;
    end;
    //使用事件来获取图片
    pdtOnGetPictureEvent:
    begin
      Result:=OnGetPictureEventPicture;
    end;



  end;


  //默认显示的图片
  if ((Self.DefaultImageName<>'') or (Self.DefaultImageIndex<>-1))
    and ((Result=nil) or ((Result<>nil) and Result.IsEmpty)) then
  begin
    ASkinBaseImageList:=FSkinImageList;


    if (ASkinBaseImageList=nil) and (Self.SkinImageListName<>'') then
    begin
      ASkinBaseImageList:=GlobalSkinBaseImageListList.Find(SkinImageListName);
    end;



    if (ASkinBaseImageList<>nil) and (Self.DefaultImageName<>'') then
    begin
      Result:=ASkinBaseImageList.PictureList.ItemsByName[DefaultImageName];
    end;


    if (ASkinBaseImageList<>nil) and (Self.DefaultImageIndex<>-1) then
    begin
      Result:=ASkinBaseImageList.PictureList.Items[DefaultImageIndex];
    end;


  end;



end;

procedure TBaseDrawPicture.SetDownloadPictureManager(const Value: TBaseDownloadPictureManager);
begin
  FDownloadPictureManager := Value;
end;

procedure TBaseDrawPicture.SetFileName(const Value: String);
begin
  if FFileName<>Value then
  begin
    FFileName := Value;
    Inherited Clear;
    FreeAndNil(FFilePicture);

    Self.FIsLoadedFromFile:=False;
    DoChange;
  end;
end;

procedure TBaseDrawPicture.SetImageIndex(const Value: Integer);
begin
  if FImageIndex<>Value then
  begin
    FImageIndex := Value;
    DoChange;
  end;
end;

procedure TBaseDrawPicture.SetImageName(const Value: String);
begin
  if FImageName<>Value then
  begin
    FImageName := Value;
    DoChange;
  end;
end;

procedure TBaseDrawPicture.SetPictureDrawType(const Value: TPictureDrawType);
begin
  if FPictureDrawType<>Value then
  begin
    FPictureDrawType := Value;
    DoChange;
  end;
end;

procedure TBaseDrawPicture.DoDownloadPictureStateChange(Sender: TObject;
  AUrlPicture: TUrlCacheItem);
begin

  //用到的时候再加载
  if (AUrlPicture.State=dpsDownloadSucc)
      //文件没有加载过
      //and (AUrlPicture.Picture=nil)//万一Url换了呢?
      //如果下载成功
      //文件存在,而且文件内容大于0
      and FileExists(AUrlPicture.GetOriginFilePath)
    then
  begin


        if (TUrlPicture(AUrlPicture).Picture=nil) then//万一Url换了呢?
        begin
            //加载图片
//            AUrlPicture.Picture:=uDrawEngine.CreateCurrentEngineSkinPicture;
            TUrlPicture(AUrlPicture).Picture:=TSkinPicture.Create();

            try

                if IsCheckGIFWhenLoad then
                begin
                    //检查是否是GIF图片
                    //检查是否是GIF,会比较耗时
                    TUrlPicture(AUrlPicture).Picture.LoadFromFile(AUrlPicture.GetOriginFilePath);

                end
                else
                begin

                    //不检查是否是GIF图片,直接加载
                    TUrlPicture(AUrlPicture).Picture.DirectLoadFromFile(AUrlPicture.GetOriginFilePath);


                end;


            finally
    //          uBaseLog.OutputDebugString('TDownloadPictureManager.DownloadPicture 成功加载图片 end ');//+'耗时'+FloatToStr(DateUtils.MilliSecondsBetween(ABefore,Now)/1000));
            end;
        end;



        //剪裁成圆形
        if Self.FIsClipRound and (TUrlPicture(AUrlPicture).ClipRoundPicture=nil) then
        begin
          {$IFDEF FMX}
            TUrlPicture(AUrlPicture).ClipRoundPicture:=RoundSkinPicture(TUrlPicture(AUrlPicture).Picture,
                                                                        Self.FClipRoundXRadis,
                                                                        Self.FClipRoundYRadis,
                                                                        Self.FClipRoundCorners);
          {$ENDIF FMX}
          {$IFDEF VCL}
            TUrlPicture(AUrlPicture).ClipRoundPicture:=RoundSkinPicture(TUrlPicture(AUrlPicture).Picture,
                                                                        Self.FClipRoundXRadis,
                                                                        Self.FClipRoundYRadis);
          {$ENDIF VCL}
        end;



        //加载下载的图片到自己
        if IsLoadUrlPictureToSelf then
        begin
          Self.LoadFromFile(AUrlPicture.GetOriginFilePath);
        end;


        DoChange;



  end;
end;

//procedure TBaseDrawPicture.DoUrlPictureDownloaded(AUrlPicture: TUrlPicture);
//begin
//  //检查图片是否下载成功,如果下载成功,那么加载
//  LoadDownloadedUrlPicture(AUrlPicture);
//
//  //重绘
//  Self.DoChange;
//end;

function TBaseDrawPicture.FileNamePicture: TSkinPicture;
var
  I: Integer;
  AScale:Integer;
  AScaleName:String;
  AFileNameNoExt:String;
  AFileExt:String;
begin
  if Not FIsLoadedFromFile then
  begin
      FLoadedFilePath:='';
      FreeAndNil(FFilePicture);


//      if FileExists(FFileName) then
//      begin
//        //找到了
//        FLoadedFilePath:=FFileName;
//      end
//      else if FileExists(uFileCommon.GetApplicationPath+FFileName) then
//      begin
//        //找到了
//        FLoadedFilePath:=uFileCommon.GetApplicationPath+FFileName;
//      end
//      else
//      begin
  //      if FilePictureSearchPaths=nil then
  //      begin
  //        //初始搜索路径
  //        {$IFDEF MSWINDOWS}
  //        //访问注册表,在设计时
  //        ReadFilePictureSearchPathsFromRegistry(FilePictureSearchPaths);
  //
  //        {$ENDIF}
  //      end;


//var
//  I: Integer;
//  AScale:Integer;
//  AScaleName:String;
//begin
//  Result:=nil;
//
        uBaseLog.HandleException(nil,'OrangeUI TBaseDrawPicture.FileNamePicture FFileName:'+FFileName+' Const_BufferBitmapScale:'+FloatToStr(Const_BufferBitmapScale));

        AFileNameNoExt:=GetFileNameWithoutExt(FFileName);
        AFileExt:=ExtractFileExt(FFileName);

        //搜索路径
//        uBaseLog.HandleException(nil,'OrangeUI TBaseDrawPicture.FileNamePicture GlobalFilePictureSearchPaths.Count:'+IntToStr(GlobalFilePictureSearchPaths.Count));
        for I := 0 to GlobalFilePictureSearchPaths.Count-1 do
        begin

//            uBaseLog.HandleException(nil,'OrangeUI TBaseDrawPicture.FileNamePicture GlobalFilePictureSearchPaths:'+GlobalFilePictureSearchPaths[I]);

            for AScale := Ceil(Const_BufferBitmapScale) downto 1 do
            begin
              AScaleName:=AFileNameNoExt;
              if AScale>1 then
              begin
                AScaleName:=AScaleName+'@'+IntToStr(AScale)+'x';
              end;

              if FileExists(GlobalFilePictureSearchPaths[I]+AScaleName+AFileExt) then
              begin
                FLoadedFilePath:=GlobalFilePictureSearchPaths[I]+AScaleName+AFileExt;
                //uBaseLog.HandleException(nil,'OrangeUI TBaseDrawPicture.FileNamePicture FLoadedFilePath:'+FLoadedFilePath+' Exists');
                Break;
              end
              else
              begin
                uBaseLog.HandleException(nil,'OrangeUI TBaseDrawPicture.FileNamePicture FLoadedFilePath:'+GlobalFilePictureSearchPaths[I]+AScaleName+AFileExt+' None');
              end;


            end;


        end;



//      end;


      if FLoadedFilePath<>'' then
      begin
//        FFilePicture:=uDrawEngine.CreateCurrentEngineSkinPicture;
        FFilePicture:=TSkinPicture.Create;
        FFilePicture.LoadFromFile(FLoadedFilePath);
      end;
      FIsLoadedFromFile:=True;
  end;
  Result:=FFilePicture;
end;

function TBaseDrawPicture.ResourceNamePicture: TSkinPicture;
var
  I: Integer;
  AResourceName:String;
var
  S: TStream;
begin
  if Not FIsLoadedFromResource then
  begin
    FreeAndNil(FResourcePicture);

    AResourceName:=Self.FResourceName;
    if (AResourceName='') and (FFileName<>'') then
    begin
      //取文件名
      AResourceName:=ExtractFileName(Self.FFileName);

      //如果存在
      AResourceName:=ReplaceStr(AResourceName,'@','_');
      AResourceName:=ReplaceStr(AResourceName,'.','_');

    end;


    {$IFDEF IOS}
    //在IOS和Android下面,资源文件是以文件来保存的
    //在Windows下面,资源文件保存在res文件中,编译到Exe中去的
    if (FFileName<>'') and FileExists(GetApplicationPath+FFileName) then
    begin
//      FResourcePicture:=uDrawEngine.CreateCurrentEngineSkinPicture;
      FResourcePicture:=TSkinPicture.Create;
      FResourcePicture.LoadFromFile(GetApplicationPath+FFileName);
    end;
    {$ENDIF}
    {$IFDEF ANDROID}
    //在IOS和Android下面,资源文件是以文件来保存的
    //在Windows下面,资源文件保存在res文件中,编译到Exe中去的
    if (FFileName<>'') and FileExists(GetApplicationPath+FFileName) then
    begin
//      FResourcePicture:=uDrawEngine.CreateCurrentEngineSkinPicture;
      FResourcePicture:=TSkinPicture.Create;
      FResourcePicture.LoadFromFile(GetApplicationPath+FFileName);
    end;
    {$ENDIF}


    {$IFDEF FMX}
    //从资源文件中加载
    if (FResourcePicture=nil)
      and (AResourceName<>'')
      and (System.FindResource(HInstance, PWideChar(AResourceName), RT_RCDATA)<>0) then
    begin
      S := TResourceStream.Create(HInstance, AResourceName, RT_RCDATA);
      try
//        FResourcePicture:=uDrawEngine.CreateCurrentEngineSkinPicture;
        FResourcePicture:=TSkinPicture.Create();
        FResourcePicture.LoadFromStream(S);
      finally
        FreeAndNil(S);
      end;
    end;
    {$ENDIF}


    FIsLoadedFromResource:=True;
  end;
  Result:=FResourcePicture;
end;

function TBaseDrawPicture.GetSkinImageList: TSkinBaseImageList;
begin
  //按FSkinImageList优先
  if FSkinImageList<>nil then
  begin
    Result:=FSkinImageList;
  end
  else
  begin
    Result:=nil;
    //如果没有FSkinImageList,那么调用FOnGetSkinImageList
    if Assigned(Self.FOnGetSkinImageList) then
    begin
      FOnGetSkinImageList(Self,Result);
    end;
  end;
end;

function TBaseDrawPicture.ImageIndexPicture: TSkinPicture;
begin
  Result:=nil;
  if (Self.SkinImageList<>nil) then
  begin

    if (Self.FCurrentEffectImageIndex<>-1)
      and (Self.FCurrentEffectImageIndex<Self.SkinImageList.Count) then
    begin
      Result:=Self.SkinImageList.PictureList[Self.FCurrentEffectImageIndex].CurrentPicture;
    end
    else if (Self.FImageIndex<>-1)
      and (Self.FImageIndex<Self.SkinImageList.Count) then
    begin
      Result:=Self.SkinImageList.PictureList[Self.FImageIndex].CurrentPicture;
    end;

  end;
end;

function TBaseDrawPicture.ImageNamePicture: TSkinPicture;
begin
  Result:=nil;
  //根据图片名称
  if (Self.SkinImageList<>nil) then
  begin

    if (Self.FCurrentEffectImageName<>'') and (Self.SkinImageList.PictureList.ItemsByName[FCurrentEffectImageName]<>nil) then
    begin
      Result:=Self.SkinImageList.PictureList.ItemsByName[FCurrentEffectImageName].CurrentPicture;
    end
    else if (Self.FImageName<>'') and (Self.SkinImageList.PictureList.ItemsByName[Self.FImageName]<>nil) then
    begin
      Result:=Self.SkinImageList.PictureList.ItemsByName[Self.FImageName].CurrentPicture;
    end;

  end;
end;

    {$IFDEF VCL}
function TBaseDrawPicture.IsColCountStroed: Boolean;
begin
  Result:=not (
                  (FColCount=1)
              and (FRowCount=1)
              and (FRowIndex=-1)
              and (FColIndex=-1)
              or
                  (FColCount=0)
              and (FRowCount=0)
              and (FRowIndex=0)
              and (FColIndex=0)
              or
                  (FColCount=0)
              and (FRowCount=0)
              and (FRowIndex=-1)
              and (FColIndex=-1)
              );
end;

function TBaseDrawPicture.IsColIndexStroed: Boolean;
begin
  Result:=not (
                  (FColCount=1)
              and (FRowCount=1)
              and (FRowIndex=-1)
              and (FColIndex=-1)
              or
                  (FColCount=0)
              and (FRowCount=0)
              and (FRowIndex=0)
              and (FColIndex=0)
              or
                  (FColCount=0)
              and (FRowCount=0)
              and (FRowIndex=-1)
              and (FColIndex=-1)
              );
end;
    {$ENDIF}


function TBaseDrawPicture.IsFileNameStroed: Boolean;
begin
  Result:=(FFileName<>'');
end;

function TBaseDrawPicture.IsImageIndexStroed: Boolean;
begin
  Result:=(FImageIndex<>-1);
end;

function TBaseDrawPicture.IsImageNameStroed: Boolean;
begin
  Result:=(FImageName<>'');
end;

function TBaseDrawPicture.IsPictureDrawTypeStroed: Boolean;
begin
  Result:=(FPictureDrawType<>pdtAuto);
end;

function TBaseDrawPicture.IsResourceNameStroed: Boolean;
begin
  Result:=(FResourceName<>'');
end;

    {$IFDEF VCL}
function TBaseDrawPicture.IsRowCountStroed: Boolean;
begin
  Result:=not (
                  (FColCount=1)
              and (FRowCount=1)
              and (FRowIndex=-1)
              and (FColIndex=-1)
              or
                  (FColCount=0)
              and (FRowCount=0)
              and (FRowIndex=0)
              and (FColIndex=0)
              or
                  (FColCount=0)
              and (FRowCount=0)
              and (FRowIndex=-1)
              and (FColIndex=-1)
              );

end;

function TBaseDrawPicture.IsRowIndexStroed: Boolean;
begin
  Result:=not (
                  (FColCount=1)
              and (FRowCount=1)
              and (FRowIndex=-1)
              and (FColIndex=-1)
              or
                  (FColCount=0)
              and (FRowCount=0)
              and (FRowIndex=0)
              and (FColIndex=0)
              or
                  (FColCount=0)
              and (FRowCount=0)
              and (FRowIndex=-1)
              and (FColIndex=-1)
              );

end;
    {$ENDIF}
function TBaseDrawPicture.IsUrlStroed: Boolean;
begin
  Result:=(FUrl<>'');
end;

function TBaseDrawPicture.CurrentPictureWidth: Integer;
var
  ACurrentPicture:TSkinPicture;
begin
  Result:=0;
  ACurrentPicture:=Self.CurrentPicture;
  if ACurrentPicture<>nil then
  begin
    Result:=ACurrentPicture.Width;
  end;
end;

function TBaseDrawPicture.CurrentPictureHeight: Integer;
var
  ACurrentPicture:TSkinPicture;
begin
  Result:=0;
  ACurrentPicture:=Self.CurrentPicture;
  if ACurrentPicture<>nil then
  begin
    Result:=ACurrentPicture.Height;
  end;
end;

function TBaseDrawPicture.CurrentPictureDrawWidth: Integer;
var
  ACurrentPicture:TSkinPicture;
begin
  Result:=0;
  ACurrentPicture:=Self.CurrentPicture;
  if ACurrentPicture<>nil then
  begin
    Result:=ACurrentPicture.Width;

    {$IFDEF VCL}
    if (Self.FColCount>=1) and (Self.FRowCount>=1) and (Self.ColIndex>-1) and (Self.RowIndex>-1) then
    begin
      Result:=Result div FColCount;
    end;
    {$ENDIF}

  end;
end;

function TBaseDrawPicture.CurrentPictureDrawHeight: Integer;
var
  ACurrentPicture:TSkinPicture;
begin
  Result:=0;
  ACurrentPicture:=Self.CurrentPicture;
  if ACurrentPicture<>nil then
  begin
    Result:=ACurrentPicture.Height;

    {$IFDEF VCL}
    if (Self.FColCount>=1) and (Self.FRowCount>=1) and (Self.ColIndex>-1) and (Self.RowIndex>-1) then
    begin
      Result:=Result div FRowCount;
    end;
    {$ENDIF}

  end;
end;

function TBaseDrawPicture.CurrentPictureDrawLeft: Integer;
    {$IFDEF VCL}
var
  ACurrentPicture:TSkinPicture;
    {$ENDIF}
begin
  Result:=0;

    {$IFDEF VCL}
  ACurrentPicture:=Self.CurrentPicture;
  if ACurrentPicture<>nil then
  begin
    if (Self.FColCount>=1) and (Self.FRowCount>=1) and (Self.ColIndex>-1) and (Self.RowIndex>-1) then
    begin
      Result:=ColIndex*(Self.CurrentPictureWidth div FColCount);
    end;
  end;
    {$ENDIF}
end;

function TBaseDrawPicture.CurrentPictureDrawTop: Integer;
    {$IFDEF VCL}
var
  ACurrentPicture:TSkinPicture;
    {$ENDIF}
begin
  Result:=0;
    {$IFDEF VCL}
  ACurrentPicture:=Self.CurrentPicture;
  if ACurrentPicture<>nil then
  begin
    if (Self.FColCount>=1) and (Self.FRowCount>=1) and (Self.ColIndex>-1) and (Self.RowIndex>-1) then
    begin
      Result:=RowIndex*(Self.CurrentPictureHeight div FRowCount);
    end;
  end;
    {$ENDIF}
end;

function TBaseDrawPicture.CurrentPictureIsEmpty: Boolean;
var
  ACurrentPicture:TSkinPicture;
begin
  Result:=True;
  ACurrentPicture:=Self.CurrentPicture;
  if ACurrentPicture<>nil then
  begin
    Result:=CurrentPicture.IsEmpty;
  end;
end;

function TBaseDrawPicture.CurrentPictureIsGIF: Boolean;
var
  ACurrentPicture:TSkinPicture;
begin
  Result:=False;
  ACurrentPicture:=Self.CurrentPicture;
  if ACurrentPicture<>nil then
  begin
    Result:=ACurrentPicture.HasGIFStream;
  end;
end;

procedure TBaseDrawPicture.SetRefPicture(const Value: TSkinPicture);
begin
  if FRefPicture<>Value then
  begin
    FRefPicture:=Value;
    DoChange;
  end;
end;

procedure TBaseDrawPicture.SetRefDrawPicture(const Value: TDrawPicture);
begin
  if FRefDrawPicture<>Value then
  begin
    FRefDrawPicture:=Value;
    DoChange;
  end;
end;

procedure TBaseDrawPicture.SetResourceName(const Value: String);
begin
  if FResourceName<>Value then
  begin
    FResourceName := Value;
    FreeAndNil(FResourcePicture);
    FIsLoadedFromResource:=False;
    DoChange;
  end;
end;

procedure TBaseDrawPicture.SetSkinImageList(const Value: TSkinBaseImageList);
begin
  if FSkinImageList<>Value then
  begin
    if FSkinImageList <> nil then
    begin
      FSkinImageList.UnRegisterChanges(FSkinImageListChangeLink);
    end;

    FSkinImageList:=Value;

    if FSkinImageList <> nil then
    begin
      FSkinImageList.RegisterChanges(FSkinImageListChangeLink);
    end;

    DoChange;
  end;
end;

procedure TBaseDrawPicture.SetUrl(const Value: String);
begin
  if FUrl<>Value then
  begin
      FUrl := Value;



      if Self.FUrlPicture<>nil then
      begin
//        FUrlPicture.DrawPictureList.Remove(Self)
        FUrlPicture.FDownloadItemStateNotifyEventList.Del(Self);
      end;




      FUrlPicture:=nil;



      //如果是加载下载的图片到自己就清除
      if IsLoadUrlPictureToSelf then
      begin
        Self.SetSize(0,0);
      end;

      DoChange;

  end;
end;

function TBaseDrawPicture.WebUrlPicture: TSkinPicture;
begin
  Result:=nil;


  if (Self.FUrlPicture=nil) and (FUrl<>'') then
  begin
      if Assigned(Self.FOnChange) then
      begin
        uBaseLog.HandleException('TBaseDrawPicture.WebUrlPicture FOnChange<>nil')
      end;
      


      //不存在,则查找或下载
      FUrlPicture:=TUrlPicture(GetDownloadPictureManager.Download(FUrl,
                                                      Self,
                                                      nil,
                                                      '',
                                                      '',
                                                      Name+Caption,
                                                      DoDownloadPictureStateChange));
      //wn
//      if FUrlPicture<>nil then
//      begin
//        //调用ADrawPicture.DoChange;
//        //FUrlPicture.DoDrawPictureListChanage(FUrlPicture);
//        Self.DoChange;
//      end;


      //wn
//      //判断图片是否已经下载,如果已经下载,那么直接使用
//      Self.LoadDownloadedUrlPicture(FUrlPicture);

  end;




  if (Self.FUrlPicture<>nil) then
  begin

      //上次使用时间,用于释放
      FUrlPicture.LastUseTime:=Now;
  

      if (Self.FUrlPicture.Picture<>nil)
          //wn下载成功后再加载图片
          and (FUrlPicture.State=dpsDownloadSucc) then
      begin


            
            //下载成功,并且已经从文件加载
            if Self.FIsClipRound  then
            begin
                //需要圆角图片
                if (Self.FUrlPicture.ClipRoundPicture=nil) then
                begin
                    //剪裁成圆形
                    if Self.FIsClipRound then
                    begin
                      {$IFDEF FMX}
                      FUrlPicture.ClipRoundPicture:=RoundSkinPicture(FUrlPicture.Picture,
                                                                      Self.FClipRoundXRadis,
                                                                      Self.FClipRoundYRadis,
                                                                      Self.FClipRoundCorners);
                      {$ENDIF FMX}
                      {$IFDEF VCL}
                      FUrlPicture.ClipRoundPicture:=RoundSkinPicture(FUrlPicture.Picture,
                                                                      Self.FClipRoundXRadis,
                                                                      Self.FClipRoundYRadis);
                      {$ENDIF FMX}
                    end;
                end;

                //圆形
                Result:=Self.FUrlPicture.ClipRoundPicture;
            end
            else
            begin
                Result:=Self.FUrlPicture.Picture;
            end;

      end
      else
      begin

            //返回下载状态图片
            case FUrlPicture.State of
              dpsNone:
              begin
                uBaseLog.OutputDebugString('OrangeUI TBaseDrawPicture.WebUrlPicture UrlPicture.State None');
              end;
              dpsWaitDownload:
              begin
                  uBaseLog.OutputDebugString('OrangeUI TBaseDrawPicture.WebUrlPicture UrlPicture.State WaitDownload');
                  //准备下载
                  Result:=TDownloadPictureManager(GetDownloadPictureManager).WaitDownloadPicture;
              end;
              dpsDownloading:
              begin
//                  uBaseLog.OutputDebugString('OrangeUI TBaseDrawPicture.WebUrlPicture UrlPicture.State Downloading');
                  //正在下载
                  Result:=TDownloadPictureManager(GetDownloadPictureManager).DownloadingPicture;
              end;
              dpsDownloadSucc:
              begin
                  uBaseLog.OutputDebugString('OrangeUI TBaseDrawPicture.WebUrlPicture UrlPicture.State DownloadSucc');
                  //如果已经从Url下载到图片,但是还没有从文件加载
                  //Result:=TDownloadPictureManager(GetDownloadPictureManager).DownloadingPicture;
                  //从文件加载
                  //Self.LoadDownloadedUrlPicture(FUrlPicture);
              end;
              dpsDownloadFail:
              begin
                  uBaseLog.OutputDebugString('OrangeUI TBaseDrawPicture.WebUrlPicture UrlPicture.State DownloadFail');
                  //下载失败
                  Result:=TDownloadPictureManager(GetDownloadPictureManager).DownloadFailPicture;
              end;
              dpsDownloadImageInvalid:
              begin
                  uBaseLog.OutputDebugString('OrangeUI TBaseDrawPicture.WebUrlPicture UrlPicture.State DownloadImageInvalid');
                  //图片非法
                  Result:=TDownloadPictureManager(GetDownloadPictureManager).ImageInvalidPicture;
              end;
            end;


      end;


  end;


end;

function TBaseDrawPicture.OnGetPictureEventPicture: TSkinPicture;
begin
  Result:=nil;
  if Assigned(Self.OnGetPicture) then
  begin
    OnGetPicture(Self,Result);
  end;
end;

procedure TBaseDrawPicture.OnSkinImageListChange(Sender: TObject);
begin
//  if Sender = FSkinImageList then
//  begin
//    if FSkinImageList.SkinObjectChangeManager.IsDestroy then
//    begin
//      Self.SetSkinImageList(nil);
//    end
//    else
//    begin
      DoChange;
//    end;
//  end;
end;

procedure TBaseDrawPicture.OnSkinImageListDestroy(Sender: TObject);
begin
//  Self.SetSkinImageList(nil);
  FSkinImageList:=nil;
end;

//procedure TBaseDrawPicture.DefineProperties(Filer: TFiler);
//begin
//  uBaseLog.HandleException(nil,'TSkinPicture.DefineProperties Begin');
//  uBaseLog.HandleException(nil,'TSkinPicture.DefineProperties FName:'+Self.FName);
//
//  inherited;
//
//
//  uBaseLog.HandleException(nil,'TSkinPicture.DefineProperties End');
//end;

destructor TBaseDrawPicture.Destroy;
begin

  //如果释放了,而且还没有启动下载,那么停止下载即可
  if Self.FUrlPicture<>nil then
  begin
//    FUrlPicture.DrawPictureList.Remove(Self)
    FUrlPicture.FDownloadItemStateNotifyEventList.Del(Self);
  end;


//  if FIsAddToGlobalList then
//  begin
//    GlobalDrawPictureList.Remove(Self);
//  end;
  FOnChange:=nil;
//  FreeAndNil(FUrlPicture);//属于DownloadPictureManager
  FreeAndNil(FFilePicture);
  FreeAndNil(FResourcePicture);
  FreeAndNil(FSkinImageListChangeLink);
  inherited;
end;

function TBaseDrawPicture.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I:Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];


    {$IFDEF VCL}
    if ABTNode.NodeName='RowCount' then
    begin
      FRowCount:=ABTNode.ConvertNode_Int32.Data;
    end
    else if ABTNode.NodeName='ColCount' then
    begin
      FColCount:=ABTNode.ConvertNode_Int32.Data;
    end
    else if ABTNode.NodeName='RowIndex' then
    begin
      FRowIndex:=ABTNode.ConvertNode_Int32.Data;
    end
    else if ABTNode.NodeName='ColIndex' then
    begin
      FColIndex:=ABTNode.ConvertNode_Int32.Data;
    end
    else
    {$ENDIF}
    if ABTNode.NodeName='PictureDrawType' then
    begin
      FPictureDrawType:=TPictureDrawType(ABTNode.ConvertNode_Int32.Data);
    end
    else if ABTNode.NodeName='ImageIndex' then
    begin
      FImageIndex:=ABTNode.ConvertNode_Int32.Data;
    end
    else if ABTNode.NodeName='ImageName' then
    begin
      FImageName:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='FileName' then
    begin
      FFileName:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='ResourceName' then
    begin
      FResourceName:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='Url' then
    begin
      FUrl:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='IsClipRound' then
    begin
      FIsClipRound:=ABTNode.ConvertNode_Bool32.Data;
    end


    ;
  end;

  Result:=True;
end;

function TBaseDrawPicture.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

  //保存类类型
  ADocNode.ClassName:='TDrawPicture';

  //保存名称
  ABTNode:=ADocNode.AddChildNode_WideString('Name','名称');
  ABTNode.ConvertNode_WideString.Data:=FName;

  ABTNode:=ADocNode.AddChildNode_WideString('Caption','标题');
  ABTNode.ConvertNode_WideString.Data:=FCaption;

  ABTNode:=ADocNode.AddChildNode_WideString('Group','分组');
  ABTNode.ConvertNode_WideString.Data:=FGroup;


  {$IFDEF VCL}
  ABTNode:=ADocNode.AddChildNode_Int32('RowCount','行数');
  ABTNode.ConvertNode_Int32.Data:=FRowCount;

  ABTNode:=ADocNode.AddChildNode_Int32('ColCount','列数');
  ABTNode.ConvertNode_Int32.Data:=FColCount;

  ABTNode:=ADocNode.AddChildNode_Int32('RowIndex','行下标');
  ABTNode.ConvertNode_Int32.Data:=FRowIndex;

  ABTNode:=ADocNode.AddChildNode_Int32('ColIndex','列下标');
  ABTNode.ConvertNode_Int32.Data:=FColIndex;
  {$ENDIF}


  ABTNode:=ADocNode.AddChildNode_Int32('PictureDrawType','绘制类型');
  ABTNode.ConvertNode_Int32.Data:=Ord(FPictureDrawType);

  ABTNode:=ADocNode.AddChildNode_Int32('ImageIndex','图片下标');
  ABTNode.ConvertNode_Int32.Data:=FImageIndex;

  ABTNode:=ADocNode.AddChildNode_WideString('ImageName','图片名称');
  ABTNode.ConvertNode_WideString.Data:=FImageName;


  ABTNode:=ADocNode.AddChildNode_WideString('FileName','图片文件名');
  ABTNode.ConvertNode_WideString.Data:=FFileName;

  ABTNode:=ADocNode.AddChildNode_WideString('ResourceName','图片资源名称');
  ABTNode.ConvertNode_WideString.Data:=FResourceName;

  ABTNode:=ADocNode.AddChildNode_WideString('Url','图片链接');
  ABTNode.ConvertNode_WideString.Data:=FUrl;

  ABTNode:=ADocNode.AddChildNode_Bool32('IsClipRound','是否剪裁成圆形');
  ABTNode.ConvertNode_Bool32.Data:=FIsClipRound;

  Result:=True;
end;

{ TDrawPictureList }

function TDrawPictureList.GetItem(Index: Integer): TDrawPicture;
begin
  Result:=TDrawPicture(Inherited Items[Index]);
end;


function TDrawPictureList.GetItemByName(const AName: String): TDrawPicture;
var
  I: Integer;
  AScale:Integer;
  AScaleName:String;
begin
  Result:=nil;

  for AScale := Ceil(Const_BufferBitmapScale) downto 1 do
  begin
    AScaleName:=AName;
    if AScale>1 then
    begin
      AScaleName:=AScaleName+'@'+IntToStr(AScale)+'x';
    end;
    for I := 0 to Self.Count-1 do
    begin
      if Items[I].ImageName=AScaleName then
      begin
        Result:=Items[I];
        Break;
      end;
    end;
  end;
end;


{$IFDEF VCL}
function TDrawPictureList.AddGraphic(AGraphic: TGraphic): Integer;
var
  ASkinPicture:TDrawPicture;
begin
  ASkinPicture:=TDrawPicture.Create('','');
  ASkinPicture.Assign(AGraphic);
  Result:=Self.Add(ASkinPicture);
end;

function TDrawPictureList.AddPicture(APicture: TPicture): Integer;
begin
  Result:=Self.AddGraphic(APicture.Graphic);
end;
{$ENDIF}

function TDrawPictureList.AddPictureFile(const APictureFile: String): Integer;
var
  ADrawPicture:TDrawPicture;
begin
//  ADrawPicture:=CreateCurrentEngineDrawPicture('','');
  ADrawPicture:=TDrawPicture.Create('','');
  ADrawPicture.LoadFromFile(APictureFile);
  Result:=Inherited Add(ADrawPicture);
end;

function TDrawPictureList.Add: TDrawPicture;
begin
//  Result:=CreateCurrentEngineDrawPicture('','');
  Result:=TDrawPicture.Create('','');
  Inherited Add(Result);
end;

function TDrawPictureList.AddFileNameOnly(const AFileName: String): Integer;
var
  ADrawPicture:TDrawPicture;
begin
//  ADrawPicture:=CreateCurrentEngineDrawPicture('','');
  ADrawPicture:=TDrawPicture.Create('','');
  ADrawPicture.FileName:=ExtractFileName(AFileName);
  Result:=Inherited Add(ADrawPicture);
end;

procedure TDrawPictureList.ReplacePictureFile(const AIndex: Integer;const APictureFile: String);
var
  ADestDrawPicture:TDrawPicture;
  ASrcSkinPicture:TDrawPicture;
begin
//  ADestDrawPicture:=CreateCurrentEngineDrawPicture('','');
  ADestDrawPicture:=TDrawPicture.Create('','');
  ADestDrawPicture.LoadFromFile(APictureFile);;
  ASrcSkinPicture:=Self.Items[AIndex];
  Self.Items[AIndex]:=ADestDrawPicture;
  FreeAndNil(ASrcSkinPicture);
end;

procedure TDrawPictureList.ReplaceFileNameOnly(const AIndex: Integer;const AFileName: String);
begin
  Self.Items[AIndex].FileName:=ExtractFileName(AFileName);
end;

procedure TDrawPictureList.SetItem(Index: Integer; const Value: TDrawPicture);
begin
  Inherited Items[Index]:=Value;
end;

function TDrawPictureList.CreateBinaryObject(const AClassName:String=''):TInterfacedPersistent;
begin
  //创建临时图片
//  Result:=CreateCurrentEngineDrawPicture('','','');
  Result:=TDrawPicture.Create('','','');
end;



function TDrawPictureList.FindImageNameIndex(AImageName: String): Integer;
var
  I: Integer;
begin
  Result:=-1;

  for I := 0 to Self.Count-1 do
  begin
    if Items[I].ImageName=AImageName then
    begin
      Result:=I;
      Break;
    end;
  end;

end;

{ TSkinBaseImageList }

constructor TSkinBaseImageList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FSkinObjectChangeManager:=TSkinObjectChangeManager.Create(Self);

  FPictureList:=TDrawPictureList.Create;
  FPictureList.OnChange:=DoPictureListChange;



  GlobalSkinBaseImageListList.Add(Self);
end;

destructor TSkinBaseImageList.Destroy;
begin

  FSkinObjectChangeManager.BeginDestroy(Self);

  FreeAndNil(FPictureList);
  FPictureList:=nil;

//  FreeAndNil(FSkinObjectChangeManager);
  //通知控件去掉引用它,从FSkinObjectChangeManager中删除控件
  inherited Destroy;

  //才能再释放FSkinObjectChangeManager
  FreeAndNil(FSkinObjectChangeManager);


  if GlobalSkinBaseImageListList<>nil then
  begin
    GlobalSkinBaseImageListList.Remove(Self,False);
  end;

end;

procedure TSkinBaseImageList.DoChange;
begin
  FSkinObjectChangeManager.DoChange(Self);
end;

function TSkinBaseImageList.Count: Integer;
begin
  Result:=Self.FPictureList.Count;
end;

procedure TSkinBaseImageList.UnRegisterChanges(Value: TSkinObjectChangeLink);
begin
  //在ImageList释放时,FSkinObjectChangeManager可能已经被释放了
  //因此要加这个判断
  if FSkinObjectChangeManager<>nil then
  begin
    Self.FSkinObjectChangeManager.UnRegisterChanges(Value);
  end;
end;

procedure TSkinBaseImageList.RegisterChanges(Value: TSkinObjectChangeLink);
begin
  Self.FSkinObjectChangeManager.RegisterChanges(Value);
end;

procedure TSkinBaseImageList.BeginUpdate;
begin
  Self.FSkinObjectChangeManager.BeginUpdate;
end;

procedure TSkinBaseImageList.EndUpdate;
begin
  FSkinObjectChangeManager.EndUpdate();
end;

procedure TSkinBaseImageList.SetPictureList(const Value: TSkinPictureList);
begin
  FPictureList.Assign(Value);
end;

procedure TSkinBaseImageList.DoPictureListChange(Sender: TObject);
begin
  DoChange;
end;

function TSkinBaseImageList.GetOnChange: TNotifyEvent;
begin
  Result:=Self.FSkinObjectChangeManager.OnChange;
end;

procedure TSkinBaseImageList.SetOnChange(const Value: TNotifyEvent);
begin
  Self.FSkinObjectChangeManager.OnChange:=Value;
end;




{ TSkinBaseImageListList }

function TSkinBaseImageListList.Find(
  AComponentName: String): TSkinBaseImageList;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Count-1 do
  begin
    if Items[I].Name=AComponentName then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TSkinBaseImageListList.GetItem(Index: Integer): TSkinBaseImageList;
begin
  Result:=TSkinBaseImageList(Inherited Items[Index]);
end;

initialization
  GlobalSkinBaseImageListList:=TSkinBaseImageListList.Create(ooReference);

finalization
  FreeAndNil(GlobalSkinBaseImageListList);

end.




