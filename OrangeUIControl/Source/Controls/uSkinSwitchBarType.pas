//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     开关条
///   </para>
///   <para>
///     SwitchBar
///   </para>
/// </summary>
unit uSkinSwitchBarType;

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
  uBaseSkinControl,
  uFuncCommon,
  uGraphicCommon,
  uDrawCanvas,
  uDrawEngine,
  uSkinMaterial,
  uBinaryTreeDoc,
  uDrawPicture,
  uDrawParam,
  uSkinBufferBitmap,
  uComponentType,
  uDrawTextParam,
  uDrawPictureParam;


const
  IID_ISkinSwitchBar:TGUID='{10BD94DC-4323-45DD-9C3B-C232CB81342B}';



type
  TSwitchBarOrientation=(srHorizontal,
                         srVertical);
  TSwitchBarProperties=class;





  //开关条的按钮状态
  TSkinSwitchBarBtnState=class
  public
    MouseDown:Boolean;
    MouseHover:Boolean;
    MouseDownPt:TPointF;
    MouseDownOffset:Double;
  end;



  ISkinSwitchBar=interface//(ISkinControl)
  ['{10BD94DC-4323-45DD-9C3B-C232CB81342B}']
    function GetOnChange: TNotifyEvent;
    property OnChange: TNotifyEvent read GetOnChange;// write SetOnChange;

    function GetSwitchBarProperties:TSwitchBarProperties;
    property Properties:TSwitchBarProperties read GetSwitchBarProperties;
    property Prop:TSwitchBarProperties read GetSwitchBarProperties;
  end;




  //开关条属性
  TSwitchBarProperties=class(TSkinControlProperties)
  protected
    FMin: Double;
    FMax: Double;
    FPosition: Double;

    FDrawPosition:Double;


    FOrientation:TSwitchBarOrientation;

    FSwitchBtnState:TSkinSwitchBarBtnState;

    FSkinSwitchBarIntf:ISkinSwitchBar;

    procedure DoChange;

    function GetChecked: Boolean;
    procedure SetChecked(const Value: Boolean);
    procedure SetStaticChecked(const Value: Boolean);
    function GetDrawChecked: Boolean;
    procedure SetDrawChecked(const Value: Boolean);

    procedure SetOrientation(const Value: TSwitchBarOrientation);
    procedure SetMax(const Value: Double);
    procedure SetMin(const Value: Double);
    procedure SetPosition(const Value: Double);
    procedure SetDrawPosition(const Value: Double);
    function GetSwitchBtnState: TSkinSwitchBarBtnState;

    procedure SetParams(APosition, AMin, AMax: Double);
    procedure SetDrawParams(APosition, AMin, AMax: Double);
    //赋值
    procedure AssignProperties(Src:TSkinControlProperties);override;
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    property SwitchBtnState:TSkinSwitchBarBtnState read GetSwitchBtnState;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  public
    property Min: Double read FMin write SetMin ;//default 0;
    property Max: Double read FMax write SetMax ;//default 1;
    property Position: Double read FPosition write SetPosition ;//default 0;
    property DrawPosition: Double read FDrawPosition write SetDrawPosition ;//default 0;
    property Orientation: TSwitchBarOrientation read FOrientation write SetOrientation ;//default srHorizontal;
  public
    //是否选中
    property DrawChecked:Boolean read GetDrawChecked write SetDrawChecked;
    property StaticChecked:Boolean read GetChecked write SetStaticChecked;
    property StaticDrawChecked:Boolean read GetDrawChecked write SetDrawChecked;
  published
    //是否选中
    property Checked:Boolean read GetChecked write SetChecked ;//default False;
  end;





  //开关条素材基类
  TSkinSwitchBarMaterial=class(TSkinControlMaterial)
  end;
  //开关条控件类型基类
  TSkinSwitchBarType=class(TSkinControlType)
  protected
    FSkinSwitchBarIntf:ISkinSwitchBar;

    procedure DoMouseMove;
  protected
    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
    procedure CustomMouseMove(Shift: TShiftState;X,Y:Double);override;
    procedure CustomMouseEnter;override;
    procedure CustomMouseLeave;override;
    procedure SizeChanged;override;
  protected
    //开关条客户区尺寸
    function GetSwitchBarClientSize:Double;

    //移动滑块位置
    function GetSwitchBtnDrawPos(APosition:Double):Double;
    //比例
    function GetSwitchDrawStep:Double;
    //移动滑块按钮尺寸
    function GetSwitchBtnDrawSize:Double;virtual;//abstract;
    //移动滑块显示矩形
    function GetSwitchBtnDrawRect(APosition:Double):TRectF;virtual;//abstract;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  public
    function CalcCurrentEffectStates:TDPEffectStates;override;
  end;






  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinSwitchBarDefaultMaterial=class(TSkinSwitchBarMaterial)
  private
    FHorzSwitchBtnHoverPicture: TDrawPicture;
    FHorzSwitchBtnNormalPicture: TDrawPicture;
    FHorzSwitchBtnDisabledPicture: TDrawPicture;
    FHorzSwitchBtnDownPicture: TDrawPicture;

    FVertSwitchBtnHoverPicture: TDrawPicture;
    FVertSwitchBtnNormalPicture: TDrawPicture;
    FVertSwitchBtnDisabledPicture: TDrawPicture;
    FVertSwitchBtnDownPicture: TDrawPicture;

    FHorzBackGndPicture: TDrawPicture;
    FVertBackGndPicture: TDrawPicture;
    FHorzForeGndPicture: TDrawPicture;
    FVertForeGndPicture: TDrawPicture;

    FBackGndDrawPictureParam:TDrawPictureParam;
    FForeGndDrawPictureParam:TDrawPictureParam;
    FSwitchBtnDrawPictureParam:TDrawPictureParam;

    FSwitchBtnDrawSize: Integer;
    FIsDrawForeAndBackGround: Boolean;
    procedure SetSwitchBtnDrawSize(const Value: Integer);

    procedure SetHorzBackGndPicture(const Value: TDrawPicture);
    procedure SetVertBackGndPicture(const Value: TDrawPicture);
    procedure SetHorzForeGndPicture(const Value: TDrawPicture);
    procedure SetVertForeGndPicture(const Value: TDrawPicture);

    procedure SetHorzSwitchBtnDisabledPicture(const Value: TDrawPicture);
    procedure SetHorzSwitchBtnDownPicture(const Value: TDrawPicture);
    procedure SetHorzSwitchBtnHoverPicture(const Value: TDrawPicture);
    procedure SetHorzSwitchBtnNormalPicture(const Value: TDrawPicture);
    procedure SetVertSwitchBtnDisabledPicture(const Value: TDrawPicture);
    procedure SetVertSwitchBtnDownPicture(const Value: TDrawPicture);
    procedure SetVertSwitchBtnHoverPicture(const Value: TDrawPicture);
    procedure SetVertSwitchBtnNormalPicture(const Value: TDrawPicture);
    procedure SetBackGndDrawPictureParam(const Value: TDrawPictureParam);
    procedure SetForeGndDrawPictureParam(const Value: TDrawPictureParam);
    procedure SetSwitchBtnDrawPictureParam(const Value: TDrawPictureParam);
    procedure SetIsDrawForeAndBackGround(const Value: Boolean);
//  protected
//    //从文档节点中加载
//    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
//    //保存到文档节点
//    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    property IsDrawForeAndBackGround:Boolean read FIsDrawForeAndBackGround write SetIsDrawForeAndBackGround ;//default True;

    //绘制大小
    property SwitchBtnDrawSize:Integer read FSwitchBtnDrawSize write SetSwitchBtnDrawSize ;//default 0;




    //水平样式移动滑块正常状态图片
    property HorzSwitchBtnNormalPicture:TDrawPicture read FHorzSwitchBtnNormalPicture write SetHorzSwitchBtnNormalPicture;
    //水平样式移动滑块鼠标停靠状态图片
    property HorzSwitchBtnHoverPicture:TDrawPicture read FHorzSwitchBtnHoverPicture write SetHorzSwitchBtnHoverPicture;
    //水平样式移动滑块禁用状态图片
    property HorzSwitchBtnDisabledPicture: TDrawPicture read FHorzSwitchBtnDisabledPicture write SetHorzSwitchBtnDisabledPicture;
    //水平样式移动滑块鼠标按下状态图片
    property HorzSwitchBtnDownPicture: TDrawPicture read FHorzSwitchBtnDownPicture write SetHorzSwitchBtnDownPicture;

    //垂直样式移动滑块正常状态图片
    property VertSwitchBtnNormalPicture:TDrawPicture read FVertSwitchBtnNormalPicture write SetVertSwitchBtnNormalPicture;
    //垂直样式移动滑块鼠标停靠状态图片
    property VertSwitchBtnHoverPicture:TDrawPicture read FVertSwitchBtnHoverPicture write SetVertSwitchBtnHoverPicture;
    //垂直样式移动滑块禁用状态图片
    property VertSwitchBtnDisabledPicture: TDrawPicture read FVertSwitchBtnDisabledPicture write SetVertSwitchBtnDisabledPicture;
    //垂直样式移动滑块鼠标按下状态图片
    property VertSwitchBtnDownPicture: TDrawPicture read FVertSwitchBtnDownPicture write SetVertSwitchBtnDownPicture;




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
    property SwitchBtnDrawPictureParam:TDrawPictureParam read FSwitchBtnDrawPictureParam write SetSwitchBtnDrawPictureParam;
  end;


  //开关条默认类型
  TSkinSwitchBarDefaultType=class(TSkinSwitchBarType)
  private
    function GetSkinMaterial: TSkinSwitchBarDefaultMaterial;
  protected
    //获取进度条的绘制矩形
    function GetUpSpaceDrawRect(APosition:Double):TRectF;
    //获取
    function GetSwitchBtnDrawSize:Double;override;
    //获取移动滑块矩形
    function GetSwitchBtnDrawRect(APosition:Double):TRectF;override;
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinSwitchBar=class(TBaseSkinControl,ISkinSwitchBar)
  private
    function GetSwitchBarProperties:TSwitchBarProperties;
    procedure SetSwitchBarProperties(Value:TSwitchBarProperties);
  protected
    FOnChange: TNotifyEvent;

    function GetOnChange: TNotifyEvent;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
    //皮肤素材更改通知事件
    procedure DoCustomSkinMaterialChange(Sender: TObject);override;
  public
    //在点击事件中设置是否勾选属性
    procedure StayClick;override;
  public
    function SelfOwnMaterialToDefault:TSkinSwitchBarDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinSwitchBarDefaultMaterial;
    function Material:TSkinSwitchBarDefaultMaterial;
  public
    property Prop:TSwitchBarProperties read GetSwitchBarProperties write SetSwitchBarProperties;
  published
    //属性
    property Properties:TSwitchBarProperties read GetSwitchBarProperties write SetSwitchBarProperties;
    property OnChange: TNotifyEvent read GetOnChange write FOnChange;
  end;


  {$IFDEF VCL}
  TSkinWinSwitchBar=class(TSkinSwitchBar)
  end;
  {$ENDIF VCL}


implementation






{ TSkinSwitchBarType }

function TSkinSwitchBarType.CalcCurrentEffectStates: TDPEffectStates;
begin
  Result:=Inherited CalcCurrentEffectStates;
  if Self.FSkinSwitchBarIntf.Prop.Checked then
  begin
    Result:=Result+[dpstPushed];
  end;

end;

function TSkinSwitchBarType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinSwitchBar,Self.FSkinSwitchBarIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinSwitchBar Interface');
    end;
  end;
end;

procedure TSkinSwitchBarType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinSwitchBarIntf:=nil;
end;

procedure TSkinSwitchBarType.DoMouseMove;
var
  Offset: Double;
  SwitchBtnPosOffset:Double;
begin

//  if Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDown then
//  begin

    case Self.FSkinSwitchBarIntf.Prop.Orientation of
      srHorizontal:
      begin
        Offset := FMouseMovePt.X - Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDownPt.X;
      end;
      srVertical:
      begin
        Offset := FMouseMovePt.Y - Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDownPt.Y;
      end;
    end;

    if Offset <> 0 then
    begin

      case Self.FSkinSwitchBarIntf.Prop.Orientation of
        srHorizontal:
        begin
          SwitchBtnPosOffset := FMouseMovePt.X
                                -Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDownOffset
                                -Self.GetSwitchBtnDrawSize / 2;
        end;
        srVertical:
        begin
          SwitchBtnPosOffset := FMouseMovePt.Y
                                -Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDownOffset
                                -Self.GetSwitchBtnDrawSize / 2;
        end;
      end;

      if (GetSwitchBarClientSize - GetSwitchBtnDrawSize)>0 then
      begin

        Self.FSkinSwitchBarIntf.Prop.Position:=Self.FSkinSwitchBarIntf.Prop.FMin
              +
                    SwitchBtnPosOffset
                    *(Self.FSkinSwitchBarIntf.Prop.Max-Self.FSkinSwitchBarIntf.Prop.Min)
                    /(GetSwitchBarClientSize - GetSwitchBtnDrawSize);
      end
      else
      begin
        Self.FSkinSwitchBarIntf.Prop.Position:=Self.FSkinSwitchBarIntf.Prop.Min;
      end;

      Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDownPt := FMouseMovePt;
    end;
//  end;

end;

function TSkinSwitchBarType.GetSwitchBarClientSize: Double;
begin
  case Self.FSkinSwitchBarIntf.Prop.Orientation of
    srHorizontal:
    begin
      Result:=Self.FSkinControlIntf.Width;
    end;
    srVertical:
    begin
      Result:=Self.FSkinControlIntf.Height;
    end;
  end;
end;

function TSkinSwitchBarType.GetSwitchBtnDrawPos(APosition:Double): Double;
begin
  Result:=Round(APosition*Self.GetSwitchDrawStep);
end;

function TSkinSwitchBarType.GetSwitchBtnDrawRect(APosition:Double): TRectF;
begin
  uBaseLog.ShowException('Have Not Implement TSkinSwitchBarType.GetSwitchBtnDrawRect');
end;

function TSkinSwitchBarType.GetSwitchBtnDrawSize: Double;
begin
  uBaseLog.ShowException('Have Not Implement TBinaryObjectList.GetSwitchBtnDrawSize');
end;

function TSkinSwitchBarType.GetSwitchDrawStep: Double;
begin
  Result := GetSwitchBarClientSize
      /(Self.FSkinSwitchBarIntf.Prop.Max-Self.FSkinSwitchBarIntf.Prop.Min);
end;

procedure TSkinSwitchBarType.CustomMouseDown(Button: TMouseButton;Shift: TShiftState;X, Y: Double);
var
  PtInBarRect:Boolean;
//  ASwitchPos:Integer;

  NeedInvalidate:Boolean;

  PtInSwitchBtnRect:Boolean;
begin
  inherited;

//  if Not (csDesigning in Self.FSkinControl.ComponentState) then
//  begin
//  if Button={$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft  then
//  begin
    NeedInvalidate:=False;

    PtInBarRect:=False;
    PtInSwitchBtnRect:=False;
    FMouseMovePt:=PointF(X,Y);


    if PtInRect(RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height),FMouseMovePt) then
    begin
      PtInBarRect:=True;
      PtInSwitchBtnRect:=PtInRect(Self.GetSwitchBtnDrawRect(Self.FSkinSwitchBarIntf.Prop.Position),FMouseMovePt);
    end;

    if Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDown<>PtInSwitchBtnRect then
    begin
      NeedInvalidate:=True;
    end;
    Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDown:=PtInSwitchBtnRect;
    if PtInSwitchBtnRect then
    begin
      Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDownPt:=FMouseMovePt;
    end;


//    if PtInBarRect and Not PtInSwitchBtnRect then
//    begin
//      //如果在开关条区域内但不在拖动按钮上,那么按钮就移动到那里。
//      DoMouseMove;
//
//      NeedInvalidate:=True;
//    end;

    if NeedInvalidate then
    begin
      Self.Invalidate;
    end;
//  end;
//  end;
end;

procedure TSkinSwitchBarType.CustomMouseEnter;
begin
  inherited;
end;

procedure TSkinSwitchBarType.CustomMouseLeave;
var
  NeedInvalidate:Boolean;
begin
  inherited;
//  if Not (csDesigning in Self.FSkinControl.ComponentState) then
//  begin
    NeedInvalidate:=False;

    if Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseHover then
    begin
      Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseHover:=False;
      NeedInvalidate:=True;
    end;

    if NeedInvalidate then
    begin
      Self.Invalidate;
    end;
//  end;
end;

procedure TSkinSwitchBarType.CustomMouseMove(Shift: TShiftState;X, Y: Double);
var
//  ASwitchPos:Integer;
//  MouseOffset:Integer;
  NeedInvalidate:Boolean;
  PtInSwitchBtnRect:Boolean;
begin
  inherited;
//  if Not (csDesigning in Self.FSkinControl.ComponentState) then
//  begin
    NeedInvalidate:=False;

    PtInSwitchBtnRect:=False;
//    FMouseMovePt:=Point(X,Y);

    if PtInRect(RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height),FMouseMovePt) then
    begin
      PtInSwitchBtnRect:=PtInRect(Self.GetSwitchBtnDrawRect(Self.FSkinSwitchBarIntf.Prop.Position),FMouseMovePt);
    end;

    if Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseHover<>PtInSwitchBtnRect then
    begin
      Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseHover:=PtInSwitchBtnRect;
      NeedInvalidate:=True;
    end;



    if Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDown then
    begin

        DoMouseMove;

    end;

    if NeedInvalidate then
    begin
      Self.Invalidate;
    end;
//  end;

end;

procedure TSkinSwitchBarType.CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
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

    if Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDown then
    begin
      Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDown:=False;
      NeedInvalidate:=True;
    end;

    if NeedInvalidate then
    begin
      Self.Invalidate;
    end;
//  end;
//  end;

end;

procedure TSkinSwitchBarType.SizeChanged;
begin
  inherited;
  Invalidate;
end;

{ TSkinSwitchBarDefaultType }

function TSkinSwitchBarDefaultType.GetSwitchBtnDrawSize: Double;
begin
  case GetSkinMaterial.FSwitchBtnDrawSize of
    0:
    begin
      if Self.FSkinSwitchBarIntf.Prop.Orientation=srVertical then
      begin
        Result:=Self.GetSkinMaterial.FVertSwitchBtnNormalPicture.CurrentPictureDrawHeight;
      end
      else
      begin
        Result:=Self.GetSkinMaterial.FHorzSwitchBtnNormalPicture.CurrentPictureDrawWidth;
      end;
    end;
    else
    begin
      Result:=GetSkinMaterial.FSwitchBtnDrawSize;
    end;
  end;
end;

function TSkinSwitchBarDefaultType.GetSkinMaterial: TSkinSwitchBarDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinSwitchBarDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinSwitchBarDefaultType.GetSwitchBtnDrawRect(APosition:Double): TRectF;
begin
  //确定移动滑块绘制矩形
  if Self.FSkinSwitchBarIntf.Prop.Orientation=srVertical then
  begin
    Result:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);
    if Self.GetSwitchBtnDrawPos(APosition)>=Self.FSkinControlIntf.Height-Self.GetSwitchBtnDrawSize / 2 then
    begin
      //过长
      Result.Top:=GetSwitchBtnDrawPos(APosition)-GetSwitchBtnDrawSize / 2;
      if Result.Top>Self.FSkinControlIntf.Height-GetSwitchBtnDrawSize then
      begin
        Result.Top:=Self.FSkinControlIntf.Height-GetSwitchBtnDrawSize;
      end;
    end
    else if Self.GetSwitchBtnDrawPos(APosition)>=Self.GetSwitchBtnDrawSize / 2 then
    begin
      //中等
      Result.Top:=Result.Top+Self.GetSwitchBtnDrawPos(APosition);
      Result.Top:=Result.Top-GetSwitchBtnDrawSize / 2;
    end;
    Result.Bottom:=Result.Top+Self.GetSwitchBtnDrawSize;
  end
  else
  begin
    Result:=RectF(0,0,Self.FSkinControlIntf.Width,Self.FSkinControlIntf.Height);
    if Self.GetSwitchBtnDrawPos(APosition)>=Self.FSkinControlIntf.Width-Self.GetSwitchBtnDrawSize / 2 then
    begin
      //过长
      Result.Left:=GetSwitchBtnDrawPos(APosition)-GetSwitchBtnDrawSize / 2;
      if Result.Left>Self.FSkinControlIntf.Width-GetSwitchBtnDrawSize then
      begin
        Result.Left:=Self.FSkinControlIntf.Width-GetSwitchBtnDrawSize;
      end;
    end
    else if Self.GetSwitchBtnDrawPos(APosition)>=Self.GetSwitchBtnDrawSize / 2 then
    begin
      //中等
      Result.Left:=Result.Left+Self.GetSwitchBtnDrawPos(APosition);
      Result.Left:=Result.Left-GetSwitchBtnDrawSize / 2;
    end;
    Result.Right:=Result.Left+Self.GetSwitchBtnDrawSize;
  end;
end;

function TSkinSwitchBarDefaultType.GetUpSpaceDrawRect(APosition:Double): TRectF;
begin
  if Self.FSkinSwitchBarIntf.Prop.Orientation=srVertical then
  begin
    //进度条
    Result.Top:=0;
    Result.Left:=0;
    Result.Right:=Self.FSkinControlIntf.Width;
    if Self.GetSwitchBtnDrawPos(APosition)<=Self.GetSwitchBtnDrawSize then
    begin
      Result.Bottom:=Result.Top+Self.GetSwitchBtnDrawPos(APosition);
    end
    else
    begin
      Result.Bottom:=Result.Top+GetSwitchBtnDrawPos(APosition)+Self.GetSwitchBtnDrawSize / 2;
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
    if Self.GetSwitchBtnDrawPos(APosition)<=Self.GetSwitchBtnDrawSize then
    begin
      Result.Right:=Result.Left+Self.GetSwitchBtnDrawPos(APosition);
    end
    else
    begin
      Result.Right:=Result.Left+GetSwitchBtnDrawPos(APosition)+Self.GetSwitchBtnDrawSize / 2;
    end;
    if Result.Right>Self.FSkinControlIntf.Width then
    begin
      Result.Right:=Self.FSkinControlIntf.Width;
    end;
  end;
end;

function TSkinSwitchBarDefaultType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
var
  ABackGndPicture:TDrawPicture;
  AForeGndPicture:TDrawPicture;
  ASwitchBtnDrawPicture:TDrawPicture;
//  ASwitchBtnDrawSize:Integer;
  AUpSpaceDrawRect:TRectF;
  ASwitchBtnRect:TRectF;
  APosition:Double;
begin
  if APaintData.IsDrawInteractiveState then
  begin
    APosition:=Self.FSkinSwitchBarIntf.Prop.FPosition;
  end
  else
  begin
    APosition:=Self.FSkinSwitchBarIntf.Prop.FDrawPosition;
  end;


  if Self.GetSkinMaterial<>nil then
  begin
    //确定素材
    if Self.FSkinSwitchBarIntf.Prop.Orientation=srVertical then
    begin
      ABackGndPicture:=Self.GetSkinMaterial.FVertBackGndPicture;
      AForeGndPicture:=Self.GetSkinMaterial.FVertForeGndPicture;
      if Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDown and APaintData.IsDrawInteractiveState then
      begin
        ASwitchBtnDrawPicture:=Self.GetSkinMaterial.FVertSwitchBtnDownPicture;
      end
      else if Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseHover and APaintData.IsDrawInteractiveState then
      begin
        ASwitchBtnDrawPicture:=Self.GetSkinMaterial.FVertSwitchBtnHoverPicture;
      end
      else
      begin
        ASwitchBtnDrawPicture:=Self.GetSkinMaterial.FVertSwitchBtnNormalPicture;
      end;
      if ASwitchBtnDrawPicture.CurrentPictureIsEmpty then
      begin
        ASwitchBtnDrawPicture:=Self.GetSkinMaterial.FVertSwitchBtnNormalPicture;
      end;
    end
    else
    begin
      ABackGndPicture:=Self.GetSkinMaterial.FHorzBackGndPicture;
      AForeGndPicture:=Self.GetSkinMaterial.FHorzForeGndPicture;
      if Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseDown and APaintData.IsDrawInteractiveState then
      begin
        ASwitchBtnDrawPicture:=Self.GetSkinMaterial.FHorzSwitchBtnDownPicture;
      end
      else if Self.FSkinSwitchBarIntf.Prop.SwitchBtnState.MouseHover and APaintData.IsDrawInteractiveState then
      begin
        ASwitchBtnDrawPicture:=Self.GetSkinMaterial.FHorzSwitchBtnHoverPicture;
      end
      else
      begin
        ASwitchBtnDrawPicture:=Self.GetSkinMaterial.FHorzSwitchBtnNormalPicture;
      end;
      if ASwitchBtnDrawPicture.CurrentPictureIsEmpty then
      begin
        ASwitchBtnDrawPicture:=Self.GetSkinMaterial.FHorzSwitchBtnNormalPicture;
      end;
    end;


    if GetSkinMaterial.FIsDrawForeAndBackGround then
    begin
      //绘制背景
      ACanvas.DrawPicture(Self.GetSkinMaterial.FBackGndDrawPictureParam,
                          ABackGndPicture,
                          ADrawRect);
      //绘制前景
      AUpSpaceDrawRect:=GetUpSpaceDrawRect(APosition);
      OffsetRect(AUpSpaceDrawRect,ADrawRect.Left,ADrawRect.Top);
      ACanvas.DrawPicture(Self.GetSkinMaterial.FForeGndDrawPictureParam,
                          AForeGndPicture,
                          AUpSpaceDrawRect);
    end
    else
    begin
      if Self.FSkinSwitchBarIntf.Prop.Checked then
      begin
        //绘制前景
        ACanvas.DrawPicture(Self.GetSkinMaterial.FForeGndDrawPictureParam,
                            AForeGndPicture,
                            ADrawRect);
      end
      else
      begin
        //绘制背景
        ACanvas.DrawPicture(Self.GetSkinMaterial.FBackGndDrawPictureParam,
                            ABackGndPicture,
                            ADrawRect);
      end;
    end;



    //绘制滑动块
    ASwitchBtnRect:=GetSwitchBtnDrawRect(APosition);
    OffsetRect(ASwitchBtnRect,ADrawRect.Left,ADrawRect.Top);

    ACanvas.DrawPicture(Self.GetSkinMaterial.FSwitchBtnDrawPictureParam,
                        ASwitchBtnDrawPicture,
                        ASwitchBtnRect);
  end;
end;



{ TSkinSwitchBarDefaultMaterial }

constructor TSkinSwitchBarDefaultMaterial.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);

  FHorzSwitchBtnHoverPicture:=CreateDrawPicture('HorzSwitchBtnHoverPicture','鼠标停靠状态水平样式移动滑块图片','水平样式移动滑块所有状态图片');
  FHorzSwitchBtnNormalPicture:=CreateDrawPicture('HorzSwitchBtnNormalPicture','正常状态水平样式移动滑块图片','水平样式移动滑块所有状态图片');
  FHorzSwitchBtnDisabledPicture:=CreateDrawPicture('HorzSwitchBtnDisabledPicture','禁用状态水平样式移动滑块图片','水平样式移动滑块所有状态图片');
  FHorzSwitchBtnDownPicture:=CreateDrawPicture('HorzSwitchBtnDownPicture','按下状态水平样式移动滑块鼠标图片','水平样式移动滑块所有状态图片');

  FVertSwitchBtnHoverPicture:=CreateDrawPicture('VertSwitchBtnHoverPicture','鼠标停靠状态垂直样式移动滑块图片','垂直样式移动滑块所有状态图片');
  FVertSwitchBtnNormalPicture:=CreateDrawPicture('VertSwitchBtnNormalPicture','正常状态垂直样式移动滑块图片','垂直样式移动滑块所有状态图片');
  FVertSwitchBtnDisabledPicture:=CreateDrawPicture('VertSwitchBtnDisabledPicture','禁用状态垂直样式移动滑块图片','垂直样式移动滑块所有状态图片');
  FVertSwitchBtnDownPicture:=CreateDrawPicture('VertSwitchBtnDownPicture','鼠标按下状态垂直样式移动滑块图片','垂直样式移动滑块所有状态图片');

  FHorzBackGndPicture:=CreateDrawPicture('HorzBackGndPicture','水平样式背景图片');
  FVertBackGndPicture:=CreateDrawPicture('VertBackGndPicture','垂直样式背景图片');
  FHorzForeGndPicture:=CreateDrawPicture('HorzForeGndPicture','水平样式前景图片');
  FVertForeGndPicture:=CreateDrawPicture('VertForeGndPicture','垂直样式前景图片');


  FIsDrawForeAndBackGround:=True;

  FBackGndDrawPictureParam:=CreateDrawPictureParam('BackGndDrawPictureParam','背景图片绘制参数');
//  FBackGndDrawPictureParam.IsStretch:=True;
//  FBackGndDrawPictureParam.StretchMargins.SetBounds(5,5,5,5);

  FForeGndDrawPictureParam:=CreateDrawPictureParam('ForeGndDrawPictureParam','前景图片绘制参数');
//  FForeGndDrawPictureParam.IsStretch:=True;
//  FForeGndDrawPictureParam.StretchMargins.SetBounds(5,5,5,5);

  FSwitchBtnDrawPictureParam:=CreateDrawPictureParam('SwitchBtnDrawPictureParam','移动滑块图片绘制参数');;


  FSwitchBtnDrawSize:=0;
end;

//function TSkinSwitchBarDefaultMaterial.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
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
////    if ABTNode.NodeName='HorzSwitchBtnNormalPicture' then
////    begin
////      FHorzSwitchBtnNormalPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HorzSwitchBtnHoverPicture' then
////    begin
////      FHorzSwitchBtnHoverPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HorzSwitchBtnDisabledPicture' then
////    begin
////      FHorzSwitchBtnDisabledPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='HorzSwitchBtnDownPicture' then
////    begin
////      FHorzSwitchBtnDownPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='VertSwitchBtnNormalPicture' then
////    begin
////      FVertSwitchBtnNormalPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='VertSwitchBtnHoverPicture' then
////    begin
////      FVertSwitchBtnHoverPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='VertSwitchBtnDisabledPicture' then
////    begin
////      FVertSwitchBtnDisabledPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
////    end
////    else if ABTNode.NodeName='VertSwitchBtnDownPicture' then
////    begin
////      FVertSwitchBtnDownPicture.LoadFromDocNode(ABTNode.ConvertNode_Class);
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
//function TSkinSwitchBarDefaultMaterial.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
////var
////  ABTNode:TBTNode20;
//begin
//  Result:=False;
//
//
//  Inherited SaveToDocNode(ADocNode);
//
//
////  ABTNode:=ADocNode.AddChildNode_Class('HorzSwitchBtnNormalPicture',FHorzSwitchBtnNormalPicture.Name);
////  Self.FHorzSwitchBtnNormalPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('HorzSwitchBtnHoverPicture',FHorzSwitchBtnHoverPicture.Name);
////  Self.FHorzSwitchBtnHoverPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('HorzSwitchBtnDisabledPicture',FHorzSwitchBtnDisabledPicture.Name);
////  Self.FHorzSwitchBtnDisabledPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('HorzSwitchBtnDownPicture',FHorzSwitchBtnDownPicture.Name);
////  Self.FHorzSwitchBtnDownPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////
////  ABTNode:=ADocNode.AddChildNode_Class('VertSwitchBtnNormalPicture',FVertSwitchBtnNormalPicture.Name);
////  Self.FVertSwitchBtnNormalPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('VertSwitchBtnHoverPicture',FVertSwitchBtnHoverPicture.Name);
////  Self.FVertSwitchBtnHoverPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('VertSwitchBtnDisabledPicture',FVertSwitchBtnDisabledPicture.Name);
////  Self.FVertSwitchBtnDisabledPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
////  ABTNode:=ADocNode.AddChildNode_Class('VertSwitchBtnDownPicture',FVertSwitchBtnDownPicture.Name);
////  Self.FVertSwitchBtnDownPicture.SaveToDocNode(ABTNode.ConvertNode_Class);
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

destructor TSkinSwitchBarDefaultMaterial.Destroy;
begin

  FreeAndNil(FHorzSwitchBtnHoverPicture);
  FreeAndNil(FHorzSwitchBtnNormalPicture);
  FreeAndNil(FHorzSwitchBtnDisabledPicture);
  FreeAndNil(FHorzSwitchBtnDownPicture);

  FreeAndNil(FVertSwitchBtnHoverPicture);
  FreeAndNil(FVertSwitchBtnNormalPicture);
  FreeAndNil(FVertSwitchBtnDisabledPicture);
  FreeAndNil(FVertSwitchBtnDownPicture);

  FreeAndNil(FSwitchBtnDrawPictureParam);
  FreeAndNil(FBackGndDrawPictureParam);
  FreeAndNil(FForeGndDrawPictureParam);

  FreeAndNil(FHorzBackGndPicture);
  FreeAndNil(FVertBackGndPicture);
  FreeAndNil(FHorzForeGndPicture);
  FreeAndNil(FVertForeGndPicture);

  inherited;
end;


procedure TSkinSwitchBarDefaultMaterial.SetBackGndDrawPictureParam(const Value: TDrawPictureParam);
begin
  FBackGndDrawPictureParam.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetForeGndDrawPictureParam(
  const Value: TDrawPictureParam);
begin
  FForeGndDrawPictureParam.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetHorzBackGndPicture(const Value: TDrawPicture);
begin
  FHorzBackGndPicture.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetVertBackGndPicture(const Value: TDrawPicture);
begin
  FVertBackGndPicture.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetHorzForeGndPicture(const Value: TDrawPicture);
begin
  FHorzForeGndPicture.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetHorzSwitchBtnDisabledPicture(const Value: TDrawPicture);
begin
  FHorzSwitchBtnDisabledPicture.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetHorzSwitchBtnDownPicture(const Value: TDrawPicture);
begin
  FHorzSwitchBtnDownPicture.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetHorzSwitchBtnHoverPicture(const Value: TDrawPicture);
begin
  FHorzSwitchBtnHoverPicture.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetHorzSwitchBtnNormalPicture(const Value: TDrawPicture);
begin
  FHorzSwitchBtnNormalPicture.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetIsDrawForeAndBackGround(
  const Value: Boolean);
begin
  if FIsDrawForeAndBackGround<>Value then
  begin
    FIsDrawForeAndBackGround := Value;
    DoChange;
  end;
end;

procedure TSkinSwitchBarDefaultMaterial.SetSwitchBtnDrawSize(
  const Value: Integer);
begin
  if FSwitchBtnDrawSize<>Value then
  begin
    FSwitchBtnDrawSize := Value;
    DoChange;
  end;
end;

procedure TSkinSwitchBarDefaultMaterial.SetSwitchBtnDrawPictureParam(
  const Value: TDrawPictureParam);
begin
  FSwitchBtnDrawPictureParam.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetVertForeGndPicture(const Value: TDrawPicture);
begin
  FVertForeGndPicture.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetVertSwitchBtnDisabledPicture(const Value: TDrawPicture);
begin
  FVertSwitchBtnDisabledPicture.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetVertSwitchBtnDownPicture(const Value: TDrawPicture);
begin
  FVertSwitchBtnDownPicture.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetVertSwitchBtnHoverPicture(const Value: TDrawPicture);
begin
  FVertSwitchBtnHoverPicture.Assign(Value);
end;

procedure TSkinSwitchBarDefaultMaterial.SetVertSwitchBtnNormalPicture(const Value: TDrawPicture);
begin
  FVertSwitchBtnNormalPicture.Assign(Value);
end;







{ TSwitchBarProperties }

procedure TSwitchBarProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
  FOrientation:=TSwitchBarProperties(Src).FOrientation;
  FMax:=TSwitchBarProperties(Src).FMax;
  FMin:=TSwitchBarProperties(Src).FMin;
  FPosition:=TSwitchBarProperties(Src).FPosition;
  FDrawPosition:=TSwitchBarProperties(Src).FDrawPosition;
end;

constructor TSwitchBarProperties.Create(ASkinControl:TControl);
begin
  FSwitchBtnState:=TSkinSwitchBarBtnState.Create;
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinSwitchBar,Self.FSkinSwitchBarIntf) then
  begin
    ShowException('This Component Do not Support ISkinSwitchBar Interface');
  end
  else
  begin
    FOrientation:=srHorizontal;
    FMin:=0;
    FMax:=1;
    FPosition:=0;
    FDrawPosition:=0;

    case FOrientation of
      srHorizontal:
      begin
        FSkinControlIntf.Width:=44;
        FSkinControlIntf.Height:=22;
      end;
      srVertical:
      begin
        FSkinControlIntf.Width:=44;
        FSkinControlIntf.Height:=120;
      end;
    end;
  end;
end;

destructor TSwitchBarProperties.Destroy;
begin
  FreeAndNil(FSwitchBtnState);
  inherited;
end;

procedure TSwitchBarProperties.DoChange;
begin
  if Assigned(Self.FSkinSwitchBarIntf.OnChange) then
  begin
    Self.FSkinSwitchBarIntf.OnChange(Self);
  end;
end;

procedure TSwitchBarProperties.SetOrientation(const Value: TSwitchBarOrientation);
begin
  if Value <> FOrientation then
  begin
    FOrientation := Value;
    if not (csLoading in FSkinControl.ComponentState) then
      FSkinControlIntf.SetBounds(FSkinControlIntf.Left, FSkinControlIntf.Top, FSkinControlIntf.Height, FSkinControlIntf.Width);
  end;
end;

procedure TSwitchBarProperties.SetChecked(const Value: Boolean);
begin
  if Checked<>Value then
  begin
    if Value then
    begin
      Self.Position:=Self.Max;
    end
    else
    begin
      Self.Position:=Self.Min;
    end;
  end;
end;

procedure TSwitchBarProperties.SetDrawChecked(const Value: Boolean);
begin
  if DrawChecked<>Value then
  begin
    if Value then
    begin
      Self.FDrawPosition:=Self.Max;
    end
    else
    begin
      Self.FDrawPosition:=Self.Min;
    end;
  end;
end;

procedure TSwitchBarProperties.SetMax(const Value: Double);
begin
  SetParams(FPosition, FMin, Value);
end;

procedure TSwitchBarProperties.SetMin(const Value: Double);
begin
  SetParams(FPosition, Value, FMax);
end;

procedure TSwitchBarProperties.SetParams(APosition, AMin, AMax: Double);
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

procedure TSwitchBarProperties.SetDrawParams(APosition, AMin, AMax: Double);
begin

  if APosition < AMin then
  begin
    APosition := AMin;
  end;

  if APosition > AMax then
  begin
    APosition := AMax;
  end;

  if (FDrawPosition <> APosition) or (FMin <> AMin) or (FMax <> AMax)  then
  begin
    FMin := AMin;
    FMax := AMax;

    FDrawPosition := APosition;

    Invalidate;
  end;

end;

procedure TSwitchBarProperties.SetPosition(const Value: Double);
begin
  SetParams(Value, FMin, FMax);
end;

procedure TSwitchBarProperties.SetDrawPosition(const Value: Double);
begin
  SetDrawParams(Value, FMin, FMax);
end;

procedure TSwitchBarProperties.SetStaticChecked(const Value: Boolean);
begin
  if Checked<>Value then
  begin
    if Value then
    begin
      Self.FPosition:=Self.Max;
    end
    else
    begin
      Self.FPosition:=Self.Min;
    end;
  end;
end;

function TSwitchBarProperties.GetChecked: Boolean;
begin
  if Self.Position=Self.Max then
  begin
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

function TSwitchBarProperties.GetComponentClassify: String;
begin
  Result:='SkinSwitchBar';
end;

function TSwitchBarProperties.GetDrawChecked: Boolean;
begin
  if Self.FDrawPosition=Self.Max then
  begin
    Result:=True;
  end
  else
  begin
    Result:=False;
  end;
end;

function TSwitchBarProperties.GetSwitchBtnState: TSkinSwitchBarBtnState;
begin
  if FSwitchBtnState=nil then
  begin
    FSwitchBtnState:=TSkinSwitchBarBtnState.Create;
  end;
  Result:=Self.FSwitchBtnState;
end;



{ TSkinSwitchBar }

function TSkinSwitchBar.Material:TSkinSwitchBarDefaultMaterial;
begin
  Result:=TSkinSwitchBarDefaultMaterial(SelfOwnMaterial);
end;

function TSkinSwitchBar.SelfOwnMaterialToDefault:TSkinSwitchBarDefaultMaterial;
begin
  Result:=TSkinSwitchBarDefaultMaterial(SelfOwnMaterial);
end;

function TSkinSwitchBar.CurrentUseMaterialToDefault:TSkinSwitchBarDefaultMaterial;
begin
  Result:=TSkinSwitchBarDefaultMaterial(CurrentUseMaterial);
end;

function TSkinSwitchBar.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TSwitchBarProperties;
end;

function TSkinSwitchBar.GetSwitchBarProperties: TSwitchBarProperties;
begin
  Result:=TSwitchBarProperties(Self.FProperties);
end;

procedure TSkinSwitchBar.StayClick;
begin
  GetSwitchBarProperties.Checked:=Not GetSwitchBarProperties.Checked;
  Inherited;
end;

procedure TSkinSwitchBar.SetSwitchBarProperties(Value: TSwitchBarProperties);
begin
  Self.FProperties.Assign(Value);
end;

function TSkinSwitchBar.GetOnChange: TNotifyEvent;
begin
  Result:=Self.FOnChange;
end;

procedure TSkinSwitchBar.DoCustomSkinMaterialChange(Sender: TObject);
begin
  if not (csReading in Self.ComponentState)
    and not (csLoading in Self.ComponentState) then
  begin
    Self.GetSwitchBarProperties.AdjustAutoSizeBounds;
  end;
  Inherited;
end;



end.

