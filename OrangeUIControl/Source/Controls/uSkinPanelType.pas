//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     面板
///   </para>
///   <para>
///     Panel
///   </para>
/// </summary>
unit uSkinPanelType;

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
  IID_ISkinPanel:TGUID='{C3B7ECD3-960E-4BF7-8AF8-19AE695DD3E6}';

type
  TPanelProperties=class;





  /// <summary>
  ///   <para>
  ///     面板接口
  ///   </para>
  ///   <para>
  ///     Panel interface
  ///   </para>
  /// </summary>
  ISkinPanel=interface//(ISkinControl)
  ['{C3B7ECD3-960E-4BF7-8AF8-19AE695DD3E6}']

    function GetPanelProperties:TPanelProperties;
    property Properties:TPanelProperties read GetPanelProperties;
    property Prop:TPanelProperties read GetPanelProperties;
  end;





  /// <summary>
  ///   <para>
  ///     面板属性
  ///   </para>
  ///   <para>
  ///     Panel properties
  ///   </para>
  /// </summary>
  TPanelProperties=class(TSkinControlProperties)
  protected
    FIsToolBar:Boolean;
    FSkinPanelIntf:ISkinPanel;
  private
    procedure SetIsToolBar(const Value: Boolean);
  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  published
    {$IFDEF FMX}
    /// <summary>
    ///   是否是工具栏
    ///   <para>
    ///     Whether is tool bar
    ///   </para>
    /// </summary>
    property IsToolBar:Boolean read FIsToolBar write SetIsToolBar;
    {$ENDIF}
  end;






  /// <summary>
  ///   <para>
  ///     面板素材基类
  ///   </para>
  ///   <para>
  ///     Base class of panel material
  ///   </para>
  /// </summary>
  TSkinPanelMaterial=class(TSkinControlMaterial)
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
    //背景图片
    FBackgroundPicture:TDrawPicture;
    //图片绘制参数
    FDrawPictureParam:TDrawPictureParam;

    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;

    procedure CreateBackgroundPicture;
  published
    //
    /// <summary>
    ///   <para>
    ///     标题绘制参数
    ///   </para>
    ///   <para>
    ///     Caption draw parameters
    ///   </para>
    /// </summary>
    property DrawCaptionParam:TDrawTextParam read FDrawCaptionParam write SetDrawCaptionParam;
  end;

  TSkinPanelType=class(TSkinControlType)
  private
    FSkinPanelIntf:ISkinPanel;
    function GetSkinMaterial:TSkinPanelMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    procedure TextChanged;override;
  end;








  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinPanelDefaultMaterial=class(TSkinPanelMaterial);
  TSkinPanelDefaultType=TSkinPanelType;


  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TBaseSkinPanel=class(TBaseSkinControl,
                      IBindSkinItemValueControl,
                      ISkinPanel)
  private
    function GetPanelProperties:TPanelProperties;
    procedure SetPanelProperties(Value:TPanelProperties);
  protected
    //控件加载完毕
    procedure Loaded;override;

    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  protected
    //绑定列表项
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  public
    function SelfOwnMaterialToDefault:TSkinPanelDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinPanelDefaultMaterial;
    function Material:TSkinPanelDefaultMaterial;
  public
    property Prop:TPanelProperties read GetPanelProperties write SetPanelProperties;
  published
    //标题
    property Caption;
    property Text;
    //属性
    property Properties:TPanelProperties read GetPanelProperties write SetPanelProperties;
  end;


  {$IFDEF VCL}
  TSkinWinPanel=class(TBaseSkinPanel)
  end;
  TSkinPanel=class(TBaseSkinPanel)
  end;
  {$ENDIF VCL}


  {$IFDEF FMX}
  TSkinPanel=class(TBaseSkinPanel)
  end;
  {$ENDIF FMX}

  TSkinChildPanel=TBaseSkinPanel;//{$IFDEF VCL}TSkinWinPanel{$ENDIF}{$IFDEF FMX}TSkinFMXPanel{$ENDIF};



implementation



{ TSkinPanelType }

function TSkinPanelType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinPanel,Self.FSkinPanelIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinPanel Interface');
    end;
  end;
end;

procedure TSkinPanelType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinPanelIntf:=nil;
end;

function TSkinPanelType.GetSkinMaterial: TSkinPanelMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinPanelMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

procedure TSkinPanelType.TextChanged;
begin
  inherited;
  Invalidate;
end;

function TSkinPanelType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  ADrawCaptionRect:TRectF;
begin
  if Self.GetSkinMaterial<>nil then
  begin


    //绘制背景图片
    if (GetSkinMaterial.FBackgroundPicture<>nil) and (GetSkinMaterial.FDrawPictureParam<>nil) then
    begin
        ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawPictureParam,
                            Self.GetSkinMaterial.FBackgroundPicture,
                            ADrawRect);
    end;



    if Self.FSkinControlIntf.Caption <> '' then
    begin
      ADrawCaptionRect:=ADrawRect;

      //标题下移
      if Self.FSkinPanelIntf.Prop.FIsToolBar
         or (Self.FSkinControl.Name='pnlToolBar') then
      begin
        ADrawCaptionRect:=RectF(ADrawRect.Left,
                          ADrawRect.Top
                          {$IFDEF FMX}+TControl(FSkinControl).Padding.Top{$ENDIF},
                          ADrawRect.Width,ADrawRect.Height);
      end;

      ACanvas.DrawText(Self.GetSkinMaterial.FDrawCaptionParam,
                        Self.FSkinControlIntf.Caption,
                        ADrawCaptionRect);
    end;
  end;
end;


{ TSkinPanelMaterial }

constructor TSkinPanelMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDrawCaptionParam:=CreateDrawTextParam('DrawCaptionParam','标题绘制参数');
end;

//function TSkinPanelMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
//function TSkinPanelMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
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

procedure TSkinPanelMaterial.CreateBackgroundPicture;
begin
  if FBackgroundPicture=nil then
  begin
    FBackgroundPicture:=TDrawPicture.Create();
    FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','图片绘制参数');
  end;
end;

destructor TSkinPanelMaterial.Destroy;
begin
  FreeAndNil(FDrawCaptionParam);

  FreeAndNil(FBackgroundPicture);
  FreeAndNil(FDrawPictureParam);
  inherited;
end;

procedure TSkinPanelMaterial.SetDrawCaptionParam(const Value: TDrawTextParam);
begin
  FDrawCaptionParam.Assign(Value);
end;


{ TPanelProperties }


procedure TPanelProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;

constructor TPanelProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinPanel,Self.FSkinPanelIntf) then
  begin
    ShowException('This Component Do not Support ISkinPanel Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=200;
    Self.FSkinControlIntf.Height:=50;

//    FSyncedToolBarHeight:=0;
//    FIsSyncedToolBar:=False;
    FIsToolBar:=False;
  end;
end;

destructor TPanelProperties.Destroy;
begin
  inherited;
end;


function TPanelProperties.GetComponentClassify: String;
begin
  Result:='SkinPanel';
end;



procedure TPanelProperties.SetIsToolBar(const Value: Boolean);
begin
  if FIsToolBar<>Value then
  begin
    FIsToolBar := Value;

    if FIsToolBar
      and not (csLoading in Self.FSkinControl.ComponentState)
      and not (csReading in Self.FSkinControl.ComponentState) then
    begin
      //更新工具栏
      SetControlAsToolBar(Self.FSkinControl,FIsToolBar);
    end;

  end;
end;

{ TBaseSkinPanel }

function TBaseSkinPanel.Material:TSkinPanelDefaultMaterial;
begin
  Result:=TSkinPanelDefaultMaterial(SelfOwnMaterial);
end;

function TBaseSkinPanel.SelfOwnMaterialToDefault:TSkinPanelDefaultMaterial;
begin
  Result:=TSkinPanelDefaultMaterial(SelfOwnMaterial);
end;

function TBaseSkinPanel.CurrentUseMaterialToDefault:TSkinPanelDefaultMaterial;
begin
  Result:=TSkinPanelDefaultMaterial(CurrentUseMaterial);
end;

function TBaseSkinPanel.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TPanelProperties;
end;

function TBaseSkinPanel.GetPanelProperties: TPanelProperties;
begin
  Result:=TPanelProperties(Self.FProperties);
end;

procedure TBaseSkinPanel.SetControlValueByBindItemField(
  const AFieldName: String; const AFieldValue: Variant; ASkinItem: TObject;
  AIsDrawItemInteractiveState: Boolean);
begin
  if AFieldName='ItemColor' then
  begin
    //是整形
    Self.SelfOwnMaterialToDefault.BackColor.FillColor.FColor:=AFieldValue;
  end;
end;

procedure TBaseSkinPanel.SetPanelProperties(Value: TPanelProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TBaseSkinPanel.Loaded;
begin
  Inherited;


  {$IFDEF FMX}
//  Self.Properties.SyncToolBar;
  //更新工具栏
  SetControlAsToolBar(Self,Self.Properties.IsToolBar);
  {$ENDIF}
end;




end.


