//convert pas to utf8 by ¥
//文本框//
unit uSkinFireMonkeyStyledEdit;

interface
{$I FrameWork.inc}

{$I FMXStyledEdit.inc}


uses
  SysUtils,
  uFuncCommon,
  Classes,
  uBaseLog,
  UITypes,
  Math,
  Types,
  FMX.Dialogs,
  FMX.Types,
  FMX.Controls,
  FMX.StdCtrls,
  FMX.Edit,
  uGraphicCommon,
  FMX.Forms,
  FMX.Styles.Objects,
  FMX.Graphics,
  uSkinPublic,
  uSkinMaterial,
  uComponentType,
  uVersion,
  uBinaryTreeDoc,
  uSkinEditType,
  uDrawEngine,
  uDrawCanvas,
  uSkinPicture,
//  uSkinPackage,
  uBaseList,
  FMX.Text,
  FMX.Objects,
  uDrawPicture,
  FMX.Edit.Style,
  FMX.Controls.Presentation,
  FMX.Presentation.Factory,

  {$IF CompilerVersion >= 30.0}//>=XE10
  FMX.Presentation.Style,
  {$ENDIF}

  uSkinRegManager,
  uSkinBufferBitmap;




Type


  /// <summary>
  ///   文本框
  /// </summary>
  TSkinFMXStyledEdit=class(TStyledEdit,
                            IEditContentMargins)
  {$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Declare_FMX.inc}
  {$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Declare_FMX.inc}
  private
    //InScrollBox属性实现
    FIsMouseDownCanFocus:Boolean;


//    FCanvas:TDrawCanvas;
//    FPaintData:TPaintData;

    FContent: TControl;

  protected
    //背景
    FStyleObj_background: TControl;
    procedure ApplyStyle;override;
    procedure FreeStyle; override;
    function GetDefaultStyleLookupName: string; override;
    procedure AdjustFixedSize(const Ref: TControl); override;
//    procedure DoPaintBackGround(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);

  public
    //InScrollBox属性实现
    //鼠标事件(系统自带的)(用于支持DirectUI)
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single);overload;override;

  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  end;



{ TStyledEditProxy }

  TSkinFMXStyledEditProxy = class(TPresentationProxy)
  protected
    function CreateReceiver: TObject; override;
  end;



implementation


uses
  uSkinFireMonkeyEdit;

{$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Styled_Impl_Code_FMX.inc}
{$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Styled_Impl_Code_FMX.inc}



{ TSkinFMXStyledEdit }


procedure TSkinFMXStyledEdit.AdjustFixedSize(const Ref: TControl);
begin
end;

procedure TSkinFMXStyledEdit.ApplyStyle;
var
  I,J: Integer;
begin
  inherited ApplyStyle;



  //FContent为'TLayout'
  FContent := TControl(FindStyleResource('content'));
  if FContent<>nil then
  begin
//    if FContentMarginsLeft>0 then
//    begin
      FContent.Margins.Left:=FContentMarginsLeft;
//    end
//    else
//    begin
//
//    end;
    if FContentMarginsTop>0 then
    begin
      FContent.Margins.Top:=FContentMarginsTop;
    end;
    if FContentMarginsRight>0 then
    begin
      FContent.Margins.Right:=FContentMarginsRight;
    end;
    if FContentMarginsBottom>0 then
    begin
      FContent.Margins.Bottom:=FContentMarginsBottom;
    end;
  end;



  if Self.FIsUseDefaultStyle then Exit;



  //去掉背景框
  for I := 0 to Self.ChildrenCount-1 do
  begin

    for J := Self.Children[I].ChildrenCount-1 downto 0 do
    begin

      if Self.Children[I].Children[J].StyleName='background' then
      begin

        //背景
        FStyleObj_background:=TControl(Self.Children[I].Children[J]);
        ClearStyleObjectVisiualElement(FStyleObj_background,'Edit');

//        FStyleObj_background.OnPainting:=Self.DoPaintBackGround;
      end;

    end;
  end;
end;



constructor TSkinFMXStyledEdit.Create(AOwner: TComponent);
begin
  inherited;
//  FCanvas:=CreateDrawCanvas;

  {$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Init_Code_FMX.inc}
  {$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Init_Code_FMX.inc}


//  //InScrollBox属性实现
//  FIsMouseDownCanFocus:=False;
end;

destructor TSkinFMXStyledEdit.Destroy;
begin
//  FreeAndNil(FCanvas);
  inherited;
end;

//procedure TSkinFMXStyledEdit.DoPaintBackGround(Sender: TObject; Canvas: TCanvas;const ARect: TRectF);
//var
//  AFMXEdit:TSkinFMXEdit;
//begin
//
//  AFMXEdit:=TSkinFMXEdit(Self.Edit);
//  if AFMXEdit=nil then Exit;
//
//    FCanvas.Prepare(Canvas);
//
//
//    //绘制父控件背景
//    if (AFMXEdit.CurrentUseMaterial<>nil) then
//    begin
//      if Not TSkinControlMaterial(AFMXEdit.CurrentUseMaterial).IsTransparent then
//      begin
//        FCanvas.DrawRect(TSkinControlMaterial(AFMXEdit.CurrentUseMaterial).BackColor,
//                          RectF(0,0,Width,Height));
//      end;
//    end;
//
//
//    //绘制
//    if AFMXEdit.SkinControlType<>nil then
//    begin
//      FPaintData:=GlobalNullPaintData;
//      FPaintData.IsDrawInteractiveState:=True;
//      FPaintData.IsInDrawDirectUI:=False;
//      AFMXEdit.SkinControlType.Paint(FCanvas,RectF(0,0,Self.Width,Self.Height),FPaintData);
//    end;
//
//
//
//    //设计时绘制虚线框和控件名称
//    if (csDesigning in Self.ComponentState) then
//    begin
//      FCanvas.DrawDesigningRect(RectF(0,0,Width,Height),GlobalNormalDesignRectBorderColor);
//      FCanvas.DrawDesigningText(RectF(0,0,Width,Height),Self.Name);
//    end;
//
//
//    FCanvas.UnPrepare;
//
//
//end;

procedure TSkinFMXStyledEdit.FreeStyle;
begin
  FContent:=nil;
  FStyleObj_background:=nil;
  inherited;
end;


function TSkinFMXStyledEdit.GetDefaultStyleLookupName: string;
begin
  Result:='EditStyle';
end;

//系统自带的
procedure TSkinFMXStyledEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
var
  AFMXEdit:TSkinFMXEdit;
begin

  AFMXEdit:=TSkinFMXEdit(Self.Edit);
  if AFMXEdit=nil then Exit;


  if AFMXEdit.CanFocus
    //当前没有获得焦点
    and Not Self.IsFocused
//    and AFMXEdit.IsInScrollBox
    //Edit的父类是滚动框
    and GetParentIsScrollBoxContent(AFMXEdit,AFMXEdit.FParentIsScrollBox,AFMXEdit.FParentScrollBox)
    and not Self.FIsMouseDownCanFocus then
  begin
      //uBaseLog.HandleException(nil,'TSkinFMXStyledEdit.MouseDown AFMXEdit.ISkinControl_CustomMouseDown');
      //滚动,但不获得焦点
      AFMXEdit.ISkinControl_CustomMouseDown(Button,Shift,X,Y,False,Self);
  end
  else
  begin
      //uBaseLog.HandleException(nil,'TSkinFMXStyledEdit.MouseDown AFMXEdit.MouseDown');
      Inherited MouseDown(Button,Shift,X,Y);
  end;
end;

procedure TSkinFMXStyledEdit.MouseMove(Shift:TShiftState;X, Y: Single);
var
  AFMXEdit:TSkinFMXEdit;
begin

  AFMXEdit:=TSkinFMXEdit(Self.Edit);
  if AFMXEdit=nil then Exit;


  if AFMXEdit.CanFocus
    and Not Self.IsFocused
//    and AFMXEdit.IsInScrollBox
    and GetParentIsScrollBoxContent(AFMXEdit,AFMXEdit.FParentIsScrollBox,AFMXEdit.FParentScrollBox)
    and not Self.FIsMouseDownCanFocus then
  begin
      //uBaseLog.HandleException(nil,'TSkinFMXStyledEdit.MouseMove AFMXEdit.ISkinControl_CustomMouseMove');
      //滚动
      AFMXEdit.ISkinControl_CustomMouseMove(Shift,X,Y,False,Self);
  end
  else
  begin
      //uBaseLog.HandleException(nil,'TSkinFMXStyledEdit.MouseMove AFMXEdit.MouseMove');
      Inherited MouseMove(Shift,X,Y);
  end;
end;

procedure TSkinFMXStyledEdit.MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
var
  AFMXEdit:TSkinFMXEdit;
begin

  AFMXEdit:=TSkinFMXEdit(Self.Edit);
  if AFMXEdit=nil then Exit;


  if AFMXEdit.CanFocus
    and Not Self.IsFocused
//    and AFMXEdit.IsInScrollBox
    and GetParentIsScrollBoxContent(AFMXEdit,AFMXEdit.FParentIsScrollBox,AFMXEdit.FParentScrollBox)
    and not Self.FIsMouseDownCanFocus then
  begin
      //滚动
      //uBaseLog.HandleException(nil,'TSkinFMXStyledEdit.MouseUp AFMXEdit.ISkinControl_CustomMouseUp');
      AFMXEdit.ISkinControl_CustomMouseUp(Button,Shift,X,Y,False,Self);


//      uBaseLog.HandleException(nil,'TSkinFMXStyledEdit.MouseUp '
//                                            +' FMouseDownAbsolutePt:'+FloatToStr(AFMXEdit.SkinControlType.FMouseDownAbsolutePt.X)+','+FloatToStr(AFMXEdit.SkinControlType.FMouseDownAbsolutePt.Y)
//                                            +' FMouseMoveAbsolutePt:'+FloatToStr(AFMXEdit.SkinControlType.FMouseMoveAbsolutePt.X)+','+FloatToStr(AFMXEdit.SkinControlType.FMouseMoveAbsolutePt.Y)
//
//                                            );

      if (AFMXEdit.SkinControlType.FMouseDownAbsolutePt.X<>0)
        and (Abs(AFMXEdit.SkinControlType.FMouseDownAbsolutePt.X
          -AFMXEdit.SkinControlType.FMouseMoveAbsolutePt.X)<Const_CanCallClickEventDistance)
        and (Abs(AFMXEdit.SkinControlType.FMouseDownAbsolutePt.Y
          -AFMXEdit.SkinControlType.FMouseMoveAbsolutePt.Y)<Const_CanCallClickEventDistance) then
      begin
          //执行点击,开始编辑
          //uBaseLog.HandleException(nil,'TSkinFMXStyledEdit.MouseUp Start Edit');

          //在DoEditStay
          FIsMouseDownCanFocus:=True;

          Inherited MouseDown(TMouseButton.mbLeft,[ssLeft],AFMXEdit.SkinControlType.FMouseDownPt.X,AFMXEdit.SkinControlType.FMouseDownPt.Y);
          Inherited MouseMove([ssLeft],AFMXEdit.SkinControlType.FMouseDownPt.X,AFMXEdit.SkinControlType.FMouseDownPt.Y);
          Inherited MouseUp(TMouseButton.mbLeft,[ssLeft],AFMXEdit.SkinControlType.FMouseDownPt.X,AFMXEdit.SkinControlType.FMouseDownPt.Y);

          FIsMouseDownCanFocus:=False;

      end;

  end
  else
  begin
      //uBaseLog.HandleException(nil,'TSkinFMXStyledEdit.MouseUp AFMXEdit.MouseUp');
      Inherited MouseUp(Button,Shift,X,Y);
  end;
end;







{ TSkinFMXStyledEditProxy }


function TSkinFMXStyledEditProxy.CreateReceiver: TObject;
begin
  Result := TSkinFMXStyledEdit.Create(nil);
end;



end.



