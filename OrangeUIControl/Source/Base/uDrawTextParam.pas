//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     文本绘制参数
///   </para>
///   <para>
///     Parameters of drawing text
///   </para>
/// </summary>
unit uDrawTextParam;




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
  FMX.Types,
  FMX.Graphics,
  FMX.TextLayout,
  FMX.Platform,
  System.Math.Vectors,
  {$ENDIF}


//  XSuperObject,


  uBaseList,
  uFuncCommon,
  uGraphicCommon,
  uBinaryTreeDoc,
  uDrawParam;



const
  //默认字体大小
  Const_DefaultFontSize: Integer = {$IFDEF FMX}12{$ENDIF}{$IFDEF VCL}8{$ENDIF};



Type
  TDrawTextParam=class;




  /// <summary>
  ///   <para>
  ///     水平对齐类型
  ///   </para>
  ///   <para>
  ///     Type of horizontal align
  ///   </para>
  /// </summary>
  TFontHorzAlign=(
                  /// <summary>
                  ///   居左
                  ///   <para>
                  ///      horizontal left
                  ///   </para>
                  /// </summary>
                  fhaLeft,
                  /// <summary>
                  ///   居中
                  ///   <para>
                  ///      horizontal center
                  ///   </para>
                  /// </summary>
                  fhaCenter,
                  /// <summary>
                  ///   居右
                  ///   <para>
                  ///      horizontal right
                  ///   </para>
                  /// </summary>
                  fhaRight
                  );



  /// <summary>
  ///   <para>
  ///     垂直对齐类型
  ///   </para>
  ///   <para>
  ///     Type of vertical align
  ///   </para>
  /// </summary>
  TFontVertAlign=(
                  /// <summary>
                  ///   居上
                  ///   <para>
                  ///     vertical top
                  ///   </para>
                  /// </summary>
                  fvaTop,
                  /// <summary>
                  ///   居中
                  ///   <para>
                  ///     vertical center
                  ///   </para>
                  /// </summary>
                  fvaCenter,
                  /// <summary>
                  ///   居右
                  ///   <para>
                  ///     vertical right
                  ///   </para>
                  /// </summary>
                  fvaBottom);




  /// <summary>
  ///   <para>
  ///     字体截断类型
  ///   </para>
  ///   <para>
  ///     Type of font trimming
  ///   </para>
  /// </summary>
  TFontTrimmingType=(
                      /// <summary>
                      ///   无
                      ///   <para>
                      ///     None
                      ///   </para>
                      /// </summary>
                      fttNone,
                      /// <summary>
                      ///   字符截断
                      ///   <para>
                      ///     Character trimming
                      ///   </para>
                      /// </summary>
                      fttCharacter,
                      /// <summary>
                      ///   字截断
                      ///   <para>
                      ///     Word trimming
                      ///   </para>
                      /// </summary>
                      fftWord
                      );





  /// <summary>
  ///   <para>
  ///     文本绘制参数的效果类型
  ///   </para>
  ///   <para>
  ///     Effect Type of drawing text
  ///   </para>
  /// </summary>
  TDTPEffectType=( //
                   /// <summary>
                   ///   字体颜色更改
                   ///   <para>
                   ///    Change font color
                   ///   </para>
                   /// </summary>
                   dtpetFontColorChange,
                   //
                   /// <summary>
                   ///   字体大小更改
                   ///   <para>
                   ///    Change font size
                   ///   </para>
                   /// </summary>
                   dtpetFontSizeChange,
                   //
                   /// <summary>
                   ///   字体风格更改
                   ///   <para>
                   ///    Change font style
                   ///   </para>
                   /// </summary>
                   dtpetFontStyleChange
                   );

  /// <summary>
  ///   <para>
  ///     文本绘制参数效果类型集合
  ///   </para>
  ///   <para>
  ///     Set of drawing text parameters effect type
  ///   </para>
  /// </summary>
  TDTPEffectTypes=set of TDTPEffectType;





  /// <summary>
  ///   <para>
  ///     字体
  ///   </para>
  ///   <para>
  ///     Font
  ///   </para>
  /// </summary>
  TDrawFont=class(TFont,ISupportClassDocNode)
  private
    FFontColor: TDrawColor;

    {$IFDEF VCL}
    FOnChanged:TNotifyEvent;
    procedure DoChanged;
    {$ENDIF}

    procedure DoFontColorChange(Sender:TObject);

    procedure SetFontColor(const Value: TDrawColor);
    procedure SetFontName(const Value: TFontName);
    procedure SetFontSize(const Value: TControlSize);
    procedure SetFontStyle(const Value: TFontStyles);

    Function GetFontName: TFontName;
    Function GetFontSize: TControlSize;
    Function GetFontStyle: TFontStyles;
  private
    FOwnerInterface: IInterface;
    function GetColor: TDelphiColor;
    procedure SetColor(const Value: TDelphiColor);
  protected
    { IInterface }
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    procedure AfterConstruction; override;
  protected
    procedure Assign(Src: TPersistent); override;
  public
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;
  public
    constructor Create;
    destructor Destroy;override;
  public
    //初始化参数
    procedure Clear;

    {$IFDEF VCL}
    property OnChanged:TNotifyEvent read FOnChanged write FOnChanged;
    {$ENDIF}

  public
    //FMX和VCL自带有,所以就不到发布属性去了
    property FontName:TFontName read GetFontName write SetFontName{$IFDEF FMX} stored IsFamilyStored{$ENDIF};
    property FontStyle:TFontStyles read GetFontStyle write SetFontStyle;
    property FontSize:TControlSize read GetFontSize write SetFontSize;
  published
    /// <summary>
    ///   <para>
    ///     字体颜色
    ///   </para>
    ///   <para>
    ///     Font color
    ///   </para>
    /// </summary>
    property Color:TDelphiColor read GetColor write SetColor default BlackColor;
    /// <summary>
    ///   <para>
    ///     字体颜色
    ///   </para>
    ///   <para>
    ///     Font color
    ///   </para>
    /// </summary>
    property FontColor:TDrawColor read FFontColor write SetFontColor;
  published
    /// <summary>
    ///   <para>
    ///     字体大小
    ///   </para>
    ///   <para>
    ///     Font size
    ///   </para>
    /// </summary>
    property Size;
  end;




  /// <summary>
  ///   <para>
  ///     颜色文本
  ///   </para>
  ///   <para>
  ///     Color text
  ///   </para>
  /// </summary>
  TBaseColorTextItem=class(TCollectionItem)
  public
    /// <summary>
    ///   <para>
    ///     文本
    ///   </para>
    ///   <para>
    ///     Text
    ///   </para>
    /// </summary>
    FText:String;
    /// <summary>
    ///   <para>
    ///     字体
    ///   </para>
    ///   <para>
    ///     Font
    ///   </para>
    /// </summary>
    FDrawFont:TDrawFont;
    /// <summary>
    ///   <para>
    ///     是否使用默认的字体绘制
    ///   </para>
    ///   <para>
    ///     Whether use default font to draw
    ///   </para>
    /// </summary>
    FIsUseDefaultDrawFont: Boolean;
    /// <summary>
    ///   <para>
    ///     是否使用默认的字体颜色
    ///   </para>
    ///   <para>
    ///     Whether use default font color
    ///   </para>
    /// </summary>
    FIsUseDefaultDrawFontColor: Boolean;
  public
    //绘制的上边距
    DrawTop:TControlSize;
    //绘制的宽度
    DrawWidth:TControlSize;
    //绘制的高度
    DrawHeight:TControlSize;
  end;




  /// <summary>
  ///   <para>
  ///     颜色文本列表的接口
  ///   </para>
  ///   <para>
  ///     Interface  of ColorTextList
  ///   </para>
  /// </summary>
  IColorTextList=interface
    ['{159B2017-7FF6-4473-A895-BE3AD949E28B}']
    //
    /// <summary>
    ///   <para>
    ///     数量
    ///   </para>
    ///   <para>
    ///     Count
    ///   </para>
    /// </summary>
    function GetColorTextCount:Integer;
    /// <summary>
    ///   <para>
    ///     获取指定下标的ColorTextItem
    ///   </para>
    ///   <para>
    ///     Get ColorTextItem of assigned index
    ///   </para>
    /// </summary>
    function GetColorTextItem(Index:Integer):TBaseColorTextItem;

    property Items[Index:Integer]:TBaseColorTextItem read GetColorTextItem;
  end;






  /// <summary>
  ///   <para>
  ///     文本绘制参数的效果
  ///   </para>
  ///   <para>
  ///     Class of drawing text parameters effect
  ///   </para>
  /// </summary>
  TDrawTextParamEffect=class(TDrawParamCommonEffect)
  private
    FFontColor: TDrawColor;
    FFontSize: TControlSize;
    FFontStyle: TFontStyles;

    FEffectTypes: TDTPEffectTypes;
    function IsEffectTypesStored: Boolean;
    function IsFontSizeStored: Boolean;
    function IsFontStyleStored: Boolean;
    procedure SetFontColor(const Value: TDrawColor);
    procedure SetEffectTypes(const Value: TDTPEffectTypes);
    procedure SetFontSize(const Value: TControlSize);
    procedure SetFontStyle(const Value: TFontStyles);
  protected
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
    constructor Create;override;
    destructor Destroy;override;
  public
    /// <summary>
    ///   <para>
    ///     是否有效果
    ///   </para>
    ///   <para>
    ///     Whether have effect
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
  public
//    function LoadFromJson(ASuperObject:ISuperObject):Boolean;override;
//    function SaveToJson(ASuperObject:ISuperObject):Boolean;override;
  published

    /// <summary>
    ///   <para>
    ///     字体颜色
    ///   </para>
    ///   <para>
    ///     Font Color
    ///   </para>
    /// </summary>
    property FontColor:TDrawColor read FFontColor write SetFontColor;

    /// <summary>
    ///   <para>
    ///     字体大小
    ///   </para>
    ///   <para>
    ///     Font Size
    ///   </para>
    /// </summary>
    property FontSize: TControlSize read FFontSize write SetFontSize stored IsFontSizeStored;

    /// <summary>
    ///   <para>
    ///     风格
    ///   </para>
    ///   <para>
    ///     Style
    ///   </para>
    /// </summary>
    property FontStyle: TFontStyles read FFontStyle write SetFontStyle stored IsFontStyleStored;

    /// <summary>
    ///   <para>
    ///     效果类型集合,一个状态可以有多个效果
    ///   </para>
    ///   <para>
    ///     Set of effect type,one state can have several effect
    ///   </para>
    /// </summary>
    property EffectTypes:TDTPEffectTypes read FEffectTypes write SetEffectTypes stored IsEffectTypesStored;
  end;




  /// <summary>
  ///   <para>
  ///     文本绘制参数的效果
  ///   </para>
  ///   <para>
  ///     Class of drawing text parameters effect
  ///   </para>
  /// </summary>
  TDrawTextEffectSetting=class(TDrawEffectSetting)
  private
    function GetMouseDownEffect: TDrawTextParamEffect;
    function GetMouseOverEffect: TDrawTextParamEffect;
    function GetPushedEffect: TDrawTextParamEffect;
    procedure SetMouseDownEffect(const Value: TDrawTextParamEffect);
    procedure SetMouseOverEffect(const Value: TDrawTextParamEffect);
    procedure SetPushedEffect(const Value: TDrawTextParamEffect);
    procedure SetDisabledEffect(const Value: TDrawTextParamEffect);
    procedure SetFocusedEffect(const Value: TDrawTextParamEffect);
    function GetDisabledEffect: TDrawTextParamEffect;
    function GetFocusedEffect: TDrawTextParamEffect;
  protected
    function GetDrawParamEffectClass:TDrawParamCommonEffectClass;override;
  published
    //禁用状态的效果
    property DisabledEffect: TDrawTextParamEffect read GetDisabledEffect write SetDisabledEffect;
    //获得焦点的效果
    property FocusedEffect: TDrawTextParamEffect read GetFocusedEffect write SetFocusedEffect;
    property MouseDownEffect:TDrawTextParamEffect read GetMouseDownEffect write SetMouseDownEffect;
    property MouseOverEffect:TDrawTextParamEffect read GetMouseOverEffect write SetMouseOverEffect;
    property PushedEffect:TDrawTextParamEffect read GetPushedEffect write SetPushedEffect;
  end;




  TDrawTextParamSetting=class(TDrawParamSetting)
  private
    function IsMouseDownFontColorChangeStored: Boolean;
    function IsMouseDownFontColorStored: Boolean;
    function IsMouseDownFontSizeChangeStored: Boolean;
    function IsMouseDownFontSizeStored: Boolean;
    function IsMouseDownFontStyleChangeStored: Boolean;
    function IsMouseDownFontStyleStored: Boolean;
    function IsMouseOverFontColorChangeStored: Boolean;
    function IsMouseOverFontColorStored: Boolean;
    function IsMouseOverFontSizeChangeStored: Boolean;
    function IsMouseOverFontSizeStored: Boolean;
    function IsMouseOverFontStyleChangeStored: Boolean;
    function IsMouseOverFontStyleStored: Boolean;
    function IsPushedFontColorChangeStored: Boolean;
    function IsPushedFontColorStored: Boolean;
    function IsPushedFontSizeChangeStored: Boolean;
    function IsPushedFontSizeStored: Boolean;
    function IsPushedFontStyleChangeStored: Boolean;
    function IsPushedFontStyleStored: Boolean;
  protected
    FDrawTextParam:TDrawTextParam;

    function GetMouseDownFontColor: TDelphiColor;
    function GetMouseDownFontColorChange: Boolean;
    function GetMouseOverFontColor: TDelphiColor;
    function GetMouseOverFontColorChange: Boolean;
    function GetPushedFontColor: TDelphiColor;
    function GetPushedFontColorChange: Boolean;

    function GetMouseDownFontSize: TControlSize;
    function GetMouseDownFontSizeChange: Boolean;
    function GetMouseOverFontSize: TControlSize;
    function GetMouseOverFontSizeChange: Boolean;
    function GetPushedFontSize: TControlSize;
    function GetPushedFontSizeChange: Boolean;

    function GetMouseDownFontStyle: TFontStyles;
    function GetMouseDownFontStyleChange: Boolean;
    function GetMouseOverFontStyle: TFontStyles;
    function GetMouseOverFontStyleChange: Boolean;
    function GetPushedFontStyle: TFontStyles;
    function GetPushedFontStyleChange: Boolean;

    procedure SetMouseDownFontStyle(const Value: TFontStyles);
    procedure SetMouseDownFontStyleChange(const Value: Boolean);
    procedure SetMouseOverFontStyle(const Value: TFontStyles);
    procedure SetMouseOverFontStyleChange(const Value: Boolean);
    procedure SetPushedFontStyle(const Value: TFontStyles);
    procedure SetPushedFontStyleChange(const Value: Boolean);

    procedure SetMouseDownFontSize(const Value: TControlSize);
    procedure SetMouseDownFontSizeChange(const Value: Boolean);
    procedure SetMouseOverFontSize(const Value: TControlSize);
    procedure SetMouseOverFontSizeChange(const Value: Boolean);
    procedure SetPushedFontSize(const Value: TControlSize);
    procedure SetPushedFontSizeChange(const Value: Boolean);

    procedure SetMouseDownFontColor(const Value: TDelphiColor);
    procedure SetMouseDownFontColorChange(const Value: Boolean);
    procedure SetMouseOverFontColor(const Value: TDelphiColor);
    procedure SetMouseOverFontColorChange(const Value: Boolean);
    procedure SetPushedFontColor(const Value: TDelphiColor);
    procedure SetPushedFontColorChange(const Value: Boolean);
  public
    constructor Create(ADrawParam:TDrawParam);override;
  published
    property MouseDownFontColor:TDelphiColor read GetMouseDownFontColor write SetMouseDownFontColor stored IsMouseDownFontColorStored;
    property MouseDownFontColorChange:Boolean read GetMouseDownFontColorChange write SetMouseDownFontColorChange stored IsMouseDownFontColorChangeStored;
    property MouseDownFontSize:TControlSize read GetMouseDownFontSize write SetMouseDownFontSize stored IsMouseDownFontSizeStored;
    property MouseDownFontSizeChange:Boolean read GetMouseDownFontSizeChange write SetMouseDownFontSizeChange stored IsMouseDownFontSizeChangeStored;
    property MouseDownFontStyle:TFontStyles read GetMouseDownFontStyle write SetMouseDownFontStyle stored IsMouseDownFontStyleStored;
    property MouseDownFontStyleChange:Boolean read GetMouseDownFontStyleChange write SetMouseDownFontStyleChange stored IsMouseDownFontStyleChangeStored;

    property MouseOverFontColor:TDelphiColor read GetMouseOverFontColor write SetMouseOverFontColor stored IsMouseOverFontColorStored;
    property MouseOverFontColorChange:Boolean read GetMouseOverFontColorChange write SetMouseOverFontColorChange stored IsMouseOverFontColorChangeStored;
    property MouseOverFontSize:TControlSize read GetMouseOverFontSize write SetMouseOverFontSize stored IsMouseOverFontSizeStored;
    property MouseOverFontSizeChange:Boolean read GetMouseOverFontSizeChange write SetMouseOverFontSizeChange stored IsMouseOverFontSizeChangeStored;
    property MouseOverFontStyle:TFontStyles read GetMouseOverFontStyle write SetMouseOverFontStyle stored IsMouseOverFontStyleStored;
    property MouseOverFontStyleChange:Boolean read GetMouseOverFontStyleChange write SetMouseOverFontStyleChange stored IsMouseOverFontStyleChangeStored;

    property PushedFontColor:TDelphiColor read GetPushedFontColor write SetPushedFontColor stored IsPushedFontColorStored;
    property PushedFontColorChange:Boolean read GetPushedFontColorChange write SetPushedFontColorChange stored IsPushedFontColorChangeStored;
    property PushedFontSize:TControlSize read GetPushedFontSize write SetPushedFontSize stored IsPushedFontSizeStored;
    property PushedFontSizeChange:Boolean read GetPushedFontSizeChange write SetPushedFontSizeChange stored IsPushedFontSizeChangeStored;
    property PushedFontStyle:TFontStyles read GetPushedFontStyle write SetPushedFontStyle stored IsPushedFontStyleStored;
    property PushedFontStyleChange:Boolean read GetPushedFontStyleChange write SetPushedFontStyleChange stored IsPushedFontStyleChangeStored;

  end;





  /// <summary>
  ///   <para>
  ///     文本绘制参数
  ///   </para>
  ///   <para>
  ///     Parameters of drawing text
  ///   </para>
  /// </summary>
  TBaseDrawTextParam=class(TDrawParam)
  private
    FDrawFont:TDrawFont;

    FIsWordWrap: Boolean;
    FIsDrawVert: Boolean;

    FFontVertAlign: TFontVertAlign;
    FFontHorzAlign: TFontHorzAlign;

    FFontTrimming: TFontTrimmingType;
    FAutoSizeHeightAdjust: Double;
    FAutoSizeWidthAdjust: Double;

    procedure SetDrawFont(const Value: TDrawFont);
    procedure DoDrawFontChange(Sender:TObject);


    function IsFontHorzAlignStored: Boolean;
    function IsFontTrimmingStored: Boolean;
    function IsFontVertAlignStored: Boolean;
    function IsIsDrawVertStored: Boolean;
    function IsIsWordWrapStored: Boolean;
    function IsFamilyStored: Boolean;
    function IsSizeStored: Boolean;
    function IsHorzAlignStored: Boolean;
    function IsVertAlignStored: Boolean;
    function IsFontColorStored: Boolean;
    function IsFontStyleStored: Boolean;

    procedure SetIsWordWrap(const Value: Boolean);
    procedure SetFontHorzAlign(const Value: TFontHorzAlign);
    procedure SetFontVertAlign(const Value: TFontVertAlign);
    procedure SetIsDrawVert(const Value: Boolean);
    function GetDrawEffectSetting: TDrawTextEffectSetting;
    procedure SetDrawEffectSetting(const Value: TDrawTextEffectSetting);
    function GetFontColor: TDelphiColor;
    function GetFontName: TFontName;
    function GetFontSize: TControlSize;
    function GetFontStyle: TFontStyles;
    procedure SetFontColor(const Value: TDelphiColor);
    procedure SetFontName(const Value: TFontName);
    procedure SetFontSize(const Value: TControlSize);
    procedure SetFontStyle(const Value: TFontStyles);
//    function GetSetting: TDrawTextParamSetting;
//    procedure SetSetting(const Value: TDrawTextParamSetting);
    function GetHorzAlign: TSkinAlign;
    function GetVertAlign: TSkinAlign;
    procedure SetHorzAlign(const Value: TSkinAlign);
    procedure SetVertAlign(const Value: TSkinAlign);
    procedure SetAutoSizeHeightAdjust(const Value: Double);
    procedure SetAutoSizeWidthAdjust(const Value: Double);
  protected
    /// <summary>
    ///   <para>
    ///     获取文本绘制参数效果类
    ///   </para>
    ///   <para>
    ///     Get class of drawing text parameters effect
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
    FIsMustStoreFontColor:Boolean;
    constructor Create(const AName:String;const ACaption:String);override;
    destructor Destroy;override;
  public
    {$IFDEF FMX}
    //用于加载速度
    FTextLayout: TTextLayout;
    {$ENDIF}

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
    /// <summary>
    ///   <para>
    ///     当前效果的字体颜色
    ///   </para>
    ///   <para>
    ///     Font color of current effect
    ///   </para>
    /// </summary>
    function CurrentEffectFontColor:TDrawColor;
    /// <summary>
    ///   <para>
    ///     当前效果的字体名称
    ///   </para>
    ///   <para>
    ///     Font name of current effect
    ///   </para>
    /// </summary>
    function CurrentEffectFontName:TFontName;
    /// <summary>
    ///   <para>
    ///     当前效果的字体大小
    ///   </para>
    ///   <para>
    ///     Font size of current effect
    ///   </para>
    /// </summary>
    function CurrentEffectFontSize:TControlSize;
    /// <summary>
    ///   <para>
    ///     当前效果的字体风格
    ///   </para>
    ///   <para>
    ///     FontStyle of current effect
    ///   </para>
    /// </summary>
    function CurrentEffectFontStyle:TFontStyles;
  public
    property FontName:TFontName read GetFontName write SetFontName{$IFDEF FMX} stored IsFamilyStored{$ENDIF};
    property FontStyle:TFontStyles read GetFontStyle write SetFontStyle stored IsFontStyleStored;
    property FontSize:TControlSize read GetFontSize write SetFontSize{$IFDEF FMX} stored IsSizeStored{$ENDIF};
    property FontColor:TDelphiColor read GetFontColor write SetFontColor stored IsFontColorStored;



    /// <summary>
    ///   <para>
    ///     字体
    ///   </para>
    ///   <para>
    ///     Font
    ///   </para>
    /// </summary>
    property DrawFont:TDrawFont read FDrawFont write SetDrawFont;
    /// <summary>
    ///   <para>
    ///     是否垂直绘制
    ///   </para>
    ///   <para>
    ///     Whether draw vertically
    ///   </para>
    /// </summary>
    property IsDrawVert:Boolean read FIsDrawVert write SetIsDrawVert stored IsIsDrawVertStored;
    /// <summary>
    ///   <para>
    ///     是否换行
    ///   </para>
    ///   <para>
    ///     Whether WordWrap
    ///   </para>
    /// </summary>
    property IsWordWrap:Boolean read FIsWordWrap write SetIsWordWrap stored IsIsWordWrapStored;
    /// <summary>
    ///   <para>
    ///     字体截断类型
    ///   </para>
    ///   <para>
    ///     Style of font trimming
    ///   </para>
    /// </summary>
    property FontTrimming:TFontTrimmingType read FFontTrimming write FFontTrimming;// stored IsFontTrimmingStored;
    /// <summary>
    ///   <para>
    ///     水平对齐风格
    ///   </para>
    ///   <para>
    ///     Style of horizontal align
    ///   </para>
    /// </summary>
    property FontHorzAlign: TFontHorzAlign read FFontHorzAlign write SetFontHorzAlign;// stored IsFontHorzAlignStored;
    property StaticFontHorzAlign: TFontHorzAlign read FFontHorzAlign write FFontHorzAlign;// stored IsFontHorzAlignStored;
    /// <summary>
    ///   <para>
    ///     垂直对齐风格
    ///   </para>
    ///   <para>
    ///     Style of vertical align
    ///   </para>
    /// </summary>
    property FontVertAlign: TFontVertAlign read FFontVertAlign write SetFontVertAlign;// stored IsFontVertAlignStored;


    /// <summary>
    ///   <para>
    ///     水平对齐风格
    ///   </para>
    ///   <para>
    ///     Style of horizontal align
    ///   </para>
    /// </summary>
    property HorzAlign: TSkinAlign read GetHorzAlign write SetHorzAlign;// stored IsHorzAlignStored;
    /// <summary>
    ///   <para>
    ///     垂直对齐风格
    ///   </para>
    ///   <para>
    ///     Style of vertical align
    ///   </para>
    /// </summary>
    property VertAlign: TSkinAlign read GetVertAlign write SetVertAlign;// stored IsVertAlignStored;


    property DrawEffectSetting:TDrawTextEffectSetting read GetDrawEffectSetting write SetDrawEffectSetting;


    //高级设置
//    property Setting:TDrawTextParamSetting read GetSetting write SetSetting;
    property AutoSizeWidthAdjust:Double read FAutoSizeWidthAdjust write SetAutoSizeWidthAdjust;
    property AutoSizeHeightAdjust:Double read FAutoSizeHeightAdjust write SetAutoSizeHeightAdjust;

  end;






  TDrawTextParam=class(TBaseDrawTextParam)
  published
    property FontName;
    property FontStyle;
    property FontSize;
    property FontColor;

    property DrawFont;
    property IsDrawVert;
    property IsWordWrap;
    property FontTrimming;
    property FontHorzAlign;
    property FontVertAlign;

    property DrawRectSetting;
    property DrawEffectSetting;
    property AutoSizeWidthAdjust;
    property AutoSizeHeightAdjust;
  end;














var
  GlobalDrawTextParam:TDrawTextParam;



  /// <summary>
  ///   <para>
  ///     是否使用系统默认的字体
  ///   </para>
  ///   <para>
  ///     Whetehr use default font
  ///   </para>
  /// </summary>
  GlobalIsUseDefaultFontFamily:Boolean;

  /// <summary>
  ///   <para>
  ///     默认的字体名称
  ///   </para>
  ///   <para>
  ///     Default font name
  ///   </para>
  /// </summary>
  GlobalDefaultFontFamily:TFontName;



function GetGlobalDrawTextParam:TDrawTextParam;


//字符串转换成Font
procedure StringToFont(sFont: string; Font: TFont{; bIncludeColor: Boolean = True});


//Font转换成字符串
function FontToString(Font: TFont{; bIncludeColor: Boolean = True}): string;

function GetStrFromSet_TDTPEffectTypes(ASet:TDTPEffectTypes):String;
function GetSetFromStr_TFontStyles(const ASetStr:String):TFontStyles;
function GetStrFromSet_TFontStyles(ASet:TFontStyles):String;
function GetSetFromStr_TDTPEffectTypes(const ASetStr:String):TDTPEffectTypes;

{$IFDEF FMX}
function DefaultFontFamily:string;
{$ENDIF}



function GetFontStyleStr(AFontStyles:TFontStyles):String;
function GetFontStyle(AFontStylesStr:String):TFontStyles;

function GetDTPEffectTypesStr(ADTPEffectTypes:TDTPEffectTypes):String;
function GetDTPEffectTypes(ADTPEffectTypesStr:String):TDTPEffectTypes;

function GetFontTrimming(AFontTrimmingStr:String): TFontTrimmingType;
function GetFontTrimmingStr(AFontTrimming:TFontTrimmingType): String;

function GetFontVertAlign(AFontVertAlignStr:String): TFontVertAlign;
function GetFontVertAlignStr(AFontVertAlign:TFontVertAlign): String;

function GetFontHorzAlign(AFontHorzAlignStr:String): TFontHorzAlign;
function GetFontHorzAlignStr(AFontHorzAlign:TFontHorzAlign): String;

{$IFDEF FMX}
function GetVertTextAlignStr(ATextAlign:TTextAlign):String;
function GetVertTextAlign(ATextAlignStr:String):TTextAlign;
function GetHorzTextAlignStr(ATextAlign:TTextAlign):String;
function GetHorzTextAlign(ATextAlignStr:String):TTextAlign;
{$ENDIF FMX}


implementation


{$IFDEF FMX}
function GetVertTextAlignStr(ATextAlign:TTextAlign):String;
begin
  case ATextAlign of
    TTextAlign.Center: Result:='Center';
    TTextAlign.Leading: Result:='Top';
    TTextAlign.Trailing: Result:='Bottom';
  end;
end;

function GetVertTextAlign(ATextAlignStr:String):TTextAlign;
begin
  Result:=TTextAlign.Leading;

//  if SameText(ATextAlignStr,'Leading') then
  if SameText(ATextAlignStr,'Top') then
  begin
    Result:=TTextAlign.Leading;
  end
  else if SameText(ATextAlignStr,'Center') then
  begin
    Result:=TTextAlign.Center;
  end
//  else if SameText(ATextAlignStr,'Trailing') then
  else if SameText(ATextAlignStr,'Bottom') then
  begin
    Result:=TTextAlign.Trailing;
  end;

end;

function GetHorzTextAlignStr(ATextAlign:TTextAlign):String;
begin
  case ATextAlign of
    TTextAlign.Center: Result:='Center';
    TTextAlign.Leading: Result:='Left';
    TTextAlign.Trailing: Result:='Right';
  end;
end;

function GetHorzTextAlign(ATextAlignStr:String):TTextAlign;
begin
  Result:=TTextAlign.Leading;

//  if SameText(ATextAlignStr,'Leading') then
  if SameText(ATextAlignStr,'Left') then
  begin
    Result:=TTextAlign.Leading;
  end
  else if SameText(ATextAlignStr,'Center') then
  begin
    Result:=TTextAlign.Center;
  end
//  else if SameText(ATextAlignStr,'Trailing') then
  else if SameText(ATextAlignStr,'Right') then
  begin
    Result:=TTextAlign.Trailing;
  end;


end;
{$ENDIF FMX}


function GetFontHorzAlign(AFontHorzAlignStr:String): TFontHorzAlign;
begin
  Result:=TFontHorzAlign.fhaLeft;

//  if SameText(AFontHorzAlignStr,'Leading') then
  if SameText(AFontHorzAlignStr,'Left')
    or SameText(AFontHorzAlignStr,'fhaLeft') then
  begin
    Result:=TFontHorzAlign.fhaLeft;
  end
  else if SameText(AFontHorzAlignStr,'Center')
    or SameText(AFontHorzAlignStr,'fhaCenter') then
  begin
    Result:=TFontHorzAlign.fhaCenter;
  end
//  else if SameText(AFontHorzAlignStr,'Trailing') then
  else if SameText(AFontHorzAlignStr,'Right')
        or SameText(AFontHorzAlignStr,'fhaRight') then
  begin
    Result:=TFontHorzAlign.fhaRight;
  end;
end;

function GetFontHorzAlignStr(AFontHorzAlign:TFontHorzAlign): String;
begin
  case AFontHorzAlign of
    fhaLeft: Result:='Left';
    fhaCenter: Result:='Center';
    fhaRight: Result:='Right';
//    fhaLeft: Result:='Leading';
//    fhaCenter: Result:='Center';
//    fhaRight: Result:='Trailing';
  end;
end;

function GetFontVertAlign(AFontVertAlignStr:String): TFontVertAlign;
begin
  Result:=TFontVertAlign.fvaTop;

//  if SameText(AFontVertAlignStr,'Leading') then
  if SameText(AFontVertAlignStr,'Top')
    or SameText(AFontVertAlignStr,'fvaTop') then
  begin
    Result:=TFontVertAlign.fvaTop;
  end
  else if SameText(AFontVertAlignStr,'Center')
        or SameText(AFontVertAlignStr,'fvaCenter') then
  begin
    Result:=TFontVertAlign.fvaCenter;
  end
//  else if SameText(AFontVertAlignStr,'Trailing') then
  else if SameText(AFontVertAlignStr,'Bottom')
        or SameText(AFontVertAlignStr,'fvaBottom') then
  begin
    Result:=TFontVertAlign.fvaBottom;
  end;
end;

function GetFontVertAlignStr(AFontVertAlign:TFontVertAlign): String;
begin
  case AFontVertAlign of
    fvaTop: Result:='Top';
    fvaCenter: Result:='Center';
    fvaBottom: Result:='Bottom';
//    fvaTop: Result:='Leading';
//    fvaCenter: Result:='Center';
//    fvaBottom: Result:='Trailing';
  end;
end;

function GetFontTrimming(AFontTrimmingStr:String): TFontTrimmingType;
begin
  Result:=TFontTrimmingType.fttNone;
  if SameText(AFontTrimmingStr,'Character') then
  begin
    Result:=TFontTrimmingType.fttCharacter;
  end;
  if SameText(AFontTrimmingStr,'Word') then
  begin
    Result:=TFontTrimmingType.fftWord;
  end;
end;

function GetFontTrimmingStr(AFontTrimming:TFontTrimmingType): String;
begin
  case AFontTrimming of
    fttNone: Result:='None';
    fttCharacter: Result:='Character';
    fftWord: Result:='Word';
  end;
end;


function GetDTPEffectTypesStr(ADTPEffectTypes:TDTPEffectTypes):String;
begin
  Result:='';
  if dtpetFontColorChange in ADTPEffectTypes then
  begin
    Result:=Result+'FontColorChange';
  end;
  if dtpetFontSizeChange in ADTPEffectTypes then
  begin
    Result:=Result+'FontSizeChange';
  end;
  if dtpetFontStyleChange in ADTPEffectTypes then
  begin
    Result:=Result+'FontStyleChange';
  end;
end;

function GetDTPEffectTypes(ADTPEffectTypesStr:String):TDTPEffectTypes;
var
  AStringList:TStringList;
begin
  Result:=[];
  AStringList:=TStringList.Create;
  try
    AStringList.CommaText:=ADTPEffectTypesStr;
    if AStringList.IndexOf('FontColorChange')<>-1 then
    begin
      Result:=Result+[TDTPEffectType.dtpetFontColorChange];
    end;
    if AStringList.IndexOf('FontSizeChange')<>-1 then
    begin
      Result:=Result+[TDTPEffectType.dtpetFontSizeChange];
    end;
    if AStringList.IndexOf('FontStyleChange')<>-1 then
    begin
      Result:=Result+[TDTPEffectType.dtpetFontStyleChange];
    end;
  finally
    FreeAndNil(AStringList);
  end;
end;

//fsBold, fsItalic, fsUnderline, fsStrikeOut
function GetFontStyleStr(AFontStyles:TFontStyles):String;
begin
  Result:='';
  if TFontStyle.fsBold in AFontStyles then
  begin
    Result:=Result+'Bold'+',';
  end;
  if TFontStyle.fsItalic in AFontStyles then
  begin
    Result:=Result+'Italic'+',';
  end;
  if TFontStyle.fsUnderline in AFontStyles then
  begin
    Result:=Result+'Underline'+',';
  end;
  if TFontStyle.fsStrikeOut in AFontStyles then
  begin
    Result:=Result+'StrikeOut'+',';
  end;
end;

function GetFontStyle(AFontStylesStr:String):TFontStyles;
var
  AStringList:TStringList;
begin
  Result:=[];
  AStringList:=TStringList.Create;
  try
    AStringList.CommaText:=AFontStylesStr;
    if AStringList.IndexOf('Bold')<>-1 then
    begin
      Result:=Result+[TFontStyle.fsBold];
    end;
    if AStringList.IndexOf('Italic')<>-1 then
    begin
      Result:=Result+[TFontStyle.fsItalic];
    end;
    if AStringList.IndexOf('Underline')<>-1 then
    begin
      Result:=Result+[TFontStyle.fsUnderline];
    end;
    if AStringList.IndexOf('StrikeOut')<>-1 then
    begin
      Result:=Result+[TFontStyle.fsStrikeOut];
    end;
  finally
    FreeAndNil(AStringList);
  end;
end;




const
  csfsBold      = '|Bold';
  csfsItalic    = '|Italic';
  csfsUnderline = '|Underline';
  csfsStrikeout = '|Strikeout';

{$IFDEF FMX}
function DefaultFontFamily:string;
begin
  Result:=GetGlobalDrawTextParam.DrawFont.DefaultFamily;
end;
{$ENDIF}

procedure StringToFont(sFont: string; Font: TFont{; bIncludeColor: Boolean = True});
var
  P     : Integer;
  sStyle: string;
begin
  with Font do
    try
      // get font name
      P := Pos(',', sFont);
      {$IFDEF VCL}Name{$ENDIF}{$IFDEF FMX}Family{$ENDIF} := Copy(sFont, 2, P - 3);
      Delete(sFont, 1, P);

      // get font size
      P := Pos(',', sFont);
      Size := ControlSize(StrToFloat(Copy(sFont, 2, P - 2)));
      Delete(sFont, 1, P);

      // get font style
      P := Pos(',', sFont);
      sStyle := '|' + Copy(sFont, 3, P - 4);
      Delete(sFont, 1, P);

//      // get font color
//      if bIncludeColor then
//        Color := StrToInt('$'+Copy(sFont, 3, Length(sFont) - 3));

      // convert str font style to
      // font style
      Style := [];

      if (Pos(csfsBold, sStyle) > 0) then
        Style := Style + [{$IFDEF FMX}TFontStyle.{$ENDIF}fsBold];

      if (Pos(csfsItalic, sStyle) > 0) then
        Style := Style + [{$IFDEF FMX}TFontStyle.{$ENDIF}fsItalic];

      if (Pos(csfsUnderline, sStyle) > 0) then
        Style := Style + [{$IFDEF FMX}TFontStyle.{$ENDIF}fsUnderline];

      if (Pos(csfsStrikeout, sStyle) > 0) then
        Style := Style + [{$IFDEF FMX}TFontStyle.{$ENDIF}fsStrikeOut];
    except
    end;
end;

//
// Output format:
//   "Aril", 9, [Bold|Italic], [clAqua]
//
function FontToString(Font: TFont{; bIncludeColor: Boolean = True}): string;
var
  sStyle: string;
begin
  with Font do
  begin
    // convert font style to string
    sStyle := '';

    if ({$IFDEF FMX}TFontStyle.{$ENDIF}fsBold in Style) then
      sStyle := sStyle + csfsBold;

    if ({$IFDEF FMX}TFontStyle.{$ENDIF}fsItalic in Style) then
      sStyle := sStyle + csfsItalic;

    if ({$IFDEF FMX}TFontStyle.{$ENDIF}fsUnderline in Style) then
      sStyle := sStyle + csfsUnderline;

    if ({$IFDEF FMX}TFontStyle.{$ENDIF}fsStrikeOut in Style) then
      sStyle := sStyle + csfsStrikeout;

    if ((Length(sStyle) > 0) and ('|' = sStyle[1])) then
      sStyle := Copy(sStyle, 2, Length(sStyle) - 1);

    Result := '"'+{$IFDEF VCL}Name{$ENDIF}{$IFDEF FMX}Family{$ENDIF}+'", '
              +FloatToStr(Size)+', ['+sStyle+']';

    Result:=Result+',';
//    if bIncludeColor then
//      Result := Result + Format(', [%s]',[IntToHex(Color, 6)]);
  end;
end;



function DefaultFontSize: TControlSize;
{$IFDEF FMX}
var
  FontSvc: IFMXSystemFontService;
{$ENDIF}
begin

  {$IFDEF FMX}
    if TPlatformServices.Current.SupportsPlatformService(IFMXSystemFontService, FontSvc) then
      Result := FontSvc.GetDefaultFontSize
    else
      Result := DefaultFontSize;
  {$ENDIF}

  {$IFDEF VCL}
    Result:=12;
  {$ENDIF}

end;



function GetStrFromSet_TFontStyles(ASet:TFontStyles):String;
var
  I:TFontStyle;
begin
  Result:='';
  for I := Low(TFontStyle) to High(TFontStyle) do
  begin
    if I in ASet then
    begin
      Result:=Result+IntToStr(Ord(I))+',';
    end;
  end;
end;

function GetSetFromStr_TFontStyles(const ASetStr:String):TFontStyles;
var
  I,AElem:Integer;
  J:TFontStyle;
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
        for J := Low(TFontStyle) to High(TFontStyle) do
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


function GetStrFromSet_TDTPEffectTypes(ASet:TDTPEffectTypes):String;
var
  I:TDTPEffectType;
begin
  Result:='';
  for I := Low(TDTPEffectType) to High(TDTPEffectType) do
  begin
    if I in ASet then
    begin
      Result:=Result+IntToStr(Ord(I))+',';
    end;
  end;
end;

function GetSetFromStr_TDTPEffectTypes(const ASetStr:String):TDTPEffectTypes;
var
  I,AElem:Integer;
  J:TDTPEffectType;
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
        for J := Low(TDTPEffectType) to High(TDTPEffectType) do
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



{ TDrawTextEffectSetting }

function TDrawTextEffectSetting.GetDisabledEffect: TDrawTextParamEffect;
begin
  Result:=TDrawTextParamEffect(Self.FDisabledEffect);
end;

function TDrawTextEffectSetting.GetDrawParamEffectClass: TDrawParamCommonEffectClass;
begin
  Result:=TDrawTextParamEffect;
end;

function TDrawTextEffectSetting.GetFocusedEffect: TDrawTextParamEffect;
begin
  Result:=TDrawTextParamEffect(Self.FFocusedEffect);
end;

function TDrawTextEffectSetting.GetMouseDownEffect: TDrawTextParamEffect;
begin
  Result:=TDrawTextParamEffect(Self.FMouseDownEffect);
end;

function TDrawTextEffectSetting.GetMouseOverEffect: TDrawTextParamEffect;
begin
  Result:=TDrawTextParamEffect(Self.FMouseOverEffect);
end;

function TDrawTextEffectSetting.GetPushedEffect: TDrawTextParamEffect;
begin
  Result:=TDrawTextParamEffect(Self.FPushedEffect);
end;

procedure TDrawTextEffectSetting.SetDisabledEffect(
  const Value: TDrawTextParamEffect);
begin
  FDisabledEffect.Assign(Value);
end;

procedure TDrawTextEffectSetting.SetFocusedEffect(
  const Value: TDrawTextParamEffect);
begin
  FFocusedEffect.Assign(Value);
end;

procedure TDrawTextEffectSetting.SetMouseDownEffect(
  const Value: TDrawTextParamEffect);
begin
  FMouseDownEffect.Assign(Value);
end;

procedure TDrawTextEffectSetting.SetMouseOverEffect(
  const Value: TDrawTextParamEffect);
begin
  FMouseOverEffect.Assign(Value);
end;

procedure TDrawTextEffectSetting.SetPushedEffect(
  const Value: TDrawTextParamEffect);
begin
  FPushedEffect.Assign(Value);
end;

{ TBaseDrawTextParam }

function TBaseDrawTextParam.GetHorzAlign: TSkinAlign;
begin
  case Self.FFontHorzAlign of
    fhaLeft: Result:=salLeading;
    fhaCenter: Result:=salCenter;
    fhaRight: Result:=salTrailing;
  end;
end;

function TBaseDrawTextParam.GetVertAlign: TSkinAlign;
begin
  case Self.FFontVertAlign of
    fvaTop: Result:=salLeading;
    fvaCenter: Result:=salCenter;
    fvaBottom: Result:=salTrailing;
  end;
end;

function TBaseDrawTextParam.IsHorzAlignStored: Boolean;
begin
  Result:=FFontHorzAlign<>fhaLeft;
end;

function TBaseDrawTextParam.IsVertAlignStored: Boolean;
begin
  Result:=FFontVertAlign<>fvaTop;
end;

procedure TBaseDrawTextParam.SetHorzAlign(const Value: TSkinAlign);
begin
  case Value of
    salLeading: FontHorzAlign:=fhaLeft;
    salCenter: FontHorzAlign:=fhaCenter;
    salTrailing: FontHorzAlign:=fhaRight;
  end;
end;

procedure TBaseDrawTextParam.SetVertAlign(const Value: TSkinAlign);
begin
  case Value of
    salLeading: FontVertAlign:=fvaTop;
    salCenter: FontVertAlign:=fvaCenter;
    salTrailing: FontVertAlign:=fvaBottom;
  end;
end;

constructor TBaseDrawTextParam.Create(const AName:String;const ACaption:String);
begin
  FDrawFont:=TDrawFont.Create;
  inherited Create(AName,ACaption);
  FDrawFont.OnChanged:=DoDrawFontChange;

  FIsDrawVert:=False;
end;

destructor TBaseDrawTextParam.Destroy;
begin
  {$IFDEF FMX}
  FreeAndNil(FTextLayout);
  {$ENDIF}
  FreeAndNil(FDrawFont);

  inherited;
end;

function TBaseDrawTextParam.GetDrawEffectSetting: TDrawTextEffectSetting;
begin
  Result:=TDrawTextEffectSetting(Self.FDrawEffectSetting);
end;

function TBaseDrawTextParam.GetDrawEffectSettingClass: TDrawEffectSettingClass;
begin
  Result:=TDrawTextEffectSetting;
end;

function TBaseDrawTextParam.GetDrawParamSettingClass: TDrawParamSettingClass;
begin
  Result:=TDrawTextParamSetting;
end;

function TBaseDrawTextParam.GetFontColor: TDelphiColor;
begin
  Result:=FDrawFont.FFontColor.Color;
end;

function TBaseDrawTextParam.GetFontName: TFontName;
begin
  {$IFDEF FMX}
  Result:=FDrawFont.Family;
  {$ENDIF}
  {$IFDEF VCL}
  Result:=FDrawFont.FontName;
  {$ENDIF}
end;

function TBaseDrawTextParam.GetFontSize: TControlSize;
begin
  Result:=FDrawFont.Size;
end;

function TBaseDrawTextParam.GetFontStyle: TFontStyles;
begin
  Result:=FDrawFont.Style;
end;

//function TBaseDrawTextParam.GetSetting: TDrawTextParamSetting;
//begin
//  Result:=TDrawTextParamSetting(Self.FSetting);
//end;

function TBaseDrawTextParam.IsFamilyStored: Boolean;
begin
  {$IFDEF FMX}
  Result := FDrawFont.Family <> FDrawFont.DefaultFamily;
  {$ENDIF}
  {$IFDEF VCL}
  Result := True;
  {$ENDIF}
end;

function TBaseDrawTextParam.IsFontColorStored: Boolean;
begin
  Result:=(Self.FDrawFont.FFontColor.FColor<>Const_DefaultColor) or FIsMustStoreFontColor;
end;

function TBaseDrawTextParam.IsFontHorzAlignStored: Boolean;
begin
  Result:=(Self.FFontHorzAlign<>fhaLeft);
end;

function TBaseDrawTextParam.IsFontStyleStored: Boolean;
begin
  Result:=(Self.FDrawFont.Style<>[]);
end;

function TBaseDrawTextParam.IsFontTrimmingStored: Boolean;
begin
  Result:=(Self.FFontTrimming<>fttNone);
end;

function TBaseDrawTextParam.IsFontVertAlignStored: Boolean;
begin
  Result:=(Self.FFontVertAlign<>fvaTop);
end;

function TBaseDrawTextParam.IsIsDrawVertStored: Boolean;
begin
  Result:=(Self.FIsDrawVert<>False);
end;

function TBaseDrawTextParam.IsIsWordWrapStored: Boolean;
begin
  Result:=(Self.FIsWordWrap<>False);
end;

function TBaseDrawTextParam.IsSizeStored: Boolean;
begin
  {$IFDEF FMX}
  Result := NotEqualDouble(FDrawFont.Size,FDrawFont.DefaultSize);
  {$ENDIF}
  {$IFDEF VCL}
  Result:=False;
  {$ENDIF}
end;

procedure TBaseDrawTextParam.DoDrawFontChange(Sender: TObject);
begin
  DoChange;
end;

procedure TBaseDrawTextParam.Clear;
begin
  inherited Clear;

  FDrawFont.Clear;

  FIsWordWrap:=False;

  Self.FFontTrimming:=fttNone;

  FFontVertAlign:=fvaTop;
  FFontHorzAlign:=fhaLeft;
end;

function TBaseDrawTextParam.CurrentEffectFontColor: TDrawColor;
begin
  Result:=Self.FDrawFont.FFontColor;
  if (CurrentEffect<>nil) and (dtpetFontColorChange in TDrawTextParamEffect(CurrentEffect).FEffectTypes) then
  begin
    Result:=TDrawTextParamEffect(CurrentEffect).FFontColor;
  end;
end;

function TBaseDrawTextParam.CurrentEffectFontName: TFontName;
begin
  Result:=Self.FDrawFont.FontName;
end;

function TBaseDrawTextParam.CurrentEffectFontSize: TControlSize;
begin
  Result:=Self.FDrawFont.FontSize;
  if (CurrentEffect<>nil) and (dtpetFontSizeChange in TDrawTextParamEffect(CurrentEffect).FEffectTypes) then
  begin
    {$IFDEF FMX}
    Result:=TDrawTextParamEffect(CurrentEffect).FFontSize;
    {$ENDIF}
    {$IFDEF VCL}
    //在高分屏的情况下,要除一下
    Result:=Ceil(TDrawTextParamEffect(CurrentEffect).FFontSize/GetScreenScaleRate);
    {$ENDIF}

  end;
end;

function TBaseDrawTextParam.CurrentEffectFontStyle: TFontStyles;
begin
  Result:=Self.FDrawFont.FontStyle;
  if (CurrentEffect<>nil) and (dtpetFontStyleChange in TDrawTextParamEffect(CurrentEffect).FEffectTypes) then
  begin
    Result:=TDrawTextParamEffect(CurrentEffect).FFontStyle;
  end;
end;

//function TBaseDrawTextParam.CustomLoadFromJson(ASuperObject: ISuperObject): Boolean;
//begin
//
//  Result:=False;
//
//  Self.FDrawFont.FontName:=ASuperObject.S['font_name'];
//  Self.FDrawFont.FontStyle:=GetFontStyle(ASuperObject.S['font_style']);
//  Self.FDrawFont.FontSize:=ASuperObject.F['font_size'];
//  Self.FDrawFont.FontColor.Color:=WebHexToColor(ASuperObject.S['font_color']);
//
//  Self.FFontTrimming:=GetFontTrimming(ASuperObject.S['font_trimming']);
//
//  Self.FFontVertAlign:=GetFontVertAlign(ASuperObject.S['font_vert_align']);
//  Self.FFontHorzAlign:=GetFontHorzAlign(ASuperObject.S['font_horz_align']);
//
//  Self.FIsWordWrap:=(ASuperObject.I['is_wordwrap']=1);
//  Self.FIsDrawVert:=(ASuperObject.I['is_drawvert']=1);
//
//  Result:=True;
//end;
//
//function TBaseDrawTextParam.CustomSaveToJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  ASuperObject.S['type']:='DrawTextParam';
//
//  ASuperObject.S['font_name']:=Self.FDrawFont.FontName;
//  ASuperObject.S['font_style']:=GetFontStyleStr(Self.FDrawFont.FontStyle);
//  ASuperObject.F['font_size']:=Self.FDrawFont.FontSize;
//  ASuperObject.S['font_color']:=ColorToWebHex(Self.FDrawFont.FontColor.Color);
//
//  ASuperObject.S['font_trimming']:=GetFontTrimmingStr(Self.FFontTrimming);
//
//  ASuperObject.S['font_vert_align']:=GetFontVertAlignStr(Self.FFontVertAlign);
//  ASuperObject.S['font_horz_align']:=GetFontHorzAlignStr(Self.FFontHorzAlign);
//
//  ASuperObject.I['is_wordwrap']:=Ord(Self.FIsWordWrap);
//  ASuperObject.I['is_drawvert']:=Ord(Self.FIsDrawVert);
//
//  Result:=True;
//end;

function TBaseDrawTextParam.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='DrawFont' then
    begin
      Self.FDrawFont.LoadFromDocNode(ABTNode.ConvertNode_Class);
    end
    else if ABTNode.NodeName='IsDrawVert' then
    begin
      FIsDrawVert:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='IsWordWrap' then
    begin
      FIsWordWrap:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='FontTrimming' then
    begin
      FFontTrimming:=TFontTrimmingType(ABTNode.ConvertNode_Int32.Data);
    end
    else if ABTNode.NodeName='FontHorzAlign' then
    begin
      FFontHorzAlign:=TFontHorzAlign(ABTNode.ConvertNode_Int32.Data);
    end
    else if ABTNode.NodeName='FontVertAlign' then
    begin
      FFontVertAlign:=TFontVertAlign(ABTNode.ConvertNode_Int32.Data);
    end
    ;

  end;

  Result:=True;
end;

function TBaseDrawTextParam.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Class('DrawFont','绘制字体');
  FDrawFont.SaveToDocNode(ABTNode.ConvertNode_Class);

  ABTNode:=ADocNode.AddChildNode_Bool32('IsDrawVert','是否垂直绘制');
  ABTNode.ConvertNode_Bool32.Data:=FIsDrawVert;

  ABTNode:=ADocNode.AddChildNode_Bool32('IsWordWrap','是否换行');
  ABTNode.ConvertNode_Bool32.Data:=FIsWordWrap;

  ABTNode:=ADocNode.AddChildNode_Int32('FontTrimming','字体截断类型');
  ABTNode.ConvertNode_Int32.Data:=Ord(FFontTrimming);

  ABTNode:=ADocNode.AddChildNode_Int32('FontHorzAlign','水平对齐风格');
  ABTNode.ConvertNode_Int32.Data:=Ord(FFontHorzAlign);

  ABTNode:=ADocNode.AddChildNode_Int32('FontVertAlign','垂直对齐风格');
  ABTNode.ConvertNode_Int32.Data:=Ord(FFontVertAlign);



  Result:=True;
end;

procedure TBaseDrawTextParam.SetAutoSizeHeightAdjust(const Value: Double);
begin
  if FAutoSizeHeightAdjust<>Value then
  begin
    FAutoSizeHeightAdjust := Value;
    DoChange;
  end;
end;

procedure TBaseDrawTextParam.SetAutoSizeWidthAdjust(const Value: Double);
begin
  if FAutoSizeHeightAdjust<>Value then
  begin
    FAutoSizeWidthAdjust := Value;
    DoChange;
  end;
end;

procedure TBaseDrawTextParam.SetDrawEffectSetting(
  const Value: TDrawTextEffectSetting);
begin
  FDrawEffectSetting.Assign(Value);
end;

procedure TBaseDrawTextParam.SetDrawFont(const Value: TDrawFont);
begin
  FDrawFont.Assign(Value);
end;

procedure TBaseDrawTextParam.SetFontColor(const Value: TDelphiColor);
begin
  Self.FDrawFont.FFontColor.Color:=Value;
end;

procedure TBaseDrawTextParam.SetFontHorzAlign(const Value: TFontHorzAlign);
begin
  if FFontHorzAlign<>Value then
  begin
    FFontHorzAlign := Value;
    DoChange;
  end;
end;

procedure TBaseDrawTextParam.SetFontName(const Value: TFontName);
begin
  {$IFDEF FMX}
  Self.FDrawFont.Family:=Value;
  {$ENDIF}
  {$IFDEF VCL}
  Self.FDrawFont.FontName:=Value;
  {$ENDIF}
end;

procedure TBaseDrawTextParam.SetFontSize(const Value: TControlSize);
begin
  Self.FDrawFont.Size:=Value;
end;

procedure TBaseDrawTextParam.SetFontStyle(const Value: TFontStyles);
begin
  Self.FDrawFont.Style:=Value;
end;

procedure TBaseDrawTextParam.SetFontVertAlign(const Value: TFontVertAlign);
begin
  if FFontVertAlign<>Value then
  begin
    FFontVertAlign := Value;
    DoChange;
  end;
end;

procedure TBaseDrawTextParam.SetIsDrawVert(const Value: Boolean);
begin
  if FIsDrawVert<>Value then
  begin
    FIsDrawVert := Value;
    if FIsDrawVert then
    begin
      FIsWordWrap := True;
    end;
    DoChange;
  end;
end;

procedure TBaseDrawTextParam.SetIsWordWrap(const Value: Boolean);
begin
  if FIsWordWrap<>Value then
  begin
    FIsWordWrap := Value;
    DoChange;
  end;
end;

//procedure TBaseDrawTextParam.SetSetting(const Value: TDrawTextParamSetting);
//begin
//
//end;

procedure TBaseDrawTextParam.AssignTo(Dest: TPersistent);
var
  DestObject:TBaseDrawTextParam;
begin
  if Dest is TBaseDrawTextParam then
  begin
    DestObject:=TBaseDrawTextParam(Dest);

    DestObject.FDrawFont.Assign(FDrawFont);

    DestObject.FFontTrimming:=FFontTrimming;

    DestObject.FFontVertAlign:=FFontVertAlign;
    DestObject.FFontHorzAlign:=FFontHorzAlign;

    DestObject.FIsWordWrap:=FIsWordWrap;
    DestObject.FIsDrawVert:=FIsDrawVert;
  end;

  Inherited;
end;




{ TDrawFont }

procedure TDrawFont.AfterConstruction;
begin
  inherited;
  if GetOwner <> nil then
    GetOwner.GetInterface(IInterface, FOwnerInterface);
end;

function TDrawFont._AddRef: Integer;
begin
  if FOwnerInterface <> nil then
    Result := FOwnerInterface._AddRef else
    Result := -1;
end;

function TDrawFont._Release: Integer;
begin
  if FOwnerInterface <> nil then
    Result := FOwnerInterface._Release else
    Result := -1;
end;

function TDrawFont.QueryInterface(const IID: TGUID;
  out Obj): HResult;
const
  E_NOINTERFACE = HResult($80004002);
begin
  if GetInterface(IID, Obj) then Result := 0 else Result := E_NOINTERFACE;
end;

constructor TDrawFont.Create;
begin
  FFontColor:=TDrawColor.Create('FontColor','字体颜色');

  Inherited Create;

  FFontColor.OnChange:=Self.DoFontColorChange;

  Clear;
end;

destructor TDrawFont.Destroy;
begin
  FreeAndNil(FFontColor);
  inherited;
end;

function TDrawFont.GetColor: TDelphiColor;
begin
  Result:=FFontColor.Color;
end;

function TDrawFont.GetFontName: TFontName;
begin
  Result:=Self.{$IFDEF VCL}Name{$ENDIF}{$IFDEF FMX}Family{$ENDIF};
end;

function TDrawFont.GetFontSize: TControlSize;
begin
  Result:=Self.Size;
end;

function TDrawFont.GetFontStyle: TFontStyles;
begin
  Result:=Self.Style;
end;

procedure TDrawFont.DoFontColorChange(Sender: TObject);
begin
  {$IFDEF VCL}
  Self.Color:=Self.FontColor.Color;
  {$ENDIF}
  DoChanged;
end;

{$IFDEF VCL}
procedure TDrawFont.DoChanged;
begin
  if Assigned(FOnChanged) then
  begin
    FOnChanged(Self);
  end;
end;
{$ENDIF}

procedure TDrawFont.Clear;
//var
//  AStyle:TFontStyleExt;
begin

  {$IFDEF VCL}
  Self.Color:=Const_DefaultColor;
  {$ENDIF}

//  FontSize:=12;
//  FontStyle:=[];
//  FontName:='Tahoma';
//  AStyle:=[];
  //一次设置全部,D10_1
//  SetSettings(DefaultFamily, DefaultSize,[]);

  FFontColor.Alpha:=255;
  FFontColor.Color:=Const_DefaultColor;

end;

//function TDrawFont.IsSizeStored: Boolean;
//begin
//  Result:=True;
//end;

function TDrawFont.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='Font' then
    begin
      StringToFont(ABTNode.ConvertNode_WideString.Data,Self);
    end
    else if ABTNode.NodeName='FontColor' then
    begin
      Self.FFontColor.Assign(ABTNode.ConvertNode_Color.Data);
    end
    ;

  end;

  Result:=True;
end;

function TDrawFont.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  ABTNode:=ADocNode.AddChildNode_WideString('Font','字体');
  ABTNode.ConvertNode_WideString.Data:=FontToString(Self);

  ABTNode:=ADocNode.AddChildNode_Color('FontColor','字体颜色');
  ABTNode.ConvertNode_Color.Data.Assign(FFontColor);

  Result:=True;
end;

procedure TDrawFont.SetColor(const Value: TDelphiColor);
begin
  FFontColor.Color:=Value;
end;

procedure TDrawFont.SetFontColor(const Value: TDrawColor);
begin
  if (FFontColor.Color<>Value.Color)
     or (FFontColor.Alpha<>Value.Alpha) then
  begin
    FFontColor.Assign(Value);

    {$IFDEF VCL}
    Self.Color:=Value.Color;
    {$ENDIF}

    DoChanged;
  end;
end;

procedure TDrawFont.SetFontName(const Value: TFontName);
begin
  if FontName<>Value then
  begin
    Self.{$IFDEF VCL}Name{$ENDIF}{$IFDEF FMX}Family{$ENDIF}:=Value;
    DoChanged;
  end;
end;

procedure TDrawFont.SetFontSize(const Value: TControlSize);
begin
  if FontSize<>Value then
  begin
    Self.Size:=Value;
    DoChanged;
  end;
end;

procedure TDrawFont.SetFontStyle(const Value: TFontStyles);
begin
  if FontStyle<>Value then
  begin
    Self.Style:=Value;
    DoChanged;
  end;
end;

procedure TDrawFont.Assign(Src: TPersistent);
var
  SrcObject:TDrawFont;
begin
  if Src is TDrawFont then
  begin
    SrcObject:=TDrawFont(Src);

    Self.FontSize:=SrcObject.GetFontSize;
    Self.FontStyle:=SrcObject.GetFontStyle;
    Self.FontName:=SrcObject.GetFontName;
    Self.FontColor.Assign(SrcObject.FFontColor);

    Self.DoChanged;
  end;
  Inherited;
end;

{ TDrawTextParamEffect }

procedure TDrawTextParamEffect.AssignTo(Dest: TPersistent);
var
  DestObject:TDrawTextParamEffect;
begin
  if Dest is TDrawTextParamEffect then
  begin
    DestObject:=TDrawTextParamEffect(Dest);

    DestObject.FFontColor.Assign(FFontColor);
//    DestObject.FFontName:=FFontName;
    DestObject.FFontSize:=FFontSize;
    DestObject.FFontStyle:=FFontStyle;

    DestObject.FEffectTypes:=FEffectTypes;
  end;

  Inherited;
end;

constructor TDrawTextParamEffect.Create;
begin
  FFontSize:=DefaultFontSize;

  FFontColor:=TDrawColor.Create('FontColor','字体颜色');

  Inherited;

  FFontColor.OnChange:=DoChange;
end;

destructor TDrawTextParamEffect.Destroy;
begin
  FreeAndNil(FFontColor);
  inherited;
end;

function TDrawTextParamEffect.HasEffectTypes: Boolean;
begin
  Result:=(Inherited HasEffectTypes) or (Self.FEffectTypes<>[]);
end;

function TDrawTextParamEffect.IsEffectTypesStored: Boolean;
begin
  Result:=(FEffectTypes<>[]);
end;

function TDrawTextParamEffect.IsFontSizeStored: Boolean;
begin
  Result:=not IsSameDouble(FFontSize, Const_DefaultFontSize)
          and not IsSameDouble(FFontSize, 0);
end;

function TDrawTextParamEffect.IsFontStyleStored: Boolean;
begin
  Result:=(Self.FFontStyle<>[]);
end;

function TDrawTextParamEffect.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='FontColor' then
    begin
      Self.FFontColor.Assign(ABTNode.ConvertNode_Color.Data);
    end
    else if ABTNode.NodeName='FontSize' then
    begin
      if ABTNode is TBTNode20_Int32 then
      begin
        Self.FFontSize:=ABTNode.ConvertNode_Int32.Data;
      end
      else if ABTNode is TBTNode20_Real64 then
      begin
        Self.FFontSize:=ControlSize(ABTNode.ConvertNode_Real64.Data);
      end;
    end
    else if ABTNode.NodeName='FontStyle' then
    begin
      Self.FFontStyle:=GetSetFromStr_TFontStyles(ABTNode.ConvertNode_WideString.Data);
    end
    else if ABTNode.NodeName='EffectTypes' then
    begin
      Self.FEffectTypes:=GetSetFromStr_TDTPEffectTypes(ABTNode.ConvertNode_WideString.Data);
    end
    ;
  end;

  Result:=True;
end;

//function TDrawTextParamEffect.LoadFromJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Inherited;
//
//  Result:=False;
//
//  Self.FFontColor.Color:=WebHexToColor(ASuperObject.S['font_color']);
//  Self.FFontSize:=ASuperObject.F['font_size'];
//  Self.FFontStyle:=GetFontStyle(ASuperObject.S['font_style']);
//
//  Self.FEffectTypes:=GetDTPEffectTypes(ASuperObject.S['effect_types']);
//
//  Result:=True;
//
//end;

function TDrawTextParamEffect.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Color('FontColor','字体颜色');
  ABTNode.ConvertNode_Color.Data.Assign(FFontColor);

  ABTNode:=ADocNode.AddChildNode_Real64('FontSize','字体大小');
  ABTNode.ConvertNode_Real64.Data:=FFontSize;

  ABTNode:=ADocNode.AddChildNode_WideString('FontStyle','字体风格');
  ABTNode.ConvertNode_WideString.Data:=GetStrFromSet_TFontStyles(FFontStyle);

  ABTNode:=ADocNode.AddChildNode_WideString('EffectTypes','效果集');
  ABTNode.ConvertNode_WideString.Data:=GetStrFromSet_TDTPEffectTypes(FEffectTypes);


  Result:=True;
end;

//function TDrawTextParamEffect.SaveToJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Inherited;
//
//  Result:=False;
//
//  ASuperObject.S['font_color']:=ColorToWebHex(Self.FFontColor.Color);
//  ASuperObject.F['font_size']:=Self.FFontSize;
//  ASuperObject.S['font_style']:=GetFontStyleStr(Self.FFontStyle);
//
//  ASuperObject.S['effect_types']:=GetDTPEffectTypesStr(Self.FEffectTypes);
//
//  Result:=True;
//end;

procedure TDrawTextParamEffect.SetEffectTypes(const Value: TDTPEffectTypes);
begin
  if FEffectTypes<>Value then
  begin
    FEffectTypes := Value;
    DoChange;
  end;
end;

procedure TDrawTextParamEffect.SetFontColor(const Value: TDrawColor);
begin
  FFontColor.Assign(Value);
end;

procedure TDrawTextParamEffect.SetFontSize(const Value: TControlSize);
begin
  if FFontSize<>Value then
  begin
    FFontSize := Value;
    DoChange;
  end;
end;

procedure TDrawTextParamEffect.SetFontStyle(const Value: TFontStyles);
begin
  if FFontStyle<>Value then
  begin
    FFontStyle := Value;
    DoChange;
  end;
end;

function GetGlobalDrawTextParam:TDrawTextParam;
begin
  if GlobalDrawTextParam=nil then GlobalDrawTextParam:=TDrawTextParam.Create('GlobalDrawTextParam','全局文本绘制参数');
  Result:=GlobalDrawTextParam;
end;







{ TDrawTextParamSetting }



constructor TDrawTextParamSetting.Create(ADrawParam: TDrawParam);
begin
  inherited;
  FDrawTextParam:=TDrawTextParam(ADrawParam);
end;

function TDrawTextParamSetting.GetMouseDownFontColor: TDelphiColor;
begin
  Result:=FDrawTextParam.DrawEffectSetting.MouseDownEffect.FFontColor.Color;
end;

function TDrawTextParamSetting.GetMouseDownFontColorChange: Boolean;
begin
  Result:=dtpetFontColorChange in FDrawTextParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawTextParamSetting.GetMouseOverFontColor: TDelphiColor;
begin
  Result:=FDrawTextParam.DrawEffectSetting.MouseOverEffect.FFontColor.Color;

end;

function TDrawTextParamSetting.GetMouseOverFontColorChange: Boolean;
begin
  Result:=dtpetFontColorChange in FDrawTextParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;

end;

function TDrawTextParamSetting.GetPushedFontColor: TDelphiColor;
begin
  Result:=FDrawTextParam.DrawEffectSetting.PushedEffect.FFontColor.Color;

end;

function TDrawTextParamSetting.GetPushedFontColorChange: Boolean;
begin
  Result:=dtpetFontColorChange in FDrawTextParam.DrawEffectSetting.PushedEffect.FEffectTypes;

end;



procedure TDrawTextParamSetting.SetMouseDownFontColor(const Value: TDelphiColor);
begin
  FDrawTextParam.DrawEffectSetting.MouseDownEffect.FontColor.Color:=Value;

end;

procedure TDrawTextParamSetting.SetMouseDownFontColorChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawTextParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.MouseDownEffect.EffectTypes+[dtpetFontColorChange];
  end
  else
  begin
    FDrawTextParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.MouseDownEffect.EffectTypes-[dtpetFontColorChange];
  end;
end;

procedure TDrawTextParamSetting.SetMouseOverFontColor(const Value: TDelphiColor);
begin
  FDrawTextParam.DrawEffectSetting.MouseOverEffect.FontColor.Color:=Value;

end;

procedure TDrawTextParamSetting.SetMouseOverFontColorChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawTextParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.MouseOverEffect.EffectTypes+[dtpetFontColorChange];
  end
  else
  begin
    FDrawTextParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.MouseOverEffect.EffectTypes-[dtpetFontColorChange];
  end;
end;

procedure TDrawTextParamSetting.SetPushedFontColor(const Value: TDelphiColor);
begin
  FDrawTextParam.DrawEffectSetting.PushedEffect.FontColor.Color:=Value;

end;

procedure TDrawTextParamSetting.SetPushedFontColorChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawTextParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.PushedEffect.EffectTypes+[dtpetFontColorChange];
  end
  else
  begin
    FDrawTextParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.PushedEffect.EffectTypes-[dtpetFontColorChange];
  end;
end;





function TDrawTextParamSetting.GetMouseDownFontSize: TControlSize;
begin
  Result:=FDrawTextParam.DrawEffectSetting.MouseDownEffect.FontSize;
end;

function TDrawTextParamSetting.GetMouseDownFontSizeChange: Boolean;
begin
  Result:=dtpetFontSizeChange in FDrawTextParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawTextParamSetting.GetMouseOverFontSize: TControlSize;
begin
  Result:=FDrawTextParam.DrawEffectSetting.MouseOverEffect.FontSize;

end;

function TDrawTextParamSetting.GetMouseOverFontSizeChange: Boolean;
begin
  Result:=dtpetFontSizeChange in FDrawTextParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;

end;

function TDrawTextParamSetting.GetPushedFontSize: TControlSize;
begin
  Result:=FDrawTextParam.DrawEffectSetting.PushedEffect.FontSize;

end;

function TDrawTextParamSetting.GetPushedFontSizeChange: Boolean;
begin
  Result:=dtpetFontSizeChange in FDrawTextParam.DrawEffectSetting.PushedEffect.FEffectTypes;

end;



procedure TDrawTextParamSetting.SetMouseDownFontSize(const Value: TControlSize);
begin
  FDrawTextParam.DrawEffectSetting.MouseDownEffect.FontSize:=Value;

end;

procedure TDrawTextParamSetting.SetMouseDownFontSizeChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawTextParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.MouseDownEffect.EffectTypes+[dtpetFontSizeChange];
  end
  else
  begin
    FDrawTextParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.MouseDownEffect.EffectTypes-[dtpetFontSizeChange];
  end;
end;

procedure TDrawTextParamSetting.SetMouseOverFontSize(const Value: TControlSize);
begin
  FDrawTextParam.DrawEffectSetting.MouseOverEffect.FontSize:=Value;

end;

procedure TDrawTextParamSetting.SetMouseOverFontSizeChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawTextParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.MouseOverEffect.EffectTypes+[dtpetFontSizeChange];
  end
  else
  begin
    FDrawTextParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.MouseOverEffect.EffectTypes-[dtpetFontSizeChange];
  end;
end;

procedure TDrawTextParamSetting.SetPushedFontSize(const Value: TControlSize);
begin
  FDrawTextParam.DrawEffectSetting.PushedEffect.FontSize:=Value;

end;

procedure TDrawTextParamSetting.SetPushedFontSizeChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawTextParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.PushedEffect.EffectTypes+[dtpetFontSizeChange];
  end
  else
  begin
    FDrawTextParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.PushedEffect.EffectTypes-[dtpetFontSizeChange];
  end;
end;



function TDrawTextParamSetting.GetMouseDownFontStyle: TFontStyles;
begin
  Result:=FDrawTextParam.DrawEffectSetting.MouseDownEffect.FontStyle;
end;

function TDrawTextParamSetting.GetMouseDownFontStyleChange: Boolean;
begin
  Result:=dtpetFontStyleChange in FDrawTextParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawTextParamSetting.GetMouseOverFontStyle: TFontStyles;
begin
  Result:=FDrawTextParam.DrawEffectSetting.MouseOverEffect.FontStyle;
end;

function TDrawTextParamSetting.GetMouseOverFontStyleChange: Boolean;
begin
  Result:=dtpetFontStyleChange in FDrawTextParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawTextParamSetting.GetPushedFontStyle: TFontStyles;
begin
  Result:=FDrawTextParam.DrawEffectSetting.PushedEffect.FontStyle;
end;

function TDrawTextParamSetting.GetPushedFontStyleChange: Boolean;
begin
  Result:=dtpetFontStyleChange in FDrawTextParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;



function TDrawTextParamSetting.IsMouseDownFontColorChangeStored: Boolean;
begin
  Result:=dtpetFontColorChange in FDrawTextParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawTextParamSetting.IsMouseDownFontColorStored: Boolean;
begin
  Result:=FDrawTextParam.DrawEffectSetting.MouseDownEffect.FFontColor.Color<>Const_DefaultColor;
end;

function TDrawTextParamSetting.IsMouseDownFontSizeChangeStored: Boolean;
begin
  Result:=dtpetFontSizeChange in FDrawTextParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawTextParamSetting.IsMouseDownFontSizeStored: Boolean;
begin
  Result:=NotEqualDouble(FDrawTextParam.DrawEffectSetting.MouseDownEffect.FFontSize,
                        Const_DefaultFontSize);
end;

function TDrawTextParamSetting.IsMouseDownFontStyleChangeStored: Boolean;
begin
  Result:=dtpetFontStyleChange in FDrawTextParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawTextParamSetting.IsMouseDownFontStyleStored: Boolean;
begin
  Result:=FDrawTextParam.DrawEffectSetting.MouseDownEffect.FFontStyle<>[];
end;

function TDrawTextParamSetting.IsMouseOverFontColorChangeStored: Boolean;
begin
  Result:=dtpetFontColorChange in FDrawTextParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawTextParamSetting.IsMouseOverFontColorStored: Boolean;
begin
  Result:=FDrawTextParam.DrawEffectSetting.MouseOverEffect.FFontColor.Color<>Const_DefaultColor;
end;

function TDrawTextParamSetting.IsMouseOverFontSizeChangeStored: Boolean;
begin
  Result:=dtpetFontSizeChange in FDrawTextParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawTextParamSetting.IsMouseOverFontSizeStored: Boolean;
begin
  Result:=NotEqualDouble(FDrawTextParam.DrawEffectSetting.MouseOverEffect.FFontSize,
                        Const_DefaultFontSize);
end;

function TDrawTextParamSetting.IsMouseOverFontStyleChangeStored: Boolean;
begin
  Result:=dtpetFontStyleChange in FDrawTextParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawTextParamSetting.IsMouseOverFontStyleStored: Boolean;
begin
  Result:=FDrawTextParam.DrawEffectSetting.MouseOverEffect.FFontStyle<>[];
end;

function TDrawTextParamSetting.IsPushedFontColorChangeStored: Boolean;
begin
  Result:=dtpetFontColorChange in FDrawTextParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;

function TDrawTextParamSetting.IsPushedFontColorStored: Boolean;
begin
  Result:=FDrawTextParam.DrawEffectSetting.PushedEffect.FFontColor.Color<>Const_DefaultColor;
end;

function TDrawTextParamSetting.IsPushedFontSizeChangeStored: Boolean;
begin
  Result:=dtpetFontSizeChange in FDrawTextParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;

function TDrawTextParamSetting.IsPushedFontSizeStored: Boolean;
begin
  Result:=NotEqualDouble(FDrawTextParam.DrawEffectSetting.PushedEffect.FFontSize,
                          Const_DefaultFontSize);
end;

function TDrawTextParamSetting.IsPushedFontStyleChangeStored: Boolean;
begin
  Result:=dtpetFontStyleChange in FDrawTextParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;

function TDrawTextParamSetting.IsPushedFontStyleStored: Boolean;
begin
  Result:=FDrawTextParam.DrawEffectSetting.PushedEffect.FFontStyle<>[];
end;

procedure TDrawTextParamSetting.SetMouseDownFontStyle(const Value: TFontStyles);
begin
  FDrawTextParam.DrawEffectSetting.MouseDownEffect.FontStyle:=Value;

end;

procedure TDrawTextParamSetting.SetMouseDownFontStyleChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawTextParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.MouseDownEffect.EffectTypes+[dtpetFontStyleChange];
  end
  else
  begin
    FDrawTextParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.MouseDownEffect.EffectTypes-[dtpetFontStyleChange];
  end;
end;

procedure TDrawTextParamSetting.SetMouseOverFontStyle(const Value: TFontStyles);
begin
  FDrawTextParam.DrawEffectSetting.MouseOverEffect.FontStyle:=Value;

end;

procedure TDrawTextParamSetting.SetMouseOverFontStyleChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawTextParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.MouseOverEffect.EffectTypes+[dtpetFontStyleChange];
  end
  else
  begin
    FDrawTextParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.MouseOverEffect.EffectTypes-[dtpetFontStyleChange];
  end;
end;

procedure TDrawTextParamSetting.SetPushedFontStyle(const Value: TFontStyles);
begin
  FDrawTextParam.DrawEffectSetting.PushedEffect.FontStyle:=Value;

end;

procedure TDrawTextParamSetting.SetPushedFontStyleChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawTextParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.PushedEffect.EffectTypes+[dtpetFontStyleChange];
  end
  else
  begin
    FDrawTextParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawTextParam.DrawEffectSetting.PushedEffect.EffectTypes-[dtpetFontStyleChange];
  end;
end;




initialization
  GlobalIsUseDefaultFontFamily:=False;
  GlobalDefaultFontFamily:='';


finalization
  FreeAndNil(GlobalDrawTextParam);

end.


