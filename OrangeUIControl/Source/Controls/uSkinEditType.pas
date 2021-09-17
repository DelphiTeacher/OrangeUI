//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     文本框
///   </para>
///   <para>
///     TextBox
///   </para>
/// </summary>
unit uSkinEditType;

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
  IID_ISkinEdit:TGUID='{426563B4-4D6F-4FB9-86EB-D85FD79744C9}';



type
  TEditProperties=class;





  /// <summary>
  ///   <para>
  ///     文本框接口
  ///   </para>
  ///   <para>
  ///     Interface of TextBox
  ///   </para>
  /// </summary>
  ISkinEdit=interface//(ISkinControl)
  ['{426563B4-4D6F-4FB9-86EB-D85FD79744C9}']

    function GetText:String;
    property Text:String read GetText;
    function IsReadOnly:Boolean;
    function GetPasswordChar:Char;

    function GetEditProperties:TEditProperties;
    property Properties:TEditProperties read GetEditProperties;
    property Prop:TEditProperties read GetEditProperties;
  end;






  //
  /// <summary>
  ///   <para>
  ///     文本框属性
  ///   </para>
  ///   <para>
  ///     TextBox property
  ///   </para>
  /// </summary>
  TEditProperties=class(TSkinControlProperties)
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
    FSkinEditIntf:ISkinEdit;


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

    property DrawText:String read FDrawText write FDrawText;
  published
    //
    /// <summary>
    ///   <para>
    ///     提示文本
    ///   </para>
    ///   <para>
    ///     HelpText
    ///   </para>
    /// </summary>
    property HelpText:String read FHelpText write SetHelpText;
    //
    /// <summary>
    ///   <para>
    ///     提示图标
    ///   </para>
    ///   <para>
    ///     HelpIcon
    ///   </para>
    /// </summary>
    property HelpIcon:TDrawPicture read FHelpIcon write SetHelpIcon;

    //
    /// <summary>
    ///   <para>
    ///     是否在获取焦点的时候绘制提示文本和提示图标
    ///   </para>
    ///   <para>
    ///     Whether draw HelpText and DrawIcon when get focused
    ///   </para>
    /// </summary>
    property IsDrawHelpWhenFocused:Boolean read FIsDrawHelpWhenFocused write SetIsDrawHelpWhenFocused ;//default False;
    property IsAlwaysDrawHelp:Boolean read FIsAlwaysDrawHelp write FIsAlwaysDrawHelp;
  end;









  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     文本框默认素材
  ///   </para>
  ///   <para>
  ///     TextBox default material
  ///   </para>
  /// </summary>
  TSkinEditDefaultMaterial=class(TSkinControlMaterial)
  private
    //提示文本绘制字体
    FDrawHelpTextParam:TDrawTextParam;
    //在ListBox中文本的绘制参数
    FDrawTextParam:TDrawTextParam;
    //提示图标绘制参数
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
    ///     Mouse hovering state picture
    ///   </para>
    /// </summary>
    property HoverPicture:TDrawPicture read FHoverPicture write SetHoverPicture;
    //
    /// <summary>
    ///   <para>
    ///     获取焦点状态下的图片
    ///   </para>
    ///   <para>
    ///     Get focused state picture
    ///   </para>
    /// </summary>
    property FocusedPicture:TDrawPicture read FFocusedPicture write SetFocusedPicture;
    //
    /// <summary>
    ///   <para>
    ///     禁用状态图片
    ///   </para>
    ///   <para>
    ///     disabled state picture
    ///   </para>
    /// </summary>
    property DisabledPicture:TDrawPicture read FDisabledPicture write SetDisabledPicture;


    //
    /// <summary>
    ///   <para>
    ///     图片绘制参数
    ///   </para>
    ///   <para>
    ///     Picture draw parameter
    ///   </para>
    /// </summary>
    property DrawPictureParam:TDrawPictureParam read FDrawPictureParam write SetDrawPictureParam;



    //
    /// <summary>
    ///   <para>
    ///     提示文本的绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameter of HelpText
    ///   </para>
    /// </summary>
    property DrawHelpTextParam:TDrawTextParam read FDrawHelpTextParam write SetDrawHelpTextParam;
    //
    /// <summary>
    ///   <para>
    ///     在ListBox中文本的绘制参数
    ///   </para>
    ///   <para>
    ///     Text draw parameter in ListBox
    ///   </para>
    /// </summary>
    property DrawTextParam:TDrawTextParam read FDrawTextParam write SetDrawTextParam;
    //
    /// <summary>
    ///   <para>
    ///     提示图标绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameter of HelpIcon
    ///   </para>
    /// </summary>
    property DrawHelpIconParam:TDrawPictureParam read FDrawHelpIconParam write SetDrawHelpIconParam;
  end;

  TSkinEditDefaultType=class(TSkinControlType)
  protected
    //文本框接口
    FSkinEditIntf:ISkinEdit;
    function GetSkinMaterial:TSkinEditDefaultMaterial;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;

    //弹出或关闭软键盘
    procedure FocusChanged;override;

    //绘制边框
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  public
    //自定义绘制方法
    function CustomPaintHelpText(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;virtual;
  end;








implementation







{ TSkinEditDefaultType }


function TSkinEditDefaultType.GetSkinMaterial: TSkinEditDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinEditDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinEditDefaultType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  ADrawPicture:TDrawPicture;
  APasswordText:String;
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
    ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawHelpIconParam,
                        Self.FSkinEditIntf.Prop.FHelpIcon,
                        ADrawRect);


    //绘制文本
    if APaintData.IsInDrawDirectUI then
    begin


      {$IFDEF VCL}
      CustomPaintHelpText(ACanvas,ASkinMaterial,ADrawRect,APaintData);
      {$ENDIF}


      if Self.FSkinEditIntf.GetPasswordChar=#0 then
      begin
        ACanvas.DrawText(Self.GetSkinMaterial.FDrawTextParam,
                        Self.FSkinEditIntf.Prop.DrawText,
                        ADrawRect);
      end
      else
      begin
        if Self.FSkinEditIntf.Prop.DrawText<>'' then
        begin
          APasswordText:=Self.FSkinEditIntf.GetPasswordChar;
          APasswordText:=APasswordText+APasswordText+APasswordText+APasswordText+APasswordText+APasswordText;
          ACanvas.DrawText(Self.GetSkinMaterial.FDrawTextParam,
                          APasswordText,
                          ADrawRect);
        end;
      end;


    end;




    {$IFDEF FMX}
    CustomPaintHelpText(ACanvas,ASkinMaterial,ADrawRect,APaintData);
    {$ENDIF}


  end;
end;

function TSkinEditDefaultType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinEdit,Self.FSkinEditIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinEdit Interface');
    end;
  end;
end;

procedure TSkinEditDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinEditIntf:=nil;
end;

procedure TSkinEditDefaultType.FocusChanged;
begin
  inherited;
  {$IFDEF FMX}
  if not Self.FSkinEditIntf.IsReadOnly then
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

function TSkinEditDefaultType.CustomPaintHelpText(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin
  //绘制提示文本
  if (
          Not Self.FSkinControlIntf.Focused
           or Self.FSkinControlIntf.Focused and Self.FSkinEditIntf.Prop.IsDrawHelpWhenFocused
           or Self.FSkinEditIntf.Prop.FIsAlwaysDrawHelp
          )
     and (
            (Self.FSkinEditIntf.Text='') and not APaintData.IsInDrawDirectUI
          or (Self.FSkinEditIntf.Prop.DrawText='') and APaintData.IsInDrawDirectUI
          )
     and (Self.FSkinEditIntf.Prop.HelpText<>'') then
  begin
    ACanvas.DrawText(Self.GetSkinMaterial.FDrawHelpTextParam,Self.FSkinEditIntf.Prop.HelpText,ADrawRect);
  end;

end;








{ TSkinEditDefaultMaterial }


procedure TSkinEditDefaultMaterial.SetDrawHelpIconParam(const Value: TDrawPictureParam);
begin
  FDrawHelpIconParam.Assign(Value);
end;

procedure TSkinEditDefaultMaterial.SetDrawHelpTextParam(const Value: TDrawTextParam);
begin
  FDrawHelpTextParam.Assign(Value);
end;

procedure TSkinEditDefaultMaterial.SetDrawTextParam(const Value: TDrawTextParam);
begin
  FDrawTextParam.Assign(Value);
end;

constructor TSkinEditDefaultMaterial.Create;
begin
  inherited Create(AOwner);

  FDrawHelpIconParam:=CreateDrawPictureParam('DrawHelpIconParam','提示图标绘制参数');

  FDrawHelpTextParam:=CreateDrawTextParam('DrawHelpTextParam','提示文本绘制参数');
  FDrawHelpTextParam.DrawFont.FontColor.Color:=GrayColor;

  FDrawTextParam:=CreateDrawTextParam('DrawTextParam','在ListBox中文本的绘制参数');

  FNormalPicture:=CreateDrawPicture('NormalPicture','正常状态图片');
  FHoverPicture:=CreateDrawPicture('HoverPicture','鼠标停靠状态图片');
  FFocusedPicture:=CreateDrawPicture('FocusedPicture','获取焦点状态图片');
  FDisabledPicture:=CreateDrawPicture('DisabledPicture','禁用状态图片');

  FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','图片绘制参数');
end;

//function TSkinEditDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
//function TSkinEditDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
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

destructor TSkinEditDefaultMaterial.Destroy;
begin
  FreeAndNil(FDrawHelpTextParam);
  FreeAndNil(FDrawTextParam);
  FreeAndNil(FDrawHelpIconParam);
  FreeAndNil(FDrawPictureParam);
  FreeAndNil(FNormalPicture);
  FreeAndNil(FHoverPicture);
  FreeAndNil(FFocusedPicture);
  FreeAndNil(FDisabledPicture);
  inherited;
end;

procedure TSkinEditDefaultMaterial.SetDisabledPicture(const Value: TDrawPicture);
begin
  FDisabledPicture.Assign(Value);
end;

procedure TSkinEditDefaultMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;

procedure TSkinEditDefaultMaterial.SetHoverPicture(const Value: TDrawPicture);
begin
  Self.FHoverPicture.Assign(Value);
end;

procedure TSkinEditDefaultMaterial.SetFocusedPicture(const Value: TDrawPicture);
begin
  Self.FFocusedPicture.Assign(Value);
end;

procedure TSkinEditDefaultMaterial.SetNormalPicture(const Value: TDrawPicture);
begin
  Self.FNormalPicture.Assign(Value);
end;






{ TEditProperties }


function TEditProperties.GetComponentClassify: String;
begin
  Result:='SkinEdit';
end;

procedure TEditProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
  Self.FHelpText:=TEditProperties(Src).FHelpText;
  Self.FHelpIcon.Assign(TEditProperties(Src).FHelpIcon);
//  Self.FBorderMargins.Assign(TEditProperties(Src).FBorderMargins);
  Self.FIsDrawHelpWhenFocused:=TEditProperties(Src).FIsDrawHelpWhenFocused;
  Self.FIsAlwaysDrawHelp:=TEditProperties(Src).FIsAlwaysDrawHelp;
end;

constructor TEditProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinEdit,Self.FSkinEditIntf) then
  begin
    ShowException('This Component Do not Support ISkinEdit Interface');
  end
  else
  begin
    FHelpIcon:=CreateDrawPicture('HelpIcon','提示图标');
    Self.FSkinControlIntf.Width:=100;
    Self.FSkinControlIntf.Height:=22;
    Self.FIsDrawHelpWhenFocused:=True;//False;
  end;
end;

procedure TEditProperties.SetIsDrawHelpWhenFocused(const Value: Boolean);
begin
  if FIsDrawHelpWhenFocused<>Value then
  begin
    FIsDrawHelpWhenFocused:=Value;
    Invalidate;
  end;
end;

destructor TEditProperties.Destroy;
begin
  FreeAndNil(FHelpIcon);
  inherited;
end;

procedure TEditProperties.SetHelpText(const Value: String);
begin
  if FHelpText<>Value then
  begin
    FHelpText:=Value;
    Invalidate;
  end;
end;

procedure TEditProperties.SetHelpIcon(const Value: TDrawPicture);
begin
  FHelpIcon.Assign(Value);
end;






end.

