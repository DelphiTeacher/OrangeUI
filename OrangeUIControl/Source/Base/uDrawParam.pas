//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     绘制参数基类
///   </para>
///   <para>
///     Base classes of drawing Parameter
///   </para>
/// </summary>
unit uDrawParam;


interface
{$I FrameWork.inc}

uses
  Classes,
  Types,
  Math,
  SysUtils,
  uBaseList,

  {$IFDEF FMX}
  FMX.Effects,
  FMX.Graphics,
  {$ENDIF}


//  XSuperObject,


  uGraphicCommon,
  uFuncCommon,
  uBinaryTreeDoc;


const
  //默认效果的透明度
  Const_DefaultEffect_Alpha=180;
  //默认效果的偏移值
  Const_DefaultEffect_Offset=1;


type
  TDrawParam=class;


  /// <summary>
  ///   <para>
  ///     尺寸类型
  ///   </para>
  ///   <para>
  ///     Size Type
  ///   </para>
  /// </summary>
  TDPSizeType=(
              /// <summary>
              ///   以像素为单位
              ///   <para>
              ///    Use pixel as unit
              ///   </para>
              /// </summary>
              dpstPixel,
              /// <summary>
              ///   以百分比为单位
              ///   <para>
              ///     Use percentage as unit
              ///   </para>
              /// </summary>
              dpstPercent
              );



  //对齐类型
  TSkinAlign=(
              salLeading,
              salCenter,
              salTrailing
              );





  /// <summary>
  ///   <para>
  ///     水平位置类型
  ///   </para>
  ///   <para>
  ///     Type of horizontal position
  ///   </para>
  /// </summary>
  TDPPositionHorzType=(
                      /// <summary>
                      ///   默认
                      ///   <para>
                      ///    Default
                      ///   </para>
                      /// </summary>
                      dpphtNone,
                      /// <summary>
                      ///   左
                      ///   <para>
                      ///    Left
                      ///   </para>
                      /// </summary>
                      dpphtLeft,
                      /// <summary>
                      ///   中
                      ///   <para>
                      ///     Center
                      ///   </para>
                      /// </summary>
                      dpphtCenter,
                      /// <summary>
                      ///   右
                      ///   <para>
                      ///     Right
                      ///   </para>
                      /// </summary>
                      dpphtRight
                      );





  /// <summary>
  ///   <para>
  ///     垂直位置类型
  ///   </para>
  ///   <para>
  ///     Type of vertical position
  ///   </para>
  /// </summary>
  TDPPositionVertType=(
                        /// <summary>
                        ///   默认
                        ///   <para>
                        ///     Default
                        ///   </para>
                        /// </summary>
                        dppvtNone,
                        /// <summary>
                        ///   上
                        ///   <para>
                        ///     Top
                        ///   </para>
                        /// </summary>
                        dppvtTop,
                        /// <summary>
                        ///   中
                        ///   <para>
                        ///     Center
                        ///   </para>
                        /// </summary>
                        dppvtCenter,
                        /// <summary>
                        ///   下
                        ///   <para>
                        ///     Bottom
                        ///   </para>
                        /// </summary>
                        dppvtBottom
                        );




  /// <summary>
  ///   <para>
  ///     效果状态
  ///   </para>
  ///   <para>
  ///     Effect state
  ///   </para>
  /// </summary>
  TDPEffectState=(
                  /// <summary>
                  ///   鼠标按下
                  ///   <para>
                  ///     Mouse click
                  ///   </para>
                  /// </summary>
                  dpstMouseDown,
                  /// <summary>
                  ///   鼠标停靠
                  ///   <para>
                  ///     Mouse hover
                  ///   </para>
                  /// </summary>
                  dpstMouseOver,
                  /// <summary>
                  ///   按下状态
                  ///   <para>
                  ///     Pressed state
                  ///   </para>
                  /// </summary>
                  dpstPushed,
                  /// <summary>
                  ///   得到焦点
                  ///   <para>
                  ///    Get focus
                  ///   </para>
                  /// </summary>
                  dpstFocused,
                  /// <summary>
                  ///   禁用状态
                  ///   <para>
                  ///    Disabled
                  ///   </para>
                  /// </summary>
                  dpstDisabled
                  );
  TDPEffectStates=set of TDPEffectState;




  /// <summary>
  ///   <para>
  ///     通用效果类型
  ///   </para>
  ///   <para>
  ///     Type of Common Effect
  ///   </para>
  /// </summary>
  TDPCommonEffectType=(

                       /// <summary>
                       ///   绘制坐标偏移
                       ///   <para>
                       ///     Draw coordinate offset
                       ///   </para>
                       /// </summary>
                       dpcetOffsetChange,
                       /// <summary>
                       ///   透明度更改
                       ///   <para>
                       ///     Alpha change
                       ///   </para>
                       /// </summary>
                       dpcetAlphaChange,
                       //阴影尺寸改变
                       dpcetShadowSizeChange
                       );
  /// <summary>
  ///   <para>
  ///     通用效果类型集
  ///   </para>
  ///   <para>
  ///     Set of Common Effect Types
  ///   </para>
  /// </summary>
  TDPCommonEffectTypes=set of TDPCommonEffectType;






  /// <summary>
  ///   <para>
  ///     绘制矩形设置(用于处理复杂的绘制逻辑)
  ///   </para>
  ///   <para>
  ///     Setting of drawing rectangle(used for dealing with complex drawing
  ///     logic)
  ///   </para>
  /// </summary>
  TDrawRectSetting=class(TInterfacedPersistent,ISupportClassDocNode)
  private
    FLeft:Double;
    FTop:Double;
    FRight: Double;
    FBottom: Double;
    FWidth:Double;
    FHeight:Double;

    FEnabled: Boolean;

    FOnChange:TNotifyEvent;

    FSizeType:TDPSizeType;

    FPositionHorzType:TDPPositionHorzType;
    FPositionVertType:TDPPositionVertType;

    procedure SetLeft(const Value: Double);
    procedure SetTop(const Value: Double);
    procedure SetRight(const Value: Double);
    procedure SetBottom(const Value: Double);
    procedure SetWidth(const Value: Double);
    procedure SetHeight(const Value: Double);

    procedure SetEnabled(const Value: Boolean);
    procedure SetSizeType(const Value: TDPSizeType);
    procedure SetPositionHorzType(const Value: TDPPositionHorzType);
    procedure SetPositionVertType(const Value: TDPPositionVertType);


    function IsBottomStored: Boolean;
    function IsEnabledStored: Boolean;
    function IsHeightStored: Boolean;
    function IsLeftStored: Boolean;
    function IsPositionHorzTypeStored: Boolean;
    function IsPositionVertTypeStored: Boolean;
    function IsRightStored: Boolean;
    function IsSizeTypeStored: Boolean;
    function IsTopStored: Boolean;
    function IsWidthStored: Boolean;
  protected
    procedure AssignTo(Dest: TPersistent); override;

  protected
    //执行更改事件
    procedure DoChange(Const AIsForce:Boolean=False);
  public
//    function LoadFromJson(ASuperObject:ISuperObject):Boolean;
//    function SaveToJson(ASuperObject:ISuperObject):Boolean;
  public
    /// <summary>
    ///   <para>
    ///     初始化参数
    ///   </para>
    ///   <para>
    ///     Initialize Parameters
    ///   </para>
    /// </summary>
    procedure Clear;virtual;

    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;

    /// <summary>
    ///   <para>
    ///     保存到文档节点
    ///   </para>
    ///   <para>
    ///     Save to document node
    ///   </para>
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  public
    constructor Create;virtual;
    destructor Destroy;override;
  public
    /// <summary>
    ///   <para>
    ///     设置位置和尺寸
    ///   </para>
    ///   <para>
    ///     Set position and size
    ///   </para>
    /// </summary>
    procedure SetBounds(ALeft,ATop,AWidth,AHeight:Double);

    /// <summary>
    ///   <para>
    ///     设置位置和边距
    ///   </para>
    ///   <para>
    ///     Set position and margin
    ///   </para>
    /// </summary>
    procedure SetMargins(ALeft,ATop,ARight,ABottom:Double);

    /// <summary>
    ///   <para>
    ///     更改的事件
    ///   </para>
    ///   <para>
    ///     Changed Event
    ///   </para>
    /// </summary>
    property OnChange:TNotifyEvent read FOnChange write FOnChange;

    /// <summary>
    ///   <para>
    ///     计算绘制的区域
    ///   </para>
    ///   <para>
    ///     Calculate DrawArea
    ///   </para>
    /// </summary>
    function CalcDrawRect(Const AControlRect:TRectF):TRectF;
  published

    /// <summary>
    ///   <para>
    ///     绘制矩形的水平位置
    ///   </para>
    ///   <para>
    ///     Position of drawing rectangle
    ///   </para>
    /// </summary>
    property Left:Double read FLeft write SetLeft stored IsLeftStored;
    /// <summary>
    ///   <para>
    ///     绘制矩形的垂直位置
    ///   </para>
    ///   <para>
    ///     Position of drawing rectangle
    ///   </para>
    /// </summary>
    property Top:Double read FTop write SetTop stored IsTopStored;
    /// <summary>
    ///   <para>
    ///     绘制矩形的右边距
    ///   </para>
    ///   <para>
    ///     Right margin of drawing rectangle
    ///   </para>
    /// </summary>
    property Right:Double read FRight write SetRight stored IsRightStored;
    /// <summary>
    ///   <para>
    ///     绘制矩形的底边距
    ///   </para>
    ///   <para>
    ///     Bottom margin of drawing rectangle
    ///   </para>
    /// </summary>
    property Bottom:Double read FBottom write SetBottom stored IsBottomStored;


    /// <summary>
    ///   <para>
    ///     绘制矩形的宽度
    ///   </para>
    ///   <para>
    ///     Width of drawing rectangle
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   <para>
    ///     如果为0,则是整个控件宽度
    ///   </para>
    ///   <para>
    ///     If it is 0,then the width is same as whole control's width
    ///   </para>
    /// </remarks>
    property Width:Double read FWidth write SetWidth stored IsWidthStored;
    /// <summary>
    ///   <para>
    ///     绘制矩形的高度
    ///   </para>
    ///   <para>
    ///     Height of drawing rectangle
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   <para>
    ///     如果是0，则是整个控件高度
     ///   </para>
    ///   <para>
    ///     If it is 0,then the width is same as whole control's width
    ///   </para>
    /// </remarks>
    property Height:Double read FHeight write SetHeight stored IsHeightStored;




    /// <summary>
    ///   <para>
    ///     是否启用
    ///   </para>
    ///   <para>
    ///     Whether Enable
    ///   </para>
    /// </summary>
    property Enabled:Boolean read FEnabled write SetEnabled stored IsEnabledStored;


    /// <summary>
    ///   <para>
    ///     尺寸类型
    ///   </para>
    ///   <para>
    ///     Size Type
    ///   </para>
    /// </summary>
    property SizeType:TDPSizeType read FSizeType write SetSizeType stored IsSizeTypeStored;


    /// <summary>
    ///   <para>
    ///     水平位置类型
    ///   </para>
    ///   <para>
    ///     Type of Horizontal Position
    ///   </para>
    /// </summary>
    property PositionHorzType:TDPPositionHorzType read FPositionHorzType write SetPositionHorzType stored IsPositionHorzTypeStored;
    /// <summary>
    ///   <para>
    ///     垂直位置类型
    ///   </para>
    ///   <para>
    ///     Type of Vertical Position
    ///   </para>
    /// </summary>
    property PositionVertType:TDPPositionVertType read FPositionVertType write SetPositionVertType stored IsPositionVertTypeStored;
  end;










  //效果设置类的类型
  TDrawParamCommonEffectClass=class of TDrawParamCommonEffect;
  //效果设置类的类型
  TDrawEffectSettingClass=class of TDrawEffectSetting;
  //设置类的类型
  TDrawParamSettingClass=class of TDrawParamSetting;





  /// <summary>
  ///   <para>
  ///     通用效果
  ///   </para>
  ///   <para>
  ///     Common Effect
  ///   </para>
  /// </summary>
  TDrawParamCommonEffect=class(TInterfacedPersistent,ISupportClassDocNode)
  private
    //透明度
    FAlpha: Byte;
    //位移
    FOffset: Double;

    FShadowSize: Double;
    //更改的事件
    FOnChange:TNotifyEvent;
    //效果种类
    FCommonEffectTypes: TDPCommonEffectTypes;
  private
    function IsAlphaStored:Boolean;
    function IsOffsetStored:Boolean;
    function IsCommonEffectTypesStored:Boolean;
  protected
    /// <summary>
    ///   <para>
    ///     结合按下状态和鼠标点击状态的效果
    ///   </para>
    ///   <para>
    ///     Combine the effect of pressed state and mouse click state
    ///   </para>
    /// </summary>
    procedure Mix(AEffect,BEffect:TDrawParamCommonEffect);virtual;

    /// <summary>
    ///   <para>
    ///     复制
    ///   </para>
    ///   <para>
    ///     Copy
    ///   </para>
    /// </summary>
    procedure AssignTo(Dest: TPersistent); override;

    /// <summary>
    ///   <para>
    ///     更改
    ///   </para>
    ///   <para>
    ///     Change
    ///   </para>
    /// </summary>
    procedure DoChange(Sender:TObject=nil);
  public
    constructor Create;virtual;
    destructor Destroy;override;
  public
    /// <summary>
    ///   <para>
    ///     初始化参数
    ///   </para>
    ///   <para>
    ///     Initialize Parameters
    ///   </para>
    /// </summary>
    procedure Clear;virtual;
    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;virtual;
    /// <summary>
    ///   <para>
    ///     保存到文档节点
    ///   </para>
    ///   <para>
    ///     Save to document node
    ///   </para>
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;virtual;
    /// <summary>
    ///   <para>
    ///     是否包含效果
    ///   </para>
    ///   <para>
    ///     Whether have effect
    ///   </para>
    /// </summary>
    function HasEffectTypes:Boolean;virtual;
  public
//    function LoadFromJson(ASuperObject:ISuperObject):Boolean;virtual;
//    function SaveToJson(ASuperObject:ISuperObject):Boolean;virtual;
    property ShadowSize:Double read FShadowSize write FShadowSize;
  published
    /// <summary>
    ///   <para>
    ///     绘制透明度
    ///   </para>
    ///   <para>
    ///     Draw Alpha
    ///   </para>
    /// </summary>
    property Alpha:Byte read FAlpha write FAlpha stored IsAlphaStored;
    /// <summary>
    ///   <para>
    ///     绘制偏移
    ///   </para>
    ///   <para>
    ///     Draw Offset
    ///   </para>
    /// </summary>
    property Offset:Double read FOffset write FOffset stored IsOffsetStored;

    /// <summary>
    ///   <para>
    ///     通用效果类型集合,一个状态可以有多个效果
    ///   </para>
    ///   <para>
    ///     Set of Common Effect Type,one state can have several types
    ///   </para>
    /// </summary>
    property CommonEffectTypes:TDPCommonEffectTypes read FCommonEffectTypes write FCommonEffectTypes stored IsCommonEffectTypesStored;//default [];
  end;











  /// <summary>
  ///   <para>
  ///     绘制效果设置
  ///   </para>
  ///   <para>
  ///     Setting of drawing effect
  ///   </para>
  /// </summary>
  TDrawEffectSetting=class(TInterfacedPersistent,ISupportClassDocNode)
  protected
    FOnChange:TNotifyEvent;


    //禁用状态的效果
    FDisabledEffect: TDrawParamCommonEffect;
    //获得焦点的效果
    FFocusedEffect: TDrawParamCommonEffect;

    //按下状态的效果
    FPushedEffect: TDrawParamCommonEffect;
    //鼠标停靠状态的效果
    FMouseOverEffect: TDrawParamCommonEffect;
    //鼠标点击状态的效果
    FMouseDownEffect: TDrawParamCommonEffect;


    function IsIsMixedMouseDownAndPushedEffectStored: Boolean;
    procedure SetMouseDownEffect(const Value: TDrawParamCommonEffect);
    procedure SetMouseOverEffect(const Value: TDrawParamCommonEffect);
    procedure SetPushedEffect(const Value: TDrawParamCommonEffect);
    procedure SetDisabledEffect(const Value: TDrawParamCommonEffect);
    procedure SetFocusedEffect(const Value: TDrawParamCommonEffect);

  protected
    //结合的效果
    FMixedEffect: TDrawParamCommonEffect;
    //是否结合按下和鼠标点击的效果
    FIsMixedMouseDownAndPushedEffect:Boolean;

  protected
    //更改
    procedure DoChange(Sender:TObject=nil);
    //赋值
    procedure AssignTo(Dest: TPersistent); override;

    function GetDrawParamEffectClass:TDrawParamCommonEffectClass;virtual;
  public
//    function LoadFromJson(ASuperObject:ISuperObject):Boolean;
//    function SaveToJson(ASuperObject:ISuperObject):Boolean;
  public
    constructor Create;virtual;
    destructor Destroy;override;
  public
    /// <summary>
    ///   <para>
    ///     初始化参数
    ///   </para>
    ///   <para>
    ///     Initialize Parameters
    ///   </para>
    /// </summary>
    procedure Clear;virtual;
    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    /// <summary>
    ///   <para>
    ///     保存到文档节点
    ///   </para>
    ///   <para>
    ///     Save to document node
    ///   </para>
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
    /// <summary>
    ///   <para>
    ///     更改的事件
    ///   </para>
    ///   <para>
    ///     Changed Event
    ///   </para>
    /// </summary>
    property OnChange:TNotifyEvent read FOnChange write FOnChange;
  published
    /// <summary>
    ///   <para>
    ///     是否结合按下和鼠标点击的效果(按下状态,还要加点击下移或透明度更改的效果)
    ///   </para>
    ///   <para>
    ///     Whether combine pressed effect and mouse click effect(pressed
    ///     state plus click move down effect or alpha change effect)
    ///   </para>
    /// </summary>
    property IsMixedMouseDownAndPushedEffect:Boolean read FIsMixedMouseDownAndPushedEffect write FIsMixedMouseDownAndPushedEffect stored IsIsMixedMouseDownAndPushedEffectStored;
    /// <summary>
    ///   <para>
    ///     鼠标按下效果
    ///   </para>
    ///   <para>
    ///     Effect of mouse down
    ///   </para>
    /// </summary>
    property MouseDownEffect:TDrawParamCommonEffect read FMouseDownEffect write SetMouseDownEffect;
    /// <summary>
    ///   <para>
    ///     鼠标停靠效果
    ///   </para>
    ///   <para>
    ///     Effect of mouse hover
    ///   </para>
    /// </summary>
    property MouseOverEffect:TDrawParamCommonEffect read FMouseOverEffect write SetMouseOverEffect;
    /// <summary>
    ///   <para>
    ///     按下状态效果
    ///   </para>
    ///   <para>
    ///     Effect of pressed state
    ///   </para>
    /// </summary>
    property PushedEffect:TDrawParamCommonEffect read FPushedEffect write SetPushedEffect;
    /// <summary>
    ///   <para>
    ///     禁用状态效果
    ///   </para>
    ///   <para>
    ///     Effect of disabled state
    ///   </para>
    /// </summary>
    property DisabledEffect:TDrawParamCommonEffect read FDisabledEffect write SetDisabledEffect;
    property FocusedEffect:TDrawParamCommonEffect read FFocusedEffect write SetFocusedEffect;
  end;





  //绘制参数设置
  TDrawParamSetting=class(TInterfacedPersistent)
  private
    function IsDrawRectCustomStored: Boolean;

    function IsDrawRectBottomStored: Boolean;
    function IsDrawRectHeightStored: Boolean;
    function IsDrawRectHorzAlignStored: Boolean;
    function IsDrawRectLeftStored: Boolean;
    function IsDrawRectRightStored: Boolean;
    function IsDrawRectSizeTypeStored: Boolean;
    function IsDrawRectTopStored: Boolean;
    function IsDrawRectVertAlignStored: Boolean;
    function IsDrawRectWidthStored: Boolean;


    function IsMouseDownAlphaChangeStored: Boolean;
    function IsMouseDownAlphaStored: Boolean;
    function IsMouseDownOffsetChangeStored: Boolean;
    function IsMouseDownOffsetStored: Boolean;
    function IsMouseOverAlphaChangeStored: Boolean;
    function IsMouseOverAlphaStored: Boolean;
    function IsMouseOverOffsetChangeStored: Boolean;
    function IsMouseOverOffsetStored: Boolean;
    function IsPushedAlphaChangeStored: Boolean;
    function IsPushedAlphaStored: Boolean;
    function IsPushedOffsetChangeStored: Boolean;
    function IsPushedOffsetStored: Boolean;
  protected
    FDrawParam:TDrawParam;

    function GetMouseDownAlpha: Byte;
    function GetMouseDownAlphaChange: Boolean;
    function GetMouseDownOffset: Double;
    function GetMouseDownOffsetChange: Boolean;
    function GetMouseOverAlpha: Byte;
    function GetMouseOverAlphaChange: Boolean;
    function GetMouseOverOffset: Double;
    function GetMouseOverOffsetChange: Boolean;
    function GetPushedAlpha: Byte;
    function GetPushedAlphaChange: Boolean;
    function GetPushedOffset: Double;
    function GetPushedOffsetChange: Boolean;
    procedure SetMouseDownAlpha(const Value: Byte);
    procedure SetMouseDownAlphaChange(const Value: Boolean);
    procedure SetMouseDownOffset(const Value: Double);
    procedure SetMouseDownOffsetChange(const Value: Boolean);
    procedure SetMouseOverAlpha(const Value: Byte);
    procedure SetMouseOverAlphaChange(const Value: Boolean);
    procedure SetMouseOverOffset(const Value: Double);
    procedure SetMouseOverOffsetChange(const Value: Boolean);
    procedure SetPushedAlpha(const Value: Byte);
    procedure SetPushedAlphaChange(const Value: Boolean);
    procedure SetPushedOffset(const Value: Double);
    procedure SetPushedOffsetChange(const Value: Boolean);


    function GetDrawRectBottom: Double;
//    function GetDrawRectCustom: Boolean;
    function GetDrawRectHeight: Double;
    function GetDrawRectHorzAlign: TSkinAlign;
    function GetDrawRectLeft: Double;
    function GetDrawRectRight: Double;
    function GetDrawRectSizeType: TDPSizeType;
    function GetDrawRectTop: Double;
    function GetDrawRectVertAlign: TSkinAlign;
    function GetDrawRectWidth: Double;
    procedure SetDrawRectBottom(const Value: Double);
//    procedure SetDrawRectCustom(const Value: Boolean);
    procedure SetDrawRectHeight(const Value: Double);
    procedure SetDrawRectHorzAlign(const Value: TSkinAlign);
    procedure SetDrawRectLeft(const Value: Double);
    procedure SetDrawRectRight(const Value: Double);
    procedure SetDrawRectSizeType(const Value: TDPSizeType);
    procedure SetDrawRectTop(const Value: Double);
    procedure SetDrawRectVertAlign(const Value: TSkinAlign);
    procedure SetDrawRectWidth(const Value: Double);
  public
    constructor Create(ADrawParam:TDrawParam);virtual;

    procedure CheckDrawRectCustom;
//    property DrawRectCustom:Boolean read GetDrawRectCustom write SetDrawRectCustom stored IsDrawRectCustomStored;
  published
    //绘制矩形设置
    property DrawRectSizeType:TDPSizeType read GetDrawRectSizeType write SetDrawRectSizeType stored IsDrawRectSizeTypeStored;
    property DrawRectLeft:Double read GetDrawRectLeft write SetDrawRectLeft stored IsDrawRectLeftStored;
    property DrawRectTop:Double read GetDrawRectTop write SetDrawRectTop stored IsDrawRectTopStored;
    property DrawRectRight:Double read GetDrawRectRight write SetDrawRectRight stored IsDrawRectRightStored;
    property DrawRectBottom:Double read GetDrawRectBottom write SetDrawRectBottom stored IsDrawRectBottomStored;
    property DrawRectWidth:Double read GetDrawRectWidth write SetDrawRectWidth stored IsDrawRectWidthStored;
    property DrawRectHeight:Double read GetDrawRectHeight write SetDrawRectHeight stored IsDrawRectHeightStored;
    property DrawRectHorzAlign:TSkinAlign read GetDrawRectHorzAlign write SetDrawRectHorzAlign stored IsDrawRectHorzAlignStored;
    property DrawRectVertAlign:TSkinAlign read GetDrawRectVertAlign write SetDrawRectVertAlign stored IsDrawRectVertAlignStored;

  published
    property MouseDownAlpha:Byte read GetMouseDownAlpha write SetMouseDownAlpha stored IsMouseDownAlphaStored;
    property MouseDownOffset:Double read GetMouseDownOffset write SetMouseDownOffset stored IsMouseDownOffsetStored;
    property MouseDownAlphaChange:Boolean read GetMouseDownAlphaChange write SetMouseDownAlphaChange stored IsMouseDownAlphaChangeStored;
    property MouseDownOffsetChange:Boolean read GetMouseDownOffsetChange write SetMouseDownOffsetChange stored IsMouseDownOffsetChangeStored;

    property MouseOverAlpha:Byte read GetMouseOverAlpha write SetMouseOverAlpha stored IsMouseOverAlphaStored;
    property MouseOverOffset:Double read GetMouseOverOffset write SetMouseOverOffset stored IsMouseOverOffsetStored;
    property MouseOverAlphaChange:Boolean read GetMouseOverAlphaChange write SetMouseOverAlphaChange stored IsMouseOverAlphaChangeStored;
    property MouseOverOffsetChange:Boolean read GetMouseOverOffsetChange write SetMouseOverOffsetChange stored IsMouseOverOffsetChangeStored;

    property PushedAlpha:Byte read GetPushedAlpha write SetPushedAlpha stored IsPushedAlphaStored;
    property PushedOffset:Double read GetPushedOffset write SetPushedOffset stored IsPushedOffsetStored;
    property PushedAlphaChange:Boolean read GetPushedAlphaChange write SetPushedAlphaChange stored IsPushedAlphaChangeStored;
    property PushedOffsetChange:Boolean read GetPushedOffsetChange write SetPushedOffsetChange stored IsPushedOffsetChangeStored;
  end;






  /// <summary>
  ///   <para>
  ///     绘制参数的基类
  ///   </para>
  ///   <para>
  ///     Base class of drawing parameters
  ///   </para>
  /// </summary>
  TDrawParam=class(TInterfacedPersistent,ISupportClassDocNode)
  protected
    //名字
    FName:String;
    //标题
    FCaption:String;


    //透明度
    FAlpha: Byte;


    //更改的事件
    FOnChange:TNotifyEvent;

    //效果状态
    FEffectStates: TDPEffectStates;

    //参数绘制矩形设置
    FDrawRectSetting:TDrawRectSetting;

    //参数效果绘制设置
    FDrawEffectSetting:TDrawEffectSetting;

    //高级设置FDrawRectSetting+FDrawEffectSetting
//    FSetting: TDrawParamSetting;




    //所属的素材,用于IDE设计时给组件设计器使用
    FSkinMaterial:TObject;
  protected
    function IsAlphaStored:Boolean;
  protected
    procedure SetShadowSize(const Value: Double);
    procedure SetAlpha(const Value: Byte);
    procedure SetDrawRectSetting(const Value: TDrawRectSetting);
    procedure SetDrawEffectSetting(const Value: TDrawEffectSetting);
    procedure SetEffectStates(const Value: TDPEffectStates);
//    procedure SetSetting(const Value: TDrawParamSetting);
  protected

    //初始化参数
    procedure Clear;virtual;
    //更改
    procedure DoChange(Sender:TObject=nil);
    //赋值
    procedure AssignTo(Dest: TPersistent); override;

    //获取效果状态类
    function GetDrawEffectSettingClass:TDrawEffectSettingClass;virtual;
    function GetDrawParamSettingClass:TDrawParamSettingClass;virtual;

    //创建颜色参数,绑定它的更改事件,以便Color更改之后可以通知DrawParam进行更改
    function CreateDrawColor(const AName:String;const ACaption:String):TDrawColor;

  public
    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;virtual;
    /// <summary>
    ///   <para>
    ///     保存到文档节点
    ///   </para>
    ///   <para>
    ///     Save to document node
    ///   </para>
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;virtual;
  public
//    function LoadFromJson(AJsonStr:String):Boolean;
//    function SaveToJson:String;

//    function CustomLoadFromJson(ASuperObject:ISuperObject):Boolean;virtual;
//    function CustomSaveToJson(ASuperObject:ISuperObject):Boolean;virtual;
  public
    constructor Create(const AName:String;const ACaption:String);virtual;
    destructor Destroy;override;
  public
    //属性是否有修改过,如果修改过,阴影效果缓存图需要重绘
    FIsChanged:Boolean;
    FShadowSize: Double;

    {$IFDEF FMX}
    FShadowEffectBitmap:TBitmap;
    //阴影效果
    FShadowEffect:TShadowEffect;
    FShadowEffectRect:TRectF;
    {$ENDIF}

    /// <summary>
    ///   <para>
    ///     当前需要绘制的透明度(CurrentAlpha*控件的透明度)
    ///   </para>
    ///   <para>
    ///     Alpha need to draw currently(CurrenAlpha*control's alpha)
    ///   </para>
    /// </summary>
    DrawAlpha:Byte;


    /// <summary>
    ///   <para>
    ///     是否是控件级别的素材(当控件状态更改时,就需要更改绘制参数的效果状态)
    ///   </para>
    ///   <para>
    ///     Whether the material is control level(when control's state
    ///     changes, we need to change the effect state of drawing parameters
    ///   </para>
    /// </summary>
    IsControlParam:Boolean;


    /// <summary>
    ///   <para>
    ///     名称
    ///   </para>
    ///   <para>
    ///     Name
    ///   </para>
    /// </summary>
    property Name:String read FName;
    /// <summary>
    ///   <para>
    ///     标题,用于给用户查看此Param有什么作用
    ///   </para>
    ///   <para>
    ///     Caption
    ///   </para>
    /// </summary>
    property Caption:String read FCaption;

    /// <summary>
    ///   <para>
    ///     更改的事件
    ///   </para>
    ///   <para>
    ///     Changed event
    ///   </para>
    /// </summary>
    property OnChange:TNotifyEvent read FOnChange write FOnChange;


    /// <summary>
    ///   <para>
    ///     当前的效果
    ///   </para>
    ///   <para>
    ///     Current Effect
    ///   </para>
    /// </summary>
    function CurrentEffect:TDrawParamCommonEffect;
    /// <summary>
    ///   <para>
    ///     当前效果的透明度
    ///   </para>
    ///   <para>
    ///     Alpha of current Effect
    ///   </para>
    /// </summary>
    function CurrentEffectAlpha:Byte;
    function CurrentEffectShadowSize:Double;


    //阴影尺寸
    property ShadowSize:Double read FShadowSize write SetShadowSize;

    /// <summary>
    ///   <para>
    ///     状态的集合(控件同时会有多种状态)
    ///   </para>
    ///   <para>
    ///     State Set
    ///   </para>
    /// </summary>
    property StaticEffectStates:TDPEffectStates read FEffectStates write FEffectStates;
//    property EffectStates:TDPEffectStates read FEffectStates write SetEffectStates;

    /// <summary>
    ///   <para>
    ///     计算绘制的区域
    ///   </para>
    ///   <para>
    ///     Calculate DrawArea
    ///   </para>
    /// </summary>
    function CalcDrawRect(AControlRect:TRectF):TRectF;virtual;
    /// <summary>
    ///   <para>
    ///     透明度
    ///   </para>
    ///   <para>
    ///     Alpha
    ///   </para>
    /// </summary>
    property Alpha:Byte read FAlpha write SetAlpha;

    /// <summary>
    ///   <para>
    ///     绘制矩形的设置
    ///   </para>
    ///   <para>
    ///     Setting of drawing rectangle
    ///   </para>
    /// </summary>
    property DrawRectSetting:TDrawRectSetting read FDrawRectSetting write SetDrawRectSetting;

    /// <summary>
    ///   <para>
    ///     绘制效果的设置
    ///   </para>
    ///   <para>
    ///     Setting of draw effect
    ///   </para>
    /// </summary>
    property DrawEffectSetting:TDrawEffectSetting read FDrawEffectSetting write SetDrawEffectSetting;


//    //高级设置,DrawEffectSetting+DrawRectSetting
//    property Setting:TDrawParamSetting read FSetting write SetSetting;
    //
    /// <summary>
    ///   <para>
    ///     绘制参数所属的素材
    ///   </para>
    ///   <para>
    ///     material belongs to
    ///   </para>
    /// </summary>
    property SkinMaterial:TObject read FSkinMaterial write FSkinMaterial;
  end;





function GetSizeTypeStr(ASizeType:TDPSizeType):String;
function GetSizeType(ASizeTypeStr:String):TDPSizeType;

function GetSkinAlignStr(ASkinAlign:TSkinAlign):String;
function GetSkinAlign(ASkinAlignStr:String):TSkinAlign;

function GetPositionHorzTypeStr(APositionHorzType:TDPPositionHorzType):String;
function GetPositionHorzType(APositionHorzTypeStr:String):TDPPositionHorzType;

function GetPositionVertTypeStr(APositionVertType:TDPPositionVertType):String;
function GetPositionVertType(APositionVertTypeStr:String):TDPPositionVertType;

function GetCommonEffectTypesStr(ACommonEffectTypes:TDPCommonEffectTypes):String;
function GetCommonEffectTypes(ACommonEffectTypesStr:String):TDPCommonEffectTypes;


implementation


function GetCommonEffectTypesStr(ACommonEffectTypes:TDPCommonEffectTypes):String;
begin
  Result:='';
  if dpcetOffsetChange in ACommonEffectTypes then
  begin
    Result:=Result+'OffsetChange'+',';
  end;
  if dpcetAlphaChange in ACommonEffectTypes then
  begin
    Result:=Result+'AlphaChange'+',';
  end;
end;

function GetCommonEffectTypes(ACommonEffectTypesStr:String):TDPCommonEffectTypes;
var
  AStringList:TStringList;
begin
  Result:=[];
  AStringList:=TStringList.Create;
  try
    AStringList.CommaText:=ACommonEffectTypesStr;
    if AStringList.IndexOf('OffsetChange')<>-1 then
    begin
      Result:=Result+[dpcetOffsetChange];
    end;
    if AStringList.IndexOf('AlphaChange')<>-1 then
    begin
      Result:=Result+[dpcetAlphaChange];
    end;
  finally
    FreeAndNil(AStringList);
  end;
end;

function GetPositionVertTypeStr(APositionVertType:TDPPositionVertType):String;
begin
  case APositionVertType of
    dppvtNone: Result:='Leading';
    dppvtTop: Result:='Leading';
    dppvtCenter: Result:='Center';
    dppvtBottom: Result:='Trailing';
  end;
end;

function GetPositionVertType(APositionVertTypeStr:String):TDPPositionVertType;
begin
  Result:=dppvtNone;
  if SameText(APositionVertTypeStr,'Leading') then
  begin
    Result:=dppvtTop;
  end
  else if SameText(APositionVertTypeStr,'Center') then
  begin
    Result:=dppvtCenter;
  end
  else if SameText(APositionVertTypeStr,'Trailing') then
  begin
    Result:=dppvtBottom;
  end;
end;

function GetPositionHorzTypeStr(APositionHorzType:TDPPositionHorzType):String;
begin
  case APositionHorzType of
    dpphtNone: Result:='Leading';
    dpphtLeft: Result:='Leading';
    dpphtCenter: Result:='Center';
    dpphtRight: Result:='Trailing';
  end;
end;

function GetPositionHorzType(APositionHorzTypeStr:String):TDPPositionHorzType;
begin
  Result:=dpphtNone;
  if SameText(APositionHorzTypeStr,'Leading') then
  begin
    Result:=dpphtLeft;
  end
  else if SameText(APositionHorzTypeStr,'Center') then
  begin
    Result:=dpphtCenter;
  end
  else if SameText(APositionHorzTypeStr,'Trailing') then
  begin
    Result:=dpphtRight;
  end;
end;

function GetSkinAlignStr(ASkinAlign:TSkinAlign):String;
begin
  case ASkinAlign of
    salLeading: Result:='Leading';
    salCenter: Result:='Center';
    salTrailing: Result:='Trailing';
  end;
end;

function GetSkinAlign(ASkinAlignStr:String):TSkinAlign;
begin
  Result:=salLeading;
  if SameText(ASkinAlignStr,'Center') then
  begin
    Result:=salCenter;
  end
  else if SameText(ASkinAlignStr,'Trailing') then
  begin
    Result:=salTrailing;
  end;
end;

function GetSizeTypeStr(ASizeType:TDPSizeType):String;
begin
  case ASizeType of
    dpstPixel: Result:='Pixel';
    dpstPercent: Result:='Percent';
  end;
end;

function GetSizeType(ASizeTypeStr:String):TDPSizeType;
begin
  Result:=dpstPixel;
  if SameText(ASizeTypeStr,'Percent') then
  begin
    Result:=dpstPercent;
  end;
end;


//将TDPCommonEffectTypes转换成字符串,用于保存到文档节点中
function GetStrFromSet_TDPCommonEffectTypes(ASet:TDPCommonEffectTypes):String;
var
  I:TDPCommonEffectType;
begin
  Result:='';
  for I := Low(TDPCommonEffectType) to High(TDPCommonEffectType) do
  begin
    if I in ASet then
    begin
      Result:=Result+IntToStr(Ord(I))+',';
    end;
  end;
end;

//将字符串转换成TDPCommonEffectTypes,用于从文档节点中加载
function GetSetFromStr_TDPCommonEffectTypes(ASetStr:String):TDPCommonEffectTypes;
var
  I,AElem:Integer;
  J:TDPCommonEffectType;
  AStrList:TStringList;
begin
  Result:=[];
  AStrList:=TStringList.Create;
  try
    AStrList.CommaText:=ASetStr;
    for I := 0 to AStrList.Count-1 do
    begin
      if (Trim(AStrList[I])<>'') and TryStrToInt(AStrList[I],AElem) then
      begin
        for J := Low(TDPCommonEffectType) to High(TDPCommonEffectType) do
        begin
          if Ord(J) = AElem then
          begin
            Result:=Result+[J];
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(AStrList);
  end;
end;


{ TBaseDrawElement }

constructor TDrawParam.Create(const AName:String;const ACaption:String);
begin
  //默认是控件级别的素材
  IsControlParam:=True;

  FDrawRectSetting:=TDrawRectSetting.Create;
  FDrawRectSetting.OnChange:=DoChange;

  FDrawEffectSetting:=GetDrawEffectSettingClass.Create;
  FDrawEffectSetting.OnChange:=DoChange;

//  FSetting:=GetDrawParamSettingClass.Create(Self);

  Clear;

  FName:=AName;
  FCaption:=ACaption;

  FIsChanged:=True;
end;

function TDrawParam.CreateDrawColor(const AName:String;const ACaption:String): TDrawColor;
begin
  Result:=TDrawColor.Create(AName,ACaption);
  Result.OnChange:=DoChange;
end;

function TDrawParam.CurrentEffect: TDrawParamCommonEffect;
begin
  Result:=nil;

  //判断当前需要使用哪个效果
  if (Self.FEffectStates<>[]) then
  begin

      if (dpstDisabled in Self.FEffectStates) then
      begin
        if (Self.FDrawEffectSetting.FDisabledEffect.HasEffectTypes) then
        begin
          Result:=Self.FDrawEffectSetting.FDisabledEffect;
        end;
      end
      else
      begin

          //一定要按顺序
          //先Focused
          if (dpstFocused in Self.FEffectStates) then
          begin
            if (Self.FDrawEffectSetting.FFocusedEffect.HasEffectTypes) then
            begin
              Result:=Self.FDrawEffectSetting.FFocusedEffect;
            end;
          end;

          //再MouseOver
          if (dpstMouseOver in Self.FEffectStates) then
          begin
            if (Self.FDrawEffectSetting.FMouseOverEffect.HasEffectTypes) then
            begin
              Result:=Self.FDrawEffectSetting.FMouseOverEffect;
            end;
          end;

          //再MouseDown
          if (dpstMouseDown in Self.FEffectStates) then
          begin
            if (Self.FDrawEffectSetting.FMouseDownEffect.HasEffectTypes) then
            begin
              Result:=Self.FDrawEffectSetting.FMouseDownEffect;
            end;
          end;

          //再Pushed
          if (dpstPushed in Self.FEffectStates) then
          begin
            if (Self.FDrawEffectSetting.FPushedEffect.HasEffectTypes) then
            begin
              Result:=Self.FDrawEffectSetting.FPushedEffect;
            end;
          end;


          if Self.FDrawEffectSetting.FIsMixedMouseDownAndPushedEffect
            and (dpstMouseDown in FEffectStates)
            and (dpstPushed in FEffectStates)
            and (Self.FDrawEffectSetting.FMouseDownEffect.HasEffectTypes)
            and (Self.FDrawEffectSetting.FPushedEffect.HasEffectTypes)
            then
          begin
            Self.FDrawEffectSetting.FMixedEffect.Mix(Self.FDrawEffectSetting.FPushedEffect,Self.FDrawEffectSetting.FMouseDownEffect);
            Result:=Self.FDrawEffectSetting.FMixedEffect;
          end;
      end;

  end;
end;

function TDrawParam.CurrentEffectAlpha: Byte;
begin
  Result:=Self.FAlpha;
  if (CurrentEffect<>nil) and (dpcetAlphaChange in Self.CurrentEffect.CommonEffectTypes) then
  begin
    Result:=CurrentEffect.FAlpha;
  end;
end;

function TDrawParam.CurrentEffectShadowSize: Double;
begin
  Result:=Self.FShadowSize;
  if (CurrentEffect<>nil) and (dpcetShadowSizeChange in Self.CurrentEffect.CommonEffectTypes) then
  begin
    Result:=CurrentEffect.FShadowSize;
  end;
end;

//function TDrawParam.CustomLoadFromJson(ASuperObject: ISuperObject): Boolean;
//begin
//  //
//end;
//
//function TDrawParam.CustomSaveToJson(ASuperObject: ISuperObject): Boolean;
//begin
//  ASuperObject.S['type']:='DrawParam';
//
//end;

destructor TDrawParam.Destroy;
begin
  {$IFDEF FMX}
  FreeAndNil(FShadowEffect);
  FreeAndNil(FShadowEffectBitmap);
  {$ENDIF}

//  FreeAndNil(FSetting);
  FreeAndNil(FDrawRectSetting);
  FreeAndNil(FDrawEffectSetting);
  inherited;
end;

function TDrawParam.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I:Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Clear;

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='Alpha' then
    begin
      FAlpha:=ABTNode.ConvertNode_UInt8.Data;
    end
    else if ABTNode.NodeName='DrawRectSetting' then
    begin
      FDrawRectSetting.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    else if ABTNode.NodeName='DrawEffectSetting' then
    begin
      FDrawEffectSetting.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    ;

  end;

  Result:=True;

end;

//function TDrawParam.LoadFromJson(AJsonStr: String): Boolean;
//var
//  ASuperObject:ISuperObject;
//  ASubJson:ISuperObject;
//begin
//  Result:=False;
//
//  ASuperObject:=TSuperObject.Create(AJsonStr);
//
//  Self.FAlpha:=ASuperObject.I['alpha'];
//
//  ASubJson:=TSuperObject.Create(ASuperObject.S['drawrect_setting_json']);
//  Self.FDrawRectSetting.LoadFromJson(ASubJson);
//
//  Self.FDrawEffectSetting.LoadFromJson(ASuperObject);
//
//  Self.CustomLoadFromJson(ASuperObject);
//
//  Result:=True;
//end;

function TDrawParam.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin

  //保存类类型
  ADocNode.ClassName:=Self.ClassName;


  ABTNode:=ADocNode.AddChildNode_WideString('Name','名称');
  ABTNode.ConvertNode_WideString.Data:=FName;

  ABTNode:=ADocNode.AddChildNode_WideString('Caption','标题');
  ABTNode.ConvertNode_WideString.Data:=FCaption;

  ABTNode:=ADocNode.AddChildNode_UInt8('Alpha','透明度');
  ABTNode.ConvertNode_UInt8.Data:=FAlpha;

  ABTNode:=ADocNode.AddChildNode_Class('DrawRectSetting','绘制矩形设置');
  FDrawRectSetting.SaveToDocNode(ABTNode.ConvertNode_Class);

  ABTNode:=ADocNode.AddChildNode_Class('DrawEffectSetting','绘制效果设置');
  FDrawEffectSetting.SaveToDocNode(ABTNode.ConvertNode_Class);

  Result:=True;
end;

//function TDrawParam.SaveToJson:String;
//var
//  ASuperObject:ISuperObject;
//  ASubJson:ISuperObject;
//begin
//  Result:='';
//
//  ASuperObject:=TSuperObject.Create();
//
//  ASuperObject.S['name']:=Self.FName;
//  ASuperObject.S['caption']:=Self.FCaption;
//
//  ASuperObject.I['alpha']:=Self.Alpha;
//
//
//  ASubJson:=TSuperObject.Create();
//  Self.FDrawRectSetting.SaveToJson(ASubJson);
//  ASuperObject.S['drawrect_setting_json']:=ASubJson.AsJson;
//
//  Self.FDrawEffectSetting.SaveToJson(ASuperObject);
//
//
//  Self.CustomSaveToJson(ASuperObject);
//
//  Result:=ASuperObject.AsJson;
//
//end;

procedure TDrawParam.SetEffectStates(const Value: TDPEffectStates);
begin
  if FEffectStates<>Value then
  begin
    FEffectStates:=Value;
  end;
end;

procedure TDrawParam.SetShadowSize(const Value: Double);
begin
  if FShadowSize<>Value then
  begin
    FShadowSize := Value;
    DoChange;
  end;
end;

//procedure TDrawParam.SetSetting(const Value: TDrawParamSetting);
//begin
//  FSetting.Assign(Value);
//end;

procedure TDrawParam.SetAlpha(const Value: Byte);
begin
  if FAlpha<>Value then
  begin
    FAlpha:=Value;
    DoChange;
  end;
end;

procedure TDrawParam.SetDrawEffectSetting(const Value: TDrawEffectSetting);
begin
  FDrawEffectSetting.Assign(Value);
end;

procedure TDrawParam.SetDrawRectSetting(const Value: TDrawRectSetting);
begin
  Self.FDrawRectSetting.Assign(Value);
end;

procedure TDrawParam.AssignTo(Dest: TPersistent);
var
  DestObject:TDrawParam;
begin
  if Dest is TDrawParam then
  begin
    DestObject:=TDrawParam(Dest);

    DestObject.FAlpha:=Self.FAlpha;
    DestObject.FDrawRectSetting.Assign(Self.FDrawRectSetting);
    DestObject.FDrawEffectSetting.Assign(Self.FDrawEffectSetting);


    DestObject.DoChange;
  end
  else
  begin
    Inherited;
  end;
end;

procedure TDrawParam.DoChange(Sender:TObject);
begin
  FIsChanged:=True;
  if Assigned(FOnChange) then
  begin
    FOnChange(Self);
  end;
end;

function TDrawParam.GetDrawEffectSettingClass: TDrawEffectSettingClass;
begin
  Result:=TDrawEffectSetting;
end;

function TDrawParam.GetDrawParamSettingClass: TDrawParamSettingClass;
begin
  Result:=TDrawParamSetting;
end;

function TDrawParam.IsAlphaStored: Boolean;
begin
  Result:=(FAlpha<>255);
end;

function TDrawParam.CalcDrawRect(AControlRect: TRectF): TRectF;
begin

  Result:=Self.FDrawRectSetting.CalcDrawRect(AControlRect);

//  //判断有没有启用位移效果
//  //计算完再处理偏移
//  if (CurrentEffect<>nil) and (dpcetOffsetChange in CurrentEffect.FCommonEffectTypes) then
//  begin
//    AControlRect.Left:=AControlRect.Left+CurrentEffect.FOffset;
//    AControlRect.Top:=AControlRect.Top+CurrentEffect.FOffset;
//    AControlRect.Right:=AControlRect.Right+CurrentEffect.FOffset;
//    AControlRect.Bottom:=AControlRect.Bottom+CurrentEffect.FOffset;
//  end;
  //判断有没有启用位移效果


  //计算完再处理偏移
  if (CurrentEffect<>nil) and (dpcetOffsetChange in CurrentEffect.FCommonEffectTypes) then
  begin
    OffsetRect(Result,CurrentEffect.FOffset,CurrentEffect.FOffset);
//    AControlRect.Left:=AControlRect.Left+CurrentEffect.FOffset;
//    AControlRect.Top:=AControlRect.Top+CurrentEffect.FOffset;
//    AControlRect.Right:=AControlRect.Right+CurrentEffect.FOffset;
//    AControlRect.Bottom:=AControlRect.Bottom+CurrentEffect.FOffset;
  end;




end;

procedure TDrawParam.Clear;
begin

  FAlpha:=255;
  DrawAlpha:=255;

  FDrawRectSetting.Clear;

  FDrawEffectSetting.Clear;

end;


{ TDrawParamSetting }

procedure TDrawParamSetting.SetDrawRectBottom(const Value: Double);
begin
  FDrawParam.FDrawRectSetting.Bottom:=Value;
end;

//procedure TDrawParamSetting.SetDrawRectCustom(const Value: Boolean);
//begin
//  FDrawParam.FDrawRectSetting.Enabled:=Value;
//end;

procedure TDrawParamSetting.SetDrawRectHeight(const Value: Double);
begin
  FDrawParam.FDrawRectSetting.Height:=Value;
  CheckDrawRectCustom;
end;

procedure TDrawParamSetting.SetDrawRectHorzAlign(const Value: TSkinAlign);
begin
  case Value of
    salLeading: FDrawParam.FDrawRectSetting.PositionHorzType:=dpphtLeft;
    salCenter: FDrawParam.FDrawRectSetting.PositionHorzType:=dpphtCenter;
    salTrailing: FDrawParam.FDrawRectSetting.PositionHorzType:=dpphtRight;
  end;
  CheckDrawRectCustom;
end;

procedure TDrawParamSetting.SetDrawRectLeft(const Value: Double);
begin
  FDrawParam.FDrawRectSetting.Left:=Value;
  CheckDrawRectCustom;
end;

procedure TDrawParamSetting.SetDrawRectRight(const Value: Double);
begin
  FDrawParam.FDrawRectSetting.Right:=Value;
  CheckDrawRectCustom;
end;

procedure TDrawParamSetting.SetDrawRectSizeType(const Value: TDPSizeType);
begin
  FDrawParam.FDrawRectSetting.SizeType:=Value;
  CheckDrawRectCustom;
end;

procedure TDrawParamSetting.SetDrawRectTop(const Value: Double);
begin
  FDrawParam.FDrawRectSetting.Top:=Value;
  CheckDrawRectCustom;
end;

procedure TDrawParamSetting.SetDrawRectVertAlign(const Value: TSkinAlign);
begin
  case Value of
    salLeading: FDrawParam.FDrawRectSetting.PositionVertType:=dppvtTop;
    salCenter: FDrawParam.FDrawRectSetting.PositionVertType:=dppvtCenter;
    salTrailing: FDrawParam.FDrawRectSetting.PositionVertType:=dppvtBottom;
  end;
  CheckDrawRectCustom;
end;

procedure TDrawParamSetting.SetDrawRectWidth(const Value: Double);
begin
  FDrawParam.FDrawRectSetting.Width:=Value;
  CheckDrawRectCustom;
end;

procedure TDrawParamSetting.CheckDrawRectCustom;
begin
  FDrawParam.FDrawRectSetting.FEnabled:=
        IsDrawRectBottomStored
    or IsDrawRectHeightStored
    or IsDrawRectHorzAlignStored
    or IsDrawRectLeftStored
    or IsDrawRectRightStored
    or IsDrawRectSizeTypeStored
    or IsDrawRectTopStored
    or IsDrawRectVertAlignStored
    or IsDrawRectWidthStored;

end;

constructor TDrawParamSetting.Create(ADrawParam: TDrawParam);
begin
  FDrawParam:=ADrawParam;
end;

function TDrawParamSetting.GetDrawRectBottom: Double;
begin
  Result:=FDrawParam.FDrawRectSetting.FBottom;
end;

//function TDrawParamSetting.GetDrawRectCustom: Boolean;
//begin
//  Result:=FDrawParam.FDrawRectSetting.FEnabled;
//end;

function TDrawParamSetting.GetDrawRectHeight: Double;
begin
  Result:=FDrawParam.FDrawRectSetting.FHeight;
end;

function TDrawParamSetting.GetDrawRectHorzAlign: TSkinAlign;
begin
  case FDrawParam.FDrawRectSetting.FPositionHorzType of
    dpphtNone: Result:=salLeading;
    dpphtLeft: Result:=salLeading;
    dpphtCenter: Result:=salCenter;
    dpphtRight: Result:=salTrailing;
  end;
end;

function TDrawParamSetting.GetDrawRectLeft: Double;
begin
  Result:=FDrawParam.FDrawRectSetting.FLeft;
end;

function TDrawParamSetting.GetDrawRectRight: Double;
begin
  Result:=FDrawParam.FDrawRectSetting.FRight;
end;

function TDrawParamSetting.GetDrawRectSizeType: TDPSizeType;
begin
  Result:=FDrawParam.FDrawRectSetting.FSizeType;
end;

function TDrawParamSetting.GetDrawRectTop: Double;
begin
  Result:=FDrawParam.FDrawRectSetting.FTop;
end;

function TDrawParamSetting.GetDrawRectVertAlign: TSkinAlign;
begin
  case FDrawParam.FDrawRectSetting.FPositionVertType of
    dppvtNone: Result:=salLeading;
    dppvtTop: Result:=salLeading;
    dppvtCenter: Result:=salCenter;
    dppvtBottom: Result:=salTrailing;
  end;
end;

function TDrawParamSetting.GetDrawRectWidth: Double;
begin
  Result:=FDrawParam.FDrawRectSetting.FWidth;
end;

function TDrawParamSetting.GetMouseDownAlpha: Byte;
begin
  Result:=FDrawParam.FDrawEffectSetting.FMouseDownEffect.FAlpha;
end;

function TDrawParamSetting.GetMouseDownAlphaChange: Boolean;
begin
  Result:=dpcetAlphaChange in FDrawParam.FDrawEffectSetting.FMouseDownEffect.FCommonEffectTypes;
end;

function TDrawParamSetting.GetMouseDownOffset: Double;
begin
  Result:=FDrawParam.FDrawEffectSetting.FMouseDownEffect.FOffset;
end;

function TDrawParamSetting.GetMouseDownOffsetChange: Boolean;
begin
  Result:=dpcetOffsetChange in FDrawParam.FDrawEffectSetting.FMouseDownEffect.FCommonEffectTypes;
end;

function TDrawParamSetting.GetMouseOverAlpha: Byte;
begin
  Result:=FDrawParam.FDrawEffectSetting.FMouseOverEffect.FAlpha;
end;

function TDrawParamSetting.GetMouseOverAlphaChange: Boolean;
begin
  Result:=dpcetAlphaChange in FDrawParam.FDrawEffectSetting.FMouseOverEffect.FCommonEffectTypes;
end;

function TDrawParamSetting.GetMouseOverOffset: Double;
begin
  Result:=FDrawParam.FDrawEffectSetting.FMouseOverEffect.FOffset;
end;

function TDrawParamSetting.GetMouseOverOffsetChange: Boolean;
begin
  Result:=dpcetOffsetChange in FDrawParam.FDrawEffectSetting.FMouseOverEffect.FCommonEffectTypes;
end;

function TDrawParamSetting.GetPushedAlpha: Byte;
begin
  Result:=FDrawParam.FDrawEffectSetting.FPushedEffect.FAlpha;
end;

function TDrawParamSetting.GetPushedAlphaChange: Boolean;
begin
  Result:=dpcetAlphaChange in FDrawParam.FDrawEffectSetting.FPushedEffect.FCommonEffectTypes;
end;

function TDrawParamSetting.GetPushedOffset: Double;
begin
  Result:=FDrawParam.FDrawEffectSetting.FPushedEffect.FOffset;
end;

function TDrawParamSetting.GetPushedOffsetChange: Boolean;
begin
  Result:=dpcetOffsetChange in FDrawParam.FDrawEffectSetting.FPushedEffect.FCommonEffectTypes;
end;

function TDrawParamSetting.IsDrawRectBottomStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawParam.FDrawRectSetting.FBottom,0);
end;

function TDrawParamSetting.IsDrawRectCustomStored: Boolean;
begin
  Result:=Self.FDrawParam.FDrawRectSetting.FEnabled<>False;
end;

function TDrawParamSetting.IsDrawRectHeightStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawParam.FDrawRectSetting.FHeight,0);
end;

function TDrawParamSetting.IsDrawRectHorzAlignStored: Boolean;
begin
  Result:=(Self.FDrawParam.FDrawRectSetting.FPositionHorzType<>dpphtNone)
    and (Self.FDrawParam.FDrawRectSetting.FPositionHorzType<>dpphtLeft);
end;

function TDrawParamSetting.IsDrawRectLeftStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawParam.FDrawRectSetting.FLeft,0);
end;

function TDrawParamSetting.IsDrawRectRightStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawParam.FDrawRectSetting.FRight,0);
end;

function TDrawParamSetting.IsDrawRectSizeTypeStored: Boolean;
begin
  Result:=Self.FDrawParam.FDrawRectSetting.FSizeType<>dpstPixel;
end;

function TDrawParamSetting.IsDrawRectTopStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawParam.FDrawRectSetting.FTop,0);
end;

function TDrawParamSetting.IsDrawRectVertAlignStored: Boolean;
begin
  Result:=(Self.FDrawParam.FDrawRectSetting.FPositionVertType<>dppvtNone)
    and (Self.FDrawParam.FDrawRectSetting.FPositionVertType<>dppvtTop);
end;

function TDrawParamSetting.IsDrawRectWidthStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawParam.FDrawRectSetting.FWidth,0);
end;

function TDrawParamSetting.IsMouseDownAlphaChangeStored: Boolean;
begin
  Result:=dpcetAlphaChange in FDrawParam.FDrawEffectSetting.FMouseDownEffect.FCommonEffectTypes;
end;

function TDrawParamSetting.IsMouseDownAlphaStored: Boolean;
begin
  Result:=Self.FDrawParam.FDrawEffectSetting.FMouseDownEffect.FAlpha<>Const_DefaultEffect_Alpha;
end;

function TDrawParamSetting.IsMouseDownOffsetChangeStored: Boolean;
begin
  Result:=dpcetOffsetChange in FDrawParam.FDrawEffectSetting.FMouseDownEffect.FCommonEffectTypes;
end;

function TDrawParamSetting.IsMouseDownOffsetStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawParam.FDrawEffectSetting.FMouseDownEffect.FOffset,Const_DefaultEffect_Offset);
end;

function TDrawParamSetting.IsMouseOverAlphaChangeStored: Boolean;
begin
  Result:=dpcetAlphaChange in FDrawParam.FDrawEffectSetting.FMouseOverEffect.FCommonEffectTypes;
end;

function TDrawParamSetting.IsMouseOverAlphaStored: Boolean;
begin
  Result:=Self.FDrawParam.FDrawEffectSetting.FMouseOverEffect.FAlpha<>Const_DefaultEffect_Alpha;
end;

function TDrawParamSetting.IsMouseOverOffsetChangeStored: Boolean;
begin
  Result:=dpcetOffsetChange in FDrawParam.FDrawEffectSetting.FMouseOverEffect.FCommonEffectTypes;
end;

function TDrawParamSetting.IsMouseOverOffsetStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawParam.FDrawEffectSetting.FMouseOverEffect.FOffset,Const_DefaultEffect_Offset);
end;

function TDrawParamSetting.IsPushedAlphaChangeStored: Boolean;
begin
  Result:=dpcetAlphaChange in FDrawParam.FDrawEffectSetting.FPushedEffect.FCommonEffectTypes;
end;

function TDrawParamSetting.IsPushedAlphaStored: Boolean;
begin
  Result:=Self.FDrawParam.FDrawEffectSetting.FPushedEffect.FAlpha<>Const_DefaultEffect_Alpha;
end;

function TDrawParamSetting.IsPushedOffsetChangeStored: Boolean;
begin
  Result:=dpcetOffsetChange in FDrawParam.FDrawEffectSetting.FPushedEffect.FCommonEffectTypes;
end;

function TDrawParamSetting.IsPushedOffsetStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawParam.FDrawEffectSetting.FPushedEffect.FOffset,Const_DefaultEffect_Offset);
end;

procedure TDrawParamSetting.SetMouseDownAlpha(const Value: Byte);
begin
  FDrawParam.FDrawEffectSetting.FMouseDownEffect.Alpha:=Value;
end;

procedure TDrawParamSetting.SetMouseDownAlphaChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawParam.FDrawEffectSetting.FMouseDownEffect.CommonEffectTypes:=
      FDrawParam.FDrawEffectSetting.FMouseDownEffect.CommonEffectTypes+[dpcetAlphaChange];
  end
  else
  begin
    FDrawParam.FDrawEffectSetting.FMouseDownEffect.CommonEffectTypes:=
      FDrawParam.FDrawEffectSetting.FMouseDownEffect.CommonEffectTypes-[dpcetAlphaChange];
  end;
end;

procedure TDrawParamSetting.SetMouseDownOffset(const Value: Double);
begin
  FDrawParam.FDrawEffectSetting.FMouseDownEffect.Offset:=Value;
end;

procedure TDrawParamSetting.SetMouseDownOffsetChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawParam.FDrawEffectSetting.FMouseDownEffect.CommonEffectTypes:=
      FDrawParam.FDrawEffectSetting.FMouseDownEffect.CommonEffectTypes+[dpcetOffsetChange];
  end
  else
  begin
    FDrawParam.FDrawEffectSetting.FMouseDownEffect.CommonEffectTypes:=
      FDrawParam.FDrawEffectSetting.FMouseDownEffect.CommonEffectTypes-[dpcetOffsetChange];
  end;
end;

procedure TDrawParamSetting.SetMouseOverAlpha(const Value: Byte);
begin
  FDrawParam.FDrawEffectSetting.FMouseOverEffect.Alpha:=Value;
end;

procedure TDrawParamSetting.SetMouseOverAlphaChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawParam.FDrawEffectSetting.FMouseOverEffect.CommonEffectTypes:=
      FDrawParam.FDrawEffectSetting.FMouseOverEffect.CommonEffectTypes+[dpcetAlphaChange];
  end
  else
  begin
    FDrawParam.FDrawEffectSetting.FMouseOverEffect.CommonEffectTypes:=
      FDrawParam.FDrawEffectSetting.FMouseOverEffect.CommonEffectTypes-[dpcetAlphaChange];
  end;
end;

procedure TDrawParamSetting.SetMouseOverOffset(const Value: Double);
begin
  FDrawParam.FDrawEffectSetting.FMouseOverEffect.Offset:=Value;
end;

procedure TDrawParamSetting.SetMouseOverOffsetChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawParam.FDrawEffectSetting.FMouseOverEffect.CommonEffectTypes:=
      FDrawParam.FDrawEffectSetting.FMouseOverEffect.CommonEffectTypes+[dpcetOffsetChange];
  end
  else
  begin
    FDrawParam.FDrawEffectSetting.FMouseOverEffect.CommonEffectTypes:=
      FDrawParam.FDrawEffectSetting.FMouseOverEffect.CommonEffectTypes-[dpcetOffsetChange];
  end;
end;

procedure TDrawParamSetting.SetPushedAlpha(const Value: Byte);
begin
  FDrawParam.FDrawEffectSetting.FPushedEffect.Alpha:=Value;
end;

procedure TDrawParamSetting.SetPushedAlphaChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawParam.FDrawEffectSetting.FPushedEffect.CommonEffectTypes:=
      FDrawParam.FDrawEffectSetting.FPushedEffect.CommonEffectTypes+[dpcetAlphaChange];
  end
  else
  begin
    FDrawParam.FDrawEffectSetting.FPushedEffect.CommonEffectTypes:=
      FDrawParam.FDrawEffectSetting.FPushedEffect.CommonEffectTypes-[dpcetAlphaChange];
  end;
end;

procedure TDrawParamSetting.SetPushedOffset(const Value: Double);
begin
  FDrawParam.FDrawEffectSetting.FPushedEffect.Offset:=Value;
end;

procedure TDrawParamSetting.SetPushedOffsetChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawParam.FDrawEffectSetting.FPushedEffect.CommonEffectTypes:=
      FDrawParam.FDrawEffectSetting.FPushedEffect.CommonEffectTypes+[dpcetOffsetChange];
  end
  else
  begin
    FDrawParam.FDrawEffectSetting.FPushedEffect.CommonEffectTypes:=
      FDrawParam.FDrawEffectSetting.FPushedEffect.CommonEffectTypes-[dpcetOffsetChange];
  end;
end;


{ TDrawRectSetting }

function TDrawRectSetting.CalcDrawRect(const AControlRect: TRectF): TRectF;
var
  ALeft:Double;
  ATop:Double;
  ARight:Double;
  ABottom:Double;
  AWidth:Double;
  AHeight:Double;
begin
  Result:=AControlRect;

  if Not Self.Enabled then
  begin
    Exit;
  end;


  ALeft:=0;
  ATop:=0;
  ARight:=0;
  ABottom:=0;
  AWidth:=0;
  AHeight:=0;


  case Self.FSizeType of
    dpstPercent:
    begin
        //百分比
        ALeft:=FLeft*(AControlRect.Right-AControlRect.Left)/100;
        ATop:=FTop*(AControlRect.Bottom-AControlRect.Top)/100;
        ARight:=FRight*(AControlRect.Right-AControlRect.Left)/100;
        ABottom:=FBottom*(AControlRect.Bottom-AControlRect.Top)/100;
        if FWidth<=0 then
        begin
          AWidth:=AControlRect.Right-AControlRect.Left;
        end
        else
        begin
          AWidth:=FWidth*(AControlRect.Right-AControlRect.Left)/100;
        end;
        if FHeight<=0 then
        begin
          AHeight:=AControlRect.Bottom-AControlRect.Top;
        end
        else
        begin
          AHeight:=FHeight*(AControlRect.Bottom-AControlRect.Top)/100;
        end;
    end;
    dpstPixel:
    begin
        //像素
        ALeft:=FLeft;
        ATop:=FTop;
        ARight:=FRight;
        ABottom:=FBottom;
        if FWidth<=0 then
        begin
          AWidth:=AControlRect.Right-AControlRect.Left;
        end
        else
        begin
          AWidth:=FWidth;
        end;
        if FHeight<=0 then
        begin
          AHeight:=AControlRect.Bottom-AControlRect.Top;
        end
        else
        begin
          AHeight:=FHeight;
        end;
    end;
  end;


  //水平尺寸类型
  case Self.FPositionHorzType of
    dpphtNone:
    begin
      ALeft:=ALeft;
    end;
    dpphtLeft:
    begin
      ALeft:=0{添加}+ALeft;
    end;
    dpphtCenter:
    begin
      ALeft:=((AControlRect.Right-AControlRect.Left)-AWidth) / 2{添加}+ALeft;
    end;
    dpphtRight:
    begin
      ALeft:=(AControlRect.Right-AControlRect.Left)-AWidth{添加}-ARight;
    end;
  end;


  //垂直类型
  case Self.FPositionVertType of
    dppvtNone:
    begin
      ATop:=ATop;
    end;
    dppvtTop:
    begin
      ATop:=0{添加}+ATop;
    end;
    dppvtCenter:
    begin
      ATop:=((AControlRect.Bottom-AControlRect.Top)-AHeight) / 2{添加}+ATop;
    end;
    dppvtBottom:
    begin
      ATop:=(AControlRect.Bottom-AControlRect.Top)-AHeight{添加}-ABottom;
    end;
  end;



  Result.Left:=Result.Left+ALeft;
  Result.Top:=Result.Top+ATop;


  if FHeight<>0 then
  begin
    Result.Bottom:=Result.Top+AHeight;
  end
  else
  if FBottom<>0 then
  begin
    Result.Bottom:=Result.Bottom-ABottom;
  end
  else
  begin
    Result.Bottom:=Result.Bottom;
  end;


  if FWidth<>0 then
  begin
    Result.Right:=Result.Left+AWidth;
  end
  else
  if FRight<>0 then
  begin
    Result.Right:=Result.Right-ARight;
  end
  else
  begin
    Result.Right:=Result.Right;
  end;

end;

destructor TDrawRectSetting.Destroy;
begin
  FOnChange:=nil;
  inherited;
end;

procedure TDrawRectSetting.DoChange(Const AIsForce:Boolean);
begin
  //如果FEnabled为False,那就不需要调用OnChange
  if (Self.FEnabled or AIsForce) and Assigned(FOnChange) then
  begin
    FOnChange(Self);
  end;
end;

function TDrawRectSetting.IsBottomStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FBottom,0);
end;

function TDrawRectSetting.IsEnabledStored: Boolean;
begin
  Result:=(Self.FEnabled<>False);
end;

function TDrawRectSetting.IsHeightStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FHeight,0)
          or (Self.FSizeType=dpstPercent) and IsNotSameDouble(Self.FHeight,100);
end;

function TDrawRectSetting.IsLeftStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FLeft,0);
end;

function TDrawRectSetting.IsPositionHorzTypeStored: Boolean;
begin
  Result:=(Self.FPositionHorzType<>dpphtNone);
end;

function TDrawRectSetting.IsPositionVertTypeStored: Boolean;
begin
  Result:=(Self.FPositionVertType<>dppvtNone);
end;

function TDrawRectSetting.IsRightStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FRight,0);
end;

function TDrawRectSetting.IsSizeTypeStored: Boolean;
begin
  Result:=(Self.FSizeType<>dpstPercent);
end;

function TDrawRectSetting.IsTopStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FTop,0);
end;

function TDrawRectSetting.IsWidthStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FWidth,0)
          or (Self.FSizeType=dpstPercent) and IsNotSameDouble(Self.FWidth,100);
end;

procedure TDrawRectSetting.AssignTo(Dest: TPersistent);
var
  DestObject:TDrawRectSetting;
begin
  if (Dest is TDrawRectSetting) then
  begin

    DestObject:=TDrawRectSetting(Dest);

    DestObject.FLeft:=FLeft;
    DestObject.FTop:=FTop;
    DestObject.FRight:=FRight;
    DestObject.FBottom:=FBottom;
    DestObject.FWidth:=FWidth;
    DestObject.FHeight:=FHeight;

    DestObject.FEnabled:=FEnabled;

    DestObject.FSizeType:=FSizeType;

    DestObject.FPositionHorzType:=FPositionHorzType;
    DestObject.FPositionVertType:=FPositionVertType;

    DestObject.DoChange;
  end
  else
  begin
    Inherited;
  end;
end;

procedure TDrawRectSetting.Clear;
begin

  FLeft:=0;
  FTop:=0;
  FRight:=0;
  FBottom:=0;
  FWidth:=0;
  FHeight:=0;

  FEnabled:=False;

  FSizeType:=dpstPercent;


  FPositionHorzType:=dpphtNone;
  FPositionVertType:=dppvtNone;
end;

constructor TDrawRectSetting.Create;
begin
  Clear;
end;

function TDrawRectSetting.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I:Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Clear;


  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='Left' then
    begin
      FLeft:=ABTNode.ConvertNode_Real64.Data;
    end
    else if ABTNode.NodeName='Top' then
    begin
      FTop:=ABTNode.ConvertNode_Real64.Data;
    end
    else if ABTNode.NodeName='Right' then
    begin
      FRight:=ABTNode.ConvertNode_Real64.Data;
    end
    else if ABTNode.NodeName='Bottom' then
    begin
      FBottom:=ABTNode.ConvertNode_Real64.Data;
    end

    else if ABTNode.NodeName='Width' then
    begin
      FWidth:=ABTNode.ConvertNode_Real64.Data;
    end
    else if ABTNode.NodeName='Height' then
    begin
      FHeight:=ABTNode.ConvertNode_Real64.Data;
    end

    else if ABTNode.NodeName='Enabled' then
    begin
      FEnabled:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='SizeType' then
    begin
      FSizeType:=TDPSizeType(ABTNode.ConvertNode_Int32.Data);
    end
    else if ABTNode.NodeName='PositionHorzType' then
    begin
      FPositionHorzType:=TDPPositionHorzType(ABTNode.ConvertNode_Int32.Data);
    end
    else if ABTNode.NodeName='PositionVertType' then
    begin
      FPositionVertType:=TDPPositionVertType(ABTNode.ConvertNode_Int32.Data);
    end

    ;
  end;

  Result:=True;
end;

//function TDrawRectSetting.LoadFromJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  Self.FLeft:=ASuperObject.F['left'];
//  Self.FTop:=ASuperObject.F['top'];
//  Self.FRight:=ASuperObject.F['right'];
//  Self.FBottom:=ASuperObject.F['bottom'];
//  Self.FWidth:=ASuperObject.F['width'];
//  Self.FHeight:=ASuperObject.F['height'];
//
//  Self.FEnabled:=(ASuperObject.I['enabled']=1);
//
//  Self.FSizeType:=GetSizeType(ASuperObject.S['size_type']);
//
//  Self.FPositionHorzType:=GetPositionHorzType(ASuperObject.S['horz_type']);
//  Self.FPositionVertType:=GetPositionVertType(ASuperObject.S['vert_type']);
//
//
//  Result:=True;
//end;

function TDrawRectSetting.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  //保存类类型
  ADocNode.ClassName:=Self.ClassName;

  ABTNode:=ADocNode.AddChildNode_Real64('Left','左');
  ABTNode.ConvertNode_Real64.Data:=FLeft;

  ABTNode:=ADocNode.AddChildNode_Real64('Top','上');
  ABTNode.ConvertNode_Real64.Data:=FTop;

  ABTNode:=ADocNode.AddChildNode_Real64('Right','右');
  ABTNode.ConvertNode_Real64.Data:=FRight;

  ABTNode:=ADocNode.AddChildNode_Real64('Bottom','下');
  ABTNode.ConvertNode_Real64.Data:=FBottom;


  ABTNode:=ADocNode.AddChildNode_Real64('Width','宽度');
  ABTNode.ConvertNode_Real64.Data:=FWidth;

  ABTNode:=ADocNode.AddChildNode_Real64('Height','高度');
  ABTNode.ConvertNode_Real64.Data:=FHeight;



  ABTNode:=ADocNode.AddChildNode_Bool32('Enabled','是否启用');
  ABTNode.ConvertNode_Bool32.Data:=FEnabled;

  ABTNode:=ADocNode.AddChildNode_Int32('SizeType','尺寸类型');
  ABTNode.ConvertNode_Int32.Data:=Ord(FSizeType);

  ABTNode:=ADocNode.AddChildNode_Int32('PositionHorzType','水平位置类型');
  ABTNode.ConvertNode_Int32.Data:=Ord(FPositionHorzType);

  ABTNode:=ADocNode.AddChildNode_Int32('PositionVertType','垂直位置类型');
  ABTNode.ConvertNode_Int32.Data:=Ord(FPositionVertType);


  Result:=True;
end;
//
//function TDrawRectSetting.SaveToJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  ASuperObject.F['left']:=Self.FLeft;
//  ASuperObject.F['top']:=Self.FTop;
//  ASuperObject.F['right']:=Self.FRight;
//  ASuperObject.F['bottom']:=Self.FBottom;
//  ASuperObject.F['width']:=Self.FWidth;
//  ASuperObject.F['height']:=Self.FHeight;
//
//  ASuperObject.I['enabled']:=Ord(Self.FEnabled);
//
//  ASuperObject.S['size_type']:=GetSizeTypeStr(Self.FSizeType);
//
//  ASuperObject.S['horz_type']:=GetPositionHorzTypeStr(Self.FPositionHorzType);
//  ASuperObject.S['vert_type']:=GetPositionVertTypeStr(Self.FPositionVertType);
//
//  Result:=True;
//end;

procedure TDrawRectSetting.SetBottom(const Value: Double);
begin
  if FBottom<>Value then
  begin
    FBottom := Value;
    DoChange;
  end;
end;

procedure TDrawRectSetting.SetBounds(ALeft, ATop, AWidth, AHeight: Double);
begin
  if (FLeft<>ALeft)
    or (FTop<>ATop)
    or (FWidth<>AWidth)
    or (FHeight<>AHeight) then
  begin
    FLeft:=ALeft;
    FTop:=ATop;
    FWidth:=AWidth;
    FHeight:=AHeight;

    DoChange;
  end;
end;

procedure TDrawRectSetting.SetEnabled(const Value: Boolean);
begin
  if FEnabled<>Value then
  begin
    FEnabled := Value;

    DoChange(True);
  end;
end;

procedure TDrawRectSetting.SetHeight(const Value: Double);
begin
  if FHeight<>Value then
  begin
    FHeight := Value;
    DoChange;
  end;
end;

procedure TDrawRectSetting.SetLeft(const Value: Double);
begin
  if FLeft<>Value then
  begin
    FLeft := Value;
    DoChange;
  end;
end;

procedure TDrawRectSetting.SetMargins(ALeft, ATop, ARight, ABottom: Double);
begin
  if (FLeft<>ALeft)
    or (FTop<>ATop)
    or (FRight<>ARight)
    or (FBottom<>ABottom) then
  begin
    FLeft:=ALeft;
    FTop:=ATop;
    FRight:=ARight;
    FBottom:=ABottom;

    DoChange;
  end;
end;

procedure TDrawRectSetting.SetPositionHorzType(const Value: TDPPositionHorzType);
begin
  if FPositionHorzType<>Value then
  begin
    FPositionHorzType := Value;
    DoChange;
  end;
end;

procedure TDrawRectSetting.SetPositionVertType(const Value: TDPPositionVertType);
begin
  if FPositionVertType<>Value then
  begin
    FPositionVertType := Value;
    DoChange;
  end;
end;

procedure TDrawRectSetting.SetRight(const Value: Double);
begin
  if FRight<>Value then
  begin
    FRight := Value;
    DoChange;
  end;
end;

procedure TDrawRectSetting.SetSizeType(const Value: TDPSizeType);
begin
  if FSizeType<>Value then
  begin
    FSizeType := Value;
    DoChange;
  end;
end;

procedure TDrawRectSetting.SetTop(const Value: Double);
begin
  if FTop<>Value then
  begin
    FTop := Value;
    DoChange;
  end;
end;

procedure TDrawRectSetting.SetWidth(const Value: Double);
begin
  if FWidth<>Value then
  begin
    FWidth := Value;
    DoChange;
  end;
end;







{ TDrawParamCommonEffect }


procedure TDrawParamCommonEffect.AssignTo(Dest: TPersistent);
var
  DestObject:TDrawParamCommonEffect;
begin
  if Dest is TDrawParamCommonEffect then
  begin
    DestObject:=TDrawParamCommonEffect(Dest);

    DestObject.FAlpha:=FAlpha;
    DestObject.FOffset:=FOffset;
    DestObject.FCommonEffectTypes:=FCommonEffectTypes;

    DestObject.DoChange;
  end
  else
  begin
    Inherited;
  end;
end;

procedure TDrawParamCommonEffect.Clear;
begin
end;

constructor TDrawParamCommonEffect.Create;
begin
  FOffset:=1;
  FAlpha:=180;
end;

destructor TDrawParamCommonEffect.Destroy;
begin
  inherited;
end;

procedure TDrawParamCommonEffect.DoChange(Sender:TObject);
begin
  if Assigned(FOnChange) then
  begin
    FOnChange(Self);
  end;
end;

function TDrawParamCommonEffect.HasEffectTypes: Boolean;
begin
  Result:=FCommonEffectTypes<>[];
end;

function TDrawParamCommonEffect.IsAlphaStored: Boolean;
begin
  Result:=(Self.FAlpha<>Const_DefaultEffect_Alpha);
end;

function TDrawParamCommonEffect.IsCommonEffectTypesStored: Boolean;
begin
  Result:=(Self.FCommonEffectTypes<>[]);
end;

function TDrawParamCommonEffect.IsOffsetStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FOffset,Const_DefaultEffect_Offset);
end;

function TDrawParamCommonEffect.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I:Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Clear;


  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='Alpha' then
    begin
      FAlpha:=ABTNode.ConvertNode_UInt8.Data;
    end
    else if ABTNode.NodeName='Offset' then
    begin
      FOffset:=ABTNode.ConvertNode_Real64.Data;
    end
    else if ABTNode.NodeName='CommonEffectTypes' then
    begin
      FCommonEffectTypes:=GetSetFromStr_TDPCommonEffectTypes(ABTNode.ConvertNode_WideString.Data);
    end
    ;
  end;

  Result:=True;
end;

//function TDrawParamCommonEffect.LoadFromJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  Self.FAlpha:=ASuperObject.I['alpha'];
//  Self.FOffset:=ASuperObject.F['offset'];
//  Self.FCommonEffectTypes:=GetCommonEffectTypes(ASuperObject.S['common_effect_types']);
//
//  Result:=True;
//end;

procedure TDrawParamCommonEffect.Mix(AEffect, BEffect: TDrawParamCommonEffect);
begin
  Self.Assign(AEffect);

  Self.FCommonEffectTypes:=AEffect.FCommonEffectTypes+BEffect.FCommonEffectTypes;

  FOffset:=0;
  if (dpcetOffsetChange in AEffect.FCommonEffectTypes) then
  begin
    Self.FOffset:=Self.FOffset+AEffect.Offset;
  end;
  if (dpcetOffsetChange in BEffect.FCommonEffectTypes) then
  begin
    Self.FOffset:=Self.FOffset+BEffect.Offset;
  end;
end;


function TDrawParamCommonEffect.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  //保存类类型
  ADocNode.ClassName:=Self.ClassName;

  ABTNode:=ADocNode.AddChildNode_UInt8('Alpha','透明度');
  ABTNode.ConvertNode_UInt8.Data:=FAlpha;

  ABTNode:=ADocNode.AddChildNode_Real64('Offset','偏移');
  ABTNode.ConvertNode_Real64.Data:=FOffset;

  ABTNode:=ADocNode.AddChildNode_WideString('CommonEffectTypes','通用效果');
  ABTNode.ConvertNode_WideString.Data:=GetStrFromSet_TDPCommonEffectTypes(FCommonEffectTypes);

  Result:=True;
end;

//function TDrawParamCommonEffect.SaveToJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  ASuperObject.I['alpha']:=Self.FAlpha;
//  ASuperObject.F['offset']:=Self.FOffset;
//  ASuperObject.S['common_effect_types']:=GetCommonEffectTypesStr(Self.FCommonEffectTypes);
//
//  Result:=True;
//end;

{ TDrawEffectSetting }

procedure TDrawEffectSetting.AssignTo(Dest: TPersistent);
var
  DestObject:TDrawEffectSetting;
begin
  if Dest is TDrawEffectSetting then
  begin
    DestObject:=TDrawEffectSetting(Dest);

    DestObject.FIsMixedMouseDownAndPushedEffect:=FIsMixedMouseDownAndPushedEffect;

    DestObject.FPushedEffect.Assign(FPushedEffect);
    DestObject.FMouseOverEffect.Assign(FMouseOverEffect);
    DestObject.FMouseDownEffect.Assign(FMouseDownEffect);

    DestObject.FMixedEffect.Assign(FMixedEffect);

    DestObject.DoChange;
  end
  else
  begin
    Inherited;
  end;
end;

procedure TDrawEffectSetting.Clear;
begin
  FIsMixedMouseDownAndPushedEffect:=False;
  FPushedEffect.Clear;
  FMouseOverEffect.Clear;
  FMouseDownEffect.Clear;
  FMixedEffect.Clear;
end;

constructor TDrawEffectSetting.Create;
begin

  FDisabledEffect:=GetDrawParamEffectClass.Create;
  FFocusedEffect:=GetDrawParamEffectClass.Create;

  FPushedEffect:=GetDrawParamEffectClass.Create;
  //只需要它赋值即可,因为设计时没有鼠标点击和停靠效果
  FPushedEffect.FOnChange:=DoChange;

  FMouseOverEffect:=GetDrawParamEffectClass.Create;

  FMouseDownEffect:=GetDrawParamEffectClass.Create;

  FMixedEffect:=GetDrawParamEffectClass.Create;

  FIsMixedMouseDownAndPushedEffect:=False;
end;

destructor TDrawEffectSetting.Destroy;
begin
  FreeAndNil(FDisabledEffect);
  FreeAndNil(FFocusedEffect);
  FreeAndNil(FPushedEffect);
  FreeAndNil(FMouseOverEffect);
  FreeAndNil(FMouseDownEffect);
  FreeAndNil(FMixedEffect);
  inherited;
end;

procedure TDrawEffectSetting.DoChange(Sender:TObject);
begin
  if Assigned(FOnChange) then
  begin
    FOnChange(Self);
  end;
end;

function TDrawEffectSetting.GetDrawParamEffectClass: TDrawParamCommonEffectClass;
begin
  Result:=TDrawParamCommonEffect;
end;

function TDrawEffectSetting.IsIsMixedMouseDownAndPushedEffectStored: Boolean;
begin
  Result:=(FIsMixedMouseDownAndPushedEffect<>False);
end;

function TDrawEffectSetting.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I:Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Clear;


  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='IsMixedMouseDownAndPushedEffect' then
    begin
      FIsMixedMouseDownAndPushedEffect:=ABTNode.ConvertNode_Bool32.Data;
    end



    else if ABTNode.NodeName='MouseDownEffect' then
    begin
      FMouseDownEffect.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    else if ABTNode.NodeName='MouseOverEffect' then
    begin
      FMouseOverEffect.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    else if ABTNode.NodeName='PushedEffect' then
    begin
      FPushedEffect.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end



    ;
  end;

  Result:=True;
end;
//
//function TDrawEffectSetting.LoadFromJson(ASuperObject: ISuperObject): Boolean;
//var
//  AEffectJson:ISuperObject;
//begin
//  Result:=False;
//
//  AEffectJson:=TSuperObject.Create(ASuperObject.S['mousedown_effect_json']);
//  Self.FMouseDownEffect.LoadFromJson(AEffectJson);
//
//  AEffectJson:=TSuperObject.Create(ASuperObject.S['mouseover_effect_json']);
//  Self.FMouseOverEffect.LoadFromJson(AEffectJson);
//
//  AEffectJson:=TSuperObject.Create(ASuperObject.S['pushed_effect_json']);
//  Self.FPushedEffect.LoadFromJson(AEffectJson);
//
//  AEffectJson:=TSuperObject.Create(ASuperObject.S['focused_effect_json']);
//  Self.FFocusedEffect.LoadFromJson(AEffectJson);
//
//  AEffectJson:=TSuperObject.Create(ASuperObject.S['disabled_effect_json']);
//  Self.FDisabledEffect.LoadFromJson(AEffectJson);
//
//
//  Result:=True;
//end;

function TDrawEffectSetting.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  ABTNode:=ADocNode.AddChildNode_Bool32('IsMixedMouseDownAndPushedEffect','是否整合按下和鼠标点击的效果');
  ABTNode.ConvertNode_Bool32.Data:=FIsMixedMouseDownAndPushedEffect;

  ABTNode:=ADocNode.AddChildNode_Class('MouseDownEffect','鼠标点击效果');
  FMouseDownEffect.SaveToDocNode(ABTNode.ConvertNode_Class);

  ABTNode:=ADocNode.AddChildNode_Class('MouseOverEffect','鼠标停靠效果');
  FMouseOverEffect.SaveToDocNode(ABTNode.ConvertNode_Class);

  ABTNode:=ADocNode.AddChildNode_Class('PushedEffect','按下状态效果');
  FPushedEffect.SaveToDocNode(ABTNode.ConvertNode_Class);

  Result:=True;
end;

//function TDrawEffectSetting.SaveToJson(ASuperObject: ISuperObject): Boolean;
//var
//  AEffectJson:ISuperObject;
//begin
//  Result:=False;
//
//  AEffectJson:=TSuperObject.Create();
//  FMouseDownEffect.SaveToJson(AEffectJson);
//  ASuperObject.S['mousedown_effect_json']:=AEffectJson.AsJson;
//
//  AEffectJson:=TSuperObject.Create();
//  FMouseOverEffect.SaveToJson(AEffectJson);
//  ASuperObject.S['mouseover_effect_json']:=AEffectJson.AsJson;
//
//  AEffectJson:=TSuperObject.Create();
//  FPushedEffect.SaveToJson(AEffectJson);
//  ASuperObject.S['pushed_effect_json']:=AEffectJson.AsJson;
//
//  AEffectJson:=TSuperObject.Create();
//  FFocusedEffect.SaveToJson(AEffectJson);
//  ASuperObject.S['focused_effect_json']:=AEffectJson.AsJson;
//
//  AEffectJson:=TSuperObject.Create();
//  FDisabledEffect.SaveToJson(AEffectJson);
//  ASuperObject.S['disabled_effect_json']:=AEffectJson.AsJson;
//
//
//  Result:=True;
//end;

procedure TDrawEffectSetting.SetMouseDownEffect(const Value: TDrawParamCommonEffect);
begin
  FMouseDownEffect.Assign(Value);
end;

procedure TDrawEffectSetting.SetMouseOverEffect(const Value: TDrawParamCommonEffect);
begin
  FMouseOverEffect.Assign(Value);
end;

procedure TDrawEffectSetting.SetPushedEffect(const Value: TDrawParamCommonEffect);
begin
  FPushedEffect.Assign(Value);
end;

procedure TDrawEffectSetting.SetDisabledEffect(const Value: TDrawParamCommonEffect);
begin
  FDisabledEffect.Assign(Value);
end;

procedure TDrawEffectSetting.SetFocusedEffect(const Value: TDrawParamCommonEffect);
begin
  FFocusedEffect.Assign(Value);
end;





end.



