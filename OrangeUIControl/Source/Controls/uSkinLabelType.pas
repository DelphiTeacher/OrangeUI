//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     标签
///   </para>
///   <para>
///     Label
///   </para>
/// </summary>
unit uSkinLabelType;

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
  ExtCtrls,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  {$ENDIF}

  uSkinAnimator,
  uBaseLog,
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
  uDrawTextParam,
  uSkinRegManager,
  uDrawPictureParam;



const
  IID_ISkinLabel:TGUID='{507F6B92-24C0-4546-8A59-01C8849AF54B}';
  IID_ISkinRollLabel:TGUID='{D716F594-3D0C-4150-AE85-BC1A871D599F}';
  IID_ISkinHintLabel:TGUID='{2E7C6A47-91D8-41D0-8BA3-926B35287FA2}';

type
  TLabelProperties=class;
  TRollLabelProperties=class;
  THintLabelProperties=class;




  /// <summary>
  ///   <para>
  ///     标签接口
  ///   </para>
  ///   <para>
  ///     Interface of label
  ///   </para>
  /// </summary>
  ISkinLabel=interface//(ISkinControl)
  ['{507F6B92-24C0-4546-8A59-01C8849AF54B}']
    function GetCaption:String;
    procedure SetCaption(const Value:String);
    property Caption:String read GetCaption write SetCaption;

    function GetLabelProperties:TLabelProperties;
    property Properties:TLabelProperties read GetLabelProperties;
    property Prop:TLabelProperties read GetLabelProperties;
  end;



  ISkinRollLabel=interface//(ISkinControl)
    ['{D716F594-3D0C-4150-AE85-BC1A871D599F}']
    function GetRollLabelProperties:TRollLabelProperties;
    property Properties:TRollLabelProperties read GetRollLabelProperties;
    property Prop:TRollLabelProperties read GetRollLabelProperties;
  end;




  ISkinHintLabel=interface//(ISkinControl)
    ['{2E7C6A47-91D8-41D0-8BA3-926B35287FA2}']
    function GetHintLabelProperties:THintLabelProperties;
    property Properties:THintLabelProperties read GetHintLabelProperties;
    property Prop:THintLabelProperties read GetHintLabelProperties;
  end;






  /// <summary>
  ///   <para>
  ///     标签属性
  ///   </para>
  ///   <para>
  ///     Label caption
  ///   </para>
  /// </summary>
  TLabelProperties=class(TSkinControlProperties)
  private
//    FPrefix:String;
//    function GetPrefix: String;
//    procedure SetPrefix(const Value: String);
  protected
    FSkinLabelIntf:ISkinLabel;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  published
    property AutoSize;
    //前缀,比如¥
//    property Prefix:String read GetPrefix write SetPrefix;
  end;




  TRollLabelProperties=class(TLabelProperties)
  private
    FEffectType: TAnimateSwitchEffectType;
    procedure DoTween(Sender:TObject;var NeedStop:Boolean);
    procedure DoCheckRepeatTimer(Sender:TObject);
    procedure SetEffectType(const Value: TAnimateSwitchEffectType);
    function GetProcessedDrawRect(ADrawRect: TRectF): TRectF;
    function GetSpeed: Double;
    procedure SetSpeed(const Value: Double);
  protected
    FSkinRollLabelIntf:ISkinRollLabel;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    FTween:TTween;
    FCheckRepeatTimer:TTimer;
    //获取分类名称
    function GetComponentClassify:String;override;
  published
    property Speed:Double read GetSpeed write SetSpeed;
    property EffectType:TAnimateSwitchEffectType read FEffectType write SetEffectType;
  end;




  THintLabelProperties=class(TLabelProperties)
  private
    FHint: String;
    procedure SetHint(const Value: String);
  protected
    FSkinHintLabelIntf:ISkinHintLabel;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  published
    property Hint:String read FHint write SetHint;
  end;




  /// <summary>
  ///   <para>
  ///     标签素材基类
  ///   </para>
  ///   <para>
  ///     Base class of label material
  ///   </para>
  /// </summary>
  TSkinLabelMaterial=class(TSkinControlMaterial)
  private
    //标题绘制参数
    FDrawCaptionParam:TDrawTextParam;
    procedure SetDrawCaptionParam(const Value: TDrawTextParam);
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
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

  TSkinHintLabelMaterial=class(TSkinLabelMaterial)
  private
    //标题绘制参数
    FDrawHintParam:TDrawTextParam;
    procedure SetDrawHintParam(const Value: TDrawTextParam);
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    /// <summary>
    ///   <para>
    ///     标题绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of caption
    ///   </para>
    /// </summary>
    property DrawHintParam:TDrawTextParam read FDrawHintParam write SetDrawHintParam;
  end;


  TSkinLabelType=class(TSkinControlType)
  private
    FSkinLabelIntf:ISkinLabel;
    function GetSkinMaterial:TSkinLabelMaterial;
  protected
    function GetDrawCaption:String;virtual;
    function GetProcessedDrawRect(ADrawRect:TRectF):TRectF;virtual;
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    procedure TextChanged;override;
    //计算
    function CalcAutoSize(var AWidth,AHeight:TControlSize):Boolean;override;
  end;


  TSkinRollLabelType=class(TSkinLabelType)
  private
    FSkinRollLabelIntf:ISkinRollLabel;
  protected
    function GetProcessedDrawRect(ADrawRect:TRectF):TRectF;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  end;


  TSkinHintLabelType=class(TSkinLabelType)
  private
    FHintSpace:String;
    FLastCalcHintSpaceFontSize:Double;
    FLastCalcHintSpaceHint:String;
    FSkinHintLabelIntf:ISkinHintLabel;
  protected
    function GetDrawCaption:String;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;







  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinLabelDefaultMaterial=class(TSkinLabelMaterial);
  TSkinLabelDefaultType=TSkinLabelType;





  //TBaseSkinControl是所有OUI控件的基类
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinLabel=class(TBaseSkinControl,
                    ISkinLabel,
                    IBindSkinItemTextControl,
                    IBindSkinItemValueControl,
                    IProcessItemColor)
  private
    function GetLabelProperties:TLabelProperties;
    procedure SetLabelProperties(Value:TLabelProperties);
  protected
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  protected
    //绑定列表项
    procedure BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);

    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);

    //处理列表项的颜色
    procedure ProcessItemColor(AItemColorType:TSkinItemColorType;AItemColor:TDelphiColor;var AOldColor:TDelphiColor);
    procedure RestoreItemColor(AItemColorType:TSkinItemColorType;AItemColor:TDelphiColor;AOldColor:TDelphiColor);
  public
    function SelfOwnMaterialToDefault:TSkinLabelDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinLabelDefaultMaterial;
    function Material:TSkinLabelDefaultMaterial;
  public
    //获取提交的值
    function GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String):Variant;override;
    //设置值
    procedure SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue:Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);override;
  public
    property Prop:TLabelProperties read GetLabelProperties write SetLabelProperties;
  published
    //标题
    property Caption;
    property Text;
    //属性
    property Properties:TLabelProperties read GetLabelProperties write SetLabelProperties;
  end;


  {$IFDEF VCL}
  TSkinWinLabel=class(TSkinLabel)
  end;
  {$ENDIF VCL}


  TSkinChildLabel=TSkinLabel;




  TSkinRollLabel=class(TSkinLabel,ISkinRollLabel)
  private
    function GetRollLabelProperties:TRollLabelProperties;
    procedure SetRollLabelProperties(Value:TRollLabelProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    property Prop:TRollLabelProperties read GetRollLabelProperties write SetRollLabelProperties;
  published
    //属性
    property Properties:TRollLabelProperties read GetRollLabelProperties write SetRollLabelProperties;
  end;

  {$IFDEF VCL}
  TSkinWinRollLabel=class(TSkinRollLabel)
  end;
  {$ENDIF VCL}
  {$IFDEF FMX}
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXRollLabel=class(TSkinRollLabel)
  end;
  {$ENDIF FMX}





  TSkinHintLabel=class(TSkinLabel,ISkinHintLabel)
  private
    function GetHintLabelProperties:THintLabelProperties;
    procedure SetHintLabelProperties(Value:THintLabelProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    //针对页面框架的控件接口
    function LoadFromFieldControlSetting(ASetting:TFieldControlSetting;AFieldControlSettingMap:TObject):Boolean;override;
  public
    property Prop:THintLabelProperties read GetHintLabelProperties write SetHintLabelProperties;
  published
    //属性
    property Properties:THintLabelProperties read GetHintLabelProperties write SetHintLabelProperties;
  end;

  {$IFDEF VCL}
  TSkinWinHintLabel=class(TSkinHintLabel)
  end;
  {$ENDIF VCL}
  {$IFDEF FMX}
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXHintLabel=class(TSkinHintLabel)
  end;
  {$ENDIF FMX}






function CreateChildLabel(AOwner:TComponent):TSkinChildLabel;


implementation

function CreateChildLabel(AOwner:TComponent):TSkinChildLabel;
begin
  Result:=TSkinChildLabel.Create(AOwner);
  Result.Caption:='';
end;


{ TSkinLabelType }

function TSkinLabelType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinLabel,Self.FSkinLabelIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinLabel Interface');
    end;
  end;
end;

procedure TSkinLabelType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinLabelIntf:=nil;
end;

function TSkinLabelType.GetDrawCaption: String;
begin
  Result:=Self.FSkinControlIntf.Caption;
end;

function TSkinLabelType.GetProcessedDrawRect(ADrawRect: TRectF): TRectF;
begin
  Result:=ADrawRect;
end;

function TSkinLabelType.GetSkinMaterial: TSkinLabelMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinLabelMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

procedure TSkinLabelType.TextChanged;
begin
  inherited;
  Self.FSkinLabelIntf.Prop.AdjustAutoSizeBounds;
  Invalidate;
end;

function TSkinLabelType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin
  if Self.GetSkinMaterial<>nil then
  begin
    if Self.FSkinControlIntf.Caption <> '' then
    begin
      ACanvas.DrawText(Self.GetSkinMaterial.FDrawCaptionParam,
//                        Self.FSkinLabelIntf.Prop.FPrefix+
                        GetDrawCaption,
                        GetProcessedDrawRect(ADrawRect));
    end;
  end;
end;

function TSkinLabelType.CalcAutoSize(var AWidth,AHeight: TControlSize): Boolean;
var
  ASize:TSizeF;
begin
  Result:=False;

  if GetSkinMaterial<>nil then
  begin
    ASize:=GetSuitControlStringContentSize(
            GetDrawCaption,
            RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height),
            Self.GetSkinMaterial.FDrawCaptionParam
            );


    AWidth:=ControlSize(ASize.cx);//+10;

    AHeight:=ControlSize(ASize.cy);
  end;

  Result:=True;
end;


{ TSkinLabelMaterial }

constructor TSkinLabelMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDrawCaptionParam:=CreateDrawTextParam('DrawCaptionParam','标题绘制参数');
end;

//function TSkinLabelMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  I: Integer;
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited LoadFromDocNode(ADocNode);
//
////  for I := 0 to ADocNode.ChildNodes.Count - 1 do
////  begin
////    ABTNode:=ADocNode.ChildNodes[I];
////    if ABTNode.NodeName='DrawCaptionParam' then
////    begin
////      FDrawCaptionParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end;
////  end;
//
//  Result:=True;
//end;
//
//function TSkinLabelMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawCaptionParam',FDrawCaptionParam.Name);
////  Self.FDrawCaptionParam.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//  Result:=True;
//end;

destructor TSkinLabelMaterial.Destroy;
begin
  FreeAndNil(FDrawCaptionParam);
  inherited;
end;

procedure TSkinLabelMaterial.SetDrawCaptionParam(const Value: TDrawTextParam);
begin
  FDrawCaptionParam.Assign(Value);
end;

{ TSkinHintLabelMaterial }

constructor TSkinHintLabelMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDrawHintParam:=CreateDrawTextParam('DrawHintParam','标题绘制参数');
end;

//function TSkinHintLabelMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  I: Integer;
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited LoadFromDocNode(ADocNode);
//
////  for I := 0 to ADocNode.ChildNodes.Count - 1 do
////  begin
////    ABTNode:=ADocNode.ChildNodes[I];
////    if ABTNode.NodeName='DrawHintParam' then
////    begin
////      FDrawHintParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end;
////  end;
//
//  Result:=True;
//end;
//
//function TSkinHintLabelMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawHintParam',FDrawHintParam.Name);
////  Self.FDrawHintParam.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//  Result:=True;
//end;

destructor TSkinHintLabelMaterial.Destroy;
begin
  FreeAndNil(FDrawHintParam);
  inherited;
end;

procedure TSkinHintLabelMaterial.SetDrawHintParam(const Value: TDrawTextParam);
begin
  FDrawHintParam.Assign(Value);
end;

{ TLabelProperties }


constructor TLabelProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinLabel,Self.FSkinLabelIntf) then
  begin
    ShowException('This Component Do not Support ISkinLabel Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=120;
    Self.FSkinControlIntf.Height:=22;
  end;
end;

destructor TLabelProperties.Destroy;
begin
  inherited;
end;


function TLabelProperties.GetComponentClassify: String;
begin
  Result:='SkinLabel';
end;



//function TLabelProperties.GetPrefix: String;
//begin
//
//end;
//
//procedure TLabelProperties.SetPrefix(const Value: String);
//begin
//
//end;

{ TSkinLabel }

function TSkinLabel.Material:TSkinLabelDefaultMaterial;
begin
  Result:=TSkinLabelDefaultMaterial(SelfOwnMaterial);
end;

function TSkinLabel.SelfOwnMaterialToDefault:TSkinLabelDefaultMaterial;
begin
  Result:=TSkinLabelDefaultMaterial(SelfOwnMaterial);
end;

//function TSkinLabel.RefMaterialToDefault:TSkinLabelDefaultMaterial;
//begin
//  Result:=TSkinLabelDefaultMaterial(RefMaterial);
//end;

function TSkinLabel.CurrentUseMaterialToDefault:TSkinLabelDefaultMaterial;
begin
  Result:=TSkinLabelDefaultMaterial(CurrentUseMaterial);
end;

function TSkinLabel.GetPostValue(ASetting:TFieldControlSetting;APageDataDir:String;ASetRecordFieldValueIntf:ISetRecordFieldValue;
                            var AErrorMessage:String): Variant;
begin
  Result:=Caption;
end;

procedure TSkinLabel.SetControlValue(ASetting:TFieldControlSetting;APageDataDir:String;AImageServerUrl:String;AValue: Variant;AValueCaption:String;
                            //要设置多个值,整个字段的记录
                            AGetDataIntfResultFieldValueIntf:IGetDataIntfResultFieldValue);
begin
  Caption:=AValue;
end;

function TSkinLabel.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TLabelProperties;
end;

function TSkinLabel.GetLabelProperties: TLabelProperties;
begin
  Result:=TLabelProperties(Self.FProperties);
end;

procedure TSkinLabel.SetControlValueByBindItemField(const AFieldName: String;
  const AFieldValue: Variant; ASkinItem: TObject;
  AIsDrawItemInteractiveState: Boolean);
begin
  Caption:=AFieldValue;
end;

procedure TSkinLabel.SetLabelProperties(Value: TLabelProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinLabel.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetLabelProperties.AdjustAutoSizeBounds;
  end;
  Inherited;
end;

procedure TSkinLabel.BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
begin
  Caption:=AText;
end;

procedure TSkinLabel.ProcessItemColor(AItemColorType:TSkinItemColorType;AItemColor:TDelphiColor;var AOldColor:TDelphiColor);
begin
  case AItemColorType of
    sictNone: ;
    sictBackColor:
    begin
      //背景颜色
    end;
    sictCaptionFontColor,
    sictDetailFontColor,
    sictDetail1FontColor,
    sictDetail2FontColor,
    sictDetail3FontColor,
    sictDetail4FontColor,
    sictDetail5FontColor,
    sictDetail6FontColor:
    begin
      //标题字体颜色
      if SelfOwnMaterialToDefault<>nil then
      begin
        AOldColor:=SelfOwnMaterialToDefault.DrawCaptionParam.FontColor;
        SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=AItemColor;
      end;
    end;
  end;
end;

procedure TSkinLabel.RestoreItemColor(AItemColorType:TSkinItemColorType;AItemColor:TDelphiColor;AOldColor:TDelphiColor);
begin
  case AItemColorType of
    sictNone: ;
    sictBackColor:
    begin
      //背景颜色
    end;
    sictCaptionFontColor,
    sictDetailFontColor,
    sictDetail1FontColor,
    sictDetail2FontColor,
    sictDetail3FontColor,
    sictDetail4FontColor,
    sictDetail5FontColor,
    sictDetail6FontColor:
    begin
      //标题字体颜色
      if SelfOwnMaterialToDefault<>nil then
      begin
        SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=AOldColor;
      end;
    end;
  end;
end;


{ TRollLabelProperties }

constructor TRollLabelProperties.Create(ASkinControl: TControl);
begin
  inherited Create(ASkinControl);

  if Not ASkinControl.GetInterface(IID_ISkinRollLabel,Self.FSkinRollLabelIntf) then
  begin
    ShowException('This Component Do not Support ISkinRollLabel Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=120;
    Self.FSkinControlIntf.Height:=22;
  end;


  FTween:=TTween.Create(nil);
//    //当前次数
//    t,
//    //初始位置
//    b,
//    //总距离
//    c,
//    //总次数
//    d,
//    //当前位置
//    p,
  FTween.t:=0;
  FTween.b:=0;
  FTween.c:=Self.FSkinControlIntf.Width;
  FTween.d:=100;
  FTween.OnTween:=DoTween;


  //检测重复启动的定时器
  FCheckRepeatTimer:=TTimer.Create(nil);
  FCheckRepeatTimer.Interval:=1000;
  FCheckRepeatTimer.OnTimer:=Self.DoCheckRepeatTimer;
  FCheckRepeatTimer.Enabled:=True;



  FEffectType:=TAnimateSwitchEffectType.ilasetMoveHorz;
end;

destructor TRollLabelProperties.Destroy;
begin
  FreeAndNil(FCheckRepeatTimer);
  FreeAndNil(FTween);
  inherited;
end;

procedure TRollLabelProperties.DoCheckRepeatTimer(Sender: TObject);
var
  ACaptionWidth,ACaptionHeight:TControlSize;
begin
  //检测各项参数
//    //总距离
//    c,
//    //总次数
//    d,

  //计算标题所需要绘制的尺寸
  if Self.FSkinControlIntf.GetSkinControlType.CalcAutoSize(ACaptionWidth,ACaptionHeight) then
  begin
      case Self.FEffectType of
        ilasetNone: ;
        ilasetMoveHorz:
        begin
            //水平移动
            FTween.c:=Self.FSkinControlIntf.Width+ACaptionWidth;
            FTween.d:=Self.FSkinControlIntf.Width+ACaptionWidth;
        end;
        ilasetMoveVert:
        begin
            //垂直移动
            FTween.c:=Self.FSkinControlIntf.Height+ACaptionHeight;
            FTween.d:=Self.FSkinControlIntf.Height+ACaptionHeight;
        end;
      end;

      if FEffectType<>ilasetNone then
      begin
          //如果滚动完一遍,再重新滚动一遍
          if not FTween.IsRuning then
          begin
            FTween.Run;
          end;
      end;
  end;


end;

procedure TRollLabelProperties.DoTween(Sender: TObject; var NeedStop: Boolean);
begin
  Self.Invalidate;
end;

function TRollLabelProperties.GetComponentClassify: String;
begin
  Result:='SkinRollLabel';
end;

procedure TRollLabelProperties.SetEffectType(const Value: TAnimateSwitchEffectType);
begin
  if FEffectType<>Value then
  begin
    FEffectType := Value;

    Self.FCheckRepeatTimer.Enabled:=(FEffectType<>ilasetNone)
  end;
end;

procedure TRollLabelProperties.SetSpeed(const Value: Double);
begin
  FTween.Speed:=Value;
end;

function TRollLabelProperties.GetProcessedDrawRect(ADrawRect: TRectF): TRectF;
begin
  Result:=ADrawRect;
  case Self.FEffectType of
    ilasetNone: ;
    ilasetMoveHorz:
    begin
          Result.Left:=ADrawRect.Right;
          Result.Right:=Result.Left+ADrawRect.Width;


          Result.Left:=Result.Left-Self.FTween.p;
          Result.Right:=Result.Right-Self.FTween.p;
    end;
    ilasetMoveVert:
    begin
          Result.Top:=ADrawRect.Bottom;
          Result.Bottom:=Result.Top+ADrawRect.Height;


          Result.Top:=Result.Top-Self.FTween.p;
          Result.Bottom:=Result.Bottom-Self.FTween.p;
    end;
  end;
end;


function TRollLabelProperties.GetSpeed: Double;
begin
  Result:=FTween.Speed;
end;



{ THintLabelProperties }

constructor THintLabelProperties.Create(ASkinControl: TControl);
begin
  inherited Create(ASkinControl);

  if Not ASkinControl.GetInterface(IID_ISkinHintLabel,Self.FSkinHintLabelIntf) then
  begin
    ShowException('This Component Do not Support ISkinHintLabel Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=120;
    Self.FSkinControlIntf.Height:=22;
  end;
end;

destructor THintLabelProperties.Destroy;
begin
  inherited;
end;


function THintLabelProperties.GetComponentClassify: String;
begin
  Result:='SkinHintLabel';
end;

procedure THintLabelProperties.SetHint(const Value: String);
begin
  if FHint<>Value then
  begin
    FHint := Value;
    Self.Invalidate;
  end;
end;

{ TSkinRollLabelType }

function TSkinRollLabelType.CustomBind(ASkinControl: TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinRollLabel,Self.FSkinRollLabelIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinRollLabel Interface');
    end;
  end;

end;

procedure TSkinRollLabelType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinRollLabelIntf:=nil;

end;

function TSkinRollLabelType.GetProcessedDrawRect(ADrawRect: TRectF): TRectF;
begin
//  Result:=ADrawRect;
  Result:=Self.FSkinRollLabelIntf.Prop.GetProcessedDrawRect(ADrawRect);
end;

{ TSkinHintLabelType }

function TSkinHintLabelType.CustomBind(ASkinControl: TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinHintLabel,Self.FSkinHintLabelIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinHintLabel Interface');
    end;
  end;

end;

function TSkinHintLabelType.CustomPaint(ACanvas: TDrawCanvas;
  ASkinMaterial: TSkinControlMaterial; const ADrawRect: TRectF;
  APaintData: TPaintData): Boolean;
begin
  //绘制提示
    if Self.FSkinHintLabelIntf.Properties.FHint <> '' then
    begin
      if (FLastCalcHintSpaceFontSize<>TSkinHintLabelMaterial(ASkinMaterial).FDrawHintParam.FontSize)
        or (FLastCalcHintSpaceHint<>Self.FSkinHintLabelIntf.Properties.FHint) then
      begin
        FHintSpace:=GetStringSpace(Self.FSkinHintLabelIntf.Properties.FHint,TSkinHintLabelMaterial(ASkinMaterial).FDrawHintParam.FontSize);
        FLastCalcHintSpaceFontSize:=TSkinHintLabelMaterial(ASkinMaterial).FDrawHintParam.FontSize;
        FLastCalcHintSpaceHint:=Self.FSkinHintLabelIntf.Properties.FHint;
      end;

      ACanvas.DrawText(TSkinHintLabelMaterial(ASkinMaterial).FDrawHintParam,
//                        Self.FSkinLabelIntf.Prop.FPrefix+
                        Self.FSkinHintLabelIntf.Properties.FHint,
                        ADrawRect);
    end;

  Result:=Inherited;

end;

procedure TSkinHintLabelType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinHintLabelIntf:=nil;

end;

function TSkinHintLabelType.GetDrawCaption: String;
begin
  Result:=FHintSpace+Inherited;
end;

{ TSkinRollLabel }

function TSkinRollLabel.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TRollLabelProperties;
end;

function TSkinRollLabel.GetRollLabelProperties: TRollLabelProperties;
begin
  Result:=TRollLabelProperties(Self.FProperties);
end;

procedure TSkinRollLabel.SetRollLabelProperties(Value: TRollLabelProperties);
begin
  Self.FProperties.Assign(Value);
end;

{ TSkinHintLabel }

function TSkinHintLabel.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=THintLabelProperties;
end;

function TSkinHintLabel.LoadFromFieldControlSetting(
  ASetting: TFieldControlSetting; AFieldControlSettingMap: TObject): Boolean;
begin
  Result:=Inherited;
  Self.Prop.Hint:=ASetting.field_caption+':';
end;

function TSkinHintLabel.GetHintLabelProperties: THintLabelProperties;
begin
  Result:=THintLabelProperties(Self.FProperties);
end;

procedure TSkinHintLabel.SetHintLabelProperties(Value: THintLabelProperties);
begin
  Self.FProperties.Assign(Value);
end;

end.



