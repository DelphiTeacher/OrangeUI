//convert pas to utf8 by ¥

unit uSkinScrollControlCornerType;

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
  IID_ISkinScrollControlCorner:TGUID='{2A558113-7528-4B27-A262-312AE81F0F6E}';

type
  TScrollControlCornerProperties=class;




  /// <summary>
  ///   滚动框边角接口
  /// </summary>
  ISkinScrollControlCorner=interface//(ISkinControl)
  ['{2A558113-7528-4B27-A262-312AE81F0F6E}']

    function GetScrollControlCornerProperties:TScrollControlCornerProperties;
    property Properties:TScrollControlCornerProperties read GetScrollControlCornerProperties;
    property Prop:TScrollControlCornerProperties read GetScrollControlCornerProperties;
  end;






  /// <summary>
  ///   滚动框边角属性
  /// </summary>
  TScrollControlCornerProperties=class(TSkinControlProperties)
  protected
    FSkinScrollControlCornerIntf:ISkinScrollControlCorner;
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
  ///   滚动框边角素材
  /// </summary>
  TSkinScrollControlCornerMaterial=class(TSkinControlMaterial)
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//  public
//    constructor Create(AOwner:TComponent);override;
//    destructor Destroy;override;
  end;
  TSkinScrollControlCornerType=class(TSkinControlType)
  private
    FSkinScrollControlCornerIntf:ISkinScrollControlCorner;
    function GetSkinMaterial:TSkinScrollControlCornerMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  end;









  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinScrollControlCornerDefaultMaterial=class(TSkinScrollControlCornerMaterial);
  TSkinScrollControlCornerDefaultType=TSkinScrollControlCornerType;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinScrollControlCorner=class(TBaseSkinControl,ISkinScrollControlCorner)
  private
    function GetScrollControlCornerProperties:TScrollControlCornerProperties;
    procedure SetScrollControlCornerProperties(Value:TScrollControlCornerProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    function SelfOwnMaterialToDefault:TSkinScrollControlCornerDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinScrollControlCornerDefaultMaterial;
    function Material:TSkinScrollControlCornerDefaultMaterial;
  public
    property Prop:TScrollControlCornerProperties read GetScrollControlCornerProperties write SetScrollControlCornerProperties;
  published
    //属性
    property Properties:TScrollControlCornerProperties read GetScrollControlCornerProperties write SetScrollControlCornerProperties;
  end;


  {$IFDEF VCL}
  TSkinWinScrollControlCorner=class(TSkinScrollControlCorner)
  end;
  {$ENDIF VCL}



  TSkinChildScrollControlCorner=TSkinScrollControlCorner;

  function CreateChildScrollControlCorner(AOwner:TComponent):TSkinChildScrollControlCorner;



implementation


function CreateChildScrollControlCorner(AOwner:TComponent):TSkinChildScrollControlCorner;
begin
  Result:=TSkinChildScrollControlCorner.Create(AOwner);
end;





{ TSkinScrollControlCornerType }


function TSkinScrollControlCornerType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinScrollControlCorner,Self.FSkinScrollControlCornerIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinScrollControlCorner Interface');
    end;
  end;
end;

procedure TSkinScrollControlCornerType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinScrollControlCornerIntf:=nil;
end;

function TSkinScrollControlCornerType.GetSkinMaterial: TSkinScrollControlCornerMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinScrollControlCornerMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinScrollControlCornerType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin
end;

//
//{ TSkinScrollControlCornerMaterial }
//
//constructor TSkinScrollControlCornerMaterial.Create(AOwner: TComponent);
//begin
//  inherited Create(AOwner);
//end;
//
//function TSkinScrollControlCornerMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
//function TSkinScrollControlCornerMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
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
//
//destructor TSkinScrollControlCornerMaterial.Destroy;
//begin
//  inherited;
//end;

{ TScrollControlCornerProperties }


procedure TScrollControlCornerProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;

constructor TScrollControlCornerProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinScrollControlCorner,Self.FSkinScrollControlCornerIntf) then
  begin
    ShowException('This Component Do not Support ISkinScrollControlCorner Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=10;
    Self.FSkinControlIntf.Height:=10;
  end;
end;

destructor TScrollControlCornerProperties.Destroy;
begin
  inherited;
end;


function TScrollControlCornerProperties.GetComponentClassify: String;
begin
  Result:='SkinScrollControlCorner';
end;



{ TSkinScrollControlCorner }

function TSkinScrollControlCorner.Material:TSkinScrollControlCornerDefaultMaterial;
begin
  Result:=TSkinScrollControlCornerDefaultMaterial(SelfOwnMaterial);
end;

function TSkinScrollControlCorner.SelfOwnMaterialToDefault:TSkinScrollControlCornerDefaultMaterial;
begin
  Result:=TSkinScrollControlCornerDefaultMaterial(SelfOwnMaterial);
end;

function TSkinScrollControlCorner.CurrentUseMaterialToDefault:TSkinScrollControlCornerDefaultMaterial;
begin
  Result:=TSkinScrollControlCornerDefaultMaterial(CurrentUseMaterial);
end;

function TSkinScrollControlCorner.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TScrollControlCornerProperties;
end;

function TSkinScrollControlCorner.GetScrollControlCornerProperties: TScrollControlCornerProperties;
begin
  Result:=TScrollControlCornerProperties(Self.FProperties);
end;

procedure TSkinScrollControlCorner.SetScrollControlCornerProperties(Value: TScrollControlCornerProperties);
begin
  Self.FProperties.Assign(Value);
end;



end.

