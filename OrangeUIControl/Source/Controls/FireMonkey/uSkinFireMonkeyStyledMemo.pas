//convert pas to utf8 by ¥
//备注框//
unit uSkinFireMonkeyStyledMemo;

interface
{$I FrameWork.inc}

{$I FMXStyledMemo.inc}


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
  FMX.Memo,
  FMX.Forms,
  FMX.Styles.Objects,
  FMX.Graphics,
  FMX.Objects, FMX.Layouts,
  uSkinPublic,
  uSkinMaterial,
  uComponentType,
  uVersion,
  uBaseList,
  uDrawPicture,
  uBinaryTreeDoc,
  uSkinMemoType,
  uDrawEngine,
  uGraphicCommon,
  uDrawCanvas,
//  uSkinPackage,
//  {$IF CompilerVersion >= 29.0}
  FMX.Memo.Style,
  FMX.Controls.Presentation,
  FMX.Presentation.Factory,
//  {$ENDIF}
//  {$IF CompilerVersion >= 30.0}
  FMX.Presentation.Style,
//  {$ENDIF}
  uSkinRegManager,
  uSkinPicture,
  uSkinBufferBitmap;


Type

//  {$IF CompilerVersion >= 29.0}

  TSkinFMXStyledMemo=class(TStyledMemo,
                          IEditContentMargins)
  {$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Declare_FMX.inc}
  {$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Declare_FMX.inc}
  private
    FIsMouseDownCanFocus:Boolean;

    FCanvas:TDrawCanvas;
    FPaintData:TPaintData;


  protected
    //背景
    FStyleObj_background: TControl;
    procedure ApplyStyle; override;
    procedure FreeStyle; override;
    function GetDefaultStyleLookupName: string; override;
    procedure AdjustFixedSize(const Ref: TControl); override;
//    procedure DoPaintBackGround(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
  protected
    //鼠标事件(系统自带的)(用于支持DirectUI)
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single);overload;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    FContent: TControl;
    function GetEdit: TCustomMemo;
    property Edit: TCustomMemo read GetEdit;
  end;


{ TStyledMemoProxy }

  TSkinFMXStyledMemoProxy = class(TPresentationProxy)
  protected
    function CreateReceiver: TObject; override;
  end;
//  {$ENDIF}










implementation


uses
  uSkinFireMonkeyMemo;



//{$IF CompilerVersion >= 29.0}



{$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Styled_Impl_Code_FMX.inc}
{$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Styled_Impl_Code_FMX.inc}


{ TOrangeUIFMXStyledMemoProxy }

function TSkinFMXStyledMemoProxy.CreateReceiver: TObject;
begin
  Result := TSkinFMXStyledMemo.Create(nil);
end;

{ TSkinFMXStyledMemo }

procedure TSkinFMXStyledMemo.AdjustFixedSize(const Ref: TControl);
begin
end;

procedure TSkinFMXStyledMemo.ApplyStyle;
var
  I,J: Integer;
begin
  inherited;

  FContent := TControl(FindStyleResource('content'));
  if (FContent<>nil) and (FContent.Parent<>nil) then
  begin
    if FContentMarginsLeft>0 then
    begin
      TControl(FContent.Parent).Padding.Left:=FContentMarginsLeft;
    end;
    if FContentMarginsTop>0 then
    begin
      TControl(FContent.Parent).Padding.Top:=FContentMarginsTop;
    end;
    if FContentMarginsRight>0 then
    begin
      TControl(FContent.Parent).Padding.Right:=FContentMarginsRight;
    end;
    if FContentMarginsBottom>0 then
    begin
      TControl(FContent.Parent).Padding.Bottom:=FContentMarginsBottom;
    end;
  end;

  if FIsUseDefaultStyle then Exit;

  //去掉背景框
  for I := 0 to Self.ChildrenCount-1 do
  begin

    for J := Self.Children[I].ChildrenCount-1 downto 0 do
    begin

      if Self.Children[I].Children[J].StyleName='background' then
      begin

        //背景
        FStyleObj_background:=TControl(Self.Children[I].Children[J]);
        ClearStyleObjectVisiualElement(FStyleObj_background,'Memo');
      end;


    end;
  end;
end;

constructor TSkinFMXStyledMemo.Create(AOwner: TComponent);
begin
  inherited;

  FCanvas:=CreateDrawCanvas('TSkinFMXStyledMemo');

  {$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Init_Code_FMX.inc}
  {$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Init_Code_FMX.inc}

  FIsMouseDownCanFocus:=False;
end;

destructor TSkinFMXStyledMemo.Destroy;
begin
  FreeAndNil(FCanvas);
  inherited;
end;

function TSkinFMXStyledMemo.GetEdit: TCustomMemo;
begin
  Result := PresentedControl as TCustomMemo;
end;

//procedure TSkinFMXStyledMemo.DoPaintBackGround(Sender: TObject; Canvas: TCanvas;
//  const ARect: TRectF);
//var
//  AFMXEdit:TSkinFMXMemo;
//begin
//
//  AFMXEdit:=TSkinFMXMemo(Self.Edit);
//  if AFMXEdit=nil then Exit;
//
//
//  FCanvas.Prepare(Canvas);
//
//
////    //绘制父控件背景
////    if (AFMXEdit.CurrentUseMaterial<>nil) then
////    begin
////      if Not TSkinControlMaterial(AFMXEdit.CurrentUseMaterial).IsTransparent then
////      begin
////        FCanvas.DrawRect(TSkinControlMaterial(AFMXEdit.CurrentUseMaterial).BackColor,
////                          RectF(0,0,Width,Height));
////      end;
////    end;
//
//    //绘制
//    if AFMXEdit.SkinControlType<>nil then
//    begin
//      FPaintData:=GlobalNullPaintData;
//      FPaintData.IsDrawInteractiveState:=True;
//      FPaintData.IsInDrawDirectUI:=False;
//      AFMXEdit.SkinControlType.Paint(FCanvas,RectF(0,0,Width,Height),FPaintData);
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
//    FCanvas.UnPrepare;
//
//
//end;

procedure TSkinFMXStyledMemo.FreeStyle;
begin
  FContent:=nil;
  FStyleObj_background:=nil;
  inherited;
end;

function TSkinFMXStyledMemo.GetDefaultStyleLookupName: string;
begin
  Result:='MemoStyle';
end;

//系统自带的
procedure TSkinFMXStyledMemo.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
var
  AFMXEdit:TSkinFMXMemo;
begin

  AFMXEdit:=TSkinFMXMemo(Self.Edit);
  if AFMXEdit=nil then Exit;

  if
    AFMXEdit.CanFocus
    and Not Self.IsFocused
//    and AFMXEdit.IsInScrollBox
    and GetParentIsScrollBoxContent(AFMXEdit,AFMXEdit.FParentIsScrollBox,AFMXEdit.FParentScrollBox)
    and not Self.FIsMouseDownCanFocus then
  begin
      //滚动
      AFMXEdit.ISkinControl_CustomMouseDown(Button,Shift,X,Y,False,Self);
  end
  else
  begin
      Inherited MouseDown(Button,Shift,X,Y);
  end;
end;

procedure TSkinFMXStyledMemo.MouseMove(Shift:TShiftState;X, Y: Single);
var
  AFMXEdit:TSkinFMXMemo;
begin

  AFMXEdit:=TSkinFMXMemo(Self.Edit);
  if AFMXEdit=nil then Exit;

  if 
    AFMXEdit.CanFocus
    and Not Self.IsFocused
//    and AFMXEdit.IsInScrollBox
    and GetParentIsScrollBoxContent(AFMXEdit,AFMXEdit.FParentIsScrollBox,AFMXEdit.FParentScrollBox)
    and not Self.FIsMouseDownCanFocus then
  begin
      //滚动
      AFMXEdit.ISkinControl_CustomMouseMove(Shift,X,Y,False,Self);
  end
  else
  begin
      Inherited MouseMove(Shift,X,Y);
  end;
end;

procedure TSkinFMXStyledMemo.MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
var
  AFMXEdit:TSkinFMXMemo;
begin

  AFMXEdit:=TSkinFMXMemo(Self.Edit);
  if AFMXEdit=nil then Exit;


  if 
    AFMXEdit.CanFocus
    and Not Self.IsFocused
//    and AFMXEdit.IsInScrollBox
    and GetParentIsScrollBoxContent(AFMXEdit,AFMXEdit.FParentIsScrollBox,AFMXEdit.FParentScrollBox)
    and not Self.FIsMouseDownCanFocus then
  begin
      //滚动
      AFMXEdit.ISkinControl_CustomMouseUp(Button,Shift,X,Y,False,Self);

      if (AFMXEdit.SkinControlType.FMouseDownAbsolutePt.X<>0)
        and (Abs(AFMXEdit.SkinControlType.FMouseDownAbsolutePt.X
          -AFMXEdit.SkinControlType.FMouseMoveAbsolutePt.X)<Const_CanCallClickEventDistance)
        and (Abs(AFMXEdit.SkinControlType.FMouseDownAbsolutePt.Y
          -AFMXEdit.SkinControlType.FMouseMoveAbsolutePt.Y)<Const_CanCallClickEventDistance) then
      begin
          //执行点击

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
      Inherited MouseUp(Button,Shift,X,Y);
  end;
end;


//{$ENDIF}




end.









