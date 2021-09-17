//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     时间编辑框
///   </para>
///   <para>
///     TimeEdit Box
///   </para>
/// </summary>
unit uSkinTimeEditType;

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
  IID_ISkinTimeEdit:TGUID='{4AB0345D-005B-4313-9098-3A9CE66BA567}';



type
  TTimeEditProperties=class;




  /// <summary>
  ///   <para>
  ///     时间编辑框接口
  ///   </para>
  ///   <para>
  ///     Interface of TimeEdit Box
  ///   </para>
  /// </summary>
  ISkinTimeEdit=interface//(ISkinControl)
    ['{4AB0345D-005B-4313-9098-3A9CE66BA567}']
    function GetText:String;
    property Text:String read GetText;

    function GetTimeEditProperties:TTimeEditProperties;
    property Properties:TTimeEditProperties read GetTimeEditProperties;
    property Prop:TTimeEditProperties read GetTimeEditProperties;
  end;






  /// <summary>
  ///   <para>
  ///     时间编辑框属性
  ///   </para>
  ///   <para>
  ///     TimeEdit Box properties
  ///   </para>
  /// </summary>
  TTimeEditProperties=class(TSkinControlProperties)
  protected
    FDrawText:String;

    //时间编辑框接口
    FSkinTimeEditIntf:ISkinTimeEdit;

  protected
    procedure AssignProperties(Src:TSkinControlProperties);override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    property DrawText:String read FDrawText write FDrawText;
    //获取分类名称
    function GetComponentClassify:String;override;
  end;










  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     时间编辑框默认素材
  ///   </para>
  ///   <para>
  ///     Default material of TimeEdit Box
  ///   </para>
  /// </summary>
  TSkinTimeEditDefaultMaterial=class(TSkinControlMaterial)
  private
    //在ListBox中文本的绘制参数
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
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //正常状态图片
    property NormalPicture:TDrawPicture read FNormalPicture write SetNormalPicture;
    //鼠标停靠状态图片
    property HoverPicture:TDrawPicture read FHoverPicture write SetHoverPicture;
    //获取焦点状态下的图片
    property FocusedPicture:TDrawPicture read FFocusedPicture write SetFocusedPicture;
    //禁用状态图片
    property DisabledPicture:TDrawPicture read FDisabledPicture write SetDisabledPicture;



    //图片绘制参数
    property DrawPictureParam:TDrawPictureParam read FDrawPictureParam write SetDrawPictureParam;
    //在ListBox中文本的绘制参数
    property DrawTextParam:TDrawTextParam read FDrawTextParam write SetDrawTextParam;
  end;



  TSkinTimeEditDefaultType=class(TSkinControlType)
  protected
    //时间编辑框接口
    FSkinTimeEditIntf:ISkinTimeEdit;
    function GetSkinMaterial:TSkinTimeEditDefaultMaterial;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    //绘制边框
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;





implementation





{ TSkinTimeEditDefaultType }


function TSkinTimeEditDefaultType.GetSkinMaterial: TSkinTimeEditDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinTimeEditDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinTimeEditDefaultType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
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
                      Self.FSkinTimeEditIntf.Prop.DrawText,
                      ADrawRect);
    end;

  end;
end;

function TSkinTimeEditDefaultType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinTimeEdit,Self.FSkinTimeEditIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinTimeEdit Interface');
    end;
  end;
end;

procedure TSkinTimeEditDefaultType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinTimeEditIntf:=nil;
end;



{ TSkinTimeEditDefaultMaterial }



procedure TSkinTimeEditDefaultMaterial.SetDrawTextParam(const Value: TDrawTextParam);
begin
  FDrawTextParam.Assign(Value);
end;

constructor TSkinTimeEditDefaultMaterial.Create;
begin
  inherited Create(AOwner);


  FDrawTextParam:=CreateDrawTextParam('DrawTextParam','在ListBox中文本的绘制参数');

  FNormalPicture:=CreateDrawPicture('NormalPicture','正常状态图片');
  FHoverPicture:=CreateDrawPicture('HoverPicture','鼠标停靠状态图片');
  FFocusedPicture:=CreateDrawPicture('FocusedPicture','获取焦点状态图片');
  FDisabledPicture:=CreateDrawPicture('DisabledPicture','禁用状态图片');



  FDrawPictureParam:=CreateDrawPictureParam('DrawPictureParam','图片绘制参数');
end;


destructor TSkinTimeEditDefaultMaterial.Destroy;
begin
  FreeAndNil(FDrawTextParam);

  FreeAndNil(FDrawPictureParam);

  FreeAndNil(FNormalPicture);
  FreeAndNil(FHoverPicture);
  FreeAndNil(FFocusedPicture);
  FreeAndNil(FDisabledPicture);
  inherited;
end;

procedure TSkinTimeEditDefaultMaterial.SetDisabledPicture(const Value: TDrawPicture);
begin
  FDisabledPicture.Assign(Value);
end;

procedure TSkinTimeEditDefaultMaterial.SetDrawPictureParam(const Value: TDrawPictureParam);
begin
  FDrawPictureParam.Assign(Value);
end;

procedure TSkinTimeEditDefaultMaterial.SetHoverPicture(const Value: TDrawPicture);
begin
  Self.FHoverPicture.Assign(Value);
end;

procedure TSkinTimeEditDefaultMaterial.SetFocusedPicture(const Value: TDrawPicture);
begin
  Self.FFocusedPicture.Assign(Value);
end;

procedure TSkinTimeEditDefaultMaterial.SetNormalPicture(const Value: TDrawPicture);
begin
  Self.FNormalPicture.Assign(Value);
end;


{ TTimeEditProperties }


function TTimeEditProperties.GetComponentClassify: String;
begin
  Result:='SkinTimeEdit';
end;

procedure TTimeEditProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;

constructor TTimeEditProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinTimeEdit,Self.FSkinTimeEditIntf) then
  begin
    ShowException('This Component Do not Support ISkinTimeEdit Interface');
  end
  else
  begin
    Self.FSkinControlIntf.Width:=100;
    Self.FSkinControlIntf.Height:=22;
  end;
end;

destructor TTimeEditProperties.Destroy;
begin
  inherited;
end;





end.

