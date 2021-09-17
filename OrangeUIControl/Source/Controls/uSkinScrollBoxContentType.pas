//convert pas to utf8 by ¥

/// <summary>
///   滚动框的内容面板
/// </summary>
unit uSkinScrollBoxContentType;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  Types,
  Math,
//  Forms,
  uSkinPublic,
  uGraphicCommon,
  {$IFDEF VCL}
  Messages,
  Windows,
  Controls,
  uSkinWindowsControl,
//  uSkinWindowsScrollControl,
//  uSkinWindowsControl,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Forms,
  FMX.Controls,
  uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl,
//  uSkinFireMonkeyControl,
  {$ENDIF}
  uBaseLog,
  uBaseSkinControl,
  uFuncCommon,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uSkinScrollBarType,
//  uSkinControlType,
  uComponentType,
  uSkinMaterial,
  uDrawEngine,
  uDrawPicture,
  uDrawTextParam,
  uDrawPictureParam;


const
  IID_ISkinScrollBoxContent:TGUID='{15422D75-667A-4DBF-9343-FB70547AF10E}';

type
  TScrollBoxContentProperties=class;





  /// <summary>
  ///   滚动框内容面板接口
  /// </summary>
  ISkinScrollBoxContent=interface//(ISkinScrollControl)
  ['{15422D75-667A-4DBF-9343-FB70547AF10E}']

    function GetScrollBox:TControl;
    function GetScrollBoxControlIntf:ISkinControl;

    function GetScrollBoxContentProperties:TScrollBoxContentProperties;
    property Properties:TScrollBoxContentProperties read GetScrollBoxContentProperties;
    property Prop:TScrollBoxContentProperties read GetScrollBoxContentProperties;
  end;







  /// <summary>
  ///   滚动框内容面板属性
  /// </summary>
  TScrollBoxContentProperties=class(TSkinControlProperties)
  protected
    FSkinScrollBoxContentIntf:ISkinScrollBoxContent;
  protected
    //赋值
    procedure AssignProperties(Src:TSkinControlProperties);override;
    //获取分类名称
    function GetComponentClassify:String;override;
  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  end;










  /// <summary>
  ///   滚动框内容面板素材基类
  /// </summary>
  TSkinScrollBoxContentMaterial=class(TSkinControlMaterial)
  end;
  TSkinScrollBoxContentType=class(TSkinControlType)
  protected
    FSkinScrollBoxContentIntf:ISkinScrollBoxContent;

//    procedure CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
//    procedure CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);override;
//    procedure CustomMouseMove(Shift: TShiftState; X, Y: Double);override;
//    function CustomMouseWheel(Shift: TShiftState; WheelDelta: Integer;X, Y: Double):Boolean;override;
//    procedure CustomMouseLeave;override;
  protected
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
    //
    procedure SizeChanged;override;
  end;








  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinScrollBoxContentDefaultMaterial=class(TSkinScrollBoxContentMaterial);
  TSkinScrollBoxContentDefaultType=TSkinScrollBoxContentType;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinScrollBoxContent=class(TBaseSkinControl,
                              ISkinScrollBoxContent)
  private
    function GetScrollBoxContentProperties:TScrollBoxContentProperties;
    procedure SetScrollBoxContentProperties(Value:TScrollBoxContentProperties);
  protected
    procedure Loaded;override;
    //获取ScrollBox,一定是Content的Parent
    function GetScrollBox:TControl;
    function GetScrollBoxControlIntf:ISkinControl;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    constructor Create(AOwner:TComponent);override;
  public
    function SelfOwnMaterialToDefault:TSkinScrollBoxContentDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinScrollBoxContentDefaultMaterial;
    function Material:TSkinScrollBoxContentDefaultMaterial;
  public
    property Prop:TScrollBoxContentProperties read GetScrollBoxContentProperties write SetScrollBoxContentProperties;
  public
    procedure SyncContentHeight;
    //所属的滚动框
    property ScrollBox:TControl read GetScrollBox;
  published
    //属性
    property Properties:TScrollBoxContentProperties read GetScrollBoxContentProperties write SetScrollBoxContentProperties;
  end;


  {$IFDEF VCL}
  TSkinWinScrollBoxContent=class(TSkinScrollBoxContent)
  end;
  {$ENDIF VCL}




implementation



uses
  uSkinScrollBoxType;




{ TScrollBoxContentProperties }

constructor TScrollBoxContentProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinScrollBoxContent,Self.FSkinScrollBoxContentIntf) then
  begin
    ShowException('This Component Do not Support ISkinScrollBoxContent Interface');
  end
  else
  begin
  end;
end;

destructor TScrollBoxContentProperties.Destroy;
begin
  inherited;
end;

function TScrollBoxContentProperties.GetComponentClassify: String;
begin
  Result:='SkinScrollBoxContent';
end;

procedure TScrollBoxContentProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;


{ TSkinScrollBoxContentType }

function TSkinScrollBoxContentType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinScrollBoxContent,Self.FSkinScrollBoxContentIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinScrollBoxContent Interface');
    end;
  end;
end;

procedure TSkinScrollBoxContentType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinScrollBoxContentIntf:=nil;
end;

//procedure TSkinScrollBoxContentType.CustomMouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
//begin
//  inherited;
//
//  //将鼠标消息传递给Box
//  if (Self.FSkinScrollBoxContentIntf.GetScrollBoxControlIntf<>nil) then
//  begin
//     Self.FSkinScrollBoxContentIntf.GetScrollBoxControlIntf.GetSkinControlType.CustomMouseDown(
//        Button,
//        Shift,
//        //因为要惯性滚动,所以使用绝对坐标
//        FMouseDownAbsolutePt.X,
//        FMouseDownAbsolutePt.Y
//        );
//  end;
//
//end;
//
//procedure TSkinScrollBoxContentType.CustomMouseLeave;
//begin
//  inherited;
//
//  //将鼠标消息传递给Box
//  if Self.FSkinScrollBoxContentIntf.GetScrollBoxControlIntf<>nil then
//  begin
//     Self.FSkinScrollBoxContentIntf.GetScrollBoxControlIntf.GetSkinControlType.CustomMouseLeave;
//  end;
//
//end;
//
//procedure TSkinScrollBoxContentType.CustomMouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Double);
//begin
//  inherited;
//
//  //将鼠标消息传递给Box
//  if Self.FSkinScrollBoxContentIntf.GetScrollBoxControlIntf<>nil then
//  begin
//     Self.FSkinScrollBoxContentIntf.GetScrollBoxControlIntf.GetSkinControlType.CustomMouseUp(
//        Button,
//        Shift,
//        //因为要惯性滚动,所以使用绝对坐标
//        FMouseUpAbsolutePt.X,
//        FMouseUpAbsolutePt.Y
//     );
//  end;
//
//
//
//
//  //问题:点击ScrollBox就会弹出虚拟键盘,
//  //解决方案:
//  //滑动ScrollBox距离超过5个像素的时候
//  //那么将Screen.ActiveForm.Focused设置为空就能隐藏键盘
//
//  if (Self.FMouseDownAbsolutePt.X<>0)
//    and (Abs(Self.FMouseDownAbsolutePt.X-Self.FMouseMoveAbsolutePt.X)>5)
//    and (Abs(Self.FMouseDownAbsolutePt.Y-Self.FMouseMoveAbsolutePt.Y)>5) then
//  begin
//
//      //取消焦点
//      //当在ScrollBox上面关闭了虚拟键盘
//      if (Screen.ActiveForm<>nil)
//        and (Screen.ActiveForm.Focused<>nil) then
//      begin
//        OutputDebugString('TSkinScrollBoxContentType.CustomMouseUp Screen.ActiveForm.Focused:=nil');
//        //那么取消焦点,避免滑动的时候又弹出来了
//        Screen.ActiveForm.Focused:=nil;
//      end;
//
//  end;
//
//
//end;
//
//procedure TSkinScrollBoxContentType.CustomMouseMove(Shift: TShiftState; X, Y: Double);
//begin
//  inherited;
//
//  //将鼠标消息传递给Box
//  if Self.FSkinScrollBoxContentIntf.GetScrollBoxControlIntf<>nil then
//  begin
//     Self.FSkinScrollBoxContentIntf.GetScrollBoxControlIntf.GetSkinControlType.CustomMouseMove(Shift,
//         //因为要惯性滚动,所以使用绝对坐标
//         FMouseMoveAbsolutePt.X,
//         FMouseMoveAbsolutePt.Y
//          );
//  end;
//end;
//
//function TSkinScrollBoxContentType.CustomMouseWheel(Shift: TShiftState; WheelDelta: Integer;X, Y: Double):Boolean;
//begin
//  inherited;
//
//
//  //将鼠标消息传递给Box
//  if Self.FSkinScrollBoxContentIntf.GetScrollBoxControlIntf<>nil then
//  begin
//    Self.FSkinScrollBoxContentIntf.GetScrollBoxControlIntf.GetSkinControlType.CustomMouseWheel(Shift,WheelDelta,X,Y);
//  end;
//end;

function TSkinScrollBoxContentType.CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;
begin
  //设计时绘制虚线框和控件名称
  if (csDesigning in Self.FSkinControl.ComponentState) then
  begin
    ACanvas.DrawDesigningRect(ADrawRect,GlobalScrollBoxContentDesignRectBorderColor);
  end;

end;

procedure TSkinScrollBoxContentType.SizeChanged;
begin
  Inherited;


  //ScrollBox改变尺寸的时候,要改ScrollBoxContent的尺寸
  //但是反过来,Content尺寸改变的时候也要改Box的尺寸
  //所以要优化一下

//  uBaseLog.HandleException('TSkinScrollBoxContentType.SizeChanged Begin');


  //设置ScrollBox的ContentWidth和ContentHeight
  if Self.FSkinScrollBoxContentIntf.GetScrollBox<>nil then
  begin

      if (Self.FSkinScrollBoxContentIntf.GetScrollBox as ISkinScrollBox).Properties.ScrollBoxType<>sbtVert then
      begin
        //不是垂直滚动条,设置宽度,因为垂直滚动条的宽度是固定的
        (Self.FSkinScrollBoxContentIntf.GetScrollBox as ISkinScrollBox).Properties.ContentWidth:=
              Self.FSkinControlIntf.Width;
      end;

      if (Self.FSkinScrollBoxContentIntf.GetScrollBox as ISkinScrollBox).Properties.ScrollBoxType<>sbtHorz then
      begin
        //不是水平滚动条,设置高度,因为水平滚动条的高度是固定的
        (Self.FSkinScrollBoxContentIntf.GetScrollBox as ISkinScrollBox).Properties.ContentHeight:=
              Self.FSkinControlIntf.Height;
      end;

  end;


//  uBaseLog.HandleException('TSkinScrollBoxContentType.SizeChanged End');

end;



{ TSkinScrollBoxContent }

constructor TSkinScrollBoxContent.Create(AOwner:TComponent);
begin
  Inherited;
end;

function TSkinScrollBoxContent.Material:TSkinScrollBoxContentDefaultMaterial;
begin
  Result:=TSkinScrollBoxContentDefaultMaterial(SelfOwnMaterial);
end;

function TSkinScrollBoxContent.SelfOwnMaterialToDefault:TSkinScrollBoxContentDefaultMaterial;
begin
  Result:=TSkinScrollBoxContentDefaultMaterial(SelfOwnMaterial);
end;

function TSkinScrollBoxContent.CurrentUseMaterialToDefault:TSkinScrollBoxContentDefaultMaterial;
begin
  Result:=TSkinScrollBoxContentDefaultMaterial(CurrentUseMaterial);
end;

function TSkinScrollBoxContent.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TScrollBoxContentProperties;
end;

function TSkinScrollBoxContent.GetScrollBoxContentProperties: TScrollBoxContentProperties;
begin
  Result:=TScrollBoxContentProperties(Self.FProperties);
end;

procedure TSkinScrollBoxContent.SetScrollBoxContentProperties(Value: TScrollBoxContentProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinScrollBoxContent.SyncContentHeight;
begin
  Self.Height:=GetSuitScrollContentHeight(Self);
end;

function TSkinScrollBoxContent.GetScrollBox: TControl;
begin
  Result:=nil;
  if Parent is TSkinScrollBox then
  begin
    Result:=TControl(Parent);
  end;
end;

function TSkinScrollBoxContent.GetScrollBoxControlIntf: ISkinControl;
begin
  Result:=nil;
  if Parent is TSkinScrollBox then
  begin
    Result:=Parent as ISkinControl;
  end;
end;

procedure TSkinScrollBoxContent.Loaded;
begin
  Inherited;

  //设计时是Client
  //运行时恢复
  if not (csDesigning in Self.ComponentState) then
  begin

    {$IFDEF FMX}
    Align:=TAlignLayout.{$IF CompilerVersion >= 34.0}None{$ELSE}alNone{$IFEND};
    {$ELSE}
    Align:=TAlignLayout.alNone;
    {$ENDIF};
  end;


end;



end.
