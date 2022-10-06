//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     备注框
///   </para>
///   <para>
///     Memo Box
///   </para>
/// </summary>
unit uSkinMemoType;

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
  uVersion,
  uSkinPublic,
  uGraphicCommon,
  uBaseLog,
  uBinaryTreeDoc,
//  uSkinPackage,

//  {$IFDEF SKIN_SUPEROBJECT}
  uSkinSuperObject,
//  {$ELSE}
//  XSuperObject,
//  XSuperJson,
//  {$ENDIF}

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
  IID_ISkinMemo:TGUID='{426563B4-4D6F-4FB9-86EB-D85FD79744C9}';



type
  TMemoProperties=class;




  /// <summary>
  ///   <para>
  ///     备注框接口
  ///   </para>
  ///   <para>
  ///     Interface of MemoBox
  ///   </para>
  /// </summary>
  ISkinMemo=interface//(ISkinControl)
  ['{426563B4-4D6F-4FB9-86EB-D85FD79744C9}']

    function GetMemoMaxLength:Integer;

    procedure SetIsAutoHeight(const Value:Boolean);
    procedure DoAutoHeightMemoChange(Sender:TObject);
    function IsReadOnly:Boolean;

    function GetText:String;
    property Text:String read GetText;

    function GetMemoProperties:TMemoProperties;
    property Properties:TMemoProperties read GetMemoProperties;
    property Prop:TMemoProperties read GetMemoProperties;
  end;






  /// <summary>
  ///   <para>
  ///     备注框属性
  ///   </para>
  ///   <para>
  ///     Properties of MemoBox
  ///   </para>
  /// </summary>
  TMemoProperties=class(TSkinControlProperties)
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

    //是否绘制字数统计
    FIsDrawCharCount:Boolean;


    //文本框接口
    FSkinMemoIntf:ISkinMemo;

    procedure SetHelpIcon(const Value: TDrawPicture);
    procedure SetHelpText(const Value: String);

    procedure SetIsDrawHelpWhenFocused(const Value: Boolean);
    procedure SetIsDrawCharCount(const Value: Boolean);
  private
    //自动计算高度
    FIsAutoHeight: Boolean;
    FAutoHeightMaxLineCount:Integer;
    procedure SetIsAutoHeight(const Value: Boolean);
    procedure SetAutoHeightMaxLineCount(const Value: Integer);
  protected
    procedure GetPropJson(ASuperObject:ISuperObject);override;
    procedure SetPropJson(ASuperObject:ISuperObject);override;

    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    //在ListBox中绘制的文本
    property DrawText:String read FDrawText write FDrawText;
  published

    /// <summary>
    ///   <para>
    ///     是否在获取焦点的时候绘制提示文本和提示图标
    ///   </para>
    ///   <para>
    ///     Whether draw HelpText and HelpIcon when get focused
    ///   </para>
    /// </summary>
    property IsDrawHelpWhenFocused:Boolean read FIsDrawHelpWhenFocused write SetIsDrawHelpWhenFocused ;//default False;
    property IsAlwaysDrawHelp:Boolean read FIsAlwaysDrawHelp write FIsAlwaysDrawHelp;
    //是否绘制字数统计
    property IsDrawCharCount:Boolean read FIsDrawCharCount write SetIsDrawCharCount;
    //是否设置自动高度
    property IsAutoHeight:Boolean read FIsAutoHeight write SetIsAutoHeight;
    //自动高度的最大行数
    property AutoHeightMaxLineCount:Integer read FAutoHeightMaxLineCount write SetAutoHeightMaxLineCount;

    /// <summary>
    ///   <para>
    ///     提示文本
    ///   </para>
    ///   <para>
    ///     Help Text
    ///   </para>
    /// </summary>
    property HelpText:String read FHelpText write SetHelpText;

    /// <summary>
    ///   <para>
    ///     提示图标
    ///   </para>
    ///   <para>
    ///     Help Icon
    ///   </para>
    /// </summary>
    property HelpIcon:TDrawPicture read FHelpIcon write SetHelpIcon;
  end;









  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     备注框素材基类
  ///   </para>
  ///   <para>
  ///     Base class of MemoBox material
  ///   </para>
  /// </summary>
  TSkinMemoDefaultMaterial=class(TSkinControlMaterial)
  private
    //在ListBox中文本的绘制参数
    FDrawTextParam:TDrawTextParam;
    //提示文本绘制字体
    FDrawHelpTextParam:TDrawTextParam;
    FDrawCharCountTextParam:TDrawTextParam;
    //左图标绘制参数
    FDrawHelpIconParam:TDrawPictureParam;

    //正常状态图片
    FNormalPicture:TDrawPicture;
    //鼠标停靠状态图片
    FHoverPicture:TDrawPicture;
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
    procedure SetDrawCharCountTextParam(const Value: TDrawTextParam);
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

    /// <summary>
    ///   <para>
    ///     图片绘制参数
    ///   </para>
    ///   <para>
    ///     Draw parameters of picture
    ///   </para>
    /// </summary>
    property DrawPictureParam:TDrawPictureParam read FDrawPictureParam write SetDrawPictureParam;

    /// <summary>
    ///   <para>
    ///     正常状态的图片
    ///   </para>
    ///   <para>
    ///     Picture at normal state
    ///   </para>
    /// </summary>
    property NormalPicture:TDrawPicture read FNormalPicture write SetNormalPicture;

    /// <summary>
    ///   <para>
    ///     鼠标停靠状态的图片
    ///   </para>
    ///   <para>
    ///     Picture at mouse hovering state
    ///   </para>
    /// </summary>
    property HoverPicture:TDrawPicture read FHoverPicture write SetHoverPicture;
    /// <summary>
    ///   <para>
    ///     焦点状态的图片
    ///   </para>
    ///   <para>
    ///     Picture at focused state
    ///   </para>
    /// </summary>
    property FocusedPicture:TDrawPicture read FFocusedPicture write SetFocusedPicture;

    /// <summary>
    ///   <para>
    ///     禁用状态的图片
    ///   </para>
    ///   <para>
    ///     Picture at disabled state
    ///   </para>
    /// </summary>
    property DisabledPicture:TDrawPicture read FDisabledPicture write SetDisabledPicture;

    /// <summary>
    ///   <para>
    ///     在ListBox中文本的绘制参数
    ///   </para>
    ///   <para>
    ///     Draw text parameters in ListBox
    ///   </para>
    /// </summary>
    property DrawTextParam:TDrawTextParam read FDrawTextParam write SetDrawTextParam;
    /// <summary>
    ///   <para>
    ///     提示文本绘制字体
    ///   </para>
    ///   <para>
    ///     Draw font of help text
    ///   </para>
    /// </summary>
    property DrawHelpTextParam:TDrawTextParam read FDrawHelpTextParam write SetDrawHelpTextParam;
    property DrawCharCountTextParam:TDrawTextParam read FDrawCharCountTextParam write SetDrawCharCountTextParam;

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

  TSkinMemoDefaultType=class(TSkinControlType)
  protected
    //文本框接口
    FSkinMemoIntf:ISkinMemo;
    function GetSkinMaterial:TSkinMemoDefaultMaterial;
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





{ TSkinMemoDefaultType }


function TSkinMemoDefaultType.GetSkinMaterial: TSkinMemoDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinMemoDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinMemoDefaultType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
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

    //绘制背景
    ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawPictureParam,ADrawPicture,ADrawRect);

    //绘制图标
    ACanvas.DrawPicture(Self.GetSkinMaterial.FDrawHelpIconParam,Self.FSkinMemoIntf.Prop.FHelpIcon,ADrawRect);




    //绘制文本
    if APaintData.IsInDrawDirectUI then
    begin
      ACanvas.DrawText(Self.GetSkinMaterial.FDrawTextParam,
                      Self.FSkinMemoIntf.Prop.DrawText,
                      ADrawRect);
    end;


    //绘制提示文本
    {$IFDEF FMX}
    CustomPaintHelpText(ACanvas,ASkinMaterial,ADrawRect,APaintData);
    {$ENDIF}



    if Self.FSkinMemoIntf.Properties.FIsDrawCharCount then
    begin
      //绘制字数统计
      ACanvas.DrawText(Self.GetSkinMaterial.FDrawCharCountTextParam,
                      IntToStr(Length(Self.FSkinMemoIntf.Text))+'/'+IntToStr(Self.FSkinMemoIntf.GetMemoMaxLength),
                      ADrawRect);
    end;



  end;
end;

function TSkinMemoDefaultType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinMemo,Self.FSkinMemoIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinMemo Interface');
    end;
  end;
end;

procedure TSkinMemoDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinMemoIntf:=nil;
end;

procedure TSkinMemoDefaultType.FocusChanged;
begin
  inherited;
  {$IFDEF FMX}
  if not Self.FSkinMemoIntf.IsReadOnly then
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

function TSkinMemoDefaultType.CustomPaintHelpText(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin
    //绘制提示文本
  if (
          Not Self.FSkinControlIntf.Focused
           or Self.FSkinControlIntf.Focused and Self.FSkinMemoIntf.Prop.IsDrawHelpWhenFocused
           or Self.FSkinMemoIntf.Prop.FIsAlwaysDrawHelp
          )
     and (
            (Self.FSkinMemoIntf.Text='') and not APaintData.IsInDrawDirectUI
          or (Self.FSkinMemoIntf.Prop.DrawText='') and APaintData.IsInDrawDirectUI
          )
     and (Self.FSkinMemoIntf.Prop.HelpText<>'') then
  begin
    ACanvas.DrawText(Self.GetSkinMaterial.FDrawHelpTextParam,Self.FSkinMemoIntf.Prop.HelpText,ADrawRect);
  end;
end;

//{ TSkinMemoType }
//
//function TSkinMemoType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;AIsDrawInteractiveState:Boolean): Boolean;
//begin
//
//end;
//
//function TSkinMemoType.GetSkinMaterial:TSkinMemoMaterial;
//begin
//  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
//  begin
//    Result:=TSkinMemoMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
//  end
//  else
//  begin
//    Result:=nil;
//  end;
//end;
//
//function TSkinMemoType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;AIsDrawInteractiveState:Boolean): Boolean;
//begin
//  //绘制边框背景透明
//  if (Self.FSkinMemoIntf<>nil)
//    and (GetSkinMaterial<>nil)
//    and (Self.FSkinMemoIntf.BorderStyle<>bsNone) then
//  begin
//    if Self.GetSkinMaterial.FIsBorderTransparent then
//    begin
//      //绘制控件背景
//      Self.FSkinMemoIntf.DrawParentBackGround(ACanvas.Handle,0,0,Self.FSkinMemoIntf.Width,Self.FSkinMemoIntf.Height,0,0);
//    end;
//    //绘制边框
//    NCDrawBorderInNCPaint(ACanvas,ADrawRect);
//  end;
//  //自定义绘制
//  NCCustomPaintInNCPaint(ACanvas,ADrawRect);
//end;

//procedure TSkinMemoType.SizeChanged;
//begin
//  if Not (csDesigning in Self.ComponentState) then
//  begin
//    InvalidateSkinMemo;
//  end;
//end;
//
//{ TSkinMemoHelpTextType }
//
//function TSkinMemoHelpTextType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;AIsDrawInteractiveState:Boolean): Boolean;
//begin
//
//end;
//
//function TSkinMemoHelpTextType.CustomPaintHelpText(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;AIsDrawInteractiveState:Boolean): Boolean;
//begin
//  if Self.GetSkinMaterial<>nil then
//  begin
//    ACanvas.DrawText(Self.GetSkinMaterial.FDrawHelpTextParam,Self.FSkinMemoIntf.Prop.HelpText,ADrawRect);
//  end;
//end;
//
//procedure TSkinMemoHelpTextType.CustomUnBind;
//begin
//  Inherited CustomUnBind;
//  Self.FSkinMemoIntf:=nil;
//end;
//
//function TSkinMemoHelpTextType.GetCustomWMNCCalcSizeLeftWidth: Integer;
//begin
//  Result:=0;
//end;
//
//function TSkinMemoHelpTextType.GetCustomWMNCCalcSizeRightWidth: Integer;
//begin
//  Result:=0;
//end;
//
//function TSkinMemoHelpTextType.GetSkinMaterial:TSkinMemoHelpTextMaterial;
//begin
//  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
//  begin
//    Result:=TSkinMemoMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
//  end
//  else
//  begin
//    Result:=nil;
//  end;
//end;
//
//function TSkinMemoHelpTextType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRect): Boolean;
//begin
//  //绘制边框背景透明
//  if (Self.FSkinMemoIntf<>nil)
//    and (GetSkinMaterial<>nil)
//    and (Self.FSkinMemoIntf.BorderStyle<>bsNone) then
//  begin
//    if Self.GetSkinMaterial.FIsBorderTransparent then
//    begin
//      //绘制控件背景
//      Self.FSkinMemoIntf.DrawParentBackGround(ACanvas.Handle,0,0,Self.FSkinMemoIntf.Width,Self.FSkinMemoIntf.Height,0,0);
//    end;
//    //绘制边框
//    NCDrawBorderInNCPaint(ACanvas,ADrawRect);
//  end;
//  //自定义绘制
//  NCCustomPaintInNCPaint(ACanvas,ADrawRect);
//end;

//procedure TSkinMemoHelpTextType.SizeChanged;
//begin
//  if Not (csDesigning in Self.ComponentState) then
//  begin
//    InvalidateSkinMemo;
//  end;
//end;
//
//
//{ TSkinMemoMaterial }
//
//constructor TSkinMemoMaterial.Create(AOwner:TComponent);
//begin
//  inherited Create(AOwner);
//end;
//
//function TSkinMemoMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  I: Integer;
//  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited LoadFromDocNode(ADocNode);
//
//  for I := 0 to ADocNode.ChildNodes.Count - 1 do
//  begin
//    ABTNode:=ADocNode.ChildNodes[I];
////    if ABTNode.NodeName='DrawHelpTextParam' then
////    begin
////      FDrawHelpTextParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else
//    if ABTNode.NodeName='BorderMargins' then
//    begin
//      FBorderMargins.LoadFromString(ABTNode.ConvertNode_WideString.Data);
//    end
//    else if ABTNode.NodeName='IsTransparent' then
//    begin
//      FIsTransparent:=ABTNode.ConvertNode_Bool32.Data;
//    end
//    else if ABTNode.NodeName='IsBorderTransparent' then
//    begin
//      FIsBorderTransparent:=ABTNode.ConvertNode_Bool32.Data;
//    end
//    ;
//
//  end;
//
//  Result:=True;
//end;
//
//function TSkinMemoMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
//var
//  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawHelpTextParam',FDrawHelpTextParam.Name);
////  Self.FDrawHelpTextParam.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//  ABTNode:=ADocNode.AddChildNode_WideString('BorderMargins','边框扩展边距');
//  ABTNode.ConvertNode_WideString.Data:=FBorderMargins.SaveToString;
//
//  ABTNode:=ADocNode.AddChildNode_Bool32('IsTransparent','是否背景透明');
//  ABTNode.ConvertNode_Bool32.Data:=FIsTransparent;
//
//  ABTNode:=ADocNode.AddChildNode_Bool32('IsBorderTransparent','是否边框透明');
//  ABTNode.ConvertNode_Bool32.Data:=FIsBorderTransparent;
//
//  Result:=True;
//end;
//
//destructor TSkinMemoMaterial.Destroy;
//begin
//  inherited;
//end;
//
//procedure TSkinMemoMaterial.SetIsBorderTransparent(const Value: Boolean);
//begin
//  FIsBorderTransparent := Value;
//end;
//
//procedure TSkinMemoMaterial.SetBorderMargins(const Value: TBorderMargins);
//begin
//  FBorderMargins.Assign(Value);
//end;
//
//procedure TSkinMemoMaterial.OnBorderMarginsChangeNotify(Sender: TObject);
//begin
//  if Not (csDesigning in Self.ComponentState) then
//  begin
//  end;
//end;




{ TSkinMemoDefaultMaterial }


procedure TSkinMemoDefaultMaterial.SetDrawHelpIconParam(const Value: TDrawPictureParam);
begin
  FDrawHelpIconParam.Assign(Value);
end;

procedure TSkinMemoDefaultMaterial.SetDrawHelpTextParam(const Value: TDrawTextParam);
begin
  FDrawHelpTextParam.Assign(Value);
end;

procedure TSkinMemoDefaultMaterial.SetDrawCharCountTextParam(const Value: TDrawTextParam);
begin
  FDrawCharCountTextParam.Assign(Value);
end;

procedure TSkinMemoDefaultMaterial.SetDrawTextParam(const Value: TDrawTextParam);
begin
  FDrawTextParam.Assign(Value);
end;


constructor TSkinMemoDefaultMaterial.Create;
begin
  inherited Create(AOwner);

  FDrawHelpIconParam:=CreateDrawPictureParam('DrawHelpIconParam','提示图标绘制参数');

  FDrawHelpTextParam:=CreateDrawTextParam('DrawHelpTextParam','提示文本绘制参数');
  FDrawHelpTextParam.DrawFont.FontColor.Color:=GrayColor;

  FDrawCharCountTextParam:=CreateDrawTextParam('DrawCharCountTextParam','字数统计文本绘制参数');
  FDrawCharCountTextParam.DrawFont.FontColor.Color:=GrayColor;

  FDrawTextParam:=CreateDrawTextParam('DrawTextParam','在ListBox中文本的绘制参数');

  FNormalPicture:=CreateDrawPicture('NormalPicture','正常状态图片');
  FHoverPicture:=CreateDrawPicture('HoverPicture','鼠标停靠状态图片');
  FFocusedPicture:=CreateDrawPicture('FocusedPicture','获取焦点状态图片');
  FDisabledPicture:=CreateDrawPicture('DisabledPicture','禁用状态图片');

  FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','图片绘制参数');
end;

//function TSkinMemoDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
//function TSkinMemoDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
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

destructor TSkinMemoDefaultMaterial.Destroy;
begin
  FreeAndNil(FDrawHelpTextParam);
  FreeAndNil(FDrawCharCountTextParam);
  FreeAndNil(FDrawTextParam);
  FreeAndNil(FDrawHelpIconParam);
  FreeAndNil(FDrawPictureParam);
  FreeAndNil(FNormalPicture);
  FreeAndNil(FHoverPicture);
  FreeAndNil(FFocusedPicture);
  FreeAndNil(FDisabledPicture);
  inherited;
end;

procedure TSkinMemoDefaultMaterial.SetDisabledPicture(const Value: TDrawPicture);
begin
  FDisabledPicture.Assign(Value);
end;

procedure TSkinMemoDefaultMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;

procedure TSkinMemoDefaultMaterial.SetHoverPicture(const Value: TDrawPicture);
begin
  Self.FHoverPicture.Assign(Value);
end;

procedure TSkinMemoDefaultMaterial.SetFocusedPicture(const Value: TDrawPicture);
begin
  Self.FFocusedPicture.Assign(Value);
end;

procedure TSkinMemoDefaultMaterial.SetNormalPicture(const Value: TDrawPicture);
begin
  Self.FNormalPicture.Assign(Value);
end;


//{ TSkinMemoHelpIconType }
//
//function TSkinMemoHelpIconType.GetCustomWMNCCalcSizeLeftWidth: Integer;
//begin
//  Result:=Self.FSkinMemoIntf.Prop.FHelpIcon.Width;
//end;
//
//function TSkinMemoHelpIconType.GetSkinMaterial: TSkinMemoHelpIconMaterial;
//begin
//  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
//  begin
//    Result:=TSkinMemoHelpIconMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
//  end
//  else
//  begin
//    Result:=nil;
//  end;
//end;
//
//function TSkinMemoHelpIconType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;AIsDrawInteractiveState:Boolean): Boolean;
////var
////  ADrawIconRect:TRectF;
//begin
//  Inherited CustomPaint(ACanvas,ADrawRect,AIsDrawInteractiveState);
////  if Self.GetSkinMaterial<>nil then
////  begin
////    //绘制图标
////    ADrawIconRect:=ADrawRect;
////    ADrawIconRect.Left:=Self.GetSkinMaterial.BorderMargins.Left;
////    ADrawIconRect.Top:=Self.GetSkinMaterial.BorderMargins.Top;
////    ADrawIconRect.Right:=ADrawIconRect.Left+Self.FHelpIcon.Width;
////    ADrawIconRect.Bottom:=ADrawRect.Bottom-Self.GetSkinMaterial.BorderMargins.Bottom;
////    ACanvas.DrawPicture(Self.GetSkinMaterial.DrawHelpIconParam,Self.FHelpIcon,ADrawIconRect);
////  end;
//end;
//
//
//{ TSkinMemoHelpIconMaterial }
//
//constructor TSkinMemoHelpIconMaterial.Create(AOwner: TComponent);
//begin
//  inherited Create(AOwner);
//  FDrawHelpIconParam:=CreateDrawPictureParam('DrawHelpIconParam','图标绘制参数');
//end;
//
//function TSkinMemoHelpIconMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
////    if ABTNode.NodeName='DrawHelpIconParam' then
////    begin
////      FDrawHelpIconParam.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    ;
////  end;
//
//  Result:=True;
//end;
//
//function TSkinMemoHelpIconMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//  Inherited SaveToDocNode(ADocNode);
//
////  ABTNode:=ADocNode.AddChildNode_Class('DrawHelpIconParam',FDrawHelpIconParam.Name);
////  Self.FDrawHelpIconParam.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//  Result:=True;
//end;
//
//destructor TSkinMemoHelpIconMaterial.Destroy;
//begin
//  FreeAndNil(FDrawHelpIconParam);
//  inherited;
//end;
//
//procedure TSkinMemoHelpIconMaterial.SetDrawHelpIconParam(const Value: TDrawPictureParam);
//begin
//  FDrawHelpIconParam.Assign(Value);
//end;

{ TMemoProperties }


function TMemoProperties.GetComponentClassify: String;
begin
  Result:='SkinMemo';
end;

procedure TMemoProperties.GetPropJson(ASuperObject: ISuperObject);
begin
  inherited;

end;

procedure TMemoProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
  Self.FHelpText:=TMemoProperties(Src).FHelpText;
  Self.FIsDrawHelpWhenFocused:=TMemoProperties(Src).FIsDrawHelpWhenFocused;
  Self.FHelpIcon.Assign(TMemoProperties(Src).FHelpIcon);
//  Self.FBorderMargins.Assign(TMemoProperties(Src).FBorderMargins);
  Self.FIsAlwaysDrawHelp:=TMemoProperties(Src).FIsAlwaysDrawHelp;
end;
constructor TMemoProperties.Create(ASkinControl:TControl);
begin
//  FBorderMargins:=TBorderMargins.Create;
//  FBorderMargins.Top:=2;
//  FBorderMargins.Bottom:=2;
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinMemo,Self.FSkinMemoIntf) then
  begin
    ShowException('This Component Do not Support ISkinMemo Interface');
  end
  else
  begin
//    FBorderMargins.OnChange:=Self.OnBorderMarginsChangeNotify;
    FHelpIcon:=CreateDrawPicture('HelpIcon','提示图标');
    Self.FSkinControlIntf.Width:=100;
    Self.FSkinControlIntf.Height:=100;
    Self.FIsDrawHelpWhenFocused:=True;//False;

    FAutoHeightMaxLineCount:=3;
  end;
end;

destructor TMemoProperties.Destroy;
begin
//  FBorderMargins.OnChange:=nil;
//  FreeAndNil(FBorderMargins);
  FreeAndNil(FHelpIcon);
  inherited;
end;

procedure TMemoProperties.SetHelpText(const Value: String);
begin
  if FHelpText<>Value then
  begin
    FHelpText:=Value;
    Invalidate;
  end;
end;

procedure TMemoProperties.SetIsAutoHeight(const Value: Boolean);
begin
  if FIsAutoHeight<>Value then
  begin
    FIsAutoHeight:=Value;

    Self.FSkinMemoIntf.SetIsAutoHeight(Value);

    Invalidate;
  end;
end;

procedure TMemoProperties.SetIsDrawCharCount(const Value: Boolean);
begin
  if FIsDrawCharCount<>Value then
  begin
    FIsDrawCharCount:=Value;
    Invalidate;
  end;
end;

procedure TMemoProperties.SetIsDrawHelpWhenFocused(const Value: Boolean);
begin
  if FIsDrawHelpWhenFocused<>Value then
  begin
    FIsDrawHelpWhenFocused:=Value;
    Invalidate;
  end;
end;

procedure TMemoProperties.SetPropJson(ASuperObject: ISuperObject);
begin
  inherited;
  if ASuperObject.Contains('input_prompt') then
  begin
    Self.HelpText:=ASuperObject.S['input_prompt'];
  end;

end;

procedure TMemoProperties.SetAutoHeightMaxLineCount(const Value: Integer);
begin
  if FAutoHeightMaxLineCount<>Value then
  begin
    FAutoHeightMaxLineCount:=Value;

    Self.FSkinMemoIntf.DoAutoHeightMemoChange(Self);

    Invalidate;
  end;
end;

procedure TMemoProperties.SetHelpIcon(const Value: TDrawPicture);
begin
  FHelpIcon.Assign(Value);
end;



end.

