//convert pas to utf8 by ¥
/// <summary>
///   矩形绘制参数
/// </summary>
unit uDrawRectParam;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  Math,

  {$IFDEF VCL}
  Graphics,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Graphics,
  FMX.Types,
  {$ENDIF}

//  XSuperObject,


  uBaseList,
  uDrawParam,
  uFuncCommon,
  Types,
  uDrawPicture,
  uGraphicCommon,
  uBinaryTreeDoc;


type

  TDrawRectParam=class;






  /// <summary>
  ///   <para>
  ///     矩形绘制参数的效果类型
  ///   </para>
  ///   <para>
  ///     Effect types of drawing rectangle parameters
  ///   </para>
  /// </summary>
  TDRPEffectType=( //
                   /// <summary>
                   ///   <para>
                   ///   填充颜色更改
                   ///   </para>
                   ///   <para>
                   ///    Change fill color
                   ///   </para>
                   /// </summary>
                   drpetFillColorChange,
                   /// <summary>
                   ///   是否填充更改
                   ///   <para>
                   ///    Change whether fill
                   ///   </para>
                   /// </summary>
                   drpetIsFillChange,
                   /// <summary>
                   ///   边框宽度更改
                   ///   <para>
                   ///    Change border width
                   ///   </para>
                   /// </summary>
                   drpetBorderWidthChange,
                   /// <summary>
                   ///   边框颜色更改
                   ///   <para>
                   ///    Change border color
                   ///   </para>
                   /// </summary>
                   drpetBorderColorChange
                   );
  /// <summary>
  ///   <para>
  ///     矩形绘制效果参数类型集合
  ///   </para>
  ///   <para>
  ///     Set of drawing rectangle effect parameters type
  ///   </para>
  /// </summary>
  TDRPEffectTypes=set of TDRPEffectType;


  TDRPBrushKind=(drpbkNone,
                drpbkFill,
                drpbkGradient);





  /// <summary>
  ///   <para>
  ///     矩形绘制参数的效果
  ///   </para>
  ///   <para>
  ///     Parameters Effect of drawing rectangle
  ///   </para>
  /// </summary>
  TDrawRectParamEffect=class(TDrawParamCommonEffect)
  private
    FIsFill: Boolean;
    FFillDrawColor: TDrawColor;
    FBorderDrawColor: TDrawColor;
    FBorderWidth:TControlSize;

    FEffectTypes: TDRPEffectTypes;
    FFillColorChangeType: TColorChangeType;
    function IsRectBorderWidthStored: Boolean;
    function IsEffectTypesStored: Boolean;
    function IsIsFillStored: Boolean;
    procedure SetBorderWidth(const Value: TControlSize);
    procedure SetEffectTypes(const Value: TDRPEffectTypes);
    procedure SetFillDrawColor(const Value: TDrawColor);
    procedure SetIsFill(const Value: Boolean);
    procedure SetBorderDrawColor(const Value: TDrawColor);
    procedure SetFillColorChangeType(const Value: TColorChangeType);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
//    function LoadFromJson(ASuperObject:ISuperObject):Boolean;override;
//    function SaveToJson(ASuperObject:ISuperObject):Boolean;override;
  public
    constructor Create;override;
    destructor Destroy;override;
  public
    //
    /// <summary>
    ///   <para>
    ///     是否包含效果类型
    ///   </para>
    ///   <para>
    ///     Whether have effect type
    ///   </para>
    /// </summary>
    function HasEffectTypes:Boolean;override;

    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;

    /// <summary>
    ///   <para>
    ///     保存到文档节点
    ///   </para>
    ///   <para>
    ///     Save to document node
    ///   </para>
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  published

    /// <summary>
    ///   <para>
    ///     边框宽度
    ///   </para>
    ///   <para>
    ///     Border Width
    ///   </para>
    /// </summary>
    property BorderWidth:TControlSize read FBorderWidth write SetBorderWidth stored IsRectBorderWidthStored;

    /// <summary>
    ///   <para>
    ///     是否填充矩形
    ///   </para>
    ///   <para>
    ///     whether fill rectangle
    ///   </para>
    /// </summary>
    property IsFill:Boolean read FIsFill write SetIsFill stored IsIsFillStored;

    /// <summary>
    ///   <para>
    ///     填充颜色
    ///   </para>
    ///   <para>
    ///     Fill Color
    ///   </para>
    /// </summary>
    property FillColor:TDrawColor read FFillDrawColor write SetFillDrawColor;
    property FillColorChangeType:TColorChangeType read FFillColorChangeType write SetFillColorChangeType;
    property BorderColor:TDrawColor read FBorderDrawColor write SetBorderDrawColor;

    /// <summary>
    ///   <para>
    ///     效果类型集合,一个状态可以有多个效果
    ///   </para>                                         =
    ///   <para>
    ///     Set of effect type,one state can have several effects
    ///   </para>
    /// </summary>
    property EffectTypes:TDRPEffectTypes read FEffectTypes write SetEffectTypes stored IsEffectTypesStored;//default [];
  end;




  TDrawRectEffectSetting=class(TDrawEffectSetting)
  private
    function GetMouseDownEffect: TDrawRectParamEffect;
    function GetMouseOverEffect: TDrawRectParamEffect;
    function GetPushedEffect: TDrawRectParamEffect;
    procedure SetMouseDownEffect(const Value: TDrawRectParamEffect);
    procedure SetMouseOverEffect(const Value: TDrawRectParamEffect);
    procedure SetPushedEffect(const Value: TDrawRectParamEffect);
    procedure SetDisabledEffect(const Value: TDrawRectParamEffect);
    procedure SetFocusedEffect(const Value: TDrawRectParamEffect);
    function GetDisabledEffect: TDrawRectParamEffect;
    function GetFocusedEffect: TDrawRectParamEffect;
  protected
    function GetDrawParamEffectClass:TDrawParamCommonEffectClass;override;
  published
    //禁用状态的效果
    property DisabledEffect: TDrawRectParamEffect read GetDisabledEffect write SetDisabledEffect;
    //获得焦点的效果
    property FocusedEffect: TDrawRectParamEffect read GetFocusedEffect write SetFocusedEffect;
    property MouseDownEffect:TDrawRectParamEffect read GetMouseDownEffect write SetMouseDownEffect;
    property MouseOverEffect:TDrawRectParamEffect read GetMouseOverEffect write SetMouseOverEffect;
    property PushedEffect:TDrawRectParamEffect read GetPushedEffect write SetPushedEffect;
  end;



  TDrawRectParamSetting=class(TDrawParamSetting)
  private
    function IsMouseDownBorderWidthChangeStored: Boolean;
    function IsMouseDownBorderWidthStored: Boolean;
    function IsMouseDownFillColorChangeStored: Boolean;
    function IsMouseDownFillColorStored: Boolean;
    function IsMouseDownIsFillChangeStored: Boolean;
    function IsMouseDownIsFillStored: Boolean;
    function IsMouseOverBorderWidthChangeStored: Boolean;
    function IsMouseOverBorderWidthStored: Boolean;
    function IsMouseOverFillColorChangeStored: Boolean;
    function IsMouseOverFillColorStored: Boolean;
    function IsMouseOverIsFillChangeStored: Boolean;
    function IsMouseOverIsFillStored: Boolean;
    function IsPushedBorderWidthChangeStored: Boolean;
    function IsPushedBorderWidthStored: Boolean;
    function IsPushedFillColorChangeStored: Boolean;
    function IsPushedFillColorStored: Boolean;
    function IsPushedIsFillChangeStored: Boolean;
    function IsPushedIsFillStored: Boolean;
  protected
    FDrawRectParam:TDrawRectParam;

    function GetMouseDownFillColor: TDelphiColor;
    function GetMouseDownFillColorChange: Boolean;
    function GetMouseOverFillColor: TDelphiColor;
    function GetMouseOverFillColorChange: Boolean;
    function GetPushedFillColor: TDelphiColor;
    function GetPushedFillColorChange: Boolean;

    function GetMouseDownBorderWidth: TControlSize;
    function GetMouseDownBorderWidthChange: Boolean;
    function GetMouseOverBorderWidth: TControlSize;
    function GetMouseOverBorderWidthChange: Boolean;
    function GetPushedBorderWidth: TControlSize;
    function GetPushedBorderWidthChange: Boolean;

    function GetMouseDownIsFill: Boolean;
    function GetMouseDownIsFillChange: Boolean;
    function GetMouseOverIsFill: Boolean;
    function GetMouseOverIsFillChange: Boolean;
    function GetPushedIsFill: Boolean;
    function GetPushedIsFillChange: Boolean;

    procedure SetMouseDownIsFill(const Value: Boolean);
    procedure SetMouseDownIsFillChange(const Value: Boolean);
    procedure SetMouseOverIsFill(const Value: Boolean);
    procedure SetMouseOverIsFillChange(const Value: Boolean);
    procedure SetPushedIsFill(const Value: Boolean);
    procedure SetPushedIsFillChange(const Value: Boolean);

    procedure SetMouseDownBorderWidth(const Value: TControlSize);
    procedure SetMouseDownBorderWidthChange(const Value: Boolean);
    procedure SetMouseOverBorderWidth(const Value: TControlSize);
    procedure SetMouseOverBorderWidthChange(const Value: Boolean);
    procedure SetPushedBorderWidth(const Value: TControlSize);
    procedure SetPushedBorderWidthChange(const Value: Boolean);

    procedure SetMouseDownFillColor(const Value: TDelphiColor);
    procedure SetMouseDownFillColorChange(const Value: Boolean);
    procedure SetMouseOverFillColor(const Value: TDelphiColor);
    procedure SetMouseOverFillColorChange(const Value: Boolean);
    procedure SetPushedFillColor(const Value: TDelphiColor);
    procedure SetPushedFillColorChange(const Value: Boolean);
  public
    constructor Create(ADrawParam:TDrawParam);override;
  public
    property MouseDownIsFill:Boolean read GetMouseDownIsFill write SetMouseDownIsFill stored IsMouseDownIsFillStored;
    property MouseDownIsFillChange:Boolean read GetMouseDownIsFillChange write SetMouseDownIsFillChange stored IsMouseDownIsFillChangeStored;
    property MouseOverIsFill:Boolean read GetMouseOverIsFill write SetMouseOverIsFill stored IsMouseOverIsFillStored;
    property MouseOverIsFillChange:Boolean read GetMouseOverIsFillChange write SetMouseOverIsFillChange stored IsMouseOverIsFillChangeStored;
    property PushedIsFill:Boolean read GetPushedIsFill write SetPushedIsFill stored IsPushedIsFillStored;
    property PushedIsFillChange:Boolean read GetPushedIsFillChange write SetPushedIsFillChange stored IsPushedIsFillChangeStored;
  published
    property MouseDownFillColor:TDelphiColor read GetMouseDownFillColor write SetMouseDownFillColor stored IsMouseDownFillColorStored;
    property MouseDownFillColorChange:Boolean read GetMouseDownFillColorChange write SetMouseDownFillColorChange stored IsMouseDownFillColorChangeStored;
    property MouseDownBorderWidth:TControlSize read GetMouseDownBorderWidth write SetMouseDownBorderWidth stored IsMouseDownBorderWidthStored;
    property MouseDownBorderWidthChange:Boolean read GetMouseDownBorderWidthChange write SetMouseDownBorderWidthChange stored IsMouseDownBorderWidthChangeStored;

    property MouseOverFillColor:TDelphiColor read GetMouseOverFillColor write SetMouseOverFillColor stored IsMouseOverFillColorStored;
    property MouseOverFillColorChange:Boolean read GetMouseOverFillColorChange write SetMouseOverFillColorChange stored IsMouseOverFillColorChangeStored;
    property MouseOverBorderWidth:TControlSize read GetMouseOverBorderWidth write SetMouseOverBorderWidth stored IsMouseOverBorderWidthStored;
    property MouseOverBorderWidthChange:Boolean read GetMouseOverBorderWidthChange write SetMouseOverBorderWidthChange stored IsMouseOverBorderWidthChangeStored;

    property PushedFillColor:TDelphiColor read GetPushedFillColor write SetPushedFillColor stored IsPushedFillColorStored;
    property PushedFillColorChange:Boolean read GetPushedFillColorChange write SetPushedFillColorChange stored IsPushedFillColorChangeStored;
    property PushedBorderWidth:TControlSize read GetPushedBorderWidth write SetPushedBorderWidth stored IsPushedBorderWidthStored;
    property PushedBorderWidthChange:Boolean read GetPushedBorderWidthChange write SetPushedBorderWidthChange stored IsPushedBorderWidthChangeStored;
  end;







  /// <summary>
  ///   <para>
  ///     边框类型
  ///   </para>
  ///   <para>
  ///     Border Type
  ///   </para>
  /// </summary>
  TDRPBorderEadge=(
                /// <summary>
                ///   左边框
                ///   <para>
                ///     Left Border
                ///   </para>
                /// </summary>
                beLeft,
                /// <summary>
                ///   上边框
                ///   <para>
                ///     Top Border
                ///   </para>
                /// </summary>
                beTop,
                /// <summary>
                ///   右边框
                ///   <para>
                ///     Right Border
                ///   </para>
                /// </summary>
                beRight,
                /// <summary>
                ///   底边框
                ///   <para>
                ///     Bottom Border
                ///   </para>
                /// </summary>
                beBottom
                );
  /// <summary>
  ///   <para>
  ///     边框类型集合
  ///   </para>
  ///   <para>
  ///     Set of border types
  ///   </para>
  /// </summary>
  TDRPBorderEadges=set of TDRPBorderEadge;



  /// <summary>
  ///   <para>
  ///     角
  ///   </para>
  ///   <para>
  ///     Corner
  ///   </para>
  /// </summary>
  TDRPRectCorner=(
                /// <summary>
                ///   左上角
                ///   <para>
                ///    Top Left Corner
                ///   </para>
                /// </summary>
                rcTopLeft,
                /// <summary>
                ///   右上角
                ///   <para>
                ///    Top Right Corner
                ///   </para>
                /// </summary>
                rcTopRight,
                /// <summary>
                ///   左下角
                ///   <para>
                ///     Bottom Left Corner
                ///   </para>
                /// </summary>
                rcBottomLeft,
                /// <summary>
                ///   右下角
                ///  Bottom Right Corner
                /// </summary>
                rcBottomRight
                );
  /// <summary>
  ///   <para>
  ///     角集合
  ///   </para>
  ///   <para>
  ///     Set of corner
  ///   </para>
  /// </summary>
  TDRPRectCorners=set of TDRPRectCorner;




  /// <summary>
  ///   <para>
  ///     线条的位置
  ///   </para>
  ///   <para>
  ///     Line Position
  ///   </para>
  /// </summary>
  TDRPLinePosition=(
                  /// <summary>
                  ///   左边
                  ///   <para>
                  ///     Left
                  ///   </para>
                  /// </summary>
                  lpLeft,
                  /// <summary>
                  ///   上边
                  ///   <para>
                  ///     Top
                  ///   </para>
                  /// </summary>
                  lpTop,
                  /// <summary>
                  ///   右边
                  ///   <para>
                  ///     Right
                  ///   </para>
                  /// </summary>
                  lpRight,
                  /// <summary>
                  ///   底边
                  ///   <para>
                  ///     Bottom
                  ///   </para>
                  /// </summary>
                  lpBottom
                  );


//  TSkinGradient=class(TGradient)
//  private
//    function GetColor: TDelphiColor;
//    function GetColor1: TDelphiColor;
//    procedure SetColor(const Value: TDelphiColor);
//    procedure SetColor1(const Value: TDelphiColor);
//  published
//    property Color: TDelphiColor read GetColor write SetColor;
//    property Color1: TDelphiColor read GetColor1 write SetColor1;
////    property GradientStyle: TGradientStyle read GetGradientStyle write SetGradientStyle stored IsGradientStored;
//  end;



  /// <summary>
  ///   <para>
  ///     矩形绘制参数
  ///   </para>
  ///   <para>
  ///     Parameters of drawing rectangle
  ///   </para>
  /// </summary>
  TBaseDrawRectParam=class(TDrawParam)
  private
    FIsFill: Boolean;
    FFillDrawColor: TDrawColor;
    FTempFillDrawColor: TDrawColor;

    FBorderDrawColor: TDrawColor;
    FBorderWidth: TControlSize;
    FBorderEadges: TDRPBorderEadges;

    FRectCorners:TDRPRectCorners;


    FIsLine: Boolean;
    FLinePosition:TDRPLinePosition;

    FIsRound:Boolean;
    FRoundWidth: TControlSize;
    FRoundHeight: TControlSize;


    {$IFDEF FMX}
    FBrushKind: TDRPBrushKind;
    FGradient: TGradient;
    procedure SetGradient(const Value: TGradient);
    function IsGradientStored: Boolean;
    procedure SetBrushKind(const Value: TDRPBrushKind);
    {$ENDIF FMX}


    procedure SetBorderDrawColor(const Value: TDrawColor);
    procedure SetFillDrawColor(const Value: TDrawColor);
    procedure SetBorderWidth(const Value: TControlSize);
    procedure SetRoundWidth(const Value: TControlSize);
    procedure SetIsFill(const Value: Boolean);
    procedure SetIsRound(const Value: Boolean);
    procedure SetRoundHeight(const Value: TControlSize);
    procedure SetBorderEadges(const Value: TDRPBorderEadges);
    procedure SetRectCorners(const Value: TDRPRectCorners);
    procedure SetLinePosition(const Value: TDRPLinePosition);
    procedure SetIsLine(const Value: Boolean);

    procedure SetClipRoundHeight(const Value: TControlSize);
    procedure SetClipRoundWidth(const Value: TControlSize);
    procedure SetClipRoundRectSetting(const Value: TDrawRectSetting);

    function GetDrawEffectSetting: TDrawRectEffectSetting;
    procedure SetDrawEffectSetting(const Value: TDrawRectEffectSetting);
//    function GetSetting: TDrawRectParamSetting;
//    procedure SetSetting(const Value: TDrawRectParamSetting);
  private
    function IsBorderEadgesStored: Boolean;
    function IsRectParamBorderWidthStored: Boolean;
    function IsIsLineStored: Boolean;
    function IsIsRoundStored: Boolean;
    function IsLinePositionStored: Boolean;
    function IsRectCornersStored: Boolean;
    function IsRoundHeightStored: Boolean;
    function IsRoundWidthStored: Boolean;
    function IsIsFillStored: Boolean;virtual;


    {$IFDEF FMX}
    function GetGradientColor: TDelphiColor;
    procedure SetGradientColor(const Value: TDelphiColor);
    function GetGradientColor1: TDelphiColor;
    procedure SetGradientColor1(const Value: TDelphiColor);
    function GetGradientStyle: TGradientStyle;
    procedure SetGradientStyle(const Value: TGradientStyle);
    function GetGradientStartPosition: TPosition;
    function GetGradientStopPosition: TPosition;
    procedure SetGradientStartPosition(const Value: TPosition);
    procedure SetGradientStopPosition(const Value: TPosition);
    {$ENDIF FMX}
  protected
    /// <summary>
    ///   <para>
    ///     获取绘制参数效果类
    ///   </para>
    ///   <para>
    ///     Get effect class of drawing parameters
    ///   </para>
    /// </summary>
    function GetDrawEffectSettingClass:TDrawEffectSettingClass;override;
    function GetDrawParamSettingClass:TDrawParamSettingClass;override;
    /// <summary>
    ///   <para>
    ///     复制
    ///   </para>
    ///   <para>
    ///     Copy
    ///   </para>
    /// </summary>
    procedure AssignTo(Dest: TPersistent); override;
  public
    //是否中空
    FIsClipRound:Boolean;

    FClipRoundWidth:TControlSize;
    FClipRoundHeight:TControlSize;
    FClipRoundRectSetting:TDrawRectSetting;

    //中心圆的半径
    property ClipRoundWidth:TControlSize read FClipRoundWidth write SetClipRoundWidth;
    property ClipRoundHeight:TControlSize read FClipRoundHeight write SetClipRoundHeight;
    //中心圆的绘制矩形设置
    property ClipRoundRectSetting:TDrawRectSetting read FClipRoundRectSetting write SetClipRoundRectSetting;
  public
    //
    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //
    /// <summary>
    ///   <para>
    ///     保存到文档节点
    ///   </para>
    ///   <para>
    ///     Save to document node
    ///   </para>
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
//    function CustomLoadFromJson(ASuperObject:ISuperObject):Boolean;override;
//    function CustomSaveToJson(ASuperObject:ISuperObject):Boolean;override;
  public

    /// <summary>
    ///   <para>
    ///     当前效果的填充颜色
    ///   </para>
    ///   <para>
    ///     Fill color of current effect
    ///   </para>
    /// </summary>
    function CurrentEffectFillDrawColor:TDrawColor;
    /// <summary>
    ///   <para>
    ///     当前效果的是否填充
    ///   </para>
    ///   <para>
    ///     Whether fill current effect
    ///   </para>
    /// </summary>
    function CurrentEffectIsFill:Boolean;
    /// <summary>
    ///   <para>
    ///     当前效果的边框宽度
    ///   </para>
    ///   <para>
    ///     Border width of current effect
    ///   </para>
    /// </summary>
    function CurrentEffectBorderWidth:TControlSize;
    /// <summary>
    ///   <para>
    ///     当前效果的边框颜色
    ///   </para>
    ///   <para>
    ///     Border color of current effect
    ///   </para>
    /// </summary>
    function CurrentEffectBorderColor:TDrawColor;

  public
    //
    /// <summary>
    ///   <para>
    ///     初始化参数
    ///   </para>
    ///   <para>
    ///     Initialize Parameter
    ///   </para>
    /// </summary>
    procedure Clear;override;
  public
    constructor Create(const AName:String;const ACaption:String);override;
    destructor Destroy;override;
  public
    /// <summary>
    ///   <para>
    ///     静态地设置角集合
    ///   </para>
    ///   <para>
    ///     Set Corners staticly
    ///   </para>
    /// </summary>
    property StaticRectCorners:TDRPRectCorners read FRectCorners write FRectCorners;
    property StaticIsFill:Boolean read FIsFill write FIsFill;
  public
    {$IFDEF FMX}
    property Gradient: TGradient read FGradient write SetGradient stored IsGradientStored;
//    property GradientColor: TDelphiColor read GetGradientColor write SetGradientColor stored IsGradientStored;
    property GradientColor1: TDelphiColor read GetGradientColor1 write SetGradientColor1 stored IsGradientStored;
    property GradientStyle: TGradientStyle read GetGradientStyle write SetGradientStyle stored IsGradientStored;
    property GradientStartPosition: TPosition read GetGradientStartPosition write SetGradientStartPosition stored IsGradientStored;
    property GradientStopPosition: TPosition read GetGradientStopPosition write SetGradientStopPosition stored IsGradientStored;
    property BrushKind:TDRPBrushKind read FBrushKind write SetBrushKind default drpbkFill;
    {$ENDIF}


//    {$IFDEF FMX}
    /// <summary>
    ///   <para>
    ///     边框集合
    ///   </para>
    ///   <para>
    ///     Set of border
    ///   </para>
    /// </summary>
    property BorderEadges:TDRPBorderEadges read FBorderEadges write SetBorderEadges stored IsBorderEadgesStored;

    //
    /// <summary>
    ///   <para>
    ///     角集合
    ///   </para>
    ///   <para>
    ///     Set of corner
    ///   </para>
    /// </summary>
    property RectCorners:TDRPRectCorners read FRectCorners write SetRectCorners stored IsRectCornersStored;



    /// <summary>
    ///   <para>
    ///     是否是线段
    ///   </para>
    ///   <para>
    ///     Whether is line
    ///   </para>
    /// </summary>
    property IsLine:Boolean read FIsLine write SetIsLine stored IsIsLineStored;

    /// <summary>
    ///   <para>
    ///     线段的位置
    ///   </para>
    ///   <para>
    ///     Position of line
    ///   </para>
    /// </summary>
    property LinePosition:TDRPLinePosition read FLinePosition write SetLinePosition stored IsLinePositionStored;
//    {$ENDIF}



    /// <summary>
    ///   <para>
    ///     是否填充
    ///   </para>
    ///   <para>
    ///     Whether fill
    ///   </para>
    /// </summary>
    property IsFill:Boolean read FIsFill write SetIsFill stored IsIsFillStored;
    /// <summary>
    ///   <para>
    ///     填充颜色
    ///   </para>
    ///   <para>
    ///     Fill Color
    ///   </para>
    /// </summary>
    property FillDrawColor:TDrawColor read FFillDrawColor write SetFillDrawColor;
    /// <summary>
    ///   <para>
    ///     边框颜色
    ///   </para>
    ///   <para>
    ///     Border Color
    ///   </para>
    /// </summary>
    property BorderDrawColor:TDrawColor read FBorderDrawColor write SetBorderDrawColor;





    /// <summary>
    ///   <para>
    ///     是否圆角
    ///   </para>
    ///   <para>
    ///     Whether is round corner
    ///   </para>
    /// </summary>
    property IsRound:Boolean read FIsRound write SetIsRound stored IsIsRoundStored;
    /// <summary>
    ///   <para>
    ///     圆角宽度
    ///   </para>
    ///   <para>
    ///     Round Width
    ///   </para>
    /// </summary>
    property RoundWidth:TControlSize read FRoundWidth write SetRoundWidth stored IsRoundWidthStored;
    //
    /// <summary>
    ///   <para>
    ///     圆角高度
    ///   </para>
    ///   <para>
    ///     Round Height
    ///   </para>
    /// </summary>
    property RoundHeight:TControlSize read FRoundHeight write SetRoundHeight stored IsRoundHeightStored;




    /// <summary>
    ///   <para>
    ///     边框宽度
    ///   </para>
    ///   <para>
    ///     Border Width
    ///   </para>
    /// </summary>
    property BorderWidth:TControlSize read FBorderWidth write SetBorderWidth stored IsRectParamBorderWidthStored;





//    /// <summary>
//    ///   <para>
//    ///     绘制矩形的设置
//    ///   </para>
//    ///   <para>
//    ///     Setting of DrawRectangle
//    ///   </para>
//    /// </summary>
//    property DrawRectSetting;

    property DrawEffectSetting:TDrawRectEffectSetting read GetDrawEffectSetting write SetDrawEffectSetting;

    //高级设置,DrawEffectSetting+DrawRectSetting
//    property Setting:TDrawRectParamSetting read GetSetting write SetSetting;
  end;





//  TBaseNewDrawRectParam=class(TBaseDrawRectParam)
//  private
//    function GetBorderColor: TDelphiColor;
//    function GetFillColor: TDelphiColor;
//    procedure SetBorderColor(const Value: TDelphiColor);
//    procedure SetFillColor(const Value: TDelphiColor);
//    function GetRoundRadius: TControlSize;
//    procedure SetRoundRadius(const Value: TControlSize);
//    function IsBorderColorStored: Boolean;
//    function IsFillColorStored: Boolean;
//  protected
//    function IsIsFillStored: Boolean;override;
//  public
//    procedure Clear;override;
//  public
//    //圆角半径
//    property RoundRadius:TControlSize read GetRoundRadius write SetRoundRadius;
//    //填充色
//    property FillColor:TDelphiColor read GetFillColor write SetFillColor stored IsFillColorStored;
//    //边框色
//    property BorderColor:TDelphiColor read GetBorderColor write SetBorderColor stored IsBorderColorStored;
//  end;






  TDrawRectParam=class(TBaseDrawRectParam)
  published
    {$IFDEF FMX}
//    property GradientColor;//: TDelphiColor read GetGradientColor write SetGradientColor;// stored IsGradientStored;
    property GradientColor1;//: TDelphiColor read GetGradientColor1 write SetGradientColor1;// stored IsGradientStored;
//    property Gradient;
    property GradientStyle;//: TGradientStyle read GetGradientStyle write SetGradientStyle stored IsGradientStored;
    property GradientStartPosition;//: TPosition read GetGradientStartPosition write SetGradientStartPosition stored IsGradientStored;
    property GradientStopPosition;//: TPosition read GetGradientStopPosition write SetGradientStopPosition stored IsGradientStored;
    {$ENDIF}

    property BorderEadges;
    {$IFDEF FMX}
    property IsLine;
    property LinePosition;
    property BrushKind;
    {$ENDIF}
    property RectCorners;
    property IsFill;
    property FillColor:TDrawColor read FFillDrawColor write SetFillDrawColor;
    property IsRound;
    property RoundWidth;
    property RoundHeight;
    property BorderColor:TDrawColor read FBorderDrawColor write SetBorderDrawColor;
    property BorderWidth;

    property DrawRectSetting;
    property DrawEffectSetting;
  end;






var
  GlobalDrawRectParam:TBaseDrawRectParam;




function GetBorderEadgesStr(ABorderEadges:TDRPBorderEadges):String;
function GetBorderEadges(ABorderEadgesStr:String):TDRPBorderEadges;

function GetRectCornersStr(ARectCorners:TDRPRectCorners):String;
function GetRectCorners(ARectCornersStr:String):TDRPRectCorners;


function GetLinePositionStr(ALinePosition:TDRPLinePosition):String;
function GetLinePosition(ALinePositionStr:String):TDRPLinePosition;


function GetDRPEffectTypesStr(ADRPEffectTypes:TDRPEffectTypes):String;
function GetDRPEffectTypes(ADRPEffectTypesStr:String):TDRPEffectTypes;






implementation


uses
  uDrawCanvas;



function GetDRPEffectTypesStr(ADRPEffectTypes:TDRPEffectTypes):String;
begin
  Result:='';
  if drpetFillColorChange in ADRPEffectTypes then
  begin
    Result:=Result+'FillColorChange';
  end;
  if drpetIsFillChange in ADRPEffectTypes then
  begin
    Result:=Result+'IsFillChange';
  end;
  if drpetBorderWidthChange in ADRPEffectTypes then
  begin
    Result:=Result+'BorderWidthChange';
  end;
  if drpetBorderColorChange in ADRPEffectTypes then
  begin
    Result:=Result+'BorderColorChange';
  end;
end;

function GetDRPEffectTypes(ADRPEffectTypesStr:String):TDRPEffectTypes;
var
  AStringList:TStringList;
begin
  Result:=[];
  AStringList:=TStringList.Create;
  try
    AStringList.CommaText:=ADRPEffectTypesStr;
    if AStringList.IndexOf('FillColorChange')<>-1 then
    begin
      Result:=Result+[TDRPEffectType.drpetFillColorChange];
    end;
    if AStringList.IndexOf('IsFillChange')<>-1 then
    begin
      Result:=Result+[TDRPEffectType.drpetIsFillChange];
    end;
    if AStringList.IndexOf('BorderWidthChange')<>-1 then
    begin
      Result:=Result+[TDRPEffectType.drpetBorderWidthChange];
    end;
    if AStringList.IndexOf('BorderColorChange')<>-1 then
    begin
      Result:=Result+[TDRPEffectType.drpetBorderColorChange];
    end;
  finally
    FreeAndNil(AStringList);
  end;
end;

function GetLinePositionStr(ALinePosition:TDRPLinePosition):String;
begin
  case ALinePosition of
    lpLeft: Result:='Left';
    lpTop: Result:='Top';
    lpRight: Result:='Right';
    lpBottom: Result:='Bottom';
  end;
end;

function GetLinePosition(ALinePositionStr:String):TDRPLinePosition;
begin
  Result:=TDRPLinePosition.lpLeft;
  if SameText(ALinePositionStr,'Left') then
  begin
    Result:=TDRPLinePosition.lpLeft;
  end;
  if SameText(ALinePositionStr,'Top') then
  begin
    Result:=TDRPLinePosition.lpTop;
  end;
  if SameText(ALinePositionStr,'Right') then
  begin
    Result:=TDRPLinePosition.lpRight;
  end;
  if SameText(ALinePositionStr,'Bottom') then
  begin
    Result:=TDRPLinePosition.lpBottom;
  end;

end;

function GetRectCornersStr(ARectCorners:TDRPRectCorners):String;
begin
  Result:='';
  if TDRPRectCorner.rcTopLeft in ARectCorners then
  begin
    Result:=Result+'TopLeft'+',';
  end;
  if TDRPRectCorner.rcTopRight in ARectCorners then
  begin
    Result:=Result+'TopRight'+',';
  end;
  if TDRPRectCorner.rcBottomLeft in ARectCorners then
  begin
    Result:=Result+'BottomLeft'+',';
  end;
  if TDRPRectCorner.rcBottomRight in ARectCorners then
  begin
    Result:=Result+'BottomRight'+',';
  end;
end;

function GetRectCorners(ARectCornersStr:String):TDRPRectCorners;
var
  AStringList:TStringList;
begin
  Result:=[];
  AStringList:=TStringList.Create;
  try
    AStringList.CommaText:=ARectCornersStr;
    if AStringList.IndexOf('TopLeft')<>-1 then
    begin
      Result:=Result+[TDRPRectCorner.rcTopLeft];
    end;
    if AStringList.IndexOf('TopRight')<>-1 then
    begin
      Result:=Result+[TDRPRectCorner.rcTopRight];
    end;
    if AStringList.IndexOf('BottomLeft')<>-1 then
    begin
      Result:=Result+[TDRPRectCorner.rcBottomLeft];
    end;
    if AStringList.IndexOf('BottomRight')<>-1 then
    begin
      Result:=Result+[TDRPRectCorner.rcBottomRight];
    end;
  finally
    FreeAndNil(AStringList);
  end;
end;



function GetBorderEadgesStr(ABorderEadges:TDRPBorderEadges):String;
begin
  Result:='';
  if TDRPBorderEadge.beLeft in ABorderEadges then
  begin
    Result:=Result+'Left'+',';
  end;
  if TDRPBorderEadge.beTop in ABorderEadges then
  begin
    Result:=Result+'Top'+',';
  end;
  if TDRPBorderEadge.beRight in ABorderEadges then
  begin
    Result:=Result+'Right'+',';
  end;
  if TDRPBorderEadge.beBottom in ABorderEadges then
  begin
    Result:=Result+'Bottom'+',';
  end;
end;

function GetBorderEadges(ABorderEadgesStr:String):TDRPBorderEadges;
var
  AStringList:TStringList;
begin
  Result:=[];
  AStringList:=TStringList.Create;
  try
    AStringList.CommaText:=ABorderEadgesStr;
    if AStringList.IndexOf('Left')<>-1 then
    begin
      Result:=Result+[TDRPBorderEadge.beLeft];
    end;
    if AStringList.IndexOf('Top')<>-1 then
    begin
      Result:=Result+[TDRPBorderEadge.beTop];
    end;
    if AStringList.IndexOf('Right')<>-1 then
    begin
      Result:=Result+[TDRPBorderEadge.beRight];
    end;
    if AStringList.IndexOf('Bottom')<>-1 then
    begin
      Result:=Result+[TDRPBorderEadge.beBottom];
    end;
  finally
    FreeAndNil(AStringList);
  end;
end;



//将TDRPEffectTypes转换为字符串
function GetStrFromSet_TDRPEffectTypes(ASet:TDRPEffectTypes):String;
var
  I:TDRPEffectType;
begin
  Result:='';
  for I := Low(TDRPEffectType) to High(TDRPEffectType) do
  begin
    if I in ASet then
    begin
      Result:=Result+IntToStr(Ord(I))+',';
    end;
  end;
end;

//将字符串转换为TDRPEffectTypes
function GetSetFromStr_TDRPEffectTypes(const ASetStr:String):TDRPEffectTypes;
var
  I,AElem:Integer;
  J:TDRPEffectType;
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
        for J := Low(TDRPEffectType) to High(TDRPEffectType) do
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

//将TDRPBorderEadges转换为字符串
function GetStrFromSet_TDRPBorderEadges(ASet:TDRPBorderEadges):String;
var
  I:TDRPBorderEadge;
begin
  Result:='';
  for I := Low(TDRPBorderEadge) to High(TDRPBorderEadge) do
  begin
    if I in ASet then
    begin
      Result:=Result+IntToStr(Ord(I))+',';
    end;
  end;
end;

//将字符串转换为TDRPBorderEadges
function GetSetFromStr_TDRPBorderEadges(const ASetStr:String):TDRPBorderEadges;
var
  I,AElem:Integer;
  J:TDRPBorderEadge;
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
        for J := Low(TDRPBorderEadge) to High(TDRPBorderEadge) do
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

//将TDRPRectCorners转换为字符串
function GetStrFromSet_TDRPRectCorners(ASet:TDRPRectCorners):String;
var
  I:TDRPRectCorner;
begin
  Result:='';
  for I := Low(TDRPRectCorner) to High(TDRPRectCorner) do
  begin
    if I in ASet then
    begin
      Result:=Result+IntToStr(Ord(I))+',';
    end;
  end;
end;

//将字符串转换为TDRPRectCorners
function GetSetFromStr_TDRPRectCorners(const ASetStr:String):TDRPRectCorners;
var
  I,AElem:Integer;
  J:TDRPRectCorner;
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
        for J := Low(TDRPRectCorner) to High(TDRPRectCorner) do
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




{ TBaseDrawRectParam }

function TBaseDrawRectParam.CurrentEffectFillDrawColor: TDrawColor;
begin
  Result:=Self.FFillDrawColor;
  if (CurrentEffect<>nil) and (drpetFillColorChange in TDrawRectParamEffect(CurrentEffect).FEffectTypes) then
  begin
    case TDrawRectParamEffect(CurrentEffect).FFillColorChangeType of
      cctNone:
          Result:=TDrawRectParamEffect(CurrentEffect).FFillDrawColor;
      cctBrightness:
        begin
//          FTempFillDrawColor.Assign(FFillDrawColor);
          FTempFillDrawColor.FColor:=FFillDrawColor.Color;
          FTempFillDrawColor.FColor:=BrightnessColor(FTempFillDrawColor.Color,20);
          Result:=FTempFillDrawColor;
        end;
      cctDarkness:
        begin
//          FTempFillDrawColor.Assign(FFillDrawColor);
          FTempFillDrawColor.FColor:=FFillDrawColor.Color;
          FTempFillDrawColor.FColor:=DarknessColor(FTempFillDrawColor.Color,20);
          Result:=FTempFillDrawColor;
        end;
    end;
  end;
end;

function TBaseDrawRectParam.CurrentEffectIsFill:Boolean;
begin
  Result:=Self.FIsFill;
  if (CurrentEffect<>nil) and (drpetIsFillChange in TDrawRectParamEffect(CurrentEffect).FEffectTypes) then
  begin
    Result:=TDrawRectParamEffect(CurrentEffect).FIsFill;
  end;
end;

//function TBaseDrawRectParam.CustomLoadFromJson(ASuperObject: ISuperObject): Boolean;
//var
//  ASubJson:ISuperObject;
//begin
//  Result:=False;
//
//  Self.FIsLine:=(ASuperObject.I['is_line']=1);
//  Self.FLinePosition:=GetLinePosition(ASuperObject.S['line_position']);
//
//  Self.FIsRound:=(ASuperObject.I['is_round']=1);
//  Self.FRoundWidth:=ASuperObject.F['round_width'];
//  Self.FRoundHeight:=ASuperObject.F['round_height'];
//
//  Self.FBorderEadges:=GetBorderEadges(ASuperObject.S['border_edges']);
//
//  Self.FRectCorners:=GetRectCorners(ASuperObject.S['rect_corners']);
//
//  Self.FIsFill:=(ASuperObject.I['is_fill']=1);
//  Self.FFillDrawColor.Color:=WebHexToColor(ASuperObject.S['fill_color']);
//
//  Self.FBorderDrawColor.Color:=WebHexToColor(ASuperObject.S['border_color']);
//  Self.FBorderWidth:=ASuperObject.F['border_width'];
//
//
//  Self.FIsClipRound:=(ASuperObject.I['is_clip_round']=1);
//  Self.FClipRoundWidth:=ASuperObject.F['clip_round_width'];
//  Self.FClipRoundHeight:=ASuperObject.F['clip_round_height'];
//
//  ASubJson:=SO(ASuperObject.S['clip_round_rect_setting_json']);
//  Self.FClipRoundRectSetting.LoadFromJson(ASubJson);
//
//  Result:=True;
//end;
//
//function TBaseDrawRectParam.CustomSaveToJson(ASuperObject: ISuperObject): Boolean;
//var
//  ASubJson:ISuperObject;
//begin
//  Result:=False;
//
//  ASuperObject.S['type']:='DrawRectParam';
//
//  ASuperObject.I['is_line']:=Ord(Self.FIsLine);
//  ASuperObject.S['line_position']:=GetLinePositionStr(Self.FLinePosition);
//
//  ASuperObject.I['is_round']:=Ord(Self.FIsRound);
//  ASuperObject.F['round_width']:=Self.FRoundWidth;
//  ASuperObject.F['round_height']:=Self.FRoundHeight;
//
//  ASuperObject.S['border_edges']:=GetBorderEadgesStr(Self.FBorderEadges);
//
//  ASuperObject.S['rect_corners']:=GetRectCornersStr(Self.FRectCorners);
//
//  ASuperObject.I['is_fill']:=Ord(Self.FIsFill);
//  ASuperObject.S['fill_color']:=ColorToWebHex(Self.FFillDrawColor.Color);
//
//  ASuperObject.S['border_color']:=ColorToWebHex(Self.FBorderDrawColor.Color);
//  ASuperObject.F['border_width']:=Self.FBorderWidth;
//
//
//  ASuperObject.I['is_clip_round']:=Ord(Self.FIsClipRound);
//  ASuperObject.F['clip_round_width']:=Self.FClipRoundWidth;
//  ASuperObject.F['clip_round_height']:=Self.FClipRoundHeight;
//
//  ASubJson:=TSuperObject.Create();
//  Self.FClipRoundRectSetting.SaveToJson(ASubJson);
//  ASuperObject.S['clip_round_rect_setting_json']:=ASubJson.AsJson;
//
//
//  Result:=True;
//end;

function TBaseDrawRectParam.CurrentEffectBorderWidth:TControlSize;
begin
  Result:=Self.FBorderWidth;
  if (CurrentEffect<>nil) and (drpetBorderWidthChange in TDrawRectParamEffect(CurrentEffect).FEffectTypes) then
  begin
    Result:=TDrawRectParamEffect(CurrentEffect).FBorderWidth;
  end;
end;
function TBaseDrawRectParam.CurrentEffectBorderColor:TDrawColor;
begin
  Result:=Self.FBorderDrawColor;
  if (CurrentEffect<>nil) and (drpetBorderColorChange in TDrawRectParamEffect(CurrentEffect).FEffectTypes) then
  begin
    Result:=TDrawRectParamEffect(CurrentEffect).FBorderDrawColor;
  end;
end;


function TBaseDrawRectParam.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I:Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);



  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='BorderEadges' then
    begin
      FBorderEadges:=GetSetFromStr_TDRPBorderEadges(ABTNode.ConvertNode_WideString.Data);
    end
    else if ABTNode.NodeName='RectCorners' then
    begin
      FRectCorners:=GetSetFromStr_TDRPRectCorners(ABTNode.ConvertNode_WideString.Data);
    end


    else if ABTNode.NodeName='IsLine' then
    begin
      FIsLine:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='LinePosition' then
    begin
      FLinePosition:=TDRPLinePosition(ABTNode.ConvertNode_Int32.Data);
    end

    else if ABTNode.NodeName='IsFill' then
    begin
      FIsFill:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='FillDrawColor' then
    begin
      FFillDrawColor.Assign(ABTNode.ConvertNode_Color.Data);
    end

    else if ABTNode.NodeName='IsRound' then
    begin
      FIsRound:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='RoundWidth' then
    begin
      FRoundWidth:=ControlSize(ABTNode.ConvertNode_Real64.Data);
    end
    else if ABTNode.NodeName='RoundHeight' then
    begin
      FRoundHeight:=ControlSize(ABTNode.ConvertNode_Real64.Data);
    end

    else if ABTNode.NodeName='BorderWidth' then
    begin
      FBorderWidth:=ControlSize(ABTNode.ConvertNode_Real64.Data);
    end
    else if ABTNode.NodeName='BorderDrawColor' then
    begin
      FBorderDrawColor.Assign(ABTNode.ConvertNode_Color.Data);
    end

    {$IFDEF FMX}
    else if ABTNode.NodeName='BrushKind' then
    begin
      Self.FBrushKind:=TDRPBrushKind(ABTNode.ConvertNode_Int32.Data);
    end
    {$ENDIF FMX}

    ;

  end;

  Result:=True;
end;

function TBaseDrawRectParam.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_WideString('BorderEadges','边框');
  ABTNode.ConvertNode_WideString.Data:=GetStrFromSet_TDRPBorderEadges(FBorderEadges);

  ABTNode:=ADocNode.AddChildNode_WideString('RectCorners','角');
  ABTNode.ConvertNode_WideString.Data:=GetStrFromSet_TDRPRectCorners(FRectCorners);


  ABTNode:=ADocNode.AddChildNode_Bool32('IsRound','是否圆角');
  ABTNode.ConvertNode_Bool32.Data:=FIsRound;

  ABTNode:=ADocNode.AddChildNode_Real64('RoundWidth','圆角宽度');
  ABTNode.ConvertNode_Real64.Data:=FRoundWidth;

  ABTNode:=ADocNode.AddChildNode_Real64('RoundHeight','圆角高度');
  ABTNode.ConvertNode_Real64.Data:=FRoundHeight;


  ABTNode:=ADocNode.AddChildNode_Bool32('IsFill','是否填充矩形');
  ABTNode.ConvertNode_Bool32.Data:=FIsFill;

  ABTNode:=ADocNode.AddChildNode_Color('FillDrawColor','填充颜色');
  ABTNode.ConvertNode_Color.Data.Assign(FFillDrawColor);

  ABTNode:=ADocNode.AddChildNode_Bool32('IsLine','是否是线段');
  ABTNode.ConvertNode_Bool32.Data:=FIsLine;

  ABTNode:=ADocNode.AddChildNode_Int32('LinePosition','线段位置');
  ABTNode.ConvertNode_Int32.Data:=Ord(FLinePosition);


  ABTNode:=ADocNode.AddChildNode_Color('BorderDrawColor','边框颜色');
  ABTNode.ConvertNode_Color.Data.Assign(FBorderDrawColor);

  ABTNode:=ADocNode.AddChildNode_Real64('BorderWidth','边框宽度');
  ABTNode.ConvertNode_Real64.Data:=FBorderWidth;



  {$IFDEF FMX}
  ABTNode:=ADocNode.AddChildNode_Bool32('BrushKind','是否填充');
  ABTNode.ConvertNode_Int32.Data:=Ord(FBrushKind);
  {$ENDIF FMX}


  Result:=True;

end;

destructor TBaseDrawRectParam.Destroy;
begin
  {$IFDEF FMX}
  FreeAndNil(FGradient);
  {$ENDIF FMX}


  FreeAndNil(FFillDrawColor);
  FreeAndNil(FTempFillDrawColor);
  FreeAndNil(FBorderDrawColor);
  FreeAndNil(FClipRoundRectSetting);
  inherited;
end;

function TBaseDrawRectParam.GetDrawEffectSetting: TDrawRectEffectSetting;
begin
  Result:=TDrawRectEffectSetting(Self.FDrawEffectSetting);
end;

function TBaseDrawRectParam.GetDrawEffectSettingClass: TDrawEffectSettingClass;
begin
  Result:=TDrawRectEffectSetting;
end;

function TBaseDrawRectParam.GetDrawParamSettingClass: TDrawParamSettingClass;
begin
  Result:=TDrawRectParamSetting;
end;

//function TBaseDrawRectParam.GetSetting: TDrawRectParamSetting;
//begin
//  Result:=TDrawRectParamSetting(Self.FSetting);
//end;

function TBaseDrawRectParam.IsBorderEadgesStored: Boolean;
begin
  Result:=(Self.FBorderEadges<>[beLeft,
                                beTop,
                                beRight,
                                beBottom]);
end;

{$IFDEF FMX}
function TBaseDrawRectParam.IsGradientStored: Boolean;
begin
  Result := (Self.FBrushKind = TDRPBrushKind.drpbkGradient);
end;
{$ENDIF FMX}

function TBaseDrawRectParam.IsRectParamBorderWidthStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FBorderWidth,0);
end;

function TBaseDrawRectParam.IsIsFillStored: Boolean;
begin
  {$IFDEF FMX}
  Result:=(Self.FIsFill<>False);
  {$ENDIF}
  {$IFDEF VCL}
  //因为VCL默认为True
  Result:=True;
  {$ENDIF}
end;

function TBaseDrawRectParam.IsIsLineStored: Boolean;
begin
  Result:=(Self.FIsLine<>False);
end;

function TBaseDrawRectParam.IsIsRoundStored: Boolean;
begin
  Result:=(Self.FIsRound<>False);
end;

function TBaseDrawRectParam.IsLinePositionStored: Boolean;
begin
  Result:=(Self.FLinePosition<>lpBottom);
end;

function TBaseDrawRectParam.IsRectCornersStored: Boolean;
begin
  Result:=(Self.FRectCorners<>[rcTopLeft,
                              rcTopRight,
                              rcBottomLeft,
                              rcBottomRight]);
end;

function TBaseDrawRectParam.IsRoundHeightStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FRoundHeight,6);
end;

function TBaseDrawRectParam.IsRoundWidthStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FRoundWidth,6);
end;

procedure TBaseDrawRectParam.SetBorderDrawColor(const Value: TDrawColor);
begin
  FBorderDrawColor.Assign(Value);
end;

procedure TBaseDrawRectParam.SetBorderEadges(const Value: TDRPBorderEadges);
begin
  if FBorderEadges<>Value then
  begin
    FBorderEadges := Value;
    DoChange;
  end;
end;

procedure TBaseDrawRectParam.SetRectCorners(const Value: TDRPRectCorners);
begin
  if FRectCorners<>Value then
  begin
    FRectCorners := Value;
    DoChange;
  end;
end;

procedure TBaseDrawRectParam.SetBorderWidth(const Value: TControlSize);
begin
  if FBorderWidth<>Value then
  begin
    FBorderWidth := Value;
    DoChange;
  end;
end;

{$IFDEF FMX}
procedure TBaseDrawRectParam.SetBrushKind(const Value: TDRPBrushKind);
begin
  if FBrushKind<>Value then
  begin
    FBrushKind := Value;
    DoChange;
  end;
end;
{$ENDIF FMX}


procedure TBaseDrawRectParam.SetClipRoundHeight(const Value: TControlSize);
begin
  if FClipRoundHeight<>Value then
  begin
    FClipRoundHeight:=Value;
    DoChange;
  end;
end;

procedure TBaseDrawRectParam.SetClipRoundWidth(const Value: TControlSize);
begin
  if FClipRoundWidth<>Value then
  begin
    FClipRoundWidth:=Value;
    DoChange;
  end;
end;

procedure TBaseDrawRectParam.SetDrawEffectSetting(
  const Value: TDrawRectEffectSetting);
begin

end;

procedure TBaseDrawRectParam.SetClipRoundRectSetting(const Value: TDrawRectSetting);
begin
  FClipRoundRectSetting.Assign(Value);
end;

procedure TBaseDrawRectParam.SetFillDrawColor(const Value: TDrawColor);
begin
  FFillDrawColor.Assign(Value);
end;

{$IFDEF FMX}

procedure TBaseDrawRectParam.SetGradient(const Value: TGradient);
begin
  FGradient.Assign(Value);
end;

procedure TBaseDrawRectParam.SetGradientColor(const Value: TDelphiColor);
begin
  FGradient.Color:=Value;
end;

procedure TBaseDrawRectParam.SetGradientColor1(const Value: TDelphiColor);
begin
  FGradient.Color1:=Value;
end;

procedure TBaseDrawRectParam.SetGradientStartPosition(const Value: TPosition);
begin
  FGradient.StartPosition:=Value;
end;

procedure TBaseDrawRectParam.SetGradientStopPosition(const Value: TPosition);
begin
  FGradient.StopPosition:=Value;
end;

procedure TBaseDrawRectParam.SetGradientStyle(const Value: TGradientStyle);
begin
  FGradient.Style:=Value;
end;

function TBaseDrawRectParam.GetGradientColor: TDelphiColor;
begin
  Result:=NullColor;
  if FGradient.Points.Count>0 then
  begin
    Result:=Self.FGradient.Points[0].Color;
  end;
end;

function TBaseDrawRectParam.GetGradientColor1: TDelphiColor;
begin
  Result:=NullColor;
  if FGradient.Points.Count>1 then
  begin
    Result:=Self.FGradient.Points[1].Color;
  end;
end;

function TBaseDrawRectParam.GetGradientStartPosition: TPosition;
begin
  Result:=FGradient.StartPosition;
end;

function TBaseDrawRectParam.GetGradientStopPosition: TPosition;
begin
  Result:=FGradient.StopPosition;
end;

function TBaseDrawRectParam.GetGradientStyle: TGradientStyle;
begin
  Result:=FGradient.Style;
end;
{$ENDIF FMX}

procedure TBaseDrawRectParam.SetRoundWidth(const Value: TControlSize);
begin
  if FRoundWidth<>Value then
  begin
    FRoundWidth := Value;
    DoChange;
  end;
end;

//procedure TBaseDrawRectParam.SetSetting(const Value: TDrawRectParamSetting);
//begin
//  FSetting.Assign(Value);
//end;

procedure TBaseDrawRectParam.SetIsFill(const Value: Boolean);
begin
  if FIsFill<>Value then
  begin
    FIsFill := Value;
    DoChange;
  end;
end;

procedure TBaseDrawRectParam.SetIsLine(const Value: Boolean);
begin
  if FIsLine<>Value then
  begin
    FIsLine := Value;
    DoChange;
  end;
end;

procedure TBaseDrawRectParam.SetIsRound(const Value: Boolean);
begin
  if FIsRound<>Value then
  begin
    FIsRound := Value;
    DoChange;
  end;
end;

procedure TBaseDrawRectParam.SetLinePosition(const Value: TDRPLinePosition);
begin
  if FLinePosition<>Value then
  begin
    FLinePosition := Value;
    DoChange;
  end;
end;

procedure TBaseDrawRectParam.SetRoundHeight(const Value: TControlSize);
begin
  if FRoundHeight<>Value then
  begin
    FRoundHeight := Value;
    DoChange;
  end;
end;

procedure TBaseDrawRectParam.AssignTo(Dest: TPersistent);
var
  DestObject:TBaseDrawRectParam;
begin
  if Dest is TBaseDrawRectParam then
  begin

    DestObject:=TBaseDrawRectParam(Dest);

    DestObject.FIsLine:=FIsLine;

    DestObject.FIsRound:=FIsRound;
    DestObject.FRoundWidth:=FRoundWidth;
    DestObject.FRoundHeight:=FRoundHeight;

    DestObject.FBorderEadges:=FBorderEadges;

    DestObject.FRectCorners:=FRectCorners;

    DestObject.FIsFill:=FIsFill;
    DestObject.FFillDrawColor.Assign(FFillDrawColor);

    DestObject.FBorderDrawColor.Assign(FBorderDrawColor);
    DestObject.FBorderWidth:=FBorderWidth;

    {$IFDEF FMX}
    DestObject.FBrushKind:=FBrushKind;

    DestObject.FGradient.Assign(FGradient);
    {$ENDIF FMX}
  end;
  Inherited;
end;

procedure TBaseDrawRectParam.Clear;
begin
  inherited Clear;

  FIsLine:=False;
  FLinePosition:=TDRPLinePosition.lpBottom;

  FIsRound:=False;
  FRoundWidth:=6;
  FRoundHeight:=6;

  FIsFill:=False;
//  FFillDrawColor.DefaultColor:=WhiteColor;
  FFillDrawColor.Color:=Const_DefaultFillColor;



  FBorderDrawColor.Color:=BlackColor;

  FBorderWidth:=0;


  FBorderEadges:=[beLeft,beTop,beRight,beBottom];



  {$IFDEF FMX}
  FBrushKind:=drpbkFill;
  {$ENDIF FMX}

end;

constructor TBaseDrawRectParam.Create(const AName: String;const ACaption:String);
begin
  FBorderEadges:=[beLeft,
                  beTop,
                  beRight,
                  beBottom
                  ];
  FRectCorners:=[rcTopLeft,
                rcTopRight,
                rcBottomLeft,
                rcBottomRight
                ];



  FFillDrawColor:=TDrawColor.Create('FillDrawColor','填充颜色');
  FFillDrawColor.StoredDefaultColor:=WhiteColor;
  FFillDrawColor.OnChange:=DoChange;

  FTempFillDrawColor:=TDrawColor.Create('TempFillDrawColor','Temp填充颜色');

  FBorderDrawColor:=CreateDrawColor('BorderDrawColor','边框颜色');


  FIsClipRound:=False;
  FClipRoundWidth:=-1;
  FClipRoundHeight:=-1;
  FClipRoundRectSetting:=TDrawRectSetting.Create;
  FClipRoundRectSetting.OnChange:=DoChange;

  {$IFDEF FMX}
  FBrushKind:=drpbkFill;


  FGradient := TGradient.Create;
  FGradient.OnChanged := DoChange;
  {$ENDIF FMX}

  inherited Create(AName,ACaption);
end;


{ TDrawRectParamEffect }

procedure TDrawRectParamEffect.AssignTo(Dest: TPersistent);
var
  DestObject:TDrawRectParamEffect;
begin
  if Dest is TDrawRectParamEffect then
  begin
    DestObject:=TDrawRectParamEffect(Dest);
    DestObject.FFillDrawColor.Assign(FFillDrawColor);
    DestObject.FBorderDrawColor.Assign(FBorderDrawColor);
    DestObject.FIsFill:=FIsFill;
    DestObject.FBorderWidth:=FBorderWidth;
    DestObject.FEffectTypes:=FEffectTypes;
  end;
  Inherited;
end;

constructor TDrawRectParamEffect.Create;
begin
  FFillDrawColor:=TDrawColor.Create('FillDrawColor','填充颜色');
  FBorderDrawColor:=TDrawColor.Create('BorderDrawColor','边框颜色');
  Inherited;

  FFillDrawColor.OnChange:=DoChange;
  FBorderDrawColor.OnChange:=DoChange;
end;

destructor TDrawRectParamEffect.Destroy;
begin
  FreeAndNil(FFillDrawColor);
  FreeAndNil(FBorderDrawColor);
  inherited;
end;

function TDrawRectParamEffect.HasEffectTypes: Boolean;
begin
  Result:=(Inherited HasEffectTypes) or (Self.FEffectTypes<>[]);
end;

function TDrawRectParamEffect.IsRectBorderWidthStored: Boolean;
begin
  //边框不为1就保存
  Result:=IsNotSameDouble(Self.FBorderWidth,0);
end;

function TDrawRectParamEffect.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited LoadFromDocNode(ADocNode);


  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='FillDrawColor' then
    begin
      Self.FFillDrawColor.Assign(ABTNode.ConvertNode_Color.Data);
    end
    else if ABTNode.NodeName='BorderWidth' then
    begin
      Self.FBorderWidth:=ControlSize(ABTNode.ConvertNode_Real64.Data);
    end
    else if ABTNode.NodeName='IsFill' then
    begin
      Self.FIsFill:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='EffectTypes' then
    begin
      Self.FEffectTypes:=GetSetFromStr_TDRPEffectTypes(ABTNode.ConvertNode_WideString.Data);
    end
    ;
  end;

  Result:=True;

end;

//function TDrawRectParamEffect.LoadFromJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Inherited;
//
//  Result:=False;
//
//  Self.FFillDrawColor.Color:=WebHexToColor(ASuperObject.S['fill_color']);
//  Self.FIsFill:=(ASuperObject.I['is_fill']=1);
//
//  Self.FBorderDrawColor.Color:=WebHexToColor(ASuperObject.S['border_color']);
//  Self.FBorderWidth:=ASuperObject.F['border_width'];
//
//  Self.FEffectTypes:=GetDRPEffectTypes(ASuperObject.S['effect_types']);
//
//  Result:=True;
//end;

function TDrawRectParamEffect.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);


  ABTNode:=ADocNode.AddChildNode_Color('FillDrawColor','字体颜色');
  ABTNode.ConvertNode_Color.Data.Assign(FFillDrawColor);

  ABTNode:=ADocNode.AddChildNode_Real64('BorderWidth','边框宽度');
  ABTNode.ConvertNode_Real64.Data:=FBorderWidth;

  ABTNode:=ADocNode.AddChildNode_Bool32('IsFill','是否填充');
  ABTNode.ConvertNode_Bool32.Data:=FIsFill;

  ABTNode:=ADocNode.AddChildNode_WideString('EffectTypes','效果集');
  ABTNode.ConvertNode_WideString.Data:=GetStrFromSet_TDRPEffectTypes(FEffectTypes);

  Result:=True;
end;

//function TDrawRectParamEffect.SaveToJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Inherited;
//
//  Result:=False;
//
//  ASuperObject.S['fill_color']:=ColorToWebHex(Self.FFillDrawColor.Color);
//  ASuperObject.I['is_fill']:=Ord(Self.FIsFill);
//
//  ASuperObject.S['border_color']:=ColorToWebHex(Self.FBorderDrawColor.Color);
//  ASuperObject.F['border_width']:=Self.FBorderWidth;
//
//  ASuperObject.S['effect_types']:=GetDRPEffectTypesStr(Self.FEffectTypes);
//
//  Result:=True;
//end;

procedure TDrawRectParamEffect.SetBorderDrawColor(const Value: TDrawColor);
begin
  FBorderDrawColor.Assign(Value);
end;

procedure TDrawRectParamEffect.SetBorderWidth(const Value: TControlSize);
begin
  if FBorderWidth<>Value then
  begin
    FBorderWidth := Value;
    DoChange;
  end;
end;

procedure TDrawRectParamEffect.SetEffectTypes(const Value: TDRPEffectTypes);
begin
  if FEffectTypes<>Value then
  begin
    FEffectTypes := Value;
    DoChange;
  end;
end;

procedure TDrawRectParamEffect.SetFillColorChangeType(
  const Value: TColorChangeType);
begin
  if FFillColorChangeType<>Value then
  begin
    FFillColorChangeType := Value;
    DoChange;
  end;
end;

procedure TDrawRectParamEffect.SetFillDrawColor(const Value: TDrawColor);
begin
  FFillDrawColor.Assign(Value);
end;

procedure TDrawRectParamEffect.SetIsFill(const Value: Boolean);
begin
  if FIsFill<>Value then
  begin
    FIsFill := Value;
    DoChange;
  end;
end;

function TDrawRectParamEffect.IsEffectTypesStored: Boolean;
begin
  Result:=(Self.FEffectTypes<>[]);
end;

function TDrawRectParamEffect.IsIsFillStored: Boolean;
begin
  Result:=(Self.FIsFill<>False);
end;


{ TDrawRectParamSetting }



constructor TDrawRectParamSetting.Create(ADrawParam: TDrawParam);
begin
  inherited;
  FDrawRectParam:=TDrawRectParam(ADrawParam);
end;

function TDrawRectParamSetting.GetMouseDownFillColor: TDelphiColor;
begin
  Result:=FDrawRectParam.DrawEffectSetting.MouseDownEffect.FFillDrawColor.Color;
end;

function TDrawRectParamSetting.GetMouseDownFillColorChange: Boolean;
begin
  Result:=drpetFillColorChange in FDrawRectParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawRectParamSetting.GetMouseOverFillColor: TDelphiColor;
begin
  Result:=FDrawRectParam.DrawEffectSetting.MouseOverEffect.FFillDrawColor.Color;
end;

function TDrawRectParamSetting.GetMouseOverFillColorChange: Boolean;
begin
  Result:=drpetFillColorChange in FDrawRectParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawRectParamSetting.GetPushedFillColor: TDelphiColor;
begin
  Result:=FDrawRectParam.DrawEffectSetting.PushedEffect.FFillDrawColor.Color;
end;

function TDrawRectParamSetting.GetPushedFillColorChange: Boolean;
begin
  Result:=drpetFillColorChange in FDrawRectParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;



procedure TDrawRectParamSetting.SetMouseDownFillColor(const Value: TDelphiColor);
begin
  FDrawRectParam.DrawEffectSetting.MouseDownEffect.FillColor.Color:=Value;
end;

procedure TDrawRectParamSetting.SetMouseDownFillColorChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawRectParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.MouseDownEffect.EffectTypes+[drpetFillColorChange];
  end
  else
  begin
    FDrawRectParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.MouseDownEffect.EffectTypes-[drpetFillColorChange];
  end;
end;

procedure TDrawRectParamSetting.SetMouseOverFillColor(const Value: TDelphiColor);
begin
  FDrawRectParam.DrawEffectSetting.MouseOverEffect.FillColor.Color:=Value;
end;

procedure TDrawRectParamSetting.SetMouseOverFillColorChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawRectParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.MouseOverEffect.EffectTypes+[drpetFillColorChange];
  end
  else
  begin
    FDrawRectParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.MouseOverEffect.EffectTypes-[drpetFillColorChange];
  end;
end;

procedure TDrawRectParamSetting.SetPushedFillColor(const Value: TDelphiColor);
begin
  FDrawRectParam.DrawEffectSetting.PushedEffect.FillColor.Color:=Value;
end;

procedure TDrawRectParamSetting.SetPushedFillColorChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawRectParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.PushedEffect.EffectTypes+[drpetFillColorChange];
  end
  else
  begin
    FDrawRectParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.PushedEffect.EffectTypes-[drpetFillColorChange];
  end;
end;





function TDrawRectParamSetting.GetMouseDownBorderWidth: TControlSize;
begin
  Result:=FDrawRectParam.DrawEffectSetting.MouseDownEffect.BorderWidth;
end;

function TDrawRectParamSetting.GetMouseDownBorderWidthChange: Boolean;
begin
  Result:=drpetBorderWidthChange in FDrawRectParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawRectParamSetting.GetMouseOverBorderWidth: TControlSize;
begin
  Result:=FDrawRectParam.DrawEffectSetting.MouseOverEffect.BorderWidth;
end;

function TDrawRectParamSetting.GetMouseOverBorderWidthChange: Boolean;
begin
  Result:=drpetBorderWidthChange in FDrawRectParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawRectParamSetting.GetPushedBorderWidth: TControlSize;
begin
  Result:=FDrawRectParam.DrawEffectSetting.PushedEffect.BorderWidth;
end;

function TDrawRectParamSetting.GetPushedBorderWidthChange: Boolean;
begin
  Result:=drpetBorderWidthChange in FDrawRectParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;



procedure TDrawRectParamSetting.SetMouseDownBorderWidth(const Value: TControlSize);
begin
  FDrawRectParam.DrawEffectSetting.MouseDownEffect.BorderWidth:=Value;
end;

procedure TDrawRectParamSetting.SetMouseDownBorderWidthChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawRectParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.MouseDownEffect.EffectTypes+[drpetBorderWidthChange];
  end
  else
  begin
    FDrawRectParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.MouseDownEffect.EffectTypes-[drpetBorderWidthChange];
  end;
end;

procedure TDrawRectParamSetting.SetMouseOverBorderWidth(const Value: TControlSize);
begin
  FDrawRectParam.DrawEffectSetting.MouseOverEffect.BorderWidth:=Value;
end;

procedure TDrawRectParamSetting.SetMouseOverBorderWidthChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawRectParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.MouseOverEffect.EffectTypes+[drpetBorderWidthChange];
  end
  else
  begin
    FDrawRectParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.MouseOverEffect.EffectTypes-[drpetBorderWidthChange];
  end;
end;

procedure TDrawRectParamSetting.SetPushedBorderWidth(const Value: TControlSize);
begin
  FDrawRectParam.DrawEffectSetting.PushedEffect.BorderWidth:=Value;
end;

procedure TDrawRectParamSetting.SetPushedBorderWidthChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawRectParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.PushedEffect.EffectTypes+[drpetBorderWidthChange];
  end
  else
  begin
    FDrawRectParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.PushedEffect.EffectTypes-[drpetBorderWidthChange];
  end;
end;



function TDrawRectParamSetting.GetMouseDownIsFill: Boolean;
begin
  Result:=FDrawRectParam.DrawEffectSetting.MouseDownEffect.FIsFill;
end;

function TDrawRectParamSetting.GetMouseDownIsFillChange: Boolean;
begin
  Result:=drpetIsFillChange in FDrawRectParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawRectParamSetting.GetMouseOverIsFill: Boolean;
begin
  Result:=FDrawRectParam.DrawEffectSetting.MouseOverEffect.FIsFill;
end;

function TDrawRectParamSetting.GetMouseOverIsFillChange: Boolean;
begin
  Result:=drpetIsFillChange in FDrawRectParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawRectParamSetting.GetPushedIsFill: Boolean;
begin
  Result:=FDrawRectParam.DrawEffectSetting.PushedEffect.FIsFill;
end;

function TDrawRectParamSetting.GetPushedIsFillChange: Boolean;
begin
  Result:=drpetIsFillChange in FDrawRectParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;



function TDrawRectParamSetting.IsMouseDownBorderWidthChangeStored: Boolean;
begin
  Result:=drpetBorderWidthChange in FDrawRectParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawRectParamSetting.IsMouseDownBorderWidthStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawRectParam.DrawEffectSetting.MouseDownEffect.FBorderWidth,0);
end;

function TDrawRectParamSetting.IsMouseDownFillColorChangeStored: Boolean;
begin
  Result:=drpetFillColorChange in FDrawRectParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawRectParamSetting.IsMouseDownFillColorStored: Boolean;
begin
  Result:=Self.FDrawRectParam.DrawEffectSetting.MouseDownEffect.FFillDrawColor.Color<>Const_DefaultColor;
end;

function TDrawRectParamSetting.IsMouseDownIsFillChangeStored: Boolean;
begin
  Result:=drpetIsFillChange in FDrawRectParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawRectParamSetting.IsMouseDownIsFillStored: Boolean;
begin
  Result:=Self.FDrawRectParam.DrawEffectSetting.MouseDownEffect.FIsFill<>False;
end;

function TDrawRectParamSetting.IsMouseOverBorderWidthChangeStored: Boolean;
begin
  Result:=drpetBorderWidthChange in FDrawRectParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawRectParamSetting.IsMouseOverBorderWidthStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawRectParam.DrawEffectSetting.MouseOverEffect.FBorderWidth,0);
end;

function TDrawRectParamSetting.IsMouseOverFillColorChangeStored: Boolean;
begin
  Result:=drpetFillColorChange in FDrawRectParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawRectParamSetting.IsMouseOverFillColorStored: Boolean;
begin
  Result:=Self.FDrawRectParam.DrawEffectSetting.MouseOverEffect.FFillDrawColor.Color<>Const_DefaultColor;
end;

function TDrawRectParamSetting.IsMouseOverIsFillChangeStored: Boolean;
begin
  Result:=drpetIsFillChange in FDrawRectParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawRectParamSetting.IsMouseOverIsFillStored: Boolean;
begin
  Result:=Self.FDrawRectParam.DrawEffectSetting.MouseOverEffect.FIsFill<>False;
end;

function TDrawRectParamSetting.IsPushedBorderWidthChangeStored: Boolean;
begin
  Result:=drpetBorderWidthChange in FDrawRectParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;

function TDrawRectParamSetting.IsPushedBorderWidthStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawRectParam.DrawEffectSetting.PushedEffect.FBorderWidth,0);
end;

function TDrawRectParamSetting.IsPushedFillColorChangeStored: Boolean;
begin
  Result:=drpetFillColorChange in FDrawRectParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;

function TDrawRectParamSetting.IsPushedFillColorStored: Boolean;
begin
  Result:=Self.FDrawRectParam.DrawEffectSetting.PushedEffect.FFillDrawColor.Color<>Const_DefaultColor;
end;

function TDrawRectParamSetting.IsPushedIsFillChangeStored: Boolean;
begin
  Result:=drpetIsFillChange in FDrawRectParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;

function TDrawRectParamSetting.IsPushedIsFillStored: Boolean;
begin
  Result:=Self.FDrawRectParam.DrawEffectSetting.PushedEffect.FIsFill<>False;
end;

procedure TDrawRectParamSetting.SetMouseDownIsFill(const Value: Boolean);
begin
  FDrawRectParam.DrawEffectSetting.MouseDownEffect.IsFill:=Value;
end;

procedure TDrawRectParamSetting.SetMouseDownIsFillChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawRectParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.MouseDownEffect.EffectTypes+[drpetIsFillChange];
  end
  else
  begin
    FDrawRectParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.MouseDownEffect.EffectTypes-[drpetIsFillChange];
  end;
end;

procedure TDrawRectParamSetting.SetMouseOverIsFill(const Value: Boolean);
begin
  FDrawRectParam.DrawEffectSetting.MouseOverEffect.IsFill:=Value;
end;

procedure TDrawRectParamSetting.SetMouseOverIsFillChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawRectParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.MouseOverEffect.EffectTypes+[drpetIsFillChange];
  end
  else
  begin
    FDrawRectParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.MouseOverEffect.EffectTypes-[drpetIsFillChange];
  end;
end;

procedure TDrawRectParamSetting.SetPushedIsFill(const Value: Boolean);
begin
  FDrawRectParam.DrawEffectSetting.PushedEffect.IsFill:=Value;
end;

procedure TDrawRectParamSetting.SetPushedIsFillChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawRectParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.PushedEffect.EffectTypes+[drpetIsFillChange];
  end
  else
  begin
    FDrawRectParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawRectParam.DrawEffectSetting.PushedEffect.EffectTypes-[drpetIsFillChange];
  end;
end;




//
//{ TBaseNewDrawRectParam }
//
//procedure TBaseNewDrawRectParam.Clear;
//begin
//  inherited;
//
//  Self.FIsFill:=True;
//
//  FIsRound:=True;
//  FRoundWidth:=0;
//  FRoundHeight:=0;
//end;
//
//function TBaseNewDrawRectParam.GetBorderColor: TDelphiColor;
//begin
//  Result:=Self.FBorderDrawColor.Color;
//end;
//
//function TBaseNewDrawRectParam.GetFillColor: TDelphiColor;
//begin
//  Result:=Self.FFillDrawColor.Color;
//end;
//
//function TBaseNewDrawRectParam.GetRoundRadius: TControlSize;
//begin
//  Result:=Self.FRoundWidth;
//end;
//
//function TBaseNewDrawRectParam.IsBorderColorStored: Boolean;
//begin
//  Result:=Self.FBorderDrawColor.Color<>Const_DefaultColor;
//end;
//
//function TBaseNewDrawRectParam.IsFillColorStored: Boolean;
//begin
//  Result:=Self.FFillDrawColor.Color<>Const_DefaultFillColor;
//end;
//
//function TBaseNewDrawRectParam.IsIsFillStored: Boolean;
//begin
//  Result:=FIsFill<>True;
//end;
//
//procedure TBaseNewDrawRectParam.SetBorderColor(const Value: TDelphiColor);
//begin
//  Self.FBorderDrawColor.Color:=Value;
//end;
//
//procedure TBaseNewDrawRectParam.SetFillColor(const Value: TDelphiColor);
//begin
//  Self.FFillDrawColor.Color:=Value;
//end;
//
//procedure TBaseNewDrawRectParam.SetRoundRadius(const Value: TControlSize);
//begin
//  RoundWidth:=Value;
//  RoundHeight:=Value;
//end;




{ TDrawRectEffectSetting }

function TDrawRectEffectSetting.GetDisabledEffect: TDrawRectParamEffect;
begin
  Result:=TDrawRectParamEffect(Self.FDisabledEffect);
end;

function TDrawRectEffectSetting.GetDrawParamEffectClass: TDrawParamCommonEffectClass;
begin
  Result:=TDrawRectParamEffect;
end;

function TDrawRectEffectSetting.GetFocusedEffect: TDrawRectParamEffect;
begin
  Result:=TDrawRectParamEffect(Self.FFocusedEffect);
end;

function TDrawRectEffectSetting.GetMouseDownEffect: TDrawRectParamEffect;
begin
  Result:=TDrawRectParamEffect(Self.FMouseDownEffect);
end;

function TDrawRectEffectSetting.GetMouseOverEffect: TDrawRectParamEffect;
begin
  Result:=TDrawRectParamEffect(Self.FMouseOverEffect);
end;

function TDrawRectEffectSetting.GetPushedEffect: TDrawRectParamEffect;
begin
  Result:=TDrawRectParamEffect(Self.FPushedEffect);
end;

procedure TDrawRectEffectSetting.SetDisabledEffect(
  const Value: TDrawRectParamEffect);
begin
  FDisabledEffect.Assign(Value);
end;

procedure TDrawRectEffectSetting.SetFocusedEffect(
  const Value: TDrawRectParamEffect);
begin
  FFocusedEffect.Assign(Value);
end;

procedure TDrawRectEffectSetting.SetMouseDownEffect(
  const Value: TDrawRectParamEffect);
begin
  FMouseDownEffect.Assign(Value);
end;

procedure TDrawRectEffectSetting.SetMouseOverEffect(
  const Value: TDrawRectParamEffect);
begin
  FMouseOverEffect.Assign(Value);
end;

procedure TDrawRectEffectSetting.SetPushedEffect(
  const Value: TDrawRectParamEffect);
begin
  FPushedEffect.Assign(Value);
end;



{ TSkinGradient }


//procedure TSkinGradient.SetColor(const Value: TDelphiColor);
//begin
//  Self.Color:=Value;
//end;
//
//procedure TSkinGradient.SetColor1(const Value: TDelphiColor);
//begin
//  Self.Color1:=Value;
//end;

//procedure TSkinGradient.SetStyle(const Value: TGradientStyle);
//begin
//  Self.Style:=Value;
//end;

//function TSkinGradient.GetColor: TDelphiColor;
//begin
//  Result:=NullColor;
//  if Self.Points.Count>0 then
//  begin
//    Result:=Self.Points[0].Color;
//  end;
//end;
//
//function TSkinGradient.GetColor1: TDelphiColor;
//begin
//  Result:=NullColor;
//  if Self.Points.Count>1 then
//  begin
//    Result:=Self.Points[1].Color;
//  end;
//end;

//function TSkinGradient.GetStyle: TGradientStyle;
//begin
//  Result:=FGradient.Style;
//end;


initialization
  GlobalDrawRectParam:=TBaseDrawRectParam.Create('GlobalDrawRectParam','全局矩形绘制参数');


finalization
  FreeAndNil(GlobalDrawRectParam);



end.
