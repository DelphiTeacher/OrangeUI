//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     蒙板图片框
///   </para>
///   <para>
///     FrameImage Box
///   </para>
/// </summary>
unit uSkinFrameImageType;

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
  uBaseLog,
  uGraphicCommon,
  uSkinImageType,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uSkinImageList,
  uComponentType,
  uDrawEngine,
  uSkinPicture,
  uDrawPicture,
  uDrawTextParam,
  uSkinRegManager,
  uDrawPictureParam;

const
  IID_ISkinFrameImage:TGUID='{A53D5EC8-7245-4B6D-B1AB-317EEFEB0EB7}';

type
  TFrameImageProperties=class;



  /// <summary>
  ///   <para>
  ///     蒙板图片框接口
  ///   </para>
  ///   <para>
  ///     Interface of FrameImage Box
  ///   </para>
  /// </summary>
  ISkinFrameImage=interface(ISkinImage)
  ['{A53D5EC8-7245-4B6D-B1AB-317EEFEB0EB7}']
    function GetFrameImageProperties:TFrameImageProperties;
    property Properties:TFrameImageProperties read GetFrameImageProperties;
    property Prop:TFrameImageProperties read GetFrameImageProperties;
  end;





  //
  /// <summary>
  ///   <para>
  ///     蒙板图片框属性
  ///   </para>
  ///   <para>
  ///     Properties of FrameImage
  ///   </para>
  /// </summary>
  TFrameImageProperties=class(TImageProperties)
  protected
    //蒙板
    FFrame: TDrawPicture;

    FSkinFrameImageIntf:ISkinFrameImage;

    procedure SetFrame(Value:TDrawPicture);
    procedure FrameChanged(Sender: TObject);
  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  published
    property AutoSize;
    //
    /// <summary>
    ///   <para>
    ///     蒙板图片
    ///   </para>
    ///   <para>
    ///     Frame
    ///   </para>
    /// </summary>
    property Frame: TDrawPicture read FFrame write SetFrame;
  end;








  /// <summary>
  ///   <para>
  ///     蒙板图片框素材基类
  ///   </para>
  ///   <para>
  ///    Base class of Frame Image box material
  ///   </para>
  /// </summary>
  TSkinFrameImageMaterial=class(TSkinImageMaterial)
  protected
    //是否使用相同的绘制参数
    FIsUseSameParam: Boolean;
    //蒙板绘制参数
    FDrawFrameParam:TDrawPictureParam;

    procedure SetIsUseSameParam(const Value: Boolean);
    procedure SetDrawFrameParam(const Value: TDrawPictureParam);
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
    ///     是否使用相同的参数绘制图片和蒙板图片
    ///   </para>
    ///   <para>
    ///     Whether use same parameters to draw picture and frame picture
    ///   </para>
    /// </summary>
    property IsUseSameParam:Boolean read FIsUseSameParam write SetIsUseSameParam;
    //
    /// <summary>
    ///   <para>
    ///     蒙板图片的绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of frame
    ///   </para>
    /// </summary>
    property DrawFrameParam:TDrawPictureParam read FDrawFrameParam write SetDrawFrameParam;
  end;


  TSkinFrameImageType=class(TSkinImageType)
  protected
    FSkinFrameImageIntf:ISkinFrameImage;
    function GetSkinMaterial:TSkinFrameImageMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  end;







  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFrameImageDefaultMaterial=class(TSkinFrameImageMaterial);
  TSkinFrameImageDefaultType=TSkinFrameImageType;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFrameImage=class(TSkinImage,
                        ISkinFrameImage,
                        IBindSkinItemIconControl)
  private
    function GetFrameImageProperties:TFrameImageProperties;
    procedure SetFrameImageProperties(Value:TFrameImageProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    property Prop:TFrameImageProperties read GetFrameImageProperties write SetFrameImageProperties;
  public
    function SelfOwnMaterialToDefault:TSkinFrameImageDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinFrameImageDefaultMaterial;
    function Material:TSkinFrameImageDefaultMaterial;
  published
    //属性
    property Properties:TFrameImageProperties read GetFrameImageProperties write SetFrameImageProperties;
  end;


  {$IFDEF VCL}
  TSkinWinFrameImage=class(TSkinFrameImage)
  end;
  {$ENDIF VCL}


implementation



{ TSkinFrameImageType }

function TSkinFrameImageType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinFrameImage,Self.FSkinFrameImageIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinFrameImage Interface');
    end;
  end;
end;

procedure TSkinFrameImageType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinFrameImageIntf:=nil;
end;

function TSkinFrameImageType.GetSkinMaterial: TSkinFrameImageMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinFrameImageMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinFrameImageType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin
  Inherited;
  //绘制覆盖图片
  if Self.GetSkinMaterial<>nil then
  begin
    if Not Self.GetSkinMaterial.FIsUseSameParam then
    begin
      ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawFrameParam,
                          Self.FSkinFrameImageIntf.Prop.Frame,
                          ADrawRect);
    end
    else
    begin
      ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawPictureParam,
                          Self.FSkinFrameImageIntf.Prop.Frame,
                          ADrawRect);
    end;
  end;
end;


{ TSkinFrameImageMaterial }

constructor TSkinFrameImageMaterial.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FIsUseSameParam:=True;
  FDrawFrameParam:=CreateDrawPictureParam('DrawFrameParam','蒙板绘制参数');
end;

function TSkinFrameImageMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='IsUseSameParam' then
    begin
      FIsUseSameParam:=ABTNode.ConvertNode_Bool32.Data;
    end
    ;
  end;

  Result:=True;
end;

function TSkinFrameImageMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Bool32('IsUseSameParam',FDrawPictureParam.Name);
  FIsUseSameParam:=ABTNode.ConvertNode_Bool32.Data;

  Result:=True;
end;

destructor TSkinFrameImageMaterial.Destroy;
begin
  FreeAndNil(FDrawFrameParam);
  inherited;
end;

procedure TSkinFrameImageMaterial.SetIsUseSameParam(const Value: Boolean);
begin
  if FIsUseSameParam<>Value then
  begin
    FIsUseSameParam := Value;
    DoChange;
  end;
end;

procedure TSkinFrameImageMaterial.SetDrawFrameParam(const Value: TDrawPictureParam);
begin
  FDrawFrameParam.Assign(Value);
end;




{ TFrameImageProperties }


procedure TFrameImageProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
  FFrame.Assign(TFrameImageProperties(Src).FFrame);
end;

constructor TFrameImageProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinFrameImage,Self.FSkinFrameImageIntf) then
  begin
    ShowException('This Component Do not Support ISkinFrameImage Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=120;
    Self.FSkinControlIntf.Height:=100;

    FFrame:=CreateDrawPicture('Frame','蒙板');
    FFrame.OnChange:=FrameChanged;

  end;
end;

destructor TFrameImageProperties.Destroy;
begin
  FreeAndNil(FPicture);
  FreeAndNil(FFrame);
  inherited;
end;

procedure TFrameImageProperties.SetFrame(Value: TDrawPicture);
begin
  FFrame.Assign(Value);
end;

procedure TFrameImageProperties.FrameChanged(Sender: TObject);
begin
  if not (csReading in Self.FSkinControl.ComponentState)
    and not (csLoading in Self.FSkinControl.ComponentState) then
  begin
    Invalidate;
  end;
end;

function TFrameImageProperties.GetComponentClassify: String;
begin
  Result:='SkinFrameImage';
end;




{ TSkinFrameImage }

function TSkinFrameImage.Material:TSkinFrameImageDefaultMaterial;
begin
  Result:=TSkinFrameImageDefaultMaterial(SelfOwnMaterial);
end;

function TSkinFrameImage.SelfOwnMaterialToDefault:TSkinFrameImageDefaultMaterial;
begin
  Result:=TSkinFrameImageDefaultMaterial(SelfOwnMaterial);
end;

function TSkinFrameImage.CurrentUseMaterialToDefault:TSkinFrameImageDefaultMaterial;
begin
  Result:=TSkinFrameImageDefaultMaterial(CurrentUseMaterial);
end;

function TSkinFrameImage.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TFrameImageProperties;
end;

function TSkinFrameImage.GetFrameImageProperties: TFrameImageProperties;
begin
  Result:=TFrameImageProperties(Self.FProperties);
end;

procedure TSkinFrameImage.SetFrameImageProperties(Value: TFrameImageProperties);
begin
  Self.FProperties.Assign(Value);
end;



end.
//------------------------------------------------------------------
//
//                 OrangeUI Source Files
//
//  Module: OrangeUIControl
//  Unit: uSkinFrameImageType
//  Description: 蒙板
//
//  Copyright: delphiteacher
//  CodeBy: delphiteacher
//  Email: ggggcexx@163.com
//  Writing: 2012-2025
//
//------------------------------------------------------------------

