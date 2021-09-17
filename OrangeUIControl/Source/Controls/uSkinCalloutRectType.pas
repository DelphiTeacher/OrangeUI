//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     气泡框
///   </para>
///   <para>
///     Check Box
///   </para>
/// </summary>
unit uSkinCalloutRectType;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  Types,

  {$IFDEF VCL}
  Messages,
  Windows,
  Controls,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  FMX.Controls,
  {$ENDIF}

  uBaseLog,
  uFuncCommon,
  uSkinItems,
  uBaseSkinControl,
  uGraphicCommon,
  uSkinMaterial,
  uBinaryTreeDoc,
  uSkinBufferBitmap,
  uDrawCanvas,
  uComponentType,
  uDrawEngine,
  uDrawPicture,
  uDrawParam,
  uDrawTextParam,
  uSkinRegManager,
  uDrawPathParam,
  uDrawRectParam,
  uDrawPictureParam;







const
  IID_ISkinCalloutRect:TGUID='{9FC3C526-8D34-482C-A69B-4FAD6544C1B1}';

type
  TCalloutRectProperties=class;





  /// <summary>
  ///   <para>
  ///     气泡框接口
  ///   </para>
  ///   <para>
  ///     Interface of CalloutRect
  ///   </para>
  /// </summary>
  ISkinCalloutRect=interface//(ISkinControl)
    ['{9FC3C526-8D34-482C-A69B-4FAD6544C1B1}']
    function GetCalloutRectProperties:TCalloutRectProperties;

    property Properties:TCalloutRectProperties read GetCalloutRectProperties;
    property Prop:TCalloutRectProperties read GetCalloutRectProperties;
  end;







  /// <summary>
  ///   <para>
  ///     气泡框属性
  ///   </para>
  ///   <para>
  ///     CalloutRect properties
  ///   </para>
  /// </summary>
  TCalloutRectProperties=class(TSkinControlProperties)
  protected
    FSkinCalloutRectIntf:ISkinCalloutRect;
  public
    constructor Create(ASkinControl:TControl);override;
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  end;











  /// <summary>
  ///   <para>
  ///     气泡框素材基类
  ///   </para>
  ///   <para>
  ///     Base class of CalloutRect material
  ///   </para>
  /// </summary>
  TSkinCalloutRectMaterial=class(TSkinControlMaterial)
  private
    FDrawCaptionParam:TDrawTextParam;
    procedure SetDrawCaptionParam(const Value: TDrawTextParam);
  public
    function HasMouseDownEffect:Boolean;override;
    function HasMouseOverEffect:Boolean;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    property DrawCaptionParam:TDrawTextParam read FDrawCaptionParam write SetDrawCaptionParam;
  end;


  //气泡框风格基类
  TSkinCalloutRectType=class(TSkinControlType)
  protected
    FSkinCalloutRectIntf:ISkinCalloutRect;
    //绑定对象
    function CustomBind(ASkinControl:TControl):Boolean;override;
    //解除绑定
    procedure CustomUnBind;override;
  end;



  //气泡突起的位置
  TSkinCalloutPosition = (scpTop, scpLeft, scpBottom, scpRight);




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  /// <summary>
  ///   <para>
  ///     气泡框默认素材
  ///   </para>
  ///   <para>
  ///     CalloutRect's default material
  ///   </para>
  /// </summary>
  TSkinCalloutRectDefaultMaterial=class(TSkinCalloutRectMaterial)
  private
    FCalloutWidth: TControlSize;
    FCalloutLength: TControlSize;
    FCalloutPosition: TSkinCalloutPosition;
    FCalloutOffset: TControlSize;

    FBorderEadges: TDRPBorderEadges;
    FRectCorners:TDRPRectCorners;

    FIsRound:Boolean;
    FRoundWidth: TControlSize;
    FRoundHeight: TControlSize;

    FDrawPathParam: TDrawPathParam;

    procedure SetIsRound(const Value: Boolean);
    procedure SetRoundWidth(const Value: TControlSize);
    procedure SetRoundHeight(const Value: TControlSize);
    procedure SetBorderEadges(const Value: TDRPBorderEadges);
    procedure SetRectCorners(const Value: TDRPRectCorners);

    procedure SetCalloutWidth(const Value: TControlSize);
    procedure SetCalloutLength(const Value: TControlSize);
    procedure SetCalloutPosition(const Value: TSkinCalloutPosition);
    procedure SetCalloutOffset(const Value: TControlSize);
  private
    function IsBorderEadgesStored: Boolean;
    function IsIsRoundStored: Boolean;
    function IsRectCornersStored: Boolean;
    function IsRoundHeightStored: Boolean;
    function IsRoundWidthStored: Boolean;
  protected
    //处理Path
    FIsProcessedDrawPath:Boolean;
    FLastProcessedDrawRect:TRectF;
    procedure ProcessDrawPath(const ADrawRect:TRectF);
    function GetCalloutRectangleRect(const ADrawRect:TRectF): TRectF;
    procedure AddRoundCornerToPath(APath: TPathActionCollection; const ARect: TRectF; const ACornerSize: TSizeF; const ACorner: TDRPRectCorner);
    procedure AddRectCornerToPath(APath: TPathActionCollection; const ARect: TRectF; const ACornerSize: TSizeF;
        const ACorner: TDRPRectCorner; const ASkipEmptySide: Boolean = True);
    procedure AddCalloutToPath(APath: TPathActionCollection; const ARect: TRectF; const ACornerRadiuses: TSizeF);
    procedure SetDrawPathParam(const Value: TDrawPathParam);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  published
    /// <summary>
    ///   <para>
    ///     边框集合
    ///   </para>
    ///   <para>
    ///     Set of border
    ///   </para>
    /// </summary>
    property BorderEadges:TDRPBorderEadges read FBorderEadges write SetBorderEadges stored IsBorderEadgesStored;

    /// <summary>
    ///   <para>
    ///     角集合
    ///   </para>
    ///   <para>
    ///     Set of corner
    ///   </para>
    /// </summary>
    property RectCorners:TDRPRectCorners read FRectCorners write SetRectCorners stored IsRectCornersStored;

    /// <summary>
    ///   <para>
    ///     是否圆角
    ///   </para>
    ///   <para>
    ///     Whether is round corner
    ///   </para>
    /// </summary>
    property IsRound:Boolean read FIsRound write SetIsRound stored IsIsRoundStored;
    /// <summary>
    ///   <para>
    ///     圆角宽度
    ///   </para>
    ///   <para>
    ///     Round Width
    ///   </para>
    /// </summary>
    property RoundWidth:TControlSize read FRoundWidth write SetRoundWidth stored IsRoundWidthStored;

    /// <summary>
    ///   <para>
    ///     圆角高度
    ///   </para>
    ///   <para>
    ///     Round Height
    ///   </para>
    /// </summary>
    property RoundHeight:TControlSize read FRoundHeight write SetRoundHeight stored IsRoundHeightStored;

    property CalloutWidth: TControlSize read FCalloutWidth write SetCalloutWidth;
    property CalloutLength: TControlSize read FCalloutLength write SetCalloutLength;
    property CalloutPosition: TSkinCalloutPosition read FCalloutPosition write SetCalloutPosition default TSkinCalloutPosition.scpTop;
    property CalloutOffset: TControlSize read FCalloutOffset write SetCalloutOffset;


    /// <summary>
    ///   <para>
    ///     气泡的路径
    ///   </para>
    ///   <para>
    ///     ??
    ///   </para>
    /// </summary>
    property DrawPathParam:TDrawPathParam read FDrawPathParam write SetDrawPathParam;
  end;

  //默认类型
  TSkinCalloutRectDefaultType=class(TSkinCalloutRectType)
  private
    function GetSkinMaterial:TSkinCalloutRectDefaultMaterial;
  protected
    //自定义绘制方法
    function CustomPaint(ACanvas:TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect:TRectF;APaintData:TPaintData):Boolean;override;
  end;





  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinCalloutRect=class(TBaseSkinControl,
                        ISkinCalloutRect,
                        IBindSkinItemTextControl,
                        IBindSkinItemValueControl
                        )
  private
    function GetCalloutRectProperties:TCalloutRectProperties;
    procedure SetCalloutRectProperties(Value:TCalloutRectProperties);
  protected
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  protected
    //绑定列表项
    procedure BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
  public
    function SelfOwnMaterialToDefault:TSkinCalloutRectDefaultMaterial;
    function CurrentUseMaterialToDefault:TSkinCalloutRectDefaultMaterial;
    function Material:TSkinCalloutRectDefaultMaterial;
  public
    property Prop:TCalloutRectProperties read GetCalloutRectProperties write SetCalloutRectProperties;
  published
    //标题
    property Caption;
    property Text;
    //属性
    property Properties:TCalloutRectProperties read GetCalloutRectProperties write SetCalloutRectProperties;
  end;




  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TSkinFMXCalloutRect=class(TSkinCalloutRect)
  end;




implementation





{ TSkinCalloutRectType }

function TSkinCalloutRectType.CustomBind(ASkinControl:TControl): Boolean;
begin
  if Inherited CustomBind(ASkinControl) then
  begin
    if ASkinControl.GetInterface(IID_ISkinCalloutRect,Self.FSkinCalloutRectIntf) then
    begin
      Result:=True;
    end
    else
    begin
      ShowException('This Component Do not Support ISkinCalloutRect Interface');
    end;
  end;
end;

procedure TSkinCalloutRectType.CustomUnBind;
begin
  Inherited CustomUnBind;
  Self.FSkinCalloutRectIntf:=nil;
end;


{ TSkinCalloutRectMaterial }

constructor TSkinCalloutRectMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDrawCaptionParam:=CreateDrawTextParam('DrawCaptionParam','标题绘制参数');
end;

destructor TSkinCalloutRectMaterial.Destroy;
begin
  FreeAndNil(FDrawCaptionParam);

  inherited;
end;

function TSkinCalloutRectMaterial.HasMouseDownEffect: Boolean;
begin
  Result:=True;
end;

function TSkinCalloutRectMaterial.HasMouseOverEffect: Boolean;
begin
  Result:=True;
end;

procedure TSkinCalloutRectMaterial.SetDrawCaptionParam(const Value: TDrawTextParam);
begin
  FDrawCaptionParam.Assign(Value);
end;


{ TCalloutRectProperties }

function TCalloutRectProperties.GetComponentClassify: String;
begin
  Result:='SkinCalloutRect';
end;

constructor TCalloutRectProperties.Create(ASkinControl:TControl);
begin
  inherited Create(ASkinControl);
  if Not ASkinControl.GetInterface(IID_ISkinCalloutRect,Self.FSkinCalloutRectIntf) then
  begin
    ShowException('This Component Do not Support ISkinCalloutRect Interface');
  end
  else
  begin

    Self.FSkinControlIntf.Width:=100;
    Self.FSkinControlIntf.Height:=100;

  end;
end;


{ TSkinCalloutRectDefaultMaterial }

constructor TSkinCalloutRectDefaultMaterial.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FBorderEadges:=[beLeft,
                  beTop,
                  beRight,
                  beBottom
                  ];
  FRectCorners:=[rcTopLeft,
                rcTopRight,
                rcBottomLeft,
                rcBottomRight
                ];

  FIsRound:=False;
  FRoundWidth:=6;
  FRoundHeight:=6;

  FCalloutWidth := 23;
  FCalloutLength := 11;

  FDrawPathParam:=CreateDrawPathParam('DrawPathParam','路径绘制参数');
  FIsProcessedDrawPath:=False;
end;

destructor TSkinCalloutRectDefaultMaterial.Destroy;
begin
  FreeAndNil(FDrawPathParam);
  inherited;
end;

procedure TSkinCalloutRectDefaultMaterial.AddRectCornerToPath(APath: TPathActionCollection; const ARect: TRectF; const ACornerSize: TSizeF;
  const ACorner: TDRPRectCorner; const ASkipEmptySide: Boolean = True);
begin
  case ACorner of
    TDRPRectCorner.rcTopLeft:
    begin
      if (TDRPBorderEadge.beLeft in FBorderEadges) or not ASkipEmptySide then
        APath.LineTo(ARect.TopLeft)
      else
        APath.MoveTo(ARect.TopLeft);
      if (TDRPBorderEadge.beTop in FBorderEadges) or not ASkipEmptySide then
        APath.LineTo(PointF(ARect.Left + ACornerSize.cx, ARect.Top))
      else
        APath.MoveTo(PointF(ARect.Left + ACornerSize.cx, ARect.Top));
    end;
    TDRPRectCorner.rcTopRight:
    begin
      if (TDRPBorderEadge.beTop in FBorderEadges) or not ASkipEmptySide then
        APath.LineTo(PointF(ARect.Right, ARect.Top))
      else
        APath.MoveTo(PointF(ARect.Right, ARect.Top));
      if (TDRPBorderEadge.beRight in FBorderEadges) or not ASkipEmptySide then
        APath.LineTo(PointF(ARect.Right, ARect.Top + ACornerSize.cy))
      else
        APath.MoveTo(PointF(ARect.Right, ARect.Top + ACornerSize.cy));
    end;
    TDRPRectCorner.rcBottomLeft:
    begin
      if (TDRPBorderEadge.beBottom in FBorderEadges) or not ASkipEmptySide then
        APath.LineTo(PointF(ARect.Left, ARect.Bottom))
      else
        APath.MoveTo(PointF(ARect.Left, ARect.Bottom));
      if (TDRPBorderEadge.beLeft in FBorderEadges) or not ASkipEmptySide then
        APath.LineTo(PointF(ARect.Left, ARect.Bottom - ACornerSize.cy))
      else
        APath.MoveTo(PointF(ARect.Left, ARect.Bottom - ACornerSize.cy));
    end;
    TDRPRectCorner.rcBottomRight:
    begin
      if (TDRPBorderEadge.beRight in FBorderEadges) or not ASkipEmptySide then
        APath.LineTo(PointF(ARect.Right, ARect.Bottom))
      else
        APath.MoveTo(PointF(ARect.Right, ARect.Bottom));
      if (TDRPBorderEadge.beBottom in FBorderEadges) or not ASkipEmptySide then
        APath.LineTo(PointF(ARect.Right - ACornerSize.cx, ARect.Bottom))
      else
        APath.MoveTo(PointF(ARect.Right - ACornerSize.cx, ARect.Bottom));
    end;
  end;
end;

procedure TSkinCalloutRectDefaultMaterial.AddRoundCornerToPath(APath: TPathActionCollection; const ARect: TRectF; const ACornerSize: TSizeF; const ACorner: TDRPRectCorner);
var
  x2: Single;
  y2: Single;
begin
  x2 := ACornerSize.cx / 2;
  y2 := ACornerSize.cy / 2;
  case ACorner of
    TDRPRectCorner.rcTopLeft:
    begin
//      case FCornerType of
//      // TDRPRectCornerType.Round - default
//      TDRPRectCornerType.Bevel:
//        APath.LineTo(PointF(ARect.Left + ACornerSize.cx, ARect.Top));
//      TDRPRectCornerType.InnerRound:
//        APath.CurveTo(PointF(ARect.Left + x2, ARect.Top + ACornerSize.cy),
//          PointF(ARect.Left + ACornerSize.cx, ARect.Top + y2), PointF(ARect.Left + ACornerSize.cx, ARect.Top));
//      TDRPRectCornerType.InnerLine:
//        begin
//          APath.LineTo(PointF(ARect.Left + x2, ARect.Top + ACornerSize.cy));
//          APath.LineTo(PointF(ARect.Left + ACornerSize.cx, ARect.Top + y2));
//          APath.LineTo(PointF(ARect.Left + ACornerSize.cx, ARect.Top));
//        end;
//      else
        APath.CurveTo(PointF(ARect.Left, ARect.Top + y2),
                      PointF(ARect.Left + x2, ARect.Top),
                      PointF(ARect.Left + ACornerSize.cx, ARect.Top)
                      )
//      end;
    end;
    TDRPRectCorner.rcTopRight:
    begin
//      case FCornerType of
//        // TDRPRectCornerType.Round - default
//        TDRPRectCornerType.Bevel:
//          APath.LineTo(PointF(ARect.Right, ARect.Top + ACornerSize.cy));
//        TDRPRectCornerType.InnerRound:
//          APath.CurveTo(PointF(ARect.Right - ACornerSize.cx, ARect.Top + y2),
//            PointF(ARect.Right - x2, ARect.Top + ACornerSize.cy), PointF(ARect.Right, ARect.Top + ACornerSize.cy));
//        TDRPRectCornerType.InnerLine:
//          begin
//            APath.LineTo(PointF(ARect.Right - ACornerSize.cx, ARect.Top + y2));
//            APath.LineTo(PointF(ARect.Right - x2, ARect.Top + ACornerSize.cy));
//            APath.LineTo(PointF(ARect.Right, ARect.Top + ACornerSize.cy));
//          end;
//      else
        APath.CurveTo(PointF(ARect.Right - x2, ARect.Top), PointF(ARect.Right, ARect.Top + y2),
          PointF(ARect.Right, ARect.Top + ACornerSize.cy))
//      end;
    end;
    TDRPRectCorner.rcBottomLeft:
    begin
//      case FCornerType of
//        // TDRPRectCornerType.Round - default
//        TDRPRectCornerType.Bevel:
//          APath.LineTo(PointF(ARect.Left, ARect.Bottom - ACornerSize.cy));
//        TDRPRectCornerType.InnerRound:
//          APath.CurveTo(PointF(ARect.Left + ACornerSize.cx, ARect.Bottom - y2),
//            PointF(ARect.Left + x2, ARect.Bottom -  ACornerSize.cy), PointF(ARect.Left, ARect.Bottom - ACornerSize.cy));
//        TDRPRectCornerType.InnerLine:
//          begin
//            APath.LineTo(PointF(ARect.Left +  ACornerSize.cx, ARect.Bottom - y2));
//            APath.LineTo(PointF(ARect.Left + x2, ARect.Bottom - ACornerSize.cy));
//            APath.LineTo(PointF(ARect.Left, ARect.Bottom - ACornerSize.cy));
//          end;
//      else
        APath.CurveTo(PointF(ARect.Left + x2, ARect.Bottom), PointF(ARect.Left, ARect.Bottom - y2),
          PointF(ARect.Left, ARect.Bottom - ACornerSize.cy))
//      end;
    end;
    TDRPRectCorner.rcBottomRight:
    begin
//      case FCornerType of
//        // TDRPRectCornerType.Round - default
//        TDRPRectCornerType.Bevel:
//          APath.LineTo(PointF(ARect.Right - ACornerSize.cx, ARect.Bottom));
//        TDRPRectCornerType.InnerRound:
//          APath.CurveTo(PointF(ARect.Right - x2, ARect.Bottom - ACornerSize.cy),
//            PointF(ARect.Right - ACornerSize.cx, ARect.Bottom - y2), PointF(ARect.Right - ACornerSize.cx, ARect.Bottom));
//        TDRPRectCornerType.InnerLine:
//          begin
//            APath.LineTo(PointF(ARect.Right - x2, ARect.Bottom - ACornerSize.cy));
//            APath.LineTo(PointF(ARect.Right - ACornerSize.cx, ARect.Bottom - y2));
//            APath.LineTo(PointF(ARect.Right - ACornerSize.cx, ARect.Bottom));
//          end;
//      else
        APath.CurveTo(PointF(ARect.Right, ARect.Bottom - y2),
          PointF(ARect.Right - x2, ARect.Bottom), PointF(ARect.Right - ACornerSize.cx, ARect.Bottom))
//      end;
    end;
  end;
end;

function TSkinCalloutRectDefaultMaterial.GetCalloutRectangleRect(const ADrawRect:TRectF): TRectF;
begin
  Result := RectF(0,0,ADrawRect.Width,ADrawRect.Height);

  case CalloutPosition of
    TSkinCalloutPosition.scpTop:
      Result.Top := Result.Top + FCalloutLength;
    TSkinCalloutPosition.scpLeft:
      Result.Left := Result.Left + FCalloutLength;
    TSkinCalloutPosition.scpBottom:
      Result.Bottom := Result.Bottom - FCalloutLength;
    TSkinCalloutPosition.scpRight:
      Result.Right := Result.Right - FCalloutLength;
  end;
end;

procedure TSkinCalloutRectDefaultMaterial.AddCalloutToPath(APath: TPathActionCollection; const ARect: TRectF; const ACornerRadiuses: TSizeF);
begin
  case CalloutPosition of
    TSkinCalloutPosition.scpTop:
    begin
      if CalloutOffset = 0 then
      begin
        APath.LineTo(PointF(ARect.Width / 2 - CalloutWidth / 2, ARect.Top));
        APath.LineTo(PointF(ARect.Width / 2, ARect.Top - FCalloutLength));
        APath.LineTo(PointF(ARect.Width / 2 + CalloutWidth / 2, ARect.Top));
        APath.LineTo(PointF(ARect.Right - ACornerRadiuses.cx, ARect.Top));
      end
      else if CalloutOffset > 0 then
      begin
        APath.LineTo(PointF(ARect.Left + FCalloutOffset, ARect.Top));
        APath.LineTo(PointF(ARect.Left + FCalloutOffset + (CalloutWidth / 2), ARect.Top - FCalloutLength));
        APath.LineTo(PointF(ARect.Left + FCalloutOffset + CalloutWidth, ARect.Top));
        APath.LineTo(PointF(ARect.Right - ACornerRadiuses.cx, ARect.Top));
      end else
      begin
        APath.LineTo(PointF(ARect.Right - Abs(FCalloutOffset) - CalloutWidth, ARect.Top));
        APath.LineTo(PointF(ARect.Right - Abs(FCalloutOffset) - CalloutWidth / 2, ARect.Top - FCalloutLength));
        APath.LineTo(PointF(ARect.Right - Abs(FCalloutOffset), ARect.Top));
        APath.LineTo(PointF(ARect.Right - ACornerRadiuses.cx, ARect.Top));
      end;
    end;
    TSkinCalloutPosition.scpLeft:
    begin
      if CalloutOffset = 0 then
      begin
        APath.LineTo(PointF(ARect.Left, ARect.Height / 2 + CalloutWidth / 2));
        APath.LineTo(PointF(ARect.Left - FCalloutLength, (ARect.Bottom - ARect.Top) / 2));
        APath.LineTo(PointF(ARect.Left, ARect.Height / 2 - CalloutWidth / 2));
        APath.LineTo(PointF(ARect.Left, ARect.Top + ACornerRadiuses.cy));
      end
      else if CalloutOffset > 0 then
      begin
        APath.LineTo(PointF(ARect.Left, ARect.Top + CalloutOffset + CalloutWidth));
        APath.LineTo(PointF(ARect.Left - FCalloutLength, ARect.Top + CalloutOffset + CalloutWidth / 2));
        APath.LineTo(PointF(ARect.Left, ARect.Top + CalloutOffset));
        APath.LineTo(PointF(ARect.Left, ARect.Top + ACornerRadiuses.cy));
      end else
      begin
        APath.LineTo(PointF(ARect.Left, ARect.Bottom + CalloutOffset + CalloutWidth));
        APath.LineTo(PointF(ARect.Left - FCalloutLength, ARect.Bottom + CalloutOffset + CalloutWidth / 2));
        APath.LineTo(PointF(ARect.Left, ARect.Bottom + CalloutOffset));
        APath.LineTo(PointF(ARect.Left, ARect.Top + ACornerRadiuses.cy));
      end;
    end;
    TSkinCalloutPosition.scpBottom:
    begin
      if CalloutOffset = 0 then
      begin
        APath.LineTo(PointF(ARect.Width / 2 + CalloutWidth / 2, ARect.Bottom));
        APath.LineTo(PointF(ARect.Width / 2, ARect.Bottom + FCalloutLength));
        APath.LineTo(PointF(ARect.Width / 2 - CalloutWidth / 2, ARect.Bottom));
        APath.LineTo(PointF(ARect.Left + ACornerRadiuses.cx, ARect.Bottom));
      end
      else if CalloutOffset > 0 then
      begin
        APath.LineTo(PointF(ARect.Left + FCalloutOffset + CalloutWidth, ARect.Bottom));
        APath.LineTo(PointF(ARect.Left + FCalloutOffset + CalloutWidth / 2, ARect.Bottom + FCalloutLength));
        APath.LineTo(PointF(ARect.Left + FCalloutOffset, ARect.Bottom));
        APath.LineTo(PointF(ARect.Left + ACornerRadiuses.cx, ARect.Bottom));
      end else
      begin
        APath.LineTo(PointF(ARect.Right - Abs(FCalloutOffset), ARect.Bottom));
        APath.LineTo(PointF(ARect.Right - Abs(FCalloutOffset) - CalloutWidth / 2, ARect.Bottom + FCalloutLength));
        APath.LineTo(PointF(ARect.Right - Abs(FCalloutOffset) - CalloutWidth, ARect.Bottom));
        APath.LineTo(PointF(ARect.Left + ACornerRadiuses.cx, ARect.Bottom));
      end;
    end;
    TSkinCalloutPosition.scpRight:
    begin
      if CalloutOffset = 0 then
      begin
        APath.LineTo(PointF(ARect.Right, ARect.Height / 2 - CalloutWidth / 2));
        APath.LineTo(PointF(ARect.Right + FCalloutLength, ARect.Height / 2));
        APath.LineTo(PointF(ARect.Right, ARect.Height / 2 + CalloutWidth / 2));
        APath.LineTo(PointF(ARect.Right, ARect.Bottom - ACornerRadiuses.cy));
      end
      else if CalloutOffset > 0 then
      begin
        APath.LineTo(PointF(ARect.Right, ARect.Top + CalloutOffset));
        APath.LineTo(PointF(ARect.Right + FCalloutLength, ARect.Top + CalloutOffset + CalloutWidth / 2));
        APath.LineTo(PointF(ARect.Right, ARect.Top + CalloutOffset + CalloutWidth));
        APath.LineTo(PointF(ARect.Right, ARect.Bottom - ACornerRadiuses.cy));
      end
      else
      begin
        APath.LineTo(PointF(ARect.Right, ARect.Bottom + CalloutOffset));
        APath.LineTo(PointF(ARect.Right + FCalloutLength, ARect.Bottom + CalloutOffset + CalloutWidth / 2));
        APath.LineTo(PointF(ARect.Right, ARect.Bottom + CalloutOffset + CalloutWidth));
        APath.LineTo(PointF(ARect.Right, ARect.Bottom - ACornerRadiuses.cy));
      end;
    end;
  end;
end;


procedure TSkinCalloutRectDefaultMaterial.ProcessDrawPath(const ADrawRect:TRectF);
var
  APathActionItem:TPathActionItem;
var
  CornerSize: TSizeF;
  R: TRectF;
begin
  if Not FIsProcessedDrawPath
      //尺寸变了
      or IsNotSameDouble(Self.FLastProcessedDrawRect.Width,ADrawRect.Width)
      or IsNotSameDouble(Self.FLastProcessedDrawRect.Height,ADrawRect.Height) then
  begin
      FIsProcessedDrawPath:=True;
      FLastProcessedDrawRect:=ADrawRect;


      Self.FDrawPathParam.PathActions.Clear;

      R := GetCalloutRectangleRect(ADrawRect);

      //圆角半么
      CornerSize := TSizeF.Create(0, 0);
      if Self.FIsRound then
      begin
        CornerSize := TSizeF.Create(FRoundWidth, FRoundHeight);
        if (R.Width - CornerSize.cx * 2 < 0) and (CornerSize.cx > 0) then
          CornerSize.cx := FRoundWidth * R.Width / (CornerSize.cx * 2);
        if (R.Height - CornerSize.cy * 2 < 0) and (CornerSize.cy > 0) then
          CornerSize.cy := FRoundHeight * R.Height / (CornerSize.cy * 2);
      end;

      Self.FDrawPathParam.PathActions.MoveTo(PointF(R.Left, R.Top + CornerSize.cy));

      // Top Left Corner
      if TDRPRectCorner.rcTopLeft in FRectCorners then
        AddRoundCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcTopLeft)
      else
        AddRectCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcTopLeft);

      // Top Side
      if not (TDRPBorderEadge.beTop in FBorderEadges) then
        Self.FDrawPathParam.PathActions.MoveTo(PointF(R.Right - CornerSize.cx, R.Top))
      else
      begin
        if CalloutPosition = TSkinCalloutPosition.scpTop then
          AddCalloutToPath(Self.FDrawPathParam.PathActions, R, CornerSize)
        else
          Self.FDrawPathParam.PathActions.LineTo(PointF(R.Right - CornerSize.cx, R.Top));
      end;

      // Top Right Corner
      if TDRPRectCorner.rcTopRight in FRectCorners then
        AddRoundCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcTopRight)
      else
        AddRectCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcTopRight);

      // Right Side
      if not (TDRPBorderEadge.beRight in FBorderEadges) then
        Self.FDrawPathParam.PathActions.MoveTo(PointF(R.Right, R.Bottom - CornerSize.cy))
      else
      begin
        if (FCalloutPosition = TSkinCalloutPosition.scpRight) then
          AddCalloutToPath(Self.FDrawPathParam.PathActions, R, CornerSize)
        else
          Self.FDrawPathParam.PathActions.LineTo(PointF(R.Right, R.Bottom - CornerSize.cy));
      end;

      // Bottom Right Corner
      if TDRPRectCorner.rcBottomRight in FRectCorners then
        AddRoundCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcBottomRight)
      else
        AddRectCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcBottomRight);

      // Bottom Side
      if not (TDRPBorderEadge.beBottom in FBorderEadges) then
        Self.FDrawPathParam.PathActions.MoveTo(PointF(R.Left + CornerSize.cx, R.Bottom))
      else
      begin
        if FCalloutPosition = TSkinCalloutPosition.scpBottom then
          AddCalloutToPath(Self.FDrawPathParam.PathActions, R, CornerSize)
        else
          Self.FDrawPathParam.PathActions.LineTo(PointF(R.Left + CornerSize.cx, R.Bottom));
      end;

      // Bottom Left Corner
      if TDRPRectCorner.rcBottomLeft in FRectCorners then
        AddRoundCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcBottomLeft)
      else
        AddRectCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcBottomLeft);

      // Left Side
      if not (TDRPBorderEadge.beLeft in FBorderEadges) then
        Self.FDrawPathParam.PathActions.MoveTo(PointF(R.Left, R.Top + CornerSize.cy))
      else
      begin
        if FCalloutPosition = TSkinCalloutPosition.scpLeft then
          AddCalloutToPath(Self.FDrawPathParam.PathActions, R, CornerSize)
        else
          Self.FDrawPathParam.PathActions.LineTo(PointF(R.Left, R.Top + CornerSize.cy));
      end;

      APathActionItem:=TPathActionItem(Self.FDrawPathParam.PathActions.Add);
      APathActionItem.ActionType:=patDrawPath;



      if Self.FDrawPathParam.IsFill then
      begin
          APathActionItem:=TPathActionItem(Self.FDrawPathParam.PathActions.Add);
          APathActionItem.ActionType:=patClear;

          Self.FDrawPathParam.PathActions.MoveTo(PointF(R.Left, R.Top + CornerSize.cy));

          // Top Left Corner
          if TDRPRectCorner.rcTopLeft in Self.FRectCorners then
            AddRoundCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcTopLeft)
          else
            AddRectCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcTopLeft, False);

          // Top Side
          if CalloutPosition = TSkinCalloutPosition.scpTop then
            AddCalloutToPath(Self.FDrawPathParam.PathActions, R, CornerSize)
          else
            Self.FDrawPathParam.PathActions.LineTo(PointF(R.Right - CornerSize.cx, R.Top));

          // Top Right Corner
          if TDRPRectCorner.rcTopRight in FRectCorners then
            AddRoundCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcTopRight)
          else
            AddRectCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcTopRight, False);

          // Right Side
          if (FCalloutPosition = TSkinCalloutPosition.scpRight) then
            AddCalloutToPath(Self.FDrawPathParam.PathActions, R, CornerSize)
          else
            Self.FDrawPathParam.PathActions.LineTo(PointF(R.Right, R.Bottom - CornerSize.cy));

          // Bottom Right Corner
          if TDRPRectCorner.rcBottomRight in FRectCorners then
            AddRoundCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcBottomRight)
          else
            AddRectCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcBottomRight, False);

          // Bottom Side
          if FCalloutPosition = TSkinCalloutPosition.scpBottom then
            AddCalloutToPath(Self.FDrawPathParam.PathActions, R, CornerSize)
          else
            Self.FDrawPathParam.PathActions.LineTo(PointF(R.Left + CornerSize.cx, R.Bottom));

          // Bottom Left Corner
          if TDRPRectCorner.rcBottomLeft in FRectCorners then
            AddRoundCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcBottomLeft)
          else
            AddRectCornerToPath(Self.FDrawPathParam.PathActions, R, CornerSize, TDRPRectCorner.rcBottomLeft, False);

          // Left Side
          if FCalloutPosition = TSkinCalloutPosition.scpLeft then
            AddCalloutToPath(Self.FDrawPathParam.PathActions, R, CornerSize)
          else
            Self.FDrawPathParam.PathActions.LineTo(PointF(R.Left, R.Top + CornerSize.cy));


          APathActionItem:=TPathActionItem(Self.FDrawPathParam.PathActions.Add);
          APathActionItem.ActionType:=patFillPath;


      end;

  end;

end;

procedure TSkinCalloutRectDefaultMaterial.SetDrawPathParam(const Value: TDrawPathParam);
begin
  FDrawPathParam.Assign(Value);
end;

procedure TSkinCalloutRectDefaultMaterial.AssignTo(Dest: TPersistent);
var
  DestObject:TSkinCalloutRectDefaultMaterial;
begin

  if Dest is TSkinCalloutRectDefaultMaterial then
  begin
    DestObject:=TSkinCalloutRectDefaultMaterial(Dest);

    DestObject.FCalloutWidth:=Self.FCalloutWidth;
    DestObject.FCalloutLength:=Self.FCalloutLength;
    DestObject.FCalloutPosition:=Self.FCalloutPosition;
    DestObject.FCalloutOffset:=Self.FCalloutOffset;

    DestObject.FBorderEadges:=Self.FBorderEadges;
    DestObject.FRectCorners:=Self.FRectCorners;

    DestObject.FIsRound:=Self.FIsRound;
    DestObject.FRoundWidth:=Self.FRoundWidth;
    DestObject.FRoundHeight:=Self.FRoundHeight;

    DestObject.FIsProcessedDrawPath:=False;
  end;

  inherited;
end;

function TSkinCalloutRectDefaultMaterial.IsBorderEadgesStored: Boolean;
begin
  Result:=(Self.FBorderEadges<>[beLeft,
                                beTop,
                                beRight,
                                beBottom]);
end;

//function TSkinCalloutRectDefaultMaterial.IsIsFillStored: Boolean;
//begin
//  {$IFDEF FMX}
//  Result:=(Self.FIsFill<>False);
//  {$ENDIF}
//  {$IFDEF VCL}
//  //因为VCL默认为True
//  Result:=True;
//  {$ENDIF}
//end;

function TSkinCalloutRectDefaultMaterial.IsIsRoundStored: Boolean;
begin
  Result:=(Self.FIsRound<>False);
end;

function TSkinCalloutRectDefaultMaterial.IsRectCornersStored: Boolean;
begin
  Result:=(Self.FRectCorners<>[rcTopLeft,
                              rcTopRight,
                              rcBottomLeft,
                              rcBottomRight]);
end;

function TSkinCalloutRectDefaultMaterial.IsRoundHeightStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FRoundHeight,6);
end;

function TSkinCalloutRectDefaultMaterial.IsRoundWidthStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FRoundWidth,6);
end;

procedure TSkinCalloutRectDefaultMaterial.SetBorderEadges(const Value: TDRPBorderEadges);
begin
  if FBorderEadges<>Value then
  begin
    FBorderEadges := Value;
    FIsProcessedDrawPath:=False;
    DoChange;
  end;
end;

procedure TSkinCalloutRectDefaultMaterial.SetRectCorners(const Value: TDRPRectCorners);
begin
  if FRectCorners<>Value then
  begin
    FRectCorners := Value;
    FIsProcessedDrawPath:=False;
    DoChange;
  end;
end;

procedure TSkinCalloutRectDefaultMaterial.SetRoundWidth(const Value: TControlSize);
begin
  if FRoundWidth<>Value then
  begin
    FRoundWidth := Value;
    FIsProcessedDrawPath:=False;
    DoChange;
  end;
end;

//procedure TSkinCalloutRectDefaultMaterial.SetIsFill(const Value: Boolean);
//begin
//  if FIsFill<>Value then
//  begin
//    FIsFill := Value;
//
//    FIsProcessedDrawPath:=False;
//    DoChange;
//  end;
//end;

procedure TSkinCalloutRectDefaultMaterial.SetIsRound(const Value: Boolean);
begin
  if FIsRound<>Value then
  begin
    FIsRound := Value;
    FIsProcessedDrawPath:=False;
    DoChange;
  end;
end;

procedure TSkinCalloutRectDefaultMaterial.SetRoundHeight(const Value: TControlSize);
begin
  if FRoundHeight<>Value then
  begin
    FRoundHeight := Value;
    FIsProcessedDrawPath:=False;
    DoChange;
  end;
end;

procedure TSkinCalloutRectDefaultMaterial.SetCalloutWidth(const Value: TControlSize);
begin
  if FCalloutWidth <> Value then
  begin
    FCalloutWidth := Value;
    FIsProcessedDrawPath:=False;
    DoChange;
  end;
end;


procedure TSkinCalloutRectDefaultMaterial.SetCalloutLength(const Value: TControlSize);
begin
  if FCalloutLength <> Value then
  begin
    FCalloutLength := Value;
    FIsProcessedDrawPath:=False;
    DoChange;
  end;
end;

procedure TSkinCalloutRectDefaultMaterial.SetCalloutPosition(const Value: TSkinCalloutPosition);
begin
  if FCalloutPosition <> Value then
  begin
    FCalloutPosition := Value;
    FIsProcessedDrawPath:=False;
    DoChange;
  end;
end;

procedure TSkinCalloutRectDefaultMaterial.SetCalloutOffset(const Value: TControlSize);
begin
  if FCalloutOffset <> Value then
  begin
    FCalloutOffset := Value;
    FIsProcessedDrawPath:=False;
    DoChange;
  end;
end;

{ TSkinCalloutRectDefaultType }


function TSkinCalloutRectDefaultType.GetSkinMaterial: TSkinCalloutRectDefaultMaterial;
begin
  if Self.FSkinControlIntf.GetCurrentUseMaterial<>nil then
  begin
    Result:=TSkinCalloutRectDefaultMaterial(Self.FSkinControlIntf.GetCurrentUseMaterial);
  end
  else
  begin
    Result:=nil;
  end;
end;

function TSkinCalloutRectDefaultType.CustomPaint(ACanvas: TDrawCanvas;ASkinMaterial:TSkinControlMaterial;const ADrawRect: TRectF;APaintData:TPaintData): Boolean;
begin
  if GetSkinMaterial<>nil then
  begin

    GetSkinMaterial.ProcessDrawPath(ADrawRect);

    ACanvas.DrawPath(GetSkinMaterial.FDrawPathParam,ADrawRect);
    ACanvas.DrawText(GetSkinMaterial.FDrawCaptionParam,Self.FSkinControlIntf.Caption,ADrawRect);

  end;
end;



{ TSkinCalloutRect }

function TSkinCalloutRect.Material:TSkinCalloutRectDefaultMaterial;
begin
  Result:=TSkinCalloutRectDefaultMaterial(SelfOwnMaterial);
end;

function TSkinCalloutRect.SelfOwnMaterialToDefault:TSkinCalloutRectDefaultMaterial;
begin
  Result:=TSkinCalloutRectDefaultMaterial(SelfOwnMaterial);
end;

procedure TSkinCalloutRect.BindingItemText(const AName, AText: String;
  ASkinItem: TObject; AIsDrawItemInteractiveState: Boolean);
begin
  StaticCaption:=AText;
end;

function TSkinCalloutRect.CurrentUseMaterialToDefault:TSkinCalloutRectDefaultMaterial;
begin
  Result:=TSkinCalloutRectDefaultMaterial(CurrentUseMaterial);
end;

function TSkinCalloutRect.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TCalloutRectProperties;
end;

function TSkinCalloutRect.GetCalloutRectProperties: TCalloutRectProperties;
begin
  Result:=TCalloutRectProperties(Self.FProperties);
end;

procedure TSkinCalloutRect.SetCalloutRectProperties(Value: TCalloutRectProperties);
begin
  Self.FProperties.Assign(Value);
end;

procedure TSkinCalloutRect.SetControlValueByBindItemField(
  const AFieldName: String; const AFieldValue: Variant; ASkinItem: TObject;
  AIsDrawItemInteractiveState: Boolean);
begin
  StaticCaption:=AFieldValue;
end;

end.




