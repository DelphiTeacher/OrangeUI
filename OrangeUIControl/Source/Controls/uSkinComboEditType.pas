//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     下拉编辑框
///   </para>
///   <para>
///     ComboEdit Box
///   </para>
/// </summary>
unit uSkinComboEditType;

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
  IID_ISkinComboEdit:TGUID='{52C1C287-3771-4FDF-9806-094697991174}';



type
  TComboEditProperties=class;




  /// <summary>
  ///   <para>
  ///     下拉编辑框
  ///   </para>
  ///   <para>
  ///     ComboEdit Box
  ///   </para>
  /// </summary>
  ISkinComboEdit=interface//(ISkinControl)
    ['{52C1C287-3771-4FDF-9806-094697991174}']
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
    function IsReadOnly:Boolean;

    function GetComboEditProperties:TComboEditProperties;
    property Properties:TComboEditProperties read GetComboEditProperties;
    property Prop:TComboEditProperties read GetComboEditProperties;
  end;




  //
  /// <summary>
  ///   <para>
  ///     下拉编辑框属性
  ///   </para>
  ///   <para>
  ///     Properties of ComboEditBox
  ///   </para>
  /// </summary>
  TComboEditProperties=class(TSkinControlProperties)
  protected
    //在ListBox中绘制的文本
    FDrawText:String;
    //提示文本
    FHelpText:String;
    //提示图标
    FHelpIcon:TDrawPicture;

    //是否在获取焦点的时候绘制提示文本和提示图标
    FIsDrawHelpWhenFocused: Boolean;
    FIsAlwaysDrawHelp:Boolean;

    //文本框接口
    FSkinComboEditIntf:ISkinComboEdit;


    procedure SetHelpIcon(const Value: TDrawPicture);
    procedure SetHelpText(const Value: String);

    procedure SetIsDrawHelpWhenFocused(const Value: Boolean);
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
    ///     在ListBox中绘制的文本
    ///   </para>
    ///   <para>
    ///     Text of drawing in ListBox
    ///   </para>
    /// </summary>
    property DrawText:String read FDrawText write FDrawText;
  published
    //
    /// <summary>
    ///   <para>
    ///     提示文本
    ///   </para>
    ///   <para>
    ///     Help Text
    ///   </para>
    /// </summary>
    property HelpText:String read FHelpText write SetHelpText;
    //
    /// <summary>
    ///   <para>
    ///     提示图标
    ///   </para>
    ///   <para>
    ///     Help Icon
    ///   </para>
    /// </summary>
    property HelpIcon:TDrawPicture read FHelpIcon write SetHelpIcon;


    //
    /// <summary>
    ///   <para>
    ///     是否在获取焦点的时候绘制提示文本和提示图标
    ///   </para>
    ///   <para>
    ///     Whether draw HelpText and HelpIcon when getting focused
    ///   </para>
    /// </summary>
    property IsDrawHelpWhenFocused:Boolean read FIsDrawHelpWhenFocused write SetIsDrawHelpWhenFocused ;//default False;
    property IsAlwaysDrawHelp:Boolean read FIsAlwaysDrawHelp write FIsAlwaysDrawHelp;
  end;









  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     下拉编辑框默认素材
  ///   </para>
  ///   <para>
  ///    ComboEdit Box default material
  ///   </para>
  /// </summary>
  TSkinComboEditDefaultMaterial=class(TSkinControlMaterial)
  private
    //下拉箭头
    FArrowPicture:TDrawPicture;
    //下拉箭头图标绘制参数
    FDrawArrowPictureParam:TDrawPictureParam;

    //在ListBox中文本的绘制参数
    FDrawTextParam:TDrawTextParam;

    //提示文本绘制字体
    FDrawHelpTextParam:TDrawTextParam;
    //左图标绘制参数
    FDrawHelpIconParam:TDrawPictureParam;

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

    procedure SetDrawHelpIconParam(const Value: TDrawPictureParam);
    procedure SetDrawHelpTextParam(const Value: TDrawTextParam);
    procedure SetDrawTextParam(const Value: TDrawTextParam);

    procedure SetArrowPicture(const Value: TDrawPicture);
    procedure SetDrawArrowPictureParam(const Value: TDrawPictureParam);
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
    ///     下拉箭头
    ///   </para>
    ///   <para>
    ///     Dropdown arrow
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
    ///     Picture at normal state
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
    ///     Picture at focused state
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
    ///     提示文本绘制字体
    ///   </para>
    ///   <para>
    ///     Draw font of help text
    ///   </para>
    /// </summary>
    property DrawHelpTextParam:TDrawTextParam read FDrawHelpTextParam write SetDrawHelpTextParam;
    //
    /// <summary>
    ///   <para>
    ///     在ListBox中文本的绘制参数
    ///   </para>
    ///   <para>
    ///     Text draw parameters in ListBox
    ///   </para>
    /// </summary>
    property DrawTextParam:TDrawTextParam read FDrawTextParam write SetDrawTextParam;
    //
    /// <summary>
    ///   <para>
    ///     提示图标绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of help icon
    ///   </para>
    /// </summary>
    property DrawHelpIconParam:TDrawPictureParam read FDrawHelpIconParam write SetDrawHelpIconParam;
  end;

  TSkinComboEditDefaultType=class(TSkinControlType)
  protected
    //下拉编辑框接口
    FSkinComboEditIntf:ISkinComboEdit;
    function GetSkinMaterial:TSkinComboEditDefaultMaterial;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    //在Windows下焦点切换的时候弹出或关闭模拟软键盘
    procedure FocusChanged;override;
    //绘制边框
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  public
    //自定义绘制方法
    function CustomPaintHelpText(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;virtual;
  end;





implementation





{ TSkinComboEditDefaultType }


function TSkinComboEditDefaultType.GetSkinMaterial: TSkinComboEditDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinComboEditDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

procedure TSkinComboEditDefaultType.FocusChanged;
begin
  inherited;
  {$IFDEF FMX}
  if not Self.FSkinComboEditIntf.IsReadOnly then
  begin
    if Self.FSkinControlIntf.Focused then
    begin
      SimulateCallMainFormVirtualKeyboardShow(TControl(Self.FSkinControl));
    end
    else
    begin
      SimulateCallMainFormVirtualKeyboardHide(TControl(Self.FSkinControl));
    end;
  end;
  {$ENDIF}
end;

function TSkinComboEditDefaultType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
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
    else if Self.FSkinControlIntf.Focused and APaintData.IsDrawInteractiveState then
    begin
      ADrawPicture:=Self.GetSkinMaterial.FFocusedPicture;
    end
    else if Self.FSkinControlIntf.IsMouseOver and APaintData.IsDrawInteractiveState then
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

    //绘制图标
    ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawHelpIconParam,Self.FSkinComboEditIntf.Prop.FHelpIcon,ADrawRect);


    //绘制下拉箭头
    ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawArrowPictureParam,
                          Self.GetSkinMaterial.FArrowPicture,
                          ADrawRect);





    //绘制文本
    if APaintData.IsInDrawDirectUI then
    begin
      ACanvas.DrawText(Self.GetSkinMaterial.FDrawTextParam,
                      Self.FSkinComboEditIntf.Prop.DrawText,
                      ADrawRect);
    end;


    {$IFDEF FMX}
    CustomPaintHelpText(ACanvas,ASkinMaterial,ADrawRect,APaintData);
    {$ENDIF}
  end;
end;

function TSkinComboEditDefaultType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinComboEdit,Self.FSkinComboEditIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinComboEdit Interface');
    end;
  end;
end;

procedure TSkinComboEditDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinComboEditIntf:=nil;
end;

function TSkinComboEditDefaultType.CustomPaintHelpText(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin

  //绘制提示文本
  //绘制提示文本
  if
      (
        Not Self.FSkinControlIntf.Focused
        or Self.FSkinControlIntf.Focused and Self.FSkinComboEditIntf.Prop.IsDrawHelpWhenFocused
        or Self.FSkinComboEditIntf.Prop.FIsAlwaysDrawHelp
      )
     and
        (
            (Self.FSkinComboEditIntf.Text='') and not APaintData.IsInDrawDirectUI
          or (Self.FSkinComboEditIntf.Prop.DrawText='') and APaintData.IsInDrawDirectUI
          )
     and (Self.FSkinComboEditIntf.Prop.HelpText<>'') then
  begin
    ACanvas.DrawText(Self.GetSkinMaterial.FDrawHelpTextParam,
                    Self.FSkinComboEditIntf.Prop.HelpText,
                    ADrawRect);
  end;

end;



{ TSkinComboEditDefaultMaterial }


procedure TSkinComboEditDefaultMaterial.SetDrawArrowPictureParam(const Value: TDrawPictureParam);
begin
  FDrawArrowPictureParam.Assign(Value);
end;

procedure TSkinComboEditDefaultMaterial.SetDrawHelpIconParam(const Value: TDrawPictureParam);
begin
  FDrawHelpIconParam.Assign(Value);
end;

procedure TSkinComboEditDefaultMaterial.SetDrawHelpTextParam(const Value: TDrawTextParam);
begin
  FDrawHelpTextParam.Assign(Value);
end;

procedure TSkinComboEditDefaultMaterial.SetDrawTextParam(const Value: TDrawTextParam);
begin
  FDrawTextParam.Assign(Value);
end;


constructor TSkinComboEditDefaultMaterial.Create;
begin
  inherited Create(AOwner);

  FDrawHelpIconParam:=CreateDrawPictureParam('DrawHelpIconParam','提示图标绘制参数');


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

//function TSkinComboEditDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
//function TSkinComboEditDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
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

destructor TSkinComboEditDefaultMaterial.Destroy;
begin
  FreeAndNil(FArrowPicture);
  FreeAndNil(FDrawArrowPictureParam);
  FreeAndNil(FDrawTextParam);
  FreeAndNil(FDrawHelpTextParam);
  FreeAndNil(FDrawHelpIconParam);
  FreeAndNil(FDrawPictureParam);
  FreeAndNil(FNormalPicture);
  FreeAndNil(FHoverPicture);
  FreeAndNil(FFocusedPicture);
  FreeAndNil(FDisabledPicture);
  inherited;
end;

procedure TSkinComboEditDefaultMaterial.SetArrowPicture(const Value: TDrawPicture);
begin
  FArrowPicture.Assign(Value);
end;

procedure TSkinComboEditDefaultMaterial.SetDisabledPicture(const Value: TDrawPicture);
begin
  FDisabledPicture.Assign(Value);
end;

procedure TSkinComboEditDefaultMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;

procedure TSkinComboEditDefaultMaterial.SetHoverPicture(const Value: TDrawPicture);
begin
  Self.FHoverPicture.Assign(Value);
end;

procedure TSkinComboEditDefaultMaterial.SetFocusedPicture(const Value: TDrawPicture);
begin
  Self.FFocusedPicture.Assign(Value);
end;

procedure TSkinComboEditDefaultMaterial.SetNormalPicture(const Value: TDrawPicture);
begin
  Self.FNormalPicture.Assign(Value);
end;


{ TComboEditProperties }


function TComboEditProperties.GetComponentClassify: String;
begin
  Result:='SkinComboEdit';
end;

procedure TComboEditProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
  Self.FHelpText:=TComboEditProperties(Src).FHelpText;
  Self.FHelpIcon.Assign(TComboEditProperties(Src).FHelpIcon);
//  Self.FBorderMargins.Assign(TComboEditProperties(Src).FBorderMargins);
  Self.FIsDrawHelpWhenFocused:=TComboEditProperties(Src).FIsDrawHelpWhenFocused;
  Self.FIsAlwaysDrawHelp:=TComboEditProperties(Src).FIsAlwaysDrawHelp;
end;

constructor TComboEditProperties.Create(ASkinControl:TControl);
begin
//  FBorderMargins:=TBorderMargins.Create;
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinComboEdit,Self.FSkinComboEditIntf) then
  begin
    ShowException('This Component Do not Support ISkinComboEdit Interface');
  end
  else
  begin
//    FBorderMargins.OnChange:=Self.OnBorderMarginsChangeNotify;
    FHelpIcon:=CreateDrawPicture('HelpIcon','提示图标');
    Self.FSkinControlIntf.Width:=100;
    Self.FSkinControlIntf.Height:=22;
    Self.FIsDrawHelpWhenFocused:=True;//False;
  end;
end;

procedure TComboEditProperties.SetIsDrawHelpWhenFocused(const Value: Boolean);
begin
  if FIsDrawHelpWhenFocused<>Value then
  begin
    FIsDrawHelpWhenFocused:=Value;
    Invalidate;
  end;
end;

destructor TComboEditProperties.Destroy;
begin
//  FBorderMargins.OnChange:=nil;
//  FreeAndNil(FBorderMargins);
  FreeAndNil(FHelpIcon);
  inherited;
end;

procedure TComboEditProperties.SetHelpText(const Value: String);
begin
  if FHelpText<>Value then
  begin
    FHelpText:=Value;
    Invalidate;
  end;
end;

procedure TComboEditProperties.SetHelpIcon(const Value: TDrawPicture);
begin
  FHelpIcon.Assign(Value);
end;

//procedure TComboEditProperties.SetBorderMargins(const Value: TBorderMargins);
//begin
//  FBorderMargins.Assign(Value);
//end;
//
//procedure TComboEditProperties.OnBorderMarginsChangeNotify(Sender: TObject);
//begin
//
//end;





end.


