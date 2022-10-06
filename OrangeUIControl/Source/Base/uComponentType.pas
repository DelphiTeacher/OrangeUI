//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     控件类型
///   </para>
///   <para>
///     Control Type
///   </para>
/// </summary>
unit uComponentType;




interface
{$I FrameWork.inc}


{$I Version.inc}



{$IFDEF FMX}
//是否需要SystemHttpControl
{$DEFINE NEED_SystemHttpControl}
{$ENDIF}



////定义是否是免费版
//{$DEFINE FREE_VERSION}




{$IFDEF FREE_VERSION}
    {$IFDEF NEED_SystemHttpControl}

        //Android平台
        {$IFDEF ANDROID}
          {$DEFINE NEED_GET_LATEST_VERSION}
        {$ENDIF}


        {$IFDEF MSWINDOWS}
          {$DEFINE NEED_GET_LATEST_VERSION}
        {$ENDIF}


        //IOS真机上
        {$IF CompilerVersion >= 31.0}//>=D10.1
          //版本要大于等于D10.1 Berlin,不然transport会报错
          {$IFDEF IOS}
            {$IFNDEF CPUX86}
              {$DEFINE NEED_GET_LATEST_VERSION}
            {$ENDIF}
          {$ENDIF}
        {$IFEND}


    {$ENDIF NEED_SystemHttpControl}
{$ENDIF FREE_VERSION}





uses
  SysUtils,
  uFuncCommon,
  Classes,
  Math,
  DateUtils,
  StrUtils,
  DB,


  {$IFDEF VCL}
  Messages,
  Windows,
  Controls,
  Forms,
  {$ENDIF}
  {$IFDEF FMX}
  FMX.Forms,
  UITypes,
  FMX.Types,
  FMX.Controls,
  System.Math.Vectors,
  FMX.Graphics,
  {$ENDIF}
  {$IFDEF IOS}
  FMX.Platform.iOS,
  FMX.Helpers.iOS,
//  FMX.Platform.IOS,
//  FMX.Helpers.IOS,
  Macapi.ObjectiveC,
  iOSapi.UIKit,
  {$ENDIF}

  {$IF CompilerVersion>=30.0}
  Types,//定义了TRectF
  {$IFEND}
//  {$IFDEF MSWINDOWS}
//  WinApi.Windows,
//  Vcl.Graphics,
//  Vcl.Imaging.JPEG,
//  {$ENDIF}
  uBasePageStructure,


  {$IF CompilerVersion >= 30.0}
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Net.HttpClientComponent,

  System.Messaging,
  {$IFEND}



  uSkinItems,

//  {$IFDEF SKIN_SUPEROBJECT}
  uSkinSuperObject,
//  {$ELSE}
//  XSuperObject,
//  XSuperJson,
//  {$ENDIF}


  uVersion,
  uBaseLog,
  uBaseList,
  uDrawParam,
  uDrawEngine,
  uDrawPicture,
  uSkinPicture,
  uGraphicCommon,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas;



const
  //默认的控件类型名称
  Const_Default_ComponentType='Default';




const
  IID_ISkinControl:TGUID='{BF586D36-805F-4BB4-BB58-2F82EF4C3181}';
const
  IID_ICustomListItemEditor:TGUID='{128F7007-0E06-4730-A7E5-D22EE848FA7D}';
const
  IID_IDirectUIParent:TGUID='{74622FA2-6A9A-4932-8A5B-9374682BEB10}';
const
  IID_ITransparentControl:TGUID='{1175DCEE-D486-444B-A3CA-0D281040F20F}';
const
  IID_IDirectUIControl:TGUID='{4E63747B-2A23-4A37-A27C-D1A325BA076B}';


const
  //绑定相关
  IID_IBindSkinItemTextControl:TGUID='{3E2D1818-9868-4536-95F2-3B85500A1323}';
  IID_IBindSkinItemBoolControl:TGUID='{6478178E-82AB-488D-B5D4-F8E3C4B4D1AF}';
  IID_IBindSkinItemIconControl:TGUID='{FECD1814-3CFE-4647-82DB-0BF09B9A4520}';
  IID_ISkinItemBindingControl:TGUID='{38DE8597-E898-4030-8EB0-4C7A139A3257}';

  IID_IBindSkinItemValueControl:TGUID='{A3D22512-3F53-499E-9374-3828EB6720B0}';
  IID_IBindSkinItemObjectControl:TGUID='{E78DFD1E-529E-422B-94DA-E55C8E79227B}';

const
  IID_IEditContentMargins:TGUID='{BC3381F7-D5D4-4788-A25C-EAFDD5BC230A}';

const
  IID_ISkinControlMaterial:TGUID='{3DC11571-7462-4AF3-A52F-EEF7D6CDC8CB}';
const
  IID_IProcessItemColor:TGUID='{FF1F61B6-D8F8-4B6F-9FE1-B85E9869BEA3}';

  IID_ISkinControlValueChange:TGUID='{C78927A0-D5A4-471A-B8E3-2AC8883467E1}';





type
  TSkinControlType=class;
  TSkinControlProperties=class;


  TDoGetStreamEvent=function():TStream;

  //鼠标事件传递类型
  TMouseEventTransToParentType=(mettptAuto,    //CheckParentIsScrollBox,
                                 mettptTrans,   //传递
                                 mettptNotTrans //不传递
                                 );


  /// <summary>
  ///   <para>
  ///     控件类型使用方式,不再使用
  ///   </para>
  ///   <para>
  ///     Use method of control type
  ///   </para>
  /// </summary>
  TComponentTypeUseKind=(
                          /// <summary>
                          ///   使用默认的
                          ///   <para>
                          ///     Use default
                          ///   </para>
                          /// </summary>
                         ctukDefault,
                         /// <summary>
                         ///   指定ComponentTypeName
                         ///   <para>
                         ///     Assign ComponentTypeName
                         ///   </para>
                         /// </summary>
                         ctukName
                         );






  /// <summary>
  ///   <para>
  ///     素材使用方式
  ///   </para>
  ///   <para>
  ///     Use method of material
  ///   </para>
  /// </summary>
  TMaterialUseKind=(
                    /// <summary>
                    ///   使用自己创建的
                    ///   <para>
                    ///     Use selfown create
                    ///   </para>
                    /// </summary>
                    mukSelfOwn,
                    /// <summary>
                    ///   使用皮肤包默认的
                    ///   <para>
                    ///     Use skin pakage default
                    ///   </para>
                    /// </summary>
                    mukDefault,
                    /// <summary>
                    ///   指定皮肤包里面的素材名称
                    ///   <para>
                    ///     Assign material name of skin pakage
                    ///   </para>
                    /// </summary>
                    mukName,
                    /// <summary>
                    ///   引用
                    ///   <para>
                    ///     Refrence
                    ///   </para>
                    /// </summary>
                    mukRef,
                    /// <summary>
                    ///   引用,并去掉自己创建的
                    ///   <para>
                    ///     Refrence and remove selfown create
                    ///   </para>
                    /// </summary>
                    mukRefOnly,
                    mukRefByStyleName
                    );











  //控件Parent的类,以及子控件的类型,用于遍历子控件
  {$IFDEF VCL}
  //在VCL下,父控件是WinControl,可以放子控件在里面
  TParentControl=TWinControl;
  TChildControl=TControl;
  {$ENDIF}
  {$IFDEF FMX}
  TParentControl=TControl;//TFmxObject;
  TChildControl=TFmxObject;
  {$ENDIF}











  //绘制时的附加参数数据(一些状态)
  TPaintData=record
    //是否是激活状态
    IsDrawInteractiveState:Boolean;
    //是否由DirectUI接管绘制
    IsInDrawDirectUI:Boolean;
    //其他数据
    OtherData:Pointer;
  end;




  //编辑框内容的边距设置
  IEditContentMargins=interface
    ['{BC3381F7-D5D4-4788-A25C-EAFDD5BC230A}']

    function GetContentMarginsLeft: Integer;
    function GetContentMarginsTop: Integer;
    function GetContentMarginsRight: Integer;
    function GetContentMarginsBottom: Integer;

    procedure SetContentMarginsLeft(const Value: Integer);
    procedure SetContentMarginsTop(const Value: Integer);
    procedure SetContentMarginsRight(const Value: Integer);
    procedure SetContentMarginsBottom(const Value: Integer);

    Property ContentMarginsLeft:Integer read GetContentMarginsLeft write SetContentMarginsLeft;
    Property ContentMarginsTop:Integer read GetContentMarginsTop write SetContentMarginsTop;
    Property ContentMarginsRight:Integer read GetContentMarginsRight write SetContentMarginsRight;
    Property ContentMarginsBottom:Integer read GetContentMarginsBottom write SetContentMarginsBottom;

  end;



  TSkinControlCustomMouseDownEvent=procedure(Button: TMouseButton; Shift: TShiftState;X, Y: Double;const AIsChildMouseEvent:Boolean;const AChild:TObject) of object;
  TSkinControlCustomMouseUpEvent=procedure(Button: TMouseButton; Shift: TShiftState;X, Y: Double;const AIsChildMouseEvent:Boolean;const AChild:TObject) of object;
  TSkinControlCustomMouseMoveEvent=procedure(Shift: TShiftState; X, Y: Double;const AIsChildMouseEvent:Boolean;const AChild:TObject) of object;

  //控件的值更改事件
  ISkinControlValueChange=interface
    ['{C78927A0-D5A4-471A-B8E3-2AC8883467E1}']
    procedure SetOnChange(Value:TNotifyEvent);
  end;


  {$REGION '皮肤控件接口ISkinControl'}
  /// <summary>
  ///   <para>
  ///     皮肤控件接口(标题,坐标,高宽,是否显示,获取焦点等)
  ///   </para>
  ///   <para>
  ///     Interface of skin control(Such as
  ///     caption,coordinate,height,width,whether display,get focus and so
  ///     on.
  ///   </para>
  /// </summary>
  ISkinControl=interface
  ['{BF586D36-805F-4BB4-BB58-2F82EF4C3181}']
    {$I Source\Controls\INC\Common\ISkinControl_Declare.inc}

    /// <summary>
    ///   <para>
    ///     获取组件的属性基类
    ///   </para>
    ///   <para>
    ///     Get property baseclass of component
    ///   </para>
    /// </summary>
    function GetProperties:TSkinControlProperties;
    /// <summary>
    ///   <para>
    ///     设置组件的属性基类
    ///   </para>
    ///   <para>
    ///     Set property base class of componet
    ///   </para>
    /// </summary>
    procedure SetProperties(const Value:TSkinControlProperties);
    //属性基类
    property Properties:TSkinControlProperties read GetProperties write SetProperties;
    property Prop:TSkinControlProperties read GetProperties write SetProperties;


    /// <summary>
    ///   <para>
    ///     获取当前使用的皮肤素材
    ///   </para>
    ///   <para>
    ///     Get skin material currently used
    ///   </para>
    /// </summary>
    function GetCurrentUseMaterial: TSkinControlMaterial;
//    function GetStaticCurrentUseMaterial: TSkinControlMaterial;

    /// <summary>
    ///   <para>
    ///     获取控件类型
    ///   </para>
    ///   <para>
    ///     Get control type
    ///   </para>
    /// </summary>
    function GetSkinControlType: TSkinControlType;
    /// <summary>
    ///   <para>
    ///     获取标题
    ///   </para>
    ///   <para>
    ///     Get caption
    ///   </para>
    /// </summary>
    function GetCaption:String;
    /// <summary>
    ///   <para>
    ///     设置标题
    ///   </para>
    ///   <para>
    ///     Set caption
    ///   </para>
    /// </summary>
    procedure SetCaption(const Value:String);
    /// <summary>
    ///   <para>
    ///     标题
    ///   </para>
    ///   <para>
    ///     Caption
    ///   </para>
    /// </summary>
    property Caption:String read GetCaption write SetCaption;
    /// <summary>
    ///   <para>
    ///     FMX中标题的别名
    ///   </para>
    ///   <para>
    ///     Caption's alias in FMX
    ///   </para>
    /// </summary>
    property Text:String read GetCaption;

    /// <summary>
    ///   <para>
    ///     水平位置
    ///   </para>
    ///   <para>
    ///     left
    ///   </para>
    /// </summary>
    property Left:TControlSize read GetLeft write SetLeft;
    /// <summary>
    ///   <para>
    ///     垂直位置
    ///   </para>
    ///   <para>
    ///     top
    ///   </para>
    /// </summary>
    property Top:TControlSize read GetTop write SetTop;
    /// <summary>
    ///   <para>
    ///     宽度
    ///   </para>
    ///   <para>
    ///     control-width
    ///   </para>
    /// </summary>
    property Width:TControlSize read GetWidth write SetWidth;
    /// <summary>
    ///   <para>
    ///     高度
    ///   </para>
    ///   <para>
    ///     height
    ///   </para>
    /// </summary>
    property Height:TControlSize read GetHeight write SetHeight;

    /// <summary>
    ///   <para>
    ///     整型宽度
    ///   </para>
    ///   <para>
    ///     Integer width
    ///   </para>
    /// </summary>
    property WidthInt:Integer read GetWidthInt write SetWidthInt;

    /// <summary>
    ///   <para>
    ///     整型高度
    ///   </para>
    ///   <para>
    ///     Integer height
    ///   </para>
    /// </summary>
    property HeightInt:Integer read GetHeightInt write SetHeightInt;
    /// <summary>
    ///   <para>
    ///     是否显示
    ///   </para>
    ///   <para>
    ///     Whether display
    ///   </para>
    /// </summary>
    property Visible:Boolean read GetVisible write SetVisible;

    /// <summary>
    ///   <para>
    ///     父控件
    ///   </para>
    ///   <para>
    ///     Parent control
    ///   </para>
    /// </summary>
    property Parent:TParentControl read GetParent write SetParent;
    /// <summary>
    ///   <para>
    ///     是否启用
    ///   </para>
    ///   <para>
    ///     Whether enable
    ///   </para>
    /// </summary>
    property Enabled:Boolean read GetEnabled;
    /// <summary>
    ///   <para>
    ///     是否获取焦点
    ///   </para>
    ///   <para>
    ///     Whether get focus
    ///   </para>
    /// </summary>
    property Focused:Boolean read GetFocused write SetFocused;
    /// <summary>
    ///   <para>
    ///     鼠标状态(是否鼠标停靠)
    ///   </para>
    ///   <para>
    ///     Mouse state(whether mouse is hovering）
    ///   </para>
    /// </summary>
    property IsMouseOver:Boolean read GetIsMouseOver write SetIsMouseOver;
    /// <summary>
    ///   <para>
    ///     鼠标状态(是否鼠标按下)
    ///   </para>
    ///   <para>
    ///     Mouse state(whether mouse is pressing)
    ///   </para>
    /// </summary>
    property IsMouseDown:Boolean read GetIsMouseDown write SetIsMouseDown;

    //传递鼠标消息给Parent
    function GetParentMouseEvent:Boolean;
    procedure SetParentMouseEvent(const AValue:Boolean);
    function GetMouseEventTransToParentType:TMouseEventTransToParentType;
    procedure SetMouseEventTransToParentType(const AValue:TMouseEventTransToParentType);
    property ParentMouseEvent:Boolean read GetParentMouseEvent write SetParentMouseEvent;
    property MouseEventTransToParentType:TMouseEventTransToParentType read GetMouseEventTransToParentType write SetMouseEventTransToParentType;
    function GetParentIsScrollBox:Boolean;
    function GetParentScrollBox:TControl;
    /// <summary>
    ///   <para>
    ///     刷新控件
    ///   </para>
    ///   <para>
    ///     Refresh control
    ///   </para>
    /// </summary>
    procedure Invalidate;

    /// <summary>
    ///   <para>
    ///     设置控件位置和尺寸
    ///   </para>
    ///   <para>
    ///     Set control's position and size
    ///   </para>
    /// </summary>
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: TControlSize);overload;
    /// <summary>
    ///   <para>
    ///     设置控件位置和尺寸
    ///   </para>
    ///   <para>
    ///     Set control's position and size
    ///   </para>
    /// </summary>
    procedure SetBounds(ABoundsRect:TRectF);overload;

    /// <summary>
    ///   <para>
    ///     获取父控件的子控件数量
    ///   </para>
    ///   <para>
    ///     Get childcontrol's count of parent control
    ///   </para>
    /// </summary>
    function GetParentChildControlCount:Integer;
    /// <summary>
    ///   <para>
    ///     获取父控件的子控件
    ///   </para>
    ///   <para>
    ///     Get parent control's child control
    ///   </para>
    /// </summary>
    function GetParentChildControl(Index:Integer):TChildControl;

    /// <summary>
    ///   <para>
    ///     获取本控件的子控件数量
    ///   </para>
    ///   <para>
    ///     Get child control's count of this control
    ///   </para>
    /// </summary>
    function GetChildControlCount:Integer;
    /// <summary>
    ///   <para>
    ///     获取本控件的子控件
    ///   </para>
    ///   <para>
    ///     Get child control of this control
    ///   </para>
    /// </summary>
    function GetChildControl(Index:Integer):TChildControl;


    //控件的MouseDown消息中会调用ISkinControl_CustomMouseDown方法
    //ISkinControl_CustomMouseDown中会调用ControlType的CustomMouseDown,
    //并且根据自身的ParentMouseEvent属性把消息传递给Parent
    procedure ISkinControl_CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double;const AIsChildMouseEvent:Boolean;const AChild:TObject);
    procedure ISkinControl_CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double;const AIsChildMouseEvent:Boolean;const AChild:TObject);
    procedure ISkinControl_CustomMouseMove(Shift: TShiftState; X, Y: Double;const AIsChildMouseEvent:Boolean;const AChild:TObject);
    procedure ISkinControl_CustomMouseEnter;
    procedure ISkinControl_CustomMouseLeave;

    function GetOnCustomMouseDown:TMouseEvent;
    function GetOnCustomMouseUp:TMouseEvent;
    function GetOnCustomMouseMove:TMouseMoveEvent;
    function GetOnCustomMouseEnter:TNotifyEvent;
    function GetOnCustomMouseLeave:TNotifyEvent;


    property OnCustomMouseDown:TMouseEvent read GetOnCustomMouseDown;
    property OnCustomMouseUp:TMouseEvent read GetOnCustomMouseUp;
    property OnCustomMouseMove:TMouseMoveEvent read GetOnCustomMouseMove;
    property OnCustomMouseEnter:TNotifyEvent read GetOnCustomMouseEnter;
    property OnCustomMouseLeave:TNotifyEvent read GetOnCustomMouseLeave;
  end;
  {$ENDREGION '皮肤控件接口ISkinControl'}




  {$REGION '素材复制接口ISkinControlMaterial'}
  //素材复制接口ISkinControlMaterial
  ISkinControlMaterial=interface
    ['{3DC11571-7462-4AF3-A52F-EEF7D6CDC8CB}']



    /// <summary>
    ///   <para>
    ///     复制皮肤素材
    ///   </para>
    ///   <para>
    ///     Copy skin material
    ///   </para>
    /// </summary>
    procedure AssignMaterial(ASrcControlIntf:ISkinControlMaterial);







    /// <summary>
    ///   <para>
    ///     获取素材名称
    ///   </para>
    ///   <para>
    ///     Get material name
    ///   </para>
    /// </summary>
    function GetMaterialName:String;
    /// <summary>
    ///   <para>
    ///     获取素材使用类型
    ///   </para>
    ///   <para>
    ///     Get material use type
    ///   </para>
    /// </summary>
    function GetMaterialUseKind: TMaterialUseKind;
    /// <summary>
    ///   <para>
    ///     获取是否保留自身的素材
    ///   </para>
    ///   <para>
    ///     Get whether keep selfown material
    ///   </para>
    /// </summary>
    function GetKeepSelfOwnMaterial:Boolean;

    /// <summary>
    ///   <para>
    ///     获取自己的皮肤素材
    ///   </para>
    ///   <para>
    ///     Get selfown skin material
    ///   </para>
    /// </summary>
    function GetSelfOwnMaterial:TSkinControlMaterial;
    /// <summary>
    ///   <para>
    ///     获取引用素材
    ///   </para>
    ///   <para>
    ///     Get refrenced material
    ///   </para>
    /// </summary>
    function GetRefMaterial:TSkinControlMaterial;


    /// <summary>
    ///   <para>
    ///     获取组件类型名称
    ///   </para>
    ///   <para>
    ///     Get type name of component
    ///   </para>
    /// </summary>
    function GetComponentTypeName: String;
    /// <summary>
    ///   <para>
    ///     获取组件类型使用类型
    ///   </para>
    ///   <para>
    ///     Get use type of component type
    ///   </para>
    /// </summary>
//    function GetComponentTypeUseKind: TComponentTypeUseKind;
    /// <summary>
    ///   <para>
    ///     获取当前使用的控件类型名称
    ///   </para>
    ///   <para>
    ///     Get type name of current use component
    ///   </para>
    /// </summary>
    function GetCurrentUseComponentTypeName:String;
    /// <summary>
    ///   <para>
    ///     把SelfOwnMaterial设置为nil
    ///   </para>
    ///   <para>
    ///     Set SelfOwnMaterial as nil
    ///   </para>
    /// </summary>
    procedure NilSelfOwnMaterial;

    /// <summary>
    ///   <para>
    ///     设置引用的皮肤素材
    ///   </para>
    ///   <para>
    ///     Set refrenced skin material
    ///   </para>
    /// </summary>
    procedure SetRefMaterial(Value:TSkinControlMaterial);
    /// <summary>
    ///   <para>
    ///     设置保留自身的素材
    ///   </para>
    ///   <para>
    ///     Set keep self own material
    ///   </para>
    /// </summary>
    procedure SetKeepSelfOwnMaterial(const Value:Boolean);
    /// <summary>
    ///   <para>
    ///     设置素材使用类型
    ///   </para>
    ///   <para>
    ///     Set use type of material
    ///   </para>
    /// </summary>
    procedure SetMaterialUseKind(const Value: TMaterialUseKind);
    /// <summary>
    ///   <para>
    ///     设置素材名称
    ///   </para>
    ///   <para>
    ///     Set material name
    ///   </para>
    /// </summary>
    procedure SetMaterialName(const Value: String);

    /// <summary>
    ///   <para>
    ///     设置控件类型名称
    ///   </para>
    ///   <para>
    ///     Set type name of component
    ///   </para>
    /// </summary>
    procedure SetComponentTypeName(const Value: String);
    /// <summary>
    ///   <para>
    ///     设置控件类型使用类型
    ///   </para>
    ///   <para>
    ///     Set use type of component type
    ///   </para>
    /// </summary>
//    procedure SetComponentTypeUseKind(const Value: TComponentTypeUseKind);

    //保持这个读取顺序
    //控件类型使用类型
//    property ComponentTypeUseKind:TComponentTypeUseKind read GetComponentTypeUseKind write SetComponentTypeUseKind;
    //素材使用类型
    property MaterialUseKind:TMaterialUseKind read GetMaterialUseKind write SetMaterialUseKind;
    //保持自身的素材
    property KeepSelfOwnMaterial:Boolean read GetKeepSelfOwnMaterial write SetKeepSelfOwnMaterial;
    //控件类型名称
    property ComponentTypeName:String read GetComponentTypeName write SetComponentTypeName;
    //皮肤包里指定的素材名称
    property MaterialName:String read GetMaterialName write SetMaterialName;
    //自带的皮肤素材
    property SelfOwnMaterial:TSkinControlMaterial read GetSelfOwnMaterial;
    //引用的皮肤素材
    property RefMaterial:TSkinControlMaterial read GetRefMaterial write SetRefMaterial;

  end;
  {$ENDREGION '素材复制接口ISkinControlMaterial'}




  //用于根据Name来创建控件,用于框架
//  TComponentClass=class of TComponent;
  TComponentTypeClassItem=class
  public
    Caption:String;
    //类型名
    ComponentType:String;
    //控件类
    ComponentClass:TComponentClass;
    ComponentClass1:String;
  end;
  TComponentTypeClassList=class(TBaseList)
  private
    function GetItem(Index: Integer): TComponentTypeClassItem;
  public
    procedure Add(AComponentType:String;
                  AComponentClass:TComponentClass;
                  ACaption:String;
                  AComponentClass1:String='');
    function FindItemByName(AComponentType:String):TComponentClass;
    function FindTypeByClass(AComponentClassName:String):String;
    function FindByComponent(AComponent:TComponent):TComponentTypeClassItem;
    property Items[Index:Integer]:TComponentTypeClassItem read GetItem;default;
  end;



  {$REGION '列表项绑定'}
  //设置控件绑定Item中的哪个数据
  ISkinItemBindingControl=interface
    ['{38DE8597-E898-4030-8EB0-4C7A139A3257}']
    //DataJson.S[FieldName],AStringList.Value[FieldName]
    function GetBindItemFieldName:String;
    procedure SetBindItemFieldName(AValue:String);
    //String,Boolean,Integer,Float....
//    function GetBindItemFieldType:TFieldType;
    //ItemCaption,ItemDetail,ItemDetail1
//    function GetBindItemDataTypeName:String;
  end;


  /// <summary>
  ///   <para>
  ///     设置绑定控件的颜色
  ///   </para>
  ///   <para>
  ///     ??
  ///   </para>
  /// </summary>
  IProcessItemColor=interface
    ['{FF1F61B6-D8F8-4B6F-9FE1-B85E9869BEA3}']
    /// <summary>
    ///   <para>
    ///     设置绑定控件的颜色
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure ProcessItemColor(AItemColorType:TSkinItemColorType;AItemColor:TDelphiColor;var AOldColor:TDelphiColor);
    /// <summary>
    ///   <para>
    ///     恢复绑定控件的颜色
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    procedure RestoreItemColor(AItemColorType:TSkinItemColorType;AItemColor:TDelphiColor;AOldColor:TDelphiColor);
  end;






  /// <summary>
  ///   <para>
  ///     支持绑定列表项字符串属性的控件
  ///   </para>
  ///   <para>
  ///     Controls which support bind ListItem property
  ///   </para>
  /// </summary>
  IBindSkinItemTextControl=interface
    ['{3E2D1818-9868-4536-95F2-3B85500A1323}']
    /// <summary>
    ///   <para>
    ///     绑定列表项Item的文本属性
    ///   </para>
    ///   <para>
    ///     Bind property Text of Item
    ///   </para>
    /// </summary>
    procedure BindingItemText(const AName:String;
                              const AText:String;
                              ASkinItem:TObject;
                              AIsDrawItemInteractiveState:Boolean);
  end;
  IBindSkinItemValueControl=interface
    ['{A3D22512-3F53-499E-9374-3828EB6720B0}']
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  end;
  IBindSkinItemObjectControl=interface
    ['{E78DFD1E-529E-422B-94DA-E55C8E79227B}']
    procedure SetControlObjectByBindItemField(const AFieldName:String;
                                              const AFieldValue:TObject;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  end;


  /// <summary>
  ///   <para>
  ///     支持绑定列表项布尔型属性的控件
  ///   </para>
  ///   <para>
  ///     Controls which support bind ListItem property
  ///   </para>
  /// </summary>
  IBindSkinItemBoolControl=interface
    ['{6478178E-82AB-488D-B5D4-F8E3C4B4D1AF}']
    /// <summary>
    ///   <para>
    ///     绑定列表项Item的布尔属性
    ///   </para>
    ///   <para>
    ///     Bind bool property of ListItem
    ///   </para>
    /// </summary>
    procedure BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
  end;


  /// <summary>
  ///   <para>
  ///     支持绑定列表项图片属性的控件
  ///   </para>
  ///   <para>
  ///     Controls which support bind ListItem property
  ///   </para>
  /// </summary>
  IBindSkinItemIconControl=interface
  ['{FECD1814-3CFE-4647-82DB-0BF09B9A4520}']
    /// <summary>
    ///   <para>
    ///     绑定列表项Item的图标属性
    ///   </para>
    ///   <para>
    ///     Bind property Icon of Item
    ///   </para>
    /// </summary>
    procedure BindingItemIcon(AIcon:TBaseDrawPicture;AImageList:TObject;AImageIndex:Integer;ARefPicture:TSkinPicture;AIsDrawItemInteractiveState:Boolean);
  end;
  {$ENDREGION '列表项绑定'}





  {$REGION 'DirectUI控件IDirectUIControl'}
  //(这个没什么用了,当初用于ListBox在绘制ItemDesignerPanel时控件不断的变换Visible而导致不能响应点击事件)
  IDirectUIParent=interface;
  //DirectUI控件(点击,父控件,是否显示,自动尺寸的宽高)
  IDirectUIControl=interface(ISkinControl)
    ['{4E63747B-2A23-4A37-A27C-D1A325BA076B}']
    //控件点击
    procedure Click;


    //设置父控件(由父控件绘制)
    procedure SetDirectUIParentIntf(Value:IDirectUIParent);




    //是否支持点击
    function GetNeedHitTest:Boolean;
    //点击值
    function GetHitTestValue:Integer;




    //是否显示
    function GetDirectUIVisible:Boolean;

    //自动尺寸宽度
    function GetAutoSizeWidth:Double;
    //自动尺寸高度
    function GetAutoSizeHeight:Double;
    //自动尺寸矩形
    function AutoSizeBoundsRect:TRectF;
  end;











  //DirectUI父控件
  IDirectUIParent=interface
  ['{74622FA2-6A9A-4932-8A5B-9374682BEB10}']
    //更新DirectUI子控件
    procedure UpdateChild(AControl:TChildControl;AControlIntf:IDirectUIControl);
  end;
  {$ENDREGION 'DirectUI控件'}




  {$REGION '用于在ListBox中编辑Edit时调用ICustomListItemEditor'}
  //用于在ListBox中编辑Edit时调用，编辑鼠标事件
  ICustomListItemEditor=interface
    ['{128F7007-0E06-4730-A7E5-D22EE848FA7D}']
    //设置值
    procedure EditSetValue(const AValue:String);
    //获取值
    function EditGetValue:String;
    //鼠标按下(用于使用Edit编辑时确定定位下标)
    procedure EditMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
    //鼠标弹起(用于使用Edit编辑时确定定位下标)
    procedure EditMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
    //鼠标移动(用于使用Edit编辑时确定定位下标)
    procedure EditMouseMove(Shift: TShiftState; X, Y: Double);
  end;
  {$ENDREGION '用于在ListBox中编辑Edit时调用ICustomListItemEditor'}



  {$REGION '控件的基本属性TSkinControlProperties'}
  TPropertiesClassType=class of TSkinControlProperties;



  /// <summary>
  ///   <para>
  ///     控件的基本属性
  ///   </para>
  ///   <para>
  ///     Basic properties of control
  ///   </para>
  /// </summary>
  TSkinControlProperties=class(TPersistent)
  protected
    FSkinControl:TControl;
    FSkinControlIntf:ISkinControl;
  protected
    procedure AssignTo(Dest: TPersistent); override;



    procedure GetPropJson(ASuperObject:ISuperObject);virtual;
    procedure SetPropJson(ASuperObject:ISuperObject);virtual;
  protected
    /// <summary>
    ///   <para>
    ///     重绘控件
    ///   </para>
    ///   <para>
    ///     Redraw control
    ///   </para>
    /// </summary>
    procedure Invalidate;
    /// <summary>
    ///   <para>
    ///     复制Properties
    ///   </para>
    ///   <para>
    ///     Copy Properties
    ///   </para>
    /// </summary>
    procedure AssignProperties(Src:TSkinControlProperties);virtual;
    /// <summary>
    ///   <para>
    ///     图片更改通知事件
    ///   </para>
    ///   <para>
    ///     Event of inform picture changed
    ///   </para>
    /// </summary>
    procedure DoPictureChanged(Sender: TObject);virtual;
    /// <summary>
    ///   <para>
    ///     创建属于本控件属性的图片
    ///   </para>
    ///   <para>
    ///     Create picture belongs to this control property
    ///   </para>
    /// </summary>
    /// <param name="AName">
    ///   名字
    /// </param>
    /// <param name="ACaption">
    ///   标题
    /// </param>
    /// <param name="AGroup">
    ///   分组
    /// </param>
    function CreateDrawPicture(
                              const AName:String;
                              const ACaption:String;
                              const AGroup:String=''
                              ):TDrawPicture;
  protected
    //自动大小
    FAutoSize:Boolean;
    procedure SetAutoSize(const Value: Boolean);
  public
    constructor Create(ASkinControl:TControl);virtual;
  public
    FIsChanging:Integer;
    procedure BeginUpdate;virtual;
    procedure EndUpdate;virtual;

    function GetPropJsonStr:String;
    procedure SetPropJsonStr(AJsonStr:String);
    /// <summary>
    ///   <para>
    ///     获取分类名称
    ///   </para>
    ///   <para>
    ///     Get name of classification
    ///   </para>
    /// </summary>
    function GetComponentClassify:String;virtual;
    /// <summary>
    ///   <para>
    ///     皮肤控件
    ///   </para>
    ///   <para>
    ///     Skin control
    ///   </para>
    /// </summary>
    property SkinControl:TControl read FSkinControl;
    /// <summary>
    ///   <para>
    ///     皮肤控件接口
    ///   </para>
    ///   <para>
    ///     Interface of skin control
    ///   </para>
    /// </summary>
    property SkinControlIntf:ISkinControl read FSkinControlIntf;
  public
    /// <summary>
    ///   <para>
    ///     自动调整控件的尺寸
    ///   </para>
    ///   <para>
    ///     Adjust control's size automatically
    ///   </para>
    /// </summary>
    procedure AdjustAutoSizeBounds;
    /// <summary>
    ///   <para>
    ///     是否自动调整控件的尺寸
    ///   </para>
    ///   <para>
    ///     Whether adjust control's size automatically
    ///   </para>
    /// </summary>
    property AutoSize:Boolean read FAutoSize write SetAutoSize;
  end;
  {$ENDREGION '控件的基本属性TSkinControlProperties'}




  {$REGION '控件类型TSkinControlType'}

  /// <summary>
  ///   <para>
  ///     控件的绘制事件
  ///   </para>
  ///   <para>
  ///     Paint event of control
  ///   </para>
  /// </summary>
  TSkinControlPaintEvent=procedure(ACanvas:TDrawCanvas;const ADrawRect:TRectF) of object;



  /// <summary>
  ///   <para>
  ///     控件类型
  ///   </para>
  ///   <para>
  ///     Control Type
  ///   </para>
  /// </summary>
  TSkinControlType=class
  protected
    //是否使用FCurrentEffectStates
    FIsUseCurrentEffectStates:Boolean;
    //当前控件的状态
    FCurrentEffectStates:TDPEffectStates;

    //获取当前的状态
    function GetCurrentEffectStates: TDPEffectStates;virtual;
  private
    //设置皮肤控件
    procedure SetSkinControl(const Value: TControl);
    //绑定控件
    procedure Bind(ASkinControl:TControl);
    //解除绑定
    procedure UnBind;
  protected
    //
    /// <summary>
    ///   <para>
    ///     皮肤控件
    ///   </para>
    ///   <para>
    ///     Skin control
    ///   </para>
    /// </summary>
    FSkinControl:TControl;
    //
    /// <summary>
    ///   <para>
    ///     皮肤控件接口
    ///   </para>
    ///   <para>
    ///     Interface of skin control
    ///   </para>
    /// </summary>
    FSkinControlIntf:ISkinControl;
  public
    constructor Create(ASkinControl:TControl);virtual;
    destructor Destroy;override;
  public
    /// <summary>
    ///   <para>
    ///     设置皮肤控件
    ///   </para>
    ///   <para>
    ///     Set skin control
    ///   </para>
    /// </summary>
    property SkinControl:TControl read FSkinControl;// write SetSkinControl;

  public
    /// <summary>
    ///   <para>
    ///     是否使用当前效果的状态(用于DirectUI)
    ///   </para>
    ///   <para>
    ///     Whether use state of current effect(used for DirectUI)
    ///   </para>
    /// </summary>
    property IsUseCurrentEffectStates:Boolean read FIsUseCurrentEffectStates write FIsUseCurrentEffectStates;
    /// <summary>
    ///   <para>
    ///     当前效果的状态(用于DirectUI)
    ///   </para>
    ///   <para>
    ///     State of current effect(used for DirectUI)
    ///   </para>
    /// </summary>
    property CurrentEffectStates:TDPEffectStates read GetCurrentEffectStates write FCurrentEffectStates;


  protected

    /// <summary>
    ///   <para>
    ///     重绘控件
    ///   </para>
    ///   <para>
    ///     Repaint control
    ///   </para>
    /// </summary>
    procedure Invalidate;virtual;

    /// <summary>
    ///   <para>
    ///     绑定皮肤控件
    ///   </para>
    ///   <para>
    ///     Bind skin control
    ///   </para>
    /// </summary>
    function CustomBind(ASkinControl:TControl):Boolean;virtual;
    /// <summary>
    ///   <para>
    ///     解除绑定
    ///   </para>
    ///   <para>
    ///     Relieve bind
    ///   </para>
    /// </summary>
    procedure CustomUnBind;virtual;
    /// <summary>
    ///   <para>
    ///     绘制控件
    ///   </para>
    ///   <para>
    ///     Draw control
    ///   </para>
    /// </summary>
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;virtual;


  public
    //获取当前绘制的素材(在ButtonGroup上的Button绘制时需要使用)
    function GetPaintCurrentUseMaterial:TSkinControlMaterial;virtual;
  protected
    //处理绘制参数的透明度
    procedure ProcessDrawParamDrawAlpha(ADrawParam:TDrawParam);
    //处理绘制参数的状态
    procedure ProcessDrawParamEffectStates(ASkinMaterial:TSkinMaterial;APaintData:TPaintData);virtual;



  public
    /// <summary>
    ///   <para>
    ///     计算控件的当前效果状态
    ///   </para>
    ///   <para>
    ///     Calculate current effect state
    ///   </para>
    /// </summary>
    function CalcCurrentEffectStates:TDPEffectStates;virtual;
    /// <summary>
    ///   <para>
    ///     计算自动尺寸的宽度
    ///   </para>
    ///   <para>
    ///     Calculate width of autosize
    ///   </para>
    /// </summary>
    function GetAutoSizeWidth: TControlSize;virtual;
    /// <summary>
    ///   <para>
    ///     计算自动尺寸的高度
    ///   </para>
    ///   <para>
    ///     Calculate height of autosize
    ///   </para>
    /// </summary>
    function GetAutoSizeHeight: TControlSize;virtual;
    /// <summary>
    ///   <para>
    ///     计算大小
    ///   </para>
    ///   <para>
    ///     Calculate autosize
    ///   </para>
    /// </summary>
    function CalcAutoSize(var Width,Height:TControlSize):Boolean;virtual;
    /// <summary>
    ///   <para>
    ///     绘制
    ///   </para>
    ///   <para>
    ///     Draw
    ///   </para>
    /// </summary>
    function Paint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;virtual;
  public

    FCurrentMouseEventIsChildOwn:Boolean;
    FCurrentMouseEventChild:TObject;

    //鼠标的坐标
    FMouseDownPt:TPointF;
    FMouseMovePt:TPointF;
    FMouseUpPt:TPointF;


    //鼠标的绝对坐标
    FMouseDownAbsolutePt:TPointF;
    FMouseMoveAbsolutePt:TPointF;
    FMouseUpAbsolutePt:TPointF;

    FMouseDownScreenPt:TPointF;
    FMouseMoveScreenPt:TPointF;
    FMouseUpScreenPt:TPointF;

    {$IFDEF FMX}
    //多点触摸的记录
    FTouches: TTouches;
    FAction: TTouchAction;
    {$ENDIF}



    //鼠标事件//
    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);virtual;
    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);virtual;
    procedure CustomMouseMove(Shift: TShiftState; X, Y: Double);virtual;
    procedure CustomMouseEnter;virtual;
    procedure CustomMouseLeave;virtual;
    function CustomMouseWheel(Shift: TShiftState; WheelDelta: Integer;X, Y: Double):Boolean;virtual;


//    function MouseDownEventCanTransWhenParentIsScrollBox:Boolean;virtual;
//    function MouseMoveEventCanTransWhenParentIsScrollBox:Boolean;virtual;
//    function MouseUpEventCanTransWhenParentIsScrollBox:Boolean;virtual;



    //键盘事件//
    procedure KeyDown(Key: Word; Shift: TShiftState);virtual;
    procedure KeyUp(Key: Word; Shift: TShiftState);virtual;


    {$IFDEF FMX}
    //手势事件
    procedure Gesture(const EventInfo: TGestureEventInfo; var Handled: Boolean);virtual;
    //多点触摸事件
    procedure MultiTouch(Sender: TObject; const Touches: TTouches;const Action: TTouchAction);virtual;
    {$ENDIF}




    //其他事件//
    //Caption更改事件
    procedure TextChanged;virtual;
    //尺寸更改
    procedure SizeChanged;virtual;
    //焦点改变
    procedure FocusChanged;virtual;


  private


    //上次按下的控件
    LastMouseDownChildControl:TChildControl;
    LastMouseDownChildControlIntf:IDirectUIControl;

    //上次鼠标移到的控件
    LastMouseMoveChildControl:TChildControl;
    LastMouseMoveChildControlIntf:IDirectUIControl;







    //控件在客户区
    function IsControlInMyClient(AControlRect:TRectF;MyClientRect:TRectF):Boolean;
    //获取控件所有的非客户区矩形
    function GetControlWindowRect(AControl:TControl):TRectF;



    //所取坐标所在的控件
    procedure NCHitTestDirectUIControls(Pt:TPointF;AParentControlIntf:ISkinControl);
    //处理控件的鼠标消息
    function ProcessMouseDownDirectUIControls(
                Button: TMouseButton;
                Shift: TShiftState;
                X,Y:Double):Boolean;
    function ProcessMouseUpDirectUIControls(
                Button: TMouseButton;
                Shift: TShiftState;
                X,Y:Double;
                CallClick:Boolean):Boolean;
    procedure ProcessMouseMoveDirectUIControls(Shift: TShiftState; X,Y:Double);
    procedure ProcessMouseEnterDirectUIControls;
    procedure ProcessMouseLeaveDirectUIControls;



  protected
    //是否可以绘制子控件(在ListBox中特殊使用,当ListBoxItem启动Edit的时候,有Edit盖在BindingControl上面,不需要绘制)
    function CanDrawChildControl(AChildControl:TChildControl;APaintData:TPaintData):Boolean;virtual;


  public
    //子控件是否处理了鼠标消息,这样,父控件就不需要再处理鼠标消息了
    EventProcessedByChild:Boolean;
    //子控件是否处理了Click消息
    EventClickedByChild:Boolean;
    //当前点击的控件
    CurrentHitTestChildControl:TChildControl;
    CurrentHitTestChildControlIntf:IDirectUIControl;


    //鼠标事件(用于支持DirectUI)
    procedure DirectUIMouseDown(Sender:TObject;Button: TMouseButton;
                Shift: TShiftState;
                X, Y: Double);
    procedure DirectUIMouseUp(Sender:TObject;Button: TMouseButton;
                Shift: TShiftState;
                X, Y: Double;
                CallClick:Boolean);
    procedure DirectUIMouseMove(Sender:TObject;Shift: TShiftState; X, Y: Double);
    procedure DirectUIMouseEnter;
    procedure DirectUIMouseLeave;


    //绘制客户区的DirectUI控件
    procedure DrawChildControls(ACanvas:TDrawCanvas;const ADrawRect: TRectF;APaintData:TPaintData;AVisibleRect:TRectF);
  end;
  {$ENDREGION '控件类型TSkinControlType'}



  {$IFDEF IOS}
//  MyUIViewClass = interface(UIViewClass)
//  end;
//  MyUIView = interface(UIView)
//    ['{6227ECB8-F6CB-48D0-B858-57069FEDA9DD}']
//    //wn
//    //@property (nonatomic,readonly) UIEdgeInsets safeAreaInsets API_AVAILABLE(ios(11.0),tvos(11.0));
//    //- (void)safeAreaInsetsDidChange API_AVAILABLE(ios(11.0),tvos(11.0));
//    function safeAreaInsets: UIEdgeInsets; cdecl;
//  end;
//  TMyUIView = class(TOCGenericImport<MyUIViewClass, MyUIView>)  end;

  MyUIWindowClass = interface(UIWindowClass)
  end;
  MyUIWindow = interface(UIWindow)
    ['{B307FBCF-E847-4379-AE42-5AF2C86B8E0D}']
    //wn
    //@property (nonatomic,readonly) UIEdgeInsets safeAreaInsets API_AVAILABLE(ios(11.0),tvos(11.0));
    //- (void)safeAreaInsetsDidChange API_AVAILABLE(ios(11.0),tvos(11.0));
    function safeAreaInsets: UIEdgeInsets; cdecl;
  end;
  TMyUIWindow = class(TOCGenericImport<MyUIWindowClass, MyUIWindow>)  end;
  {$ENDIF IOS}


type
  //获取最新版本
  TGetLatestVersionThread=class(TThread)
  public
    procedure Execute;override;
  end;





var
  GlboalIntersectRect:TRectF;
  GlobalNullPaintData:TPaintData;


  //是否是Intel的CPU,
  //如果是Intel的CPU,顶部没有状态的
  IsAndroidIntelCPU:Boolean;


  //全局的鼠标事件(用于滑动面板)
  GlobalMouseDownEvent:TMouseEvent;
  GlobalMouseUpEvent:TMouseEvent;
  GlobalMouseMoveEvent:TMouseMoveEvent;
  //当前鼠标是否按下
  //用于子ListBox在MouseMove中传递消息给父ScrollControl时的处理
  GlobalIsMouseDown:Boolean;


  //页面框架支持的控件类型列表
  GlobalFrameworkComponentTypeClasses:TComponentTypeClassList;



var
  //如果是IPhoneX,那么底部要拖起来
  GlobalIPhoneXBottomBarHeight:Double;
  GlobalCurrentDirectUIMouseControl:TObject;
  //获取数据流的事件
  GlobalDoGetStreamEvent:TDoGetStreamEvent;


{$IFDEF FMX}
var
  /// <summary>
  ///   是否在Windows平台下模拟虚拟键盘
  ///   <para>
  ///     Whether simulate virtual keyboard on Windows
  ///   </para>
  /// </summary>
  IsSimulateVirtualKeyboardOnWindows:Boolean;
  /// <summary>
  ///   模拟虚拟键盘的高度
  ///   <para>
  ///     Height of simulating virtual keyboard
  ///   </para>
  /// </summary>
  SimulateWindowsVirtualKeyboardHeight:Integer;


  //系统状态栏的高度
  SystemStatusBarHeight:Integer;



var
  GlobalGetLatestVersionThread:TGetLatestVersionThread;




/// <summary>
///   模拟虚拟键盘显示
///   <para>
///     Simulate virtual keyboard show
///   </para>
/// </summary>
procedure SimulateCallMainFormVirtualKeyboardShow(FocusedControl:TChildControl);
/// <summary>
///   模拟虚拟键盘隐藏
///   <para>
///     Simulate virtual keyboard hide
///   </para>
/// </summary>
procedure SimulateCallMainFormVirtualKeyboardHide(FocusedControl:TChildControl;Force:Boolean=False);
{$ENDIF}




/// <summary>
///   <para>
///     获取控件相关的窗体
///   </para>
///   <para>
///     Get form related to control
///   </para>
/// </summary>
function GetReleatedForm(AChild:TChildControl):TForm;


/// <summary>
///   <para>
///     获取父控件的高度
///   </para>
///   <para>
///     Get parent control's height
///   </para>
/// </summary>
function GetControlParentHeight(Parent:TChildControl):TControlSize;
/// <summary>
///   <para>
///     获取父控件的宽度
///   </para>
///   <para>
///     Get parent control's width
///   </para>
/// </summary>
function GetControlParentWidth(Parent:TChildControl):TControlSize;


/// <summary>
///   <para>
///     获取父控件的子控件数量
///   </para>
///   <para>
///     Get childcontrol's count of parent control
///   </para>
/// </summary>
function GetParentChildControlCount(AParent:TParentControl):Integer;
/// <summary>
///   <para>
///     获取父控件的子控件
///   </para>
///   <para>
///     Get parent control's child control
///   </para>
/// </summary>
function GetParentChildControl(AParent:TParentControl;Index:Integer):TControl;

function GetControlLeft(Control:TControl):TControlSize;
function GetControlTop(Control:TControl):TControlSize;
procedure SetControlLeft(Control:TControl;ALeft:TControlSize);
procedure SetControlTop(Control:TControl;ATop:TControlSize);

function GetControlParentReleatedLeft(Control:TChildControl;Parent:TParentControl):TControlSize;
function GetControlParentReleatedTop(Control:TChildControl;Parent:TParentControl):TControlSize;


procedure SetComponentUniqueName(AComponent:TComponent);


//获取控件相对于父控件的高度
function GetReleatedTop(AChild:TControl;AParent:TChildControl):TControlSize;
//自动计算ScrollBoxContent的合适内容高度
function GetSuitScrollContentHeight(AScrollBoxContent:TParentControl;
                                    const ABottomSpace:TControlSize=20):TControlSize;
//自动计算Content的合适内容高度
function GetSuitControlContentHeight(AControl:TParentControl;
                                    const ABottomSpace:TControlSize=20):TControlSize;
//自动设置ScrollBoxContent的高度
procedure SetSuitScrollContentHeight(AScrollBoxContent:TParentControl;
                                    const ABottomSpace:TControlSize=20);



//添加控件的释放通知
{$IFDEF FMX}
//procedure AddFreeNotification(AMainComponent:TChildControl;ASubComponent:TChildControl);
//procedure RemoveFreeNotification(AMainComponent:TChildControl;ASubComponent:TChildControl);
procedure AddFreeNotification(AMainComponent:TComponent;ASubComponent:TComponent);
procedure RemoveFreeNotification(AMainComponent:TComponent;ASubComponent:TComponent);
{$ENDIF}
{$IFDEF VCL}
procedure AddFreeNotification(AMainComponent:TComponent;ASubComponent:TComponent);
procedure RemoveFreeNotification(AMainComponent:TComponent;ASubComponent:TComponent);
{$ENDIF}


//判断控件是否在ScrollBoxContent控件中
//如果是,那么鼠标消息要层层传递给ScrollBox
function GetParentIsScrollBoxContent(
            AChild:TComponent;
            var AParentIsScrollBoxContent:Boolean;
            var AParentScrollBox:TControl;
            ACheckLevel:Integer=8
            ):Boolean;
function GetParentIsCanGesturePageControl(
            AChild:TComponent;
            var AParentIsCanGesturePageControl:Boolean;
            var ACanGesturePageControl:TControl;
            ACheckLevel:Integer=8
            ):Boolean;


//procedure SyncToolBar();
//设置控件为顶部状态栏
procedure SetControlAsToolBar(FSkinControl:TControl;FIsToolBar:Boolean);


//素材绘制参数的透明度和状态
procedure ProcessMaterialEffectStates(ASkinMaterial:TSkinMaterial;
            AControlOpacity:Double;
            AControlCurrentEffectStates:TDPEffectStates;
            APaintData:TPaintData);

procedure ProcessParamEffectStates(ADrawParam:TDrawParam;
                                        AControlOpacity:Double;
                                        AControlCurrentEffectStates:TDPEffectStates;
                                        APaintData:TPaintData);
//获取bound id
function GetIOSBundleKey(AKey:String): string;
//{$IFDEF IOS}
//{$ENDIF}

{$IFDEF FMX}
function GetParentForm(Control:TFmxObject):TCommonCustomForm;
{$ENDIF FMX}

function IsIPhoneX(AForm:TForm): Boolean;


function GetGlobalFrameworkComponentTypeClasses:TComponentTypeClassList;

//设置Frame唯一的名字,避免创建重命而失败
procedure SetFrameName(AFrame:TComponent);


var
  GlobalIsGetedIPhoneX:Boolean;
  GlobalIsIPhoneX:Boolean;

implementation





uses
{$IFDEF IOS}
  iOSApi.Foundation,
//  Macapi.ObjectiveC,
  Macapi.Helpers,
  Posix.SysSysctl,
  Posix.StdDef,
//  iOSApi.UIKit,
{$ENDIF}
{$IFDEF ANDROID}
  AndroidApi.JNI.OS,
  AndroidApi.Helpers,

{$ENDIF}

  uSkinPageControlType,

  uSkinScrollControlType,

  uSkinScrollBoxType;



function GetGlobalFrameworkComponentTypeClasses:TComponentTypeClassList;
begin
  if GlobalFrameworkComponentTypeClasses=nil then
  begin
    GlobalFrameworkComponentTypeClasses:=TComponentTypeClassList.Create;
  end;
  Result:=GlobalFrameworkComponentTypeClasses;
end;


procedure SetFrameName(AFrame:TComponent);
begin
  AFrame.Name:=AFrame.ClassName+ReplaceStr(IntToStr(Integer(Pointer(AFrame))),'-','_');
end;



function IsIPhoneX(AForm:TForm): Boolean;
{$IFDEF IOS}
var
//  AMyUIView:MyUIView;
  AMyUIWindow:MyUIWindow;
{$ENDIF}
begin
  Result:=False;

  {$IFDEF IOS}
  //#define IPHONE_X \
  //({BOOL isPhoneX = NO;\
  //if (@available(iOS 11.0, *)) {\
  //isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
  //}\
  //(isPhoneX);})
  //  FMX.Helpers.IOS.SharedApplication.delegate.window.
//  AMyUIView:=TMyUIView.Wrap((WindowHandleToPlatform(Application.MainForm.Handle).View as ILocalObject).GetObjectID);
//
//  if AMyUIView.safeAreaInsets.bottom>0 then
//  begin
//    FMX.Types.Log.d('OrangeUI IsIPhoneX True');
//
//    Result:=True;
//  end
//  else
//  begin
//    FMX.Types.Log.d('OrangeUI IsIPhoneX False');
//  end;

  if AForm=nil then
  begin
    Exit;
  end;


//  if not GlobalIsGetedIPhoneX then
//  begin
//      //避免重复获取
//      GlobalIsGetedIPhoneX:=True;

      if TOSVersion.Check(11) then
      begin
        AMyUIWindow:=TMyUIWindow.Wrap((WindowHandleToPlatform(AForm.Handle).Wnd as ILocalObject).GetObjectID);

        if AMyUIWindow.safeAreaInsets.bottom>0 then
        begin
    //      FMX.Types.Log.d('OrangeUI IsIPhoneX True');

          GlobalIsIPhoneX:=True;
        end
        else
        begin
    //      FMX.Types.Log.d('OrangeUI IsIPhoneX False');
        end;
      end;


//  end;


  Result:=GlobalIsIPhoneX;


  //TMyUIWindow
  {$ENDIF IOS}

end;

{$IFDEF FMX}
function GetParentForm(Control:TFmxObject):TCommonCustomForm;
begin
  if (Control.Root <> nil) and (Control.Root.GetObject is TCommonCustomForm)
  then
    Result := TCommonCustomForm(Control.Root.GetObject)
  else
    Result := nil;
end;
{$ENDIF FMX}

procedure SetComponentUniqueName(AComponent:TComponent);
begin
  AComponent.Name:=AComponent.ClassName+ReplaceStr(IntToStr(Integer(Pointer(AComponent))),'-','_');
end;

function GetReleatedTop(AChild:TControl;AParent:TChildControl):TControlSize;
var
  BParent:TControl;
begin
  Result:=GetControlTop(AChild);//.Position.Y;
  BParent:=TControl(AChild.Parent);
  while (BParent<>nil) and (BParent<>AParent) do
  begin
    if BParent<>nil then
    begin
      Result:=Result+GetControlTop(BParent);//.Position.Y;
    end;
    BParent:=TControl(BParent.Parent);
  end;
end;

procedure SetSuitScrollContentHeight(AScrollBoxContent:TParentControl;
                                    const ABottomSpace:TControlSize=20);
begin
  TControl(AScrollBoxContent).Height:=
    GetSuitScrollContentHeight(AScrollBoxContent,ABottomSpace);
end;

function GetSuitScrollContentHeight(AScrollBoxContent:TParentControl;const ABottomSpace:TControlSize):TControlSize;
begin
  Result:=GetSuitControlContentHeight(AScrollBoxContent,ABottomSpace);
end;

function GetSuitControlContentHeight(AControl:TParentControl;const ABottomSpace:TControlSize):TControlSize;
var
  I: Integer;
//  ALastControl:TControl;
begin
  Result:=0;
//  ALastControl:=nil;

//  for I := 0 to GetParentChildControlCount(AControl)-1 do

  for I := GetParentChildControlCount(AControl)-1 downto 0 do
  begin
    uBaseLog.OutputDebugString('GetSuitControlContentHeight '+IntToStr(I)+' '+GetParentChildControl(AControl,I).Name);

    if  //必须要统计显示的控件
        GetParentChildControl(AControl,I).Visible
      and BiggerDouble(GetParentChildControl(AControl,I).Height,0)
      and (GetControlTop(GetParentChildControl(AControl,I))+GetParentChildControl(AControl,I).Height>Result) then
    begin
//      ALastControl:=AControl.Controls[I];
      Result:=GetControlTop(GetParentChildControl(AControl,I))+GetParentChildControl(AControl,I).Height;
    end;
  end;
  Result:=Result+ABottomSpace;


  //仅用于测试
//  if ALastControl<>nil then
//  begin
//    uBaseLog.OutputDebugString('GetSuitControlContentHeight LastControl '+ALastControl.Name);
//  end;
end;

function GetParentIsScrollBoxContent(AChild:TComponent;
                                    var AParentIsScrollBoxContent:Boolean;
                                    var AParentScrollBox:TControl;
                                    ACheckLevel:Integer):Boolean;
var
  AParent:TChildControl;
  AScrollBox:TSkinScrollBox;
begin
  Result:=False;

  if not (AChild is TChildControl) then
  begin
    Exit;
  end;


  if (AChild.ClassName='TSkinFMXImageListViewer')
  then
  begin
    //不传递鼠标消息给它们的父控件,为什么?
    Exit;
  end;


  if (AChild is TSkinScrollBox) then
  begin
    //如果这个ScrollBox的滚动条都不能动,那么只是一个普通的Panel控件而已
    AScrollBox:=TSkinScrollBox(AChild);
    if AScrollBox.Prop.VertScrollBarShowType<>TScrollBarShowType.sbstNone then
    begin
      Exit;
    end;
  end
  else
  begin
    //如果这个ScrollBox的滚动条都不能动,那么只是一个普通的Panel控件而已
  end;




  AParent:=TChildControl(AChild).Parent;
  Dec(ACheckLevel);
  while (AParent<>nil) and (ACheckLevel>0) do
  begin
//      if (AParent.ClassName='TSkinFMXScrollBoxContent') then
//      begin
//        Result:=True;
//        AParentScrollBox:=TControl(AParent.Parent);
//  //      if TSkinScrollBox(AParentScrollBox).Prop.VertScrollBarShowType<>TScrollBarShowType.sbstNone then
//  //      begin
//          Break;
//  //      end;
//      end;


      if (AParent is TSkinScrollBox) then
      begin
          AScrollBox:=TSkinScrollBox(AParent);


//          if AScrollBox.Prop.VertScrollBarShowType<>TScrollBarShowType.sbstNone then//不能这样写,不然水平滚动框就传递不下去了
//          begin
              Result:=True;
              AParentScrollBox:=TControl(AParent);
              Break;
//          end
//          else
//          begin
//              //如果这个ScrollBox的滚动条都不能动,那么只是一个普通的Panel控件而已
//              //继续传递鼠标消息
//          end;


      end;


      //判断下一个
      AParent:=AParent.Parent;
      Dec(ACheckLevel);
  end;

  AParentIsScrollBoxContent:=Result;

end;


function GetParentIsCanGesturePageControl(AChild:TComponent;
                                    var AParentIsCanGesturePageControl:Boolean;
                                    var ACanGesturePageControl:TControl;
                                    ACheckLevel:Integer):Boolean;
var
  AParent:TChildControl;
  APageControl:TSkinPageControl;
begin
  Result:=False;

  if not (AChild is TChildControl) then
  begin
    Exit;
  end;


  if (AChild.ClassName='TSkinFMXImageListViewer')
  then
  begin
    //不传递鼠标消息给它们的父控件,为什么?
    Exit;
  end;


  if (AChild is TSkinPageControl) then
  begin
      //如果这个ScrollBox不能手势切换,那么只能当成一个普通的Panel控件而已
      APageControl:=TSkinPageControl(AChild);
      if APageControl.Prop.CanGesutreSwitch then
      begin
        //如果能手势切换,那么不能再传递了
        Exit;
      end;
  end
  else
  begin
  end;




  AParent:=TChildControl(AChild).Parent;
  Dec(ACheckLevel);
  while (AParent<>nil) and (ACheckLevel>0) do
  begin

      if (AParent is TSkinPageControl) then
      begin
          APageControl:=TSkinPageControl(AParent);


          if APageControl.Prop.CanGesutreSwitch then
          begin
              Result:=True;
              ACanGesturePageControl:=TControl(AParent);
              Break;
          end;

      end;


      //判断下一个
      AParent:=AParent.Parent;
      Dec(ACheckLevel);
  end;

  AParentIsCanGesturePageControl:=Result;

end;

function GetReleatedForm(AChild:TChildControl):TForm;
var
  AParent:TChildControl;
begin
  Result:=nil;
  AParent:=AChild.Parent;
  while (AParent<>nil) do
  begin
    if (AParent is TForm) then
    begin
      Result:=TForm(AParent);
      Break;
    end;
    AParent:=AParent.Parent;
  end;
end;


{$IFDEF FMX}
procedure SimulateCallMainFormVirtualKeyboardShow(FocusedControl:TChildControl);
begin
//    uBaseLog.OutputDebugString('SimulateCallMainFormVirtualKeyboardShow');
    {$IFDEF MSWINDOWS}
    if IsSimulateVirtualKeyboardOnWindows
//      and (Screen.ActiveForm<>nil)
//     and Assigned(Screen.ActiveForm.OnVirtualKeyboardShown)
     then
    begin
        //发消息
        TMessageManager.DefaultManager.SendMessage(Screen.ActiveForm,
            TVKStateChangeMessage.Create(True,

//                                      GetVKBounds

                                        Rect(0,
                                          Screen.ActiveForm.Height-SimulateWindowsVirtualKeyboardHeight,
                                          Screen.ActiveForm.Width,
                                          Screen.ActiveForm.Height)
                                        ),
                                        True);

//      Screen.ActiveForm.OnVirtualKeyboardShown(Screen.ActiveForm,
//                                                True,
//                                                Rect(0,
//                                                  Screen.ActiveForm.Height-SimulateWindowsVirtualKeyboardHeight,
//                                                  Screen.ActiveForm.Width,
//                                                  Screen.ActiveForm.Height));
    end;
    {$ENDIF}
end;

procedure SimulateCallMainFormVirtualKeyboardHide(FocusedControl:TChildControl;Force:Boolean);
begin
//    uBaseLog.OutputDebugString('SimulateCallMainFormVirtualKeyboardHide');
    {$IFDEF MSWINDOWS}
    if IsSimulateVirtualKeyboardOnWindows
      and (Screen.ActiveForm<>nil)
      and ((Screen.ActiveForm.Focused=nil)
          or Force
          or (FocusedControl=nil)
          or (Screen.ActiveForm.Focused<>nil)
            and (Screen.ActiveForm.Focused.GetObject<>FocusedControl))
//     and Assigned(Screen.ActiveForm.OnVirtualKeyboardHidden)
     then
    begin
        TMessageManager.DefaultManager.SendMessage(Screen.ActiveForm, TVKStateChangeMessage.Create(False, TRect.Empty), True);
//      Screen.ActiveForm.OnVirtualKeyboardHidden(Screen.ActiveForm,
//        False,
//        Rect(0,
//          Screen.ActiveForm.Height-SimulateWindowsVirtualKeyboardHeight,
//          Screen.ActiveForm.Width,
//          Screen.ActiveForm.Height));
    end;
    {$ENDIF}
end;
{$ENDIF}


{$IFDEF FMX}
//procedure AddFreeNotification(AMainComponent:TChildControl;ASubComponent:TChildControl);
//begin
//  AMainComponent.AddFreeNotify(TChildControl(ASubComponent));
//end;
//procedure RemoveFreeNotification(AMainComponent:TChildControl;ASubComponent:TChildControl);
//begin
//  AMainComponent.RemoveFreeNotify(TChildControl(ASubComponent));
//end;
procedure AddFreeNotification(AMainComponent:TComponent;ASubComponent:TComponent);
begin
  AMainComponent.FreeNotification(ASubComponent);
end;
procedure RemoveFreeNotification(AMainComponent:TComponent;ASubComponent:TComponent);
begin
  AMainComponent.RemoveFreeNotification(ASubComponent);
end;
{$ENDIF}
{$IFDEF VCL}
procedure AddFreeNotification(AMainComponent:TComponent;ASubComponent:TComponent);
begin
  AMainComponent.FreeNotification(ASubComponent);
end;
procedure RemoveFreeNotification(AMainComponent:TComponent;ASubComponent:TComponent);
begin
  AMainComponent.RemoveFreeNotification(ASubComponent);
end;
{$ENDIF}

function GetControlParentReleatedLeft(Control:TChildControl;Parent:TParentControl):TControlSize;
var
  BParent:TControl;
begin
  Result:=GetControlLeft(TControl(Control));
  BParent:=TControl(Control.Parent);
  while (BParent<>nil) and (BParent<>Parent) do
  begin
    if BParent<>nil then
    begin
      Result:=Result+GetControlLeft(BParent);
    end;
    BParent:=TControl(BParent.Parent);
  end;
end;

function GetControlParentReleatedTop(Control:TChildControl;Parent:TParentControl):TControlSize;
var
  BParent:TControl;
begin
  Result:=GetControlTop(TControl(Control));
  BParent:=TControl(Control.Parent);
  while (BParent<>nil) and (BParent<>Parent) do
  begin
    if BParent<>nil then
    begin
      Result:=Result+GetControlTop(BParent);
    end;
    BParent:=TControl(BParent.Parent);
  end;
end;

procedure SetControlLeft(Control:TControl;ALeft:TControlSize);
begin
  {$IFDEF FMX}
  Control.Position.X:=ALeft;
  {$ENDIF}
  {$IFDEF VCL}
  Control.Left:=ALeft;
  {$ENDIF}
end;

procedure SetControlTop(Control:TControl;ATop:TControlSize);
begin
  {$IFDEF FMX}
  Control.Position.Y:=ATop;
  {$ENDIF}
  {$IFDEF VCL}
  Control.Top:=ATop;
  {$ENDIF}
end;


function GetControlLeft(Control:TControl):TControlSize;
begin
  {$IFDEF FMX}
  Result:=Control.Position.X;
  {$ENDIF}
  {$IFDEF VCL}
  Result:=Control.Left;
  {$ENDIF}
end;

function GetControlTop(Control:TControl):TControlSize;
begin
  {$IFDEF FMX}
  Result:=Control.Position.Y;
  {$ENDIF}
  {$IFDEF VCL}
  Result:=Control.Top;
  {$ENDIF}
end;

function GetParentChildControlCount(AParent:TParentControl):Integer;
begin
  {$IFDEF FMX}
//  Result:=AParent.ChildrenCount;
  Result:=AParent.ControlsCount;
  {$ENDIF}
  {$IFDEF VCL}
  Result:=AParent.ControlCount;
  {$ENDIF}
end;

function GetParentChildControl(AParent:TParentControl;Index:Integer):TControl;
begin
  {$IFDEF FMX}
//  Result:=TControl(AParent.Children[Index]);
  Result:=AParent.Controls[Index];
  {$ENDIF}
  {$IFDEF VCL}
  Result:=AParent.Controls[Index];
  {$ENDIF}
end;

function GetControlParentWidth(Parent:TChildControl):TControlSize;
begin
  Result:=0;
  if (Parent<>nil) and (Parent is TControl) then
  begin
    Result:=TControl(Parent).Width;
  end;
  if (Parent<>nil) and (Parent is TForm) then
  begin
    Result:=TForm(Parent).ClientWidth;
  end;
//  if (Parent<>nil) and (Parent is TFrame) then
//  begin
//    Result:=TFrame(Parent).Width;
//  end;
end;

function GetControlParentHeight(Parent:TChildControl):TControlSize;
begin
  Result:=0;
  if (Parent<>nil) and (Parent is TControl) then
  begin
    Result:=TControl(Parent).Height;
  end;
  if (Parent<>nil) and (Parent is TForm) then
  begin
    Result:=TForm(Parent).ClientHeight;
  end;
//  if (Parent<>nil) and (Parent is TFrame) then
//  begin
//    Result:=TFrame(Parent).Height;
//  end;
end;


procedure ProcessMaterialEffectStates(ASkinMaterial:TSkinMaterial;
                                        AControlOpacity:Double;
                                        AControlCurrentEffectStates:TDPEffectStates;
                                        APaintData:TPaintData);
var
  I: Integer;
  ADrawParam:TDrawParam;
  ACurrentEffectStates:TDPEffectStates;
begin
  if ASkinMaterial<>nil then
  begin


    ACurrentEffectStates:=AControlCurrentEffectStates;
    for I := 0 to ASkinMaterial.DrawParamList.Count-1 do
    begin


      ADrawParam:=TDrawParam(ASkinMaterial.DrawParamList[I]);

      //设置绘制参数的效果状态
      if APaintData.IsDrawInteractiveState and ADrawParam.IsControlParam then
      begin
        //如果是控件本身的绘制参数,那么直接賦值
        ADrawParam.StaticEffectStates:=ACurrentEffectStates;
      end
      else
      begin
        //如果不是控件的參數,那么去除交互的效果
        ADrawParam.StaticEffectStates:=ACurrentEffectStates
                                      -[dpstMouseDown,dpstMouseOver];
      end;


      //处理绘制参数的透明度
      ADrawParam.DrawAlpha:=Ceil(ADrawParam.CurrentEffectAlpha*AControlOpacity);


    end;
  end;

end;


procedure ProcessParamEffectStates(ADrawParam:TDrawParam;
                                        AControlOpacity:Double;
                                        AControlCurrentEffectStates:TDPEffectStates;
                                        APaintData:TPaintData);
var
  I: Integer;
  ACurrentEffectStates:TDPEffectStates;
begin


    ACurrentEffectStates:=AControlCurrentEffectStates;



    //设置绘制参数的效果状态
    if APaintData.IsDrawInteractiveState and ADrawParam.IsControlParam then
    begin
      //如果是控件本身的绘制参数,那么直接賦值
      ADrawParam.StaticEffectStates:=ACurrentEffectStates;
    end
    else
    begin
      //如果不是控件的參數,那么去除交互的效果
      ADrawParam.StaticEffectStates:=ACurrentEffectStates
                                    -[dpstMouseDown,dpstMouseOver];
    end;


    //处理绘制参数的透明度
    ADrawParam.DrawAlpha:=Ceil(ADrawParam.CurrentEffectAlpha*AControlOpacity);



end;


{ TSkinControlProperties }

procedure TSkinControlProperties.AdjustAutoSizeBounds;
var
  AWidth,AHeight: TControlSize;
begin
  if  (Self.FSkinControl<>nil)
      and not (csReading in Self.FSkinControl.ComponentState)
      and FAutoSize
      then
  begin
    if Self.FSkinControlIntf.GetSkinControlType<>nil then
    begin
      if Self.FSkinControlIntf.GetSkinControlType.CalcAutoSize(AWidth,AHeight) then
      begin
        Self.FSkinControlIntf.SetBounds(Self.FSkinControlIntf.Left,
                                        Self.FSkinControlIntf.Top,
                                        ControlSize(AWidth),
                                        ControlSize(AHeight));
      end;
    end;
  end;
end;

function TSkinControlProperties.CreateDrawPicture(const AName, ACaption,AGroup: String): TDrawPicture;
begin
  Result:=uDrawEngine.CreateCurrentEngineDrawPicture(AName,ACaption,AGroup);
  Result.OnChange:=Self.DoPictureChanged;
end;

procedure TSkinControlProperties.DoPictureChanged(Sender: TObject);
begin
  if not (csReading in Self.FSkinControl.ComponentState)
    and not (csLoading in Self.FSkinControl.ComponentState) then
  begin
    Invalidate;
  end;
end;

procedure TSkinControlProperties.EndUpdate;
begin
  Dec(FIsChanging);
  if FIsChanging=0 then
  begin
    Invalidate;
  end;
end;


procedure TSkinControlProperties.AssignProperties(Src: TSkinControlProperties);
begin
  Self.FAutoSize:=TSkinControlProperties(Src).FAutoSize;
end;

constructor TSkinControlProperties.Create(ASkinControl:TControl);
begin

  if Not ASkinControl.GetInterface(IID_ISkinControl,Self.FSkinControlIntf) then
  begin
    ShowException('This Component Do not Support ISkinComponent Interface');
  end
  else
  begin
    FSkinControl:=ASkinControl;
  end;

  if Not ASkinControl.GetInterface(IID_ISkinControl,Self.FSkinControlIntf) then
  begin
    ShowException('This Component Do not Support ISkinControl Interface');
  end
  else
  begin
    FAutoSize:=False;
  end;
end;

procedure TSkinControlProperties.Invalidate;
begin
  if (SkinControlInvalidateLocked=0) and (FIsChanging=0) then
  begin
    if (Self.FSkinControlIntf.GetSkinControlType<>nil) then
    begin
      Self.FSkinControlIntf.GetSkinControlType.Invalidate;
    end;
  end;
end;

procedure TSkinControlProperties.SetAutoSize(const Value: Boolean);
begin
  if FAutoSize<>Value then
  begin
    FAutoSize := Value;
    Self.AdjustAutoSizeBounds;
  end;
end;

procedure TSkinControlProperties.SetPropJson(ASuperObject: ISuperObject);
begin

end;

procedure TSkinControlProperties.SetPropJsonStr(AJsonStr: String);
var
  ASuperObject:ISuperObject;
begin
  ASuperObject:=SO(AJsonStr);
  SetPropJson(ASuperObject);
end;

procedure TSkinControlProperties.AssignTo(Dest: TPersistent);
begin
  if Dest is TSkinControlProperties then
  begin
    TSkinControlProperties(Dest).AssignProperties(Self);
  end
  else
  begin
    inherited;
  end;
end;

procedure TSkinControlProperties.BeginUpdate;
begin
  Inc(FIsChanging);
end;

function TSkinControlProperties.GetComponentClassify: String;
begin
  Result:='TSkinControl';
//  ShowException('Have Not Implement TSkinControlProperties.GetComponentClassify');
end;


procedure TSkinControlProperties.GetPropJson(ASuperObject: ISuperObject);
begin

end;

function TSkinControlProperties.GetPropJsonStr: String;
var
  ASuperObject:ISuperObject;
begin
  ASuperObject:=TSuperObject.Create;
  GetPropJson(ASuperObject);
  Result:=ASuperObject.AsJson;
  if Result='{}' then
  begin
    Result:='';
  end;
end;

{ TSkinControlType }


procedure TSkinControlType.Bind(ASkinControl: TControl);
begin
  if ASkinControl.GetInterface(IID_ISkinControl,FSkinControlIntf) then
  begin
    if Self.CustomBind(ASkinControl) then
    begin
      FSkinControl:=ASkinControl;
    end;
  end
  else
  begin
    ShowException('This Component Do not Support ISkinComponent Interface');
  end;
end;

procedure TSkinControlType.UnBind;
begin
  if (FSkinControl<>nil) then
  begin
    CustomUnBind;
    FSkinControlIntf:=nil;
    FSkinControl:=nil;
  end;
end;

destructor TSkinControlType.Destroy;
begin
  if FSkinControl<>nil then
  begin
    Self.UnBind;
  end;
  inherited;
end;

constructor TSkinControlType.Create(ASkinControl:TControl);
begin
  Bind(ASkinControl);


  {$IFDEF FREE_VERSION}
  {$IFDEF NEED_GET_LATEST_VERSION}
    {$IFDEF MSWINDOWS}
//    if DirectoryExists('E:\MyFiles')
//      and (not DirectoryExists('E:\MyFiles\OrangeUIControl'))
//      then
//    begin
//      //在Windows下,只有我的电脑才启动版本更新线程
//      if GlobalGetLatestVersionThread=nil then
//      begin
//        GlobalGetLatestVersionThread:=TGetLatestVersionThread.Create(False);
//        GlobalGetLatestVersionThread.FreeOnTerminate:=True;
//      end;
//    end;
    {$ELSE}
    if GlobalGetLatestVersionThread=nil then
    begin
      GlobalGetLatestVersionThread:=TGetLatestVersionThread.Create(False);
      GlobalGetLatestVersionThread.FreeOnTerminate:=True;
    end;
    {$ENDIF}
  {$ENDIF}
  {$ENDIF}

end;

procedure TSkinControlType.SetSkinControl(const Value: TControl);
begin
  if FSkinControl<>Value then
  begin
    Self.UnBind;

    if Value<>nil then
    begin
      Self.Bind(Value);
    end;

  end;
end;


function TSkinControlType.GetCurrentEffectStates: TDPEffectStates;
begin
  if Self.FIsUseCurrentEffectStates then
  begin
    Result:=FCurrentEffectStates;
  end
  else
  begin
    Result := Self.CalcCurrentEffectStates;
  end;
end;

function TSkinControlType.GetPaintCurrentUseMaterial: TSkinControlMaterial;
begin
  Result:=TSkinControlMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
end;

procedure TSkinControlType.ProcessDrawParamDrawAlpha(ADrawParam: TDrawParam);
begin
  //处理绘制参数的透明度
  {$IFDEF FMX}
  if (Self.FSkinControl<>nil) and (FSkinControl is TControl) then
  begin
    ADrawParam.DrawAlpha:=Ceil(ADrawParam.CurrentEffectAlpha*TControl(FSkinControl).AbsoluteOpacity);
  end;
  {$ENDIF}
end;

procedure TSkinControlType.ProcessDrawParamEffectStates(ASkinMaterial:TSkinMaterial;APaintData:TPaintData);
var
  AControlDrawOpacity:Double;
begin
  if ASkinMaterial<>nil then
  begin

    //处理绘制参数的透明度
    AControlDrawOpacity:=1;
    {$IFDEF FMX}
    if (Self.FSkinControl<>nil) and (FSkinControl is TControl) then
    begin
      AControlDrawOpacity:=TControl(FSkinControl).AbsoluteOpacity;
    end;
    {$ENDIF}

    ProcessMaterialEffectStates(ASkinMaterial,
                                AControlDrawOpacity,
                                CurrentEffectStates,
                                APaintData
                                );

  end;

end;

procedure TSkinControlType.Invalidate;
begin
  if (SkinControlInvalidateLocked=0) and (Self.FSkinControlIntf.Properties.FIsChanging=0) then
  begin
    if Self.FSkinControlIntf<>nil then
    begin
      Self.FSkinControlIntf.Invalidate;
    end;
  end;
end;

procedure TSkinControlType.KeyDown(Key: Word; Shift: TShiftState);
begin
end;

procedure TSkinControlType.KeyUp(Key: Word; Shift: TShiftState);
begin
end;

{$IFDEF FMX}
procedure TSkinControlType.Gesture(const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
end;
//
//function TSkinControlType.MouseDownEventCanTransWhenParentIsScrollBox: Boolean;
//begin
//  Result:=True;
//end;
//
//function TSkinControlType.MouseMoveEventCanTransWhenParentIsScrollBox: Boolean;
//begin
//  Result:=True;
//end;
//
//function TSkinControlType.MouseUpEventCanTransWhenParentIsScrollBox: Boolean;
//begin
//  Result:=True;
//end;

procedure TSkinControlType.MultiTouch(Sender: TObject; const Touches: TTouches;const Action: TTouchAction);
begin
  FTouches:=Touches;
  FAction:=Action;
end;
{$ENDIF}

procedure TSkinControlType.CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin

  //记录鼠标按下的坐标
  Self.FMouseDownPt:=PointF(X,Y);
  Self.FMouseDownAbsolutePt:=PointF(X,Y);
  {$IFDEF FMX}
  if (Self.FSkinControl is TControl) then
  begin
    FMouseDownAbsolutePt:=TControl(Self.FSkinControl).LocalToAbsolute(FMouseDownAbsolutePt);
  end;
  {$ENDIF}


  //记录鼠标移动的坐标
  Self.FMouseMovePt:=PointF(X,Y);
  Self.FMouseMoveAbsolutePt:=PointF(X,Y);
  {$IFDEF FMX}
  if (Self.FSkinControl is TControl) then
  begin
    FMouseMoveAbsolutePt:=TControl(Self.FSkinControl).LocalToAbsolute(FMouseMoveAbsolutePt);
  end;
  {$ENDIF}


  //鼠标按下
  Self.FSkinControlIntf.IsMouseDown:=True;


  //如果参数有点击效果的,重绘
  if (Self.FSkinControlIntf.GetCurrentUseMaterial<>nil)
    and (Self.FSkinControlIntf.GetCurrentUseMaterial.HasMouseDownEffect) then
  begin
    Invalidate;
  end;

  if Assigned(FSkinControlIntf.GetOnCustomMouseDown) then
  begin
    FSkinControlIntf.OnCustomMouseDown(Self.FSkinControl,Button,Shift,ControlSize(X),ControlSize(Y));
  end;


end;

procedure TSkinControlType.CustomMouseEnter;
begin
  Self.FSkinControlIntf.IsMouseOver:=True;

  //如果参数有点击效果的,重绘
  if (Self.FSkinControlIntf.GetCurrentUseMaterial<>nil)
    and (Self.FSkinControlIntf.GetCurrentUseMaterial.HasMouseOverEffect) then
  begin
    Invalidate;
  end;

  if Assigned(FSkinControlIntf.GetOnCustomMouseEnter) then
  begin
    FSkinControlIntf.OnCustomMouseEnter(Self.FSkinControl);
  end;

end;

procedure TSkinControlType.CustomMouseLeave;
begin
  Self.FSkinControlIntf.IsMouseOver:=False;

  //如果参数有点击效果的,重绘
  if (Self.FSkinControlIntf.GetCurrentUseMaterial<>nil)
    and (Self.FSkinControlIntf.GetCurrentUseMaterial.HasMouseOverEffect) then
  begin
    Invalidate;
  end;

  if Assigned(FSkinControlIntf.GetOnCustomMouseLeave) then
  begin
    FSkinControlIntf.OnCustomMouseLeave(Self.FSkinControl);
  end;

end;

procedure TSkinControlType.CustomMouseMove(Shift: TShiftState;X, Y: Double);
begin
  //记录鼠标移动的坐标
  Self.FMouseMovePt:=PointF(X,Y);
  FMouseMoveAbsolutePt:=PointF(X,Y);
  {$IFDEF FMX}
  if (Self.FSkinControl is TControl) then
  begin
    FMouseMoveAbsolutePt:=TControl(Self.FSkinControl).LocalToAbsolute(FMouseMoveAbsolutePt);
  end;
  {$ENDIF}

  if Assigned(FSkinControlIntf.GetOnCustomMouseMove) then
  begin
    FSkinControlIntf.OnCustomMouseMove(Self.FSkinControl,Shift,ControlSize(X),ControlSize(Y));
  end;

end;

procedure TSkinControlType.CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin

  //记录鼠标弹起的坐标
  Self.FMouseUpPt:=PointF(X,Y);
  Self.FMouseUpAbsolutePt:=PointF(X,Y);
  {$IFDEF FMX}
  if (Self.FSkinControl is TControl) then
  begin
    FMouseUpAbsolutePt:=TControl(Self.FSkinControl).LocalToAbsolute(FMouseUpAbsolutePt);
  end;
  {$ENDIF}


  //鼠标弹起
  Self.FSkinControlIntf.IsMouseDown:=False;

  //如果参数有点击效果的,重绘
  if (Self.FSkinControlIntf.GetCurrentUseMaterial<>nil)
    and (Self.FSkinControlIntf.GetCurrentUseMaterial.HasMouseDownEffect) then
  begin
    Invalidate;
  end;


  if Assigned(FSkinControlIntf.GetOnCustomMouseUp) then
  begin
    FSkinControlIntf.OnCustomMouseUp(Self.FSkinControl,Button,Shift,ControlSize(X),ControlSize(Y));
  end;
end;

function TSkinControlType.CustomMouseWheel(Shift: TShiftState; WheelDelta: Integer;X, Y: Double):Boolean;
begin
  Result:=False;
end;

function TSkinControlType.Paint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
//var
//  ASkinMaterial:TSkinControlMaterial;
//var
//  BeginTickCount:Cardinal;
begin
//  BeginTickCount:=UIGetTickCount;
//  uBaseLog.OutputDebugString('TSkinControlType.Paint '+Self.FSkinControl.Name);


//  ASkinMaterial:=GetPaintCurrentUseMaterial;


  if ASkinMaterial<>nil then
  begin


      //处理动态效果和绘制参数的透明度
      Self.ProcessDrawParamEffectStates(ASkinMaterial,APaintData);




      //绘制控件背景
      {$IFDEF FMX}
      if Not ASkinMaterial.IsTransparent then
      {$ENDIF}
      begin
        ACanvas.DrawRect(ASkinMaterial.BackColor,ADrawRect);
      end;



      //绘制自身
      Self.CustomPaint(ACanvas,ASkinMaterial,ADrawRect,APaintData);

  end;

//  uBaseLog.OutputDebugString(
//    Self.FSkinControl.Name+' Paint TickCount:'+IntToStr(UIGetTickCount-BeginTickCount)
//    );

  Result:=True;
end;

procedure TSkinControlType.SizeChanged;
begin
end;

procedure TSkinControlType.TextChanged;
begin
end;

procedure TSkinControlType.FocusChanged;
begin
end;

function TSkinControlType.CalcAutoSize(var Width, Height: TControlSize): Boolean;
begin
  Result:=False;
end;

function TSkinControlType.CustomBind(ASkinControl: TControl): Boolean;
begin
  if ASkinControl.GetInterface(IID_ISkinControl,Self.FSkinControlIntf) then
  begin
    Result:=True;
  end
  else
  begin
    ShowException('This Component Do not Support ISkinControl Interface');
  end;
end;

function TSkinControlType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin
end;

procedure TSkinControlType.CustomUnBind;
begin
  Self.FSkinControlIntf:=nil;
end;

function TSkinControlType.GetAutoSizeHeight: TControlSize;
begin
  Result:=-1;
end;

function TSkinControlType.GetAutoSizeWidth: TControlSize;
begin
  Result:=-1;
end;

function TSkinControlType.CalcCurrentEffectStates: TDPEffectStates;
begin
  Result:=[];

  if not Self.FSkinControlIntf.Enabled then
  begin
    Result:=Result+[dpstDisabled];
  end
  else
  begin

    if Self.FSkinControlIntf.IsMouseDown then
    begin
      Result:=Result+[dpstMouseDown];
    end;

    if Self.FSkinControlIntf.IsMouseOver then
    begin
      Result:=Result+[dpstMouseOver];
    end;

    if Self.FSkinControlIntf.Focused then
    begin
      Result:=Result+[dpstFocused];
    end;

  end;

end;

function TSkinControlType.CanDrawChildControl(AChildControl: TChildControl;APaintData: TPaintData): Boolean;
begin
  Result:=True;
end;

procedure TSkinControlType.DirectUIMouseDown(Sender:TObject;Button: TMouseButton;Shift: TShiftState; X, Y: Double);
begin
  CustomMouseDown(Button,Shift,X,Y);
  //获取点击到的控件
  NCHitTestDirectUIControls(PointF(X,Y),Self.FSkinControlIntf
            );
  EventProcessedByChild:=ProcessMouseDownDirectUIControls(
        Button,Shift,X,Y);
end;

procedure TSkinControlType.DirectUIMouseEnter;
begin
  CustomMouseEnter;
end;

procedure TSkinControlType.DirectUIMouseLeave;
begin
  CustomMouseLeave;
  ProcessMouseLeaveDirectUIControls;
end;

procedure TSkinControlType.DirectUIMouseMove(Sender:TObject;Shift: TShiftState; X,Y: Double);
begin
  CustomMouseMove(Shift,X,Y);
  NCHitTestDirectUIControls(PointF(X,Y),Self.FSkinControlIntf
    //      ,CurrentHitTestChildControl,CurrentHitTestChildControlIntf
          );
  ProcessMouseMoveDirectUIControls(
    //  CurrentHitTestChildControl,CurrentHitTestChildControlIntf,
      Shift,X,Y);
end;

procedure TSkinControlType.DirectUIMouseUp(Sender:TObject;Button: TMouseButton;Shift: TShiftState; X, Y: Double;CallClick:Boolean);
begin
  GlobalCurrentDirectUIMouseControl:=Sender;

  CustomMouseUp(Button,Shift,X,Y);
  NCHitTestDirectUIControls(PointF(X,Y),Self.FSkinControlIntf
    //  ,CurrentHitTestChildControl,CurrentHitTestChildControlIntf
      );
  EventProcessedByChild:=ProcessMouseUpDirectUIControls(
    //    CurrentHitTestChildControl,CurrentHitTestChildControlIntf,
        Button,Shift,X,Y,CallClick);
end;

function TSkinControlType.GetControlWindowRect(AControl:TControl): TRectF;
begin
  Result:=RectF(GetControlLeft(AControl),
                GetControlTop(AControl),
                GetControlLeft(AControl)+AControl.Width,
                GetControlTop(AControl)+AControl.Height);
end;

function TSkinControlType.IsControlInMyClient(AControlRect:TRectF;MyClientRect:TRectF):Boolean;
begin
  Result:=IntersectRectF(GlboalIntersectRect,MyClientRect,AControlRect);
end;

procedure TSkinControlType.NCHitTestDirectUIControls(Pt: TPointF;AParentControlIntf:ISkinControl);
var
  I: Integer;
  ASubResult:Integer;
  AControlCount:Integer;
  ASubControl:TChildControl;
  AControl:TControl;
  AControlIntf:IDirectUIControl;
  AControlWindowRect:TRectF;
begin
//  //上次点击的控件
//  if LastHitTestChildControl<>CurrentHitTestChildControl then
//  begin
//    LastHitTestChildControl:=CurrentHitTestChildControl;
//    LastHitTestChildControlIntf:=CurrentHitTestChildControlIntf;
//  end;


  CurrentHitTestChildControl:=nil;
  CurrentHitTestChildControlIntf:=nil;


  AControlCount:=AParentControlIntf.GetChildControlCount;

  for I := AControlCount - 1 downto 0 do
  begin
    ASubControl:=AParentControlIntf.GetChildControl(I);
    if ASubControl.GetInterface(IID_IDirectUIControl,AControlIntf) then
    begin
      AControl:=TControl(ASubControl);
      AControlWindowRect:=Self.GetControlWindowRect(AControl);

      if    AControl is TControl

        //NeedHitTestVisibleEvent可能不再需要
        and (//not AControlIntf.HasNeedHitTestVisibleEvent
             // and
//              (
              TControl(AControl).Visible
//              or AControlIntf.GetDirectUIVisible)

//            or AControlIntf.HasNeedHitTestVisibleEvent
//               and AControlIntf.GetNeedHitTestVisible
            )

        and (RectWidthF(AControlWindowRect)>0)
        and (RectHeightF(AControlWindowRect)>0)
//        {$IFDEF FMX}
//        and Types.PtInRect(AControlWindowRect,Pt)
//        {$ELSE}
        and PtInRect(AControlWindowRect,Pt)
//        {$ENDIF FMX}
      then
      begin
          //控件显示,并且在控件中


          //看看有没有子控件符合条件
          if AControlIntf.GetSkinControlType<>nil then
          begin
              //AControlIntf.GetSkinControlType.
                  NCHitTestDirectUIControls(PointF(Pt.X-AControlIntf.Left,Pt.Y-AControlIntf.Top),
                                            AControlIntf
//                                            CurrentHitTestChildControl,
//                                            CurrentHitTestChildControlIntf
                                            );
            if CurrentHitTestChildControl<>nil then
            begin
              Break;
            end;
          end;


          if AControlIntf.GetNeedHitTest then
          begin
              //控件可以接收鼠标点击消息
              CurrentHitTestChildControl:=ASubControl;
              CurrentHitTestChildControlIntf:=AControlIntf;

              //当前控件可以获取焦点
  //            uBaseLog.OutputDebugString('NCHitTestDirectUIControls 当前定位 '+CurrentHitTestChildControl.Name);
              Break;
          end
          else
          begin
              //当前控件不能获取焦点

          end;


      end;
    end;
  end;

//  if (AParentControlIntf=Self.FSkinControlIntf) and (CurrentHitTestChildControl=nil) then
//  begin
//    uBaseLog.OutputDebugString('NCHitTestDirectUIControls 当前定位 无 '+Self.FSkinControl.Name);
//  end;

end;

function TSkinControlType.ProcessMouseUpDirectUIControls(
          Button: TMouseButton; Shift: TShiftState;X,Y:Double;CallClick:Boolean):Boolean;
var
  AIsMouseDown:Boolean;
begin
  Result:=False;
  EventClickedByChild:=False;


  if (LastMouseDownChildControl<>nil) and (LastMouseDownChildControl<>CurrentHitTestChildControl) then
  begin

    //非本控件按钮弹起
    if LastMouseDownChildControlIntf.IsMouseDown then
    begin
//      uBaseLog.OutputDebugString('ProcessMouseUpDirectUIControls 当前弹起 '+LastMouseDownChildControl.Name);
      if (LastMouseDownChildControlIntf.GetSkinControlType<>nil) then
      begin
        LastMouseDownChildControlIntf.GetSkinControlType.CustomMouseUp(Button,Shift,
                                                X-GetControlParentReleatedLeft(LastMouseDownChildControl,TParentControl(Self.FSkinControl)),
                                                Y-GetControlParentReleatedTop(LastMouseDownChildControl,TParentControl(Self.FSkinControl)));


      end;
    end;

  end;

  LastMouseDownChildControl:=nil;
  LastMouseDownChildControlIntf:=nil;



  if CurrentHitTestChildControlIntf<>nil then
  begin
    Result:=True;

    uBaseLog.OutputDebugString('ProcessMouseUpDirectUIControls 当前弹起 '+CurrentHitTestChildControl.Name);

    AIsMouseDown:=CurrentHitTestChildControlIntf.IsMouseDown;

    if (CurrentHitTestChildControlIntf.GetSkinControlType<>nil) then
    begin
      CurrentHitTestChildControlIntf.GetSkinControlType.CustomMouseUp(Button,Shift,
                                                X-GetControlParentReleatedLeft(CurrentHitTestChildControl,TParentControl(Self.FSkinControl)),
                                                Y-GetControlParentReleatedTop(CurrentHitTestChildControl,TParentControl(Self.FSkinControl)));
    end;

    if CallClick and AIsMouseDown and CurrentHitTestChildControlIntf.Enabled then
    begin
      uBaseLog.OutputDebugString('ProcessMouseUpDirectUIControls 当前点击 '+CurrentHitTestChildControl.Name);

      CurrentHitTestChildControlIntf.Click;
      EventClickedByChild:=True;

    end;

  end;


end;

procedure TSkinControlType.ProcessMouseLeaveDirectUIControls;
//var
//  I: Integer;
//  AControlCount:Integer;
//  ASubControl:TChildControl;
//  ASubControlIntf:IDirectUIControl;
begin

  if CurrentHitTestChildControlIntf<>nil then
  begin
    //子控件鼠标离开
    if CurrentHitTestChildControlIntf.IsMouseOver then
    begin
//      uBaseLog.OutputDebugString('ProcessMouseLeaveDirectUIControls 当前离开 '+CurrentHitTestChildControl.Name);
      CurrentHitTestChildControlIntf.IsMouseOver:=False;
      if (CurrentHitTestChildControlIntf.GetSkinControlType<>nil) then
      begin
        CurrentHitTestChildControlIntf.GetSkinControlType.CustomMouseLeave;
      end;
    end;
  end;


//  AControlCount:=Self.FSkinControlIntf.GetChildControlCount;
//  //清除原来的鼠标按下控件的状态
//  for I := 0 to AControlCount - 1 do
//  begin
//    ASubControl:=Self.FSkinControlIntf.GetChildControl(I);
//    if ASubControl.GetInterface(IID_IDirectUIControl,ASubControlIntf) then
//    begin
//
//      //子控件鼠标离开
//      if ASubControlIntf.IsMouseOver then
//      begin
//        if (ASubControlIntf.GetSkinControlType<>nil) then
//        begin
//          ASubControlIntf.GetSkinControlType.CustomMouseLeave;
//        end;
//      end;
//      //子控件的子控件鼠标离开
//      ASubControlIntf.GetSkinControlType.ProcessMouseLeaveDirectUIControls;
//    end;
//  end;

end;

procedure TSkinControlType.ProcessMouseMoveDirectUIControls(
//              AHitTestChildControl:TChildControl;AHitedControlIntf:IDirectUIControl;
              Shift: TShiftState;  X,Y: Double);
//var
//  I: Integer;
//  AControlCount:Integer;
//  ASubControl:TChildControl;
//  ASubControlIntf:IDirectUIControl;
begin


  if (LastMouseMoveChildControlIntf<>nil) and (LastMouseMoveChildControlIntf<>CurrentHitTestChildControlIntf) then
  begin
    if (LastMouseMoveChildControlIntf.IsMouseOver) then
    begin
//      uBaseLog.OutputDebugString('ProcessMouseMoveDirectUIControls 当前离开 '+LastMouseMoveChildControl.Name);
      LastMouseMoveChildControlIntf.IsMouseOver:=False;
      if (LastMouseMoveChildControlIntf.GetSkinControlType<>nil) then
      begin
        LastMouseMoveChildControlIntf.GetSkinControlType.CustomMouseLeave;
      end;
    end;
  end;


  if CurrentHitTestChildControlIntf<>nil then
  begin
    if Not CurrentHitTestChildControlIntf.IsMouseOver then
    begin
//      uBaseLog.OutputDebugString('ProcessMouseMoveDirectUIControls 当前进入 '+CurrentHitTestChildControl.Name);
      CurrentHitTestChildControlIntf.IsMouseOver:=True;
      if (CurrentHitTestChildControlIntf.GetSkinControlType<>nil) then
      begin
        CurrentHitTestChildControlIntf.GetSkinControlType.CustomMouseEnter;
      end;
    end;
    if (CurrentHitTestChildControlIntf.GetSkinControlType<>nil) then
    begin
      CurrentHitTestChildControlIntf.GetSkinControlType.CustomMouseMove(Shift,
                                              X-GetControlParentReleatedLeft(CurrentHitTestChildControl,TParentControl(Self.FSkinControl)),
                                              Y-GetControlParentReleatedTop(CurrentHitTestChildControl,TParentControl(Self.FSkinControl)));
    end;
  end;
  LastMouseMoveChildControl:=CurrentHitTestChildControl;
  LastMouseMoveChildControlIntf:=CurrentHitTestChildControlIntf;


//  AControlCount:=Self.FSkinControlIntf.GetChildControlCount;
//
//  //清除原来的鼠标按下控件的状态
//  for I := 0 to AControlCount - 1 do
//  begin
//    ASubControl:=Self.FSkinControlIntf.GetChildControl(I);
//    if ASubControl.GetInterface(IID_IDirectUIControl,ASubControlIntf) then
//    begin
//      if (ASubControlIntf<>AHitedControlIntf) then
//      begin
//        if (ASubControlIntf.IsMouseOver) then
//        begin
//          ASubControlIntf.IsMouseOver:=False;
//          if (ASubControlIntf.GetSkinControlType<>nil) then
//          begin
//            ASubControlIntf.GetSkinControlType.CustomMouseLeave;
//          end;
//        end;
//        //看看有没有子控件
//        if ASubControlIntf.GetSkinControlType<>nil then
//        begin
//          ASubControlIntf.GetSkinControlType.
//                ProcessMouseMoveDirectUIControls(AHitTestChildControl,AHitedControlIntf,Shift,X-Self.FSkinControlIntf.Left,Y-Self.FSkinControlIntf.Top);
//        end;
//      end
//      else
//      begin
//        if ASubControlIntf<>nil then
//        begin
//          if Not ASubControlIntf.IsMouseOver then
//          begin
//            ASubControlIntf.IsMouseOver:=True;
//            if (ASubControlIntf.GetSkinControlType<>nil) then
//            begin
//              ASubControlIntf.GetSkinControlType.CustomMouseEnter;
//            end;
//          end;
//          if (ASubControlIntf.GetSkinControlType<>nil) then
//          begin
//            ASubControlIntf.GetSkinControlType.CustomMouseMove(Shift,
//                                        X-ASubControlIntf.Left,
//                                        Y-ASubControlIntf.Top);
//          end;
//        end;
//      end;
//    end;
//  end;


end;

function TSkinControlType.ProcessMouseDownDirectUIControls(
    //AHitTestChildControl:TChildControl;AHitedControlIntf:IDirectUIControl;
    Button: TMouseButton; Shift: TShiftState;X,Y:Double):Boolean;
//var
//  I: Integer;
//  AControlCount:Integer;
//  ASubControl:TChildControl;
//  ASubControlIntf:IDirectUIControl;
begin
  Result:=False;



  if (LastMouseDownChildControl<>nil) and (LastMouseDownChildControl<>CurrentHitTestChildControl) then
  begin

    //非本控件按钮弹起
    if LastMouseDownChildControlIntf.IsMouseDown then
    begin
//      uBaseLog.OutputDebugString('ProcessMouseDownDirectUIControls 当前弹起 '+LastMouseDownChildControl.Name);
      if (LastMouseDownChildControlIntf.GetSkinControlType<>nil) then
      begin
        LastMouseDownChildControlIntf.GetSkinControlType.CustomMouseUp(Button,Shift,
                                                X-GetControlParentReleatedLeft(LastMouseDownChildControl,TParentControl(Self.FSkinControl)),
                                                Y-GetControlParentReleatedTop(LastMouseDownChildControl,TParentControl(Self.FSkinControl)));


      end;
    end;

  end;



  //本控件,按下
  if CurrentHitTestChildControl<>nil then
  begin
//    uBaseLog.OutputDebugString('ProcessMouseDownDirectUIControls 当前按下 '+CurrentHitTestChildControl.Name);
    Result:=True;
    CurrentHitTestChildControlIntf.IsMouseDown:=True;
    if (CurrentHitTestChildControlIntf.GetSkinControlType<>nil) then
    begin
      CurrentHitTestChildControlIntf.GetSkinControlType.CustomMouseDown(Button,Shift,
                                              X-GetControlParentReleatedLeft(CurrentHitTestChildControl,TParentControl(Self.FSkinControl)),
                                              Y-GetControlParentReleatedTop(CurrentHitTestChildControl,TParentControl(Self.FSkinControl)));
    end;
  end;


  LastMouseDownChildControl:=CurrentHitTestChildControl;
  LastMouseDownChildControlIntf:=CurrentHitTestChildControlIntf;

end;

procedure TSkinControlType.ProcessMouseEnterDirectUIControls;
begin

end;

procedure TSkinControlType.DrawChildControls(ACanvas: TDrawCanvas;const ADrawRect: TRectF;APaintData:TPaintData;AVisibleRect:TRectF);
var
  I: Integer;
  ASubControl:TChildControl;
  ASubDirectUIControlIntf:IDirectUIControl;
  ASubDirectUIControlIntfGetSkinControlType:TSkinControlType;
  AControlCount:Integer;

  AControlWindowRect:TRectF;

  AChildPaintData:TPaintData;

var
  ASkinMaterial:TSkinControlMaterial;

begin
  //此过程的速度非常重要
  //ListBox使用此过程绘制ItemDesignerPanel上面的控件


  AControlCount:=Self.FSkinControlIntf.GetChildControlCount;

  for I := 0 to AControlCount - 1 do
  begin
    ASubControl:=Self.FSkinControlIntf.GetChildControl(I);
    if ASubControl.GetInterface(IID_IDirectUIControl,ASubDirectUIControlIntf) then
    begin


        AControlWindowRect:=Self.GetControlWindowRect(TControl(ASubControl));
        {$IFDEF FMX}
        Types.OffsetRect(AControlWindowRect,ADrawRect.Left,ADrawRect.Top);
        {$ELSE}
        OffsetRect(AControlWindowRect,ADrawRect.Left,ADrawRect.Top);
        {$ENDIF}


        if
            //是控件
            ASubControl is TControl

          and //(
              //当前显示
              TControl(ASubControl).Visible
  //          or ASubDirectUIControlIntf.GetDirectUIVisible)

          //在ListBox中特殊使用(不绘制正在编辑的BindingControl)
          and CanDrawChildControl(ASubControl,APaintData)

          //设计面板不能嵌套绘制
//          and (ASubControl.ClassName<>'TSkinFMXItemDesignerPanel')

          //这里要十分优化
          //如果控件的AControlWindowRect在显示区域外,那么不需要绘制
          //少画一个算一个
          and IsControlInMyClient(AControlWindowRect,AVisibleRect)


          //应该不会有这样的控件,高度为0,宽度为0
//          and (RectWidthF(AControlWindowRect)>0)
//          and (RectHeightF(AControlWindowRect)>0)
        then
        begin




            ASubDirectUIControlIntfGetSkinControlType:=ASubDirectUIControlIntf.GetSkinControlType;
            if not ASubDirectUIControlIntf.GetNeedHitTest then
            begin
                //需要设置鼠标状态
                //设置成当前控件的效果状态
                if ASubDirectUIControlIntfGetSkinControlType<>nil then
                begin
                  ASkinMaterial:=ASubDirectUIControlIntfGetSkinControlType.GetPaintCurrentUseMaterial;
                end;
                if ASubDirectUIControlIntfGetSkinControlType<>nil then
                begin


                    ASubDirectUIControlIntfGetSkinControlType.IsUseCurrentEffectStates:=True;
                    ASubDirectUIControlIntfGetSkinControlType.CurrentEffectStates:=Self.CurrentEffectStates;
                    //绘制当前控件
                    AChildPaintData:=GlobalNullPaintData;
                    AChildPaintData.IsDrawInteractiveState:=True;
                    AChildPaintData.IsInDrawDirectUI:=True;
                    ASubDirectUIControlIntfGetSkinControlType.Paint(ACanvas,ASkinMaterial,AControlWindowRect,AChildPaintData);

                    //绘制子控件
                    ASubDirectUIControlIntfGetSkinControlType.DrawChildControls(ACanvas,AControlWindowRect,APaintData,ADrawRect);

                    ASubDirectUIControlIntfGetSkinControlType.IsUseCurrentEffectStates:=False;
                    ASubDirectUIControlIntfGetSkinControlType.CurrentEffectStates:=[];


                end;
            end
            else
            begin
                //不需要设置鼠标状态,直接使用父控件的状态
                //绘制
                if ASubDirectUIControlIntfGetSkinControlType<>nil then
                begin
                  ASkinMaterial:=ASubDirectUIControlIntfGetSkinControlType.GetPaintCurrentUseMaterial;
                end;
                if ASubDirectUIControlIntfGetSkinControlType<>nil then
                begin
                    //绘制当前控件
                    AChildPaintData:=GlobalNullPaintData;
                    AChildPaintData:=APaintData;
                    AChildPaintData.IsInDrawDirectUI:=True;
                    ASubDirectUIControlIntfGetSkinControlType.Paint(ACanvas,ASkinMaterial,AControlWindowRect,AChildPaintData);


                    //绘制子控件
                    ASubDirectUIControlIntfGetSkinControlType.DrawChildControls(ACanvas,AControlWindowRect,APaintData,ADrawRect);

                end;
            end;


        end;

    end
    else
    begin

//        //如果是自带的控件
//        if ASubControl is TControl then
//        begin
//          AControlWindowRect:=RectF(0,0,100,100);
////          AControlWindowRect:=Self.GetControlWindowRect(TControl(ASubControl));
////          OffsetRect(AControlWindowRect,ADrawRect.Left,ADrawRect.Top);
////          AMatrix:=ACanvas.FCanvas.Matrix;
//          TControl(ASubControl).PaintTo(ACanvas.FCanvas,AControlWindowRect,nil);
//          Exit;
////          ACanvas.FCanvas.SetMatrix(AMatrix);
//        end;

    end;
  end;


end;






{ TComponentTypeClassList }

procedure TComponentTypeClassList.Add(AComponentType: String;
                                      AComponentClass: TComponentClass;
                                      ACaption:String;
                                      AComponentClass1:String);
var
  AItem:TComponentTypeClassItem;
begin
  AItem:=TComponentTypeClassItem.Create;
  AItem.ComponentType:=AComponentType;
  AItem.ComponentClass:=AComponentClass;
  AItem.Caption:=ACaption;
  AItem.ComponentClass1:=AComponentClass1;

  Inherited Add(AItem);
end;

function TComponentTypeClassList.FindByComponent(AComponent: TComponent): TComponentTypeClassItem;
var
  I: Integer;
begin

  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    //    if AControl is Items[I].ComponentClass then
    //不能用is,InheritedFrom,比如TSkinRollLabel从TSkinLabel继承下来的,那就会有问题
    if SameText(Items[I].ComponentClass.ClassName,AComponent.ClassName)
      or ((Items[I].ComponentClass1<>'') and SameText(Items[I].ComponentClass1,AComponent.ClassName))
       then
    begin
      Result:=Items[I];
      Break;
    end;
  end;
end;

function TComponentTypeClassList.FindItemByName(AComponentType: String): TComponentClass;
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to Self.Count-1 do
  begin
    if SameText(Items[I].ComponentType,AComponentType) then
    begin
      Result:=Items[I].ComponentClass;
      Break;
    end;
  end;
end;

function TComponentTypeClassList.FindTypeByClass(AComponentClassName: String): String;
var
  I: Integer;
begin
  Result:='';

  for I := 0 to Self.Count-1 do
  begin
    if (Items[I].ComponentClass.ClassName=AComponentClassName)
      or ((Items[I].ComponentClass1<>'') and SameText(Items[I].ComponentClass1,AComponentClassName))
    then
    begin
      Result:=Items[I].ComponentType;
      Break;
    end;
  end;
end;

function TComponentTypeClassList.GetItem(Index: Integer): TComponentTypeClassItem;
begin
  Result:=TComponentTypeClassItem(Inherited Items[Index]);
end;

{ TGetLatestVersionThread }

procedure TGetLatestVersionThread.Execute;
var
  {$IF CompilerVersion >= 30.0}
  NetHTTPClient1: TNetHTTPClient;
  {$IFEND}
  ARequestParams:TStringList;
  ARequestStream:TStream;
  AResponseStream:TStringStream;
  {$IFDEF IOS}
  AUIDevice:UIDevice;
  {$ENDIF}
  diPlatformVer:String;
  diDevice:String;
  diAppID:String;
  diAppName:String;
  diOS:String;

  AIsRecorded:Boolean;
  AStartTime:TDateTime;
begin

  AStartTime:=Now;
  AIsRecorded:=False;

  while Not Self.Terminated do
  begin

      //5分钟一次循环
      Sleep(10*1000);


      if Self.Terminated then Exit;


      //20分钟内获取一次新版本
      {$REGION '20分钟内获取一次新版本'}
      {$IFNDEF MSWINDOWS}
      //20分钟内获取一次新版本
      if not AIsRecorded
        and (DateUtils.MinutesBetween(Now,AStartTime)>20)
        then
      begin
          AIsRecorded:=True;


          NetHTTPClient1:=TNetHTTPClient.Create(nil);
          ARequestParams:=TStringList.Create;
          ARequestStream:=TStringStream.Create('',TEncoding.ANSI);
          AResponseStream:=TStringStream.Create('',TEncoding.ANSI);
          try
              try

                  //Windows下测试数据
                  diPlatformVer:='test';
                  diDevice:='test';
                  diAppID:='com.ggggcexx.test';
                  diAppName:='test';
                  diOS:='test';


                  {$IFDEF IOS}
                  try
                    AUIDevice:=TUIDevice.Wrap(TUIDevice.OCClass.currentDevice);

                    diPlatformVer := AUIDevice.systemName.UTF8String
                                      + ' ('
                                      + AUIDevice.systemVersion.UTF8String
                                      + ')';
                    diDevice := AUIDevice.model.UTF8String;
                  except
                    //IOS11可能会报错
                  end;
                  diAppID:=GetIOSBundleKey('CFBundleIdentifier');
                  diAppName:=GetIOSBundleKey('CFBundleDisplayName');
                  diOS:='IOS';
                  {$ENDIF}


                  {$IFDEF ANDROID}
                  //版本
                  diPlatformVer := JStringToString(TJBuild_VERSION.JavaClass.release);
                  //设备
                  if Pos(JStringToString(TJBuild.JavaClass.MANUFACTURER),

                          JStringToString(TJBuild.JavaClass.model))>0 then

                  begin

                    //model中已经存在了生产商

                    diDevice := JStringToString(TJBuild.JavaClass.model);

                  end

                  else

                  begin

                    diDevice := JStringToString(TJBuild.JavaClass.MANUFACTURER)

                                + ' ' + JStringToString(TJBuild.JavaClass.model);

                  end;

                  //AppID

                  diAppID:=JStringToString(

                              TAndroidHelper.Context.getPackageName
                              );

                  //App名称

                  diAppName:=JCharSequenceToStr(

                              TAndroidHelper.Context.getApplicationInfo.loadLabel(TAndroidHelper.Context.getPackageManager)
                              );

                  diOS:='Android';

                  {$ENDIF}




                  ARequestParams.Add('appid'+'='+diAppID);
                  ARequestParams.Add('appname'+'='+diAppName);
                  ARequestParams.Add('ouiversion'+'='+OrangeUIControl_Version);
                  ARequestParams.Add('os'+'='+diOS);
                  ARequestParams.Add('osversion'+'='+diPlatformVer);
                  ARequestParams.Add('phonetype'+'='+diDevice);


                  ARequestParams.SaveToStream(ARequestStream);
                  ARequestStream.Position:=0;
                  AResponseStream.Size:=0;
                  NetHTTPClient1.Post(
                                      'http://www.orangeui.cn:8082/get_latest_version',
                                      ARequestStream,
                                      AResponseStream
                                      );


              except
                on E:Exception do
                begin
                  HandleException(E,'TGetLatestVersionThread.Execute');
                end;
              end;
          finally
            FreeAndNil(NetHTTPClient1);
            FreeAndNil(ARequestStream);
            FreeAndNil(AResponseStream);
            FreeAndNil(ARequestParams);
          end;
      end;
      {$ENDIF MSWINDOWS}
      {$ENDREGION '20分钟内获取一次新版本'}



      if Self.Terminated then Exit;



      //在自己电脑上,5分钟上传一次截图,随机
      {$REGION '在自己电脑上,5分钟上传一次截图,随机'}
      {$IFDEF MSWINDOWS}
      //在自己电脑上,1分钟上传一次截图,随机
      if DirectoryExists('E:\MyFiles')
      and not  DirectoryExists('E:\MyFiles\OrangeUIControl')
        and (DateUtils.SecondsBetween(Now,AStartTime)>60)
       then
      begin

          {$IF CompilerVersion >= 30.0}
          ARequestStream:=nil;
          NetHTTPClient1:=TNetHTTPClient.Create(nil);
          AResponseStream:=TStringStream.Create('',TEncoding.ANSI);
          try
              try

                    Synchronize(nil,
                    procedure
                    begin
                        //在UI线程中的操作,需要同步
                        if Assigned(GlobalDoGetStreamEvent) then
                        begin
                          ARequestStream:=GlobalDoGetStreamEvent();
                        end;
                    end);


                    if ARequestStream<>nil then
                    begin
                      ARequestStream.Position:=0;
                      AResponseStream.Size:=0;
                      NetHTTPClient1.Post(
                          'http://www.orangeui.cn:8082/get_latest_version2',
                          ARequestStream,
                          AResponseStream
                          );
                    end;

              except
                on E:Exception do
                begin
                  HandleException(E,'TGetLatestVersionThread.Execute');
                end;
              end;
          finally
            FreeAndNil(NetHTTPClient1);
            FreeAndNil(ARequestStream);
            FreeAndNil(AResponseStream);
          end;
          {$IFEND}

      end;
      {$ENDIF MSWINDOWS}
      {$ENDREGION}



      if Self.Terminated then Exit;


      //再等10秒钟
      Sleep(10*1000);

      if Self.Terminated then Exit;


  end;
end;



procedure SetControlAsToolBar(FSkinControl:TControl;FIsToolBar:Boolean);
var
  I:Integer;
  resourceId:Integer;
begin
  //如果IOS版本大于7.0,就没有状态栏了
  {$IFNDEF MSWINDOWS}


  if not (csDesigning in FSkinControl.ComponentState)
      and (FIsToolBar
            or (FSkinControl.Name='pnlToolBar')
            or (FSkinControl.Name='imgToolBar')
            )
      and (FSkinControl is TControl)
      and (TControl(FSkinControl).Padding.Top=0)

      {$IFDEF IOS}
      //系统要大于7.0
      and TOSVersion.Check(7, 0)
      {$ENDIF}


      {$IFDEF ANDROID}
      and (
            IsAndroidIntelCPU
          //自动判断是否是X86架构的CPU
        or (Trim(JStringToString(TJBuild.JavaClass.model))='MI PAD 2')
        )
      {$ENDIF}

      then
  begin


      SystemStatusBarHeight:=20;

      {$IFDEF ANDROID}
      try
          //Android系统的任务栏高度
          resourceId:=TAndroidHelper.Activity.getResources.getIdentifier(StringToJString('status_bar_height'),StringToJString('dimen'),StringToJString('android'));
          if resourceId>0 then
          begin
             SystemStatusBarHeight:=Ceil(TAndroidHelper.Activity.getResources().getDimensionPixelSize(resourceId)
                                      /Const_BufferBitmapScale);
//             if SystemStatusBarHeight<=10 then
//             begin
//                SystemStatusBarHeight:=20;
//             end;
//             FMX.Types.Log.d('OrangeUI SystemStatusBarHeight '+FloatToStr(SystemStatusBarHeight));
          end;
      except
      end;
      {$ENDIF}


      //    {$IF DEFINED(IOS) AND NOT DEFINED(CPUX86)}
      {$IFDEF IOS}
      {$IFNDEF CPUX86}
      //模拟器的任务栏高度是固定的20,而且计算不出来
      //IOS系统的任务栏高度
      SystemStatusBarHeight := Ceil(Min(SharedApplication.statusBarFrame.size.width,
                                      SharedApplication.statusBarFrame.size.height));
      {$ENDIF}
      {$ENDIF}




      //控件增加高度
      FSkinControl.Height:=FSkinControl.Height+SystemStatusBarHeight;
      if FSkinControl is TControl then
      begin
        TControl(FSkinControl).Padding.Top:=TControl(FSkinControl).Padding.Top+SystemStatusBarHeight;
      end;
      //控件里面的所有子控件的Top也加一下
      for I := 0 to FSkinControl.ControlsCount-1 do
      begin
        if FSkinControl.Controls[I] is TControl then
        begin
          if TControl(FSkinControl.Controls[I]).Align=TAlignLayout.None then
          begin
            TControl(FSkinControl.Controls[I]).Position.Y:=
                    TControl(FSkinControl.Controls[I]).Position.Y
                    +SystemStatusBarHeight;
          end;
        end;
      end;


  end;
  {$ENDIF}

end;



//获取bound id
function GetIOSBundleKey(AKey:String): string;
{$IFDEF IOS}
var
  AppNameKey: Pointer;
  AppBundle: NSBundle;
  NSAppName: NSString;
{$ENDIF}
begin
{$IFDEF IOS}
  AppNameKey := (StrToNSStr(AKey) as ILocalObject).GetObjectID;
  AppBundle := TNSBundle.Wrap(TNSBundle.OCClass.mainBundle);
  NSAppName := TNSString.Wrap(AppBundle.infoDictionary.objectForKey(AppNameKey));
  Result := UTF8ToString(NSAppName.UTF8String);
{$ENDIF}
end;





initialization
  GlobalNullPaintData.OtherData:=nil;



  {$IFDEF FMX}
    IsSimulateVirtualKeyboardOnWindows:=False;
    SimulateWindowsVirtualKeyboardHeight:=150;


    {$IFDEF NEED_GET_LATEST_VERSION}
    GlobalGetLatestVersionThread:=nil;
    {$ENDIF}

    {$IFDEF FREE_VERSION}
    {$IFDEF MSWINDOWS}
      {$IFDEF NEED_GET_LATEST_VERSION}
      if DirectoryExists('E:\MyFiles')
        and (not DirectoryExists('E:\MyFiles\OrangeUIControl'))
        then
      begin
        //在Windows下,只有我的电脑才启动版本更新线程
        if GlobalGetLatestVersionThread=nil then
        begin
          GlobalGetLatestVersionThread:=TGetLatestVersionThread.Create(False);
          GlobalGetLatestVersionThread.FreeOnTerminate:=True;
        end;
      end;
      {$ENDIF}
    {$ENDIF}
    {$ENDIF}


  {$ENDIF}



  //如果是IPhoneX,那么底部要拖起来
  GlobalIPhoneXBottomBarHeight:=20;



finalization

  {$IFDEF FMX}
    {$IFDEF FREE_VERSION}
    {$IFDEF NEED_GET_LATEST_VERSION}
    //释放新版本检测线程
    if GlobalGetLatestVersionThread<>nil then
    begin
      GlobalGetLatestVersionThread.Terminate;
    end;
    {$ENDIF}
    {$ENDIF}

  {$ENDIF}




  FreeAndNil(GlobalFrameworkComponentTypeClasses);


end.


