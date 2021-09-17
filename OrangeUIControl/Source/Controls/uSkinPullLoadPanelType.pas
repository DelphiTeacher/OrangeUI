//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     拖动加载面板
///   </para>
///   <para>
///     Drag load panel
///   </para>
/// </summary>
unit uSkinPullLoadPanelType;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  Types,
  uFuncCommon,
  {$IFDEF VCL}
  Windows,
  Messages,
  Controls,
  ExtCtrls,
  Forms,
  uSkinWindowsControl,
  {$ENDIF}
  {$IFDEF FMX}
  FMX.Types,
  UITypes,
  FMX.Forms,
  FMX.Controls,
  uSkinFireMonkeyControl,
  {$ENDIF}
  Math,
  uLang,
  uSkinImageList,
  uBaseSkinControl,
  DateUtils,
  uTimerTask,
  uBaseLog,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uComponentType,
  uSkinMaterial,
  uDrawEngine,
  uSkinAnimator,
  uDrawPicture,
//  uSkinScrollBarType,
  uSkinControlGestureManager,
  uDrawTextParam,
  uDrawRectParam,
  uSkinLabelType,
  uSkinImageType,
  uGraphicCommon,
  uDrawPictureParam;



const
  IID_ISkinPullLoadPanel:TGUID='{AFC17867-05BA-46FA-BFBA-288BBD2D8F80}';

type
  TPullLoadPanelProperties=class;






  /// <summary>
  ///   <para>
  ///     拖动加载面板接口
  ///   </para>
  ///   <para>
  ///     Interface of Drag load panel
  ///   </para>
  /// </summary>
  ISkinPullLoadPanel=interface
    ['{AFC17867-05BA-46FA-BFBA-288BBD2D8F80}']

    //执行加载事件
    function GetOnExecuteLoad:TNotifyEvent;
    property OnExecuteLoad:TNotifyEvent read GetOnExecuteLoad;




    //在线程中执行加载事件
    function GetOnThreadExecuteLoad:TNotifyEvent;
    property OnThreadExecuteLoad:TNotifyEvent read GetOnThreadExecuteLoad;
    //线程加载结束事件
    function GetOnThreadLoadFinished:TNotifyEvent;
    property OnThreadLoadFinished:TNotifyEvent read GetOnThreadLoadFinished;



    function GetPullLoadPanelProperties:TPullLoadPanelProperties;
    property Properties:TPullLoadPanelProperties read GetPullLoadPanelProperties;
    property Prop:TPullLoadPanelProperties read GetPullLoadPanelProperties;
  end;












  /// <summary>
  ///   <para>
  ///     拖动加载面板类型
  ///   </para>
  ///   <para>
  ///     Drag load panel type
  ///   </para>
  /// </summary>
  TPullLoadPanelType=(
                      sborlptTop,
                      sborlptBottom
                      );





  /// <summary>
  ///   <para>
  ///     拖动加载面板属性
  ///   </para>
  ///   <para>
  ///     Drag load panel properties
  ///   </para>
  /// </summary>
  TPullLoadPanelProperties=class(TSkinControlProperties)
  private
    //设计时存储和还原
    FIsDesignTimeStored:Boolean;

    //设计时的位置和高度
    FDesignTimeTop:Double;
    FDesignTimeHeight:Double;


    //设计时暂存加载面板位置
    procedure DesignTimeStorePanel;
    //设计时还原加载面板位置
    procedure DesignTimeResotorePanel;
  protected
    //下拉松开的时候,
    //Panel弹回到初始的位置,
    //再按住手指往上拖动,
    //Panel也能上移,
    //而不是固定在初始位置
    FIsFirstDropAndStay:Boolean;



    //是否正在加载
    FIsLoading: Boolean;
    //是否加载正在结束
    FIsStopLoading: Boolean;



    //加载面板类型(上拉还是下拉)
    FLoadPanelType: TPullLoadPanelType;


    //正在加载的提示文本
    FLoadingLabel: TChildControl;
    //旋转菊花的提示图片
    FLoadingImage: TChildControl;
    //决定是否加载的提示图片
    FDecideLoadHintImage: TChildControl;



    FLoadingLabelIntf: ISkinLabel;
    FLoadingImageIntf: ISkinImage;
    FDecideLoadHintImageIntf: ISkinImage;


    FLoadingLabelControlIntf: ISkinControl;
    FLoadingImageControlIntf: ISkinControl;
    FDecideLoadHintImageControlIntf: ISkinControl;


    //上次加载结束时间
    FLastLoadStopTime:TDateTime;
    //时间间隔
    FCanNextLoadDelayTimeSpace:Integer;


    FSkinPullLoadPanelIntf:ISkinPullLoadPanel;


    procedure SetLoadingImage(const Value: TChildControl);
    procedure SetLoadingLabel(const Value: TChildControl);
    procedure SetDecideLoadHintImage(const Value: TChildControl);


    //执行设计期测试加载
    procedure DoDesigningExecuteLoad(ATimerTask:TObject);
    //执行设计期测试加载结束
    procedure DoDesigningExecuteLoadEnd(ATimerTask:TObject);


    //执行线程加载
    procedure DoThreadExecuteLoad(ATimerTask:TObject);
    //执行线程加载结束
    procedure DoThreadExecuteLoadEnd(ATimerTask:TObject);


    //执行加载
    function DoExecuteLoad:Boolean;

  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    procedure DoOverRangePosValueChange(Sender:TObject;
                                        AScrollBarKind:TScrollBarKind;
                                        IsUserDraging:Boolean;
                                        PositionValue:Double;
                                        NextPositionValue:Double;
                                        LastPositionValue:Double;
                                        NextValue:Double;
                                        LastValue:Double;
                                        Step:Double;
                                        var NewValue:Double;
                                        var CanChange:Boolean);
    //滚回到初始结束(设置FIsLoading和FIsStopLoading)
    procedure DoScrollingToInitialEnd;
    //松开手指事件
    procedure DoDragingStateChange(Sender:TObject;
                                  AScrollBarKind:TScrollBarKind;
                                  IsUserDraging:Boolean;
                                  PositionValue:Double);
  public
    FWaitHintTime:Integer;
    FControlGestureManager:TSkinControlGestureManager;


    /// <summary>
    ///   <para>
    ///     开始加载(自动加载)
    ///   </para>
    ///   <para>
    ///     Start load(load automatically)
    ///   </para>
    /// </summary>
    procedure StartLoad(AScrollBarKind:TScrollBarKind=sbVertical);

    /// <summary>
    ///   <para>
    ///     结束加载
    ///   </para>
    ///   <para>
    ///     End load
    ///   </para>
    /// </summary>
    procedure StopLoad(const ALoadingStopCaption:String='刷新成功!';const AWaitHintTime:Integer=0;const AHasLoadMoreDataNeedScroll:Boolean=False);




    //计算
    function CalcPosition(AScrollBarKind:TScrollBarKind;SettingPosition:Integer;ImageHeightInc:Integer):Double;
    function CalcDecideStartLoadPosition(AScrollBarKind:TScrollBarKind):Double;
    function CalcWaitLoadingStopMinPosition(AScrollBarKind:TScrollBarKind):Double;
    function CalcLoadingImageStopBiggerPosition(AScrollBarKind:TScrollBarKind):Double;
    function CalcLoadingImageBeginRotatePosition(AScrollBarKind:TScrollBarKind):Double;


    //是否正在加载
    property IsLoading:Boolean read FIsLoading;
    //是否加载结束
    property IsLoadingStopping:Boolean read FIsStopLoading;




    /// <summary>
    ///   <para>
    ///     面板类型
    ///   </para>
    ///   <para>
    ///     Panel Type
    ///   </para>
    /// </summary>
    property LoadPanelType:TPullLoadPanelType read FLoadPanelType write FLoadPanelType;

  published

    /// <summary>
    ///   <para>
    ///     正在加载文字控件
    ///   </para>
    ///   <para>
    ///     Loading text control
    ///   </para>
    /// </summary>
    property LoadingLabel:TChildControl read FLoadingLabel write SetLoadingLabel;
    /// <summary>
    ///   <para>
    ///     正在加载的图片控件
    ///   </para>
    ///   <para>
    ///     Loading image control
    ///   </para>
    /// </summary>
    property LoadingImage:TChildControl read FLoadingImage write SetLoadingImage;

    /// <summary>
    ///   <para>
    ///     加载提示图片控件
    ///   </para>
    ///   <para>
    ///     Load hint image control
    ///   </para>
    /// </summary>
    property DecideLoadHintImage:TChildControl read FDecideLoadHintImage write SetDecideLoadHintImage;

  end;



















  /// <summary>
  ///   <para>
  ///     拖动加载面板素材基类
  ///   </para>
  ///   <para>
  ///     Base class of drag load panel material
  ///   </para>
  /// </summary>
  TSkinPullLoadPanelMaterial=class(TSkinControlMaterial)
  end;
  TSkinPullLoadPanelType=class(TSkinControlType)
  private
    FSkinPullLoadPanelIntf:ISkinPullLoadPanel;
    function GetSkinMaterial:TSkinPullLoadPanelMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  public
    procedure DoOverRangePosValueChange(Sender:TObject;
                                        AScrollBarKind:TScrollBarKind;
                                        //是否用户在拖动
                                        IsUserDraging:Boolean;
                                        //位置
                                        PositionValue:Double;
                                        //下一位置
                                        NextPositionValue:Double;
                                        //上一位置
                                        LastPositionValue:Double;
                                        NextValue:Double;
                                        LastValue:Double;
                                        //
                                        Step:Double;
                                        //新值
                                        var NewValue:Double;
                                        //是否更改
                                        var CanChange:Boolean);virtual;
  end;




  













  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     拖动加载面板默认素材
  ///   </para>
  ///   <para>
  ///     Default material of drag load panel
  ///   </para>
  /// </summary>
  /// <remarks>
  ///   只有一个加载图片(有图片放大和旋转效果)
  /// </remarks>
  TSkinPullLoadPanelBasicMaterial=class(TSkinPullLoadPanelMaterial)
  private
    procedure SetIndicatorColor(const Value: TDelphiColor);
  protected
    FIndicatorColor:TDelphiColor;

    //启用自动居中
    FEnableAutoCenterPosition:Boolean;

    //是否启用加载图片慢慢放大
    FEnableLoadingImageBiggerEffect: Boolean;
    //是否启用加载图片旋转
    FEnableLoadingImageRotateEffect: Boolean;


    //加载图片停止放大的距离
    FLoadingImageStopBiggerPosition: Integer;
    //加载图片开始旋转的距离
    FLoadingImageBeginRotatePosition: Integer;

    //正在加载的图片
    FLoadingPicture: TDrawPicture;

    //正在加载的标题绘制参数
    FDrawLoadingCaptionParam:TDrawTextParam;

    procedure SetLoadingPicture(const Value: TDrawPicture);
    procedure SetDrawLoadingCaptionParam(const Value: TDrawTextParam);
  public
    FAutoCreatedIndicatorImageList:TSkinImageList;

    constructor Create(AOwner:TComponent);override;
    Destructor Destroy;override;
  published
    //自动创建的指示图的颜色
    property IndicatorColor:TDelphiColor read FIndicatorColor write SetIndicatorColor;

    //正在加载的图片
    property LoadingPicture:TDrawPicture read FLoadingPicture write SetLoadingPicture;
    //正在加载的标题绘制参数
    property DrawLoadingCaptionParam:TDrawTextParam read FDrawLoadingCaptionParam write SetDrawLoadingCaptionParam;

    /// <summary>
    ///   <para>
    ///     启用自动居中
    ///   </para>
    ///   <para>
    ///     Enable auto center
    ///   </para>
    /// </summary>
    property EnableAutoCenterPosition:Boolean read FEnableAutoCenterPosition write FEnableAutoCenterPosition;


    /// <summary>
    ///   <para>
    ///     是否启用加载图片慢慢放大
    ///   </para>
    ///   <para>
    ///     Whether enable enlarge effect when loading image
    ///   </para>
    /// </summary>
    property EnableLoadingImageBiggerEffect:Boolean read FEnableLoadingImageBiggerEffect write FEnableLoadingImageBiggerEffect;

    /// <summary>
    ///   <para>
    ///     是否启用加载图片旋转
    ///   </para>
    ///   <para>
    ///     Whether enable rotate effect when loading image
    ///   </para>
    /// </summary>
    property EnableLoadingImageRotateEffect:Boolean read FEnableLoadingImageRotateEffect write FEnableLoadingImageRotateEffect;

    /// <summary>
    ///   <para>
    ///     加载图片停止放大的距离
    ///   </para>
    ///   <para>
    ///     Distance of loading picture stop enlarging
    ///   </para>
    /// </summary>
    property LoadingImageStopBiggerPosition:Integer read FLoadingImageStopBiggerPosition write FLoadingImageStopBiggerPosition stored False;

    /// <summary>
    ///   <para>
    ///     加载图片开始旋转的距离
    ///   </para>
    ///   <para>
    ///     Distance of loading picture start totating
    ///   </para>
    /// </summary>
    property LoadingImageBeginRotatePosition:Integer read FLoadingImageBeginRotatePosition write FLoadingImageBeginRotatePosition stored False;
  end;
  TSkinPullLoadPanelBasicType=class(TSkinPullLoadPanelType)
  private
    function GetSkinMaterial:TSkinPullLoadPanelBasicMaterial;
  public
    procedure DoOverRangePosValueChange(Sender:TObject;
                                        AScrollBarKind:TScrollBarKind;
                                        IsUserDraging:Boolean;
                                        PositionValue:Double;
                                        NextPositionValue:Double;
                                        LastPositionValue:Double;
                                        NextValue:Double;
                                        LastValue:Double;
                                        Step:Double;
                                        var NewValue:Double;
                                        var CanChange:Boolean);override;
  end;















  //加载图片+加载文字
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinPullLoadPanelDefaultMaterial=class(TSkinPullLoadPanelBasicMaterial)
  private
    //正在加载
    FLoadingCaption:String;
    //松开加载
    FDecidedLoadCaption:String;
    //下拉加载
    FUnDecidedLoadCaption:String;

    FLoadingStopCaption: String;

  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published

    /// <summary>
    ///   <para>
    ///     正在加载
    ///   </para>
    ///   <para>
    ///     Loading
    ///   </para>
    /// </summary>
    property LoadingCaption:String read FLoadingCaption write FLoadingCaption;

    /// <summary>
    ///   <para>
    ///     松开加载
    ///   </para>
    ///   <para>
    ///     Undo load
    ///   </para>
    /// </summary>
    property DecidedLoadCaption:String read FDecidedLoadCaption write FDecidedLoadCaption;

    /// <summary>
    ///   <para>
    ///     下拉加载
    ///   </para>
    ///   <para>
    ///     Pulldown load
    ///   </para>
    /// </summary>
    property UnDecidedLoadCaption:String read FUnDecidedLoadCaption write FUnDecidedLoadCaption;
    /// <summary>
    ///   <para>
    ///     加载结束
    ///   </para>
    ///   <para>
    ///     Stop loading
    ///   </para>
    /// </summary>
    property LoadingStopCaption:String read FLoadingStopCaption write FLoadingStopCaption stored False;
  end;
  TSkinPullLoadPanelDefaultType=class(TSkinPullLoadPanelBasicType)
  private
    function GetSkinMaterial:TSkinPullLoadPanelDefaultMaterial;
  public
    procedure DoOverRangePosValueChange(Sender:TObject;
                                        AScrollBarKind:TScrollBarKind;
                                        IsUserDraging:Boolean;
                                        PositionValue:Double;
                                        NextPositionValue:Double;
                                        LastPositionValue:Double;
                                        NextValue:Double;
                                        LastValue:Double;
                                        Step:Double;
                                        var NewValue:Double;
                                        var CanChange:Boolean);override;
  end;









  //加载图片+加载文字
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinPullLoadPanelDefaultProMaterial=class(TSkinPullLoadPanelDefaultMaterial)
  end;
  TSkinPullLoadPanelDefaultProType=class(TSkinPullLoadPanelDefaultType)
  private
    aniImgSyncFlagRotate: TSkinAnimator;
    procedure DoaniImgSyncFlagRotateAnimate(Sender: TObject);
    function GetSkinMaterial:TSkinPullLoadPanelDefaultProMaterial;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    procedure DoOverRangePosValueChange(Sender:TObject;
                                        AScrollBarKind:TScrollBarKind;
                                        IsUserDraging:Boolean;
                                        PositionValue:Double;
                                        NextPositionValue:Double;
                                        LastPositionValue:Double;
                                        NextValue:Double;
                                        LastValue:Double;
                                        Step:Double;
                                        var NewValue:Double;
                                        var CanChange:Boolean);override;
  end;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinPullLoadPanel=class(TBaseSkinControl,ISkinPullLoadPanel)
  private
    function GetPullLoadPanelProperties:TPullLoadPanelProperties;
    procedure SetPullLoadPanelProperties(Value:TPullLoadPanelProperties);
  protected
    FOnExecuteLoad:TNotifyEvent;
    FOnThreadExecuteLoad:TNotifyEvent;
    FOnThreadLoadFinished:TNotifyEvent;
    function GetOnExecuteLoad:TNotifyEvent;
    function GetOnThreadExecuteLoad:TNotifyEvent;
    function GetOnThreadLoadFinished:TNotifyEvent;

//    procedure SetControlGestureManager(Value:TSkinControlGestureManager);
  protected
    procedure Loaded;override;
    //通知
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    function SelfOwnMaterialToDefault:TSkinPullLoadPanelDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinPullLoadPanelDefaultMaterial;
    function Material:TSkinPullLoadPanelDefaultMaterial;
  public
    property Prop:TPullLoadPanelProperties read GetPullLoadPanelProperties write SetPullLoadPanelProperties;
  published
    //执行加载事件
    property OnExecuteLoad:TNotifyEvent read GetOnExecuteLoad write FOnExecuteLoad;
    //在线程中执行加载事件
    property OnThreadExecuteLoad:TNotifyEvent read GetOnThreadExecuteLoad write FOnThreadExecuteLoad;
    //加载结束事件
    property OnThreadLoadFinished:TNotifyEvent read GetOnThreadLoadFinished write FOnThreadLoadFinished;
    //属性
    property Properties:TPullLoadPanelProperties read GetPullLoadPanelProperties write SetPullLoadPanelProperties;
  end;


  TSkinChildPullLoadPanel=TSkinPullLoadPanel;//{$IFDEF VCL}TSkinWinPullLoadPanel{$ENDIF}{$IFDEF FMX}TSkinFMXPullLoadPanel{$ENDIF};


  {$IFDEF VCL}
  TSkinWinPullLoadPanel=class(TSkinPullLoadPanel)
  end;
  {$ENDIF VCL}




implementation


{ TSkinPullLoadPanelType }

function TSkinPullLoadPanelType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinPullLoadPanel,Self.FSkinPullLoadPanelIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinPullLoadPanel Interface');
    end;
  end;
end;

procedure TSkinPullLoadPanelType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinPullLoadPanelIntf:=nil;
end;

procedure TSkinPullLoadPanelType.DoOverRangePosValueChange(Sender:TObject;
                                                          AScrollBarKind:TScrollBarKind;
                                                          IsUserDraging:Boolean;
                                                          PositionValue:Double;
                                                          NextPositionValue:Double;
                                                          LastPositionValue:Double;
                                                          NextValue:Double;
                                                          LastValue:Double;
                                                          Step:Double;
                                                          var NewValue:Double;
                                                          var CanChange:Boolean);
begin

  //要放在首位
  //松开鼠标,保持最小的位置,并停止回滚到初始
  if not (IsUserDraging) then
  begin



      //在刷新的时候松开鼠标,保持最小的位置,停止回滚到初始
      if Self.FSkinPullLoadPanelIntf.Prop.FIsLoading
        //并且当前不是结束刷新回滚
        and not Self.FSkinPullLoadPanelIntf.Prop.FIsStopLoading
         then
      begin

        //准备加载停止的最小位置
        if (PositionValue<=Self.FSkinPullLoadPanelIntf.Prop.CalcWaitLoadingStopMinPosition(AScrollBarKind)) then
        begin

            if Not Self.FSkinPullLoadPanelIntf.Prop.FIsFirstDropAndStay then
            begin
                //第一次滑动释放而保持位置
                Self.FSkinPullLoadPanelIntf.Prop.FIsFirstDropAndStay:=True;

                //只需要弹回来的时候保持一下就可以了
                PositionValue:=Self.FSkinPullLoadPanelIntf.Prop.CalcWaitLoadingStopMinPosition(AScrollBarKind);

                //计算出合理位置
                if (NextPositionValue<=Self.FSkinPullLoadPanelIntf.Prop.CalcWaitLoadingStopMinPosition(AScrollBarKind))
                  and (PositionValue>=Self.FSkinPullLoadPanelIntf.Prop.CalcWaitLoadingStopMinPosition(AScrollBarKind)) then
                begin
                  NewValue:=Self.FSkinPullLoadPanelIntf.Prop.CalcWaitLoadingStopMinPosition(AScrollBarKind)/Step+2;
                end;

  //              CanChange:=False;

            end;

            uBaseLog.OutputDebugString('PullLoadPanel PositionValue '+FloatToStr(PositionValue));

            //停止回滚到初始
            Self.FSkinPullLoadPanelIntf.Prop.FControlGestureManager.ScrollingToInitialAnimator.Pause;

        end;

      end;


  end;





  //设置加载面板的位置
  //随着用户拖动而改变
  case Self.FSkinPullLoadPanelIntf.Prop.FLoadPanelType of
    sborlptTop:
    begin
      //-2是为了避免挡往顶部分隔线
      Self.FSkinControlIntf.Top:=ControlSize(PositionValue-Self.FSkinControlIntf.Height)-2;
    end;
    sborlptBottom:
    begin
      Self.FSkinControlIntf.Top:=ControlSize(TControl(Self.FSkinControlIntf.Parent).Height
                                              -PositionValue);
    end;
  end;
  //加载面板需要水平居中
  Self.FSkinControlIntf.Left:=
                                  ControlSize(

                                      (TControl(Self.FSkinControlIntf.Parent).Width
                                      -FSkinControlIntf.Width) / 2
                                      )
                                      ;
  Self.FSkinControlIntf.Visible:=True;
//  Self.FSkinControl.BringToFront;
//  uBaseLog.OutputDebugString('Top '+FloatToStr(Self.FSkinControlIntf.Top));




  //在下拉刷新的过程中要设置滚动图片为显示
  //如果在刷新结束时则不需要
  if not Self.FSkinPullLoadPanelIntf.Prop.FIsStopLoading then
  begin
    if Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf<>nil then
    begin
      Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf.Visible:=True;
    end;
  end;




  //用户松开手指,并且大于可以刷新的距离,那就开始加载
  if (Not IsUserDraging) then
  begin

      //用户松开手指状态,并且大于可以刷新的距离
      if (LastPositionValue>=Self.FSkinPullLoadPanelIntf.Prop.CalcDecideStartLoadPosition(AScrollBarKind)) then
      begin


          if Not Self.FSkinPullLoadPanelIntf.Prop.FIsLoading
            and Not Self.FSkinPullLoadPanelIntf.Prop.FIsStopLoading then
          begin
              uBaseLog.OutputDebugString('DoExecuteLoad');
              //那就开始加载
              if Self.FSkinPullLoadPanelIntf.Prop.DoExecuteLoad then
              begin
              end;

          end;

      end;
  end;


end;

function TSkinPullLoadPanelType.GetSkinMaterial: TSkinPullLoadPanelMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinPullLoadPanelMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinPullLoadPanelType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin
  //设计时绘制虚线框和控件名称
  if (csDesigning in Self.FSkinControl.ComponentState) then
  begin
    ACanvas.DrawDesigningRect(ADrawRect,GlobalPullLoadPanelDesignRectBorderColor);
  end;
end;


{ TPullLoadPanelProperties }


procedure TPullLoadPanelProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;

function TPullLoadPanelProperties.CalcDecideStartLoadPosition(AScrollBarKind:TScrollBarKind): Double;
begin
  //图片的高度
//  Result:=0;
//  if (Self.FSkinPullLoadPanelIntf.Prop.FLoadingImage<>nil)
//    and not Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf.Prop.Picture.CurrentPictureIsEmpty then
//  begin
//    Result:=Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf.Prop.Picture.CurrentPictureHeight;
//  end;
//  if Result>Self.FSkinControlIntf.Height then
//  begin
    Result:=Self.FSkinControlIntf.Height;
//  end;
end;

function TPullLoadPanelProperties.CalcLoadingImageBeginRotatePosition(AScrollBarKind:TScrollBarKind): Double;
begin
  //图片的高度
//  Result:=0;
//  if (Self.FSkinPullLoadPanelIntf.Prop.FLoadingImage<>nil)
//    and not Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf.Prop.Picture.CurrentPictureIsEmpty then
//  begin
//    Result:=Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf.Prop.Picture.CurrentPictureHeight;
//  end;
//  if Result>Self.FSkinControlIntf.Height then
//  begin
    Result:=Self.FSkinControlIntf.Height;
//  end;

end;

function TPullLoadPanelProperties.CalcLoadingImageStopBiggerPosition(AScrollBarKind:TScrollBarKind): Double;
begin
//  //图片的高度
//  Result:=0;
//  if (Self.FSkinPullLoadPanelIntf.Prop.FLoadingImage<>nil)
//    and not Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf.Prop.Picture.CurrentPictureIsEmpty then
//  begin
//    Result:=Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf.Prop.Picture.CurrentPictureHeight;
//  end;
//  if Result>Self.FSkinControlIntf.Height then
//  begin
    Result:=Self.FSkinControlIntf.Height;
//  end;
end;

function TPullLoadPanelProperties.CalcPosition(AScrollBarKind:TScrollBarKind;SettingPosition, ImageHeightInc: Integer): Double;
begin
  Result:=SettingPosition;
  case Ceil(Result) of
    -1:
    begin
      //Panel的高度
      Result:=Self.FSkinControlIntf.Height;
    end;
    0:
    begin
      //图片的高度
//      Result:=0;
//      if (Self.FSkinPullLoadPanelIntf.Prop.FLoadingImage<>nil)
//        and not Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf.Prop.Picture.CurrentPictureIsEmpty then
//      begin
//        Result:=Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf.Prop.Picture.CurrentPictureHeight
//          +ImageHeightInc;
//      end;
//      if Result>Self.FSkinControlIntf.Height then
//      begin
        Result:=Self.FSkinControlIntf.Height;
//      end;
    end;
  end;
end;

function TPullLoadPanelProperties.CalcWaitLoadingStopMinPosition(AScrollBarKind:TScrollBarKind): Double;
begin
//  //图片的高度
//  Result:=0;
//  if (Self.FSkinPullLoadPanelIntf.Prop.FLoadingImage<>nil)
//    and not Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf.Prop.Picture.CurrentPictureIsEmpty then
//  begin
//    Result:=Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf.Prop.Picture.CurrentPictureHeight;
//  end;
//  if Result>Self.FSkinControlIntf.Height then
//  begin
    Result:=Self.FSkinControlIntf.Height;
//  end;
end;

constructor TPullLoadPanelProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinPullLoadPanel,Self.FSkinPullLoadPanelIntf) then
  begin
    ShowException('This Component Do not Support ISkinPullLoadPanel Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=200;
    Self.FSkinControlIntf.Height:=100;

//    Self.FDecideStartLoadPosition:=0;
//    Self.FWaitLoadingStopMinPosition:=0;

    FCanNextLoadDelayTimeSpace:=100;//2000;//1000;
    FLastLoadStopTime:=0;

//    FLoadPanelType:=sborlptNone;
  end;
end;

procedure TPullLoadPanelProperties.DesignTimeResotorePanel;
begin
  if Self.FIsDesignTimeStored then
  begin
    Self.FSkinControlIntf.Top:=ControlSize(FDesignTimeTop);
    Self.FSkinControlIntf.Height:=ControlSize(FDesignTimeHeight);
    FIsDesignTimeStored:=False;
  end;
end;

procedure TPullLoadPanelProperties.DesignTimeStorePanel;
begin
  FDesignTimeTop:=Self.FSkinControlIntf.Top;
  FDesignTimeHeight:=Self.FSkinControlIntf.Height;
  FIsDesignTimeStored:=True;
end;

destructor TPullLoadPanelProperties.Destroy;
begin
  inherited;
end;

procedure TPullLoadPanelProperties.DoOverRangePosValueChange(Sender:TObject;
                                        AScrollBarKind:TScrollBarKind;
                                        IsUserDraging:Boolean;
                                        PositionValue:Double;
                                        NextPositionValue:Double;
                                        LastPositionValue:Double;
                                        NextValue:Double;
                                        LastValue:Double;
                                        Step:Double;
                                        var NewValue:Double;
                                        var CanChange:Boolean);
begin

  if not Self.FIsDesignTimeStored then
  begin
    //先在设计时保存加载面板的位置
    Self.DesignTimeStorePanel;
  end;
  if (Self.FSkinControlIntf.GetSkinControlType<>nil) then
  begin
    TSkinPullLoadPanelType(FSkinControlIntf.GetSkinControlType).
                            DoOverRangePosValueChange(Self,
                                                      AScrollBarKind,
                                                      IsUserDraging,
                                                      PositionValue,
                                                      NextPositionValue,
                                                      LastPositionValue,
                                                      NextValue,
                                                      LastValue,
                                                      Step,
                                                      NewValue,
                                                      CanChange);
  end;
end;

procedure TPullLoadPanelProperties.DoScrollingToInitialEnd;
begin

  if Self.FLoadingImage<>nil then
  begin
    Self.FLoadingImageIntf.Prop.Rotated:=False;
  end;

  if Self.FDecideLoadHintImage<>nil then
  begin
    Self.FDecideLoadHintImageIntf.Prop.Rotated:=False;
  end;


  //还原
  Self.DesignTimeResotorePanel;


  //运行时隐藏
  //自动创建的不显示
  if not (csDesigning in Self.FSkinControl.ComponentState)
    {$IFDEF FMX}
    or Not Self.FSkinControl.Stored
    {$ENDIF}
    then
  begin
    Self.FSkinControlIntf.Visible:=False;
  end;


  if FIsStopLoading then
  begin
    Self.FIsLoading:=False;

    FIsStopLoading:=False;
    FLastLoadStopTime:=Now;

  end;



end;

procedure TPullLoadPanelProperties.DoThreadExecuteLoad(ATimerTask: TObject);
begin
  if Assigned(Self.FSkinPullLoadPanelIntf.OnThreadExecuteLoad) then
  begin
    //线程加载
    Self.FSkinPullLoadPanelIntf.OnThreadExecuteLoad(ATimerTask);
  end;
end;

procedure TPullLoadPanelProperties.DoThreadExecuteLoadEnd(ATimerTask: TObject);
begin
  if Assigned(Self.FSkinPullLoadPanelIntf.OnThreadLoadFinished) then
  begin
    //线程加载结束
    Self.FSkinPullLoadPanelIntf.OnThreadLoadFinished(ATimerTask);
  end;

  Self.StopLoad;
end;

procedure TPullLoadPanelProperties.DoDesigningExecuteLoad(ATimerTask: TObject);
begin
  //设计时加载5秒延迟
  Sleep(3000);
end;

procedure TPullLoadPanelProperties.DoDesigningExecuteLoadEnd(ATimerTask: TObject);
begin
  Self.StopLoad;
end;

function TPullLoadPanelProperties.DoExecuteLoad:Boolean;
var
  ATimerTask:TTimerTask;
begin
  Result:=False;

//  if DateUtils.MilliSecondsBetween(FLastLoadStopTime,Now)<FCanNextLoadDelayTimeSpace then
//  begin
//    OutputDebugString('---------------------间隔太短,不加载'+DateTimeToStr(Now));
//    //间隔太短,不加载
//    Exit;
//  end;

//  OutputDebugString('---------------------开始加载DoExecuteLoad'+DateTimeToStr(Now));



  Result:=True;

  FIsStopLoading:=False;
  Self.FIsLoading:=True;

  try

    if csDesigning in Self.FSkinControl.ComponentState then
    begin
        //设计时
        //设计时模拟刷新
        ATimerTask:=TTimerTask.Create(0);
        ATimerTask.OnExecute:=DoDesigningExecuteLoad;
        ATimerTask.OnExecuteEnd:=DoDesigningExecuteLoadEnd;
        GetGlobalTimerThread.RunTask(ATimerTask);

    end
    else
    begin
        if Assigned(Self.FSkinPullLoadPanelIntf.OnExecuteLoad) then
        begin
          //运行时加载
          Self.FSkinPullLoadPanelIntf.OnExecuteLoad(Self);
        end
        else
        begin

          //线程中加载
          if Assigned(Self.FSkinPullLoadPanelIntf.OnThreadExecuteLoad) then
          begin
            ATimerTask:=TTimerTask.Create(0);
            ATimerTask.OnExecute:=DoThreadExecuteLoad;
            ATimerTask.OnExecuteEnd:=DoThreadExecuteLoadEnd;
            GetGlobalTimerThread.RunTask(ATimerTask);
          end;

        end;
    end;
  except
    on E:Exception do
    begin
      uBaseLog.HandleException(E,'OrangeUIControl','uSkinPullLoadPanelType','TPullLoadPanelProperties.DoExecuteLoad');
    end;
  end;
end;

procedure TPullLoadPanelProperties.DoDragingStateChange(Sender:TObject;
                                                        AScrollBarKind:TScrollBarKind;
                                                        IsUserDraging:Boolean;
                                                        PositionValue:Double);
begin
  if not IsUserDraging then
  begin

      //用户松开手指状态,并且大于可以刷新的距离
      if (PositionValue>=Self.CalcDecideStartLoadPosition(AScrollBarKind)) then
      begin
        //再次释放的时候,第一次需要保持固定的位置
        Self.FIsFirstDropAndStay:=False;
      end;

  end;
end;

function TPullLoadPanelProperties.GetComponentClassify: String;
begin
  Result:='SkinPullLoadPanel';
end;

procedure TPullLoadPanelProperties.SetLoadingImage(const Value: TChildControl);
begin
  if FLoadingImage<>Value then
  begin
    if FLoadingImage<>nil then
    begin
      RemoveFreeNotification(FLoadingImage,Self.FSkinControl);

      FLoadingImageIntf:=nil;
      FLoadingImageControlIntf:=nil;
      FLoadingImage:=nil;
    end;


    if Value<>nil then
    begin
      if Not Value.GetInterface(IID_ISkinImage,Self.FLoadingImageIntf) then
      begin
        ShowException('This Component Do not Support ISkinImage Interface');
      end
      else
      begin
        if Not Value.GetInterface(IID_ISkinControl,Self.FLoadingImageControlIntf) then
        begin
          ShowException('This Component Do not Support ISkinControl Interface');
        end
        else
        begin
          FLoadingImage:=Value;
          AddFreeNotification(FLoadingImage,Self.FSkinControl);
        end;
      end;
    end
    else
    begin
      FLoadingImage := nil;
      FLoadingImageIntf := nil;
      FLoadingImageControlIntf := nil;
    end;
  end;
end;

procedure TPullLoadPanelProperties.SetDecideLoadHintImage(const Value: TChildControl);
begin
  if FDecideLoadHintImage<>Value then
  begin

    if FDecideLoadHintImage<>nil then
    begin
        RemoveFreeNotification(FDecideLoadHintImage,Self.FSkinControl);

        FDecideLoadHintImage := nil;
        FDecideLoadHintImageIntf := nil;
        FDecideLoadHintImageControlIntf := nil;

    end;


    if Value<>nil then
    begin
      if Not Value.GetInterface(IID_ISkinImage,Self.FDecideLoadHintImageIntf) then
      begin
        ShowException('This Component Do not Support ISkinImage Interface');
      end
      else
      begin
        if Not Value.GetInterface(IID_ISkinControl,Self.FDecideLoadHintImageControlIntf) then
        begin
          ShowException('This Component Do not Support ISkinControl Interface');
        end
        else
        begin
          FDecideLoadHintImage:=Value;
          AddFreeNotification(FDecideLoadHintImage,Self.FSkinControl);
        end;
      end;
    end
    else
    begin
      FDecideLoadHintImage := nil;
      FDecideLoadHintImageIntf := nil;
      FDecideLoadHintImageControlIntf := nil;
    end;
  end;
end;

procedure TPullLoadPanelProperties.SetLoadingLabel(const Value: TChildControl);
begin
  if FLoadingLabel<>Value then
  begin

    if FLoadingLabel<>nil then
    begin
        RemoveFreeNotification(FLoadingLabel,Self.FSkinControl);
        FLoadingLabel := nil;
        FLoadingLabelIntf := nil;
        FLoadingLabelControlIntf := nil;

    end;


    if Value<>nil then
    begin
      if Not Value.GetInterface(IID_ISkinLabel,Self.FLoadingLabelIntf) then
      begin
        ShowException('This Component Do not Support ISkinLabel Interface');
      end
      else
      begin
        if Not Value.GetInterface(IID_ISkinControl,Self.FLoadingLabelControlIntf) then
        begin
          ShowException('This Component Do not Support ISkinControl Interface');
        end
        else
        begin
          FLoadingLabel:=Value;
          AddFreeNotification(FLoadingLabel,Self.FSkinControl);
        end;
      end;
    end
    else
    begin
      FLoadingLabel := nil;
      FLoadingLabelIntf := nil;
      FLoadingLabelControlIntf := nil;
    end;
  end;
end;

procedure TPullLoadPanelProperties.StartLoad(AScrollBarKind:TScrollBarKind);
begin

  //暂停返回到初始
  //StopLoad里面,有一个等待时间
  FWaitHintTime:=0;

  //等待停止刷新结束

//  //先等待,展示一段时间,
//  while FControlGestureManager.ScrollingToInitialAnimator.IsRuning do
//  begin
//    Application.ProcessMessages;
//  end;



  //松开
  FIsFirstDropAndStay:=False;

  if FControlGestureManager<>nil then
  begin


      //停止滚动到初始
      Self.FControlGestureManager.ScrollingToInitialAnimator.Stop;



      case FLoadPanelType of
        sborlptTop:
        begin
            //静态设置越界值
            Self.FControlGestureManager.StaticPosition:=Self.FControlGestureManager.Min;
            Self.FControlGestureManager.StaticMinOverRangePosValue:=
                            (Self.CalcDecideStartLoadPosition(AScrollBarKind)*4)
                            /Self.FControlGestureManager.FOverRangePosValueStep;
        end;
        sborlptBottom:
        begin
            //静态设置越界值
            Self.FControlGestureManager.StaticPosition:=Self.FControlGestureManager.Max;
            Self.FControlGestureManager.StaticMaxOverRangePosValue:=
                            (Self.CalcDecideStartLoadPosition(AScrollBarKind)*4)
                            /Self.FControlGestureManager.FOverRangePosValueStep;
        end;
      end;
      //滚回初始,开始加载
      Self.FControlGestureManager.StartScrollToInitial;
  end;
end;

procedure TPullLoadPanelProperties.StopLoad(const ALoadingStopCaption:String;const AWaitHintTime:Integer;const AHasLoadMoreDataNeedScroll:Boolean);
var
  ATicket:Cardinal;
begin
//      OutputDebugString('----------------------调用StopLoad');
    FIsStopLoading:=True;
    FWaitHintTime:=AWaitHintTime;


    //设置加载成功的标题
    if FLoadingLabelIntf<>nil then
    begin
      Self.FLoadingLabelIntf.Caption:=Trans(ALoadingStopCaption);
    end;

    //停止滚动
    if Self.FLoadingImage<>nil then
    begin
      Self.FLoadingImageIntf.Prop.Rotated:=False;
      Self.FLoadingImageControlIntf.Visible:=False;
    end;


    if FWaitHintTime>0 then
    begin

      //先等待,展示一段时间,
      ATicket:=UIGetTickCount;
      while (UIGetTickCount-ATicket<FWaitHintTime) do
      begin
        Application.ProcessMessages;
      end;

    end;


    if FControlGestureManager<> nil then
    begin



        //加载结束
        if (Self.FLoadPanelType=sborlptTop) then
        begin
              //启动回滚初始
              //恢复回滚

              //再回滚
              Self.FControlGestureManager.ScrollingToInitialAnimator.Continue;

        end
        else if Not AHasLoadMoreDataNeedScroll then
        begin

              //没有加载到更多数据
              //再回滚
              Self.FControlGestureManager.ScrollingToInitialAnimator.Continue;

        end
        else
        begin
              if (Self.FLoadPanelType=sborlptBottom) and AHasLoadMoreDataNeedScroll then
              begin
                  //如果是加载更多的面板,
                  //如果加载到了更多的数据
                  //那么不需要滚动回初始,
                  //而是继续向下滚动
                  Self.FControlGestureManager.StaticMaxOverRangePosValue:=0;
                  DoScrollingToInitialEnd;
                  Self.FControlGestureManager.DoInertiaScroll(700);
              end;
        end;
    end;

end;



{ TSkinPullLoadPanelBasicType }

procedure TSkinPullLoadPanelBasicType.DoOverRangePosValueChange(Sender:TObject;
                                        AScrollBarKind:TScrollBarKind;
                                        IsUserDraging:Boolean;
                                        PositionValue:Double;
                                        NextPositionValue:Double;
                                        LastPositionValue:Double;
                                        NextValue:Double;
                                        LastValue:Double;
                                        Step:Double;
                                        var NewValue:Double;
                                        var CanChange:Boolean);
begin

      Inherited;







      //当前未在加载中,启用加载图片放大缩小的效果

      //启用加载图片放大的效果
      if GetSkinMaterial.FEnableLoadingImageBiggerEffect
        and (Self.FSkinPullLoadPanelIntf.Prop.FLoadingImage<>nil) then
      begin
          //加载图片停止变大的位置
          if (PositionValue<Self.FSkinPullLoadPanelIntf.Prop.CalcLoadingImageStopBiggerPosition(AScrollBarKind)) then
          begin
            //慢慢移下来,加载图片变大,慢慢变大或变小
            Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf.Width:=ControlSize(PositionValue);
            Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf.Height:=ControlSize(PositionValue);
          end
          else
          begin
            //加载图片已达最大状态,停止变大
            Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf.Width:=ControlSize(Self.FSkinPullLoadPanelIntf.Prop.CalcLoadingImageStopBiggerPosition(AScrollBarKind));
            Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf.Height:=ControlSize(Self.FSkinPullLoadPanelIntf.Prop.CalcLoadingImageStopBiggerPosition(AScrollBarKind));
          end;

      end;









      //自动排列位置(图片居中)
      if GetSkinMaterial.FEnableAutoCenterPosition  then
      begin
          if (Self.FSkinPullLoadPanelIntf.Prop.FLoadingImage<>nil) then
          begin

                  //图片垂直居中
                  Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf.Top:=ControlSize(
                          (Self.FSkinControlIntf.Height
                            -Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf.Height) / 2);



                  //只有图片没有文字
                  if (Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabel=nil) then
                  begin
                      //图片水平居中
                      Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf.Left:=ControlSize(
                              (Self.FSkinControlIntf.Width
                                -Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf.Width) / 2);
                  end
                  else
                  //有图片有文字
                  begin
                      //加载图片水平居中
                      Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf.Left:=ControlSize(
                        (Self.FSkinControlIntf.Width
                          -Self.FSkinPullLoadPanelIntf.Prop.CalcPosition(AScrollBarKind,Self.GetSkinMaterial.FLoadingImageStopBiggerPosition,0)
                          -Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabelControlIntf.Width) / 2
                          +(Self.FSkinPullLoadPanelIntf.Prop.CalcPosition(AScrollBarKind,Self.GetSkinMaterial.FLoadingImageStopBiggerPosition,0)
                            -Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf.Width) / 2
                            );

                      //加载文字水平居中
                      if (Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabel<>nil) then
                      begin
                        Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabelControlIntf.Left:=ControlSize(
                              (Self.FSkinControlIntf.Width
                              -Self.FSkinPullLoadPanelIntf.Prop.CalcPosition(AScrollBarKind,Self.GetSkinMaterial.FLoadingImageStopBiggerPosition,0)
                              -Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabelControlIntf.Width) / 2
                              +Self.FSkinPullLoadPanelIntf.Prop.CalcPosition(AScrollBarKind,Self.GetSkinMaterial.FLoadingImageStopBiggerPosition,0));
                      end;

                  end;
          end
          else
          begin
                  //只有文本没有图片
                  //文字垂直居中
                  Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabelControlIntf.Top:=ControlSize(
                          (Self.FSkinControlIntf.Height
                            -Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabelControlIntf.Height) / 2);

                  //文字水平居中
                  Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabelControlIntf.Left:=ControlSize(
                          (Self.FSkinControlIntf.Width
                            -Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabelControlIntf.Width) / 2);
          end;



      end;








      //图片旋转
      if (IsUserDraging) then
      begin
          //用户正在拖动

          //启用加载图片旋转
          if GetSkinMaterial.FEnableLoadingImageRotateEffect and (Self.FSkinPullLoadPanelIntf.Prop.FLoadingImage<>nil) then
          begin
            //加载图片开始旋转的位置
            if (PositionValue>Self.FSkinPullLoadPanelIntf.Prop.CalcLoadingImageBeginRotatePosition(AScrollBarKind)) then
            begin
              //大于允许旋转的位置,开始旋转
              Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf.Prop.Rotated:=True;
            end
            else
            begin
              //小于允许旋转的位置,停止旋转
              Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf.Prop.Rotated:=False;
            end;
          end;

      end
      else
      begin
          //用户松开手指
          if Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf<>nil then
          begin
            //加载的时候旋一直旋转
            Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageIntf.Prop.Rotated:=
                          Self.FSkinPullLoadPanelIntf.Prop.FIsLoading
                          and not Self.FSkinPullLoadPanelIntf.Prop.FIsStopLoading;
          end;

      end;

end;

function TSkinPullLoadPanelBasicType.GetSkinMaterial: TSkinPullLoadPanelBasicMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinPullLoadPanelBasicMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;




{ TSkinPullLoadPanelBasicMaterial }

constructor TSkinPullLoadPanelBasicMaterial.Create(AOwner: TComponent);
begin
  inherited;

  FIndicatorColor:=BlackColor;

//  FEnableAutoCenterPosition:=True;

  FEnableLoadingImageBiggerEffect:=False;
  FEnableLoadingImageRotateEffect:=True;//False;//



  //-1:使用Panel控件的高度
  //0:使用图片的原始大小
  //**:使用设置的值
//  FLoadingImageStopBiggerPosition:=0;//使用图片的原始大小;
//  FLoadingImageBeginRotatePosition:=0;//使用图片的原始大小;

  FLoadingPicture:=CreateDrawPicture('LoadingPicture','正在加载的图片');

  FDrawLoadingCaptionParam:=CreateDrawTextParam('DrawLoadingCaptionParam','正在加载标题的绘制参数');

end;


destructor TSkinPullLoadPanelBasicMaterial.Destroy;
begin
  FreeAndNil(FAutoCreatedIndicatorImageList);

  FreeAndNil(FLoadingPicture);
  FreeAndNil(FDrawLoadingCaptionParam);
  inherited;
end;

procedure TSkinPullLoadPanelBasicMaterial.SetDrawLoadingCaptionParam(const Value: TDrawTextParam);
begin
  FDrawLoadingCaptionParam.Assign(Value);
end;

procedure TSkinPullLoadPanelBasicMaterial.SetIndicatorColor(const Value: TDelphiColor);
begin
  if FIndicatorColor<>Value then
  begin
    FIndicatorColor := Value;

    FreeAndNil(FAutoCreatedIndicatorImageList);
  end;
end;

procedure TSkinPullLoadPanelBasicMaterial.SetLoadingPicture(const Value: TDrawPicture);
begin
  FLoadingPicture.Assign(Value);
end;

{ TSkinPullLoadPanelDefaultType }

procedure TSkinPullLoadPanelDefaultType.DoOverRangePosValueChange(Sender:TObject;
                                        AScrollBarKind:TScrollBarKind;
                                        IsUserDraging:Boolean;
                                        PositionValue:Double;
                                        NextPositionValue:Double;
                                        LastPositionValue:Double;
                                        NextValue:Double;
                                        LastValue:Double;
                                        Step:Double;
                                        var NewValue:Double;
                                        var CanChange:Boolean);
begin

  Inherited;




  //设置标题
  if (IsUserDraging) then
  begin
      //用户正在拖动
      //拖动的时候不执行刷新


      //用户松开手指状态,并且大于可以刷新的距离
      if Not (Self.FSkinPullLoadPanelIntf.Prop.FIsLoading
              or Self.FSkinPullLoadPanelIntf.Prop.FIsStopLoading)
        and (Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabel<>nil) then
      begin
          if (PositionValue>=Self.FSkinPullLoadPanelIntf.Prop.CalcDecideStartLoadPosition(AScrollBarKind)) then
          begin
            //松开加载
            Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabelIntf.Caption:=Trans(Self.GetSkinMaterial.FDecidedLoadCaption);
          end
          else
          begin
            //下拉加载
            Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabelIntf.Caption:=Trans(Self.GetSkinMaterial.FUnDecidedLoadCaption);
          end;
      end;


  end
  else
  begin
      //用户松开手指
      //并且刷新没有结束
      if Not Self.FSkinPullLoadPanelIntf.Prop.FIsStopLoading then
      begin
          if (Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabel<>nil) then
          begin
              if Self.FSkinPullLoadPanelIntf.Prop.FIsLoading then
              begin
                //正在加载
                Self.FSkinPullLoadPanelIntf.Prop.FLoadingLabelIntf.Caption:=Trans(Self.GetSkinMaterial.FLoadingCaption);
              end;
          end;
      end;



  end;

end;

function TSkinPullLoadPanelDefaultType.GetSkinMaterial: TSkinPullLoadPanelDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinPullLoadPanelDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

{ TSkinPullLoadPanelDefaultMaterial }

constructor TSkinPullLoadPanelDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited;

  FLoadingCaption:=('正在刷新...');
//  FLoadingStopCaption:='刷新成功!';
  FDecidedLoadCaption:=('松开刷新');
  FUnDecidedLoadCaption:=('下拉刷新');

end;


destructor TSkinPullLoadPanelDefaultMaterial.Destroy;
begin

  inherited;
end;






{ TSkinPullLoadPanelDefaultProType }

constructor TSkinPullLoadPanelDefaultProType.Create(ASkinControl:TControl);
begin
  inherited;

  aniImgSyncFlagRotate:=TSkinAnimator.Create(nil);
  aniImgSyncFlagRotate.OnAnimate := DoaniImgSyncFlagRotateAnimate;
  aniImgSyncFlagRotate.Min := 0;
  aniImgSyncFlagRotate.Max := 180;
  aniImgSyncFlagRotate.Speed := 1;
  aniImgSyncFlagRotate.TweenType:= Cubic;
  aniImgSyncFlagRotate.EaseType := easeIn;
  aniImgSyncFlagRotate.EndTimesCount := 5;
  aniImgSyncFlagRotate.DirectionType := adtForward;

end;

procedure TSkinPullLoadPanelDefaultProType.DoaniImgSyncFlagRotateAnimate(Sender: TObject);
begin
  Self.FSkinPullLoadPanelIntf.Prop.FDecideLoadHintImageIntf.Prop.CurrentRotateAngle:=
    Ceil(Self.aniImgSyncFlagRotate.Position);
end;

destructor TSkinPullLoadPanelDefaultProType.Destroy;
begin
  FreeAndNil(aniImgSyncFlagRotate);
  inherited;
end;

procedure TSkinPullLoadPanelDefaultProType.DoOverRangePosValueChange(Sender:TObject;
                                        AScrollBarKind:TScrollBarKind;
                                        IsUserDraging:Boolean;
                                        PositionValue:Double;
                                        NextPositionValue:Double;
                                        LastPositionValue:Double;
                                        NextValue:Double;
                                        LastValue:Double;
                                        Step:Double;
                                        var NewValue:Double;
                                        var CanChange:Boolean);
begin

  Inherited;




  if (IsUserDraging) then
  begin
      //用户正在拖动



      //正在加载或加载刚结束,更改加载文字,用户松开手指状态,并且大于可以刷新的距离
      if Not (Self.FSkinPullLoadPanelIntf.Prop.FIsLoading
              or Self.FSkinPullLoadPanelIntf.Prop.FIsStopLoading) then
      begin

          //显示加载提示的图片
          if Self.FSkinPullLoadPanelIntf.Prop.FLoadingImage<>nil then
          begin
            Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf.Visible:=False;
          end;
          if Self.FSkinPullLoadPanelIntf.Prop.FDecideLoadHintImage<>nil then
          begin
            Self.FSkinPullLoadPanelIntf.Prop.FDecideLoadHintImageControlIntf.Visible:=True;
          end;


          if (PositionValue>=Self.FSkinPullLoadPanelIntf.Prop.CalcDecideStartLoadPosition(AScrollBarKind)) then
          begin
            if Self.FSkinPullLoadPanelIntf.Prop.FDecideLoadHintImage<>nil then
            begin
                //松开刷新提示图片旋转
                if Self.FSkinPullLoadPanelIntf.Prop.FDecideLoadHintImageIntf.Prop.CurrentRotateAngle=0 then
                begin
                  aniImgSyncFlagRotate.DirectionType:=adtForward;
                  aniImgSyncFlagRotate.Start;
                end;
            end;
          end
          else
          begin
            if Self.FSkinPullLoadPanelIntf.Prop.FDecideLoadHintImage<>nil then
            begin
                //下拉刷新提示图片旋转
                if Self.FSkinPullLoadPanelIntf.Prop.FDecideLoadHintImageIntf.Prop.CurrentRotateAngle=180 then
                begin
                  aniImgSyncFlagRotate.DirectionType:=adtBackward;
                  aniImgSyncFlagRotate.Start;
                end
                else
                begin

                end;
            end;
          end;

      end;


  end
  else
  begin
      //用户松开手指


      //隐藏加载提示图片
      if Self.FSkinPullLoadPanelIntf.Prop.FDecideLoadHintImage<>nil then
      begin
        Self.FSkinPullLoadPanelIntf.Prop.FDecideLoadHintImageControlIntf.Visible:=
          not (Self.FSkinPullLoadPanelIntf.Prop.FIsLoading
                    or Self.FSkinPullLoadPanelIntf.Prop.FIsStopLoading);
      end;

      //旋转(加载时和加载后旋转),显示正在加载图片
      if Self.FSkinPullLoadPanelIntf.Prop.FLoadingImage<>nil then
      begin
        Self.FSkinPullLoadPanelIntf.Prop.FLoadingImageControlIntf.Visible:=
                  Self.FSkinPullLoadPanelIntf.Prop.FIsLoading
                    or Self.FSkinPullLoadPanelIntf.Prop.FIsStopLoading;
      end;



  end;

end;

function TSkinPullLoadPanelDefaultProType.GetSkinMaterial: TSkinPullLoadPanelDefaultProMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinPullLoadPanelDefaultProMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;








{ TSkinPullLoadPanel }

procedure TSkinPullLoadPanel.Loaded;
begin
  Inherited;
  //运行时隐藏
  if not (csDesigning in Self.ComponentState) then
  begin
    Visible:=False;
  end;
end;
function TSkinPullLoadPanel.Material:TSkinPullLoadPanelDefaultMaterial;
begin
  Result:=TSkinPullLoadPanelDefaultMaterial(SelfOwnMaterial);
end;

function TSkinPullLoadPanel.SelfOwnMaterialToDefault:TSkinPullLoadPanelDefaultMaterial;
begin
  Result:=TSkinPullLoadPanelDefaultMaterial(SelfOwnMaterial);
end;

function TSkinPullLoadPanel.CurrentUseMaterialToDefault:TSkinPullLoadPanelDefaultMaterial;
begin
  Result:=TSkinPullLoadPanelDefaultMaterial(CurrentUseMaterial);
end;

function TSkinPullLoadPanel.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TPullLoadPanelProperties;
end;

function TSkinPullLoadPanel.GetPullLoadPanelProperties: TPullLoadPanelProperties;
begin
  Result:=TPullLoadPanelProperties(Self.FProperties);
end;

procedure TSkinPullLoadPanel.SetPullLoadPanelProperties(Value: TPullLoadPanelProperties);
begin
  Self.FProperties.Assign(Value);
end;

//procedure TSkinPullLoadPanel.SetControlGestureManager(Value:TSkinControlGestureManager);
//begin
//  Self.Prop.FControlGestureManager:=Value;
//end;

function TSkinPullLoadPanel.GetOnExecuteLoad:TNotifyEvent;
begin
  Result:=FOnExecuteLoad;
end;

function TSkinPullLoadPanel.GetOnThreadExecuteLoad:TNotifyEvent;
begin
  Result:=FOnThreadExecuteLoad;
end;

function TSkinPullLoadPanel.GetOnThreadLoadFinished:TNotifyEvent;
begin
  Result:=FOnThreadLoadFinished;
end;

procedure TSkinPullLoadPanel.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);
  if (Operation=opRemove) then
  begin
    if (Self.Properties<>nil) then
    begin
//    FLoadingLabelControlIntf: ISkinControl;
//    FLoadingImageControlIntf: ISkinControl;
//    FDecideLoadHintImageControlIntf: ISkinControl;
//    FLastLoadingInfoLabelControlIntf: ISkinControl;
      if (AComponent=Self.Properties.LoadingImage) then
      begin
        Self.Properties.LoadingImage:=nil;
      end;
      if (AComponent=Self.Properties.DecideLoadHintImage) then
      begin
        Self.Properties.DecideLoadHintImage:=nil;
      end;
      if (AComponent=Self.Properties.LoadingLabel) then
      begin
        Self.Properties.LoadingLabel:=nil;
      end;
//      if (AComponent=Self.Properties.LastLoadingInfoLabel) then
//      begin
//        Self.Properties.LastLoadingInfoLabel:=nil;
//      end;
    end
    ;
  end;
end;



end.


