//convert pas to utf8 by ¥
unit uBasePathData;

interface


{$I FrameWork.inc}

uses
  Classes,
  Math,
  SysUtils,

  {$IF CompilerVersion>=30.0}
  Types,//定义了TRectF
  {$IFEND}

  {$IFDEF VCL}
  Windows,
  Messages,
  Controls,
  Graphics,
  {$ENDIF}


  {$IFDEF FMX}
  UITypes,
  FMX.Types,
  FMX.Graphics,
  {$ENDIF}

  uBaseLog,
  uFuncCommon,
  uGraphicCommon;




type
  TDrawPathDataClass=class of TBaseDrawPathData;



  /// <summary>
  ///   <para>
  ///     Path数据的基类
  ///   </para>
  ///   <para>
  ///     Base class of Path data
  ///   </para>
  /// </summary>
  TBaseDrawPathData=class
  public

    /// <summary>
    ///   <para>
    ///     画笔的宽度
    ///   </para>
    ///   <para>
    ///     Width of pen
    ///   </para>
    /// </summary>
    PenWidth:Double;
    /// <summary>
    ///   <para>
    ///     画笔的颜色
    ///   </para>
    ///   <para>
    ///     Color of pen
    ///   </para>
    /// </summary>
    PenColor:TDrawColor;
  public
    constructor Create;virtual;
    destructor Destroy;override;
  public

    procedure Clear;virtual;
    procedure MoveTo(const X:Double;const Y:Double);virtual;abstract;
    procedure CurveTo(const X:Double;const Y:Double;
                    const X1:Double;const Y1:Double;
                    const X2:Double;const Y2:Double);virtual;abstract;
    procedure LineTo(const X:Double;const Y:Double);virtual;abstract;
    procedure AddRect(const ARect:TRectF);virtual;abstract;
    procedure AddPie(const ARect:TRectF;
                      AStartAngle, ASweepAngle:Double
                      );virtual;abstract;
    //添加一个圆边
    procedure AddArc(const ARect:TRectF;
                      AStartAngle, ASweepAngle:Double
                      );virtual;abstract;
    //添加一个圆
    procedure AddEllipse(const ARect:TRectF);virtual;abstract;
//    //闭合路径
//    procedure Close;virtual;abstract;
//    //获取区域,用来判断鼠标是否在区域内
//    procedure GetRegion;virtual;abstract;
//    //判断鼠标是否在路径内
//    function IsInRegion(const APoint: TPointF):Boolean;virtual;abstract;
  end;






implementation



{ TBaseDrawPathData }

procedure TBaseDrawPathData.Clear;
begin

end;

constructor TBaseDrawPathData.Create;
begin
  PenWidth:=DefaultPenWidth;
  PenColor:=TDrawColor.Create('','');
end;

destructor TBaseDrawPathData.Destroy;
begin
  FreeAndNil(PenColor);
  inherited;
end;

//function TBaseDrawPathData.LineTo(const X:Double;const Y:Double): Boolean;
//begin
//  Result:=True;
//end;
//
//function TBaseDrawPathData.MoveTo(const X:Double;const Y:Double): Boolean;
//begin
//  Result:=True;
//end;


end.
