//convert pas to utf8 by ¥
//下拉编辑框//
unit uSkinFireMonkeyStyledComboEdit;

interface
{$I FrameWork.inc}

{$I FMXStyledComboEdit.inc}


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
  uDrawPicture,
  uGraphicCommon,
  FMX.Forms,
  FMX.Styles.Objects,
  FMX.Graphics,
  uSkinPublic,
  uSkinMaterial,
  uComponentType,
  uVersion,
  uSkinPicture,
  uBinaryTreeDoc,
  uSkinComboEditType,
  uDrawEngine,
  uDrawCanvas,
//  uSkinPackage,
  uBaseList,
  FMX.Text,
  FMX.Objects,
  FMX.ComboEdit,

  FMX.ComboEdit.Style,
  FMX.Controls.Presentation,
  FMX.Presentation.Factory,
  {$IF CompilerVersion >= 30.0}//>=XE10
  FMX.Presentation.Style,
  {$ENDIF}
  uSkinRegManager,
  uSkinBufferBitmap;






Type


  /// <summary>
  ///   下拉编辑框
  /// </summary>
  TSkinFMXStyledComboEdit=class(TStyledComboEdit,
                                IEditContentMargins)
  {$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Declare_FMX.inc}
  {$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Declare_FMX.inc}
  private
    //InScrollBox属性实现
    FIsMouseDownCanFocus:Boolean;


    FContent: TControl;

    FCanvas:TDrawCanvas;
    FPaintData:TPaintData;
  protected
    //背景
    FStyleObj_background: TControl;
    procedure ApplyStyle; override;
    procedure FreeStyle; override;
    procedure AdjustFixedSize(const Ref: TControl); override;
    procedure DoPaintBackGround(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);

//    procedure DoComboMouseDown(Sender:TObject; Button: TMouseButton; Shift: TShiftState; x, Y: Single); override;
  public
    //InScrollBox属性实现
    //鼠标事件(系统自带的)(用于支持DirectUI)
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);overload;override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single);overload;override;


  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
  end;



{ TStyledComboEditProxy }

  TSkinFMXStyledComboEditProxy = class(TPresentationProxy)
  protected
    function CreateReceiver: TObject; override;
  end;



implementation


uses
  uSkinFireMonkeyComboEdit;


{$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Styled_Impl_Code_FMX.inc}
{$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Styled_Impl_Code_FMX.inc}





{ TSkinFMXStyledComboEdit }

//procedure TSkinFMXStyledComboEdit.DoComboMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
//var
//  OldPressed: Boolean;
//begin
//  if CanDropDown(Button, Shift) then
//  begin
////    if FNeedSetFocusAfterButtonClick then
////      SetFocus;
//    OldPressed := Pressed;
//    try
//      Pressed := True;
//      DropDown;
//    finally
//      Pressed := OldPressed;
//    end;
//  end;
//end;

procedure TSkinFMXStyledComboEdit.AdjustFixedSize(const Ref: TControl);
begin
end;

procedure TSkinFMXStyledComboEdit.ApplyStyle;
var
  I,J: Integer;
begin
  inherited;

  FContent := TControl(FindStyleResource('content'));
  if FContent<>nil then
  begin
    if FContentMarginsLeft>0 then
    begin
      FContent.Margins.Left:=FContentMarginsLeft;
    end;
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


  //'TActiveStyleObject'
  if (ArrowButton<>nil) and Assigned(ArrowButton) then
  begin
    //ArrowButton.Visible:=False;
    //隐藏图片即可

    ClearStyleObjectVisiualElement(ArrowButton,'ComboEdit');
  end;


  //去掉背景框
  for I := 0 to Self.ChildrenCount-1 do
  begin

    for J := Self.Children[I].ChildrenCount-1 downto 0 do
    begin

      if Self.Children[I].Children[J].StyleName='background' then
      begin

        //背景
        FStyleObj_background:=TControl(Self.Children[I].Children[J]);
        ClearStyleObjectVisiualElement(FStyleObj_background,'ComboEdit');
        FStyleObj_background.OnPainting:=Self.DoPaintBackGround;

      end;

    end;
  end;
end;

constructor TSkinFMXStyledComboEdit.Create(AOwner: TComponent);
begin
  inherited;
  FCanvas:=CreateDrawCanvas('TSkinFMXStyledComboEdit');

  {$I Source\Controls\INC\FMX\ISkinEdit_ContentMargin_Init_Code_FMX.inc}
  {$I Source\Controls\INC\FMX\ISkinEdit_UseDefaultStyle_Init_Code_FMX.inc}


  //InScrollBox属性实现
  FIsMouseDownCanFocus:=False;



  //ComboEdit和StyledComboEdit两边要同步起来
  FContentMarginsRight:=30;//右边空出来,才能让用户点击出来
end;

destructor TSkinFMXStyledComboEdit.Destroy;
begin
  FreeAndNil(FCanvas);
  inherited;
end;




//系统自带的
procedure TSkinFMXStyledComboEdit.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
var
  AFMXEdit:TSkinFMXComboEdit;
begin
  AFMXEdit:=TSkinFMXComboEdit(Self.Edit);
  if AFMXEdit=nil then Exit;

  if AFMXEdit.CanFocus
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
      //启动编辑
      Inherited MouseDown(Button,Shift,X,Y);
  end;
end;

procedure TSkinFMXStyledComboEdit.MouseMove(Shift:TShiftState;X, Y: Single);
var
  AFMXEdit:TSkinFMXComboEdit;
begin
  AFMXEdit:=TSkinFMXComboEdit(Self.Edit);
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

procedure TSkinFMXStyledComboEdit.MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Single);
var
  AFMXEdit:TSkinFMXComboEdit;
begin
  AFMXEdit:=TSkinFMXComboEdit(Self.Edit);
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

          inherited MouseDown(TMouseButton.mbLeft,[ssLeft],AFMXEdit.SkinControlType.FMouseDownPt.X,AFMXEdit.SkinControlType.FMouseDownPt.Y);
          inherited MouseMove([ssLeft],AFMXEdit.SkinControlType.FMouseDownPt.X,AFMXEdit.SkinControlType.FMouseDownPt.Y);
          inherited MouseUp(TMouseButton.mbLeft,[ssLeft],AFMXEdit.SkinControlType.FMouseDownPt.X,AFMXEdit.SkinControlType.FMouseDownPt.Y);

          FIsMouseDownCanFocus:=False;

      end;

  end
  else
  begin
      Inherited MouseUp(Button,Shift,X,Y);
  end;
end;

//procedure TSkinFMXStyledComboEdit.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
//begin
//  Inherited;
//  if PtInRect(RectF(Width-Height,0,Width,Height),PointF(X,Y)) then
//  begin
//    DropDown;
//  end;
//end;

procedure TSkinFMXStyledComboEdit.DoPaintBackGround(Sender: TObject; Canvas: TCanvas;const ARect: TRectF);
var
  AFMXEdit:TSkinFMXComboEdit;
var
  ASkinMaterial:TSkinControlMaterial;
begin
  AFMXEdit:=TSkinFMXComboEdit(Self.Edit);
  if AFMXEdit=nil then Exit;


  FCanvas.Prepare(Canvas);


  if (AFMXEdit.SkinControlType<>nil) then
  begin
    ASkinMaterial:=AFMXEdit.SkinControlType.GetPaintCurrentUseMaterial;
  end;

//  //绘制父控件背景
//  if (AFMXEdit.CurrentUseMaterial<>nil) then
//  begin
//    if Not TSkinControlMaterial(AFMXEdit.CurrentUseMaterial).IsTransparent then
//    begin
//      FCanvas.DrawRect(TSkinControlMaterial(AFMXEdit.CurrentUseMaterial).BackColor,
//                        RectF(0,0,Width,Height));
//    end;
//  end;

  //绘制
  if AFMXEdit.SkinControlType<>nil then
  begin
    FPaintData:=GlobalNullPaintData;
    FPaintData.IsDrawInteractiveState:=True;
    FPaintData.IsInDrawDirectUI:=False;
    AFMXEdit.SkinControlType.Paint(FCanvas,ASkinMaterial,RectF(0,0,Self.Width,Self.Height),FPaintData);
  end;

  //设计时绘制虚线框和控件名称
  if (csDesigning in Self.ComponentState) then
  begin
    FCanvas.DrawDesigningRect(RectF(0,0,Width,Height),GlobalNormalDesignRectBorderColor);
    FCanvas.DrawDesigningText(RectF(0,0,Width,Height),Self.Name);

    //绘制控件绑定的字段
//      FCanvas.DrawDesigningText(RectF(0,0,Width,Height),Self.BindItemFieldName);
//    Canvas.Font.Size:=10;
//    Canvas.Fill.Color:=TAlphaColorRec.Black;
//    Canvas.FillText(RectF(0,0,Width,Height),Self.BindItemFieldName,True,0.6,[],TTextAlign.taLeading,TTextAlign.taLeading);
  end;

  FCanvas.UnPrepare;

end;

procedure TSkinFMXStyledComboEdit.FreeStyle;
begin
  FContent:=nil;
  FStyleObj_background:=nil;
  inherited;
end;



{ TSkinFMXStyledComboEditProxy }


function TSkinFMXStyledComboEditProxy.CreateReceiver: TObject;
begin
  Result := TSkinFMXStyledComboEdit.Create(nil);
end;





end.




