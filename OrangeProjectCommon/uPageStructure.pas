//convert pas to utf8 by ¥
unit uPageStructure;



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
  Types,
  DB,

  {$IFDEF VCL}
  ExtCtrls,
  StdCtrls,
  Graphics,
  Dialogs,
  {$ENDIF VCL}

  {$IFDEF FMX}
  FMX.Controls,
  FMX.Types,
  FMX.Dialogs,
  FMX.Edit,
  FMX.ComboEdit,
  FMX.ListBox,
  FMX.StdCtrls,
  FMX.Memo,
  FMX.Graphics,
  FMX.Forms,
  HintFrame,
  MessageBoxFrame,
  WaitingFrame,
  uUIFunction,
  uSkinCommonFrames,
  System.IOUtils,
  {$ENDIF FMX}

  {$IFDEF VCL}
  Forms,
  Controls,
  {$ENDIF VCL}


//  uLang,
  uDrawParam,
  uOpenCommon,
  uGraphicCommon,
  uSkinItems,
  uSkinMaterial,
  uSkinListLayouts,
  uSkinListViewType,
  uComponentType,
  uSkinRegManager,
  uBaseList,
  uBaseLog,
  IdURI,
  Math,
  Variants,


  {$IF CompilerVersion <= 21.0} // Delphi 2010以前
  SuperObject,
  superobjecthelper,
  {$ELSE}
    {$IFDEF SKIN_SUPEROBJECT}
    uSkinSuperObject,
    {$ELSE}
    XSuperObject,
    XSuperJson,
    {$ENDIF}
  {$IFEND}


  IniFiles,
//  uOpenCommon,
  uBaseSkinControl,
  uDrawTextParam,
  uDrawPictureParam,
  uDrawRectParam,
//  uSkinPageControl,
//  uBasePageStructure,
  uSkinVirtualListType,
  uSkinItemDesignerPanelType,
  uDataInterface,
//  uTableCommonRestCenter,
  uLang,
//  uComponentType,
  uSkinItemJsonHelper,
  uBasePageStructure,
  uFrameContext,


//  System.Math.Vectors,
//  System.UIConsts,
//  UITypes,
//  System.Net.URLClient,


//  uSkinCommonFrames,
//  uTimerTask,
  DateUtils,
//  XSuperObject,
  uFuncCommon,
  uFileCommon,
//  uBaseHttpControl,
  uRestInterfaceCall,
  uBaseHttpControl,


  uDatasetToJson,


  uSkinPageControlType,
  uUrlPicture,


  uDrawCanvas,
//  uOpenClientCommon,



  StrUtils,
  uTimerTask,
  uTimerTaskEvent;






Const
  SUCC=200;
  FAIL=400;


const
  //组件设计时的尺寸
  COMPONENT_DESIGN_SIZE=48;



const
  IID_ITextSettings:TGUID='{FD99635D-D8DB-4E26-B36F-97D3AABBCCB3}';

type
  TPageList=class;
  TPage=class;
  TPageInstance=class;
  TFieldControlSettingMap=class;
//  TPageInstance=class;
  TFieldControlSettingMapList=class;


  //因为我Json用的是XSuperObject
  //但是XSuperObject编译成C++Builder会编译不过,
  //而且很多控件包中都包含了XSuperObject,
  //所以要从控件包中独立出来,做一个Helper
  TFieldControlSettingHelper=class helper for TFieldControlSetting
  public
    function SaveToJson(AJson:ISuperObject):Boolean;
    function LoadFromJson(AJson:ISuperObject):Boolean;

    //只保留更改过的字段
    function SaveToUpdateJson(AJson:ISuperObject;AOldSetting:TFieldControlSetting;var AIsChanged:Boolean):Boolean;
  end;




//  //服务端
//  TDataServer=class
//  public
//    fid:Integer;
//    appid:Integer;
//    user_fid:Integer;
//    template_fid:Integer;
//
//    name:String;
//    caption:String;
//    description:String;
//
//    url:String;
//    image_url:String;
//
//
//  end;



//  //服务端接口
//  TDataInterface=class
//  public
//    Name:String;
//    Caption:String;
//    //分直连数据库,网络接口调用等
//    IntfType:String;//
//    TableCommonRestName:String;//
//
////    GetRecordListPageJsonDataRootKey:String;
//    //'RecordList'
////    get_record_list_json_root_key:String;
//
//
//    //本地调用数据库的接口
//    FCommonRestIntfItem:TCommonRestIntfItem;
//  public
//    constructor Create;
//    destructor Destroy;override;
//  public
//    function LoadFromJson(AJson:ISuperObject):Boolean;
//    function SaveToJson(AJson:ISuperObject):Boolean;
//
//  end;
//  TDataInterfaceList=class(TBaseList)
//  private
//    function GetItem(Index: Integer): TDataInterface;
//  public
//    property Items[Index:Integer]:TDataInterface read GetItem;default;
//  end;





  //程序模板
  TProgramTemplate=class
  private
    tteGetPage: TTimerTaskEvent;
    FOnGetPageExecuteEnd:TTimerTaskNotify;
    procedure tteGetPageBegin(ATimerTask: TTimerTask);
    procedure tteGetPageExecute(ATimerTask: TTimerTask);
    //加载好页面结构,打开
    procedure tteGetPageExecuteEnd(ATimerTask: TTimerTask);
  public
    fid:Integer;
    appid:Integer;
    user_fid:String;


    name:String;
    caption:String;
    description:String;

//    //接口列表
//    DataIntfList:TDataInterfaceList;


    //页面列表
    PageList:TPageList;

    IsLoaded:Boolean;
    FLoadedJsonFilePath:String;
  public
    constructor Create;
    destructor Destroy;override;
  public
    function LoadFromFile(AJsonFilePath:String):Boolean;
    function SaveToFile(AJsonFilePath:String):Boolean;

    function LoadFromJson(AJson:ISuperObject):Boolean;
    function SaveToJson(AJson:ISuperObject):Boolean;

//    procedure LoadFromLocal;
//    procedure SaveToLocal;
    function GetProgramTemplateDir:String;
  public
    function IsLocal:Boolean;
    procedure Clear;
    function NewPage:TPage;


    //从服务器加载程序模板
    function LoadFromServer(AInterfaceUrl:String;
                            AAppID:Integer;
                            AProgramTemplateName:String;
                            var ADesc:String):Boolean;
    //加载页面,根根Program,Function,PageType
    function LoadPage(AProgram:String;
                      AFunction:String;
                      APageType:String;
                      //可以为空
                      APageName:String;
                      APlatform:String;
                      AOnGetPageExecuteEnd: TTimerTaskNotify):Boolean;overload;
    //加载页面,根据PageFID
    function LoadPage(APageFID:Integer;
                      AOnGetPageExecuteEnd: TTimerTaskNotify):Boolean;overload;
  end;






//  //功能
//  TDataFunction=class
//
//  end;






  //页面区域的控件布局
  TLayoutSetting=class
  public
    //main/bottom_toolbar
    name:String;

    //排列类型,auto,manual
    align_type:String;


    //控件排几列,一般是一列
    col_count:Integer;
    //控件的宽度,-1表示页面宽度
    col_width:double;
    //控件的高度
    row_height:double;
    //控件的间隔
    row_space:double;



    //提示文本的宽度
    hint_label_width:double;

    //控件的左边距
    margins_left:double;
    margins_top:double;
    margins_right:double;
    margins_bottom:double;


    function LoadFromJson(AJson:ISuperObject):Boolean;
    function SaveToJson(AJson:ISuperObject):Boolean;

  end;




  //列表项的属性和数据字段的绑定
  {"ItemCaption":"name","ItemDetail":"desc"}
  TListItemBindingItem=class(TCollectionItem)
  private
    Fitem_field_name: String;
    Fdata_field_name: String;
  published
    //Item的属性,比如ItemCaption,ItemDetail,ItemIcon等
    property item_field_name:String read Fitem_field_name write Fitem_field_name;
    //比如Name,Sex,Age,数据记录的字段
    property data_field_name:String read Fdata_field_name write Fdata_field_name;
  end;
  TListItemBindings=class(TCollection)
  private
    function GetItem(Index: Integer): TListItemBindingItem;
  public
    function Add:TListItemBindingItem;
    property Items[Index:Integer]:TListItemBindingItem read GetItem;default;
  public
    procedure LoadFromJson(AJson:ISuperObject);
    procedure SaveToJson(AJson:ISuperObject);
  end;




  //自定义检测每个控件输入的值,也可以自定义返回值
  TOnCustomCheckControlInputValueEvent=procedure(Sender:TObject;
                                            APageInstance:TPageInstance;
                                            AControlMap:TFieldControlSettingMap;
                                            var AInputValue:Variant;
                                            //是否可以提交
                                            var AIsCanPost:Boolean);

  //自定义提交的参数
  TOnCustomPostJsonEvent=procedure(Sender:TObject;
                                    APageInstance:TPageInstance;
                                    APostJson:ISuperObject;
                                    //检测每个参数是否合格
                                    //是否可以提交
                                    var AIsCanPost:Boolean
                                    ) of object;

  //自定义调用加载数据的接口
  TOnCustomCallLoadDataIntfEvent=procedure(Sender:TObject;
                                    APageInstance:TPageInstance;
                                    var ALoadDataSetting:TLoadDataSetting;
                                    ALoadDataIntfResult:TDataIntfResult) of object;
  //自定义调用保存数据的接口
  TOnCustomCallSaveDataIntfEvent=procedure(Sender:TObject;
                                    APageInstance:TPageInstance;
                                    var ASaveDataSetting:TSaveDataSetting;
                                    ASaveDataIntfResult:TDataIntfResult) of object;
  //页面自定义加载数据到界面上的事件
  TPageLoadedDataToUIEvent=procedure(Sender:TObject;
                                     APage:TPage;
                                     APageInstance:TPageInstance;
                                     ALoadDataSetting:TLoadDataSetting;
                                     ALoadDataIntfResult:TDataIntfResult;
                                     ALoadDataIntfResult2:TDataIntfResult) of object;


  //页面的结构
  TPage=class(TComponent)
  private
    //列表页面的静态列表项列表
    FDataSkinItems: TSkinItems;


    FBottomToolbarLayoutControlList: TFieldControlSettingList;
    FMainLayoutControlList: TFieldControlSettingList;
    FOnCustomCallSaveDataIntf: TOnCustomCallSaveDataIntfEvent;
    FOnCustomCallLoadDataIntf: TOnCustomCallLoadDataIntfEvent;
    FOnLoadedDataToUI: TPageLoadedDataToUIEvent;
    procedure SetDataSkinItems(const Value: TSkinItems);
    procedure SetBottomToolbarLayoutControlList(
      const Value: TFieldControlSettingList);
    procedure SetMainLayoutControlList(const Value: TFieldControlSettingList);
    procedure SetDefaultListItemBindings(const Value: TListItemBindings);
  public
    //程序模板
    ProgramTemplate:TProgramTemplate;
    //接口,主接口
    DataInterface:TDataInterface;
    //接口2,用于调用第二个存储过程,专门用于医院界面设计器
    DataInterface2:TDataInterface;

//    //服务端
//    DataServer:TDataServer;
//    //功能模块
//    DataFunction:TDataFunction;
  public


    //所属的程序模块
    program_template_fid:Integer;
    //有个名字好记好懂
    program_template_name:String;


    //所调用的接口
    data_intf_fid:Integer;
    //有个名字好记好懂
    data_intf_name:String;

    //所调用的接口
    data_intf_fid2:Integer;
    //有个名字好记好懂
    data_intf_name2:String;


    //所属的功能
    function_fid:Integer;
    //有个名字好记好懂
    function_name:String;



  public
    //页面的数据库字段
    fid:Integer;
    appid:Integer;


    //页面的名称
    //name:String;
    //页面的标题
    caption:String;


    //排列布局类型,
    //manual手动布局,
    //auto自动布局,框架页面一般是自动布局
    align_type:String;


    //页面类型,list_page,edit_page,view_page,custom_page,list_item_style
    page_type:String;
    //平台,web,pc,app,wxapp
    platform:String;


  public
    //为医院设计器加的
    //设计器里设计时的宽度和高度
    design_width:Double;
    design_height:Double;


    //页面刷新间隔
    refresh_seconds:Integer;



    //加载接口1需要的参数,Json
    //[{"name":"fid","value_from":"local_data_source","value_key":"office_fid"},{"name":"appid","value_from":"const","value":1010}]
    load_data_params:String;
    //保存接口1所需要的参数,Json
    save_data_params:String;


    //加载接口2需要的参数,Json
    //[{"name":"fid","value_from":"local_data_source","value_key":"office_fid"},{"name":"appid","value_from":"const","value":1010}]
    load_data_params2:String;
    //保存接口2所需要的参数,Json
    save_data_params2:String;



  public
    //列表页面，或者界面控件布局//
    //每行列表项的列数
    item_col_count:Integer;
    //每列列表项的宽度
    item_col_width:Integer;
    //列表项的行高
    item_height:Integer;




    //列表页面相关设置//
    //是否是默认的ListPage,
    //如果是就创建一个默认的ListView
//    is_simple_list_page:Integer;
    //列表页面是否需要添加记录按钮
    has_add_record_button:Integer;

    data_list_field_name:String;
    data_list_other_field_name:String;



    //默认列表项的显示风格,比如Default,SaleManage,等等
    default_list_item_style:String;
    //默认列表项的绑定设置的json数组,比如{"ItemCaption":"name"}
    default_list_item_bindings:String;


    //做为列表项样式时的默认值
    list_item_style_default_height:Double;
    list_item_style_autosize:Integer;
    list_item_style_default_width:Double;



//    //是否有搜索框
//    has_search_bar:Integer;
//    //是否有过滤栏
//    has_filter_bar:Integer;


  public
    //默认列表项的绑定设置,比如{"ItemCaption":"工序","ItemDetail":"完成人员姓名"}'
    //表示Json中的工序赋给Item.Caption
    FDefaultListItemBindings:TListItemBindings;


    //主控件排列布局设置
    MainLayoutSetting:TLayoutSetting;
    //底部工具栏的布局设置
    BottomToolbarLayoutSetting:TLayoutSetting;



//    //加载需要的参数
//    LoadDataParamsJsonArray:ISuperArray;
//    //保存所需要的参数
//    SaveDataParamsJsonArray:ISuperArray;

    IsLoaded:Boolean;
    FLoadedJsonFilePath:String;

//    //列表页面的表格列列表
//    PageColumns:TPageColumns;
  public
    //列表页面属性//
    //编辑页面结构
    EditPage:TPage;
    //查看页面结构
    ViewPage:TPage;


    //列表页面时点击Item跳转的页面
    ClickItemJumpPage:TPage;


    procedure AssignTo(Dest: TPersistent); override;


    //初始列表页面所需要的控件ListView
    procedure LoadLayoutControlListEnd;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure ClearFid;
    //创建页面实例到控件上
    function CreatePageInstalceTo(AOwner:TComponent;AParent:TParentControl;var AError:String):TPageInstance;
  public
    //存放页面图片以及其他数据的地方
    function GetPageDataDir:String;

    //从服务端接口获取页面结构
    function LoadFromServer(AInterfaceUrl:String;
                            AAppID:Integer;
                            //根据PageFID
                            //APageFID:Integer;

                            //根据ProgramTemplateName和PageName
                            AProgramTemplateName:String;
                            //根据FunctionName和PageType
                            AFunctionName:String;
                            APageType:String;
                            APlatform:String;
                            APageName:String;
                            //是否使用缓存
                            AIsCanUseCache:Boolean;
                            var ADesc:String;
                            var AIsUsedCache:Boolean):Boolean;overload;


    //保存到服务端
//    function SaveToServer(AInterfaceUrl:String;
//                            AAppID:Integer;
//                            AProgramTemplateName:String;
//                            AFunctionName:String;
//                            APageType:String;
//                            APlatform:String;
//                            APageName:String;
//                            var ADesc:String):Boolean;overload;


    procedure LoadFromFile(AJsonFilePath:String);
    procedure SaveToFile(AJsonFilePath:String);


    //仅加载和保存TPage,不保存接口、控件结构等
    function LoadFromJson(AJson:ISuperObject):Boolean;
    function SaveToJson(AJson:ISuperObject):Boolean;

    //仅保存索引
    function LoadFromIndexJson(AJson:ISuperObject):Boolean;
    function SaveToIndexJson(AJson:ISuperObject):Boolean;

    //加载和保存Page,保存接口,保存控件列表等,全部保存
    function LoadPageStructureFromJson(ASuperObject:ISuperObject):Boolean;
    function SavePageStructureToJson(ASuperObject:ISuperObject;APageDataDir:String):Boolean;

    //保存子组件到页面
    function SaveSubControlsToServer(AInterfaceUrl:String;
                                    AAppID:Integer;
                                    AParent:TControl;
                                    APageDataDir:String;
                                    //可以为空
                                    APageInstance:TPageInstance;
                                    AImageHttpServerUrl:String;
                                    AOldFieldControlSettingList:TFieldControlSettingList;
                                    var ANewFieldControlSettingList:TFieldControlSettingList;
                                    var ANeedAddFieldControlSettingList:TList;
                                    var ADesc:String):Boolean;


    //页面自定义加载数据到界面上的事件
    property OnLoadedDataToUI:TPageLoadedDataToUIEvent read FOnLoadedDataToUI write FOnLoadedDataToUI;
  published
    //静态列表数据
    property DataSkinItems:TSkinItems read FDataSkinItems write SetDataSkinItems;

    //列表页面时的静态列表项
    property DefaultListItemBindings:TListItemBindings read FDefaultListItemBindings write SetDefaultListItemBindings;

    //页面的控件列表(编辑页面)
    property MainLayoutControlList:TFieldControlSettingList read FMainLayoutControlList write SetMainLayoutControlList;
    property StaticMainLayoutControlList:TFieldControlSettingList read FMainLayoutControlList write FMainLayoutControlList;
    //页面其他区域的控件(一些按钮)
    property BottomToolbarLayoutControlList:TFieldControlSettingList read FBottomToolbarLayoutControlList write SetBottomToolbarLayoutControlList;

    //自定义调用加载数据的接口
    property OnCustomCallLoadDataIntf:TOnCustomCallLoadDataIntfEvent read FOnCustomCallLoadDataIntf write FOnCustomCallLoadDataIntf;
    //自定义调用保存数据的接口
    property OnCustomCallSaveDataIntf:TOnCustomCallSaveDataIntfEvent read FOnCustomCallSaveDataIntf write FOnCustomCallSaveDataIntf;


  end;
  TPageList=class(TBaseList)
  private
    function GetItem(Index: Integer): TPage;
  public
    FProgramTemplate:TProgramTemplate;
    function Find(AFunction:String;
                  APageType:String;
                  APageName:String;
                  APlatform:String):TPage;overload;
    function Find(APageFID:Integer):TPage;overload;
    property Items[Index:Integer]:TPage read GetItem;default;


    //保存页面索引到数据
    procedure SaveIndexToJsonArray(ASuperArray:ISuperArray);
    procedure LoadIndexFromJsonArray(ASuperArray:ISuperArray);


    procedure SaveIndexToFile(AJsonFilePath:String);
    procedure LoadIndexFromFile(AJsonFilePath:String);
  end;





  //控件设置与控件的映射(这样Setting和Control对应起来了)
  TFieldControlSettingMap=class(TInterfacedPersistent,ISkinItem)
  public
    //编辑页面输入时的底部Panel
    InputPanel:TControl;
    //比如TTS是Component,而不是Control
    Component:TComponent;
    //控件设置
    Setting:TFieldControlSetting;
    //用于设置控件的值,或提交时获取控件的值
    PageFrameworkControlIntf:IControlForPageFramework;
  public
    //ISkinItem接口,用于排列

    //列表中的矩形
    FItemRect:TRectF;
    //绘制矩形(加上了滚动偏移)
    FItemDrawRect:TRectF;

    FSkinListIntf:ISkinList;
    function GetWidth:TControlSize;
    function GetHeight:TControlSize;
    function GetLevel:Integer;
    function GetVisible:Boolean;
    function GetSelected:Boolean;
    function GetObject:TObject;
    //设置所属的列表(用于更改Width,Height等其他属性的时候调用OnChange事件)
    procedure SetSkinListIntf(ASkinListIntf:ISkinList);
//    function GetListLayoutsManager:TSkinListLayoutsManager;
    function GetIsRowEnd:Boolean;
    procedure ClearItemRect;

    function GetItemRect:TRectF;
    procedure SetItemRect(Value:TRectF);

    function GetItemDrawRect:TRectF;
    procedure SetItemDrawRect(Value:TRectF);

  public
    //排列控件
    procedure AlignControl(AItemRect:TRectF;ALayoutSetting:TLayoutSetting);
  public
    constructor Create(AOwner: TFieldControlSettingMapList);
    destructor Destroy;override;
  end;

  //管理字段和控件的映射,以及控件的排列
  TFieldControlSettingMapList=class(TBaseList,ISkinList)
  private
    //ISkinList接口
    //更新个数
    function GetUpdateCount:Integer;
    //获取某一项
    function GetSkinItem(const Index:Integer):ISkinItem;
    function GetSkinObject(const Index:Integer):TObject;
    //设置排列布局管理者
    procedure SetListLayoutsManager(ALayoutsManager:TSkinListLayoutsManager);virtual;
    //获取排列布局管理者
    function GetListLayoutsManager:TSkinListLayoutsManager;virtual;
    function GetObject:TObject;
  public
    FListLayoutsManager:TSkinListViewLayoutsManager;

    //调用DoItemVisibleChange
    procedure DoChange;override;
    //调用DoItemVisibleChange
    procedure EndUpdate(AIsForce:Boolean=False);override;
  private
    function GetItem(Index: Integer): TFieldControlSettingMap;
  public
    property Items[Index:Integer]:TFieldControlSettingMap read GetItem;default;
  public
    //控件列表的父控件,重新排序需要使用,用于获取合适的宽度
    Parent:TParentControl;
    //布局设置,重新排序需要使用
    LayoutSetting:TLayoutSetting;


    //事件点击要用,要将事件传递给PageInstance
    PageInstance:TPageInstance;

    //排列控件
    function AlignControls(AParentMarginsLeft:Double=0;
                            AParentMarginsTop:Double=0):Boolean;
    function Find(AFieldName:String):TFieldControlSettingMap;
    function FindControlByName(AName:String):TComponent;
    function FindControlByFid(AFid:Integer):TComponent;
    function FindByComponent(AComponent:TObject):TFieldControlSettingMap;
    procedure DelComponent(AComponent:TObject);
  public
    constructor Create(
                        const AObjectOwnership:TObjectOwnership=ooOwned;
                        const AIsCreateObjectChangeManager:Boolean=True
                        );
    destructor Destroy;override;
  public
    //清除控件上的值
    procedure ClearValue;
    procedure ClearParent;
    procedure SetReadOnly(AReadOnly:Boolean);
  end;






  //用于在控件中除了Value之外获取其他字段的值
  TGetDataIntfResultFieldValue=class(TInterfacedObject,IGetDataIntfResultFieldValue)
  private
    //数据相关,接口返回的结果
    FLoadDataIntfResult:TDataIntfResult;
    FLoadDataIntfResult2:TDataIntfResult;
  public
    function GetFieldValue(AFieldName:String):Variant;
  public
    constructor Create(ALoadDataIntfResult:TDataIntfResult;
                       ALoadDataIntfResult2:TDataIntfResult);
  end;






  //用于在控件中设置除了Value之外,还能设置其他字段的值,提交时
  TBaseSetRecordFieldValue=class(TInterfacedObject,ISetRecordFieldValue)
  public
    procedure SetFieldValue(AFieldName:String;AFieldValue:Variant);virtual;abstract;
  end;
  TSetJsonRecordFieldValue=class(TBaseSetRecordFieldValue)
  private
    FJson:ISuperObject;
  public
    constructor Create(AJson:ISuperObject);
  public
    procedure SetFieldValue(AFieldName:String;AFieldValue:Variant);override;
  end;



  //给图片字段加上服务器链接
  TSkinPageStructureJsonItem=class(TSkinJsonItem)
  public
    //根据绑定的FieldName获取Item的值,然后赋给绑定的控件
    //如果是图片类型的字段,加上图片链接基址
    function GetValueByBindItemField(AFieldName:String):Variant;override;
  end;
  //列表项控件,用于在页面上放TSkinItem到ListView中
  TSkinRealSkinItemComponent=class(TComponent,IControlForPageFramework)
  protected
    //针对页面框架的控件接口
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting):Boolean;
    //获取与设置自定义属性
    function GetPropJsonStr:String;
    procedure SetPropJsonStr(AJsonStr:String);

    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            //可以获取其他字段的值
                            ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            AImageServerUrl:String;
                            AValue:Variant;
                            AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
    //设置属性
    function GetProp(APropName:String):Variant;
    procedure SetProp(APropName:String;APropValue:Variant);

  public
    FSkinItem:TRealSkinItem;
    constructor Create(AOwner:TComponent);override;
  end;


//  TPageFrameworkControlSetPostValueEvent=procedure(AControl:TControl;
//                                                    APageDataDir:String;
//                                                    AImageServerUrl:String;
//                                                    AValue:Variant;
//                                                    var AIsSetted:Boolean) of Object;
  //初始控件的事件,用于初始其他属性
  TPageFrameCustomInitFieldControlEvent=procedure(AControl:TComponent;
                                             AFieldControlSetting:TFieldControlSetting) of object;
  TLoadDataTaskEndEvent=procedure(Sender:TObject;
                                   APageInstance:TPageInstance;
                                   ADataIntfResult: TDataIntfResult;
                                   ADataIntfResult2: TDataIntfResult
                                   ) of object;


  //页面控件点击事件
  TPageFrameControlClickEvent=procedure(Sender:TObject;
                                        APageInstance:TPageInstance;
                                        APageLayoutControlMap:TFieldControlSettingMap;
                                        //是否我已处理
                                        var AIsProcessed:Boolean) of object;
  //页面实例
  TPageInstance=class//(TComponent)
  private
    FRefreshTimer:TTimer;
    procedure DoRefreshTimer(Sender:TObject);
  private
    //删除数据列表相关
    FDelDataIntfResult:TDataIntfResult;
    //调用接口返回
    //获取数据列表相关
    //调用接口返回
    FDelDataTimerTaskEvent:TTimerTaskEvent;
    procedure DoDelDataTaskExecuteBegin(ATimerTask:TTimerTask);
    procedure DoDelDataTaskExecute(ATimerTask:TTimerTask);
    procedure DoDelDataTaskExecuteEnd(ATimerTask:TTimerTask);
    function CallDelDataInterface:Boolean;virtual;
  private
    ///////////
    ///
    //获取数据列表相关
    //调用接口返回
    FLoadDataTimerTaskEvent:TTimerTaskEvent;
    procedure DoLoadDataTaskExecuteBegin(ATimerTask:TTimerTask);
    procedure DoLoadDataTaskExecute(ATimerTask:TTimerTask);
    procedure DoLoadDataTaskExecuteEnd(ATimerTask:TTimerTask);virtual;

    //自定义给控件赋值
    //将Json数组赋给ListControl
    procedure DoCustomSetControlPostValue(AFieldControlSettingMap:TFieldControlSettingMap;
                                          AComponent:TComponent;
                                          APageDataDir:String;
                                          AImageServerUrl:String;
                                          AValue:Variant;
                                          //如果值是一个数组
                                          AValueArray:ISuperArray;
                                          AValueObject:TObject;
                                          var AIsSetted:Boolean);
    procedure SetLoadDataIntfResult(const Value: TDataIntfResult);
    procedure SetLoadDataIntfResult2(const Value: TDataIntfResult);
  public
    FSaveDataSetting:TSaveDataSetting;
    //    FOnSaveRecordSucc: TNotifyEvent;
    //保存后返回的新数据,如果要把保存后的新数据显示在界面上，则从它的DataJson中获取
    FSaveDataIntfResult:TDataIntfResult;
    //预定义的动作
    //保存数据,如何判断是添加还是修改
    //    SaveRecordMessageBox:TSkinMessageBox;
    //    procedure DoSaveRecordSuccMessageBoxModalResult(AMessageBoxFrame:TFrame);
    procedure DoSaveRecordTimerTaskExecute(ATimerTask:TObject);
    procedure DoSaveRecordTimerTaskExecuteEnd(ATimerTask:TObject);

    //  //保存记录
    //  Const_PageAction_SaveRecord='save_record';
    procedure DoSaveRecordAction(AIsNeedStartThread:Boolean);virtual;

    //调用DoSaveRecordAction去保存记录
    procedure SaveRecord;
  public
    //注释掉,因为一个程序里面,AppID,UserFID,Key都是统一的，不需要每个PageInstance单独设置
//    //用于提交接口
//    AppID:Integer;
//    UserFID:Integer;
//    Key:String;
  public
//    PageDataDir:String;
    //页面结构
    PageStructure:TPage;

    //主控件映射列表
    MainControlMapList:TFieldControlSettingMapList;
    //底部栏控件映射列表
    BottomToolbarControlMapList:TFieldControlSettingMapList;
  public
    constructor Create;//(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    ///////////
    //控件相关
    //    FOnControlClick: TPageFrameControlClickEvent;
    //创建控件列表
    function CreateControls(AOwner:TComponent;
                            AParent:TParentControl;
                            //显示哪个部分的控件
                            AFilterPagePart:String;
                            //保存图片的根相对目录
                            APageDataDir:String;
                            //是否设计时
                            AIsDesignTime:Boolean;
                            var AError:String;
                            AIsControlTypeMustExists:Boolean=False):Boolean;
//    procedure ClearControlsValue;
//    //排列控件
//    function AlignControls(AParentMarginsLeft:Double=0;AParentMarginsTop:Double=0):Boolean;
    //精简版
    procedure SetFieldControlValue(AFieldName:String;
                                  AValue:Variant);
    function GetFieldControlValue(AFieldName:String):Variant;
  public
    //加载数据结束之后,是否需要加载数据到控件，什么情况下不用？
    FIsNeedLoadDataIntfResultToControls:Boolean;
    //调用接口的设置
    FLoadDataSetting:TLoadDataSetting;
    OnLoadDataTaskEnd:TLoadDataTaskEndEvent;
    //数据相关,接口返回的结果
    FLoadDataIntfResult:TDataIntfResult;
    FLoadDataIntfResult2:TDataIntfResult;
    //加载数据,获取数据
    function LoadData(AIsNeedStartThread:Boolean=True):Boolean;

    //将调用接口返回的数据加载到界面,比如将Json中的Key值赋给对应的控件
    function LoadDataIntfResultToControls(ADataIntfResult:TDataIntfResult;
                                          ADataIntfResult2:TDataIntfResult):Boolean;virtual;
    function LoadDataJsonToControls(ADataJson:ISuperObject):Boolean;virtual;

    //刷新
    procedure Refresh;
  public
    //默认的添加记录的初始Json
    AddPostInitJson:ISuperObject;

    FOnAfterSaveRecord:TNotifyEvent;

    //获取提交接口所需要的数据的DataJson
    function GetPostDataJson(APageDataDir:String;
                            //是否是添加记录
                            AIsAddRecord:Boolean;
                            var AError:String):ISuperObject;

//    //调用TableCommonRest类型的添加记录接口
//    function DoPostToTableCommonRestAddRecord(
//                APageDataDir:String;
//                var ACode:Integer;
//                var ADesc:String;
//                var ADataJson:ISuperObject):Boolean;
//    function PostToServer(APageDataDir:String;var ACode:Integer;
//                          var ADesc:String;
//                          var ADataJson:ISuperObject):Boolean;
//    property LoadDataIntfResult:TDataIntfResult read FLoadDataIntfResult write SetLoadDataIntfResult;
//    property LoadDataIntfResult2:TDataIntfResult read FLoadDataIntfResult2 write SetLoadDataIntfResult2;




    //添加编辑保存取消动作
    procedure BeginAddRecord;
    procedure BeginEditRecord;
    procedure CancelAddRecord;
    procedure CancelEditRecord;


  public
    //将数据添加到列表控件上
    procedure AddSkinItemToListControl(ASkinVirtualList:TSkinVirtualList;
                                      ASuperObject:ISuperObject;
                                      AValueObject:TObject);

    //自定义初始控件,比如ListView
    procedure DoPageFrameCustomInitFieldControl(AControl:TComponent;AFieldControlSetting:TFieldControlSetting);virtual;
    //控件点击事件,在里面找到Sender对应的FieldControlSetting，然后调用DoPageLayoutControlClick
    procedure DoFieldControlClick(Sender:TObject);
    //控件点击事件
    procedure DoPageLayoutControlClick(Sender:TObject;APageLayoutControlMap:TFieldControlSettingMap);virtual;
  public
    //自定义初始控件,比如ListView
    FOnCustomInitFieldControl:TPageFrameCustomInitFieldControlEvent;
    //自定义清除控件的值,比如ListView
    FOnCustomClearFieldControl:TPageFrameCustomInitFieldControlEvent;

  public
    //    FOnReturnPage: TNotifyEvent;
    //控件动作//
    //  //页面框架的操作
    //  Const_PageAction_JumpToNewRecordPage='jump_to_new_record_page';

    //从新增记录页面返回到列表页面,一般是进行刷新
    procedure DoReturnFrameFromEditPageFrame(AFrame:TFrame);virtual;
    //  //跳转到新增页面
    procedure DoJumpToNewRecordPageAction;


    //  //跳转到编辑页面
    //  Const_PageAction_JumpToEditRecordPage='jump_to_edit_record_page';
    procedure DoJumpToEditRecordPageAction(ALoadDataSetting:TLoadDataSetting);virtual;


    //  //跳转到查看页面
    //  Const_PageAction_JumpToViewRecordPage='jump_to_view_record_page';
    //
    //
    //
    //  //跳转到主从新增页面
    //  Const_PageAction_JumpToNewMasterDetailRecordPage='jump_to_new_master_detail_record_page';
    //  //跳转到主从编辑页面
    //  Const_PageAction_JumpToEditMasterDetailRecordPage='jump_to_edit_master_detail_record_page';
    //  //跳转到主从查看页面
    //  Const_PageAction_JumpToViewMasterDetailRecordPage='jump_to_view_master_detail_record_page';
    //  //批量删除
    //  Const_PageAction_BatchDelRecord='batch_del_record';
    //  //批量保存
    //  Const_PageAction_BatchSaveRecord='batch_save_record';
    //  //搜索
    //  Const_PageAction_SearchRecordList='search_record_list';


    //  //删除
    //  Const_PageAction_DelRecord='del_record';
    procedure DoDelRecordAction;virtual;


    //  //返回
    //  Const_PageAction_ReturnPage='return_page';
    //返回上一页
    procedure DoReturnPageAction(AFromPageInstance:TPageInstance);


    //  //关闭页面
    //  Const_PageAction_ClosePage='close_page';


    //  //取消保存
    //  Const_PageAction_CancelSaveRecord='cancel_save_record';
    //  //保存并返回
    //  Const_PageAction_SaveRecordAndReturn='save_record_and_return';
    //  //保存新增并继续新增
    //  Const_PageAction_SaveRecordAndContinueAdd='save_record_and_continue_add';

//  published
//    //返回页面事件
//    property OnReturnPage:TNotifyEvent read FOnReturnPage write FOnReturnPage;

  end;




  //默认列表页面
  TListPageInstance=class(TPageInstance)
  public
    FlvData:TSkinVirtualList;

    //自定义列表项点击事件
    FOnCustomClickListSkinItem:TVirtualListClickItemEvent;

    //自定义初始控件,比如ListView的上拉下拉点击事件
    procedure DoPageFrameCustomInitFieldControl(AControl:TComponent;AFieldControlSetting:TFieldControlSetting);override;

    //列表页面,上拉下拉事件
    procedure lvDataPullDownRefresh(Sender: TObject);
    procedure lvDataPullUpLoadMore(Sender: TObject);
    //加载数据线程结束
    procedure DoLoadDataTaskExecuteEnd(ATimerTask:TTimerTask);override;

    //列表项点击事件,跳转到编辑页面或查看页面
    procedure lvDataClickItemEx(Sender:TObject;
                                AItem:TSkinItem;
                                X:Double;Y:Double);

//    //点击设计面板上面子控件的事件
//    procedure lvDataCustomListClickItemDesignerPanelChild(Sender:TObject;
//                                                          AItem:TBaseSkinItem;//这里应该用TBaseSkinItem
//                                                          AItemDesignerPanel:TItemDesignerPanel;
//                                                          AChild:TChildControl);

  public
    //从编辑页面返回到列表页面
    procedure DoReturnFrameFromEditPageFrame(AFrame:TFrame);override;

//    //跳转到编辑页面
//    procedure DoJumpToEditRecordPageAction(ALoadDataSetting:TLoadDataSetting);override;
//
//    //跳转到编辑页面
//    procedure DoJumpToListRecordPageAction(ALoadDataSetting:TLoadDataSetting);override;
  end;





  //默认编辑页面
  TEditPageInstance=class(TPageInstance)
  public
    //控件点击事件
    procedure DoPageLayoutControlClick(Sender:TObject;APageLayoutControlMap:TFieldControlSettingMap);override;

//    function CallDelDataInterface:Boolean;override;

    //编辑页面中跳转到选项列表页面,选项列表页面点击列表项选中并返回
    procedure DoReturnFrameFromOptionsListPage(AFrame:TFrame);
  public
    procedure DoDelRecordAction;override;
  end;











  //需要显示页面
  TOnNeedShowPageEvent=procedure(Sender:TObject;
                                  APageFID:Integer;
                                  APage:TPage;
//                                  ALoadDataSetting:TLoadDataSetting;
                                  //返回
                                  AOnReturnFrame:TReturnFromFrameEvent) of object;
  //需要返回上一页
  TOnNeedReturnPageEvent=procedure(Sender:TObject;
                                  AFromPageInstance:TPageInstance) of object;

  
  //开放平台的程序设置
  TOpenPlatformProgramSetting=class(TComponent)
  private
    FDataIntfServerUrl: String;
    FOpenPlatformImageUrl: String;
    FOnNeedShowPage: TOnNeedShowPageEvent;
    FOnNeedReturnPage: TOnNeedReturnPageEvent;
    FOpenPlatformAppID: Integer;
    FAppID: Integer;
    FProgramTemplateName: String;
    FDataIntfImageUrl: String;
    FPlatform: String;
    FMainPageName: String;
    FOpenPlatformServerUrl: String;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    function Load(AIniFilePath:String):Boolean;
    procedure Save(AIniFilePath:String);
  published
    //用于加载页面结构//
    //开放平台的APPID,用于获取程序信息,页面结构,
    //默认是1000
    property OpenPlatformAppID:Integer read FOpenPlatformAppID write FOpenPlatformAppID;
    //开放平台的服务器,
    //默认是http://www.orangeui.cn:10000/
    property OpenPlatformServerUrl:String read FOpenPlatformServerUrl write FOpenPlatformServerUrl;
    //开放平台图片下载的服务器,
    //页面结构中的图片
    //默认是http://www.orangeui.cn:10001/
    property OpenPlatformImageUrl:String read FOpenPlatformImageUrl write FOpenPlatformImageUrl;

  published
    //应用的APPID,
    //比如是1010,医院测试
    property AppID:Integer read FAppID write FAppID;

    //程序模板的名称,
    //比如hospitcal医院应用
    property ProgramTemplateName:String read FProgramTemplateName write FProgramTemplateName;


    //只设置名称,能简单一点
    //主页的名称,如果为空,那么就显示默认的主页,
    //比如是hospital_office_status
    property MainPageName:String read FMainPageName write FMainPageName;
    //平台,比如web,pc,app
    property Platform:String read FPlatform write FPlatform;

  published
    //应用服务器,应用数据自己的服务器
    //http://www.orangeui.cn:10000/
    property DataIntfServerUrl:String read FDataIntfServerUrl write FDataIntfServerUrl;
    //图片下载服务器
    //http://www.orangeui.cn:10001/
    property DataIntfImageUrl:String read FDataIntfImageUrl write FDataIntfImageUrl;

  published
    //自定义的页面显示事件
    property OnNeedShowPage:TOnNeedShowPageEvent read FOnNeedShowPage write FOnNeedShowPage;
    //自定义的页面返回事件
    property OnNeedReturnPage:TOnNeedReturnPageEvent read FOnNeedReturnPage write FOnNeedReturnPage;
  end;





{ TPageDesignPanel }

  TPageDesignPanel = class(TControl)//TFrame)
  public const
    DefaultColor = $FF1072C5;
//  public type
//    TGrabHandle = (None, LeftTop, RightTop, LeftBottom, RightBottom);
  private
//    FParentBounds: Boolean;
//    FOnChange: TNotifyEvent;
//    FHideSelection: Boolean;
//    FMinSize: Integer;
//    FOnTrack: TNotifyEvent;
//    FProportional: Boolean;
//    FGripSize: Single;
//    FRatio: Single;
//    FActiveHandle: TGrabHandle;
//    FHotHandle: TGrabHandle;
//    FDownPos: TPointF;
//    FShowHandles: Boolean;
//    FColor: TAlphaColor;
//    procedure SetHideSelection(const Value: Boolean);
//    procedure SetMinSize(const Value: Integer);
//    procedure SetGripSize(const Value: Single);
//    procedure ResetInSpace(const ARotationPoint: TPointF; ASize: TPointF);
//    function GetProportionalSize(const ASize: TPointF): TPointF;
//    function GetHandleForPoint(const P: TPointF): TGrabHandle;
//    procedure GetTransformLeftTop(AX, AY: Single; var NewSize: TPointF; var Pivot: TPointF);
//    procedure GetTransformLeftBottom(AX, AY: Single; var NewSize: TPointF; var Pivot: TPointF);
//    procedure GetTransformRightTop(AX, AY: Single; var NewSize: TPointF; var Pivot: TPointF);
//    procedure GetTransformRightBottom(AX, AY: Single; var NewSize: TPointF; var Pivot: TPointF);
//    procedure MoveHandle(AX, AY: Single);
//    procedure SetShowHandles(const Value: Boolean);
//    procedure SetColor(const Value: TAlphaColor);
  private
    FLoadDataParams:TStringList;
    FLoadDataParams2:TStringList;

    function GetAlignType: String;
    function GetCaption: String;
    function GetPageName: String;
    function GetPageType: String;
    function GetPlatform: String;
    function GetDataIntfType: String;
    function GetDataIntfType2: String;
//    function GetDataSQL: String;
    procedure SetAlignType(const Value: String);
    procedure SetCaption(const Value: String);
    procedure SetPageName(const Value: String);
    procedure SetPageType(const Value: String);
    procedure SetPlatform(const Value: String);
    procedure SetDataIntfType(const Value: String);
    procedure SetDataIntfType2(const Value: String);
//    procedure SetDataSQL(const Value: String);
    function GetDataInterface: TDataInterface;
    procedure SetDataInterface(const Value: TDataInterface);
    function GetDataInterface2: TDataInterface;
    procedure SetDataInterface2(const Value: TDataInterface);
    procedure SetRefreshSeconds(const Value: Integer);
    function GetRefreshSeconds: Integer;
    function GetLoadDataParams: TStringList;
    procedure SetLoadDataParams(const Value: TStringList);
    function GetLoadDataParams2: TStringList;
    procedure SetLoadDataParams2(const Value: TStringList);
    function GetListItemStyleDefaultAutoSize: Boolean;
    function GetListItemStyleDefaultHeight: Double;
    function GetListItemStyleDefaultWidth: Double;
    procedure SetListItemStyleDefaultAutoSize(const Value: Boolean);
    procedure SetListItemStyleDefaultHeight(const Value: Double);
    procedure SetListItemStyleDefaultWidth(const Value: Double);
  protected
//    function DoGetUpdateRect: TRectF; override;

    procedure Paint; {$IFDEF FMX}override;{$ENDIF}
    procedure AfterPaint; {$IFDEF FMX}override;{$ENDIF}
//    ///<summary>Draw grip handle</summary>
//    procedure DrawHandle(const Canvas: TCanvas; const Handle: TGrabHandle; const Rect: TRectF); virtual;
    ///<summary>Draw frame rectangle</summary>
    procedure DrawFrame(const Canvas: TCanvas; const Rect: TRectF); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
//  public
//    function PointInObjectLocal(X, Y: Single): Boolean; override;
//    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
//    procedure MouseMove(Shift: TShiftState; X, Y: Single); override;
//    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
//    procedure DoMouseLeave; override;
//    ///<summary>Grip handle where mouse is hovered</summary>
//    property HotHandle: TGrabHandle read FHotHandle;
  public
    FPage:TPage;

//    property GripSize: Single read FGripSize write SetGripSize;
//    property ParentBounds: Boolean read FParentBounds write FParentBounds default True;
//    property Proportional: Boolean read FProportional write FProportional;
//    property ShowHandles: Boolean read FShowHandles write SetShowHandles;

    property Page:TPage read FPage write FPage;
  published
//    //排列布局类型,
//    //manual手动布局,
//    //auto自动布局
//    align_type:String;
//
//
//    //页面类型
//    page_type:String;
//    //平台
//    platform:String;
//    property PageName:String read GetPageName write SetPageName;
    property Caption:String read GetCaption write SetCaption;

    property AlignType:String read GetAlignType write SetAlignType;
    property PageType:String read GetPageType write SetPageType;
    property Platform:String read GetPlatform write SetPlatform;

    property ListItemStyleDefaultHeight:Double read GetListItemStyleDefaultHeight write SetListItemStyleDefaultHeight;
    property ListItemStyleDefaultWidth:Double read GetListItemStyleDefaultWidth write SetListItemStyleDefaultWidth;
    property ListItemStyleDefaultAutoSize:Boolean read GetListItemStyleDefaultAutoSize write SetListItemStyleDefaultAutoSize;

  published
    //接口类型
    property DataIntfType:String read GetDataIntfType write SetDataIntfType;

    property DataInterface:TDataInterface read GetDataInterface write SetDataInterface;
  published
    //接口类型
    property DataIntfType2:String read GetDataIntfType2 write SetDataIntfType2;

    property DataInterface2:TDataInterface read GetDataInterface2 write SetDataInterface2;
  published
//    //SQL语句
//    property DataSQL:String read GetDataSQL write SetDataSQL;
//    //保存所需要的参数
//    SaveDataParamsJsonArray:ISuperArray;

    property RefreshSeconds:Integer read GetRefreshSeconds write SetRefreshSeconds;

    //加载接口1需要的参数
    property LoadDataParams:TStringList read GetLoadDataParams write SetLoadDataParams;

    //加载接口2需要的参数
    property LoadDataParams2:TStringList read GetLoadDataParams2 write SetLoadDataParams2;
  published
//    property Align;
//    property Anchors;
//    property ClipChildren default False;
//    property ClipParent default False;
//    property Cursor default crDefault;
//    ///<summary>Selection frame and handle's border color</summary>
//    property Color: TAlphaColor read FColor write SetColor default DefaultColor;
//    property DragMode default TDragMode.dmManual;
//    property EnableDragHighlight default True;
//    property Enabled default True;
//    property Locked default False;
    property Height;


//    property HideSelection: Boolean read FHideSelection write SetHideSelection;
//    property HitTest default True;
//    property Padding;
//    property MinSize: Integer read FMinSize write SetMinSize default 15;
//    property Opacity;
//    property Margins;
//    property PopupMenu;
//    property Position;
//    property RotationAngle;
//    property RotationCenter;
//    property Scale;

    {$IFDEF FMX}
    property Size;
    {$ENDIF}
//    ///<summary>Indicates visibility of handles</summary>
//    property Visible default True;
    property Width;
//    property OnChange: TNotifyEvent read FOnChange write FOnChange;
//    {Drag and Drop events}
//    property OnDragEnter;
//    property OnDragLeave;
//    property OnDragOver;
//    property OnDragDrop;
//    property OnDragEnd;
//    {Mouse events}
//    property OnClick;
//    property OnDblClick;
//
//    property OnMouseDown;
//    property OnMouseMove;
//    property OnMouseUp;
//    property OnMouseWheel;
//    property OnMouseEnter;
//    property OnMouseLeave;
//
//    property OnPainting;
//    property OnPaint;
//    property OnResize;
//    property OnResized;
//    property OnTrack: TNotifyEvent read FOnTrack write FOnTrack;
  end;








  //列表项样式下载
//  TListItemStlyleDownloadItem=class(TUrlItem)
//  public
//    FPage:TPage;
//  end;




//  IRestInterfaceCall=interface
//    ['{8AD273E6-9AA5-4198-9609-E77CF11C8FED}']
//    //调用rest接口,返回字符串,在服务端中使用
//    function SimpleCallAPI(API: String;
//                          AHttpControl: THttpControl;
//                          AInterfaceUrl:String;
//                          AUrlParamNames:TStringDynArray;
//                          AUrlParamValues:TVariantDynArray;
//                          var ACode:Integer;
//                          var ADesc:String;
//                          var ADataJson:ISuperObject;
//                          ASignType:String='';
//                          ASignSecret:String='';
//                          AIsPost:Boolean=False;
//                          APostStream:TStream=nil): Boolean;overload;
//
//  end;


  TLocalJsonPageFrameworkDataSourceManager=class(TPageFrameworkDataSourceManager)
  public
    //本地数据,比如医院显示屏项目,保存办公室fid
    FDataJson:ISuperObject;

  public
    constructor Create;override;
    destructor Destroy;override;

  public
    procedure Load;override;
    procedure Save;override;
    function GetParamValue(AValueFrom:String;AParamName:String):Variant;override;
    procedure SetParamValue(AValueFrom:String;AParamName:String;AValue:Variant);override;

  end;



  TPageCheckBox=class(TCheckBox,IControlForPageFramework)
    //针对页面框架的控件接口
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting):Boolean;
    //获取与设置自定义属性
    function GetPropJsonStr:String;
    procedure SetPropJsonStr(AJsonStr:String);
    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            //可以获取其他字段的值
                            ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            AImageServerUrl:String;
                            AValue:Variant;
                            AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
    //设置属性
    function GetProp(APropName:String):Variant;
    procedure SetProp(APropName:String;APropValue:Variant);

  end;






var
  //主程序设置
  GlobalMainProgramSetting:TOpenPlatformProgramSetting;



function DoCreateControl(
                        AOwner:TComponent;
                        AParent: TParentControl;
                        AFieldControlSetting:TFieldControlSetting;
                        AControlMapList: TFieldControlSettingMapList;
                        //保存图片的根相对目录
                        APageDataDir:String;
                        AIsDesignTime:Boolean;
                        AOnPageFrameCustomInitFieldControl:TPageFrameCustomInitFieldControlEvent;
                        var AControlMap:TFieldControlSettingMap;
                        var AError:String;
                        AIsControlTypeMustExists:Boolean=False
                        ): Boolean;

//创建控件列表
function DoCreateControls(
                          AOwner:TComponent;
                          AParent: TParentControl;
                          ALayoutSetting:TLayoutSetting;
                          AFieldControlSettingList: TFieldControlSettingList;
                          AFilterPagePart:String;
                          //保存图片的根相对目录
                          APageDataDir:String;
                          AIsDesignTime:Boolean;
                          AOnPageFrameCustomInitFieldControl:TPageFrameCustomInitFieldControlEvent;
                          var AControlMapList:TFieldControlSettingMapList;
                          var AError:String;
                          AIsControlTypeMustExists:Boolean=False
                          ): Boolean;

//将设置项中的设置到新创建的控件中
function LoadComponentFromFieldControlSetting(AControlMap:TFieldControlSettingMap;
                                              AComponent:TComponent;
                                              AFieldControlSetting:TFieldControlSetting;
                                              //保存图片的根相对目录
                                              APageDataDir:String;
                                              AIsDesignTime:Boolean;
                                              var AError:String):Boolean;



//将Parent中的控件保存到List中,用于遍历
function SaveChildComponentList(
                                AParent:TControl;
                                AComponentList:TList):Boolean;



//保存父控件上面的子控件到FieldControlSettingList
function SaveSubControlsToFieldControlSettingList(
                                      ARootParent:TControl;
                                      AParent:TControl;
                                      AFieldControlSettingList:TFieldControlSettingList;
                                      AParentFieldControlSetting:TFieldControlSetting;
                                      //保存图片的根相对目录
                                      APageDataDir:String;
                                      var AError:String):Boolean;
function SaveComponentToFieldControlSetting(
                                            ARootParent:TControl;
                                            AComponent:TComponent;
                                            AFieldControlSetting:TFieldControlSetting;
                                            //保存图片的根相对目录
                                            APageDataDir:String;
                                            var AError:String):Boolean;
//调用接口,返回数据
function CallLoadDataIntf(APageStructure:TPage;
                              //接口
                              ADataInterface:TDataInterface;
                              //接口返回值
                              ALoadDataIntfResult:TDataIntfResult;
                              //页面的加载设置
                              ALoadDataSetting:TLoadDataSetting;
                              //页面的加载参数
                              ALoadDataParams:String):Boolean;


//获取参数的值
function GetLoadDataParamValue(AParamJson:ISuperObject;var AError:String):Variant;

//获取变量值
function GetPageFrameworkVariableValue(AVariableName:String):Variant;
//根据字段名从接口的返回中获取数据
//可能有多级的情况,比如DataJson.Summary.I['SumCount']
//AFieldNameList,$data_intf,Summary,SumCount
function GetDataIntfFieldValue(AFieldName:String;
                               ADataIntfResult:TDataIntfResult;
                               AFieldNameNodeList:TStringList;
                               var AValueObject:TObject):Variant;
//根据字段名从两个接口的返回中获取页面的数据
function GetPageDataIntfResultFieldValue(AFieldName:String;
                                          ADataIntfResult:TDataIntfResult;
                                          ADataIntfResult2:TDataIntfResult;
                                          var AJsonArrayValue:ISuperArray;
                                          var AValueObject:TObject):Variant;


//function SortFieldControlSettingByOrderNo_Compare(Item1, Item2: Pointer): Integer;
//function SortFieldControlByOrderNo_Compare(Item1, Item2: Pointer): Integer;
//function GetAnchors(AAnchorsStr:String):TAnchors;
//function GetAlign(AAlignStr:String):TAlignLayout;



//从服务端获取页面结构
function GetPageStructureFromServer(
                        //            AAppID:Integer;
                                    AOpenPlatformServer:String;
                                    AProgramTemlateName:String;
                                    AFunctionName:String;
                                    APageType:String;
                                    APageName:String):TPage;



function GetComponentBoundsRect(AComponent:TComponent):TRectF;
procedure SetComponentBoundsRect(AComponent:TComponent;ARect:TRectF);
procedure SetComponentLeft(AComponent:TComponent;ALeft:TControlSize);
procedure SetComponentTop(AComponent:TComponent;ATop:TControlSize);
procedure SetComponentWidth(AComponent:TComponent;AWidth:TControlSize);
procedure SetComponentHeight(AComponent:TComponent;AHeight:TControlSize);

//加载APP的主页到PageControl
procedure LoadPageControlMenu(APageControl:TSkinPageControl;AMenus:ISuperArray);

//function CreateListItemStyleByPage(APage:TPage):Boolean;

//保存控件为页面结构,用于将设计面板保存为页面
function SaveControlToPage(AInterfaceUrl:String;
                            AAppID:Integer;
                            AProgramTemplateName:String;
                            APageName:String;
                            APageType:String;
                            APlatform:String;
                            APageCaption:String;
                            AParent:TControl;
                            AImageHttpServerUrl:String;
                            AIsSaveToServer:Boolean;ALocalFilePath:String):Boolean;

//设置控件的值,支持原生控件TEdit，TMemo等
procedure SetFieldControlPostValue(AFieldControlSettingMap:TFieldControlSettingMap;
                              APageDataDir:String;
                              AImageServerUrl:String;
                              AValue:Variant;
                              AValueCaption:String;
                              //要设置多个值,整个字段的记录
                              AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);overload;


//获取提交的值
function GetFieldControlPostValue(AFieldControlSettingMap:TFieldControlSettingMap;
                                  APageDataDir:String;
                                  ASetRecordFieldValueIntf:ISetRecordFieldValue;
                                  var AErrorMessage:String):Variant;

//初始控件,比如设置ComboBox.Items
procedure InitFieldControlBySetting(AControlMap:TFieldControlSettingMap;APageDataDir:String);


procedure Register;



implementation

uses

  //组件
//  uGraphicCommon,
//  uTimerTask,
//  uTimerTaskEvent,

//  {$IFDEF FMX}
//  uFrameContext,
//  uSkinCommonFrames,
//  uSkinCalloutRectType,
//  {$ENDIF FMX}
//
//  uSkinAnimator,
//  uSkinImageList,
//  uSkinRegManager,
//  uDownloadPictureManager,
//  uSkinControlGestureManager,
//  uSkinControlPanDragGestureManager,
//  uSkinSwitchPageListControlGestureManager,


//  uVirtualListDataController,

  //控件
  uSkinCheckBoxType,
  uSkinSwitchType,
  uSkinRadioButtonType,
  uSkinLabelType,
  uSkinMultiColorLabelType,
  uSkinPanelType,
  uSkinDrawPanelType,
//  uSkinPageControlType,
//  uSkinItemDesignerPanelType,
//  uSkinDirectUIParentType,
  uSkinImageType,
  uSkinFrameImageType,
  uSkinRoundImageType,
  uSkinImageListPlayerType,
  uSkinImageListViewerType,
  uSkinSwitchPageListPanelType,
//  uSkinCalloutRectType,

  uSkinEditType,
  uSkinComboBoxType,
  uSkinDateEditType,
  uSkinTimeEditType,
  uSkinPopupType,
  uSkinComboEditType,
  uSkinMemoType,

//  {$IFDEF FMX}
//  uSkinRoundRectType,
//  uProcessNativeControlModalShowPanel,
//  AddPictureListSubFrame,
//  {$ENDIF}


  uSkinNotifyNumberIconType,
  uSkinTrackBarType,
  uSkinSwitchBarType,
  uSkinProgressBarType,


  uSkinScrollBarType,

  uSkinScrollControlType,
  uSkinScrollControlCornerType,

  uSkinScrollBoxType,
  uSkinScrollBoxContentType,

  uSkinCustomListType,

//  uSkinVirtualListType,
  uSkinListBoxType,
//  uSkinListViewType,
  uSkinTreeViewType,

//  uSkinVirtualGridType,
  uSkinItemGridType,
  uSkinDBGridType,


  uSkinPullLoadPanelType,

//  {$IFDEF VCL}
//  uSkinFormType,
////  uSkinFormPictureType,
////  uSkinFormColorType,
//  {$ENDIF}


  {$IFDEF FMX}
  uSkinFireMonkeyButton,
  uSkinFireMonkeyLabel,
  uSkinFireMonkeyMultiColorLabel,
  uSkinFireMonkeyEdit,
  uSkinFireMonkeyComboBox,
  uSkinFireMonkeyDateEdit,
  uSkinFireMonkeyTimeEdit,
  uSkinFireMonkeyPopup,
  uSkinFireMonkeyComboEdit,
  uSkinFireMonkeyMemo,
  uSkinFireMonkeyPanel,
  uSkinFireMonkeyDrawPanel,
//  uSkinFireMonkeyDirectUIParent,
  uSkinFireMonkeyPageControl,
  uSkinFireMonkeyItemDesignerPanel,
  uSkinFireMonkeyImage,
  uSkinFireMonkeyRoundRect,
  uSkinFireMonkeyImageListPlayer,
  uSkinFireMonkeyImageListViewer,
  uSkinFireMonkeyRoundImage,
  uSkinFireMonkeyFrameImage,
  uSkinFireMonkeyTrackBar,
  uSkinFireMonkeySwitchBar,
  uSkinFireMonkeyProgressBar,
  uSkinFireMonkeyScrollBar,
  uSkinFireMonkeyPullLoadPanel,
  uSkinFireMonkeyScrollBox,
  uSkinFireMonkeyScrollBoxContent,
  uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollControlCorner,
  uSkinFireMonkeySwitchPageListPanel,

  uSkinFireMonkeyCustomList,
//  uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox,
  uSkinFireMonkeyListView,
  uSkinFireMonkeyTreeView,

//  uSkinFireMonkeyVirtualGrid,
  uSkinFireMonkeyItemGrid,
  uSkinFireMonkeyDBGrid,

  uSkinFireMonkeyRadioButton,
  uSkinFireMonkeyNotifyNumberIcon,
  uSkinFireMonkeyCheckBox,
//  uSkinFireMonkeyCalloutRect,
  uSkinFireMonkeySwitch,
  {$ENDIF}


//  uPageFramework,
//  BasePageFrame,
//  BaseListPageFrame,
//  BaseViewPageFrame,
//  BaseEditPageFrame;
  uSkinButtonType;


  {$IFDEF VCL}
type
  TSkinPanel=class(TBaseSkinPanel)
  end;
  {$ENDIF}


var
  //主程序设置
  FInnterGlobalMainProgramSetting:TOpenPlatformProgramSetting;



procedure Register;
begin
  RegisterComponents('OrangePageFramework',
                      [TPage,
                      TOpenPlatformProgramSetting,
                      TPageFrameworkDataSource]);
end;


procedure InitFieldControlBySetting(AControlMap:TFieldControlSettingMap;APageDataDir:String);
begin
      if AControlMap.Component.GetInterface(IID_IControlForPageFramework,AControlMap.PageFrameworkControlIntf) then
      begin
//        AControlMap.PageFrameworkControlIntf:=AControlForPageFrameworkIntf;
        //加载设置
        AControlMap.PageFrameworkControlIntf.LoadFromFieldControlSetting(AControlMap.Setting);
        //设置自定义的值
        AControlMap.PageFrameworkControlIntf.SetPropJsonStr(AControlMap.Setting.prop);



          //'Upload\1000\page_design\2019\2019-10-29\30B8E826680948EAA7D60EDBE7E68F61.png'
    //      if SameText(AFieldControlSetting.control_type,'image') then
    //      begin
    //          APicPath:=AFieldControlSetting.value;
    //          //如果本地不存在图片,那就远程取
    //          if (APicPath<>'') then
    //          begin
    //              if not FileExists(APageDataDir+'pics\'+AFieldControlSetting.value) then
    //              begin
    //                  //没有绑定,那么需要设置初始值,界面设计时的值,设计时的值,保存在开放平台,appid为1000的服务器上
    //                  //图片都从服务器下载
    //                  if (APicPath.IndexOf('http://')>=0)
    //                    or (APicPath.IndexOf('https://')>=0) then
    //                  begin
    //                      //不用加服务端地址了
    //                  end
    //                  else
    //                  begin
    //                      //加上图片服务器的链接
    //                      APicPath:=GlobalMainProgramSetting.OpenPlatformImageUrl+ReplaceStr(APicPath,'\','/');;
    //                  end;
    //              end;
    //          end;
    //          AControlForPageFrameworkIntf.SetPostValue(APageDataDir,GlobalMainProgramSetting.OpenPlatformImageUrl,APicPath);
    //
    //      end
    //      else
    //      begin

              //赋设计时的值
              AControlMap.PageFrameworkControlIntf.SetControlValue(AControlMap.Setting,
                                                                    APageDataDir,
                                                                    GlobalMainProgramSetting.OpenPlatformImageUrl,
                                                                    //Setting.value支持变量，比如$login_user_name，$my_vip_end_date
                                                                    GetPageFrameworkVariableValue(AControlMap.Setting.value),
                                                                    '',//AFieldControlSetting.caption,
                                                                    nil);

    //      end;
      end
//      else if AControlMap.Component is TSkinRealSkinItemComponent then
//      begin
//          if TSkinRealSkinItemComponent(AControlMap.Component).FSkinItem.GetInterface(IID_IControlForPageFramework,AControlMap.PageFrameworkControlIntf) then
//          begin
//      //        AControlMap.PageFrameworkControlIntf:=AControlForPageFrameworkIntf;
//              //加载设置
//              AControlMap.PageFrameworkControlIntf.LoadFromFieldControlSetting(AControlMap.Setting);
//              //设置自定义的值
//              AControlMap.PageFrameworkControlIntf.SetPropJsonStr(AControlMap.Setting.prop);
//              //赋设计时的值
//              AControlMap.PageFrameworkControlIntf.SetControlValue(AControlMap.Setting,
//                                                                    APageDataDir,
//                                                                    GlobalMainProgramSetting.OpenPlatformImageUrl,
//                                                                    //Setting.value支持变量，比如$login_user_name，$my_vip_end_date
//                                                                    GetPageFrameworkVariableValue(AControlMap.Setting.value),
//                                                                    '',//AFieldControlSetting.caption,
//                                                                    nil);
//
//          end;
//      end
      else if AControlMap.Component is TComboBox then
      begin
          //标准控件
          TComboBox(AControlMap.Component).Items.CommaText:=AControlMap.Setting.options_caption;
          TComboBox(AControlMap.Component).ItemIndex:=-1;
      end
      else if AControlMap.Component is TCheckBox then
      begin
          //标准控件
          TCheckBox(AControlMap.Component).{$IFDEF VCL}Checked{$ENDIF}{$IFDEF FMX}IsChecked{$ENDIF}:=SameText(AControlMap.Setting.value,'True')
                                                    or SameText(AControlMap.Setting.value,'1');
      end
      else if AControlMap.Component is TMemo then
      begin
          //标准控件
          TMemo(AControlMap.Component).Text:=AControlMap.Setting.value;
      end
      else if AControlMap.Component is TEdit then
      begin
          //标准控件
          TEdit(AControlMap.Component).Text:=AControlMap.Setting.value;
      end
      ;
end;

procedure SetFieldControlPostValue(
                                  AFieldControlSettingMap:TFieldControlSettingMap;
                                  APageDataDir:String;
                                  AImageServerUrl:String;
                                  AValue:Variant;
                                  AValueCaption:String;
                                  //要设置多个值,整个字段的记录
                                  AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
var
  AStringList:TStringList;
  AValueStr:String;
begin
  if AFieldControlSettingMap.PageFrameworkControlIntf<>nil then
  begin
    AFieldControlSettingMap.PageFrameworkControlIntf.SetControlValue(AFieldControlSettingMap.Setting,
                                                                      APageDataDir,
                                                                      AImageServerUrl,
                                                                      AValue,
                                                                      AValueCaption,
                                                                      AGetDataIntfResultFieldValueIntf);
  end
  else
  begin
    if AFieldControlSettingMap.Component is TEdit then
    begin
      TEdit(AFieldControlSettingMap.Component).Text:=AValue;
    end
    else if AFieldControlSettingMap.Component is TMemo then
    begin
      TMemo(AFieldControlSettingMap.Component).Text:=AValue;
    end
    else if AFieldControlSettingMap.Component is TCheckBox then
    begin
      AValueStr:=AValue;
      if AValueStr='' then
      begin
        AValue:=False;
      end;
      TCheckBox(AFieldControlSettingMap.Component).{$IFDEF VCL}Checked{$ENDIF}{$IFDEF FMX}IsChecked{$ENDIF}:=AValue;

    end
    else if AFieldControlSettingMap.Component is TComboBox then
    begin
      {$IFDEF FMX}
      TComboBox(AFieldControlSettingMap.Component).ItemIndex:=TComboBox(AFieldControlSettingMap.Component).Items.IndexOf(AValue);
      {$ENDIF}
      {$IFDEF VCL}
      //TComboBox(AFieldControlSettingMap.Component).Text:=AValue;
      AStringList:=TStringList.Create;
      try
        AStringList.CommaText:=AFieldControlSettingMap.Setting.options_value;
        TComboBox(AFieldControlSettingMap.Component).ItemIndex:=AStringList.IndexOf(AValue);
      finally
        FreeAndNil(AStringList);
      end;
      {$ENDIF}
    end
    ;
  end;
end;


//获取提交的值
function GetFieldControlPostValue(AFieldControlSettingMap:TFieldControlSettingMap;
                                  APageDataDir:String;
                                  ASetRecordFieldValueIntf:ISetRecordFieldValue;
                                  var AErrorMessage:String):Variant;
var
  AStringList:TStringList;
begin
  Result:='';
  if AFieldControlSettingMap.PageFrameworkControlIntf<>nil then
  begin
    Result:=AFieldControlSettingMap.PageFrameworkControlIntf.GetPostValue(
                                                              AFieldControlSettingMap.Setting,
                                                              APageDataDir,
                                                              ASetRecordFieldValueIntf,
                                                              AErrorMessage);

  end
  else
  begin
    if AFieldControlSettingMap.Component is TEdit then
    begin
      Result:=TEdit(AFieldControlSettingMap.Component).Text;
    end
    else if AFieldControlSettingMap.Component is TMemo then
    begin
      Result:=TMemo(AFieldControlSettingMap.Component).Text;
    end
    else if AFieldControlSettingMap.Component is TCheckBox then
    begin
      Result:=TCheckBox(AFieldControlSettingMap.Component).{$IFDEF VCL}Checked{$ENDIF}{$IFDEF FMX}IsChecked{$ENDIF};
    end
    else if AFieldControlSettingMap.Component is TComboBox then
    begin
      {$IFDEF FMX}
      Result:=TComboBox(AFieldControlSettingMap.Component).Items[TComboBox(AFieldControlSettingMap.Component).ItemIndex];
      {$ENDIF}
      {$IFDEF VCL}
//      Result:=TComboBox(AFieldControlSettingMap.Component).Text;
      AStringList:=TStringList.Create;
      try
        AStringList.CommaText:=AFieldControlSettingMap.Setting.options_value;
        Result:=AStringList[TComboBox(AFieldControlSettingMap.Component).ItemIndex];
      finally
        FreeAndNil(AStringList);
      end;
      {$ENDIF}
    end
    ;
  end;

end;


//保存控件为页面结构
//保存控件为页面结构,用于将设计面板保存为页面
function SaveControlToPage(AInterfaceUrl:String;
                            AAppID:Integer;
                            AProgramTemplateName:String;
                            APageName:String;
                            APageType:String;
                            APlatform:String;
                            APageCaption:String;
                            AParent:TControl;
                            AImageHttpServerUrl:String;
                            AIsSaveToServer:Boolean;ALocalFilePath:String):Boolean;
var
  APage:TPage;
  AIsAdd:Boolean;
  ADesc:String;
  ADataJson:ISuperObject;
  AIsUsedCache:Boolean;
  APageDataDir:String;
//  FSavePageInThreadDesc:String;
  APageRecordJson:ISuperObject;
  ANeedAddFieldControlSettingList:TList;
  AOldFieldControlSettingList:TFieldControlSettingList;
  ANewFieldControlSettingList:TFieldControlSettingList;
//  AIsSaveSubControlsToFieldControlSettingListSucc:Boolean;
begin

  Result:=False;



  //先判断页面是否存在

  APage:=TPage.Create(nil);
  try


    if AIsSaveToServer then
    begin
        //先从接口加载
        APage.LoadFromServer(AInterfaceUrl,
                             AAppID,
                             //0,
                             AProgramTemplateName,
                             '',
                             APageType,
                             APlatform,
                             APageName,
                             False,
                             ADesc,
                             AIsUsedCache
                             );
    end;


    APage.Name:=APageName;
    APage.caption:=APageCaption;
    APage.page_type:=APageType;
    APage.align_type:='manual';
    APage.appid:=AAppID;//页面的appid也基本都是1000
    APage.program_template_name:=AProgramTemplateName;
    APage.platform:=APlatform;

    {$IFDEF FMX}
    APage.design_width:=AParent.Width-AParent.Padding.Left*2;
    APage.design_height:=AParent.Height-AParent.Padding.Bottom*2;
    {$ENDIF}
    {$IFDEF VCL}
    APage.design_width:=AParent.Width;
    APage.design_height:=AParent.Height;
    {$ENDIF}

    APageRecordJson:=TSuperObject.Create();
    APage.SaveToJson(APageRecordJson);



    if AIsSaveToServer then
    begin
        //先将页面保存到数据库
        //将页面记录保存到服务端
        if not SaveRecordToServer(AInterfaceUrl,
                                  AAppID,
                                  '',
                                  '',
                                  'page',
                                  APage.fid,
                                  APageRecordJson,
                                  //返回是否是新增的记录
                                  AIsAdd,
                                  ADesc,
                                  ADataJson,
                                  '',
                                  '') then
        begin
      //    ShowMessage(ADesc);
          Exit;
        end;
      //  Exit;

        //保存成功,要取出新增记录的fid
        if AIsAdd then
        begin
          APage.fid:=ADataJson.I['fid'];
        end;
    end;





    AOldFieldControlSettingList:=APage.MainLayoutControlList;


    //新的控件列表
    ANewFieldControlSettingList:=TFieldControlSettingList.Create;
    //AIsSaveSubControlsToFieldControlSettingListSucc:=False;
    //要放在主线程中保存
//    TThread.Synchronize(nil,procedure
//    begin
        //将pnlClient中的控件都保存到列表中
        APageDataDir:=APage.GetPageDataDir;
        if not AIsSaveToServer and (ALocalFilePath<>'') then
        begin
          APageDataDir:=ExtractFilePath(ALocalFilePath);
        end;
        if not SaveSubControlsToFieldControlSettingList(
                                                AParent,
                                                AParent,
                                                ANewFieldControlSettingList,
                                                nil,
                                                APageDataDir,//APage.GetPageDataDir,
                                                ADesc) then
        begin
          Exit;
        end;
//        AIsSaveSubControlsToFieldControlSettingListSucc:=True;
//    end);
    APage.StaticMainLayoutControlList:=ANewFieldControlSettingList;
//    if not AIsSaveSubControlsToFieldControlSettingListSucc then
//    begin
//      Exit;
//    end;






    if AIsSaveToServer then
    begin

      if not APage.SaveSubControlsToServer(AInterfaceUrl,
                                          AAppID,
                                          AParent,
                                          APageDataDir,//APage.GetPageDataDir,
                                          nil,
                                          AImageHttpServerUrl,
                                          AOldFieldControlSettingList,
                                          //返回
                                          ANewFieldControlSettingList,
                                          ANeedAddFieldControlSettingList,
                                          ADesc
                                          ) then
      begin
        Exit;
      end;

      FreeAndNil(ANeedAddFieldControlSettingList);

    end;



    //保存页面到本地
    if not AIsSaveToServer then
    begin
      APage.SaveToFile(ALocalFilePath);
    end;





    FreeAndNil(AOldFieldControlSettingList);




    Result:=True;
  finally
    FreeAndNil(APage);
  end;
end;



procedure LoadPageControlMenu(APageControl:TSkinPageControl;AMenus:ISuperArray);
var
  I: Integer;
  ATabSheet:TSkinTabSheet;
begin

  APageControl.Prop.ClearPages;
  for I := 0 to AMenus.Length-1 do
  begin
    ATabSheet:=TSkinTabSheet.Create(APageControl);
//    ATabSheet.
    ATabSheet.Prop.PageControl:=APageControl;
    ATabSheet.Caption:=AMenus.O[I].S['caption'];
//    ATabSheet.Prop.Icon.Url:=GetImageUrl(AMenus.O[I].S['icon_pic_path']);
//    ATabSheet.Prop.PushedIcon.Url:=GetImageUrl(AMenus.O[I].S['pushed_icon_pic_path']);
    SetFrameName(ATabSheet);
  end;


end;

procedure SetComponentBoundsRect(AComponent:TComponent;ARect:TRectF);
begin
  if AComponent is TControl then
  begin
      //是控件
      {$IFDEF FMX}
      TControl(AComponent).BoundsRect:=ARect;
      {$ELSE}
      TControl(AComponent).BoundsRect:=RectF2Rect(ARect);//SetBounds(Ceil(ARect.Left),Ceil(ARect.Top),Ceil(ARect.Width),Ceil(ARect.Height));
      {$ENDIF}
  end
  else
  begin
      //是组件
      SetComponentLeft(AComponent,ControlSize(ARect.Left));
      SetComponentTop(AComponent,ControlSize(ARect.Top));
  end;
end;


function GetComponentBoundsRect(AComponent:TComponent):TRectF;
begin
  if AComponent is TControl then
  begin
      //是控件
      {$IFDEF FMX}
      Result:=TControl(AComponent).BoundsRect;
      {$ELSE}
      Result:=Rect2RectF(TControl(AComponent).BoundsRect);
      {$ENDIF}
  end
  else
  begin
      //是组件
      Result.Left:=LongRec(AComponent.DesignInfo).Lo;
      Result.Top:=LongRec(AComponent.DesignInfo).Hi;
      Result.Width:=COMPONENT_DESIGN_SIZE;
      Result.Height:=COMPONENT_DESIGN_SIZE;
  end;

end;

procedure SetComponentLeft(AComponent:TComponent;ALeft:TControlSize);
{$IFDEF FMX}
var
  ADesignInfo:TDesignInfo;
{$ENDIF}
{$IFDEF VCL}
var
  ADesignInfo:LongInt;
{$ENDIF}
begin
  if AComponent is TControl then
  begin
      //是控件
//      TControl(AComponent).Position.X:=ALeft;
      SetControlLeft(TControl(AComponent),ControlSize(ALeft));
  end
  else
  begin
      //是组件
      ADesignInfo:=AComponent.DesignInfo;
      LongRec(ADesignInfo).Lo:=Ceil(ALeft);
      AComponent.DesignInfo:=ADesignInfo;
  end;
end;

procedure SetComponentTop(AComponent:TComponent;ATop:TControlSize);
{$IFDEF FMX}
var
  ADesignInfo:TDesignInfo;
{$ENDIF}
{$IFDEF VCL}
var
  ADesignInfo:LongInt;
{$ENDIF}
begin
  if AComponent is TControl then
  begin
      //是控件
//      TControl(AComponent).Position.Y:=ATop;
      SetControlTop(TControl(AComponent),ControlSize(ATop));
  end
  else
  begin
      //是组件
      ADesignInfo:=AComponent.DesignInfo;
      LongRec(ADesignInfo).Hi:=Ceil(ATop);
      AComponent.DesignInfo:=ADesignInfo;
  end;
end;

procedure SetComponentWidth(AComponent:TComponent;AWidth:TControlSize);
begin
  if AComponent is TControl then
  begin
      //是控件
      TControl(AComponent).Width:=AWidth;
  end
  else
  begin
      //是组件
  end;
end;

procedure SetComponentHeight(AComponent:TComponent;AHeight:TControlSize);
begin
  if AComponent is TControl then
  begin
      //是控件
      TControl(AComponent).Height:=AHeight;
  end
  else
  begin
      //是组件
  end;
end;



function SaveChildComponentList(
              AParent:TControl;
              AComponentList:TList):Boolean;
var
  I: Integer;
begin
  Result:=False;

  AComponentList.Add(AParent);


  for I := 0 to AParent.ComponentCount-1 do
  begin

      //保存子组件列表
      if not (csSubComponent in AParent.Components[I].ComponentStyle) and not (AParent.Components[I] is TControl) then
      begin
        AComponentList.Add(AParent.Components[I]);
      end;

  end;

  {$IFDEF FMX}
  for I := 0 to AParent.ControlsCount-1 do
  begin

      //保存子控件列表
      if not (csSubComponent in AParent.Controls[I].ComponentStyle) then
      begin
        if not SaveChildComponentList(AParent.Controls[I],AComponentList) then
        begin
          Exit;
        end;
      end;

  end;
  {$ENDIF FMX}

  Result:=True;
end;

function SaveSubControlsToFieldControlSettingList(
      ARootParent:TControl;
      AParent:TControl;
      AFieldControlSettingList:TFieldControlSettingList;
      AParentFieldControlSetting:TFieldControlSetting;
      //保存图片的根相对目录
      APageDataDir:String;
      var AError:String):Boolean;
var
  I: Integer;
  AControl:TControl;
  AComponent:TComponent;
  AComponentType:String;
  AFieldControlSetting:TFieldControlSetting;
  AChildFieldControlSetting:TFieldControlSetting;
  J: Integer;
  AComponentTypeClassItem:TComponentTypeClassItem;
begin
  uBaseLog.HandleException(nil,'SaveSubControlsToFieldControlSettingList');


  Result:=False;


  //先保存组件
  for I := 0 to AParent.ComponentCount-1 do
  begin
      if not (csSubComponent in AParent.Components[I].ComponentStyle) and not (AParent.Components[I] is TControl) then
      begin


          AComponent:=AParent.Components[I];

          AComponentTypeClassItem:=GlobalFrameworkComponentTypeClasses.FindByComponent(AComponent);

          if AComponentTypeClassItem=nil then
          begin
            //有时候Selection不保存进去的
            AError:='Can''t find this component-type '+AComponent.Name+':'+AComponent.ClassName;
            uBaseLog.HandleException(nil,'SaveSubControlsToFieldControlSettingList '+AError);
    //        Exit;
            Continue;
          end;



          AFieldControlSetting:=TFieldControlSetting.Create(AFieldControlSettingList);
          AFieldControlSetting.control_type:=AComponentTypeClassItem.ComponentType;
          //父控件
          AFieldControlSetting.ParentFieldControlSetting:=AParentFieldControlSetting;
          if not SaveComponentToFieldControlSetting(ARootParent,AComponent,AFieldControlSetting,APageDataDir,AError) then
          begin
            //有时候Selection不保存进去的
            //Exit;
          end;

          //确定parent_control_fid
//          AFieldControlSettingList.Add(AFieldControlSetting);


      end;
  end;



  {$IFDEF FMX}
  //保存控件
  for I := 0 to AParent.ControlsCount-1 do
  begin

      if not (csSubComponent in AParent.Controls[I].ComponentStyle) then
      begin

          AControl:=AParent.Controls[I];
    //      AComponentType:=GlobalFrameworkComponentTypeClasses.FindTypeByClass(AControl.ClassName);
    //
    //      if AComponentType='' then
    //      begin
    //        AError:='Can''t support this control '+AControl.Name+':'+AControl.ClassName;
    //        Exit;
    //      end;

          AComponentTypeClassItem:=GlobalFrameworkComponentTypeClasses.FindByComponent(AControl);

          if AComponentTypeClassItem=nil then
          begin
            //有时候Selection不保存进去的
            AError:=AError+'Can''t find this control-type '+AControl.Name+':'+AControl.ClassName+#13#10;
            uBaseLog.HandleException(nil,'SaveSubControlsToFieldControlSettingList '+AError);
    //        Exit;
            Continue;
          end;



          AFieldControlSetting:=TFieldControlSetting.Create(AFieldControlSettingList);
          AFieldControlSetting.control_type:=AComponentTypeClassItem.ComponentType;
          //父控件
          AFieldControlSetting.ParentFieldControlSetting:=AParentFieldControlSetting;
          if not SaveComponentToFieldControlSetting(ARootParent,
                                                    AControl,
                                                    AFieldControlSetting,
                                                    APageDataDir,
                                                    AError) then
          begin
            //有时候Selection不保存进去的
            //Exit;
          end;

          //确定parent_control_fid
//          AFieldControlSettingList.Add(AFieldControlSetting);






//          //判断是否需要提交上传图片,图片有没有改过,怎么判断?
//          if SameText(AFieldControlSetting.control_type,'image') then
//          begin
//              if TSkinImage(AFieldControlSetting.SavedComponent).Prop.Picture.IsChanged then
//              begin
//                  if FileExists(APageDataDir+'pics\'+AFieldControlSetting.value) then
//                  begin
//                      //改过图片
//                      //提交图片
//                      if not DoUploadFile(APageDataDir+'pics\'+AFieldControlSetting.value,
//                                         AImageHttpServerUrl,
//                                         AAppID,
//                                         'page_design',
//                                         ARemoteFilePath,
//                                         ADesc
//                                         ) then
//                      begin
//                        Exit;
//                      end;
//                      AFieldControlSetting.value:=ARemoteFilePath;
//                  end;
//              end;
//          end;





          //保存子控件列表
          if not SaveSubControlsToFieldControlSettingList(ARootParent,
                                                          AControl,
                                                          AFieldControlSettingList,
                                                          AFieldControlSetting,
                                                          APageDataDir,
                                                          AError) then
          begin
            Exit;
          end;







      end;

  end;
  {$ENDIF FMX}


  Result:=True;

end;

function SaveComponentToFieldControlSetting(
    ARootParent:TControl;
    AComponent:TComponent;
    AFieldControlSetting:TFieldControlSetting;
    //保存图片的根相对目录
    APageDataDir:String;
    var AError:String):Boolean;
var
  AControl:TControl;
  ABoundsRect:TRectF;
  AComponentTypeClassItem:TComponentTypeClassItem;
  ASkinControlMaterialIntf:ISkinControlMaterial;
  ASkinControlIntf:ISkinControl;

  {$IFDEF FMX}
  ATextSettingsIntf:ITextSettings;
  {$ENDIF}

  ADrawCaptionParam:TDrawTextParam;
  ADrawPictureParam:TDrawPictureParam;
  AControlForPageFrameworkIntf:IControlForPageFramework;
  ASkinItemBindingControlIntf:ISkinItemBindingControl;


  AHasMultiFields:Boolean;
  AFieldNames:Array of String;
  AFieldValues:Array of Variant;

begin
  uBaseLog.HandleException(nil,'SaveComponentToFieldControlSetting ');



  Result:=False;


  //控件类型
  AComponentTypeClassItem:=GlobalFrameworkComponentTypeClasses.FindByComponent(AComponent);

  if AComponentTypeClassItem=nil then
  begin
    AError:='Can''t find this control-type '+AComponent.Name+':'+AComponent.ClassName;
    uBaseLog.HandleException(nil,'SaveComponentToFieldControlSetting '+AError);
    Exit;
  end;
  AFieldControlSetting.control_type:=AComponentTypeClassItem.ComponentType;



  AFieldControlSetting.name:=AComponent.Name;



  //所对应的字段
  //所绑定的字段
  if AComponent.GetInterface(IID_ISkinItemBindingControl,ASkinItemBindingControlIntf) then
  begin
      AFieldControlSetting.field_name:=ASkinItemBindingControlIntf.GetBindItemFieldName;
  end;



  //位置和尺寸
  ABoundsRect:=GetComponentBoundsRect(AComponent);
  AFieldControlSetting.x:=ABoundsRect.Left;//AControl.Position.X;
  AFieldControlSetting.y:=ABoundsRect.Top;//AControl.Position.Y;
  AFieldControlSetting.width:=ABoundsRect.Width;//AControl.Width;
  AFieldControlSetting.height:=ABoundsRect.Height;//AControl.Height;



  AFieldControlSetting.SavedComponent:=AComponent;




  //保存值,比如Label的Caption,Image的图片
  //加载设置
  if AComponent.GetInterface(IID_IControlForPageFramework,AControlForPageFrameworkIntf) then
  begin
      AFieldControlSetting.prop:=AControlForPageFrameworkIntf.GetPropJsonStr;

      AError:='';
      AFieldControlSetting.value:=AControlForPageFrameworkIntf.GetPostValue(AFieldControlSetting,
                                                                            APageDataDir,
                                                                            nil,
                                                                            AError);
      if AError<>'' then
      begin
        uBaseLog.HandleException(nil,'AControlForPageFrameworkIntf.GetPostValue '+AError);

        Exit;
      end;
  end
  else
  begin
    AFieldControlSetting.value:='';
  end;




  if AComponent is TControl then
  begin

      AControl:=TControl(AComponent);


      //根控件的
      if ARootParent<>AControl.Parent then
      begin
        AFieldControlSetting.parent_control_name:=AControl.Parent.Name;
      end;


//      //每类控件的特殊属性
//      if AControl.GetInterface(IID_ISkinControl,ASkinControlIntf) then
//      begin
//          AFieldControlSetting.prop:=ASkinControlIntf.Prop.GetPropJsonStr;
//      end;





      //保存控件属性,常用的属性直接是字段,特有的属性是保存到自己的json中去
      //位置和尺寸
      {$IFDEF FMX}
      AFieldControlSetting.margins:=GetMarginsStr(AControl.Margins);
      {$ENDIF}

      //对齐
      AFieldControlSetting.align:=GetAlignStr(AControl.Align);

      //锚点
      AFieldControlSetting.anchors:=GetAnchorsStr(AControl.Anchors);

      //是否显示
      AFieldControlSetting.Visible:=Ord(AControl.Visible);
      {$IFDEF FMX}
      AFieldControlSetting.hittest:=Ord(AControl.HitTest);
      {$ENDIF FMX}
      AFieldControlSetting.enabled:=Ord(AControl.Enabled);




      {$IFDEF FMX}
      //Edit保存TextSetting
      if AControl.GetInterface(IID_ITextSettings,ATextSettingsIntf) then
      begin
          //输入的字体设置
          AFieldControlSetting.text_font_name:=ATextSettingsIntf.TextSettings.Font.Family;
          AFieldControlSetting.text_font_size:=Ceil(ATextSettingsIntf.TextSettings.Font.Size);
          AFieldControlSetting.text_font_color:=ColorToWebHex(ATextSettingsIntf.TextSettings.FontColor);
          AFieldControlSetting.text_vert_align:=GetVertTextAlignStr(ATextSettingsIntf.TextSettings.VertAlign);
          AFieldControlSetting.text_horz_align:=GetHorzTextAlignStr(ATextSettingsIntf.TextSettings.HorzAlign);
          AFieldControlSetting.text_style:=GetFontStyleStr(ATextSettingsIntf.TextSettings.Font.Style);
          AFieldControlSetting.text_wordwrap:=Ord(ATextSettingsIntf.TextSettings.WordWrap);
      end;
      {$ENDIF FMX}



      //背景色,这种是比较简单的设置,如果要复杂的,需要使用风格
      if AControl.GetInterface(IID_ISkinControlMaterial,ASkinControlMaterialIntf)
          and (ASkinControlMaterialIntf.SelfOwnMaterial<>nil) then
      begin
          AFieldControlSetting.back_color:='';



          if not ASkinControlMaterialIntf.SelfOwnMaterial.IsTransparent then
          begin
              if ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.IsFill then
              begin
                AFieldControlSetting.back_color:=ColorToWebHex(ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.FillColor.Color);
              end;
              if BiggerDouble(ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.BorderWidth,0) then
              begin
                AFieldControlSetting.border_color:=ColorToWebHex(ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.BorderColor.Color);
                AFieldControlSetting.border_width:=ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.BorderWidth;
                AFieldControlSetting.border_edges:=GetBorderEadgesStr(ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.BorderEadges);
              end;
              if ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.IsRound then
              begin
                AFieldControlSetting.back_round_width:=ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.RoundWidth;
                AFieldControlSetting.back_corners:=GetRectCornersStr(ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.RectCorners);
              end;

          end;



          {$IFDEF FMX}
          if AControl.GetInterface(IID_ITextSettings,ATextSettingsIntf) then
          begin
              //Edit保存TextSetting

          end
          else
          {$ENDIF FMX}
          begin

              //字体设置
              ADrawCaptionParam:=TDrawTextParam(ASkinControlMaterialIntf.SelfOwnMaterial.FindParamByName('DrawCaptionParam'));
              if ADrawCaptionParam<>nil then
              begin
                AFieldControlSetting.text_font_name:=ADrawCaptionParam.DrawFont.FontName;
                AFieldControlSetting.text_font_size:=Ceil(ADrawCaptionParam.DrawFont.FontSize);
                AFieldControlSetting.text_font_color:=ColorToWebHex(ADrawCaptionParam.DrawFont.FontColor.Color);
                AFieldControlSetting.text_vert_align:=GetFontVertAlignStr(ADrawCaptionParam.FontVertAlign);
                AFieldControlSetting.text_horz_align:=GetFontHorzAlignStr(ADrawCaptionParam.FontHorzAlign);
                AFieldControlSetting.text_style:=GetFontStyleStr(ADrawCaptionParam.FontStyle);
                AFieldControlSetting.text_wordwrap:=Ord(ADrawCaptionParam.IsWordWrap);
              end;


          end;



          //图片绘制设置
          ADrawPictureParam:=TDrawPictureParam(ASkinControlMaterialIntf.SelfOwnMaterial.FindParamByName('DrawPictureParam'));
          if ADrawPictureParam<>nil then
          begin
            AFieldControlSetting.picture_is_stretch:=Ord(ADrawPictureParam.IsStretch);
            AFieldControlSetting.picture_is_autofit:=Ord(ADrawPictureParam.IsAutoFit);
            AFieldControlSetting.picture_vert_align:=GetPictureVertAlignStr(ADrawPictureParam.PictureVertAlign);
            AFieldControlSetting.picture_horz_align:=GetPictureHorzAlignStr(ADrawPictureParam.PictureHorzAlign);
          end;


      end;



      if (ASkinControlMaterialIntf<>nil)
          and (ASkinControlMaterialIntf.MaterialUseKind=mukRef)
          and (ASkinControlMaterialIntf.RefMaterial<>nil) then
      begin
        AFieldControlSetting.control_style:=ASkinControlMaterialIntf.RefMaterial.StyleName;
      end;

      if (ASkinControlMaterialIntf<>nil)
          and (ASkinControlMaterialIntf.MaterialUseKind=mukRefByStyleName) then
      begin
        AFieldControlSetting.control_style:=ASkinControlMaterialIntf.MaterialName;
      end;



  end;

  Result:=True;
end;


function LoadComponentFromFieldControlSetting(
    AControlMap:TFieldControlSettingMap;
    AComponent:TComponent;
    AFieldControlSetting:TFieldControlSetting;
    //保存图片的根相对目录
    APageDataDir:String;
    AIsDesignTime:Boolean;
    var AError:String):Boolean;
var
  AControl:TControl;
  AComponentTypeClassItem:TComponentTypeClassItem;
  ASkinControlMaterialIntf:ISkinControlMaterial;
  ASkinControlIntf:ISkinControl;

  {$IFDEF FMX}
  ATextSettingsIntf:ITextSettings;
  {$ENDIF FMX}

  ADrawCaptionParam:TDrawTextParam;
  ADrawPictureParam:TDrawPictureParam;
//  AControlForPageFrameworkIntf:IControlForPageFramework;
//  APicPath:String;
  ASkinItemBindingControlIntf:ISkinItemBindingControl;
//  ASkinControlMaterialIntf:ISkinControlMaterial;
  ABoundsRect:TRectF;
begin
  Result:=False;

  try

    //  //控件类型
    //  AComponentTypeClassItem:=GlobalFrameworkComponentTypeClasses.FindByControl(AControl);
    //
    //  if AComponentTypeClassItem=nil then
    //  begin
    //    AError:='Can''t find this control-type '+AControl.Name+':'+AControl.ClassName;
    //    Exit;
    //  end;
    //  AFieldControlSetting.control_type:=AComponentTypeClassItem.ComponentType;

      AComponent.Name:=AFieldControlSetting.Name;



      //设置控件属性,常用的属性直接是字段,特有的属性是保存到自己的json中去
      //位置和尺寸
      ABoundsRect:=RectF(AFieldControlSetting.x,
                         AFieldControlSetting.y,
                         AFieldControlSetting.x+AFieldControlSetting.width,
                         AFieldControlSetting.y+AFieldControlSetting.height
                          );
      if AComponent is TControl then
      begin
        //必须这样的赋值方式,不然在ScaleLayout上面会显示变形
        SetControlLeft(TControl(AComponent),ControlSize(AFieldControlSetting.x));
        SetControlTop(TControl(AComponent),ControlSize(AFieldControlSetting.y));
        TControl(AComponent).Width:=ControlSize(AFieldControlSetting.width);
        TControl(AComponent).Height:=ControlSize(AFieldControlSetting.height);
      end
      else
      begin
        SetComponentBoundsRect(AComponent,ABoundsRect);
      end;



      //设置绑定字段,这里就有点问题了,又不是ItemDesignerPanel上面的控件,不需要设置这个BindItemFieldName
      if AComponent.GetInterface(IID_ISkinItemBindingControl,ASkinItemBindingControlIntf) then
      begin
          ASkinItemBindingControlIntf.SetBindItemFieldName(AFieldControlSetting.field_name);
      end;




      if AComponent is TControl then
      begin

            AControl:=TControl(AComponent);


            {$IFDEF FMX}
            //设置对齐边距
            SetMargins(AControl.Margins,AFieldControlSetting.margins);
            {$ENDIF FMX}


            //对齐
            AControl.Align:=GetAlign(AFieldControlSetting.align);

            //锚点
            AControl.Anchors:=GetAnchors(AFieldControlSetting.anchors);

            //是否显示
            AControl.Visible:=(AFieldControlSetting.Visible=1);
            if AControlMap.InputPanel<>nil then AControlMap.InputPanel.Visible:=(AFieldControlSetting.Visible=1);
            
            {$IFDEF FMX}
            AControl.HitTest:=(AFieldControlSetting.hittest=1);
            {$ENDIF FMX}
            AControl.Enabled:=(AFieldControlSetting.enabled=1);



            {$IFDEF FMX}
            //Edit加载TextSetting
            if AControl.GetInterface(IID_ITextSettings,ATextSettingsIntf) then
            begin
                //输入的字体设置
                if AFieldControlSetting.text_font_name<>'' then ATextSettingsIntf.TextSettings.Font.Family:=AFieldControlSetting.text_font_name;
                if BiggerDouble(AFieldControlSetting.text_font_size,0) then ATextSettingsIntf.TextSettings.Font.Size:=AFieldControlSetting.text_font_size;
                if AFieldControlSetting.text_font_color<>'' then ATextSettingsIntf.TextSettings.FontColor:=WebHexToColor(AFieldControlSetting.text_font_color);
                if AFieldControlSetting.text_vert_align<>'' then ATextSettingsIntf.TextSettings.VertAlign:=GetVertTextAlign(AFieldControlSetting.text_vert_align);
                if AFieldControlSetting.text_horz_align<>'' then ATextSettingsIntf.TextSettings.HorzAlign:=GetHorzTextAlign(AFieldControlSetting.text_horz_align);
                if AFieldControlSetting.text_style<>'' then ATextSettingsIntf.TextSettings.Font.Style:=GetFontStyle(AFieldControlSetting.text_style);
                //Edit没有换行功能
                //Memo呢默认都是要换行的,
                ATextSettingsIntf.TextSettings.WordWrap:=True;//(AFieldControlSetting.text_wordwrap=1);
            end;
            {$ENDIF FMX}



            //创建素材SelfOwnMaterial和ComponentType
            if AControl.GetInterface(IID_ISkinControl,ASkinControlIntf) then
            begin
                ASkinControlIntf.GetSkinControlType;
                ASkinControlIntf.GetCurrentUseMaterial;


                ASkinControlIntf.ParentMouseEvent:=AIsDesignTime;

    //            ASkinControlIntf.Prop.SetPropJsonStr(AFieldControlSetting.prop);


//                ASkinControlIntf.GetCurrentUseMaterial.IsTransparent:=False;
//                ASkinControlIntf.GetCurrentUseMaterial.BackColor.IsFill:=True;
//                ASkinControlIntf.GetCurrentUseMaterial.BackColor.FillColor.Color:=TAlphaColorRec.Red;
           end;



//            if AControl is TSkinButton then
//            begin
//                TSkinButton(AControl).Caption:=AFieldControlSetting.field_caption;
//            end;



            if AControl is TSkinItemDesignerPanel then
            begin
                //默认值
                //设计面板在设计器时要处理,
                AControl.Visible:=AIsDesignTime;//设计时才显示
                if AControl.Parent is TSkinVirtualList then
                begin
                  TSkinVirtualList(AControl.Parent).Prop.ItemDesignerPanel:=TSkinItemDesignerPanel(AControl);
                end;
            end;



            if AControl is TSkinVirtualList then
            begin
                //默认值
                TSkinVirtualList(AControl).Prop.ItemWidth:=-1;
                if AControl is TSkinListView then
                begin
                  TSkinListView(AControl).Prop.ViewType:=TListViewType.lvtList;
                end;
                TSkinVirtualList(AControl).VertScrollBar;
                TSkinVirtualList(AControl).HorzScrollBar;
                TSkinVirtualList(AControl).Prop.EnableAutoPullDownRefreshPanel:=True;
                TSkinVirtualList(AControl).Prop.EnableAutoPullUpLoadMorePanel:=True;
                //默认带有分隔线
                TSkinVirtualList(AControl).Material.DrawItemDevideParam.IsFill:=True;
            //    TSkinVirtualList(AControl).Material.IsTransparent:=False;
            //    TSkinVirtualList(AControl).Material.BackColor.IsFill:=True;
            //    TSkinVirtualList(AControl).Material.BackColor.FillColor.Color:=TAlphaColorRec.Red;
            end;




            //加载背景色,这种是比较简单的设置,如果要复杂的,需要使用风格
            if AControl.GetInterface(IID_ISkinControlMaterial,ASkinControlMaterialIntf)
              and (ASkinControlMaterialIntf.SelfOwnMaterial<>nil) then
            begin

                if AFieldControlSetting.control_style<>'' then
                begin
                  ASkinControlMaterialIntf.MaterialUseKind:=TMaterialUseKind.mukRefByStyleName;
                  ASkinControlMaterialIntf.MaterialName:=AFieldControlSetting.control_style;
                end
                else
                begin
//                  {$IFNDEF MY_PROGRAM_DESIGNER}
//                  {$IFNDEF MY_PROGRAM_VIEWER}
//                  ASkinControlMaterialIntf.MaterialUseKind:=TMaterialUseKind.mukRefByStyleName;
//                  ASkinControlMaterialIntf.MaterialName:='Default';
//                  {$ENDIF}
//                  {$ENDIF}
                  //设计器和查看器都使用SelfOwnMaterial
                end;




//                if AControl is TSkinButton then
//                begin
//                  ASkinControlMaterialIntf.MaterialUseKind:=TMaterialUseKind.mukRefByStyleName;
//                  //多个控件需要有不同的素材
//                  if AFieldControlSetting.control_style='' then
//                  begin
//                    ASkinControlMaterialIntf.MaterialName:='Default';//会影响设计器
//                  end
//                  else
//                  begin
//                    ASkinControlMaterialIntf.MaterialName:=AFieldControlSetting.control_style;
//                  end;
//                end;


                //背景色
                if AFieldControlSetting.back_color<>'' then
                begin
                  ASkinControlMaterialIntf.SelfOwnMaterial.IsTransparent:=False;
                  ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.IsFill:=True;

                  ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.FillColor.Color:=WebHexToColor(AFieldControlSetting.back_color);
                end;


                //边框
                if BiggerDouble(AFieldControlSetting.border_width,0) then
                begin
                  ASkinControlMaterialIntf.SelfOwnMaterial.IsTransparent:=False;

                  ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.BorderWidth:=ControlSize(AFieldControlSetting.border_width);
                  ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.BorderColor.Color:=WebHexToColor(AFieldControlSetting.border_color);
                  ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.BorderEadges:=GetBorderEadges(AFieldControlSetting.border_edges);
                end;


//                if BiggerDouble(AFieldControlSetting.border_width,0) then
//                begin
//                  ASkinControlMaterialIntf.SelfOwnMaterial.IsTransparent:=False;
//
//                  ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.BorderWidth:=AFieldControlSetting.border_width;
//                  ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.BorderColor.Color:=WebHexToColor(AFieldControlSetting.border_color);
//                  ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.BorderEadges:=GetBorderEadges(AFieldControlSetting.border_edges);
//                end;



                //圆角宽度
                if BiggerDouble(AFieldControlSetting.back_round_width,0) then
                begin
                  ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.IsRound:=True;
                  ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.RoundWidth:=ControlSize(AFieldControlSetting.back_round_width);
                  ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.RoundHeight:=ControlSize(AFieldControlSetting.back_round_width);
                  ASkinControlMaterialIntf.SelfOwnMaterial.BackColor.RectCorners:=GetRectCorners(AFieldControlSetting.back_corners);
                end;


                {$IFDEF FMX}
                if AControl.GetInterface(IID_ITextSettings,ATextSettingsIntf) then
                begin
                    //Edit保存TextSetting


                end
                else
                {$ENDIF FMX}
                begin
                    //加载字体设置
                    ADrawCaptionParam:=TDrawTextParam(ASkinControlMaterialIntf.SelfOwnMaterial.FindParamByName('DrawCaptionParam'));
                    if ADrawCaptionParam<>nil then
                    begin
                      if AFieldControlSetting.text_font_name<>'' then ADrawCaptionParam.DrawFont.FontName:=AFieldControlSetting.text_font_name;
                      if BiggerDouble(AFieldControlSetting.text_font_size,0) then ADrawCaptionParam.DrawFont.FontSize:=AFieldControlSetting.text_font_size;
                      if AFieldControlSetting.text_font_color<>'' then ADrawCaptionParam.DrawFont.FontColor.Color:=WebHexToColor(AFieldControlSetting.text_font_color);
                      if AFieldControlSetting.text_vert_align<>'' then ADrawCaptionParam.FontVertAlign:=GetFontVertAlign(AFieldControlSetting.text_vert_align);
                      if AFieldControlSetting.text_horz_align<>'' then ADrawCaptionParam.FontHorzAlign:=GetFontHorzAlign(AFieldControlSetting.text_horz_align);
                      if AFieldControlSetting.text_style<>'' then ADrawCaptionParam.FontStyle:=GetFontStyle(AFieldControlSetting.text_style);
                      ADrawCaptionParam.IsWordWrap:=(AFieldControlSetting.text_wordwrap=1);
                    end;
                end;




                //图片绘制设置
                ADrawPictureParam:=TDrawPictureParam(ASkinControlMaterialIntf.SelfOwnMaterial.FindParamByName('DrawPictureParam'));
                if ADrawPictureParam<>nil then
                begin
                  ADrawPictureParam.IsStretch:=(AFieldControlSetting.picture_is_stretch=1);
                  ADrawPictureParam.IsAutoFit:=(AFieldControlSetting.picture_is_autofit=1);
                  ADrawPictureParam.PictureVertAlign:=GetPictureVertAlign(AFieldControlSetting.picture_vert_align);
                  ADrawPictureParam.PictureHorzAlign:=GetPictureHorzAlign(AFieldControlSetting.picture_horz_align);
                end;



//                if AControl is TSkinButton then
//                begin
//                  TSkinButton(AControl).Caption:=AFieldControlSetting.field_caption;
//                end;


            end;



      end;




      //设置值,比如Label的Caption,Image的图片
      AControlMap.PageFrameworkControlIntf:=nil;

      InitFieldControlBySetting(AControlMap,APageDataDir);



      Result:=True;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'LoadComponentFromFieldControlSetting');
    end;
  end;
end;



//function ShowEditPageFrame(AEditPageStructure:TPage):Boolean;
//begin
//
//end;
//
//function ShowListPageFrame(AListPageStructure:TPage):Boolean;
//begin
//
//end;
//
//function ShowViewPageFrame(AViewPageStructure:TPage):Boolean;
//begin
//
//end;
//
//function DoCreateControls(
//  AParent: TControl;
//  ALayoutSetting:TLayoutSetting;
//  AFieldControlSettingList: TPageLayoutControlList;
//  AFilterPagePart:String;
//  var AControlMapList:TPageLayoutControlMapList
//  ): Boolean;
//var
//  I: Integer;
//  AControl:TControl;
//  AControlParent:TControl;
//  AComponentClass:TComponentClass;
//  AControlMap:TPageLayoutControlMap;
//  AFieldControlSetting:TFieldControlSetting;
//  ALayoutItem:TControlLayoutItem;
//begin
//  Result:=False;
//
//  try
//
//    //如果是创建在设计面板上面的,那么先清除绑定
////    if AParent is TSkinItemDesignerPanel then
////    begin
////      TSkinItemDesignerPanel(AParent).Prop.Clear;
////    end;
//
//
//
//    //释放原来创建的控件
//    for I := AControlMapList.Count-1 downto 0 do
//    begin
//      AControlMapList[I].Control.Parent:=nil;
//      AControlMapList.Delete(I,True);
//    end;
//    AControlMapList.LayoutManager.Clear(True);
//    AControlMapList.Parent:=nil;
//    AControlMapList.LayoutSetting:=ALayoutSetting;
//
//
//
//    AControlMapList.Parent:=AParent;
//    //创建控件列表
//    for I := 0 to AFieldControlSettingList.Count-1 do
//    begin
//        AFieldControlSetting:=AFieldControlSettingList[I];
//
//        if SameText(AFieldControlSetting.PagePart,AFilterPagePart) then
//        begin
//
//            AControlMap:=TPageLayoutControlMap.Create;
//            AControlMap.Setting:=AFieldControlSetting;
//
//
//            AControlParent:=AParent;
//            //创建提示控件
//            if AFieldControlSetting.HasHintLabel=1 then
//            begin
//
//                //编辑页面需要加入一个底部的Panel
////                if (ALayoutSetting<>nil)
//////                  and (APage.PageType=Const_PageType_EditPage)
////                  then
////                begin
//                  AControlMap.InputPanel:=TBaseSkinPanel.Create(nil);
//                  AControlMap.InputPanel.Parent:=AParent;
//                  AControlParent:=AControlMap.InputPanel;
//                  TBaseSkinPanel(AControlMap.InputPanel).MaterialUseKind:=TMaterialUseKind.mukRefByStyleName;
//                  TBaseSkinPanel(AControlMap.InputPanel).MaterialName:=Const_ControlStyle_EditPageInputPanelDefault;
////                end;
//
//                //创建提示控件
//                AControlMap.HintLabel:=TSkinLabel.Create(nil);
//                AControlMap.HintLabel.Parent:=AControlParent;
//                //设置标题
//                TSkinLabel(AControlMap.HintLabel).Caption:=AFieldControlSetting.caption;
//                //设置素材
//                TSkinLabel(AControlMap.HintLabel).MaterialUseKind:=TMaterialUseKind.mukRefByStyleName;
//                TSkinLabel(AControlMap.HintLabel).MaterialName:=Const_ControlStyle_EditPageHintLabelDefult;
//            end;
//
//
//
//            //根据控件类型来创建控件
//            AComponentClass:=GlobalFrameworkComponentTypeClasses.FindItemByName(AFieldControlSetting.ComponentType);
//            if AComponentClass=nil then
//            begin
//              raise Exception.Create('DoCreateControls 不支持'+AFieldControlSetting.ComponentType+'控件');
//              Exit;
//            end;
//            //创建控件
//            AControlMap.Control:=AComponentClass.Create(nil);
//            AControlMap.Control.Parent:=AControlParent;
//            AControlMap.Control.OnClick:=AControlMapList.DoFieldControlClick;
//            //设置控件的属性
//            if AControlMap.Control.GetInterface(IID_IControlForPageFramework,
//                  AControlMap.PageFrameworkControlIntf) then
//            begin
//                //加载设置
//                AControlMap.PageFrameworkControlIntf.LoadFromFieldControlSetting(AFieldControlSetting);
//            end;
//
//            AControlMapList.Add(AControlMap);
//
//
//
//            //创建布局项,用于排列
//            ALayoutItem:=TControlLayoutItem.Create(AControlMapList.LayoutManager);
//            ALayoutItem.ControlMap:=AControlMap;
//            ALayoutItem.Height:=AFieldControlSetting.height;
//            if (AControlMap.PageFrameworkControlIntf<>nil)
//              //自定义的高度,GetSuitDefaultItemHeight不为-1
//              and IsNotSameDouble(AControlMap.PageFrameworkControlIntf.GetSuitDefaultItemHeight,
//                                  Const_Tag_UseListItemHeight) then
//            begin
//              ALayoutItem.Height:=
//                AControlMap.PageFrameworkControlIntf.GetSuitDefaultItemHeight;
//            end;
//            AControlMapList.LayoutManager.Add(ALayoutItem);
//
//        end;
//
//    end;
//
//
//
////    //根据控件创建布局排列项
////    AControlMapList.LayoutManager.BeginUpdate;
////    try
////      AControlMapList.LayoutManager.Clear(True);
////      for I := 0 to AControlMapList.Count-1 do
////      begin
////        ALayoutItem:=TControlLayoutItem.Create(AControlMapList.LayoutManager);
////        ALayoutItem.ControlMap:=AControlMapList[I];
////
////
////        ALayoutItem.Height:=AControlMapList[I].Setting.height;
////        if (AControlMapList[I].PageFrameworkControlIntf<>nil)
////          //自定义的高度
////          and IsNotSameDouble(AControlMapList[I].PageFrameworkControlIntf.GetSuitDefaultItemHeight,Const_Tag_UseListItemHeight) then
////        begin
////          ALayoutItem.Height:=
////            AControlMapList[I].PageFrameworkControlIntf.GetSuitDefaultItemHeight;
////        end;
////
////
////        AControlMapList.LayoutManager.Add(ALayoutItem);
////      end;
////    finally
////      AControlMapList.LayoutManager.EndUpdate();
////    end;
//
//
////    //设置绑定
////    if AParent is TSkinItemDesignerPanel then
////    begin
////      for I := 0 to Self.Count-1 do
////      begin
////        if Items[I].Setting.bind_listitem_data_type<>'' then
////        begin
////          //需要绑定
////          TSkinItemDesignerPanel(ALayoutParent).Prop.BindControl(
////              Items[I].Setting.bind_listitem_data_type,
////              Items[I].Setting.BindSubItemsIndex,
////              Items[I].Control
////              );
////        end;
////      end;
////    end;
//
//
//
//    Result:=True;
//
//  except
//    on E:Exception do
//    begin
//      uBaseLog.HandleException(E,'CreateControls');
//    end;
//  end;
//
//end;



//function SimpleCallAPI(API: String;
//                      AHttpControl:THttpControl;
//                      AInterfaceUrl:String;
//                      AUrlParamNames:TStringDynArray;
//                      AUrlParamValues:Array of Variant): String;
//var
//  ACallResult:Boolean;
//  AIsNeedFreeAHttpControl:Boolean;
//  AResponseStream: TStringStream;
//begin
////  uBaseLog.HandleException(nil,'SimpleCallAPI '+API+' '+'begin');
//
//  Result:='';
//
//  AIsNeedFreeAHttpControl:=False;
//  if AHttpControl=nil then
//  begin
//    AIsNeedFreeAHttpControl:=True;
//    AHttpControl:=TSystemHttpControl.Create;
//  end;
//
//
//  AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
//  try
//    ACallResult:=SimpleGet(
//                       API,
//                       AHttpControl,
//                       AInterfaceUrl,
//                       AUrlParamNames,
//                       AUrlParamValues,
//                       AResponseStream
//                       );
//
//
//    if ACallResult then
//    begin
//        //调用成功
//
//        //保存成临时文件,用来查日志
////        {$IFDEF MSWINDOWS}
////        AResponseStream.Position:=0;
////        AResponseStream.
////            SaveToFile(GetApplicationPath
////                        +ReplaceStr(API,'/','_')+' '
////                        +FormatDateTime('YYYY-MM-DD HH-MM-SS-ZZZ',Now)+'.json');
////        {$ENDIF}
//
//        AResponseStream.Position:=0;
//        Result:=AResponseStream.DataString;
//
////        //服务不可用
////        if Result='Service Unavailable' then
////        begin
////          Result:='';
////        end;
//
//
//    end
//    else
//    begin
//      //调用失败
//
//    end;
//
//  finally
//    SysUtils.FreeAndNil(AResponseStream);
//    if AIsNeedFreeAHttpControl then
//    begin
//      SysUtils.FreeAndNil(AHttpControl);
//    end;
//  end;
//
////  uBaseLog.HandleException(nil,'SimpleCallAPI '+API+' '+'end');
//end;
//
//
//function SimpleCallAPI(API: String;
//          AHttpControl: THttpControl;
//          AInterfaceUrl:String;
//          AUrlParamNames:TStringDynArray;
//          AUrlParamValues:Array of Variant;
//          var ACode:Integer;
//          var ADesc:String;
//          var ADataJson:ISuperObject): Boolean;
//var
//  AHttpResponse:String;
//  ASuperObject:ISuperObject;
//begin
//  Result:=False;
//
//  //在外面初始好了,不用再在里面初始了
//  ACode:=400;//FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//  AHttpResponse:=SimpleCallAPI(API,
//                              AHttpControl,
//                              AInterfaceUrl,
//                              AUrlParamNames,
//                              AUrlParamValues);
//  if (AHttpResponse<>'')
//    or not SameText(AHttpResponse,'Service Unavailable') then
//  begin
//      try
//        ASuperObject:=TSuperObject.Create(AHttpResponse);
//
//        ACode:=ASuperObject.I['Code'];
//        ADesc:=ASuperObject.S['Desc'];
//        ADataJson:=ASuperObject.O['Data'];
//
//        Result:=True;
//
//      except
//        on E:Exception do
//        begin
//          ADesc:=E.Message;
//          uBaseLog.HandleException(E,'SimpleCallAPI Url:'+AInterfaceUrl+' API'+API);
//        end;
//      end;
//  end
//  else
//  begin
//      ADesc:=API+Trans('接口调用失败'+AHttpResponse);
//  end;
//end;
//
//function SimpleGet(API: String;
//                  AHttpControl:THttpControl;
//                  AInterfaceUrl:String;
//                  AUrlParamNames:TStringDynArray;
//                  AUrlParamValues:Array of Variant;
//                  AResponseStream: TStream): Boolean;
//var
//  I:Integer;
//  AStrValue:String;
//  AParamsStr:String;
//  ABefore:TDateTime;
//begin
//    ABefore:=Now;
////    uBaseLog.HandleException(nil,'SimplePost'+' '+'begin'+' '+FormatDateTime('HH:MM:SS',ABefore));
//
//    AParamsStr:='';
//    for I:=0 to Length(AUrlParamNames)-1 do
//    begin
//      AStrValue:=AUrlParamValues[I];
//      if AParamsStr<>'' then
//      begin
//        AParamsStr:=AParamsStr+'&'+AUrlParamNames[I]+'='+AStrValue;
//      end
//      else
//      begin
//        AParamsStr:=AUrlParamNames[I]+'='+AStrValue;
//      end;
//    end;
//
////    if Assigned(OnCallAPIEvent) then
////    begin
////      OnCallAPIEvent(AHttpControl,AInterfaceUrl+API+'?'+AParamsStr);
////    end;
//
//
//    Result:=AHttpControl.Get(
//        TIdURI.URLEncode(AInterfaceUrl+API+'?'+AParamsStr),
//        AResponseStream);
//
//
//    uBaseLog.OutputDebugString('SimpleGet'+' '+AInterfaceUrl+API+' '+'end'+' '+'耗时'+IntToStr(DateUtils.MilliSecondsBetween(ABefore,Now)));
//
//end;


//function GetPageStructureFromServer(
//            AOpenPlatformServer:String;
//            AProgramTemlateName:String;
//            AFunctionName:String;
//            APageType:String;
//            APageName:String):TPage;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataObject:ISuperObject;
//begin
//  Result:=nil;
////  if Not SimpleCallAPI(
////          'get_page_structure',
////          nil,
////          AOpenPlatformServer,
////          ['appid','user_fid','key',
////          'program_template_name',
////          'function_name',
////          'page_type',
////          'platform',
////          'page_name'
////          ],
////          [],
////          ACode,ADesc,ADataObject) then
////  begin
////    Exit;
////  end;
////
//end;


//function LoadDataJsonArrayToItems(
//          ADataJsonArray:ISuperArray;
//          ASkinItems:TSkinItems;
//          AFieldControlSettingList:TFieldControlSettingList):Boolean;
//var
//  I: Integer;
//  ASkinItem:TSkinItem;
//begin
//  Result:=False;
////  ASkinItems.BeginUpdate;
////  try
//
//      for I := 0 to ADataJsonArray.Length-1 do
//      begin
//        ASkinItem:=TSkinItem(ASkinItems.Add);
//        if Not LoadDataJsonToSkinItem(
//                               ADataJsonArray.O[I],
//                               ASkinItem,
//                               AFieldControlSettingList) then
//        begin
//          //加载数据失败
//          Exit;
//        end;
//      end;
//
//      Result:=True;
////  finally
////    ASkinItems.EndUpdate();
////  end;
//end;
//
//
//function LoadDataJsonToSkinItem(
//    ADataJson:ISuperObject;
//    ASkinItem:TSkinItem;
//    AFieldControlSettingList:TFieldControlSettingList):Boolean;
//var
//  I: Integer;
//begin
//  Result:=True;
//
//  //Json数据保存到DataJsonStr
//  ASkinItem.DataJsonStr:=ADataJson.AsJSON;
//
//  for I := 0 to AFieldControlSettingList.Count-1 do
//  begin
//    if not LoadDataJsonToSkinItemProp(
//        ADataJson,
//        ASkinItem,
//        AFieldControlSettingList[I]) then
//    begin
//      Exit;
//    end;
//  end;
//  Result:=True;
//end;
//
//function LoadDataJsonToSkinItemProp(
//    ADataJson:ISuperObject;
//    ASkinItem:TSkinItem;
//    AFieldControlSetting:TFieldControlSetting):Boolean;
//begin
//  Result:=True;
//
//  if AFieldControlSetting.field_name<>'' then
//  begin
//      if ADataJson.Contains(AFieldControlSetting.field_name) then
//      begin
//          //给Item的属性赋值
//          SetItemValueByItemDataType(
//              ASkinItem,
//              GetItemDataType(AFieldControlSetting.bind_listitem_data_type),
//              AFieldControlSetting.BindSubItemsIndex,
//              ADataJson.V[AFieldControlSetting.field_name]
//              );
//      end
//      else
//      begin
//          HandleException(nil,'LoadDataJsonToSkinItemProp ADataJson中不存在'+AFieldControlSetting.field_name);
//          Exit;
//      end;
//  end;
//
//  Result:=True;
//end;

//function SortFieldControlSettingByOrderNo_Compare(Item1, Item2: Pointer): Integer;
//var
//  Param1,Param2:TFieldControlSetting;
//begin
//  Param1:=TFieldControlSetting(Item1);
//  Param2:=TFieldControlSetting(Item2);
//
//  if Param1.orderno>Param2.orderno then
//  begin
//    Result:=1;
//  end
//  else if Param1.orderno<Param2.orderno then
//  begin
//    Result:=-1;
//  end
//  else
//  begin
//    Result:=0;
//  end;
//
//end;
//
//function SortFieldControlByOrderNo_Compare(Item1, Item2: Pointer): Integer;
//var
//  Param1,Param2:TControlLayoutItem;
//begin
//  Param1:=TControlLayoutItem(Item1);
//  Param2:=TControlLayoutItem(Item2);
//
//  if Param1.Setting.orderno>Param2.Setting.orderno then
//  begin
//    Result:=1;
//  end
//  else if Param1.Setting.orderno<Param2.Setting.orderno then
//  begin
//    Result:=-1;
//  end
//  else
//  begin
//    Result:=0;
//  end;
//end;


//{ TPage }
//
//constructor TPage.Create;
//begin
//end;
//
//destructor TPage.Destroy;
//begin
//  inherited;
//end;
//
//procedure TPage.Prepare;
//var
//  I:Integer;
//  ABindSubItemsIndex:Integer;
//begin
//  ABindSubItemsIndex:=-1;
//  for I := 0 to Self.FieldControlSettingList.Count-1 do
//  begin
//    if FieldControlSettingList[I].bind_listitem_data_type<>'' then
//    begin
//      if SameText(FieldControlSettingList[I].bind_listitem_data_type,'ItemSubItems') then
//      begin
//        Inc(ABindSubItemsIndex);
//        FieldControlSettingList[I].BindSubItemsIndex:=ABindSubItemsIndex;
//      end;
//    end;
//  end;
//end;
//
//function TPage.LoadFromJson(AJson: ISuperObject): Boolean;
//begin
//
//end;

//{ TFieldControlSettingList }
//
//constructor TFieldControlSettingList.Create;
//begin
//
//end;
//
//function TFieldControlSettingList.FindItemByFid(
//  AFid: Integer): TFieldControlSetting;
//var
//  I: Integer;
//begin
//  Result:=nil;
//  for I := 0 to Self.Count-1 do
//  begin
//    if Items[I].fid=AFid then
//    begin
//      Result:=Items[I];
//    end;
//  end;
//end;
//
//function TFieldControlSettingList.GetItem(Index: Integer): TFieldControlSetting;
//begin
//  Result:=TFieldControlSetting(Inherited Items[Index]);
//end;

{ TControlLayoutManager }

//function TControlLayoutManager.AlignControls(ALayoutParent: TControl;
//  APage: TPage): Boolean;
//var
//  I: Integer;
//  ASkinItem:ISkinItem;
//  AFieldControl:TControlLayoutItem;
//  AItemRect:TRectF;
//begin
//  Result:=False;
//
//
//  if APage.align_type=Const_PageAlignType_Auto then
//  begin
//
//      FListLayoutsManager.ControlWidth:=ALayoutParent.Width;
//      FListLayoutsManager.ControlHeight:=ALayoutParent.Height;
//      FListLayoutsManager.DoItemSizeChange(nil);
//
//
////      for I := 0 to Self.FListLayoutsManager.GetVisibleItemsCount-1 do
////      begin
////        ASkinItem:=Self.FListLayoutsManager.GetVisibleItem(I);
////        AFieldControl:=TControlLayoutItem(ASkinItem.GetObject);
////
////        if AFieldControl.Control<>nil then
////        begin
////            AItemRect:=ASkinItem.ItemRect;
////
////            //设置提示文本的区域
////            AFieldControl.AlignControl(AItemRect,APage);
////
////        end;
////
////      end;
//  end;
//
//  Result:=True;
//end;

//constructor TControlLayoutManager.Create(const AObjectOwnership: TObjectOwnership;
//  const AIsCreateObjectChangeManager: Boolean);
//begin
//  inherited;
//
//  FListLayoutsManager:=TSkinListViewLayoutsManager.Create(Self);
//
//end;

//function TControlLayoutManager.CreateFieldControls(
//  ALayoutParent: TControl;
//  APage: TPage): Boolean;
//var
//  I: Integer;
//  AControl:TControl;
//  AFieldControlSetting:TFieldControlSetting;
//  AFieldControl:TControlLayoutItem;
//begin
//  Result:=False;
//
//  LayoutParent:=ALayoutParent;
//  Page:=APage;
//
//
//
//
//  try
//
//    try
//
//          //先清除绑定
//          if ALayoutParent is TSkinItemDesignerPanel then
//          begin
//            TSkinItemDesignerPanel(ALayoutParent).Prop.Clear;
//          end;
//
//
//
//          //设置排列布局管理者
//          FListLayoutsManager.ViewType:=TListViewType.lvtIcon;
//          FListLayoutsManager.ItemCountPerLine:=APage.item_col_count;
//          FListLayoutsManager.StaticItemWidth:=APage.item_col_width;
//          FListLayoutsManager.StaticItemHeight:=APage.item_height;
//          //默认就设置成isctSeparate,避免用户使用上出现问题
//          FListLayoutsManager.StaticItemSizeCalcType:=isctSeparate;
//
//    //      FListLayoutsManager.OnItemPropChange:=DoItemPropChange;
//    //      FListLayoutsManager.OnItemSizeChange:=DoItemSizeChange;
//    //      FListLayoutsManager.OnItemVisibleChange:=DoItemVisibleChange;
//
//          FListLayoutsManager.ControlWidth:=ALayoutParent.Width;
//          FListLayoutsManager.ControlHeight:=ALayoutParent.Height;
//
//    //      FListLayoutsManager.OnSetSelectedItem:=Self.DoSetListLayoutsManagerSelectedItem;
//
//
//
//
//          //准备
//          APage.Prepare;
//
//
//          //不存在,则创建
//          for I := 0 to APage.FieldControlSettingList.Count-1 do
//          begin
//              AFieldControlSetting:=APage.FieldControlSettingList[I];
//
//              AFieldControl:=Self.FindItemBySettingFid(AFieldControlSetting.fid);
//              if (AFieldControl=nil) then
//              begin
//                AFieldControl:=TControlLayoutItem.Create(Self);
//                AFieldControl.Setting:=AFieldControlSetting;
//                Self.Add(AFieldControl);
//              end;
//          end;
//
//
//          //存在,则更新
//          for I := 0 to Self.Count-1 do
//          begin
//            if Not Items[I].Sync(ALayoutParent) then
//            begin
//              //更新失败
//              Exit;
//            end;
//          end;
//
//
//          //不存在,则删除
//          for I := Self.Count-1 downto 0 do
//          begin
//            if APage.FieldControlSettingList.IndexOf(
//                Self.Items[I].Setting
//                )=-1 then
//            begin
//              Self.Delete(I);
//            end;
//          end;
//
//
//          Self.Sort(SortFieldControlByOrderNo_Compare);
//
//
//
//          //设置绑定
//          if ALayoutParent is TSkinItemDesignerPanel then
//          begin
//            for I := 0 to Self.Count-1 do
//            begin
//              if Items[I].Setting.bind_listitem_data_type<>'' then
//              begin
//                //需要绑定
//                TSkinItemDesignerPanel(ALayoutParent).Prop.BindControl(
//                    Items[I].Setting.bind_listitem_data_type,
//                    Items[I].Setting.BindSubItemsIndex,
//                    Items[I].Control
//                    );
//              end;
//            end;
//          end;
//
//
//
//          Result:=True;
//
//    except
//      on E:Exception do
//      begin
//        uBaseLog.HandleException(E,'TControlLayoutManager.CreateFieldControls');
//      end;
//    end;
//  finally
//    Self.GetListLayoutsManager.DoItemVisibleChange(nil,False);
//    Self.GetListLayoutsManager.DoItemPropChange(nil);
//  end;
//
//
//  //排列位置
//  AlignControls(ALayoutParent,APage);
//
//
//end;

//
//destructor TControlLayoutManager.Destroy;
//begin
//  FreeAndNil(FListLayoutsManager);
//  inherited;
//end;
//
//procedure TControlLayoutManager.DoChange;
//begin
//  inherited;
//
//  if Not IsLoading
//    and (FSkinObjectChangeManager<>nil)
//    and not FSkinObjectChangeManager.IsDestroy then
//  begin
//    if (ictAdd in Self.FLastItemChangeTypes)
//      or (ictDel in Self.FLastItemChangeTypes) then
//    begin
//      if GetListLayoutsManager<>nil then
//      begin
//        Self.GetListLayoutsManager.DoItemVisibleChange(nil);
//      end;
//    end;
//  end;
//
//end;
//
//procedure TControlLayoutManager.EndUpdate(AIsForce: Boolean);
//begin
//
//  inherited EndUpdate(AIsForce);
//
//  //判断列表项是否改变过大小再调用
//  //万一有Item的Visible更改过了,也需要调用的
//  if GetListLayoutsManager<>nil then
//  begin
//    Self.GetListLayoutsManager.DoItemVisibleChange(nil,True);
//    Self.GetListLayoutsManager.DoItemPropChange(nil);
//  end;
//
//end;

//function TControlLayoutManager.FindItemBySettingFid(ASettingFid: Integer): TControlLayoutItem;
//var
//  I: Integer;
//begin
//  Result:=nil;
//  for I := 0 to Self.Count-1 do
//  begin
//    if Items[I].Setting.fid=ASettingFid then
//    begin
//      Result:=Items[I];
//      Break;
//    end;
//  end;
//end;

//function TControlLayoutManager.GetItem(Index: Integer): TControlLayoutItem;
//begin
//  Result:=TControlLayoutItem(Inherited Items[Index]);
//end;
//
//function TControlLayoutManager.GetListLayoutsManager: TSkinListLayoutsManager;
//begin
//  Result:=FListLayoutsManager;
//end;
//
//function TControlLayoutManager.GetObject: TObject;
//begin
//  Result:=Self;
//end;
//
//function TControlLayoutManager.GetSkinItem(const Index: Integer): ISkinItem;
//begin
//  Result:=Items[Index] as ISkinItem;
//end;
//
//function TControlLayoutManager.GetSkinObject(const Index: Integer): TObject;
//begin
//  Result:=Items[Index];
//end;
//
//function TControlLayoutManager.GetUpdateCount: Integer;
//begin
//  Result:=0;
//  if (Self.FSkinObjectChangeManager<>nil) then
//  begin
//    Result:=Self.FSkinObjectChangeManager.UpdateCount;
//  end;
//end;
//
//procedure TControlLayoutManager.SetListLayoutsManager(ALayoutsManager: TSkinListLayoutsManager);
//begin
//  FListLayoutsManager:=TSkinListViewLayoutsManager(ALayoutsManager);
//end;
//
//{ TControlLayoutItem }
//
//procedure TControlLayoutItem.AlignControl(AItemRect: TRectF;
//                                          APage:TLayoutSetting);
//begin
//  //加上边距
//  AItemRect.Left:=AItemRect.Left+APage.ControlMarginsLeft;
//  AItemRect.Top:=AItemRect.Top+APage.ControlMarginsTop;
//  AItemRect.Right:=AItemRect.Right-APage.ControlMarginsRight;
//  AItemRect.Bottom:=AItemRect.Bottom-APage.ControlMarginsBottom;
//
//  if Self.ControlMap.InputPanel<>nil then
//  begin
//      Self.ControlMap.InputPanel.SetBounds(
//        AItemRect.Left,
//        AItemRect.Top,
//        AItemRect.Width,
//        AItemRect.Height
//        );
//      if Self.ControlMap.HintLabel<>nil then
//      begin
//        Self.ControlMap.HintLabel.Align:=TAlignLayout.Left;
//        Self.ControlMap.HintLabel.Width:=APage.HintLabelWidth;
//      end;
//      if Self.ControlMap.Control<>nil then
//      begin
//        Self.ControlMap.Control.Align:=TAlignLayout.Client;
//      end;
//
//  end
//  else
//  begin
//
//      //设置提醒标签的位置
//      if Self.ControlMap.HintLabel<>nil then
//      begin
//          Self.ControlMap.HintLabel.SetBounds(
//            AItemRect.Left,
//            AItemRect.Top,
//            APage.HintLabelWidth,
//            AItemRect.Height
//            );
//          AItemRect.Left:=AItemRect.Left
//              +APage.HintLabelWidth;
//      end;
//
//
//      //设置控件的位置
//      if Self.ControlMap.Control<>nil then
//      begin
//        Self.ControlMap.Control.SetBounds(
//            AItemRect.Left,
//            AItemRect.Top,
//            AItemRect.Width,
//            AItemRect.Height
//            );
//      end;
//
//  end;
//end;
//
//procedure TControlLayoutItem.ClearItemRect;
//begin
//  FItemRect:=RectF(0,0,0,0);
//  FItemDrawRect:=RectF(0,0,0,0);
//end;
//
//constructor TControlLayoutItem.Create(AOwner: TControlLayoutManager);
//begin
//  SetSkinListIntf(AOwner);
//end;
//
//destructor TControlLayoutItem.Destroy;
//begin
//  inherited;
//end;
//
//function TControlLayoutItem.GetHeight: TControlSize;
//begin
//  Result:=Height;//ControlMap.Setting.height;
//end;
//
//function TControlLayoutItem.GetItemDrawRect: TRectF;
//begin
//  Result:=FItemDrawRect;
//end;
//
//function TControlLayoutItem.GetItemRect: TRectF;
//begin
//  Result:=FItemRect;
//end;
//
//function TControlLayoutItem.GetObject: TObject;
//begin
//  Result:=Self;
//end;
//
//function TControlLayoutItem.GetSelected: Boolean;
//begin
//  Result:=False;
//end;
//
//function TControlLayoutItem.GetVisible: Boolean;
//begin
//  Result:=(ControlMap.Setting.visible=1);
//end;
//
//function TControlLayoutItem.GetWidth: TControlSize;
//begin
//  Result:=ControlMap.Setting.width;
//end;
//
//procedure TControlLayoutItem.SetItemDrawRect(Value: TRectF);
//begin
//  FItemDrawRect:=Value;
//end;
//
//procedure TControlLayoutItem.SetItemRect(Value: TRectF);
//begin
//  FItemRect:=Value;
//end;
//
//procedure TControlLayoutItem.SetSkinListIntf(ASkinListIntf: ISkinList);
//begin
//  FSkinListIntf:=ASkinListIntf;
//end;

//function TControlLayoutItem.Sync(ALayoutParent:TControl): Boolean;
//begin
//  Result:=False;
//
////  Result:=ControlMap.Setting.SyncControl(Self,ALayoutParent);
//end;



//{ TFieldControlSetting }
//
//constructor TFieldControlSetting.Create;
//begin
//
//  //-1表示默认
//  height:=-1;
//  //-1表示默认
//  width:=-1;
//
//  visible:=1;
//
//end;
//
//destructor TFieldControlSetting.Destroy;
//begin
//
//  inherited;
//end;
//
//function TFieldControlSetting.SyncControl(
//  AFieldControl: TControlLayoutItem;
//  ALayoutParent:TControl): Boolean;
//var
////  ASkinControlIntf:ISkinControl;
//  AControlForPageFrameworkIntf:IControlForPageFramework;
//begin
//  Result:=False;
//  try
//      //控件类型变过了,要重新创建
//      if (AFieldControl.control_type<>Self.control_type) then
//      begin
//        if GlobalComponentClasses.FindItemByName(Self.control_type)<>nil then
//        begin
//            FreeAndNil(AFieldControl.Control);
//            AFieldControl.Control:=GlobalComponentClasses.FindItemByName(Self.control_type).Create(nil);
//            AFieldControl.Control.Parent:=ALayoutParent;
//
//            AFieldControl.control_type:=Self.control_type;
//
//
////            //设置素材
////            if AFieldControl.Control.GetInterface(IID_ISkinControl,ASkinControlIntf) then
////            begin
////              ASkinControlIntf.GetSkinComponentType;
////              ASkinControlIntf.GetCurrentUseMaterial;
////
////              //测试,设置为不透明
////              ASkinControlIntf.GetCurrentUseMaterial.DrawBackColorParam.IsFill:=True;
////              ASkinControlIntf.GetCurrentUseMaterial.DrawBackColorParam.FillColor.Color:=TAlphaColorRec.Red;
////              ASkinControlIntf.GetCurrentUseMaterial.IsTransparent:=False;
////
////            end;
//
//
//            //加载设置
//            if AFieldControl.Control.GetInterface(IID_IControlForPageFramework,AControlForPageFrameworkIntf) then
//            begin
//              AControlForPageFrameworkIntf.LoadFromFieldControlSetting(Self)
//            end;
//
//
//        end
//        else
//        begin
//            uBaseLog.HandleException(nil,'CreateFieldControls 找不到类型为'+Self.control_type+'的控件');
//            Exit;
//        end;
//      end;
//
//
//
//
//      if (Self.has_hint_label=1)
//        and (AFieldControl.HintLabel=nil) then
//      begin
//        AFieldControl.HintLabel:=TSkinLabel.Create(nil);
//        AFieldControl.HintLabel.Parent:=ALayoutParent;
//        //不可点击
//        AFieldControl.HintLabel.HitTest:=False;
//      end;
//
//      if (Self.has_hint_label=0)
//        and (AFieldControl.HintLabel<>nil) then
//      begin
//        FreeAndNil(AFieldControl.HintLabel);
//      end;
//
//      //提示文本的标签
//      if (Self.has_hint_label=1)
//        and (AFieldControl.HintLabel<>nil) then
//      begin
//        AFieldControl.HintLabel.Caption:=Self.hint_label_caption;
//      end;
//
//      //位置和尺寸
//      if (Self.is_custom_position=1) then
//      begin
//        AFieldControl.Control.SetBounds(left,top,width,height);
//      end;
//
//
//
//
//      AFieldControl.Control.Anchors:=GetAnchors(anchors);
//      AFieldControl.Control.Align:=GetAlign(align);
//      AFieldControl.Control.Visible:=(visible=1);
//      AFieldControl.Control.HitTest:=(hittest=1);
//      AFieldControl.Control.Enabled:=(enabled=1);
//
//
//
//      Result:=True;
//  except
//    on E:Exception do
//    begin
//      uBaseLog.HandleException(E,'TFieldControlSetting.SyncControl');
//    end;
//  end;
//end;

//{ TFieldControlDrawParamList }
//
//function TFieldControlDrawParamList.GetItem(Index: Integer): TFieldControlDrawParam;
//begin
//  Result:=TFieldControlDrawParam(Inherited Items[Index]);
//end;

{ TPage }

//constructor TPage.Create(AOwner: TComponent);
//begin
//  inherited;
//  ProgramTemplate:=TProgramTemplate.Create;
//  DataServer:=TDataServer.Create;
//  DataInterface:=TDataInterface.Create;
////  DataFunction:=TDataFunction.Create;
////  Page:=TPage.Create;
//
//
//  //列表页面的表格列列表
////  PageColumns:=TPageColumns.Create;
//  //页面的控件列表
//  MainLayoutControlList:=TPageLayoutControlList.Create;
//  //页面其他区域的控件
//  BottomToolbarLayoutControlList:=TPageLayoutControlList.Create;
//
//  //主控件排列设置
//  MainLayoutSetting:=TLayoutSetting.Create;
//  //底部工具栏的设置
//  BottomToolbarLayoutSetting:=TLayoutSetting.Create;
//
//end;
//
//destructor TPage.Destroy;
//begin
//  FreeAndNil(ProgramTemplate);
//  FreeAndNil(DataServer);
//  FreeAndNil(DataInterface);
////  FreeAndNil(DataFunction);
////  FreeAndNil(Page);
//
//
//  FreeAndNil(MainLayoutSetting);
//  FreeAndNil(BottomToolbarLayoutSetting);
//
//  //列表页面的表格列列表
////  FreeAndNil(PageColumns);
//  //页面的控件列表
//  FreeAndNil(MainLayoutControlList);
//  //页面其他区域的控件
//  FreeAndNil(BottomToolbarLayoutControlList);
//
//  inherited;
//end;
//
//{ TPageLayoutControlMapList }
//
//function TPageLayoutControlMapList.AlignControls: Boolean;
//var
//  I: Integer;
//  ASkinItem:ISkinItem;
//  AControlLayoutItem:TControlLayoutItem;
//  AItemRect:TRectF;
//begin
//  Result:=False;
//
//
//  if LayoutSetting.ControlAlignType=Const_PageAlignType_Auto then
//  begin
//
//      LayoutManager.BeginUpdate;
//      try
//        LayoutManager.FListLayoutsManager.ControlWidth:=Parent.Width;
//        LayoutManager.FListLayoutsManager.ControlHeight:=Parent.Height;
//        //每个控件的宽度
//    //    LayoutManager.FListLayoutsManager.ItemWidth:=LayoutSetting.ControlColWidth;
//        //每个控件的高度
//        LayoutManager.FListLayoutsManager.ItemHeight:=LayoutSetting.RowHeight;
//        //每行的间隔
//        LayoutManager.FListLayoutsManager.ItemSpace:=LayoutSetting.RowSpace;
//
//        LayoutManager.FListLayoutsManager.ViewType:=TListViewType.lvtIcon;
//        LayoutManager.FListLayoutsManager.ItemCountPerLine:=LayoutSetting.ControlColCount;
//        LayoutManager.FListLayoutsManager.IsItemCountFitControl:=True;
//
//      finally
//        LayoutManager.EndUpdate();
//      end;
//
//
//      LayoutManager.FListLayoutsManager.DoItemSizeChange(nil,True);
//
//
//      for I := 0 to LayoutManager.FListLayoutsManager.GetVisibleItemsCount-1 do
//      begin
//        ASkinItem:=LayoutManager.FListLayoutsManager.GetVisibleItem(I);
//        AControlLayoutItem:=TControlLayoutItem(ASkinItem.GetObject);
//
//        AItemRect:=ASkinItem.ItemRect;
//
//        //设置控件的位置和尺寸
//        AControlLayoutItem.AlignControl(AItemRect,LayoutSetting);
//      end;
//
//  end;
//
//  Result:=True;
//
//end;
//
//constructor TPageLayoutControlMapList.Create(
//  const AObjectOwnership: TObjectOwnership;
//  const AIsCreateObjectChangeManager: Boolean);
//begin
//  inherited Create(AObjectOwnership,AIsCreateObjectChangeManager);
//
//  //布局管理
//  LayoutManager:=TControlLayoutManager.Create;
//
//end;
//
//destructor TPageLayoutControlMapList.Destroy;
//begin
//  FreeAndNil(LayoutManager);
//
//  inherited;
//end;
//
//procedure TPageLayoutControlMapList.DoFieldControlClick(Sender: TObject);
//var
//  I: Integer;
//begin
//  for I := 0 to Self.Count-1 do
//  begin
//    if Items[I].Control=Sender then
//    begin
//      Self.PageInstance.DoPageLayoutControlClick(
//        Sender,Items[I]);
//      Break;
//    end;
//  end;
//end;
//
//function TPageLayoutControlMapList.GetItem(Index: Integer): TPageLayoutControlMap;
//begin
//  Result:=TPageLayoutControlMap(Inherited Items[Index]);
//end;
//
//{ TPageLayoutControlList }
//
//constructor TPageLayoutControlList.Create;
//begin
//  Inherited Create(TFieldControlSetting);
//
//end;
//
//function TPageLayoutControlList.GetItem(Index: Integer): TFieldControlSetting;
//begin
//  Result:=TFieldControlSetting(Inherited Items[Index]);
//end;
//
//{ TPageInstance }
//
//function TPageInstance.AlignControls: Boolean;
//begin
//  //主控件映射列表
//  MainControlMapList.AlignControls;
//  //底部栏控件映射列表
//  BottomToolbarControlMapList.AlignControls;
//end;
//
//constructor TPageInstance.Create(AOwner:TComponent);
//begin
//  Inherited;
//
//  //控件映射列表
//  MainControlMapList:=TPageLayoutControlMapList.Create();
//  MainControlMapList.PageInstance:=Self;
//
//  //底部栏控件映射列表
//  BottomToolbarControlMapList:=TPageLayoutControlMapList.Create;
//  BottomToolbarControlMapList.PageInstance:=Self;
//end;
//
//function TPageInstance.CreateControls(AParent: TControl;AFilterPagePart:String): Boolean;
//begin
//
//  if SameText(AFilterPagePart,Const_PagePart_Main) then
//  begin
//      //创建主控件列表
//      Result:=DoCreateControls(
//                AParent,
//                Self.PageStructure.MainLayoutSetting,
//                Self.PageStructure.MainLayoutControlList,
//                AFilterPagePart,
//                Self.MainControlMapList);
//      MainControlMapList.AlignControls;
//  end
//  else if SameText(AFilterPagePart,Const_PagePart_BottomToolbar) then
//  begin
//      //创建底部工具栏列表
//      Result:=DoCreateControls(
//                AParent,
//                Self.PageStructure.BottomToolbarLayoutSetting,
//                Self.PageStructure.BottomToolbarLayoutControlList,
//                AFilterPagePart,
//                Self.BottomToolbarControlMapList);
//      BottomToolbarControlMapList.AlignControls;
//  end;
//
//
//
//end;
//
//destructor TPageInstance.Destroy;
//begin
////  FreeAndNil(SaveRecordMessageBox);
//  FreeAndNil(MainControlMapList);
//  FreeAndNil(BottomToolbarControlMapList);
//  inherited;
//end;
//
//procedure TPageInstance.DoPageLayoutControlClick(Sender: TObject;APageLayoutControlMap: TPageLayoutControlMap);
//var
//  AIsProcessed:Boolean;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//begin
//
//  AIsProcessed:=False;
//
//  if Assigned(Self.FOnControlClick) then
//  begin
//    FOnControlClick(Sender,Self,APageLayoutControlMap,AIsProcessed);
//  end;
//
//
//  //事件没有被用户处理过,那么处理预定义的事件
//  if Not AIsProcessed then
//  begin
//      if APageLayoutControlMap.Setting.Action<>'' then
//      begin
//          //处理自定义的事件
//
//          if SameText(APageLayoutControlMap.Setting.Action,Const_PageAction_SaveRecord) then
//          begin
//              //保存
//              DoSaveRecordAction;
//          end
//          else if SameText(APageLayoutControlMap.Setting.Action,Const_PageAction_CancelSaveRecord) then
//          begin
//              //取消保存
//              Self.DoReturnPageAction;
//          end
//          else
//          begin
//              raise Exception.Create('TPageInstance.DoFieldControlClick 不支持此动作'+APageLayoutControlMap.Setting.Action);
//          end;
//
//      end;
//  end;
//end;
//
//function TPageInstance.ffDoPostToTableCommonRestAddRecord(
//  var ACode: Integer;
//  var ADesc: String;
//  var ADataJson: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  //在外面初始好了,不用再在里面初始了
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//  if not SameText(Self.PageStructure.DataInterface.IntfType,
//                  Const_IntfType_TableCommonRest) then
//  begin
//    ADesc:=Trans('不是TableCommonRest的接口类型');
//    Exit;
//  end;
//
//
//  if not SimpleCallAPI('add_record',
//                        nil,
//                        Self.PageStructure.DataServer.ServerUrl+'tablecommonrest/',
//                        ['appid',
//                        'user_fid',
//                        'key',
//                        'rest_name',
//                        'record_data_json'],
//                        [AppID,
//                        UserFID,
//                        Key,
//                        Self.PageStructure.DataInterface.TableCommonRestName,
//                        Self.GetPostDataJson.AsJSON],
//                        ACode,
//                        ADesc,
//                        ADataJson) then
//  begin
//    Exit;
//  end;
//
//  Result:=True;
//
//end;
//
//procedure TPageInstance.DoReturnPageAction;
//begin
//  if Owner is TFrame then
//  begin
//    DoHideFrame(TFrame(Owner));
//    //返回上一页
//    DoReturnFrame(TFrame(Owner));
//  end;
//end;
//
////procedure TPageInstance.DoSaveRecordSuccMessageBoxModalResult(AMessageBoxFrame: TFrame);
////begin
////
////end;
//
//procedure TPageInstance.DoSaveRecordTimerTaskExecute(ATimerTask: TObject);
//var
//  AIsSucc:Boolean;
//
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
//begin
//  //出错
//
//  //提交数据到服务器
//  AIsSucc:=Self.PostToServer(ACode,ADesc,ADataJson);
//
//
//  TThread.Synchronize(nil,procedure
//  begin
//      try
//          if AIsSucc then
//          begin
//              //将数据传递给UI
////              if SaveRecordMessageBox=nil then
////              begin
////                SaveRecordMessageBox:=TSkinMessageBox.Create(nil);
////              end;
////              SaveRecordMessageBox.Msg:=Trans('保存成功');
////              SaveRecordMessageBox.ButtonCaptions:=Trans('确定');
//
//              //ShowMessageBoxFrame(nil,Trans('保存成功'),'',);
//              ShowHintFrame(nil,Trans('保存成功'));
//              DoReturnPageAction;
//          end
//          else
//          begin
//              //网络异常或接口调用失败
//              ShowMessageBoxFrame(nil,ADesc,'');
//          end;
//      finally
//        HideWaitingFrame;
//      end;
//
//  end);
//end;

//function TPageInstance.GetPostDataJson(APageDataDir:String): ISuperObject;
//var
//  I: Integer;
//begin
//  Result:=TSuperObject.Create();
//  for I := 0 to Self.MainControlMapList.Count-1 do
//  begin
//    Result.V[MainControlMapList[I].Setting.FieldName]
//      :=MainControlMapList[I].PageFrameworkControlIntf.GetPostValue;
//  end;
//end;

//function TPageInstance.PostToServer(var ACode: Integer; var ADesc: String;
//  var ADataJson: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  //在外面初始好了,不用再在里面初始了
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//  if SameText(Self.PageStructure.DataInterface.IntfType,
//                  Const_IntfType_TableCommonRest) then
//  begin
//    Result:=Self.DoPostToTableCommonRestAddRecord(
//                    ACode,
//                    ADesc,
//                    ADataJson);
//  end
//  else
//  begin
//    ADesc:='不支持该接口类型';
//  end;
//
//end;
//
//procedure TPageInstance.DoSaveRecordAction;
//begin
//  GlobalShowWaiting(nil,'保存中...');
//  //启动线程
//  GetGlobalTimerThread.RunTempTask(
//      DoSaveRecordTimerTaskExecute,
//      nil
//      );
//end;
//
//
//
//{ TPageLayoutControlMap }
//
//constructor TPageLayoutControlMap.Create;
//begin
//
//end;
//
//destructor TPageLayoutControlMap.Destroy;
//begin
//  if HintLabel<>nil then
//  begin
//    HintLabel.Parent:=nil;
//    FreeAndNil(HintLabel);
//  end;
//  if Control<>nil then
//  begin
//    Control.Parent:=nil;
//    FreeAndNil(Control);
//  end;
//
//  inherited;
//end;
//
//{ TFieldControlSetting }
//
//constructor TFieldControlSetting.Create(Collection: TCollection);
//begin
//  inherited Create(Collection);
//
//  //-1表示默认
//  height:=-1;
//  //-1表示默认
//  width:=-1;
//
//  visible:=1;
//
//end;
//
//destructor TFieldControlSetting.Destroy;
//begin
//
//  inherited;
//end;
//
//{ TPageList }
//
//function TPageList.GetItem(Index: Integer): TPage;
//begin
//  Result:=TPage(Inherited Items[Index]);
//end;



//{ TListDataController }
//
//
//constructor TListDataController.Create(AOwner: TComponent);
//begin
//
//  FieldControlSettingList:=TFieldControlSettingList.Create();
//
//  tteGetData:=TTimerTaskEvent.Create(nil);
//  tteGetData.OnBegin:=tteGetDataBegin;
//  tteGetData.OnExecute:=tteGetDataExecute;
//  tteGetData.OnExecuteEnd:=tteGetDataExecuteEnd;
//end;
//
//destructor TListDataController.Destroy;
//begin
//  FreeAndNil(tteGetData);
//  FreeAndNil(FieldControlSettingList);
//
//  inherited;
//end;
//
//procedure TListDataController.GetData(
//  AParentControl:TFmxObject;
//  AListControl: TSkinVirtualList;
//  AOnGetDataEvent: TTimerTaskNotify;
//  AOnOnLoadDataToControlsEnd:TNotifyEvent;
//  ADataJsonArrayKey,
//  AItemStyle: String);
//begin
//  ParentControl:=AParentControl;
//
//  ListControl:=AListControl;
//
//  //数据列表在DataJson中的哪个Key
//  DataJsonArrayKey:=ADataJsonArrayKey;
//  //获取数据的方法
//  OnGetListData:=AOnGetDataEvent;
//
//  OnLoadDataToControlsEnd:=AOnOnLoadDataToControlsEnd;
//
//  //启动获取数据的线程
//  Self.tteGetData.Run;
//
//end;
//
//procedure TListDataController.tteGetDataBegin(ATimerTask: TTimerTask);
//begin
//  GlobalShowWaiting(ParentControl,'加载中...');
//end;
//
//procedure TListDataController.tteGetDataExecute(ATimerTask: TTimerTask);
//begin
//  if Assigned(OnGetListData) then
//  begin
//    OnGetListData(ATimerTask);
//  end;
//end;
//
//procedure TListDataController.tteGetDataExecuteEnd(ATimerTask: TTimerTask);
//var
//  ASuperObject:ISuperObject;
//begin
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//
//        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//        if (ASuperObject.I['Code']=200) then
//        begin
//            if ASuperObject.Contains('Data')
//              and ASuperObject.O['Data'].Contains(DataJsonArrayKey) then
//            begin
//                Self.ListControl.Prop.Items.BeginUpdate;
//                try
//                  LoadDataJsonArrayToItems(
//                      ASuperObject.O['Data'].A[DataJsonArrayKey],
//                      Self.ListControl.Prop.Items,
//                      Self.FieldControlSettingList
//                      );
//                finally
//                  Self.ListControl.Prop.Items.EndUpdate;
//                end;
//
//                //设置弹出框的高度
//                if Assigned(Self.OnLoadDataToControlsEnd) then
//                begin
//                  OnLoadDataToControlsEnd(Self);
//                end;
//                //FrameResize(nil);
//            end
//            else
//            begin
//                ShowMessageBoxFrame(ParentControl,'返回的数据格式不匹配!','');//,'',TMsgDlgType.mtInformation,['确定'],nil);
//            end;
//        end
//        else
//        begin
//            //获取列表失败
//            ShowMessageBoxFrame(ParentControl,ASuperObject.S['Desc'],'');//,'',TMsgDlgType.mtInformation,['确定'],nil);
//        end;
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(ParentControl,'网络异常,请检查您的网络连接!','');//,TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    HideWaitingFrame;
//  end;
//
//end;
//
//
//



//{ TListBoxDataController }
//
//
//constructor TListBoxDataController.Create(AOwner: TComponent);
//begin
//  Inherited Create(AOwner);
//
////  FieldControlSettingList:=TFieldControlSettingList.Create();
//
//  FDefaultItemDataBinding:=TSkinItemDataBinding.Create(nil);
//
//
//
////  tteGetData:=TTimerTaskEvent.Create(nil);
////  tteGetData.OnBegin:=tteGetDataBegin;
////  tteGetData.OnExecute:=tteGetDataExecute;
////  tteGetData.OnExecuteEnd:=tteGetDataExecuteEnd;
//end;
//
//destructor TListBoxDataController.Destroy;
//begin
////  FreeAndNil(tteGetData);
////  FreeAndNil(FieldControlSettingList);
//  FreeAndNil(FDefaultItemDataBinding);
//
//  inherited;
//end;
//
//procedure TListBoxDataController.ShowList(
////  AParentControl:TFmxObject;
//  AListControl: TSkinVirtualList//;
////  AOnGetDataEvent: TGetListDataEvent;
////  AOnOnLoadDataToControlsEnd:TNotifyEvent;
////  ADataJsonArrayKey,
////  AItemStyle: String
//  );
//begin
////  ParentControl:=AParentControl;
//
//  ListControl:=AListControl;
//
//
//  //设置列表项的风格
//  ListControl.Prop.DefaultItemStyle:=Self.DefaultItemStyle;
//
//
////  //数据列表在DataJson中的哪个Key
////  DataJsonArrayKey:=ADataJsonArrayKey;
////  //获取数据的方法
////  OnGetListData:=AOnGetDataEvent;
////
////  OnLoadDataToControlsEnd:=AOnOnLoadDataToControlsEnd;
//
//  //启动获取数据的线程
//  GetGlobalTimerThread.RunTempTask(
//      Self.tteGetDataExecute,
//      Self.tteGetDataExecuteEnd
//      );
//  //Self.tteGetData.Run;
//
//end;
//
////procedure TListBoxDataController.tteGetDataBegin(ATimerTask: TTimerTask);
////begin
////  GlobalShowWaiting(ParentControl,'加载中...');
////end;
//
//procedure TListBoxDataController.tteGetDataExecute(ATimerTask: TObject);
//var
//  AListData:TListData;
//  AIsSucc:Boolean;
//begin
//  TThread.Synchronize(nil,procedure
//  begin
//    GlobalShowWaiting(nil,'加载中...');
//  end);
//
//  AIsSucc:=False;
//  TTimerTask(ATimerTask).TaskTag:=TASK_FAIL;
//  TTimerTask(ATimerTask).TaskDesc:='网络异常,请检查您的网络连接!';
//
//  if Assigned(OnGetListData) then
//  begin
//
//      try
//        AListData:=TListData.Create;
//        TTimerTask(ATimerTask).TaskObject:=AListData;
//
//        OnGetListData(AListData,AIsSucc);
//
//        TTimerTask(ATimerTask).TaskDesc:=AListData.Desc;
//        if AIsSucc then
//        begin
//          //调用成功
//          TTimerTask(ATimerTask).TaskTag:=TASK_SUCC;
//        end;
//      except
//        on E:Exception do
//        begin
//          TTimerTask(ATimerTask).TaskDesc:=E.Message;
//          uBaseLog.HandleException(E,'TListBoxDataController.tteGetDataExecute');
//        end;
//      end;
//
//  end;
//end;
//
//procedure TListBoxDataController.tteGetDataExecuteEnd(ATimerTask: TObject);
////var
////  ASuperObject:ISuperObject;
//var
//  AListData:TListData;
//begin
//  AListData:=TListData(TTimerTask(ATimerTask).TaskObject);
//  try
//
//    if TTimerTask(ATimerTask).TaskTag=TASK_SUCC then
//    begin
//        //调用成功
//        case AListData.DataType of
//          ldtJson:
//          begin
//
//    //        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//    //        if (ASuperObject.I['Code']=200) then
//    //        begin
//                if (AListData.DataJson<>nil)
//                  and AListData.DataJson.Contains(DataJsonArrayKey) then
//                begin
//                    Self.ListControl.Prop.Items.BeginUpdate;
//                    try
//                      LoadDataJsonArrayToItems(
//                          AListData.DataJson.A[DataJsonArrayKey],
//                          Self.ListControl.Prop.Items,
//                          Self.FDefaultItemDataBinding.FieldControlSettingList
//                          );
//                    finally
//                      Self.ListControl.Prop.Items.EndUpdate;
//                    end;
//
//                    //设置弹出框的高度
//                    if Assigned(Self.OnLoadDataToControlsEnd) then
//                    begin
//                      OnLoadDataToControlsEnd(Self);
//                    end;
//                    //FrameResize(nil);
//                end
//                else
//                begin
//                    ShowMessageBoxFrame(nil,'返回的数据格式不匹配!','');//,'',TMsgDlgType.mtInformation,['确定'],nil);
//                end;
//    //        end
//    //        else
//    //        begin
//    //            //获取列表失败
//    //            ShowMessageBoxFrame(nil,ASuperObject.S['Desc'],'');//,'',TMsgDlgType.mtInformation,['确定'],nil);
//    //        end;
//
//          end
//          else
//          begin
//            ShowMessageBoxFrame(nil,'请指定数据格式类型AListData.DataType','');
//          end;
//        end;
//
//
//    end
//    else //if TTimerTask(ATimerTask).TaskTag=TASK_FAIL then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(nil,TTimerTask(ATimerTask).TaskDesc,'');//,TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    FreeAndNil(AListData);
//    HideWaitingFrame;
//  end;
//
//end;
//
//
//
//
//{ TSkinItemDataBinding }
//
//constructor TSkinItemDataBinding.Create(AOwner: TComponent);
//begin
//  inherited;
//  FieldControlSettingList:=TPageLayoutControlList.Create();
//
//  FItemCaptionFieldControl:=TFieldControlSetting(FieldControlSettingList.Add);
//  FItemCaptionFieldControl.bind_listitem_data_type:='ItemCaption';
//  FItemIconFieldControl:=TFieldControlSetting(FieldControlSettingList.Add);
//  FItemIconFieldControl.bind_listitem_data_type:='ItemIcon';
//  FItemPicFieldControl:=TFieldControlSetting(FieldControlSettingList.Add);
//  FItemPicFieldControl.bind_listitem_data_type:='ItemPic';
//  FItemSelectedFieldControl:=TFieldControlSetting(FieldControlSettingList.Add);
//  FItemSelectedFieldControl.bind_listitem_data_type:='ItemSelected';
//  FItemCheckedFieldControl:=TFieldControlSetting(FieldControlSettingList.Add);
//  FItemCheckedFieldControl.bind_listitem_data_type:='ItemChecked';
//  FItemExpanededFieldControl:=TFieldControlSetting(FieldControlSettingList.Add);
//  FItemExpanededFieldControl.bind_listitem_data_type:='ItemExpaned';
//
//  FItemDetailFieldControl:=TFieldControlSetting(FieldControlSettingList.Add);
//  FItemDetailFieldControl.bind_listitem_data_type:='ItemDetail';
//  FItemDetail1FieldControl:=TFieldControlSetting(FieldControlSettingList.Add);
//  FItemDetail1FieldControl.bind_listitem_data_type:='ItemDetail1';
//  FItemDetail2FieldControl:=TFieldControlSetting(FieldControlSettingList.Add);
//  FItemDetail2FieldControl.bind_listitem_data_type:='ItemDetail2';
//  FItemDetail3FieldControl:=TFieldControlSetting(FieldControlSettingList.Add);
//  FItemDetail3FieldControl.bind_listitem_data_type:='ItemDetail3';
//  FItemDetail4FieldControl:=TFieldControlSetting(FieldControlSettingList.Add);
//  FItemDetail4FieldControl.bind_listitem_data_type:='ItemDetail4';
//  FItemDetail5FieldControl:=TFieldControlSetting(FieldControlSettingList.Add);
//  FItemDetail5FieldControl.bind_listitem_data_type:='ItemDetail5';
//  FItemDetail6FieldControl:=TFieldControlSetting(FieldControlSettingList.Add);
//  FItemDetail6FieldControl.bind_listitem_data_type:='ItemDetail6';
//
//
//end;
//
//destructor TSkinItemDataBinding.Destroy;
//begin
//  FreeAndNil(FieldControlSettingList);
//  inherited;
//end;
//
//function TSkinItemDataBinding.GetItemCaptionField: String;
//begin
//  Result:=FItemCaptionFieldControl.FieldName;
//end;
//
//function TSkinItemDataBinding.GetItemCheckedField: String;
//begin
//  Result:=FItemCheckedFieldControl.FieldName;
//end;
//
//function TSkinItemDataBinding.GetItemDetail1Field: String;
//begin
//  Result:=FItemDetail1FieldControl.FieldName;
//end;
//
//function TSkinItemDataBinding.GetItemDetail2Field: String;
//begin
//  Result:=FItemDetail2FieldControl.FieldName;
//end;
//
//function TSkinItemDataBinding.GetItemDetail3Field: String;
//begin
//  Result:=FItemDetail3FieldControl.FieldName;
//end;
//
//function TSkinItemDataBinding.GetItemDetail4Field: String;
//begin
//  Result:=FItemDetail4FieldControl.FieldName;
//end;
//
//function TSkinItemDataBinding.GetItemDetail5Field: String;
//begin
//  Result:=FItemDetail5FieldControl.FieldName;
//end;
//
//function TSkinItemDataBinding.GetItemDetail6Field: String;
//begin
//  Result:=FItemDetail6FieldControl.FieldName;
//end;
//
//function TSkinItemDataBinding.GetItemDetailField: String;
//begin
//  Result:=FItemDetailFieldControl.FieldName;
//end;
//
//function TSkinItemDataBinding.GetItemExpanededField: String;
//begin
//  Result:=FItemExpanededFieldControl.FieldName;
//end;
//
//function TSkinItemDataBinding.GetItemIconField: String;
//begin
//  Result:=FItemIconFieldControl.FieldName;
//end;
//
//function TSkinItemDataBinding.GetItemPicField: String;
//begin
//  Result:=FItemPicFieldControl.FieldName;
//end;
//
//function TSkinItemDataBinding.GetItemSelectedField: String;
//begin
//  Result:=FItemSelectedFieldControl.FieldName;
//end;
//
//procedure TSkinItemDataBinding.SetItemCaptionField(const Value: String);
//begin
//  FItemCaptionFieldControl.FieldName:=Value;
//end;
//
//procedure TSkinItemDataBinding.SetItemCheckedField(const Value: String);
//begin
//  FItemCheckedFieldControl.FieldName:=Value;
//end;
//
//procedure TSkinItemDataBinding.SetItemDetail1Field(const Value: String);
//begin
//  FItemDetail1FieldControl.FieldName:=Value;
//end;
//
//procedure TSkinItemDataBinding.SetItemDetail2Field(const Value: String);
//begin
//  FItemDetail2FieldControl.FieldName:=Value;
//end;
//
//procedure TSkinItemDataBinding.SetItemDetail3Field(const Value: String);
//begin
//  FItemDetail3FieldControl.FieldName:=Value;
//end;
//
//procedure TSkinItemDataBinding.SetItemDetail4Field(const Value: String);
//begin
//  FItemDetail4FieldControl.FieldName:=Value;
//end;
//
//procedure TSkinItemDataBinding.SetItemDetail5Field(const Value: String);
//begin
//  FItemDetail5FieldControl.FieldName:=Value;
//end;
//
//procedure TSkinItemDataBinding.SetItemDetail6Field(const Value: String);
//begin
//  FItemDetail6FieldControl.FieldName:=Value;
//end;
//
//procedure TSkinItemDataBinding.SetItemDetailField(const Value: String);
//begin
//  FItemDetailFieldControl.FieldName:=Value;
//end;
//
//procedure TSkinItemDataBinding.SetItemExpanededField(const Value: String);
//begin
//  FItemExpanededFieldControl.FieldName:=Value;
//end;
//
//procedure TSkinItemDataBinding.SetItemIconField(const Value: String);
//begin
//  FItemIconFieldControl.FieldName:=Value;
//end;
//
//procedure TSkinItemDataBinding.SetItemPicField(const Value: String);
//begin
//  FItemPicFieldControl.FieldName:=Value;
//end;
//
//procedure TSkinItemDataBinding.SetItemSelectedField(const Value: String);
//begin
//  FItemSelectedFieldControl.FieldName:=Value;
//end;
//
//
//initialization
//  GolobalPageStructureList:=TPageList.Create(ooReference);
//
//finalization
//  FreeAndNil(GolobalPageStructureList);
//
//{ TFieldControlSetting }
//
//constructor TFieldControlSetting.Create(Collection: TCollection);
//begin
//  inherited Create(Collection);
//
//  //-1表示默认
//  height:=-1;
//  //-1表示默认
//  width:=-1;
//
//  visible:=1;
//
//end;
//
//destructor TFieldControlSetting.Destroy;
//begin
//
//  inherited;
//end;









//function ShowEditPageFrame(AEditPageStructure:TPage):Boolean;
//begin
//
//end;
//
//function ShowListPageFrame(AListPageStructure:TPage):Boolean;
//begin
//
//end;
//
//function ShowViewPageFrame(AViewPageStructure:TPage):Boolean;
//begin
//
//end;

function DoCreateControl(
                          AOwner:TComponent;
                          AParent: TParentControl;
                          AFieldControlSetting:TFieldControlSetting;
                          AControlMapList: TFieldControlSettingMapList;
                          //保存图片的根相对目录
                          APageDataDir:String;
                          AIsDesignTime:Boolean;
                          AOnPageFrameCustomInitFieldControl:TPageFrameCustomInitFieldControlEvent;
                          var AControlMap:TFieldControlSettingMap;
                          var AError:String;
                          AIsControlTypeMustExists:Boolean
                          ): Boolean;
var
  I: Integer;
  AControl:TControl;
  AControlParent:TParentControl;
  AComponentClass:TComponentClass;
//  AFieldControlSetting:TFieldControlSetting;
//  ALayoutItem:TControlLayoutItem;
begin
  Result:=False;

                //根据控件类型来创建控件
                //判断该控件类型是否支持
                AComponentClass:=GlobalFrameworkComponentTypeClasses.FindItemByName(AFieldControlSetting.control_type);
                if AComponentClass=nil then
                begin
                  AError:='DoCreateControls 不支持'+AFieldControlSetting.control_type+'控件';
                  uBaseLog.HandleException(nil,'DoCreateControls '+AError);

                  if not AIsControlTypeMustExists then
                  begin
                    Result:=True;
                  end;

                  Exit;
//                  Continue;
                end;


                //在设计器中,隐藏的也要添加进去
    //            if AFieldControlSetting.visible=0 then Continue;



                AControlMap:=TFieldControlSettingMap.Create(AControlMapList);
                AControlMap.Setting:=AFieldControlSetting;


                AControlParent:=AParent;

                if AFieldControlSetting.parent_control_fid<>0 then
                begin
                  AControlParent:=TParentControl(AControlMapList.FindControlByFid(AFieldControlSetting.parent_control_fid));
                end
                else if AFieldControlSetting.parent_control_name<>'' then
                begin
                  AControlParent:=TParentControl(AControlMapList.FindControlByName(AFieldControlSetting.parent_control_name));
                end;



                //创建控件
                AControlMap.Component:=AComponentClass.Create(AOwner);
                if AControlMap.Component is TControl then
                begin
                    //是控件
                    AControl:=TControl(AControlMap.Component);

    //                AControlMap.Control:=TControl(AControlMap.Component);

                    {$IFDEF FMX}
                    //为了不上子控件显示到父控件外面
                    AControl.ClipChildren:=True;
                    {$ENDIF FMX}


                    //创建输入框的提示控件,其实在编辑页面和查看页面基本都需要一个这样的页面
                    if AFieldControlSetting.has_caption_label=1 then
                    begin

                        //编辑页面需要加入一个底部的Panel
        //                if (ALayoutSetting<>nil)
        ////                  and (APage.PageType=Const_PageType_EditPage)
        //                  then
        //                begin
                          AControlMap.InputPanel:=TBaseSkinPanel.Create(nil);
                          AControlMap.InputPanel.Parent:=AParent;
                          AControlParent:=TParentControl(AControlMap.InputPanel);


                          {$IFDEF FMX}
                          //加入间隔,为了能将边框显示全
                          AControlMap.InputPanel.Padding.Rect:=RectF(0,1,0,1);
                          {$ENDIF FMX}

                          AControlParent:=TParentControl(AControlMap.InputPanel);
                          TBaseSkinPanel(AControlMap.InputPanel).Caption:=AFieldControlSetting.field_caption;
                          TBaseSkinPanel(AControlMap.InputPanel).SkinControlType;
//                          TBaseSkinPanel(AControlMap.InputPanel).SelfOwnMaterial;
                          TBaseSkinPanel(AControlMap.InputPanel).MaterialName:=Const_ControlStyle_EditPageInputPanelDefault;
                          TBaseSkinPanel(AControlMap.InputPanel).MaterialUseKind:=TMaterialUseKind.mukRefByStyleName;
        //                end;



        //                //创建提示控件
        //                AControlMap.HintLabel:=TSkinLabel.Create(nil);
        //                AControlMap.HintLabel.Parent:=AControlParent;
        //                //设置标题
        //                TSkinLabel(AControlMap.HintLabel).SkinControlType;
        //                TSkinLabel(AControlMap.HintLabel).SelfOwnMaterial;
        //                TSkinLabel(AControlMap.HintLabel).Caption:=AFieldControlSetting.field_caption;
        //                //设置素材
        //                TSkinLabel(AControlMap.HintLabel).MaterialUseKind:=TMaterialUseKind.mukRefByStyleName;
        //                TSkinLabel(AControlMap.HintLabel).MaterialName:=Const_ControlStyle_EditPageHintLabelDefult;






//                      if AControl<>nil then
//                      begin
                          //先设置下默认值
                          TControl(AControl).Margins.Left:=100;
                          {$IFDEF FMX}
                          TControl(AControl).Align:=TAlignLayout.Client;
                          {$ENDIF}
                          {$IFDEF VCL}
                          TControl(AControl).AlignWithMargins:=True;
                          TControl(AControl).Align:=TAlignLayout.alClient;
                          {$ENDIF}
//                      end;



                    end;






                    AControl.Parent:=AControlParent;


                    {$IFDEF FMX}
                    //是否设计时
                    AControl.SetDesign(AIsDesignTime);
                    {$ENDIF FMX}

                    //点击事件,改在AOnPageFrameCustomInitFieldControl中设置
        //            AControlMap.Control.OnClick:=AOnControlClick;






                end
                else if AControlMap.Component is TSkinRealSkinItemComponent then
                begin
                  if AControlParent<>nil then
                  begin
                    TSkinVirtualList(AControlParent).Prop.Items.Add(TSkinRealSkinItemComponent(AControlMap.Component).FSkinItem);
                  end;
                end
                else
                begin
                    //是组件
                    //设置组件的位置
    //                SetComponentLeft(AControlMap.Component,);
    //                SetComponentTop(AControlMap.Component,);


                end;

                AControlMapList.Add(AControlMap);



                //设置控件宽、高、显示等
                if not LoadComponentFromFieldControlSetting(AControlMap,
                                                            AControlMap.Component,
                                                            AFieldControlSetting,
                                                            APageDataDir,
                                                            AIsDesignTime,
                                                            AError) then
                begin
                  Exit;
                end;





                //自定义的初始控件的属性和事件
                if Assigned(AOnPageFrameCustomInitFieldControl) then
                begin
                  AOnPageFrameCustomInitFieldControl(AControlMap.Component,AFieldControlSetting);
                end;

                Result:=True;

end;

function DoCreateControls(
                          AOwner:TComponent;
                          AParent: TParentControl;
                          ALayoutSetting:TLayoutSetting;
                          AFieldControlSettingList: TFieldControlSettingList;
                          AFilterPagePart:String;
                          //保存图片的根相对目录
                          APageDataDir:String;
                          AIsDesignTime:Boolean;
                          AOnPageFrameCustomInitFieldControl:TPageFrameCustomInitFieldControlEvent;
                          var AControlMapList:TFieldControlSettingMapList;
                          var AError:String;
                          AIsControlTypeMustExists:Boolean
                          ): Boolean;
var
  I: Integer;
  AControl:TControl;
  AControlParent:TControl;
  AComponentClass:TComponentClass;
  AControlMap:TFieldControlSettingMap;
  AFieldControlSetting:TFieldControlSetting;
//  ALayoutItem:TControlLayoutItem;
begin
  uBaseLog.HandleException(nil,'DoCreateControls');

  Result:=False;
  AError:='';

  AControlMapList.BeginUpdate;
  try
  try



    //    //如果是创建在设计面板上面的,那么先清除绑定
    //    if AParent is TSkinItemDesignerPanel then
    //    begin
    //      TSkinItemDesignerPanel(AParent).Prop.Clear;
    //    end;


        //要先将Parent设置为nil，避免它显示出来
        //释放原来自动创建的控件
        for I := AControlMapList.Count-1 downto 0 do
        begin
          if AControlMapList[I].Component is TControl then
          begin
            TControl(AControlMapList[I].Component).Parent:=nil;
          end;
          AControlMapList.Delete(I,True);
        end;
        AControlMapList.Clear(True);
        AControlMapList.Parent:=nil;
        AControlMapList.LayoutSetting:=ALayoutSetting;





        AControlMapList.Parent:=AParent;


        //创建控件列表
        for I := 0 to AFieldControlSettingList.Count-1 do
        begin
            AFieldControlSetting:=AFieldControlSettingList[I];

            if SameText(AFieldControlSetting.page_part,AFilterPagePart) then
            begin


                if not DoCreateControl(AOwner,
                                        AParent,
                                        AFieldControlSetting,
                                        AControlMapList,
                                        APageDataDir,
                                        AIsDesignTime,
                                        AOnPageFrameCustomInitFieldControl,
                                        AControlMap,
                                        AError,
                                        AIsControlTypeMustExists) then
                begin
                  Exit;
                end;

    //            //设置控件的属性
    //            if AControlMap.Control.GetInterface(IID_IControlForPageFramework,
    //                  AControlMap.PageFrameworkControlIntf) then
    //            begin
    //                //加载特殊控件的设置
    //                AControlMap.PageFrameworkControlIntf.LoadFromFieldControlSetting(AFieldControlSetting);
    //            end;


//                AControlMapList.Add(AControlMap);



    //            //创建布局项,用于排列
    //            ALayoutItem:=TControlLayoutItem.Create(AControlMapList.LayoutManager);
    //            ALayoutItem.ControlMap:=AControlMap;
    //            ALayoutItem.Height:=AFieldControlSetting.height;
    ////            if (AControlMap.PageFrameworkControlIntf<>nil)
    ////              //自定义的高度,GetSuitDefaultItemHeight不为-1
    ////              and IsNotSameDouble(AControlMap.PageFrameworkControlIntf.GetSuitDefaultItemHeight,
    ////                                  Const_Tag_UseListItemHeight) then
    ////            begin
    ////              ALayoutItem.Height:=
    ////                AControlMap.PageFrameworkControlIntf.GetSuitDefaultItemHeight;
    ////            end;
    //            AControlMapList.LayoutManager.Add(ALayoutItem);

            end;

        end;



        //给控件恢复设计时的位置和尺寸
        for I := 0 to AControlMapList.Count-1 do
        begin
          if AControlMapList[I].Component is TControl then
          begin
            if AControlMapList[I].InputPanel=nil then
            begin
              //控件设置位置
              TControl(AControlMapList[I].Component).SetBounds(
                                                                ControlSize(AControlMapList[I].Setting.x),
                                                                ControlSize(AControlMapList[I].Setting.y),
                                                                ControlSize(AControlMapList[I].Setting.width),
                                                                ControlSize(AControlMapList[I].Setting.height)
                                                                );
            end;
          end
          else
          begin
            //组件设置位置
            SetComponentBoundsRect(AControlMapList[I].Component,
                                  RectF(
                                        AControlMapList[I].Setting.x,
                                        AControlMapList[I].Setting.y,
                                        AControlMapList[I].Setting.x+AControlMapList[I].Setting.width,
                                        AControlMapList[I].Setting.y+AControlMapList[I].Setting.height
                                  ));
          end;
        end;




    //    //根据控件创建布局排列项
    //    AControlMapList.LayoutManager.BeginUpdate;
    //    try
    //      AControlMapList.LayoutManager.Clear(True);
    //      for I := 0 to AControlMapList.Count-1 do
    //      begin
    //        ALayoutItem:=TControlLayoutItem.Create(AControlMapList.LayoutManager);
    //        ALayoutItem.ControlMap:=AControlMapList[I];
    //
    //
    //        ALayoutItem.Height:=AControlMapList[I].Setting.height;
    //        if (AControlMapList[I].PageFrameworkControlIntf<>nil)
    //          //自定义的高度
    //          and IsNotSameDouble(AControlMapList[I].PageFrameworkControlIntf.GetSuitDefaultItemHeight,Const_Tag_UseListItemHeight) then
    //        begin
    //          ALayoutItem.Height:=
    //            AControlMapList[I].PageFrameworkControlIntf.GetSuitDefaultItemHeight;
    //        end;
    //
    //
    //        AControlMapList.LayoutManager.Add(ALayoutItem);
    //      end;
    //    finally
    //      AControlMapList.LayoutManager.EndUpdate();
    //    end;


    //    //设置绑定
    //    if AParent is TSkinItemDesignerPanel then
    //    begin
    //      for I := 0 to Self.Count-1 do
    //      begin
    //        if Items[I].Setting.bind_listitem_data_type<>'' then
    //        begin
    //          //需要绑定
    //          TSkinItemDesignerPanel(ALayoutParent).Prop.BindControl(
    //              Items[I].Setting.bind_listitem_data_type,
    //              Items[I].Setting.BindSubItemsIndex,
    //              Items[I].Control
    //              );
    //        end;
    //      end;
    //    end;



        Result:=True;

  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'CreateControls');
    end;
  end;
  finally
    AControlMapList.EndUpdate;
  end;

end;



//function SimpleCallAPI(API: String;
//                      AHttpControl:THttpControl;
//                      AInterfaceUrl:String;
//                      AUrlParamNames:TStringDynArray;
//                      AUrlParamValues:Array of Variant): String;
//var
//  ACallResult:Boolean;
//  AIsNeedFreeAHttpControl:Boolean;
//  AResponseStream: TStringStream;
//begin
////  uBaseLog.HandleException(nil,'SimpleCallAPI '+API+' '+'begin');
//
//  Result:='';
//
//  AIsNeedFreeAHttpControl:=False;
//  if AHttpControl=nil then
//  begin
//    AIsNeedFreeAHttpControl:=True;
//    AHttpControl:=TSystemHttpControl.Create;
//  end;
//
//
//  AResponseStream:=TStringStream.Create('',TEncoding.UTF8);
//  try
//    ACallResult:=SimpleGet(
//                       API,
//                       AHttpControl,
//                       AInterfaceUrl,
//                       AUrlParamNames,
//                       AUrlParamValues,
//                       AResponseStream
//                       );
//
//
//    if ACallResult then
//    begin
//        //调用成功
//
//        //保存成临时文件,用来查日志
////        {$IFDEF MSWINDOWS}
////        AResponseStream.Position:=0;
////        AResponseStream.
////            SaveToFile(GetApplicationPath
////                        +ReplaceStr(API,'/','_')+' '
////                        +FormatDateTime('YYYY-MM-DD HH-MM-SS-ZZZ',Now)+'.json');
////        {$ENDIF}
//
//        AResponseStream.Position:=0;
//        Result:=AResponseStream.DataString;
//
////        //服务不可用
////        if Result='Service Unavailable' then
////        begin
////          Result:='';
////        end;
//
//
//    end
//    else
//    begin
//      //调用失败
//
//    end;
//
//  finally
//    SysUtils.FreeAndNil(AResponseStream);
//    if AIsNeedFreeAHttpControl then
//    begin
//      SysUtils.FreeAndNil(AHttpControl);
//    end;
//  end;
//
////  uBaseLog.HandleException(nil,'SimpleCallAPI '+API+' '+'end');
//end;
//
//
//function SimpleCallAPI(API: String;
//          AHttpControl: THttpControl;
//          AInterfaceUrl:String;
//          AUrlParamNames:TStringDynArray;
//          AUrlParamValues:Array of Variant;
//          var ACode:Integer;
//          var ADesc:String;
//          var ADataJson:ISuperObject): Boolean;
//var
//  AHttpResponse:String;
//  ASuperObject:ISuperObject;
//begin
//  Result:=False;
//
//  //在外面初始好了,不用再在里面初始了
//  ACode:=400;//FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//  AHttpResponse:=SimpleCallAPI(API,
//                              AHttpControl,
//                              AInterfaceUrl,
//                              AUrlParamNames,
//                              AUrlParamValues);
//  if (AHttpResponse<>'')
//    or not SameText(AHttpResponse,'Service Unavailable') then
//  begin
//      try
//        ASuperObject:=TSuperObject.Create(AHttpResponse);
//
//        ACode:=ASuperObject.I['Code'];
//        ADesc:=ASuperObject.S['Desc'];
//        ADataJson:=ASuperObject.O['Data'];
//
//        Result:=True;
//
//      except
//        on E:Exception do
//        begin
//          ADesc:=E.Message;
//          uBaseLog.HandleException(E,'SimpleCallAPI Url:'+AInterfaceUrl+' API'+API);
//        end;
//      end;
//  end
//  else
//  begin
//      ADesc:=API+Trans('接口调用失败'+AHttpResponse);
//  end;
//end;
//
//function SimpleGet(API: String;
//                  AHttpControl:THttpControl;
//                  AInterfaceUrl:String;
//                  AUrlParamNames:TStringDynArray;
//                  AUrlParamValues:Array of Variant;
//                  AResponseStream: TStream): Boolean;
//var
//  I:Integer;
//  AStrValue:String;
//  AParamsStr:String;
//  ABefore:TDateTime;
//begin
//    ABefore:=Now;
////    uBaseLog.HandleException(nil,'SimplePost'+' '+'begin'+' '+FormatDateTime('HH:MM:SS',ABefore));
//
//    AParamsStr:='';
//    for I:=0 to Length(AUrlParamNames)-1 do
//    begin
//      AStrValue:=AUrlParamValues[I];
//      if AParamsStr<>'' then
//      begin
//        AParamsStr:=AParamsStr+'&'+AUrlParamNames[I]+'='+AStrValue;
//      end
//      else
//      begin
//        AParamsStr:=AUrlParamNames[I]+'='+AStrValue;
//      end;
//    end;
//
////    if Assigned(OnCallAPIEvent) then
////    begin
////      OnCallAPIEvent(AHttpControl,AInterfaceUrl+API+'?'+AParamsStr);
////    end;
//
//
//    Result:=AHttpControl.Get(
//        TIdURI.URLEncode(AInterfaceUrl+API+'?'+AParamsStr),
//        AResponseStream);
//
//
//    uBaseLog.OutputDebugString('SimpleGet'+' '+AInterfaceUrl+API+' '+'end'+' '+'耗时'+IntToStr(DateUtils.MilliSecondsBetween(ABefore,Now)));
//
//end;


function GetPageStructureFromServer(
            AOpenPlatformServer:String;
            AProgramTemlateName:String;
            AFunctionName:String;
            APageType:String;
            APageName:String):TPage;
var
  ACode:Integer;
  ADesc:String;
  ADataObject:ISuperObject;
begin
  Result:=nil;
//  if Not SimpleCallAPI(
//          'get_page_structure',
//          nil,
//          AOpenPlatformServer,
//          ['appid','user_fid','key',
//          'program_template_name',
//          'function_name',
//          'page_type',
//          'platform',
//          'page_name'
//          ],
//          [],
//          ACode,ADesc,ADataObject) then
//  begin
//    Exit;
//  end;
//
end;


//function LoadDataJsonArrayToItems(
//          ADataJsonArray:ISuperArray;
//          ASkinItems:TSkinItems;
//          AFieldControlSettingList:TFieldControlSettingList):Boolean;
//var
//  I: Integer;
//  ASkinItem:TSkinItem;
//begin
//  Result:=False;
////  ASkinItems.BeginUpdate;
////  try
//
//      for I := 0 to ADataJsonArray.Length-1 do
//      begin
//        ASkinItem:=TSkinItem(ASkinItems.Add);
//        if Not LoadDataJsonToSkinItem(
//                               ADataJsonArray.O[I],
//                               ASkinItem,
//                               AFieldControlSettingList) then
//        begin
//          //加载数据失败
//          Exit;
//        end;
//      end;
//
//      Result:=True;
////  finally
////    ASkinItems.EndUpdate();
////  end;
//end;
//
//
//function LoadDataJsonToSkinItem(
//    ADataJson:ISuperObject;
//    ASkinItem:TSkinItem;
//    AFieldControlSettingList:TFieldControlSettingList):Boolean;
//var
//  I: Integer;
//begin
//  Result:=True;
//
//  //Json数据保存到DataJsonStr
//  ASkinItem.DataJsonStr:=ADataJson.AsJSON;
//
//  for I := 0 to AFieldControlSettingList.Count-1 do
//  begin
//    if not LoadDataJsonToSkinItemProp(
//        ADataJson,
//        ASkinItem,
//        AFieldControlSettingList[I]) then
//    begin
//      Exit;
//    end;
//  end;
//  Result:=True;
//end;
//
//function LoadDataJsonToSkinItemProp(
//    ADataJson:ISuperObject;
//    ASkinItem:TSkinItem;
//    AFieldControlSetting:TFieldControlSetting):Boolean;
//begin
//  Result:=True;
//
//  if AFieldControlSetting.field_name<>'' then
//  begin
//      if ADataJson.Contains(AFieldControlSetting.field_name) then
//      begin
//          //给Item的属性赋值
//          SetItemValueByItemDataType(
//              ASkinItem,
//              GetItemDataType(AFieldControlSetting.bind_listitem_data_type),
//              AFieldControlSetting.BindSubItemsIndex,
//              ADataJson.V[AFieldControlSetting.field_name]
//              );
//      end
//      else
//      begin
//          HandleException(nil,'LoadDataJsonToSkinItemProp ADataJson中不存在'+AFieldControlSetting.field_name);
//          Exit;
//      end;
//  end;
//
//  Result:=True;
//end;

//function SortFieldControlSettingByOrderNo_Compare(Item1, Item2: Pointer): Integer;
//var
//  Param1,Param2:TFieldControlSetting;
//begin
//  Param1:=TFieldControlSetting(Item1);
//  Param2:=TFieldControlSetting(Item2);
//
//  if Param1.orderno>Param2.orderno then
//  begin
//    Result:=1;
//  end
//  else if Param1.orderno<Param2.orderno then
//  begin
//    Result:=-1;
//  end
//  else
//  begin
//    Result:=0;
//  end;
//
//end;
//
//function SortFieldControlByOrderNo_Compare(Item1, Item2: Pointer): Integer;
//var
//  Param1,Param2:TControlLayoutItem;
//begin
//  Param1:=TControlLayoutItem(Item1);
//  Param2:=TControlLayoutItem(Item2);
//
//  if Param1.Setting.orderno>Param2.Setting.orderno then
//  begin
//    Result:=1;
//  end
//  else if Param1.Setting.orderno<Param2.Setting.orderno then
//  begin
//    Result:=-1;
//  end
//  else
//  begin
//    Result:=0;
//  end;
//end;

//function GetAlign(AAlignStr:String):TAlignLayout;
//begin
//  Result:=TAlignLayout.None;
////  TAlignLayout = (None, Top, Left, Right, Bottom,
////MostTop, MostBottom,MostLeft, MostRight,
////Client, Contents, Center, VertCenter,HorzCenter,
////Horizontal, Vertical, Scale,
////Fit, FitLeft, FitRight);
//  if SameText(AAlignStr,'Top') then Result:=TAlignLayout.Top;
//  if SameText(AAlignStr,'Left') then Result:=TAlignLayout.Left;
//  if SameText(AAlignStr,'Right') then Result:=TAlignLayout.Right;
//  if SameText(AAlignStr,'Bottom') then Result:=TAlignLayout.Bottom;
//
//  if SameText(AAlignStr,'MostTop') then Result:=TAlignLayout.MostTop;
//  if SameText(AAlignStr,'MostBottom') then Result:=TAlignLayout.MostBottom;
//  if SameText(AAlignStr,'MostLeft') then Result:=TAlignLayout.MostLeft;
//  if SameText(AAlignStr,'MostRight') then Result:=TAlignLayout.MostRight;
//
//  if SameText(AAlignStr,'Client') then Result:=TAlignLayout.Client;
//  if SameText(AAlignStr,'Contents') then Result:=TAlignLayout.Contents;
//  if SameText(AAlignStr,'Center') then Result:=TAlignLayout.Center;
//  if SameText(AAlignStr,'VertCenter') then Result:=TAlignLayout.VertCenter;
//
//  if SameText(AAlignStr,'Horizontal') then Result:=TAlignLayout.Horizontal;
//  if SameText(AAlignStr,'Vertical') then Result:=TAlignLayout.Vertical;
//  if SameText(AAlignStr,'Scale') then Result:=TAlignLayout.Scale;
//
//  if SameText(AAlignStr,'Fit') then Result:=TAlignLayout.Fit;
//  if SameText(AAlignStr,'FitLeft') then Result:=TAlignLayout.FitLeft;
//  if SameText(AAlignStr,'FitRight') then Result:=TAlignLayout.FitRight;
//
//end;
//
//function GetAnchors(AAnchorsStr:String):TAnchors;
//var
//  AStringList:TStringList;
//  I: Integer;
//begin
//  Result:=[];
//  AStringList:=TStringList.Create;
//  try
//      AStringList.CommaText:=AAnchorsStr;
//
////  TAnchorKind = (akLeft, akTop, akRight, );
////  TAnchors = set of TAnchorKind;
//
//      for I := 0 to AStringList.Count-1 do
//      begin
//        if SameText(AStringList[I],'Left') then
//        begin
//          Result:=Result+[TAnchorKind.akLeft];
//        end;
//        if SameText(AStringList[I],'Top') then
//        begin
//          Result:=Result+[TAnchorKind.akTop];
//        end;
//        if SameText(AStringList[I],'Right') then
//        begin
//          Result:=Result+[TAnchorKind.akRight];
//        end;
//        if SameText(AStringList[I],'Bottom') then
//        begin
//          Result:=Result+[TAnchorKind.akBottom];
//        end;
//      end;
//
//  finally
//    FreeAndNil(AStringList);
//  end;
//end;





//{ TPage }
//
//constructor TPage.Create;
//begin
//end;
//
//destructor TPage.Destroy;
//begin
//  inherited;
//end;
//
//procedure TPage.Prepare;
//var
//  I:Integer;
//  ABindSubItemsIndex:Integer;
//begin
//  ABindSubItemsIndex:=-1;
//  for I := 0 to Self.FieldControlSettingList.Count-1 do
//  begin
//    if FieldControlSettingList[I].bind_listitem_data_type<>'' then
//    begin
//      if SameText(FieldControlSettingList[I].bind_listitem_data_type,'ItemSubItems') then
//      begin
//        Inc(ABindSubItemsIndex);
//        FieldControlSettingList[I].BindSubItemsIndex:=ABindSubItemsIndex;
//      end;
//    end;
//  end;
//end;
//
//function TPage.LoadFromJson(AJson: ISuperObject): Boolean;
//begin
//
//end;

//{ TFieldControlSettingList }
//
//constructor TFieldControlSettingList.Create;
//begin
//
//end;
//
//function TFieldControlSettingList.FindItemByFid(
//  AFid: Integer): TFieldControlSetting;
//var
//  I: Integer;
//begin
//  Result:=nil;
//  for I := 0 to Self.Count-1 do
//  begin
//    if Items[I].fid=AFid then
//    begin
//      Result:=Items[I];
//    end;
//  end;
//end;
//
//function TFieldControlSettingList.GetItem(Index: Integer): TFieldControlSetting;
//begin
//  Result:=TFieldControlSetting(Inherited Items[Index]);
//end;

{ TControlLayoutManager }

//function TControlLayoutManager.AlignControls(ALayoutParent: TControl;
//  APage: TPage): Boolean;
//var
//  I: Integer;
//  ASkinItem:ISkinItem;
//  AFieldControl:TControlLayoutItem;
//  AItemRect:TRectF;
//begin
//  Result:=False;
//
//
//  if APage.align_type=Const_PageAlignType_Auto then
//  begin
//
//      FListLayoutsManager.ControlWidth:=ALayoutParent.Width;
//      FListLayoutsManager.ControlHeight:=ALayoutParent.Height;
//      FListLayoutsManager.DoItemSizeChange(nil);
//
//
////      for I := 0 to Self.FListLayoutsManager.GetVisibleItemsCount-1 do
////      begin
////        ASkinItem:=Self.FListLayoutsManager.GetVisibleItem(I);
////        AFieldControl:=TControlLayoutItem(ASkinItem.GetObject);
////
////        if AFieldControl.Control<>nil then
////        begin
////            AItemRect:=ASkinItem.ItemRect;
////
////            //设置提示文本的区域
////            AFieldControl.AlignControl(AItemRect,APage);
////
////        end;
////
////      end;
//  end;
//
//  Result:=True;
//end;
//
//constructor TControlLayoutManager.Create(const AObjectOwnership: TObjectOwnership;
//  const AIsCreateObjectChangeManager: Boolean);
//begin
//  inherited;
//
//  FListLayoutsManager:=TSkinListViewLayoutsManager.Create(Self);
//
//end;
//
////function TControlLayoutManager.CreateFieldControls(
////  ALayoutParent: TControl;
////  APage: TPage): Boolean;
////var
////  I: Integer;
////  AControl:TControl;
////  AFieldControlSetting:TFieldControlSetting;
////  AFieldControl:TControlLayoutItem;
////begin
////  Result:=False;
////
////  LayoutParent:=ALayoutParent;
////  Page:=APage;
////
////
////
////
////  try
////
////    try
////
////          //先清除绑定
////          if ALayoutParent is TSkinItemDesignerPanel then
////          begin
////            TSkinItemDesignerPanel(ALayoutParent).Prop.Clear;
////          end;
////
////
////
////          //设置排列布局管理者
////          FListLayoutsManager.ViewType:=TListViewType.lvtIcon;
////          FListLayoutsManager.ItemCountPerLine:=APage.item_col_count;
////          FListLayoutsManager.StaticItemWidth:=APage.item_col_width;
////          FListLayoutsManager.StaticItemHeight:=APage.item_height;
////          //默认就设置成isctSeparate,避免用户使用上出现问题
////          FListLayoutsManager.StaticItemSizeCalcType:=isctSeparate;
////
////    //      FListLayoutsManager.OnItemPropChange:=DoItemPropChange;
////    //      FListLayoutsManager.OnItemSizeChange:=DoItemSizeChange;
////    //      FListLayoutsManager.OnItemVisibleChange:=DoItemVisibleChange;
////
////          FListLayoutsManager.ControlWidth:=ALayoutParent.Width;
////          FListLayoutsManager.ControlHeight:=ALayoutParent.Height;
////
////    //      FListLayoutsManager.OnSetSelectedItem:=Self.DoSetListLayoutsManagerSelectedItem;
////
////
////
////
////          //准备
////          APage.Prepare;
////
////
////          //不存在,则创建
////          for I := 0 to APage.FieldControlSettingList.Count-1 do
////          begin
////              AFieldControlSetting:=APage.FieldControlSettingList[I];
////
////              AFieldControl:=Self.FindItemBySettingFid(AFieldControlSetting.fid);
////              if (AFieldControl=nil) then
////              begin
////                AFieldControl:=TControlLayoutItem.Create(Self);
////                AFieldControl.Setting:=AFieldControlSetting;
////                Self.Add(AFieldControl);
////              end;
////          end;
////
////
////          //存在,则更新
////          for I := 0 to Self.Count-1 do
////          begin
////            if Not Items[I].Sync(ALayoutParent) then
////            begin
////              //更新失败
////              Exit;
////            end;
////          end;
////
////
////          //不存在,则删除
////          for I := Self.Count-1 downto 0 do
////          begin
////            if APage.FieldControlSettingList.IndexOf(
////                Self.Items[I].Setting
////                )=-1 then
////            begin
////              Self.Delete(I);
////            end;
////          end;
////
////
////          Self.Sort(SortFieldControlByOrderNo_Compare);
////
////
////
////          //设置绑定
////          if ALayoutParent is TSkinItemDesignerPanel then
////          begin
////            for I := 0 to Self.Count-1 do
////            begin
////              if Items[I].Setting.bind_listitem_data_type<>'' then
////              begin
////                //需要绑定
////                TSkinItemDesignerPanel(ALayoutParent).Prop.BindControl(
////                    Items[I].Setting.bind_listitem_data_type,
////                    Items[I].Setting.BindSubItemsIndex,
////                    Items[I].Control
////                    );
////              end;
////            end;
////          end;
////
////
////
////          Result:=True;
////
////    except
////      on E:Exception do
////      begin
////        uBaseLog.HandleException(E,'TControlLayoutManager.CreateFieldControls');
////      end;
////    end;
////  finally
////    Self.GetListLayoutsManager.DoItemVisibleChange(nil,False);
////    Self.GetListLayoutsManager.DoItemPropChange(nil);
////  end;
////
////
////  //排列位置
////  AlignControls(ALayoutParent,APage);
////
////
////end;
//
//
//destructor TControlLayoutManager.Destroy;
//begin
//  FreeAndNil(FListLayoutsManager);
//  inherited;
//end;
//
//procedure TControlLayoutManager.DoChange;
//begin
//  inherited;
//
//  if Not IsLoading
//    and (FSkinObjectChangeManager<>nil)
//    and not FSkinObjectChangeManager.IsDestroy then
//  begin
//    if (ictAdd in Self.FLastItemChangeTypes)
//      or (ictDel in Self.FLastItemChangeTypes) then
//    begin
//      if GetListLayoutsManager<>nil then
//      begin
//        Self.GetListLayoutsManager.DoItemVisibleChange(nil);
//      end;
//    end;
//  end;
//
//end;
//
//procedure TControlLayoutManager.EndUpdate(AIsForce: Boolean);
//begin
//
//  inherited EndUpdate(AIsForce);
//
//  //判断列表项是否改变过大小再调用
//  //万一有Item的Visible更改过了,也需要调用的
//  if GetListLayoutsManager<>nil then
//  begin
//    Self.GetListLayoutsManager.DoItemVisibleChange(nil,True);
//    Self.GetListLayoutsManager.DoItemPropChange(nil);
//  end;
//
//end;
//
////function TControlLayoutManager.FindItemBySettingFid(ASettingFid: Integer): TControlLayoutItem;
////var
////  I: Integer;
////begin
////  Result:=nil;
////  for I := 0 to Self.Count-1 do
////  begin
////    if Items[I].Setting.fid=ASettingFid then
////    begin
////      Result:=Items[I];
////      Break;
////    end;
////  end;
////end;
//
//function TControlLayoutManager.GetItem(Index: Integer): TControlLayoutItem;
//begin
//  Result:=TControlLayoutItem(Inherited Items[Index]);
//end;
//
//function TControlLayoutManager.GetListLayoutsManager: TSkinListLayoutsManager;
//begin
//  Result:=FListLayoutsManager;
//end;
//
//function TControlLayoutManager.GetObject: TObject;
//begin
//  Result:=Self;
//end;
//
//function TControlLayoutManager.GetSkinItem(const Index: Integer): ISkinItem;
//begin
//  Result:=Items[Index] as ISkinItem;
//end;
//
//function TControlLayoutManager.GetSkinObject(const Index: Integer): TObject;
//begin
//  Result:=Items[Index];
//end;
//
//function TControlLayoutManager.GetUpdateCount: Integer;
//begin
//  Result:=0;
//  if (Self.FSkinObjectChangeManager<>nil) then
//  begin
//    Result:=Self.FSkinObjectChangeManager.UpdateCount;
//  end;
//end;
//
//procedure TControlLayoutManager.SetListLayoutsManager(ALayoutsManager: TSkinListLayoutsManager);
//begin
//  FListLayoutsManager:=TSkinListViewLayoutsManager(ALayoutsManager);
//end;

{ TControlLayoutItem }
//
//procedure TControlLayoutItem.AlignControl(AItemRect: TRectF;
//                                          ALayoutSetting:TLayoutSetting);
//begin
//  //加上边距
//  AItemRect.Left:=AItemRect.Left+ALayoutSetting.margins_left;
//  AItemRect.Top:=AItemRect.Top+ALayoutSetting.margins_top;
//  AItemRect.Right:=AItemRect.Right-ALayoutSetting.margins_right;
//  AItemRect.Bottom:=AItemRect.Bottom-ALayoutSetting.margins_bottom;
//
////  if Self.ControlMap.InputPanel<>nil then
////  begin
////      Self.ControlMap.InputPanel.SetBounds(
////        AItemRect.Left,
////        AItemRect.Top,
////        AItemRect.Width,
////        AItemRect.Height
////        );
////      if Self.ControlMap.HintLabel<>nil then
////      begin
////        Self.ControlMap.HintLabel.Align:=TAlignLayout.Left;
////        Self.ControlMap.HintLabel.Width:=ALayoutSetting.hint_label_width;
////      end;
////      if Self.ControlMap.Control<>nil then
////      begin
////        Self.ControlMap.Control.Align:=TAlignLayout.Client;
////      end;
////
////  end
////  else
////  begin
////
////      //设置提醒标签的位置
////      if Self.ControlMap.HintLabel<>nil then
////      begin
////          Self.ControlMap.HintLabel.SetBounds(
////            AItemRect.Left,
////            AItemRect.Top,
////            ALayoutSetting.hint_label_width,
////            AItemRect.Height
////            );
////          AItemRect.Left:=AItemRect.Left
////              +ALayoutSetting.hint_label_width;
////      end;
////
////
////      //设置控件的位置
////      if Self.ControlMap.Control<>nil then
////      begin
////        Self.ControlMap.Control.SetBounds(
////            AItemRect.Left,
////            AItemRect.Top,
////            AItemRect.Width,
////            AItemRect.Height
////            );
////      end;
////
////  end;
//end;
//
//procedure TControlLayoutItem.ClearItemRect;
//begin
//  FItemRect:=RectF(0,0,0,0);
//  FItemDrawRect:=RectF(0,0,0,0);
//end;
//
//constructor TControlLayoutItem.Create(AOwner: TControlLayoutManager);
//begin
//  SetSkinListIntf(AOwner);
//end;
//
//destructor TControlLayoutItem.Destroy;
//begin
//  inherited;
//end;
//
//function TControlLayoutItem.GetHeight: TControlSize;
//begin
//  Result:=Height;//ControlMap.Setting.height;
//end;
//
//function TControlLayoutItem.GetItemDrawRect: TRectF;
//begin
//  Result:=FItemDrawRect;
//end;
//
//function TControlLayoutItem.GetItemRect: TRectF;
//begin
//  Result:=FItemRect;
//end;
//
//function TControlLayoutItem.GetObject: TObject;
//begin
//  Result:=Self;
//end;
//
//function TControlLayoutItem.GetSelected: Boolean;
//begin
//  Result:=False;
//end;
//
//function TControlLayoutItem.GetVisible: Boolean;
//begin
//  Result:=(ControlMap.Setting.visible=1);
//end;
//
//function TControlLayoutItem.GetWidth: TControlSize;
//begin
//  Result:=ControlMap.Setting.width;
//end;
//
//procedure TControlLayoutItem.SetItemDrawRect(Value: TRectF);
//begin
//  FItemDrawRect:=Value;
//end;
//
//procedure TControlLayoutItem.SetItemRect(Value: TRectF);
//begin
//  FItemRect:=Value;
//end;
//
//procedure TControlLayoutItem.SetSkinListIntf(ASkinListIntf: ISkinList);
//begin
//  FSkinListIntf:=ASkinListIntf;
//end;
//
//function TControlLayoutItem.Sync(ALayoutParent:TControl): Boolean;
//begin
//  Result:=False;
//
////  Result:=ControlMap.Setting.SyncControl(Self,ALayoutParent);
//end;



//{ TFieldControlSetting }
//
//constructor TFieldControlSetting.Create;
//begin
//
//  //-1表示默认
//  height:=-1;
//  //-1表示默认
//  width:=-1;
//
//  visible:=1;
//
//end;
//
//destructor TFieldControlSetting.Destroy;
//begin
//
//  inherited;
//end;
//
//function TFieldControlSetting.SyncControl(
//  AFieldControl: TControlLayoutItem;
//  ALayoutParent:TControl): Boolean;
//var
////  ASkinControlIntf:ISkinControl;
//  AControlForPageFrameworkIntf:IControlForPageFramework;
//begin
//  Result:=False;
//  try
//      //控件类型变过了,要重新创建
//      if (AFieldControl.control_type<>Self.control_type) then
//      begin
//        if GlobalComponentClasses.FindItemByName(Self.control_type)<>nil then
//        begin
//            FreeAndNil(AFieldControl.Control);
//            AFieldControl.Control:=GlobalComponentClasses.FindItemByName(Self.control_type).Create(nil);
//            AFieldControl.Control.Parent:=ALayoutParent;
//
//            AFieldControl.control_type:=Self.control_type;
//
//
////            //设置素材
////            if AFieldControl.Control.GetInterface(IID_ISkinControl,ASkinControlIntf) then
////            begin
////              ASkinControlIntf.GetSkinComponentType;
////              ASkinControlIntf.GetCurrentUseMaterial;
////
////              //测试,设置为不透明
////              ASkinControlIntf.GetCurrentUseMaterial.DrawBackColorParam.IsFill:=True;
////              ASkinControlIntf.GetCurrentUseMaterial.DrawBackColorParam.FillColor.Color:=TAlphaColorRec.Red;
////              ASkinControlIntf.GetCurrentUseMaterial.IsTransparent:=False;
////
////            end;
//
//
//            //加载设置
//            if AFieldControl.Control.GetInterface(IID_IControlForPageFramework,AControlForPageFrameworkIntf) then
//            begin
//              AControlForPageFrameworkIntf.LoadFromFieldControlSetting(Self)
//            end;
//
//
//        end
//        else
//        begin
//            uBaseLog.HandleException(nil,'CreateFieldControls 找不到类型为'+Self.control_type+'的控件');
//            Exit;
//        end;
//      end;
//
//
//
//
//      if (Self.has_caption_label=1)
//        and (AFieldControl.HintLabel=nil) then
//      begin
//        AFieldControl.HintLabel:=TSkinLabel.Create(nil);
//        AFieldControl.HintLabel.Parent:=ALayoutParent;
//        //不可点击
//        AFieldControl.HintLabel.HitTest:=False;
//      end;
//
//      if (Self.has_caption_label=0)
//        and (AFieldControl.HintLabel<>nil) then
//      begin
//        FreeAndNil(AFieldControl.HintLabel);
//      end;
//
//      //提示文本的标签
//      if (Self.has_caption_label=1)
//        and (AFieldControl.HintLabel<>nil) then
//      begin
//        AFieldControl.HintLabel.Caption:=Self.hint_label_caption;
//      end;
//
//      //位置和尺寸
//      if (Self.is_custom_position=1) then
//      begin
//        AFieldControl.Control.SetBounds(left,top,width,height);
//      end;
//
//
//
//
//      AFieldControl.Control.Anchors:=GetAnchors(anchors);
//      AFieldControl.Control.Align:=GetAlign(align);
//      AFieldControl.Control.Visible:=(visible=1);
//      AFieldControl.Control.HitTest:=(hittest=1);
//      AFieldControl.Control.Enabled:=(enabled=1);
//
//
//
//      Result:=True;
//  except
//    on E:Exception do
//    begin
//      uBaseLog.HandleException(E,'TFieldControlSetting.SyncControl');
//    end;
//  end;
//end;

//{ TFieldControlDrawParamList }
//
//function TFieldControlDrawParamList.GetItem(Index: Integer): TFieldControlDrawParam;
//begin
//  Result:=TFieldControlDrawParam(Inherited Items[Index]);
//end;


//{ TListDataController }
//
//
//constructor TListDataController.Create(AOwner: TComponent);
//begin
//
//  FieldControlSettingList:=TFieldControlSettingList.Create;
//
//  tteGetData:=TTimerTaskEvent.Create(nil);
//  tteGetData.OnBegin:=tteGetDataBegin;
//  tteGetData.OnExecute:=tteGetDataExecute;
//  tteGetData.OnExecuteEnd:=tteGetDataExecuteEnd;
//end;
//
//destructor TListDataController.Destroy;
//begin
//  FreeAndNil(tteGetData);
//  FreeAndNil(FieldControlSettingList);
//
//  inherited;
//end;
//
//procedure TListDataController.GetData(
//  AParentControl:TFmxObject;
//  AListControl: TSkinVirtualList;
//  AOnGetDataEvent: TTimerTaskNotify;
//  AOnOnLoadDataToControlsEnd:TNotifyEvent;
//  ADataJsonArrayKey,
//  AItemStyle: String);
//begin
//  ParentControl:=AParentControl;
//
//  ListControl:=AListControl;
//
//  //数据列表在DataJson中的哪个Key
//  DataJsonArrayKey:=ADataJsonArrayKey;
//  //获取数据的方法
//  OnGetListData:=AOnGetDataEvent;
//
//  OnLoadDataToControlsEnd:=AOnOnLoadDataToControlsEnd;
//
//  //启动获取数据的线程
//  Self.tteGetData.Run;
//
//end;
//
//procedure TListDataController.tteGetDataBegin(ATimerTask: TTimerTask);
//begin
//  ShowWaitingFrame(ParentControl,'加载中...');
//end;
//
//procedure TListDataController.tteGetDataExecute(ATimerTask: TTimerTask);
//begin
//  if Assigned(OnGetListData) then
//  begin
//    OnGetListData(ATimerTask);
//  end;
//end;
//
//procedure TListDataController.tteGetDataExecuteEnd(ATimerTask: TTimerTask);
//var
//  ASuperObject:ISuperObject;
//begin
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//
//        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//        if (ASuperObject.I['Code']=200) then
//        begin
//            if ASuperObject.Contains('Data')
//              and ASuperObject.O['Data'].Contains(DataJsonArrayKey) then
//            begin
//                Self.ListControl.Prop.Items.BeginUpdate;
//                try
//                  LoadDataJsonArrayToItems(
//                      ASuperObject.O['Data'].A[DataJsonArrayKey],
//                      Self.ListControl.Prop.Items,
//                      Self.FieldControlSettingList
//                      );
//                finally
//                  Self.ListControl.Prop.Items.EndUpdate;
//                end;
//
//                //设置弹出框的高度
//                if Assigned(Self.OnLoadDataToControlsEnd) then
//                begin
//                  OnLoadDataToControlsEnd(Self);
//                end;
//                //FrameResize(nil);
//            end
//            else
//            begin
//                ShowMessageBoxFrame(ParentControl,'返回的数据格式不匹配!','',TMsgDlgType.mtInformation,['确定'],nil);
//            end;
//        end
//        else
//        begin
//            //获取列表失败
//            ShowMessageBoxFrame(ParentControl,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
//        end;
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(ParentControl,'网络异常,请检查您的网络连接!',TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    HideWaitingFrame;
//  end;
//
//end;

{ TPage }

procedure TPage.AssignTo(Dest: TPersistent);
var
  ADest:TPage;
  I: Integer;
  AFieldControlSetting:TFieldControlSetting;
begin
  if (Dest<>nil) and (Dest is TPage) then
  begin
      ADest:=TPage(Dest);

      //程序模板
      ADest.ProgramTemplate:=ProgramTemplate;


  //    //服务端
  //    DataServer:TDataServer;


      //接口
      if ADest.DataInterface<>nil then
      begin
        ADest.DataInterface.Assign(DataInterface);
      end;
      if ADest.DataInterface2<>nil then
      begin
        ADest.DataInterface2.Assign(DataInterface2);
      end;


  //    //功能模块
  //    DataFunction:TDataFunction;
  //    //页面
  //    Page:TPage;





      ADest.fid:=fid;
      ADest.appid:=Self.appid;





      //所属的程序模块
      ADest.program_template_fid:=program_template_fid;
      ADest.program_template_name:=program_template_name;


      //所调用的接口
      ADest.data_intf_fid:=data_intf_fid;
      ADest.data_intf_name:=data_intf_name;


      //所调用的接口
      ADest.data_intf_fid2:=data_intf_fid2;
      ADest.data_intf_name2:=data_intf_name2;



      //所属的功能
      ADest.function_fid:=function_fid;
      ADest.function_name:=function_name;




      //页面的名称
      ADest.name:=name;
      //页面的标题
      ADest.caption:=caption;


      //排列布局类型,
      //manual手动布局,
      //auto自动布局
      ADest.align_type:=align_type;


      //页面类型
      ADest.page_type:=page_type;
      //平台
      ADest.platform:=platform;


      ADest.design_width:=design_width;
      ADest.design_height:=design_height;


      ADest.refresh_seconds:=refresh_seconds;






      //加载接口1需要的参数
      ADest.load_data_params:=load_data_params;
      //保存接口1所需要的参数
      ADest.save_data_params:=save_data_params;


      //加载接口2需要的参数
      ADest.load_data_params2:=load_data_params2;
      //保存接口2所需要的参数
      ADest.save_data_params2:=save_data_params2;





      //默认列表项的显示风格
      ADest.default_list_item_style:=default_list_item_style;
      //默认列表项的绑定设置
      ADest.default_list_item_bindings:=default_list_item_bindings;




      ADest.MainLayoutControlList.Clear();
      for I := 0 to Self.MainLayoutControlList.Count-1 do
      begin
        AFieldControlSetting:=TFieldControlSetting.Create(ADest.MainLayoutControlList);
        AFieldControlSetting.Assign(MainLayoutControlList[I]);
  //      ADest.MainLayoutControlList.Add(AFieldControlSetting);
      end;


      ADest.BottomToolbarLayoutControlList.Clear();
      for I := 0 to Self.BottomToolbarLayoutControlList.Count-1 do
      begin
        AFieldControlSetting:=TFieldControlSetting.Create(ADest.BottomToolbarLayoutControlList);
        AFieldControlSetting.Assign(BottomToolbarLayoutControlList[I]);
  //      ADest.BottomToolbarLayoutControlList.Add(AFieldControlSetting);
      end;




      //列表页面，或者界面控件布局//
      //每行列数
      ADest.item_col_count:=item_col_count;
      //每列宽度
      ADest.item_col_width:=item_col_width;
      //行高
      ADest.item_height:=item_height;




      //列表页面相关设置//
      //是否是默认的ListPage,
      //如果是就创建一个默认的ListView
//      ADest.is_simple_list_page:=is_simple_list_page;
      //列表页面是否需要添加记录按钮
      ADest.has_add_record_button:=has_add_record_button;


      ADest.FDataSkinItems.Assign(FDataSkinItems);




      //做为列表项样式时的默认值
      ADest.list_item_style_default_height:=list_item_style_default_height;
      ADest.list_item_style_autosize:=list_item_style_autosize;
      ADest.list_item_style_default_width:=list_item_style_default_width;




  end;

end;

procedure TPage.ClearFid;
var
  I:Integer;
begin
  Self.fid:=0;

  Self.data_intf_fid:=0;
  Self.data_intf_name:='';

  Self.data_intf_fid2:=0;
  Self.data_intf_name2:='';

  if Self.DataInterface<>nil then Self.DataInterface.fid:=0;
  if Self.DataInterface2<>nil then Self.DataInterface2.fid:=0;

  for I := 0 to Self.MainLayoutControlList.Count-1 do
  begin
    MainLayoutControlList[I].ClearFid;
  end;

  for I := 0 to Self.BottomToolbarLayoutControlList.Count-1 do
  begin
    BottomToolbarLayoutControlList[I].ClearFid;
  end;

end;

constructor TPage.Create(AOwner: TComponent);
begin
  inherited;

  FDataSkinItems:=TSkinItems.Create;



//  ProgramTemplate:=TProgramTemplate.Create;
//  DataServer:=TDataServer.Create;
//  DataInterface:=TDataInterface.Create;
//  DataFunction:=TDataFunction.Create;
//  Page:=TPage.Create;



  FDefaultListItemBindings:=TListItemBindings.Create(TListItemBindingItem);



//  //列表页面的表格列列表
//  PageColumns:=TPageColumns.Create;





  //页面的控件列表
  FMainLayoutControlList:=TFieldControlSettingList.Create;
  //页面其他区域的控件
  FBottomToolbarLayoutControlList:=TFieldControlSettingList.Create;

  //主控件排列设置
  MainLayoutSetting:=TLayoutSetting.Create;
  MainLayoutSetting.name:='main';

  //底部工具栏的设置
  BottomToolbarLayoutSetting:=TLayoutSetting.Create;
  BottomToolbarLayoutSetting.name:='bottom_toolbar';



//  //加载需要的参数
//  LoadDataParamsJsonArray:=TSuperArray.Create;
//  //保存所需要的参数
//  SaveDataParamsJsonArray:=TSuperArray.Create;


  if GlobalDataInterfaceClass<>nil then
  begin
      DataInterface:=GlobalDataInterfaceClass.Create;
    //  if DataInterface is TCommonRestIntfItem then
    //  begin
    //
    //  end;


      DataInterface2:=GlobalDataInterfaceClass.Create;
        //TCommonRestIntfItem.Create(nil);
  end
  else
  begin
      //Raise Exception.Create('GlobalDataInterfaceClass不能为空');
  end;




  //做为列表项样式时的默认值
  list_item_style_default_height:=-1;
  list_item_style_autosize:=0;
  list_item_style_default_width:=-1;



end;

function TPage.CreatePageInstalceTo(AOwner:TComponent;AParent: TParentControl;var AError:String): TPageInstance;
begin
  Result:=TPageInstance.Create;//(nil);
  Result.PageStructure:=Self;
  Result.CreateControls(AOwner,
                        AParent,
                        '',
                        Self.GetPageDataDir,
                        False,
                        AError
                        );
end;

destructor TPage.Destroy;
begin

  FreeAndNil(FDefaultListItemBindings);
//  FreeAndNil(ProgramTemplate);
//  FreeAndNil(DataServer);


  FreeAndNil(DataInterface);

  FreeAndNil(DataInterface2);


//  FreeAndNil(DataFunction);
//  FreeAndNil(Page);


  FreeAndNil(MainLayoutSetting);
  FreeAndNil(BottomToolbarLayoutSetting);

  //列表页面的表格列列表
//  FreeAndNil(PageColumns);
  //页面的控件列表
  FreeAndNil(FMainLayoutControlList);
  //页面其他区域的控件
  FreeAndNil(FBottomToolbarLayoutControlList);


  FreeAndNil(FDataSkinItems);

  inherited;
end;

function TPage.LoadPageStructureFromJson(ASuperObject: ISuperObject): Boolean;
var
  I: Integer;
  AControlRecordJson:ISuperObject;
  AFieldControlSetting:TFieldControlSetting;
begin
  uBaseLog.HandleException(nil,'TPage.LoadPageStructureFromJson');


  Result:=LoadFromJson(ASuperObject.O['page']);
  if not Result then Exit;




  //主要的接口
//  FreeAndNil(Self.DataInterface);
//  if ASuperObject.O['data_interface'].S['type']=Const_IntfType_TableCommonRest then
//  begin
//    DataInterface:=TCommonRestIntfItem.Create(nil);
    if not DataInterface.LoadFromJson(ASuperObject.O['data_interface']) then
    begin
      Exit;
    end;
//  end;


    //接口2
    if not DataInterface2.LoadFromJson(ASuperObject.O['data_interface2']) then
    begin
      Exit;
    end;



  //控件列表
  Self.MainLayoutControlList.Clear;
  for I := 0 to ASuperObject.A['controls'].Length-1 do
  begin

      AFieldControlSetting:=TFieldControlSetting.Create(MainLayoutControlList);
      if not AFieldControlSetting.LoadFromJson(ASuperObject.A['controls'].O[I]) then
      begin
        Exit;
      end;


      

//      MainLayoutControlList.Add(AFieldControlSetting);
  end;




  //控件列表
  Self.BottomToolbarLayoutControlList.Clear;
  for I := 0 to ASuperObject.A['controls'].Length-1 do
  begin

      if ASuperObject.A['other_page_part_controls'].O[I].S['page_part']=Const_PagePart_BottomToolbar then
      begin
          AFieldControlSetting:=TFieldControlSetting.Create(BottomToolbarLayoutControlList);
          if not AFieldControlSetting.LoadFromJson(ASuperObject.A['other_page_part_controls'].O[I]) then
          begin
            Exit;
          end;

//          BottomToolbarLayoutControlList.Add(AFieldControlSetting);
      end;
  end;


  //MainLayoutControlList.LoadFromJson后面
  LoadLayoutControlListEnd;


  IsLoaded:=True;



  Result:=True;
end;

function TPage.GetPageDataDir: String;
begin
  if (Self.FLoadedJsonFilePath<>'') then
  begin
    Result:=ExtractFilePath(FLoadedJsonFilePath);
    Exit;
  end;

  Result:=GetApplicationPath+'programs'+PathDelim;

  if (Self.ProgramTemplate<>nil) then
  begin
    Result:=ProgramTemplate.GetProgramTemplateDir;
  end
  else if program_template_name<>'' then
  begin
    Result:=Result+Self.program_template_name+PathDelim;
  end;

  Result:=Result+Self.name+PathDelim;


end;

function TPage.LoadFromServer(AInterfaceUrl:String;
                              AAppID:Integer;
                              //APageFID:Integer;
                              AProgramTemplateName:String;
                              AFunctionName:String;
                              APageType:String;
                              APlatform:String;
                              APageName:String;
                              AIsCanUseCache:Boolean;
                              var ADesc:String;
                              var AIsUsedCache:Boolean): Boolean;
var
  ACode: Integer;
  ADataJson:ISuperObject;
var
  I: Integer;
  AControlRecordJson:ISuperObject;
  AFieldControlSetting:TFieldControlSetting;
  ACacheFilePath:String;
begin
  Result:=False;
  ADesc:='';

  ADataJson:=nil;

  AIsUsedCache:=False;



  if (AProgramTemplateName<>'') and ((APageName<>'') or (AFunctionName<>'')) then
  begin
  end
//  else
//  if APageFID>0 then
//  begin
//      //直接通过fid加载页面结构
//      //不存在fid,表示要新增该记录
//      if not SimpleCallAPI(
//                          'get_page_info',
//                          nil,
//                          AInterfaceUrl+'program_framework/',
//                          ['appid',
//                          'user_fid',
//                          'key',
//
//                          'page_fid'
//                          ],
//                          [
//                          AAppID,
//                          0,
//                          '',
//                          APageFID
//                          ],
//                          ACode,
//                          ADesc,
//                          ADataJson,
//                          GlobalRestAPISignType,
//                          GlobalRestAPIAppSecret) then
//      begin
//        Exit;
//      end;
//  end
  else
  begin
      ADesc:='请指定页面!';
      Exit;
  end;



  ACacheFilePath:=GetApplicationPath
                      +AProgramTemplateName+'_'
                      +AFunctionName+'_'
                      +APageType+'_'
                      +APlatform+'_'
                      +APageName
                      +'.json';
  if AIsCanUseCache and FileExists(ACacheFilePath) then
  begin
      ADataJson:=TSuperObject.ParseFile(ACacheFilePath{$IFDEF VCL},True{$ENDIF});

      AIsUsedCache:=True;

  end
  else
  begin
      //不存在fid,表示要新增该记录
      if not SimpleCallAPI(
                          'get_page_structure',
                          nil,
                          AInterfaceUrl+'program_framework/',
                          ConvertToStringDynArray(['appid',
                                                  'user_fid',
                                                  'key',

                                                  'program_template_name',
                                                  'function_name',
                                                  'page_type',
                                                  'platform',
                                                  'page_name'//可以忽略
                                                  ]),
                          ConvertToVariantDynArray([
                                                  AAppID,
                                                  0,
                                                  '',
                                                  AProgramTemplateName,
                                                  AFunctionName,
                                                  APageType,
                                                  APlatform,
                                                  APageName
                                                  ]),
                          ACode,
                          ADesc,
                          ADataJson,
                          GlobalRestAPISignType,
                          GlobalRestAPIAppSecret

                          ) then
      begin
        Exit;
      end;


      if AIsCanUseCache then
      begin
        ADataJson.SaveTo(ACacheFilePath);
      end;


  end;

  if ADataJson<>nil then
  begin
    //加载页面数据和结构
    Self.LoadPageStructureFromJson(ADataJson);
  end;



  Result:=True;

end;

procedure TPage.LoadLayoutControlListEnd;
var
  I: Integer;
  APropJson:ISuperObject;
  AFieldControlSetting:TFieldControlSetting;
var
  ASuperObject:ISuperObject;
//  I: Integer;
//  AListItemBindingItem:TListItemBindingItem;
begin
  //如果是列表页面,并且不存在列表控件,那么自动创建一个列表控件项
  if (Self.page_type=Const_PageType_ListPage) then//and (is_simple_list_page=1) then
  begin
//      if MainLayoutControlList.FindByControlType('listview')=nil then
//      begin
          AFieldControlSetting:=TFieldControlSetting.Create(MainLayoutControlList);


          //字段名
          AFieldControlSetting.field_name:='RecordList';
          AFieldControlSetting.field_caption:='数据列表';
//          //控件风格
//          AFieldControlSetting.control_style:String;


          //默认的动作
          //点击编辑列表项
          AFieldControlSetting.action:=Const_PageAction_JumpToEditRecordPage;



      //    //控件所在的页面位置
      //    page_part:String;

      //    //所属页面的FID
      //    page_fid:Integer;
      //    //父控件的id
      //    parent_control_fid:Integer;
      //    //本地时使用
      //    parent_control_name:String;


      //    //控件属性
      //    x:double;
      //    y:double;
      //    width:double;
      //    height:double;
      //
      //    //边距
      //    margins:String;
      //
      //
      //    //拉伸模式
      //    anchors:String;
          //对齐方式
          AFieldControlSetting.align:='Client';
          //是否可以响应点击
          AFieldControlSetting.hittest:=1;
          //是否启用
          AFieldControlSetting.enabled:=1;


          //是否显示
          AFieldControlSetting.visible:=1;

          AFieldControlSetting.has_caption_label:=0;


          //控件类型,要与HTML等通用
          AFieldControlSetting.control_type:='listview';
          //控件名,一定要,因为有些控件并不一定有FieldName
          AFieldControlSetting.name:='lvData';
//          //标题
//          AFieldControlSetting.caption:='数据列表';





          //    //值,Label的Caption,
          //    value:String;
          if default_list_item_style='' then
          begin
            default_list_item_style:='Default';
            if default_list_item_bindings='' then
            begin
              //默认值,没有默认的话,列表页面内容出不来
              default_list_item_bindings:='{"ItemCaption":"name"}';
            end;
          end;




          //列表框的默认参数
          APropJson:=TSuperObject.Create;
          APropJson.S['DefaultItemStyle']:=Self.default_list_item_style;
          if Self.item_col_count>0 then
          begin
            APropJson.I['ColCount']:=Self.item_col_count;
          end;
          if Self.item_height>0 then
          begin
            APropJson.I['ItemHeight']:=Self.item_height;
          end;
          AFieldControlSetting.prop:=APropJson.AsJSON;



          ASuperObject:=TSuperObject.Create(default_list_item_bindings);
          FDefaultListItemBindings.LoadFromJson(ASuperObject);
//          Self.FDefaultListItemBindings.Clear;
//          if ASuperObject.Contains('ItemCaption') then
//          begin
//            //列表项属性与数据字段的绑定
//            AListItemBindingItem:=Self.FDefaultListItemBindings.Add;
//            AListItemBindingItem.item_field_name:='ItemCaption';
//            AListItemBindingItem.data_field_name:=ASuperObject.S['ItemCaption'];
//          end;



//          //存在添加按钮
//          if Self.has_add_record_button=1 then


//      end;
  end;
end;

procedure TPage.LoadFromFile(AJsonFilePath: String);
var
  ASuperObject:ISuperObject;
begin
  ASuperObject:=TSuperObject.Create(GetStringFromFile(AJsonFilePath,TEncoding.UTF8));
  LoadPageStructureFromJson(ASuperObject);

  FLoadedJsonFilePath:=AJsonFilePath;
end;

function TPage.LoadFromIndexJson(AJson: ISuperObject): Boolean;
begin
  Result:=False;

  //页面的名称
  name:=AJson.S['name'];
  //页面的标题
  caption:=AJson.S['caption'];


  Result:=True;

end;

function TPage.LoadFromJson(AJson: ISuperObject): Boolean;
var
  ASuperObject:ISuperObject;
begin
  Result:=False;

  try


      fid:=AJson.I['fid'];
      Self.appid:=AJson.I['appid'];


      //所属的程序模块
      program_template_fid:=AJson.I['program_template_fid'];
      program_template_name:=AJson.S['program_template_name'];


      //所调用的接口
      data_intf_fid:=AJson.I['data_intf_fid'];
      data_intf_name:=AJson.S['data_intf_name'];

      //所调用的接口
      data_intf_fid2:=AJson.I['data_intf_fid2'];
      data_intf_name2:=AJson.S['data_intf_name2'];


      //所属的功能
      function_fid:=AJson.I['function_fid'];
      function_name:=AJson.S['function_name'];

      //页面的名称
      name:=AJson.S['name'];
      //页面的标题
      caption:=AJson.S['caption'];


      //排列布局类型,
      //manual手动布局,
      //auto自动布局
      align_type:=AJson.S['align_type'];


      //页面类型
      page_type:=AJson.S['type'];
      platform:=AJson.S['platform'];



      design_width:=AJson.F['design_width'];
      design_height:=AJson.F['design_height'];


      refresh_seconds:=AJson.I['refresh_seconds'];



      //加载接口1需要的参数
      load_data_params:=AJson.S['load_data_params'];
      //保存接口1所需要的参数
      save_data_params:=AJson.S['save_data_params'];
    //  Self.LoadDataParamsJsonArray:=TSuperArray.Create(AJson.S['load_data_params']);
    //  Self.SaveDataParamsJsonArray:=TSuperArray.Create(AJson.S['save_data_params']);



      //加载接口2需要的参数
      load_data_params2:=AJson.S['load_data_params2'];
      //保存接口2所需要的参数
      save_data_params2:=AJson.S['save_data_params2'];
    //  Self.LoadDataParamsJsonArray2:=TSuperArray.Create(AJson.S['load_data_params2']);
    //  Self.SaveDataParamsJsonArray2:=TSuperArray.Create(AJson.S['save_data_params2']);



      //默认列表项的显示风格
      default_list_item_style:=AJson.S['default_list_item_style'];
      //默认列表项的绑定设置
      default_list_item_bindings:=AJson.S['default_list_item_bindings'];




      ASuperObject:=TSuperObject.Create(default_list_item_bindings);
      FDefaultListItemBindings.LoadFromJson(ASuperObject);


      

      //主控件排列设置
      MainLayoutSetting.LoadFromJson(AJson);


      BottomToolbarLayoutSetting.LoadFromJson(AJson);



      //做为列表项样式时的默认值
      list_item_style_default_height:=AJson.F['list_item_style_default_height'];
      list_item_style_autosize:=AJson.I['list_item_style_autosize'];
      list_item_style_default_width:=AJson.F['list_item_style_default_width'];


      Result:=True;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'TPage.LoadFromJson');
    end;
  end;
end;

procedure TPage.SaveToFile(AJsonFilePath: String);
var
  ASuperObject:ISuperObject;
begin
  ASuperObject:=TSuperObject.Create();
  SavePageStructureToJson(ASuperObject,Self.GetPageDataDir);
  SaveStringToFile(//ASuperObject.AsJSON,
                    formatJson(UTFStrToUnicode(ASuperObject.AsJSON)),
                    AJsonFilePath,TEncoding.UTF8);
end;

function TPage.SaveToIndexJson(AJson: ISuperObject): Boolean;
begin
  Result:=False;

  //页面的名称
  AJson.S['name']:=name;
  //页面的标题
  AJson.S['caption']:=caption;

  Result:=True;

end;

function TPage.SaveToJson(AJson: ISuperObject): Boolean;
var
  ASuperObject:ISuperObject;
begin
  Result:=False;


  try


      //页面的名称
      AJson.S['name']:=name;
      //页面的标题
      AJson.S['caption']:=caption;


      //排列布局类型,
      //manual手动布局,
      //auto自动布局
      AJson.S['align_type']:=align_type;


      //页面类型
      AJson.S['type']:=page_type;
      AJson.S['platform']:=platform;



      if fid<>0 then AJson.I['fid']:=fid;
      AJson.I['appid']:=Self.appid;



      //所属的程序模块
      if program_template_fid<>0 then AJson.I['program_template_fid']:=program_template_fid;
      if program_template_name<>'' then AJson.S['program_template_name']:=program_template_name;


      //所调用的接口
      if data_intf_fid<>0 then AJson.I['data_intf_fid']:=data_intf_fid;
      if data_intf_name<>'' then AJson.S['data_intf_name']:=data_intf_name;



      //所调用的接口
      if data_intf_fid2<>0 then AJson.I['data_intf_fid2']:=data_intf_fid2;
      if data_intf_name2<>'' then AJson.S['data_intf_name2']:=data_intf_name2;



      //所属的功能
      if function_fid<>0 then AJson.I['function_fid']:=function_fid;
      if function_name<>'' then AJson.S['function_name']:=function_name;


      AJson.F['design_width']:=design_width;
      AJson.F['design_height']:=design_height;

      AJson.I['refresh_seconds']:=refresh_seconds;


    //    //加载接口1需要的参数
    //    load_data_params:String;
    //    //保存接口1所需要的参数
    //    save_data_params:String;
      if load_data_params<>'' then AJson.S['load_data_params']:=load_data_params;//Self.LoadDataParamsJsonArray.AsJSON;
      if save_data_params<>'' then AJson.S['save_data_params']:=save_data_params;//Self.SaveDataParamsJsonArray.AsJSON;


    //    //加载接口2需要的参数
    //    load_data_params2:String;
    //    //保存接口2所需要的参数
    //    save_data_params2:String;
      if load_data_params2<>'' then AJson.S['load_data_params2']:=load_data_params2;//Self.LoadDataParamsJsonArray2.AsJSON;
      if save_data_params2<>'' then AJson.S['save_data_params2']:=save_data_params2;//Self.SaveDataParamsJsonArray2.AsJSON;



      //默认列表项的显示风格
      if default_list_item_style<>'' then AJson.S['default_list_item_style']:=default_list_item_style;



      ASuperObject:=TSuperObject.Create();
      FDefaultListItemBindings.SaveToJson(ASuperObject);
      default_list_item_bindings:=ASuperObject.AsJson;
      //默认列表项的绑定设置
      if default_list_item_bindings<>'' then AJson.S['default_list_item_bindings']:=default_list_item_bindings;




      //主控件排列设置
      MainLayoutSetting.SaveToJson(AJson);


      BottomToolbarLayoutSetting.SaveToJson(AJson);




      //做为列表项样式时的默认值
      AJson.F['list_item_style_default_height']:=list_item_style_default_height;
      AJson.I['list_item_style_autosize']:=list_item_style_autosize;
      AJson.F['list_item_style_default_width']:=list_item_style_default_width;



      Result:=True;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'TPage.SaveToJson');
    end;
  end;
end;

procedure TPage.SetBottomToolbarLayoutControlList(
  const Value: TFieldControlSettingList);
begin
  FBottomToolbarLayoutControlList.Assign(Value);
end;

procedure TPage.SetDataSkinItems(const Value: TSkinItems);
begin
  FDataSkinItems.Assign(Value);
end;

procedure TPage.SetDefaultListItemBindings(const Value: TListItemBindings);
begin
  FDefaultListItemBindings.Assign(Value);
end;

procedure TPage.SetMainLayoutControlList(const Value: TFieldControlSettingList);
begin
  FMainLayoutControlList.Assign(Value);
end;

function TPage.SavePageStructureToJson(ASuperObject: ISuperObject;APageDataDir:String): Boolean;
var
  I: Integer;
  AControlRecordJson:ISuperObject;
  ASuperArray:ISuperArray;
  ADataIntfJson:ISuperObject;
begin
  Result:=SaveToJson(ASuperObject.O['page']);
  if not Result then Exit;




  //保存接口
  if (DataInterface<>nil) and not DataInterface.IsEmpty then
  begin
    ADataIntfJson:=TSuperObject.Create();
    ASuperObject.O['data_interface']:=ADataIntfJson;
    DataInterface.SaveToJson(ASuperObject.O['data_interface']);
  end;


  //保存接口2
  if (DataInterface2<>nil) and not DataInterface2.IsEmpty then
  begin
    ADataIntfJson:=TSuperObject.Create();
    ASuperObject.O['data_interface2']:=ADataIntfJson;
    DataInterface2.SaveToJson(ASuperObject.O['data_interface2']);
  end;




  //保存控件列表
  ASuperArray:=TSuperArray.Create;
  ASuperObject.A['controls']:=ASuperArray;

  for I := 0 to Self.MainLayoutControlList.Count-1 do
  begin
      AControlRecordJson:=TSuperObject.Create;

      if not MainLayoutControlList[I].SaveToJson(AControlRecordJson) then
      begin
        Exit;
      end;

      ASuperArray.O[I]:=AControlRecordJson;
  end;


  {$IFDEF FMX}
  if FileExists(APageDataDir+Self.name+'.json') then
  begin
    ForceDirectories(APageDataDir+'backup\');
//    System.IOUtils.TFile.Move(APageDataDir+Self.name+'.json',APageDataDir+'backup\'+Self.name+' '+FormatDateTime('YYYY-MM-DD HH-MM-SS-ZZZ',Now)+'.json');
    System.IOUtils.TFile.Copy(APageDataDir+Self.name+'.json',APageDataDir+'backup\'+Self.name+' '+FormatDateTime('YYYY-MM-DD HH-MM-SS-ZZZ',Now)+'.json');
  end;
  {$ENDIF FMX}


  //保存成文件
  SaveStringToFile(ASuperObject.AsJSON,APageDataDir+Self.name+'.json',TEncoding.UTF8);



  Result:=True;

end;

function TPage.SaveSubControlsToServer(AInterfaceUrl:String;
                                      AAppID:Integer;
                                      AParent: TControl;
                                      APageDataDir:String;
                                      APageInstance:TPageInstance;
                                      AImageHttpServerUrl:String;
                                      AOldFieldControlSettingList:TFieldControlSettingList;
                                      //在里面创建并返回,需要负责释放
                                      var ANewFieldControlSettingList:TFieldControlSettingList;
                                      var ANeedAddFieldControlSettingList:TList;
                                      var ADesc:String): Boolean;
var
//  ADesc:String;
  I: Integer;
  AIsAdd:Boolean;
  ADataJson:ISuperObject;
  AOldFieldControlSetting:TFieldControlSetting;
  ANewFieldControlSetting:TFieldControlSetting;


  AFieldControlSettingMapList:TFieldControlSettingMapList;

//  AIsSaveSubControlsToFieldControlSettingListSucc:Boolean;

//  FSavePageInThreadDesc:String;
  AControlRecordJson:ISuperObject;
  ARemoteFilePath:String;
  AIsFieldControlSettingChanged:Boolean;

begin
  Result:=False;


  ANeedAddFieldControlSettingList:=TList.Create;










  //将控件列表同步控件到服务器









  //判断老控件是否存在,Self.FPageInstance.MainControlMapList中的是老的创建的控件
  //ANewFieldControlSettingList中的SavedControl是新控件
  if APageInstance<>nil then
  begin
      for I := 0 to APageInstance.MainControlMapList.Count-1 do
      begin
          //原控件列表,如果在新控件列表中不存在了,就表示已经删除了
          ANewFieldControlSetting:=ANewFieldControlSettingList.FindBySavedComponent(APageInstance.MainControlMapList[I].Component);
          if ANewFieldControlSetting<>nil then
          begin
            //老控件还存在,没有被删除,那么取回fid
            AOldFieldControlSetting:=APageInstance.MainControlMapList[I].Setting;
            ANewFieldControlSetting.fid:=AOldFieldControlSetting.fid;
          end
          else
          begin
            //老控件不存在,已经被删除,标记为删除
            APageInstance.MainControlMapList[I].Setting.is_deleted:=1;



            AControlRecordJson:=TSuperObject.Create;
            AControlRecordJson.I['fid']:=APageInstance.MainControlMapList[I].Setting.fid;
            AControlRecordJson.I['is_deleted']:=1;

            if not SaveRecordToServer(AInterfaceUrl,
                                        AAppID,
                                        '',
                                        '',
                                        'page_layout_control',
                                        APageInstance.MainControlMapList[I].Setting.fid,
                                        AControlRecordJson,
                                        AIsAdd,
                                        ADesc,
                                        ADataJson,
                                        '',
                                        '') then
            begin
              Exit;
            end;

          end;
      end;

  end
  else
  begin

      for I := 0 to AOldFieldControlSettingList.Count-1 do
      begin

          AOldFieldControlSetting:=AOldFieldControlSettingList[I];
          //原控件列表,如果在新控件列表中不存在了,就表示已经删除了
          ANewFieldControlSetting:=ANewFieldControlSettingList.FindByName(AOldFieldControlSetting.name);

          if ANewFieldControlSetting<>nil then
          begin
            //老控件还存在,没有被删除,那么取回fid
            ANewFieldControlSetting.fid:=AOldFieldControlSetting.fid;
          end
          else
          begin
            //老控件不存在,已经被删除,标记为删除
            AOldFieldControlSetting.is_deleted:=1;



            AControlRecordJson:=TSuperObject.Create;
            AControlRecordJson.I['fid']:=AOldFieldControlSetting.fid;
            AControlRecordJson.I['is_deleted']:=1;

            if not SaveRecordToServer(AInterfaceUrl,
                                        AAppID,
                                        '',
                                        '',
                                        'page_layout_control',
                                        AOldFieldControlSetting.fid,
                                        AControlRecordJson,
                                        AIsAdd,
                                        ADesc,
                                        ADataJson,
                                        '',
                                        '') then
            begin
              Exit;
            end;

          end;
      end;


  end;





  //提交删除的控件到服务器
//  for I := 0 to Self.FPageInstance.MainControlMapList.Count-1 do
//  begin
//      if Self.FPageInstance.MainControlMapList[I].Setting.is_deleted=1 then
//      begin
//          AControlRecordJson:=TSuperObject.Create;
//          AControlRecordJson.I['fid']:=Self.FPageInstance.MainControlMapList[I].Setting.fid;
//          AControlRecordJson.I['is_deleted']:=1;
//
//          if not SaveRecordToServer(InterfaceUrl,AppID,0,'','page_layout_control',AControlRecordJson,AIsAdd,ADesc,ADataJson) then
//          begin
//            Exit;
//          end;
//
//      end;
//  end;








  //提交更新的控件
  for I := 0 to ANewFieldControlSettingList.Count-1 do
  begin
      ANewFieldControlSetting:=ANewFieldControlSettingList[I];

      //找到原控件设置,比对哪些字段需要更新
      AOldFieldControlSetting:=nil;
      if ANewFieldControlSetting.fid>0 then
      begin
        AOldFieldControlSetting:=AOldFieldControlSettingList.FindByFid(ANewFieldControlSetting.fid);
      end;

      ANewFieldControlSetting.appid:=AppID;//1000;
      ANewFieldControlSetting.page_fid:=Self.fid;
      ANewFieldControlSetting.parent_control_fid:=0;
      if ANewFieldControlSetting.ParentFieldControlSetting<>nil then
      begin
        ANewFieldControlSetting.parent_control_fid:=ANewFieldControlSetting.ParentFieldControlSetting.fid;
        ANewFieldControlSetting.parent_control_name:=ANewFieldControlSetting.ParentFieldControlSetting.name;
      end;


      //判断是否需要提交上传图片,图片有没有改过,怎么判断?
      if SameText(ANewFieldControlSetting.control_type,'image') then
      begin
          if TSkinImage(ANewFieldControlSetting.SavedComponent).Prop.Picture.IsChanged then
          begin
              if FileExists(APageDataDir+'pics\'+ANewFieldControlSetting.value) then
              begin
                  //改过图片
                  //提交图片
                  if not DoUploadFile(APageDataDir+'pics\'+ANewFieldControlSetting.value,
                                     AImageHttpServerUrl,
                                     AAppID,
                                     'page_design',
                                     ARemoteFilePath,
                                     ADesc
                                     ) then
                  begin
                    Exit;
                  end;
                  ANewFieldControlSetting.value:=ARemoteFilePath;
              end;
          end;
      end;


      //将控件记录保存到Json
      AControlRecordJson:=TSuperObject.Create();

      if AOldFieldControlSetting<>nil then
      begin
          //看哪些字段需要更新
          ANewFieldControlSetting.SaveToUpdateJson(AControlRecordJson,
                                                    AOldFieldControlSetting,
                                                    AIsFieldControlSettingChanged);
      end
      else
      begin
          //添加
          ANewFieldControlSetting.SaveToJson(AControlRecordJson);
          AIsFieldControlSettingChanged:=True;
      end;

      if AIsFieldControlSettingChanged then
      begin
          if SaveRecordToServer(AInterfaceUrl,
                                AAppID,
                                '',
                                '',
                                'page_layout_control',
                                ANewFieldControlSetting.fid,
                                AControlRecordJson,
                                AIsAdd,
                                ADesc,
                                ADataJson,
                                '',
                                '') then
          begin
            //保存成功,要取出新增记录的fid
            if AIsAdd then
            begin
              ANeedAddFieldControlSettingList.Add(ANewFieldControlSetting);
              ANewFieldControlSetting.fid:=ADataJson.I['fid'];
            end;
          end
          else
          begin
    //        ShowMessage(ADesc);
            Exit;
          end;
      end;

  end;
//  Exit;










  Result:=True;
end;

{ TFieldControlSettingMapList }

function TFieldControlSettingMapList.AlignControls(AParentMarginsLeft:Double;AParentMarginsTop:Double): Boolean;
var
  I: Integer;
  ASkinItem:ISkinItem;
  AControlLayoutItem:TFieldControlSettingMap;
  AItemRect:TRectF;
begin
  Result:=False;


  if (LayoutSetting<>nil) and (LayoutSetting.align_type=Const_PageAlignType_Auto) then
  begin

      Self.BeginUpdate;
      try
          Self.FListLayoutsManager.ControlWidth:=GetControlParentWidth(Parent);
          Self.FListLayoutsManager.ControlHeight:=GetControlParentHeight(Parent);


          if Self.LayoutSetting.name=Const_PagePart_BottomToolbar then
          begin
              //底部工具栏

              //每个控件的宽度
      //        Self.FListLayoutsManager.ItemWidth:=LayoutSetting.ControlColWidth;
              if BiggerDouble(LayoutSetting.col_width,0) then
              begin
                //每个控件的宽度
                Self.FListLayoutsManager.ItemWidth:=ControlSize(LayoutSetting.col_width);
              end
              else
              begin
                //默认占宽页面的宽度
                Self.FListLayoutsManager.ItemWidth:=GetControlParentWidth(Parent);
              end;




              if BiggerDouble(LayoutSetting.row_height,0) then
              begin
                //每个控件的高度
                Self.FListLayoutsManager.ItemHeight:=ControlSize(LayoutSetting.row_height);
              end
              else
              begin
                //默认50
                Self.FListLayoutsManager.ItemHeight:=50;
              end;


              //每行的间隔
              if BiggerDouble(LayoutSetting.row_space,0) then
              begin
                Self.FListLayoutsManager.ItemSpace:=ControlSize(LayoutSetting.row_space);
              end
              else
              begin
                //默认没有间隔
                Self.FListLayoutsManager.ItemSpace:=15;
              end;



              Self.FListLayoutsManager.ViewType:=TListViewType.lvtIcon;

              //每行几个控件
              if BiggerDouble(LayoutSetting.col_count,0) then
              begin
                Self.FListLayoutsManager.ItemCountPerLine:=LayoutSetting.col_count;
              end
              else
              begin
                //默认一个
      //          Self.FListLayoutsManager.ItemCountPerLine:=2;
                Self.FListLayoutsManager.ItemCountPerLine:=1;
              end;


          end
          else
          begin

              //每个控件的宽度
      //        Self.FListLayoutsManager.ItemWidth:=LayoutSetting.ControlColWidth;
              if BiggerDouble(LayoutSetting.col_width,0) then
              begin
                //每个控件的宽度
                Self.FListLayoutsManager.ItemWidth:=ControlSize(LayoutSetting.col_width);
              end
              else
              begin
                //默认占宽页面的宽度
                Self.FListLayoutsManager.ItemWidth:=GetControlParentWidth(Parent);
              end;




              if BiggerDouble(LayoutSetting.row_height,0) then
              begin
                //每个控件的高度
                Self.FListLayoutsManager.ItemHeight:=ControlSize(LayoutSetting.row_height);
              end
              else
              begin
                //默认50
                Self.FListLayoutsManager.ItemHeight:=50;
              end;


              //每行的间隔
              if BiggerDouble(LayoutSetting.row_space,0) then
              begin
                Self.FListLayoutsManager.ItemSpace:=ControlSize(LayoutSetting.row_space);
              end
              else
              begin
                //默认没有间隔
                Self.FListLayoutsManager.ItemSpace:=0;
              end;



              Self.FListLayoutsManager.ViewType:=TListViewType.lvtIcon;

              //每行几个控件
              if BiggerDouble(LayoutSetting.col_count,0) then
              begin
                Self.FListLayoutsManager.ItemCountPerLine:=LayoutSetting.col_count;
              end
              else if IsSameDouble(LayoutSetting.col_count,-1) then
              begin
                Self.FListLayoutsManager.ItemCountPerLine:=-1;
              end
              else
              begin
                //默认一个
      //          Self.FListLayoutsManager.ItemCountPerLine:=2;
                Self.FListLayoutsManager.ItemCountPerLine:=1;
              end;

          end;

          Self.FListLayoutsManager.IsItemCountFitControl:=True;



      finally
        Self.EndUpdate();
      end;


      Self.FListLayoutsManager.DoItemSizeChange(nil,False);


      for I := 0 to Self.FListLayoutsManager.GetVisibleItemsCount-1 do
      begin
        ASkinItem:=Self.FListLayoutsManager.GetVisibleItem(I);
        AControlLayoutItem:=TFieldControlSettingMap(ASkinItem.GetObject);

        AItemRect:=ASkinItem.ItemRect;
        AItemRect.Left:=AItemRect.Left+AParentMarginsLeft;
        AItemRect.Right:=AItemRect.Right+AParentMarginsLeft;
        AItemRect.Top:=AItemRect.Top+AParentMarginsTop;
        AItemRect.Bottom:=AItemRect.Bottom+AParentMarginsTop;



        //设置控件的位置和尺寸
        AControlLayoutItem.AlignControl(AItemRect,LayoutSetting);
      end;

  end;

  Result:=True;

end;

procedure TFieldControlSettingMapList.ClearParent;
var
  I: Integer;
begin
  for I := 0 to Self.Count-1 do
  begin
    if (Self.Items[I].Component<>nil)
      and (Self.Items[I].Component is TControl) then
    begin
      TControl(Self.Items[I].Component).Parent:=nil;
    end;
  end;
end;

procedure TFieldControlSettingMapList.ClearValue;
var
  I: Integer;
//  AControlForPageFrameworkIntf:IControlForPageFramework;
begin
  for I := 0 to Self.Count-1 do
  begin
    if (Self.Items[I].Setting.field_name<>'') and (Self.Items[I].Setting.is_no_post=0) then
    begin

//      //清空
//      if Items[I].Component.GetInterface(IID_IControlForPageFramework,AControlForPageFrameworkIntf) then
//      begin
          //清空
//          AControlForPageFrameworkIntf
            SetFieldControlPostValue(Self.Items[I],'','','','',nil);
//      end;


      //自定义初始控件的事件
      if (PageInstance<>nil) and Assigned(PageInstance.FOnCustomClearFieldControl) then
      begin
        PageInstance.FOnCustomClearFieldControl(Self.Items[I].Component,Self.Items[I].Setting);
      end;
      
    end;
  end;
end;

constructor TFieldControlSettingMapList.Create(
  const AObjectOwnership: TObjectOwnership;
  const AIsCreateObjectChangeManager: Boolean);
begin
  inherited Create(AObjectOwnership,AIsCreateObjectChangeManager);

  //布局管理
  FListLayoutsManager:=TSkinListViewLayoutsManager.Create(Self);
  FListLayoutsManager.ItemSizeCalcType:=isctSeparate;//isctFixed;

end;

procedure TFieldControlSettingMapList.DelComponent(AComponent: TObject);
var
  AFieldControlSettingMap:TFieldControlSettingMap;
begin
  if AComponent is TChildControl then
  begin
    TChildControl(AComponent).Parent:=nil;
  end;

  AFieldControlSettingMap:=Self.FindByComponent(AComponent);
  //同时会释放控件
  Self.Remove(AFieldControlSettingMap);
end;

destructor TFieldControlSettingMapList.Destroy;
begin
  FreeAndNil(FListLayoutsManager);

  inherited;
end;

function TFieldControlSettingMapList.Find(AFieldName: String): TFieldControlSettingMap;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if SameText(Items[I].Setting.field_name,AFieldName) then
    begin
      Result:=Items[I];
      Break;
    end;
  end;

end;

function TFieldControlSettingMapList.FindByComponent(
  AComponent: TObject): TFieldControlSettingMap;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if (Items[I].Component=AComponent) then
    begin
      Result:=Items[I];
      Break;
    end;
  end;

end;

function TFieldControlSettingMapList.FindControlByFid(AFid: Integer): TComponent;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if (Items[I].Component<>nil) and (Items[I].Setting.fid=AFid) then
    begin
      Result:=Items[I].Component;
      Break;
    end;
  end;
end;

function TFieldControlSettingMapList.FindControlByName(AName: String): TComponent;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if (Items[I].Component<>nil) and SameText(Items[I].Setting.name,AName) then
    begin
      Result:=Items[I].Component;
      Break;
    end;
  end;

end;

function TFieldControlSettingMapList.GetItem(Index: Integer): TFieldControlSettingMap;
begin
  Result:=TFieldControlSettingMap(Inherited Items[Index]);
end;


//constructor TFieldControlSettingMapList.Create(const AObjectOwnership: TObjectOwnership;
//  const AIsCreateObjectChangeManager: Boolean);
//begin
//  inherited;
//
//  FListLayoutsManager:=TSkinListViewLayoutsManager.Create(Self);
//
//end;

//function TFieldControlSettingMapList.CreateFieldControls(
//  ALayoutParent: TControl;
//  APage: TPage): Boolean;
//var
//  I: Integer;
//  AControl:TControl;
//  AFieldControlSetting:TFieldControlSetting;
//  AFieldControl:TControlLayoutItem;
//begin
//  Result:=False;
//
//  LayoutParent:=ALayoutParent;
//  Page:=APage;
//
//
//
//
//  try
//
//    try
//
//          //先清除绑定
//          if ALayoutParent is TSkinItemDesignerPanel then
//          begin
//            TSkinItemDesignerPanel(ALayoutParent).Prop.Clear;
//          end;
//
//
//
//          //设置排列布局管理者
//          FListLayoutsManager.ViewType:=TListViewType.lvtIcon;
//          FListLayoutsManager.ItemCountPerLine:=APage.item_col_count;
//          FListLayoutsManager.StaticItemWidth:=APage.item_col_width;
//          FListLayoutsManager.StaticItemHeight:=APage.item_height;
//          //默认就设置成isctSeparate,避免用户使用上出现问题
//          FListLayoutsManager.StaticItemSizeCalcType:=isctSeparate;
//
//    //      FListLayoutsManager.OnItemPropChange:=DoItemPropChange;
//    //      FListLayoutsManager.OnItemSizeChange:=DoItemSizeChange;
//    //      FListLayoutsManager.OnItemVisibleChange:=DoItemVisibleChange;
//
//          FListLayoutsManager.ControlWidth:=ALayoutParent.Width;
//          FListLayoutsManager.ControlHeight:=ALayoutParent.Height;
//
//    //      FListLayoutsManager.OnSetSelectedItem:=Self.DoSetListLayoutsManagerSelectedItem;
//
//
//
//
//          //准备
//          APage.Prepare;
//
//
//          //不存在,则创建
//          for I := 0 to APage.FieldControlSettingList.Count-1 do
//          begin
//              AFieldControlSetting:=APage.FieldControlSettingList[I];
//
//              AFieldControl:=Self.FindItemBySettingFid(AFieldControlSetting.fid);
//              if (AFieldControl=nil) then
//              begin
//                AFieldControl:=TControlLayoutItem.Create(Self);
//                AFieldControl.Setting:=AFieldControlSetting;
//                Self.Add(AFieldControl);
//              end;
//          end;
//
//
//          //存在,则更新
//          for I := 0 to Self.Count-1 do
//          begin
//            if Not Items[I].Sync(ALayoutParent) then
//            begin
//              //更新失败
//              Exit;
//            end;
//          end;
//
//
//          //不存在,则删除
//          for I := Self.Count-1 downto 0 do
//          begin
//            if APage.FieldControlSettingList.IndexOf(
//                Self.Items[I].Setting
//                )=-1 then
//            begin
//              Self.Delete(I);
//            end;
//          end;
//
//
//          Self.Sort(SortFieldControlByOrderNo_Compare);
//
//
//
//          //设置绑定
//          if ALayoutParent is TSkinItemDesignerPanel then
//          begin
//            for I := 0 to Self.Count-1 do
//            begin
//              if Items[I].Setting.bind_listitem_data_type<>'' then
//              begin
//                //需要绑定
//                TSkinItemDesignerPanel(ALayoutParent).Prop.BindControl(
//                    Items[I].Setting.bind_listitem_data_type,
//                    Items[I].Setting.BindSubItemsIndex,
//                    Items[I].Control
//                    );
//              end;
//            end;
//          end;
//
//
//
//          Result:=True;
//
//    except
//      on E:Exception do
//      begin
//        uBaseLog.HandleException(E,'TControlLayoutManager.CreateFieldControls');
//      end;
//    end;
//  finally
//    Self.GetListLayoutsManager.DoItemVisibleChange(nil,False);
//    Self.GetListLayoutsManager.DoItemPropChange(nil);
//  end;
//
//
//  //排列位置
//  AlignControls(ALayoutParent,APage);
//
//
//end;
//
//
//destructor TFieldControlSettingMapList.Destroy;
//begin
//  FreeAndNil(FListLayoutsManager);
//  inherited;
//end;

procedure TFieldControlSettingMapList.DoChange;
begin
  inherited;

  if //Not IsLoading
    //and
    (FSkinObjectChangeManager<>nil)
    and not FSkinObjectChangeManager.IsDestroy then
  begin
    if (ictAdd in Self.FLastItemChangeTypes)
      or (ictDel in Self.FLastItemChangeTypes) then
    begin
      if GetListLayoutsManager<>nil then
      begin
        Self.GetListLayoutsManager.DoItemVisibleChange(nil);
      end;
    end;
  end;

end;

procedure TFieldControlSettingMapList.EndUpdate(AIsForce: Boolean);
begin

  inherited EndUpdate(AIsForce);

  //判断列表项是否改变过大小再调用
  //万一有Item的Visible更改过了,也需要调用的
  if GetListLayoutsManager<>nil then
  begin
    Self.GetListLayoutsManager.DoItemVisibleChange(nil,True);
    Self.GetListLayoutsManager.DoItemPropChange(nil);
  end;

end;

//function TFieldControlSettingMapList.FindItemBySettingFid(ASettingFid: Integer): TControlLayoutItem;
//var
//  I: Integer;
//begin
//  Result:=nil;
//  for I := 0 to Self.Count-1 do
//  begin
//    if Items[I].Setting.fid=ASettingFid then
//    begin
//      Result:=Items[I];
//      Break;
//    end;
//  end;
//end;
//
//function TFieldControlSettingMapList.GetItem(Index: Integer): TControlLayoutItem;
//begin
//  Result:=TControlLayoutItem(Inherited Items[Index]);
//end;

function TFieldControlSettingMapList.GetListLayoutsManager: TSkinListLayoutsManager;
begin
  Result:=FListLayoutsManager;
end;

function TFieldControlSettingMapList.GetObject: TObject;
begin
  Result:=Self;
end;

function TFieldControlSettingMapList.GetSkinItem(const Index: Integer): ISkinItem;
begin
  Result:=Items[Index] as ISkinItem;
end;

function TFieldControlSettingMapList.GetSkinObject(const Index: Integer): TObject;
begin
  Result:=Items[Index];
end;

function TFieldControlSettingMapList.GetUpdateCount: Integer;
begin
  Result:=0;
  if (Self.FSkinObjectChangeManager<>nil) then
  begin
    Result:=Self.FSkinObjectChangeManager.UpdateCount;
  end;
end;

procedure TFieldControlSettingMapList.SetListLayoutsManager(ALayoutsManager: TSkinListLayoutsManager);
begin
  FListLayoutsManager:=TSkinListViewLayoutsManager(ALayoutsManager);
end;


procedure TFieldControlSettingMapList.SetReadOnly(AReadOnly: Boolean);
var
  I: Integer;
//  AControlForPageFrameworkIntf:IControlForPageFramework;
begin
  for I := 0 to Self.Count-1 do
  begin
    if (Self.Items[I].Component is TEdit) then
    begin
      TEdit(Self.Items[I].Component).ReadOnly:=AReadOnly;
    end
    else if (Self.Items[I].Component is TMemo) then
    begin
      TMemo(Self.Items[I].Component).ReadOnly:=AReadOnly;
    end
    else if (Self.Items[I].Component is TComboBox) then
    begin
      TComboBox(Self.Items[I].Component).Enabled:=not AReadOnly;
    end
    else if (Self.Items[I].Component is TCheckBox) then
    begin
      TCheckBox(Self.Items[I].Component).Enabled:=not AReadOnly;
    end
    else if (Self.Items[I].PageFrameworkControlIntf<>nil) then
    begin
      Self.Items[I].PageFrameworkControlIntf.SetProp('ReadOnly',AReadOnly);
    end;
    ;
  end;

end;

{ TPageInstance }

//function TPageInstance.AlignControls(AParentMarginsLeft:Double;AParentMarginsTop:Double): Boolean;
//begin
//  //主控件映射列表
//  MainControlMapList.AlignControls(AParentMarginsLeft,AParentMarginsTop);
//  //底部栏控件映射列表
//  BottomToolbarControlMapList.AlignControls(AParentMarginsLeft,AParentMarginsTop);
//end;

procedure TPageInstance.AddSkinItemToListControl(
  ASkinVirtualList: TSkinVirtualList;
  ASuperObject: ISuperObject;
  AValueObject:TObject);
var
  J:Integer;
  ASkinItem:TSkinItem;
  AValue:Variant;
begin
  if ASuperObject<>nil then
  begin
      if (Self.PageStructure.FDefaultListItemBindings.Count=0) then
      begin


            //设有设置Item属性与字段的对应,那就是使用JsonSkinItem
            ASkinItem:=TSkinPageStructureJsonItem.Create;
            TSkinPageStructureJsonItem(ASkinItem).Json:=ASuperObject;
            ASkinVirtualList.Prop.Items.Add(ASkinItem);


      end
      else
      begin


            ASkinItem:=TSkinItem(ASkinVirtualList.Prop.Items.Add);
            ASkinItem.Json:=ASuperObject;

            //会不会慢
            for J := 0 to Self.PageStructure.FDefaultListItemBindings.Count-1 do
            begin
              AValue:=ASuperObject.V[Self.PageStructure.FDefaultListItemBindings[J].data_field_name];

              if AValue=Null then
              begin
                AValue:='';
              end;

              ASkinItem.SetValueByBindItemField(
                                                Self.PageStructure.FDefaultListItemBindings[J].item_field_name,
                                                AValue,
                                                Self.PageStructure.GetPageDataDir,
                                                GlobalMainProgramSetting.DataIntfImageUrl
                                                );
            end;

      end;
  end;

  if (AValueObject<>nil) and (AValueObject is TBaseSkinItem) then
  begin
      if AValueObject is TSkinPageStructureJsonItem then
      begin
        ASkinItem:=TSkinPageStructureJsonItem.Create;
        ASkinItem.Assign(TSkinItem(AValueObject));
        ASkinVirtualList.Prop.Items.Add(ASkinItem);
      end
      else
      begin
        //直接赋值
        ASkinItem:=TSkinItem(ASkinVirtualList.Prop.Items.Add);
        ASkinItem.Assign(TSkinItem(AValueObject));
        ASkinItem.Json:=TSkinItem(AValueObject).Json;
      end;

  end;

end;

procedure TPageInstance.BeginAddRecord;
begin
  Self.FLoadDataSetting.IsAddRecord:=True;
  Self.MainControlMapList.ClearValue;

end;

procedure TPageInstance.BeginEditRecord;
begin
  //编辑记录
  Self.FLoadDataSetting.IsAddRecord:=False;
  Self.FLoadDataSetting.IsEditRecord:=True;

//  Self.FPageInstance.MainControlMapList.ClearValue;

end;

function TPageInstance.CallDelDataInterface: Boolean;
begin

end;

procedure TPageInstance.CancelAddRecord;
begin
  Self.FLoadDataSetting.IsAddRecord:=False;
  Self.MainControlMapList.ClearValue;

end;

procedure TPageInstance.CancelEditRecord;
begin
  Self.FLoadDataSetting.IsEditRecord:=False;
  Self.MainControlMapList.ClearValue;
  Self.LoadDataIntfResultToControls(Self.FLoadDataIntfResult,Self.FLoadDataIntfResult2)

end;

procedure TPageInstance.DoSaveRecordTimerTaskExecute(ATimerTask: TObject);
var
//  AIsSucc:Boolean;
//
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;

  I:Integer;
  AError:String;
//  AIsAdd:Boolean;
  ARecordDataJson:ISuperObject;
//  AControlForPageFrameworkIntf:IControlForPageFramework;
//  AValue:Variant;
//  AValueStr:String;
//  AOldValueStr:String;
//  ASaveDataSetting:TSaveDataSetting;
//  ASetJsonRecordFieldValueIntf:ISetRecordFieldValue;
begin
  //出错
  TTimerTask(ATimerTask).TaskTag:=TASK_FAIL;
  try

      //提交数据到服务器
    //  AIsSucc:=Self.PostToServer(PageDataDir,ACode,ADesc,ADataJson);

    //  Result:=False;

      //在外面初始好了,不用再在里面初始了
//      ACode:=FAIL;
//      ADesc:='';
//      ADataJson:=nil;


//      if SameText(Self.PageStructure.DataInterface.intf_type,Const_IntfType_TableCommonRest) then
//      begin
//        Result:=Self.DoPostToTableCommonRestAddRecord(
//                        APageDataDir,
//                        ACode,
//                        ADesc,
//                        ADataJson);

//          if not SimpleCallAPI('add_record',
//                                nil,
//                                Self.PageStructure.DataServer.ServerUrl+'tablecommonrest/',
//                                ['appid',
//                                'user_fid',
//                                'key',
//                                'rest_name',
//                                'record_data_json'],
//                                [AppID,
//                                UserFID,
//                                Key,
//                                Self.PageStructure.DataInterface.TableCommonRestName,
//                                Self.GetPostDataJson.AsJSON],
//                                ACode,
//                                ADesc,
//                                ADataJson) then
//          begin
//            Exit;
//          end;


//          ARecordDataJson:=TSuperObject.Create();
//          ASetJsonRecordFieldValueIntf:=TSetJsonRecordFieldValue.Create(ARecordDataJson);
//
//          AError:='';
//          for I := 0 to Self.MainControlMapList.Count-1 do
//          begin
////            if MainControlMapList[I].Component.GetInterface(IID_IControlForPageFramework,AControlForPageFrameworkIntf) then
////            begin
//              AValue:=//AControlForPageFrameworkIntf
//                  MainControlMapList[I].PageFrameworkControlIntf.GetPostValue(MainControlMapList[I].Setting,
//                      Self.PageStructure.GetPageDataDir,
//                      ASetJsonRecordFieldValueIntf,
//                      AError);
//
//
//              if AError<>'' then
//              begin
//                TTimerTask(ATimerTask).TaskDesc:=AError;
//                Exit;
//              end;
//
//
//
//              //要转换成字符串,这样好比较,不然会报错
//              AValueStr:=AValue;
//              if not FLoadDataSetting.IsAddRecord then
//              begin
//                AOldValueStr:=Self.FLoadDataIntfResult.DataJson.V[MainControlMapList[I].Setting.field_name];
//              end;
//
//
//
//              if
//                //添加时,所有需要提交
//                FLoadDataSetting.IsAddRecord
//                //修改时,没有改过就不用提交
//                or (AOldValueStr<>AValueStr) then
//              begin
//                ARecordDataJson.V[MainControlMapList[I].Setting.field_name]:=AValue;
//              end;
//
////            end;
//          end;

          FSaveDataIntfResult.Clear;


          AError:='';
          ARecordDataJson:=GetPostDataJson(Self.PageStructure.GetPageDataDir,
                                          Self.FLoadDataSetting.IsAddRecord,
                                          AError);
          if AError<>'' then
          begin
            TTimerTask(ATimerTask).TaskDesc:=AError;
            Exit;
          end;
          //如果需要提交的数据为空,怎么办？
          if ARecordDataJson.AsJSON='{}' then
          begin
            TTimerTask(ATimerTask).TaskTag:=TASK_SUCC;
            Exit;
          end;



          FSaveDataSetting.Clear;
          FSaveDataSetting.AppID:=GlobalMainProgramSetting.AppID;
          if not FLoadDataSetting.IsAddRecord then
          begin
            //不一定都是从DataSet中获取的,不一定主键都是fid
            FSaveDataSetting.EditingRecordFID:=Self.FLoadDataIntfResult.DataJson.I['fid'];
          end;
          FSaveDataSetting.RecordDataJson:=ARecordDataJson;
//          FSaveDataSetting.IsAddRecord:=Self.FLoadDataSetting.IsAddRecord;//AIsAdd;


          if Assigned(Self.PageStructure.OnCustomCallSaveDataIntf) then
          begin
              Self.PageStructure.OnCustomCallSaveDataIntf(Self,
                                                                Self,
                                                                FSaveDataSetting,
                                                                FSaveDataIntfResult
                                                                );
              if FSaveDataIntfResult.Succ then
              begin
                  TTimerTask(ATimerTask).TaskTag:=TASK_SUCC;
              end;
            
          end
          else
          begin
          
              //将接口保存到数据库
              if Self.PageStructure.DataInterface.SaveData(FSaveDataSetting,Self.FSaveDataIntfResult) then
    //          SaveRecordToServer(GlobalMainProgramSetting.DataServerUrl,
    //                                GlobalMainProgramSetting.AppID,
    //                                0,
    //                                '',
    //                                Self.PageStructure.DataInterface.Name,
    //                                Self.FLoadDataIntfResult.DataJson.I['fid'],
    //                                ARecordDataJson,
    //                                AIsAdd,
    //                                ADesc,
    //                                ADataJson)
    //
    //                                then
              begin
    //              //保存成功,要取出新增记录的fid
    //              if AIsAdd then
    //              begin
    //                FPage.DataInterface.fid:=ADataJson.I['fid'];
    //              end;
                  TTimerTask(ATimerTask).TaskDesc:=FSaveDataIntfResult.Desc;
                  TTimerTask(ATimerTask).TaskTag:=TASK_SUCC;
              end
              else
              begin
            //      ShowMessage(ADesc);
                  TTimerTask(ATimerTask).TaskDesc:=FSaveDataIntfResult.Desc;
                  Exit;
              end;

          end;
//      end
//      else
//      begin
//        ADesc:='不支持该接口类型';
//      end;





//      if FLoadDataIntfResult.Succ then
//      begin
//        TTimerTask(ATimerTask).TaskTag:=TASK_SUCC;
//      end;


  except
    on E:Exception do
    begin
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
      uBaseLog.HandleException(E,'TPageInstance.DoSaveRecordTimerTaskExecute');
    end;
  end;
end;


procedure TPageInstance.DoSaveRecordTimerTaskExecuteEnd(ATimerTask: TObject);
begin

  try

      if TTimerTask(ATimerTask).TaskTag=TASK_SUCC then
      begin

          {$IFDEF FMX}
          ShowHintFrame(nil,Trans('保存成功'));
          {$ENDIF FMX}


          //保存记录之后,要刷新界面
          if Assigned(FOnAfterSaveRecord) then
          begin
            FOnAfterSaveRecord(Self);
          end;

          Self.FLoadDataSetting.IsAddRecord:=False;
          Self.FLoadDataSetting.IsEditRecord:=False;


          DoReturnPageAction(Self);



//          //保存后处理
//          if Assigned(FOnSaveRecordSucc) then
//          begin
//            FOnSaveRecordSucc(Self);
//          end;

      end
      else
      begin
          //网络异常
          {$IFDEF FMX}
          ShowMessageBoxFrame(nil,TTimerTask(ATimerTask).TaskDesc,'');//,TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
          {$ENDIF}

          {$IFDEF VCL}
          ShowMessage(TTimerTask(ATimerTask).TaskDesc);
          {$ENDIF}

      end;
  finally
    {$IFDEF FMX}
    HideWaitingFrame;
    {$ENDIF}

  end;




//  TThread.Synchronize(nil,procedure
//  begin
//      try
//          if AIsSucc then
//          begin
//              //将数据传递给UI
////              if SaveRecordMessageBox=nil then
////              begin
////                SaveRecordMessageBox:=TSkinMessageBox.Create(nil);
////              end;
////              SaveRecordMessageBox.Msg:=Trans('保存成功');
////              SaveRecordMessageBox.ButtonCaptions:=Trans('确定');
//
//              //ShowMessageBoxFrame(nil,Trans('保存成功'),'',);
//              ShowHintFrame(nil,Trans('保存成功'));
//              DoReturnPageAction;
//          end
//          else
//          begin
//              //网络异常或接口调用失败
//              ShowMessageBoxFrame(nil,ADesc,'');
//          end;
//      finally
//        HideWaitingFrame;
//      end;
//
//  end);
end;


constructor TPageInstance.Create;//(AOwner:TComponent);
begin
//  Inherited;


  //控件映射列表
  MainControlMapList:=TFieldControlSettingMapList.Create();
  MainControlMapList.PageInstance:=Self;

  //底部栏控件映射列表
  BottomToolbarControlMapList:=TFieldControlSettingMapList.Create;
  BottomToolbarControlMapList.PageInstance:=Self;




  FLoadDataTimerTaskEvent:=TTimerTaskEvent.Create(nil);
  FLoadDataTimerTaskEvent.TaskName:='PageInstance.LoadDataTask';
  FLoadDataTimerTaskEvent.OnBegin:=Self.DoLoadDataTaskExecuteBegin;
  FLoadDataTimerTaskEvent.OnExecute:=Self.DoLoadDataTaskExecute;
  FLoadDataTimerTaskEvent.OnExecuteEnd:=Self.DoLoadDataTaskExecuteEnd;



  FDelDataTimerTaskEvent:=TTimerTaskEvent.Create(nil);
  FDelDataTimerTaskEvent.TaskName:='PageInstance.DelDataTask';
  FDelDataTimerTaskEvent.OnBegin:=Self.DoDelDataTaskExecuteBegin;
  FDelDataTimerTaskEvent.OnExecute:=Self.DoDelDataTaskExecute;
  FDelDataTimerTaskEvent.OnExecuteEnd:=Self.DoDelDataTaskExecuteEnd;



  FLoadDataIntfResult:=TDataIntfResult.Create;

  FLoadDataIntfResult2:=TDataIntfResult.Create;

  FIsNeedLoadDataIntfResultToControls:=True;


  FDelDataIntfResult:=TDataIntfResult.Create;

  FSaveDataIntfResult:=TDataIntfResult.Create;

  FLoadDataSetting:=TLoadDataSetting.Create;
  FLoadDataSetting.AppID:=GlobalMainProgramSetting.AppID;

end;

function TPageInstance.CreateControls(
                                      AOwner:TComponent;
                                      AParent: TParentControl;
                                      AFilterPagePart:String;
                                      //保存图片的根相对目录
                                      APageDataDir:String;
                                      AIsDesignTime:Boolean;
                                      var AError:String;
                                      AIsControlTypeMustExists:Boolean): Boolean;
begin

  if SameText(AFilterPagePart,Const_PagePart_Main) then
  begin
      //如果是列表页面,而且是默认的


      //创建主控件列表
      Result:=DoCreateControls(
                              AOwner,
                              AParent,
                              Self.PageStructure.MainLayoutSetting,
                              Self.PageStructure.MainLayoutControlList,
                              AFilterPagePart,
                              APageDataDir,
                              AIsDesignTime,
                              Self.DoPageFrameCustomInitFieldControl,
                              Self.MainControlMapList,
                              AError,
                              AIsControlTypeMustExists);
//      MainControlMapList.AlignControls;


  end
  else if SameText(AFilterPagePart,Const_PagePart_BottomToolbar) then
  begin
      //创建底部工具栏列表
      Result:=DoCreateControls(
                                AOwner,
                                AParent,
                                Self.PageStructure.BottomToolbarLayoutSetting,
                                Self.PageStructure.BottomToolbarLayoutControlList,
                                AFilterPagePart,
                                APageDataDir,
                                AIsDesignTime,
                                Self.DoPageFrameCustomInitFieldControl,
                                Self.BottomToolbarControlMapList,
                                AError,
                                AIsControlTypeMustExists);
//      BottomToolbarControlMapList.AlignControls;
  end;

end;

destructor TPageInstance.Destroy;
begin
  FreeAndNil(FRefreshTimer);


//  FreeAndNil(SaveRecordMessageBox);


  MainControlMapList.ClearParent;
  BottomToolbarControlMapList.ClearParent;

  FreeAndNil(MainControlMapList);
  FreeAndNil(BottomToolbarControlMapList);

  FreeAndNil(FLoadDataTimerTaskEvent);

  FreeAndNil(FDelDataTimerTaskEvent);


  FreeAndNil(FDelDataIntfResult);

  FreeAndNil(FLoadDataIntfResult);
  FreeAndNil(FLoadDataIntfResult2);

  FreeAndNil(FSaveDataIntfResult);

  FreeAndNil(FLoadDataSetting);


//  FGetDataIntfResultFieldValue:=nil;

  inherited;
end;

procedure TPageInstance.DoLoadDataTaskExecute(ATimerTask: TTimerTask);
begin
  ATimerTask.TaskTag:=TASK_FAIL;
  try
      FLoadDataIntfResult.Clear;
      FLoadDataIntfResult2.Clear;


      if Assigned(Self.PageStructure.OnCustomCallLoadDataIntf) then
      begin
          //自定义调用接口
          Self.PageStructure.OnCustomCallLoadDataIntf(Self,
                                                      Self,
                                                      FLoadDataSetting,
                                                      FLoadDataIntfResult
                                                      );
      end
      else
      begin
          //调用接口
          if (PageStructure.DataInterface<>nil) and not PageStructure.DataInterface.IsEmpty then
          begin
              CallLoadDataIntf(PageStructure,
                              PageStructure.DataInterface,
                              Self.FLoadDataIntfResult,
                              Self.FLoadDataSetting,
                              //加入,合并,WhereKeyJson
                              Self.PageStructure.load_data_params
                              );
          end
          else
          begin
              FLoadDataIntfResult.Desc:='接口为空!';
              uBaseLog.HandleException(nil,'TPageInstance.DoLoadDataTaskExecute 接口1为空');
          end;
      end;




      //调用接口2
      if (PageStructure.DataInterface2<>nil) and (not PageStructure.DataInterface2.IsEmpty) then
      begin
          CallLoadDataIntf(PageStructure,
                                PageStructure.DataInterface2,
                                Self.FLoadDataIntfResult2,
                                Self.FLoadDataSetting,

                                //加入,合并,加入WhereKeyJson
                                Self.PageStructure.load_data_params2
                                );
      end
      else
      begin
          uBaseLog.HandleException(nil,'TPageInstance.DoLoadDataTaskExecute 接口2为空');
      end;



      //如果是编辑页面,那么要获取下拉框的选项值
      //将options_page_value_field_name,options_page_caption_field_name
      //的值取出来,放入options_value,options_caption
      //options_caption	nvarchar(255)	选项的标题,用于显示,比如男,女
      //options_value	nvarchar(255)	选项的值,用于保存到数据,比如male,female
      //options_is_multi_select	int	是否支持多选
      //
      //options_page_fid	int	选择选项的列表页面fid,它里面包含数据接口
      //options_page_value_field_name	nvarchar(45)	选择选项列表页面的值字段
      //options_page_caption_field_name	nvarchar(45)	选择选项列表页面的标题字段
      //options_has_empty	int	是否拥有空的选项
      //options_empty_value	nvarchar(45)
      //options_empty_caption	nvarchar(45)
      //获取页面结构,然后获取页面数据列表
//      for I := 0 to Self.PageStructure.MainLayoutControlList.Count-1 do
//      begin
//        if Self.PageStructure.MainLayoutControlList[I].options_page_fid>0 then
//        begin
//          //需要取页面的数据
//
//        end;
//      end;


      ATimerTask.TaskDesc:=Self.FLoadDataIntfResult.Desc;


      if FLoadDataIntfResult.Succ then
      begin
        ATimerTask.TaskTag:=TASK_SUCC;
      end;


  except
    on E:Exception do
    begin
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
      uBaseLog.HandleException(E,'TPageInstance.DoLoadDataTaskExecute');
    end;
  end;
end;

procedure TPageInstance.DoLoadDataTaskExecuteBegin(ATimerTask: TTimerTask);
begin
//  GlobalShowWaiting(CurrentFrame,'加载中...');
end;

procedure TPageInstance.DoLoadDataTaskExecuteEnd(ATimerTask: TTimerTask);
begin
  try

      if TTimerTask(ATimerTask).TaskTag=TASK_SUCC then
      begin
          //调用成功,加载数据到界面
          if FIsNeedLoadDataIntfResultToControls then
          begin
            Self.LoadDataIntfResultToControls(Self.FLoadDataIntfResult,
                                              Self.FLoadDataIntfResult2);
          end;


      end
      else
      begin
          //网络异常
//          ShowMessageBoxFrame(nil,TTimerTask(ATimerTask).TaskDesc,'');//,TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);

          uBaseLog.HandleException(nil,'TPageInstance.DoLoadDataTaskExecuteEnd '+TTimerTask(ATimerTask).TaskDesc);
          {$IFDEF FMX}
          ShowHintFrame(nil,TTimerTask(ATimerTask).TaskDesc);//,TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
          {$ENDIF}



      end;

      //自定义数据加载结束事件
      if Assigned(OnLoadDataTaskEnd) then
      begin
        OnLoadDataTaskEnd(Self,Self,Self.FLoadDataIntfResult,
                                            Self.FLoadDataIntfResult2);
      end;



  finally
//    HideWaitingFrame;
  end;



  if Self.PageStructure.refresh_seconds>0 then
  begin
      if FRefreshTimer=nil then
      begin
        FRefreshTimer:=TTimer.Create(nil);
        FRefreshTimer.OnTimer:=Self.DoRefreshTimer;
        FRefreshTimer.Interval:=Self.PageStructure.refresh_seconds*1000;
      end;
      //定时刷新
      if FRefreshTimer<>nil then
      begin
        Self.FRefreshTimer.Enabled:=True;
      end;
  end;


end;


procedure TPageInstance.DoDelDataTaskExecute(ATimerTask: TTimerTask);
begin
  ATimerTask.TaskTag:=TASK_FAIL;
  try
      FDelDataIntfResult.Clear;
//      FDelDataIntfResult2.Clear;


      //调用接口
      if not PageStructure.DataInterface.IsEmpty then
      begin
        CallDelDataInterface();

//          PageStructure.DataInterface.DelData(
//                            Self.FLoadDataIntfResult,
//                            FDelDataIntfResult
//                            );
//          CallLoadDataIntf(PageStructure,
//                                  PageStructure.DataInterface,
//                                  Self.FDelDataIntfResult,
//                                  Self.FDelDataSetting,
//                                  Self.PageStructure.load_data_params
//                                  );
      end
      else
      begin
          FDelDataIntfResult.Desc:='接口为空!';
          uBaseLog.HandleException(nil,'TPageInstance.DoDelDataTaskExecute 接口1为空');
      end;


//      //调用接口
//      if (PageStructure.DataInterface2<>nil) and (not PageStructure.DataInterface2.IsEmpty) then
//      begin
//          CallDelDataInterface(PageStructure,
//                                  PageStructure.DataInterface2,
//                                  Self.FDelDataIntfResult2,
//                                  Self.FDelDataSetting,
//                                  Self.PageStructure.load_data_params2
//                                  );
//      end
//      else
//      begin
//          uBaseLog.HandleException(nil,'TPageInstance.DoDelDataTaskExecute 接口2为空');
//      end;



      ATimerTask.TaskDesc:=Self.FDelDataIntfResult.Desc;

      if FDelDataIntfResult.Succ then
      begin
        ATimerTask.TaskTag:=TASK_SUCC;
      end;


  except
    on E:Exception do
    begin
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
      uBaseLog.HandleException(E,'TPageInstance.DoDelDataTaskExecute');
    end;
  end;
end;

procedure TPageInstance.DoDelDataTaskExecuteBegin(ATimerTask: TTimerTask);
begin
//  GlobalShowWaiting(CurrentFrame,'加载中...');
end;

procedure TPageInstance.DoDelDataTaskExecuteEnd(ATimerTask: TTimerTask);
begin
  try

      if TTimerTask(ATimerTask).TaskTag=TASK_SUCC then
      begin

        //删除了数据
        Self.FLoadDataSetting.IsDelRecord:=True;

        //返回到上一页
        Self.DoReturnPageAction(Self);

  //        if then
  //        begin
  //
  //
  //        end
  //        else
  //        begin
  //            ShowMessageBoxFrame(nil,'返回的数据格式不匹配!','');
  //        end;


      end
      else
      begin
          //网络异常
//          ShowMessageBoxFrame(nil,TTimerTask(ATimerTask).TaskDesc,'');//,TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);

          uBaseLog.HandleException(nil,'TPageInstance.DoDelDataTaskExecuteEnd '+TTimerTask(ATimerTask).TaskDesc);
          {$IFDEF FMX}
          ShowHintFrame(nil,TTimerTask(ATimerTask).TaskDesc);//,TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
          {$ENDIF}



      end;
  finally
//    HideWaitingFrame;
  end;
end;


{$IFDEF VCL}
type
  TProtectedParentControl=class(TParentControl)
  end;
{$ENDIF}



procedure TPageInstance.DoPageFrameCustomInitFieldControl(AControl: TComponent;
  AFieldControlSetting: TFieldControlSetting);
begin
  {$IFDEF FMX}
  if AControl is TControl then
  begin
    TControl(AControl).OnClick:=Self.DoFieldControlClick;
  end;
  {$ENDIF}

  {$IFDEF VCL}
  if AControl is TParentControl then
  begin
    TProtectedParentControl(AControl).OnClick:=Self.DoFieldControlClick;
  end;
  {$ENDIF}

  if Assigned(FOnCustomInitFieldControl) then
  begin
    FOnCustomInitFieldControl(AControl,AFieldControlSetting);
  end;

end;

procedure TPageInstance.DoPageLayoutControlClick(Sender: TObject;APageLayoutControlMap: TFieldControlSettingMap);
//var
//  AIsProcessed:Boolean;
//var
//  ACode:Integer;
//  ADesc:String;
//  ADataJson:ISuperObject;
begin
//
//  AIsProcessed:=False;
//
//  if Assigned(Self.FOnControlClick) then
//  begin
//    FOnControlClick(Sender,Self,APageLayoutControlMap,AIsProcessed);
//  end;
//
//
//  //事件没有被用户处理过,那么处理预定义的事件
//  if Not AIsProcessed then
//  begin
//      if APageLayoutControlMap.Setting.Action<>'' then
//      begin
//          //处理自定义的事件
//
//          if SameText(APageLayoutControlMap.Setting.Action,Const_PageAction_SaveRecord) then
//          begin
//              //保存
//              DoSaveRecordAction;
//          end
//          else
//          if SameText(APageLayoutControlMap.Setting.Action,Const_PageAction_CancelSaveRecord) then
//          begin
//              //取消保存
//              Self.DoReturnPageAction;
//          end
//          else
//          begin
//              raise Exception.Create('TPageInstance.DoFieldControlClick 不支持此动作'+APageLayoutControlMap.Setting.Action);
//          end;
//
//      end;
//  end;
end;

//function TPageInstance.DoPostToTableCommonRestAddRecord(
//  APageDataDir:String;
//  var ACode: Integer;
//  var ADesc: String;
//  var ADataJson: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  //在外面初始好了,不用再在里面初始了
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//  if not SameText(Self.PageStructure.DataInterface.intf_type,
//                  Const_IntfType_TableCommonRest) then
//  begin
//    ADesc:=Trans('不是TableCommonRest的接口类型');
//    Exit;
//  end;
//
//
//  if not SimpleCallAPI('add_record',
//                        nil,
//                        GlobalMainProgramSetting.DataServerUrl+'tablecommonrest/',
//                        ['appid',
//                        'user_fid',
//                        'key',
//                        'rest_name',
//                        'record_data_json'],
//                        [AppID,
//                        UserFID,
//                        Key,
//                        Self.PageStructure.DataInterface.name,//table_common_rest_name,
//                        Self.GetPostDataJson(APageDataDir).AsJSON],
//                        ACode,
//                        ADesc,
//                        ADataJson) then
//  begin
//    Exit;
//  end;
//
//
//  Result:=True;
//
//end;

procedure TPageInstance.DoRefreshTimer(Sender: TObject);
begin
  Self.FRefreshTimer.Enabled:=False;

  Self.LoadData();
end;

procedure TPageInstance.DoReturnFrameFromEditPageFrame(AFrame: TFrame);
begin

end;

procedure TPageInstance.DoReturnPageAction(AFromPageInstance:TPageInstance);
begin
  //自定义返回的事件
  if Assigned(GlobalMainProgramSetting.OnNeedReturnPage) then
  begin
    GlobalMainProgramSetting.OnNeedReturnPage(Self,AFromPageInstance);
  end
  else
  begin
    {$IFDEF FMX}
    HideFrame;
    ReturnFrame;
    {$ENDIF}


  end;

//  if Owner is TFrame then
//  begin
//    DoHideFrame(TFrame(Owner));
//    //返回上一页
//    DoReturnFrame(TFrame(Owner));
//  end;
end;

procedure TPageInstance.DoSaveRecordAction(AIsNeedStartThread:Boolean);
var
  ATimerTask:TTimerTask;
begin
  //判断值是否符合条件
  if AIsNeedStartThread then
  begin

      {$IFDEF FMX}
      GlobalShowWaiting(nil,'保存中...');
      {$ENDIF FMX}
      //启动线程
      GetGlobalTimerThread.RunTempTask(
                DoSaveRecordTimerTaskExecute,
                DoSaveRecordTimerTaskExecuteEnd,
                'PageInstance.SaveRecord'
                );
  end
  else
  begin
      ATimerTask:=TTimerTask.Create();
      try
        ATimerTask.TaskName:='PageInstance.SaveRecord';
        DoSaveRecordTimerTaskExecute(ATimerTask);
        DoSaveRecordTimerTaskExecuteEnd(ATimerTask);
      finally
        FreeAndNil(ATimerTask);
      end;

  end;

end;

//procedure TPageInstance.DoSaveRecordSuccMessageBoxModalResult(AMessageBoxFrame: TFrame);
//begin
//
//end;


//根据字段名从接口的返回中获取数据
//可能有多级的情况,比如DataJson.Summary.I['SumCount']
//AFieldNameList,$data_intf,Summary,SumCount
function GetDataIntfFieldValue(AFieldName:String;
                               ADataIntfResult:TDataIntfResult;
                               AFieldNameNodeList:TStringList;
                               var AValueObject:TObject):Variant;
var
  I: Integer;
  ADataJson:ISuperObject;
begin

  case ADataIntfResult.DataType of
    ldtNone: ;
    ldtJson:
    begin
        //Json格式的数据
        ADataJson:=ADataIntfResult.DataJson;
        for I := 1 to AFieldNameNodeList.Count-2 do
        begin
          ADataJson:=ADataJson.O[AFieldNameNodeList[I]];
        end;
        Result:=ADataJson.V[AFieldNameNodeList[AFieldNameNodeList.Count-1]];
    end;
    ldtSkinItems:
    begin
        AValueObject:=ADataIntfResult.DataSkinItems;
    end;
  end;

end;


//获取变量值
function GetPageFrameworkVariableValue(AVariableName:String):Variant;
begin
  {$IFDEF FMX}
  if AVariableName.Substring(0,1)='$' then
  {$ENDIF}
  {$IFDEF VCL}
  if Copy(AVariableName,1,1)='$' then
  {$ENDIF}
  begin
      //是变量,
      //比如像网页中的我们用到过的$login_shop.fid
      //也可以取我们当前登录用户的信息比如$login_user.fid,$login_user.name等
      //也可以取

      //本地数据源Json的字段
      Result:=GetGlobalPageFrameworkDataSourceManager.GetParamValue('',AVariableName)


  end
  else
  begin
      //是常量
      Result:=AVariableName;
  end;
end;

function GetPageDataIntfResultFieldValue(AFieldName:String;
                                          ADataIntfResult:TDataIntfResult;
                                          ADataIntfResult2:TDataIntfResult;
                                          var AJsonArrayValue:ISuperArray;
                                          var AValueObject:TObject):Variant;
var
  AFieldNameList:TStringList;
begin
  AJsonArrayValue:=nil;
  AValueObject:=nil;

  {$IFDEF FMX}
  if AFieldName.Substring(0,1)='$' then
  {$ENDIF}
  {$IFDEF VCL}
  if Copy(AFieldName,1,1)='$' then
  {$ENDIF}
  begin
      //是变量,
      //比如像网页中的我们用到过的$login_shop.fid
      //也可以取我们当前登录用户的信息比如$login_user.fid,$login_user.name等
      //也可以取
      AFieldNameList:=TStringList.Create;
      try
          AFieldNameList.Delimiter:='.';
          AFieldNameList.DelimitedText:=AFieldName;


          if AFieldNameList[0]='$data_intf' then
          begin
            //接口1的字段
            Result:=GetDataIntfFieldValue(AFieldName,ADataIntfResult,AFieldNameList,AValueObject);
          end
          else if AFieldNameList[0]='$data_intf2' then
          begin
            //接口2的字段
            Result:=GetDataIntfFieldValue(AFieldName,ADataIntfResult2,AFieldNameList,AValueObject);
          end
          else if AFieldNameList[0]='$local_data_source' then
          begin
            //本地数据源Json的字段
            Result:=TLocalJsonPageFrameworkDataSourceManager(GetGlobalPageFrameworkDataSourceManager).FDataJson.V[AFieldNameList[AFieldNameList.Count-1]];
          end
          else
          begin
            //本地数据源Json的字段
            Result:=GetPageFrameworkVariableValue(AFieldName)
          end
          ;

      finally
        FreeAndNil(AFieldNameList);
      end;
  end
  else
  begin
      //是字段名
      case ADataIntfResult.DataType of
        ldtNone: ;
        ldtJson:
        begin
            if ADataIntfResult.DataJson<>nil then
            begin
                if ADataIntfResult.DataJson.GetType(AFieldName)=varArray then
                begin
                  //Json数组,一般用于加载到ListBox
      //            Result:=ADataIntfResult.DataJson.A[AFieldName];
                  AJsonArrayValue:=ADataIntfResult.DataJson.A[AFieldName];
                end
                else
                begin
                  Result:=ADataIntfResult.DataJson.V[AFieldName];
                end;
            end
            else
            begin
                Result:='';
            end;
        end;
        ldtSkinItems:
        begin
            AValueObject:=ADataIntfResult.DataSkinItems;
        end;
      end;
  end;
end;


function GetLoadDataParamValue(AParamJson: ISuperObject;var AError:String): Variant;
begin

  //  AParamJson.S['name']:='fid';//参数名
  //  AParamJson.S['value_from']:='local_data_source';//值从哪里来
  //  AParamJson.V['value_key']:='office_fid';//哪个键
  //  AParamJson.S['value_from']:='const';//值从哪里来,或者空表示常量
  //  AParamJson.V['value']:=1010;//常量值


//  if AParamJson.S['value_from']='local_data_source' then
//  begin
////    Result:=GetGlobalLocalDataSource.FDataJson.V[AParamJson.V['value_key']];
//  end
//  {$IFDEF FMX}
//  else if AParamJson.S['value_from']='login_shop' then
//  begin
//    Result:=GetGlobalLocalDataSource.FLoginShopJson.V[AParamJson.V['value_key']];
//  end
//  else if AParamJson.S['value_from']='login_user' then
//  begin
//    Result:=GetGlobalLocalDataSource.GetLoginUserJson.V[AParamJson.V['value_key']];
//  end
//  {$ENDIF}
//  else
  if AParamJson.S['value_from']='const' then
  begin
    Result:=AParamJson.V['value'];
  end
  else
  begin
//    Result:=GetGlobalLocalDataSource.FDataJson.V[AParamJson.V['value_key']];
    Result:=GetGlobalPageFrameworkDataSourceManager.GetParamValue(AParamJson.S['value_from'],AParamJson.V['value_key']);

  end;

end;

function TPageInstance.GetFieldControlValue(AFieldName: String): Variant;
var
  AErrorMessage:String;
begin
  Result:=GetFieldControlPostValue(Self.MainControlMapList.Find(AFieldName),
                                   Self.PageStructure.GetPageDataDir,
                                   nil,
                                   AErrorMessage
                                   );
end;

function TPageInstance.GetPostDataJson(APageDataDir:String;
                                        AIsAddRecord:Boolean;
                                        var AError:String): ISuperObject;
var
  I:Integer;
  ARecordDataJson:ISuperObject;
  AValue:Variant;
  AValueStr:String;
  AOldValueStr:String;
  ASetJsonRecordFieldValueIntf:ISetRecordFieldValue;

  ASaveDataParamsJsonArray:ISuperArray;
begin
          if AIsAddRecord and (AddPostInitJson<>nil) then
          begin
            //添加记录使用初始的数据Json
            ARecordDataJson:=AddPostInitJson;//TSuperObject.Create();
          end
          else
          begin
            //修改记录,只需要提交修改的那些字段即可
            ARecordDataJson:=TSuperObject.Create();
          end;
          ASetJsonRecordFieldValueIntf:=TSetJsonRecordFieldValue.Create(ARecordDataJson);



          AError:='';
          for I := 0 to Self.MainControlMapList.Count-1 do
          begin
  //            if MainControlMapList[I].Component.GetInterface(IID_IControlForPageFramework,AControlForPageFrameworkIntf) then
  //            begin

                if MainControlMapList[I].Setting.field_name='' then Continue;
                if MainControlMapList[I].Setting.is_no_post=1 then Continue;

                AError:='';
                AValue:=//AControlForPageFrameworkIntf
                    GetFieldControlPostValue(
                                            MainControlMapList[I],
                                            Self.PageStructure.GetPageDataDir,
                                            ASetJsonRecordFieldValueIntf,
                                            AError);


                if AError<>'' then
                begin
  //                TTimerTask(ATimerTask).TaskDesc:=AError;
                  Exit;
                end;



                //要转换成字符串,这样好比较,不然会报错
                AValueStr:=AValue;
  //              if not FLoadDataSetting.IsAddRecord then
                if not AIsAddRecord then
                begin
                  //获取老数据,但是并不一定是DataJson
                  AOldValueStr:=Self.FLoadDataIntfResult.DataJson.V[MainControlMapList[I].Setting.field_name];
                end;



                if
                  //添加时,所有需要提交
                  AIsAddRecord
                  //修改时,新老数据比对,没有改过就不用提交
                  or (AOldValueStr<>AValueStr) then
                begin
                  ARecordDataJson.V[MainControlMapList[I].Setting.field_name]:=AValue;
                end;

  //            end;
          end;



          //自定义的提交参数
          ASaveDataParamsJsonArray:=TSuperArray.Create(Self.PageStructure.save_data_params);
          //准备参数
          for I:=0 to ASaveDataParamsJsonArray.Length-1 do
          begin
              //  AParamJson.S['name']:='fid';//参数名
              //  AParamJson.S['value_from']:='local_data_source';//值从哪里来
              //  AParamJson.V['value_key']:='office_fid';//哪个键
              //  AParamJson.S['value_from']:='const';//值从哪里来,或者空表示常量
              //  AParamJson.V['value']:=1010;//常量值
              ARecordDataJson.V[ASaveDataParamsJsonArray.O[I].S['name']]
                          :=GetLoadDataParamValue(ASaveDataParamsJsonArray.O[I],AError);
          end;


          Result:=ARecordDataJson;
end;

function TPageInstance.LoadData(AIsNeedStartThread:Boolean): Boolean;
var
  ALoadDataTimerTask:TTimerTask;
begin
    Result:=False;


    FLoadDataSetting.PageDataSkinItems:=Self.PageStructure.DataSkinItems;



    //列表页面,必须为加载数据
    if SameText(Self.PageStructure.page_type,Const_PageType_ListPage)
      //如果是查看编辑页面,而不是新增,并且没有数据,那么需要调用接口查询
      or not SameText(Self.PageStructure.page_type,Const_PageType_ListPage)
          and (FLoadDataSetting.RecordDataJson=nil)
          and not FLoadDataSetting.IsAddRecord then
    begin
        uBaseLog.HandleException(nil,'TPageInstance.LoadData 1');

        //需要调用接口
//        if not PageStructure.DataInterface.IsEmpty then
//        begin

          if AIsNeedStartThread then
          begin
              FLoadDataTimerTaskEvent.TaskName:=Self.PageStructure.name+'.LoadDataTask';
              FLoadDataTimerTaskEvent.Run();
          end
          else
          begin
              ALoadDataTimerTask:=TTimerTask.Create;
              ALoadDataTimerTask.TaskName:=Self.PageStructure.name+'.LoadDataTask';
              try
                  DoLoadDataTaskExecuteBegin(ALoadDataTimerTask);
                  DoLoadDataTaskExecute(ALoadDataTimerTask);
                  DoLoadDataTaskExecuteEnd(ALoadDataTimerTask);
              finally
                FreeAndNil(ALoadDataTimerTask);
              end;
          end;
          Result:=True;
//        end
//        else
//        begin
//          uBaseLog.HandleException(nil,'TPageInstance.LoadData PageStructure.DataInterface.IsEmpty');
//        end;

    end
    else if not FLoadDataSetting.IsAddRecord then
    begin
        uBaseLog.HandleException(nil,'TPageInstance.LoadData 2');


        //加载编辑页面或者详情页面
        if FLoadDataSetting.RecordDataJson<>nil then
        begin 
            //已经获取好的数据
            FLoadDataIntfResult.Succ:=True;
            FLoadDataIntfResult.DataType:=ldtJson;
            FLoadDataIntfResult.Desc:='获取数据成功';
            FLoadDataIntfResult.DataJson:=FLoadDataSetting.RecordDataJson;



            Self.LoadDataIntfResultToControls(FLoadDataIntfResult,FLoadDataIntfResult2);


            //再调用单独的接口
            //开启线程,加载页面中ComboBox选项框的设置
            if not PageStructure.DataInterface.IsEmpty then
            begin
              FLoadDataTimerTaskEvent.TaskName:=Self.PageStructure.name+'.LoadDataTask';
              FLoadDataTimerTaskEvent.Run();
              Result:=True;
            end
            else
            begin
              uBaseLog.HandleException(nil,'TPageInstance.LoadData PageStructure.DataInterface.IsEmpty');

            end;



            Result:=True;
        end;


    end
    else
    begin
        //添加记录,不需要调用接口
        uBaseLog.HandleException(nil,'TPageInstance.LoadData 2');


        Result:=True;
    end;


end;

function CallLoadDataIntf(APageStructure:TPage;
                              ADataInterface:TDataInterface;
                              ALoadDataIntfResult:TDataIntfResult;
                              ALoadDataSetting:TLoadDataSetting;
                              ALoadDataParams:String
                              ): Boolean;
var
//  ACode:Integer;
  I:Integer;

  APageLoadDataParamsWhereKeyJson:ISuperObject;

  ACustomWhereKeyJsonArray:ISuperArray;


  APageLoadDataParamsWhereKeyJsonArray:ISuperArray;
  ALoadDataParamsJsonArray:ISuperArray;

  AAllParamCount:Integer;
  AParamIndex:Integer;
begin
  Result:=False;

  try

      ALoadDataIntfResult.Clear;





      APageLoadDataParamsWhereKeyJsonArray:=TSuperArray.Create;



      ALoadDataParamsJsonArray:=TSuperArray.Create(ALoadDataParams);
      ACustomWhereKeyJsonArray:=TSuperArray.Create(ALoadDataSetting.CustomWhereKeyJson);
      AAllParamCount:=ALoadDataParamsJsonArray.Length
                      +ACustomWhereKeyJsonArray.Length;
      if APageStructure.page_type=Const_PageType_ListPage then
      begin
        AAllParamCount:=AAllParamCount+5;
      end;


      SetLength(ALoadDataSetting.LoadDataParamNames,AAllParamCount);
      SetLength(ALoadDataSetting.LoadDataParamValues,AAllParamCount);



      AParamIndex:=0;
      //准备参数
      for I:=0 to ALoadDataParamsJsonArray.Length-1 do
      begin


          //  AParamJson.S['name']:='fid';//参数名
          //  AParamJson.S['value_from']:='local_data_source';//值从哪里来
          //  AParamJson.V['value_key']:='office_fid';//哪个键
          //  AParamJson.S['value_from']:='const';//值从哪里来,或者空表示常量
          //  AParamJson.V['value']:=1010;//常量值

          APageLoadDataParamsWhereKeyJson:=TSuperObject.Create;
          APageLoadDataParamsWhereKeyJson.S['logical_operator']:='AND';
          APageLoadDataParamsWhereKeyJson.S['name']:=ALoadDataParamsJsonArray.O[I].S['name'];
          APageLoadDataParamsWhereKeyJson.S['operator']:='=';
          APageLoadDataParamsWhereKeyJson.V['value']:=GetLoadDataParamValue(ALoadDataParamsJsonArray.O[I],ALoadDataIntfResult.Desc);


          ALoadDataSetting.LoadDataParamNames[AParamIndex]:=ALoadDataParamsJsonArray.O[I].S['name'];
          ALoadDataSetting.LoadDataParamValues[AParamIndex]:=ALoadDataParamsJsonArray.O[I].V['value'];
          Inc(AParamIndex);


          APageLoadDataParamsWhereKeyJsonArray.O[I]:=APageLoadDataParamsWhereKeyJson;

      end;



      //ALoadDataSetting.CustomWhereKeyJson:=GetWhereConditions(['appid','fid'],
      //                                                        [GlobalMainProgramSetting.AppID,
      //                                                          ALoadDataSetting.RecordDataJson.I['fid']]);
      //有些地方设置的自定义查询条件
      if ALoadDataSetting.CustomWhereKeyJson<>'' then
      begin
        ACustomWhereKeyJsonArray:=TSuperArray.Create(ALoadDataSetting.CustomWhereKeyJson);
        for I:=0 to ACustomWhereKeyJsonArray.Length-1 do
        begin
            //要在前面,不然下标不准了
            ALoadDataSetting.LoadDataParamNames[AParamIndex]:=
              ACustomWhereKeyJsonArray.O[I].S['name'];
            ALoadDataSetting.LoadDataParamValues[AParamIndex]:=
              ACustomWhereKeyJsonArray.O[I].V['value'];
            Inc(AParamIndex);


            APageLoadDataParamsWhereKeyJsonArray.O[APageLoadDataParamsWhereKeyJsonArray.Length]:=
                ACustomWhereKeyJsonArray.O[I];
        end;
      end;







      if APageStructure.page_type=Const_PageType_ListPage then
      begin

              //这个是每个列表页面的接口一般都要传的
//              ALoadDataSetting.LoadDataParamNames[AParamIndex]:='appid';
//              ALoadDataSetting.LoadDataParamValues[AParamIndex]:=AppID;
//              Inc(AParamIndex);
//              ALoadDataSetting.LoadDataParamNames[AParamIndex]:='user_fid';
//              ALoadDataSetting.LoadDataParamValues[AParamIndex]:=GetGlobalLocalDataSource.GetLoginUserJson.V['fid'];
//              Inc(AParamIndex);
//              ALoadDataSetting.LoadDataParamNames[AParamIndex]:='key';
//              ALoadDataSetting.LoadDataParamValues[AParamIndex]:=GetGlobalLocalDataSource.GetLoginUserJson.V['key'];
//              Inc(AParamIndex);
              ALoadDataSetting.LoadDataParamNames[AParamIndex]:='pageindex';
              ALoadDataSetting.LoadDataParamValues[AParamIndex]:=ALoadDataSetting.PageIndex;
              Inc(AParamIndex);
              ALoadDataSetting.LoadDataParamNames[AParamIndex]:='pagesize';
              ALoadDataSetting.LoadDataParamValues[AParamIndex]:=ALoadDataSetting.PageSize;
              Inc(AParamIndex);




              //查询条件,Json数组
              ALoadDataSetting.WhereKeyJson:=APageLoadDataParamsWhereKeyJsonArray.AsJSON;
//              //排序
//              ALoadDataSetting.OrderBy:='';
//              //自带的Where条件
//              ALoadDataSetting.CustomWhereSQL:='';
//              //是否需要总数
//              ALoadDataSetting.IsNeedSumCount:=1;
//              //是否需要返回层级
//              ALoadDataSetting.IsNeedReturnLevel:=0;
//              //接口参数值来源(CommonRest接口的配置支持从RecordDataJson中获取参数值)
//              ALoadDataSetting.ParamRecordDataJsonStr:='';
              //是否需要返回子表数据
              ALoadDataSetting.IsNeedSubQueryList:=0;



              //列表页面,get_record_list
              //调用接口获取数据
              if not ADataInterface.GetDataList(
        //                          TCommonRestIntfItem(Self.PageStructure.DataInterface).DBModule,
        //                          nil,
    //                              GlobalMainProgramSetting.AppID,
    //                              ALoadDataSetting.PageIndex,
    //                              ALoadDataSetting.PageSize,
    //                              APageLoadDataParamsWhereKeyJsonArray.AsJSON,
    //                              '',
    //                              '',
    //                              1,  //是否需要返回总数
    //                              0,  //是否需要返回层级列表
    //                              '', //查询的参数
    //                              0,  //是否需要返回明细列表
                                  ALoadDataSetting,
                                  ALoadDataIntfResult
    //                              ACode,
    //                              ALoadDataIntfResult.Desc,
    //                              ALoadDataIntfResult.DataJson
                                  ) then
              begin
                Exit;
              end;

//              ALoadDataIntfResult.DataType:=ldtJson;
      end
      else if (APageStructure.page_type=Const_PageType_EditPage)
            or (APageStructure.page_type=Const_PageType_ViewPage) then
      begin
              //查看页面和编辑页面,调用get_record
//                   //自带的Where条件
//                   ACustomWhereSQL:String;
//                   //接口参数
//                   ARecordDataJsonStr:String;


              //查询条件,Json数组
              ALoadDataSetting.WhereKeyJson:=APageLoadDataParamsWhereKeyJsonArray.AsJSON;
              //接口参数
//              ALoadDataSetting.ParamRecordDataJsonStr:='';
              ALoadDataSetting.IsMustExist:=False;
              ALoadDataSetting.IsNeedSubQueryList:=1;


              if not ADataInterface.GetDataDetail(
        //                          TCommonRestIntfItem(Self.PageStructure.DataInterface).DBModule,
        //                          nil,
//                                  GlobalMainProgramSetting.AppID,
//                                  APageLoadDataParamsWhereKeyJsonArray.AsJSON,
//                                  '',
//                                  '',
                                  ALoadDataSetting,
                                  ALoadDataIntfResult
    //                              ACode,
    //                              ALoadDataIntfResult.Desc,
    //                              ALoadDataIntfResult.DataJson,
    //                              //不需要一定存在
    //                              False
                                  ) then
              begin
                Exit;
              end;
//              ALoadDataIntfResult.DataType:=ldtJson;
      end
      else
      begin
              //其他页面
              uBaseLog.HandleException(nil,'CallLoadDataIntf 请指定页面类型');


      end;




//      ALoadDataIntfResult.Succ:=(ACode=SUCC);

      Result:=ALoadDataIntfResult.Succ;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'CallLoadDataIntf');
    end;
  end;
end;

//procedure TPageInstance.ClearControlsValue;
//var
//  I: Integer;
//  AControlForPageFrameworkIntf:IControlForPageFramework;
//  AFieldControlSettingMap:TFieldControlSettingMap;
//begin
//
//    for I := 0 to Self.MainControlMapList.Count-1 do
//    begin
//        AFieldControlSettingMap:=MainControlMapList[I];
//        if AFieldControlSettingMap.Setting.field_name<>'' then
//        begin
//
//            if AFieldControlSettingMap.Control.GetInterface(IID_IControlForPageFramework,AControlForPageFrameworkIntf) then
//            begin
//              AControlForPageFrameworkIntf.SetPostValue(Self.PageDataDir,'');
//            end;
//
//        end;
//
//    end;
//
//end;

procedure TPageInstance.SaveRecord;
begin

  //保存添加/修改
  Self.DoSaveRecordAction(False);





end;

procedure TPageInstance.SetFieldControlValue(AFieldName: String;
  AValue: Variant);
begin
  SetFieldControlPostValue(Self.MainControlMapList.Find(AFieldName),
                           Self.PageStructure.GetPageDataDir,
                           '',
                           AValue,
                           '',
                           nil
                           );

end;

procedure TPageInstance.SetLoadDataIntfResult(
  const Value: TDataIntfResult);
begin
  FLoadDataIntfResult.Assign(Value);
end;

procedure TPageInstance.SetLoadDataIntfResult2(
  const Value: TDataIntfResult);
begin
  FLoadDataIntfResult2.Assign(Value);
end;

function TPageInstance.LoadDataIntfResultToControls(ADataIntfResult: TDataIntfResult;ADataIntfResult2: TDataIntfResult): Boolean;
var
  I: Integer;
//  AControlForPageFrameworkIntf:IControlForPageFramework;
  AFieldControlSettingMap:TFieldControlSettingMap;
  AIsSetted:Boolean;
  AValue:Variant;
  AValueCaption:String;
  AJsonArrayValue:ISuperArray;
  //比如SkinItems
  AValueObject:TObject;
//  APicPath:String;
//  ABindSkinItemValueControlIntf:IBindSkinItemValueControl;
  FGetDataIntfResultFieldValue:IGetDataIntfResultFieldValue;
begin
        //RecordList
//        if Self.PageStructure.DataInterface.get_record_list_json_root_key<>'' then
//        begin
//          if AResult.DataJson.Contains(Self.PageStructure.DataInterface.get_record_list_json_root_key) then
//          begin
//
//          end;
//        end;
//  Self.MainControlMapList.ClearValue;

  FGetDataIntfResultFieldValue:=TGetDataIntfResultFieldValue.Create(ADataIntfResult,ADataIntfResult2);
//  FGetDataIntfResultFieldValue.FLoadDataIntfResult:=FLoadDataIntfResult;
//  FGetDataIntfResultFieldValue.FLoadDataIntfResult2:=FLoadDataIntfResult2;


  Result:=False;
  try


        for I := 0 to Self.MainControlMapList.Count-1 do
        begin
                AFieldControlSettingMap:=MainControlMapList[I];
                if (AFieldControlSettingMap.Setting.field_name='') or (AFieldControlSettingMap.Setting.is_no_post=1) then
                begin
                  //is_no_post的话不赋值?
                  Continue;
                end;


                //如果父控件是ItemDesignerPanel,那就不用赋值

                if (AFieldControlSettingMap.Component is TComponent
                  ////如果父控件是ItemDesignerPanel,那就不用赋值
                  or (GetParentItemDesignerPanel(TControl(AFieldControlSettingMap.Component))=nil))
//                  and AFieldControlSettingMap.Component.GetInterface(IID_IControlForPageFramework,AControlForPageFrameworkIntf)
                  then
                begin
//                    if SameText(AFieldControlSettingMap.Setting.control_type,'image') then
//                    begin
//
//                        //图片都从服务器下载
//                        APicPath:=AResult.DataJson.V[AFieldControlSettingMap.Setting.field_name];
//                        if (APicPath<>'') then
//                        begin
//                            if (APicPath.IndexOf(#13#10)>=0) then
//                            begin
//                              //Base64
//                            end
//                            else if (APicPath.IndexOf('http://')>=0)
//                              or (APicPath.IndexOf('https://')>=0) then
//                            begin
//                                //不用加服务端地址了
//                            end
//                            else
//                            begin
//                                //加上图片服务器的链接
//                                APicPath:=GlobalMainProgramSetting.DataImageUrl+ReplaceStr(APicPath,'\','/');;
//                            end;
//                            try
//                              AControlForPageFrameworkIntf.SetPostValue(Self.PageDataDir,APicPath);
//                            except
//
//                            end;
//                        end;
//
//                    end
//                    else
//                    begin
//                      case AResult.DataType of
//                        ldtNone: ;
//                        ldtJson:
//                        begin
                          try

                            //如果是数组,那么赋值要区分开来
//                            if SameText(AFieldControlSettingMap.Setting.field_name,'RecordList') then
//                            begin
//                              //ListView赋值
//
//                            end
//                            else
//                            begin



                              //'{"SumCount":6,"Summary":{"SumCount":6},"RecordList":[]}'
                              AIsSetted:=False;
                              AJsonArrayValue:=nil;
                              AValueObject:=nil;
                              //从接口中获取值,
                              //AFieldControlSettingMap.Setting.field_name支持变量,但是如果提交的时候有变量就麻烦了
                              //
                              AValue:=GetPageDataIntfResultFieldValue(AFieldControlSettingMap.Setting.field_name,
                                                                      ADataIntfResult,
                                                                      ADataIntfResult2,
                                                                      AJsonArrayValue,
                                                                      AValueObject
                                                                      );

                              if AValue=Null then
                              begin
                                AValue:='';
                              end;

                              
//                              AValueStr:String;
//                            begin
//                            //First chance exception at $7771C5AF. Exception class EVariantTypeCastError with message
//                            //'Could not convert variant of type (Null) into type (OleStr)'.
//                            //Process TestOrangeUIFramework_D10_3.exe (43532)
//                              AValueStr:String;
//                            begin
//                              AValueStr:='';
//                              if AValue<>NULL then
//                              begin
//                                AValueStr:=AValue;
//                              end;


                              //将Json数组的值赋给ListBox
                              DoCustomSetControlPostValue(AFieldControlSettingMap,
                                                          AFieldControlSettingMap.Component,
                                                          Self.PageStructure.GetPageDataDir,
                                                          GlobalMainProgramSetting.DataIntfImageUrl,
                                                          AValue,
                                                          AJsonArrayValue,
                                                          AValueObject,
                                                          AIsSetted
                                                          );
                              //给控件赋值
                              if not AIsSetted then
                              begin
//                                AControlForPageFrameworkIntf

                                  AValueCaption:='';
                                  if (AFieldControlSettingMap.Setting.options_caption_field_name<>'') and (FGetDataIntfResultFieldValue<>nil) then
                                  begin
                                    AValueCaption:=FGetDataIntfResultFieldValue.GetFieldValue(AFieldControlSettingMap.Setting.options_caption_field_name);
                                  end;

                                  SetFieldControlPostValue(AFieldControlSettingMap,
                                                        Self.PageStructure.GetPageDataDir,
                                                        GlobalMainProgramSetting.DataIntfImageUrl,
                                                        AValue,
                                                        AValueCaption,
                                                        FGetDataIntfResultFieldValue
                                                        );
                              end;




//                            end;

                          except

                          end;
//                        end;
//                      end;
//                    end;
                end;
    //            if AFieldControlSettingMap.Control.GetInterface(IID_IBindSkinItemValueControl,ABindSkinItemValueControlIntf) then
    //            begin
    //              ABindSkinItemValueControlIntf.SetControlValueByBindItemField(Self.PageDataDir,AResult.DataJson.V[AFieldControlSettingMap.Setting.field_name]);
    //            end;

        end;

        Result:=True;

  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'TPageInstance.LoadDataIntfResultToControls');
    end;
  end;
end;

function TPageInstance.LoadDataJsonToControls(ADataJson: ISuperObject): Boolean;
//var
//  ADataIntfResult:TDataIntfResult;
begin
//  ADataIntfResult:=TDataIntfResult.Create;
//  try
//    //调用接口,获取数据,显示在界面上
//    ADataIntfResult.DataType:=ldtJson;
//    ADataIntfResult.Succ:=True;
//    ADataIntfResult.Desc:='数据加载成功';
//    ADataIntfResult.DataJson:=ADataJson;
//    Self.LoadDataIntfResultToControls(ADataIntfResult,nil);
//  finally
//    FreeAndNil(ADataIntfResult);
//  end;



    //调用接口,获取数据,显示在界面上
    FLoadDataIntfResult.DataType:=ldtJson;
    FLoadDataIntfResult.Succ:=True;
    FLoadDataIntfResult.Desc:='数据加载成功';
    FLoadDataIntfResult.DataJson:=ADataJson;
    Self.LoadDataIntfResultToControls(FLoadDataIntfResult,nil);

end;

procedure TPageInstance.Refresh;
begin
  Self.LoadData();
end;

//function TPageInstance.PostToServer(APageDataDir:String;var ACode: Integer; var ADesc: String;
//  var ADataJson: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  //在外面初始好了,不用再在里面初始了
//  ACode:=FAIL;
//  ADesc:='';
//  ADataJson:=nil;
//
//
//  if SameText(Self.PageStructure.DataInterface.intf_type,
//                  Const_IntfType_TableCommonRest) then
//  begin
//    Result:=Self.DoPostToTableCommonRestAddRecord(
//                    APageDataDir,
//                    ACode,
//                    ADesc,
//                    ADataJson);
//  end
//  else
//  begin
//    ADesc:='不支持该接口类型';
//  end;
//
//end;


procedure TPageInstance.DoFieldControlClick(Sender: TObject);
var
  I: Integer;
begin
  uBaseLog.HandleException(nil,'TPageInstance.DoFieldControlClick');

  for I := 0 to Self.MainControlMapList.Count-1 do
  begin
    if MainControlMapList[I].Component=Sender then
    begin
      Self.DoPageLayoutControlClick(Sender,MainControlMapList[I]);
      Break;
    end;
  end;

  for I := 0 to Self.BottomToolbarControlMapList.Count-1 do
  begin
    if BottomToolbarControlMapList[I].Component=Sender then
    begin
      Self.DoPageLayoutControlClick(Sender,BottomToolbarControlMapList[I]);
      Break;
    end;
  end;
end;

procedure TPageInstance.DoCustomSetControlPostValue(
  AFieldControlSettingMap:TFieldControlSettingMap;
  AComponent: TComponent;
  APageDataDir, AImageServerUrl: String;
  AValue: Variant;
  AValueArray:ISuperArray;
  AValueObject:TObject;
  var AIsSetted: Boolean);
var
  ASkinVirtualList:TSkinVirtualList;
  I: Integer;
  ASkinItem:TBaseSkinItem;
  ASkinItems:TSkinItems;
//  J: Integer;
  ASkinItemList:TList;
begin
  if AComponent is TSkinVirtualList then
  begin
      AIsSetted:=True;


      ASkinVirtualList:=TSkinVirtualList(AComponent);
      ASkinVirtualList.Prop.Items.BeginUpdate;
      try

          //第一页要清空
          //TSkinRealSkinItemComponent对应的Item不需要清除
          if Self.FLoadDataSetting.PageIndex<=1 then
          begin
//            for I := 0 to Self.PageStructure.MainLayoutControlList.Count-1 do
//            begin
//
//            end;

            ASkinVirtualList.Prop.Items.Clear(True);

          end;


//          //其他字段名
//          if AFieldControlSettingMap.Setting.other_field_names<>'' then
//          begin
//
//          end;
          



//          //字段名
//          AFieldControlSetting.field_name:='RecordList';
//          AFieldControlSetting.field_caption:='数据列表';





          //返回的是Json数组
          if (AValueArray<>nil) then
          begin

              //设计面板直接与Json字段进行绑定的,只需要设置Item.Json属性即可
              for I := 0 to AValueArray.Length-1 do
              begin
                Self.AddSkinItemToListControl(ASkinVirtualList,AValueArray.O[I],nil);
              end;

          end;




          //返回的是TSkinItems
          if (AValueObject<>nil) and (AValueObject is TSkinItems) then
          begin
              ASkinItems:=TSkinItems(AValueObject);
              for I := 0 to ASkinItems.Count-1 do
              begin

                Self.AddSkinItemToListControl(ASkinVirtualList,nil,ASkinItems[I]);

  //                if ASkinItems[I] is TSkinPageStructureJsonItem then
  //                begin
  //                  ASkinItem:=TSkinPageStructureJsonItem.Create;
  //                  TSkinPageStructureJsonItem(ASkinItem).Json:=AValueArray.O[I];
  //                  ASkinVirtualList.Prop.Items.Add(ASkinItem);
  //                end
  //                else
  //                begin
  //                  //直接赋值
  //                  ASkinItem:=TBaseSkinItem(ASkinVirtualList.Prop.Items.Add);
  //                  ASkinItem.Assign(ASkinItems[I]);
  //                end;


              end;
          end;
        

      finally
        ASkinVirtualList.Prop.Items.EndUpdate();
      end;

  end;
end;

procedure TPageInstance.DoDelRecordAction;
begin
  FDelDataTimerTaskEvent.TaskName:=Self.PageStructure.name+'.DelDataTask';
  FDelDataTimerTaskEvent.Run();

end;

procedure TPageInstance.DoJumpToEditRecordPageAction(ALoadDataSetting:TLoadDataSetting);
begin
  //判断是要编辑哪条记录


end;

procedure TPageInstance.DoJumpToNewRecordPageAction;
//var
//  ALoadDataSetting:TLoadDataSetting;
begin
  //添加记录

//  if Self.PageStructure.EditPage<>nil then
//  begin
//    ALoadDataSetting.AppID:=Self.FLoadDataSetting.AppID;
//    ALoadDataSetting.IsAddRecord:=True;
//
//    if Assigned(GlobalMainProgramSetting.OnNeedShowPage) then
//    begin
//      GlobalMainProgramSetting.OnNeedShowPage(Self,
//                                              0,
//                                              Self.PageStructure.EditPage,
//                                              ALoadDataSetting,
//                                              DoReturnFrameFromEditPageFrame
//                                              );
////      HideFrame;
////      ShowPageFrame(Self.PageStructure.EditPage,
////                    ALoadDataSetting,
////                    DoReturnFrameFromEditPageFrame);
//    end;
//
////    HideFrame;
////    ShowPageFrame(Self.PageStructure.EditPage,
////                  ALoadDataSetting,
////                  DoReturnFrameFromEditPageFrame);
//  end;

end;

{ TFieldControlSettingMap }


procedure TFieldControlSettingMap.AlignControl(AItemRect: TRectF;
                                              ALayoutSetting:TLayoutSetting);
begin
  //加上边距
  AItemRect.Left:=AItemRect.Left+ALayoutSetting.margins_left;
  AItemRect.Top:=AItemRect.Top+ALayoutSetting.margins_top;
  AItemRect.Right:=AItemRect.Right-ALayoutSetting.margins_right;
  AItemRect.Bottom:=AItemRect.Bottom-ALayoutSetting.margins_bottom;


  if Component is TControl then
  begin
      if Self.InputPanel<>nil then
      begin
          Self.InputPanel.SetBounds(
            ControlSize(AItemRect.Left),
            ControlSize(AItemRect.Top),
            ControlSize(AItemRect.Width),
            ControlSize(AItemRect.Height)
            );


          if Self.Component<>nil then
          begin
            if BiggerDouble(ALayoutSetting.hint_label_width,0) then
            begin
              TControl(Component).Margins.Left:=ControlSize(ALayoutSetting.hint_label_width);
            end
            else
            begin
              TControl(Component).Margins.Left:=100;
            end;
            {$IFDEF FMX}
            TControl(Component).Align:=TAlignLayout.Client;
            {$ENDIF}
            {$IFDEF VCL}
            TControl(Component).Align:=TAlignLayout.alClient;
            {$ENDIF}
          end;

      end
      else
      begin

          //设置控件的位置
          if Self.Component<>nil then
          begin
            TControl(Self.Component).SetBounds(
                ControlSize(AItemRect.Left),
                ControlSize(AItemRect.Top),
                ControlSize(AItemRect.Width),
                ControlSize(AItemRect.Height)
                );
          end;

      end;
  end;
end;

procedure TFieldControlSettingMap.ClearItemRect;
begin
  FItemRect:=RectF(0,0,0,0);
  FItemDrawRect:=RectF(0,0,0,0);
end;

//constructor TFieldControlSettingMap.Create(AOwner: TControlLayoutManager);
//begin
//  SetSkinListIntf(AOwner);
//end;
//
//destructor TFieldControlSettingMap.Destroy;
//begin
//  inherited;
//end;

function TFieldControlSettingMap.GetHeight: TControlSize;
begin
//  Result:=Height;//ControlMap.Setting.height;
//  if Self.Setting.height=0 then
//  begin
//    Result:=40;
//    Exit;
//  end
//  else
//  begin
    Result:=ControlSize(Self.Setting.height);
//  end;
end;

function TFieldControlSettingMap.GetIsRowEnd: Boolean;
begin
  Result:=False;
end;

function TFieldControlSettingMap.GetItemDrawRect: TRectF;
begin
  Result:=FItemDrawRect;
end;

function TFieldControlSettingMap.GetItemRect: TRectF;
begin
  Result:=FItemRect;
end;

function TFieldControlSettingMap.GetLevel: Integer;
begin
  Result:=0;
end;

function TFieldControlSettingMap.GetObject: TObject;
begin
  Result:=Self;
end;

function TFieldControlSettingMap.GetSelected: Boolean;
begin
  Result:=False;
end;

function TFieldControlSettingMap.GetVisible: Boolean;
begin
  Result:=(Self.Setting.visible=1);
end;

function TFieldControlSettingMap.GetWidth: TControlSize;
begin
//  if BiggerDouble( then

//  if Self.Setting.width=0 then
//  begin
//    //默认
//    Result:=-1;
//    Exit;
//  end
//  else
//  begin
    Result:=ControlSize(Self.Setting.width);
//  end;
end;

procedure TFieldControlSettingMap.SetItemDrawRect(Value: TRectF);
begin
  FItemDrawRect:=Value;
end;

procedure TFieldControlSettingMap.SetItemRect(Value: TRectF);
begin
  FItemRect:=Value;
end;

procedure TFieldControlSettingMap.SetSkinListIntf(ASkinListIntf: ISkinList);
begin
  FSkinListIntf:=ASkinListIntf;
end;


constructor TFieldControlSettingMap.Create(AOwner: TFieldControlSettingMapList);
begin
  SetSkinListIntf(AOwner);
end;

destructor TFieldControlSettingMap.Destroy;
begin
//  if HintLabel<>nil then
//  begin
//    HintLabel.Parent:=nil;
//    FreeAndNil(HintLabel);
//  end;

//  if InputPanel<>nil then
//  begin
//    InputPanel.Parent:=nil;
//    FreeAndNil(InputPanel);
//  end;


  //Parent在释放的时候,会释放下面的子控件,所以Owner基本没有用
  PageFrameworkControlIntf:=nil;

  if Component<>nil then
  begin
    if Component is TControl then
    begin
      TControl(Component).Parent:=nil;
    end;

    FreeAndNil(Component);
  end;

  inherited;
end;

{ TPageList }

function TPageList.Find(AFunction:String;
                                  APageType:String;
                                  APageName:String;
                                  APlatform:String): TPage;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Count-1 do
  begin
    if (AFunction<>'')
        and (APageType<>'')
        and SameText(Items[I].function_name,AFunction)
         and SameText(Items[I].page_type,APageType)
      or (APageName<>'') and SameText(Items[I].name,APageName)
      then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TPageList.Find(APageFID: Integer): TPage;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Count-1 do
  begin
    if (APageFID=Items[I].fid) then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TPageList.GetItem(Index: Integer): TPage;
begin
  Result:=TPage(Inherited Items[Index]);
end;

procedure TPageList.LoadIndexFromFile(AJsonFilePath: String);
var
  ASuperObject:ISuperObject;
begin
  ASuperObject:=TSuperObject.Create(GetStringFromFile(AJsonFilePath,TEncoding.UTF8));
  Self.LoadIndexFromJsonArray(ASuperObject.A['pages']);
end;

procedure TPageList.LoadIndexFromJsonArray(ASuperArray: ISuperArray);
var
  I: Integer;
  APage:TPage;
begin
  Clear;
  for I := 0 to ASuperArray.Length-1 do
  begin
    APage:=TPage.Create(nil);
    APage.ProgramTemplate:=FProgramTemplate;
    APage.LoadFromIndexJson(ASuperArray.O[I]);
    Self.Add(APage);
  end;
end;

procedure TPageList.SaveIndexToFile(AJsonFilePath: String);
var
  ASuperObject:ISuperObject;
begin
  ASuperObject:=TSuperObject.Create();
  Self.SaveIndexToJsonArray(ASuperObject.A['pages']);
  SaveStringToFile(//ASuperObject.AsJSON,
                  formatJson(UTFStrToUnicode(ASuperObject.AsJSON)),
                  AJsonFilePath,TEncoding.UTF8);
end;

procedure TPageList.SaveIndexToJsonArray(ASuperArray: ISuperArray);
var
  I: Integer;
  ASuperObject:ISuperObject;
begin
  for I := 0 to Self.Count-1 do
  begin
    ASuperObject:=TSuperObject.Create();
    Items[I].SaveToIndexJson(ASuperObject);
    ASuperArray.O[I]:=ASuperObject;
  end;
end;

//function LoadDataJsonArrayToItems(
//          ADataJsonArray:ISuperArray;
//          ASkinItems:TSkinItems;
//          AFieldControlSettingList:TFieldControlSettingList):Boolean;
//var
//  I: Integer;
//  ASkinItem:TSkinItem;
//begin
//  Result:=False;
////  ASkinItems.BeginUpdate;
////  try
//
////      for I := 0 to ADataJsonArray.Length-1 do
////      begin
////        ASkinItem:=TSkinItem(ASkinItems.Add);
////        if Not LoadDataJsonToSkinItem(
////                               ADataJsonArray.O[I],
////                               ASkinItem,
////                               AFieldControlSettingList) then
////        begin
////          //加载数据失败
////          Exit;
////        end;
////      end;
//
//      Result:=True;
////  finally
////    ASkinItems.EndUpdate();
////  end;
//end;


function LoadDataJsonToSkinItem(
    ADataJson:ISuperObject;
    ASkinItem:TSkinItem;
    AFieldControlSettingList:TFieldControlSettingList):Boolean;
var
  I: Integer;
begin
  Result:=True;

  //Json数据保存到DataJsonStr
  ASkinItem.DataJsonStr:=ADataJson.AsJSON;

//  for I := 0 to AFieldControlSettingList.Count-1 do
//  begin
//    if not LoadDataJsonToSkinItemProp(
//              ADataJson,
//              ASkinItem,
//              AFieldControlSettingList[I]) then
//    begin
//      Exit;
//    end;
//  end;

  Result:=True;
end;

function LoadDataJsonToSkinItemProp(
    ADataJson:ISuperObject;
    ASkinItem:TSkinItem;
    AFieldControlSetting:TFieldControlSetting):Boolean;
begin
  Result:=True;

  if AFieldControlSetting.field_name<>'' then
  begin

//      if ADataJson.Contains(AFieldControlSetting.FieldName) then
//      begin
//          //给Item的属性赋值
//          SetItemValueByItemDataType(
//              ASkinItem,
//              GetItemDataType(AFieldControlSetting.bind_listitem_data_type),
//              AFieldControlSetting.BindSubItemsIndex,
//              ADataJson.V[AFieldControlSetting.FieldName]
//              );
//      end
//      else
//      begin
//          HandleException(nil,'LoadDataJsonToSkinItemProp ADataJson中不存在'+AFieldControlSetting.FieldName);
//          Exit;
//      end;

  end;

  Result:=True;
end;



//{ TListDataController }
//
//
//constructor TListDataController.Create(AOwner: TComponent);
//begin
//
//  FieldControlSettingList:=TFieldControlSettingList.Create();
//
//  tteGetData:=TTimerTaskEvent.Create(nil);
//  tteGetData.OnBegin:=tteGetDataBegin;
//  tteGetData.OnExecute:=tteGetDataExecute;
//  tteGetData.OnExecuteEnd:=tteGetDataExecuteEnd;
//end;
//
//destructor TListDataController.Destroy;
//begin
//  FreeAndNil(tteGetData);
//  FreeAndNil(FieldControlSettingList);
//
//  inherited;
//end;
//
//procedure TListDataController.GetData(
//  AParentControl:TFmxObject;
//  AListControl: TSkinVirtualList;
//  AOnGetDataEvent: TTimerTaskNotify;
//  AOnOnLoadDataToControlsEnd:TNotifyEvent;
//  ADataJsonArrayKey,
//  AItemStyle: String);
//begin
//  ParentControl:=AParentControl;
//
//  ListControl:=AListControl;
//
//  //数据列表在DataJson中的哪个Key
//  DataJsonArrayKey:=ADataJsonArrayKey;
//  //获取数据的方法
//  OnGetListData:=AOnGetDataEvent;
//
//  OnLoadDataToControlsEnd:=AOnOnLoadDataToControlsEnd;
//
//  //启动获取数据的线程
//  Self.tteGetData.Run;
//
//end;
//
//procedure TListDataController.tteGetDataBegin(ATimerTask: TTimerTask);
//begin
//  GlobalShowWaiting(ParentControl,'加载中...');
//end;
//
//procedure TListDataController.tteGetDataExecute(ATimerTask: TTimerTask);
//begin
//  if Assigned(OnGetListData) then
//  begin
//    OnGetListData(ATimerTask);
//  end;
//end;
//
//procedure TListDataController.tteGetDataExecuteEnd(ATimerTask: TTimerTask);
//var
//  ASuperObject:ISuperObject;
//begin
//  try
//    if TTimerTask(ATimerTask).TaskTag=0 then
//    begin
//
//        ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
//        if (ASuperObject.I['Code']=200) then
//        begin
//            if ASuperObject.Contains('Data')
//              and ASuperObject.O['Data'].Contains(DataJsonArrayKey) then
//            begin
//                Self.ListControl.Prop.Items.BeginUpdate;
//                try
//                  LoadDataJsonArrayToItems(
//                      ASuperObject.O['Data'].A[DataJsonArrayKey],
//                      Self.ListControl.Prop.Items,
//                      Self.FieldControlSettingList
//                      );
//                finally
//                  Self.ListControl.Prop.Items.EndUpdate;
//                end;
//
//                //设置弹出框的高度
//                if Assigned(Self.OnLoadDataToControlsEnd) then
//                begin
//                  OnLoadDataToControlsEnd(Self);
//                end;
//                //FrameResize(nil);
//            end
//            else
//            begin
//                ShowMessageBoxFrame(ParentControl,'返回的数据格式不匹配!','');//,'',TMsgDlgType.mtInformation,['确定'],nil);
//            end;
//        end
//        else
//        begin
//            //获取列表失败
//            ShowMessageBoxFrame(ParentControl,ASuperObject.S['Desc'],'');//,'',TMsgDlgType.mtInformation,['确定'],nil);
//        end;
//
//    end
//    else if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(ParentControl,'网络异常,请检查您的网络连接!','');//,TTimerTask(ATimerTask).TaskDesc,TMsgDlgType.mtInformation,['确定'],nil);
//    end;
//  finally
//    HideWaitingFrame;
//  end;
//
//end;





//initialization
//  GolobalPageStructureList:=TPageList.Create(ooReference);
//
//finalization
//  FreeAndNil(GolobalPageStructureList);




{ TLayoutSetting }

function TLayoutSetting.LoadFromJson(AJson: ISuperObject): Boolean;
begin

  Result:=False;

  //排列类型,auto,manual
  align_type:=AJson.S[name+'_'+'align_type'];


  //控件排几列
  col_count:=AJson.I[name+'_'+'col_count'];
  //控件的宽度
  col_width:=AJson.F[name+'_'+'col_width'];
  //控件的高度
  row_height:=AJson.F[name+'_'+'row_height'];
  //控件的间隔
  row_space:=AJson.F[name+'_'+'row_space'];



  //提示文本的宽度
  hint_label_width:=AJson.F[name+'_'+'hint_label_width'];


  //控件的左边距
  margins_left:=AJson.F[name+'_'+'margins_left'];
  margins_top:=AJson.F[name+'_'+'margins_top'];
  margins_right:=AJson.F[name+'_'+'margins_right'];
  margins_bottom:=AJson.F[name+'_'+'margins_bottom'];


  Result:=True;


end;

function TLayoutSetting.SaveToJson(AJson: ISuperObject): Boolean;
begin

  Result:=False;

  //排列类型,auto,manual
  if align_type<>'' then AJson.S[name+'_'+'align_type']:=align_type;


  //控件排几列
  if col_count<>0 then AJson.I[name+'_'+'col_count']:=col_count;
  //控件的宽度
  if col_width<>0 then AJson.F[name+'_'+'col_width']:=col_width;
  //控件的高度
  if row_height<>0 then AJson.F[name+'_'+'row_height']:=row_height;
  //控件的间隔
  if row_space<>0 then AJson.F[name+'_'+'row_space']:=row_space;



  //提示文本的宽度
  if hint_label_width<>0 then AJson.F[name+'_'+'hint_label_width']:=hint_label_width;


  //控件的左边距
  if margins_left<>0 then AJson.F[name+'_'+'margins_left']:=margins_left;
  if margins_top<>0 then AJson.F[name+'_'+'margins_top']:=margins_top;
  if margins_right<>0 then AJson.F[name+'_'+'margins_right']:=margins_right;
  if margins_bottom<>0 then AJson.F[name+'_'+'margins_bottom']:=margins_bottom;


  Result:=True;

end;

//{ TDataInterface }
//
//constructor TDataInterface.Create;
//begin
//
//end;
//
//destructor TDataInterface.Destroy;
//begin
//  FreeAndNil(FCommonRestIntfItem);
//  inherited;
//end;
//
//function TDataInterface.LoadFromJson(AJson: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  if Self.IntfType=Const_IntfType_TableCommonRest then
//  begin
//    FreeAndNil(FCommonRestIntfItem);
//    FCommonRestIntfItem:=TCommonRestIntfItem.Create();
//    FCommonRestIntfItem.LoadFromJson(AJson);
//  end;
//
//  Result:=True;
//end;
//
//function TDataInterface.SaveToJson(AJson: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  if Self.IntfType=Const_IntfType_TableCommonRest then
//  begin
//
//    if FCommonRestIntfItem<>nil then
//    begin
//      FCommonRestIntfItem.SaveToJson(AJson);
//    end;
//
//  end;
//
//  Result:=True;
//end;














//{ TDataInterfaceList }
//
//function TDataInterfaceList.GetItem(Index: Integer): TDataInterface;
//begin
//  Result:=TDataInterface(Inherited Items[Index]);
//end;








{ TProgramTemplate }

procedure TProgramTemplate.tteGetPageBegin(ATimerTask: TTimerTask);
begin
  {$IFDEF FMX}
  ShowWaitingFrame(nil,'页面加载中...');
  {$ENDIF}
end;

procedure TProgramTemplate.tteGetPageExecute(ATimerTask: TTimerTask);
var
  ADesc:String;
  APage:TPage;
  AIsUsedCache:Boolean;
begin
  ATimerTask.TaskTag:=TASK_FAIL;
  try
      APage:=TPage(ATimerTask.TaskObject);


      if APage.LoadFromServer(
                              GlobalMainProgramSetting.OpenPlatformServerUrl,
                              GlobalMainProgramSetting.OpenPlatformAppID,
                              //APage.fid,
                              APage.program_template_name,
                              APage.function_name,
                              APage.page_type,
                              APage.platform,
                              APage.name,
                              False,
                              ADesc,
                              AIsUsedCache
                              ) then
      begin
        ATimerTask.TaskTag:=TASK_SUCC;
      end;

      ATimerTask.TaskDesc:=ADesc;


  except
    on E:Exception do
    begin
      TTimerTask(ATimerTask).TaskDesc:=E.Message;
      uBaseLog.HandleException(E,'TFrameMain.tteGetProgramTemplateExecute');
    end;
  end;

end;

procedure TProgramTemplate.tteGetPageExecuteEnd(ATimerTask: TTimerTask);
//var
//  APage:TPage;
begin
  if Assigned(FOnGetPageExecuteEnd) then
  begin
    FOnGetPageExecuteEnd(ATimerTask);
  end;


//  try
//    if TTimerTask(ATimerTask).TaskTag=TASK_SUCC then
//    begin
////      ASuperObject:=TSuperObject.Create(TTimerTask(ATimerTask).TaskDesc);
////      if ASuperObject.I['Code']=200 then
////      begin
//
//        APage:=TPage(ATimerTask.TaskObject);
//
//        //加载工程
//        //Self.DoLoadPage(APage);
//
//
////      end
////      else
////      begin
////        //登录失败
////        ShowMessageBoxFrame(Self,ASuperObject.S['Desc'],'',TMsgDlgType.mtInformation,['确定'],nil);
////      end;
//
//    end
//    else if TTimerTask(ATimerTask).TaskDesc<>'' then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(nil,TTimerTask(ATimerTask).TaskDesc);
//    end
//    else //if TTimerTask(ATimerTask).TaskTag=1 then
//    begin
//      //网络异常
//      ShowMessageBoxFrame(nil,'网络异常,请检查您的网络连接!');
//    end;
//  finally
//    HideWaitingFrame;
//  end;
end;


procedure TProgramTemplate.Clear;
begin

    fid:=0;
    appid:=0;
    user_fid:='';


    name:='';
    caption:='';
    description:='';

//    //接口列表
//    DataIntfList:TDataInterfaceList;


    //页面列表
    PageList.Clear();

    IsLoaded:=False;
    FLoadedJsonFilePath:='';

end;

constructor TProgramTemplate.Create;
begin
  PageList:=TPageList.Create();
  PageList.FProgramTemplate:=Self;


  tteGetPage:=TTimerTaskEvent.Create(nil);
  tteGetPage.OnBegin:=Self.tteGetPageBegin;
  tteGetPage.OnExecute:=Self.tteGetPageExecute;
  Self.tteGetPage.OnExecuteEnd:=tteGetPageExecuteEnd;

end;

destructor TProgramTemplate.Destroy;
begin
  FreeAndNil(PageList);

  FreeAndNil(tteGetPage);

  inherited;
end;

function TProgramTemplate.GetProgramTemplateDir: String;
begin
  Result:=GetApplicationPath;
  if Self.FLoadedJsonFilePath<>'' then
  begin
    Result:=ExtractFilePath(FLoadedJsonFilePath);
  end;
end;

function TProgramTemplate.IsLocal: Boolean;
begin
  Result:=(FLoadedJsonFilePath<>'');
end;

function TProgramTemplate.LoadFromFile(AJsonFilePath: String): Boolean;
var
  ASuperObject:ISuperObject;
begin
  if FileExists(AJsonFilePath) then
  begin
    FLoadedJsonFilePath:=AJsonFilePath;
    ASuperObject:=TSuperObject.Create(GetStringFromFile(AJsonFilePath,TEncoding.UTF8));
    Self.LoadFromJson(ASuperObject);



    //页面列表呢?
    //页面列表保存在同级目录的pages.json中
    if FileExists(ExtractFilePath(AJsonFilePath)+'pages.json') then
    begin
      Self.PageList.LoadIndexFromFile(ExtractFilePath(AJsonFilePath)+'pages.json');
    end;

  end;
end;

function TProgramTemplate.LoadFromJson(AJson: ISuperObject): Boolean;
//var
//  ADataIntfListArray:ISuperArray;
//  I: Integer;
//  ADataIntfListJson:ISuperObject;
begin
  Result:=False;

  fid:=AJson.I['fid'];
  Self.appid:=AJson.I['appid'];
  user_fid:=AJson.V['user_fid'];


  name:=AJson.S['name'];
  caption:=AJson.S['caption'];
  description:=AJson.S['description'];



  Self.PageList.Clear();


//  ADataIntfListArray:=TSuperArray.Create;
//  AJson.A['data_intf_list']:=ADataIntfListArray;
//  for I := 0 to Self.DataIntfList.Count-1 do
//  begin
//    ADataIntfListJson:=TSuperObject.Create;
//    DataIntfList[I].SaveToJson(ADataIntfListJson);
//    ADataIntfListArray.O[I]:=ADataIntfListJson;
//  end;

  IsLoaded:=True;


  Result:=True;

end;

function TProgramTemplate.LoadFromServer(AInterfaceUrl: String;
  AAppID: Integer;
  AProgramTemplateName: String;
  var ADesc:String): Boolean;
var
  ACode: Integer;
  ADataJson:ISuperObject;
var
  I: Integer;
  APageStructure:TPage;
begin
  Result:=False;
  ADesc:='';

  PageList.Clear(True);



  //不存在fid,表示要新增该记录
  if not SimpleCallAPI(
                      'get_record',
                      nil,
                      AInterfaceUrl+'tablecommonrest/',
                      ConvertToStringDynArray(['appid',
                                              'user_fid',
                                              'key',

                                              'rest_name',
                                              'where_key_json'
                                              ]),
                      ConvertToVariantDynArray([
                                              AAppID,
                                              0,
                                              '',
                                              'program_template',
                                              GetWhereConditions(['appid','name'],
                                                                [AAppID,AProgramTemplateName])
                                              ]),
                      ACode,
                      ADesc,
                      ADataJson,
                      GlobalRestAPISignType,
                      GlobalRestAPIAppSecret) then
  begin
    Exit;
  end;

  if ACode<>SUCC then
  begin
    ShowMessage(ADesc);
  end;


  //加载程序模板
  Self.LoadFromJson(ADataJson);


  //加载程序模板的所有功能和页面
  if not SimpleCallAPI(
                      'get_record_list',
                      nil,
                      AInterfaceUrl+'tablecommonrest/',
                      ConvertToStringDynArray(['appid',
                                              'user_fid',
                                              'key',
                                              'rest_name',
                                              'pageindex',
                                              'pagesize',
                                              'where_key_json',
                        //                      'where_sql',
                                              'order_by'
                                              ]),
                      ConvertToVariantDynArray([
                                              AAppID,
                                              0,
                                              '',
                                              'page_no_function',
                                              1,
                                              MaxInt,
                                              GetWhereConditions(['appid','program_template_name'],
                                                                [AAppID,AProgramTemplateName]),
                        //                      ' AND (program_template_name='+QuotedStr(AProgramTemplateName)+' OR '+'page_program_template_name='+QuotedStr(AProgramTemplateName)+') ',
                                              'orderno ASC,createtime ASC'
                                              ]),
                      ACode,
                      ADesc,
                      ADataJson,
                      GlobalRestAPISignType,
                      GlobalRestAPIAppSecret) then
  begin
    Exit;
  end;


  if ACode<>SUCC then
  begin
    ShowMessage(ADesc);
  end;





  for I := 0 to ADataJson.A['RecordList'].Length-1 do
  begin
      APageStructure:=TPage.Create(nil);
      APageStructure.ProgramTemplate:=Self;
      APageStructure.LoadFromJson(ADataJson.A['RecordList'].O[I]);
      Self.PageList.Add(APageStructure);
  end;



  Result:=True;


end;

function TProgramTemplate.LoadPage(APageFID: Integer;AOnGetPageExecuteEnd: TTimerTaskNotify): Boolean;
var
  APage:TPage;
begin
  Result:=False;

  //当找不到了,怎么办?从服务端加载
  APage:=Self.PageList.Find(APageFID);
  if APage=nil then
  begin
    APage:=TPage.Create(nil);
    Self.PageList.Add(APage);

    APage.ProgramTemplate:=Self;

    APage.fid:=APageFID;

  end;
  if not APage.IsLoaded then
  begin
      //加载
      FOnGetPageExecuteEnd:=AOnGetPageExecuteEnd;
      Self.tteGetPage.TaskObject:=APage;
      Self.tteGetPage.Run();
//  end
//  else
//  begin
//      //激活
//      Self.DoShowPageFrame(APage);

  end;

  Result:=True;

  
end;

function TProgramTemplate.NewPage: TPage;
begin
  Result:=TPage.Create(nil);

  //初始好
  Result.name:='new_page';
  Result.caption:='新建页面';

  if Result.DataInterface<>nil then Result.DataInterface.intf_type:=Const_IntfType_TableCommonRest;

  Result.platform:='pc';


  Result.page_type:=Const_PageType_ViewPage;
  Result.IsLoaded:=True;


  Result.ProgramTemplate:=Self;
  Self.PageList.Add(Result);

end;

function TProgramTemplate.LoadPage(AProgram, AFunction, APageType, APageName, APlatform: String;
                                    AOnGetPageExecuteEnd: TTimerTaskNotify):Boolean;
var
  APage:TPage;
begin
  Result:=False;

  //当找不到了,怎么办?从服务端加载
  APage:=Self.PageList.Find(AFunction,APageType,APageName,APlatform);
  if APage=nil then
  begin
    APage:=TPage.Create(nil);
    Self.PageList.Add(APage);

    APage.ProgramTemplate:=Self;

    APage.program_template_name:=AProgram;
    APage.function_name:=AFunction;
    APage.page_type:=APageType;
    APage.platform:=APlatform;
    APage.name:=APageName;

  end;
  if not APage.IsLoaded then
  begin
      //加载
      FOnGetPageExecuteEnd:=AOnGetPageExecuteEnd;
      Self.tteGetPage.TaskObject:=APage;
      Self.tteGetPage.Run();
//  end
//  else
//  begin
//      //激活
//      Self.DoShowPageFrame(APage);

  end;

  Result:=True;

end;

function TProgramTemplate.SaveToFile(AJsonFilePath: String): Boolean;
var
  ASuperObject:ISuperObject;
begin
  Result:=False;

  ASuperObject:=TSuperObject.Create;
  Self.SaveToJson(ASuperObject);
  SaveStringToFile(//ASuperObject.AsJSON,
                    formatJson(UTFStrToUnicode(ASuperObject.AsJSON)),
                    AJsonFilePath,TEncoding.UTF8);


  //页面列表呢?
  //页面列表保存在同级目录的pages.json中

  Self.PageList.SaveIndexToFile(ExtractFilePath(AJsonFilePath)+'pages.json');



  Result:=True;
end;

function TProgramTemplate.SaveToJson(AJson: ISuperObject): Boolean;
//var
//  ADataIntfListArray:ISuperArray;
//  I: Integer;
//  ADataInterface:TDataInterface;
begin
  Result:=False;


  if fid<>0 then AJson.I['fid']:=fid;
  AJson.I['appid']:=Self.appid;


  AJson.V['user_fid']:=user_fid;


  AJson.S['name']:=name;
  AJson.S['caption']:=caption;
  AJson.S['description']:=description;


//  DataIntfList.Clear();
//  for I := 0 to AJson.A['data_intf_list'].Length-1 do
//  begin
//    ADataInterface:=TDataInterface.Create;
//    ADataInterface.LoadFromJson(AJson.A['data_intf_list'].O[I]);
//    Self.DataIntfList.Add(ADataInterface);
//  end;


  Result:=True;

end;

//procedure TProgramTemplate.LoadFromLocal;
//var
//  ASuperObject:ISuperObject;
//begin
//  if FileExists(GetApplicationPath+'programs\'+name+'\'+'program.json') then
//  begin
//    ASuperObject:=TSuperObject.Create(GetStringFromFile(GetApplicationPath+'program.json',TEncoding.UTF8));
//
//    Self.LoadFromJson(ASuperObject)
//  end;
//end;
//
//procedure TProgramTemplate.SaveToLocal;
//var
//  ASuperObject:ISuperObject;
//begin
//  ASuperObject:=TSuperObject.Create;
//  Self.SaveToJson(ASuperObject);
//  SaveStringToFile(ASuperObject.AsJSON,GetApplicationPath+'programs\'+name+'\'+'program.json',TEncoding.UTF8);
//end;



{ TOpenPlatformProgramSetting }


constructor TOpenPlatformProgramSetting.Create(AOwner:TComponent);
begin
  Inherited;

  //开放平台的APPID,用于获取程序信息,页面结构,默认是1000
  OpenPlatformAppID:=1000;
  //开放平台的服务器,默认是http://www.orangeui.cn:10000/
  OpenPlatformServerUrl:='http://www.orangeui.cn:10000/';
  OpenPlatformImageUrl:='http://www.orangeui.cn:10001/';


//  ProgramTemplate:=TProgramTemplate.Create;

  GlobalMainProgramSetting:=Self;
end;

destructor TOpenPlatformProgramSetting.Destroy;
begin
  GlobalMainProgramSetting:=nil;

//  FreeAndNil(ProgramTemplate);
  inherited;
end;

function TOpenPlatformProgramSetting.Load(AIniFilePath:String):Boolean;
var
  AIniFile:TIniFile;
begin
  Result:=False;

//  if FileExists(GetApplicationPath+'program.ini') then
//  begin
      AIniFile:=TIniFile.Create(AIniFilePath//GetApplicationPath+'program.ini'
                                {$IFNDEF MSWINDOWS},TEncoding.UTF8{$ENDIF});
      try


        //    //开放平台的APPID,用于获取程序信息,页面结构,默认是1000
        //    OpenPlatformAppID:Integer;
        //    //开放平台的服务器,默认是http://www.orangeui.cn:10000/
        //    OpenPlatformServerUrl:String;
        //    //开放平台图片下载的服务器,默认是http://www.orangeui.cn:10001/
        //    OpenPlatformImageUrl:String;
          Self.OpenPlatformAppID:=AIniFile.ReadInteger('','OpenPlatformAppID',1000);
          Self.OpenPlatformServerUrl:=AIniFile.ReadString('','OpenPlatformServerUrl','http://www.orangeui.cn:10000/');
          Self.OpenPlatformImageUrl:=AIniFile.ReadString('','OpenPlatformImageUrl','http://www.orangeui.cn:10001/');



        //    //应用的APPID,比如是1010
        //    AppID:Integer;
        //
        //    //程序模板的名称,比如hospitcal
        //    ProgramTemplateName:String;
        //    //主页的名称,如果为空,那么就显示默认的主页,比如是hospital_office_status
        //    MainPageName:String;
        //    //平台,比如web,pc,app
        //    Platform:String;


          Self.AppID:=AIniFile.ReadInteger('','AppID',0);
          Self.ProgramTemplateName:=AIniFile.ReadString('','ProgramTemplateName','');
          Self.MainPageName:=AIniFile.ReadString('','MainPageName','');
          Self.Platform:=AIniFile.ReadString('','Platform','');

          Self.DataIntfServerUrl:=AIniFile.ReadString('','DataServerUrl','');
          Self.DataIntfImageUrl:=AIniFile.ReadString('','DataImageUrl','');



      finally
        FreeAndNil(AIniFile);
      end;

      Result:=True;
//  end;

end;

procedure TOpenPlatformProgramSetting.Save(AIniFilePath:String);
var
  AIniFile:TIniFile;
begin
  AIniFile:=TIniFile.Create(
                          AIniFilePath//GetApplicationPath+'program.ini'
                          {$IFNDEF MSWINDOWS},TEncoding.UTF8{$ENDIF});


//    //开放平台的APPID,用于获取程序信息,页面结构,默认是1000
//    OpenPlatformAppID:Integer;
//    //开放平台的服务器,默认是http://www.orangeui.cn:10000
//    OpenPlatformServerUrl:String;
//    //开放平台图片下载的服务器,默认是http://www.orangeui.cn:10001
//    OpenPlatformImageUrl:String;
//  Self.OpenPlatformAppID:=AIniFile.ReadInteger('','OpenPlatformAppID',1000);
//  Self.OpenPlatformServerUrl:=AIniFile.ReadString('','OpenPlatformServerUrl','http://www.orangeui.cn:10000/');
//  Self.OpenPlatformImageUrl:=AIniFile.ReadString('','OpenPlatformImageUrl','http://www.orangeui.cn:10001/');

  AIniFile.WriteInteger('','OpenPlatformAppID',Self.OpenPlatformAppID);
  AIniFile.WriteString('','OpenPlatformServerUrl',Self.OpenPlatformServerUrl);
  AIniFile.WriteString('','OpenPlatformImageUrl',Self.OpenPlatformImageUrl);



//    //应用的APPID,比如是1010
//    AppID:Integer;
//
//    //程序模板的名称,比如hospitcal
//    ProgramTemplateName:String;
//    //主页的名称,如果为空,那么就显示默认的主页,比如是hospital_office_status
//    MainPageName:String;
//    //平台,比如web,pc,app
//    Platform:String;
  AIniFile.WriteInteger('','AppID',Self.AppID);
  AIniFile.WriteString('','ProgramTemplateName',Self.ProgramTemplateName);
  AIniFile.WriteString('','MainPageName',Self.MainPageName);
  AIniFile.WriteString('','Platform',Self.Platform);



  AIniFile.WriteString('','DataServerUrl',Self.DataIntfServerUrl);
  AIniFile.WriteString('','DataImageUrl',Self.DataIntfImageUrl);




//  AIniFile.WriteString('','DBType',Self.FDBType);
//
//  AIniFile.WriteString('','DBHostName',Self.FDBHostName);
//  AIniFile.WriteString('','DBHostPort',Self.FDBHostPort);
//  AIniFile.WriteString('','DBUserName',Self.FDBUserName);
//  AIniFile.WriteString('','DBPassword',Self.FDBPassword);
//  AIniFile.WriteString('','DBDataBaseName',Self.FDBDataBaseName);
//  AIniFile.WriteString('','DBCharset',Self.FDBCharset);


  FreeAndNil(AIniFile);

end;


{ TPageDesignPanel }

procedure TPageDesignPanel.AfterPaint;
var
  I: Integer;
  AComponentRect:TRectF;
begin
  inherited;


{$IFDEF FMX}
  //绘制组件列表
  for I := 0 to Self.ComponentCount-1 do
  begin
    if not (csSubComponent in Self.Components[I].ComponentStyle) and not (Self.Components[I] is TControl) then
    begin
      AComponentRect:=GetComponentBoundsRect(Self.Components[I]);

      Canvas.Fill.Color:=TAlphaColorRec.Orange;
      Canvas.FillRect(AComponentRect,0,0,[],1);

      Canvas.Stroke.Thickness:=1;
      Canvas.DrawRect(AComponentRect,0,0,[],1);


      Canvas.Fill.Color:=TAlphaColorRec.Black;
      Canvas.Font.Size:=12;
      Canvas.FillText(AComponentRect,Self.Components[I].Name,True,1,[],TTextAlign.Center);
    end;
  end;
{$ENDIF}

end;

constructor TPageDesignPanel.Create(AOwner: TComponent);
begin
  inherited;
//  AutoCapture := True;
//  ParentBounds := True;
//  FColor := DefaultColor;
//  FShowHandles := True;
//  FMinSize := 15;
//  FGripSize := 3;
//  SetAcceptsControls(False);
end;

destructor TPageDesignPanel.Destroy;
begin
  FreeAndNil(FLoadDataParams);
  FreeAndNil(FLoadDataParams2);

  inherited;
end;

function TPageDesignPanel.GetPageName: String;
begin
  Result:='';

  if Self.FPage<>nil then
  begin
    Result:=FPage.name;
  end;
end;

function TPageDesignPanel.GetPageType: String;
begin
  Result:='';

  if Self.FPage<>nil then
  begin
    Result:=FPage.page_type;
  end;

end;

function TPageDesignPanel.GetPlatform: String;
begin
  Result:='';

  if Self.FPage<>nil then
  begin
    Result:=FPage.platform;
  end;

end;

//function TPageDesignPanel.GetProportionalSize(const ASize: TPointF): TPointF;
//begin
//  Result := ASize;
//  if FRatio * Result.Y  > Result.X  then
//  begin
//    if Result.X < FMinSize then
//      Result.X := FMinSize;
//    Result.Y := Result.X / FRatio;
//    if Result.Y < FMinSize then
//    begin
//      Result.Y := FMinSize;
//      Result.X := FMinSize * FRatio;
//    end;
//  end
//  else
//  begin
//    if Result.Y < FMinSize then
//      Result.Y := FMinSize;
//    Result.X := Result.Y * FRatio;
//    if Result.X < FMinSize then
//    begin
//      Result.X := FMinSize;
//      Result.Y := FMinSize / FRatio;
//    end;
//  end;
//end;

function TPageDesignPanel.GetRefreshSeconds: Integer;
begin
  Result:=0;

  if Self.FPage<>nil then
  begin
    Result:=FPage.refresh_seconds;
  end;
end;

function TPageDesignPanel.GetAlignType: String;
begin
  Result:='';

  if Self.FPage<>nil then
  begin
    Result:=FPage.align_type;
  end;

end;

function TPageDesignPanel.GetCaption: String;
begin
  Result:='';

  if Self.FPage<>nil then
  begin
    Result:=FPage.caption;
  end;

end;

function TPageDesignPanel.GetDataInterface: TDataInterface;
begin
  Result:=nil;

  if (Self.FPage<>nil) then
  begin
    Result:=FPage.DataInterface;
  end;

end;

function TPageDesignPanel.GetDataInterface2: TDataInterface;
begin
  Result:=nil;

  if (Self.FPage<>nil) then
  begin
    Result:=FPage.DataInterface2;
  end;

end;

function TPageDesignPanel.GetDataIntfType: String;
begin
  Result:='';

  if (Self.FPage<>nil) and (FPage.DataInterface<>nil) then
  begin
    Result:=FPage.DataInterface.intf_type;
  end;

end;

function TPageDesignPanel.GetDataIntfType2: String;
begin
  Result:='';

  if (Self.FPage<>nil) and (FPage.DataInterface2<>nil) then
  begin
    Result:=FPage.DataInterface2.intf_type;
  end;

end;

//function TPageDesignPanel.GetDataSQL: String;
//begin
//  if (Self.FPage<>nil) and (FPage.DataInterface<>nil) then
//  begin
//    Result:=FPage.DataInterface;
//  end;
//end;

//function TPageDesignPanel.GetHandleForPoint(const P: TPointF): TGrabHandle;
//var
//  Local, R: TRectF;
//begin
//  Local := LocalRect;
//  R := TRectF.Create(Local.Left - GripSize, Local.Top - GripSize, Local.Left + GripSize, Local.Top + GripSize);
//  if R.Contains(P) then
//    Exit(TGrabHandle.LeftTop);
//  R := TRectF.Create(Local.Right - GripSize, Local.Top - GripSize, Local.Right + GripSize, Local.Top + GripSize);
//  if R.Contains(P) then
//    Exit(TGrabHandle.RightTop);
//  R := TRectF.Create(Local.Right - GripSize, Local.Bottom - GripSize, Local.Right + GripSize, Local.Bottom + GripSize);
//  if R.Contains(P) then
//    Exit(TGrabHandle.RightBottom);
//  R := TRectF.Create(Local.Left - GripSize, Local.Bottom - GripSize, Local.Left + GripSize, Local.Bottom + GripSize);
//  if R.Contains(P) then
//    Exit(TGrabHandle.LeftBottom);
//  Result := TGrabHandle.None;
//end;

function TPageDesignPanel.GetListItemStyleDefaultAutoSize: Boolean;
begin
  Result:=False;

  if Self.FPage<>nil then
  begin
    Result:=(FPage.list_item_style_autosize=1);
  end;
end;

function TPageDesignPanel.GetListItemStyleDefaultHeight: Double;
begin
  Result:=-1;//表示默认

  if Self.FPage<>nil then
  begin
    Result:=FPage.list_item_style_default_height;
  end;
end;

function TPageDesignPanel.GetListItemStyleDefaultWidth: Double;
begin
  Result:=-1;//表示默认

  if Self.FPage<>nil then
  begin
    Result:=FPage.list_item_style_default_width;
  end;
end;

function TPageDesignPanel.GetLoadDataParams: TStringList;
begin
  Result:=nil;

  if (Self.FPage<>nil) then
  begin
    if FLoadDataParams=nil then FLoadDataParams:=TStringList.Create;

    FLoadDataParams.Text:=FPage.load_data_params;
  end;

  Result:=FLoadDataParams;
end;

function TPageDesignPanel.GetLoadDataParams2: TStringList;
begin
  Result:=nil;

  if (Self.FPage<>nil) then
  begin
    if FLoadDataParams2=nil then FLoadDataParams2:=TStringList.Create;

    FLoadDataParams2.Text:=FPage.load_data_params2;
  end;

  Result:=FLoadDataParams2;
end;

//procedure TPageDesignPanel.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
//begin
//  // this line may be necessary because TPageDesignPanel is not a styled control;
//  // must further investigate for a better fix
//  if not Enabled then
//    Exit;
//
//  inherited;
//
//  FDownPos := TPointF.Create(X, Y);
//  if Button = TMouseButton.mbLeft then
//  begin
//    FRatio := Width / Height;
//    FActiveHandle := GetHandleForPoint(FDownPos);
//  end;
//end;
//
//procedure TPageDesignPanel.MouseMove(Shift: TShiftState; X, Y: Single);
//var
//  MoveVector: TVector;
//  MovePos: TPointF;
//  GrabHandle: TGrabHandle;
//begin
//  // this line may be necessary because TPageDesignPanel is not a styled control;
//  // must further investigate for a better fix
//  if not Enabled then
//    Exit;
//
//  inherited;
//
//  MovePos := TPointF.Create(X, Y);
//  if not Pressed then
//  begin
//    // handle painting for hotspot mouse hovering
//    GrabHandle := GetHandleForPoint(MovePos);
//    if GrabHandle <> FHotHandle then
//      Repaint;
//    FHotHandle := GrabHandle;
//  end
//  else if ssLeft in Shift then
//  begin
//    if FActiveHandle = TGrabHandle.None then
//    begin
////      MoveVector := LocalToAbsoluteVector(TVector.Create(X - FDownPos.X, Y - FDownPos.Y));
////      if ParentControl <> nil then
////        MoveVector := ParentControl.AbsoluteToLocalVector(MoveVector);
////      Position.Point := Position.Point + TPointF(MoveVector);
////      if ParentBounds then
////      begin
////        if Position.X < 0 then
////          Position.X := 0;
////        if Position.Y < 0 then
////          Position.Y := 0;
////        if ParentControl <> nil then
////        begin
////          if Position.X + Width > ParentControl.Width then
////            Position.X := ParentControl.Width - Width;
////          if Position.Y + Height > ParentControl.Height then
////            Position.Y := ParentControl.Height - Height;
////        end
////        else
////          if Canvas <> nil then
////          begin
////            if Position.X + Width > Canvas.Width then
////              Position.X := Canvas.Width - Width;
////            if Position.Y + Height > Canvas.Height then
////              Position.Y := Canvas.Height - Height;
////          end;
////      end;
////      if Assigned(FOnTrack) then
////        FOnTrack(Self);
//      Exit;
//    end;
//    MoveHandle(X, Y);
//  end;
//end;
//
//function TPageDesignPanel.PointInObjectLocal(X, Y: Single): Boolean;
//begin
//  Result := inherited or (GetHandleForPoint(TPointF.Create(X, Y)) <> TGrabHandle.None);
//end;
//
//procedure TPageDesignPanel.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
//begin
//  // this line may be necessary because TPageDesignPanel is not a styled control;
//  // must further investigate for a better fix
//  if not Enabled then
//    Exit;
//
//  inherited;
//
//  if Assigned(FOnChange) then
//    FOnChange(Self);
//  FActiveHandle := TGrabHandle.None;
//end;

procedure TPageDesignPanel.DrawFrame(const Canvas: TCanvas; const Rect: TRectF);
begin
  {$IFDEF FMX}
  Canvas.DrawDashRect(Rect, 0, 0, AllCorners, AbsoluteOpacity, FColor);
  {$ENDIF}
end;

//procedure TPageDesignPanel.DrawHandle(const Canvas: TCanvas; const Handle: TGrabHandle; const Rect: TRectF);
//var
//  Fill: TBrush;
//  Stroke: TStrokeBrush;
//begin
//  Fill := TBrush.Create(TBrushKind.Solid, claWhite);
//  Stroke := TStrokeBrush.Create(TBrushKind.Solid, FColor);
//  try
//    if Enabled then
//      if FHotHandle = Handle then
//        Canvas.Fill.Color := claRed
//      else
//        Canvas.Fill.Color := claWhite
//    else
//      Canvas.Fill.Color := claGrey;
//
//    Canvas.FillEllipse(Rect, AbsoluteOpacity, Fill);
//    Canvas.DrawEllipse(Rect, AbsoluteOpacity, Stroke);
//  finally
//    Fill.Free;
//    Stroke.Free;
//  end;
//end;

procedure TPageDesignPanel.Paint;
var
  R: TRectF;
begin
//  if FHideSelection then
//    Exit;

  {$IFDEF FMX}

  R := LocalRect;
  R.Inflate(-0.5, -0.5);
  DrawFrame(Canvas, R);
  {$ENDIF}

//  if ShowHandles then
//  begin
//    R := LocalRect;
//    DrawHandle(Canvas, TGrabHandle.LeftTop, TRectF.Create(R.Left - GripSize, R.Top - GripSize, R.Left + GripSize,
//      R.Top + GripSize));
//    DrawHandle(Canvas, TGrabHandle.RightTop, TRectF.Create(R.Right - GripSize, R.Top - GripSize, R.Right + GripSize,
//      R.Top + GripSize));
//    DrawHandle(Canvas, TGrabHandle.LeftBottom, TRectF.Create(R.Left - GripSize, R.Bottom - GripSize, R.Left + GripSize,
//      R.Bottom + GripSize));
//    DrawHandle(Canvas, TGrabHandle.RightBottom, TRectF.Create(R.Right - GripSize, R.Bottom - GripSize,
//      R.Right + GripSize, R.Bottom + GripSize));
//  end;


end;

//function TPageDesignPanel.DoGetUpdateRect: TRectF;
//begin
//  Result := inherited;
//  Result.Inflate((FGripSize + 1) * Scale.X, (FGripSize + 1) * Scale.Y);
//end;
//
//
//procedure TPageDesignPanel.ResetInSpace(const ARotationPoint: TPointF; ASize: TPointF);
//var
//  LLocalPos: TPointF;
//  LAbsPos: TPointF;
//begin
//  LAbsPos := LocalToAbsolute(ARotationPoint);
//  if ParentControl <> nil then
//  begin
//    LLocalPos := ParentControl.AbsoluteToLocal(LAbsPos);
//    LLocalPos.X := LLocalPos.X - ASize.X * RotationCenter.X * Scale.X;
//    LLocalPos.Y := LLocalPos.Y - ASize.Y * RotationCenter.Y * Scale.Y;
//    if ParentBounds then
//    begin
//      if LLocalPos.X < 0 then
//      begin
//        ASize.X := ASize.X + LLocalPos.X;
//        LLocalPos.X := 0;
//      end;
//      if LLocalPos.Y < 0 then
//      begin
//        ASize.Y := ASize.Y + LLocalPos.Y;
//        LLocalPos.Y := 0;
//      end;
//      if LLocalPos.X + ASize.X > ParentControl.Width then
//        ASize.X := ParentControl.Width - LLocalPos.X;
//      if LLocalPos.Y + ASize.Y > ParentControl.Height then
//        ASize.Y := ParentControl.Height - LLocalPos.Y;
//    end;
//  end
//  else
//  begin
//    LLocalPos.X := LAbsPos.X - ASize.X * RotationCenter.X * Scale.X;
//    LLocalPos.Y := LAbsPos.Y - ASize.Y * RotationCenter.Y * Scale.Y;
//  end;
//  SetBounds(LLocalPos.X, LLocalPos.Y, ASize.X, ASize.Y);
//end;
//
//procedure TPageDesignPanel.GetTransformLeftTop(AX, AY: Single; var NewSize: TPointF; var Pivot: TPointF);
//var
//  LCorrect: TPointF;
//begin
//  NewSize := Size.Size - TSizeF.Create(AX, AY);
//  if NewSize.Y < FMinSize then
//  begin
//    AY := Height - FMinSize;
//    NewSize.Y := FMinSize;
//  end;
//  if NewSize.X < FMinSize then
//  begin
//    AX := Width - FMinSize;
//    NewSize.X := FMinSize;
//  end;
//  if FProportional then
//  begin
//    LCorrect := NewSize;
//    NewSize := GetProportionalSize(NewSize);
//    LCorrect := LCorrect - NewSize;
//    AX := AX + LCorrect.X;
//    AY := AY + LCorrect.Y;
//  end;
//  Pivot := TPointF.Create(Width * RotationCenter.X + AX * (1 - RotationCenter.X),
//    Height * RotationCenter.Y + AY * (1 - RotationCenter.Y));
//end;
//
//procedure TPageDesignPanel.GetTransformLeftBottom(AX, AY: Single; var NewSize: TPointF; var Pivot: TPointF);
//var
//  LCorrect: TPointF;
//begin
//  NewSize := TPointF.Create(Width - AX, AY);
//  if NewSize.Y < FMinSize then
//  begin
//    AY := FMinSize;
//    NewSize.Y := FMinSize;
//  end;
//  if NewSize.X < FMinSize then
//  begin
//    AX := Width - FMinSize;
//    NewSize.X := FMinSize;
//  end;
//  if FProportional then
//  begin
//    LCorrect := NewSize;
//    NewSize := GetProportionalSize(NewSize);
//    LCorrect := LCorrect - NewSize;
//    AX := AX + LCorrect.X;
//    AY := AY - LCorrect.Y;
//  end;
//  Pivot := TPointF.Create(Width * RotationCenter.X + AX * (1 - RotationCenter.X),
//    Height * RotationCenter.Y + (AY - Height) * RotationCenter.Y);
//end;
//
//procedure TPageDesignPanel.GetTransformRightTop(AX, AY: Single; var NewSize: TPointF; var Pivot: TPointF);
//var
//  LCorrect: TPointF;
//begin
//  NewSize := TPointF.Create(AX, Height - AY);
//  if NewSize.Y < FMinSize then
//  begin
//    AY := Height - FMinSize;
//    NewSize.Y := FMinSize;
//  end;
//  if AX < FMinSize then
//  begin
//    AX := FMinSize;
//    NewSize.X := FMinSize;
//  end;
//  if FProportional then
//  begin
//    LCorrect := NewSize;
//    NewSize := GetProportionalSize(NewSize);
//    LCorrect := LCorrect - NewSize;
//    AX := AX - LCorrect.X;
//    AY := AY + LCorrect.Y;
//  end;
//  Pivot := TPointF.Create(Width * RotationCenter.X + (AX - Width) * RotationCenter.X,
//    Height * RotationCenter.Y + AY * (1 - RotationCenter.Y));
//end;
//
//procedure TPageDesignPanel.GetTransformRightBottom(AX, AY: Single; var NewSize: TPointF; var Pivot: TPointF);
//var
//  LCorrect: TPointF;
//begin
//  NewSize := TPointF.Create(AX, AY);
//  if NewSize.Y < FMinSize then
//  begin
//    AY := FMinSize;
//    NewSize.Y := FMinSize;
//  end;
//  if NewSize.X < FMinSize then
//  begin
//    AX := FMinSize;
//    NewSize.X := FMinSize;
//  end;
//  if FProportional then
//  begin
//    LCorrect := NewSize;
//    NewSize := GetProportionalSize(NewSize);
//    LCorrect := LCorrect - NewSize;
//    AX := AX - LCorrect.X;
//    AY := AY - LCorrect.Y;
//  end;
//  Pivot := TPointF.Create(Width * RotationCenter.X + (AX - Width) * RotationCenter.X,
//    Height * RotationCenter.Y + (AY - Height) * RotationCenter.Y);
//end;
//
//procedure TPageDesignPanel.MoveHandle(AX, AY: Single);
//var
//  NewSize, Pivot: TPointF;
//begin
//  case FActiveHandle of
//    TPageDesignPanel.TGrabHandle.LeftTop: GetTransformLeftTop(AX, AY, NewSize, Pivot);
//    TPageDesignPanel.TGrabHandle.LeftBottom: GetTransformLeftBottom(AX, AY, NewSize, Pivot);
//    TPageDesignPanel.TGrabHandle.RightTop: GetTransformRightTop(AX, AY, NewSize, Pivot);
//    TPageDesignPanel.TGrabHandle.RightBottom: GetTransformRightBottom(AX, AY, NewSize, Pivot);
//  end;
//  ResetInSpace(Pivot, NewSize);
//  if Assigned(FOnTrack) then
//    FOnTrack(Self);
//end;
//
//procedure TPageDesignPanel.DoMouseLeave;
//begin
//  inherited;
//  FHotHandle := TGrabHandle.None;
//  Repaint;
//end;
//
//procedure TPageDesignPanel.SetHideSelection(const Value: Boolean);
//begin
//  if FHideSelection <> Value then
//  begin
//    FHideSelection := Value;
//    Repaint;
//  end;
//end;

procedure TPageDesignPanel.SetListItemStyleDefaultAutoSize(
  const Value: Boolean);
begin
  if (Self.FPage<>nil) then
  begin
    FPage.list_item_style_autosize:=Ord(Value);
  end;
end;

procedure TPageDesignPanel.SetListItemStyleDefaultHeight(const Value: Double);
begin
  if (Self.FPage<>nil) then
  begin
    FPage.list_item_style_default_height:=Value;
  end;
end;

procedure TPageDesignPanel.SetListItemStyleDefaultWidth(const Value: Double);
begin
  if (Self.FPage<>nil) then
  begin
    FPage.list_item_style_default_width:=Value;
  end;
end;

procedure TPageDesignPanel.SetLoadDataParams(const Value: TStringList);
begin
  if (Self.FPage<>nil) then
  begin
    FLoadDataParams.Assign(Value);
    FPage.load_data_params:=FLoadDataParams.Text;
  end;
end;

procedure TPageDesignPanel.SetLoadDataParams2(const Value: TStringList);
begin
  if (Self.FPage<>nil) then
  begin
    FLoadDataParams2.Assign(Value);
    FPage.load_data_params2:=FLoadDataParams2.Text;
  end;
end;

//procedure TPageDesignPanel.SetMinSize(const Value: Integer);
//begin
//  if FMinSize <> Value then
//  begin
//    FMinSize := Value;
//    if FMinSize < 1 then
//      FMinSize := 1;
//  end;
//end;

procedure TPageDesignPanel.SetPageName(const Value: String);
begin
  if Self.FPage<>nil then
  begin
    FPage.name:=Value;
  end;


end;

procedure TPageDesignPanel.SetPageType(const Value: String);
begin
  if Self.FPage<>nil then
  begin
    FPage.page_type:=Value;
  end;


end;

procedure TPageDesignPanel.SetPlatform(const Value: String);
begin
  if Self.FPage<>nil then
  begin
    FPage.platform:=Value;
  end;

end;

procedure TPageDesignPanel.SetRefreshSeconds(const Value: Integer);
begin
  if Self.FPage<>nil then
  begin
    FPage.refresh_seconds:=Value;
  end;
end;

//procedure TPageDesignPanel.SetShowHandles(const Value: Boolean);
//begin
//  if FShowHandles <> Value then
//  begin
//    FShowHandles := Value;
//    Repaint;
//  end;
//end;

procedure TPageDesignPanel.SetAlignType(const Value: String);
begin
  if Self.FPage<>nil then
  begin
    FPage.align_type:=Value;
  end;

end;

procedure TPageDesignPanel.SetCaption(const Value: String);
begin
  if Self.FPage<>nil then
  begin
    FPage.caption:=Value;
  end;

end;

//procedure TPageDesignPanel.SetColor(const Value: TAlphaColor);
//begin
//  if FColor <> Value then
//  begin
//    FColor := Value;
//    Repaint;
//  end;
//end;

procedure TPageDesignPanel.SetDataInterface(const Value: TDataInterface);
begin
  if (Self.FPage<>nil) and (FPage.DataInterface<>nil) then
  begin
    FPage.DataInterface.Assign(Value);
  end;
end;

procedure TPageDesignPanel.SetDataInterface2(const Value: TDataInterface);
begin
  if (Self.FPage<>nil) and (FPage.DataInterface2<>nil) then
  begin
    FPage.DataInterface2.Assign(Value);
  end;
end;

procedure TPageDesignPanel.SetDataIntfType(const Value: String);
begin

  if (Self.FPage<>nil) and (FPage.DataInterface<>nil) then
  begin
    FPage.DataInterface.intf_type:=Value;
  end;

end;

procedure TPageDesignPanel.SetDataIntfType2(const Value: String);
begin

  if (Self.FPage<>nil) and (FPage.DataInterface2<>nil) then
  begin
    FPage.DataInterface2.intf_type:=Value;
  end;

end;

//procedure TPageDesignPanel.SetDataSQL(const Value: String);
//begin
//
//end;

//procedure TPageDesignPanel.SetGripSize(const Value: Single);
//begin
//  if FGripSize <> Value then
//  begin
//    if Value < FGripSize then
//      Repaint;
//    FGripSize := Value;
//    if FGripSize > 20 then
//      FGripSize := 20;
//    if FGripSize < 1 then
//      FGripSize := 1;
//    HandleSizeChanged;
//    Repaint;
//  end;
//end;








//{ TLoadDataSetting }
//
//constructor TLoadDataSetting.Create;
//begin
//    PageIndex:=1;
//    PageSize:=20;
//end;








{ TFieldControlSettingHelper }




function TFieldControlSettingHelper.LoadFromJson(AJson: ISuperObject): Boolean;
begin
  Result:=False;

  try

      fid:=AJson.I['fid'];
      Self.appid:=AJson.I['appid'];


      //所属页面的FID
      page_fid:=AJson.I['page_fid'];
      //布局的FID
    //  layout_fid:=AJson.I['layout_fid'];
      control_style:=AJson.S['control_style'];


      //父控件的id
      parent_control_fid:=AJson.I['parent_control_fid'];
      parent_control_name:=AJson.S['parent_control_name'];



      name:=AJson.S['name'];
      control_type:=AJson.S['control_type'];


      field_name:=AJson.S['field_name'];
      action:=AJson.S['action'];
      field_caption:=AJson.S['field_caption'];

      value:=AJson.S['value'];
      visible:=AJson.I['visible'];
      hittest:=AJson.I['hittest'];
      enabled:=AJson.I['enabled'];


      x:=AJson.F['x'];
      y:=AJson.F['y'];
      width:=AJson.F['width'];
      height:=AJson.F['height'];
      margins:=AJson.S['margins'];


      anchors:=AJson.S['anchors'];
      align:=AJson.S['align'];


      back_color:=AJson.S['back_color'];
      border_color:=AJson.S['border_color'];
      border_width:=AJson.F['border_width'];
      border_edges:=AJson.S['border_edges'];

      back_round_width:=AJson.F['back_round_width'];
      back_corners:=AJson.S['back_corners'];


      text_font_name:=AJson.S['text_font_name'];
      text_font_size:=AJson.I['text_font_size'];
      text_font_color:=AJson.S['text_font_color'];
      text_vert_align:=AJson.S['text_vert_align'];
      text_horz_align:=AJson.S['text_horz_align'];
      text_style:=AJson.S['text_style'];
      text_wordwrap:=AJson.I['text_wordwrap'];



      //图片是否拉伸
      picture_is_stretch:=AJson.I['picture_is_stretch'];
      //图片是否自适应
      picture_is_autofit:=AJson.I['picture_is_autofit'];
      picture_vert_align:=AJson.S['picture_vert_align'];
      picture_horz_align:=AJson.S['picture_horz_align'];



  //    //图片路径
  //    pic_path:String;
      image_kind:=AJson.S['image_kind'];//	int	图片是否需要裁剪
      image_is_need_clip:=AJson.I['image_is_need_clip'];//	int	图片是否需要裁剪
      image_clip_width:=AJson.I['image_clip_width'];//	int	裁剪图片的宽度
      image_clip_height:=AJson.I['image_clip_height'];//	int	裁剪图片的高度
      image_max_count:=AJson.I['image_max_count'];//	int	最多支持添加几张图片,0表示默认1
      //image_upload_url	nvarchar(255)	上传图片的接口地址,
      //比如：http://www.orangeui.cn:10011/upload?appid=1003&filename=%s&filedir=repair_car_order_pic&fileext=.jpg
      other_field_names:=AJson.S['other_field_names'];//	nvarchar(45)	图片宽度的字段名,比如pic1_width,创建这个控件，在选择好图片之后赋宽度给它
      other_field_controlprops:=AJson.S['other_field_controlprops'];//	nvarchar(45)	图片宽度的字段名,比如pic1_width,创建这个控件，在选择好图片之后赋宽度给它




      has_caption_label:=AJson.I['has_caption_label'];



      input_format:=AJson.S['input_format'];//	nvarchar(45)	输入格式要求，保存的时候要使用,相关的控件是edit,comboedit
      //		number,只允许输入数字
      //		email,必须是email
      //		phone,必须是手机号
      input_prompt:=AJson.S['input_prompt'];//	nvarchar(255)	输入提示,比如请输入密码
      input_max_length:=AJson.I['input_max_length'];//	int	输入字符串的最大长度
      input_read_only:=AJson.I['input_read_only'];//	int	是否只读






      options_value:=AJson.S['options_value'];
      options_caption:=AJson.S['options_caption'];
      options_is_multi_select:=AJson.I['options_is_multi_select'];//	int	是否支持多选

      options_page_fid:=AJson.I['options_page_fid'];//	int	选择选项的列表页面fid,它里面包含数据接口
      options_page_name:=AJson.S['options_page_name'];//	int	选择选项的列表页面fid,它里面包含数据接口
      options_page_value_field_name:=AJson.S['options_page_value_field_name'];//	nvarchar(45)	选择选项列表页面的值字段
      options_page_caption_field_name:=AJson.S['options_page_caption_field_name'];//	nvarchar(45)	选择选项列表页面的标题字段
      options_has_empty:=AJson.I['options_has_empty'];//	int	是否拥有空的选项
      options_empty_value:=AJson.S['options_empty_value'];//	nvarchar(45)
      options_empty_caption:=AJson.S['options_empty_caption'];//	nvarchar(45)
      options_caption_field_name:=AJson.S['options_caption_field_name'];//	nvarchar(45)//在编辑页面和查看页面能直接取到值的标题



      page_part:=AJson.S['page_part'];



      bind_listitem_data_type:=AJson.S['bind_listitem_data_type'];
      prop:=AJson.S['prop'];

      orderno:=AJson.F['orderno'];
      is_deleted:=AJson.I['is_deleted'];



      control_page_fid:=AJson.I['control_page_fid'];
      control_page_name:=AJson.S['control_page_name'];



      jump_to_page_program:=AJson.S['jump_to_page_program'];//	nvarchar(255)	跳转到指定的页面的程序模板name,比如ycliving
      jump_to_page_function:=AJson.S['jump_to_page_function'];//	nvarchar(255)	跳转到指定的页面的功能name,比如shop_goods_manage
      jump_to_page_name:=AJson.S['jump_to_page_name'];//	nvarchar(255)	跳转到指定的页面的页面name,比如goods_list_page
      jump_to_page_type:=AJson.S['jump_to_page_type'];//	nvarchar(255)	跳转到指定的页面的页面类型,list_page

      jump_to_page_fid:=AJson.I['jump_to_page_fid'];//	int	跳转到指定的页面的页面fid,比较直接



      Result:=True;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'TFieldControlSetting.LoadFromJson');
    end;
  end;
end;

function TFieldControlSettingHelper.SaveToJson(AJson: ISuperObject): Boolean;
begin
  Result:=False;


  AJson.S['name']:=name;
  AJson.S['control_type']:=control_type;


  if fid<>0 then AJson.I['fid']:=fid;
  if appid<>0 then AJson.I['appid']:=Self.appid;


  //所属页面的FID
  if page_fid<>0 then AJson.I['page_fid']:=page_fid;
  //布局的FID
//  if layout_fid<>0 then AJson.I['layout_fid']:=layout_fid;

  if control_style<>'' then AJson.S['control_style']:=control_style;


  //父控件的id
  if parent_control_fid<>0 then AJson.I['parent_control_fid']:=parent_control_fid;
  if parent_control_name<>'' then AJson.S['parent_control_name']:=parent_control_name;




  if field_name<>'' then AJson.S['field_name']:=field_name;
  if field_name<>'' then AJson.S['action']:=action;


  if value<>'' then AJson.S['value']:=value;
  //if visible=0 then
  AJson.I['visible']:=visible;
  //if hittest=0 then
  AJson.I['hittest']:=hittest;
  //if enabled=0 then
  AJson.I['enabled']:=enabled;


  AJson.F['x']:=x;
  AJson.F['y']:=y;
  AJson.F['width']:=width;
  AJson.F['height']:=height;
  if (margins<>'') and (margins<>'0,0,0,0') then AJson.S['margins']:=margins;


  if anchors<>'' then AJson.S['anchors']:=anchors;
  if (align<>'') and (align<>'None') then AJson.S['align']:=align;


  if back_color<>'' then AJson.S['back_color']:=back_color;
  if border_color<>'' then AJson.S['border_color']:=border_color;
  if border_width<>0 then AJson.F['border_width']:=border_width;
  if border_edges<>'' then AJson.S['border_edges']:=border_edges;


  if back_round_width<>0 then AJson.F['back_round_width']:=back_round_width;
  if back_corners<>'' then AJson.S['back_corners']:=back_corners;



  if text_font_name<>'' then AJson.S['text_font_name']:=text_font_name;
  if text_font_size<>0 then AJson.I['text_font_size']:=text_font_size;

  //if (text_font_color<>'') and (text_font_color<>'FF000000') then
  AJson.S['text_font_color']:=text_font_color;

  if (text_vert_align<>'') and (text_vert_align<>'Top') then AJson.S['text_vert_align']:=text_vert_align;
  if (text_horz_align<>'') and (text_horz_align<>'Left') then AJson.S['text_horz_align']:=text_horz_align;
  if text_style<>'' then AJson.S['text_style']:=text_style;
  if text_wordwrap<>0 then AJson.I['text_wordwrap']:=text_wordwrap;



  if picture_is_stretch<>0 then AJson.I['picture_is_stretch']:=picture_is_stretch;
  if picture_is_autofit<>0 then AJson.I['picture_is_autofit']:=picture_is_autofit;
  if (picture_vert_align<>'') and (picture_vert_align<>'Top') then AJson.S['picture_vert_align']:=picture_vert_align;
  if (picture_horz_align<>'') and (picture_horz_align<>'Left') then AJson.S['picture_horz_align']:=picture_horz_align;



//    //图片路径
//    pic_path:String;
  if image_kind<>'' then AJson.S['image_kind']:=image_kind;//	int	图片是否需要裁剪
  if image_is_need_clip<>0 then AJson.I['image_is_need_clip']:=image_is_need_clip;//	int	图片是否需要裁剪
  if image_clip_width<>0 then AJson.I['image_clip_width']:=image_clip_width;//	int	裁剪图片的宽度
  if image_clip_height<>0 then AJson.I['image_clip_height']:=image_clip_height;//	int	裁剪图片的高度
  if image_max_count<>0 then AJson.I['image_max_count']:=image_max_count;//	int	最多支持添加几张图片,0表示默认1
  //image_upload_url	nvarchar(255)	上传图片的接口地址,
  //比如：http://www.orangeui.cn:10011/upload?appid=1003&filename=%s&filedir=repair_car_order_pic&fileext=.jpg
  if other_field_names<>'' then AJson.S['other_field_names']:=other_field_names;//	nvarchar(45)	图片宽度的字段名,比如pic1_width,创建这个控件，在选择好图片之后赋宽度给它
  if other_field_controlprops<>'' then AJson.S['other_field_controlprops']:=other_field_controlprops;//	nvarchar(45)	图片宽度的字段名,比如pic1_width,创建这个控件，在选择好图片之后赋宽度给它




  if has_caption_label<>0 then AJson.I['has_caption_label']:=has_caption_label;


  if input_format<>'' then AJson.S['input_format']:=input_format;//	nvarchar(45)	输入格式要求，保存的时候要使用,相关的控件是edit,comboedit
  //		number,只允许输入数字
  //		email,必须是email
  //		phone,必须是手机号
  if input_prompt<>'' then AJson.S['input_prompt']:=input_prompt;//	nvarchar(255)	输入提示,比如请输入密码
  if input_max_length<>0 then AJson.I['input_max_length']:=input_max_length;//	int	输入字符串的最大长度
  if input_read_only<>0 then AJson.I['input_read_only']:=input_read_only;//	int	是否只读




  if options_value<>'' then AJson.S['options_value']:=options_value;
  if options_caption<>'' then AJson.S['options_caption']:=options_caption;

  if options_page_fid<>0 then AJson.I['options_page_fid']:=options_page_fid;//	int	选择选项的列表页面fid,它里面包含数据接口
  if options_page_name<>'' then AJson.S['options_page_name']:=options_page_name;//	int	选择选项的列表页面fid,它里面包含数据接口
  if options_page_value_field_name<>'' then AJson.S['options_page_value_field_name']:=options_page_value_field_name;//	nvarchar(45)	选择选项列表页面的值字段
  if options_page_caption_field_name<>'' then AJson.S['options_page_caption_field_name']:=options_page_caption_field_name;//	nvarchar(45)	选择选项列表页面的标题字段
  if options_has_empty<>0 then AJson.I['options_has_empty']:=options_has_empty;//	int	是否拥有空的选项
  if options_empty_value<>'' then AJson.S['options_empty_value']:=options_empty_value;//	nvarchar(45)
  if options_empty_caption<>'' then AJson.S['options_empty_caption']:=options_empty_caption;//	nvarchar(45)

  if options_caption_field_name<>'' then AJson.S['options_caption_field_name']:=options_caption_field_name;




  if page_part<>'' then AJson.S['page_part']:=page_part;



  if bind_listitem_data_type<>'' then AJson.S['bind_listitem_data_type']:=bind_listitem_data_type;

  if prop<>'' then AJson.S['prop']:=prop;

  if orderno<>0 then AJson.F['orderno']:=orderno;
  if is_deleted<>0 then AJson.I['is_deleted']:=is_deleted;


  //子页面
  if control_page_fid<>0 then AJson.I['control_page_fid']:=control_page_fid;
  if control_page_name<>'' then AJson.S['control_page_name']:=control_page_name;




  if jump_to_page_program<>'' then AJson.S['jump_to_page_program']:=jump_to_page_program;//	nvarchar(255)	跳转到指定的页面的程序模板name,比如ycliving
  if jump_to_page_function<>'' then AJson.S['jump_to_page_function']:=jump_to_page_function;//	nvarchar(255)	跳转到指定的页面的功能name,比如shop_goods_manage
  if jump_to_page_name<>'' then AJson.S['jump_to_page_name']:=jump_to_page_name;//	nvarchar(255)	跳转到指定的页面的页面name,比如goods_list_page
  if jump_to_page_type<>'' then AJson.S['jump_to_page_type']:=jump_to_page_type;//	nvarchar(255)	跳转到指定的页面的页面类型,list_page

  if jump_to_page_fid<>0 then AJson.I['jump_to_page_fid']:=jump_to_page_fid;//	int	跳转到指定的页面的页面fid,比较直接



  Result:=True;
end;

function TFieldControlSettingHelper.SaveToUpdateJson(AJson: ISuperObject;AOldSetting: TFieldControlSetting;var AIsChanged:Boolean): Boolean;
begin
  Result:=False;
  AIsChanged:=False;


//  if fid<>0 then
  AJson.I['fid']:=fid;
//  if appid<>0 then
  AJson.I['appid']:=Self.appid;


  //所属页面的FID
//  if page_fid<>0 then
  if page_fid<>AOldSetting.page_fid then
  begin
    AIsChanged:=True;
    AJson.I['page_fid']:=page_fid;
  end;
  //布局的FID
//  if layout_fid<>0 then AJson.I['layout_fid']:=layout_fid;


  //父控件的id
//  if parent_control_fid<>0 then
  if parent_control_fid<>AOldSetting.parent_control_fid then
  begin
    AIsChanged:=True;
    AJson.I['parent_control_fid']:=parent_control_fid;
  end;


  if parent_control_name<>AOldSetting.parent_control_name then
  begin
    AIsChanged:=True;
    AJson.S['parent_control_name']:=parent_control_name;
  end;




  if name<>AOldSetting.name then
  begin
    AIsChanged:=True;
    AJson.S['name']:=name;
  end;
  if control_type<>AOldSetting.control_type then
  begin
    AIsChanged:=True;
    AJson.S['control_type']:=control_type;
  end;

  if field_name<>AOldSetting.field_name then
  begin
    AIsChanged:=True;
    AJson.S['field_name']:=field_name;
  end;


  if value<>AOldSetting.value then
  begin
    AIsChanged:=True;
    AJson.S['value']:=value;
  end;
  if visible<>AOldSetting.visible then
  begin
    AIsChanged:=True;
    AJson.I['visible']:=visible;
  end;
  if hittest<>AOldSetting.hittest then
  begin
    AIsChanged:=True;
    AJson.I['hittest']:=hittest;
  end;
  if enabled<>AOldSetting.enabled then
  begin
    AIsChanged:=True;
    AJson.I['enabled']:=enabled;
  end;


  if x<>AOldSetting.x then
  begin
    AIsChanged:=True;
    AJson.F['x']:=x;
  end;
  if y<>AOldSetting.y then
  begin
    AIsChanged:=True;
    AJson.F['y']:=y;
  end;
  if width<>AOldSetting.width then
  begin
    AIsChanged:=True;
    AJson.F['width']:=width;
  end;
  if height<>AOldSetting.height then
  begin
    AIsChanged:=True;
    AJson.F['height']:=height;
  end;
  if margins<>AOldSetting.margins then
  begin
    AIsChanged:=True;
    AJson.S['margins']:=margins;
  end;


  if anchors<>AOldSetting.anchors then
  begin
    AIsChanged:=True;
    AJson.S['anchors']:=anchors;
  end;
  if align<>AOldSetting.align then
  begin
    AIsChanged:=True;
    AJson.S['align']:=align;
  end;


  if back_color<>AOldSetting.back_color then
  begin
    AIsChanged:=True;
    AJson.S['back_color']:=back_color;
  end;
  if border_color<>AOldSetting.border_color then
  begin
    AIsChanged:=True;
    AJson.S['border_color']:=border_color;
  end;
  if border_width<>AOldSetting.border_width then
  begin
    AIsChanged:=True;
    AJson.F['border_width']:=border_width;
  end;
  if border_edges<>AOldSetting.border_edges then
  begin
    AIsChanged:=True;
    AJson.S['border_edges']:=border_edges;
  end;


  if back_round_width<>AOldSetting.back_round_width then
  begin
    AIsChanged:=True;
    AJson.F['back_round_width']:=back_round_width;
  end;
  if back_corners<>AOldSetting.back_corners then
  begin
    AIsChanged:=True;
    AJson.S['back_corners']:=back_corners;
  end;



  if text_font_name<>AOldSetting.text_font_name then
  begin
    AIsChanged:=True;
    AJson.S['text_font_name']:=text_font_name;
  end;
  if text_font_size<>AOldSetting.text_font_size then
  begin
    AIsChanged:=True;
    AJson.I['text_font_size']:=text_font_size;
  end;
  if text_font_color<>AOldSetting.text_font_color then
  begin
    AIsChanged:=True;
    AJson.S['text_font_color']:=text_font_color;
  end;
  if text_vert_align<>AOldSetting.text_vert_align then
  begin
    AIsChanged:=True;
    AJson.S['text_vert_align']:=text_vert_align;
  end;
  if text_horz_align<>AOldSetting.text_horz_align then
  begin
    AIsChanged:=True;
    AJson.S['text_horz_align']:=text_horz_align;
  end;
  if text_style<>AOldSetting.text_style then
  begin
    AIsChanged:=True;
    AJson.S['text_style']:=text_style;
  end;
  if text_wordwrap<>AOldSetting.text_wordwrap then
  begin
    AIsChanged:=True;
    AJson.I['text_wordwrap']:=text_wordwrap;
  end;



  if picture_is_stretch<>AOldSetting.picture_is_stretch then
  begin
    AIsChanged:=True;
    AJson.I['picture_is_stretch']:=picture_is_stretch;
  end;
  if picture_is_autofit<>AOldSetting.picture_is_autofit then
  begin
    AIsChanged:=True;
    AJson.I['picture_is_autofit']:=picture_is_autofit;
  end;
  if picture_vert_align<>AOldSetting.picture_vert_align then
  begin
    AIsChanged:=True;
    AJson.S['picture_vert_align']:=picture_vert_align;
  end;
  if picture_horz_align<>AOldSetting.picture_horz_align then
  begin
    AIsChanged:=True;
    AJson.S['picture_horz_align']:=picture_horz_align;
  end;


  if has_caption_label<>AOldSetting.has_caption_label then
  begin
    AIsChanged:=True;
    AJson.I['has_caption_label']:=has_caption_label;
  end;


  if bind_listitem_data_type<>AOldSetting.bind_listitem_data_type then
  begin
    AIsChanged:=True;
    AJson.S['bind_listitem_data_type']:=bind_listitem_data_type;
  end;

  if prop<>AOldSetting.prop then
  begin
    AIsChanged:=True;
    AJson.S['prop']:=prop;
  end;

  if orderno<>AOldSetting.orderno then
  begin
    AIsChanged:=True;
    AJson.F['orderno']:=orderno;
  end;
  if is_deleted<>AOldSetting.is_deleted then
  begin
    AIsChanged:=True;
    AJson.I['is_deleted']:=is_deleted;
  end;





  //除了fid和appid还有别的改过了
  //AIsChanged:=(GetJsonCount(AJson)>2);


  Result:=True;


end;






{ TListItemBindings }

function TListItemBindings.Add: TListItemBindingItem;
begin
  Result:=TListItemBindingItem(Inherited Add);
end;

function TListItemBindings.GetItem(Index: Integer): TListItemBindingItem;
begin
  Result:=TListItemBindingItem(Inherited Items[Index]);
end;

procedure TListItemBindings.LoadFromJson(AJson: ISuperObject);
var
  AJsonNameArray:TStringDynArray;
  I: Integer;
  AListItemBindingItem:TListItemBindingItem;
begin
  Clear;

  AJsonNameArray:=GetJsonNameArray(AJson);
  for I := 0 to Length(AJsonNameArray)-1 do
  begin
    //列表项属性与数据字段的绑定
    AListItemBindingItem:=Self.Add;
    AListItemBindingItem.item_field_name:=AJsonNameArray[I];
    AListItemBindingItem.data_field_name:=AJson.S[AJsonNameArray[I]];
  end;


//  Self.FDefaultListItemBindings.Clear;
//  if ASuperObject.Contains('ItemCaption') then
//  begin
//    //列表项属性与数据字段的绑定
//    AListItemBindingItem:=Self.FDefaultListItemBindings.Add;
//    AListItemBindingItem.item_field_name:='ItemCaption';
//    AListItemBindingItem.data_field_name:=ASuperObject.S['ItemCaption'];
//  end;

end;

procedure TListItemBindings.SaveToJson(AJson: ISuperObject);
var
  I: Integer;
begin
  for I := 0 to Count-1 do
  begin
    AJson.S[Items[I].item_field_name]:=Items[I].data_field_name;
  end;
end;

{ TEditPageInstance }

//function TEditPageInstance.CallDelDataInterface:Boolean;
//begin
//  inherited;
//
//  Result:=Self.PageStructure.DataInterface.DelData(
//                                                  Self.FLoadDataIntfResult,
//                                                  Self.FDelDataIntfResult
//                                                  );
//
//end;

procedure TEditPageInstance.DoDelRecordAction;
begin
  inherited;
  //删除当前记录

  //删除之后返回上一页



end;

procedure TEditPageInstance.DoPageLayoutControlClick(Sender: TObject;
                                                    APageLayoutControlMap: TFieldControlSettingMap);
//var
//  ALoadDataSetting:TLoadDataSetting;
begin
  inherited;

  if SameText(APageLayoutControlMap.Setting.Action,Const_PageAction_CancelSaveRecord) then
  begin
      //取消保存
      Self.DoReturnPageAction(Self);
  end
  else if SameText(APageLayoutControlMap.Setting.Action,Const_PageAction_DelRecord) then
  begin
      //删除记录
      Self.DoDelRecordAction;
  end
  else if APageLayoutControlMap.Setting.options_page_fid>0 then
  begin

//      //跳转到选项选择页面,一般是列表页面进行选择,选择后返回
//      if Assigned(GlobalMainProgramSetting.OnNeedShowPage) then
//      begin
//          //你怎么知道一定是列表页面呢?
//          //只支持Json数据加载
//          ALoadDataSetting.Clear;
//          ALoadDataSetting.PageIndex:=1;
//          ALoadDataSetting.PageSize:=20;
//          ALoadDataSetting.AppID:=GlobalMainProgramSetting.AppID;
//          //以便返回回来给按钮赋值
//          ALoadDataSetting.JumpFromControlMap:=APageLayoutControlMap;
//  //        ALoadDataSetting.RecordDataJson:=TSkinPageStructureJsonItem(AItem).Json;
//  //        ALoadDataSetting.CustomWhereKeyJson:=GetWhereConditions(['appid','fid'],
//  //                                          [GlobalMainProgramSetting.AppID,ALoadDataSetting.RecordDataJson.I['fid']]);
//          GlobalMainProgramSetting.OnNeedShowPage(Self,
//                                                  APageLayoutControlMap.Setting.options_page_fid,
//                                                  nil,
//                                                  ALoadDataSetting,
//                                                  DoReturnFrameFromOptionsListPage
//                                                  );
//      end
//      else
//      begin
//          {$IFDEF FMX}
//          ShowMessage('OnNeedShowPage不能为空');
//          {$ENDIF}
//      end;

  end;
//  else
//  begin
//      raise Exception.Create('TPageInstance.DoFieldControlClick 不支持此动作'+APageLayoutControlMap.Setting.Action);
//  end;

end;

procedure TEditPageInstance.DoReturnFrameFromOptionsListPage(AFrame: TFrame);
begin
  //

end;

{ TListPageInstance }

//procedure TListPageInstance.DoJumpToEditRecordPageAction(ALoadDataSetting:TLoadDataSetting);
//begin
//  inherited;
//
//  //跳转到相同功能模块下的编辑页面
//  if Self.PageStructure.EditPage<>nil then
//  begin
//      if Assigned(GlobalMainProgramSetting.OnNeedShowPage) then
//      begin
//        GlobalMainProgramSetting.OnNeedShowPage(Self,
//                                                0,
//                                                Self.PageStructure.EditPage,
////                                                ALoadDataSetting,
//                                                DoReturnFrameFromEditPageFrame
//                                                );
//  //      HideFrame;
//  //      ShowPageFrame(Self.PageStructure.EditPage,
//  //                    ALoadDataSetting,
//  //                    DoReturnFrameFromEditPageFrame);
//      end;
//  end;
//
//end;

procedure TListPageInstance.DoLoadDataTaskExecuteEnd(ATimerTask: TTimerTask);
begin
  inherited;

  //停止刷新
  if FlvData<>nil then
  begin
    if FLoadDataSetting.PageIndex>1 then
    begin
        if FLoadDataIntfResult.DataJson.A['RecordList'].Length>0 then
        begin
          Self.FlvData.Prop.StopPullUpLoadMore('加载成功!',0,True);
        end
        else
        begin
          Self.FlvData.Prop.StopPullUpLoadMore('下面没有了!',600,False);
        end;
    end
    else
    begin
        Self.FlvData.Prop.StopPullDownRefresh('刷新成功!',600);
    end;
  end;

end;

procedure TListPageInstance.DoPageFrameCustomInitFieldControl(AControl: TComponent;
  AFieldControlSetting: TFieldControlSetting);
begin
  inherited;

  if (AControl is TSkinVirtualList)
//    and SameText(AFieldControlSetting.field_name,'RecordList')
    then
  begin
    FlvData:=TSkinVirtualList(AControl);
    TSkinVirtualList(AControl).OnPullDownRefresh:=Self.lvDataPullDownRefresh;
    TSkinVirtualList(AControl).OnPullUpLoadMore:=Self.lvDataPullUpLoadMore;
    TSkinVirtualList(AControl).OnClickItemEx:=Self.lvDataClickItemEx;
//    TSkinVirtualList(AControl).OnClickItemDesignerPanelChild:=Self.lvDataClickItemEx;
  end;

end;

procedure TListPageInstance.DoReturnFrameFromEditPageFrame(AFrame: TFrame);
var
  ASkinItem:TBaseSkinItem;
begin
  inherited;

//  //从编辑页面返回到列表页面
//  if TFrameBaseEditPage(AFrame).PageInstance.FLoadDataSetting.IsAddRecord then
//  begin
//    //添加记录返回
////    ASkinItem:=TBaseSkinItem(Self.PageInstance.FlvData.Prop.Items.Add);
//    //怎么把值赋给它
//    Self.AddSkinItemToListControl(Self.FlvData,
//                                   TFrameBaseEditPage(AFrame).EditPageInstance.FSaveDataIntfResult.DataJson,
//                                   nil
//                                    );
//  end;
//
//
//  //从编辑页面返回到列表页面
//  if TFrameBaseEditPage(AFrame).PageInstance.FLoadDataSetting.IsDelRecord then
//  begin
//    //删除了记录返回
//    //将那条列表项删除
//    Self.FlvData.Prop.Items.Remove(TFrameBaseEditPage(AFrame).PageInstance.FLoadDataSetting.JumpFromSourceItem)
//
//  end;

  //刷新即可
  Self.FlvData.Prop.StartPullDownRefresh;

end;

procedure TListPageInstance.lvDataClickItemEx(Sender:TObject;
                                              AItem:TSkinItem;
                                              X:Double;Y:Double);
var
  ARecordDataJson:ISuperObject;
//  ALoadDataSetting:TLoadDataSetting;
  AFieldControlSettingMap:TFieldControlSettingMap;
begin

  //自定义列表项点击事件
  if Assigned(FOnCustomClickListSkinItem) then
  begin
    FOnCustomClickListSkinItem(AItem);
  end;



  AFieldControlSettingMap:=Self.MainControlMapList.FindByComponent(Sender);

  if (AFieldControlSettingMap<>nil)
    and (AFieldControlSettingMap.Setting<>nil)
    and (AFieldControlSettingMap.Setting.action<>'') then
  begin
      //列表控件的FieldControlSetting中指定了action动作,那么根据动作来执行


      ARecordDataJson:=nil;
      if AItem is TSkinPageStructureJsonItem then
      begin
        ARecordDataJson:=TSkinPageStructureJsonItem(AItem).Json;

      end
      else if AItem.Json<>nil then
      begin
          ARecordDataJson:=AItem.Json;
      end;



      //优先级比较高,列表页面是从哪个控件跳转过来的?
      //
      if (Self.FLoadDataSetting.JumpFromControlMap<>nil) then
      begin

          //按了Button,显示列表选择页面,选择好返回,修改Button的Caption和Value
          if ARecordDataJson<>nil then
          begin
            //列表选项页面,选择了列表项,返回
            //给控件赋值
            AFieldControlSettingMap:=TFieldControlSettingMap(Self.FLoadDataSetting.JumpFromControlMap);
            SetFieldControlPostValue(
                                  AFieldControlSettingMap,
                                  '',
                                  GlobalMainProgramSetting.DataIntfImageUrl,
                                  ARecordDataJson.V[AFieldControlSettingMap.Setting.options_page_value_field_name],
                                  ARecordDataJson.S[AFieldControlSettingMap.Setting.options_page_caption_field_name],
                                  nil
                                  );
          end;

          DoReturnPageAction(Self);
      end
//      else if AFieldControlSettingMap.Setting.action=Const_PageAction_JumpToEditRecordPage then
//      begin
//          //跳转到编辑页面,编辑哪条记录呢
//          //只支持Json数据加载
//          ALoadDataSetting.Clear;
//          ALoadDataSetting.AppID:=GlobalMainProgramSetting.AppID;
//          ALoadDataSetting.JumpFromSourceItem:=AItem;
//          ALoadDataSetting.RecordDataJson:=ARecordDataJson;
//          ALoadDataSetting.CustomWhereKeyJson:=GetWhereConditions(['appid','fid'],
//                                                                  [GlobalMainProgramSetting.AppID,
//                                                                    ALoadDataSetting.RecordDataJson.I['fid']]);
//          DoJumpToEditRecordPageAction(ALoadDataSetting);
//
//      end
      else if Self.PageStructure.ClickItemJumpPage<>nil then
      begin
          //点击列表项跳转到某一页面
//          ALoadDataSetting.Clear;
//          ALoadDataSetting.AppID:=GlobalMainProgramSetting.AppID;
          if Assigned(GlobalMainProgramSetting.OnNeedShowPage) then
          begin
            GlobalMainProgramSetting.OnNeedShowPage(Self,
                                                    0,
                                                    Self.PageStructure.ClickItemJumpPage,
//                                                    ALoadDataSetting,
                                                    nil
                                                    );
          end;

      end
      else
      begin


      end;

      //ClickItemJumpPage

      //根据这个ListBox的action分别做处理
      //先找到AFieldControlSetting,看他的Action


      //  ShowPageFrame(Self.PageStructure.program_template_name,
      //                //功能的默认页面
      //                Self.PageStructure.function_name,
      //                '',
      //                Const_PageType_ViewPage,
      //                Self.PageStructure.platform,
      //                ALoadDataSetting,
      //                True);

  end
  else
  begin
      //其他情况


  end;
end;

//procedure TListPageInstance.lvDataCustomListClickItemDesignerPanelChild(
//  Sender: TObject; AItem: TBaseSkinItem; AItemDesignerPanel: TItemDesignerPanel;
//  AChild: TChildControl);
//begin
//
//end;

procedure TListPageInstance.lvDataPullDownRefresh(Sender: TObject);
begin
//  //商家获取费用列表
//  FFilterStartTime:=StandardDateTimeToStr(StartOfTheDay(Now-1));
//  FFilterEndTime:='';//不需要结束时间//StandardDateTimeToStr(EndOfTheDay(Now));
//
//  FPageIndex:=1;
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                 DoGetShopOrderListExecute,
//                 DoGetShopOrderListExecuteEnd,
//                 'GetShopOrderList');

  FLoadDataSetting.PageIndex:=1;

  Self.LoadData();


end;

procedure TListPageInstance.lvDataPullUpLoadMore(Sender: TObject);
begin
//  FPageIndex:=FPageIndex+1;
//  uTimerTask.GetGlobalTimerThread.RunTempTask(
//                 DoGetShopOrderListExecute,
//                 DoGetShopOrderListExecuteEnd,
//                 'GetShopOrderList');
  FLoadDataSetting.PageIndex:=FLoadDataSetting.PageIndex+1;

  Self.LoadData();

end;


{ TGetDataIntfResultFieldValue }

constructor TGetDataIntfResultFieldValue.Create(ALoadDataIntfResult,
  ALoadDataIntfResult2: TDataIntfResult);
begin
    FLoadDataIntfResult:=ALoadDataIntfResult;
    FLoadDataIntfResult2:=ALoadDataIntfResult2;
end;

function TGetDataIntfResultFieldValue.GetFieldValue(AFieldName: String): Variant;
var
  AJsonArrayValue:ISuperArray;
  //比如SkinItems
  AValueObject:TObject;
begin
  Result:=GetPageDataIntfResultFieldValue(AFieldName,
                                          FLoadDataIntfResult,
                                          FLoadDataIntfResult2,
                                          AJsonArrayValue,
                                          AValueObject
                                          );
end;

{ TSetJsonRecordFieldValue }

constructor TSetJsonRecordFieldValue.Create(AJson: ISuperObject);
begin
  FJson:=AJson;
end;

procedure TSetJsonRecordFieldValue.SetFieldValue(AFieldName: String;
  AFieldValue: Variant);
begin
  FJson.V[AFieldName]:=AFieldValue;
end;

{ TBaseSetRecordFieldValue }


{ TSkinPageStructureJsonItem }

function TSkinPageStructureJsonItem.GetValueByBindItemField(AFieldName: String): Variant;
var
  AValue:String;
begin
  Result:=Inherited GetValueByBindItemField(AFieldName);

  if Pos('_path',AFieldName)>0 then
  begin
      AValue:=Result;

      {$IFDEF FMX}
      if (AValue.IndexOf('http://')>=0) or (AValue.IndexOf('https://')>=0) then
      {$ENDIF}
      {$IFDEF VCL}
      if (Pos('http://',AValue)=1) or (Pos('https://',AValue)=1) then
      {$ENDIF}
      begin

      end
      else
      begin
          Result:=GlobalMainProgramSetting.FDataIntfImageUrl+ReplaceStr(AValue,'\','/');
      end;
  end;
end;




{ TSkinRealSkinItemComponent }

constructor TSkinRealSkinItemComponent.Create(AOwner: TComponent);
begin
  inherited;

  FSkinItem:=TRealSkinItem.Create;

end;

//针对页面框架的控件接口
function TSkinRealSkinItemComponent.LoadFromFieldControlSetting(ASetting:TFieldControlSetting):Boolean;
begin
  Result:=FSkinItem.LoadFromFieldControlSetting(ASetting);
end;

//获取与设置自定义属性
function TSkinRealSkinItemComponent.GetProp(APropName: String): Variant;
begin
  Result:='';
end;

function TSkinRealSkinItemComponent.GetPropJsonStr:String;
begin
  Result:=FSkinItem.GetPropJsonStr;
end;

procedure TSkinRealSkinItemComponent.SetProp(APropName: String;
  APropValue: Variant);
begin

end;

procedure TSkinRealSkinItemComponent.SetPropJsonStr(AJsonStr:String);
begin
  FSkinItem.SetPropJsonStr(AJsonStr);
end;


//获取提交的值
function TSkinRealSkinItemComponent.GetPostValue(ASetting:TFieldControlSetting;
                        APageDataDir:String;
                        //可以获取其他字段的值
                        ASetRecordFieldValueIntf:ISetRecordFieldValue;
                        var AErrorMessage:String):Variant;
begin
  Result:=FSkinItem.GetPostValue(ASetting,APageDataDir,ASetRecordFieldValueIntf,AErrorMessage);
end;

//设置值
procedure TSkinRealSkinItemComponent.SetControlValue(ASetting:TFieldControlSetting;
                        APageDataDir:String;
                        AImageServerUrl:String;
                        AValue:Variant;
                        AValueCaption:String;
                        //要设置多个值,整个字段的记录
                        AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
  FSkinItem.SetControlValue(ASetting,APageDataDir,AImageServerUrl,AValue,AValueCaption,AGetDataIntfResultFieldValueIntf);
end;




{ TLocalJsonPageFrameworkDataSourceManager }

constructor TLocalJsonPageFrameworkDataSourceManager.Create;
begin
  inherited;
  FDataJson:=TSuperObject.Create;

end;

destructor TLocalJsonPageFrameworkDataSourceManager.Destroy;
begin

  inherited;
end;

function TLocalJsonPageFrameworkDataSourceManager.GetParamValue(AValueFrom,
  AParamName: String): Variant;
begin
  if Self.FDataJson.Contains(AParamName) then
  begin
    Result:=FDataJson.V[AParamName];
  end
  else
  begin
    Result:=Inherited;
  end;
  
end;

procedure TLocalJsonPageFrameworkDataSourceManager.Load;
begin
  inherited;

  if FileExists(GetApplicationPath+'local_data_source.json') then
  begin
    FDataJson:=TSuperObject.Create(GetStringFromTextFile(GetApplicationPath+'local_data_source.json'));
  end
  else
  begin
    FDataJson:=TSuperObject.Create;
  end;

end;

procedure TLocalJsonPageFrameworkDataSourceManager.Save;
begin
  inherited;

  SaveStringToFile(FDataJson.AsJSON,GetApplicationPath+'local_data_source.json',TEncoding.UTF8);

end;

procedure TLocalJsonPageFrameworkDataSourceManager.SetParamValue(AValueFrom,
  AParamName: String; AValue: Variant);
begin
  inherited;

end;

{ TPageCheckBox }

function TPageCheckBox.GetPostValue(ASetting: TFieldControlSetting;
  APageDataDir: String; ASetRecordFieldValueIntf: ISetRecordFieldValue;
  var AErrorMessage: String): Variant;
begin
  Result:=Self.{$IFDEF VCL}Checked{$ENDIF}{$IFDEF FMX}IsChecked{$ENDIF};
end;

function TPageCheckBox.GetProp(APropName: String): Variant;
begin

end;

function TPageCheckBox.GetPropJsonStr: String;
begin

end;

function TPageCheckBox.LoadFromFieldControlSetting(
  ASetting: TFieldControlSetting): Boolean;
begin
  if ASetting.has_caption_label=0 then
  begin
    Caption:=ASetting.field_caption;
  end;

  Result:=True;
end;

procedure TPageCheckBox.SetControlValue(ASetting: TFieldControlSetting;
  APageDataDir, AImageServerUrl: String; AValue: Variant; AValueCaption: String;
  AGetDataIntfResultFieldValueIntf: IGetDataIntfResultFieldValue);
var
  AValueStr:String;
begin
  AValueStr:=AValue;
  if AValueStr='' then
  begin
    AValue:=False;
  end;
  Self.{$IFDEF VCL}Checked{$ENDIF}{$IFDEF FMX}IsChecked{$ENDIF}:=AValue;


end;

procedure TPageCheckBox.SetProp(APropName: String; APropValue: Variant);
begin

end;

procedure TPageCheckBox.SetPropJsonStr(AJsonStr: String);
begin

end;



initialization
  GlobalMainProgramSetting:=TOpenPlatformProgramSetting.Create(nil);
  FInnterGlobalMainProgramSetting:=GlobalMainProgramSetting;

  GlobalPageFrameworkDataSourceManagerClass:=TLocalJsonPageFrameworkDataSourceManager;


  {$IFDEF FMX}
  GetGlobalFrameworkComponentTypeClasses.Add('button',TSkinFMXButton,'按钮');
  GetGlobalFrameworkComponentTypeClasses.Add('label',TSkinFMXLabel,'文本');
  GetGlobalFrameworkComponentTypeClasses.Add('panel',TSkinFMXPanel,'面板');
  GetGlobalFrameworkComponentTypeClasses.Add('image',TSkinFMXImage,'图片');
  GetGlobalFrameworkComponentTypeClasses.Add('item_designer_panel',TSkinFMXItemDesignerPanel,'列表项设计面板');
  GetGlobalFrameworkComponentTypeClasses.Add('listview',TSkinFMXListView,'列表视图');
  GetGlobalFrameworkComponentTypeClasses.Add('checkbox',TSkinFMXCheckBox,'复选框');
  GetGlobalFrameworkComponentTypeClasses.Add('radio_button',TSkinFMXRadioButton,'单选框');

  GetGlobalFrameworkComponentTypeClasses.Add('edit',TSkinFMXEdit,'编辑框');
  GetGlobalFrameworkComponentTypeClasses.Add('memo',TSkinFMXMemo,'备注框');
  GetGlobalFrameworkComponentTypeClasses.Add('roll_label',TSkinFMXRollLabel,'滑动文本');
  GetGlobalFrameworkComponentTypeClasses.Add('test_component',TComponent,'测试组件');
  GetGlobalFrameworkComponentTypeClasses.Add('dateedit',TSkinFMXDateEdit,'日期框');
  GetGlobalFrameworkComponentTypeClasses.Add('timeedit',TSkinFMXTimeEdit,'时间框');
  GetGlobalFrameworkComponentTypeClasses.Add('combobox',TSkinFMXComboBox,'下拉框');
  GetGlobalFrameworkComponentTypeClasses.Add('comboedit',TSkinFMXComboEdit,'下拉编辑框');
  {$ENDIF}



  {$IFDEF VCL}
  GetGlobalFrameworkComponentTypeClasses.Add('button',TSkinWinButton,'按钮');
  GetGlobalFrameworkComponentTypeClasses.Add('label',TSkinWinLabel,'文本');
  GetGlobalFrameworkComponentTypeClasses.Add('panel',TSkinWinPanel,'面板');
  GetGlobalFrameworkComponentTypeClasses.Add('image',TSkinWinImage,'图片');
  GetGlobalFrameworkComponentTypeClasses.Add('item_designer_panel',TSkinWinItemDesignerPanel,'列表项设计面板');
  GetGlobalFrameworkComponentTypeClasses.Add('listview',TSkinWinListView,'列表视图');
  GetGlobalFrameworkComponentTypeClasses.Add('checkbox',TPageCheckBox,'复选框');
  GetGlobalFrameworkComponentTypeClasses.Add('radio_button',TSkinWinRadioButton,'单选框');

//  GetGlobalFrameworkComponentTypeClasses.Add('edit',TSkinWinEdit,'编辑框');
//  GetGlobalFrameworkComponentTypeClasses.Add('memo',TSkinWinMemo,'备注框');

  GetGlobalFrameworkComponentTypeClasses.Add('edit',TEdit,'编辑框');
  GetGlobalFrameworkComponentTypeClasses.Add('memo',TMemo,'备注框');

  GetGlobalFrameworkComponentTypeClasses.Add('roll_label',TSkinWinRollLabel,'滑动文本');
  GetGlobalFrameworkComponentTypeClasses.Add('test_component',TComponent,'测试组件');
//  GetGlobalFrameworkComponentTypeClasses.Add('dateedit',TSkinWinDateEdit,'日期框');
//  GetGlobalFrameworkComponentTypeClasses.Add('timeedit',TSkinWinTimeEdit,'时间框');
//  GetGlobalFrameworkComponentTypeClasses.Add('combobox',TSkinWinComboBox,'下拉框');
  GetGlobalFrameworkComponentTypeClasses.Add('combobox',TComboBox,'下拉框');
//  GetGlobalFrameworkComponentTypeClasses.Add('comboedit',TSkinWinComboEdit,'下拉编辑框');
  {$ENDIF}

  GetGlobalFrameworkComponentTypeClasses.Add('listitem',TSkinRealSkinItemComponent,'列表项');

//  GetGlobalFrameworkComponentTypeClasses.Add('list_page',TSkinFMXComboEdit,'下拉编辑框');
//  GetGlobalFrameworkComponentTypeClasses.Add('button_group',TSkinFMXButtonGroup);
//  GetGlobalFrameworkComponentTypeClasses.Add('multi_color_label',TSkinFMXMultiColorLabel);
//  GetGlobalFrameworkComponentTypeClasses.Add('Switch',TSkinFMXSwitch);
//  GetGlobalFrameworkComponentTypeClasses.Add('DrawPanel',TSkinFMXDrawPanel);
//  GetGlobalFrameworkComponentTypeClasses.Add('RoundRect',TSkinFMXRoundRect);
//  GetGlobalFrameworkComponentTypeClasses.Add('TabSheet',TSkinFMXTabSheet);
//  GetGlobalFrameworkComponentTypeClasses.Add('PageControl',TSkinFMXPageControl);
//  GetGlobalFrameworkComponentTypeClasses.Add('TrackBar',TSkinFMXTrackBar);
//  GetGlobalFrameworkComponentTypeClasses.Add('SwitchBar',TSkinFMXSwitchBar);
//  GetGlobalFrameworkComponentTypeClasses.Add('ProgressBar',TSkinFMXProgressBar);
//  GetGlobalFrameworkComponentTypeClasses.Add('ScrollBar',TSkinFMXScrollBar);
//  GetGlobalFrameworkComponentTypeClasses.Add('ScrollBox',TSkinFMXScrollBox);
//  GetGlobalFrameworkComponentTypeClasses.Add('SwitchPageListPanel',TSkinFMXSwitchPageListPanel);
//  GetGlobalFrameworkComponentTypeClasses.Add('NotifyNumberIcon',TSkinFMXNotifyNumberIcon);
//  GetGlobalFrameworkComponentTypeClasses.Add('FrameImage',TSkinFMXFrameImage);
//  GetGlobalFrameworkComponentTypeClasses.Add('RoundImage',TSkinFMXRoundImage);
//  GetGlobalFrameworkComponentTypeClasses.Add('ImageListPlayer',TSkinFMXImageListPlayer);
//  GetGlobalFrameworkComponentTypeClasses.Add('ImageListViewer',TSkinFMXImageListViewer);
//  GetGlobalFrameworkComponentTypeClasses.Add('listbox',TSkinFMXListBox);
//  GetGlobalFrameworkComponentTypeClasses.Add('treeview',TSkinFMXTreeView);
//  GetGlobalFrameworkComponentTypeClasses.Add('itemgrid',TSkinFMXItemGrid);
//  GetGlobalFrameworkComponentTypeClasses.Add('dbgrid',TSkinFMXDBGrid);
//  GetGlobalFrameworkComponentTypeClasses.Add('Popup',TSkinFMXPopup);





finalization
  FreeAndNil(FInnterGlobalMainProgramSetting);



end.
