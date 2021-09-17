//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     圆角矩形框
///   </para>
///   <para>
///     Round rectangle Box
///   </para>
/// </summary>
unit uSkinRoundRectType;

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

  Math,
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
  IID_ISkinRoundRect:TGUID='{A241B4A7-B1F7-4832-956E-EBF477F3BB2A}';

type
  TRoundRectProperties=class;


  ISkinRoundRect=interface//(ISkinControl)
    ['{A241B4A7-B1F7-4832-956E-EBF477F3BB2A}']

    function GetRoundRectProperties:TRoundRectProperties;
    property Properties:TRoundRectProperties read GetRoundRectProperties;
    property Prop:TRoundRectProperties read GetRoundRectProperties;
  end;




  //RoundRect属性
  TRoundRectProperties=class(TSkinControlProperties)
  protected
    FRadius:Double;
    FFill: TBrush;
    FStroke: TStrokeBrush;
    FSkinRoundRectIntf:ISkinRoundRect;
  private
    procedure SetRadius(const Value: Double);
  protected
    procedure SetFill(const Value: TBrush);
    procedure SetStroke(const Value: TStrokeBrush);
    procedure FillChanged(Sender: TObject); virtual;
    procedure StrokeChanged(Sender: TObject); virtual;
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  published
    property Radius:Double read FRadius write SetRadius;
    property Fill: TBrush read FFill write SetFill;
    property Stroke: TStrokeBrush read FStroke write SetStroke;
  end;





  TSkinRoundRectMaterial=class(TSkinControlMaterial)
  end;





  TSkinRoundRectType=class(TSkinControlType)
  private
    FSkinRoundRectIntf:ISkinRoundRect;
    function GetSkinMaterial:TSkinRoundRectMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  end;






  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinRoundRectDefaultMaterial=class(TSkinRoundRectMaterial);
  TSkinRoundRectDefaultType=TSkinRoundRectType;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinRoundRect=class(TBaseSkinControl,ISkinRoundRect)
  private
    function GetRoundRectProperties:TRoundRectProperties;
    procedure SetRoundRectProperties(Value:TRoundRectProperties);
  protected

    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    function SelfOwnMaterialToDefault:TSkinRoundRectDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinRoundRectDefaultMaterial;
    function Material:TSkinRoundRectDefaultMaterial;
  public
    property Prop:TRoundRectProperties read GetRoundRectProperties write SetRoundRectProperties;
  published
    //属性
    property Properties:TRoundRectProperties read GetRoundRectProperties write SetRoundRectProperties;
  end;



implementation



{ TSkinRoundRectType }

function TSkinRoundRectType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinRoundRect,Self.FSkinRoundRectIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinRoundRect Interface');
    end;
  end;
end;

procedure TSkinRoundRectType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinRoundRectIntf:=nil;
end;

function TSkinRoundRectType.GetSkinMaterial: TSkinRoundRectMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinRoundRectMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;



function GetDrawingRoundRectAndSetThickness(FFill:TBrush;FStroke:TStrokeBrush; const ADrawRect:TRectF; const Fit: Boolean; var FillShape, DrawShape: Boolean;
  var StrokeThicknessRestoreValue: Single): TRectF;
const
  MinRectAreaSize = 0.01;
begin
  {$IFDEF FMX}

  FillShape := (FFill <> nil) and (FFill.Kind <> TBrushKind.None);
  DrawShape := (FStroke <> nil) and (FStroke.Kind <> TBrushKind.None);

//  if Fit then
//    Result := TRectF.Create(0, 0, 1, 1).FitInto(AShape.LocalRect)
//  else
    Result := ADrawRect;//AShape.LocalRect;

  if DrawShape then
  begin
    if Result.Width < FStroke.Thickness then
    begin
      StrokeThicknessRestoreValue := FStroke.Thickness;
      FillShape := False;
      FStroke.Thickness := Min(Result.Width, Result.Height);
      Result.Left := (Result.Right + Result.Left) * 0.5;
      Result.Right := Result.Left + MinRectAreaSize;
    end
    else
      Result.Inflate(-FStroke.Thickness * 0.5, 0);

    if Result.Height < FStroke.Thickness then
    begin
      if StrokeThicknessRestoreValue < 0.0 then
        StrokeThicknessRestoreValue := FStroke.Thickness;
      FillShape := False;
      FStroke.Thickness := Min(Result.Width, Result.Height);
      Result.Top := (Result.Bottom + Result.Top) * 0.5;
      Result.Bottom := Result.Top + MinRectAreaSize;
    end
    else
      Result.Inflate(0, -FStroke.Thickness * 0.5);
  end;
  {$ENDIF FMX}
end;

function TSkinRoundRectType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  ARadius: Single;
  R: TRectF;
  StrokeThicknessRestoreValue: Single;
  FillShape, DrawShape: Boolean;
begin
  {$IFDEF FMX}
  StrokeThicknessRestoreValue := Self.FSkinRoundRectIntf.Prop.FStroke.Thickness;
  try
    R := GetDrawingRoundRectAndSetThickness(
                            Self.FSkinRoundRectIntf.Prop.FFill,
                            Self.FSkinRoundRectIntf.Prop.FStroke,
                            ADrawRect,
                            False, FillShape, DrawShape, StrokeThicknessRestoreValue);

    ARadius:=Self.FSkinRoundRectIntf.Prop.FRadius;
    if ARadius<0 then
    begin
      if Self.FSkinControlIntf.Height < Self.FSkinControlIntf.Width then
        ARadius := R.Height / 2
      else
        ARadius := R.Width / 2;
    end;

    if FillShape then
      ACanvas.FCanvas.FillRect(R, ARadius, ARadius, AllCorners, 1, Self.FSkinRoundRectIntf.Prop.FFill);
    if DrawShape then
      ACanvas.FCanvas.DrawRect(R, ARadius, ARadius, AllCorners, 1, Self.FSkinRoundRectIntf.Prop.FStroke);

  finally
    if StrokeThicknessRestoreValue <> Self.FSkinRoundRectIntf.Prop.FStroke.Thickness then
      Self.FSkinRoundRectIntf.Prop.FStroke.Thickness := StrokeThicknessRestoreValue;
  end;
  {$ENDIF FMX}

end;

//
//{ TSkinRoundRectMaterial }
//
//constructor TSkinRoundRectMaterial.Create(AOwner: TComponent);
//begin
//  inherited Create(AOwner);
//end;
//
//function TSkinRoundRectMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
//function TSkinRoundRectMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
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
//destructor TSkinRoundRectMaterial.Destroy;
//begin
//  inherited;
//end;
//

{ TRoundRectProperties }


procedure TRoundRectProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;

constructor TRoundRectProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinRoundRect,Self.FSkinRoundRectIntf) then
  begin
    ShowException('This Component Do not Support ISkinRoundRect Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=200;
    Self.FSkinControlIntf.Height:=200;

    FRadius:=-1;

    FFill := TBrush.Create(TBrushKind.Solid, $FFE0E0E0);
    FFill.OnChanged := FillChanged;
    FStroke := TStrokeBrush.Create(TBrushKind.Solid, $FF000000);
    FStroke.OnChanged := StrokeChanged;

  end;
end;

destructor TRoundRectProperties.Destroy;
begin
  FreeAndNil(FStroke);
  FreeAndNil(FFill);
  inherited;
end;

procedure TRoundRectProperties.SetFill(const Value: TBrush);
begin
  FFill.Assign(Value);
end;

procedure TRoundRectProperties.SetRadius(const Value: Double);
begin
  if FRadius<>Value then
  begin
    FRadius := Value;
    Self.Invalidate;
  end;
end;

procedure TRoundRectProperties.SetStroke(const Value: TStrokeBrush);
begin
  FStroke.Assign(Value);
end;

procedure TRoundRectProperties.FillChanged(Sender: TObject);
begin
  Invalidate;
end;

function TRoundRectProperties.GetComponentClassify: String;
begin
  Result:='SkinRoundRect';
end;

procedure TRoundRectProperties.StrokeChanged(Sender: TObject);
begin
  Invalidate;
end;


{ TSkinRoundRect }

function TSkinRoundRect.Material:TSkinRoundRectDefaultMaterial;
begin
  Result:=TSkinRoundRectDefaultMaterial(SelfOwnMaterial);
end;

function TSkinRoundRect.SelfOwnMaterialToDefault:TSkinRoundRectDefaultMaterial;
begin
  Result:=TSkinRoundRectDefaultMaterial(SelfOwnMaterial);
end;

function TSkinRoundRect.CurrentUseMaterialToDefault:TSkinRoundRectDefaultMaterial;
begin
  Result:=TSkinRoundRectDefaultMaterial(CurrentUseMaterial);
end;

function TSkinRoundRect.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TRoundRectProperties;
end;

function TSkinRoundRect.GetRoundRectProperties: TRoundRectProperties;
begin
  Result:=TRoundRectProperties(Self.FProperties);
end;

procedure TSkinRoundRect.SetRoundRectProperties(Value: TRoundRectProperties);
begin
  Self.FProperties.Assign(Value);
end;



end.

