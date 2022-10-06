//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     单选框
///   </para>
///   <para>
///     RadioButton
///   </para>
/// </summary>
unit uSkinRadioButtonType;

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
  FMX.Controls,
  {$ENDIF}
  uBaseLog,
  Variants,
  uSkinItems,
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
  uDrawRectParam,
  uSkinRegManager,
  uDrawPictureParam;

const
  IID_ISkinRadioButton:TGUID='{632F7B49-7141-4FF6-B3E5-F4E7054C1BFD}';

type
  TRadioButtonProperties=class;




  /// <summary>
  ///   <para>
  ///     单选框接口
  ///   </para>
  ///   <para>
  ///     Interface of Radio Box
  ///   </para>
  /// </summary>
  ISkinRadioButton=Interface//(ISkinControl)
  ['{632F7B49-7141-4FF6-B3E5-F4E7054C1BFD}']
    function GetOnChange: TNotifyEvent;
    property OnChange: TNotifyEvent read GetOnChange;// write SetOnChange;

    function GetRadioButtonProperties:TRadioButtonProperties;
    property Properties:TRadioButtonProperties read GetRadioButtonProperties;
    property Prop:TRadioButtonProperties read GetRadioButtonProperties;
  end;




  //
  /// <summary>
  ///   <para>
  ///     单选框属性
  ///   </para>
  ///   <para>
  ///     Properties of RadioButton
  ///   </para>
  /// </summary>
  TRadioButtonProperties=class(TSkinControlProperties)
  protected
    FChecked:Boolean;
    FIsAutoChecked:Boolean;

    FSkinRadioButtonIntf:ISkinRadioButton;
    procedure SetChecked(const Value:Boolean);
  protected
    procedure DoChange;
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
    property StaticChecked:Boolean read FChecked write FChecked;
  published
    //
    /// <summary>
    ///   <para>
    ///     自动尺寸
    ///   </para>
    ///   <para>
    ///     AutoSize
    ///   </para>
    /// </summary>
    property AutoSize;
    //
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
    ///     是否自动勾选
    ///   </para>
    ///   <para>
    ///     Whether checke automatically
    ///   </para>
    /// </summary>
    property IsAutoChecked:Boolean read FIsAutoChecked write FIsAutoChecked;
  end;









  //
  /// <summary>
  ///   <para>
  ///     单选框素材基类
  ///   </para>
  ///   <para>
  ///     Base class of Radio Box material
  ///   </para>
  /// </summary>
  TSkinRadioButtonMaterial=class(TSkinControlMaterial)
  private
    //自动排列Caption和勾选框的位置
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
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //
    /// <summary>
    ///   <para>
    ///     标题绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of caption
    ///   </para>
    /// </summary>
    property DrawCaptionParam:TDrawTextParam read FDrawCaptionParam write SetDrawCaptionParam;
    //
    /// <summary>
    ///   <para>
    ///     自动排列Caption和勾选框的位置
    ///   </para>
    ///   <para>
    ///     Align Caption and RadioBox's position automatically
    ///   </para>
    /// </summary>
    property IsAutoPosition:Boolean read FIsAutoPosition write SetIsAutoPosition ;//default True;
  end;

  //单选框风格基类
  TSkinRadioButtonType=class(TSkinControlType)
  private
    FSkinRadioButtonIntf:ISkinRadioButton;
  protected
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
  ///     单选框默认素材
  ///   </para>
  ///   <para>
  ///     Default material of RadioBox
  ///   </para>
  /// </summary>
  TSkinRadioButtonDefaultMaterial=class(TSkinRadioButtonMaterial)
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
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //
    /// <summary>
    ///   <para>
    ///     正常状态时未勾选图片
    ///   </para>
    ///   <para>
    ///     Unchecked picture at normal state
    ///   </para>
    /// </summary>
    property NormalUnCheckedPicture:TDrawPicture read FNormalUnCheckedPicture write SetNormalUnCheckedDrawPicture;
    //
    /// <summary>
    ///   <para>
    ///     正常状态时已勾选图片
    ///   </para>
    ///   <para>
    ///     Checked picture at normal state
    ///   </para>
    /// </summary>
    property NormalCheckedPicture:TDrawPicture read FNormalCheckedPicture write SetNormalCheckedDrawPicture;

    //
    /// <summary>
    ///   <para>
    ///     鼠标停靠时未勾选图片
    ///   </para>
    ///   <para>
    ///     Unchecked picture when mouse hovering
    ///   </para>
    /// </summary>
    property HoverUnCheckedPicture:TDrawPicture read FHoverUnCheckedPicture write SetHoverUnCheckedDrawPicture;
    //
    /// <summary>
    ///   <para>
    ///     鼠标停靠时已勾选图片
    ///   </para>
    ///   <para>
    ///     Checked picture when mouse hovering
    ///   </para>
    /// </summary>
    property HoverCheckedPicture:TDrawPicture read FHoverCheckedPicture write SetHoverCheckedDrawPicture;

    //
    /// <summary>
    ///   <para>
    ///     禁用状态时已勾选图片
    ///   </para>
    ///   <para>
    ///     Chencked picture at disabled state
    ///   </para>
    /// </summary>
    property DisabledCheckedPicture: TDrawPicture read FDisabledCheckedPicture write SetDisabledCheckedDrawPicture;
    //
    /// <summary>
    ///   <para>
    ///     禁用状态时未勾选图片
    ///   </para>
    ///   <para>
    ///     Unchecked picture at disabled state
    ///   </para>
    /// </summary>
    property DisabledUnCheckedPicture: TDrawPicture read FDisabledUnCheckedPicture write SetDisabledUnCheckedDrawPicture;
    //
    /// <summary>
    ///   <para>
    ///     勾选框图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of RadioBox image
    ///   </para>
    /// </summary>
    property DrawPictureParam:TDrawPictureParam read FDrawPictureParam write SetDrawPictureParam;
  end;

  //默认类型
  TSkinRadioButtonDefaultType=class(TSkinRadioButtonType)
  private
    function GetSkinMaterial:TSkinRadioButtonDefaultMaterial;
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
  ///     RadioButton's default material
  ///   </para>
  /// </summary>
  TSkinRadioButtonColorMaterial=class(TSkinRadioButtonMaterial)
  private
    FDrawCheckRectParam: TDrawRectParam;
    FDrawCheckStateParam: TDrawRectParam;

    procedure SetDrawCheckStateParam(const Value: TDrawRectParam);
    procedure SetDrawCheckRectParam(const Value: TDrawRectParam);
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    /// <summary>
    ///   <para>
    ///     勾选状态路径
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawCheckStateParam:TDrawRectParam read FDrawCheckStateParam write SetDrawCheckStateParam;
    property DrawCheckRectParam:TDrawRectParam read FDrawCheckRectParam write SetDrawCheckRectParam;
  end;

  //颜色类型
  TSkinRadioButtonColorType=class(TSkinRadioButtonType)
  private
    function GetSkinMaterial:TSkinRadioButtonColorMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;








  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TBaseSkinRadioButton=class(TBaseSkinControl,
                            ISkinRadioButton,
                            IBindSkinItemBoolControl,
                            IBindSkinItemValueControl
                            )
  private
    FOnChange: TNotifyEvent;
    FBindItemFieldTrueValue: String;
    function GetOnChange: TNotifyEvent;
    function GetRadioButtonProperties:TRadioButtonProperties;
    procedure SetRadioButtonProperties(Value:TRadioButtonProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
  public
    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;override;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);override;
  public
    //在点击事件中设置是否勾选属性
    procedure StayClick;override;
  protected
    //绑定列表项的值
    procedure BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  public
    function SelfOwnMaterialToDefault:TSkinRadioButtonDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinRadioButtonDefaultMaterial;
    function Material:TSkinRadioButtonDefaultMaterial;
  public
    property Prop:TRadioButtonProperties read GetRadioButtonProperties write SetRadioButtonProperties;
  published
    //标题
    property Caption;
    property Text;
    //判断列表项是否为真的值
    property BindItemFieldTrueValue:String read FBindItemFieldTrueValue write FBindItemFieldTrueValue;
    //属性
    property Properties:TRadioButtonProperties read GetRadioButtonProperties write SetRadioButtonProperties;
    property OnChange: TNotifyEvent read GetOnChange write FOnChange;
  end;



  {$IFDEF FMX}
  TSkinRadioButton=class(TBaseSkinRadioButton)
  end;
  {$ENDIF FMX}

  {$IFDEF VCL}
  TSkinWinRadioButton=class(TBaseSkinRadioButton)
  end;
  {$ENDIF VCL}



implementation


{ TSkinRadioButtonType }

function TSkinRadioButtonType.CalcAutoSize(var AWidth,AHeight: TControlSize): Boolean;
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
            TSkinRadioButtonMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial).FDrawCaptionParam,
            Self.FSkinControlIntf.Caption,
            RectF(0,0,MaxInt,Self.FSkinControlIntf.Height),
            AWidth,
            ATempHeight,
            cdstBoth);
      AWidth:=AWidth+Self.FSkinControl.Height;//+5;//
//            +Length(Self.FSkinControlIntf.Caption)*4+5;
  end;
end;

function TSkinRadioButtonType.CalcCurrentEffectStates: TDPEffectStates;
begin
  Result:=Inherited CalcCurrentEffectStates;

  if Self.FSkinRadioButtonIntf.Prop.FChecked then
  begin
    Result:=Result+[dpstPushed];
  end;

end;

function TSkinRadioButtonType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinRadioButton,Self.FSkinRadioButtonIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinRadioButton Interface');
    end;
  end;
end;

procedure TSkinRadioButtonType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinRadioButtonIntf:=nil;
end;

function TSkinRadioButtonType.GetCurrentEffectStates: TDPEffectStates;
begin
  if Self.FIsUseCurrentEffectStates then
  begin
    Result:=FCurrentEffectStates;

    //因为Color类型的素材类型用的是PushedEffect,
    //当Item.Selected为True时,EffectStates会自动加入dpstPushed
    //而不是根据自身的Checked
    if Not Self.FSkinRadioButtonIntf.Prop.FChecked then
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

//procedure TSkinRadioButtonType.CustomMouseEnter;
//begin
//  inherited;
//  Self.Invalidate;
//end;
//
//procedure TSkinRadioButtonType.CustomMouseLeave;
//begin
//  inherited;
//  Self.Invalidate;
//end;

procedure TSkinRadioButtonType.TextChanged;
begin
  inherited;
  Self.FSkinRadioButtonIntf.Prop.AdjustAutoSizeBounds;
  Self.Invalidate;
end;

{ TSkinRadioButtonDefaultType }

function TSkinRadioButtonDefaultType.GetSkinMaterial: TSkinRadioButtonDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinRadioButtonDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinRadioButtonDefaultType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  ADrawPicture:TDrawPicture;
  ACaptionDrawRect:TRectF;
  APictureDrawRect:TRectF;
begin
  if GetSkinMaterial<>nil then
  begin
    ADrawPicture:=nil;
    if Not Self.FSkinControlIntf.Enabled then
    begin
      if Self.FSkinRadioButtonIntf.Prop.Checked then
        ADrawPicture:=GetSkinMaterial.FDisabledCheckedPicture
      else
        ADrawPicture:=GetSkinMaterial.FDisabledUnCheckedPicture;
    end
    else if Self.FSkinControlIntf.IsMouseOver and APaintData.IsDrawInteractiveState then
    begin
      if Self.FSkinRadioButtonIntf.Prop.Checked then
        ADrawPicture:=GetSkinMaterial.FHoverCheckedPicture
      else
        ADrawPicture:=GetSkinMaterial.FHoverUnCheckedPicture;
    end
    else
    begin
      if Self.FSkinRadioButtonIntf.Prop.Checked then
        ADrawPicture:=GetSkinMaterial.FNormalCheckedPicture
      else
        ADrawPicture:=GetSkinMaterial.FNormalUnCheckedPicture;
    end;



    if ADrawPicture.CurrentPictureIsEmpty then
    begin
      if Self.FSkinRadioButtonIntf.Prop.Checked then
        ADrawPicture:=GetSkinMaterial.FNormalCheckedPicture
      else
        ADrawPicture:=GetSkinMaterial.FNormalUnCheckedPicture;
    end;


    if GetSkinMaterial.FIsAutoPosition then
    begin

      APictureDrawRect:=ADrawRect;
      APictureDrawRect.Right:=APictureDrawRect.Left+APictureDrawRect.Height;//ADrawPicture.Width;
      APictureDrawRect.Bottom:=APictureDrawRect.Top+APictureDrawRect.Height;//ADrawPicture.Height;
      ACanvas.DrawPicture(GetSkinMaterial.FDrawPictureParam,ADrawPicture,APictureDrawRect);
      ACaptionDrawRect:=ADrawRect;
      ACaptionDrawRect.Left:=APictureDrawRect.Right+5;
      ACanvas.DrawText(GetSkinMaterial.FDrawCaptionParam,Self.FSkinControlIntf.Caption,ACaptionDrawRect);

    end
    else
    begin

      ACanvas.DrawPicture(GetSkinMaterial.FDrawPictureParam,ADrawPicture,ADrawRect);
      ACanvas.DrawText(GetSkinMaterial.FDrawCaptionParam,Self.FSkinControlIntf.Caption,ADrawRect);

    end;
  end;
end;

{ TSkinRadioButtonDefaultMaterial }

constructor TSkinRadioButtonDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNormalCheckedPicture:=CreateDrawPicture('NormalCheckedPicture','正常状态时已勾选图片','已勾选所有状态图片');
  FHoverCheckedPicture:=CreateDrawPicture('HoverCheckedPicture','鼠标停靠时已勾选图片','已勾选所有状态图片');
  FDisabledCheckedPicture:=CreateDrawPicture('DisabledCheckedPicture','禁用状态时已勾选图片','已勾选所有状态图片');

  FNormalUnCheckedPicture:=CreateDrawPicture('NormalUnCheckedPicture','正常状态时未勾选图片','未勾选所有状态图片');
  FHoverUnCheckedPicture:=CreateDrawPicture('HoverUnCheckedPicture','鼠标停靠时未勾选图片','未勾选所有状态图片');
  FDisabledUnCheckedPicture:=CreateDrawPicture('DisabledUnCheckedPicture','禁用状态时未勾选图片','未勾选所有状态图片');

  FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','勾选框图片绘制参数');
end;

//function TSkinRadioButtonDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  I: Integer;
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited LoadFromDocNode(ADocNode);
//
////  for I := 0 to ADocNode.ChildNodes.Count - 1 do
////  begin
////    ABTNode:=ADocNode.ChildNodes[I];
////    if ABTNode.NodeName='DrawCaptionParam' then
////    begin
////      FDrawCaptionParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='DrawPictureParam' then
////    begin
////      FDrawPictureParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='NormalCheckedPicture' then
////    begin
////      FNormalCheckedPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='NormalUnCheckedPicture' then
////    begin
////      FNormalUnCheckedPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HoverCheckedPicture' then
////    begin
////      FHoverCheckedPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HoverUnCheckedPicture' then
////    begin
////      FHoverUnCheckedPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='DisabledCheckedPicture' then
////    begin
////      FDisabledCheckedPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='DisabledUnCheckedPicture' then
////    begin
////      FDisabledUnCheckedPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    ;
////  end;
//
//  Result:=True;
//end;
//
//function TSkinRadioButtonDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
////
////  ABTNode:=ADocNode.AddChildNode_Class('DrawCaptionParam',FDrawCaptionParam.Name);
////  Self.FDrawCaptionParam.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('DrawPictureParam',FDrawPictureParam.Name);
////  Self.FDrawPictureParam.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('NormalCheckedPicture',FNormalCheckedPicture.Name);
////  Self.FNormalCheckedPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('NormalUnCheckedPicture',FNormalUnCheckedPicture.Name);
////  Self.FNormalUnCheckedPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('HoverCheckedPicture',FHoverCheckedPicture.Name);
////  Self.FHoverCheckedPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('HoverUnCheckedPicture',FHoverUnCheckedPicture.Name);
////  Self.FHoverUnCheckedPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('DisabledCheckedPicture',FDisabledCheckedPicture.Name);
////  Self.FDisabledCheckedPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('DisabledUnCheckedPicture',FDisabledUnCheckedPicture.Name);
////  Self.FDisabledUnCheckedPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//  Result:=True;
//end;

destructor TSkinRadioButtonDefaultMaterial.Destroy;
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

procedure TSkinRadioButtonDefaultMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;

procedure TSkinRadioButtonDefaultMaterial.SetDisabledCheckedDrawPicture(const Value: TDrawPicture);
begin
  FDisabledCheckedPicture.Assign(Value);
end;

procedure TSkinRadioButtonDefaultMaterial.SetDisabledUnCheckedDrawPicture(const Value: TDrawPicture);
begin
  FDisabledUnCheckedPicture.Assign(Value);
end;


procedure TSkinRadioButtonDefaultMaterial.SetHoverCheckedDrawPicture(const Value: TDrawPicture);
begin
  FHoverCheckedPicture.Assign(Value);
end;

procedure TSkinRadioButtonDefaultMaterial.SetHoverUnCheckedDrawPicture(const Value: TDrawPicture);
begin
  FHoverUnCheckedPicture.Assign(Value);
end;

procedure TSkinRadioButtonDefaultMaterial.SetNormalCheckedDrawPicture(const Value: TDrawPicture);
begin
  FNormalCheckedPicture.Assign(Value);
end;

procedure TSkinRadioButtonDefaultMaterial.SetNormalUnCheckedDrawPicture(const Value: TDrawPicture);
begin
  FNormalUnCheckedPicture.Assign(Value);
end;



{ TSkinRadioButtonMaterial }

procedure TSkinRadioButtonMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinRadioButtonMaterial;
begin

  if Dest is TSkinRadioButtonMaterial then
  begin
    DestObject:=TSkinRadioButtonMaterial(Dest);

    DestObject.FIsAutoPosition:=Self.FIsAutoPosition;

  end;

  inherited;

end;

constructor TSkinRadioButtonMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

//  FIsAutoPosition := True;

  FDrawCaptionParam:=CreateDrawTextParam('DrawCaptionParam','标题绘制参数');

end;

function TSkinRadioButtonMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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

function TSkinRadioButtonMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Class('IsAutoPosition','自动排列Caption和勾选框的位置');
  ABTNode.ConvertNode_Bool32.Data:=Self.FIsAutoPosition;

  Result:=True;
end;

destructor TSkinRadioButtonMaterial.Destroy;
begin
  FreeAndNil(FDrawCaptionParam);

  inherited;
end;


procedure TSkinRadioButtonMaterial.SetDrawCaptionParam(const Value: TDrawTextParam);
begin
  FDrawCaptionParam.Assign(Value);
end;

procedure TSkinRadioButtonMaterial.SetIsAutoPosition(const Value: Boolean);
begin
  if FIsAutoPosition<>Value then
  begin
    FIsAutoPosition := Value;
    DoChange;
  end;
end;

{ TRadioButtonProperties }


function TRadioButtonProperties.GetComponentClassify: String;
begin
  Result:='SkinRadioButton';
end;

procedure TRadioButtonProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
  Self.FChecked:=TRadioButtonProperties(Src).FChecked;
  Self.FIsAutoChecked:=TRadioButtonProperties(Src).FIsAutoChecked;
end;

constructor TRadioButtonProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinRadioButton,Self.FSkinRadioButtonIntf) then
  begin
    ShowException('This Component Do not Support ISkinRadioButton Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=120;
    Self.FSkinControlIntf.Height:=22;
    FChecked:=False;
    FIsAutoChecked:=True;
  end;
end;

destructor TRadioButtonProperties.Destroy;
begin
  inherited;
end;

procedure TRadioButtonProperties.DoChange;
begin
  if Assigned(Self.FSkinRadioButtonIntf.OnChange) then
  begin
    Self.FSkinRadioButtonIntf.OnChange(Self);
  end;
end;

procedure TRadioButtonProperties.SetChecked(const Value: Boolean);
var
  I: Integer;
  AHasSameTypeControl:Boolean;
  ASkinRadioButtonIntf:ISkinRadioButton;
begin
  if FChecked<>Value then
  begin

    AHasSameTypeControl:=False;


    //遍历,只能有一个按钮处于按下状态
    if Not Self.Checked and (Self.FSkinControlIntf.GetParent<>nil) then
    begin
      for I := 0 to Self.FSkinControlIntf.GetParentChildControlCount - 1 do
      begin
        if Self.FSkinControlIntf.GetParentChildControl(I).GetInterface(IID_ISkinRadioButton,ASkinRadioButtonIntf) then
        begin
          if (Self.FSkinControlIntf.GetParentChildControl(I)<>Self.FSkinControl) then
          begin


              AHasSameTypeControl:=True;
              if ASkinRadioButtonIntf.Prop.Checked then
              begin
                ASkinRadioButtonIntf.Prop.Checked:=False;
              end;


          end;
        end;
      end;
    end;


    if AHasSameTypeControl and Value or Not AHasSameTypeControl then
    begin
      Self.FChecked:=Value;
      DoChange;
    end;

    Invalidate;

  end;
end;




{ TSkinRadioButtonColorMaterial }

constructor TSkinRadioButtonColorMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDrawCheckStateParam:=CreateDrawRectParam('DrawCheckStateParam','勾选状态的方框绘制参数');
  FDrawCheckRectParam:=CreateDrawRectParam('DrawCheckRectParam','勾选状态的方框绘制参数');

end;

destructor TSkinRadioButtonColorMaterial.Destroy;
begin
  FreeAndNil(FDrawCheckStateParam);
  FreeAndNil(FDrawCheckRectParam);
  inherited;
end;

procedure TSkinRadioButtonColorMaterial.SetDrawCheckStateParam(const Value: TDrawRectParam);
begin
  FDrawCheckStateParam.Assign(Value);
end;

procedure TSkinRadioButtonColorMaterial.SetDrawCheckRectParam(const Value: TDrawRectParam);
begin
  FDrawCheckRectParam.Assign(Value);
end;



{ TSkinRadioButtonColorType }


function TSkinRadioButtonColorType.GetSkinMaterial: TSkinRadioButtonColorMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinRadioButtonColorMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinRadioButtonColorType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  ACaptionDrawRect:TRectF;
  ACheckDrawRect:TRectF;
begin
  if GetSkinMaterial<>nil then
  begin

    if GetSkinMaterial.FIsAutoPosition then
    begin
        ACheckDrawRect:=ADrawRect;
        ACheckDrawRect.Right:=ACheckDrawRect.Left+ACheckDrawRect.Height;
        ACheckDrawRect.Bottom:=ACheckDrawRect.Top+ACheckDrawRect.Height;
        ACanvas.DrawRect(GetSkinMaterial.FDrawCheckRectParam,ACheckDrawRect);
        ACanvas.DrawRect(GetSkinMaterial.FDrawCheckStateParam,ACheckDrawRect);

        ACaptionDrawRect:=ADrawRect;
        ACaptionDrawRect.Left:=ACheckDrawRect.Right+5;
        ACanvas.DrawText(GetSkinMaterial.FDrawCaptionParam,Self.FSkinControlIntf.Caption,ACaptionDrawRect);
    end
    else
    begin
        ACanvas.DrawRect(GetSkinMaterial.FDrawCheckRectParam,ADrawRect);
        ACanvas.DrawRect(GetSkinMaterial.FDrawCheckStateParam,ADrawRect);
        ACanvas.DrawText(GetSkinMaterial.FDrawCaptionParam,Self.FSkinControlIntf.Caption,ADrawRect);
    end;

  end;
end;



{ TBaseSkinRadioButton }

function TBaseSkinRadioButton.Material:TSkinRadioButtonDefaultMaterial;
begin
  Result:=TSkinRadioButtonDefaultMaterial(SelfOwnMaterial);
end;

function TBaseSkinRadioButton.SelfOwnMaterialToDefault:TSkinRadioButtonDefaultMaterial;
begin
  Result:=TSkinRadioButtonDefaultMaterial(SelfOwnMaterial);
end;

function TBaseSkinRadioButton.CurrentUseMaterialToDefault:TSkinRadioButtonDefaultMaterial;
begin
  Result:=TSkinRadioButtonDefaultMaterial(CurrentUseMaterial);
end;

procedure TBaseSkinRadioButton.StayClick;
begin
  if GetRadioButtonProperties.IsAutoChecked and Not GetRadioButtonProperties.Checked then
  begin
    GetRadioButtonProperties.Checked:=Not GetRadioButtonProperties.Checked;
  end;
  inherited;
end;

function TBaseSkinRadioButton.GetOnChange: TNotifyEvent;
begin
  Result:=Self.FOnChange;
end;

function TBaseSkinRadioButton.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String): Variant;
begin
  Result:=BoolToStr(Self.Prop.Checked);
//begin
//  //显示不出
//  Result:=Ord(Self.Prop.Checked);
end;

procedure TBaseSkinRadioButton.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
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

function TBaseSkinRadioButton.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TRadioButtonProperties;
end;

function TBaseSkinRadioButton.GetRadioButtonProperties: TRadioButtonProperties;
begin
  Result:=TRadioButtonProperties(Self.FProperties);
end;

procedure TBaseSkinRadioButton.SetControlValueByBindItemField(
  const AFieldName: String; const AFieldValue: Variant; ASkinItem: TObject;
  AIsDrawItemInteractiveState: Boolean);
var
  AAFieldValueStr:String;
begin
  if VarType(AFieldValue)=varBoolean then
  begin
      Self.GetRadioButtonProperties.StaticChecked:=AFieldValue;
  end
  else
  begin
      if Self.FBindItemFieldTrueValue<>'' then
      begin
        AAFieldValueStr:=AFieldValue;
        Self.GetRadioButtonProperties.StaticChecked:=(Self.FBindItemFieldTrueValue=AAFieldValueStr);
      end;
  end;
end;

procedure TBaseSkinRadioButton.SetRadioButtonProperties(Value: TRadioButtonProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TBaseSkinRadioButton.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetRadioButtonProperties.AdjustAutoSizeBounds;
  end;
  Inherited;
end;

procedure TBaseSkinRadioButton.BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
begin
  Self.GetRadioButtonProperties.StaticChecked:=ABool;
end;



end.

