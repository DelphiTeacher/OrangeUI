//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     日期编辑框
///   </para>
///   <para>
///     DateEdit Box
///   </para>
/// </summary>
unit uSkinDateEditType;

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
  IID_ISkinDateEdit:TGUID='{0591FFC8-D257-4B2D-B875-6CE4EE4D05B7}';



type
  TDateEditProperties=class;

  ISkinDateEdit=interface//(ISkinControl)
    ['{0591FFC8-D257-4B2D-B875-6CE4EE4D05B7}']
    function GetText:String;
    property Text:String read GetText;

    function GetDateEditProperties:TDateEditProperties;
    property Properties:TDateEditProperties read GetDateEditProperties;
    property Prop:TDateEditProperties read GetDateEditProperties;
  end;


  //DateEdit属性
  TDateEditProperties=class(TSkinControlProperties)
  protected
    FDrawText:String;


    //日期编辑框接口
    FSkinDateEditIntf:ISkinDateEdit;

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
  end;









  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     日期编辑框默认素材
  ///   </para>
  ///   <para>
  ///    DateEdit Box default material
  ///   </para>
  /// </summary>
  TSkinDateEditDefaultMaterial=class(TSkinControlMaterial)
  private
    //文本绘制参数
    FDrawTextParam:TDrawTextParam;

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
    ///     正常状态图片
    ///   </para>
    ///   <para>
    ///     Normal state picture
    ///   </para>
    /// </summary>
    property NormalPicture:TDrawPicture read FNormalPicture write SetNormalPicture;

    /// <summary>
    ///   <para>
    ///     鼠标停靠状态图片
    ///   </para>
    ///   <para>
    ///     Picture at hovering state picture
    ///   </para>
    /// </summary>
    property HoverPicture:TDrawPicture read FHoverPicture write SetHoverPicture;

    /// <summary>
    ///   <para>
    ///     获取焦点状态下的图片
    ///   </para>
    ///   <para>
    ///     Picture at focused state
    ///   </para>
    /// </summary>
    property FocusedPicture:TDrawPicture read FFocusedPicture write SetFocusedPicture;

    /// <summary>
    ///   <para>
    ///     禁用状态图片
    ///   </para>
    ///   <para>
    ///     Picture at disabled state
    ///   </para>
    /// </summary>
    property DisabledPicture:TDrawPicture read FDisabledPicture write SetDisabledPicture;

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
    ///     文本绘制参数
    ///   </para>
    ///   <para>
    ///     Draw text parameters
    ///   </para>
    /// </summary>
    property DrawTextParam:TDrawTextParam read FDrawTextParam write SetDrawTextParam;
  end;

  TSkinDateEditDefaultType=class(TSkinControlType)
  protected
    //日期编辑框接口
    FSkinDateEditIntf:ISkinDateEdit;
    function GetSkinMaterial:TSkinDateEditDefaultMaterial;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    //绘制边框
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;







implementation





{ TSkinDateEditDefaultType }


function TSkinDateEditDefaultType.GetSkinMaterial: TSkinDateEditDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinDateEditDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinDateEditDefaultType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
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
    else if Self.FSkinControlIntf.Focused then
    begin
      ADrawPicture:=Self.GetSkinMaterial.FFocusedPicture;
    end
    else if Self.FSkinControlIntf.IsMouseOver then
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



    //在ListBox中绘制文本
    if APaintData.IsInDrawDirectUI then
    begin
      ACanvas.DrawText(Self.GetSkinMaterial.FDrawTextParam,
                      Self.FSkinDateEditIntf.Prop.DrawText,
                      ADrawRect);
    end;



  end;
end;

function TSkinDateEditDefaultType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinDateEdit,Self.FSkinDateEditIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinDateEdit Interface');
    end;
  end;
end;

procedure TSkinDateEditDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinDateEditIntf:=nil;
end;


{ TSkinDateEditDefaultMaterial }


procedure TSkinDateEditDefaultMaterial.SetDrawTextParam(const Value: TDrawTextParam);
begin
  FDrawTextParam.Assign(Value);
end;

constructor TSkinDateEditDefaultMaterial.Create;
begin
  inherited Create(AOwner);


  FDrawTextParam:=CreateDrawTextParam('DrawTextParam','在ListBox中文本的绘制参数');//  FDrawTextParam.FontVertAlign:=fvaCenter;

  FNormalPicture:=CreateDrawPicture('NormalPicture','正常状态图片');
  FHoverPicture:=CreateDrawPicture('HoverPicture','鼠标停靠状态图片');
  FFocusedPicture:=CreateDrawPicture('FocusedPicture','获取焦点状态图片');
  FDisabledPicture:=CreateDrawPicture('DisabledPicture','禁用状态图片');

  FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','图片绘制参数');
end;

destructor TSkinDateEditDefaultMaterial.Destroy;
begin
  FreeAndNil(FDrawTextParam);
  FreeAndNil(FDrawPictureParam);
  FreeAndNil(FNormalPicture);
  FreeAndNil(FHoverPicture);
  FreeAndNil(FFocusedPicture);
  FreeAndNil(FDisabledPicture);
  inherited;
end;

procedure TSkinDateEditDefaultMaterial.SetDisabledPicture(const Value: TDrawPicture);
begin
  FDisabledPicture.Assign(Value);
end;

procedure TSkinDateEditDefaultMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;

procedure TSkinDateEditDefaultMaterial.SetHoverPicture(const Value: TDrawPicture);
begin
  Self.FHoverPicture.Assign(Value);
end;

procedure TSkinDateEditDefaultMaterial.SetFocusedPicture(const Value: TDrawPicture);
begin
  Self.FFocusedPicture.Assign(Value);
end;

procedure TSkinDateEditDefaultMaterial.SetNormalPicture(const Value: TDrawPicture);
begin
  Self.FNormalPicture.Assign(Value);
end;


{ TDateEditProperties }


function TDateEditProperties.GetComponentClassify: String;
begin
  Result:='SkinDateEdit';
end;

procedure TDateEditProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;

constructor TDateEditProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinDateEdit,Self.FSkinDateEditIntf) then
  begin
    ShowException('This Component Do not Support ISkinDateEdit Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=100;
    Self.FSkinControlIntf.Height:=22;
  end;
end;


destructor TDateEditProperties.Destroy;
begin
  inherited;
end;



end.


