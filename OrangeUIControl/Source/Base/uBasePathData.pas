//convert pas to utf8 by ¥
unit uBasePathData;

interface


{$I FrameWork.inc}

uses
  Classes,
  Math,
  SysUtils,


  {$IFDEF VCL}
  Windows,
  Messages,
  Controls,
  Graphics,
  {$ENDIF}


  {$IFDEF FMX}
  Types,
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
    function MoveTo(const X:Double;const Y:Double):Boolean;virtual;abstract;
    function CurveTo(const X:Double;const Y:Double;
                    const X1:Double;const Y1:Double;
                    const X2:Double;const Y2:Double):Boolean;virtual;abstract;
    function LineTo(const X:Double;const Y:Double):Boolean;virtual;abstract;
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
