//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     圆形图片框
///   </para>
///   <para>
///     Round image Box
///   </para>
/// </summary>
unit uSkinRoundImageType;

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
  FMX.Graphics,
  {$ENDIF}

  {$IFDEF IOS}
  FMX.Helpers.iOS,
  {$ENDIF}

  uDrawParam,
  uDrawRectParam,
  uSkinImageType,
  Math,
  uBaseLog,
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
  IID_ISkinRoundImage:TGUID='{08C6A34B-FB29-4D2B-A816-3C007440C727}';

type
  TRoundImageProperties=class;



  /// <summary>
  ///   <para>
  ///     圆形图片框接口
  ///   </para>
  ///   <para>
  ///     Interface of round image
  ///   </para>
  /// </summary>
  ISkinRoundImage=interface//(ISkinImage)
    ['{08C6A34B-FB29-4D2B-A816-3C007440C727}']

    function GetRoundImageProperties:TRoundImageProperties;
    property Properties:TRoundImageProperties read GetRoundImageProperties;
    property Prop:TRoundImageProperties read GetRoundImageProperties;
  end;







  /// <summary>
  ///   <para>
  ///     圆形图片框属性
  ///   </para>
  ///   <para>
  ///     Round image box properties
  ///   </para>
  /// </summary>
  TRoundImageProperties=class(TImageProperties)
  protected
    FSkinRoundImageIntf:ISkinRoundImage;
  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  end;







  /// <summary>
  ///   <para>
  ///     圆形图片框素材基类
  ///   </para>
  ///   <para>
  ///     Base class of round ImageBox
  ///   </para>
  /// </summary>
  TSkinRoundImageMaterial=class(TSkinImageMaterial)
  protected
    //是否绘制空心圆
    FIsDrawClipRound: Boolean;
    FDrawRoundOutSideRectParam: TDrawRectParam;

    function GetClipRoundHeight: TControlSize;
    function GetClipRoundWidth: TControlSize;
    function GetClipRoundRectSetting: TDrawRectSetting;

    procedure SetClipRoundHeight(const Value: TControlSize);
    procedure SetClipRoundRectSetting(const Value: TDrawRectSetting);
    procedure SetClipRoundWidth(const Value: TControlSize);

    procedure SetIsDrawClipRound(const Value: Boolean);
    procedure SetDrawRoundOutSideRectParam(const Value: TDrawRectParam);
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

    /// <summary>
    ///   <para>
    ///     是否剪裁出圆角矩形
    ///   </para>
    ///   <para>
    ///     Whether clip round corner rectangle
    ///   </para>
    /// </summary>
    property IsDrawClipRound:Boolean read FIsDrawClipRound write SetIsDrawClipRound;

    /// <summary>
    ///   <para>
    ///     剪裁出圆角矩形的圆角宽度
    ///   </para>
    ///   <para>
    ///    clip round corner rectangle's round corner width
    ///   </para>
    /// </summary>
    property ClipRoundWidth:TControlSize read GetClipRoundWidth write SetClipRoundWidth;

    /// <summary>
    ///   <para>
    ///     剪裁出圆角矩形的圆角高度
    ///   </para>
    ///   <para>
    ///     Clip round corner rectangle's round corner height
    ///   </para>
    /// </summary>
    property ClipRoundHeight:TControlSize read GetClipRoundHeight write SetClipRoundHeight;

    /// <summary>
    ///   <para>
    ///     剪裁出圆角矩形的绘制矩形设置
    ///   </para>
    ///   <para>
    ///     Clip round corner rectangle's draw rectangle setting
    ///   </para>
    /// </summary>
    property ClipRoundRectSetting:TDrawRectSetting read GetClipRoundRectSetting write SetClipRoundRectSetting;

    /// <summary>
    ///   <para>
    ///     圆角矩形外面的矩形绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of outside round rectangle
    ///   </para>
    /// </summary>
    property DrawRoundOutSideRectParam: TDrawRectParam read FDrawRoundOutSideRectParam write SetDrawRoundOutSideRectParam;
  end;

  TSkinRoundImageType=class(TSkinImageType)
  protected
    FSkinRoundImageIntf:ISkinRoundImage;
    function GetSkinMaterial:TSkinRoundImageMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  end;





  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinRoundImageDefaultMaterial=class(TSkinRoundImageMaterial);
  TSkinRoundImageDefaultType=TSkinRoundImageType;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinRoundImage=class(TSkinImage,
                        ISkinRoundImage)
  private
    function GetRoundImageProperties:TRoundImageProperties;
    procedure SetRoundImageProperties(Value:TRoundImageProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    function SelfOwnMaterialToDefault:TSkinRoundImageDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinRoundImageDefaultMaterial;
    function Material:TSkinRoundImageDefaultMaterial;
  public
    property Prop:TRoundImageProperties read GetRoundImageProperties write SetRoundImageProperties;
  published
    //属性
    property Properties:TRoundImageProperties read GetRoundImageProperties write SetRoundImageProperties;
  end;

  {$IFDEF VCL}
  TSkinWinRoundImage=class(TSkinRoundImage)
  end;
  {$ENDIF VCL}



implementation







{ TSkinRoundImageType }

function TSkinRoundImageType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinRoundImage,Self.FSkinRoundImageIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinRoundImage Interface');
    end;
  end;
end;

procedure TSkinRoundImageType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinRoundImageIntf:=nil;
end;

function TSkinRoundImageType.GetSkinMaterial: TSkinRoundImageMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinRoundImageMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinRoundImageType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin
  Inherited;

  if (GetSkinMaterial<>nil) and (GetSkinMaterial.FIsDrawClipRound) then
  begin
    ACanvas.DrawRect(GetSkinMaterial.FDrawRoundOutSideRectParam,ADrawRect);
  end;

end;


{ TSkinRoundImageMaterial }

procedure TSkinRoundImageMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinRoundImageMaterial;
begin

  if Dest is TSkinRoundImageMaterial then
  begin
    DestObject:=TSkinRoundImageMaterial(Dest);

    DestObject.FIsDrawClipRound:=Self.FIsDrawClipRound;
    DestObject.ClipRoundWidth:=Self.ClipRoundWidth;
    DestObject.ClipRoundHeight:=Self.ClipRoundHeight;

  end;

  inherited;

end;

constructor TSkinRoundImageMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FIsDrawClipRound:=True;

  FDrawRoundOutSideRectParam:=CreateDrawRectParam('DrawRoundOutSideRectParam','圆外矩形绘制参数');
  FDrawRoundOutSideRectParam.FIsClipRound:=True;
end;

function TSkinRoundImageMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='IsDrawClipRound' then
    begin
      FIsDrawClipRound:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='ClipRoundWidth' then
    begin
      ClipRoundWidth:=ControlSize(ABTNode.ConvertNode_Real64.Data);
    end
    else if ABTNode.NodeName='ClipRoundHeight' then
    begin
      ClipRoundHeight:=ControlSize(ABTNode.ConvertNode_Real64.Data);
    end
    ;

  end;
  Result:=True;
end;

function TSkinRoundImageMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Bool32('IsDrawClipRound','是否绘制空心圆');
  ABTNode.ConvertNode_Bool32.Data:=Self.FIsDrawClipRound;

  ABTNode:=ADocNode.AddChildNode_Real64('ClipRoundWidth','空心圆宽度');
  ABTNode.ConvertNode_Real64.Data:=Self.ClipRoundWidth;

  ABTNode:=ADocNode.AddChildNode_Real64('ClipRoundHeight','空心圆高度');
  ABTNode.ConvertNode_Real64.Data:=Self.ClipRoundHeight;

  Result:=True;
end;

destructor TSkinRoundImageMaterial.Destroy;
begin
  FreeAndNil(FDrawRoundOutSideRectParam);
  inherited;
end;

function TSkinRoundImageMaterial.GetClipRoundHeight: TControlSize;
begin
  Result:=FDrawRoundOutSideRectParam.FClipRoundHeight;
end;

function TSkinRoundImageMaterial.GetClipRoundRectSetting: TDrawRectSetting;
begin
  Result:=FDrawRoundOutSideRectParam.FClipRoundRectSetting;
end;

function TSkinRoundImageMaterial.GetClipRoundWidth: TControlSize;
begin
  Result:=FDrawRoundOutSideRectParam.FClipRoundWidth;
end;

procedure TSkinRoundImageMaterial.SetDrawRoundOutSideRectParam(const Value: TDrawRectParam);
begin
  FDrawRoundOutSideRectParam.Assign(Value);
end;

procedure TSkinRoundImageMaterial.SetIsDrawClipRound(const Value: Boolean);
begin
  if FIsDrawClipRound<>Value then
  begin
    FIsDrawClipRound := Value;
    Self.DoChange();
  end;
end;

procedure TSkinRoundImageMaterial.SetClipRoundHeight(const Value: TControlSize);
begin
  FDrawRoundOutSideRectParam.ClipRoundHeight:=Value;
end;

procedure TSkinRoundImageMaterial.SetClipRoundWidth(const Value: TControlSize);
begin
  FDrawRoundOutSideRectParam.ClipRoundWidth:=Value;
end;

procedure TSkinRoundImageMaterial.SetClipRoundRectSetting(const Value: TDrawRectSetting);
begin
  FDrawRoundOutSideRectParam.FClipRoundRectSetting.Assign(Value);
end;

{ TRoundImageProperties }


procedure TRoundImageProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;

constructor TRoundImageProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinRoundImage,Self.FSkinRoundImageIntf) then
  begin
    ShowException('This Component Do not Support ISkinRoundImage Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=200;
    Self.FSkinControlIntf.Height:=200;
  end;
end;

destructor TRoundImageProperties.Destroy;
begin
  inherited;
end;

function TRoundImageProperties.GetComponentClassify: String;
begin
  Result:='SkinRoundImage';
end;


{ TSkinRoundImage }

function TSkinRoundImage.Material:TSkinRoundImageDefaultMaterial;
begin
  Result:=TSkinRoundImageDefaultMaterial(SelfOwnMaterial);
end;

function TSkinRoundImage.SelfOwnMaterialToDefault:TSkinRoundImageDefaultMaterial;
begin
  Result:=TSkinRoundImageDefaultMaterial(SelfOwnMaterial);
end;

function TSkinRoundImage.CurrentUseMaterialToDefault:TSkinRoundImageDefaultMaterial;
begin
  Result:=TSkinRoundImageDefaultMaterial(CurrentUseMaterial);
end;

function TSkinRoundImage.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TRoundImageProperties;
end;

function TSkinRoundImage.GetRoundImageProperties: TRoundImageProperties;
begin
  Result:=TRoundImageProperties(Self.FProperties);
end;

procedure TSkinRoundImage.SetRoundImageProperties(Value: TRoundImageProperties);
begin
  Self.FProperties.Assign(Value);
end;



end.

