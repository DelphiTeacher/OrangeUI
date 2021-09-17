//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     开关
///   </para>
///   <para>
///     Switch
///   </para>
/// </summary>
unit uSkinSwitchType;


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
  Variants,
  uBaseLog,
  uSkinItems,
  uGraphicCommon,
  uSkinMaterial,
  uBaseSkinControl,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uComponentType,
  uDrawEngine,
  uDrawPicture,
  uDrawParam,
  uDrawTextParam,
  uSkinRegManager,
  uDrawPictureParam;

const
  IID_ISkinSwitch:TGUID='{71DE2EA8-D375-47A6-BEBC-19589D3A7C2A}';

type
  TSwitchProperties=class;

  ISkinSwitch=interface//(ISkinControl)
    ['{71DE2EA8-D375-47A6-BEBC-19589D3A7C2A}']
//    //标题
//    function GetCaption:String;
//    //AutoCaption的时候需要设置标题
//    procedure SetCaption(const Value:String);
//
//    property Caption:String read GetCaption write SetCaption;
//    property Text:String read GetCaption;

    function GetSwitchProperties:TSwitchProperties;
    property Properties:TSwitchProperties read GetSwitchProperties;
    property Prop:TSwitchProperties read GetSwitchProperties;
  end;


  //Switch属性
  TSwitchProperties=class(TSkinControlProperties)
  protected
    FChecked:Boolean;
//    FIsAutoChecked:Boolean;

//    FIsAutoCaption:Boolean;
//    FCheckedCaption: String;
//    FUnCheckedCaption: String;

    FSkinSwitchIntf:ISkinSwitch;

    procedure SetChecked(const Value:Boolean);
//    procedure SetCheckedCaption(const Value: String);
//    procedure SetUnCheckedCaption(const Value: String);
//    procedure SetIsAutoChecked(const Value: Boolean);
//    procedure SetIsAutoCaption(const Value: Boolean);
  protected
//    procedure AutoCaption;
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
    //自动尺寸
    property AutoSize;
    //是否选中
    property Checked:Boolean read FChecked write SetChecked ;//default False;
//    //鼠标点击的时候是否自动选中
//    property IsAutoChecked:Boolean read FIsAutoChecked write SetIsAutoChecked;
//    //自动更换标题
//    property IsAutoCaption:Boolean read FIsAutoCaption write SetIsAutoCaption;
//    property CheckedCaption:String read FCheckedCaption write SetCheckedCaption;
//    property UnCheckedCaption:String read FUnCheckedCaption write SetUnCheckedCaption;
  end;







  //复选框素材基类
  TSkinSwitchMaterial=class(TSkinControlMaterial)
  protected
//    FIsAutoPosition:Boolean;
//    FDrawCaptionParam:TDrawTextParam;
    FDrawPictureParam:TDrawPictureParam;
//    procedure SetDrawCaptionParam(const Value: TDrawTextParam);
    procedure SetDrawPictureParam(const Value: TDrawPictureParam);
//    procedure SetIsAutoPosition(const Value: Boolean);
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
//    //标题绘制参数
//    property DrawCaptionParam:TDrawTextParam read FDrawCaptionParam write SetDrawCaptionParam;
    //勾选框图片绘制参数
    property DrawPictureParam:TDrawPictureParam read FDrawPictureParam write SetDrawPictureParam;
//    //自动计算Caption和Box的位置
//    property IsAutoPosition:Boolean read FIsAutoPosition write SetIsAutoPosition;
  end;


  //复选框风格基类
  TSkinSwitchType=class(TSkinControlType)
  protected
    FSkinSwitchIntf:ISkinSwitch;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
//    //最后绘制
//    function CopyrightPaint(ACanvas:TDrawCanvas;const ADrawRect:TRect):Boolean;override;
  public
//    //鼠标事件(用于支持DirectUI)
//    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);override;
//    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);override;
//    procedure CustomMouseEnter;override;
//    procedure CustomMouseLeave;override;
//    //Caption更改事件
//    procedure TextChanged;override;
  public
    function CalcCurrentEffectStates:TDPEffectStates;override;
  end;








  //默认素材
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinSwitchDefaultMaterial=class(TSkinSwitchMaterial)
  private
//    FHoverCheckedPicture: TDrawPicture;
//    FHoverUnCheckedPicture: TDrawPicture;
    FNormalCheckedPicture: TDrawPicture;
    FNormalUnCheckedPicture: TDrawPicture;
    FDisabledCheckedPicture: TDrawPicture;
    FDisabledUnCheckedPicture: TDrawPicture;

//    procedure SetHoverCheckedDrawPicture(const Value: TDrawPicture);
//    procedure SetHoverUnCheckedDrawPicture(const Value: TDrawPicture);
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
    //正常状态时已勾选图片
    property NormalUnCheckedPicture:TDrawPicture read FNormalUnCheckedPicture write SetNormalUnCheckedDrawPicture;
    //正常状态时未勾选图片
    property NormalCheckedPicture:TDrawPicture read FNormalCheckedPicture write SetNormalCheckedDrawPicture;

//    //鼠标停靠时已勾选图片
//    property HoverUnCheckedPicture:TDrawPicture read FHoverUnCheckedPicture write SetHoverUnCheckedDrawPicture;
//    //鼠标停靠时未勾选图片
//    property HoverCheckedPicture:TDrawPicture read FHoverCheckedPicture write SetHoverCheckedDrawPicture;

    //禁用状态时已勾选图片
    property DisabledCheckedPicture: TDrawPicture read FDisabledCheckedPicture write SetDisabledCheckedDrawPicture;
    //禁用状态时未勾选图片
    property DisabledUnCheckedPicture: TDrawPicture read FDisabledUnCheckedPicture write SetDisabledUnCheckedDrawPicture;
  end;

  //默认类型
  TSkinSwitchDefaultType=class(TSkinSwitchType)
  private
    function GetSkinMaterial:TSkinSwitchDefaultMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinSwitch=class(TBaseSkinControl,
                    ISkinSwitch,
                    IBindSkinItemBoolControl,
                    IBindSkinItemValueControl
                    )
  private
    FBindItemFieldTrueValue: String;
    function GetSwitchProperties:TSwitchProperties;
    procedure SetSwitchProperties(Value:TSwitchProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
  public
    //在点击事件中设置是否勾选属性
    procedure Click;override;
  protected
    //绑定列表项的值
    procedure BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  public
    function SelfOwnMaterialToDefault:TSkinSwitchDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinSwitchDefaultMaterial;
    function Material:TSkinSwitchDefaultMaterial;
  public
    property Prop:TSwitchProperties read GetSwitchProperties write SetSwitchProperties;
  published
    //判断列表项是否为真的值
    property BindItemFieldTrueValue:String read FBindItemFieldTrueValue write FBindItemFieldTrueValue;
    //属性
    property Properties:TSwitchProperties read GetSwitchProperties write SetSwitchProperties;
  end;


  {$IFDEF VCL}
  TSkinWinSwitch=class(TSkinSwitch)
  end;
  {$ENDIF VCL}



implementation


{ TSkinSwitchType }

//function TSkinSwitchType.CopyrightPaint(ACanvas: TDrawCanvas;const ADrawRect: TRect): Boolean;
//begin
//
//end;

function TSkinSwitchType.CalcCurrentEffectStates: TDPEffectStates;
begin
  Result:=Inherited CalcCurrentEffectStates;
  if Self.FSkinSwitchIntf.Prop.FChecked then
  begin
    Result:=Result+[dpstPushed];
  end;

end;

function TSkinSwitchType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinSwitch,Self.FSkinSwitchIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinSwitch Interface');
    end;
  end;
end;

procedure TSkinSwitchType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinSwitchIntf:=nil;
end;

//procedure TSkinSwitchType.CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);
//begin
//  inherited;
////  if Not (csDesigning in Self.FSkinControl.ComponentState) then
////  begin
//  if Button={$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft  then
//  begin
//  Self.Invalidate;
//  end;
////  end;
//end;
//
//procedure TSkinSwitchType.CustomMouseEnter;
//begin
//  inherited;
//  Self.Invalidate;
//end;
//
//procedure TSkinSwitchType.CustomMouseLeave;
//begin
//  inherited;
//  Self.Invalidate;
//end;
//
//procedure TSkinSwitchType.CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);
//begin
//  inherited;
////  if Not (csDesigning in Self.FSkinControl.ComponentState) then
////  begin
//  if Button={$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft then
//  begin
//    Self.Invalidate;
//  end;
////  end;
//end;
//
//procedure TSkinSwitchType.TextChanged;
//begin
//  inherited;
//  Self.FSkinSwitchIntf.Prop.AdjustAutoSizeBounds;
//  Self.Invalidate;
//end;

{ TSkinSwitchDefaultType }


function TSkinSwitchDefaultType.GetSkinMaterial: TSkinSwitchDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinSwitchDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinSwitchDefaultType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
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
      if Self.FSkinSwitchIntf.Prop.Checked then
        APicture:=GetSkinMaterial.FDisabledCheckedPicture
      else
        APicture:=GetSkinMaterial.FDisabledUnCheckedPicture;
    end
//    else if Self.FSkinControlIntf.IsMouseOver and AIsDrawInteractiveState then
//    begin
//      if Self.FSkinSwitchIntf.Prop.Checked then
//        APicture:=GetSkinMaterial.FHoverCheckedPicture
//      else
//        APicture:=GetSkinMaterial.FHoverUnCheckedPicture;
//    end
    else
    begin
      if Self.FSkinSwitchIntf.Prop.Checked then
        APicture:=GetSkinMaterial.FNormalCheckedPicture
      else
        APicture:=GetSkinMaterial.FNormalUnCheckedPicture;
    end;


    if APicture.CurrentPictureIsEmpty then
    begin
      if Self.FSkinSwitchIntf.Prop.Checked then
        APicture:=GetSkinMaterial.FNormalCheckedPicture
      else
        APicture:=GetSkinMaterial.FNormalUnCheckedPicture;
    end;

//    if GetSkinMaterial.FIsAutoPosition then
//    begin
//        APictureDrawRect:=ADrawRect;
//        APictureDrawRect.Right:=APictureDrawRect.Left;
//        if    (Not APicture.CurrentPictureIsEmpty)
//          then
//        begin
//          APictureDrawRect.Left:=APictureDrawRect.Left;
//          APictureDrawRect.Top:=APictureDrawRect.Top;
//          APictureDrawRect.Right:=APictureDrawRect.Left+APictureDrawRect.Height;
//          APictureDrawRect.Bottom:=APictureDrawRect.Top+APictureDrawRect.Height;
//          ACanvas.DrawPicture(GetSkinMaterial.FDrawPictureParam,APicture,APictureDrawRect);
//        end;
//        ACanvas.DrawPicture(GetSkinMaterial.FDrawPictureParam,APicture,APictureDrawRect);
//
//        ACaptionDrawRect:=ADrawRect;
//        ACaptionDrawRect.Left:=APictureDrawRect.Right;
//        ACanvas.DrawText(GetSkinMaterial.FDrawCaptionParam,Self.FSkinControlIntf.Caption,ACaptionDrawRect);
//    end
//    else
//    begin
        ACanvas.DrawPicture(GetSkinMaterial.FDrawPictureParam,APicture,ADrawRect);
//        ACanvas.DrawText(GetSkinMaterial.FDrawCaptionParam,Self.FSkinControlIntf.Caption,ADrawRect);
//    end;

  end;
end;

{ TSkinSwitchDefaultMaterial }

constructor TSkinSwitchDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNormalCheckedPicture:=CreateDrawPicture('NormalCheckedPicture','正常状态时已勾选图片','已勾选所有状态图片');
//  FHoverCheckedPicture:=CreateDrawPicture('HoverCheckedPicture','鼠标停靠时已勾选图片','已勾选所有状态图片');
  FDisabledCheckedPicture:=CreateDrawPicture('DisabledCheckedPicture','禁用状态时已勾选图片','已勾选所有状态图片');

  FNormalUnCheckedPicture:=CreateDrawPicture('NormalUnCheckedPicture','正常状态时未勾选图片','未勾选所有状态图片');
//  FHoverUnCheckedPicture:=CreateDrawPicture('HoverUnCheckedPicture','鼠标停靠时未勾选图片','未勾选所有状态图片');
  FDisabledUnCheckedPicture:=CreateDrawPicture('DisabledUnCheckedPicture','禁用状态时未勾选图片','未勾选所有状态图片');
end;

//function TSkinSwitchDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
//function TSkinSwitchDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
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

destructor TSkinSwitchDefaultMaterial.Destroy;
begin
//  FreeAndNil(FHoverCheckedPicture);
//  FreeAndNil(FHoverUnCheckedPicture);
  FreeAndNil(FNormalCheckedPicture);
  FreeAndNil(FNormalUnCheckedPicture);
  FreeAndNil(FDisabledCheckedPicture);
  FreeAndNil(FDisabledUnCheckedPicture);
  inherited;
end;

procedure TSkinSwitchDefaultMaterial.SetDisabledCheckedDrawPicture(const Value: TDrawPicture);
begin
  FDisabledCheckedPicture.Assign(Value);
end;

procedure TSkinSwitchDefaultMaterial.SetDisabledUnCheckedDrawPicture(const Value: TDrawPicture);
begin
  FDisabledUnCheckedPicture.Assign(Value);
end;
//
//procedure TSkinSwitchDefaultMaterial.SetHoverCheckedDrawPicture(const Value: TDrawPicture);
//begin
//  FHoverCheckedPicture.Assign(Value);
//end;
//
//procedure TSkinSwitchDefaultMaterial.SetHoverUnCheckedDrawPicture(const Value: TDrawPicture);
//begin
//  FHoverUnCheckedPicture.Assign(Value);
//end;

procedure TSkinSwitchDefaultMaterial.SetNormalCheckedDrawPicture(const Value: TDrawPicture);
begin
  FNormalCheckedPicture.Assign(Value);
end;

procedure TSkinSwitchDefaultMaterial.SetNormalUnCheckedDrawPicture(const Value: TDrawPicture);
begin
  FNormalUnCheckedPicture.Assign(Value);
end;



//{ TSkinSwitchSimpleMaterial }
//
//constructor TSkinSwitchSimpleMaterial.Create(AOwner: TComponent);
//begin
//  inherited Create(AOwner);
//
//  FUnCheckedPicture:=CreateDrawPicture('UnCheckedPicture','鼠标停靠时已勾选图片');
//  FCheckedPicture:=CreateDrawPicture('CheckedPicture','鼠标停靠时已勾选图片');
//
////  FAllStatePictureColCount:=0;
//
//  FHoverPicture:=CreateDrawPicture('HoverPicture','鼠标停靠时方框图片');
//  FNormalPicture:=CreateDrawPicture('NormalPicture','正常状态时方框图片');
//  FDownPicture:=CreateDrawPicture('DownPicture','鼠标按下时方框图片');
//  FDisabledPicture:=CreateDrawPicture('DisabledPicture','禁用状态时已勾选图片');
//
//end;
//
//function TSkinSwitchSimpleMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  I: Integer;
//  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited LoadFromDocNode(ADocNode);
//
//  for I := 0 to ADocNode.ChildNodes.Count - 1 do
//  begin
//    ABTNode:=ADocNode.ChildNodes[I];
////    if ABTNode.NodeName='CheckedPicture' then
////    begin
////      FCheckedPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='UnCheckedPicture' then
////    begin
////      FUnCheckedPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else
////    if ABTNode.NodeName='AllStatePictureColCount' then
////    begin
////      FAllStatePictureColCount:=ABTNode.ConvertNode_Int32.Data;
////    end
////    else
////    if ABTNode.NodeName='NormalPicture' then
////    begin
////      FNormalPicture:=ABTNode.ConvertNode_Int32.Data;
////    end
////    else if ABTNode.NodeName='HoverPicture' then
////    begin
////      FHoverPicture:=ABTNode.ConvertNode_Int32.Data;
////    end
////    else if ABTNode.NodeName='DownPicture' then
////    begin
////      FDownPicture:=ABTNode.ConvertNode_Int32.Data;
////    end
////    else if ABTNode.NodeName='DisabledPicture' then
////    begin
////      FDisabledPicture:=ABTNode.ConvertNode_Int32.Data;
////    end
////    ;
//
//  end;
//
//  Result:=True;
//end;
//
//function TSkinSwitchSimpleMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited SaveToDocNode(ADocNode);
//
//
//  ABTNode:=ADocNode.AddChildNode_Class('CheckedPicture',FCheckedPicture.Name);
//  Self.FCheckedPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
//  ABTNode:=ADocNode.AddChildNode_Class('UnCheckedPicture',FUnCheckedPicture.Name);
//  Self.FUnCheckedPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
//
////  ABTNode:=ADocNode.AddChildNode_Int32('AllStatePictureColCount','图片列数');
////  ABTNode.ConvertNode_Int32.Data:=FAllStatePictureColCount;
////
////  ABTNode:=ADocNode.AddChildNode_Int32('NormalPicture','正常状态时图片列下标');
////  ABTNode.ConvertNode_Int32.Data:=FNormalPicture;
////
////  ABTNode:=ADocNode.AddChildNode_Int32('HoverPicture','鼠标停靠时图片列下标');
////  ABTNode.ConvertNode_Int32.Data:=FHoverPicture;
////
////  ABTNode:=ADocNode.AddChildNode_Int32('DownPicture','鼠标按下时图片列图片');
////  ABTNode.ConvertNode_Int32.Data:=FDownPicture;
////
////  ABTNode:=ADocNode.AddChildNode_Int32('DisabledPicture','禁用状态时图片列下标');
////  ABTNode.ConvertNode_Int32.Data:=FDisabledPicture;
//
//
//  Result:=True;
//end;
//
//destructor TSkinSwitchSimpleMaterial.Destroy;
//begin
//  FreeAndNil(FCheckedPicture);
//  FreeAndNil(FUnCheckedPicture);
//  inherited;
//end;
//
//procedure TSkinSwitchSimpleMaterial.SetCheckedPicture(const Value: TDrawPicture);
//begin
//  FCheckedPicture.Assign(Value);
//end;
//
//procedure TSkinSwitchSimpleMaterial.SetDisabledPicture(const Value: TDrawPicture);
//begin
//  FDisabledPicture.Assign(Value);
//end;
//
//procedure TSkinSwitchSimpleMaterial.SetDownPicture(const Value: TDrawPicture);
//begin
//  FDownPicture.Assign(Value);
//end;
//
//procedure TSkinSwitchSimpleMaterial.SetHoverPicture(const Value: TDrawPicture);
//begin
//  FHoverPicture.Assign(Value);
//end;
//
//procedure TSkinSwitchSimpleMaterial.SetNormalPicture(const Value: TDrawPicture);
//begin
//  FNormalPicture.Assign(Value);
//end;
//
////procedure TSkinSwitchSimpleMaterial.SetAllStatePictureColCount(const Value: Integer);
////begin
////  FAllStatePictureColCount := Value;
////end;
//
//procedure TSkinSwitchSimpleMaterial.SetUnCheckedPicture(const Value: TDrawPicture);
//begin
//  FUnCheckedPicture.Assign(Value);
//end;
//
//{ TSkinSwitchSimpleType }
//
//function TSkinSwitchSimpleType.CalcAutoSize(var Width,Height: Integer): Boolean;
////var
////  ABufferBitmap:TBufferBitmap;
//begin
//  Result:=False;
//  Width:=0;
//  Height:=0;
////  ABufferBitmap:=TBufferBitmap.Create;
////  try
////    ABufferBitmap.CreateBufferBitmap(1,1);
//    if (GetGlobalAutoSizeBufferBitmap.DrawCanvas<>nil)
//    and (Self.GetSkinMaterial<>nil) then
//    begin
////      try
//        Result:=GetGlobalAutoSizeBufferBitmap.DrawCanvas.CalcTextDrawSize(Self.GetSkinMaterial.FDrawCaptionParam,Self.FSkinSwitchIntf.Caption,
//                            Width,Height,cdstBoth);
//        if Self.GetSkinMaterial.FAllStatePictureColCount>0 then
//        begin
//          Width:=Width
//            +Self.GetSkinMaterial.FUnCheckedPicture.Width div Self.GetSkinMaterial.FAllStatePictureColCount+10;
//          if Self.GetSkinMaterial.FUnCheckedPicture.Height>Height then
//          begin
//            Height:=Self.GetSkinMaterial.FUnCheckedPicture.Height;
//          end;
//        end;
////      finally
////      end;
//    end;
////  finally
////    FreeAndNil(ABufferBitmap);
////  end;
//end;
//
//function TSkinSwitchSimpleType.GetSkinMaterial: TSkinSwitchSimpleMaterial;
//begin
//  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
//  begin
//    Result:=TSkinSwitchSimpleMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
//  end
//  else
//  begin
//    Result:=nil;
//  end;
//end;
//
//function TSkinSwitchSimpleType.CustomPaint(ACanvas: TDrawCanvas;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
//var
//  ADrawPicture:TDrawPicture;
//  ACaptionDrawRect:TRectF;
//  APictureDrawRect:TRectF;
//begin
//  if GetSkinMaterial<>nil then
//  begin
//    ADrawPicture:=-1;
//
//    if Not Self.FSkinControlIntf.Enabled then
//    begin
//      ADrawPicture:=GetSkinMaterial.FDisabledPicture;
//    end
//    else if Self.FSkinControlIntf.IsMouseDown and AIsDrawInteractiveState then
//    begin
//      ADrawPicture:=GetSkinMaterial.FDownPicture;
//    end
//    else if Self.FSkinControlIntf.IsMouseOver and AIsDrawInteractiveState then
//    begin
//      ADrawPicture:=GetSkinMaterial.FHoverPicture;
//    end
//    else
//    begin
//      ADrawPicture:=GetSkinMaterial.FNormalPicture;
//    end;
//
//
//
//    if GetSkinMaterial.FIsAutoPosition then
//    begin
//        APictureDrawRect:=ADrawRect;
//        APictureDrawRect.Right:=APictureDrawRect.Left;
//        if    (Not GetSkinMaterial.FUnCheckedPicture.IsEmpty)
//          and (GetSkinMaterial.FUnCheckedPicture.Height>0)
//          and (GetSkinMaterial.FUnCheckedPicture.Width>0)
//          and (GetSkinMaterial.FAllStatePictureColCount>0)
//          and (ADrawPicture>=0)
//          and (ADrawPicture<GetSkinMaterial.FAllStatePictureColCount) then
//        begin
//          APictureDrawRect.Left:=APictureDrawRect.Left;
//          APictureDrawRect.Top:=APictureDrawRect.Top;//(RectHeight(APictureDrawRect)-GetSkinMaterial.FUnCheckedPicture.Height) div 2;
//          APictureDrawRect.Right:=APictureDrawRect.Left+APictureDrawRect.Height;//GetSkinMaterial.FUnCheckedPicture.Width div Self.GetSkinMaterial.FAllStatePictureColCount;
//          APictureDrawRect.Bottom:=APictureDrawRect.Top+APictureDrawRect.Height;//GetSkinMaterial.FUnCheckedPicture.Height;
//          if Self.FSkinSwitchIntf.Prop.Checked then
//          begin
//            ACanvas.DrawPicture(GetSkinMaterial.FDrawPictureParam,GetSkinMaterial.FCheckedPicture,APictureDrawRect,
//                  True,
//                  1,GetSkinMaterial.FAllStatePictureColCount,
//                  0,ADrawPicture);
//          end
//          else
//          begin
//            ACanvas.DrawPicture(GetSkinMaterial.FDrawPictureParam,GetSkinMaterial.FUnCheckedPicture,APictureDrawRect,
//                  True,
//                  1,GetSkinMaterial.FAllStatePictureColCount,
//                  0,ADrawPicture);
//          end;
//        end;
//        ACaptionDrawRect:=ADrawRect;
//        ACaptionDrawRect.Left:=APictureDrawRect.Right;
//        ACanvas.DrawText(GetSkinMaterial.FDrawCaptionParam,Self.FSkinSwitchIntf.Caption,ACaptionDrawRect);
//
//    end
//    else
//    begin
//
//        if Self.FSkinSwitchIntf.Prop.Checked then
//        begin
//          ACanvas.DrawPicture(GetSkinMaterial.FDrawPictureParam,GetSkinMaterial.FCheckedPicture,ADrawRect,
//                True,
//                1,GetSkinMaterial.FAllStatePictureColCount,
//                0,ADrawPicture);
//        end
//        else
//        begin
//          ACanvas.DrawPicture(GetSkinMaterial.FDrawPictureParam,GetSkinMaterial.FUnCheckedPicture,ADrawRect,
//                True,
//                1,GetSkinMaterial.FAllStatePictureColCount,
//                0,ADrawPicture);
//        end;
//        ACanvas.DrawText(GetSkinMaterial.FDrawCaptionParam,Self.FSkinSwitchIntf.Caption,ADrawRect);
//
//    end;
//
//
//  end;
//end;



{ TSkinSwitchMaterial }

constructor TSkinSwitchMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

//  FIsAutoPosition := True;
//
//  FDrawCaptionParam:=CreateDrawTextParam('DrawCaptionParam','标题绘制参数');
////  FDrawCaptionParam.IsDrawInRect:=True;
//  FDrawCaptionParam.FontVertAlign:=fvaCenter;

  FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','勾选框图片绘制参数');
//  FDrawPictureParam.PictureVertAlign:=pvaCenter;
end;
//
//function TSkinSwitchMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
////    end;
////
////  end;
//
//  Result:=True;
//
//end;
//
//function TSkinSwitchMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited SaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawCaptionParam',FDrawCaptionParam.Name);
////  Self.FDrawCaptionParam.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('DrawPictureParam',FDrawPictureParam.Name);
////  Self.FDrawPictureParam.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//  Result:=True;
//end;

destructor TSkinSwitchMaterial.Destroy;
begin
  FreeAndNil(FDrawPictureParam);
//  FreeAndNil(FDrawCaptionParam);

  inherited;
end;
//
//procedure TSkinSwitchMaterial.SetDrawCaptionParam(const Value: TDrawTextParam);
//begin
//  FDrawCaptionParam.Assign(Value);
//end;

procedure TSkinSwitchMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;
//
//procedure TSkinSwitchMaterial.SetIsAutoPosition(const Value: Boolean);
//begin
//  if FIsAutoPosition<>Value then
//  begin
//    FIsAutoPosition := Value;
//    DoChange;
//  end;
//end;

function TSwitchProperties.GetComponentClassify: String;
begin
  Result:='SkinSwitch';
end;

procedure TSwitchProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
  Self.FChecked:=TSwitchProperties(Src).FChecked;
//  Self.FIsAutoChecked:=TSwitchProperties(Src).FIsAutoChecked;
//  Self.FIsAutoCaption:=TSwitchProperties(Src).FIsAutoCaption;
//  Self.FCheckedCaption:=TSwitchProperties(Src).FCheckedCaption;
//  Self.FUnCheckedCaption:=TSwitchProperties(Src).FUnCheckedCaption;
//  AutoCaption;
end;

//procedure TSwitchProperties.AutoCaption;
//begin
//  if Self.FIsAutoCaption then
//  begin
//    if Self.FChecked then
//    begin
//      Self.FSkinControlIntf.Caption:=Self.FCheckedCaption;
//    end
//    else
//    begin
//      Self.FSkinControlIntf.Caption:=Self.FUnCheckedCaption;
//    end;
//  end;
//end;

constructor TSwitchProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinSwitch,Self.FSkinSwitchIntf) then
  begin
    ShowException('This Component Do not Support ISkinSwitch Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=40;
    Self.FSkinControlIntf.Height:=22;
//    Self.FIsAutoChecked:=True;
//    Self.FIsAutoCaption:=False;
  end;
end;

destructor TSwitchProperties.Destroy;
begin
  inherited;
end;

procedure TSwitchProperties.SetChecked(const Value: Boolean);
begin
  if FChecked<>Value then
  begin
    Self.FChecked:=Value;
//    AutoCaption;
    Invalidate;
  end;
end;

//procedure TSwitchProperties.SetCheckedCaption(const Value: String);
//begin
//  if FCheckedCaption<>Value then
//  begin
//    Self.FCheckedCaption:=Value;
//    AutoCaption;
//  end;
//end;
//
//procedure TSwitchProperties.SetIsAutoCaption(const Value: Boolean);
//begin
//  if FIsAutoCaption<>Value then
//  begin
//    Self.FIsAutoCaption:=Value;
//    AutoCaption;
//  end;
//end;
//
//procedure TSwitchProperties.SetIsAutoChecked(const Value: Boolean);
//begin
//  if FIsAutoChecked<>Value then
//  begin
//    Self.FIsAutoChecked:=Value;
//    Invalidate;
//  end;
//end;
//
//procedure TSwitchProperties.SetUnCheckedCaption(const Value: String);
//begin
//  if FUnCheckedCaption<>Value then
//  begin
//    Self.FUnCheckedCaption:=Value;
//    AutoCaption;
//  end;
//end;






{ TSkinSwitch }

function TSkinSwitch.Material:TSkinSwitchDefaultMaterial;
begin
  Result:=TSkinSwitchDefaultMaterial(SelfOwnMaterial);
end;

function TSkinSwitch.SelfOwnMaterialToDefault:TSkinSwitchDefaultMaterial;
begin
  Result:=TSkinSwitchDefaultMaterial(SelfOwnMaterial);
end;

function TSkinSwitch.CurrentUseMaterialToDefault:TSkinSwitchDefaultMaterial;
begin
  Result:=TSkinSwitchDefaultMaterial(CurrentUseMaterial);
end;

procedure TSkinSwitch.Click;
begin
  GetSwitchProperties.Checked:=Not GetSwitchProperties.Checked;
  inherited;
end;

function TSkinSwitch.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TSwitchProperties;
end;

function TSkinSwitch.GetSwitchProperties: TSwitchProperties;
begin
  Result:=TSwitchProperties(Self.FProperties);
end;

procedure TSkinSwitch.SetControlValueByBindItemField(const AFieldName: String;
  const AFieldValue: Variant; ASkinItem: TObject;
  AIsDrawItemInteractiveState: Boolean);
var
  AAFieldValueStr:String;
begin
  if VarType(AFieldValue)=varBoolean then
  begin
      Self.GetSwitchProperties.Checked:=AFieldValue;
  end
  else
  begin
      if Self.FBindItemFieldTrueValue<>'' then
      begin
        AAFieldValueStr:=AFieldValue;
        Self.GetSwitchProperties.Checked:=(Self.FBindItemFieldTrueValue=AAFieldValueStr);
      end;

  end;

end;

procedure TSkinSwitch.SetSwitchProperties(Value: TSwitchProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinSwitch.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetSwitchProperties.AdjustAutoSizeBounds;
  end;
  Inherited;
end;

procedure TSkinSwitch.BindingItemBool(ABool:Boolean;AIsDrawItemInteractiveState:Boolean);
begin
  Self.GetSwitchProperties.Checked:=ABool;
end;

//procedure TSkinSwitch.BindingItemIcon(AIcon:TDrawPicture;AImageList:TObject;AImageIndex:Integer;ARefPicture:TSkinPicture;AIsDrawItemInteractiveState:Boolean);
//begin
//
//end;





end.



