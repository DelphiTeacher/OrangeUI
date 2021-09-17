//convert pas to utf8 by ¥
/// <summary>
///   路径绘制参数
/// </summary>
unit uDrawPathParam;

interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,
  Math,

  {$IFDEF VCL}
  Graphics,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  Types,
  {$ENDIF}

//  XSuperObject,


  uBasePathData,
  uDrawParam,
  uFuncCommon,
  uGraphicCommon,
  uBinaryTreeDoc;


type

  TDrawPathParam=class;
  TBaseDrawPathParam=class;





  /// <summary>
  ///   <para>
  ///     路径绘制参数的效果类型
  ///   </para>
  ///   <para>
  ///     Effect types of drawing rectangle parameters
  ///   </para>
  /// </summary>
  TDPPEffectType=( //
                   /// <summary>
                   ///   <para>
                   ///   填充颜色更改
                   ///   </para>
                   ///   <para>
                   ///    Change fill color
                   ///   </para>
                   /// </summary>
                   dppetFillColorChange,
                   /// <summary>
                   ///   是否填充更改
                   ///   <para>
                   ///    Change whether fill
                   ///   </para>
                   /// </summary>
                   dppetIsFillChange,
                   /// <summary>
                   ///   边框宽度更改
                   ///   <para>
                   ///    Change border width
                   ///   </para>
                   /// </summary>
                   dppetPenWidthChange,
                   /// <summary>
                   ///   边框颜色更改
                   ///   <para>
                   ///    Change border color
                   ///   </para>
                   /// </summary>
                   dppetPenColorChange
                   );
  /// <summary>
  ///   <para>
  ///     路径绘制效果参数类型集合
  ///   </para>
  ///   <para>
  ///     Set of drawing rectangle effect parameters type
  ///   </para>
  /// </summary>
  TDPPEffectTypes=set of TDPPEffectType;




  TPathActionType=(patLineTo,
                    patMoveTo,
                    patCurveTo,
                    patClear,
                    patFillPath,
                    patDrawPath
                    );
  TPathActionItem=class(TCollectionItem)
  private
    FActionType: TPathActionType;
    FX: TControlSize;
    FY: TControlSize;
    FX1: TControlSize;
    FY1: TControlSize;
    FX2: TControlSize;
    FY2: TControlSize;
    FSizeType:TDPSizeType;
    procedure SetActionType(const Value: TPathActionType);
    procedure SetX(const Value: TControlSize);
    procedure SetY(const Value: TControlSize);
    procedure SetX1(const Value: TControlSize);
    procedure SetY1(const Value: TControlSize);
    procedure SetX2(const Value: TControlSize);
    procedure SetY2(const Value: TControlSize);
    procedure SetSizeType(const Value: TDPSizeType);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
//    function LoadFromJson(ASuperObject:ISuperObject):Boolean;
//    function SaveToJson(ASuperObject:ISuperObject):Boolean;
  public
    constructor Create(Collection: TCollection); override;
  public
    function GetX(Const ADrawRect:TRectF):TControlSize;
    function GetY(Const ADrawRect:TRectF):TControlSize;
    function GetX1(Const ADrawRect:TRectF):TControlSize;
    function GetY1(Const ADrawRect:TRectF):TControlSize;
    function GetX2(Const ADrawRect:TRectF):TControlSize;
    function GetY2(Const ADrawRect:TRectF):TControlSize;
  published
    //点
    property X:TControlSize read FX write SetX;
    property Y:TControlSize read FY write SetY;
    property X1:TControlSize read FX1 write SetX1;
    property Y1:TControlSize read FY1 write SetY1;
    property X2:TControlSize read FX2 write SetX2;
    property Y2:TControlSize read FY2 write SetY2;
    property SizeType:TDPSizeType read FSizeType write SetSizeType;
    //类型,线,弧,圆
    property ActionType:TPathActionType read FActionType write SetActionType;
  end;

  TPathActionCollection=class(TCollection)
  private
    function GetItem(Index: Integer): TPathActionItem;
    procedure SetItem(Index: Integer;const Value: TPathActionItem);
  public
    constructor Create(ItemClass: TCollectionItemClass;
                      ADrawPathParam:TBaseDrawPathParam;
                      ADrawPathDataClass:TDrawPathDataClass);
    destructor Destroy; override;
  public
    FDrawPathParam:TBaseDrawPathParam;
    FDrawPathData:TBaseDrawPathData;
    property Items[Index:Integer]:TPathActionItem read GetItem write SetItem;default;
  public
//    function LoadFromJsonArray(ASuperArray:ISuperArray):Boolean;
//    function SaveToJsonArray(ASuperArray:ISuperArray):Boolean;
  public
    procedure MoveTo(const P: TPointF;ASizeType:TDPSizeType=dpstPixel);
    procedure CurveTo(const P,P1,P2: TPointF;ASizeType:TDPSizeType=dpstPixel);
    procedure LineTo(const P: TPointF;ASizeType:TDPSizeType=dpstPixel);
  end;




  /// <summary>
  ///   <para>
  ///     路径绘制参数的效果
  ///   </para>
  ///   <para>
  ///     Parameters Effect of drawing rectangle
  ///   </para>
  /// </summary>
  TDrawPathParamEffect=class(TDrawParamCommonEffect)
  private
    FIsFill: Boolean;
    FFillDrawColor: TDrawColor;
    FPenDrawColor: TDrawColor;
    FPenWidth:TControlSize;

    FEffectTypes: TDPPEffectTypes;
  private
    function IsRectPenWidthStored: Boolean;
    function IsEffectTypesStored: Boolean;
    function IsIsFillStored: Boolean;
    procedure SetPenWidth(const Value: TControlSize);
    procedure SetEffectTypes(const Value: TDPPEffectTypes);
    procedure SetFillDrawColor(const Value: TDrawColor);
    procedure SetIsFill(const Value: Boolean);
    procedure SetPenDrawColor(const Value: TDrawColor);
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
//    function LoadFromJson(ASuperObject:ISuperObject):Boolean;override;
//    function SaveToJson(ASuperObject:ISuperObject):Boolean;override;
  public
    constructor Create;override;
    destructor Destroy;override;
  public
    /// <summary>
    ///   <para>
    ///     是否包含效果类型
    ///   </para>
    ///   <para>
    ///     Whether have effect type
    ///   </para>
    /// </summary>
    function HasEffectTypes:Boolean;override;

    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;

    /// <summary>
    ///   <para>
    ///     保存到文档节点
    ///   </para>
    ///   <para>
    ///     Save to document node
    ///   </para>
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  published

    /// <summary>
    ///   <para>
    ///     边框宽度
    ///   </para>
    ///   <para>
    ///     Border Width
    ///   </para>
    /// </summary>
    property PenWidth:TControlSize read FPenWidth write SetPenWidth stored IsRectPenWidthStored;

    /// <summary>
    ///   <para>
    ///     是否填充路径
    ///   </para>
    ///   <para>
    ///     whether fill rectangle
    ///   </para>
    /// </summary>
    property IsFill:Boolean read FIsFill write SetIsFill stored IsIsFillStored;

    /// <summary>
    ///   <para>
    ///     填充颜色
    ///   </para>
    ///   <para>
    ///     Fill Color
    ///   </para>
    /// </summary>
    property FillColor:TDrawColor read FFillDrawColor write SetFillDrawColor;
    property PenColor:TDrawColor read FPenDrawColor write SetPenDrawColor;
    /// <summary>
    ///   <para>
    ///     效果类型集合,一个状态可以有多个效果
    ///   </para>                                         =
    ///   <para>
    ///     Set of effect type,one state can have several effects
    ///   </para>
    /// </summary>
    property EffectTypes:TDPPEffectTypes read FEffectTypes write SetEffectTypes stored IsEffectTypesStored;//default [];
  end;




  TDrawPathEffectSetting=class(TDrawEffectSetting)
  private
    function GetMouseDownEffect: TDrawPathParamEffect;
    function GetMouseOverEffect: TDrawPathParamEffect;
    function GetPushedEffect: TDrawPathParamEffect;
    procedure SetMouseDownEffect(const Value: TDrawPathParamEffect);
    procedure SetMouseOverEffect(const Value: TDrawPathParamEffect);
    procedure SetPushedEffect(const Value: TDrawPathParamEffect);
    procedure SetDisabledEffect(const Value: TDrawPathParamEffect);
    procedure SetFocusedEffect(const Value: TDrawPathParamEffect);
    function GetDisabledEffect: TDrawPathParamEffect;
    function GetFocusedEffect: TDrawPathParamEffect;
  protected
    function GetDrawParamEffectClass:TDrawParamCommonEffectClass;override;
  published
    //禁用状态的效果
    property DisabledEffect: TDrawPathParamEffect read GetDisabledEffect write SetDisabledEffect;
    //获得焦点的效果
    property FocusedEffect: TDrawPathParamEffect read GetFocusedEffect write SetFocusedEffect;
    property MouseDownEffect:TDrawPathParamEffect read GetMouseDownEffect write SetMouseDownEffect;
    property MouseOverEffect:TDrawPathParamEffect read GetMouseOverEffect write SetMouseOverEffect;
    property PushedEffect:TDrawPathParamEffect read GetPushedEffect write SetPushedEffect;
  end;



  TDrawPathParamSetting=class(TDrawParamSetting)
  private
    function IsMouseDownPenWidthChangeStored: Boolean;
    function IsMouseDownPenWidthStored: Boolean;
    function IsMouseDownFillColorChangeStored: Boolean;
    function IsMouseDownFillColorStored: Boolean;
    function IsMouseDownIsFillChangeStored: Boolean;
    function IsMouseDownIsFillStored: Boolean;
    function IsMouseOverPenWidthChangeStored: Boolean;
    function IsMouseOverPenWidthStored: Boolean;
    function IsMouseOverFillColorChangeStored: Boolean;
    function IsMouseOverFillColorStored: Boolean;
    function IsMouseOverIsFillChangeStored: Boolean;
    function IsMouseOverIsFillStored: Boolean;
    function IsPushedPenWidthChangeStored: Boolean;
    function IsPushedPenWidthStored: Boolean;
    function IsPushedFillColorChangeStored: Boolean;
    function IsPushedFillColorStored: Boolean;
    function IsPushedIsFillChangeStored: Boolean;
    function IsPushedIsFillStored: Boolean;
  protected
    FDrawPathParam:TDrawPathParam;

    function GetMouseDownFillColor: TDelphiColor;
    function GetMouseDownFillColorChange: Boolean;
    function GetMouseOverFillColor: TDelphiColor;
    function GetMouseOverFillColorChange: Boolean;
    function GetPushedFillColor: TDelphiColor;
    function GetPushedFillColorChange: Boolean;

    function GetMouseDownPenWidth: TControlSize;
    function GetMouseDownPenWidthChange: Boolean;
    function GetMouseOverPenWidth: TControlSize;
    function GetMouseOverPenWidthChange: Boolean;
    function GetPushedPenWidth: TControlSize;
    function GetPushedPenWidthChange: Boolean;

    function GetMouseDownIsFill: Boolean;
    function GetMouseDownIsFillChange: Boolean;
    function GetMouseOverIsFill: Boolean;
    function GetMouseOverIsFillChange: Boolean;
    function GetPushedIsFill: Boolean;
    function GetPushedIsFillChange: Boolean;

    procedure SetMouseDownIsFill(const Value: Boolean);
    procedure SetMouseDownIsFillChange(const Value: Boolean);
    procedure SetMouseOverIsFill(const Value: Boolean);
    procedure SetMouseOverIsFillChange(const Value: Boolean);
    procedure SetPushedIsFill(const Value: Boolean);
    procedure SetPushedIsFillChange(const Value: Boolean);

    procedure SetMouseDownPenWidth(const Value: TControlSize);
    procedure SetMouseDownPenWidthChange(const Value: Boolean);
    procedure SetMouseOverPenWidth(const Value: TControlSize);
    procedure SetMouseOverPenWidthChange(const Value: Boolean);
    procedure SetPushedPenWidth(const Value: TControlSize);
    procedure SetPushedPenWidthChange(const Value: Boolean);

    procedure SetMouseDownFillColor(const Value: TDelphiColor);
    procedure SetMouseDownFillColorChange(const Value: Boolean);
    procedure SetMouseOverFillColor(const Value: TDelphiColor);
    procedure SetMouseOverFillColorChange(const Value: Boolean);
    procedure SetPushedFillColor(const Value: TDelphiColor);
    procedure SetPushedFillColorChange(const Value: Boolean);
  public
    constructor Create(ADrawParam:TDrawParam);override;
  public
    property MouseDownIsFill:Boolean read GetMouseDownIsFill write SetMouseDownIsFill stored IsMouseDownIsFillStored;
    property MouseDownIsFillChange:Boolean read GetMouseDownIsFillChange write SetMouseDownIsFillChange stored IsMouseDownIsFillChangeStored;
    property MouseOverIsFill:Boolean read GetMouseOverIsFill write SetMouseOverIsFill stored IsMouseOverIsFillStored;
    property MouseOverIsFillChange:Boolean read GetMouseOverIsFillChange write SetMouseOverIsFillChange stored IsMouseOverIsFillChangeStored;
    property PushedIsFill:Boolean read GetPushedIsFill write SetPushedIsFill stored IsPushedIsFillStored;
    property PushedIsFillChange:Boolean read GetPushedIsFillChange write SetPushedIsFillChange stored IsPushedIsFillChangeStored;
  published
    property MouseDownFillColor:TDelphiColor read GetMouseDownFillColor write SetMouseDownFillColor stored IsMouseDownFillColorStored;
    property MouseDownFillColorChange:Boolean read GetMouseDownFillColorChange write SetMouseDownFillColorChange stored IsMouseDownFillColorChangeStored;
    property MouseDownPenWidth:TControlSize read GetMouseDownPenWidth write SetMouseDownPenWidth stored IsMouseDownPenWidthStored;
    property MouseDownPenWidthChange:Boolean read GetMouseDownPenWidthChange write SetMouseDownPenWidthChange stored IsMouseDownPenWidthChangeStored;

    property MouseOverFillColor:TDelphiColor read GetMouseOverFillColor write SetMouseOverFillColor stored IsMouseOverFillColorStored;
    property MouseOverFillColorChange:Boolean read GetMouseOverFillColorChange write SetMouseOverFillColorChange stored IsMouseOverFillColorChangeStored;
    property MouseOverPenWidth:TControlSize read GetMouseOverPenWidth write SetMouseOverPenWidth stored IsMouseOverPenWidthStored;
    property MouseOverPenWidthChange:Boolean read GetMouseOverPenWidthChange write SetMouseOverPenWidthChange stored IsMouseOverPenWidthChangeStored;

    property PushedFillColor:TDelphiColor read GetPushedFillColor write SetPushedFillColor stored IsPushedFillColorStored;
    property PushedFillColorChange:Boolean read GetPushedFillColorChange write SetPushedFillColorChange stored IsPushedFillColorChangeStored;
    property PushedPenWidth:TControlSize read GetPushedPenWidth write SetPushedPenWidth stored IsPushedPenWidthStored;
    property PushedPenWidthChange:Boolean read GetPushedPenWidthChange write SetPushedPenWidthChange stored IsPushedPenWidthChangeStored;
  end;






  /// <summary>
  ///   <para>
  ///     路径绘制参数
  ///   </para>
  ///   <para>
  ///     Parameters of drawing rectangle
  ///   </para>
  /// </summary>
  TBaseDrawPathParam=class(TDrawParam)
  private
    FIsFill: Boolean;
    FFillDrawColor: TDrawColor;

    FPenDrawColor: TDrawColor;
    FPenWidth: TControlSize;

    FPathActions:TPathActionCollection;

    procedure SetPenDrawColor(const Value: TDrawColor);
    procedure SetFillDrawColor(const Value: TDrawColor);
    procedure SetPenWidth(const Value: TControlSize);
    procedure SetIsFill(const Value: Boolean);
    procedure SetPathActions(const Value: TPathActionCollection);

    function GetDrawEffectSetting: TDrawPathEffectSetting;
    procedure SetDrawEffectSetting(const Value: TDrawPathEffectSetting);
//    function GetSetting: TDrawPathParamSetting;
//    procedure SetSetting(const Value: TDrawPathParamSetting);
  private
    function IsRectParamPenWidthStored: Boolean;
    function IsIsFillStored: Boolean;virtual;
  protected
    /// <summary>
    ///   <para>
    ///     获取绘制参数效果类
    ///   </para>
    ///   <para>
    ///     Get effect class of drawing parameters
    ///   </para>
    /// </summary>
    function GetDrawEffectSettingClass:TDrawEffectSettingClass;override;
    function GetDrawParamSettingClass:TDrawParamSettingClass;override;
    /// <summary>
    ///   <para>
    ///     复制
    ///   </para>
    ///   <para>
    ///     Copy
    ///   </para>
    /// </summary>
    procedure AssignTo(Dest: TPersistent); override;
  public

    /// <summary>
    ///   <para>
    ///     从文档节点中加载
    ///   </para>
    ///   <para>
    ///     Load from document node
    ///   </para>
    /// </summary>
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //
    /// <summary>
    ///   <para>
    ///     保存到文档节点
    ///   </para>
    ///   <para>
    ///     Save to document node
    ///   </para>
    /// </summary>
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
//    function CustomLoadFromJson(ASuperObject:ISuperObject):Boolean;override;
//    function CustomSaveToJson(ASuperObject:ISuperObject):Boolean;override;
  public
    /// <summary>
    ///   <para>
    ///     当前效果的填充颜色
    ///   </para>
    ///   <para>
    ///     Fill color of current effect
    ///   </para>
    /// </summary>
    function CurrentEffectFillDrawColor:TDrawColor;
    /// <summary>
    ///   <para>
    ///     当前效果的是否填充
    ///   </para>
    ///   <para>
    ///     Whether fill current effect
    ///   </para>
    /// </summary>
    function CurrentEffectIsFill:Boolean;
    /// <summary>
    ///   <para>
    ///     当前效果的边框宽度
    ///   </para>
    ///   <para>
    ///     Border width of current effect
    ///   </para>
    /// </summary>
    function CurrentEffectPenWidth:TControlSize;
    /// <summary>
    ///   <para>
    ///     当前效果的边框颜色
    ///   </para>
    ///   <para>
    ///     Border color of current effect
    ///   </para>
    /// </summary>
    function CurrentEffectPenColor:TDrawColor;
  public
    /// <summary>
    ///   <para>
    ///     初始化参数
    ///   </para>
    ///   <para>
    ///     Initialize Parameter
    ///   </para>
    /// </summary>
    procedure Clear;override;
  public
    constructor Create(const AName:String;const ACaption:String);override;
    destructor Destroy;override;
  public
    /// <summary>
    ///   <para>
    ///     是否填充
    ///   </para>
    ///   <para>
    ///     Whether fill
    ///   </para>
    /// </summary>
    property IsFill:Boolean read FIsFill write SetIsFill stored IsIsFillStored;
    /// <summary>
    ///   <para>
    ///     填充颜色
    ///   </para>
    ///   <para>
    ///     Fill Color
    ///   </para>
    /// </summary>
    property FillDrawColor:TDrawColor read FFillDrawColor write SetFillDrawColor;
    /// <summary>
    ///   <para>
    ///     边框颜色
    ///   </para>
    ///   <para>
    ///     Border Color
    ///   </para>
    /// </summary>
    property PenDrawColor:TDrawColor read FPenDrawColor write SetPenDrawColor;





    /// <summary>
    ///   <para>
    ///     边框宽度
    ///   </para>
    ///   <para>
    ///     Border Width
    ///   </para>
    /// </summary>
    property PenWidth:TControlSize read FPenWidth write SetPenWidth stored IsRectParamPenWidthStored;


    property PathActions:TPathActionCollection read FPathActions write SetPathActions;


//    /// <summary>
//    ///   <para>
//    ///     绘制路径的设置
//    ///   </para>
//    ///   <para>
//    ///     Setting of DrawRectangle
//    ///   </para>
//    /// </summary>
//    property DrawRectSetting;

    property DrawEffectSetting:TDrawPathEffectSetting read GetDrawEffectSetting write SetDrawEffectSetting;

    //高级设置,DrawEffectSetting+DrawRectSetting
//    property Setting:TDrawPathParamSetting read GetSetting write SetSetting;
  end;





  TBaseNewDrawPathParam=class(TBaseDrawPathParam)
  private
    function GetPenColor: TDelphiColor;
    function GetFillColor: TDelphiColor;
    procedure SetPenColor(const Value: TDelphiColor);
    procedure SetFillColor(const Value: TDelphiColor);
    function IsPenColorStored: Boolean;
    function IsFillColorStored: Boolean;
  protected
    function IsIsFillStored: Boolean;override;
  public
    procedure Clear;override;
  public
    //填充色
    property FillColor:TDelphiColor read GetFillColor write SetFillColor stored IsFillColorStored;
    //边框色
    property PenColor:TDelphiColor read GetPenColor write SetPenColor stored IsPenColorStored;
  end;






  TDrawPathParam=class(TBaseDrawPathParam)
  published
    property IsFill;
    property FillColor:TDrawColor read FFillDrawColor write SetFillDrawColor;
    property PenColor:TDrawColor read FPenDrawColor write SetPenDrawColor;
    property PenWidth;

    property PathActions;

    property DrawRectSetting;
    property DrawEffectSetting;
  end;




function GetPathActionTypeStr(APathActionType:TPathActionType):String;
function GetPathActionType(APathActionTypeStr:String):TPathActionType;

function GetDPPEffectTypesStr(ADPPEffectTypes:TDPPEffectTypes):String;
function GetDPPEffectTypes(ADPPEffectTypesStr:String):TDPPEffectTypes;



implementation

uses
  uDrawEngine;




function GetDPPEffectTypesStr(ADPPEffectTypes:TDPPEffectTypes):String;
begin
  Result:='';
  if dppetFillColorChange in ADPPEffectTypes then
  begin
    Result:=Result+'FillColorChange';
  end;
  if dppetIsFillChange in ADPPEffectTypes then
  begin
    Result:=Result+'IsFillChange';
  end;
  if dppetPenWidthChange in ADPPEffectTypes then
  begin
    Result:=Result+'PenWidthChange';
  end;
  if dppetPenColorChange in ADPPEffectTypes then
  begin
    Result:=Result+'PenColorChange';
  end;
end;

function GetDPPEffectTypes(ADPPEffectTypesStr:String):TDPPEffectTypes;
var
  AStringList:TStringList;
begin
  Result:=[];
  AStringList:=TStringList.Create;
  try
    AStringList.CommaText:=ADPPEffectTypesStr;
    if AStringList.IndexOf('FillColorChange')<>-1 then
    begin
      Result:=Result+[TDPPEffectType.dppetFillColorChange];
    end;
    if AStringList.IndexOf('IsFillChange')<>-1 then
    begin
      Result:=Result+[TDPPEffectType.dppetIsFillChange];
    end;
    if AStringList.IndexOf('PenWidthChange')<>-1 then
    begin
      Result:=Result+[TDPPEffectType.dppetPenWidthChange];
    end;
    if AStringList.IndexOf('PenColorChange')<>-1 then
    begin
      Result:=Result+[TDPPEffectType.dppetPenColorChange];
    end;
  finally
    FreeAndNil(AStringList);
  end;
end;

function GetPathActionTypeStr(APathActionType:TPathActionType):String;
begin
  case APathActionType of
    patLineTo: Result:='LineTo';
    patMoveTo: Result:='MoveTo';
    patCurveTo: Result:='CurveTo';
    patClear: Result:='Clear';
    patFillPath: Result:='FillPath';
    patDrawPath: Result:='DrawPath';
  end;
end;

function GetPathActionType(APathActionTypeStr:String):TPathActionType;
begin
  Result:=patLineTo;
  if SameText(APathActionTypeStr,'LineTo') then
  begin
    Result:=patLineTo;
  end;
  if SameText(APathActionTypeStr,'MoveTo') then
  begin
    Result:=patMoveTo;
  end;
  if SameText(APathActionTypeStr,'CurveTo') then
  begin
    Result:=patCurveTo;
  end;
  if SameText(APathActionTypeStr,'Clear') then
  begin
    Result:=patClear;
  end;
  if SameText(APathActionTypeStr,'FillPath') then
  begin
    Result:=patFillPath;
  end;
  if SameText(APathActionTypeStr,'DrawPath') then
  begin
    Result:=patDrawPath;
  end;
end;

//将TDPPEffectTypes转换为字符串
function GetStrFromSet_TDPPEffectTypes(ASet:TDPPEffectTypes):String;
var
  I:TDPPEffectType;
begin
  Result:='';
  for I := Low(TDPPEffectType) to High(TDPPEffectType) do
  begin
    if I in ASet then
    begin
      Result:=Result+IntToStr(Ord(I))+',';
    end;
  end;
end;

//将字符串转换为TDPPEffectTypes
function GetSetFromStr_TDPPEffectTypes(const ASetStr:String):TDPPEffectTypes;
var
  I,AElem:Integer;
  J:TDPPEffectType;
  AStrList:TStringList;
begin
  Result:=[];
  AStrList:=TStringList.Create;
  try
    AStrList.CommaText:=ASetStr;
    for I := 0 to AStrList.Count-1 do
    begin
      if (Trim(AStrList[I])<>'') and TryStrToInt(AStrList[I],AElem) then
      begin
        for J := Low(TDPPEffectType) to High(TDPPEffectType) do
        begin
          if Ord(J) = AElem then
          begin
            Result:=Result+[J];
          end;
        end;
      end;
    end;
  finally
    FreeAndNil(AStrList);
  end;
end;



{ TBaseDrawPathParam }

function TBaseDrawPathParam.CurrentEffectFillDrawColor: TDrawColor;
begin
  Result:=Self.FFillDrawColor;
  if (CurrentEffect<>nil) and (dppetFillColorChange in TDrawPathParamEffect(CurrentEffect).FEffectTypes) then
  begin
    Result:=TDrawPathParamEffect(CurrentEffect).FFillDrawColor;
  end;
end;

function TBaseDrawPathParam.CurrentEffectIsFill:Boolean;
begin
  Result:=Self.FIsFill;
  if (CurrentEffect<>nil) and (dppetIsFillChange in TDrawPathParamEffect(CurrentEffect).FEffectTypes) then
  begin
    Result:=TDrawPathParamEffect(CurrentEffect).FIsFill;
  end;
end;

function TBaseDrawPathParam.CurrentEffectPenWidth:TControlSize;
begin
  Result:=Self.FPenWidth;
  if (CurrentEffect<>nil) and (dppetPenWidthChange in TDrawPathParamEffect(CurrentEffect).FEffectTypes) then
  begin
    Result:=TDrawPathParamEffect(CurrentEffect).FPenWidth;
  end;
end;

//function TBaseDrawPathParam.CustomLoadFromJson(ASuperObject: ISuperObject): Boolean;
//var
//  ASubJsonArray:ISuperArray;
//begin
//  Result:=False;
//
//
//  Self.FIsFill:=(ASuperObject.I['is_fill']=1);
//  Self.FFillDrawColor.Color:=WebHexToColor(ASuperObject.S['fill_color']);
//
//  Self.FPenWidth:=ASuperObject.F['pen_width'];
//  Self.FPenDrawColor.Color:=WebHexToColor(ASuperObject.S['fill_color']);
//
//  ASubJsonArray:=TSuperArray.Create(ASuperObject.S['path_actions']);
//  Self.FPathActions.LoadFromJsonArray(ASubJsonArray);
//
//  Result:=True;
//end;
//
//function TBaseDrawPathParam.CustomSaveToJson(ASuperObject: ISuperObject): Boolean;
//var
//  ASubJsonArray:ISuperArray;
//begin
//  Result:=False;
//
//  ASuperObject.S['type']:='DrawPathParam';
//
//  ASuperObject.F['pen_width']:=Self.FPenWidth;
//  ASuperObject.S['pen_color']:=ColorToWebHex(Self.FPenDrawColor.Color);
//
//  ASuperObject.I['is_fill']:=Ord(Self.FIsFill);
//  ASuperObject.S['fill_color']:=ColorToWebHex(Self.FFillDrawColor.Color);
//
//  ASubJsonArray:=TSuperArray.Create();
//  Self.FPathActions.SaveToJsonArray(ASubJsonArray);
//  ASuperObject.S['path_actions']:=ASubJsonArray.AsJson;
//
//  Result:=True;
//end;

function TBaseDrawPathParam.CurrentEffectPenColor:TDrawColor;
begin
  Result:=Self.FPenDrawColor;
  if (CurrentEffect<>nil) and (dppetPenColorChange in TDrawPathParamEffect(CurrentEffect).FEffectTypes) then
  begin
    Result:=TDrawPathParamEffect(CurrentEffect).FPenDrawColor;
  end;
end;

function TBaseDrawPathParam.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I:Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited LoadFromDocNode(ADocNode);



  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];


    if ABTNode.NodeName='IsFill' then
    begin
      FIsFill:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='FillDrawColor' then
    begin
      FFillDrawColor.Assign(ABTNode.ConvertNode_Color.Data);
    end


    else if ABTNode.NodeName='PenWidth' then
    begin
      FPenWidth:=ControlSize(ABTNode.ConvertNode_Real64.Data);
    end
    else if ABTNode.NodeName='PenDrawColor' then
    begin
      FPenDrawColor.Assign(ABTNode.ConvertNode_Color.Data);
    end

    ;

  end;

  Result:=True;
end;

function TBaseDrawPathParam.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);


  ABTNode:=ADocNode.AddChildNode_Bool32('IsFill','是否填充路径');
  ABTNode.ConvertNode_Bool32.Data:=FIsFill;

  ABTNode:=ADocNode.AddChildNode_Color('FillDrawColor','填充颜色');
  ABTNode.ConvertNode_Color.Data.Assign(FFillDrawColor);


  ABTNode:=ADocNode.AddChildNode_Color('PenDrawColor','边框颜色');
  ABTNode.ConvertNode_Color.Data.Assign(FPenDrawColor);

  ABTNode:=ADocNode.AddChildNode_Real64('PenWidth','边框宽度');
  ABTNode.ConvertNode_Real64.Data:=FPenWidth;


  Result:=True;

end;

destructor TBaseDrawPathParam.Destroy;
begin

  FreeAndNil(FPathActions);
  FreeAndNil(FFillDrawColor);
  FreeAndNil(FPenDrawColor);
  inherited;
end;

function TBaseDrawPathParam.GetDrawEffectSetting: TDrawPathEffectSetting;
begin
  Result:=TDrawPathEffectSetting(Self.FDrawEffectSetting);
end;

function TBaseDrawPathParam.GetDrawEffectSettingClass: TDrawEffectSettingClass;
begin
  Result:=TDrawPathEffectSetting;
end;

function TBaseDrawPathParam.GetDrawParamSettingClass: TDrawParamSettingClass;
begin
  Result:=TDrawPathParamSetting;
end;

//function TBaseDrawPathParam.GetSetting: TDrawPathParamSetting;
//begin
//  Result:=TDrawPathParamSetting(Self.FSetting);
//end;

function TBaseDrawPathParam.IsRectParamPenWidthStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FPenWidth,0);
end;

function TBaseDrawPathParam.IsIsFillStored: Boolean;
begin
  {$IFDEF FMX}
  Result:=(Self.FIsFill<>False);
  {$ENDIF}
  {$IFDEF VCL}
  //因为VCL默认为True
  Result:=True;
  {$ENDIF}
end;

procedure TBaseDrawPathParam.SetPathActions(const Value: TPathActionCollection);
begin
  FPathActions.Assign(Value);
end;

procedure TBaseDrawPathParam.SetPenDrawColor(const Value: TDrawColor);
begin
  FPenDrawColor.Assign(Value);
end;

procedure TBaseDrawPathParam.SetPenWidth(const Value: TControlSize);
begin
  if FPenWidth<>Value then
  begin
    FPenWidth := Value;
    DoChange;
  end;
end;


procedure TBaseDrawPathParam.SetDrawEffectSetting(
  const Value: TDrawPathEffectSetting);
begin

end;

procedure TBaseDrawPathParam.SetFillDrawColor(const Value: TDrawColor);
begin
  FFillDrawColor.Assign(Value);
end;


//procedure TBaseDrawPathParam.SetSetting(const Value: TDrawPathParamSetting);
//begin
//  FSetting.Assign(Value);
//end;

procedure TBaseDrawPathParam.SetIsFill(const Value: Boolean);
begin
  if FIsFill<>Value then
  begin
    FIsFill := Value;
    DoChange;
  end;
end;

procedure TBaseDrawPathParam.AssignTo(Dest: TPersistent);
var
  DestObject:TBaseDrawPathParam;
begin
  if Dest is TBaseDrawPathParam then
  begin

    DestObject:=TBaseDrawPathParam(Dest);


    DestObject.FIsFill:=FIsFill;
    DestObject.FFillDrawColor.Assign(FFillDrawColor);

    DestObject.FPenDrawColor.Assign(FPenDrawColor);
    DestObject.FPenWidth:=FPenWidth;

  end;
  Inherited;
end;

procedure TBaseDrawPathParam.Clear;
begin
  inherited Clear;


  FIsFill:=False;
//  FFillDrawColor.DefaultColor:=WhiteColor;
  FFillDrawColor.Color:=Const_DefaultFillColor;



  FPenDrawColor.Color:=BlackColor;

  FPenWidth:=0;


end;

constructor TBaseDrawPathParam.Create(const AName: String;const ACaption:String);
begin

  FFillDrawColor:=TDrawColor.Create('FillDrawColor','填充颜色');
  FFillDrawColor.StoredDefaultColor:=WhiteColor;
  FFillDrawColor.OnChange:=DoChange;


  FPenDrawColor:=CreateDrawColor('PenDrawColor','边框颜色');

  inherited Create(AName,ACaption);

  FPathActions:=TPathActionCollection.Create(TPathActionItem,Self,GlobalDrawPathDataClass);
end;


{ TDrawPathParamEffect }

procedure TDrawPathParamEffect.AssignTo(Dest: TPersistent);
var
  DestObject:TDrawPathParamEffect;
begin
  if Dest is TDrawPathParamEffect then
  begin
    DestObject:=TDrawPathParamEffect(Dest);
    DestObject.FFillDrawColor.Assign(FFillDrawColor);
    DestObject.FIsFill:=FIsFill;
    DestObject.FPenWidth:=FPenWidth;
    DestObject.FEffectTypes:=FEffectTypes;
  end;
  Inherited;
end;

constructor TDrawPathParamEffect.Create;
begin
  FFillDrawColor:=TDrawColor.Create('FillDrawColor','填充颜色');
  FPenDrawColor:=TDrawColor.Create('PenDrawColor','边框颜色');
  Inherited;

  FFillDrawColor.OnChange:=DoChange;
  FPenDrawColor.OnChange:=DoChange;
end;

destructor TDrawPathParamEffect.Destroy;
begin
  FreeAndNil(FFillDrawColor);
  FreeAndNil(FPenDrawColor);
  inherited;
end;

function TDrawPathParamEffect.HasEffectTypes: Boolean;
begin
  Result:=(Inherited HasEffectTypes) or (Self.FEffectTypes<>[]);
end;

function TDrawPathParamEffect.IsRectPenWidthStored: Boolean;
begin
  //边框不为1就保存
  Result:=IsNotSameDouble(Self.FPenWidth,0);
end;

function TDrawPathParamEffect.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I: Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited LoadFromDocNode(ADocNode);


  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='FillDrawColor' then
    begin
      Self.FFillDrawColor.Assign(ABTNode.ConvertNode_Color.Data);
    end
    else if ABTNode.NodeName='PenWidth' then
    begin
      Self.FPenWidth:=ControlSize(ABTNode.ConvertNode_Real64.Data);
    end
    else if ABTNode.NodeName='IsFill' then
    begin
      Self.FIsFill:=ABTNode.ConvertNode_Bool32.Data;
    end
    else if ABTNode.NodeName='EffectTypes' then
    begin
      Self.FEffectTypes:=GetSetFromStr_TDPPEffectTypes(ABTNode.ConvertNode_WideString.Data);
    end
    ;
  end;

  Result:=True;

end;

//function TDrawPathParamEffect.LoadFromJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Inherited;
//
//  Result:=False;
//
//  Self.FFillDrawColor.Color:=WebHexToColor(ASuperObject.S['fill_color']);
//  Self.FIsFill:=(ASuperObject.I['is_fill']=1);
//
//  Self.FPenWidth:=ASuperObject.F['pen_width'];
//  Self.FPenDrawColor.Color:=WebHexToColor(ASuperObject.S['pen_color']);
//
//  Self.FEffectTypes:=GetDPPEffectTypes(ASuperObject.S['effect_types']);
//
//  Result:=True;
//end;

function TDrawPathParamEffect.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);


  ABTNode:=ADocNode.AddChildNode_Color('FillDrawColor','字体颜色');
  ABTNode.ConvertNode_Color.Data.Assign(FFillDrawColor);

  ABTNode:=ADocNode.AddChildNode_Real64('PenWidth','边框宽度');
  ABTNode.ConvertNode_Real64.Data:=FPenWidth;

  ABTNode:=ADocNode.AddChildNode_Bool32('IsFill','是否填充');
  ABTNode.ConvertNode_Bool32.Data:=FIsFill;

  ABTNode:=ADocNode.AddChildNode_WideString('EffectTypes','效果集');
  ABTNode.ConvertNode_WideString.Data:=GetStrFromSet_TDPPEffectTypes(FEffectTypes);


  Result:=True;
end;

//function TDrawPathParamEffect.SaveToJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Inherited;
//
//  Result:=False;
//
//  ASuperObject.S['fill_color']:=ColorToWebHex(Self.FFillDrawColor.Color);
//  ASuperObject.I['is_fill']:=Ord(Self.FIsFill);
//
//  ASuperObject.S['pen_color']:=ColorToWebHex(Self.FPenDrawColor.Color);
//  ASuperObject.F['pen_width']:=Self.FPenWidth;
//
//  ASuperObject.S['effect_types']:=GetDPPEffectTypesStr(Self.FEffectTypes);
//
//  Result:=True;
//end;

procedure TDrawPathParamEffect.SetPenDrawColor(const Value: TDrawColor);
begin
  FPenDrawColor.Assign(Value);
end;

procedure TDrawPathParamEffect.SetPenWidth(const Value: TControlSize);
begin
  if FPenWidth<>Value then
  begin
    FPenWidth := Value;
    DoChange;
  end;
end;

procedure TDrawPathParamEffect.SetEffectTypes(const Value: TDPPEffectTypes);
begin
  if FEffectTypes<>Value then
  begin
    FEffectTypes := Value;
    DoChange;
  end;
end;

procedure TDrawPathParamEffect.SetFillDrawColor(const Value: TDrawColor);
begin
  FFillDrawColor.Assign(Value);
end;

procedure TDrawPathParamEffect.SetIsFill(const Value: Boolean);
begin
  if FIsFill<>Value then
  begin
    FIsFill := Value;
    DoChange;
  end;
end;

function TDrawPathParamEffect.IsEffectTypesStored: Boolean;
begin
  Result:=(Self.FEffectTypes<>[]);
end;

function TDrawPathParamEffect.IsIsFillStored: Boolean;
begin
  Result:=(Self.FIsFill<>False);
end;


{ TDrawPathParamSetting }



constructor TDrawPathParamSetting.Create(ADrawParam: TDrawParam);
begin
  inherited;
  FDrawPathParam:=TDrawPathParam(ADrawParam);
end;

function TDrawPathParamSetting.GetMouseDownFillColor: TDelphiColor;
begin
  Result:=FDrawPathParam.DrawEffectSetting.MouseDownEffect.FFillDrawColor.Color;
end;

function TDrawPathParamSetting.GetMouseDownFillColorChange: Boolean;
begin
  Result:=dppetFillColorChange in FDrawPathParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawPathParamSetting.GetMouseOverFillColor: TDelphiColor;
begin
  Result:=FDrawPathParam.DrawEffectSetting.MouseOverEffect.FFillDrawColor.Color;
end;

function TDrawPathParamSetting.GetMouseOverFillColorChange: Boolean;
begin
  Result:=dppetFillColorChange in FDrawPathParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawPathParamSetting.GetPushedFillColor: TDelphiColor;
begin
  Result:=FDrawPathParam.DrawEffectSetting.PushedEffect.FFillDrawColor.Color;
end;

function TDrawPathParamSetting.GetPushedFillColorChange: Boolean;
begin
  Result:=dppetFillColorChange in FDrawPathParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;



procedure TDrawPathParamSetting.SetMouseDownFillColor(const Value: TDelphiColor);
begin
  FDrawPathParam.DrawEffectSetting.MouseDownEffect.FillColor.Color:=Value;
end;

procedure TDrawPathParamSetting.SetMouseDownFillColorChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPathParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.MouseDownEffect.EffectTypes+[dppetFillColorChange];
  end
  else
  begin
    FDrawPathParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.MouseDownEffect.EffectTypes-[dppetFillColorChange];
  end;
end;

procedure TDrawPathParamSetting.SetMouseOverFillColor(const Value: TDelphiColor);
begin
  FDrawPathParam.DrawEffectSetting.MouseOverEffect.FillColor.Color:=Value;
end;

procedure TDrawPathParamSetting.SetMouseOverFillColorChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPathParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.MouseOverEffect.EffectTypes+[dppetFillColorChange];
  end
  else
  begin
    FDrawPathParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.MouseOverEffect.EffectTypes-[dppetFillColorChange];
  end;
end;

procedure TDrawPathParamSetting.SetPushedFillColor(const Value: TDelphiColor);
begin
  FDrawPathParam.DrawEffectSetting.PushedEffect.FillColor.Color:=Value;
end;

procedure TDrawPathParamSetting.SetPushedFillColorChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPathParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.PushedEffect.EffectTypes+[dppetFillColorChange];
  end
  else
  begin
    FDrawPathParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.PushedEffect.EffectTypes-[dppetFillColorChange];
  end;
end;





function TDrawPathParamSetting.GetMouseDownPenWidth: TControlSize;
begin
  Result:=FDrawPathParam.DrawEffectSetting.MouseDownEffect.PenWidth;
end;

function TDrawPathParamSetting.GetMouseDownPenWidthChange: Boolean;
begin
  Result:=dppetPenWidthChange in FDrawPathParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawPathParamSetting.GetMouseOverPenWidth: TControlSize;
begin
  Result:=FDrawPathParam.DrawEffectSetting.MouseOverEffect.PenWidth;
end;

function TDrawPathParamSetting.GetMouseOverPenWidthChange: Boolean;
begin
  Result:=dppetPenWidthChange in FDrawPathParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawPathParamSetting.GetPushedPenWidth: TControlSize;
begin
  Result:=FDrawPathParam.DrawEffectSetting.PushedEffect.PenWidth;
end;

function TDrawPathParamSetting.GetPushedPenWidthChange: Boolean;
begin
  Result:=dppetPenWidthChange in FDrawPathParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;



procedure TDrawPathParamSetting.SetMouseDownPenWidth(const Value: TControlSize);
begin
  FDrawPathParam.DrawEffectSetting.MouseDownEffect.PenWidth:=Value;
end;

procedure TDrawPathParamSetting.SetMouseDownPenWidthChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPathParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.MouseDownEffect.EffectTypes+[dppetPenWidthChange];
  end
  else
  begin
    FDrawPathParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.MouseDownEffect.EffectTypes-[dppetPenWidthChange];
  end;
end;

procedure TDrawPathParamSetting.SetMouseOverPenWidth(const Value: TControlSize);
begin
  FDrawPathParam.DrawEffectSetting.MouseOverEffect.PenWidth:=Value;
end;

procedure TDrawPathParamSetting.SetMouseOverPenWidthChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPathParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.MouseOverEffect.EffectTypes+[dppetPenWidthChange];
  end
  else
  begin
    FDrawPathParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.MouseOverEffect.EffectTypes-[dppetPenWidthChange];
  end;
end;

procedure TDrawPathParamSetting.SetPushedPenWidth(const Value: TControlSize);
begin
  FDrawPathParam.DrawEffectSetting.PushedEffect.PenWidth:=Value;
end;

procedure TDrawPathParamSetting.SetPushedPenWidthChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPathParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.PushedEffect.EffectTypes+[dppetPenWidthChange];
  end
  else
  begin
    FDrawPathParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.PushedEffect.EffectTypes-[dppetPenWidthChange];
  end;
end;



function TDrawPathParamSetting.GetMouseDownIsFill: Boolean;
begin
  Result:=FDrawPathParam.DrawEffectSetting.MouseDownEffect.FIsFill;
end;

function TDrawPathParamSetting.GetMouseDownIsFillChange: Boolean;
begin
  Result:=dppetIsFillChange in FDrawPathParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawPathParamSetting.GetMouseOverIsFill: Boolean;
begin
  Result:=FDrawPathParam.DrawEffectSetting.MouseOverEffect.FIsFill;
end;

function TDrawPathParamSetting.GetMouseOverIsFillChange: Boolean;
begin
  Result:=dppetIsFillChange in FDrawPathParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawPathParamSetting.GetPushedIsFill: Boolean;
begin
  Result:=FDrawPathParam.DrawEffectSetting.PushedEffect.FIsFill;
end;

function TDrawPathParamSetting.GetPushedIsFillChange: Boolean;
begin
  Result:=dppetIsFillChange in FDrawPathParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;



function TDrawPathParamSetting.IsMouseDownPenWidthChangeStored: Boolean;
begin
  Result:=dppetPenWidthChange in FDrawPathParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawPathParamSetting.IsMouseDownPenWidthStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawPathParam.DrawEffectSetting.MouseDownEffect.FPenWidth,0);
end;

function TDrawPathParamSetting.IsMouseDownFillColorChangeStored: Boolean;
begin
  Result:=dppetFillColorChange in FDrawPathParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawPathParamSetting.IsMouseDownFillColorStored: Boolean;
begin
  Result:=Self.FDrawPathParam.DrawEffectSetting.MouseDownEffect.FFillDrawColor.Color<>Const_DefaultColor;
end;

function TDrawPathParamSetting.IsMouseDownIsFillChangeStored: Boolean;
begin
  Result:=dppetIsFillChange in FDrawPathParam.DrawEffectSetting.MouseDownEffect.FEffectTypes;
end;

function TDrawPathParamSetting.IsMouseDownIsFillStored: Boolean;
begin
  Result:=Self.FDrawPathParam.DrawEffectSetting.MouseDownEffect.FIsFill<>False;
end;

function TDrawPathParamSetting.IsMouseOverPenWidthChangeStored: Boolean;
begin
  Result:=dppetPenWidthChange in FDrawPathParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawPathParamSetting.IsMouseOverPenWidthStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawPathParam.DrawEffectSetting.MouseOverEffect.FPenWidth,0);
end;

function TDrawPathParamSetting.IsMouseOverFillColorChangeStored: Boolean;
begin
  Result:=dppetFillColorChange in FDrawPathParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawPathParamSetting.IsMouseOverFillColorStored: Boolean;
begin
  Result:=Self.FDrawPathParam.DrawEffectSetting.MouseOverEffect.FFillDrawColor.Color<>Const_DefaultColor;
end;

function TDrawPathParamSetting.IsMouseOverIsFillChangeStored: Boolean;
begin
  Result:=dppetIsFillChange in FDrawPathParam.DrawEffectSetting.MouseOverEffect.FEffectTypes;
end;

function TDrawPathParamSetting.IsMouseOverIsFillStored: Boolean;
begin
  Result:=Self.FDrawPathParam.DrawEffectSetting.MouseOverEffect.FIsFill<>False;
end;

function TDrawPathParamSetting.IsPushedPenWidthChangeStored: Boolean;
begin
  Result:=dppetPenWidthChange in FDrawPathParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;

function TDrawPathParamSetting.IsPushedPenWidthStored: Boolean;
begin
  Result:=IsNotSameDouble(Self.FDrawPathParam.DrawEffectSetting.PushedEffect.FPenWidth,0);
end;

function TDrawPathParamSetting.IsPushedFillColorChangeStored: Boolean;
begin
  Result:=dppetFillColorChange in FDrawPathParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;

function TDrawPathParamSetting.IsPushedFillColorStored: Boolean;
begin
  Result:=Self.FDrawPathParam.DrawEffectSetting.PushedEffect.FFillDrawColor.Color<>Const_DefaultColor;
end;

function TDrawPathParamSetting.IsPushedIsFillChangeStored: Boolean;
begin
  Result:=dppetIsFillChange in FDrawPathParam.DrawEffectSetting.PushedEffect.FEffectTypes;
end;

function TDrawPathParamSetting.IsPushedIsFillStored: Boolean;
begin
  Result:=Self.FDrawPathParam.DrawEffectSetting.PushedEffect.FIsFill<>False;
end;

procedure TDrawPathParamSetting.SetMouseDownIsFill(const Value: Boolean);
begin
  FDrawPathParam.DrawEffectSetting.MouseDownEffect.IsFill:=Value;
end;

procedure TDrawPathParamSetting.SetMouseDownIsFillChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPathParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.MouseDownEffect.EffectTypes+[dppetIsFillChange];
  end
  else
  begin
    FDrawPathParam.DrawEffectSetting.MouseDownEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.MouseDownEffect.EffectTypes-[dppetIsFillChange];
  end;
end;

procedure TDrawPathParamSetting.SetMouseOverIsFill(const Value: Boolean);
begin
  FDrawPathParam.DrawEffectSetting.MouseOverEffect.IsFill:=Value;
end;

procedure TDrawPathParamSetting.SetMouseOverIsFillChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPathParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.MouseOverEffect.EffectTypes+[dppetIsFillChange];
  end
  else
  begin
    FDrawPathParam.DrawEffectSetting.MouseOverEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.MouseOverEffect.EffectTypes-[dppetIsFillChange];
  end;
end;

procedure TDrawPathParamSetting.SetPushedIsFill(const Value: Boolean);
begin
  FDrawPathParam.DrawEffectSetting.PushedEffect.IsFill:=Value;
end;

procedure TDrawPathParamSetting.SetPushedIsFillChange(const Value: Boolean);
begin
  if Value then
  begin
    FDrawPathParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.PushedEffect.EffectTypes+[dppetIsFillChange];
  end
  else
  begin
    FDrawPathParam.DrawEffectSetting.PushedEffect.EffectTypes:=
      FDrawPathParam.DrawEffectSetting.PushedEffect.EffectTypes-[dppetIsFillChange];
  end;
end;





{ TBaseNewDrawPathParam }

procedure TBaseNewDrawPathParam.Clear;
begin
  inherited;

  Self.FIsFill:=True;
end;

function TBaseNewDrawPathParam.GetPenColor: TDelphiColor;
begin
  Result:=Self.FPenDrawColor.Color;
end;

function TBaseNewDrawPathParam.GetFillColor: TDelphiColor;
begin
  Result:=Self.FFillDrawColor.Color;
end;

function TBaseNewDrawPathParam.IsPenColorStored: Boolean;
begin
  Result:=Self.FPenDrawColor.Color<>Const_DefaultColor;
end;

function TBaseNewDrawPathParam.IsFillColorStored: Boolean;
begin
  Result:=Self.FFillDrawColor.Color<>Const_DefaultFillColor;
end;

function TBaseNewDrawPathParam.IsIsFillStored: Boolean;
begin
  Result:=FIsFill<>True;
end;

procedure TBaseNewDrawPathParam.SetPenColor(const Value: TDelphiColor);
begin
  Self.FPenDrawColor.Color:=Value;
end;

procedure TBaseNewDrawPathParam.SetFillColor(const Value: TDelphiColor);
begin
  Self.FFillDrawColor.Color:=Value;
end;




{ TDrawPathEffectSetting }

function TDrawPathEffectSetting.GetDisabledEffect: TDrawPathParamEffect;
begin
  Result:=TDrawPathParamEffect(Self.FDisabledEffect);
end;

function TDrawPathEffectSetting.GetDrawParamEffectClass: TDrawParamCommonEffectClass;
begin
  Result:=TDrawPathParamEffect;
end;

function TDrawPathEffectSetting.GetFocusedEffect: TDrawPathParamEffect;
begin
  Result:=TDrawPathParamEffect(Self.FFocusedEffect);
end;

function TDrawPathEffectSetting.GetMouseDownEffect: TDrawPathParamEffect;
begin
  Result:=TDrawPathParamEffect(Self.FMouseDownEffect);
end;

function TDrawPathEffectSetting.GetMouseOverEffect: TDrawPathParamEffect;
begin
  Result:=TDrawPathParamEffect(Self.FMouseOverEffect);
end;

function TDrawPathEffectSetting.GetPushedEffect: TDrawPathParamEffect;
begin
  Result:=TDrawPathParamEffect(Self.FPushedEffect);
end;

procedure TDrawPathEffectSetting.SetDisabledEffect(
  const Value: TDrawPathParamEffect);
begin
  FDisabledEffect.Assign(Value);
end;

procedure TDrawPathEffectSetting.SetFocusedEffect(
  const Value: TDrawPathParamEffect);
begin
  FFocusedEffect.Assign(Value);
end;

procedure TDrawPathEffectSetting.SetMouseDownEffect(
  const Value: TDrawPathParamEffect);
begin
  FMouseDownEffect.Assign(Value);
end;

procedure TDrawPathEffectSetting.SetMouseOverEffect(
  const Value: TDrawPathParamEffect);
begin
  FMouseOverEffect.Assign(Value);
end;

procedure TDrawPathEffectSetting.SetPushedEffect(
  const Value: TDrawPathParamEffect);
begin
  FPushedEffect.Assign(Value);
end;


{ TPathActionItem }

procedure TPathActionItem.AssignTo(Dest: TPersistent);
begin
  if (Dest<>nil) and (Dest is TPathActionItem) then
  begin
    TPathActionItem(Dest).FActionType:=FActionType;
    TPathActionItem(Dest).FX:=FX;
    TPathActionItem(Dest).FY:=FY;
    TPathActionItem(Dest).FSizeType:=FSizeType;
  end
  else
  begin
    Inherited;
  end;
end;

constructor TPathActionItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);

end;

function TPathActionItem.GetX(const ADrawRect: TRectF): TControlSize;
begin
  case Self.FSizeType of
    dpstPixel: Result:=FX;
    dpstPercent: Result:=ControlSize(FX/100*(RectWidthF(ADrawRect)));
  end;
end;

function TPathActionItem.GetY(const ADrawRect: TRectF): TControlSize;
begin
  case Self.FSizeType of
    dpstPixel: Result:=FY;
    dpstPercent: Result:=ControlSize(FY/100*(RectHeightF(ADrawRect)));
  end;
end;

function TPathActionItem.GetX1(const ADrawRect: TRectF): TControlSize;
begin
  case Self.FSizeType of
    dpstPixel: Result:=FX1;
    dpstPercent: Result:=ControlSize(FX1/100*(RectWidthF(ADrawRect)));
  end;
end;

function TPathActionItem.GetY1(const ADrawRect: TRectF): TControlSize;
begin
  case Self.FSizeType of
    dpstPixel: Result:=FY1;
    dpstPercent: Result:=ControlSize(FY1/100*(RectHeightF(ADrawRect)));
  end;
end;

function TPathActionItem.GetX2(const ADrawRect: TRectF): TControlSize;
begin
  case Self.FSizeType of
    dpstPixel: Result:=FX2;
    dpstPercent: Result:=ControlSize(FX2/100*(RectWidthF(ADrawRect)));
  end;
end;

function TPathActionItem.GetY2(const ADrawRect: TRectF): TControlSize;
begin
  case Self.FSizeType of
    dpstPixel: Result:=FY2;
    dpstPercent: Result:=ControlSize(FY2/100*(RectHeightF(ADrawRect)));
  end;
end;

//function TPathActionItem.LoadFromJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  FActionType:=GetPathActionType(ASuperObject.S['action_type']);
//  FX:=ASuperObject.F['x'];
//  FY:=ASuperObject.F['y'];
//
//  FX1:=ASuperObject.F['x1'];
//  FY1:=ASuperObject.F['y1'];
//
//  FX2:=ASuperObject.F['x2'];
//  FY2:=ASuperObject.F['y2'];
//
//  FSizeType:=GetSizeType(ASuperObject.S['size_type']);
//
//  Result:=True;
//end;
//
//function TPathActionItem.SaveToJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  ASuperObject.S['action_type']:=GetPathActionTypeStr(FActionType);
//  ASuperObject.F['x']:=FX;
//  ASuperObject.F['y']:=FY;
//
//  ASuperObject.F['x1']:=FX1;
//  ASuperObject.F['y1']:=FY1;
//
//  ASuperObject.F['x2']:=FX2;
//  ASuperObject.F['y2']:=FY2;
//
//  ASuperObject.S['size_type']:=GetSizeTypeStr(FSizeType);
//
//  Result:=True;
//end;

procedure TPathActionItem.SetActionType(const Value: TPathActionType);
begin
  if FActionType<>Value then
  begin
    FActionType := Value;
    TPathActionCollection(Self.Collection).FDrawPathParam.DoChange();
  end;
end;

procedure TPathActionItem.SetSizeType(const Value: TDPSizeType);
begin
  if FSizeType<>Value then
  begin
    FSizeType := Value;
    TPathActionCollection(Self.Collection).FDrawPathParam.DoChange();
  end;
end;

procedure TPathActionItem.SetX(const Value: TControlSize);
begin
  if FX<>Value then
  begin
    FX := Value;
    TPathActionCollection(Self.Collection).FDrawPathParam.DoChange();
  end;
end;

procedure TPathActionItem.SetY(const Value: TControlSize);
begin
  if FY<>Value then
  begin
    FY := Value;
    TPathActionCollection(Self.Collection).FDrawPathParam.DoChange();
  end;
end;

procedure TPathActionItem.SetX1(const Value: TControlSize);
begin
  if FX1<>Value then
  begin
    FX1 := Value;
    TPathActionCollection(Self.Collection).FDrawPathParam.DoChange();
  end;
end;

procedure TPathActionItem.SetY1(const Value: TControlSize);
begin
  if FY1<>Value then
  begin
    FY1 := Value;
    TPathActionCollection(Self.Collection).FDrawPathParam.DoChange();
  end;
end;

procedure TPathActionItem.SetX2(const Value: TControlSize);
begin
  if FX2<>Value then
  begin
    FX2 := Value;
    TPathActionCollection(Self.Collection).FDrawPathParam.DoChange();
  end;
end;

procedure TPathActionItem.SetY2(const Value: TControlSize);
begin
  if FY2<>Value then
  begin
    FY2 := Value;
    TPathActionCollection(Self.Collection).FDrawPathParam.DoChange();
  end;
end;

{ TPathActionCollection }


constructor TPathActionCollection.Create(ItemClass: TCollectionItemClass;
                      ADrawPathParam:TBaseDrawPathParam;
                      ADrawPathDataClass:TDrawPathDataClass);
begin
  Inherited Create(ItemClass);
  FDrawPathData:=ADrawPathDataClass.Create;
  FDrawPathParam:=ADrawPathParam;
end;

procedure TPathActionCollection.CurveTo(const P, P1, P2: TPointF;ASizeType: TDPSizeType);
var
  APathActionItem:TPathActionItem;
begin
  APathActionItem:=TPathActionItem(Self.Add);
  APathActionItem.ActionType:=patCurveTo;
  APathActionItem.SizeType:=ASizeType;
  APathActionItem.X:=ControlSize(P.X);
  APathActionItem.Y:=ControlSize(P.Y);
  APathActionItem.X1:=ControlSize(P1.X);
  APathActionItem.Y1:=ControlSize(P1.Y);
  APathActionItem.X2:=ControlSize(P2.X);
  APathActionItem.Y2:=ControlSize(P2.Y);
end;

destructor TPathActionCollection.Destroy;
begin
  FreeAndNil(FDrawPathData);
  inherited;
end;

function TPathActionCollection.GetItem(Index: Integer): TPathActionItem;
begin
  Result:=TPathActionItem(Inherited Items[Index]);
end;

procedure TPathActionCollection.LineTo(const P: TPointF;ASizeType: TDPSizeType);
var
  APathActionItem:TPathActionItem;
begin
  APathActionItem:=TPathActionItem(Self.FDrawPathParam.PathActions.Add);
  APathActionItem.ActionType:=patLineTo;
  APathActionItem.SizeType:=ASizeType;
  APathActionItem.X:=ControlSize(P.X);
  APathActionItem.Y:=ControlSize(P.Y);
end;

//function TPathActionCollection.LoadFromJsonArray(ASuperArray: ISuperArray): Boolean;
//var
//  I: Integer;
//  AItem:TPathActionItem;
//  ASuperObject:ISuperObject;
//begin
//  Result:=False;
//
//  Self.Clear;
//
//  for I := 0 to ASuperArray.Length-1 do
//  begin
//    AItem:=TPathActionItem(Self.Add);
//    AItem.LoadFromJson(ASuperArray.O[I]);
//  end;
//
//  Result:=True;
//end;

procedure TPathActionCollection.MoveTo(const P: TPointF;ASizeType: TDPSizeType);
var
  APathActionItem:TPathActionItem;
begin
  APathActionItem:=TPathActionItem(Self.Add);
  APathActionItem.ActionType:=patMoveTo;
  APathActionItem.SizeType:=ASizeType;
  APathActionItem.X:=ControlSize(P.X);
  APathActionItem.Y:=ControlSize(P.Y);
end;

//function TPathActionCollection.SaveToJsonArray(ASuperArray: ISuperArray): Boolean;
//var
//  I: Integer;
//  AItem:TPathActionItem;
//  ASuperObject:ISuperObject;
//begin
//  Result:=False;
//
//  for I := 0 to Self.Count-1 do
//  begin
//    AItem:=TPathActionItem(Self.Items[I]);
//    ASuperObject:=TSuperObject.Create();
//    AItem.SaveToJson(ASuperObject);
//    ASuperArray.O[I]:=ASuperObject;
//  end;
//
//  Result:=True;
//end;

procedure TPathActionCollection.SetItem(Index: Integer;const Value: TPathActionItem);
begin
  Inherited Items[Index]:=Value;
end;








end.
