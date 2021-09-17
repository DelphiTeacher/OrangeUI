//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     复选框
///   </para>
///   <para>
///     Check Box
///   </para>
/// </summary>
unit uSkinCheckBoxType;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  Types,

  {$IFDEF VCL}
  Messages,
  Windows,
  Controls,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Controls,
  {$ENDIF}

  Variants,
  uBaseLog,
  uSkinItems,
  uFuncCommon,
  uBasePageStructure,
  uBaseSkinControl,
  uGraphicCommon,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uComponentType,
  uDrawEngine,
  uDrawPicture,
  uDrawParam,
  uDrawTextParam,
  uSkinRegManager,
  uDrawPathParam,
  uDrawRectParam,
  uDrawPictureParam;







const
  IID_ISkinCheckBox:TGUID='{A9A41077-14FD-4D5F-8564-9BC3FAECD841}';

type
  TCheckBoxProperties=class;





  /// <summary>
  ///   <para>
  ///     复选框接口
  ///   </para>
  ///   <para>
  ///     Interface of CheckBox
  ///   </para>
  /// </summary>
  ISkinCheckBox=interface//(ISkinControl)
  ['{A9A41077-14FD-4D5F-8564-9BC3FAECD841}']
    function GetOnChange: TNotifyEvent;
    property OnChange: TNotifyEvent read GetOnChange;// write SetOnChange;

    function GetCheckBoxProperties:TCheckBoxProperties;
    property Properties:TCheckBoxProperties read GetCheckBoxProperties;
    property Prop:TCheckBoxProperties read GetCheckBoxProperties;
  end;







  /// <summary>
  ///   <para>
  ///     复选框属性
  ///   </para>
  ///   <para>
  ///     CheckBox properties
  ///   </para>
  /// </summary>
  TCheckBoxProperties=class(TSkinControlProperties)
  protected
    FChecked:Boolean;
    FIsAutoChecked:Boolean;

    FIsAutoCaption:Boolean;
    FCheckedCaption: String;
    FUnCheckedCaption: String;


    FSkinCheckBoxIntf:ISkinCheckBox;

    procedure SetChecked(const Value:Boolean);
    procedure SetCheckedCaption(const Value: String);
    procedure SetUnCheckedCaption(const Value: String);
    procedure SetIsAutoChecked(const Value: Boolean);
    procedure SetIsAutoCaption(const Value: Boolean);
  protected
    procedure DoChange;
    procedure AutoCaption;
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    property StaticChecked:Boolean read FChecked write FChecked;
  published

    /// <summary>
    ///   <para>
    ///     自动尺寸
    ///   </para>
    ///   <para>
    ///     Auto size
    ///   </para>
    /// </summary>
    property AutoSize;

    /// <summary>
    ///   <para>
    ///     是否勾选
    ///   </para>
    ///   <para>
    ///     Whether checked
    ///   </para>
    /// </summary>
    property Checked:Boolean read FChecked write SetChecked;

    /// <summary>
    ///   <para>
    ///     鼠标点击的时候是否自动勾选
    ///   </para>
    ///   <para>
    ///     Whether check automatically when mouse clicking
    ///   </para>
    /// </summary>
    property IsAutoChecked:Boolean read FIsAutoChecked write SetIsAutoChecked;
    /// <summary>
    ///   <para>
    ///     Checked属性更改的时候自动更换标题
    ///   </para>
    ///   <para>
    ///     Change caption automatically when property Checked change
    ///   </para>
    /// </summary>
    property IsAutoCaption:Boolean read FIsAutoCaption write SetIsAutoCaption;

    /// <summary>
    ///   <para>
    ///     勾选状态时的标题
    ///   </para>
    ///   <para>
    ///     Caption of checked state
    ///   </para>
    /// </summary>
    property CheckedCaption:String read FCheckedCaption write SetCheckedCaption;

    /// <summary>
    ///   <para>
    ///     未勾选状态时的标题
    ///   </para>
    ///   <para>
    ///     Caption of unchecked state
    ///   </para>
    /// </summary>
    property UnCheckedCaption:String read FUnCheckedCaption write SetUnCheckedCaption;
  end;











  /// <summary>
  ///   <para>
  ///     复选框素材基类
  ///   </para>
  ///   <para>
  ///     Base class of CheckBox material
  ///   </para>
  /// </summary>
  TSkinCheckBoxMaterial=class(TSkinControlMaterial)
  protected
    //自动排列标题和勾选框的位置
    FIsAutoPosition:Boolean;
    //标题绘制参数
    FDrawCaptionParam:TDrawTextParam;

    procedure SetIsAutoPosition(const Value: Boolean);
    procedure SetDrawCaptionParam(const Value: TDrawTextParam);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  protected
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    function HasMouseDownEffect:Boolean;override;
    function HasMouseOverEffect:Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure DrawTo(ACanvas:TDrawCanvas;
                      ACaption:String;
                      ADrawRect:TRectF);virtual;
  published

    /// <summary>
    ///   <para>
    ///     自动排列标题和勾选框的位置
    ///   </para>
    ///   <para>
    ///     Align Caption and CheckBox's position automatically
    ///   </para>
    /// </summary>
    property IsAutoPosition:Boolean read FIsAutoPosition write SetIsAutoPosition;

    /// <summary>
    ///   <para>
    ///     标题绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of caption
    ///   </para>
    /// </summary>
    property DrawCaptionParam:TDrawTextParam read FDrawCaptionParam write SetDrawCaptionParam;
  end;


  //复选框风格基类
  TSkinCheckBoxType=class(TSkinControlType)
  protected
    FSkinCheckBoxIntf:ISkinCheckBox;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    //计算
    function CalcAutoSize(var AWidth,AHeight:TControlSize):Boolean;override;
  public
    //Caption更改事件
    procedure TextChanged;override;
  public
    //获取当前的状态
    function GetCurrentEffectStates: TDPEffectStates;override;
    function CalcCurrentEffectStates:TDPEffectStates;override;
  end;


















  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     复选框默认素材
  ///   </para>
  ///   <para>
  ///     CheckBox's default material
  ///   </para>
  /// </summary>
  TSkinCheckBoxDefaultMaterial=class(TSkinCheckBoxMaterial)
  private
    FHoverCheckedPicture: TDrawPicture;
    FHoverUnCheckedPicture: TDrawPicture;
    FNormalCheckedPicture: TDrawPicture;
    FNormalUnCheckedPicture: TDrawPicture;
    FDisabledCheckedPicture: TDrawPicture;
    FDisabledUnCheckedPicture: TDrawPicture;
    //勾选框图片绘制参数
    FDrawPictureParam:TDrawPictureParam;

    procedure SetDrawPictureParam(const Value: TDrawPictureParam);

    procedure SetHoverCheckedDrawPicture(const Value: TDrawPicture);
    procedure SetHoverUnCheckedDrawPicture(const Value: TDrawPicture);
    procedure SetNormalCheckedDrawPicture(const Value: TDrawPicture);
    procedure SetNormalUnCheckedDrawPicture(const Value: TDrawPicture);
    procedure SetDisabledCheckedDrawPicture(const Value: TDrawPicture);
    procedure SetDisabledUnCheckedDrawPicture(const Value: TDrawPicture);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published

    /// <summary>
    ///   <para>
    ///     正常状态时未勾选图片
    ///   </para>
    ///   <para>
    ///     Unchecked picture at normal state
    ///   </para>
    /// </summary>
    property NormalUnCheckedPicture:TDrawPicture read FNormalUnCheckedPicture write SetNormalUnCheckedDrawPicture;

    /// <summary>
    ///   <para>
    ///     正常状态时已勾选图片
    ///   </para>
    ///   <para>
    ///     Checked picture at normal state
    ///   </para>
    /// </summary>
    property NormalCheckedPicture:TDrawPicture read FNormalCheckedPicture write SetNormalCheckedDrawPicture;


    /// <summary>
    ///   <para>
    ///     鼠标停靠时未勾选图片
    ///   </para>
    ///   <para>
    ///     Unchecked picture when mouse hovering
    ///   </para>
    /// </summary>
    property HoverUnCheckedPicture:TDrawPicture read FHoverUnCheckedPicture write SetHoverUnCheckedDrawPicture;

    /// <summary>
    ///   <para>
    ///     鼠标停靠时已勾选图片
    ///   </para>
    ///   <para>
    ///     Checked picture when mouse hovering
    ///   </para>
    /// </summary>
    property HoverCheckedPicture:TDrawPicture read FHoverCheckedPicture write SetHoverCheckedDrawPicture;


    /// <summary>
    ///   <para>
    ///     禁用状态时已勾选图片
    ///   </para>
    ///   <para>
    ///     Checked picture at disabled state
    ///   </para>
    /// </summary>
    property DisabledCheckedPicture: TDrawPicture read FDisabledCheckedPicture write SetDisabledCheckedDrawPicture;
    //
    /// <summary>
    ///   <para>
    ///     禁用状态时未勾选图片
    ///   </para>
    ///   <para>
    ///     Unchecked picture at normal state
    ///   </para>
    /// </summary>
    property DisabledUnCheckedPicture: TDrawPicture read FDisabledUnCheckedPicture write SetDisabledUnCheckedDrawPicture;

    /// <summary>
    ///   <para>
    ///     勾选框图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of CheckBox picture
    ///   </para>
    /// </summary>
    property DrawPictureParam:TDrawPictureParam read FDrawPictureParam write SetDrawPictureParam;
  end;

  //默认类型
  TSkinCheckBoxDefaultType=class(TSkinCheckBoxType)
  private
    function GetSkinMaterial:TSkinCheckBoxDefaultMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     复选框颜色素材
  ///   </para>
  ///   <para>
  ///     CheckBox's default material
  ///   </para>
  /// </summary>
  TSkinCheckBoxColorMaterial=class(TSkinCheckBoxMaterial)
  private
    FDrawCheckRectParam: TDrawRectParam;
    FDrawCheckStateParam: TDrawPathParam;
    FIsSimpleDrawCheckState: Boolean;

    FIsProcessedSimpleDrawCheckState:Boolean;
    procedure ProcessSimpleDrawCheckState;
    procedure SetDrawCheckStateParam(const Value: TDrawPathParam);
    procedure SetDrawCheckRectParam(const Value: TDrawRectParam);
    procedure SetIsSimpleDrawCheckState(const Value: Boolean);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure DrawTo(ACanvas:TDrawCanvas;
                    ACaption:String;
                    ADrawRect:TRectF);override;
  published
    /// <summary>
    ///   <para>
    ///     勾选状态路径
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawCheckStateParam:TDrawPathParam read FDrawCheckStateParam write SetDrawCheckStateParam;
    /// <summary>
    ///   <para>
    ///     勾选框
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawCheckRectParam:TDrawRectParam read FDrawCheckRectParam write SetDrawCheckRectParam;
    //是否自动绘制勾选状态
    property IsSimpleDrawCheckState:Boolean read FIsSimpleDrawCheckState write SetIsSimpleDrawCheckState;
  end;

  //颜色类型
  TSkinCheckBoxColorType=class(TSkinCheckBoxType)
  private
    function GetSkinMaterial:TSkinCheckBoxColorMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TBaseSkinCheckBox=class(TBaseSkinControl,
                      ISkinCheckBox,
                      IBindSkinItemBoolControl,
                      IBindSkinItemValueControl)
  private
    FOnChange: TNotifyEvent;
    FBindItemFieldTrueValue: String;
    function GetOnChange: TNotifyEvent;
    function GetCheckBoxProperties:TCheckBoxProperties;
    procedure SetCheckBoxProperties(Value:TCheckBoxProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
  public
    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;
                            APageDataDir:String;
                            ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;override;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);override;
  public
    //在点击事件中设置是否勾选属性
    procedure StayClick;override;
  protected
    //绑定列表项
    procedure BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  public
    function SelfOwnMaterialToDefault:TSkinCheckBoxDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinCheckBoxDefaultMaterial;
    function Material:TSkinCheckBoxDefaultMaterial;
  public
    property Prop:TCheckBoxProperties read GetCheckBoxProperties write SetCheckBoxProperties;
  published
    //标题
    property Caption;
    property Text;

    //判断列表项是否为真的值
    property BindItemFieldTrueValue:String read FBindItemFieldTrueValue write FBindItemFieldTrueValue;
    //属性
    property Properties:TCheckBoxProperties read GetCheckBoxProperties write SetCheckBoxProperties;
    property OnChange: TNotifyEvent read GetOnChange write FOnChange;
  end;


//  {$I Source\Controls\ComponentPlatformsAttribute.inc}
//  TSkinFMXCheckBox=class(TBaseSkinCheckBox)
//  end;

  {$IFDEF FMX}
  TSkinCheckBox=class(TBaseSkinCheckBox)
  end;
  {$ENDIF FMX}

  {$IFDEF VCL}
  TSkinWinCheckBox=class(TBaseSkinCheckBox)
  end;
  {$ENDIF VCL}


implementation





{ TSkinCheckBoxType }


function TSkinCheckBoxType.CalcAutoSize(var AWidth,AHeight: TControlSize): Boolean;
var
  ATempHeight:TControlSize;
begin
  Result:=False;
  AWidth:=0;
  AHeight:=Self.FSkinControl.Height;

  if (GetGlobalAutoSizeBufferBitmap.DrawCanvas<>nil)
  and (Self.FSkinControlIntf.GetCurrentUseMaterial<>nil) then
  begin
    Result:=GetGlobalAutoSizeBufferBitmap.DrawCanvas.CalcTextDrawSize(
                        TSkinCheckBoxMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial).FDrawCaptionParam,
                        Self.FSkinControlIntf.Caption,
                        RectF(0,0,MaxInt,Self.FSkinControlIntf.Height),
                        AWidth,
                        ATempHeight,
                        cdstBoth);
    AWidth:=AWidth+AHeight+Length(Self.FSkinControlIntf.Caption)*4+5;
  end;

end;

function TSkinCheckBoxType.CalcCurrentEffectStates: TDPEffectStates;
begin
  Result:=Inherited CalcCurrentEffectStates;

  if Self.FSkinCheckBoxIntf.Prop.FChecked then
  begin
    Result:=Result+[dpstPushed];
  end;

end;

function TSkinCheckBoxType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinCheckBox,Self.FSkinCheckBoxIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinCheckBox Interface');
    end;
  end;
end;

procedure TSkinCheckBoxType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinCheckBoxIntf:=nil;
end;

function TSkinCheckBoxType.GetCurrentEffectStates: TDPEffectStates;
begin
  if Self.FIsUseCurrentEffectStates then
  begin
    Result:=FCurrentEffectStates;


    //因为Color类型的素材类型用的是PushedEffect,
    //当Item.Selected为True时,EffectStates会自动加入dpstPushed
    //而不是根据自身的Checked
    if Not Self.FSkinCheckBoxIntf.Prop.FChecked then
    begin
      Result:=Result-[dpstPushed];
    end
    else
    begin
      Result:=Result+[dpstPushed];
    end;

  end
  else
  begin
    Result := Self.CalcCurrentEffectStates;
  end;

end;

procedure TSkinCheckBoxType.TextChanged;
begin
  inherited;
  Self.FSkinCheckBoxIntf.Prop.AdjustAutoSizeBounds;
  Self.Invalidate;
end;



{ TSkinCheckBoxDefaultType }

function TSkinCheckBoxDefaultType.GetSkinMaterial: TSkinCheckBoxDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinCheckBoxDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinCheckBoxDefaultType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  APicture:TDrawPicture;
  ACaptionDrawRect:TRectF;
  APictureDrawRect:TRectF;
begin
  if GetSkinMaterial<>nil then
  begin
    APicture:=nil;
    if Not Self.FSkinControlIntf.Enabled then
    begin
      if Self.FSkinCheckBoxIntf.Prop.Checked then
        APicture:=GetSkinMaterial.FDisabledCheckedPicture
      else
        APicture:=GetSkinMaterial.FDisabledUnCheckedPicture;
    end
    else if Self.FSkinControlIntf.IsMouseOver and APaintData.IsDrawInteractiveState then
    begin
      if Self.FSkinCheckBoxIntf.Prop.Checked then
        APicture:=GetSkinMaterial.FHoverCheckedPicture
      else
        APicture:=GetSkinMaterial.FHoverUnCheckedPicture;
    end
    else
    begin
      if Self.FSkinCheckBoxIntf.Prop.Checked then
        APicture:=GetSkinMaterial.FNormalCheckedPicture
      else
        APicture:=GetSkinMaterial.FNormalUnCheckedPicture;
    end;


    if APicture.CurrentPictureIsEmpty then
    begin
      if Self.FSkinCheckBoxIntf.Prop.Checked then
        APicture:=GetSkinMaterial.FNormalCheckedPicture
      else
        APicture:=GetSkinMaterial.FNormalUnCheckedPicture;
    end;

    if GetSkinMaterial.FIsAutoPosition then
    begin
        APictureDrawRect:=ADrawRect;

        APictureDrawRect.Left:=APictureDrawRect.Left;
        APictureDrawRect.Top:=APictureDrawRect.Top;
        APictureDrawRect.Right:=APictureDrawRect.Left+APictureDrawRect.Height;
        APictureDrawRect.Bottom:=APictureDrawRect.Top+APictureDrawRect.Height;

        ACanvas.DrawPicture(GetSkinMaterial.FDrawPictureParam,APicture,APictureDrawRect);

        ACaptionDrawRect:=ADrawRect;
        ACaptionDrawRect.Left:=APictureDrawRect.Right+5;
        ACanvas.DrawText(GetSkinMaterial.FDrawCaptionParam,
                          Self.FSkinControlIntf.Caption,
                          ACaptionDrawRect);
    end
    else
    begin
        ACanvas.DrawPicture(GetSkinMaterial.FDrawPictureParam,APicture,ADrawRect);
        ACanvas.DrawText(GetSkinMaterial.FDrawCaptionParam,Self.FSkinControlIntf.Caption,ADrawRect);
    end;

  end;
end;



{ TSkinCheckBoxDefaultMaterial }

constructor TSkinCheckBoxDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','勾选框图片绘制参数');

  FNormalCheckedPicture:=CreateDrawPicture('NormalCheckedPicture','正常状态时已勾选图片','已勾选所有状态图片');
  FHoverCheckedPicture:=CreateDrawPicture('HoverCheckedPicture','鼠标停靠时已勾选图片','已勾选所有状态图片');
  FDisabledCheckedPicture:=CreateDrawPicture('DisabledCheckedPicture','禁用状态时已勾选图片','已勾选所有状态图片');

  FNormalUnCheckedPicture:=CreateDrawPicture('NormalUnCheckedPicture','正常状态时未勾选图片','未勾选所有状态图片');
  FHoverUnCheckedPicture:=CreateDrawPicture('HoverUnCheckedPicture','鼠标停靠时未勾选图片','未勾选所有状态图片');
  FDisabledUnCheckedPicture:=CreateDrawPicture('DisabledUnCheckedPicture','禁用状态时未勾选图片','未勾选所有状态图片');
end;

destructor TSkinCheckBoxDefaultMaterial.Destroy;
begin
  FreeAndNil(FDrawPictureParam);

  FreeAndNil(FHoverCheckedPicture);
  FreeAndNil(FHoverUnCheckedPicture);
  FreeAndNil(FNormalCheckedPicture);
  FreeAndNil(FNormalUnCheckedPicture);
  FreeAndNil(FDisabledCheckedPicture);
  FreeAndNil(FDisabledUnCheckedPicture);
  inherited;
end;

procedure TSkinCheckBoxDefaultMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;

procedure TSkinCheckBoxDefaultMaterial.SetDisabledCheckedDrawPicture(const Value: TDrawPicture);
begin
  FDisabledCheckedPicture.Assign(Value);
end;

procedure TSkinCheckBoxDefaultMaterial.SetDisabledUnCheckedDrawPicture(const Value: TDrawPicture);
begin
  FDisabledUnCheckedPicture.Assign(Value);
end;

procedure TSkinCheckBoxDefaultMaterial.SetHoverCheckedDrawPicture(const Value: TDrawPicture);
begin
  FHoverCheckedPicture.Assign(Value);
end;

procedure TSkinCheckBoxDefaultMaterial.SetHoverUnCheckedDrawPicture(const Value: TDrawPicture);
begin
  FHoverUnCheckedPicture.Assign(Value);
end;

procedure TSkinCheckBoxDefaultMaterial.SetNormalCheckedDrawPicture(const Value: TDrawPicture);
begin
  FNormalCheckedPicture.Assign(Value);
end;

procedure TSkinCheckBoxDefaultMaterial.SetNormalUnCheckedDrawPicture(const Value: TDrawPicture);
begin
  FNormalUnCheckedPicture.Assign(Value);
end;



{ TSkinCheckBoxMaterial }

procedure TSkinCheckBoxMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinCheckBoxMaterial;
begin

  if Dest is TSkinCheckBoxMaterial then
  begin
    DestObject:=TSkinCheckBoxMaterial(Dest);

    DestObject.FIsAutoPosition:=Self.FIsAutoPosition;

  end;

  inherited;
end;

constructor TSkinCheckBoxMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  //FIsAutoPosition := True;

  FDrawCaptionParam:=CreateDrawTextParam('DrawCaptionParam','标题绘制参数');
end;

function TSkinCheckBoxMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='IsAutoPosition' then
    begin
      ABTNode.ConvertNode_Bool32.Data:=FIsAutoPosition;
    end
    ;

  end;

  Result:=True;

end;

function TSkinCheckBoxMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Bool32('IsAutoPosition','自动排列标题和勾选框的位置');
  ABTNode.ConvertNode_Bool32.Data:=Self.FIsAutoPosition;

  Result:=True;
end;

destructor TSkinCheckBoxMaterial.Destroy;
begin
  FreeAndNil(FDrawCaptionParam);

  inherited;
end;

procedure TSkinCheckBoxMaterial.DrawTo(ACanvas: TDrawCanvas;
  ACaption:String;
  ADrawRect: TRectF);
begin

end;

function TSkinCheckBoxMaterial.HasMouseDownEffect: Boolean;
begin
  Result:=True;
end;

function TSkinCheckBoxMaterial.HasMouseOverEffect: Boolean;
begin
  Result:=True;
end;

procedure TSkinCheckBoxMaterial.SetDrawCaptionParam(const Value: TDrawTextParam);
begin
  FDrawCaptionParam.Assign(Value);
end;

procedure TSkinCheckBoxMaterial.SetIsAutoPosition(const Value: Boolean);
begin
  if FIsAutoPosition<>Value then
  begin
    FIsAutoPosition := Value;
    DoChange;
  end;
end;

function TCheckBoxProperties.GetComponentClassify: String;
begin
  Result:='SkinCheckBox';
end;

procedure TCheckBoxProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;

  Self.FChecked:=TCheckBoxProperties(Src).FChecked;
  Self.FIsAutoChecked:=TCheckBoxProperties(Src).FIsAutoChecked;
  Self.FIsAutoCaption:=TCheckBoxProperties(Src).FIsAutoCaption;
  Self.FCheckedCaption:=TCheckBoxProperties(Src).FCheckedCaption;
  Self.FUnCheckedCaption:=TCheckBoxProperties(Src).FUnCheckedCaption;
  AutoCaption;
end;

procedure TCheckBoxProperties.AutoCaption;
begin
  if Self.FIsAutoCaption then
  begin
    if Self.FChecked then
    begin
      Self.FSkinControlIntf.Caption:=Self.FCheckedCaption;
    end
    else
    begin
      Self.FSkinControlIntf.Caption:=Self.FUnCheckedCaption;
    end;
  end;
end;

constructor TCheckBoxProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinCheckBox,Self.FSkinCheckBoxIntf) then
  begin
    ShowException('This Component Do not Support ISkinCheckBox Interface');
  end
  else
  begin

    Self.FSkinControlIntf.Width:=120;
    Self.FSkinControlIntf.Height:=22;

    Self.FChecked:=False;
    Self.FIsAutoChecked:=True;
    Self.FIsAutoCaption:=False;
  end;
end;

destructor TCheckBoxProperties.Destroy;
begin
  inherited;
end;

procedure TCheckBoxProperties.DoChange;
begin
  if Assigned(Self.FSkinCheckBoxIntf.OnChange) then
  begin
    Self.FSkinCheckBoxIntf.OnChange(Self);
  end;
end;

procedure TCheckBoxProperties.SetChecked(const Value: Boolean);
begin
  if FChecked<>Value then
  begin
    Self.FChecked:=Value;
    AutoCaption;
    DoChange;
    Invalidate;
  end;
end;

procedure TCheckBoxProperties.SetCheckedCaption(const Value: String);
begin
  if FCheckedCaption<>Value then
  begin
    Self.FCheckedCaption:=Value;
    AutoCaption;
  end;
end;

procedure TCheckBoxProperties.SetIsAutoCaption(const Value: Boolean);
begin
  if FIsAutoCaption<>Value then
  begin
    Self.FIsAutoCaption:=Value;
    AutoCaption;
  end;
end;

procedure TCheckBoxProperties.SetIsAutoChecked(const Value: Boolean);
begin
  if FIsAutoChecked<>Value then
  begin
    Self.FIsAutoChecked:=Value;
    Invalidate;
  end;
end;

procedure TCheckBoxProperties.SetUnCheckedCaption(const Value: String);
begin
  if FUnCheckedCaption<>Value then
  begin
    Self.FUnCheckedCaption:=Value;
    AutoCaption;
  end;
end;






{ TSkinCheckBoxColorMaterial }

procedure TSkinCheckBoxColorMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinCheckBoxColorMaterial;
begin

  if Dest is TSkinCheckBoxColorMaterial then
  begin
    DestObject:=TSkinCheckBoxColorMaterial(Dest);

    DestObject.FIsSimpleDrawCheckState:=Self.FIsSimpleDrawCheckState;

    DestObject.FIsProcessedSimpleDrawCheckState:=False;

  end;

  inherited;

end;

constructor TSkinCheckBoxColorMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDrawCheckStateParam:=CreateDrawPathParam('DrawCheckStateParam','勾选状态的路径绘制参数');
  FDrawCheckRectParam:=CreateDrawRectParam('DrawCheckRectParam','勾选状态的方框绘制参数');

  FIsSimpleDrawCheckState:=True;
  FIsProcessedSimpleDrawCheckState:=False;
end;

destructor TSkinCheckBoxColorMaterial.Destroy;
begin
  FreeAndNil(FDrawCheckStateParam);
  FreeAndNil(FDrawCheckRectParam);
  inherited;
end;

procedure TSkinCheckBoxColorMaterial.DrawTo(ACanvas: TDrawCanvas;
  ACaption:String;
  ADrawRect: TRectF);
var
  ACaptionDrawRect:TRectF;
  ACheckDrawRect:TRectF;
begin
  inherited;

  if Not Self.FIsProcessedSimpleDrawCheckState then
  begin
    Self.ProcessSimpleDrawCheckState;
  end;

  if Self.FIsAutoPosition then
  begin
      ACheckDrawRect:=ADrawRect;

      ACheckDrawRect:=Self.FDrawCheckRectParam.CalcDrawRect(ADrawRect);

      ACheckDrawRect.Right:=ACheckDrawRect.Left+ACheckDrawRect.Height;
      ACheckDrawRect.Bottom:=ACheckDrawRect.Top+ACheckDrawRect.Height;
      ACanvas.DrawRect(Self.FDrawCheckRectParam,ACheckDrawRect);
      ACanvas.DrawPath(Self.FDrawCheckStateParam,ACheckDrawRect);

      ACaptionDrawRect:=ADrawRect;
      ACaptionDrawRect.Left:=ACheckDrawRect.Right+5;
      ACanvas.DrawText(Self.FDrawCaptionParam,ACaption,ACaptionDrawRect);
  end
  else
  begin
      ACanvas.DrawRect(Self.FDrawCheckRectParam,ADrawRect);
      ACanvas.DrawPath(Self.FDrawCheckStateParam,ADrawRect);
      ACanvas.DrawText(Self.FDrawCaptionParam,ACaption,ADrawRect);
  end;
end;

procedure TSkinCheckBoxColorMaterial.ProcessSimpleDrawCheckState;
var
  APathActionItem:TPathActionItem;
begin
  if Not FIsProcessedSimpleDrawCheckState then
  begin
    FIsProcessedSimpleDrawCheckState:=True;

    if FIsSimpleDrawCheckState then
    begin
        Self.FDrawCheckStateParam.PathActions.Clear;

        APathActionItem:=TPathActionItem(Self.FDrawCheckStateParam.PathActions.Add);
        APathActionItem.ActionType:=patMoveTo;
        APathActionItem.SizeType:=dpstPercent;
        APathActionItem.X:=25;
        APathActionItem.Y:=50;
        {$IFDEF VCL}
//        APathActionItem.X:=20;
//        APathActionItem.Y:=45;


        APathActionItem.X:=20;
        APathActionItem.Y:=35;
        {$ENDIF}



        APathActionItem:=TPathActionItem(Self.FDrawCheckStateParam.PathActions.Add);
        APathActionItem.ActionType:=patLineTo;
        APathActionItem.SizeType:=dpstPercent;
//        {$IFDEF MSWINDOWS}
        APathActionItem.X:=40;
        APathActionItem.Y:=70;
//        {$ELSE}
//        //移动平台下面,如果线比较粗,会画的比较短
//        APathActionItem.X:=50;
//        APathActionItem.Y:=80;
//        {$ENDIF}





        {$IFDEF VCL}
        APathActionItem:=TPathActionItem(Self.FDrawCheckStateParam.PathActions.Add);
        APathActionItem.ActionType:=patDrawPath;
        {$ENDIF}





        APathActionItem:=TPathActionItem(Self.FDrawCheckStateParam.PathActions.Add);
        APathActionItem.ActionType:=patLineTo;
        APathActionItem.SizeType:=dpstPercent;
        {$IFDEF MSWINDOWS}
        APathActionItem.X:=75;
        APathActionItem.Y:=35;
        {$ELSE}
        //移动平台下面,如果线比较粗,会画的比较短
        APathActionItem.X:=85;
        APathActionItem.Y:=25;
        {$ENDIF}

        APathActionItem:=TPathActionItem(Self.FDrawCheckStateParam.PathActions.Add);
        APathActionItem.ActionType:=patDrawPath;


    end;
  end;

end;

procedure TSkinCheckBoxColorMaterial.SetDrawCheckStateParam(const Value: TDrawPathParam);
begin
  FDrawCheckStateParam.Assign(Value);
end;

procedure TSkinCheckBoxColorMaterial.SetIsSimpleDrawCheckState(const Value: Boolean);
begin
  if FIsSimpleDrawCheckState<>Value then
  begin
    FIsSimpleDrawCheckState := Value;

    //需要重新处理路径
    Self.FIsProcessedSimpleDrawCheckState:=False;
  end;
end;

procedure TSkinCheckBoxColorMaterial.SetDrawCheckRectParam(const Value: TDrawRectParam);
begin
  FDrawCheckRectParam.Assign(Value);
end;



{ TSkinCheckBoxColorType }


function TSkinCheckBoxColorType.GetSkinMaterial: TSkinCheckBoxColorMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinCheckBoxColorMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinCheckBoxColorType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin
  if GetSkinMaterial<>nil then
  begin

    GetSkinMaterial.DrawTo(ACanvas,
                           Self.FSkinControlIntf.Caption,
                           ADrawRect
                            );
  end;
end;



{ TBaseSkinCheckBox }

function TBaseSkinCheckBox.Material:TSkinCheckBoxDefaultMaterial;
begin
  Result:=TSkinCheckBoxDefaultMaterial(SelfOwnMaterial);
end;

function TBaseSkinCheckBox.SelfOwnMaterialToDefault:TSkinCheckBoxDefaultMaterial;
begin
  Result:=TSkinCheckBoxDefaultMaterial(SelfOwnMaterial);
end;

function TBaseSkinCheckBox.CurrentUseMaterialToDefault:TSkinCheckBoxDefaultMaterial;
begin
  Result:=TSkinCheckBoxDefaultMaterial(CurrentUseMaterial);
end;

procedure TBaseSkinCheckBox.StayClick;
begin
  if GetCheckBoxProperties.IsAutoChecked then
  begin
    GetCheckBoxProperties.Checked:=Not GetCheckBoxProperties.Checked;
  end;
  inherited;
end;

function TBaseSkinCheckBox.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String): Variant;
begin
  Result:=BoolToStr(Self.Prop.Checked);
//begin
//  //显示不出
//  Result:=Ord(Self.Prop.Checked);
end;

procedure TBaseSkinCheckBox.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
  if AValue<>'' then
  begin
    Self.Prop.Checked:=StrToBool(AValue);
  end
  else
  begin
    Self.Prop.Checked:=False;
  end;
end;

function TBaseSkinCheckBox.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TCheckBoxProperties;
end;

function TBaseSkinCheckBox.GetCheckBoxProperties: TCheckBoxProperties;
begin
  Result:=TCheckBoxProperties(Self.FProperties);
end;

function TBaseSkinCheckBox.GetOnChange: TNotifyEvent;
begin
  Result:=Self.FOnChange;
end;

procedure TBaseSkinCheckBox.SetCheckBoxProperties(Value: TCheckBoxProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TBaseSkinCheckBox.SetControlValueByBindItemField(const AFieldName: String;
  const AFieldValue: Variant; ASkinItem: TObject;
  AIsDrawItemInteractiveState: Boolean);
var
  AAFieldValueStr:String;
begin
  if VarType(AFieldValue)=varBoolean then
  begin
      Self.GetCheckBoxProperties.Checked:=AFieldValue;
  end
  else
  begin
      if Self.FBindItemFieldTrueValue<>'' then
      begin
        AAFieldValueStr:=AFieldValue;
        Self.GetCheckBoxProperties.Checked:=(Self.FBindItemFieldTrueValue=AAFieldValueStr);
      end;

  end;
end;

procedure TBaseSkinCheckBox.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetCheckBoxProperties.AdjustAutoSizeBounds;
  end;
  Inherited;
end;

procedure TBaseSkinCheckBox.BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
begin
  Self.GetCheckBoxProperties.Checked:=ABool;
end;




end.




