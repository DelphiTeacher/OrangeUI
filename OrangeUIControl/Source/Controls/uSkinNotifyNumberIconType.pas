//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     提醒数字图标
///   </para>
///   <para>
///     NotifyNumber icon
///   </para>
/// </summary>
unit uSkinNotifyNumberIconType;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  uFuncCommon,
  Types,
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
  Variants,
  uBaseLog,
  uBaseList,
  uSkinItems,
  uDrawParam,
  uGraphicCommon,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uComponentType,
  uSkinButtonType,
  uDrawEngine,
  uDrawPicture,
  uSkinImageList,
  uDrawTextParam,
  uSkinRegManager,
  uDrawRectParam,
  uDrawPictureParam;



const
  IID_ISkinNotifyNumberIcon:TGUID='{632F7B49-7141-4FF6-B3E5-F4E7054C1BFA}';

type
  TNotifyNumberIconProperties=class;



  /// <summary>
  ///   <para>
  ///     提醒数字图标接口
  ///   </para>
  ///   <para>
  ///     Interface of NotifyNumber icon
  ///   </para>
  /// </summary>
  ISkinNotifyNumberIcon=Interface//(ISkinControl)
  ['{632F7B49-7141-4FF6-B3E5-F4E7054C1BFA}']

    //提醒图标属性
    function GetNotifyNumberIconProperties:TNotifyNumberIconProperties;
    property Properties:TNotifyNumberIconProperties read GetNotifyNumberIconProperties;
    property Prop:TNotifyNumberIconProperties read GetNotifyNumberIconProperties;
  end;





  /// <summary>
  ///   <para>
  ///     提醒数字图标显示类型
  ///   </para>
  ///   <para>
  ///     Show type of NotifyNumber icon
  ///   </para>
  /// </summary>
  TNotifyNumberIconShowType=(
                              /// <summary>
                              ///   <para>
                              ///     显示提醒数字
                              ///   </para>
                              ///   <para>
                              ///     Show NotifyNumber
                              ///   </para>
                              /// </summary>
                              nnistNumber,
                             /// <summary>
                             ///   <para>
                             ///     显示提醒图标
                             ///   </para>
                             ///   <para>
                             ///     Show NotifyIcon
                             ///   </para>
                             /// </summary>
                             nnistIcon,
                             nnistText
                             );


  /// <summary>
  ///   <para>
  ///     提醒数字图标属性
  ///   </para>
  ///   <para>
  ///     NotifyNumber icon property
  ///   </para>
  /// </summary>
  TNotifyNumberIconProperties=class(TBaseButtonProperties)
  protected
    //提醒数字
    FNumber: Double;
    //最大值
    FNumberMax:Double;
    //超出符号,99+
    FNumberExceedSymbol:Char;

    //提醒图标
    FNotifyIcon:TDrawPicture;

    //是否需要通知
    FNeedNotify:Boolean;
    //显示类型
    FShowType: TNotifyNumberIconShowType;

    //提醒图标接口
    FSkinNotifyNumberIconIntf:ISkinNotifyNumberIcon;

    //通知文本,支持文本
    FNotifyText: String;

    procedure SetNotifyText(const Value: String);

    function GetButtonIcon: TDrawPicture;
    function GetButtonPushedIcon: TDrawPicture;
    procedure SetNumber(const Value: Double);
    procedure SetNotifyIcon(const Value: TDrawPicture);
    procedure SetButtonIcon(const Value: TDrawPicture);
    procedure SetButtonPushedIcon(const Value: TDrawPicture);
    procedure SetNumberMax(const Value: Double);
    procedure SetNeedNotify(const Value: Boolean);
    procedure SetShowType(const Value: TNotifyNumberIconShowType);
    procedure SetNumberExceedSymbol(const Value: Char);
    function GetNumberText(const Value: Double):String;
  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //绘制事件
    OnInvalidate: TNotifyEvent;

    //是否寄生在别的控件里
    IsInHostControl:Boolean;

    //清除通知
    procedure ClearNotify;

    //获取分类名称
    function GetComponentClassify:String;override;
    //提醒数字
    property StaticNumber:Double read FNumber write FNumber;
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
  published

    /// <summary>
    ///   <para>
    ///     是否需要提醒
    ///   </para>
    ///   <para>
    ///     Whether need notify
    ///   </para>
    /// </summary>
    property NeedNotify:Boolean read FNeedNotify write SetNeedNotify;




    /// <summary>
    ///   <para>
    ///     提醒图标
    ///   </para>
    ///   <para>
    ///     NotifyIcon
    ///   </para>
    /// </summary>
    property Icon:TDrawPicture read FNotifyIcon write SetNotifyIcon;
    property ButtonIcon:TDrawPicture read GetButtonIcon write SetButtonIcon;
    property ButtonPushedIcon:TDrawPicture read GetButtonPushedIcon write SetButtonPushedIcon;



    /// <summary>
    ///   <para>
    ///     提醒数字
    ///   </para>
    ///   <para>
    ///     NotifyNumber
    ///   </para>
    /// </summary>
    property NotifyText:String read FNotifyText write SetNotifyText;
    property Number:Double read FNumber write SetNumber;

    /// <summary>
    ///   <para>
    ///     提醒数字的最大值
    ///   </para>
    ///   <para>
    ///     NotifyNumber max value
    ///   </para>
    /// </summary>
    property NumberMax:Double read FNumberMax write SetNumberMax;

    /// <summary>
    ///   <para>
    ///     提醒数字超出最大值时添加的符号
    ///   </para>
    ///   <para>
    ///     Symbol when NotifyNumber exceeds max value
    ///   </para>
    /// </summary>
    property NumberExceedSymbol:Char read FNumberExceedSymbol write SetNumberExceedSymbol;


    /// <summary>
    ///   <para>
    ///     显示类型
    ///   </para>
    ///   <para>
    ///     ShowType
    ///   </para>
    /// </summary>
    property ShowType:TNotifyNumberIconShowType read FShowType write SetShowType;
  end;










  /// <summary>
  ///   <para>
  ///     提醒数字图标素材基类
  ///   </para>
  ///   <para>
  ///     Base class of NotifyNumber icon material
  ///   </para>
  /// </summary>
  TSkinNotifyNumberIconMaterial=class(TSkinButtonMaterial)
  protected
    //提醒图标标题绘制参数
    FDrawNumberParam:TDrawTextParam;
    //提醒图标绘制参数
    FDrawNotifyIconParam:TDrawPictureParam;


    //绘制背景区域时的自适应水平边距
    FAutoSuitNumberHorzMargin:Integer;
    //绘制背景区域时的自适应垂直边距
    FAutoSuitNumberVertMargin:Integer;


    //是否自适应绘制背景图片
    FIsDrawPictureAutoSuitNumber: Boolean;

    FIsDrawNumberAutoSuitPicture: Boolean;

    procedure SetDrawNotifyIconParam(const Value: TDrawPictureParam);
    procedure SetDrawNumberParam(const Value: TDrawTextParam);

    procedure SetIsDrawPictureAutoSuitNumber(const Value: Boolean);
    procedure SetIsDrawNumberAutoSuitPicture(const Value: Boolean);

    procedure SetAutoSuitNumberHorzMargin(const Value: Integer);
    procedure SetAutoSuitNumberVertMargin(const Value: Integer);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  protected
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    /// <summary>
    ///   <para>
    ///     是否根据背景图片的绘制矩形来自适应绘制数字
    ///   </para>
    ///   <para>
    ///     Whetehr autosuit draw number according to background picture's draw rectangle
    ///   </para>
    /// </summary>
    property IsDrawNumberAutoSuitPicture:Boolean read FIsDrawNumberAutoSuitPicture write SetIsDrawNumberAutoSuitPicture ;// True;
  published

    /// <summary>
    ///   <para>
    ///     绘制背景区域时的自适应水平边距
    ///   </para>
    ///   <para>
    ///     Autosuit horizontal margin
    ///   </para>
    /// </summary>
    property AutoSuitNumberHorzMargin:Integer read FAutoSuitNumberHorzMargin write SetAutoSuitNumberHorzMargin ;// 3;

    /// <summary>
    ///   <para>
    ///     绘制背景区域时的自适应垂直边距
    ///   </para>
    ///   <para>
    ///     Autosuit vertical margin
    ///   </para>
    /// </summary>
    property AutoSuitNumberVertMargin:Integer read FAutoSuitNumberVertMargin write SetAutoSuitNumberVertMargin ;// 3;

    /// <summary>
    ///   <para>
    ///     是否根据提醒数字的绘制矩形来自适应绘制背景图片
    ///   </para>
    ///   <para>
    ///     Whether autosuit draw background picture according to NotifyNumber's draw rectangle
    ///   </para>
    /// </summary>
    property IsDrawPictureAutoSuitNumber:Boolean read FIsDrawPictureAutoSuitNumber write SetIsDrawPictureAutoSuitNumber ;// True;


    /// <summary>
    ///   <para>
    ///     提醒数字绘制参数
    ///   </para>
    ///   <para>
    ///     NotifyNumber draw parameter
    ///   </para>
    /// </summary>
    property DrawCaptionParam:TDrawTextParam read FDrawNumberParam write SetDrawNumberParam;
    property DrawNumberParam:TDrawTextParam read FDrawNumberParam write SetDrawNumberParam;

    /// <summary>
    ///   <para>
    ///     提醒图标绘制参数
    ///   </para>
    ///   <para>
    ///     NotifyIcon draw parameter
    ///   </para>
    /// </summary>
    property DrawIconParam:TDrawPictureParam read FDrawNotifyIconParam write SetDrawNotifyIconParam;
    property DrawNotifyIconParam:TDrawPictureParam read FDrawNotifyIconParam write SetDrawNotifyIconParam;


    property DrawButtonCaptionParam:TDrawTextParam read FDrawCaptionParam write SetDrawCaptionParam;
    property DrawButtonIconParam:TDrawPictureParam read FDrawIconParam write SetDrawIconParam;
  end;



  TSkinNotifyNumberIconType=class(TSkinButtonType)
  protected
    FSkinNotifyNumberIconIntf:ISkinNotifyNumberIcon;
  protected
    function GetSkinMaterial:TSkinNotifyNumberIconMaterial;
  protected
    FIsOldFill:Boolean;
    //重绘控件
    procedure Invalidate;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    function Paint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    function HasBackground:Boolean;virtual;
    procedure DrawBackground(ACanvas:TDrawCanvas;
                            const ADrawRect:TRectF;
                            ANumber:String;
                            const ANumberRect:TRectF;
                            var APictureRect:TRectF);virtual;
    //计算
    function CalcAutoSize(var AWidth,AHeight:TControlSize):Boolean;override;
  protected
    procedure TextChanged;override;
  public
    function CalcCurrentEffectStates:TDPEffectStates;override;
  end;









  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     提醒数字图标素材基类
  ///   </para>
  ///   <para>
  ///     Base class of NotifyNumber icon material
  ///   </para>
  /// </summary>
  TSkinNotifyNumberIconDefaultMaterial=class(TSkinNotifyNumberIconMaterial)
  protected
    //背景图片
    FNotifyPicture: TDrawPicture;
    //长背景图片
    FNotifyLongPicture: TDrawPicture;

    //图片绘制参数
    FDrawNotifyPictureParam:TDrawPictureParam;

    procedure SetNotifyPicture(const Value: TDrawPicture);
    procedure SetNotifyLongPicture(const Value: TDrawPicture);

    procedure SetDrawNotifyPictureParam(const Value: TDrawPictureParam);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published

    /// <summary>
    ///   <para>
    ///     背景图片
    ///   </para>
    ///   <para>
    ///     Background picture
    ///   </para>
    /// </summary>
    property Picture:TDrawPicture read FNotifyPicture write SetNotifyPicture;

    /// <summary>
    ///   <para>
    ///     长背景图片
    ///   </para>
    ///   <para>
    ///     Long background picture
    ///   </para>
    /// </summary>
    property LongPicture:TDrawPicture read FNotifyLongPicture write SetNotifyLongPicture;

    /// <summary>
    ///   <para>
    ///     背景图片绘制参数
    ///   </para>
    ///   <para>
    ///     Background picture draw parameter
    ///   </para>
    /// </summary>
    property DrawPictureParam:TDrawPictureParam read FDrawNotifyPictureParam write SetDrawNotifyPictureParam;

    property IsDrawNumberAutoSuitPicture;
  end;

  TSkinNotifyNumberIconDefaultType=class(TSkinNotifyNumberIconType)
  protected
    function GetSkinMaterial:TSkinNotifyNumberIconDefaultMaterial;
  protected
    function HasBackground:Boolean;override;
    //自定义绘制方法
    procedure DrawBackground(ACanvas:TDrawCanvas;
                            const ADrawRect:TRectF;
                            ANumber:String;
                            const ANumberRect:TRectF;
                            var APictureRect:TRectF);override;
    //计算
    function CalcAutoSize(var AWidth,AHeight:TControlSize):Boolean;override;
  end;






  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     提醒数字图标素材基类
  ///   </para>
  ///   <para>
  ///     Base class of NotifyNumber icon material
  ///   </para>
  /// </summary>
  TSkinNotifyNumberIconColorMaterial=class(TSkinNotifyNumberIconMaterial)
  protected
    //提醒图标绘制参数
    FDrawNotifyRectParam:TDrawRectParam;

    procedure SetDrawNotifyRectParam(const Value: TDrawRectParam);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published

    /// <summary>
    ///   <para>
    ///     提醒图标绘制参数
    ///   </para>
    ///   <para>
    ///     NotifyIcon draw parameter
    ///   </para>
    /// </summary>
    property DrawNotifyRectParam:TDrawRectParam read FDrawNotifyRectParam write SetDrawNotifyRectParam;
  end;

  TSkinNotifyNumberIconColorType=class(TSkinNotifyNumberIconType)
  protected
    function GetSkinMaterial:TSkinNotifyNumberIconColorMaterial;
  protected
    //自定义绘制方法
    function HasBackground:Boolean;override;
    procedure DrawBackground(ACanvas:TDrawCanvas;
                            const ADrawRect:TRectF;
                            ANumber:String;
                            const ANumberRect:TRectF;
                            var APictureRect:TRectF);override;
  end;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinNotifyNumberIcon=class(TBaseSkinButton,
                              ISkinNotifyNumberIcon,
                              IBindSkinItemTextControl,
                              IBindSkinItemValueControl
                              )
  private
    function GetNotifyNumberIconProperties:TNotifyNumberIconProperties;
    procedure SetNotifyNumberIconProperties(Value:TNotifyNumberIconProperties);
  protected
//    FIsOldFill:Boolean;
//    //控件绘制
//    procedure Paint;overload;override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
  protected
    //绑定列表项的值
    procedure BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  public
    function SelfOwnMaterialToDefault:TSkinNotifyNumberIconDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinNotifyNumberIconDefaultMaterial;
    function Material:TSkinNotifyNumberIconDefaultMaterial;
  public
    property Prop:TNotifyNumberIconProperties read GetNotifyNumberIconProperties write SetNotifyNumberIconProperties;
  published
    //属性
    property Properties:TNotifyNumberIconProperties read GetNotifyNumberIconProperties write SetNotifyNumberIconProperties;
  end;

  {$IFDEF VCL}
  TSkinWinNotifyNumberIcon=class(TSkinNotifyNumberIcon)
  end;
  {$ENDIF VCL}


implementation



{ TSkinNotifyNumberIconDefaultType }

function TSkinNotifyNumberIconDefaultType.GetSkinMaterial: TSkinNotifyNumberIconDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinNotifyNumberIconDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinNotifyNumberIconDefaultType.HasBackground: Boolean;
begin
  Result:=Not Self.GetSkinMaterial.FNotifyPicture.IsEmpty;
end;

function TSkinNotifyNumberIconDefaultType.CalcAutoSize(var AWidth,AHeight: TControlSize): Boolean;
begin
  Result:=False;
  if Not Self.GetSkinMaterial.FNotifyPicture.CurrentPictureIsEmpty then
  begin
    AWidth:=Self.GetSkinMaterial.FNotifyPicture.CurrentPictureDrawWidth;
    AHeight:=Self.GetSkinMaterial.FNotifyPicture.CurrentPictureDrawHeight;
    Result:=True;
  end
  else
  begin
    if Not Self.FSkinNotifyNumberIconIntf.Prop.FNotifyIcon.CurrentPictureIsEmpty then
    begin
      AWidth:=Self.FSkinNotifyNumberIconIntf.Prop.FNotifyIcon.CurrentPictureDrawWidth;
      AHeight:=Self.FSkinNotifyNumberIconIntf.Prop.FNotifyIcon.CurrentPictureDrawHeight;
      Result:=True;
    end;
  end;
end;

procedure TSkinNotifyNumberIconDefaultType.DrawBackground(ACanvas:TDrawCanvas;
                                                          const ADrawRect:TRectF;
                                                          ANumber:String;
                                                          const ANumberRect:TRectF;
                                                          var APictureRect:TRectF);
var
  ADrawPicture:TDrawPicture;
begin
  inherited;

  //绘制背景
  ADrawPicture:=Self.GetSkinMaterial.FNotifyPicture;
  if (Not Self.GetSkinMaterial.FNotifyLongPicture.IsEmpty) and (Length(ANumber)>1)  then
  begin
    //如果Number的位数为两位数以上
    ADrawPicture:=Self.GetSkinMaterial.FNotifyLongPicture;
  end;


  if (Not ADrawPicture.IsEmpty) and GetSkinMaterial.IsDrawNumberAutoSuitPicture then
  begin
      //自适应绘制数字
      //根据背景图片计算绘制矩形和绘制参数
      CalcImageDrawRect(
              Self.GetSkinMaterial.FDrawNotifyPictureParam,
              ADrawPicture.CurrentPictureWidth,
              ADrawPicture.CurrentPictureHeight,
              ADrawRect,
              APictureRect
              );
  end
  else
  begin
      APictureRect:=ADrawRect;
  end;



  ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawNotifyPictureParam,
                      ADrawPicture,
                      ANumberRect);

end;

{ TSkinNotifyNumberIconDefaultMaterial }

procedure TSkinNotifyNumberIconDefaultMaterial.SetNotifyPicture(const Value: TDrawPicture);
begin
  FNotifyPicture.Assign(Value);
end;

procedure TSkinNotifyNumberIconDefaultMaterial.SetNotifyLongPicture(const Value: TDrawPicture);
begin
  FNotifyLongPicture.Assign(Value);
end;

constructor TSkinNotifyNumberIconDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FNotifyPicture:=CreateDrawPicture('NotifyPicture','背景图片','背景图片');
  FNotifyLongPicture:=CreateDrawPicture('NotifyLongPicture','长背景图片','长背景图片');

  FDrawNotifyPictureParam:=CreateDrawPictureParam('DrawNotifyPictureParam','图片绘制参数');
end;

destructor TSkinNotifyNumberIconDefaultMaterial.Destroy;
begin
  FreeAndNil(FNotifyPicture);
  FreeAndNil(FNotifyLongPicture);
  FreeAndNil(FDrawNotifyPictureParam);
  inherited;
end;

procedure TSkinNotifyNumberIconDefaultMaterial.SetDrawNotifyPictureParam(const Value: TDrawPictureParam);
begin
  FDrawNotifyPictureParam.Assign(Value);
end;



{ TNotifyNumberIconProperties }

procedure TNotifyNumberIconProperties.AssignProperties(Src:TSkinControlProperties);
begin
  inherited;
  Self.FNotifyIcon.Assign(TNotifyNumberIconProperties(Src).FNotifyIcon);
end;

procedure TNotifyNumberIconProperties.ClearNotify;
begin
  Self.Number:=0;
  Self.NeedNotify:=False;
end;

constructor TNotifyNumberIconProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinNotifyNumberIcon,Self.FSkinNotifyNumberIconIntf) then
  begin
    ShowException('This Component Do not Support ISkinNotifyNumberIcon Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=25;
    Self.FSkinControlIntf.Height:=25;

    Self.FNumber:=0;
    Self.FNumberMax:=99;
    Self.FNeedNotify:=True;
    Self.FShowType:=nnistNumber;
    Self.FNumberExceedSymbol:='+';

    FNotifyIcon:=CreateDrawPicture('Icon','提醒图标');

    Self.IsInHostControl:=False;
  end;
end;

destructor TNotifyNumberIconProperties.Destroy;
begin
  FreeAndNil(FNotifyIcon);
  inherited;
end;

function TNotifyNumberIconProperties.GetButtonIcon: TDrawPicture;
begin
  Result:=FIcon;
end;

function TNotifyNumberIconProperties.GetButtonPushedIcon: TDrawPicture;
begin
  Result:=FPushedIcon;
end;

function TNotifyNumberIconProperties.GetComponentClassify: String;
begin
  Result:='SkinNotifyNumberIcon';
end;

procedure TNotifyNumberIconProperties.SetNotifyIcon(const Value: TDrawPicture);
begin
  Self.FNotifyIcon.Assign(Value);
end;

procedure TNotifyNumberIconProperties.SetNotifyText(const Value: String);
begin
//  if FNotifyText<>'' then
  if FNotifyText<>Value then
  begin
    FNotifyText := Value;
    Invalidate;
  end;
end;

procedure TNotifyNumberIconProperties.SetButtonIcon(const Value: TDrawPicture);
begin
  FIcon.Assign(Value);
end;

procedure TNotifyNumberIconProperties.SetButtonPushedIcon(const Value: TDrawPicture);
begin
  FPushedIcon.Assign(Value);
end;

procedure TNotifyNumberIconProperties.SetNeedNotify(const Value: Boolean);
begin
  if FNeedNotify<>Value then
  begin
    FNeedNotify := Value;

    Self.Invalidate;
  end;
end;

function TNotifyNumberIconProperties.GetNumberText(const Value: Double):String;
begin
  //判断数字是否超过了最大值
  if EqualDouble(Value,0) then
  begin
    Result:='';
  end
  else if Value>Self.FNumberMax then
  begin
    //99+
    Result:=FloatToStr(Self.FNumberMax)+FNumberExceedSymbol;
  end
  else
  begin
    //9
    Result:=FloatToStr(Value);
  end;
end;

procedure TNotifyNumberIconProperties.SetNumber(const Value: Double);
begin
  if FNumber<>Value then
  begin
      FNumber := Value;

      case Self.FShowType of
        nnistNumber,nnistIcon:
        begin
          //9
          FNotifyText:=GetNumberText(Self.FNumber);
        end;
      end;

      //如果绑定了PageControl,那么PageControl需要重绘
      Self.Invalidate;
  end;
end;

procedure TNotifyNumberIconProperties.SetNumberExceedSymbol(const Value: Char);
begin
  if FNumberExceedSymbol<>Value then
  begin
    FNumberExceedSymbol := Value;
    Self.Invalidate;
  end;
end;

procedure TNotifyNumberIconProperties.SetNumberMax(const Value: Double);
begin
  if FNumberMax<>Value then
  begin
    FNumberMax := Value;
    Self.Invalidate;
  end;
end;

procedure TNotifyNumberIconProperties.SetShowType(const Value: TNotifyNumberIconShowType);
begin
  if FShowType<>Value then
  begin
    FShowType := Value;
    Self.Invalidate;
  end;
end;





{ TSkinNotifyNumberIconColorType }

procedure TSkinNotifyNumberIconColorType.DrawBackground(ACanvas:TDrawCanvas;
                                                        const ADrawRect:TRectF;
                                                        ANumber:String;
                                                        const ANumberRect:TRectF;
                                                        var APictureRect:TRectF);
begin
  inherited;

  ACanvas.DrawRect(Self.GetSkinMaterial.FDrawNotifyRectParam,ANumberRect);

end;

function TSkinNotifyNumberIconColorType.GetSkinMaterial: TSkinNotifyNumberIconColorMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinNotifyNumberIconColorMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;


function TSkinNotifyNumberIconColorType.HasBackground: Boolean;
begin
  Result:=Self.GetSkinMaterial.FDrawNotifyRectParam.IsFill;
end;

{ TSkinNotifyNumberIconColorMaterial }

constructor TSkinNotifyNumberIconColorMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDrawNotifyRectParam:=CreateDrawRectParam('DrawNotifyRectParam','提醒颜色绘制参数');
end;

destructor TSkinNotifyNumberIconColorMaterial.Destroy;
begin
  FreeAndNil(FDrawNotifyRectParam);
  inherited;
end;

procedure TSkinNotifyNumberIconColorMaterial.SetDrawNotifyRectParam(const Value: TDrawRectParam);
begin
  FDrawNotifyRectParam.Assign(Value);
end;



{ TSkinNotifyNumberIconType }

procedure TSkinNotifyNumberIconType.TextChanged;
begin
  Inherited;
  Self.FSkinNotifyNumberIconIntf.Prop.AdjustAutoSizeBounds;
  Self.Invalidate;
end;

function TSkinNotifyNumberIconType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinNotifyNumberIcon,Self.FSkinNotifyNumberIconIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinNotifyNumberIcon Interface');
    end;
  end;
end;

procedure TSkinNotifyNumberIconType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinNotifyNumberIconIntf:=nil;
end;

procedure TSkinNotifyNumberIconType.DrawBackground(ACanvas:TDrawCanvas;
                                                    const ADrawRect:TRectF;
                                                    ANumber:String;
                                                    const ANumberRect:TRectF;
                                                    var APictureRect:TRectF);
begin

end;

function TSkinNotifyNumberIconType.CalcCurrentEffectStates: TDPEffectStates;
begin
  Result:=Inherited CalcCurrentEffectStates;
end;

function TSkinNotifyNumberIconType.GetSkinMaterial: TSkinNotifyNumberIconMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinNotifyNumberIconMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinNotifyNumberIconType.HasBackground: Boolean;
begin
  Result:=False;
end;

procedure TSkinNotifyNumberIconType.Invalidate;
begin
  if Self.FSkinNotifyNumberIconIntf.Prop.IsInHostControl
     and Assigned(Self.FSkinNotifyNumberIconIntf.Prop.OnInvalidate) then
  begin

    if Assigned(Self.FSkinNotifyNumberIconIntf.Prop.OnInvalidate) then
    begin
      Self.FSkinNotifyNumberIconIntf.Prop.OnInvalidate(Self);
    end;

  end
  else
  begin
    inherited;
  end;

end;

function TSkinNotifyNumberIconType.Paint(ACanvas: TDrawCanvas;
  ASkinMaterial: TSkinControlMaterial; const ADrawRect: TRectF;
  APaintData: TPaintData): Boolean;
begin
  if ASkinMaterial<>nil then
  begin
      if (Self.FSkinNotifyNumberIconIntf.Prop.FShowType=nnistNumber)
        or (Self.FSkinNotifyNumberIconIntf.Prop.FShowType=nnistText) then
      begin
        FIsOldFill:=ASkinMaterial.BackColor.IsFill;
//        TSkinNotifyNumberIconType(GetSkinControlType).FIsOldFill:=GetSkinControlType.GetPaintCurrentUseMaterial.BackColor.IsFill;
        ASkinMaterial.BackColor.IsFill:=(Self.FSkinNotifyNumberIconIntf.Prop.FNotifyText<>'');
      end;
  end;

  inherited;


  if ASkinMaterial<>nil then
  begin
      if (Self.FSkinNotifyNumberIconIntf.Prop.FShowType=nnistNumber)
        or (Self.FSkinNotifyNumberIconIntf.Prop.FShowType=nnistText) then
      begin
        ASkinMaterial.BackColor.IsFill:=FIsOldFill;
      end;
  end;


end;

function TSkinNotifyNumberIconType.CalcAutoSize(var AWidth,AHeight: TControlSize): Boolean;
begin
  Result:=False;

  if Not Self.FSkinNotifyNumberIconIntf.Prop.FNotifyIcon.CurrentPictureIsEmpty then
  begin
    AWidth:=Self.FSkinNotifyNumberIconIntf.Prop.FNotifyIcon.CurrentPictureDrawWidth;
    AHeight:=Self.FSkinNotifyNumberIconIntf.Prop.FNotifyIcon.CurrentPictureDrawHeight;
    Result:=True;
  end;

end;

function TSkinNotifyNumberIconType.CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData): Boolean;
var
//  ANumber:String;
  ANumberRect:TRectF;
  APictureRect:TRectF;
begin
  Inherited CustomPaint(ACanvas,GetSkinMaterial,ADrawRect,APaintData);

  if GetSkinMaterial<>nil then
  begin

    if Self.FSkinNotifyNumberIconIntf.Prop.FNeedNotify then
    begin
      case Self.FSkinNotifyNumberIconIntf.Prop.FShowType of
        nnistNumber,nnistText:
        begin
          //显示数字
//          if Self.FSkinNotifyNumberIconIntf.Prop.FNumber>0 then
          if Self.FSkinNotifyNumberIconIntf.Prop.FNotifyText<>'' then
          begin



//                //判断数字是否超过了最大值
//                if Self.FSkinNotifyNumberIconIntf.Prop.FNumber
//                      >Self.FSkinNotifyNumberIconIntf.Prop.FNumberMax then
//                begin
//                  //99+
//                  ANumber:=FloatToStr(Self.FSkinNotifyNumberIconIntf.Prop.FNumberMax)
//                          +Self.FSkinNotifyNumberIconIntf.Prop.FNumberExceedSymbol;
//                end
//                else
//                begin
//                  //9
//                  ANumber:=FloatToStr(Self.FSkinNotifyNumberIconIntf.Prop.FNumber);
//                end;





                //根据文本的绘制位置来自适应绘制背景图片
                //计算出文本绘制矩形
                //然后使用这个矩形来绘制背景
                if GetSkinMaterial.IsDrawPictureAutoSuitNumber and HasBackground then
                begin
                    ACanvas.CalcTextDrawRect(
                            Self.GetSkinMaterial.FDrawNumberParam,
                            Self.FSkinNotifyNumberIconIntf.Prop.FNotifyText,//ANumber,
                            Self.GetSkinMaterial.FDrawNumberParam.CalcDrawRect(ADrawRect),
                            ANumberRect
                            );
                    //加上自适应的偏移
                    ANumberRect:=RectF(
                            ANumberRect.Left-Self.GetSkinMaterial.FAutoSuitNumberHorzMargin,
                            //ADrawRect.Top,//
                            ANumberRect.Top-Self.GetSkinMaterial.FAutoSuitNumberVertMargin,
                            ANumberRect.Right+Self.GetSkinMaterial.FAutoSuitNumberHorzMargin,
                            //ADrawRect.Bottom//
                            ANumberRect.Bottom+Self.GetSkinMaterial.FAutoSuitNumberVertMargin
                            );

                end
                else
                begin
                    ANumberRect:=ADrawRect;
                end;



                //绘制背景
                APictureRect:=ADrawRect;
                DrawBackground(ACanvas,
                                ADrawRect,
                                Self.FSkinNotifyNumberIconIntf.Prop.FNotifyText,//ANumber,
                                ANumberRect,
                                APictureRect);



                //绘制数字
                ACanvas.DrawText(Self.GetSkinMaterial.FDrawNumberParam,
                                  Self.FSkinNotifyNumberIconIntf.Prop.FNotifyText,//ANumber,
                                  APictureRect);



          end;
        end;
        nnistIcon:
        begin
              //显示图标
              //绘制图标
              ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawNotifyIconParam,
                                  Self.FSkinNotifyNumberIconIntf.Prop.FNotifyIcon,
                                  ADrawRect);
        end;
      end;
    end;

  end;


//  if Self.GetPaintCurrentUseMaterial<>nil then
//  begin
//      if Self.FSkinNotifyNumberIconIntf.Prop.FShowType=nnistNumber then
//      begin
//        Self.GetPaintCurrentUseMaterial.BackColor.IsFill:=FIsOldFill;
//      end;
//  end;
end;





{ TSkinNotifyNumberIconMaterial }

procedure TSkinNotifyNumberIconMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinNotifyNumberIconMaterial;
begin
  if Dest is TSkinNotifyNumberIconMaterial then
  begin
    DestObject:=TSkinNotifyNumberIconMaterial(Dest);

    DestObject.FAutoSuitNumberHorzMargin:=FAutoSuitNumberHorzMargin;
    DestObject.FAutoSuitNumberVertMargin:=FAutoSuitNumberVertMargin;

    DestObject.FIsDrawPictureAutoSuitNumber:=FIsDrawPictureAutoSuitNumber;
    DestObject.FIsDrawNumberAutoSuitPicture:=FIsDrawNumberAutoSuitPicture;

  end;

  inherited;
end;

constructor TSkinNotifyNumberIconMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAutoSuitNumberHorzMargin:=3;
  FAutoSuitNumberVertMargin:=3;

  FIsDrawPictureAutoSuitNumber:=True;
  FIsDrawNumberAutoSuitPicture:=False;

  FDrawNumberParam:=CreateDrawTextParam('DrawNumberParam','提醒图标标题绘制参数');
  FDrawNotifyIconParam:=CreateDrawPictureParam('DrawNotifyIconParam','提醒图标绘制参数');
end;


function TSkinNotifyNumberIconMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='AutoSuitNumberHorzMargin' then
    begin
      FAutoSuitNumberHorzMargin:=ABTNode.ConvertNode_Int32.Data;
    end
    else if ABTNode.NodeName='AutoSuitNumberVertMargin' then
    begin
      FAutoSuitNumberVertMargin:=ABTNode.ConvertNode_Int32.Data;
    end
    else if ABTNode.NodeName='IsDrawPictureAutoSuitNumber' then
    begin
      FIsDrawPictureAutoSuitNumber:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='IsDrawNumberAutoSuitPicture' then
    begin
      FIsDrawNumberAutoSuitPicture:=ABTNode.ConvertNode_Bool32.Data;
    end
    ;

  end;

  Result:=True;

end;

function TSkinNotifyNumberIconMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Int32('AutoSuitNumberHorzMargin','自适应水平边框');
  ABTNode.ConvertNode_Int32.Data:=Self.FAutoSuitNumberHorzMargin;

  ABTNode:=ADocNode.AddChildNode_Int32('AutoSuitNumberVertMargin','自适应垂直边框');
  ABTNode.ConvertNode_Int32.Data:=Self.FAutoSuitNumberVertMargin;

  ABTNode:=ADocNode.AddChildNode_Bool32('IsDrawPictureAutoSuitNumber','是否根据数字自适应绘制背景图片');
  ABTNode.ConvertNode_Bool32.Data:=Self.FIsDrawPictureAutoSuitNumber;

  ABTNode:=ADocNode.AddChildNode_Bool32('IsDrawNumberAutoSuitPicture','是否根据背景图片自适应绘制数字');
  ABTNode.ConvertNode_Bool32.Data:=Self.FIsDrawNumberAutoSuitPicture;

  Result:=True;
end;


destructor TSkinNotifyNumberIconMaterial.Destroy;
begin
  FreeAndNil(FDrawNumberParam);
  FreeAndNil(FDrawNotifyIconParam);
  inherited;
end;

procedure TSkinNotifyNumberIconMaterial.SetAutoSuitNumberHorzMargin(const Value: Integer);
begin
  if FAutoSuitNumberHorzMargin<>Value then
  begin
    FAutoSuitNumberHorzMargin := Value;
    Self.DoChange;
  end;
end;

procedure TSkinNotifyNumberIconMaterial.SetAutoSuitNumberVertMargin(const Value: Integer);
begin
  if FAutoSuitNumberVertMargin<>Value then
  begin
    FAutoSuitNumberVertMargin := Value;
    Self.DoChange;
  end;
end;

procedure TSkinNotifyNumberIconMaterial.SetDrawNumberParam(const Value: TDrawTextParam);
begin
  FDrawNumberParam.Assign(Value);
end;

procedure TSkinNotifyNumberIconMaterial.SetIsDrawPictureAutoSuitNumber(const Value: Boolean);
begin
  if FIsDrawPictureAutoSuitNumber<>Value then
  begin
    FIsDrawPictureAutoSuitNumber := Value;

    //只能二选一
    if FIsDrawPictureAutoSuitNumber then
    begin
      FIsDrawNumberAutoSuitPicture:=False;
    end;

    Self.DoChange;
  end;
end;

procedure TSkinNotifyNumberIconMaterial.SetIsDrawNumberAutoSuitPicture(const Value: Boolean);
begin
  if FIsDrawNumberAutoSuitPicture<>Value then
  begin
    FIsDrawNumberAutoSuitPicture := Value;

    //只能二选一
    if FIsDrawNumberAutoSuitPicture then
    begin
      FIsDrawPictureAutoSuitNumber:=False;
    end;

    Self.DoChange;
  end;
end;

procedure TSkinNotifyNumberIconMaterial.SetDrawNotifyIconParam(const Value: TDrawPictureParam);
begin
  FDrawNotifyIconParam.Assign(Value);
end;


{ TSkinNotifyNumberIcon }

function TSkinNotifyNumberIcon.Material:TSkinNotifyNumberIconDefaultMaterial;
begin
  Result:=TSkinNotifyNumberIconDefaultMaterial(SelfOwnMaterial);
end;

//procedure TSkinNotifyNumberIcon.Paint;
//begin
//  if GetSkinControlType.GetPaintCurrentUseMaterial<>nil then
//  begin
//      if Self.Prop.FShowType=nnistNumber then
//      begin
//        FIsOldFill:=GetSkinControlType.GetPaintCurrentUseMaterial.BackColor.IsFill;
////        TSkinNotifyNumberIconType(GetSkinControlType).FIsOldFill:=GetSkinControlType.GetPaintCurrentUseMaterial.BackColor.IsFill;
//        GetSkinControlType.GetPaintCurrentUseMaterial.BackColor.IsFill:=(Self.Prop.FNotifyText<>'');
//      end;
//  end;
//
//  inherited;
//
//  if GetSkinControlType.GetPaintCurrentUseMaterial<>nil then
//  begin
//      if Self.Prop.FShowType=nnistNumber then
//      begin
//        GetSkinControlType.GetPaintCurrentUseMaterial.BackColor.IsFill:=FIsOldFill;
//      end;
//  end;
//end;

function TSkinNotifyNumberIcon.SelfOwnMaterialToDefault:TSkinNotifyNumberIconDefaultMaterial;
begin
  Result:=TSkinNotifyNumberIconDefaultMaterial(SelfOwnMaterial);
end;

function TSkinNotifyNumberIcon.CurrentUseMaterialToDefault:TSkinNotifyNumberIconDefaultMaterial;
begin
  Result:=TSkinNotifyNumberIconDefaultMaterial(CurrentUseMaterial);
end;

function TSkinNotifyNumberIcon.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TNotifyNumberIconProperties;
end;

function TSkinNotifyNumberIcon.GetNotifyNumberIconProperties: TNotifyNumberIconProperties;
begin
  Result:=TNotifyNumberIconProperties(Self.FProperties);
end;

procedure TSkinNotifyNumberIcon.SetControlValueByBindItemField(
  const AFieldName: String; const AFieldValue: Variant; ASkinItem: TObject;
  AIsDrawItemInteractiveState: Boolean);
var
//  ATempNumber:Double;
  AFieldValueStr:String;
begin
  AFieldValueStr:=AFieldValue;
  BindingItemText(AFieldName,AFieldValueStr,ASkinItem,AIsDrawItemInteractiveState);

//  if (VarType(AFieldValue)=varInteger)
//    or (VarType(AFieldValue)=varDouble) then
//  begin
//    Self.GetNotifyNumberIconProperties.StaticNumber:=AFieldValue;
//  end
//  else
//  begin
//    ATempNumber:=0;
//    AFieldValueStr:=AFieldValue;
//    TryStrToFloat(AFieldValueStr,ATempNumber);
//    Self.GetNotifyNumberIconProperties.StaticNumber:=ControlSize(ATempNumber);
//  end;
end;

procedure TSkinNotifyNumberIcon.SetNotifyNumberIconProperties(Value: TNotifyNumberIconProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinNotifyNumberIcon.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetNotifyNumberIconProperties.AdjustAutoSizeBounds;
  end;
  Inherited;
end;

procedure TSkinNotifyNumberIcon.BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
var
  ATempNumber:Double;
begin
  ATempNumber:=0;

  case Self.GetNotifyNumberIconProperties.FShowType of
    nnistNumber:
    begin

        if TryStrToFloat(AText,ATempNumber) then
        begin
          //是数字
      //    Self.GetNotifyNumberIconProperties.StaticNumber:=ControlSize(ATempNumber);
          Self.GetNotifyNumberIconProperties.FNotifyText:=Self.GetNotifyNumberIconProperties.GetNumberText(ATempNumber);
        end
        else
        begin
          //是文本
          Self.GetNotifyNumberIconProperties.FNotifyText:=AText;
        end;

    end;
    nnistText:
    begin
        //是文本
        Self.GetNotifyNumberIconProperties.FNotifyText:=AText;
    end;
  end;
end;



end.

