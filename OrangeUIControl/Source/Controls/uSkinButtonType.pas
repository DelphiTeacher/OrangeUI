//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     按钮以及按钮分组
///   </para>
///   <para>
///     Button and buttongroup
///   </para>
/// </summary>
unit uSkinButtonType;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,


  {$IFDEF VCL}
  Messages,
  Windows,
  Controls,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  {$ENDIF}
  uBaseSkinControl,
  Types,


//  {$IFDEF SKIN_SUPEROBJECT}
  uSkinSuperObject,
//  {$ELSE}
//  XSuperObject,
//  XSuperJson,
//  {$ENDIF}


  uLang,
  uSkinItems,
  uFuncCommon,
  uBaseLog,
  uBaseList,
  uDrawParam,
  uBasePageStructure,

  uGraphicCommon,
  uSkinListLayouts,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uSkinPicture,
  uComponentType,
  uDrawEngine,
  uDrawPicture,
  uSkinImageList,
  uDrawTextParam,
  uDrawRectParam,
  uSkinRegManager,
  uDrawPictureParam;






const
  IID_ISkinButton:TGUID='{632F7B49-7141-4FF6-B3E5-F4E7054C1BFC}';
const
  IID_ISkinButtonGroup:TGUID='{632F7B49-7141-4FF6-B3E5-F4E7054C1BFE}';



type
  TSkinBaseButtonGroup=TParentControl;


  TSkinButtonDefaultMaterial=class;


  TBaseButtonProperties=class;
  TButtonProperties=class;
  TButtonGroupProperties=class;



  //按钮的排列方式
  TButtonOrientation = (
                        boHorz,       //水平
                        boVert        //垂直
                        );

  //按钮尺寸的计算方式
  TButtonSizeCalcType=(
                        bsctFixed,    //固定
                        bsctSeparate  //单独
                        );







  /// <summary>
  ///   <para>
  ///     控钮接口
  ///   </para>
  ///   <para>
  ///     Button interface
  ///   </para>
  /// </summary>
  ISkinButton=Interface//(ISkinControl)
  ['{632F7B49-7141-4FF6-B3E5-F4E7054C1BFC}']
    /// <summary>
    ///   按钮的明细
    /// </summary>
    function GetDetail:String;
    property Detail:String read GetDetail;


    /// <summary>
    ///   <para>
    ///     按钮的明细1
    ///   </para>
    ///   <para>
    ///     Button Detail1
    ///   </para>
    /// </summary>
    function GetDetail1:String;
    property Detail1:String read GetDetail1;



    /// <summary>
    ///   <para>
    ///     按钮属性
    ///   </para>
    ///   <para>
    ///     Button Property
    ///   </para>
    /// </summary>
    function GetButtonProperties:TButtonProperties;
    property Properties:TButtonProperties read GetButtonProperties;
    property Prop:TButtonProperties read GetButtonProperties;
  end;






  /// <summary>
  ///   <para>
  ///     按钮分组接口
  ///   </para>
  ///   <para>
  ///     Interface of buttongroup
  ///   </para>
  /// </summary>
  ISkinButtonGroup=Interface//(ISkinControl)
  ['{632F7B49-7141-4FF6-B3E5-F4E7054C1BFE}']
    //修复子按钮的个数
    procedure FixChildButtonCount(const AButtonCount:Integer;
                                  const APushedButtonIndex:Integer;
                                  const AButtonClickEvent:TNotifyEvent);
    //释放所有子按钮
//    procedure FreeChildButtons;

    //按钮分组属性
    function GetButtonGroupProperties:TButtonGroupProperties;
    property Properties:TButtonGroupProperties read GetButtonGroupProperties;
    property Prop:TButtonGroupProperties read GetButtonGroupProperties;
  end;










  /// <summary>
  ///   <para>
  ///     按钮属性
  ///   </para>
  ///   <para>
  ///     Button Property
  ///   </para>
  /// </summary>
  TBaseButtonProperties=class(TSkinControlProperties)
  protected

    //提示文本
    FHelpText:String;

    //是否按下
    FIsPushed:Boolean;
    //是否自动按钮
    FIsAutoPush: Boolean;
    //按下的分组
    FPushedGroupIndex: Integer;


    //按钮图标
    FIcon:TDrawPicture;
    //按下按钮图标
    FPushedIcon:TDrawPicture;



    //按钮下标
    FButtonIndex:Integer;
    //所属按钮分组
    FButtonGroup:TSkinBaseButtonGroup;


    //按钮的接口
    FSkinButtonIntf:ISkinButton;


    //按钮分组的接口
    FSkinButtonGroupIntf:ISkinButtonGroup;


    procedure SetIcon(const Value: TDrawPicture);
    procedure SetPushedIcon(const Value: TDrawPicture);

    procedure SetIsPushed(const Value: Boolean);

    procedure SetButtonGroup(Value:TSkinBaseButtonGroup);

    function GetButtonIndex: Integer;
    procedure SetButtonIndex(const Value: Integer);
    procedure SetHelpText(const Value: String);
  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;

    procedure GetPropJson(ASuperObject:ISuperObject);override;
    procedure SetPropJson(ASuperObject:ISuperObject);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  public

    /// <summary>
    ///   <para>
    ///     所属的ButtonGroup接口
    ///   </para>
    ///   <para>
    ///     Interface of belonged ButtonGroup
    ///   </para>
    /// </summary>
    property SkinButtonGroupIntf:ISkinButtonGroup read FSkinButtonGroupIntf;

    /// <summary>
    ///   <para>
    ///     静态地设置是否按下
    ///   </para>
    ///   <para>
    ///     Set whetehr pushed statically
    ///   </para>
    /// </summary>
    property StaticIsPushed:Boolean read FIsPushed write FIsPushed;


    /// <summary>
    ///   <para>
    ///     按钮图标
    ///   </para>
    ///   <para>
    ///     Button icon
    ///   </para>
    /// </summary>
    property Icon:TDrawPicture read FIcon write SetIcon;

    /// <summary>
    ///   <para>
    ///     按下状态的按钮图标
    ///   </para>
    ///   <para>
    ///     Button icon of pressed state
    ///   </para>
    /// </summary>
    property PushedIcon:TDrawPicture read FPushedIcon write SetPushedIcon;
    /// <summary>
    ///   <para>
    ///     所属的按钮分组控件
    ///   </para>
    ///   <para>
    ///     ButtonGroup control
    ///   </para>
    /// </summary>
    property ButtonGroup:TSkinBaseButtonGroup read FButtonGroup write SetButtonGroup;

    /// <summary>
    ///   <para>
    ///     在按钮分组中的顺序下标
    ///   </para>
    ///   <para>
    ///     Sequence index in button group
    ///   </para>
    /// </summary>
    property ButtonIndex:Integer read GetButtonIndex write SetButtonIndex;
    /// <summary>
    ///   <para>
    ///     按钮分组的标识
    ///   </para>
    ///   <para>
    ///     Index of ButtonGroup
    ///   </para>
    /// </summary>
    property PushedGroupIndex:Integer read FPushedGroupIndex write FPushedGroupIndex;
    /// <summary>
    ///   <para>
    ///     提示文本
    ///   </para>
    ///   <para>
    ///     HelpText
    ///   </para>
    /// </summary>
    property HelpText:String read FHelpText write SetHelpText;
  published

    /// <summary>
    ///   <para>
    ///     自动设置尺寸
    ///   </para>
    ///   <para>
    ///     Set size automatically
    ///   </para>
    /// </summary>
    property AutoSize;



    /// <summary>
    ///   <para>
    ///     鼠标点击的时候是否自动设置按下属性
    ///   </para>
    ///   <para>
    ///     Whether set pushed property automatically when mouse clicking
    ///   </para>
    /// </summary>
    property IsAutoPush:Boolean read FIsAutoPush write FIsAutoPush;

    /// <summary>
    ///   <para>
    ///     是否按下
    ///   </para>
    ///   <para>
    ///     Whether pressed
    ///   </para>
    /// </summary>
    property IsPushed:Boolean read FIsPushed write SetIsPushed;



  end;



  TButtonProperties=class(TBaseButtonProperties)
  published
    property Icon;
    property PushedIcon;
    property ButtonGroup;
    property ButtonIndex;
    property PushedGroupIndex;
    property HelpText;
  end;








  //按钮列表
  TSkinButtonList=class(TBaseList,ISkinList)
  protected
    FListLayoutsManager:TSkinListLayoutsManager;
  public
    //更新个数
    function GetUpdateCount:Integer;
    //获取某一项
    function GetSkinItem(const Index:Integer):ISkinItem;
    function GetSkinObject(const Index:Integer):TObject;
    function GetObject:TObject;
    function GetListLayoutsManager:TSkinListLayoutsManager;
    //设置排列布局管理者
    procedure SetListLayoutsManager(ALayoutsManager:TSkinListLayoutsManager);

    //调用DoItemVisibleChange
    procedure DoChange;override;
    //调用DoItemVisibleChange
    procedure EndUpdate(AIsForce:Boolean=False);override;
  end;




  /// <summary>
  ///   <para>
  ///     按钮分组属性
  ///   </para>
  ///   <para>
  ///     ButtonGroup Properties
  ///   </para>
  /// </summary>
  TButtonGroupProperties=class(TSkinControlProperties)
  protected

    //按钮接口
    FSkinButtonGroupIntf:ISkinButtonGroup;

    //获取分页的绘制矩形
    function GetButtonRect(Index:Integer):TRectF;

    function GetButtonSize: Double;
    function GetButtonSizeCalcType: TButtonSizeCalcType;
    function GetOrientation: TButtonOrientation;

    procedure SetButtonSize(const Value: Double);
    procedure SetOrientation(const Value: TButtonOrientation);
    procedure SetButtonSizeCalcType(const Value: TButtonSizeCalcType);

    function GetButtonCount:Integer;
    function GetButton(Index: Integer):TComponent;
    function GetButtonButtonIntf(Index: Integer):ISkinButton;

    procedure InsertButton(Button: TComponent);
    procedure RemoveButton(Button: TComponent);

  protected
    //按钮列表
    FButtonList:TSkinButtonList;

    //按钮布局管理者
    FListLayoutsManager:TSkinListLayoutsManager;

    function DoGetListLayoutsManagerControlHeight(Sender:TObject):Double;
    function DoGetListLayoutsManagerControlWidth(Sender:TObject):Double;

    //IsCheckNeed,检查是否需要,如果不需要,那么就不调用相关的事件
    //列表项属性更改事件,只需要重绘
    procedure DoGetListLayoutsManagerItemPropChange(Sender:TObject);
    //列表项尺寸更改事件,需要重新计算列表的内容尺寸,绘制矩形
    procedure DoGetListLayoutsManagerItemSizeChange(Sender:TObject);
    //列表项可见属性更改事件,需要重新计算可见列表
    procedure DoGetListLayoutsManagerItemVisibleChange(Sender:TObject);

  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //按钮列表
    property ButtonList:TSkinButtonList read FButtonList;


    //按钮布局管理者
    property LayoutsManager:TSkinListLayoutsManager read FListLayoutsManager;

    /// <summary>
    ///   <para>
    ///     按钮列表排序
    ///   </para>
    ///   <para>
    ///     Sort Buttons
    ///   </para>
    /// </summary>
    procedure SortButtons;
  public
    property Buttons[Index:Integer]:TComponent read GetButton;

    /// <summary>
    ///   <para>
    ///     按钮个数
    ///   </para>
    ///   <para>
    ///     Button count
    ///   </para>
    /// </summary>
    property ButtonCount:Integer read GetButtonCount;
  published

    /// <summary>
    ///   <para>
    ///     自动设置尺寸
    ///   </para>
    ///   <para>
    ///     Set size automatically
    ///   </para>
    /// </summary>
    property AutoSize;

    /// <summary>
    ///   <para>
    ///     按钮大小
    ///   </para>
    ///   <para>
    ///     Button size
    ///   </para>
    /// </summary>
    property ButtonSize:Double read GetButtonSize write SetButtonSize;

    /// <summary>
    ///   <para>
    ///     按钮大小计算类型
    ///   </para>
    ///   <para>
    ///     Button size calculate type
    ///   </para>
    /// </summary>
    property ButtonSizeCalcType:TButtonSizeCalcType read GetButtonSizeCalcType write SetButtonSizeCalcType;

    /// <summary>
    ///   <para>
    ///     按钮的排列方向
    ///   </para>
    ///   <para>
    ///     Orientation of buttons
    ///   </para>
    /// </summary>
    property Orientation:TButtonOrientation read GetOrientation write SetOrientation;

  end;














  //按钮素材类类型
  TSkinButtonMaterialClass=class of TSkinButtonMaterial;
  /// <summary>
  ///   <para>
  ///     按钮素材基类
  ///   </para>
  ///   <para>
  ///     Button material base class
  ///   </para>
  /// </summary>
  TSkinButtonMaterial=class(TSkinControlMaterial)
  private
    FIsAutoCenterIconAndCaption: Boolean;
    procedure SetIsAutoCenterIconAndCaption(const Value: Boolean);
  protected
    //按钮标题绘制参数
    FDrawCaptionParam:TDrawTextParam;
    //明细绘制参数
    FDrawDetailParam:TDrawTextParam;
    //明细1绘制参数
    FDrawDetail1Param:TDrawTextParam;
    //按钮图标绘制参数
    FDrawIconParam:TDrawPictureParam;

    //提示文本绘制字体
    FDrawHelpTextParam:TDrawTextParam;

    procedure SetDrawIconParam(const Value: TDrawPictureParam);
    procedure SetDrawCaptionParam(const Value: TDrawTextParam);
    procedure SetDrawDetailParam(const Value: TDrawTextParam);
    procedure SetDrawDetail1Param(const Value: TDrawTextParam);
    procedure SetDrawHelpTextParam(const Value: TDrawTextParam);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    function HasMouseDownEffect:Boolean;override;
    function HasMouseOverEffect:Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;

  public
    /// <summary>
    ///   <para>
    ///     按钮图标绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of button icon
    ///   </para>
    /// </summary>
    property DrawIconParam:TDrawPictureParam read FDrawIconParam write SetDrawIconParam;
    /// <summary>
    ///   <para>
    ///     按钮标题绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of button caption
    ///   </para>
    /// </summary>
    property DrawCaptionParam:TDrawTextParam read FDrawCaptionParam write SetDrawCaptionParam;
  published
    //自动处理图标和标题
    //居中
    property IsAutoCenterIconAndCaption:Boolean read FIsAutoCenterIconAndCaption write SetIsAutoCenterIconAndCaption;


    /// <summary>
    ///   <para>
    ///     明细绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of Detail
    ///   </para>
    /// </summary>
    property DrawDetailParam:TDrawTextParam read FDrawDetailParam write SetDrawDetailParam;

    /// <summary>
    ///   <para>
    ///     明细1绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of Detail1
    ///   </para>
    /// </summary>
    property DrawDetail1Param:TDrawTextParam read FDrawDetail1Param write SetDrawDetail1Param;
    /// <summary>
    ///   <para>
    ///     提示文本的绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameter of HelpText
    ///   </para>
    /// </summary>
    property DrawHelpTextParam:TDrawTextParam read FDrawHelpTextParam write SetDrawHelpTextParam;
  end;


  TSkinButtonType=class(TSkinControlType)
  protected
    FSkinButtonIntf:ISkinButton;
  protected
    function GetSkinMaterial:TSkinButtonMaterial;
    function GetButtonGroupSkinMaterial:TSkinButtonMaterial;
    //获取当前的状态
    function GetCurrentEffectStates: TDPEffectStates;override;
  protected
    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure TextChanged;override;
    //处理绘制参数的状态
    function GetPaintCurrentUseMaterial:TSkinControlMaterial;override;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    function GetCurrentIcon:TDrawPicture;
    //绘制图标
    function DrawIcon(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF):Boolean;
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //计算
    function CalcAutoSize(var AWidth,AHeight:TControlSize):Boolean;override;
  public
    function CalcCurrentEffectStates:TDPEffectStates;override;
  end;















  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     按钮默认素材类
  ///   </para>
  ///   <para>
  ///     Button default material class
  ///   </para>
  /// </summary>
  TSkinButtonDefaultMaterial=class(TSkinButtonMaterial)
  private
    //正常状态图片
    FNormalPicture: TDrawPicture;
    //鼠标停靠状态图片
    FHoverPicture: TDrawPicture;
    //鼠标按下状态图片
    FDownPicture: TDrawPicture;
    //禁用状态图片
    FDisabledPicture: TDrawPicture;
    //得到焦点状态图片
    FFocusedPicture: TDrawPicture;
    //按下状态图片
    FPushedPicture: TDrawPicture;

    //图片绘制参数
    FDrawPictureParam:TDrawPictureParam;

    procedure SetPushedPicture(const Value: TDrawPicture);
    procedure SetHoverPicture(const Value: TDrawPicture);
    procedure SetNormalPicture(const Value: TDrawPicture);
    procedure SetDisabledPicture(const Value: TDrawPicture);
    procedure SetDownPicture(const Value: TDrawPicture);
    procedure SetFocusedPicture(const Value: TDrawPicture);
    procedure SetDrawPictureParam(const Value: TDrawPictureParam);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    property DrawIconParam;
    property DrawCaptionParam;

    /// <summary>
    ///   <para>
    ///     正常状态的图片
    ///   </para>
    ///   <para>
    ///     Normal state picture
    ///   </para>
    /// </summary>
    property NormalPicture:TDrawPicture read FNormalPicture write SetNormalPicture;

    /// <summary>
    ///   <para>
    ///     鼠标停靠状态的图片
    ///   </para>
    ///   <para>
    ///     Picture at mouse hovering state
    ///   </para>
    /// </summary>
    property HoverPicture:TDrawPicture read FHoverPicture write SetHoverPicture;

    /// <summary>
    ///   <para>
    ///     鼠标按下状态的图片
    ///   </para>
    ///   <para>
    ///     Picture at mouse pressed state
    ///   </para>
    /// </summary>
    property DownPicture: TDrawPicture read FDownPicture write SetDownPicture;

    /// <summary>
    ///   <para>
    ///     禁用状态的图片
    ///   </para>
    ///   <para>
    ///     Disabled picture
    ///   </para>
    /// </summary>
    property DisabledPicture: TDrawPicture read FDisabledPicture write SetDisabledPicture;

    /// <summary>
    ///   <para>
    ///     得到焦点状态的图片
    ///   </para>
    ///   <para>
    ///     Get foused state picture
    ///   </para>
    /// </summary>
    property FocusedPicture: TDrawPicture read FFocusedPicture write SetFocusedPicture;

    /// <summary>
    ///   <para>
    ///     按下状态的图片
    ///   </para>
    ///   <para>
    ///     Pressed state picture
    ///   </para>
    /// </summary>
    property PushedPicture:TDrawPicture read FPushedPicture write SetPushedPicture;

    /// <summary>
    ///   <para>
    ///     图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of picture
    ///   </para>
    /// </summary>
    property DrawPictureParam:TDrawPictureParam read FDrawPictureParam write SetDrawPictureParam;
  end;

  TSkinButtonDefaultType=class(TSkinButtonType)
  private
    function GetSkinMaterial:TSkinButtonDefaultMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //计算
//    function CalcAutoSize(var AWidth,AHeight:TControlSize):Boolean;override;
  end;




















  /// <summary>
  ///   <para>
  ///     按钮分组素材基类
  ///   </para>
  ///   <para>
  ///     Base class of button group material
  ///   </para>
  /// </summary>
  TSkinButtonGroupMaterial=class(TSkinControlMaterial)
  protected
    FIsUseFirstButtonMaterial: Boolean;
    FIsUseLastButtonMaterial: Boolean;

    FFirstButtonMaterial: TSkinButtonMaterial;
    FLastButtonMaterial: TSkinButtonMaterial;
    FMiddleButtonMaterial: TSkinButtonMaterial;

    function GetFirstButtonMaterial: TSkinButtonMaterial;
    function GetLastButtonMaterial: TSkinButtonMaterial;
    function GetMiddleButtonMaterial: TSkinButtonMaterial;

    procedure SetFirstButtonMaterial(const Value: TSkinButtonMaterial);
    procedure SetLastButtonMaterial(const Value: TSkinButtonMaterial);
    procedure SetMiddleButtonMaterial(const Value: TSkinButtonMaterial);

    procedure SetIsUseFirstButtonMaterial(const Value: Boolean);
    procedure SetIsUseLastButtonMaterial(const Value: Boolean);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  protected
    //获取按钮素材类
    function GetButtonMaterialClass:TSkinButtonMaterialClass;virtual;
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published

    /// <summary>
    ///   <para>
    ///     是否使用第一个按钮素材
    ///   </para>
    ///   <para>
    ///     Whether use the first button material
    ///   </para>
    /// </summary>
    property IsUseFirstButtonMaterial:Boolean read FIsUseFirstButtonMaterial write SetIsUseFirstButtonMaterial ;//default False;

    /// <summary>
    ///   <para>
    ///     是否使用最后一个按钮素材
    ///   </para>
    ///   <para>
    ///     Whether use last button material
    ///   </para>
    /// </summary>
    property IsUseLastButtonMaterial:Boolean read FIsUseLastButtonMaterial write SetIsUseLastButtonMaterial ;//default False;


    /// <summary>
    ///   <para>
    ///     第一个按钮的素材
    ///   </para>
    ///   <para>
    ///     First button's material
    ///   </para>
    /// </summary>
    property FirstButtonMaterial:TSkinButtonMaterial read GetFirstButtonMaterial write SetFirstButtonMaterial;

    /// <summary>
    ///   <para>
    ///     最后一个按钮的素材
    ///   </para>
    ///   <para>
    ///     Last button's material
    ///   </para>
    /// </summary>
    property LastButtonMaterial:TSkinButtonMaterial read GetLastButtonMaterial write SetLastButtonMaterial;

    /// <summary>
    ///   <para>
    ///     中间按钮的素材
    ///   </para>
    ///   <para>
    ///     Middle button's material
    ///   </para>
    /// </summary>
    property MiddleButtonMaterial:TSkinButtonMaterial read GetMiddleButtonMaterial write SetMiddleButtonMaterial;
  end;


  TSkinButtonGroupType=class(TSkinControlType)
  protected
    FSkinButtonGroupIntf:ISkinButtonGroup;
  protected
    function GetSkinMaterial:TSkinButtonGroupMaterial;
  protected
    procedure SizeChanged;override;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    //计算
    function CalcAutoSize(var AWidth,AHeight:TControlSize):Boolean;override;
  end;













  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     按钮分组默认素材类
  ///   </para>
  ///   <para>
  ///     Button group default material class
  ///   </para>
  /// </summary>
  TSkinButtonGroupDefaultMaterial=class(TSkinButtonGroupMaterial)
  protected
    //获取按钮素材类
    function GetButtonMaterialClass:TSkinButtonMaterialClass;override;
  end;

  TSkinButtonGroupDefaultType=class(TSkinButtonGroupType)
  private
    function GetSkinMaterial:TSkinButtonGroupDefaultMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;









  {$REGION 'SkinButton'}
//  {$IFDEF FMX}
//  //皮肤按钮
//  {$I Source\Controls\ComponentPlatformsAttribute.inc}
////  TSkinButton=class(TBaseNewSkinControl,
//  TSkinButton=class(TBaseSkinControl,
//                    ISkinButton,
//                    IBindSkinItemTextControl,
//                    ISkinItem)
//  private
//    FDetail:String;
//    FDetail1:String;
//    function GetDetail:String;
//    function GetDetail1:String;
//    procedure SetDetail(const Value:String);
//    procedure SetDetail1(const Value:String);
//
//    function GetButtonProperties:TButtonProperties;
//    procedure SetButtonProperties(Value:TButtonProperties);
//
//    function GetIcon: TDrawPicture;
//    function GetIsAutoPush: Boolean;
//    function GetIsPushed: Boolean;
//    function GetPushedGroupIndex: Integer;
//    function GetPushedIcon: TDrawPicture;
//
//    procedure SetIcon(const Value: TDrawPicture);
//    procedure SetIsPushed(const Value: Boolean);
//    procedure SetPushedGroupIndex(const Value: Integer);
//    procedure SetPushedIcon(const Value: TDrawPicture);
//    procedure SetIsAutoPush(const Value: Boolean);
//
//    function GetDrawCaptionParam: TDrawTextParam;
//    function GetDrawDetail1Param: TDrawTextParam;
//    function GetDrawDetailParam: TDrawTextParam;
//    function GetDisabledPicture: TDrawPicture;
//    function GetDownPicture: TDrawPicture;
//    function GetFocusedPicture: TDrawPicture;
//    function GetHoverPicture: TDrawPicture;
//    function GetDrawIconParam: TDrawPictureParam;
//    function GetNormalPicture: TDrawPicture;
//    function GetDrawPictureParam: TDrawPictureParam;
//    function GetPushedPicture: TDrawPicture;
//
//    procedure SetDrawCaptionParam(const Value: TDrawTextParam);
//    procedure SetDrawDetail1Param(const Value: TDrawTextParam);
//    procedure SetDrawDetailParam(const Value: TDrawTextParam);
//    procedure SetDisabledPicture(const Value: TDrawPicture);
//    procedure SetDownPicture(const Value: TDrawPicture);
//    procedure SetFocusedPicture(const Value: TDrawPicture);
//    procedure SetHoverPicture(const Value: TDrawPicture);
//    procedure SetDrawIconParam(const Value: TDrawPictureParam);
//    procedure SetNormalPicture(const Value: TDrawPicture);
//    procedure SetDrawPictureParam(const Value: TDrawPictureParam);
//    procedure SetPushedPicture(const Value: TDrawPicture);
//  protected
//
////    //获取控件素材类
////    function GetMaterialClass:TMaterialClass;override;
////    //获取控件行为类
////    function GetControlTypeClass:TControlTypeClass;override;
//
//    //获取控件属性类
//    function GetPropertiesClassType:TPropertiesClassType;override;
//
//    //皮肤素材更改通知事件
//    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
//  protected
//    procedure ReadState(Reader: TReader); override;
//  protected
//    //ISkinItem的实现,用于自动排列
//    FItemRect:TRectF;
//    FItemDrawRect:TRectF;
//
//    FSkinListIntf:ISkinList;
//    function GetSelected:Boolean;
//    function GetObject:TObject;
//    function GetItemRect:TRectF;
//    procedure SetItemRect(Value:TRectF);
//    function GetItemDrawRect:TRectF;
//    procedure SetItemDrawRect(Value:TRectF);
//
//
//    procedure SetSkinListIntf(ASkinListIntf:ISkinList);
//    function GetListLayoutsManager:TSkinListLayoutsManager;
//
//    procedure ClearItemRect;
//
//  protected
//    //绑定列表项的文本属性
//    procedure BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
//  public
//    //在点击事件中设置是否勾选属性
//    procedure Click;override;
//  public
//    //素材
//    function Material:TSkinButtonDefaultMaterial;
//  public
//    //属性
//    property Prop:TButtonProperties read GetButtonProperties write SetButtonProperties;
//  published
//
//    /// <summary>
//    ///   <para>
//    ///     鼠标点击的时候是否自动设置按下属性
//    ///   </para>
//    ///   <para>
//    ///     Whether set pushed property automatically when mouse clicking
//    ///   </para>
//    /// </summary>
//    property IsAutoPush:Boolean read GetIsAutoPush write SetIsAutoPush;
//
//    /// <summary>
//    ///   <para>
//    ///     是否按下
//    ///   </para>
//    ///   <para>
//    ///     Whether pressed
//    ///   </para>
//    /// </summary>
//    property IsPushed:Boolean read GetIsPushed write SetIsPushed;
//
//    /// <summary>
//    ///   <para>
//    ///     按钮分组的下标
//    ///   </para>
//    ///   <para>
//    ///     Index of ButtonGroup
//    ///   </para>
//    /// </summary>
//    property PushedGroupIndex:Integer read GetPushedGroupIndex write SetPushedGroupIndex;
//
//    /// <summary>
//    ///   <para>
//    ///     按钮图标
//    ///   </para>
//    ///   <para>
//    ///     Button icon
//    ///   </para>
//    /// </summary>
//    property Icon:TDrawPicture read GetIcon write SetIcon;
//
//    /// <summary>
//    ///   <para>
//    ///     按下状态的按钮图标
//    ///   </para>
//    ///   <para>
//    ///     Button icon of pressed state
//    ///   </para>
//    /// </summary>
//    property PushedIcon:TDrawPicture read GetPushedIcon write SetPushedIcon;
//
//  published
//
//    /// <summary>
//    ///   <para>
//    ///     正常状态的图片
//    ///   </para>
//    ///   <para>
//    ///     Normal state picture
//    ///   </para>
//    /// </summary>
//    property NormalPicture:TDrawPicture read GetNormalPicture write SetNormalPicture;
//
//    /// <summary>
//    ///   <para>
//    ///     鼠标停靠状态的图片
//    ///   </para>
//    ///   <para>
//    ///     Picture at mouse hovering state
//    ///   </para>
//    /// </summary>
//    property HoverPicture:TDrawPicture read GetHoverPicture write SetHoverPicture;
//
//    /// <summary>
//    ///   <para>
//    ///     鼠标按下状态的图片
//    ///   </para>
//    ///   <para>
//    ///     Picture at mouse pressed state
//    ///   </para>
//    /// </summary>
//    property DownPicture: TDrawPicture read GetDownPicture write SetDownPicture;
//
//    /// <summary>
//    ///   <para>
//    ///     禁用状态的图片
//    ///   </para>
//    ///   <para>
//    ///     Disabled picture
//    ///   </para>
//    /// </summary>
//    property DisabledPicture: TDrawPicture read GetDisabledPicture write SetDisabledPicture;
//
//    /// <summary>
//    ///   <para>
//    ///     得到焦点状态的图片
//    ///   </para>
//    ///   <para>
//    ///     Get foused state picture
//    ///   </para>
//    /// </summary>
//    property FocusedPicture: TDrawPicture read GetFocusedPicture write SetFocusedPicture;
//
//    /// <summary>
//    ///   <para>
//    ///     按下状态的图片
//    ///   </para>
//    ///   <para>
//    ///     Pressed state picture
//    ///   </para>
//    /// </summary>
//    property PushedPicture:TDrawPicture read GetPushedPicture write SetPushedPicture;
//
//  published
//
//    /// <summary>
//    ///   <para>
//    ///     按钮标题绘制参数
//    ///   </para>
//    ///   <para>
//    ///     Draw parameters of button caption
//    ///   </para>
//    /// </summary>
//    property DrawCaptionParam:TDrawTextParam read GetDrawCaptionParam write SetDrawCaptionParam;
//
//    /// <summary>
//    ///   <para>
//    ///     明细绘制参数
//    ///   </para>
//    ///   <para>
//    ///     Draw parameters of Detail
//    ///   </para>
//    /// </summary>
//    property DrawDetailParam:TDrawTextParam read GetDrawDetailParam write SetDrawDetailParam;
//
//    /// <summary>
//    ///   <para>
//    ///     明细1绘制参数
//    ///   </para>
//    ///   <para>
//    ///     Draw parameters of Detail1
//    ///   </para>
//    /// </summary>
//    property DrawDetail1Param:TDrawTextParam read GetDrawDetail1Param write SetDrawDetail1Param;
//
//    /// <summary>
//    ///   <para>
//    ///     按钮图标绘制参数
//    ///   </para>
//    ///   <para>
//    ///     Draw parameters of button icon
//    ///   </para>
//    /// </summary>
//    property DrawIconParam:TDrawPictureParam read GetDrawIconParam write SetDrawIconParam;
//
//    /// <summary>
//    ///   <para>
//    ///     图片绘制参数
//    ///   </para>
//    ///   <para>
//    ///     Draw parameters of picture
//    ///   </para>
//    /// </summary>
//    property DrawPictureParam:TDrawPictureParam read GetDrawPictureParam write SetDrawPictureParam;
//
//
//
//  published
//    //动态
//    property Action;
//    //标题
//    property Caption;
//
//    property Detail:String read FDetail write SetDetail;
//    property Detail1:String read FDetail1 write SetDetail1;
//
//    property Text;
//    //点击事件
//    property OnClick;
//    //双击事件
//    property OnDblClick;
//
//  end;
//
//
//
//
//
//  {$I Source\Controls\ComponentPlatformsAttribute.inc}
////  TSkinButtonGroup=class(TBaseNewSkinControl,
//  TSkinButtonGroup=class(TBaseSkinControl,
//                          ISkinButtonGroup)
//  private
//    function GetButtonGroupProperties:TButtonGroupProperties;
//    procedure SetButtonGroupProperties(Value:TButtonGroupProperties);
//
//    function GetMiddleButtonMaterial: TSkinButtonDefaultMaterial;
//    procedure SetMiddleButtonMaterial(const Value: TSkinButtonDefaultMaterial);
//
//    function GetAutoSize: Boolean;
//    procedure SetAutoSize(const Value: Boolean);
//    function GetLayoutType:TItemLayoutType;
//    function GetButtonSize: TControlSize;
//    procedure SetButtonSize(const Value: TControlSize);
//    procedure SetLayoutType(const Value: TItemLayoutType);
//
//    function GetButtonDisabledPicture: TDrawPicture;
//    function GetButtonDownPicture: TDrawPicture;
//    function GetButtonFocusedPicture: TDrawPicture;
//    function GetButtonHoverPicture: TDrawPicture;
//    function GetButtonNormalPicture: TDrawPicture;
//    function GetButtonPushedPicture: TDrawPicture;
//
//    function GetDrawButtonIconParam: TDrawPictureParam;
//    function GetDrawButtonPictureParam: TDrawPictureParam;
//    function GetDrawButtonCaptionParam: TDrawTextParam;
//    function GetDrawButtonDetail1Param: TDrawTextParam;
//    function GetDrawButtonDetailParam: TDrawTextParam;
//
//    procedure SetDrawButtonCaptionParam(const Value: TDrawTextParam);
//    procedure SetDrawButtonDetail1Param(const Value: TDrawTextParam);
//    procedure SetDrawButtonDetailParam(const Value: TDrawTextParam);
//    procedure SetDrawButtonIconParam(const Value: TDrawPictureParam);
//    procedure SetDrawButtonPictureParam(const Value: TDrawPictureParam);
//
//    procedure SetButtonNormalPicture(const Value: TDrawPicture);
//    procedure SetButtonDisabledPicture(const Value: TDrawPicture);
//    procedure SetButtonDownPicture(const Value: TDrawPicture);
//    procedure SetButtonFocusedPicture(const Value: TDrawPicture);
//    procedure SetButtonHoverPicture(const Value: TDrawPicture);
//    procedure SetButtonPushedPicture(const Value: TDrawPicture);
//
//    function GetButtonBackColorParam: TDrawRectParam;
//    procedure SetButtonBackColorParam(const Value: TDrawRectParam);
//  protected
////    //获取控件的素材类
////    function GetMaterialClass:TMaterialClass;override;
////    //获取控件的行为类
////    function GetControlTypeClass:TControlTypeClass;override;
//
//    //获取控件属性类
//    function GetPropertiesClassType:TPropertiesClassType;override;
//  public
//
//    procedure FixChildButtonCount(const AButtonCount:Integer;
//                                  const APushedButtonIndex:Integer;
//                                  const AButtonClickEvent:TNotifyEvent);
//    procedure FreeChildButtons;
//  public
//    //素材
//    function Material:TSkinButtonGroupDefaultMaterial;
//  public
//    //属性
//    property Prop:TButtonGroupProperties read GetButtonGroupProperties write SetButtonGroupProperties;
//  public
//
//    /// <summary>
//    ///   <para>
//    ///     中间按钮的素材
//    ///   </para>
//    ///   <para>
//    ///     Middle button's material
//    ///   </para>
//    /// </summary>
//    property ButtonMaterial:TSkinButtonDefaultMaterial read GetMiddleButtonMaterial write SetMiddleButtonMaterial;
//  public
//    destructor Destroy;override;
//  published
//    /// <summary>
//    ///   <para>
//    ///     自动设置尺寸
//    ///   </para>
//    ///   <para>
//    ///     Set size automatically
//    ///   </para>
//    /// </summary>
//    property AutoSize:Boolean read GetAutoSize write SetAutoSize;
//    /// <summary>
//    ///   <para>
//    ///     按钮大小
//    ///   </para>
//    ///   <para>
//    ///     Button size
//    ///   </para>
//    /// </summary>
//    property ButtonSize:TControlSize read GetButtonSize write SetButtonSize;
//    /// <summary>
//    ///   <para>
//    ///     按钮排列类型
//    ///   </para>
//    ///   <para>
//    ///     Button Layout
//    ///   </para>
//    /// </summary>
//    property LayoutType:TItemLayoutType read GetLayoutType write SetLayoutType;
//
//  published
//
//    //按钮的背景颜色
//    property ButtonBackColorParam:TDrawRectParam read GetButtonBackColorParam write SetButtonBackColorParam;
//
//    /// <summary>
//    ///   <para>
//    ///     正常状态的图片
//    ///   </para>
//    ///   <para>
//    ///     Normal state picture
//    ///   </para>
//    /// </summary>
//    property ButtonNormalPicture:TDrawPicture read GetButtonNormalPicture write SetButtonNormalPicture;
//
//    /// <summary>
//    ///   <para>
//    ///     鼠标停靠状态的图片
//    ///   </para>
//    ///   <para>
//    ///     Picture at mouse hovering state
//    ///   </para>
//    /// </summary>
//    property ButtonHoverPicture:TDrawPicture read GetButtonHoverPicture write SetButtonHoverPicture;
//
//    /// <summary>
//    ///   <para>
//    ///     鼠标按下状态的图片
//    ///   </para>
//    ///   <para>
//    ///     Picture at mouse pressed state
//    ///   </para>
//    /// </summary>
//    property ButtonDownPicture: TDrawPicture read GetButtonDownPicture write SetButtonDownPicture;
//
//    /// <summary>
//    ///   <para>
//    ///     禁用状态的图片
//    ///   </para>
//    ///   <para>
//    ///     Disabled picture
//    ///   </para>
//    /// </summary>
//    property ButtonDisabledPicture: TDrawPicture read GetButtonDisabledPicture write SetButtonDisabledPicture;
//
//    /// <summary>
//    ///   <para>
//    ///     得到焦点状态的图片
//    ///   </para>
//    ///   <para>
//    ///     Get foused state picture
//    ///   </para>
//    /// </summary>
//    property ButtonFocusedPicture: TDrawPicture read GetButtonFocusedPicture write SetButtonFocusedPicture;
//
//    /// <summary>
//    ///   <para>
//    ///     按下状态的图片
//    ///   </para>
//    ///   <para>
//    ///     Pressed state picture
//    ///   </para>
//    /// </summary>
//    property ButtonPushedPicture:TDrawPicture read GetButtonPushedPicture write SetButtonPushedPicture;
//
//  published
//
//    /// <summary>
//    ///   <para>
//    ///     按钮标题绘制参数
//    ///   </para>
//    ///   <para>
//    ///     Draw parameters of button caption
//    ///   </para>
//    /// </summary>
//    property DrawButtonCaptionParam:TDrawTextParam read GetDrawButtonCaptionParam write SetDrawButtonCaptionParam;
//
//    /// <summary>
//    ///   <para>
//    ///     明细绘制参数
//    ///   </para>
//    ///   <para>
//    ///     Draw parameters of Detail
//    ///   </para>
//    /// </summary>
//    property DrawButtonDetailParam:TDrawTextParam read GetDrawButtonDetailParam write SetDrawButtonDetailParam;
//
//    /// <summary>
//    ///   <para>
//    ///     明细1绘制参数
//    ///   </para>
//    ///   <para>
//    ///     Draw parameters of Detail1
//    ///   </para>
//    /// </summary>
//    property DrawButtonDetail1Param:TDrawTextParam read GetDrawButtonDetail1Param write SetDrawButtonDetail1Param;
//
//    /// <summary>
//    ///   <para>
//    ///     按钮图标绘制参数
//    ///   </para>
//    ///   <para>
//    ///     Draw parameters of button icon
//    ///   </para>
//    /// </summary>
//    property DrawButtonIconParam:TDrawPictureParam read GetDrawButtonIconParam write SetDrawButtonIconParam;
//
//    /// <summary>
//    ///   <para>
//    ///     图片绘制参数
//    ///   </para>
//    ///   <para>
//    ///     Draw parameters of picture
//    ///   </para>
//    /// </summary>
//    property DrawButtonPictureParam:TDrawPictureParam read GetDrawButtonPictureParam write SetDrawButtonPictureParam;
//
//  end;
//
//  {$ENDIF}
  {$ENDREGION 'SkinButton'}




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TBaseSkinButton=class(TBaseSkinControl,
                        ISkinButton,
                        IBindSkinItemTextControl,
                        IBindSkinItemValueControl,
                        IBindSkinItemObjectControl,
                        ISkinItem)
  private
    FDetail:String;
    FDetail1:String;
    procedure SetDetail(const Value:String);
    procedure SetDetail1(const Value:String);
    function GetButtonProperties:TButtonProperties;
    procedure SetButtonProperties(Value:TButtonProperties);
  protected
    function GetDetail:String;
    function GetDetail1:String;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
  protected
    procedure ReadState(Reader: TReader); override;
  protected
    FItemRect:TRectF;
    FItemDrawRect:TRectF;

    FSkinListIntf:ISkinList;
    //层级
    function GetLevel:Integer;
    function GetWidth:Double;
    function GetHeight:Double;
    function GetSelected:Boolean;
    function GetObject:TObject;
    function GetItemRect:TRectF;
    procedure SetItemRect(Value:TRectF);
    function GetItemDrawRect:TRectF;
    procedure SetItemDrawRect(Value:TRectF);
    function GetIsRowEnd:Boolean;
    function GetThisRowItemCount:Integer;

    procedure SetSkinListIntf(ASkinListIntf:ISkinList);
    function GetListLayoutsManager:TSkinListLayoutsManager;
    procedure ClearItemRect;

    //鼠标是否在Item里面
    function PtInItem(APoint:TPointF):Boolean;
  protected
    procedure BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
    procedure SetControlObjectByBindItemField(const AFieldName:String;
                                              const AFieldValue:TObject;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  public
    Value:Variant;
    //是不是选择性的按钮
    //选择性的按钮,Caption是值的标题,value存值
    //非选择性的按钮,Caption就是FieldCaption
    IsSelectButton:Boolean;
    Setting:TFieldControlSetting;
    //针对页面框架的控件接口
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;override;
    //获取与设置自定义属性
    function GetPropJsonStr:String;override;
    procedure SetPropJsonStr(AJsonStr:String);override;
    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;override;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            AImageServerUrl:String;
                            AValue:Variant;
                            AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);override;
  public
    //在点击事件中设置是否勾选属性
    procedure Click;override;
  public
    //记录多语言的索引
    procedure RecordControlLangIndex(APrefix:String;ALang:TLang;ACurLang:String);override;
    //翻译
    procedure TranslateControlLang(APrefix:String;ALang:TLang;ACurLang:String);override;
  public
    function SelfOwnMaterialToDefault:TSkinButtonDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinButtonDefaultMaterial;
    function Material:TSkinButtonDefaultMaterial;
  public
    property Prop:TButtonProperties read GetButtonProperties write SetButtonProperties;
  published
    //动态
    property Action;
    //标题
    property Caption;
    property Detail:String read FDetail write SetDetail;
    property Detail1:String read FDetail1 write SetDetail1;
    property Text;
    //点击事件
    property OnClick;
    //双击事件
    property OnDblClick;
    //属性
    property Properties:TButtonProperties read GetButtonProperties write SetButtonProperties;

  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TBaseSkinButtonGroup=class(TBaseSkinControl,
                              ISkinButtonGroup)
  private
    function GetButtonGroupProperties:TButtonGroupProperties;
    procedure SetButtonGroupProperties(Value:TButtonGroupProperties);
  protected
    procedure ReadState(Reader: TReader); override;

    procedure Loaded;override;
  protected
    procedure FixChildButtonCount(const AButtonCount:Integer;
                                  const APushedButtonIndex:Integer;
                                  const AButtonClickEvent:TNotifyEvent);
    procedure FreeChildButtons;

    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    function SelfOwnMaterialToDefault:TSkinButtonGroupDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinButtonGroupDefaultMaterial;
    function Material:TSkinButtonGroupDefaultMaterial;
  public
    destructor Destroy;override;
  public
    property Prop:TButtonGroupProperties read GetButtonGroupProperties write SetButtonGroupProperties;
  published
    property Text;
    //属性
    property Properties:TButtonGroupProperties read GetButtonGroupProperties write SetButtonGroupProperties;
  end;

  {$IFDEF FMX}
  TSkinButton=class(TBaseSkinButton)

  end;
  {$ENDIF FMX}

  TSkinButtonGroup=class(TBaseSkinButtonGroup)

  end;

  {$IFDEF VCL}
  TSkinButton=class(TBaseSkinButton)

  end;
  TSkinWinButton=class(TBaseSkinButton)

  end;
  TSkinWinButtonGroup=class(TSkinButtonGroup)

  end;
  {$ENDIF VCL}




  //选择日期范围的按钮
  TSkinSelectDateAreaButton=class(TBaseSkinButton)
  private
  protected
    FEndDate: String;
    FStartDate: String;
    procedure SyncCaption;
    procedure SetEndDate(const Value: String);
    procedure SetStartDate(const Value: String);
  published
    property StartDate:String read FStartDate write SetStartDate;
    property EndDate:String read FEndDate write SetEndDate;
  end;






  TSkinChildButton=TBaseSkinButton;//{$IFDEF VCL}TSkinWinButton{$ENDIF}{$IFDEF FMX}TSkinFMXButton{$ENDIF};
  TSkinParentButtonGroup=TBaseSkinButtonGroup;//{$IFDEF VCL}TSkinWinButtonGroup{$ENDIF}{$IFDEF FMX}TSkinFMXButtonGroup{$ENDIF};

  function CreateChildButton(AOwner:TComponent):TSkinChildButton;


implementation


function CreateChildButton(AOwner:TComponent):TSkinChildButton;
begin
  Result:=TSkinChildButton.Create(AOwner);
  Result.Caption:='';
end;



{ TSkinButtonType }

function TSkinButtonType.GetPaintCurrentUseMaterial:TSkinControlMaterial;
begin
  Result:=GetSkinMaterial;
end;

procedure TSkinButtonType.TextChanged;
begin
  Inherited;
  Self.FSkinButtonIntf.Prop.AdjustAutoSizeBounds;
  Self.Invalidate;
end;

procedure TSkinButtonType.CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
  inherited;
end;

function TSkinButtonType.CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData): Boolean;
var
  AIconDrawRect:TRectF;
  ACaptionDrawSize:TSizeF;
  ATempDrawRect:TRectF;
  AContentWidth:Double;
  AOldPictureHorzAlign:TPictureHorzAlign;
  AOldFontHorzAlign:TFontHorzAlign;
begin
  if GetSkinMaterial<>nil then
  begin

    if not GetSkinMaterial.FIsAutoCenterIconAndCaption then
    begin
        //绘制图标
        DrawIcon(ACanvas,GetSkinMaterial,ADrawRect);
        //绘制标题
        ACanvas.DrawText(Self.GetSkinMaterial.FDrawCaptionParam,
                            Self.FSkinControlIntf.Caption,
                            ADrawRect);
    end
    else
    begin
        //自动水平居中标题和图标
        AContentWidth:=0;
        AIconDrawRect:=RectF(0,0,0,0);



        if not GetCurrentIcon.CurrentPictureIsEmpty and (Self.FSkinControlIntf.Caption='') then
        begin
            //没有标题
            //居中绘制图标
            //绘制图标
            AOldPictureHorzAlign:=GetSkinMaterial.FDrawIconParam.StaticPictureHorzAlign;
            GetSkinMaterial.FDrawIconParam.StaticPictureHorzAlign:=phaCenter;
            DrawIcon(ACanvas,GetSkinMaterial,ADrawRect);
            GetSkinMaterial.FDrawIconParam.StaticPictureHorzAlign:=AOldPictureHorzAlign;
        end
        else
        if GetCurrentIcon.CurrentPictureIsEmpty and (Self.FSkinControlIntf.Caption<>'') then
        begin
            //没有图标
            //居中绘制标题
            //绘制标题
            AOldFontHorzAlign:=GetSkinMaterial.FDrawCaptionParam.StaticFontHorzAlign;
            GetSkinMaterial.FDrawCaptionParam.StaticFontHorzAlign:=fhaCenter;
            ACanvas.DrawText(Self.GetSkinMaterial.FDrawCaptionParam,
                                Self.FSkinControlIntf.Caption,
                                ADrawRect);
            GetSkinMaterial.FDrawCaptionParam.StaticFontHorzAlign:=AOldFontHorzAlign;
        end
        else
        begin
            //有图标，有标题

//            if not GetCurrentIcon.CurrentPictureIsEmpty then
//            begin
                //图标不为空
                AIconDrawRect:=GetSkinMaterial.FDrawIconParam.CalcDrawRect(ADrawRect);
                CalcImageDrawRect(GetSkinMaterial.FDrawIconParam,
                                  GetCurrentIcon.CurrentPictureWidth,
                                  GetCurrentIcon.CurrentPictureHeight,
                                  AIconDrawRect,
                                  AIconDrawRect
                                  );
                AContentWidth:=AIconDrawRect.Width;

//            end;
            ACaptionDrawSize.cx:=0;
//            if Self.FSkinControlIntf.Caption<>'' then
//            begin
                ACaptionDrawSize:=GetStringSize(Self.FSkinControlIntf.Caption,
                                                ADrawRect,
                                                GetSkinMaterial.FDrawCaptionParam);
                AContentWidth:=AContentWidth+ACaptionDrawSize.cx;
//            end;





            ATempDrawRect:=ADrawRect;
            ATempDrawRect.Left:=ATempDrawRect.Left+(ADrawRect.Width-AContentWidth)/2;





            if GetSkinMaterial.FDrawIconParam.PictureHorzAlign=phaRight then
            begin
                //标题左，图标右

                //绘制标题
                ACanvas.DrawText(Self.GetSkinMaterial.FDrawCaptionParam,
                                    Self.FSkinControlIntf.Caption,
                                    ATempDrawRect);


                ATempDrawRect.Left:=ATempDrawRect.Left+ACaptionDrawSize.cx;
                ATempDrawRect.Width:=AIconDrawRect.Width;

                //绘制图标
                //GetSkinMaterial.FDrawIconParam.StaticPictureHorzAlign:=phaLeft;
                DrawIcon(ACanvas,GetSkinMaterial,ATempDrawRect);
                //GetSkinMaterial.FDrawIconParam.StaticPictureHorzAlign:=phaRight;


            end
            else
            begin

                //绘制图标
                DrawIcon(ACanvas,GetSkinMaterial,ATempDrawRect);


                if AIconDrawRect.Width>0 then
                begin
                  ATempDrawRect.Left:=ATempDrawRect.Left+AIconDrawRect.Width;
                end;
                ATempDrawRect.Right:=ATempDrawRect.Left+ACaptionDrawSize.cx;
                //绘制标题
                ACanvas.DrawText(Self.GetSkinMaterial.FDrawCaptionParam,
                                    Self.FSkinControlIntf.Caption,
                                    ATempDrawRect);

            end;

        end;

    end;




    //绘制明细
    ACanvas.DrawText(Self.GetSkinMaterial.FDrawDetailParam,
                        Self.FSkinButtonIntf.Detail,
                        ADrawRect);
    //绘制明细1
    ACanvas.DrawText(Self.GetSkinMaterial.FDrawDetail1Param,
                        Self.FSkinButtonIntf.Detail1,
                        ADrawRect);

    //绘制提示文本
    if  (Self.FSkinControlIntf.Caption='')
       and (Self.FSkinButtonIntf.Prop.HelpText<>'') then
    begin
      ACanvas.DrawText(Self.GetSkinMaterial.FDrawHelpTextParam,
                        Self.FSkinButtonIntf.Prop.HelpText,
                        ADrawRect);
    end;


  end;

end;

function TSkinButtonType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinButton,Self.FSkinButtonIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinButton Interface');
    end;
  end;
end;

procedure TSkinButtonType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinButtonIntf:=nil;
end;

function TSkinButtonType.DrawIcon(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF): Boolean;
begin
  if Self.GetSkinMaterial<>nil then
  begin
    ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawIconParam,GetCurrentIcon,ADrawRect);
  end;
end;

function TSkinButtonType.CalcAutoSize(var AWidth,AHeight: TControlSize): Boolean;
var
  ASize:TSizeF;
  AIconDrawRect:TRectF;
begin
  Result:=False;

  if GetSkinMaterial<>nil then
  begin
      //根据标题
      ASize:=GetSuitControlStringContentSize(
              Self.FSkinControlIntf.Caption,
              RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height),
              Self.GetSkinMaterial.FDrawCaptionParam
              );
      if not GetSkinMaterial.FIsAutoCenterIconAndCaption then
      begin

          AWidth:=ControlSize(ASize.cx);//+10;
          AHeight:=ControlSize(ASize.cy);
          Result:=True;
      end
      else
      begin
          AIconDrawRect:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);
          AIconDrawRect:=GetSkinMaterial.FDrawIconParam.CalcDrawRect(AIconDrawRect);

          CalcImageDrawRect(GetSkinMaterial.FDrawIconParam,
                            GetCurrentIcon.CurrentPictureWidth,
                            GetCurrentIcon.CurrentPictureHeight,
                            AIconDrawRect,
                            AIconDrawRect
                            );
          AWidth:=ControlSize(AIconDrawRect.Width
                  +ASize.cx);//+10;
          AHeight:=ControlSize(ASize.cy);
          Result:=True;

      end;
  end;

end;

function TSkinButtonType.CalcCurrentEffectStates: TDPEffectStates;
begin
  Result:=Inherited CalcCurrentEffectStates;
  if Self.FSkinButtonIntf.Prop.FIsPushed then
  begin
    Result:=Result+[dpstPushed];
  end;
end;

function TSkinButtonType.GetButtonGroupSkinMaterial: TSkinButtonMaterial;
var
  AButtonGroupMaterial:TSkinButtonGroupMaterial;
begin
  Result:=nil;
  AButtonGroupMaterial:=nil;

  if (Self.FSkinButtonIntf.Prop.FButtonGroup<>nil) then
  begin
    AButtonGroupMaterial:=TSkinButtonGroupMaterial((Self.FSkinButtonIntf.Prop.FButtonGroup as ISkinControl).GetCurrentUseMaterial);
  end;

  if (AButtonGroupMaterial<>nil) then
  begin

      if (Self.FSkinButtonIntf.Prop.ButtonIndex=0) and AButtonGroupMaterial.FIsUseFirstButtonMaterial then
      begin
        //第一个按钮的素材
        Result:=AButtonGroupMaterial.FFirstButtonMaterial;
      end
      else
      if (Self.FSkinButtonIntf.Prop.FSkinButtonGroupIntf.Prop.ButtonCount>1)
        and (Self.FSkinButtonIntf.Prop.ButtonIndex=Self.FSkinButtonIntf.Prop.FSkinButtonGroupIntf.Prop.ButtonCount-1)
        and AButtonGroupMaterial.FIsUseLastButtonMaterial then
      begin
        //最后一个按钮的素材
        Result:=AButtonGroupMaterial.FLastButtonMaterial;
      end
      else
      begin
        //中间的按钮素材
        Result:=AButtonGroupMaterial.FMiddleButtonMaterial;
      end

  end;
end;

function TSkinButtonType.GetCurrentEffectStates: TDPEffectStates;
begin
  Result:=Inherited GetCurrentEffectStates;
  if Self.FSkinButtonIntf.Prop.FIsPushed then
  begin
    Result:=Result+[dpstPushed];
  end;
end;

function TSkinButtonType.GetCurrentIcon: TDrawPicture;
begin

  if Not Self.FSkinButtonIntf.Prop.IsPushed then
  begin
    Result:=Self.FSkinButtonIntf.Prop.FIcon;
  end
  else
  begin
    Result:=Self.FSkinButtonIntf.Prop.FPushedIcon;
  end;

  if Result.CurrentPictureIsEmpty then
  begin
    Result:=Self.FSkinButtonIntf.Prop.FIcon;
  end;

end;

function TSkinButtonType.GetSkinMaterial: TSkinButtonMaterial;
begin
  Result:=GetButtonGroupSkinMaterial;

  if Result=nil then
  begin
    Result:=TSkinButtonMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end;

end;




{ TSkinButtonDefaultType }

function TSkinButtonDefaultType.GetSkinMaterial: TSkinButtonDefaultMaterial;
begin
  Result:=TSkinButtonDefaultMaterial(GetButtonGroupSkinMaterial);

  if Result=nil then
  begin
    Result:=TSkinButtonDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end;
end;

//function TSkinButtonDefaultType.CalcAutoSize(var AWidth,AHeight: TControlSize): Boolean;
//begin
//  Result:=False;
//  if (GetSkinMaterial<>nil) and Not Self.GetSkinMaterial.FNormalPicture.CurrentPictureIsEmpty then
//  begin
//    //背景图片不为空,根据背景图片
//    AWidth:=Self.GetSkinMaterial.FNormalPicture.CurrentPictureDrawWidth;
//    AHeight:=Self.GetSkinMaterial.FNormalPicture.CurrentPictureDrawHeight;
//    Result:=True;
//  end
//  else
//  begin
//    Result:=Inherited CalcAutoSize(AWidth,AHeight);
//  end;
//end;

function TSkinButtonDefaultType.CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData): Boolean;
var
  ADrawPicture:TDrawPicture;
begin
  if GetSkinMaterial<>nil then
  begin
    ADrawPicture:=nil;
    if Not Self.FSkinControlIntf.Enabled then
    begin
      ADrawPicture:=Self.GetSkinMaterial.FDisabledPicture;
    end
    else if Self.FSkinControlIntf.IsMouseDown and APaintData.IsDrawInteractiveState then
    begin
      ADrawPicture:=Self.GetSkinMaterial.FDownPicture;
    end
    else if Self.FSkinControlIntf.IsMouseOver and APaintData.IsDrawInteractiveState then
    begin
      ADrawPicture:=Self.GetSkinMaterial.FHoverPicture;
    end
    else if Self.FSkinButtonIntf.Prop.IsPushed then
    begin
      ADrawPicture:=Self.GetSkinMaterial.FPushedPicture;
    end
    else if Self.FSkinControlIntf.Focused and APaintData.IsDrawInteractiveState then
    begin
      ADrawPicture:=Self.GetSkinMaterial.FFocusedPicture;
    end
    else
    begin
      ADrawPicture:=Self.GetSkinMaterial.FNormalPicture;
    end;




    if Self.FSkinControlIntf.Focused and ADrawPicture.CurrentPictureIsEmpty and APaintData.IsDrawInteractiveState then
    begin
      ADrawPicture:=Self.GetSkinMaterial.FFocusedPicture;
    end;



    if ADrawPicture.CurrentPictureIsEmpty then
    begin
      if Self.FSkinButtonIntf.Prop.IsPushed then
      begin
        ADrawPicture:=Self.GetSkinMaterial.FPushedPicture;
      end
      else
      begin
        ADrawPicture:=Self.GetSkinMaterial.FNormalPicture;
      end;
    end;




    if ADrawPicture.CurrentPictureIsEmpty then
    begin
      ADrawPicture:=Self.GetSkinMaterial.FNormalPicture;
    end;



    //绘制背景
    ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawPictureParam,
                        ADrawPicture,
                        ADrawRect);


    Inherited CustomPaint(ACanvas,GetSkinMaterial,ADrawRect,APaintData);

//    //绘制图标
//    DrawIcon(ACanvas,GetSkinMaterial,ADrawRect);
//    //绘制标题
//    ACanvas.DrawText(Self.GetSkinMaterial.FDrawCaptionParam,
//                        Self.FSkinControlIntf.Caption,
//                        ADrawRect);
//    //绘制明细
//    ACanvas.DrawText(Self.GetSkinMaterial.FDrawDetailParam,
//                        Self.FSkinButtonIntf.Detail,
//                        ADrawRect);
//    //绘制明细1
//    ACanvas.DrawText(Self.GetSkinMaterial.FDrawDetail1Param,
//                        Self.FSkinButtonIntf.Detail1,
//                        ADrawRect);
//
//    //绘制提示文本
//    if  (Self.FSkinControlIntf.Caption='')
//       and (Self.FSkinButtonIntf.Prop.HelpText<>'') then
//    begin
//      ACanvas.DrawText(Self.GetSkinMaterial.FDrawHelpTextParam,
//                        Self.FSkinButtonIntf.Prop.HelpText,
//                        ADrawRect);
//    end;
//

  end;
end;









{ TSkinButtonDefaultMaterial }

constructor TSkinButtonDefaultMaterial.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);

  FNormalPicture:=CreateDrawPicture('NormalPicture','正常状态图片','所有状态图片');
  FHoverPicture:=CreateDrawPicture('HoverPicture','鼠标停靠状态图片','所有状态图片');
  FDownPicture:=CreateDrawPicture('DownPicture','鼠标按下状态图片','所有状态图片');
  FDisabledPicture:=CreateDrawPicture('DisabledPicture','禁用状态图片','所有状态图片');
  FFocusedPicture:=CreateDrawPicture('FocusedPicture','得到焦点状态图片','所有状态图片');
  FPushedPicture:=CreateDrawPicture('PushedPicture','按下状态图片','所有状态图片');
  FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','背景图片绘制参数');

end;


destructor TSkinButtonDefaultMaterial.Destroy;
begin
  FreeAndNil(FDrawPictureParam);
  FreeAndNil(FHoverPicture);
  FreeAndNil(FNormalPicture);
  FreeAndNil(FDisabledPicture);
  FreeAndNil(FDownPicture);
  FreeAndNil(FPushedPicture);
  FreeAndNil(FFocusedPicture);
  inherited;
end;

procedure TSkinButtonDefaultMaterial.SetDisabledPicture(const Value: TDrawPicture);
begin
  FDisabledPicture.Assign(Value);
end;

procedure TSkinButtonDefaultMaterial.SetDownPicture(const Value: TDrawPicture);
begin
  FDownPicture.Assign(Value);
end;

procedure TSkinButtonDefaultMaterial.SetFocusedPicture(const Value: TDrawPicture);
begin
  FFocusedPicture.Assign(Value);
end;

procedure TSkinButtonDefaultMaterial.SetHoverPicture(const Value: TDrawPicture);
begin
  FHoverPicture.Assign(Value);
end;

procedure TSkinButtonDefaultMaterial.SetNormalPicture(const Value: TDrawPicture);
begin
  FNormalPicture.Assign(Value);
end;

procedure TSkinButtonDefaultMaterial.SetPushedPicture(const Value: TDrawPicture);
begin
  FPushedPicture.Assign(Value);
end;

procedure TSkinButtonDefaultMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;



{ TSkinButtonMaterial }



function TSkinButtonMaterial.HasMouseDownEffect:Boolean;
begin
  Result:=True;
end;

function TSkinButtonMaterial.HasMouseOverEffect:Boolean;
begin
  Result:=True;
end;

procedure TSkinButtonMaterial.AssignTo(Dest: TPersistent);
begin
  inherited;

  TSkinButtonMaterial(Dest).FIsAutoCenterIconAndCaption:=FIsAutoCenterIconAndCaption;
end;

constructor TSkinButtonMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDrawHelpTextParam:=CreateDrawTextParam('DrawHelpTextParam','提示文本绘制参数');
  FDrawHelpTextParam.DrawFont.FontColor.Color:=GrayColor;

  FDrawCaptionParam:=CreateDrawTextParam('DrawCaptionParam','标题绘制参数');
  FDrawDetailParam:=CreateDrawTextParam('DrawDetailParam','明细绘制参数');
  FDrawDetail1Param:=CreateDrawTextParam('DrawDetail1Param','明细1绘制参数');
  FDrawIconParam:=CreateDrawPictureParam('DrawIconParam','图标绘制参数');
end;

destructor TSkinButtonMaterial.Destroy;
begin
  FreeAndNil(FDrawHelpTextParam);
  FreeAndNil(FDrawCaptionParam);
  FreeAndNil(FDrawDetailParam);
  FreeAndNil(FDrawDetail1Param);
  FreeAndNil(FDrawIconParam);
  inherited;
end;

procedure TSkinButtonMaterial.SetDrawCaptionParam(const Value: TDrawTextParam);
begin
  FDrawCaptionParam.Assign(Value);
end;

procedure TSkinButtonMaterial.SetDrawDetailParam(const Value: TDrawTextParam);
begin
  FDrawDetailParam.Assign(Value);
end;

procedure TSkinButtonMaterial.SetDrawHelpTextParam(const Value: TDrawTextParam);
begin
  FDrawHelpTextParam.Assign(Value);
end;

procedure TSkinButtonMaterial.SetDrawDetail1Param(const Value: TDrawTextParam);
begin
  FDrawDetail1Param.Assign(Value);
end;

procedure TSkinButtonMaterial.SetDrawIconParam(const Value: TDrawPictureParam);
begin
  FDrawIconParam.Assign(Value);
end;

procedure TSkinButtonMaterial.SetIsAutoCenterIconAndCaption(const Value: Boolean);
begin
  if FIsAutoCenterIconAndCaption<>Value then
  begin
    FIsAutoCenterIconAndCaption := Value;
    Self.DoChange();
  end;
end;

{ TBaseButtonProperties }

procedure TBaseButtonProperties.SetButtonGroup(Value: TSkinBaseButtonGroup);
begin
  if FButtonGroup<>Value then
  begin

    if FButtonGroup<>nil then
    begin
      Self.FSkinControlIntf.Parent:=nil;
      if Self.FSkinButtonGroupIntf.Properties<>nil then
      begin
        Self.FSkinButtonGroupIntf.Prop.RemoveButton(Self.FSkinControl);
      end;
      FSkinButtonGroupIntf:=nil;
    end;



    FButtonGroup:=Value;


    if (FButtonGroup<>nil) then
    begin
      FSkinButtonGroupIntf:=FButtonGroup as ISkinButtonGroup;
      if (Self.FSkinButtonGroupIntf.Properties<>nil) and (Self.FSkinButtonGroupIntf.Prop.FButtonList.IndexOf(Self.FSkinControl)=-1) then
      begin
        Self.FSkinButtonGroupIntf.Prop.InsertButton(Self.FSkinControl);
        Self.FSkinControlIntf.Parent:=TParentControl(FButtonGroup);
      end;
    end;


    Self.FSkinButtonGroupIntf.Prop.FListLayoutsManager.DoItemVisibleChange(nil);

  end;




end;

procedure TBaseButtonProperties.AssignProperties(Src:TSkinControlProperties);
begin
  inherited;

  Self.FIsPushed:=TBaseButtonProperties(Src).FIsPushed;
  Self.FIsAutoPush:=TBaseButtonProperties(Src).FIsAutoPush;
  Self.FPushedGroupIndex:=TBaseButtonProperties(Src).FPushedGroupIndex;
  Self.FIcon.Assign(TBaseButtonProperties(Src).FIcon);
  Self.FPushedIcon.Assign(TBaseButtonProperties(Src).FPushedIcon);
end;

constructor TBaseButtonProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinButton,Self.FSkinButtonIntf) then
  begin
    ShowException('This Component Do not Support ISkinButton Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=100;
    Self.FSkinControlIntf.Height:=40;

    FButtonIndex:=-1;

    Self.FIsPushed:=False;
    Self.FIsAutoPush:=False;
    Self.FPushedGroupIndex:=0;

    FIcon:=CreateDrawPicture('Icon','按钮图标');
    FPushedIcon:=CreateDrawPicture('PushedIcon','按钮按下图标');
  end;
end;

destructor TBaseButtonProperties.Destroy;
begin
  if (Self.FButtonGroup <> nil) and (Self.FSkinButtonGroupIntf.Properties<>nil) then
  begin
    //删除按钮
    Self.FSkinButtonGroupIntf.Prop.RemoveButton(Self.FSkinControl);
    //重新排列
//    Self.FSkinButtonGroupIntf.Prop.AlignButtons;
    Self.FSkinButtonGroupIntf.Prop.FListLayoutsManager.DoItemVisibleChange(nil);
  end;

  FreeAndNil(FPushedIcon);
  FreeAndNil(FIcon);
  inherited;
end;

function TBaseButtonProperties.GetComponentClassify: String;
begin
  Result:='SkinButton';
end;

procedure TBaseButtonProperties.GetPropJson(ASuperObject: ISuperObject);
begin
  inherited;

end;

procedure TBaseButtonProperties.SetIcon(const Value: TDrawPicture);
begin
  Self.FIcon.Assign(Value);
end;

procedure TBaseButtonProperties.SetPropJson(ASuperObject: ISuperObject);
begin
  inherited;

  if ASuperObject.Contains('IsAutoPush') then
  begin
    Self.IsAutoPush:=ASuperObject.B['IsAutoPush'];
  end;

  if ASuperObject.Contains('PushedGroupIndex') then
  begin
    Self.PushedGroupIndex:=ASuperObject.I['PushedGroupIndex'];
  end;

end;

procedure TBaseButtonProperties.SetPushedIcon(const Value: TDrawPicture);
begin
  Self.FPushedIcon.Assign(Value);
end;

function TBaseButtonProperties.GetButtonIndex: Integer;
begin
  if FButtonGroup <> nil then
  begin
    Result := FSkinButtonGroupIntf.Prop.FButtonList.IndexOf(Self.FSkinControl);
  end
  else
  begin
    Result := -1;
  end;
  Self.FButtonIndex:=Result;
end;

procedure TBaseButtonProperties.SetButtonIndex(const Value: Integer);
var
  MaxButtonIndex, OldIndex: Integer;
begin
  if (csLoading in Self.FSkinControl.ComponentState)
    or (csReading in Self.FSkinControl.ComponentState) then
  begin
    FButtonIndex := Value;
    Exit;
  end;

  if (FButtonGroup <> nil) then
  begin
    OldIndex := ButtonIndex;
    MaxButtonIndex := FSkinButtonGroupIntf.Prop.FButtonList.Count - 1;
    if Value <= MaxButtonIndex then
    begin
      FSkinButtonGroupIntf.Prop.FButtonList.Move(OldIndex,Value);
      FButtonIndex:=Value;
      Self.FSkinButtonGroupIntf.Prop.FListLayoutsManager.DoItemSizeChange(nil);
    end;
  end;
end;

procedure TBaseButtonProperties.SetHelpText(const Value: String);
begin
  if FHelpText<>Value then
  begin
    FHelpText:=Value;
    Invalidate;
  end;
end;

procedure TBaseButtonProperties.SetIsPushed(const Value: Boolean);
var
  I: Integer;
  AHasSameGroupIndex:Boolean;
  ASkinButtonIntf:ISkinButton;
begin
  if FIsPushed<>Value then
  begin

    AHasSameGroupIndex:=False;




    if not (csReading in Self.FSkinControl.ComponentState)
      and not (csLoading in Self.FSkinControl.ComponentState) then
    begin

      //遍历,只能有一个按钮处于按下状态
      if (Self.FPushedGroupIndex<>0)
        and (Self.FSkinControlIntf.GetParent<>nil) then
      begin
            for I := 0 to Self.FSkinControlIntf.GetParentChildControlCount - 1 do
            begin
              if Self.FSkinControlIntf.GetParentChildControl(I).GetInterface(IID_ISkinButton,ASkinButtonIntf) then
              begin
                if (Self.FSkinControlIntf.GetParentChildControl(I)<>Self.FSkinControl) then
                begin
                  if (ASkinButtonIntf.Prop.PushedGroupIndex=Self.FPushedGroupIndex) then
                  begin
                    AHasSameGroupIndex:=True;
                    //将要选中时
                    if Not Self.IsPushed and ASkinButtonIntf.Prop.IsPushed then
                    begin
                      ASkinButtonIntf.Prop.FIsPushed:=False;
                      ASkinButtonIntf.Prop.Invalidate;
                    end;
                  end;
                end;
              end;
            end;
      end
      else
      begin
      end;
    end;


    if (Self.FPushedGroupIndex<>0) then
    begin
      if AHasSameGroupIndex and Value or Not AHasSameGroupIndex then
      begin
        Self.FIsPushed:=Value;
      end
      else
      begin
      end;
    end
    else
    begin
      Self.FIsPushed:=Value;
    end;

    Invalidate;
  end;
end;



{ TSkinButtonGroupType }

function TSkinButtonGroupType.CalcAutoSize(var AWidth, AHeight: TControlSize): Boolean;
begin
  Result:=False;
  if
    //按钮个数不为0的时候才自动尺寸,不然高度宽度为0,都不能选中了
    (Self.FSkinButtonGroupIntf.Prop.ButtonCount>0) then
  begin
    case Self.FSkinButtonGroupIntf.Prop.FListLayoutsManager.ItemLayoutType of
      iltVertical:
      begin
          AHeight:=ControlSize(Self.FSkinButtonGroupIntf.Prop.FListLayoutsManager.CalcContentHeight);
          AWidth:=Self.FSkinControlIntf.Width;
      end;
      iltHorizontal:
      begin
          AWidth:=ControlSize(Self.FSkinButtonGroupIntf.Prop.FListLayoutsManager.CalcContentWidth);
          AHeight:=Self.FSkinControlIntf.Height;
      end;
    end;
    Result:=True;
  end;
end;

function TSkinButtonGroupType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinButtonGroup,Self.FSkinButtonGroupIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinButtonGroup Interface');
    end;
  end;
end;

procedure TSkinButtonGroupType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinButtonGroupIntf:=nil;
end;

function TSkinButtonGroupType.GetSkinMaterial: TSkinButtonGroupMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinButtonGroupMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

procedure TSkinButtonGroupType.SizeChanged;
begin
  inherited;
  if Self.FSkinButtonGroupIntf.Properties<>nil then
  begin
    Self.FSkinButtonGroupIntf.Prop.FListLayoutsManager.DoItemSizeChange(nil);
//    Self.FSkinButtonGroupIntf.Prop.AlignButtons;
  end;
end;






{ TSkinButtonGroupDefaultType }

function TSkinButtonGroupDefaultType.GetSkinMaterial: TSkinButtonGroupDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinButtonGroupDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinButtonGroupDefaultType.CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData): Boolean;
var
  I: Integer;
begin
  for I := 0 to Self.FSkinButtonGroupIntf.Prop.FListLayoutsManager.GetVisibleItemsCount-1 do
  begin
    Self.FSkinButtonGroupIntf.Prop.FListLayoutsManager.VisibleItemRectByIndex(I);
  end;
end;




{ TSkinButtonGroupDefaultMaterial }


{ TSkinButtonGroupMaterial }
function TSkinButtonGroupMaterial.GetFirstButtonMaterial: TSkinButtonMaterial;
begin
  Result:=FFirstButtonMaterial;
end;

function TSkinButtonGroupMaterial.GetLastButtonMaterial: TSkinButtonMaterial;
begin
  Result:=FLastButtonMaterial;
end;

function TSkinButtonGroupMaterial.GetMiddleButtonMaterial: TSkinButtonMaterial;
begin
  Result:=FMiddleButtonMaterial;
end;

constructor TSkinButtonGroupMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FFirstButtonMaterial:=Self.GetButtonMaterialClass.Create(Self);
  FFirstButtonMaterial.SetSubComponent(True);
  FFirstButtonMaterial.Name:='FirstButtonMaterial';

  FLastButtonMaterial:=Self.GetButtonMaterialClass.Create(Self);
  FLastButtonMaterial.SetSubComponent(True);
  FLastButtonMaterial.Name:='LastButtonMaterial';

  FMiddleButtonMaterial:=Self.GetButtonMaterialClass.Create(Self);
  FMiddleButtonMaterial.SetSubComponent(True);
  FMiddleButtonMaterial.Name:='MiddleButtonMaterial';

  FIsUseFirstButtonMaterial:=False;
  FIsUseLastButtonMaterial:=False;
end;


function TSkinButtonGroupMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='IsUseFirstButtonMaterial' then
    begin
      FIsUseFirstButtonMaterial:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='IsUseLastButtonMaterial' then
    begin
      FIsUseLastButtonMaterial:=ABTNode.ConvertNode_Bool32.Data;
    end

    else if ABTNode.NodeName='FirstButtonMaterial' then
    begin
      FFirstButtonMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    else if ABTNode.NodeName='MiddleButtonMaterial' then
    begin
      FMiddleButtonMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    else if ABTNode.NodeName='LastButtonMaterial' then
    begin
      FLastButtonMaterial.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end

    ;

  end;

  Result:=True;

end;

function TSkinButtonGroupMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Bool32('IsUseFirstButtonMaterial','是否使用第一个按钮素材');
  ABTNode.ConvertNode_Bool32.Data:=Self.FIsUseFirstButtonMaterial;

  ABTNode:=ADocNode.AddChildNode_Bool32('IsUseLastButtonMaterial','是否使用最后一个按钮素材');
  ABTNode.ConvertNode_Bool32.Data:=Self.FIsUseLastButtonMaterial;



  ABTNode:=ADocNode.AddChildNode_Class('FirstButtonMaterial','第一个按钮的素材');
  FFirstButtonMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);

  ABTNode:=ADocNode.AddChildNode_Class('MiddleButtonMaterial','中间按钮的素材');
  FMiddleButtonMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);

  ABTNode:=ADocNode.AddChildNode_Class('LastButtonMaterial','最后一个按钮的素材');
  FLastButtonMaterial.SaveToDocNode(ABTNode.ConvertNode_Class);


  Result:=True;
end;


destructor TSkinButtonGroupMaterial.Destroy;
begin
  FreeAndNil(FFirstButtonMaterial);
  FreeAndNil(FLastButtonMaterial);
  FreeAndNil(FMiddleButtonMaterial);
  inherited;
end;

function TSkinButtonGroupMaterial.GetButtonMaterialClass: TSkinButtonMaterialClass;
begin
  Result:=TSkinButtonMaterial;
end;

procedure TSkinButtonGroupMaterial.SetFirstButtonMaterial(const Value: TSkinButtonMaterial);
begin
  FFirstButtonMaterial.Assign(Value);
end;

procedure TSkinButtonGroupMaterial.SetLastButtonMaterial(const Value: TSkinButtonMaterial);
begin
  FLastButtonMaterial.Assign(Value);
end;

procedure TSkinButtonGroupMaterial.SetMiddleButtonMaterial(const Value: TSkinButtonMaterial);
begin
  FMiddleButtonMaterial.Assign(Value);
end;

procedure TSkinButtonGroupMaterial.SetIsUseFirstButtonMaterial(const Value: Boolean);
begin
  if FIsUseFirstButtonMaterial<>Value then
  begin
    FIsUseFirstButtonMaterial:=Value;
    DoChange;
  end;
end;

procedure TSkinButtonGroupMaterial.SetIsUseLastButtonMaterial(const Value: Boolean);
begin
  if FIsUseLastButtonMaterial<>Value then
  begin
    FIsUseLastButtonMaterial:=Value;
    DoChange;
  end;
end;

procedure TSkinButtonGroupMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinButtonGroupMaterial;
begin

  if Dest is TSkinButtonGroupMaterial then
  begin
    DestObject:=TSkinButtonGroupMaterial(Dest);

    DestObject.FIsUseFirstButtonMaterial:=Self.FIsUseFirstButtonMaterial;
    DestObject.FIsUseLastButtonMaterial:=Self.FIsUseLastButtonMaterial;


    DestObject.FFirstButtonMaterial.Assign(Self.FFirstButtonMaterial);
    DestObject.FMiddleButtonMaterial.Assign(Self.FMiddleButtonMaterial);
    DestObject.FLastButtonMaterial.Assign(Self.FLastButtonMaterial);


  end;

  inherited;
end;






{ TSkinButtonGroupNormalMaterial }


{ TButtonGroupProperties }

procedure TButtonGroupProperties.AssignProperties(Src:TSkinControlProperties);
begin
  inherited;
end;

constructor TButtonGroupProperties.Create(ASkinControl:TControl);
begin
  FButtonList:=TSkinButtonList.Create(ooReference);
  FListLayoutsManager:=TSkinListLayoutsManager.Create(FButtonList);
  FListLayoutsManager.OnItemSizeChange:=Self.DoGetListLayoutsManagerItemSizeChange;
  FListLayoutsManager.OnItemPropChange:=Self.DoGetListLayoutsManagerItemPropChange;
  FListLayoutsManager.OnItemVisibleChange:=Self.DoGetListLayoutsManagerItemVisibleChange;


  inherited Create(ASkinControl);

  if Not ASkinControl.GetInterface(IID_ISkinButtonGroup,Self.FSkinButtonGroupIntf) then
  begin
    ShowException('This Component Do not Support ISkinButtonGroup Interface');
  end
  else
  begin


    //设置布局
    SetOrientation(boHorz);

    //获取父控件尺寸
    FListLayoutsManager.OnGetControlWidth:=DoGetListLayoutsManagerControlWidth;
    FListLayoutsManager.OnGetControlHeight:=DoGetListLayoutsManagerControlHeight;


    Self.FSkinControlIntf.Width:=300;
    Self.FSkinControlIntf.Height:=44;

  end;
end;

destructor TButtonGroupProperties.Destroy;
//var
//  I: Integer;
//  AButton:TObject;
begin
//  Self.FSkinButtonGroupIntf.FreeChildButtons;
//  for I := FButtonList.Count-1 downto 0 do
//  begin
//    AButton:=FButtonList[I];
//    (TComponent(FButtonList[I]) as ISkinButton).Properties.ButtonGroup:=nil;
//    FreeAndNil(AButton);
//  end;

  FreeAndNil(FButtonList);
  FreeAndNil(FListLayoutsManager);

  inherited;
end;

function TButtonGroupProperties.DoGetListLayoutsManagerControlHeight(Sender: TObject): Double;
begin
  Result:=Self.FSkinControl.Height;
end;

function TButtonGroupProperties.DoGetListLayoutsManagerControlWidth(Sender: TObject): Double;
begin
  Result:=Self.FSkinControl.Width;
end;

procedure TButtonGroupProperties.DoGetListLayoutsManagerItemPropChange(Sender: TObject);
begin

end;

procedure TButtonGroupProperties.DoGetListLayoutsManagerItemSizeChange(Sender: TObject);
begin

end;

procedure TButtonGroupProperties.DoGetListLayoutsManagerItemVisibleChange(Sender: TObject);
var
  I: Integer;
begin

  {$IFDEF FMX}
  for I := 0 to Self.FButtonList.Count-1 do
  begin
    TControl(FButtonList[I]).Locked:=(csDesigning in Self.FSkinControl.ComponentState);
  end;
  {$ENDIF FMX}


  //重新计算自动尺寸
  Self.AdjustAutoSizeBounds;
end;

function TButtonGroupProperties.GetComponentClassify: String;
begin
  Result:='SkinButtonGroup';
end;

function TButtonGroupProperties.GetOrientation: TButtonOrientation;
begin
  case FListLayoutsManager.ItemLayoutType of
    iltVertical: Result:=boVert;
    iltHorizontal: Result:=boHorz;
  end;
end;

function TButtonGroupProperties.GetButtonButtonIntf(Index: Integer): ISkinButton;
begin
  Result:=TComponent(Self.FButtonList[Index]) as ISkinButton;
end;

function TButtonGroupProperties.GetButtonRect(Index: Integer): TRectF;
//var
//  I: Integer;
//  SumSize:Double;
//  EqualSize:Double;
begin
  Result:=FListLayoutsManager.VisibleItemRectByIndex(Index);
//  Result:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);
//
//  case Self.FButtonSizeCalcType of
//    bsctEqual:
//    begin
//      EqualSize:=Self.FSkinControlIntf.Width / Self.FButtonList.Count;
//      case Self.FOrientation of
//        boHorz:
//        begin
//          Result.Left:=Result.Left+Index*EqualSize;
//          Result.Right:=Result.Left+EqualSize;
//        end;
//        boVert:
//        begin
//          Result.Top:=Result.Top+Index*EqualSize;
//          Result.Bottom:=Result.Top+EqualSize;
//        end;
//      end;
//    end;
//    bsctFixed:
//    begin
//      case Self.FOrientation of
//        boHorz:
//        begin
//          Result.Left:=Result.Left+Index*FButtonSize;
//          Result.Right:=Result.Left+FButtonSize;
//        end;
//       boVert:
//        begin
//          Result.Top:=Result.Top+Index*FButtonSize;
//          Result.Bottom:=Result.Top+FButtonSize;
//        end;
//      end;
//    end;
//    bsctSeparate:
//    begin
//      SumSize:=0;
//      for I := 0 to Index-1 do
//      begin
//        SumSize:=SumSize+Self.GetButtonButtonIntf(I).Properties.FSkinControlIntf.Width;
//      end;
//
//      case Self.FOrientation of
//        boHorz:
//        begin
//          Result.Left:=Result.Left+SumSize;
//          Result.Right:=Result.Left+Self.GetButtonButtonIntf(Index).Properties.FSkinControlIntf.Width;
//        end;
//        boVert:
//        begin
//          Result.Top:=Result.Top+SumSize;
//          Result.Bottom:=Result.Top+Self.GetButtonButtonIntf(Index).Properties.FSkinControlIntf.Width;
//        end;
//      end;
//    end;
////    bsctAutoSize: ;
////    bsctCustom: ;
//  end;
end;

function TButtonGroupProperties.GetButtonSize: Double;
begin
  case FListLayoutsManager.ItemLayoutType of
    iltVertical: Result:=FListLayoutsManager.ItemHeight;
    iltHorizontal: Result:=FListLayoutsManager.ItemWidth;
  end;
end;

function TButtonGroupProperties.GetButtonSizeCalcType: TButtonSizeCalcType;
begin
  case FListLayoutsManager.ItemSizeCalcType of
    isctFixed: Result:=bsctFixed;
    isctSeparate: Result:=bsctSeparate;
  end;
end;                             

procedure TButtonGroupProperties.SetOrientation(const Value: TButtonOrientation);
var
  AOldButtonSize:Double;
begin
  //预先保留按钮的尺寸
  AOldButtonSize:=GetButtonSize;

  //设置排列布局
  case Value of
    boHorz:
    begin
      FListLayoutsManager.StaticItemHeight:=Const_Tag_UseControlHeight;
      FListLayoutsManager.ItemLayoutType:=iltHorizontal;
    end;
    boVert:
    begin
      FListLayoutsManager.StaticItemWidth:=Const_Tag_UseControlWidth;
      FListLayoutsManager.ItemLayoutType:=iltVertical;
    end;
  end;

  //再设置原先的按钮尺寸
  ButtonSize:=AOldButtonSize;
end;

procedure TButtonGroupProperties.SetButtonSize(const Value: Double);
begin
  case FListLayoutsManager.ItemLayoutType of
    iltVertical:
    begin
      FListLayoutsManager.ItemHeight:=Value;
    end;
    iltHorizontal:
    begin
      FListLayoutsManager.ItemWidth:=Value;
    end;
  end;
end;

procedure TButtonGroupProperties.SetButtonSizeCalcType(const Value: TButtonSizeCalcType);
begin
  case Value of
    bsctFixed: FListLayoutsManager.ItemSizeCalcType:=isctFixed;
    bsctSeparate: FListLayoutsManager.ItemSizeCalcType:=isctSeparate;
  end;
end;

function ListCompareByButtonIndex(Item1, Item2: Pointer): Integer;
begin
  Result:=0;
  if (TComponent(Item1) as ISkinButton).Properties.FButtonIndex
    >(TComponent(Item2) as ISkinButton).Properties.FButtonIndex then
  begin
    Result:=1;
  end
  else if (TComponent(Item1) as ISkinButton).Properties.FButtonIndex
          <(TComponent(Item2) as ISkinButton).Properties.FButtonIndex then
  begin
    Result:=-1;
  end;
end;

procedure TButtonGroupProperties.SortButtons;
begin
  Self.FButtonList.Sort(ListCompareByButtonIndex);
end;

function TButtonGroupProperties.GetButtonCount:Integer;
begin
  Result:=Self.FButtonList.Count;
end;

function TButtonGroupProperties.GetButton(Index: Integer):TComponent;
begin
  Result:=TComponent(Self.FButtonList[Index]);
end;

procedure TButtonGroupProperties.InsertButton(Button: TComponent);
begin
  Self.FButtonList.Add(Button);
  (Button as ISkinButton).Properties.FButtonGroup:=TSkinBaseButtonGroup(Self.FSkinControl);
end;

procedure TButtonGroupProperties.RemoveButton(Button: TComponent);
begin
  Self.FButtonList.Remove(Button,False);
  if (Button as ISkinButton).Properties<>nil then
  begin
    (Button as ISkinButton).Properties.FButtonGroup:=nil;
  end;
end;




{ TSkinButtonGroupNormalPushedMaterial }







{ TSkinButtonGroupDefaultMaterial }

function TSkinButtonGroupDefaultMaterial.GetButtonMaterialClass: TSkinButtonMaterialClass;
begin
  Result:=TSkinButtonDefaultMaterial;
end;



//{$IFDEF FMX}
//{ TSkinButton }
//
//function TSkinButton.Material:TSkinButtonDefaultMaterial;
//begin
//  Result:=TSkinButtonDefaultMaterial(FMaterial);
//end;
//
//function TSkinButton.GetDrawPictureParam: TDrawPictureParam;
//begin
//  Result:=Self.Material.FDrawPictureParam;
//end;
//
//function TSkinButton.GetPropertiesClassType: TPropertiesClassType;
//begin
//  Result:=TButtonProperties;
//end;
//
//function TSkinButton.GetPushedGroupIndex: Integer;
//begin
//  Result:=Self.Prop.FPushedGroupIndex;
//end;
//
//function TSkinButton.GetPushedIcon: TDrawPicture;
//begin
//  Result:=Self.Prop.FPushedIcon;
//end;
//
//function TSkinButton.GetPushedPicture: TDrawPicture;
//begin
//  Result:=Self.Material.FPushedPicture;
//end;
//
//function TSkinButton.GetSelected: Boolean;
//begin
//  Result:=False;
//end;
//
//procedure TSkinButton.ReadState(Reader: TReader);
//var
//  ASkinButtonGroupIntf:ISkinButtonGroup;
//begin
//  inherited ReadState(Reader);
//
//
//  //动态指定Button的按钮组
//  if (Reader.Parent<>nil)
//    and (Reader.Parent.GetInterface(IID_ISkinButtonGroup,ASkinButtonGroupIntf)) then
//  begin
//    Self.Prop.ButtonGroup:=TSkinBaseButtonGroup(Reader.Parent);
//  end;
//
//end;
//
//function TSkinButton.GetButtonProperties: TButtonProperties;
//begin
//  Result:=TButtonProperties(Self.FProperties);
//end;
//
//function TSkinButton.GetDrawCaptionParam: TDrawTextParam;
//begin
//  Result:=Self.Material.FDrawCaptionParam;
//end;
//
////function TSkinButton.GetControlTypeClass: TControlTypeClass;
////begin
////  Result:=TSkinButtonDefaultType;
////end;
//
//procedure TSkinButton.SetButtonProperties(Value: TButtonProperties);
//begin
//  Self.FProperties.Assign(Value);
//end;
//
//procedure TSkinButton.SetDrawCaptionParam(const Value: TDrawTextParam);
//begin
//  Self.Material.DrawCaptionParam:=Value;
//end;
//
//procedure TSkinButton.SetDetail(const Value:String);
//begin
//  if FDetail<>Value then
//  begin
//    FDetail:=Value;
//    Invalidate;
//  end;
//end;
//
//procedure TSkinButton.SetDetail1(const Value:String);
//begin
//  if FDetail1<>Value then
//  begin
//    FDetail1:=Value;
//    Invalidate;
//  end;
//end;
//
//procedure TSkinButton.SetDrawDetail1Param(const Value: TDrawTextParam);
//begin
//  Self.Material.DrawDetail1Param:=Value;
//end;
//
//procedure TSkinButton.SetDrawDetailParam(const Value: TDrawTextParam);
//begin
//  Self.Material.DrawDetailParam:=Value;
//end;
//
//procedure TSkinButton.SetDisabledPicture(const Value: TDrawPicture);
//begin
//  Self.Material.DisabledPicture:=Value;
//end;
//
//procedure TSkinButton.SetDownPicture(const Value: TDrawPicture);
//begin
//  Self.Material.DownPicture:=Value;
//end;
//
//procedure TSkinButton.SetFocusedPicture(const Value: TDrawPicture);
//begin
//  Self.Material.FocusedPicture:=Value;
//end;
//
//procedure TSkinButton.SetHoverPicture(const Value: TDrawPicture);
//begin
//  Self.Material.HoverPicture:=Value;
//end;
//
//procedure TSkinButton.SetIcon(const Value: TDrawPicture);
//begin
//  Self.Prop.Icon:=Value;
//end;
//
//procedure TSkinButton.SetDrawIconParam(const Value: TDrawPictureParam);
//begin
//  Self.Material.DrawIconParam:=Value;
//end;
//
//procedure TSkinButton.SetIsAutoPush(const Value: Boolean);
//begin
//  Self.Prop.IsAutoPush:=Value;
//end;
//
//procedure TSkinButton.SetIsPushed(const Value: Boolean);
//begin
//  Self.Prop.IsPushed:=Value;
//end;
//
//procedure TSkinButton.SetItemDrawRect(Value: TRectF);
//begin
//  FItemDrawRect:=Value;
//end;
//
//procedure TSkinButton.SetSkinListIntf(ASkinListIntf: ISkinList);
//begin
//  FSkinListIntf:=ASkinListIntf;
//end;
//
//procedure TSkinButton.SetItemRect(Value: TRectF);
//begin
//  FItemRect:=Value;
//  Self.SetBounds(Value);
//end;
//
//procedure TSkinButton.SetNormalPicture(const Value: TDrawPicture);
//begin
//  Self.Material.NormalPicture:=Value;
//end;
//
//procedure TSkinButton.SetDrawPictureParam(const Value: TDrawPictureParam);
//begin
//  Self.Material.DrawPictureParam:=Value;
//end;
//
//procedure TSkinButton.SetPushedGroupIndex(const Value: Integer);
//begin
//  Self.Prop.PushedGroupIndex:=Value;
//end;
//
//procedure TSkinButton.SetPushedIcon(const Value: TDrawPicture);
//begin
//  Self.Prop.PushedIcon:=Value;
//end;
//
//procedure TSkinButton.SetPushedPicture(const Value: TDrawPicture);
//begin
//  Self.Material.PushedPicture:=Value;
//end;
//
//procedure TSkinButton.ClearItemRect;
//begin
//
//end;
//
//procedure TSkinButton.Click;
//begin
//
//  if Self.GetButtonProperties.IsAutoPush then
//  begin
//
//    Self.GetButtonProperties.IsPushed:=Not Self.GetButtonProperties.IsPushed;
//
//    inherited;
//  end
//  else
//  begin
//    inherited;
//  end;
//
//end;
//
//function TSkinButton.GetDetail:String;
//begin
//  Result:=FDetail;
//end;
//
//function TSkinButton.GetDetail1:String;
//begin
//  Result:=FDetail1;
//end;
//
//function TSkinButton.GetDrawDetail1Param: TDrawTextParam;
//begin
//  Result:=Self.Material.FDrawDetail1Param;
//end;
//
//function TSkinButton.GetDrawDetailParam: TDrawTextParam;
//begin
//  Result:=Self.Material.FDrawDetailParam;
//end;
//
//function TSkinButton.GetDisabledPicture: TDrawPicture;
//begin
//  Result:=Self.Material.FDisabledPicture;
//end;
//
//function TSkinButton.GetDownPicture: TDrawPicture;
//begin
//  Result:=Self.Material.FDownPicture;
//end;
//
//function TSkinButton.GetFocusedPicture: TDrawPicture;
//begin
//  Result:=Self.Material.FFocusedPicture;
//end;
//
//function TSkinButton.GetHoverPicture: TDrawPicture;
//begin
//  Result:=Self.Material.FHoverPicture;
//end;
//
//function TSkinButton.GetIcon: TDrawPicture;
//begin
//  Result:=Self.Prop.FIcon;
//end;
//
//function TSkinButton.GetDrawIconParam: TDrawPictureParam;
//begin
//  Result:=Self.Material.FDrawIconParam;
//end;
//
//function TSkinButton.GetIsAutoPush: Boolean;
//begin
//  Result:=Self.Prop.FIsAutoPush;
//end;
//
//function TSkinButton.GetIsPushed: Boolean;
//begin
//  Result:=Self.Prop.FIsPushed;
//end;
//
//function TSkinButton.GetItemDrawRect: TRectF;
//begin
//  Result:=FItemDrawRect;
//end;
//
//function TSkinButton.GetListLayoutsManager:TSkinListLayoutsManager;
//begin
//  Result:=Self.FSkinListIntf.GetListLayoutsManager;
//end;
//
//function TSkinButton.GetItemRect: TRectF;
//begin
//  Result:=FItemRect;
//end;
//
////function TSkinButton.GetMaterialClass: TMaterialClass;
////begin
////  Result:=TSkinButtonDefaultMaterial;
////end;
//
//function TSkinButton.GetNormalPicture: TDrawPicture;
//begin
//  Result:=Self.Material.FNormalPicture;
//end;
//
//function TSkinButton.GetObject: TObject;
//begin
//  Result:=Self;
//end;
//
//procedure TSkinButton.DoCustomSkinMaterialChange(Sender: TObject);
//begin
//
//  //自动设置尺寸
//  if not (csReading in Self.ComponentState)
//    and not (csLoading in Self.ComponentState) then
//  begin
//    Self.GetButtonProperties.AdjustAutoSizeBounds;
//  end;
//
//  Inherited;
//end;
//
//procedure TSkinButton.BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
//begin
//  StaticCaption:=AText;
//end;
//
//
//
//
//
//{ TSkinButtonGroup }
//
//function TSkinButtonGroup.GetDrawButtonPictureParam: TDrawPictureParam;
//begin
//  Result:=ButtonMaterial.FDrawPictureParam;
//end;
//
//function TSkinButtonGroup.GetPropertiesClassType: TPropertiesClassType;
//begin
//  Result:=TButtonGroupProperties;
//end;
//
//function TSkinButtonGroup.GetButtonPushedPicture: TDrawPicture;
//begin
//  Result:=ButtonMaterial.FPushedPicture;
//end;
//
//function TSkinButtonGroup.Material: TSkinButtonGroupDefaultMaterial;
//begin
//  Result:=TSkinButtonGroupDefaultMaterial(FMaterial);
//end;
//
//function TSkinButtonGroup.GetAutoSize: Boolean;
//begin
//  Result:=Self.Prop.AutoSize;
//end;
//
//function TSkinButtonGroup.GetButtonBackColorParam: TDrawRectParam;
//begin
//  Result:=Self.ButtonMaterial.FDrawBackColorParam;
//end;
//
//function TSkinButtonGroup.GetButtonGroupProperties: TButtonGroupProperties;
//begin
//  Result:=TButtonGroupProperties(Self.FProperties);
//end;
//
//function TSkinButtonGroup.GetLayoutType: TItemLayoutType;
//begin
//  Result:=Self.Prop.FListLayoutsManager.ItemLayoutType;
//end;
//
//function TSkinButtonGroup.GetButtonSize: TControlSize;
//begin
//  Result:=Self.Prop.ButtonSize;
//end;
//
//function TSkinButtonGroup.GetDrawButtonCaptionParam: TDrawTextParam;
//begin
//  Result:=ButtonMaterial.FDrawCaptionParam;
//end;
//
////function TSkinButtonGroup.GetControlTypeClass: TControlTypeClass;
////begin
////  Result:=TSkinButtonGroupDefaultType;
////end;
//
//function TSkinButtonGroup.GetDrawButtonDetail1Param: TDrawTextParam;
//begin
//  Result:=ButtonMaterial.FDrawDetail1Param;
//end;
//
//function TSkinButtonGroup.GetDrawButtonDetailParam: TDrawTextParam;
//begin
//  Result:=ButtonMaterial.FDrawDetailParam;
//end;
//
//function TSkinButtonGroup.GetButtonDisabledPicture: TDrawPicture;
//begin
//  Result:=ButtonMaterial.FDisabledPicture;
//end;
//
//function TSkinButtonGroup.GetButtonDownPicture: TDrawPicture;
//begin
//  Result:=ButtonMaterial.FDownPicture;
//end;
//
//function TSkinButtonGroup.GetButtonFocusedPicture: TDrawPicture;
//begin
//  Result:=ButtonMaterial.FFocusedPicture;
//end;
//
//function TSkinButtonGroup.GetButtonHoverPicture: TDrawPicture;
//begin
//  Result:=ButtonMaterial.FHoverPicture;
//end;
//
//function TSkinButtonGroup.GetDrawButtonIconParam: TDrawPictureParam;
//begin
//  Result:=ButtonMaterial.FDrawIconParam;
//end;
//
////function TSkinButtonGroup.GetMaterialClass: TMaterialClass;
////begin
////  Result:=TSkinButtonGroupDefaultMaterial;
////end;
//
//function TSkinButtonGroup.GetMiddleButtonMaterial: TSkinButtonDefaultMaterial;
//begin
//  Result:=TSkinButtonDefaultMaterial(TSkinButtonGroupDefaultMaterial(FMaterial).FMiddleButtonMaterial);
//end;
//
//function TSkinButtonGroup.GetButtonNormalPicture: TDrawPicture;
//begin
//  Result:=ButtonMaterial.FNormalPicture;
//end;
//
//procedure TSkinButtonGroup.SetAutoSize(const Value: Boolean);
//begin
//  Self.Prop.AutoSize:=Value;
//end;
//
//procedure TSkinButtonGroup.SetButtonBackColorParam(const Value: TDrawRectParam);
//begin
//  ButtonMaterial.DrawBackColorParam:=Value;
//end;
//
//procedure TSkinButtonGroup.SetButtonGroupProperties(Value: TButtonGroupProperties);
//begin
//  Self.FProperties.Assign(Value);
//end;
//
//procedure TSkinButtonGroup.SetButtonSize(const Value: TControlSize);
//begin
//  Self.Prop.ButtonSize:=Value;
//end;
//
//procedure TSkinButtonGroup.SetLayoutType(const Value: TItemLayoutType);
//begin
//  case Value of
//    iltVertical: Self.Prop.Orientation:=boVert;
//    iltHorizontal: Self.Prop.Orientation:=boHorz;
//  end;
//end;
//
//procedure TSkinButtonGroup.SetDrawButtonCaptionParam(const Value: TDrawTextParam);
//begin
//  ButtonMaterial.DrawCaptionParam:=Value;
//end;
//
//procedure TSkinButtonGroup.SetDrawButtonDetail1Param(const Value: TDrawTextParam);
//begin
//  ButtonMaterial.DrawDetail1Param:=Value;
//end;
//
//procedure TSkinButtonGroup.SetDrawButtonDetailParam(const Value: TDrawTextParam);
//begin
//  ButtonMaterial.DrawDetailParam:=Value;
//end;
//
//procedure TSkinButtonGroup.SetButtonDisabledPicture(const Value: TDrawPicture);
//begin
//  ButtonMaterial.DisabledPicture:=Value;
//end;
//
//procedure TSkinButtonGroup.SetButtonDownPicture(const Value: TDrawPicture);
//begin
//  ButtonMaterial.DownPicture:=Value;
//end;
//
//procedure TSkinButtonGroup.SetButtonFocusedPicture(const Value: TDrawPicture);
//begin
//  ButtonMaterial.FocusedPicture:=Value;
//end;
//
//procedure TSkinButtonGroup.SetButtonHoverPicture(const Value: TDrawPicture);
//begin
//  ButtonMaterial.HoverPicture:=Value;
//end;
//
//procedure TSkinButtonGroup.SetDrawButtonIconParam(const Value: TDrawPictureParam);
//begin
//  ButtonMaterial.DrawIconParam:=Value;
//end;
//
//procedure TSkinButtonGroup.SetMiddleButtonMaterial(const Value: TSkinButtonDefaultMaterial);
//begin
//  TSkinButtonDefaultMaterial(TSkinButtonGroupDefaultMaterial(FMaterial).FMiddleButtonMaterial).Assign(Value);
//end;
//
//procedure TSkinButtonGroup.SetButtonNormalPicture(const Value: TDrawPicture);
//begin
//  ButtonMaterial.NormalPicture:=Value;
//end;
//
//procedure TSkinButtonGroup.SetDrawButtonPictureParam(const Value: TDrawPictureParam);
//begin
//  ButtonMaterial.DrawPictureParam:=Value;
//end;
//
//procedure TSkinButtonGroup.SetButtonPushedPicture(const Value: TDrawPicture);
//begin
//  ButtonMaterial.PushedPicture:=Value;
//end;
//
//procedure TSkinButtonGroup.FixChildButtonCount(const AButtonCount:Integer;
//                                              const APushedButtonIndex:Integer;
//                                              const AButtonClickEvent:TNotifyEvent);
//var
//  I: Integer;
//  MoreCount:Integer;
//  LessCount:Integer;
//  ASkinButton:TSkinButton;
//begin
//
//    if Self.Prop.ButtonCount<>AButtonCount then
//    begin
//
//        //多的就删除
//        MoreCount:=Self.Prop.ButtonCount-AButtonCount;
//        if MoreCount>0 then
//        begin
//            for I := MoreCount-1 downto 0 do
//            begin
//              ASkinButton:=TSkinButton(Self.Prop.Buttons[I]);
//              Self.Prop.FButtonList.Delete(I,False);
//
//              //先隐藏,避免释放不掉,还显示在上面
//              ASkinButton.Visible:=False;
//              ASkinButton.Parent:=nil;
//              FreeAndNil(ASkinButton);
//            end;
//        end
//        else
//        begin
//            //少的就创建
//            MoreCount:=-MoreCount;
//            for I := 0 to MoreCount-1 do
//            begin
//              ASkinButton:=TSkinButton.Create(Self);
//              ASkinButton.Caption:='';
//              ASkinButton.Parent:=Self;
//              ASkinButton.Prop.ButtonGroup:=Self;
//              //不保存,避免启动加载的时候报错
//              ASkinButton.Stored:=False;
//            end;
//        end;
//
//    end;
//
//
//
//
//    //设置自动按下
//    for I := 0 to Self.Prop.ButtonCount-1 do
//    begin
//
//        ASkinButton:=TSkinButton(Self.Prop.Buttons[I]);
//
//        if ASkinButton.Prop.PushedGroupIndex=0 then
//        begin
//          ASkinButton.Prop.PushedGroupIndex:=1;
//        end;
//        ASkinButton.Prop.IsAutoPush:=True;
//        ASkinButton.Prop.ButtonIndex:=I;
//        if I=APushedButtonIndex then
//        begin
//          ASkinButton.Prop.IsPushed:=True;
//        end;
//        ASkinButton.OnClick:=AButtonClickEvent;
//
//
//        //不保存,避免启动加载的时候报错
//        ASkinButton.Stored:=False;
//
//    end;
//
//
//    Self.Prop.FListLayoutsManager.DoItemSizeChange(nil);
//
//end;
//
//procedure TSkinButtonGroup.FreeChildButtons;
//var
//  I: Integer;
//  ASkinButton:TSkinButton;
//begin
//
//  if Prop<>nil then
//  begin
//    for I := Self.Prop.ButtonCount-1 downto 0 do
//    begin
//      ASkinButton:=TSkinButton(Self.Prop.Buttons[I]);
//      Self.Prop.FButtonList.Delete(I,False);
//
//      //先隐藏,避免释放不掉,还显示在上面
//      ASkinButton.Visible:=False;
//      ASkinButton.Parent:=nil;
//      FreeAndNil(ASkinButton);
//    end;
//  end;
//
//end;
//
//
//destructor TSkinButtonGroup.Destroy;
//begin
//
//  //释放子按钮
//  FreeChildButtons;
//
//  Inherited;
//end;
//
//
//
//
//
//{$ENDIF}

{ TSkinButtonList }

function TSkinButtonList.GetObject: TObject;
begin
  Result:=Self;
end;

function TSkinButtonList.GetSkinItem(const Index: Integer): ISkinItem;
begin
  Result:=TControl(Items[Index]) as ISkinItem;
end;

function TSkinButtonList.GetSkinObject(const Index: Integer): TObject;
begin
  Result:=Items[Index];
end;

procedure TSkinButtonList.DoChange;
begin
  inherited;

  if //Not IsLoading
//    and
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

procedure TSkinButtonList.EndUpdate(AIsForce: Boolean);
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

function TSkinButtonList.GetListLayoutsManager: TSkinListLayoutsManager;
begin
  Result:=FListLayoutsManager;
end;

function TSkinButtonList.GetUpdateCount: Integer;
begin
  Result:=0;
  if (Self.FSkinObjectChangeManager<>nil) then
  begin
    Result:= Self.FSkinObjectChangeManager.UpdateCount;
  end;
end;

procedure TSkinButtonList.SetListLayoutsManager(ALayoutsManager: TSkinListLayoutsManager);
begin
  FListLayoutsManager:=ALayoutsManager;
end;




{ TSkinChildButton }

function TBaseSkinButton.GetSelected: Boolean;
begin
  Result:=False;
end;

function TBaseSkinButton.GetThisRowItemCount: Integer;
begin
  Result:=0;
end;

//层级
function TBaseSkinButton.GetLevel:Integer;
begin
  Result:=0;
end;

//获取与设置自定义属性
function TBaseSkinButton.GetPropJsonStr:String;
begin
  Result:=Inherited;
end;

procedure TBaseSkinButton.SetPropJsonStr(AJsonStr:String);
var
  APropJson:ISuperObject;
begin
  Inherited;

  APropJson:=SO(AJsonStr);
  if APropJson.Contains('ReadOnly') then
  begin
    Self.Enabled:=not APropJson.B['ReadOnly'];
    Invalidate;
  end;

  if APropJson.Contains('IsSelectButton') then
  begin
    Self.IsSelectButton:=APropJson.B['IsSelectButton'];
  end;

end;


function TBaseSkinButton.LoadFromFieldControlSetting(ASetting: TFieldControlSetting;AFieldControlSettingMap:TObject): Boolean;
begin
  Setting:=ASetting;
  Caption:=ASetting.field_caption;

//  {$IFDEF FMX}
//  IsSelectButton:=True;
//  {$ENDIF}
//
//  {$IFDEF VCL}
  IsSelectButton:=False;
//  {$ENDIF}




//  Result:=Inherited;
//
//  if (ASetting.ControlStyle='') and (ASetting.Action<>'') then
//  begin
//    //根据按钮的功能来设置按钮的素材风格
//    SetMaterialName(ASetting.Action);
//  end;
  Result:=True;
end;

procedure TBaseSkinButton.SetItemDrawRect(Value: TRectF);
begin
  FItemDrawRect:=Value;
end;

function TBaseSkinButton.GetIsRowEnd:Boolean;
begin
  Result:=False;
end;

procedure TBaseSkinButton.SetSkinListIntf(ASkinListIntf: ISkinList);
begin
  FSkinListIntf:=ASkinListIntf;
end;

procedure TBaseSkinButton.TranslateControlLang(APrefix: String; ALang: TLang;
  ACurLang: String);
begin
  inherited;

  if GetLangValue(ALang,APrefix+Name+'.Detail',ACurLang)<>'' then
  begin
    Detail:=GetLangValue(ALang,APrefix+Name+'.Detail',ACurLang);
  end;

  if GetLangValue(ALang,APrefix+Name+'.Detail1',ACurLang)<>'' then
  begin
    Detail1:=GetLangValue(ALang,APrefix+Name+'.Detail1',ACurLang);
  end;

  if GetLangValue(ALang,APrefix+Name+'.HelpText',ACurLang)<>'' then
  begin
    Prop.HelpText:=GetLangValue(ALang,APrefix+Name+'.HelpText',ACurLang);
  end;
end;

function TBaseSkinButton.GetListLayoutsManager:TSkinListLayoutsManager;
begin
  Result:=FSkinListIntf.GetListLayoutsManager;
end;

procedure TBaseSkinButton.ClearItemRect;
begin

end;

procedure TBaseSkinButton.SetItemRect(Value: TRectF);
begin
  FItemRect:=Value;
  Self.SetBounds(Value);
end;

function TBaseSkinButton.GetItemDrawRect: TRectF;
begin
  Result:=FItemDrawRect;
end;

function TBaseSkinButton.GetItemRect: TRectF;
begin
  Result:=FItemRect;
end;


function TBaseSkinButton.GetObject: TObject;
begin
  Result:=Self;
end;

function TBaseSkinButton.GetWidth:Double;
begin
  Result:=Width;
end;

function TBaseSkinButton.GetHeight:Double;
begin
  Result:=Height;
end;

function TBaseSkinButton.Material:TSkinButtonDefaultMaterial;
begin
  Result:=TSkinButtonDefaultMaterial(SelfOwnMaterial);
end;

function TBaseSkinButton.PtInItem(APoint: TPointF): Boolean;
begin
  Result:=PtInRect(Self.FItemDrawRect,APoint);

end;

function TBaseSkinButton.CurrentUseMaterialToDefault:TSkinButtonDefaultMaterial;
begin
  Result:=TSkinButtonDefaultMaterial(CurrentUseMaterial);
end;

function TBaseSkinButton.SelfOwnMaterialToDefault:TSkinButtonDefaultMaterial;
begin
  Result:=TSkinButtonDefaultMaterial(SelfOwnMaterial);
end;

function TBaseSkinButton.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TButtonProperties;
end;

procedure TBaseSkinButton.ReadState(Reader: TReader);
var
  ASkinButtonGroupIntf:ISkinButtonGroup;
begin
  inherited ReadState(Reader);


  //自动的指定Button的Parent为按钮组
  if (Reader.Parent<>nil)
    and (Reader.Parent.GetInterface(IID_ISkinButtonGroup,ASkinButtonGroupIntf)) then
  begin
    Self.Properties.ButtonGroup:=TSkinBaseButtonGroup(Reader.Parent);
  end;

end;

procedure TBaseSkinButton.RecordControlLangIndex(APrefix: String; ALang: TLang;
  ACurLang: String);
begin
  inherited;

  if Detail<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.Detail',ACurLang,Detail);
  end;

  if Detail1<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.Detail1',ACurLang,Detail1);
  end;

  if Self.Prop.HelpText<>'' then
  begin
    RecordLangIndex(ALang,APrefix+Name+'.HelpText',ACurLang,Self.Prop.HelpText);
  end;
end;

function TBaseSkinButton.GetButtonProperties: TButtonProperties;
begin
  Result:=TButtonProperties(Self.FProperties);
end;

procedure TBaseSkinButton.SetButtonProperties(Value: TButtonProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TBaseSkinButton.SetControlValueByBindItemField(
  const AFieldName: String; const AFieldValue: Variant; ASkinItem: TObject;
  AIsDrawItemInteractiveState: Boolean);
begin
  Caption:=AFieldValue;
end;

procedure TBaseSkinButton.SetControlObjectByBindItemField(const AFieldName: String;
  const AFieldValue: TObject; ASkinItem: TObject;
  AIsDrawItemInteractiveState: Boolean);
begin
  //有图片
//  if (Self.Prop.Picture.StaticPictureDrawType<>pdtReference) or (Self.Prop.Picture.StaticPictureDrawType<>pdtRefDrawPicture) then


  Self.Prop.Icon.StaticPictureDrawType:=pdtReference;


  if AFieldValue<>nil then
  begin

      //是否圆形根据图片控件设置
      TSkinPicture(AFieldValue).IsClipRound:=Self.Prop.Icon.IsClipRound or TSkinPicture(AFieldValue).IsClipRound;


      if (AFieldValue is TBaseDrawPicture) and (TBaseDrawPicture(AFieldValue).PictureDrawType=pdtRefDrawPicture) then
      begin
        Self.Prop.Icon.StaticPictureDrawType:=pdtRefDrawPicture;
        Self.Prop.Icon.StaticRefDrawPicture:=TDrawPicture(AFieldValue);
      end
      else if AFieldValue is TBaseDrawPicture then
      begin
        Self.Prop.Icon.StaticRefPicture:=TDrawPicture(AFieldValue).CurrentPicture;
      end
      else
      begin
        Self.Prop.Icon.StaticRefPicture:=TSkinPicture(AFieldValue);
      end;

  end
  else
  begin
      Self.Prop.Icon.StaticRefPicture:=nil;
  end;
end;

procedure TBaseSkinButton.SetDetail(const Value:String);
begin
  if FDetail<>Value then
  begin
    FDetail:=Value;
    Invalidate;
  end;
end;

procedure TBaseSkinButton.SetDetail1(const Value:String);
begin
  if FDetail1<>Value then
  begin
    FDetail1:=Value;
    Invalidate;
  end;
end;

procedure TBaseSkinButton.Click;
begin
  if Self.GetButtonProperties.IsAutoPush then
  begin
    Self.GetButtonProperties.IsPushed:=Not Self.GetButtonProperties.IsPushed;
    inherited;
  end
  else
  begin
    inherited;
  end;
end;

function TBaseSkinButton.GetDetail:String;
begin
  Result:=FDetail;
end;

function TBaseSkinButton.GetDetail1:String;
begin
  Result:=FDetail1;
end;

procedure TBaseSkinButton.DoCustomSkinMaterialChange(Sender: TObject);
begin
  //自动设置尺寸
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetButtonProperties.AdjustAutoSizeBounds;
  end;

  Inherited;
end;

procedure TBaseSkinButton.BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
begin
  //为什么要Caption,
  Caption:=AText;
end;

function TBaseSkinButton.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String): Variant;
begin
//  Result:=BoolToStr(Self.Prop.Checked);
//begin
//  //显示不出
//  Result:=Ord(Self.Prop.Checked);


//  //wn
//  if IsSelectButton then
//  begin

  if Setting.search_operator<>'' then
  begin
    if Self.Prop.IsPushed then
    begin
      Result:=Value;
    end
    else
    begin
      Result:='';
    end;
  end
  else
  begin
//    //内部ID
    Result:=Value;
  end;

//  end
//  else
//  begin
//    Result:=Value;
//  end;



end;

procedure TBaseSkinButton.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
//  if (ASetting.options_caption_field_name='') or (AGetDataIntfResultFieldValueIntf=nil) then
//  begin
//    Text:=AValue;
//    Value:='';
//  end
//  else
//  begin


  if IsSelectButton then
  begin
    //用于保存选择后的内部ID
    //Value:=AValue;



    Caption:=AValueCaption;
    Value:=AValue;
  end
  else
  begin
//    //标题
//    Text:=AValue;//AValueCaption;//AGetDataIntfResultFieldValueIntf.GetFieldValue(ASetting.options_caption_field_name);

    Value:=AValue;
  end;



//  end;
//  if AValue<>'' then
//  begin
//    Self.Prop.Checked:=StrToBool(AValue);
//  end
//  else
//  begin
//    Self.Prop.Checked:=False;
//  end;
end;


{ TSkinButtonGroup }

function TBaseSkinButtonGroup.SelfOwnMaterialToDefault:TSkinButtonGroupDefaultMaterial;
begin
  Result:=TSkinButtonGroupDefaultMaterial(SelfOwnMaterial);
end;


function TBaseSkinButtonGroup.Material:TSkinButtonGroupDefaultMaterial;
begin
  Result:=TSkinButtonGroupDefaultMaterial(SelfOwnMaterial);
end;
function  TBaseSkinButtonGroup.CurrentUseMaterialToDefault:TSkinButtonGroupDefaultMaterial;
begin
  Result:=TSkinButtonGroupDefaultMaterial(CurrentUseMaterial);
end;

function TBaseSkinButtonGroup.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TButtonGroupProperties;
end;

function TBaseSkinButtonGroup.GetButtonGroupProperties: TButtonGroupProperties;
begin
  Result:=TButtonGroupProperties(Self.FProperties);
end;

procedure TBaseSkinButtonGroup.SetButtonGroupProperties(Value: TButtonGroupProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TBaseSkinButtonGroup.FixChildButtonCount(const AButtonCount:Integer;
                                                                                        const APushedButtonIndex:Integer;
                                                                                        const AButtonClickEvent:TNotifyEvent);
var
  I: Integer;
  MoreCount:Integer;
  LessCount:Integer;
  ASkinButton:TSkinChildButton;
begin

    if Self.Properties.ButtonCount<>AButtonCount then
    begin

        //多的就删除
        MoreCount:=Self.Properties.ButtonCount-AButtonCount;
        if MoreCount>0 then
        begin
            for I := MoreCount-1 downto 0 do
            begin
              ASkinButton:=TSkinChildButton(Self.Properties.Buttons[I]);
              Self.Prop.ButtonList.Delete(I,False);

              //先隐藏,避免释放不掉,还显示在上面
              ASkinButton.Visible:=False;
              ASkinButton.Parent:=nil;
              FreeAndNil(ASkinButton);
            end;
        end
        else
        begin
            //少的就创建
            MoreCount:=-MoreCount;
            for I := 0 to MoreCount-1 do
            begin
              ASkinButton:=CreateChildButton(Self);
              ASkinButton.Caption:='';
              ASkinButton.Parent:=Self;
              ASkinButton.Properties.ButtonGroup:=Self;

              {$IFDEF FMX}
              //不保存,避免启动加载的时候报错
              ASkinButton.Stored:=False;
              {$ENDIF FMX}
            end;
        end;

    end;


    //设置自动按下
    for I := 0 to Self.Properties.ButtonCount-1 do
    begin

        ASkinButton:=TSkinChildButton(Self.Properties.Buttons[I]);

        if ASkinButton.Properties.PushedGroupIndex=0 then
        begin
          ASkinButton.Properties.PushedGroupIndex:=1;
        end;
        ASkinButton.Properties.IsAutoPush:=True;
        ASkinButton.Properties.ButtonIndex:=I;
        {$IFDEF FMX}
        ASkinButton.HitTest:=True;
        {$ENDIF}
        if I=APushedButtonIndex then
        begin
          ASkinButton.Properties.IsPushed:=True;
        end;
        ASkinButton.OnClick:=AButtonClickEvent;

        {$IFDEF FMX}
        //不保存,避免启动加载的时候报错
        ASkinButton.Stored:=False;
        {$ENDIF FMX}

    end;


    Self.Properties.LayoutsManager.DoItemSizeChange(nil);

end;

procedure TBaseSkinButtonGroup.FreeChildButtons;
var
  I: Integer;
  ASkinButton:TSkinChildButton;
begin

  if Properties<>nil then
  begin
    Self.Properties.ButtonList.BeginUpdate;
    try
      for I := Self.Properties.ButtonCount-1 downto 0 do
      begin
        ASkinButton:=TSkinChildButton(Self.Properties.Buttons[I]);
        Self.Prop.ButtonList.Delete(I,False);


        //先隐藏,避免释放不掉,还显示在上面
        ASkinButton.Visible:=False;
        ASkinButton.Parent:=nil;


        //Parent释放的时候自己会释放
        if ASkinButton.Owner=Self then
        begin
          try
            FreeAndNil(ASkinButton);
          except
            on E:Exception do
            begin
              uBaseLog.HandleException(E,'OrangeUI TBaseSkinButtonGroup.FreeChildButtons');
            end;
          end;
        end;
      end;
    finally
      Self.Properties.ButtonList.EndUpdate;
    end;
  end;

end;


destructor TBaseSkinButtonGroup.Destroy;
begin

  //释放子按钮
  FreeChildButtons;

  Inherited;
end;


procedure TBaseSkinButtonGroup.Loaded;
begin
  Inherited;

  Self.Properties.ButtonList.EndUpdate(True);
  Self.Properties.LayoutsManager.DoItemVisibleChange(nil);
end;

procedure TBaseSkinButtonGroup.ReadState(Reader: TReader);
begin
  Self.Properties.ButtonList.BeginUpdate;

  inherited ReadState(Reader);
end;


{ TSkinSelectDateAreaButton }

procedure TSkinSelectDateAreaButton.SetEndDate(const Value: String);
begin
  FEndDate := Value;
  SyncCaption;
end;

procedure TSkinSelectDateAreaButton.SetStartDate(const Value: String);
begin
  FStartDate := Value;
  SyncCaption;
end;

procedure TSkinSelectDateAreaButton.SyncCaption;
begin
//  Caption:=FormatDateTime('YYYY-MM-DD',FStartDate)+'至'+FormatDateTime('YYYY-MM-DD',FEndDate);
  if (FStartDate='') and (FEndDate='') then
  begin
    Caption:='';
  end
  else
  begin
    Caption:=FStartDate+'至'+FEndDate;
  end;
end;


end.




