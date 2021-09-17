//convert pas to utf8 by ¥

unit uSkinSwitchPageListPanelType;

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
  Math,
  uBaseLog,
  uSkinAnimator,
  uBaseSkinControl,
//  uDialogCommon,
  uGraphicCommon,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uBaseList,
//  {$IFDEF VCL}
//  uSkinWindowsButton,
//  uSkinDirectUIButton,
//  {$ENDIF}
//  {$IFDEF FMX}
//  {$ENDIF}
  uSkinScrollBarType,
  uSkinScrollControlType,
  uSkinControlGestureManager,
  uSkinSwitchPageListControlGestureManager,
  uSkinImageList,
  uComponentType,
  uDrawEngine,
//  uBufferBitmap,
  uDrawParam,
  uSkinPicture,
  uDrawPicture,
  uSkinButtonType,
  uDrawTextParam,
  uDrawRectParam,
  uSkinRegManager,
  uDrawPictureParam;

const
  IID_ISkinSwitchPageListPanel:TGUID='{D4ECE6B6-3682-4A61-8E4A-46426815C450}';

type
  TSwitchPageListPanelProperties=class;


  ISkinSwitchPageListPanel=interface//(ISkinControl)

  ['{D4ECE6B6-3682-4A61-8E4A-46426815C450}']

    function GetSwitchPageListPanelProperties:TSwitchPageListPanelProperties;
    property Properties:TSwitchPageListPanelProperties read GetSwitchPageListPanelProperties;
    property Prop:TSwitchPageListPanelProperties read GetSwitchPageListPanelProperties;
  end;





  TSwitchPageListPanelProperties=class(TSkinControlProperties)
  protected
    FSkinSwitchPageListPanelIntf:ISkinSwitchPageListPanel;
    FSwitchPageListControlGestureManager:TSkinSwitchPageListControlGestureManager;
  private
    function GetIsNotCanSeeOutOfBoundArea: Boolean;
    function GetIsNotMoveMiddleControl: Boolean;
    function GetMiddleControl: TControl;
    function GetNextControl: TControl;
    function GetPriorControl: TControl;
    procedure SetIsNotCanSeeOutOfBoundArea(const Value: Boolean);
    procedure SetIsNotMoveMiddleControl(const Value: Boolean);
    procedure SetMiddleControl(const Value: TControl);
    procedure SetNextControl(const Value: TControl);
    procedure SetPriorControl(const Value: TControl);
    function GetKind: TGestureKind;
    procedure SetKind(const Value: TGestureKind);
//    procedure SetSwitchPageListControlGestureManager(const Value: TSkinSwitchPageListControlGestureManager);
  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
    //切换
    property SwitchPageListControlGestureManager:TSkinSwitchPageListControlGestureManager read FSwitchPageListControlGestureManager;
  published
    property Kind:TGestureKind read GetKind write SetKind;

    property MiddleControl:TControl read GetMiddleControl write SetMiddleControl;
    property PriorControl:TControl read GetPriorControl write SetPriorControl;
    property NextControl:TControl read GetNextControl write SetNextControl;

    //是否只移动中间的控件
    property IsNotMoveMiddleControl:Boolean read GetIsNotMoveMiddleControl write SetIsNotMoveMiddleControl;
    property IsNotCanSeeOutOfBoundArea:Boolean read GetIsNotCanSeeOutOfBoundArea write SetIsNotCanSeeOutOfBoundArea;
  end;




  TSkinSwitchPageListPanelMaterial=class(TSkinControlMaterial)
  protected
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  end;




  TSkinSwitchPageListPanelType=class(TSkinControlType)
  protected
    FSkinSwitchPageListPanelIntf:ISkinSwitchPageListPanel;
    function GetSkinMaterial:TSkinSwitchPageListPanelMaterial;
  protected
    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseMove(Shift: TShiftState; X, Y: Double);override;
    procedure CustomMouseEnter;override;
    procedure CustomMouseLeave;override;
    function CustomMouseWheel(Shift: TShiftState; WheelDelta: Integer;X, Y: Double):Boolean;override;

    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;

    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;

  end;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinSwitchPageListPanelDefaultMaterial=class(TSkinSwitchPageListPanelMaterial);
  TSkinSwitchPageListPanelDefaultType=TSkinSwitchPageListPanelType;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinSwitchPageListPanel=class(TBaseSkinControl,ISkinSwitchPageListPanel)
  private
    function GetSwitchPageListPanelProperties:TSwitchPageListPanelProperties;
    procedure SetSwitchPageListPanelProperties(Value:TSwitchPageListPanelProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;

  public
    constructor Create(AOwner:TComponent);override;
    property Prop:TSwitchPageListPanelProperties read GetSwitchPageListPanelProperties write SetSwitchPageListPanelProperties;
  published
    //属性
    property Properties:TSwitchPageListPanelProperties read GetSwitchPageListPanelProperties write SetSwitchPageListPanelProperties;
  end;


  {$IFDEF VCL}
  TSkinWinSwitchPageListPanel=class(TSkinSwitchPageListPanel)
  end;
  {$ENDIF VCL}



implementation


{ TSkinSwitchPageListPanelType }

function TSkinSwitchPageListPanelType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinSwitchPageListPanel,Self.FSkinSwitchPageListPanelIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinSwitchPageListPanel Interface');
    end;
  end;
end;

function TSkinSwitchPageListPanelType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin

end;

procedure TSkinSwitchPageListPanelType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinSwitchPageListPanelIntf:=nil;
end;

function TSkinSwitchPageListPanelType.GetSkinMaterial: TSkinSwitchPageListPanelMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinSwitchPageListPanelMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;


procedure TSkinSwitchPageListPanelType.CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
  inherited;
  if Self.FSkinSwitchPageListPanelIntf.Prop.FSwitchPageListControlGestureManager<>nil then
  Self.FSkinSwitchPageListPanelIntf.Prop.FSwitchPageListControlGestureManager.MouseDown(Button,Shift,X,Y);
end;

procedure TSkinSwitchPageListPanelType.CustomMouseEnter;
begin
  inherited;
  if Self.FSkinSwitchPageListPanelIntf.Prop.FSwitchPageListControlGestureManager<>nil then
    Self.FSkinSwitchPageListPanelIntf.Prop.FSwitchPageListControlGestureManager.MouseEnter;

end;

procedure TSkinSwitchPageListPanelType.CustomMouseLeave;
begin
  inherited;
  if Self.FSkinSwitchPageListPanelIntf.Prop.FSwitchPageListControlGestureManager<>nil then
    Self.FSkinSwitchPageListPanelIntf.Prop.FSwitchPageListControlGestureManager.MouseLeave;
end;

procedure TSkinSwitchPageListPanelType.CustomMouseMove(Shift: TShiftState; X, Y: Double);
begin
  inherited;
  if Self.FSkinSwitchPageListPanelIntf.Prop.FSwitchPageListControlGestureManager<>nil then
  Self.FSkinSwitchPageListPanelIntf.Prop.FSwitchPageListControlGestureManager.MouseMove(Shift,X,Y);
end;

procedure TSkinSwitchPageListPanelType.CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
begin
  inherited;
  if Self.FSkinSwitchPageListPanelIntf.Prop.FSwitchPageListControlGestureManager<>nil then
  Self.FSkinSwitchPageListPanelIntf.Prop.FSwitchPageListControlGestureManager.MouseUp(Button,Shift,X,Y);
end;

function TSkinSwitchPageListPanelType.CustomMouseWheel(Shift: TShiftState; WheelDelta:Integer; X,Y: Double): Boolean;
begin
  Inherited;
  if Self.FSkinSwitchPageListPanelIntf.Prop.FSwitchPageListControlGestureManager<>nil then
  Self.FSkinSwitchPageListPanelIntf.Prop.FSwitchPageListControlGestureManager.MouseWheel(Shift,WheelDelta,X,Y);
end;



{ TSkinSwitchPageListPanelMaterial }

constructor TSkinSwitchPageListPanelMaterial.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
end;

destructor TSkinSwitchPageListPanelMaterial.Destroy;
begin
  inherited;
end;

function TSkinSwitchPageListPanelMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  I: Integer;
//  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);

//  for I := 0 to ADocNode.ChildNodes.Count - 1 do
//  begin
//    ABTNode:=ADocNode.ChildNodes[I];
//    if ABTNode.NodeName='DrawPictureParam' then
//    begin
//      FDrawPictureParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
//    end
//    ;
//  end;

  Result:=True;
end;

function TSkinSwitchPageListPanelMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

//  ABTNode:=ADocNode.AddChildNode_Class('DrawPictureParam',FDrawPictureParam.Name);
//  Self.FDrawPictureParam.SaveToDocNode(ABTNode.ConvertNode_Class);

  Result:=True;

end;



{ TSwitchPageListPanelProperties }


procedure TSwitchPageListPanelProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;

constructor TSwitchPageListPanelProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinSwitchPageListPanel,Self.FSkinSwitchPageListPanelIntf) then
  begin
    ShowException('This Component Do not Support ISkinSwitchPageListPanel Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=200;
    Self.FSkinControlIntf.Height:=200;

    FSwitchPageListControlGestureManager:=TSkinSwitchPageListControlGestureManager.Create(nil);
//    FSwitchPageListControlGestureManager.CanGestureSwitch:=False;
//    FSwitchPageListControlGestureManager.PageListSwitchEffectType:=TAnimateSwitchEffectType.ilasetMoveHorz;
  end;
end;

destructor TSwitchPageListPanelProperties.Destroy;
begin
  FreeAndNil(FSwitchPageListControlGestureManager);
  inherited;
end;

function TSwitchPageListPanelProperties.GetComponentClassify: String;
begin
  Result:='SkinSwitchPageListPanel';
end;

function TSwitchPageListPanelProperties.GetIsNotCanSeeOutOfBoundArea: Boolean;
begin
  Result:=FSwitchPageListControlGestureManager.IsNotCanSeeOutOfBoundArea;
end;

function TSwitchPageListPanelProperties.GetIsNotMoveMiddleControl: Boolean;
begin
  Result:=FSwitchPageListControlGestureManager.IsNotMoveMiddleControl;
end;

function TSwitchPageListPanelProperties.GetKind: TGestureKind;
begin
  Result:=FSwitchPageListControlGestureManager.Kind;
end;

function TSwitchPageListPanelProperties.GetMiddleControl: TControl;
begin
  Result:=FSwitchPageListControlGestureManager.MiddleControl;
end;

function TSwitchPageListPanelProperties.GetNextControl: TControl;
begin
  Result:=FSwitchPageListControlGestureManager.NextControl;
end;

function TSwitchPageListPanelProperties.GetPriorControl: TControl;
begin
  Result:=FSwitchPageListControlGestureManager.PriorControl;
end;

procedure TSwitchPageListPanelProperties.SetIsNotCanSeeOutOfBoundArea(const Value: Boolean);
begin
  FSwitchPageListControlGestureManager.IsNotCanSeeOutOfBoundArea:=Value;
end;

procedure TSwitchPageListPanelProperties.SetIsNotMoveMiddleControl(
  const Value: Boolean);
begin
  FSwitchPageListControlGestureManager.IsNotMoveMiddleControl:=Value;
end;

procedure TSwitchPageListPanelProperties.SetKind(const Value: TGestureKind);
begin
  FSwitchPageListControlGestureManager.Kind:=Value;
end;

procedure TSwitchPageListPanelProperties.SetMiddleControl(
  const Value: TControl);
begin
  FSwitchPageListControlGestureManager.MiddleControl:=Value;
end;

procedure TSwitchPageListPanelProperties.SetNextControl(const Value: TControl);
begin
  FSwitchPageListControlGestureManager.NextControl:=Value;
end;

procedure TSwitchPageListPanelProperties.SetPriorControl(const Value: TControl);
begin
  FSwitchPageListControlGestureManager.PriorControl:=Value;
end;

//procedure TSwitchPageListPanelProperties.SetSwitchPageListControlGestureManager(const Value: TSkinSwitchPageListControlGestureManager);
//begin
//  FSwitchPageListControlGestureManager := Value;
//end;





{ TSkinSwitchPageListPanel }


constructor TSkinSwitchPageListPanel.Create(AOwner:TComponent);
begin
  inherited;
  {$IFDEF VCL}
  ControlStyle:=ControlStyle+[csAcceptsControls];
  {$ENDIF}

//  {$IFDEF FMX}
//  Touch.DefaultInteractiveGestures := Touch.DefaultInteractiveGestures + [TInteractiveGesture.igZoom];
//  Touch.InteractiveGestures := Touch.InteractiveGestures + [TInteractiveGesture.igZoom];
//  {$ENDIF}

end;


function TSkinSwitchPageListPanel.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TSwitchPageListPanelProperties;
end;

function TSkinSwitchPageListPanel.GetSwitchPageListPanelProperties: TSwitchPageListPanelProperties;
begin
  Result:=TSwitchPageListPanelProperties(Self.FProperties);
end;

procedure TSkinSwitchPageListPanel.SetSwitchPageListPanelProperties(Value: TSwitchPageListPanelProperties);
begin
  Self.FProperties.Assign(Value);
end;





end.

