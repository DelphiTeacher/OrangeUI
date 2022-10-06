//convert pas to utf8 by ¥


/// <summary>
///   <para>
///     下拉框
///   </para>
///   <para>
///     ComboBox
///   </para>
/// </summary>
unit uSkinComboBoxType;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  uFuncCommon,
  Types,
  {$IFDEF VCL}
  Windows,
  Messages,
  Controls,
  StdCtrls,
  Forms,
  ExtCtrls,
  Graphics,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  {$ENDIF}
  uSkinPublic,
  uGraphicCommon,
  uBaseLog,
  uBinaryTreeDoc,
//  uSkinPackage,
  uSkinRegManager,
  uSkinBufferBitmap,
  uDrawCanvas,
  uSkinMaterial,
  uComponentType,
  uDrawEngine,
  uDrawPicture,
  uDrawTextParam,
  uDrawPictureParam;

const
  IID_ISkinComboBox:TGUID='{0591FFC8-D257-4B2D-B875-6CE4EE4D05B7}';



type
  TComboBoxProperties=class;




  /// <summary>
  ///   <para>
  ///     下拉框接口
  ///   </para>
  ///   <para>
  ///     Interface of ComboBox
  ///   </para>
  /// </summary>
  ISkinComboBox=interface//(ISkinControl)
    ['{0591FFC8-D257-4B2D-B875-6CE4EE4D05B7}']
    /// <summary>
    ///   <para>
    ///     文本
    ///   </para>
    ///   <para>
    ///     Text
    ///   </para>
    /// </summary>
    function GetText:String;
    property Text:String read GetText;

    function GetComboBoxProperties:TComboBoxProperties;
    property Properties:TComboBoxProperties read GetComboBoxProperties;
    property Prop:TComboBoxProperties read GetComboBoxProperties;
  end;





  //
  /// <summary>
  ///   <para>
  ///     下拉框属性
  ///   </para>
  ///   <para>
  ///     ComboBox properties
  ///   </para>
  /// </summary>
  TComboBoxProperties=class(TSkinControlProperties)
  protected
    //绘制文本
    FDrawText:String;
    //提示文本
    FHelpText:String;

    //下拉框接口
    FSkinComboBoxIntf:ISkinComboBox;


    procedure SetHelpText(const Value: String);

  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    /// <summary>
    ///   <para>
    ///     在ListBox绘制时文本
    ///   </para>
    ///   <para>
    ///     Text of drawing in ListBox
    ///   </para>
    /// </summary>
    property DrawText:String read FDrawText write FDrawText;
  published
    /// <summary>
    ///   <para>
    ///     提示文本
    ///   </para>
    ///   <para>
    ///     Help text
    ///   </para>
    /// </summary>
    property HelpText:String read FHelpText write SetHelpText;
  end;








  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     下拉框默认素材
  ///   </para>
  ///   <para>
  ///     Default material of ComboBox
  ///   </para>
  /// </summary>
  TSkinComboBoxDefaultMaterial=class(TSkinControlMaterial)
  private
    //下拉箭头图片图片
    FArrowPicture:TDrawPicture;
    //下拉箭头图片图标绘制参数
    FDrawArrowPictureParam:TDrawPictureParam;


    //在ListBox中文本的绘制参数
    FDrawTextParam:TDrawTextParam;


    //提示文本绘制字体
    FDrawHelpTextParam:TDrawTextParam;


    //正常状态图片
    FNormalPicture:TDrawPicture;
    //鼠标停靠状态图片
    FHoverPicture:TDrawPicture;
    //获取焦点情况下的状态图片
    FFocusedPicture:TDrawPicture;
    //禁用状态图片
    FDisabledPicture:TDrawPicture;
    //图片绘制参数
    FDrawPictureParam:TDrawPictureParam;


    procedure SetHoverPicture(const Value: TDrawPicture);
    procedure SetFocusedPicture(const Value: TDrawPicture);
    procedure SetNormalPicture(const Value: TDrawPicture);
    procedure SetDisabledPicture(const Value: TDrawPicture);
    procedure SetDrawPictureParam(const Value: TDrawPictureParam);

    procedure SetDrawTextParam(const Value: TDrawTextParam);
    procedure SetDrawHelpTextParam(const Value: TDrawTextParam);

    procedure SetArrowPicture(const Value: TDrawPicture);
    procedure SetDrawArrowPictureParam(const Value: TDrawPictureParam);
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    function HasMouseDownEffect:Boolean;override;
    function HasMouseOverEffect:Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //
    /// <summary>
    ///   <para>
    ///    下拉箭头图标(点击弹出下拉菜单)
    ///   </para>
    ///   <para>
    ///     Drop down arrow icon(click to pop up drop down menu)
    ///   </para>
    /// </summary>
    property ArrowPicture:TDrawPicture read FArrowPicture write SetArrowPicture;
    //
    /// <summary>
    ///   <para>
    ///     下拉箭头图标绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of dropdown arrow icon
    ///   </para>
    /// </summary>
    property DrawArrowPictureParam:TDrawPictureParam read FDrawArrowPictureParam write SetDrawArrowPictureParam;


    //
    /// <summary>
    ///   <para>
    ///     正常状态图片
    ///   </para>
    ///   <para>
    ///     Normal state picture
    ///   </para>
    /// </summary>
    property NormalPicture:TDrawPicture read FNormalPicture write SetNormalPicture;
    //
    /// <summary>
    ///   <para>
    ///     鼠标停靠状态图片
    ///   </para>
    ///   <para>
    ///     Picture at mouse hovering state
    ///   </para>
    /// </summary>
    property HoverPicture:TDrawPicture read FHoverPicture write SetHoverPicture;
    //
    /// <summary>
    ///   <para>
    ///     获取焦点状态下的图片
    ///   </para>
    ///   <para>
    ///      Picture of getting focused state
    ///   </para>
    /// </summary>
    property FocusedPicture:TDrawPicture read FFocusedPicture write SetFocusedPicture;
    //
    /// <summary>
    ///   <para>
    ///     禁用状态图片
    ///   </para>
    ///   <para>
    ///     Picture at disabled state
    ///   </para>
    /// </summary>
    property DisabledPicture:TDrawPicture read FDisabledPicture write SetDisabledPicture;


    //
    /// <summary>
    ///   <para>
    ///     图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of picture
    ///   </para>
    /// </summary>
    property DrawPictureParam:TDrawPictureParam read FDrawPictureParam write SetDrawPictureParam;


    //
    /// <summary>
    ///   <para>
    ///     提示文本绘制参数
    ///   </para>
    ///   <para>
    ///     Draw text of Help text
    ///   </para>
    /// </summary>
    property DrawHelpTextParam:TDrawTextParam read FDrawHelpTextParam write SetDrawHelpTextParam;
    //
    /// <summary>
    ///   <para>
    ///     在ListBox中文本的绘制参数
    ///   </para>
    ///   <para>
    ///     Draw text parameters in ListBox
    ///   </para>
    /// </summary>
    property DrawTextParam:TDrawTextParam read FDrawTextParam write SetDrawTextParam;
  end;

  TSkinComboBoxDefaultType=class(TSkinControlType)
  protected
    //下拉框接口
    FSkinComboBoxIntf:ISkinComboBox;
    function GetSkinMaterial:TSkinComboBoxDefaultMaterial;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    //绘制边框
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  public
    //自定义绘制方法
    function CustomPaintHelpText(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;virtual;
  end;








implementation





{ TSkinComboBoxDefaultType }


function TSkinComboBoxDefaultType.GetSkinMaterial: TSkinComboBoxDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinComboBoxDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinComboBoxDefaultType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  ADrawPicture:TDrawPicture;
begin
  ADrawPicture:=nil;
  if Self.GetSkinMaterial<>nil then
  begin


    if Not Self.FSkinControlIntf.Enabled then
    begin
      ADrawPicture:=Self.GetSkinMaterial.FDisabledPicture;
    end
    else if Self.FSkinControlIntf.Focused and APaintData.IsDrawInteractiveState  then
    begin
      ADrawPicture:=Self.GetSkinMaterial.FFocusedPicture;
    end
    else if Self.FSkinControlIntf.IsMouseOver and APaintData.IsDrawInteractiveState  then
    begin
      ADrawPicture:=Self.GetSkinMaterial.FHoverPicture;
    end
    else
    begin
      ADrawPicture:=Self.GetSkinMaterial.FNormalPicture;
    end;

    if ADrawPicture.CurrentPictureIsEmpty then
    begin
      ADrawPicture:=Self.GetSkinMaterial.FNormalPicture;
    end;



    //绘制背景图片
    ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawPictureParam,ADrawPicture,ADrawRect);


    //绘制下拉箭头
    ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawArrowPictureParam,
                          Self.GetSkinMaterial.FArrowPicture,
                          ADrawRect);




    //绘制文本
    if APaintData.IsInDrawDirectUI then
    begin
      ACanvas.DrawText(Self.GetSkinMaterial.FDrawTextParam,
                      Self.FSkinComboBoxIntf.Prop.DrawText,
                      ADrawRect);
    end
    else
    begin

      //绘制文本
      if (Self.FSkinComboBoxIntf.Text<>'') then
      begin
        ACanvas.DrawText(Self.GetSkinMaterial.FDrawTextParam,
                        Self.FSkinComboBoxIntf.Text,
                        ADrawRect);
      end;

    end;




    {$IFDEF FMX}
    CustomPaintHelpText(ACanvas,ASkinMaterial,ADrawRect,APaintData);
    {$ENDIF}



  end;
end;

function TSkinComboBoxDefaultType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinComboBox,Self.FSkinComboBoxIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinComboBox Interface');
    end;
  end;
end;

procedure TSkinComboBoxDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinComboBoxIntf:=nil;
end;

function TSkinComboBoxDefaultType.CustomPaintHelpText(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin

  //绘制提示文本
  if (
            (Self.FSkinComboBoxIntf.Text='') and not APaintData.IsInDrawDirectUI
          or (Self.FSkinComboBoxIntf.Prop.DrawText='') and APaintData.IsInDrawDirectUI
      )
     and (Self.FSkinComboBoxIntf.Prop.HelpText<>'') then
  begin
    ACanvas.DrawText(Self.GetSkinMaterial.FDrawHelpTextParam,Self.FSkinComboBoxIntf.Prop.HelpText,ADrawRect);
  end;

end;



{ TSkinComboBoxDefaultMaterial }


procedure TSkinComboBoxDefaultMaterial.SetDrawArrowPictureParam(const Value: TDrawPictureParam);
begin
  FDrawArrowPictureParam.Assign(Value);
end;

procedure TSkinComboBoxDefaultMaterial.SetDrawHelpTextParam(const Value: TDrawTextParam);
begin
  FDrawHelpTextParam.Assign(Value);
end;

procedure TSkinComboBoxDefaultMaterial.SetDrawTextParam(const Value: TDrawTextParam);
begin
  FDrawTextParam.Assign(Value);
end;

constructor TSkinComboBoxDefaultMaterial.Create;
begin
  inherited Create(AOwner);


  FDrawHelpTextParam:=CreateDrawTextParam('DrawHelpTextParam','提示文本绘制参数');
  FDrawHelpTextParam.DrawFont.FontColor.Color:=GrayColor;

  FDrawTextParam:=CreateDrawTextParam('DrawTextParam','在ListBox中文本的绘制参数');

  FArrowPicture:=CreateDrawPicture('ArrowPicture','下拉箭头图标');
  FDrawArrowPictureParam:=CreateDrawPictureParam('DrawArrowPictureParam','下拉箭头图标绘制参数');



  FNormalPicture:=CreateDrawPicture('NormalPicture','正常状态图片');
  FHoverPicture:=CreateDrawPicture('HoverPicture','鼠标停靠状态图片');
  FFocusedPicture:=CreateDrawPicture('FocusedPicture','获取焦点状态图片');
  FDisabledPicture:=CreateDrawPicture('DisabledPicture','禁用状态图片');

  FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','图片绘制参数');
end;

//function TSkinComboBoxDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
////    if ABTNode.NodeName='DrawPictureParam' then
////    begin
////      FDrawPictureParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='NormalPicture' then
////    begin
////      FNormalPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HoverPicture' then
////    begin
////      FHoverPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='DisabledPicture' then
////    begin
////      FDisabledPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    ;
////
////  end;
//
//  Result:=True;
//end;
//
//function TSkinComboBoxDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawPictureParam',FDrawPictureParam.Name);
////  Self.FDrawPictureParam.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('NormalPicture',FNormalPicture.Name);
////  Self.FNormalPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('HoverPicture',FHoverPicture.Name);
////  Self.FHoverPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('DisabledPicture',FDisabledPicture.Name);
////  Self.FDisabledPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
//
//  Result:=True;
//end;

destructor TSkinComboBoxDefaultMaterial.Destroy;
begin
  FreeAndNil(FArrowPicture);
  FreeAndNil(FDrawArrowPictureParam);

  FreeAndNil(FDrawTextParam);
  FreeAndNil(FDrawHelpTextParam);

  FreeAndNil(FDrawPictureParam);
  FreeAndNil(FNormalPicture);
  FreeAndNil(FHoverPicture);
  FreeAndNil(FFocusedPicture);
  FreeAndNil(FDisabledPicture);
  inherited;
end;

function TSkinComboBoxDefaultMaterial.HasMouseDownEffect: Boolean;
begin
  Result:=True;
end;

function TSkinComboBoxDefaultMaterial.HasMouseOverEffect: Boolean;
begin
  Result:=True;
end;

procedure TSkinComboBoxDefaultMaterial.SetArrowPicture(const Value: TDrawPicture);
begin
  FArrowPicture.Assign(Value);
end;

procedure TSkinComboBoxDefaultMaterial.SetDisabledPicture(const Value: TDrawPicture);
begin
  FDisabledPicture.Assign(Value);
end;

procedure TSkinComboBoxDefaultMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;

procedure TSkinComboBoxDefaultMaterial.SetHoverPicture(const Value: TDrawPicture);
begin
  Self.FHoverPicture.Assign(Value);
end;

procedure TSkinComboBoxDefaultMaterial.SetFocusedPicture(const Value: TDrawPicture);
begin
  Self.FFocusedPicture.Assign(Value);
end;

procedure TSkinComboBoxDefaultMaterial.SetNormalPicture(const Value: TDrawPicture);
begin
  Self.FNormalPicture.Assign(Value);
end;


{ TComboBoxProperties }


function TComboBoxProperties.GetComponentClassify: String;
begin
  Result:='SkinComboBox';
end;

procedure TComboBoxProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
  Self.FHelpText:=TComboBoxProperties(Src).FHelpText;
end;

constructor TComboBoxProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinComboBox,Self.FSkinComboBoxIntf) then
  begin
    ShowException('This Component Do not Support ISkinComboBox Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=100;
    Self.FSkinControlIntf.Height:=22;
  end;
end;

destructor TComboBoxProperties.Destroy;
begin
  inherited;
end;

procedure TComboBoxProperties.SetHelpText(const Value: String);
begin
  if FHelpText<>Value then
  begin
    FHelpText:=Value;
    Invalidate;
  end;
end;





end.

