//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     图片绘制参数
///   </para>
///   <para>
///     Parameters of drawing picture
///   </para>
/// </summary>
unit uDrawPictureParam;



interface
{$I FrameWork.inc}



uses
  Classes,
  SysUtils,


//  XSuperObject,


  uGraphicCommon,
  uBinaryTreeDoc,
  uFuncCommon,
  uDrawParam;


const
  Const_DefaultEffect_RotateAngle=90;


type

  TBaseDrawPictureParam=class;


  /// <summary>
  ///   <para>
  ///     水平对齐风格
  ///   </para>
  ///   <para>
  ///     Style of Horizontal Align
  ///   </para>
  /// </summary>
  TPictureHorzAlign=(
                      /// <summary>
                      ///   居左
                      ///   <para>
                      ///     Horizontally left
                      ///   </para>
                      /// </summary>
                      phaLeft,
                      /// <summary>
                      ///   居中
                      ///   <para>
                      ///     Horizontally center
                      ///   </para>
                      /// </summary>
                      phaCenter,
                      /// <summary>
                      ///   居右
                      ///   <para>
                      ///     Horizontally right
                      ///   </para>
                      /// </summary>
                      phaRight
                      );




  /// <summary>
  ///   <para>
  ///     垂直对齐风格
  ///   </para>
  ///   <para>
  ///     Style of Vertical Align
  ///   </para>
  /// </summary>
  TPictureVertAlign=(
                      /// <summary>
                      ///   居上
                      ///   <para>
                      ///     Vertically top
                      ///   </para>
                      /// </summary>
                      pvaTop,
                      /// <summary>
                      ///   居中
                      ///   <para>
                      ///     Vertically center
                      ///   </para>
                      /// </summary>
                      pvaCenter,
                      /// <summary>
                      ///   居下
                      ///   <para>
                      ///     Vertically bottom
                      ///   </para>
                      /// </summary>
                      pvaBottom
                      );





  /// <summary>
  ///   <para>
  ///     图片拉伸类型
  ///   </para>
  ///   <para>
  ///     Style of stretching picture
  ///   </para>
  /// </summary>
  TPictureStretchStyle=(
                      /// <summary>
                      ///   拉伸
                      ///   <para>
                      ///   Tensile
                      ///   </para>
                      /// </summary>
                      issTensile,
                      /// <summary>
                      ///   九宫格
                      ///   <para>
                      ///     Square
                      ///   </para>
                      /// </summary>
                      issSquare,
                      /// <summary>
                      ///   九宫格扩展
                      ///   <para>
                      ///   Square expand
                      ///   </para>
                      /// </summary>
                      issSquarePro,
                      /// <summary>
                      ///   水平三分法
                      ///   <para>
                      ///   Horizontal Trichotomy:Divide the picture horizontally into three parts, stretch the middle part
                      ///   </para>
                      /// </summary>
                      issThreePartHorz,
                      /// <summary>
                      ///   垂直三分法
                      ///   <para>
                      ///   Vertical Trichotomy:Divide the picture vertically into three parts, stretch the middle part
                      ///   </para>
                      /// </summary>
                      issThreePartVert,
                      /// <summary>
                      ///   水平三分法扩展
                      ///   <para>
                      ///   Horizontal trichotomy expand
                      ///   </para>
                      /// </summary>
                      issThreePartHorzPro,
                      /// <summary>
                      ///   垂直三分法扩展
                      ///   <para>
                      ///   Vertical trichotomy expand
                      ///   </para>
                      /// </summary>
                      issThreePartVertPro,

                      //自适应填满
                      issAutoFitFillMax
                      );




//  //图片拉伸模式
//  TSkinStretchMode=(
//                    ssmNone,
//                    ssmStretch,
//                    ssmSquare,
//                    ssmHorz3Part,
//                    ssmVert3Part
//                    );




  /// <summary>
  ///   <para>
  ///     当拉伸矩形比较小的时候的处理方式
  ///   </para>
  ///   <para>
  ///     deal method when stretch rectangle is small
  ///   </para>
  /// </summary>
  TPictureTooSmallProcessType=(
                             /// <summary>
                             ///   无
                             ///   <para>
                             ///   None
                             ///   </para>
                             /// </summary>
                             itsptNone,
                             /// <summary>
                             ///   拉伸
                             ///   <para>
                             ///   Tensile
                             ///   </para>
                             /// </summary>
                             itsptTensile,
                             /// <summary>
                             ///   分块
                             ///   <para>
                             ///   Part
                             ///   </para>
                             /// </summary>
                             itsptPart
                            );





  /// <summary>
  ///   当拉伸矩形比较大的时候的处理方式
  ///   <para>
  ///     deal method when stretch rectangle is big
  ///   </para>
  /// </summary>
  TPictureTooLargeProcessType=(
                             /// <summary>
                             ///   无
                             ///   <para>
                             ///   None
                             ///   </para>
                             /// </summary>
                             itlptNone,
                             /// <summary>
                             ///   正常绘制
                             ///   <para>
                             ///   Normally draw
                             ///   </para>
                             /// </summary>
                             itlptNormal,
                             /// <summary>
                             ///   局部绘制
                             ///   <para>
                             ///   Partly draw
                             ///   </para>
                             /// </summary>
                             itlptPart
                            );






  /// <summary>
  ///   <para>
  ///     图片绘制效果类型
  ///   </para>
  ///   <para>
  ///     Effect Type of drawing pictures
  ///   </para>
  /// </summary>
  TDPPEffectType=( //
                   /// <summary>
                   ///   图片下标更改
                   ///   <para>
                   ///   Change Image Index
                   ///   </para>
                   /// </summary>
                   dppetImageIndexChange,
                   /// <summary>
                   ///   图片下标加1
                   ///   <para>
                   ///   Plus 1 to Image Index
                   ///   </para>
                   /// </summary>
                   dppetImageIndexInc1,
                   /// <summary>
                   ///   图片名称更改
                   ///   <para>
                   ///   Change Image Name
                   ///   </para>
                   /// </summary>
                   dppetImageNameChange,
                   /// <summary>
                   ///   旋转角度更改
                   ///   <para>
                   ///   Change Rotate Angle
                   ///   </para>
                   /// </summary>
                   dppetRotateAngleChange
                   );
  /// <summary>
  ///   <para>
  ///     图片绘制效果类型集合
  ///   </para>
  ///   <para>
  ///     Set of drawing picture effect types
  ///   </para>
  /// </summary>
  TDPPEffectTypes=set of TDPPEffectType;







  /// <summary>
  ///   <para>
  ///     绘制图片的效果
  ///   </para>
  ///   <para>
  ///     Effect of drawing pictures
  ///   </para>
  /// </summary>
  TDrawPictureParamEffect=class(TDrawParamCommonEffect)
  private
    FImageIndex: Integer;
    FImageName: String;
    FRotateAngle: Integer;
    FEffectTypes: TDPPEffectTypes;
  private
    function IsEffectTypesStored: Boolean;
    function IsImageIndexStored: Boolean;
    function IsImageNameStored: Boolean;
    function IsRotateAngleStored: Boolean;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
//    function LoadFromJson(ASuperObject:ISuperObject):Boolean;override;
//    function SaveToJson(ASuperObject:ISuperObject):Boolean;override;
  public
    constructor Create;override;
  public
    /// <summary>
    ///   <para>
    ///     初始化参数
    ///   </para>
    ///   <para>
    ///     Initialize Parameters
    ///   </para>
    /// </summary>
    procedure Clear;override;
    /// <summary>
    ///   <para>
    ///     是否包含效果
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
  published
    /// <summary>
    ///   <para>
    ///     旋转角度
    ///   </para>
    ///   <para>
    ///     Rotate Angle
    ///   </para>
    /// </summary>
    property RotateAngle:Integer read FRotateAngle write FRotateAngle stored IsRotateAngleStored;
    /// <summary>
    ///   <para>
    ///     图片下标
    ///   </para>
    ///   <para>
    ///     Image Index
    ///   </para>
    /// </summary>
    property ImageIndex:Integer read FImageIndex write FImageIndex stored IsImageIndexStored;
    /// <summary>
    ///   <para>
    ///     图片名称
    ///   </para>
    ///   <para>
    ///     Image Name
    ///   </para>
    /// </summary>
    property ImageName:String read FImageName write FImageName stored IsImageNameStored;
    /// <summary>
    ///   <para>
    ///     效果类型集合,一个状态可以有多个效果
    ///   </para>
    ///   <para>
    ///     Set of effect types,one state can have several effects
    ///   </para>
    /// </summary>
    property EffectTypes:TDPPEffectTypes read FEffectTypes write FEffectTypes stored IsEffectTypesStored;
  end;






  TDrawPictureEffectSetting=class(TDrawEffectSetting)
  private
    function GetMouseDownEffect: TDrawPictureParamEffect;
    function GetMouseOverEffect: TDrawPictureParamEffect;
    function GetPushedEffect: TDrawPictureParamEffect;
    procedure SetMouseDownEffect(const Value: TDrawPictureParamEffect);
    procedure SetMouseOverEffect(const Value: TDrawPictureParamEffect);
    procedure SetPushedEffect(const Value: TDrawPictureParamEffect);
    procedure SetDisabledEffect(const Value: TDrawPictureParamEffect);
    procedure SetFocusedEffect(const Value: TDrawPictureParamEffect);
    function GetDisabledEffect: TDrawPictureParamEffect;
    function GetFocusedEffect: TDrawPictureParamEffect;
  protected
    function GetDrawParamEffectClass:TDrawParamCommonEffectClass;override;
  published
    //禁用状态的效果
    property DisabledEffect: TDrawPictureParamEffect read GetDisabledEffect write SetDisabledEffect;
    //获得焦点的效果
    property FocusedEffect: TDrawPictureParamEffect read GetFocusedEffect write SetFocusedEffect;
    property MouseDownEffect:TDrawPictureParamEffect read GetMouseDownEffect write SetMouseDownEffect;
    property MouseOverEffect:TDrawPictureParamEffect read GetMouseOverEffect write SetMouseOverEffect;
    property PushedEffect:TDrawPictureParamEffect read GetPushedEffect write SetPushedEffect;
  end;




  TDrawPictureParamSetting=class(TDrawParamSetting)
  private
    function IsMouseDownImageIndexChangeStored: Boolean;
    function IsMouseDownImageIndexStored: Boolean;
    function IsMouseDownImageNameChangeStored: Boolean;
//    function IsMouseDownImageNameStored: Boolean;
    function IsMouseOverImageIndexChangeStored: Boolean;
    function IsMouseOverImageIndexStored: Boolean;
    function IsMouseOverImageNameChangeStored: Boolean;
//    function IsMouseOverImageNameStored: Boolean;
    function IsPushedImageIndexChangeStored: Boolean;
    function IsPushedImageIndexStored: Boolean;
    function IsPushedImageNameChangeStored: Boolean;
//    function IsPushedImageNameStored: Boolean;
    function IsMouseDownRotateAngleChangeStored: Boolean;
    function IsMouseDownRotateAngleStored: Boolean;
    function IsMouseOverRotateAngleChangeStored: Boolean;
    function IsMouseOverRotateAngleStored: Boolean;
    function IsPushedRotateAngleChangeStored: Boolean;
    function IsPushedRotateAngleStored: Boolean;
  protected
    FDrawPictureParam:TBaseDrawPictureParam;

    function GetMouseDownImageIndex: Integer;
    function GetMouseDownImageIndexChange: Boolean;
    function GetMouseOverImageIndex: Integer;
    function GetMouseOverImageIndexChange: Boolean;
    function GetPushedImageIndex: Integer;
    function GetPushedImageIndexChange: Boolean;

    function GetMouseDownImageName: String;
    function GetMouseDownImageNameChange: Boolean;
    function GetMouseOverImageName: String;
    function GetMouseOverImageNameChange: Boolean;
    function GetPushedImageName: String;
    function GetPushedImageNameChange: Boolean;

    function GetMouseDownRotateAngle: Integer;
    function GetMouseDownRotateAngleChange: Boolean;
    function GetMouseOverRotateAngle: Integer;
    function GetMouseOverRotateAngleChange: Boolean;
    function GetPushedRotateAngle: Integer;
    function GetPushedRotateAngleChange: Boolean;

    procedure SetMouseDownRotateAngle(const Value: Integer);
    procedure SetMouseDownRotateAngleChange(const Value: Boolean);
    procedure SetMouseOverRotateAngle(const Value: Integer);
    procedure SetMouseOverRotateAngleChange(const Value: Boolean);
    procedure SetPushedRotateAngle(const Value: Integer);
    procedure SetPushedRotateAngleChange(const Value: Boolean);


    procedure SetMouseDownImageName(const Value: String);
    procedure SetMouseDownImageNameChange(const Value: Boolean);
    procedure SetMouseOverImageName(const Value: String);
    procedure SetMouseOverImageNameChange(const Value: Boolean);
    procedure SetPushedImageName(const Value: String);
    procedure SetPushedImageNameChange(const Value: Boolean);

    procedure SetMouseDownImageIndex(const Value: Integer);
    procedure SetMouseDownImageIndexChange(const Value: Boolean);
    procedure SetMouseOverImageIndex(const Value: Integer);
    procedure SetMouseOverImageIndexChange(const Value: Boolean);
    procedure SetPushedImageIndex(const Value: Integer);
    procedure SetPushedImageIndexChange(const Value: Boolean);
  public
    constructor Create(ADrawParam:TDrawParam);override;
  public
    property MouseDownImageName:String read GetMouseDownImageName write SetMouseDownImageName;// stored IsMouseDownImageNameStored;
    property MouseDownImageNameChange:Boolean read GetMouseDownImageNameChange write SetMouseDownImageNameChange stored IsMouseDownImageNameChangeStored;
    property MouseOverImageName:String read GetMouseOverImageName write SetMouseOverImageName;// stored IsMouseOverImageNameStored;
    property MouseOverImageNameChange:Boolean read GetMouseOverImageNameChange write SetMouseOverImageNameChange stored IsMouseOverImageNameChangeStored;
    property PushedImageName:String read GetPushedImageName write SetPushedImageName;// stored IsPushedImageNameStored;
    property PushedImageNameChange:Boolean read GetPushedImageNameChange write SetPushedImageNameChange stored IsPushedImageNameChangeStored;
  published
    property MouseDownImageIndex:Integer read GetMouseDownImageIndex write SetMouseDownImageIndex stored IsMouseDownImageIndexStored;
    property MouseDownImageIndexChange:Boolean read GetMouseDownImageIndexChange write SetMouseDownImageIndexChange stored IsMouseDownImageIndexChangeStored;

    property MouseOverImageIndex:Integer read GetMouseOverImageIndex write SetMouseOverImageIndex stored IsMouseOverImageIndexStored;
    property MouseOverImageIndexChange:Boolean read GetMouseOverImageIndexChange write SetMouseOverImageIndexChange stored IsMouseOverImageIndexChangeStored;

    property PushedImageIndex:Integer read GetPushedImageIndex write SetPushedImageIndex stored IsPushedImageIndexStored;
    property PushedImageIndexChange:Boolean read GetPushedImageIndexChange write SetPushedImageIndexChange stored IsPushedImageIndexChangeStored;

    property MouseDownRotateAngle:Integer read GetMouseDownRotateAngle write SetMouseDownRotateAngle stored IsMouseDownRotateAngleStored;
    property MouseDownRotateAngleChange:Boolean read GetMouseDownRotateAngleChange write SetMouseDownRotateAngleChange stored IsMouseDownRotateAngleChangeStored;
    property MouseOverRotateAngle:Integer read GetMouseOverRotateAngle write SetMouseOverRotateAngle stored IsMouseOverRotateAngleStored;
    property MouseOverRotateAngleChange:Boolean read GetMouseOverRotateAngleChange write SetMouseOverRotateAngleChange stored IsMouseOverRotateAngleChangeStored;
    property PushedRotateAngle:Integer read GetPushedRotateAngle write SetPushedRotateAngle stored IsPushedRotateAngleStored;
    property PushedRotateAngleChange:Boolean read GetPushedRotateAngleChange write SetPushedRotateAngleChange stored IsPushedRotateAngleChangeStored;
  end;






  /// <summary>
  ///   <para>
  ///     图片绘制参数
  ///   </para>
  ///   <para>
  ///     Parameters of drawing picture
  ///   </para>
  /// </summary>
  TBaseDrawPictureParam=class(TDrawParam)
  private

    //缩放比例
    FScale: Double;


    //是否拉伸
    FIsStretch: Boolean;

    //是否自动计算尺寸
    FIsAutoFit: Boolean;


    //旋转角度
    FRotateAngle: Double;



    //拉伸类型
    FStretchStyle: TPictureStretchStyle;
    //拉伸边距
    FStretchMargins: TBorderMargins;
    //
    FDestDrawStretchMargins: TBorderMargins;
//    //是否绘制中心块
//    FIsDrawSquareCenterBlock: Boolean;

    //垂直对齐
    FPictureVertAlign: TPictureVertAlign;
    //水平对齐
    FPictureHorzAlign: TPictureHorzAlign;


    //处理类型
    FPictureTooSmallProcessType:TPictureTooSmallProcessType;
    FPictureTooLargeProcessType:TPictureTooLargeProcessType;

    procedure SetScale(const Value: Double);
    procedure SetRotateAngle(const Value: Double);


    procedure SetIsAutoFit(const Value: Boolean);


    procedure SetIsStretch(const Value: Boolean);
    procedure SetStretchStyle(const Value: TPictureStretchStyle);

    procedure SetStretchMargins(const Value: TBorderMargins);
    procedure SetDestDrawStretchMargins(const Value: TBorderMargins);

    procedure SetPictureHorzAlign(const Value: TPictureHorzAlign);
    procedure SetPictureVertAlign(const Value: TPictureVertAlign);



//    procedure SetIsDrawSquareCenterBlock(const Value: Boolean);
    procedure SetPictureTooSmallProcessType(const Value: TPictureTooSmallProcessType);
    procedure SetPictureTooLargeProcessType(const Value: TPictureTooLargeProcessType);
  private
    function IsIsAutoFitStored: Boolean;
    function IsPictureHorzAlignStored: Boolean;
    function IsPictureVertAlignStored: Boolean;
    function IsStretchStyleStored: Boolean;
    function IsIsStretchStored: Boolean;
    function GetDrawEffectSetting: TDrawPictureEffectSetting;
//    function GetSetting: TDrawPictureParamSetting;
    procedure SetDrawEffectSetting(const Value: TDrawPictureEffectSetting);
//    procedure SetSetting(const Value: TDrawPictureParamSetting);
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

    /// <summary>
    ///   <para>
    ///     获取图片绘制效果的类
    ///   </para>
    ///   <para>
    ///     Get class of drawing picture effect
    ///   </para>
    /// </summary>
    function GetDrawEffectSettingClass:TDrawEffectSettingClass;override;
    function GetDrawParamSettingClass:TDrawParamSettingClass;override;

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
//    function CustomLoadFromJson(ASuperObject:ISuperObject):Boolean;override;
//    function CustomSaveToJson(ASuperObject:ISuperObject):Boolean;override;
  public
    constructor Create(const AName:String;const ACaption:String);override;
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
    procedure Clear;override;


    /// <summary>
    ///   <para>
    ///     当前效果下的图片下标
    ///   </para>
    ///   <para>
    ///     Image index of curent effect
    ///   </para>
    /// </summary>
    function CurrentEffectImageIndex(AImageIndex:Integer):Integer;


    /// <summary>
    ///   <para>
    ///     当前效果下的图片名称
    ///   </para>
    ///   <para>
    ///     Image name of curent effect
    ///   </para>
    /// </summary>
    function CurrentEffectImageName:String;


    /// <summary>
    ///   <para>
    ///     当前效果下的图片旋转角度
    ///   </para>
    ///   <para>
    ///     Rotate angle of current effect
    ///   </para>
    /// </summary>
    function CurrentEffectRotateAngle:Double;




  public
    /// <summary>
    ///   <para>
    ///     缩放比例
    ///   </para>
    ///   <para>
    ///     Scale
    ///   </para>
    /// </summary>
    property Scale:Double read FScale write SetScale;
    /// <summary>
    ///   <para>
    ///     静态地设置缩放比例
    ///   </para>
    ///   <para>
    ///     Set scale staticly
    ///   </para>
    /// </summary>
    property StaticScale:Double read FScale write FScale;



    /// <summary>
    ///   <para>
    ///     旋转角度
    ///   </para>
    ///   <para>
    ///     Rotate angle
    ///   </para>
    /// </summary>
    property RotateAngle:Double read FRotateAngle write SetRotateAngle;
    /// <summary>
    ///   <para>
    ///     静态地设置旋转角度
    ///   </para>
    ///   <para>
    ///     Set rotate angle staticly
    ///   </para>
    /// </summary>
    property StaticRotateAngle:Double read FRotateAngle write FRotateAngle;



//    //
//    /// <summary>
//    ///   <para>
//    ///     是否绘制九宫格中心块
//    ///   </para>
//    ///   <para>
//    ///     Whether draw center block of square
//    ///   </para>
//    /// </summary>
//    property IsDrawSquareCenterBlock:Boolean read FIsDrawSquareCenterBlock write SetIsDrawSquareCenterBlock;


    property StaticPictureHorzAlign: TPictureHorzAlign read FPictureHorzAlign write FPictureHorzAlign;

    /// <summary>
    ///   <para>
    ///     绘制矩形过小时的处理绘制方式
    ///   </para>
    ///   <para>
    ///     Process method when the drawing rectangle is too small
    ///   </para>
    /// </summary>
    property PictureTooSmallProcessType:TPictureTooSmallProcessType read FPictureTooSmallProcessType write SetPictureTooSmallProcessType;
    /// <summary>
    ///   <para>
    ///     绘制矩形过大时的处理绘制方式
    ///   </para>
    ///   <para>
    ///     Process method when the drawing rectangle is too big
    ///   </para>
    /// </summary>
    property PictureTooLargeProcessType:TPictureTooLargeProcessType read FPictureTooLargeProcessType write SetPictureTooLargeProcessType;


  public
    /// <summary>
    ///   <para>
    ///     透明度
    ///   </para>
    ///   <para>
    ///     Alpha
    ///   </para>
    /// </summary>
    property Alpha stored IsAlphaStored;

    /// <summary>
    ///   <para>
    ///     是否自适应
    ///   </para>
    ///   <para>
    ///     Whether autofit
    ///   </para>
    /// </summary>
    property IsAutoFit:Boolean read FIsAutoFit write SetIsAutoFit stored IsIsAutoFitStored;



    /// <summary>
    ///   <para>
    ///     是否拉伸
    ///   </para>
    ///   <para>
    ///     Whether stretch
    ///   </para>
    /// </summary>
    property IsStretch: Boolean read FIsStretch write SetIsStretch stored IsIsStretchStored;
    /// <summary>
    ///   <para>
    ///     拉伸风格
    ///   </para>
    ///   <para>
    ///     Stretch Style
    ///   </para>
    /// </summary>
    property StretchStyle: TPictureStretchStyle read FStretchStyle write SetStretchStyle stored IsStretchStyleStored;
    /// <summary>
    ///   <para>
    ///     图片拉伸边距
    ///   </para>
    ///   <para>
    ///     Stretch Margins
    ///   </para>
    /// </summary>
    property StretchMargins:TBorderMargins read FStretchMargins write SetStretchMargins;
    /// <summary>
    ///   <para>
    ///     目标绘制拉伸边距
    ///   </para>
    ///   <para>
    ///     Stretch margins of drawing destination
    ///   </para>
    /// </summary>
    property DestDrawStretchMargins:TBorderMargins read FDestDrawStretchMargins write SetDestDrawStretchMargins;



    /// <summary>
    ///   <para>
    ///     水平对齐类型
    ///   </para>
    ///   <para>
    ///     Style of horizontal align
    ///   </para>
    /// </summary>
    property PictureHorzAlign: TPictureHorzAlign read FPictureHorzAlign write SetPictureHorzAlign stored IsPictureHorzAlignStored;
    /// <summary>
    ///   <para>
    ///     垂直对齐类型
    ///   </para>
    ///   <para>
    ///     Style of vertical align
    ///   </para>
    /// </summary>
    property PictureVertAlign: TPictureVertAlign read FPictureVertAlign write SetPictureVertAlign stored IsPictureVertAlignStored;




//    /// <summary>
//    ///   绘制矩形的设置
//    /// </summary>
//    property DrawRectSetting;


    property DrawEffectSetting:TDrawPictureEffectSetting read GetDrawEffectSetting write SetDrawEffectSetting;

    //高级设置,DrawEffectSetting+DrawRectSetting
//    property Setting:TDrawPictureParamSetting read GetSetting write SetSetting;


  end;




//  TBaseNewDrawPictureParam=class(TBaseDrawPictureParam)
//  protected
//    function GetHorzAlign: TSkinAlign;
//    function GetVertAlign: TSkinAlign;
//    function IsHorzAlignStored: Boolean;
//    function IsVertAlignStored: Boolean;
//    procedure SetHorzAlign(const Value: TSkinAlign);
//    procedure SetVertAlign(const Value: TSkinAlign);
//    function GetStretchMode: TSkinStretchMode;
//    procedure SetStretchMode(const Value: TSkinStretchMode);
//    function IsStretchModeStored: Boolean;
//  public
//    property HorzAlign: TSkinAlign read GetHorzAlign write SetHorzAlign stored IsHorzAlignStored;
//    property VertAlign: TSkinAlign read GetVertAlign write SetVertAlign stored IsVertAlignStored;
//  end;



  TDrawPictureParam=class(TBaseDrawPictureParam)
  published
    property Alpha;
    property IsAutoFit;
    property IsStretch;
    property StretchStyle;
    property StretchMargins;
    property DestDrawStretchMargins;
    property PictureHorzAlign;
    property PictureVertAlign;

    property DrawRectSetting;
    property DrawEffectSetting;
  end;




var
  GlobalDrawPictureParam:TDrawPictureParam;
  GlobalDrawColorRoundRectBitmapParam:TDrawPictureParam;


//function GetPictureVertAlign(APictureVertAlignStr:String): TPictureVertAlign;
//function GetPictureVertAlignStr(APictureVertAlign:TPictureVertAlign): String;
//
//function GetPictureHorzAlign(APictureHorzAlignStr:String): TPictureHorzAlign;
//function GetPictureHorzAlignStr(APictureHorzAlign:TPictureHorzAlign): String;


function GetPictureStretchStyle(AStretchStyleStr:String): TPictureStretchStyle;
function GetPictureStretchStyleStr(AStretchStyle:TPictureStretchStyle): String;

function GetDPPEffectTypesStr(ADPPEffectTypes:TDPPEffectTypes):String;
function GetDPPEffectTypes(ADPPEffectTypesStr:String):TDPPEffectTypes;



function GetPictureVertAlign(APictureVertAlignStr:String): TPictureVertAlign;
function GetPictureVertAlignStr(APictureVertAlign:TPictureVertAlign): String;

function GetPictureHorzAlign(APictureHorzAlignStr:String): TPictureHorzAlign;
function GetPictureHorzAlignStr(APictureHorzAlign:TPictureHorzAlign): String;


implementation


function GetPictureHorzAlign(APictureHorzAlignStr:String): TPictureHorzAlign;
begin
  Result:=TPictureHorzAlign.phaLeft;

//  if SameText(APictureHorzAlignStr,'Leading') then
  if SameText(APictureHorzAlignStr,'Left') then
  begin
    Result:=TPictureHorzAlign.phaLeft;
  end
  else if SameText(APictureHorzAlignStr,'Center') then
  begin
    Result:=TPictureHorzAlign.phaCenter;
  end
//  else if SameText(APictureHorzAlignStr,'Trailing') then
  else if SameText(APictureHorzAlignStr,'Right') then
  begin
    Result:=TPictureHorzAlign.phaRight;
  end;
end;

function GetPictureHorzAlignStr(APictureHorzAlign:TPictureHorzAlign): String;
begin
  case APictureHorzAlign of
    phaLeft: Result:='Left';
    phaCenter: Result:='Center';
    phaRight: Result:='Right';
//    phaLeft: Result:='Leading';
//    phaCenter: Result:='Center';
//    phaRight: Result:='Trailing';
  end;
end;

function GetPictureVertAlign(APictureVertAlignStr:String): TPictureVertAlign;
begin
  Result:=TPictureVertAlign.pvaTop;

//  if SameText(APictureVertAlignStr,'Leading') then
  if SameText(APictureVertAlignStr,'Top') then
  begin
    Result:=TPictureVertAlign.pvaTop;
  end
  else if SameText(APictureVertAlignStr,'Center') then
  begin
    Result:=TPictureVertAlign.pvaCenter;
  end
//  else if SameText(APictureVertAlignStr,'Trailing') then
  else if SameText(APictureVertAlignStr,'Bottom') then
  begin
    Result:=TPictureVertAlign.pvaBottom;
  end;
end;

function GetPictureVertAlignStr(APictureVertAlign:TPictureVertAlign): String;
begin
  case APictureVertAlign of
    pvaTop: Result:='Top';
    pvaCenter: Result:='Center';
    pvaBottom: Result:='Bottom';
//    pvaTop: Result:='Leading';
//    pvaCenter: Result:='Center';
//    pvaBottom: Result:='Trailing';
  end;
end;





function GetDPPEffectTypesStr(ADPPEffectTypes:TDPPEffectTypes):String;
begin
  Result:='';
  if dppetImageIndexChange in ADPPEffectTypes then
  begin
    Result:=Result+'ImageIndexChange';
  end;
  if dppetImageIndexInc1 in ADPPEffectTypes then
  begin
    Result:=Result+'ImageIndexInc1';
  end;
  if dppetImageNameChange in ADPPEffectTypes then
  begin
    Result:=Result+'ImageNameChange';
  end;
  if dppetRotateAngleChange in ADPPEffectTypes then
  begin
    Result:=Result+'RotateAngleChange';
  end;
end;

function GetDPPEffectTypes(ADPPEffectTypesStr:String):TDPPEffectTypes;
var
  AStringList:TStringList;
begin
  Result:=[];
  AStringList:=TStringList.Create;
  try
    AStringList.CommaText:=ADPPEffectTypesStr;
    if AStringList.IndexOf('ImageIndexChange')<>-1 then
    begin
      Result:=Result+[TDPPEffectType.dppetImageIndexChange];
    end;
    if AStringList.IndexOf('ImageIndexInc1')<>-1 then
    begin
      Result:=Result+[TDPPEffectType.dppetImageIndexInc1];
    end;
    if AStringList.IndexOf('ImageNameChange')<>-1 then
    begin
      Result:=Result+[TDPPEffectType.dppetImageNameChange];
    end;
    if AStringList.IndexOf('RotateAngleChange')<>-1 then
    begin
      Result:=Result+[TDPPEffectType.dppetRotateAngleChange];
    end;
  finally
    FreeAndNil(AStringList);
  end;
end;


function GetPictureStretchStyle(AStretchStyleStr:String): TPictureStretchStyle;
begin
  Result:=TPictureStretchStyle.issTensile;

  if SameText(AStretchStyleStr,'Tensile') then
  begin
    Result:=TPictureStretchStyle.issTensile;
  end
  else if SameText(AStretchStyleStr,'Square') then
  begin
    Result:=TPictureStretchStyle.issSquare;
  end
  else if SameText(AStretchStyleStr,'SquarePro') then
  begin
    Result:=TPictureStretchStyle.issSquarePro;
  end
  else if SameText(AStretchStyleStr,'ThreePartHorz') then
  begin
    Result:=TPictureStretchStyle.issThreePartHorz;
  end
  else if SameText(AStretchStyleStr,'ThreePartVert') then
  begin
    Result:=TPictureStretchStyle.issThreePartVert;
  end
  else if SameText(AStretchStyleStr,'ThreePartHorzPro') then
  begin
    Result:=TPictureStretchStyle.issThreePartHorzPro;
  end
  else if SameText(AStretchStyleStr,'ThreePartVertPro') then
  begin
    Result:=TPictureStretchStyle.issThreePartVertPro;
  end
  else if SameText(AStretchStyleStr,'AutoFitFillMax') then
  begin
    Result:=TPictureStretchStyle.issAutoFitFillMax;
  end
  ;
end;

function GetPictureStretchStyleStr(AStretchStyle:TPictureStretchStyle): String;
begin
  case AStretchStyle of
    issTensile: Result:='Tensile';
    issSquare: Result:='Square';
    issSquarePro: Result:='SquarePro';
    issThreePartHorz: Result:='ThreePartHorz';
    issThreePartVert: Result:='ThreePartVert';
    issThreePartHorzPro: Result:='ThreePartHorzPro';
    issThreePartVertPro: Result:='ThreePartVertPro';
    issAutoFitFillMax: Result:='AutoFitFillMax';
  end;
end;

//function GetPictureHorzAlign(APictureHorzAlignStr:String): TPictureHorzAlign;
//begin
//  Result:=TPictureHorzAlign.phaLeft;
//
//  if SameText(APictureHorzAlignStr,'Leading') then
//  begin
//    Result:=TPictureHorzAlign.phaLeft;
//  end
//  else if SameText(APictureHorzAlignStr,'Center') then
//  begin
//    Result:=TPictureHorzAlign.phaCenter;
//  end
//  else if SameText(APictureHorzAlignStr,'Trailing') then
//  begin
//    Result:=TPictureHorzAlign.phaRight;
//  end;
//end;
//
//function GetPictureHorzAlignStr(APictureHorzAlign:TPictureHorzAlign): String;
//begin
//  case APictureHorzAlign of
//    phaLeft: Result:='Leading';
//    phaCenter: Result:='Center';
//    phaRight: Result:='Trailing';
//  end;
//end;
//
//function GetPictureVertAlign(APictureVertAlignStr:String): TPictureVertAlign;
//begin
//  Result:=TPictureVertAlign.pvaTop;
//
//  if SameText(APictureVertAlignStr,'Leading') then
//  begin
//    Result:=TPictureVertAlign.pvaTop;
//  end
//  else if SameText(APictureVertAlignStr,'Center') then
//  begin
//    Result:=TPictureVertAlign.pvaCenter;
//  end
//  else if SameText(APictureVertAlignStr,'Trailing') then
//  begin
//    Result:=TPictureVertAlign.pvaBottom;
//  end;
//end;
//
//function GetPictureVertAlignStr(APictureVertAlign:TPictureVertAlign): String;
//begin
//  case APictureVertAlign of
//    pvaTop: Result:='Leading';
//    pvaCenter: Result:='Center';
//    pvaBottom: Result:='Trailing';
//  end;
//end;



//将TDPPEffectTypes转换为字符串
function GetStrFromSet_TDPPEffectTypes(ASet:TDPPEffectTypes):String;
var
  I:TDPPEffectType;
begin
  Result:='';
  for I := Low(TDPPEffectType) to High(TDPPEffectType) do
  begin
    if I in ASet then
    begin
      Result:=Result+IntToStr(Ord(I))+',';
    end;
  end;
end;

//将T字符串转换为DPPEffectTypes
function GetSetFromStr_TDPPEffectTypes(ASetStr:String):TDPPEffectTypes;
var
  I,AElem:Integer;
  J:TDPPEffectType;
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
        for J := Low(TDPPEffectType) to High(TDPPEffectType) do
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







{ TBaseDrawPictureParam }

constructor TBaseDrawPictureParam.Create(const AName:String;const ACaption:String);
begin
  //拉伸边距
  FStretchMargins:=TBorderMargins.Create;
  FDestDrawStretchMargins:=TBorderMargins.Create;


  inherited Create(AName,ACaption);


  FStretchMargins.OnChange:=Self.DoChange;
  FDestDrawStretchMargins.OnChange:=Self.DoChange;
end;

function TBaseDrawPictureParam.CurrentEffectImageIndex(AImageIndex:Integer): Integer;
begin
  Result:=-1;
  if (CurrentEffect<>nil) and (dppetImageIndexChange in TDrawPictureParamEffect(CurrentEffect).FEffectTypes) then
  begin
    Result:=TDrawPictureParamEffect(CurrentEffect).FImageIndex;
  end;
  if (CurrentEffect<>nil) and (dppetImageIndexInc1 in TDrawPictureParamEffect(CurrentEffect).FEffectTypes) then
  begin
    Result:=AImageIndex+1;
  end;
end;

function TBaseDrawPictureParam.CurrentEffectImageName: String;
begin
  Result:='';
  if (CurrentEffect<>nil) and (dppetImageNameChange in TDrawPictureParamEffect(CurrentEffect).FEffectTypes) then
  begin
    Result:=TDrawPictureParamEffect(CurrentEffect).FImageName;
  end;
end;

function TBaseDrawPictureParam.CurrentEffectRotateAngle: Double;
begin
  Result:=Self.FRotateAngle;
  if (CurrentEffect<>nil) and (dppetRotateAngleChange in TDrawPictureParamEffect(CurrentEffect).FEffectTypes) then
  begin
    Result:=FRotateAngle+TDrawPictureParamEffect(CurrentEffect).FRotateAngle;
  end;
end;

//function TBaseDrawPictureParam.CustomLoadFromJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  //这些属性保存
//  Self.FIsAutoFit:=(ASuperObject.I['is_autofit']=1);
//
//  Self.FIsStretch:=(ASuperObject.I['is_stretch']=1);
//  Self.FStretchStyle:=GetPictureStretchStyle(ASuperObject.S['stretch_style']);
//
//  Self.FStretchMargins.LoadFromString(ASuperObject.S['stretch_margins']);
//  Self.FDestDrawStretchMargins.LoadFromString(ASuperObject.S['dest_draw_stretch_margins']);
//
//  Self.FPictureVertAlign:=GetPictureVertAlign(ASuperObject.S['picture_vert_align']);
//  Self.FPictureHorzAlign:=GetPictureHorzAlign(ASuperObject.S['picture_hroz_align']);
//
//  Result:=True;
//end;
//
//function TBaseDrawPictureParam.CustomSaveToJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  ASuperObject.S['type']:='DrawPictureParam';
//
//  ASuperObject.I['is_autofit']:=Ord(Self.FIsAutoFit);
//
//  ASuperObject.I['is_stretch']:=Ord(Self.FIsStretch);
//  Self.FStretchStyle:=FStretchStyle;
//
//  ASuperObject.S['stretch_margins']:=Self.FStretchMargins.SaveToString;
//  ASuperObject.S['dest_draw_stretch_margins']:=Self.FDestDrawStretchMargins.SaveToString;
//
//  ASuperObject.S['picture_vert_align']:=GetPictureVertAlignStr(Self.FPictureVertAlign);
//  ASuperObject.S['picture_hroz_align']:=GetPictureHorzAlignStr(Self.FPictureHorzAlign);
//
//
//  Result:=True;
//end;

function TBaseDrawPictureParam.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I:Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited LoadFromDocNode(ADocNode);



  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='IsAutoFit' then
    begin
      FIsAutoFit:=ABTNode.ConvertNode_Bool32.Data;
    end


    else if ABTNode.NodeName='IsStretch' then
    begin
      FIsStretch:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='StretchStyle' then
    begin
      FStretchStyle:=TPictureStretchStyle(ABTNode.ConvertNode_Int32.Data);
    end
    else if ABTNode.NodeName='StretchMargins' then
    begin
      FStretchMargins.LoadFromString(ABTNode.ConvertNode_WideString.Data);
    end
    else if ABTNode.NodeName='DestDrawStretchMargins' then
    begin
      DestDrawStretchMargins.LoadFromString(ABTNode.ConvertNode_WideString.Data);
    end


    else if ABTNode.NodeName='PictureHorzAlign' then
    begin
      FPictureHorzAlign:=TPictureHorzAlign(ABTNode.ConvertNode_Int32.Data);
    end
    else if ABTNode.NodeName='PictureVertAlign' then
    begin
      FPictureVertAlign:=TPictureVertAlign(ABTNode.ConvertNode_Int32.Data);
    end

    ;

  end;



  Result:=True;
end;

function TBaseDrawPictureParam.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited SaveToDocNode(ADocNode);


  ABTNode:=ADocNode.AddChildNode_Bool32('IsAutoFit','是否自适应');
  ABTNode.ConvertNode_Bool32.Data:=FIsAutoFit;



  ABTNode:=ADocNode.AddChildNode_Bool32('IsStretch','是否拉伸');
  ABTNode.ConvertNode_Bool32.Data:=FIsStretch;

  ABTNode:=ADocNode.AddChildNode_Int32('StretchStyle','拉伸风格');
  ABTNode.ConvertNode_Int32.Data:=Ord(FStretchStyle);

  ABTNode:=ADocNode.AddChildNode_WideString('StretchMargins','图片拉伸边距');
  ABTNode.ConvertNode_WideString.Data:=FStretchMargins.SaveToString;

  ABTNode:=ADocNode.AddChildNode_WideString('DestDrawStretchMargins','目标绘制拉伸边距');
  ABTNode.ConvertNode_WideString.Data:=FDestDrawStretchMargins.SaveToString;



  ABTNode:=ADocNode.AddChildNode_Int32('PictureHorzAlign','水平对齐风格');
  ABTNode.ConvertNode_Int32.Data:=Ord(FPictureHorzAlign);

  ABTNode:=ADocNode.AddChildNode_Int32('PictureVertAlign','垂直对齐风格');
  ABTNode.ConvertNode_Int32.Data:=Ord(FPictureVertAlign);


  Result:=True;

end;

destructor TBaseDrawPictureParam.Destroy;
begin
  FreeAndNil(FStretchMargins);
  FreeAndNil(FDestDrawStretchMargins);
  inherited;
end;

function TBaseDrawPictureParam.GetDrawEffectSetting: TDrawPictureEffectSetting;
begin
  Result:=TDrawPictureEffectSetting(Self.FDrawEffectSetting);
end;

function TBaseDrawPictureParam.GetDrawEffectSettingClass: TDrawEffectSettingClass;
begin
  Result:=TDrawPictureEffectSetting;
end;

function TBaseDrawPictureParam.GetDrawParamSettingClass: TDrawParamSettingClass;
begin
  Result:=TDrawPictureParamSetting;
end;

//function TBaseDrawPictureParam.GetSetting: TDrawPictureParamSetting;
//begin
//  Result:=TDrawPictureParamSetting(Self.FSetting);
//end;

function TBaseDrawPictureParam.IsIsAutoFitStored: Boolean;
begin
  Result:=(Self.FIsAutoFit<>False);
end;

function TBaseDrawPictureParam.IsIsStretchStored: Boolean;
begin
  Result:=(Self.FIsStretch<>False);
end;

function TBaseDrawPictureParam.IsPictureHorzAlignStored: Boolean;
begin
  Result:=(Self.FPictureHorzAlign<>phaLeft);
end;

function TBaseDrawPictureParam.IsPictureVertAlignStored: Boolean;
begin
  Result:=(Self.FPictureVertAlign<>pvaTop);
end;

function TBaseDrawPictureParam.IsStretchStyleStored: Boolean;
begin
  Result:=(Self.FStretchStyle<>issTensile);
end;

procedure TBaseDrawPictureParam.AssignTo(Dest: TPersistent);
var
  DestObject:TBaseDrawPictureParam;
begin

  if Dest is TBaseDrawPictureParam then
  begin

    DestObject:=TBaseDrawPictureParam(Dest);

    //不保存
    DestObject.FScale:=FScale;
    DestObject.FRotateAngle:=FRotateAngle;

    DestObject.FPictureTooSmallProcessType:=FPictureTooSmallProcessType;
    DestObject.FPictureTooLargeProcessType:=FPictureTooLargeProcessType;
//    DestObject.FIsDrawSquareCenterBlock:=FIsDrawSquareCenterBlock;


    //这些属性保存
    DestObject.FIsAutoFit:=FIsAutoFit;

    DestObject.FIsStretch:=FIsStretch;
    DestObject.FStretchStyle:=FStretchStyle;


    DestObject.FStretchMargins.Assign(Self.FStretchMargins);
    DestObject.FDestDrawStretchMargins.Assign(Self.FDestDrawStretchMargins);


    DestObject.FPictureVertAlign:=FPictureVertAlign;
    DestObject.FPictureHorzAlign:=FPictureHorzAlign;

  end;

  Inherited;

end;

procedure TBaseDrawPictureParam.Clear;
begin
  inherited Clear;

  FRotateAngle:=0;

  FScale:=1;

//  FPictureTooSmallProcessType:=itsptNone;
//  FPictureTooLargeProcessType:=itlptNone;

//  FIsDrawSquareCenterBlock:=True;


  FIsAutoFit:=False;

  FIsStretch:=False;

  FStretchMargins.SetBounds(8,8,8,8);

  FDestDrawStretchMargins.SetBounds(8,8,8,8);

  FStretchStyle:=issTensile;

  FPictureVertAlign:=pvaTop;
  FPictureHorzAlign:=phaLeft;

end;


procedure TBaseDrawPictureParam.SetPictureHorzAlign(const Value: TPictureHorzAlign);
begin
  if FPictureHorzAlign<>Value then
  begin
    FPictureHorzAlign := Value;
    DoChange;
  end;
end;

procedure TBaseDrawPictureParam.SetPictureVertAlign(const Value: TPictureVertAlign);
begin
  if FPictureVertAlign<>Value then
  begin
    FPictureVertAlign := Value;
    DoChange;
  end;
end;

procedure TBaseDrawPictureParam.SetIsAutoFit(const Value: Boolean);
begin
  if FIsAutoFit<>Value then
  begin
    FIsAutoFit := Value;
    DoChange;
  end;
end;

//procedure TBaseDrawPictureParam.SetIsDrawSquareCenterBlock(const Value: Boolean);
//begin
//  if FIsDrawSquareCenterBlock<>Value then
//  begin
//    FIsDrawSquareCenterBlock := Value;
//    DoChange;
//  end;
//end;

procedure TBaseDrawPictureParam.SetIsStretch(const Value: Boolean);
begin
  if FIsStretch<>Value then
  begin
    FIsStretch := Value;
    DoChange;
  end;
end;

procedure TBaseDrawPictureParam.SetPictureTooSmallProcessType(const Value: TPictureTooSmallProcessType);
begin
  if FPictureTooSmallProcessType<>Value then
  begin
    FPictureTooSmallProcessType := Value;
    DoChange;
  end;
end;

procedure TBaseDrawPictureParam.SetPictureTooLargeProcessType(const Value: TPictureTooLargeProcessType);
begin
  if FPictureTooLargeProcessType<>Value then
  begin
    FPictureTooLargeProcessType := Value;
    DoChange;
  end;
end;

procedure TBaseDrawPictureParam.SetRotateAngle(const Value: Double);
begin
  if FRotateAngle<>Value then
  begin
    FRotateAngle := Value;
    DoChange;
  end;
end;

procedure TBaseDrawPictureParam.SetScale(const Value: Double);
begin
  if FScale<>Value then
  begin
    FScale := Value;
    DoChange;
  end;
end;

//procedure TBaseDrawPictureParam.SetSetting(const Value: TDrawPictureParamSetting);
//begin
//
//end;

procedure TBaseDrawPictureParam.SetStretchMargins(const Value: TBorderMargins);
begin
  FStretchMargins.Assign(Value);
end;

procedure TBaseDrawPictureParam.SetDestDrawStretchMargins(const Value: TBorderMargins);
begin
  FDestDrawStretchMargins.Assign(Value);
end;

procedure TBaseDrawPictureParam.SetDrawEffectSetting(
  const Value: TDrawPictureEffectSetting);
begin

end;

procedure TBaseDrawPictureParam.SetStretchStyle(const Value: TPictureStretchStyle);
begin
  if FStretchStyle<>Value then
  begin
    FStretchStyle := Value;
    DoChange;
  end;
end;






{ TDrawPictureParamEffect }


procedure TDrawPictureParamEffect.AssignTo(Dest: TPersistent);
var
  DestObject:TDrawPictureParamEffect;
begin
  if Dest is TDrawPictureParamEffect then
  begin
    DestObject:=TDrawPictureParamEffect(Dest);

    DestObject.FImageIndex:=FImageIndex;
    DestObject.FImageName:=FImageName;
    DestObject.FRotateAngle:=FRotateAngle;

    DestObject.FEffectTypes:=FEffectTypes;
  end;

  Inherited;
end;

procedure TDrawPictureParamEffect.Clear;
begin
  Inherited;
end;

constructor TDrawPictureParamEffect.Create;
begin
  FImageIndex:=-1;

  FImageName:='';

  FRotateAngle:=Const_DefaultEffect_RotateAngle;

  Inherited;
end;

function TDrawPictureParamEffect.HasEffectTypes: Boolean;
begin
  Result:=(Inherited HasEffectTypes) or (Self.FEffectTypes<>[]);
end;

function TDrawPictureParamEffect.IsEffectTypesStored: Boolean;
begin
  Result:=(Self.FEffectTypes<>[]);
end;

function TDrawPictureParamEffect.IsImageIndexStored: Boolean;
begin
  Result:=(Self.FImageIndex<>-1);
end;

function TDrawPictureParamEffect.IsImageNameStored: Boolean;
begin
  Result:=(Self.FImageName<>'');
end;

function TDrawPictureParamEffect.IsRotateAngleStored: Boolean;
begin
  Result:=(Self.FRotateAngle<>90);
end;

function TDrawPictureParamEffect.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='RotateAngle' then
    begin
      Self.FRotateAngle:=ABTNode.ConvertNode_Int32.Data;
    end
    else if ABTNode.NodeName='ImageIndex' then
    begin
      Self.FImageIndex:=ABTNode.ConvertNode_Int32.Data;
    end
    else if ABTNode.NodeName='ImageName' then
    begin
      Self.FImageName:=ABTNode.ConvertNode_WideString.Data;
    end
    else if ABTNode.NodeName='EffectTypes' then
    begin
      Self.FEffectTypes:=GetSetFromStr_TDPPEffectTypes(ABTNode.ConvertNode_WideString.Data);
    end
    ;
  end;

  Result:=True;


end;

//function TDrawPictureParamEffect.LoadFromJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Inherited;
//
//  Result:=False;
//
//  Self.FImageIndex:=ASuperObject.I['image_index'];
//  Self.FImageName:=ASuperObject.S['image_name'];
//  Self.FRotateAngle:=ASuperObject.I['rotate_angle'];
//
//  Self.FEffectTypes:=GetDPPEffectTypes(ASuperObject.S['effect_types']);
//
//  Result:=True;
//end;

function TDrawPictureParamEffect.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);


  ABTNode:=ADocNode.AddChildNode_Int32('RotateAngle','旋转角度');
  ABTNode.ConvertNode_Int32.Data:=FRotateAngle;

  ABTNode:=ADocNode.AddChildNode_Int32('ImageIndex','图片下标');
  ABTNode.ConvertNode_Int32.Data:=FImageIndex;

  ABTNode:=ADocNode.AddChildNode_WideString('ImageName','图片名称');
  ABTNode.ConvertNode_WideString.Data:=FImageName;

  ABTNode:=ADocNode.AddChildNode_WideString('EffectTypes','效果集');
  ABTNode.ConvertNode_WideString.Data:=GetStrFromSet_TDPPEffectTypes(FEffectTypes);


  Result:=True;

end;

//function TDrawPictureParamEffect.SaveToJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Inherited;
//
//  Result:=False;
//
//  ASuperObject.I['image_index']:=Self.FImageIndex;
//  ASuperObject.S['image_name']:=Self.FImageName;
//  ASuperObject.I['rotate_angle']:=Self.FRotateAngle;
//
//  ASuperObject.S['effect_types']:=GetDPPEffectTypesStr(Self.FEffectTypes);
//
//  Result:=True;
//end;

{ TDrawPictureEffectSetting }

function TDrawPictureEffectSetting.GetDisabledEffect: TDrawPictureParamEffect;
begin
  Result:=TDrawPictureParamEffect(Self.FDisabledEffect);
end;

function TDrawPictureEffectSetting.GetDrawParamEffectClass: TDrawParamCommonEffectClass;
begin
  Result:=TDrawPictureParamEffect;
end;

function TDrawPictureEffectSetting.GetFocusedEffect: TDrawPictureParamEffect;
begin
  Result:=TDrawPictureParamEffect(Self.FFocusedEffect);
end;

function TDrawPictureEffectSetting.GetMouseDownEffect: TDrawPictureParamEffect;
begin
  Result:=TDrawPictureParamEffect(Self.FMouseDownEffect);
end;

function TDrawPictureEffectSetting.GetMouseOverEffect: TDrawPictureParamEffect;
begin
  Result:=TDrawPictureParamEffect(Self.FMouseOverEffect);
end;

function TDrawPictureEffectSetting.GetPushedEffect: TDrawPictureParamEffect;
begin
  Result:=TDrawPictureParamEffect(Self.FPushedEffect);
end;

procedure TDrawPictureEffectSetting.SetDisabledEffect(
  const Value: TDrawPictureParamEffect);
begin
  FDisabledEffect.Assign(Value);
end;

procedure TDrawPictureEffectSetting.SetFocusedEffect(
  const Value: TDrawPictureParamEffect);
begin
  FFocusedEffect.Assign(Value);
end;

procedure TDrawPictureEffectSetting.SetMouseDownEffect(
  const Value: TDrawPictureParamEffect);
begin
  FMouseDownEffect.Assign(Value);
end;

procedure TDrawPictureEffectSetting.SetMouseOverEffect(
  const Value: TDrawPictureParamEffect);
begin
  FMouseOverEffect.Assign(Value);
end;

procedure TDrawPictureEffectSetting.SetPushedEffect(
  const Value: TDrawPictureParamEffect);
begin
  FPushedEffect.Assign(Value);
end;





{ TDrawPictureParamSetting }



constructor TDrawPictureParamSetting.Create(ADrawParam: TDrawParam);
begin
  inherited;
  FDrawPictureParam:=TBaseDrawPictureParam(ADrawParam);
end;


function TDrawPictureParamSetting.GetMouseDownRotateAngle: Integer;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.MouseDownEffect.FRotateAngle;
end;

function TDrawPictureParamSetting.GetMouseDownRotateAngleChange: Boolean;
begin
  Result:=dppetRotateAngleChange in FDrawPictureParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.GetMouseOverRotateAngle: Integer;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.MouseOverEffect.FRotateAngle;

end;

function TDrawPictureParamSetting.GetMouseOverRotateAngleChange: Boolean;
begin
  Result:=dppetRotateAngleChange in FDrawPictureParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.GetPushedRotateAngle: Integer;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.PushedEffect.FRotateAngle;
end;

function TDrawPictureParamSetting.GetPushedRotateAngleChange: Boolean;
begin
  Result:=dppetRotateAngleChange in FDrawPictureParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;



procedure TDrawPictureParamSetting.SetMouseDownRotateAngle(const Value: Integer);
begin
  FDrawPictureParam.DrawEffectSetting.MouseDownEffect.RotateAngle:=Value;
end;

procedure TDrawPictureParamSetting.SetMouseDownRotateAngleChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPictureParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.MouseDownEffect.EffectTypes+[dppetRotateAngleChange];
  end
  else
  begin
    FDrawPictureParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.MouseDownEffect.EffectTypes-[dppetRotateAngleChange];
  end;
end;

procedure TDrawPictureParamSetting.SetMouseOverRotateAngle(const Value: Integer);
begin
  FDrawPictureParam.DrawEffectSetting.MouseOverEffect.RotateAngle:=Value;
end;

procedure TDrawPictureParamSetting.SetMouseOverRotateAngleChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPictureParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.MouseOverEffect.EffectTypes+[dppetRotateAngleChange];
  end
  else
  begin
    FDrawPictureParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.MouseOverEffect.EffectTypes-[dppetRotateAngleChange];
  end;
end;

procedure TDrawPictureParamSetting.SetPushedRotateAngle(const Value: Integer);
begin
  FDrawPictureParam.DrawEffectSetting.PushedEffect.RotateAngle:=Value;
end;

procedure TDrawPictureParamSetting.SetPushedRotateAngleChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPictureParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.PushedEffect.EffectTypes+[dppetRotateAngleChange];
  end
  else
  begin
    FDrawPictureParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.PushedEffect.EffectTypes-[dppetRotateAngleChange];
  end;
end;



function TDrawPictureParamSetting.GetMouseDownImageIndex: Integer;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.MouseDownEffect.FImageIndex;
end;

function TDrawPictureParamSetting.GetMouseDownImageIndexChange: Boolean;
begin
  Result:=dppetImageIndexChange in FDrawPictureParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.GetMouseOverImageIndex: Integer;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.MouseOverEffect.FImageIndex;

end;

function TDrawPictureParamSetting.GetMouseOverImageIndexChange: Boolean;
begin
  Result:=dppetImageIndexChange in FDrawPictureParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.GetPushedImageIndex: Integer;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.PushedEffect.FImageIndex;
end;

function TDrawPictureParamSetting.GetPushedImageIndexChange: Boolean;
begin
  Result:=dppetImageIndexChange in FDrawPictureParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;



procedure TDrawPictureParamSetting.SetMouseDownImageIndex(const Value: Integer);
begin
  FDrawPictureParam.DrawEffectSetting.MouseDownEffect.ImageIndex:=Value;
end;

procedure TDrawPictureParamSetting.SetMouseDownImageIndexChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPictureParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.MouseDownEffect.EffectTypes+[dppetImageIndexChange];
  end
  else
  begin
    FDrawPictureParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.MouseDownEffect.EffectTypes-[dppetImageIndexChange];
  end;
end;

procedure TDrawPictureParamSetting.SetMouseOverImageIndex(const Value: Integer);
begin
  FDrawPictureParam.DrawEffectSetting.MouseOverEffect.ImageIndex:=Value;
end;

procedure TDrawPictureParamSetting.SetMouseOverImageIndexChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPictureParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.MouseOverEffect.EffectTypes+[dppetImageIndexChange];
  end
  else
  begin
    FDrawPictureParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.MouseOverEffect.EffectTypes-[dppetImageIndexChange];
  end;
end;

procedure TDrawPictureParamSetting.SetPushedImageIndex(const Value: Integer);
begin
  FDrawPictureParam.DrawEffectSetting.PushedEffect.ImageIndex:=Value;
end;

procedure TDrawPictureParamSetting.SetPushedImageIndexChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPictureParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.PushedEffect.EffectTypes+[dppetImageIndexChange];
  end
  else
  begin
    FDrawPictureParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.PushedEffect.EffectTypes-[dppetImageIndexChange];
  end;
end;





function TDrawPictureParamSetting.GetMouseDownImageName: String;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.MouseDownEffect.FImageName;
end;

function TDrawPictureParamSetting.GetMouseDownImageNameChange: Boolean;
begin
  Result:=dppetImageNameChange in FDrawPictureParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.GetMouseOverImageName: String;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.MouseOverEffect.FImageName;
end;

function TDrawPictureParamSetting.GetMouseOverImageNameChange: Boolean;
begin
  Result:=dppetImageNameChange in FDrawPictureParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.GetPushedImageName: String;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.PushedEffect.FImageName;
end;

function TDrawPictureParamSetting.GetPushedImageNameChange: Boolean;
begin
  Result:=dppetImageNameChange in FDrawPictureParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;



function TDrawPictureParamSetting.IsMouseDownImageIndexChangeStored: Boolean;
begin
  Result:=dppetImageIndexChange in FDrawPictureParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.IsMouseDownImageIndexStored: Boolean;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.MouseDownEffect.FImageIndex<>-1;
end;

function TDrawPictureParamSetting.IsMouseDownImageNameChangeStored: Boolean;
begin
  Result:=dppetImageNameChange in FDrawPictureParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.IsMouseDownRotateAngleChangeStored: Boolean;
begin
  Result:=dppetRotateAngleChange in FDrawPictureParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.IsMouseDownRotateAngleStored: Boolean;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.MouseDownEffect.FRotateAngle<>Const_DefaultEffect_RotateAngle;
end;

//function TDrawPictureParamSetting.IsMouseDownImageNameStored: Boolean;
//begin
//  Result:=FDrawPictureParam.DrawEffectSetting.MouseDownEffect.FImageName<>-1;
//end;

function TDrawPictureParamSetting.IsMouseOverImageIndexChangeStored: Boolean;
begin
  Result:=dppetImageIndexChange in FDrawPictureParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.IsMouseOverImageIndexStored: Boolean;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.MouseOverEffect.FImageIndex<>-1;
end;

function TDrawPictureParamSetting.IsMouseOverImageNameChangeStored: Boolean;
begin
  Result:=dppetImageNameChange in FDrawPictureParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.IsMouseOverRotateAngleChangeStored: Boolean;
begin
  Result:=dppetRotateAngleChange in FDrawPictureParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.IsMouseOverRotateAngleStored: Boolean;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.MouseOverEffect.FRotateAngle<>Const_DefaultEffect_RotateAngle;
end;

//function TDrawPictureParamSetting.IsMouseOverImageNameStored: Boolean;
//begin
//
//end;

function TDrawPictureParamSetting.IsPushedImageIndexChangeStored: Boolean;
begin
  Result:=dppetImageIndexChange in FDrawPictureParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.IsPushedImageIndexStored: Boolean;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.PushedEffect.FImageIndex<>-1;
end;

function TDrawPictureParamSetting.IsPushedImageNameChangeStored: Boolean;
begin
  Result:=dppetImageNameChange in FDrawPictureParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.IsPushedRotateAngleChangeStored: Boolean;
begin
  Result:=dppetRotateAngleChange in FDrawPictureParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;

function TDrawPictureParamSetting.IsPushedRotateAngleStored: Boolean;
begin
  Result:=FDrawPictureParam.DrawEffectSetting.PushedEffect.FRotateAngle<>Const_DefaultEffect_RotateAngle;
end;

//function TDrawPictureParamSetting.IsPushedImageNameStored: Boolean;
//begin
//
//end;

procedure TDrawPictureParamSetting.SetMouseDownImageName(const Value: String);
begin
  FDrawPictureParam.DrawEffectSetting.MouseDownEffect.ImageName:=Value;
end;

procedure TDrawPictureParamSetting.SetMouseDownImageNameChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPictureParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.MouseDownEffect.EffectTypes+[dppetImageNameChange];
  end
  else
  begin
    FDrawPictureParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.MouseDownEffect.EffectTypes-[dppetImageNameChange];
  end;
end;

procedure TDrawPictureParamSetting.SetMouseOverImageName(const Value: String);
begin
  FDrawPictureParam.DrawEffectSetting.MouseOverEffect.ImageName:=Value;
end;

procedure TDrawPictureParamSetting.SetMouseOverImageNameChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPictureParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.MouseOverEffect.EffectTypes+[dppetImageNameChange];
  end
  else
  begin
    FDrawPictureParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.MouseOverEffect.EffectTypes-[dppetImageNameChange];
  end;
end;

procedure TDrawPictureParamSetting.SetPushedImageName(const Value: String);
begin
  FDrawPictureParam.DrawEffectSetting.PushedEffect.ImageName:=Value;
end;

procedure TDrawPictureParamSetting.SetPushedImageNameChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPictureParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.PushedEffect.EffectTypes+[dppetImageNameChange];
  end
  else
  begin
    FDrawPictureParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawPictureParam.DrawEffectSetting.PushedEffect.EffectTypes-[dppetImageNameChange];
  end;
end;



//{ TBaseNewDrawPictureParam }
//
//function TBaseNewDrawPictureParam.GetHorzAlign: TSkinAlign;
//begin
//  case Self.FPictureHorzAlign of
//    phaLeft: Result:=salLeading;
//    phaCenter: Result:=salCenter;
//    phaRight: Result:=salTrailing;
//  end;
//end;
//
//function TBaseNewDrawPictureParam.GetStretchMode: TSkinStretchMode;
//begin
//  if Self.FIsStretch then
//  begin
//    case Self.FStretchStyle of
//      issTensile: Result:=ssmStretch;
//      issSquare: Result:=ssmSquare;
//      issSquarePro: Result:=ssmSquare;
//      issThreePartHorz: Result:=ssmHorz3Part;
//      issThreePartVert: Result:=ssmVert3Part;
//      issThreePartHorzPro: Result:=ssmHorz3Part;
//      issThreePartVertPro: Result:=ssmVert3Part;
//    end;
//  end
//  else
//  begin
//    Result:=ssmNone;
//  end;
//end;
//
//function TBaseNewDrawPictureParam.GetVertAlign: TSkinAlign;
//begin
//  case Self.FPictureVertAlign of
//    pvaTop: Result:=salLeading;
//    pvaCenter: Result:=salCenter;
//    pvaBottom: Result:=salTrailing;
//  end;
//end;
//
//function TBaseNewDrawPictureParam.IsHorzAlignStored: Boolean;
//begin
//  Result:=FPictureHorzAlign<>phaLeft;
//end;
//
//function TBaseNewDrawPictureParam.IsStretchModeStored: Boolean;
//begin
//  Result:=FIsStretch<>False;
//end;
//
//function TBaseNewDrawPictureParam.IsVertAlignStored: Boolean;
//begin
//  Result:=FPictureVertAlign<>pvaTop;
//end;
//
//procedure TBaseNewDrawPictureParam.SetHorzAlign(const Value: TSkinAlign);
//begin
//  case Value of
//    salLeading: PictureHorzAlign:=phaLeft;
//    salCenter: PictureHorzAlign:=phaCenter;
//    salTrailing: PictureHorzAlign:=phaRight;
//  end;
//end;
//
//procedure TBaseNewDrawPictureParam.SetStretchMode(const Value: TSkinStretchMode);
//begin
////  if Self.FIsStretch then
////  begin
////    case Self.FStretchStyle of
////      issTensile: Result:=ssmStretch;
////      issSquare: Result:=ssmSquare;
////      issSquarePro: Result:=ssmSquare;
////      issThreePartHorz: Result:=ssmHorz3Part;
////      issThreePartVert: Result:=ssmVert3Part;
////      issThreePartHorzPro: Result:=ssmHorz3Part;
////      issThreePartVertPro: Result:=ssmVert3Part;
////    end;
////  end
////  else
////  begin
////    Result:=ssmNone;
////  end;
//
//  if Value=ssmNone then
//  begin
//    FIsStretch:=False;
//  end
//  else
//  begin
//    FIsStretch:=True;
//
//    case Value of
//      ssmNone: FIsStretch:=False;
//      ssmStretch: FStretchStyle:=issTensile;
//      ssmSquare: FStretchStyle:=issSquare;
//      ssmHorz3Part: FStretchStyle:=issThreePartHorz;
//      ssmVert3Part: FStretchStyle:=issThreePartVert;
//    end;
//  end;
//end;
//
//procedure TBaseNewDrawPictureParam.SetVertAlign(const Value: TSkinAlign);
//begin
//  case Value of
//    salLeading: PictureVertAlign:=pvaTop;
//    salCenter: PictureVertAlign:=pvaCenter;
//    salTrailing: PictureVertAlign:=pvaBottom;
//  end;
//end;



initialization
  GlobalDrawPictureParam:=TDrawPictureParam.Create('GlobalDrawPictureParam','全局图片绘制参数');
  GlobalDrawColorRoundRectBitmapParam:=TDrawPictureParam.Create('','');
//  GlobalDrawColorRoundRectBitmapParam.StretchStyle:=issSquarePro;
//  GlobalDrawColorRoundRectBitmapParam.IsStretch:=True;


finalization
  FreeAndNil(GlobalDrawPictureParam);
  FreeAndNil(GlobalDrawColorRoundRectBitmapParam);

end.



