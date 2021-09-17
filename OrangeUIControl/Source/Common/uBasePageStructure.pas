//convert pas to utf8 by ¥
unit uBasePageStructure;



interface
//{$IF DEFINED(ANDROID) OR DEFINED(IOS) OR DEFINED(MACOS) }
//  {$DEFINE FMX}
//{$IFEND}
//
//
//
////请在工程下放置FrameWork.inc
////或者在工程设置中配置FMX编译指令
////才可以正常编译此单元
//{$IFNDEF FMX}
//  {$IFNDEF VCL}
//    {$I FrameWork.inc}
//  {$ENDIF}
//{$ENDIF}





uses
  Classes,
  SysUtils,
  Types,
  {$IFDEF FMX}
  FMX.Types,
  FMX.Controls,
  {$ENDIF FMX}
//  FMX.Dialogs,
//  FMX.Edit,
//  FMX.ComboEdit,
//  FMX.ListBox,
//  FMX.StdCtrls,
//  FMX.Memo,
//  FMX.Graphics,
//  UITypes,
//  uDrawParam,
//  uGraphicCommon,
//  uSkinItems,
//  uSkinMaterial,
//  uSkinListLayouts,
//  uSkinListViewType,
//  uComponentType,
//  uSkinRegManager,
  uBaseList,
  uBaseLog,
  IdURI,
  Math,
//  FMX.Forms,
//  IniFiles,
//  uBaseSkinControl,
//  uSkinCommonFrames,
//  uDrawTextParam,
//  uDrawPictureParam,
//  uDrawRectParam,
////  MessageBoxFrame,
////  WaitingFrame,
////  uBasePageStructure,
//  uSkinVirtualListType,
//  uDataInterface,
//  uTableCommonRestCenter,
  uLang,
//  uFrameContext,

  {$IF CompilerVersion >= 30.0}
  System.Math.Vectors,
  System.UIConsts,
  System.Net.URLClient,
  {$IFEND}


//  uTimerTask,
//  uTimerTaskEvent,
//  uSkinCommonFrames,
//  uTimerTask,
  DateUtils,
  uDrawPicture,
  uFuncCommon,


//  {$IFDEF SKIN_SUPEROBJECT}
//  uSkinSuperObject,
//  {$ELSE}
//  XSuperObject,
//  XSuperJson,
//  {$ENDIF}


//  uFuncCommon,
  uFileCommon,
//  uBaseHttpControl,
//  uRestInterfaceCall,
//  uPageFrameworkCommon,
  uBaseHttpControl,
  StrUtils
  ;


const
  IID_IControlForPageFramework:TGUID='{6B39D8E8-ED7B-46D7-9CA6-FA480AEBB7C8}';
//  IID_IImageControlForPageFramework:TGUID='{36635F61-9217-4DF8-BD36-B193BDB65980}';



type


  //控件基本设置
  TFieldControlSetting=class(TCollectionItem)
  private
    Ffield_name: String;
    Fpage_part: String;
    Ffield_caption: String;
    Faction: String;
    Fcontrol_style: String;
    Fname: String;
    Fvalue: String;
    Fcontrol_type: String;
    Finput_format: String;
    Foptions_caption: String;
    Finput_max_length: Integer;
    Foptions_value: String;
    Finput_read_only: Integer;
    Finput_prompt: String;
    Fhas_caption_label: Integer;
    Falign: String;
    Fanchors: String;
    Fwidth: double;
    Fmargins: String;
    Fx: double;
    Fy: double;
    Fheight: double;
  public
    fid:Integer;
    appid:Integer;
    //所属页面的FID
    page_fid:Integer;


    //父控件的id
    parent_control_fid:Integer;
    //本地时使用,因为fid是数据库的表自动生成的,本地保存的时候没有的
    //定位父控件
    parent_control_name:String;

  public
    //作为表格列的时候的设置
    col_width:Double;
    col_visible:Integer;
  public
    //是否可以响应点击,默认都必须是1
    hittest:Integer;
    //是否启用
    enabled:Integer;
    //是否显示
    visible:Integer;
    readonly:Integer;

    //不提交给接口
    is_no_post:Integer;
    //图标名称
    icon_image_name:String;
  public

    //背景颜色
    back_color:String;
    border_color:String;
    border_edges:String;
    border_width:Double;
    back_round_width:Double;
    back_corners:String;


    //字体设置,TEdit.TextSetting
    text_font_name:String;
    text_font_size:Integer;
    text_font_color:String;
    text_vert_align:String;
    text_horz_align:String;
    text_style:String;
    text_wordwrap:Integer;

  public
    //图片是否拉伸
    picture_is_stretch:Integer;
    //图片是否自适应
    picture_is_autofit:Integer;
    picture_vert_align:String;
    picture_horz_align:String;

  public
//    //图片路径
//    pic_path:String;
    image_kind:String;//图片类型,比如user_head,goods_pic,上传目录
    image_is_need_clip:Integer;//	int	图片是否需要裁剪
    image_clip_width:Integer;//	int	裁剪图片的宽度
    image_clip_height:Integer;//	int	裁剪图片的高度
    image_max_count:Integer;//	int	最多支持添加几张图片,0表示默认1
    //image_upload_url	nvarchar(255)	上传图片的接口地址,
    //比如：http://www.orangeui.cn:10011/upload?appid=1003&filename=%s&filedir=repair_car_order_pic&fileext=.jpg

  public
    //控件要保存的其他字段
    //其他要提交的字段,比如pic1_width,pic1_height
    other_field_names:String;//	nvarchar(45)	图片宽度的字段名,比如pic1_width,创建这个控件，在选择好图片之后赋宽度给它
    //其他字段的值的来源
    //其他字段的取值,比如picture0.width,picture0.height
    other_field_controlprops:String;//	nvarchar(45)

  public
    //ComboBox,ComboEdit,Button可以用做选择框,跳转到列表页面进行选择

    options_is_multi_select:Integer;//	int	是否支持多选

    options_page_fid:Integer;//	int	选择选项的列表页面fid,它里面包含数据接口
    options_page_name:String;//	仅仅是为了好记
    options_page_value_field_name:String;//	nvarchar(45)	选择选项列表页面的值字段
    options_page_caption_field_name:String;//	nvarchar(45)	选择选项列表页面的标题字段

    options_has_empty:Integer;//	int	是否拥有空的选项
    options_empty_value:String;//	nvarchar(45)
    options_empty_caption:String;//	nvarchar(45)


    //避免在页面初始的时候为了一个字段值的标题去查询一下接口
    //比如记录中只有分类ID,没有分类标题,但显示的时候要分类标题,不可能去查一下标题
    options_caption_field_name:String;//在编辑页面和查看页面能直接取到值的标题


  public
    //绑定列表项的数据类型
    bind_listitem_data_type:String;
    //控件自定义的属性
    prop:String;

    //子页面控件
    control_page_fid:Integer;
    control_page_name:String;
    //子页面类型的控件结构
//    FControlPageStructure:TObject;


  public
    jump_to_page_program:String;//	nvarchar(255)	跳转到指定的页面的程序模板name,比如ycliving
    jump_to_page_function:String;//	nvarchar(255)	跳转到指定的页面的功能name,比如shop_goods_manage
    jump_to_page_name:String;//	nvarchar(255)	跳转到指定的页面的页面name,比如goods_list_page
    jump_to_page_type:String;//	nvarchar(255)	跳转到指定的页面的页面类型,list_page

    jump_to_page_fid:Integer;//	int	跳转到指定的页面的页面fid,比较直接


  public
    //顺序号
    orderno:double;

    is_deleted:Integer;



//    //布局的FID
//    layout_fid:Integer;

    //自定义尺寸和位置
//    is_custom_position:Integer;

//    //Edit
//    //输入框的提示性文字
//    input_prompt:String;


//    //是否不提交
//    IsNoPost:String;


    procedure AssignTo(Dest:TPersistent);override;
  public
    //父控件,保存的时候有用,ChildControl.parent_control_fid要赋值
    ParentFieldControlSetting:TFieldControlSetting;

    //保存时所根据的控件
    SavedComponent:TComponent;
  public
    procedure ClearFid;
    constructor Create(ACollection: TCollection);override;
    destructor Destroy;override;
  published

    //字段名
    property field_name:String read Ffield_name write Ffield_name;
    //字段标题用来做什么?输入框的标题,按钮的标题
    property field_caption:String read Ffield_caption write Ffield_caption;
    //控件风格,Material.StyleName
    property control_style:String read Fcontrol_style write Fcontrol_style;


    //默认的动作
    property action:String read Faction write Faction;

    //控件所在的页面位置,比如main,bottom_toolbar等
    property page_part:String read Fpage_part write Fpage_part;
  published
    //控件类型,要与HTML等通用
    property control_type:String read Fcontrol_type write Fcontrol_type;
    //控件名,一定要,因为有些控件并不一定有FieldName
    property name:String read Fname write Fname;
    //标题,控件的标题
//    caption:string;
    //值,Label的Caption,
    property value:String read Fvalue write Fvalue;
  published
    //选项值列表,比如0,1,2
    property options_value:String read Foptions_value write Foptions_value;
    //选项标题列表,比如未知,男,女
    property options_caption:String read Foptions_caption write Foptions_caption;
  published
    //    //提示Label的标题
    //    HintLabelCaption:String;
    property input_format:String read Finput_format write Finput_format;//	nvarchar(45)	输入格式要求，保存的时候要使用,相关的控件是edit,comboedit
    //		number,只允许输入数字
    //		email,必须是email
    //		phone,必须是手机号
    property input_prompt:String read Finput_prompt write Finput_prompt;//	nvarchar(255)	输入提示,比如请输入密码
    property input_max_length:Integer read Finput_max_length write Finput_max_length;//	int	输入字符串的最大长度
    property input_read_only:Integer read Finput_read_only write Finput_read_only;//	int	是否只读
  published
    //是否需要提示Label
    property has_caption_label:Integer read Fhas_caption_label write Fhas_caption_label;
  published
    //控件属性,位置尺寸,自定义排列控件时使用
    property x:double read Fx write Fx;
    property y:double read Fy write Fy;
    property width:double read Fwidth write Fwidth;
    property height:double read Fheight write Fheight;

    //边距
    property margins:String read Fmargins write Fmargins;


    //拉伸模式
    property anchors:String read Fanchors write Fanchors;
    //对齐方式
    property align:String read Falign write Falign;

  end;

  TFieldControlSettingList=class(TCollection)
  private
    function GetItem(Index: Integer): TFieldControlSetting;
  public
    property Items[Index:Integer]:TFieldControlSetting read GetItem;default;
  public
    function FindBySavedComponent(ASavedComponent: TComponent):TFieldControlSetting;
    function FindByFid(AFid: Integer):TFieldControlSetting;
    function FindByControlType(AControlType: String):TFieldControlSetting;
    function FindByName(AName: String):TFieldControlSetting;
    function FindByFieldName(AFieldName: String):TFieldControlSetting;
    function Add:TFieldControlSetting;overload;
    procedure Clear(AIsNeedFree:Boolean);overload;
  public
    constructor Create;
  end;




  //从数据接口获取字段值的接口
  IGetDataIntfResultFieldValue=interface
    ['{B6EC6FF9-891D-449D-9A60-8E0B29035B53}']
    function GetFieldValue(AFieldName:String):Variant;
  end;
  //将字段值赋给提交
  ISetRecordFieldValue=interface
    ['{4C5F1CBE-6356-416A-BA64-C75AD2F89AD6}']
    //AddPictureListSubFrame上传图片的链接
    //上传到服务器
    //例如:ImageHttpServerUrl+'/upload'
    //                 +'?appid='+IntToStr(AppID)
    //                 +'&filename='+'%s'//用于替换文件名
    //                 +'&filedir='+'repair_car_order_pic'
    //                 +'&fileext='+'.jpg',
    //上传宠物头像
//    if not Self.FPetHeadPicFrame.Upload(
//        ImageHttpServerUrl+'/upload'
//                         +'?appid='+IntToStr(AppID)
//                         +'&filename='+'%s'
//                         +'&filedir='+'userhead_pic'
//                         +'&fileext='+'.jpg',
//        AServerResponse) then
//    begin
//      TTimerTask(ATimerTask).TaskDesc:=AServerResponse;
//      Exit;
//    end;
//    function GetImageUploadTemplateUrl(ASetting:TFieldControlSetting):String;
    //设置其他字段的值
    procedure SetFieldValue(AFieldName:String;AFieldValue:Variant);
  end;



  //支持页面框架的控件接口
  IControlForPageFramework=interface
    ['{6B39D8E8-ED7B-46D7-9CA6-FA480AEBB7C8}']
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
//    //获取合适的高度
//    function GetSuitDefaultItemHeight:Double;






  //应用程序的数据源,
  //可以是Json可以是Ini,
  //直接放在程序的根目录,
  //local_data_source.json
  //初始本地数据源,调用接口的有些参数从这里取出来的
  TOnGetParamValueEvent=function(AValueFrom:String;AParamName:String;var AIsGeted:Boolean):Variant of object;
  TOnSetParamValueEvent=procedure(AValueFrom:String;AParamName:String;AValue:Variant;var AIsSeted:Boolean) of object;
  TOnGetDrawPictureEvent=function(AImageName:String;var AIsGeted:Boolean):TDrawPicture of object;

  TPageFrameworkDataSource=class(TComponent)
  private
    FOnGetParamValue: TOnGetParamValueEvent;
    FOnSetParamValue: TOnSetParamValueEvent;
    FOnGetDrawPicture: TOnGetDrawPictureEvent;
  public
    constructor Create(AComponent:TComponent);override;
    destructor Destroy;override;
  published
    //根据FieldControlSetting.icon_image_name返回图片
    property OnGetDrawPicture:TOnGetDrawPictureEvent read FOnGetDrawPicture write FOnGetDrawPicture;

    property OnGetParamValue:TOnGetParamValueEvent read FOnGetParamValue write FOnGetParamValue;

    property OnSetParamValue:TOnSetParamValueEvent read FOnSetParamValue write FOnSetParamValue;

  end;
  TPageFrameworkDataSourceList=class(TBaseList)
  private
    function GetItem(Index: Integer): TPageFrameworkDataSource;
  public
    property Items[Index:Integer]:TPageFrameworkDataSource read GetItem;default;
  end;



  TPageFrameworkDataSourceManager=class
  public
    FOnGetParamValue:TOnGetParamValueEvent;
    FOnSetParamValue:TOnSetParamValueEvent;
  public
    constructor Create;virtual;
    destructor Destroy;override;

    //本地数据,比如医院显示屏项目,保存办公室fid
    //FDataJson:ISuperObject;
    function GetParamValue(AValueFrom:String;AParamName:String):Variant;virtual;
    procedure SetParamValue(AValueFrom:String;AParamName:String;AValue:Variant);virtual;

    function GetDrawPicture(AImageName:String):TDrawPicture;virtual;

    procedure Load;virtual;
    procedure Save;virtual;
  end;
  TPageFrameworkDataSourceManagerClass=class of TPageFrameworkDataSourceManager;



var

  GlobalPageFrameworkDataSourceManagerClass:TPageFrameworkDataSourceManagerClass;
  //页面框架的数据源列表,用于获取和设置数据
  GlobalPageFrameworkDataSourceList:TPageFrameworkDataSourceList;


function GetGlobalPageFrameworkDataSourceManager:TPageFrameworkDataSourceManager;


implementation

var

  //本地参数的数据源
  //初始本地数据源,调用接口的有些参数从这里取出来的
  GlobalPlatformDataSourceManager:TPageFrameworkDataSourceManager;


function GetGlobalPageFrameworkDataSourceManager:TPageFrameworkDataSourceManager;
begin
  if GlobalPlatformDataSourceManager=nil then
  begin
    GlobalPlatformDataSourceManager:=GlobalPageFrameworkDataSourceManagerClass.Create;
  end;
  Result:=GlobalPlatformDataSourceManager;
end;

{ TFieldControlSettingList }

//constructor TFieldControlSettingList.Create;
//begin
//  Inherited Create(TFieldControlSetting);
//
//end;

function TFieldControlSettingList.Add: TFieldControlSetting;
begin
//  Result:=TFieldControlSetting.Create;
//  Inherited Add(Result);
  Result:=TFieldControlSetting(Inherited Add);
end;

procedure TFieldControlSettingList.Clear(AIsNeedFree: Boolean);
var
  I: Integer;
begin
  if AIsNeedFree then
  begin
    Inherited Clear;
  end
  else
  begin
    for I := Self.Count-1 downto 0 do
    begin
      Self.Items[I].Collection:=nil;
    end;
  end;
end;

constructor TFieldControlSettingList.Create;
begin
  Inherited Create(TFieldControlSetting);
end;

function TFieldControlSettingList.FindByControlType(
  AControlType: String): TFieldControlSetting;
var
  I: Integer;
begin
  Result:=nil;

  for I := 0 to Self.Count-1 do
  begin
    if Items[I].control_type=AControlType then
    begin
      Result:=Items[I];
      Break;
    end;
  end;

end;

function TFieldControlSettingList.FindByFid(AFid: Integer): TFieldControlSetting;
var
  I: Integer;
begin
  Result:=nil;

  for I := 0 to Self.Count-1 do
  begin
    if Items[I].fid=AFid then
    begin
      Result:=Items[I];
      Break;
    end;
  end;


end;

function TFieldControlSettingList.FindByFieldName(
  AFieldName: String): TFieldControlSetting;
var
  I: Integer;
begin
  Result:=nil;

  for I := 0 to Self.Count-1 do
  begin
    if Items[I].field_name=AFieldName then
    begin
      Result:=Items[I];
      Break;
    end;
  end;

end;

function TFieldControlSettingList.FindByName(
  AName: String): TFieldControlSetting;
var
  I: Integer;
begin
  Result:=nil;

  for I := 0 to Self.Count-1 do
  begin
    if Items[I].Name=AName then
    begin
      Result:=Items[I];
      Break;
    end;
  end;

end;

function TFieldControlSettingList.FindBySavedComponent(ASavedComponent: TComponent): TFieldControlSetting;
var
  I: Integer;
begin
  Result:=nil;

  for I := 0 to Self.Count-1 do
  begin
    if Items[I].SavedComponent=ASavedComponent then
    begin
      Result:=Items[I];
      Break;
    end;
  end;

end;

function TFieldControlSettingList.GetItem(Index: Integer): TFieldControlSetting;
begin
  Result:=TFieldControlSetting(Inherited Items[Index]);
end;

//procedure TFieldControlSettingList.SetItemBinding(AItemDataBindingFieldNames,
//  AItemDataType: array of String);
//var
//  I: Integer;
//  AFieldControlSetting:TFieldControlSetting;
//begin
//  Self.Clear;
//
//  for I := 0 to Length(AItemDataBindingFieldNames)-1 do
//  begin
//    //绑定字段
//    AFieldControlSetting:=TFieldControlSetting.Create(Self);
//    AFieldControlSetting.bind_listitem_data_type:=AItemDataType[I];
//    AFieldControlSetting.FieldName:=AItemDataBindingFieldNames[I];
//  end;
//
//end;




{ TFieldControlSetting }

procedure TFieldControlSetting.AssignTo(Dest: TPersistent);
var
  ADest:TFieldControlSetting;
begin
  if Dest is TFieldControlSetting then
  begin
    ADest:=TFieldControlSetting(Dest);

    //字段名
    ADest.field_name:=field_name;
    //控件风格
    ADest.control_style:=control_style;


    //默认的动作
    ADest.action:=action;

    //控件所在的页面位置
    ADest.page_part:=page_part;


    ADest.fid:=fid;
    ADest.appid:=Self.appid;


    //所属页面的FID
    ADest.page_fid:=page_fid;
    //父控件的id
    ADest.parent_control_fid:=parent_control_fid;
    //本地时使用
    ADest.parent_control_name:=parent_control_name;



    //控件属性
    ADest.x:=x;
    ADest.y:=y;
    ADest.width:=width;
    ADest.height:=height;

    //边距
    ADest.margins:=margins;


    //拉伸模式
    ADest.anchors:=anchors;
    //对齐方式
    ADest.align:=align;
    //是否可以响应点击
    ADest.hittest:=hittest;
    //是否启用
    ADest.enabled:=enabled;


    //是否显示
    ADest.visible:=visible;


    //控件类型,要与HTML等通用
    ADest.control_type:=control_type;
    //控件名,一定要,因为有些控件并不一定有FieldName
    ADest.name:=name;
    //标题
//    ADest.caption:=caption;
    //设计时的值,Label的Caption,一般用作初始值
    ADest.value:=value;



    //这些其实没有什么用处,放在一个字段中就好了,独立出来费空间
    //背景颜色
    ADest.back_color:=back_color;
    ADest.border_color:=border_color;
    ADest.border_edges:=border_edges;
    ADest.border_width:=border_width;
    ADest.back_round_width:=back_round_width;
    ADest.back_corners:=back_corners;




    //字体设置,TEdit.TextSetting
    ADest.text_font_name:=text_font_name;
    ADest.text_font_size:=text_font_size;
    ADest.text_font_color:=text_font_color;
    ADest.text_vert_align:=text_vert_align;
    ADest.text_horz_align:=text_horz_align;
    ADest.text_style:=text_style;
    ADest.text_wordwrap:=text_wordwrap;



    //图片是否拉伸
    ADest.picture_is_stretch:=picture_is_stretch;
    //图片是否自适应
    ADest.picture_is_autofit:=picture_is_autofit;
    ADest.picture_vert_align:=picture_vert_align;
    ADest.picture_horz_align:=picture_horz_align;



//    //图片路径
//    pic_path:String;//改成存在value中了
    ADest.image_kind:=image_kind;//	int	图片是否需要裁剪
    ADest.image_is_need_clip:=image_is_need_clip;//	int	图片是否需要裁剪
    ADest.image_clip_width:=image_clip_width;//	int	裁剪图片的宽度
    ADest.image_clip_height:=image_clip_height;//	int	裁剪图片的高度
    ADest.image_max_count:=image_max_count;//	int	最多支持添加几张图片,0表示默认1
    //image_upload_url	nvarchar(255)	上传图片的接口地址,
    //比如：http://www.orangeui.cn:10011/upload?appid=1003&filename=%s&filedir=repair_car_order_pic&fileext=.jpg
    //一个控件要保存很多其他字段,比如pic11_width,pic1_height
    ADest.other_field_names:=other_field_names;//	nvarchar(45)	图片宽度的字段名,比如pic1_width,创建这个控件，在选择好图片之后赋宽度给它
    //其他字段对应的控件属性,Image.Width,Image.Height
    ADest.other_field_controlprops:=other_field_controlprops;//	nvarchar(45)	图片宽度的字段名,比如pic1_width,创建这个控件，在选择好图片之后赋宽度给它




    //绑定列表项的数据类型
    ADest.bind_listitem_data_type:=bind_listitem_data_type;
    ADest.prop:=prop;





    //顺序号
    ADest.orderno:=orderno;

    ADest.is_deleted:=is_deleted;




    ADest.has_caption_label:=has_caption_label;





    ADest.input_format:=input_format;//	nvarchar(45)	输入格式要求，保存的时候要使用,相关的控件是edit,comboedit
    //		number,只允许输入数字
    //		email,必须是email
    //		phone,必须是手机号
    ADest.input_prompt:=input_prompt;//	nvarchar(255)	输入提示,比如请输入密码
    ADest.input_max_length:=input_max_length;//	int	输入字符串的最大长度
    ADest.input_read_only:=input_read_only;//	int	是否只读





    ADest.options_value:=options_value;
    ADest.options_caption:=options_caption;

    ADest.options_is_multi_select:=options_is_multi_select;//	int	是否支持多选

    ADest.options_page_fid:=options_page_fid;//	int	选择选项的列表页面fid,它里面包含数据接口
    ADest.options_page_name:=options_page_name;//	int	选择选项的列表页面fid,它里面包含数据接口
    ADest.options_page_value_field_name:=options_page_value_field_name;//	nvarchar(45)	选择选项列表页面的值字段
    ADest.options_page_caption_field_name:=options_page_caption_field_name;//	nvarchar(45)	选择选项列表页面的标题字段
    ADest.options_has_empty:=options_has_empty;//	int	是否拥有空的选项
    ADest.options_empty_value:=options_empty_value;//	nvarchar(45)
    ADest.options_empty_caption:=options_empty_caption;//	nvarchar(45)

    ADest.options_caption_field_name:=options_caption_field_name;//在编辑页面和查看页面能直接取到值的标题



    //子页面类型的控件
    ADest.control_page_fid:=control_page_fid;
    ADest.control_page_name:=control_page_name;




    ADest.jump_to_page_program:=jump_to_page_program;//	nvarchar(255)	跳转到指定的页面的程序模板name,比如ycliving
    ADest.jump_to_page_function:=jump_to_page_function;//	nvarchar(255)	跳转到指定的页面的功能name,比如shop_goods_manage
    ADest.jump_to_page_name:=jump_to_page_name;//	nvarchar(255)	跳转到指定的页面的页面name,比如goods_list_page
    ADest.jump_to_page_type:=jump_to_page_type;//	nvarchar(255)	跳转到指定的页面的页面类型,list_page

    ADest.jump_to_page_fid:=jump_to_page_fid;//	int	跳转到指定的页面的页面fid,比较直接


  end;
end;

procedure TFieldControlSetting.ClearFid;
begin
  fid:=0;
  page_fid:=0;

  Self.parent_control_fid:=0;

end;



constructor TFieldControlSetting.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);


  //初始值

  //控件属性
  x:=0;
  y:=0;
  width:=100;
  height:=40;



  //是否可以响应点击
  hittest:=1;
  //是否启用
  enabled:=1;
  //是否显示
  visible:=1;


  //作为表格列的时候的设置
  col_width:=100;
  col_visible:=1;


end;

destructor TFieldControlSetting.Destroy;
begin
//  FreeAndNil(FControlPageStructure);

  inherited;
end;

//
//{ TFieldControlSettingRefList }
//
//function TFieldControlSettingRefList.GetItem(
//  Index: Integer): TFieldControlSetting;
//begin
//  Result:=TFieldControlSetting(Inherited Items[Index]);
//end;



{ TPageFrameworkDataSourceManager }

constructor TPageFrameworkDataSourceManager.Create;
begin
//  FDataJson:=TSuperObject.Create;

end;

destructor TPageFrameworkDataSourceManager.Destroy;
begin
//  FDataJson:=nil;
  inherited;
end;

function TPageFrameworkDataSourceManager.GetDrawPicture(
  AImageName: String): TDrawPicture;
var
  AIsGeted:Boolean;
  I: Integer;
begin
  AIsGeted:=False;

  Result:=nil;

//  if Assigned(FOnGetParamValue) then
//  begin
//    Result:=FOnGetParamValue(AValueFrom,AParamName,AIsGeted);
//  end;
//
//  if AIsGeted then Exit;


  for I := 0 to GlobalPageFrameworkDataSourceList.Count-1 do
  begin
    AIsGeted:=False;
    if Assigned(GlobalPageFrameworkDataSourceList[I].FOnGetDrawPicture) then
    begin
      Result:=GlobalPageFrameworkDataSourceList[I].FOnGetDrawPicture(AImageName,AIsGeted);
    end;
    if AIsGeted then Exit;
  end;


  if Result=nil then
  begin
    //没有取到值就要弹出报错
    raise Exception.Create('The Image named '+AImageName+' is not geted');
  end;

end;

function TPageFrameworkDataSourceManager.GetParamValue(AValueFrom:String;AParamName: String): Variant;
var
  AIsGeted:Boolean;
  I: Integer;
begin
  AIsGeted:=False;
  if Assigned(FOnGetParamValue) then
  begin
    Result:=FOnGetParamValue(AValueFrom,AParamName,AIsGeted);
  end;

  if AIsGeted then Exit;


  for I := 0 to GlobalPageFrameworkDataSourceList.Count-1 do
  begin
    AIsGeted:=False;
    if Assigned(GlobalPageFrameworkDataSourceList[I].FOnGetParamValue) then
    begin
      Result:=GlobalPageFrameworkDataSourceList[I].FOnGetParamValue(AValueFrom,AParamName,AIsGeted);
    end;
    if AIsGeted then Exit;
  end;

  //没有取到值就要弹出报错
  raise Exception.Create('The Value of '+AParamName+' is not geted');

//  if not FDataJson.Contains(AParamName) then
//  begin
//    //没有取到值就要弹出报错
//    raise Exception.Create('The Value of '+AParamName+' is not geted');
//  end;
//  Result:=FDataJson.V[AParamName];
end;

procedure TPageFrameworkDataSourceManager.Load;
begin
//  if FileExists(GetApplicationPath+'local_data_source.json') then
//  begin
//    FDataJson:=TSuperObject.Create(GetStringFromTextFile(GetApplicationPath+'local_data_source.json'));
//  end
//  else
//  begin
//    FDataJson:=TSuperObject.Create;
//  end;
end;

procedure TPageFrameworkDataSourceManager.Save;
begin
//  SaveStringToFile(FDataJson.AsJSON,GetApplicationPath+'local_data_source.json',TEncoding.UTF8);
end;

procedure TPageFrameworkDataSourceManager.SetParamValue(AValueFrom:String;AParamName: String;AValue: Variant);
var
  AIsSeted:Boolean;
  I: Integer;
begin
  AIsSeted:=False;
  if Assigned(FOnSetParamValue) then
  begin
    FOnSetParamValue(AValueFrom,AParamName,AValue,AIsSeted);
  end;

  if AIsSeted then Exit;


  for I := 0 to GlobalPageFrameworkDataSourceList.Count-1 do
  begin
    AIsSeted:=False;
    if Assigned(GlobalPageFrameworkDataSourceList[I].FOnSetParamValue) then
    begin
      GlobalPageFrameworkDataSourceList[I].FOnSetParamValue(AValueFrom,AParamName,AValue,AIsSeted);
    end;
    if AIsSeted then Exit;
  end;


  //没有取到值就要弹出报错
  raise Exception.Create('The Value of '+AParamName+' is not Seted');


//  FDataJson.V[AParamName]:=AValue;
end;


{ TPageFrameworkDataSourceList }

function TPageFrameworkDataSourceList.GetItem(
  Index: Integer): TPageFrameworkDataSource;
begin
  Result:=TPageFrameworkDataSource(Inherited Items[Index]);

end;

{ TPageFrameworkDataSource }

constructor TPageFrameworkDataSource.Create(AComponent: TComponent);
begin
  inherited;
  GlobalPageFrameworkDataSourceList.Add(Self);
end;

destructor TPageFrameworkDataSource.Destroy;
begin
  GlobalPageFrameworkDataSourceList.Remove(Self,False);
  inherited;
end;


initialization
  GlobalPageFrameworkDataSourceManagerClass:=TPageFrameworkDataSourceManager;
  GlobalPageFrameworkDataSourceList:=TPageFrameworkDataSourceList.Create(ooReference);


finalization
  FreeAndNil(GlobalPlatformDataSourceManager);
  FreeAndNil(GlobalPageFrameworkDataSourceList);


end.
