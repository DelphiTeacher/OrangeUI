//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     拖动条
///   </para>
///   <para>
///     TrackBar
///   </para>
/// </summary>
unit uSkinTrackBarType;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  {$IFDEF VCL}
  Windows,
  Messages,
  Controls,
  {$ENDIF}
  {$IFDEF FMX}
  FMX.Types,
  UITypes,
  FMX.Controls,
  {$ENDIF}
  Math,
  Types,
  uBaseLog,
  uFuncCommon,
  uBaseSkinControl,
  uGraphicCommon,
  uDrawCanvas,
  uDrawEngine,
  uSkinMaterial,
  uBinaryTreeDoc,
  uDrawPicture,
  uSkinBufferBitmap,
  uComponentType,
  uDrawTextParam,
  uDrawPictureParam;


const
  IID_ISkinTrackBar:TGUID='{50CE5B8C-9C79-453A-984E-C8AF7516A204}';



type

  /// <summary>
  ///   <para>
  ///     拖动条类型
  ///   </para>
  ///   <para>
  ///     TrackBar Type
  ///   </para>
  /// </summary>
  TTrackBarOrientation=(
                        trHorizontal,
                        trVertical
                        );
  TTrackBarProperties=class;





  //拖动条的按钮状态
  TSkinTrackBarBtnState=class
  public
    MouseDown:Boolean;
    MouseHover:Boolean;
    MouseDownPt:TPointF;
    MouseDownOffset:Double;
  end;





  /// <summary>
  ///   <para>
  ///     拖动条接口
  ///   </para>
  ///   <para>
  ///     Interface of TrackBar
  ///   </para>
  /// </summary>
  ISkinTrackBar=interface//(ISkinControl)
  ['{50CE5B8C-9C79-453A-984E-C8AF7516A204}']
    function GetOnChange: TNotifyEvent;
    property OnChange: TNotifyEvent read GetOnChange;// write SetOnChange;

    function GetTrackBarProperties:TTrackBarProperties;
    property Properties:TTrackBarProperties read GetTrackBarProperties;
    property Prop:TTrackBarProperties read GetTrackBarProperties;
  end;




  /// <summary>
  ///   <para>
  ///     拖动条属性
  ///   </para>
  ///   <para>
  ///     TrackBar properties
  ///   </para>
  /// </summary>
  TTrackBarProperties=class(TSkinControlProperties)
  protected
    FMin: Double;
    FMax: Double;
    FPosition: Double;

    FOrientation:TTrackBarOrientation;

    FTrackBtnState:TSkinTrackBarBtnState;

    FSkinTrackBarIntf:ISkinTrackBar;

    procedure DoChange;


    procedure SetMax(const Value: Double);
    procedure SetMin(const Value: Double);
    procedure SetPosition(const Value: Double);

    function GetTrackBtnState: TSkinTrackBarBtnState;

    procedure SetOrientation(const Value: TTrackBarOrientation);

    procedure SetParams(APosition, AMin, AMax: Double);
    //赋值
    procedure AssignProperties(Src:TSkinControlProperties);override;
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    property TrackBtnState:TSkinTrackBarBtnState read GetTrackBtnState;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  published

    /// <summary>
    ///   <para>
    ///     最小值
    ///   </para>
    ///   <para>
    ///     Min  value
    ///   </para>
    /// </summary>
    property Min: Double read FMin write SetMin;
    /// <summary>
    ///   <para>
    ///     最大值
    ///   </para>
    ///   <para>
    ///     Max value
    ///   </para>
    /// </summary>
    property Max: Double read FMax write SetMax;

    /// <summary>
    ///   <para>
    ///     当前值
    ///   </para>
    ///   <para>
    ///     Current value
    ///   </para>
    /// </summary>
    property Position: Double read FPosition write SetPosition;

    /// <summary>
    ///   <para>
    ///     布局方向
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property Orientation: TTrackBarOrientation read FOrientation write SetOrientation;
  end;






  /// <summary>
  ///   <para>
  ///     拖动条素材基类
  ///   </para>
  ///   <para>
  ///     Base class of TrackBar material
  ///   </para>
  /// </summary>
  TSkinTrackBarMaterial=class(TSkinControlMaterial)
  end;
  //拖动条控件类型基类
  TSkinTrackBarType=class(TSkinControlType)
  protected
    FMouseMovePt:TPointF;
    FSkinTrackBarIntf:ISkinTrackBar;

    procedure DoMouseMove;
  protected
    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseMove(Shift: TShiftState;X,Y:Double);override;
    procedure CustomMouseEnter;override;
    procedure CustomMouseLeave;override;
    procedure SizeChanged;override;

    //拖动条客户区尺寸
    function GetTrackBarClientSize:Double;

    //移动滑块位置
    function GetTrackBtnDrawPos:Double;
    //比例
    function GetTrackDrawStep:Double;
    //移动滑块按钮尺寸
    function GetTrackBtnDrawSize:Integer;virtual;
    //移动滑块显示矩形
    function GetTrackBtnDrawRect:TRectF;virtual;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  end;







  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinTrackBarDefaultMaterial=class(TSkinTrackBarMaterial)
  private
    FHorzTrackBtnHoverPicture: TDrawPicture;
    FHorzTrackBtnNormalPicture: TDrawPicture;
    FHorzTrackBtnDisabledPicture: TDrawPicture;
    FHorzTrackBtnDownPicture: TDrawPicture;

    FVertTrackBtnHoverPicture: TDrawPicture;
    FVertTrackBtnNormalPicture: TDrawPicture;
    FVertTrackBtnDisabledPicture: TDrawPicture;
    FVertTrackBtnDownPicture: TDrawPicture;

    FHorzBackGndPicture: TDrawPicture;
    FVertBackGndPicture: TDrawPicture;
    FHorzForeGndPicture: TDrawPicture;
    FVertForeGndPicture: TDrawPicture;

    FBackGndDrawPictureParam:TDrawPictureParam;
    FForeGndDrawPictureParam:TDrawPictureParam;
    FTrackBtnDrawPictureParam:TDrawPictureParam;

    FTrackBtnDrawSize: Integer;

    procedure SetTrackBtnDrawSize(const Value: Integer);

    procedure SetHorzBackGndPicture(const Value: TDrawPicture);
    procedure SetVertBackGndPicture(const Value: TDrawPicture);
    procedure SetHorzForeGndPicture(const Value: TDrawPicture);
    procedure SetVertForeGndPicture(const Value: TDrawPicture);

    procedure SetHorzTrackBtnDisabledPicture(const Value: TDrawPicture);
    procedure SetHorzTrackBtnDownPicture(const Value: TDrawPicture);
    procedure SetHorzTrackBtnHoverPicture(const Value: TDrawPicture);
    procedure SetHorzTrackBtnNormalPicture(const Value: TDrawPicture);

    procedure SetVertTrackBtnDisabledPicture(const Value: TDrawPicture);
    procedure SetVertTrackBtnDownPicture(const Value: TDrawPicture);
    procedure SetVertTrackBtnHoverPicture(const Value: TDrawPicture);
    procedure SetVertTrackBtnNormalPicture(const Value: TDrawPicture);

    procedure SetBackGndDrawPictureParam(const Value: TDrawPictureParam);
    procedure SetForeGndDrawPictureParam(const Value: TDrawPictureParam);
    procedure SetTrackBtnDrawPictureParam(const Value: TDrawPictureParam);
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //绘制大小
    property TrackBtnDrawSize:Integer read FTrackBtnDrawSize write SetTrackBtnDrawSize;// default 0;



    //水平样式移动滑块正常状态图片
    property HorzTrackBtnNormalPicture:TDrawPicture read FHorzTrackBtnNormalPicture write SetHorzTrackBtnNormalPicture;
    //水平样式移动滑块鼠标停靠状态图片
    property HorzTrackBtnHoverPicture:TDrawPicture read FHorzTrackBtnHoverPicture write SetHorzTrackBtnHoverPicture;
    //水平样式移动滑块禁用状态图片
    property HorzTrackBtnDisabledPicture: TDrawPicture read FHorzTrackBtnDisabledPicture write SetHorzTrackBtnDisabledPicture;
    //水平样式移动滑块鼠标按下状态图片
    property HorzTrackBtnDownPicture: TDrawPicture read FHorzTrackBtnDownPicture write SetHorzTrackBtnDownPicture;



    //垂直样式移动滑块正常状态图片
    property VertTrackBtnNormalPicture:TDrawPicture read FVertTrackBtnNormalPicture write SetVertTrackBtnNormalPicture;
    //垂直样式移动滑块鼠标停靠状态图片
    property VertTrackBtnHoverPicture:TDrawPicture read FVertTrackBtnHoverPicture write SetVertTrackBtnHoverPicture;
    //垂直样式移动滑块禁用状态图片
    property VertTrackBtnDisabledPicture: TDrawPicture read FVertTrackBtnDisabledPicture write SetVertTrackBtnDisabledPicture;
    //垂直样式移动滑块鼠标按下状态图片
    property VertTrackBtnDownPicture: TDrawPicture read FVertTrackBtnDownPicture write SetVertTrackBtnDownPicture;


    //水平样式背景图片
    property VertBackGndPicture:TDrawPicture read FVertBackGndPicture write SetVertBackGndPicture;
    //垂直样式背景图片
    property HorzBackGndPicture:TDrawPicture read FHorzBackGndPicture write SetHorzBackGndPicture;



    //水平样式前景图片
    property VertForeGndPicture:TDrawPicture read FVertForeGndPicture write SetVertForeGndPicture;
    //垂直样式前景图片
    property HorzForeGndPicture:TDrawPicture read FHorzForeGndPicture write SetHorzForeGndPicture;



    //背景绘制参数
    property BackGndDrawPictureParam:TDrawPictureParam read FBackGndDrawPictureParam write SetBackGndDrawPictureParam;
    //前景绘制参数
    property ForeGndDrawPictureParam:TDrawPictureParam read FForeGndDrawPictureParam write SetForeGndDrawPictureParam;
    //拖动滑块绘制参数
    property TrackBtnDrawPictureParam:TDrawPictureParam read FTrackBtnDrawPictureParam write SetTrackBtnDrawPictureParam;
  end;


  //拖动条默认类型
  TSkinTrackBarDefaultType=class(TSkinTrackBarType)
  private
    function GetSkinMaterial: TSkinTrackBarDefaultMaterial;
  protected
    //获取进度条的绘制矩形
    function GetUpSpaceDrawRect:TRectF;
    //获取
    function GetTrackBtnDrawSize:Integer;override;
    //获取移动滑块矩形
    function GetTrackBtnDrawRect:TRectF;override;
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;













  //进度条方式拖动条
  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinTrackBarProgressBarMaterial=class(TSkinTrackBarDefaultMaterial)
  private
    FHorzProgressNormalPicture: TDrawPicture;
    FVertProgressNormalPicture: TDrawPicture;
//    FHorzProgressDisabledPicture: TDrawPicture;
//    FVertProgressDisabledPicture: TDrawPicture;
    FProgressDrawPictureParam:TDrawPictureParam;
    procedure SetHorzProgressNormalPicture(const Value: TDrawPicture);
    procedure SetVertProgressNormalPicture(const Value: TDrawPicture);
//    procedure SetHorzProgressDisabledPicture(const Value: TDrawPicture);
//    procedure SetVertProgressDisabledPicture(const Value: TDrawPicture);
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    //垂直样式进度正常状态图片
    property VertProgressNormalPicture:TDrawPicture read FVertProgressNormalPicture write SetVertProgressNormalPicture;
//    property VertProgressDisabledPicture:TDrawPicture read FVertProgressDisabledPicture write SetVertProgressDisabledPicture;
    //水平样式进度禁用状态图片
    property HorzProgressNormalPicture:TDrawPicture read FHorzProgressNormalPicture write SetHorzProgressNormalPicture;
//    property HorzProgressDisabledPicture:TDrawPicture read FHorzProgressDisabledPicture write SetHorzProgressDisabledPicture;
  end;

  TSkinTrackBarProgressBarType=class(TSkinTrackBarDefaultType)
  private
    function GetSkinMaterial: TSkinTrackBarProgressBarMaterial;
  protected
    function GetTrackBtnDrawSize:Integer;override;
    function GetUpSpaceDrawRect:TRectF;
    function GetProgressDrawRect:TRectF;
//    procedure CustomMouseEnter;override;
//    procedure CustomMouseLeave;override;
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinTrackBar=class(TBaseSkinControl,ISkinTrackBar)
  private
    function GetTrackBarProperties:TTrackBarProperties;
    procedure SetTrackBarProperties(Value:TTrackBarProperties);
  protected

    FOnChange: TNotifyEvent;

    function GetOnChange: TNotifyEvent;
//    procedure SetOnChange(const Value: TNotifyEvent);
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
  public
    function SelfOwnMaterialToDefault:TSkinTrackBarDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinTrackBarDefaultMaterial;
    function Material:TSkinTrackBarDefaultMaterial;
  public
    property Prop:TTrackBarProperties read GetTrackBarProperties write SetTrackBarProperties;
  published
    //属性
    property Properties:TTrackBarProperties read GetTrackBarProperties write SetTrackBarProperties;
    property OnChange: TNotifyEvent read GetOnChange write FOnChange;
  end;


  {$IFDEF VCL}
  TSkinWinTrackBar=class(TSkinTrackBar)
  end;
  {$ENDIF VCL}


implementation






{ TSkinTrackBarType }

function TSkinTrackBarType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinTrackBar,Self.FSkinTrackBarIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinTrackBar Interface');
    end;
  end;
end;

procedure TSkinTrackBarType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinTrackBarIntf:=nil;
end;

procedure TSkinTrackBarType.DoMouseMove;
var
  Offset: Double;
  TrackBtnPosOffset:Double;
begin

//  if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDown then
//  begin

    case Self.FSkinTrackBarIntf.Prop.Orientation of
      trHorizontal:
      begin
        Offset := FMouseMovePt.X - Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDownPt.X;
      end;
      trVertical:
      begin
        Offset := FMouseMovePt.Y - Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDownPt.Y;
      end;
    end;

    if Offset <> 0 then
    begin

      case Self.FSkinTrackBarIntf.Prop.Orientation of
        trHorizontal:
        begin
          TrackBtnPosOffset := FMouseMovePt.X
                                -Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDownOffset
                                -Self.GetTrackBtnDrawSize div 2;
        end;
        trVertical:
        begin
          TrackBtnPosOffset := FMouseMovePt.Y
                                -Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDownOffset
                                -Self.GetTrackBtnDrawSize div 2;
        end;
      end;

      if (GetTrackBarClientSize
            - GetTrackBtnDrawSize)>0 then
      begin

        Self.FSkinTrackBarIntf.Prop.Position:=Self.FSkinTrackBarIntf.Prop.FMin
              +
            TrackBtnPosOffset
            *(Self.FSkinTrackBarIntf.Prop.Max-Self.FSkinTrackBarIntf.Prop.Min)
            /(GetTrackBarClientSize
              - GetTrackBtnDrawSize);
      end
      else
      begin
        Self.FSkinTrackBarIntf.Prop.Position:=Self.FSkinTrackBarIntf.Prop.Min;
      end;

      Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDownPt := FMouseMovePt;
    end;
//  end;

end;

function TSkinTrackBarType.GetTrackBarClientSize: Double;
begin
  case Self.FSkinTrackBarIntf.Prop.Orientation of
    trHorizontal:
    begin
      Result:=Self.FSkinControlIntf.Width;
    end;
    trVertical:
    begin
      Result:=Self.FSkinControlIntf.Height;
    end;
  end;
end;

function TSkinTrackBarType.GetTrackBtnDrawPos: Double;
begin
  Result:=Self.FSkinTrackBarIntf.Prop.Position*Self.GetTrackDrawStep;
end;

function TSkinTrackBarType.GetTrackBtnDrawRect: TRectF;
begin
  uBaseLog.ShowException('Have Not Implement TSkinTrackBarType.GetTrackBtnDrawRect');
end;

function TSkinTrackBarType.GetTrackBtnDrawSize: Integer;
begin
  uBaseLog.ShowException('Have Not Implement TBinaryObjectList.GetTrackBtnDrawSize');
end;

function TSkinTrackBarType.GetTrackDrawStep: Double;
begin
  Result := (GetTrackBarClientSize)
      /(Self.FSkinTrackBarIntf.Prop.Max-Self.FSkinTrackBarIntf.Prop.Min);
end;

procedure TSkinTrackBarType.CustomMouseDown(Button: TMouseButton;Shift: TShiftState;X, Y: Double);
var
  PtInBarRect:Boolean;
//  ATrackPos:Integer;

  NeedInvalidate:Boolean;

  PtInTrackBtnRect:Boolean;
begin
  inherited;

//  if Not (csDesigning in Self.FSkinControl.ComponentState) then
//  begin
//  if Button={$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft  then
//  begin
    NeedInvalidate:=False;

    PtInBarRect:=False;
    PtInTrackBtnRect:=False;
    FMouseMovePt:=PointF(X,Y);


    if PtInRect(RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height),FMouseMovePt) then
    begin
      PtInBarRect:=True;
      PtInTrackBtnRect:=PtInRect(Self.GetTrackBtnDrawRect,FMouseMovePt);
    end;

    if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDown<>PtInTrackBtnRect then
    begin
      NeedInvalidate:=True;
    end;
    Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDown:=PtInTrackBtnRect;
    if PtInTrackBtnRect then
    begin
      Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDownPt:=FMouseMovePt;
    end;


    if PtInBarRect and Not PtInTrackBtnRect then
    begin
//      //如果在拖动条区域内但不在拖动按钮上,那么按钮就移动到那里。
      DoMouseMove;

      NeedInvalidate:=True;
    end;

    if NeedInvalidate then
    begin
      Self.Invalidate;
    end;
//  end;
//  end;
end;

procedure TSkinTrackBarType.CustomMouseEnter;
begin
  inherited;
end;

procedure TSkinTrackBarType.CustomMouseLeave;
var
  NeedInvalidate:Boolean;
begin
  inherited;
//  if Not (csDesigning in Self.FSkinControl.ComponentState) then
//  begin
    NeedInvalidate:=False;

    if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseHover then
    begin
      Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseHover:=False;
      NeedInvalidate:=True;
    end;

    if NeedInvalidate then
    begin
      Self.Invalidate;
    end;
//  end;
end;

procedure TSkinTrackBarType.CustomMouseMove(Shift: TShiftState;X, Y: Double);
var
//  ATrackPos:Integer;
//  MouseOffset:Integer;
  NeedInvalidate:Boolean;
  PtInTrackBtnRect:Boolean;
begin
  inherited;
//  if Not (csDesigning in Self.FSkinControl.ComponentState) then
//  begin
    NeedInvalidate:=False;

    PtInTrackBtnRect:=False;
    FMouseMovePt:=PointF(X,Y);

    if PtInRect(RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height),FMouseMovePt) then
    begin
      PtInTrackBtnRect:=PtInRect(Self.GetTrackBtnDrawRect,FMouseMovePt);
    end;

    if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseHover<>PtInTrackBtnRect then
    begin
      Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseHover:=PtInTrackBtnRect;
      NeedInvalidate:=True;
    end;



    if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDown then
    begin

        DoMouseMove;

    end;

    if NeedInvalidate then
    begin
      Self.Invalidate;
    end;
//  end;

end;

procedure TSkinTrackBarType.CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
var
  NeedInvalidate:Boolean;
begin
  inherited;
//  if Not (csDesigning in Self.FSkinControl.ComponentState) then
//  begin
//  if Button={$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft  then
//  begin
    NeedInvalidate:=False;

    FMouseMovePt:=PointF(X,Y);

    if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDown then
    begin
      Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDown:=False;
      NeedInvalidate:=True;
    end;

    if NeedInvalidate then
    begin
      Self.Invalidate;
    end;
//  end;
//  end;

end;

procedure TSkinTrackBarType.SizeChanged;
begin
  inherited;
  Invalidate;
end;

{ TSkinTrackBarDefaultType }

function TSkinTrackBarDefaultType.GetTrackBtnDrawSize: Integer;
begin
  case GetSkinMaterial.FTrackBtnDrawSize of
    0:
    begin
      if Self.FSkinTrackBarIntf.Prop.Orientation=trVertical then
      begin
        Result:=Self.GetSkinMaterial.FVertTrackBtnNormalPicture.CurrentPictureDrawHeight;
      end
      else
      begin
        Result:=Self.GetSkinMaterial.FHorzTrackBtnNormalPicture.CurrentPictureDrawWidth;
      end;
    end;
    else
    begin
      Result:=GetSkinMaterial.FTrackBtnDrawSize;
    end;
  end;
end;

function TSkinTrackBarDefaultType.GetSkinMaterial: TSkinTrackBarDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinTrackBarDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinTrackBarDefaultType.GetTrackBtnDrawRect: TRectF;
begin
  //确定移动滑块绘制矩形
  if Self.FSkinTrackBarIntf.Prop.Orientation=trVertical then
  begin
    Result:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);
    if Self.GetTrackBtnDrawPos>=Self.FSkinControlIntf.Height-Self.GetTrackBtnDrawSize div 2 then
    begin
      //过长
      Result.Top:=GetTrackBtnDrawPos-GetTrackBtnDrawSize div 2;
      if Result.Top>Self.FSkinControlIntf.Height-GetTrackBtnDrawSize then
      begin
        Result.Top:=Self.FSkinControlIntf.Height-GetTrackBtnDrawSize;
      end;
    end
    else if Self.GetTrackBtnDrawPos>=Self.GetTrackBtnDrawSize div 2 then
    begin
      //中等
      Result.Top:=Result.Top+Self.GetTrackBtnDrawPos;
      Result.Top:=Result.Top-GetTrackBtnDrawSize div 2;
    end;
    Result.Bottom:=Result.Top+Self.GetTrackBtnDrawSize;
  end
  else
  begin
    Result:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);
    if Self.GetTrackBtnDrawPos>=Self.FSkinControlIntf.Width-Self.GetTrackBtnDrawSize div 2 then
    begin
      //过长
      Result.Left:=GetTrackBtnDrawPos-GetTrackBtnDrawSize div 2;
      if Result.Left>Self.FSkinControlIntf.Width-GetTrackBtnDrawSize then
      begin
        Result.Left:=Self.FSkinControlIntf.Width-GetTrackBtnDrawSize;
      end;
    end
    else if Self.GetTrackBtnDrawPos>=Self.GetTrackBtnDrawSize div 2 then
    begin
      //中等
      Result.Left:=Result.Left+Self.GetTrackBtnDrawPos;
      Result.Left:=Result.Left-GetTrackBtnDrawSize div 2;
    end;
    Result.Right:=Result.Left+Self.GetTrackBtnDrawSize;
  end;
end;

function TSkinTrackBarDefaultType.GetUpSpaceDrawRect: TRectF;
begin
  if Self.FSkinTrackBarIntf.Prop.Orientation=trVertical then
  begin
    //进度条
    Result.Top:=0;
    Result.Left:=0;
    Result.Right:=Self.FSkinControlIntf.Width;
    if Self.GetTrackBtnDrawPos<=Self.GetTrackBtnDrawSize then
    begin
      Result.Bottom:=Result.Top+Self.GetTrackBtnDrawPos;
    end
    else
    begin
      Result.Bottom:=Result.Top+GetTrackBtnDrawPos+Self.GetTrackBtnDrawSize div 2;
    end;
    if Result.Bottom>Self.FSkinControlIntf.Height then
    begin
      Result.Bottom:=Self.FSkinControlIntf.Height;
    end;
  end
  else
  begin
    //进度条
    Result.Top:=0;
    Result.Left:=0;
    Result.Bottom:=Self.FSkinControlIntf.Height;
    if Self.GetTrackBtnDrawPos<=Self.GetTrackBtnDrawSize then
    begin
      Result.Right:=Result.Left+Self.GetTrackBtnDrawPos;
    end
    else
    begin
      Result.Right:=Result.Left+GetTrackBtnDrawPos+Self.GetTrackBtnDrawSize div 2;
    end;
    if Result.Right>Self.FSkinControlIntf.Width then
    begin
      Result.Right:=Self.FSkinControlIntf.Width;
    end;
  end;
end;

function TSkinTrackBarDefaultType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  ABackGndPicture:TDrawPicture;
  AForeGndPicture:TDrawPicture;
  ATrackBtnDrawPicture:TDrawPicture;
  AUpSpaceDrawRect:TRectF;
  ATrackBtnRect:TRectF;
begin
  if Self.GetSkinMaterial<>nil then
  begin
    ATrackBtnDrawPicture:=nil;
    //确定素材
    if Self.FSkinTrackBarIntf.Prop.Orientation=trVertical then
    begin
        ABackGndPicture:=Self.GetSkinMaterial.FVertBackGndPicture;
        AForeGndPicture:=Self.GetSkinMaterial.FVertForeGndPicture;
        if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDown and APaintData.IsDrawInteractiveState then
        begin
          ATrackBtnDrawPicture:=Self.GetSkinMaterial.FVertTrackBtnDownPicture;
        end
        else if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseHover and APaintData.IsDrawInteractiveState then
        begin
          ATrackBtnDrawPicture:=Self.GetSkinMaterial.FVertTrackBtnHoverPicture;
        end
        else
        begin
          ATrackBtnDrawPicture:=Self.GetSkinMaterial.FVertTrackBtnNormalPicture;
        end;
        if ATrackBtnDrawPicture.CurrentPictureIsEmpty then
        begin
          ATrackBtnDrawPicture:=Self.GetSkinMaterial.FVertTrackBtnNormalPicture;
        end;
    end
    else
    begin
        ABackGndPicture:=Self.GetSkinMaterial.FHorzBackGndPicture;
        AForeGndPicture:=Self.GetSkinMaterial.FHorzForeGndPicture;
        if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDown and APaintData.IsDrawInteractiveState then
        begin
          ATrackBtnDrawPicture:=Self.GetSkinMaterial.FHorzTrackBtnDownPicture;
        end
        else if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseHover and APaintData.IsDrawInteractiveState then
        begin
          ATrackBtnDrawPicture:=Self.GetSkinMaterial.FHorzTrackBtnHoverPicture;
        end
        else
        begin
          ATrackBtnDrawPicture:=Self.GetSkinMaterial.FHorzTrackBtnNormalPicture;
        end;
        if ATrackBtnDrawPicture.CurrentPictureIsEmpty then
        begin
          ATrackBtnDrawPicture:=Self.GetSkinMaterial.FHorzTrackBtnNormalPicture;
        end;
    end;


    //确定绘制矩形
    if Self.FSkinTrackBarIntf.Prop.Orientation=trVertical then
    begin
      Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchStyle:=issThreePartVert;
      Self.GetSkinMaterial.FForeGndDrawPictureParam.StretchStyle:=issThreePartVert;
    end
    else
    begin
      Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchStyle:=issThreePartHorz;
      Self.GetSkinMaterial.FForeGndDrawPictureParam.StretchStyle:=issThreePartHorz;
    end;


    //绘制背景
    ACanvas.DrawPicture(Self.GetSkinMaterial.FBackGndDrawPictureParam,
                        ABackGndPicture,
                        ADrawRect);



    //绘制前景
    AUpSpaceDrawRect:=GetUpSpaceDrawRect;
    OffsetRect(AUpSpaceDrawRect,ADrawRect.Left,ADrawRect.Top);

    ACanvas.DrawPicture(Self.GetSkinMaterial.FForeGndDrawPictureParam,
                        AForeGndPicture,
                        AUpSpaceDrawRect);

    //绘制滑动块
    ATrackBtnRect:=GetTrackBtnDrawRect;
    OffsetRect(ATrackBtnRect,ADrawRect.Left,ADrawRect.Top);

    ACanvas.DrawPicture(Self.GetSkinMaterial.FTrackBtnDrawPictureParam,
                        ATrackBtnDrawPicture,
                        ATrackBtnRect);
  end;
end;



{ TSkinTrackBarDefaultMaterial }

constructor TSkinTrackBarDefaultMaterial.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);

  FHorzTrackBtnHoverPicture:=CreateDrawPicture('HorzTrackBtnHoverPicture','鼠标停靠状态水平样式移动滑块图片','水平样式移动滑块所有状态图片');
  FHorzTrackBtnNormalPicture:=CreateDrawPicture('HorzTrackBtnNormalPicture','正常状态水平样式移动滑块图片','水平样式移动滑块所有状态图片');
  FHorzTrackBtnDisabledPicture:=CreateDrawPicture('HorzTrackBtnDisabledPicture','禁用状态水平样式移动滑块图片','水平样式移动滑块所有状态图片');
  FHorzTrackBtnDownPicture:=CreateDrawPicture('HorzTrackBtnDownPicture','按下状态水平样式移动滑块鼠标图片','水平样式移动滑块所有状态图片');

  FVertTrackBtnHoverPicture:=CreateDrawPicture('VertTrackBtnHoverPicture','鼠标停靠状态垂直样式移动滑块图片','垂直样式移动滑块所有状态图片');
  FVertTrackBtnNormalPicture:=CreateDrawPicture('VertTrackBtnNormalPicture','正常状态垂直样式移动滑块图片','垂直样式移动滑块所有状态图片');
  FVertTrackBtnDisabledPicture:=CreateDrawPicture('VertTrackBtnDisabledPicture','禁用状态垂直样式移动滑块图片','垂直样式移动滑块所有状态图片');
  FVertTrackBtnDownPicture:=CreateDrawPicture('VertTrackBtnDownPicture','鼠标按下状态垂直样式移动滑块图片','垂直样式移动滑块所有状态图片');

  FHorzBackGndPicture:=CreateDrawPicture('HorzBackGndPicture','水平样式背景图片');
  FVertBackGndPicture:=CreateDrawPicture('VertBackGndPicture','垂直样式背景图片');
  FHorzForeGndPicture:=CreateDrawPicture('HorzForeGndPicture','水平样式前景图片');
  FVertForeGndPicture:=CreateDrawPicture('VertForeGndPicture','垂直样式前景图片');


  FBackGndDrawPictureParam:=CreateDrawPictureParam('BackGndDrawPictureParam','背景图片绘制参数');
//  FBackGndDrawPictureParam.IsStretch:=True;
//  FBackGndDrawPictureParam.StretchMargins.SetBounds(5,5,5,5);

  FForeGndDrawPictureParam:=CreateDrawPictureParam('ForeGndDrawPictureParam','前景图片绘制参数');
//  FForeGndDrawPictureParam.IsStretch:=True;
//  FForeGndDrawPictureParam.StretchMargins.SetBounds(5,5,5,5);
//  FForeGndDrawPictureParam.ImageTooSmallProcessType:=itsptPart;
//
  FTrackBtnDrawPictureParam:=CreateDrawPictureParam('TrackBtnDrawPictureParam','移动滑块图片绘制参数');;


  FTrackBtnDrawSize:=0;
end;

//function TSkinTrackBarDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  I: Integer;
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited LoadFromDocNode(ADocNode);
//
////
////  for I := 0 to ADocNode.ChildNodes.Count - 1 do
////  begin
////    ABTNode:=ADocNode.ChildNodes[I];
////
////
////    if ABTNode.NodeName='HorzTrackBtnNormalPicture' then
////    begin
////      FHorzTrackBtnNormalPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HorzTrackBtnHoverPicture' then
////    begin
////      FHorzTrackBtnHoverPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HorzTrackBtnDisabledPicture' then
////    begin
////      FHorzTrackBtnDisabledPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HorzTrackBtnDownPicture' then
////    begin
////      FHorzTrackBtnDownPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='VertTrackBtnNormalPicture' then
////    begin
////      FVertTrackBtnNormalPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='VertTrackBtnHoverPicture' then
////    begin
////      FVertTrackBtnHoverPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='VertTrackBtnDisabledPicture' then
////    begin
////      FVertTrackBtnDisabledPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='VertTrackBtnDownPicture' then
////    begin
////      FVertTrackBtnDownPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='VertBackGndPicture' then
////    begin
////      FVertBackGndPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HorzBackGndPicture' then
////    begin
////      FHorzBackGndPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='VertForeGndPicture' then
////    begin
////      FVertForeGndPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HorzForeGndPicture' then
////    begin
////      FHorzForeGndPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    ;
////
////  end;
//
//  Result:=True;
//end;
//
//function TSkinTrackBarDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited SaveToDocNode(ADocNode);
//
//
////  ABTNode:=ADocNode.AddChildNode_Class('HorzTrackBtnNormalPicture',FHorzTrackBtnNormalPicture.Name);
////  Self.FHorzTrackBtnNormalPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('HorzTrackBtnHoverPicture',FHorzTrackBtnHoverPicture.Name);
////  Self.FHorzTrackBtnHoverPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('HorzTrackBtnDisabledPicture',FHorzTrackBtnDisabledPicture.Name);
////  Self.FHorzTrackBtnDisabledPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('HorzTrackBtnDownPicture',FHorzTrackBtnDownPicture.Name);
////  Self.FHorzTrackBtnDownPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('VertTrackBtnNormalPicture',FVertTrackBtnNormalPicture.Name);
////  Self.FVertTrackBtnNormalPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('VertTrackBtnHoverPicture',FVertTrackBtnHoverPicture.Name);
////  Self.FVertTrackBtnHoverPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('VertTrackBtnDisabledPicture',FVertTrackBtnDisabledPicture.Name);
////  Self.FVertTrackBtnDisabledPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('VertTrackBtnDownPicture',FVertTrackBtnDownPicture.Name);
////  Self.FVertTrackBtnDownPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('VertBackGndPicture',FVertBackGndPicture.Name);
////  Self.FVertBackGndPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('HorzBackGndPicture',FHorzBackGndPicture.Name);
////  Self.FHorzBackGndPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('VertForeGndPicture',FVertForeGndPicture.Name);
////  Self.FVertForeGndPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('HorzForeGndPicture',FHorzForeGndPicture.Name);
////  Self.FHorzForeGndPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//
//  Result:=True;
//end;

destructor TSkinTrackBarDefaultMaterial.Destroy;
begin

  FreeAndNil(FHorzTrackBtnHoverPicture);
  FreeAndNil(FHorzTrackBtnNormalPicture);
  FreeAndNil(FHorzTrackBtnDisabledPicture);
  FreeAndNil(FHorzTrackBtnDownPicture);

  FreeAndNil(FVertTrackBtnHoverPicture);
  FreeAndNil(FVertTrackBtnNormalPicture);
  FreeAndNil(FVertTrackBtnDisabledPicture);
  FreeAndNil(FVertTrackBtnDownPicture);

  FreeAndNil(FTrackBtnDrawPictureParam);
  FreeAndNil(FBackGndDrawPictureParam);
  FreeAndNil(FForeGndDrawPictureParam);

  FreeAndNil(FHorzBackGndPicture);
  FreeAndNil(FVertBackGndPicture);
  FreeAndNil(FHorzForeGndPicture);
  FreeAndNil(FVertForeGndPicture);

  inherited;
end;


procedure TSkinTrackBarDefaultMaterial.SetBackGndDrawPictureParam(
  const Value: TDrawPictureParam);
begin
  FBackGndDrawPictureParam.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetForeGndDrawPictureParam(
  const Value: TDrawPictureParam);
begin
  FForeGndDrawPictureParam.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetHorzBackGndPicture(const Value: TDrawPicture);
begin
  FHorzBackGndPicture.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetVertBackGndPicture(const Value: TDrawPicture);
begin
  FVertBackGndPicture.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetHorzForeGndPicture(const Value: TDrawPicture);
begin
  FHorzForeGndPicture.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetHorzTrackBtnDisabledPicture(const Value: TDrawPicture);
begin
  FHorzTrackBtnDisabledPicture.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetHorzTrackBtnDownPicture(const Value: TDrawPicture);
begin
  FHorzTrackBtnDownPicture.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetHorzTrackBtnHoverPicture(const Value: TDrawPicture);
begin
  FHorzTrackBtnHoverPicture.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetHorzTrackBtnNormalPicture(const Value: TDrawPicture);
begin
  FHorzTrackBtnNormalPicture.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetTrackBtnDrawSize(
  const Value: Integer);
begin
  if FTrackBtnDrawSize<>Value then
  begin
    FTrackBtnDrawSize := Value;
    DoChange;
  end;
end;

procedure TSkinTrackBarDefaultMaterial.SetTrackBtnDrawPictureParam(
  const Value: TDrawPictureParam);
begin
  FTrackBtnDrawPictureParam.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetVertForeGndPicture(const Value: TDrawPicture);
begin
  FVertForeGndPicture.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetVertTrackBtnDisabledPicture(const Value: TDrawPicture);
begin
  FVertTrackBtnDisabledPicture.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetVertTrackBtnDownPicture(const Value: TDrawPicture);
begin
  FVertTrackBtnDownPicture.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetVertTrackBtnHoverPicture(const Value: TDrawPicture);
begin
  FVertTrackBtnHoverPicture.Assign(Value);
end;

procedure TSkinTrackBarDefaultMaterial.SetVertTrackBtnNormalPicture(const Value: TDrawPicture);
begin
  FVertTrackBtnNormalPicture.Assign(Value);
end;



{ TSkinTrackBarProgressBarMaterial }

constructor TSkinTrackBarProgressBarMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHorzProgressNormalPicture:=CreateDrawPicture('HorzProgressNormalPicture','垂直样式进度正常状态图片');
  FVertProgressNormalPicture:=CreateDrawPicture('VertProgressNormalPicture','水平样式进度正常状态图片');
//  FHorzProgressDisabledPicture:=CreateDrawPicture('HorzProgressDisabledPicture','垂直样式进度禁用状态图片');
//  FVertProgressDisabledPicture:=CreateDrawPicture('VertProgressDisabledPicture','水平样式进度禁用状态图片');
  FProgressDrawPictureParam:=CreateDrawPictureParam('ProgressDrawPictureParam','进度图片绘制参数');
//  FProgressDrawPictureParam.IsStretch:=True;
end;

//function TSkinTrackBarProgressBarMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
////
////
////    if ABTNode.NodeName='VertProgressNormalPicture' then
////    begin
////      FVertProgressNormalPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HorzProgressNormalPicture' then
////    begin
////      FHorzProgressNormalPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='VertProgressDisabledPicture' then
////    begin
////      FVertProgressDisabledPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HorzProgressDisabledPicture' then
////    begin
////      FHorzProgressDisabledPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end;
////
////  end;
//
//  Result:=True;
//end;
//
//function TSkinTrackBarProgressBarMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited SaveToDocNode(ADocNode);
//
//
////  ABTNode:=ADocNode.AddChildNode_Class('VertProgressNormalPicture',FVertProgressNormalPicture.Name);
////  Self.FVertProgressNormalPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('HorzProgressNormalPicture',FHorzProgressNormalPicture.Name);
////  Self.FHorzProgressNormalPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('VertProgressPicture',FVertProgressDisabledPicture.Name);
////  Self.FVertProgressDisabledPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('HorzProgressDisabledPicture',FHorzProgressDisabledPicture.Name);
////  Self.FHorzProgressDisabledPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
//
//
//  Result:=True;
//end;

destructor TSkinTrackBarProgressBarMaterial.Destroy;
begin
  FreeAndNil(FProgressDrawPictureParam);
  FreeAndNil(FHorzProgressNormalPicture);
  FreeAndNil(FVertProgressNormalPicture);
//  FreeAndNil(FHorzProgressDisabledPicture);
//  FreeAndNil(FVertProgressDisabledPicture);
  inherited;
end;

procedure TSkinTrackBarProgressBarMaterial.SetHorzProgressNormalPicture(const Value: TDrawPicture);
begin
  FHorzProgressNormalPicture.Assign(Value);
end;

procedure TSkinTrackBarProgressBarMaterial.SetVertProgressNormalPicture(const Value: TDrawPicture);
begin
  FVertProgressNormalPicture.Assign(Value);
end;

//procedure TSkinTrackBarProgressBarMaterial.SetHorzProgressDisabledPicture(const Value: TDrawPicture);
//begin
//  FHorzProgressDisabledPicture.Assign(Value);
//end;
//
//procedure TSkinTrackBarProgressBarMaterial.SetVertProgressDisabledPicture(const Value: TDrawPicture);
//begin
//  FVertProgressDisabledPicture.Assign(Value);
//end;

{ TSkinTrackBarProgressBarType }

function TSkinTrackBarProgressBarType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  ABackGndPicture:TDrawPicture;
  AForeGndPicture:TDrawPicture;
  ATrackDrawPicture:TDrawPicture;
  AUpSpaceDrawRect:TRectF;
  ATrackBtnRect:TRectF;
  AProgressDrawRect:TRectF;
begin
  if Self.GetSkinMaterial<>nil then
  begin
    ATrackDrawPicture:=nil;
    //确定素材
    if Self.FSkinTrackBarIntf.Prop.Orientation=trVertical then
    begin
      ABackGndPicture:=Self.GetSkinMaterial.FVertBackGndPicture;
      AForeGndPicture:=Self.GetSkinMaterial.FVertForeGndPicture;
      if Self.FSkinControlIntf.IsMouseOver then
      begin
        if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDown and APaintData.IsDrawInteractiveState then
        begin
          ATrackDrawPicture:=Self.GetSkinMaterial.FVertTrackBtnDownPicture;
        end
        else if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseHover and APaintData.IsDrawInteractiveState then
        begin
          ATrackDrawPicture:=Self.GetSkinMaterial.FVertTrackBtnHoverPicture;
        end
        else
        begin
          ATrackDrawPicture:=Self.GetSkinMaterial.FVertTrackBtnNormalPicture;
        end;
        if ATrackDrawPicture.CurrentPictureIsEmpty then
        begin
          ATrackDrawPicture:=Self.GetSkinMaterial.FVertTrackBtnNormalPicture;
        end;
      end
      else
      begin
//        if Self.FSkinControlIntf.Enabled then
//        begin
          ATrackDrawPicture:=Self.GetSkinMaterial.FVertProgressNormalPicture;
//        end
//        else
//        begin
//          ATrackDrawPicture:=Self.GetSkinMaterial.FVertProgressDisabledPicture;
//        end;
      end;
    end
    else
    begin
      ABackGndPicture:=Self.GetSkinMaterial.FHorzBackGndPicture;
      AForeGndPicture:=Self.GetSkinMaterial.FHorzForeGndPicture;
      if Self.FSkinControlIntf.IsMouseOver then
      begin
        if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseDown and APaintData.IsDrawInteractiveState then
        begin
          ATrackDrawPicture:=Self.GetSkinMaterial.FHorzTrackBtnDownPicture;
        end
        else if Self.FSkinTrackBarIntf.Prop.TrackBtnState.MouseHover
            and APaintData.IsDrawInteractiveState then
        begin
          ATrackDrawPicture:=Self.GetSkinMaterial.FHorzTrackBtnHoverPicture;
        end
        else
        begin
          ATrackDrawPicture:=Self.GetSkinMaterial.FHorzTrackBtnNormalPicture;
        end;
        if ATrackDrawPicture.CurrentPictureIsEmpty then
        begin
          ATrackDrawPicture:=Self.GetSkinMaterial.FHorzTrackBtnNormalPicture;
        end;
      end
      else
      begin
//        if Self.FSkinControlIntf.Enabled then
//        begin
          ATrackDrawPicture:=Self.GetSkinMaterial.FHorzProgressNormalPicture;
//        end
//        else
//        begin
//          ATrackDrawPicture:=Self.GetSkinMaterial.FHorzProgressDisabledPicture;
//        end;
      end;
    end;

    //图片绘制参数
    if Self.FSkinTrackBarIntf.Prop.Orientation=trVertical then
    begin
      Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchStyle:=issThreePartVert;
    end
    else
    begin
      Self.GetSkinMaterial.FBackGndDrawPictureParam.StretchStyle:=issThreePartHorz;
    end;

    //绘制背景
    ACanvas.DrawPicture(Self.GetSkinMaterial.FBackGndDrawPictureParam,
                        ABackGndPicture,
                        ADrawRect);

//    if Not (csDesigning in Self.FSkinControl.ComponentState) then
//    begin

      //绘制前景
      AUpSpaceDrawRect:=GetUpSpaceDrawRect;
      OffsetRect(AUpSpaceDrawRect,ADrawRect.Left,ADrawRect.Top);
      ACanvas.DrawPicture(Self.GetSkinMaterial.FBackGndDrawPictureParam,
                          AForeGndPicture,
                          AUpSpaceDrawRect);

      if Self.FSkinControlIntf.IsMouseOver and APaintData.IsDrawInteractiveState then
      begin
        ATrackBtnRect:=GetTrackBtnDrawRect;
        OffsetRect(ATrackBtnRect,ADrawRect.Left,ADrawRect.Top);

        //绘制拖动条滑动块
        ACanvas.DrawPicture(Self.GetSkinMaterial.FTrackBtnDrawPictureParam,
                            ATrackDrawPicture,
                            ATrackBtnRect);
      end
      else
      begin
        //绘制进度条
        AProgressDrawRect:=GetProgressDrawRect;
        OffsetRect(AProgressDrawRect,ADrawRect.Left,ADrawRect.Top);
        if (Self.FSkinTrackBarIntf.Prop.Position<>Self.FSkinTrackBarIntf.Prop.Max)
          and (Self.FSkinTrackBarIntf.Prop.Position<>Self.FSkinTrackBarIntf.Prop.Min) then
        ACanvas.DrawPicture(Self.GetSkinMaterial.FProgressDrawPictureParam,
                            ATrackDrawPicture,
                            AProgressDrawRect);
      end;

//    end;

  end;
end;

function TSkinTrackBarProgressBarType.GetProgressDrawRect: TRectF;
begin
  if Self.FSkinTrackBarIntf.Prop.Orientation=trVertical then
  begin
    Result.Left:=0;
    Result.Right:=Self.FSkinControlIntf.Width;
    //进度条
    Result.Bottom:=GetTrackBtnDrawPos;
    if Self.GetTrackBtnDrawPos<=Self.GetTrackBtnDrawSize then
    begin
      Result.Top:=0;
    end
    else
    begin
      Result.Top:=Result.Bottom-Self.GetTrackBtnDrawSize;
    end;
  end
  else
  begin
    Result.Top:=0;
    Result.Bottom:=Self.FSkinControlIntf.Height;
    //进度条
    Result.Right:=GetTrackBtnDrawPos;
    if Self.GetTrackBtnDrawPos<=Self.GetTrackBtnDrawSize then
    begin
      Result.Left:=0;
    end
    else
    begin
      Result.Left:=Result.Right-Self.GetTrackBtnDrawSize;
    end;
  end;
end;

function TSkinTrackBarProgressBarType.GetSkinMaterial: TSkinTrackBarProgressBarMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinTrackBarProgressBarMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinTrackBarProgressBarType.GetTrackBtnDrawSize: Integer;
begin
  if Self.FSkinTrackBarIntf.Prop.Orientation=trVertical then
  begin
    Result:=Self.GetSkinMaterial.FVertTrackBtnHoverPicture.CurrentPictureHeight;
  end
  else
  begin
    Result:=Self.GetSkinMaterial.FHorzTrackBtnHoverPicture.CurrentPictureWidth;
  end;
end;

function TSkinTrackBarProgressBarType.GetUpSpaceDrawRect: TRectF;
begin
  if Self.FSkinTrackBarIntf.Prop.Orientation=trVertical then
  begin
    //进度条
    Result.Top:=0;
    Result.Left:=0;
    Result.Right:=Self.FSkinControlIntf.Width;
    if Self.FSkinControlIntf.IsMouseOver then
    begin
      if Self.GetTrackBtnDrawPos<=Self.GetTrackBtnDrawSize then
      begin
        Result.Bottom:=Result.Top+Self.GetTrackBtnDrawPos;
      end
      else
      begin
        Result.Bottom:=Result.Top+GetTrackBtnDrawPos+Self.GetTrackBtnDrawSize div 2;
      end;
    end
    else
    begin
      Result.Bottom:=Result.Top+Self.GetTrackBtnDrawPos;
    end;
    if Result.Bottom>Self.FSkinControlIntf.Height then
    begin
      Result.Bottom:=Self.FSkinControlIntf.Height;
    end;
  end
  else
  begin
    //进度条
    Result.Top:=0;
    Result.Left:=0;
    Result.Bottom:=Self.FSkinControlIntf.Height;
    if Self.FSkinControlIntf.IsMouseOver then
    begin
      if Self.GetTrackBtnDrawPos<=Self.GetTrackBtnDrawSize then
      begin
        Result.Right:=Result.Left+Self.GetTrackBtnDrawPos;
      end
      else
      begin
        Result.Right:=Result.Left+GetTrackBtnDrawPos+Self.GetTrackBtnDrawSize div 2;
      end;
    end
    else
    begin
      Result.Right:=Result.Left+Self.GetTrackBtnDrawPos;
    end;
    if Result.Right>Self.FSkinControlIntf.Width then
    begin
      Result.Right:=Self.FSkinControlIntf.Width;
    end;
  end;
end;

//procedure TSkinTrackBarProgressBarType.CustomMouseEnter;
//begin
//  inherited;
//  Self.Invalidate;
//end;
//
//procedure TSkinTrackBarProgressBarType.CustomMouseLeave;
//begin
//  inherited;
//  Self.Invalidate;
//end;








{ TTrackBarProperties }

procedure TTrackBarProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
  FOrientation:=TTrackBarProperties(Src).FOrientation;
  FMax:=TTrackBarProperties(Src).FMax;
  FMin:=TTrackBarProperties(Src).FMin;
  FPosition:=TTrackBarProperties(Src).FPosition;
end;

constructor TTrackBarProperties.Create(ASkinControl:TControl);
begin
  FTrackBtnState:=TSkinTrackBarBtnState.Create;
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinTrackBar,Self.FSkinTrackBarIntf) then
  begin
    ShowException('This Component Do not Support ISkinTrackBar Interface');
  end
  else
  begin
    FOrientation:=trHorizontal;
    FMin:=0;
    FMax:=100;
    FPosition:=0;
    case FOrientation of
      trHorizontal:
      begin
        FSkinControlIntf.Width:=120;
        FSkinControlIntf.Height:=22;
      end;
      trVertical:
      begin
        FSkinControlIntf.Width:=22;
        FSkinControlIntf.Height:=120;
      end;
    end;
  end;
end;

destructor TTrackBarProperties.Destroy;
begin
  FreeAndNil(FTrackBtnState);
  inherited;
end;

procedure TTrackBarProperties.DoChange;
begin
  if Assigned(Self.FSkinTrackBarIntf.OnChange) then
  begin
    Self.FSkinTrackBarIntf.OnChange(Self);
  end;
end;

procedure TTrackBarProperties.SetOrientation(const Value: TTrackBarOrientation);
begin
  if Value <> FOrientation then
  begin
    FOrientation := Value;
    if not (csLoading in FSkinControl.ComponentState) then
      FSkinControlIntf.SetBounds(FSkinControlIntf.Left, FSkinControlIntf.Top, FSkinControlIntf.Height, FSkinControlIntf.Width);
  end;
end;

procedure TTrackBarProperties.SetMax(const Value: Double);
begin
  SetParams(FPosition, FMin, Value);
end;

procedure TTrackBarProperties.SetMin(const Value: Double);
begin
  SetParams(FPosition, Value, FMax);
end;

procedure TTrackBarProperties.SetParams(APosition, AMin, AMax: Double);
begin

  if APosition < AMin then
  begin
    APosition := AMin;
  end;

  if APosition > AMax then
  begin
    APosition := AMax;
  end;

  if (FPosition <> APosition) or (FMin <> AMin) or (FMax <> AMax)  then
  begin
    FMin := AMin;
    FMax := AMax;

    FPosition := APosition;

    //触发更改事件
    DoChange;

    Invalidate;
  end;

end;

procedure TTrackBarProperties.SetPosition(const Value: Double);
begin
  SetParams(Value, FMin, FMax);
end;

function TTrackBarProperties.GetComponentClassify: String;
begin
  Result:='SkinTrackBar';
end;


function TTrackBarProperties.GetTrackBtnState: TSkinTrackBarBtnState;
begin
  if FTrackBtnState=nil then
  begin
    FTrackBtnState:=TSkinTrackBarBtnState.Create;
  end;
  Result:=Self.FTrackBtnState;
end;




{ TSkinTrackBar }

function TSkinTrackBar.Material:TSkinTrackBarDefaultMaterial;
begin
  Result:=TSkinTrackBarDefaultMaterial(SelfOwnMaterial);
end;

function TSkinTrackBar.SelfOwnMaterialToDefault:TSkinTrackBarDefaultMaterial;
begin
  Result:=TSkinTrackBarDefaultMaterial(SelfOwnMaterial);
end;

function TSkinTrackBar.CurrentUseMaterialToDefault:TSkinTrackBarDefaultMaterial;
begin
  Result:=TSkinTrackBarDefaultMaterial(CurrentUseMaterial);
end;

function TSkinTrackBar.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TTrackBarProperties;
end;

function TSkinTrackBar.GetTrackBarProperties: TTrackBarProperties;
begin
  Result:=TTrackBarProperties(Self.FProperties);
end;

procedure TSkinTrackBar.SetTrackBarProperties(Value: TTrackBarProperties);
begin
  Self.FProperties.Assign(Value);
end;



//procedure TSkinTrackBar.SetOnChange(const Value: TNotifyEvent);
//begin
//  Self.FOnChange:=Value;
//end;

function TSkinTrackBar.GetOnChange: TNotifyEvent;
begin
  Result:=Self.FOnChange;
end;

procedure TSkinTrackBar.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetTrackBarProperties.AdjustAutoSizeBounds;
  end;
  Inherited;
end;




end.

