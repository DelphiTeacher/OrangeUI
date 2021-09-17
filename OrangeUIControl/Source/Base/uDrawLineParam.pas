//convert pas to utf8 by ¥
/// <summary>
///   <para>
///     绘制直线参数
///   </para>
///   <para>
///     Parameters of drawing line
///   </para>
/// </summary>
unit uDrawLineParam;





interface
{$I FrameWork.inc}

uses
  Classes,
  SysUtils,

  {$IFDEF VCL}
  Graphics,
  {$ENDIF}
  {$IFDEF FMX}
  UITypes,
  {$ENDIF}


//  XSuperObject,


  uGraphicCommon,
  uBinaryTreeDoc,
  uFuncCommon,
  uDrawParam;





type
  /// <summary>
  ///   <para>
  ///     绘制直线参数
  ///   </para>
  ///   <para>
  ///       Parameters of drawing line
  ///   </para>
  /// </summary>
  TBaseDrawLineParam=class(TDrawParam)
  private
    FPenDrawColor: TDrawColor;
    FPenWidth: Double;
    procedure SetPenDrawColor(const Value: TDrawColor);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    //从文档节点中加载
    function LoadFromDocNode(ADocNode:TBTNode20_Class):Boolean;override;
    //保存到文档节点
    function SaveToDocNode(ADocNode:TBTNode20_Class):Boolean;override;
  public
//    function CustomLoadFromJson(ASuperObject:ISuperObject):Boolean;override;
//    function CustomSaveToJson(ASuperObject:ISuperObject):Boolean;override;
  public
    //初始化参数
    procedure Clear;override;
  public
    constructor Create(const AName:String;const ACaption:String);override;
    destructor Destroy;override;
  public
    /// <summary>
    ///   <para>
    ///     画笔的颜色
    ///   </para>
    ///   <para>
    ///    Pen color
    ///   </para>
    /// </summary>
    property PenDrawColor:TDrawColor read FPenDrawColor write SetPenDrawColor;
    /// <summary>
    ///   <para>
    ///     画笔的宽度
    ///   </para>
    ///   <para>
    ///     Pen width
    ///   </para>
    /// </summary>
    property PenWidth:Double read FPenWidth write FPenWidth;
  end;


  TBaseNewDrawLineParam=class(TBaseDrawLineParam)
  private
    function GetPenColor: TDelphiColor;
    procedure SetPenColor(const Value: TDelphiColor);
  public
    property PenColor:TDelphiColor read GetPenColor write SetPenColor;
  end;


  TDrawLineParam=class(TBaseDrawLineParam)
  published
    property Color:TDrawColor read FPenDrawColor write SetPenDrawColor;
    property PenWidth;
    property DrawRectSetting;
  end;



implementation




{ TBaseDrawLineParam }

function TBaseDrawLineParam.LoadFromDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  I:Integer;
  ABTNode:TBTNode20;
begin
  Result:=False;


  Inherited LoadFromDocNode(ADocNode);

  for I := 0 to ADocNode.ChildNodes.Count - 1 do
  begin
    ABTNode:=ADocNode.ChildNodes[I];

    if ABTNode.NodeName='PenWidth' then
    begin
      FPenWidth:=ABTNode.ConvertNode_Real64.Data;
    end
    else if ABTNode.NodeName='PenDrawColor' then
    begin
      FPenDrawColor.Assign(ABTNode.ConvertNode_Color.Data);
    end
    ;

  end;

  Result:=True;
end;

function TBaseDrawLineParam.SaveToDocNode(ADocNode: TBTNode20_Class): Boolean;
var
  ABTNode:TBTNode20;
begin
  Result:=False;

  Inherited SaveToDocNode(ADocNode);

  ABTNode:=ADocNode.AddChildNode_Real64('PenWidth','画笔的宽度');
  ABTNode.ConvertNode_Real64.Data:=FPenWidth;

  ABTNode:=ADocNode.AddChildNode_Color('PenDrawColor','画笔的颜色');
  ABTNode.ConvertNode_Color.Data.Assign(FPenDrawColor);

  Result:=True;
end;

destructor TBaseDrawLineParam.Destroy;
begin
  FreeAndNil(FPenDrawColor);
  inherited;
end;

procedure TBaseDrawLineParam.SetPenDrawColor(const Value: TDrawColor);
begin
  FPenDrawColor.Assign(Value);
end;

procedure TBaseDrawLineParam.AssignTo(Dest: TPersistent);
var
  DestObject:TBaseDrawLineParam;
begin
  if (Dest is TBaseDrawLineParam) then
  begin
    DestObject:=TBaseDrawLineParam(Dest);
    DestObject.FPenDrawColor.Assign(FPenDrawColor);
  end;
  Inherited;
end;

procedure TBaseDrawLineParam.Clear;
begin
  inherited Clear;

  FPenWidth:=DefaultPenWidth;
end;

constructor TBaseDrawLineParam.Create(const AName: String;const ACaption:String);
begin
  FPenDrawColor:=CreateDrawColor('PenDrawColor','画笔的颜色');
  inherited Create(AName,ACaption);
end;

//function TBaseDrawLineParam.CustomLoadFromJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  Self.FPenWidth:=ASuperObject.F['pen_width'];
//  Self.FPenDrawColor.Color:=WebHexToColor(ASuperObject.S['pen_color']);
//
//  Result:=True;
//end;
//
//function TBaseDrawLineParam.CustomSaveToJson(ASuperObject: ISuperObject): Boolean;
//begin
//  Result:=False;
//
//  ASuperObject.S['type']:='DrawLineParam';
//
//  ASuperObject.F['pen_width']:=Self.FPenWidth;
//  ASuperObject.S['pen_color']:=ColorToWebHex(Self.FPenDrawColor.Color);
//
//  Result:=True;
//end;

{ TBaseNewDrawLineParam }

function TBaseNewDrawLineParam.GetPenColor: TDelphiColor;
begin
  Result:=Self.FPenDrawColor.Color;
end;

procedure TBaseNewDrawLineParam.SetPenColor(const Value: TDelphiColor);
begin
  Self.FPenDrawColor.Color:=Value;
end;

end.

