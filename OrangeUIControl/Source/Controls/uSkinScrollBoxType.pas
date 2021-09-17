//convert pas to utf8 by ¥

/// <summary>
///   <para>
///     滚动框
///   </para>
///   <para>
///     Scroll Box
///   </para>
/// </summary>
unit uSkinScrollBoxType;

interface
{$I FrameWork.inc}

uses
  Classes,
  Types,
  Math,
  SysUtils,
  uSkinPublic,
  uGraphicCommon,
  {$IFDEF VCL}
  Messages,
  Windows,
  Controls,
  uSkinWindowsControl,
//  uSkinWindowsScrollControl,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Controls,
  uSkinFireMonkeyControl,
  uSkinFireMonkeyScrollControl,
  {$ENDIF}
  uFuncCommon,
  uBaseLog,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uSkinScrollBarType,
  uSkinScrollControlType,
  uSkinScrollBoxContentType,
  uComponentType,
  uSkinMaterial,
  uDrawEngine,
  uDrawPicture,
  uDrawTextParam,
  uDrawPictureParam;


const
  IID_ISkinScrollBox:TGUID='{15422D75-667A-4DBF-9343-FB70547AF10D}';

type
  TScrollBoxProperties=class;




  /// <summary>
  ///   <para>
  ///     滚动框接口
  ///   </para>
  ///   <para>
  ///     Interface of ScrollBar
  ///   </para>
  /// </summary>
  ISkinScrollBox=interface//(ISkinScrollControl)
  ['{15422D75-667A-4DBF-9343-FB70547AF10D}']
    //内容控件
    function GetContent:TChildControl;
    function GetContentControlIntf:ISkinControl;

    function GetScrollBoxProperties:TScrollBoxProperties;
    property Properties:TScrollBoxProperties read GetScrollBoxProperties;
    property Prop:TScrollBoxProperties read GetScrollBoxProperties;
  end;





  /// <summary>
  ///   <para>
  ///     滚动框类型
  ///   </para>
  ///   <para>
  ///     Scroll Box type
  ///   </para>
  /// </summary>
  TScrollBoxType=(
                  /// <summary>
                  ///   垂直滚动框
                  ///   <para>
                  ///   Vertical  Scroll Box
                  ///   </para>
                  /// </summary>
                  sbtVert,
                  /// <summary>
                  ///   水平滚动框
                  ///   <para>
                  ///   Horizontal  Scroll Box
                  ///   </para>
                  /// </summary>
                  sbtHorz,
                  /// <summary>
                  ///   水平垂直滚动框
                  ///   <para>
                  ///   Horizontal and vertical Scroll Box
                  ///   </para>
                  /// </summary>
                  sbtBoth
                  );






  //
  /// <summary>
  ///   <para>
  ///     滚动框属性
  ///   </para>
  ///   <para>
  ///     ScrollBox properties
  ///   </para>
  /// </summary>
  TScrollBoxProperties=class(TScrollControlProperties)
  protected
    FScrollBoxType:TScrollBoxType;

    FSkinScrollBoxIntf:ISkinScrollBox;



    //赋值
    procedure AssignProperties(Src:TSkinControlProperties);override;
    //获取分类名称
    function GetComponentClassify:String;override;

    //内容尺寸属性更改
    procedure DoContentWidthChange;override;
    procedure DoContentHeightChange;override;


    //获取客户区矩形
    function GetClientRect:TRectF;override;

    {$IFDEF FMX}
  protected
    //处理虚拟键盘弹起
    FVirtualKeyboardHeight:Integer;
    procedure SetVirtualKeyboardHeight(Value:Integer);
  public
    property VirtualKeyboardHeight:Integer read FVirtualKeyboardHeight write SetVirtualKeyboardHeight;
    {$ENDIF}



  protected
    //控件手势管理者位置更改,相应更改滚动条的位置
    //滚动条位置更改,更改Content的坐标
    procedure DoVert_InnerPositionChange(Sender:TObject);override;
    procedure DoHorz_InnerPositionChange(Sender:TObject);override;

  public
    constructor Create(ASkinControl:TControl);override;
    destructor Destroy;override;
  published

    /// <summary>
    ///   <para>
    ///     内容宽度(-1表示自动计算)
    ///   </para>
    ///   <para>
    ///     Content width(-1 means calculate aotumatically)
    ///   </para>
    /// </summary>
    property ContentWidth;
    //
    /// <summary>
    ///   内容高度(-1表示自动计算)
    ///   <para>
    ///     Content height(-1 means calculate aotumatically)
    ///   </para>
    /// </summary>
    property ContentHeight;


    //
    property ScrollBarEmbeddedType;



    //
    /// <summary>
    ///   <para>
    ///     垂直滚动条是否显示
    ///   </para>
    ///   <para>
    ///     Whether display vertical scrollbar
    ///   </para>
    /// </summary>
    property VertScrollBarShowType;
    //
    /// <summary>
    ///   <para>
    ///     水平滚动条是否显示
    ///   </para>
    ///   <para>
    ///     Whether display horizontal scrollbar
    ///   </para>
    /// </summary>
    property HorzScrollBarShowType;




    /// <summary>
    ///   <para>
    ///     滚动框类型
    ///   </para>
    ///   <para>
    ///     ScrollBox type
    ///   </para>
    /// </summary>
    property ScrollBoxType:TScrollBoxType read FScrollBoxType write FScrollBoxType;
  end;









  /// <summary>
  ///   <para>
  ///     滚动框素材基类
  ///   </para>
  ///   <para>
  ///     Bass class of ScrollBox material
  ///   </para>
  /// </summary>
  TSkinScrollBoxMaterial=class(TSkinScrollControlDefaultMaterial)
  end;
  TSkinScrollBoxType=class(TSkinScrollControlDefaultType)
  private
    FSkinScrollBoxIntf:ISkinScrollBox;
  protected
    procedure SizeChanged;override;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  end;







  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinScrollBoxDefaultMaterial=class(TSkinScrollBoxMaterial);
  TSkinScrollBoxDefaultType=TSkinScrollBoxType;




  TSkinScrollBox=class(TSkinScrollControl,
                        ISkinScrollControl,ISkinScrollBox)
  private
    function GetScrollBoxProperties:TScrollBoxProperties;
    procedure SetScrollBoxProperties(Value:TScrollBoxProperties);
  protected

    //内容控件
    function GetContent:TChildControl;
    function GetContentControlIntf:ISkinControl;

  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    function SelfOwnMaterialToDefault:TSkinScrollBoxDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinScrollBoxDefaultMaterial;
    function Material:TSkinScrollBoxDefaultMaterial;
  public
  public
    procedure SyncContentHeight;
    constructor Create(AOwner:TComponent);override;
  public
    property Prop:TScrollBoxProperties read GetScrollBoxProperties write SetScrollBoxProperties;
  public
    //内容控件
    property Content:TChildControl read GetContent;
  published

    //属性(必须在VertScrollBar和HorzScrollBar之前)
    property Properties:TScrollBoxProperties read GetScrollBoxProperties write SetScrollBoxProperties;


    //垂直滚动条
    property VertScrollBar;
    //水平滚动条
    property HorzScrollBar;


  end;



  {$IFDEF VCL}
  TSkinWinScrollBox=class(TSkinScrollBox)
  end;
  {$ENDIF VCL}


implementation







{ TScrollBoxProperties }

constructor TScrollBoxProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinScrollBox,Self.FSkinScrollBoxIntf) then
  begin
    ShowException('This Component Do not Support ISkinScrollBox Interface');
  end
  else
  begin


    Self.FSkinControlIntf.Width:=200;
    Self.FSkinControlIntf.Height:=200;

    FScrollBoxType:=sbtVert;

    {$IFDEF FMX}
    FVirtualKeyboardHeight:=0;
    {$ENDIF}

  end;
end;

destructor TScrollBoxProperties.Destroy;
begin
  inherited;
end;

//获取客户区矩形
function TScrollBoxProperties.GetClientRect:TRectF;
begin
  Result:=Inherited GetClientRect;
  {$IFDEF FMX}
  Result.Bottom:=Result.Bottom-FVirtualKeyboardHeight;
  {$ENDIF}
end;

{$IFDEF FMX}
procedure TScrollBoxProperties.SetVirtualKeyboardHeight(Value:Integer);
begin
  if Self.FVirtualKeyboardHeight<>Value then
  begin
    FVirtualKeyboardHeight:=Value;
    Self.UpdateScrollBars;
  end;
end;
{$ENDIF}

procedure TScrollBoxProperties.DoContentHeightChange;
begin
  if (Self.FScrollBoxType<>sbtHorz) and (FSkinScrollBoxIntf.GetContentControlIntf<>nil) then
  begin
    FSkinScrollBoxIntf.GetContentControlIntf.Height:=ControlSize(FSkinScrollBoxIntf.Prop.ContentHeight);
  end;
  inherited;
end;

procedure TScrollBoxProperties.DoContentWidthChange;
begin
  if (Self.FScrollBoxType<>sbtVert) and (FSkinScrollBoxIntf.GetContentControlIntf<>nil) then
  begin
    FSkinScrollBoxIntf.GetContentControlIntf.Width:=ControlSize(FSkinScrollBoxIntf.Prop.ContentWidth);
  end;
  inherited;
end;

procedure TScrollBoxProperties.DoHorz_InnerPositionChange(Sender: TObject);
begin
  inherited;

  if (Self.FSkinScrollBoxIntf.GetContent<>nil) then
  begin
    SetControlLeft(TControl(Self.FSkinScrollBoxIntf.GetContent),ControlSize(-Self.GetLeftDrawOffset));
  end;
end;

procedure TScrollBoxProperties.DoVert_InnerPositionChange(Sender: TObject);
begin
  inherited;

//  uBaseLog.OutputDebugString('DoVert_InnerPositionChange '+FloatToStr(-Self.GetTopDrawOffset));

  if (Self.FSkinScrollBoxIntf.GetContent<>nil) then
  begin
    SetControlTop(TControl(Self.FSkinScrollBoxIntf.GetContent),ControlSize(-Self.GetTopDrawOffset));
//    {$IFDEF FMX}
//    TControl(Self.FSkinScrollBoxIntf.GetContent).Position.Y:=ControlSize(-Self.GetTopDrawOffset);
//    {$ENDIF}
//    {$IFDEF VCL}
//    TControl(Self.FSkinScrollBoxIntf.GetContent).Top:=ControlSize(-Self.GetTopDrawOffset);
//    {$ENDIF}
  end;


end;

function TScrollBoxProperties.GetComponentClassify: String;
begin
  Result:='SkinScrollBox';
end;

procedure TScrollBoxProperties.AssignProperties(Src: TSkinControlProperties);
begin
  inherited;
end;


{ TSkinScrollBoxType }

function TSkinScrollBoxType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinScrollBox,Self.FSkinScrollBoxIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinScrollBox Interface');
    end;
  end;
end;

procedure TSkinScrollBoxType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinScrollBoxIntf:=nil;
end;

procedure TSkinScrollBoxType.SizeChanged;
begin

//  uBaseLog.HandleException('TSkinScrollBoxType.SizeChanged Begin');

  //ScrollBox改变尺寸的时候,要改ScrollBoxContent的尺寸
  //但是反过来,Content尺寸改变的时候也要改Box的尺寸
  //所以要优化一下

  if  (FSkinScrollBoxIntf<>nil)
    and (Self.FSkinScrollBoxIntf.GetContentControlIntf<>nil) then
  begin

      if (Self.FSkinScrollBoxIntf.Prop.ScrollBoxType=sbtVert) then
      begin
        //垂直滚动条,设置固定宽度
        Self.FSkinScrollBoxIntf.GetContentControlIntf.Left:=0;

        Self.FSkinScrollBoxIntf.GetContentControlIntf.Width:=
                  ControlSize(RectWidthF(Self.FSkinScrollBoxIntf.Prop.GetClientRect))
                  ;

      end;

      if (Self.FSkinScrollBoxIntf.Prop.ScrollBoxType=sbtHorz) then
      begin
        //水平滚动条,设置固定高度
        Self.FSkinScrollBoxIntf.GetContentControlIntf.Top:=0;
        Self.FSkinScrollBoxIntf.GetContentControlIntf.Height:=
                  ControlSize(RectHeightF(Self.FSkinScrollBoxIntf.Prop.GetClientRect))
                  ;
      end;


  end;

//  uBaseLog.HandleException('TSkinScrollBoxType.SizeChanged End');



  //然后再UpdateScrollBar
  Inherited;
end;




{ TSkinScrollBox }


constructor TSkinScrollBox.Create(AOwner:TComponent);
begin
  Inherited;

  {$IFDEF FMX}
  Self.ClipChildren:=True;
  {$ENDIF}

end;

function TSkinScrollBox.Material:TSkinScrollBoxDefaultMaterial;
begin
  Result:=TSkinScrollBoxDefaultMaterial(SelfOwnMaterial);
end;

function TSkinScrollBox.SelfOwnMaterialToDefault:TSkinScrollBoxDefaultMaterial;
begin
  Result:=TSkinScrollBoxDefaultMaterial(SelfOwnMaterial);
end;

function TSkinScrollBox.CurrentUseMaterialToDefault:TSkinScrollBoxDefaultMaterial;
begin
  Result:=TSkinScrollBoxDefaultMaterial(CurrentUseMaterial);
end;

function TSkinScrollBox.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TScrollBoxProperties;
end;

function TSkinScrollBox.GetScrollBoxProperties: TScrollBoxProperties;
begin
  Result:=TScrollBoxProperties(Self.FProperties);
end;

procedure TSkinScrollBox.SetScrollBoxProperties(Value: TScrollBoxProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinScrollBox.SyncContentHeight;
begin
  if GetContent<>nil then
  begin
    TControl(Self.GetContent).Height:=GetSuitScrollContentHeight(TParentControl(GetContent));
  end;

end;

function TSkinScrollBox.GetContent: TChildControl;
begin

  Result:=nil;

  if GetChildControlCount>0 then
  begin
    Result:=Self.GetChildControl(0);
  end;

end;

function TSkinScrollBox.GetContentControlIntf: ISkinControl;
begin
  Result:=nil;
  if GetContent<>nil then
  begin
    Result:=GetContent as ISkinControl;
  end;
end;




end.

