//Ƥ���ı���//
unit uSkinWindowsEdit;

interface
{$I FrameWork.inc}

{$I Source\Controls\Windows\WinEdit.inc}

uses
  Windows,
  Classes,
  Controls,
  SysUtils,
  Messages,
  StdCtrls,
  Forms,
  ExtCtrls,
  Graphics,
  uVersion,
  uSkinPublic,
  uFuncCommon,
  uGraphicCommon,
  uBaseLog,
  uBaseList,
  uBinaryTreeDoc,
//  uSkinPackage,
  uSkinRegManager,
  uSkinBufferBitmap,
  uDrawCanvas,
  uSkinMaterial,
  uComponentType,
  uSkinEditType,
  uDrawEngine,
  uDrawPicture,
  uDrawTextParam,
  uDrawPictureParam;


type
  //Ƥ���ı���TSkinEdit
  TSkinWinEdit=class(TCustomEdit,
  ISkinEdit,
      ISkinControlMaterial,
      IDirectUIControl,
//  ISkinComponent,
  ISkinControl,
  IBindSkinItemTextControl,
  IBindSkinItemValueControl,
  ISkinItemBindingControl
  )
  private
    {$I Source\Controls\INC\Common\ISkinControl_Declare.inc}
    {$I Source\Controls\INC\VCL\ISkinControl_Control_Impl_Mouse_Declare_VCL.inc}
    {$I Source\Controls\INC\VCL\ISkinControl_Control_Impl_Key_Declare_VCL.inc}
    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_DirectUI_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Property_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Declare.inc}
  protected
    function GetEditProperties:TEditProperties;
    procedure SetEditProperties(Value:TEditProperties);




  protected
    //����λͼ
    FBufferBitmap:TBufferBitmap;
    //����λͼ
    function GetBufferBitmap: TBufferBitmap;
    //����λͼ
    property BufferBitmap:TBufferBitmap read GetBufferBitmap;





  protected
    //������Ķ�ʱ��
    FCheckMouseStayTimer:TTimer;
    FCheckMouseStayTimerID:Integer;
    procedure CreateCheckMouseStayTimer;
    procedure OnCheckMouseStayTimer(Sender:TObject);




  protected
    //����͸������
    FTransparentBrush:TBrush;
    FTransparentBitmap:TBitmap;
    procedure CNCtlColorEdit(var Message:TWMCtlColorEdit);message CN_CTLCOLOREDIT;



  protected
    //��Ϣ����
    procedure WMPaint(var Message:TWMPaint);message WM_PAINT;
    procedure WMEraseBkGnd(var Message:TWMEraseBkGnd);message WM_ERASEBKGND;
    procedure WMNCCalcSize(var Message:TWMNCCalcSize);message WM_NCCALCSIZE;
    procedure WMNCPaint(var Message:TWMNCPaint);message WM_NCPAINT;
    procedure WMKillFocus(var Message:TMessage);message WM_KILLFOCUS;
    //���Ʒǿͻ���
    procedure NCPaintWindow;
    //�ǿͻ�������
    function NCPaint(ACanvas:TDrawCanvas;const ADrawRect:TRect):Boolean;virtual;

    procedure WMNCHitTest(var Message:TWMNCHitTest);message WM_NCHITTEST;

    procedure WMSize(var Message:TWMSize);message WM_SIZE;

    //�ڴ�����ĳߴ���¼���ˢ��
    procedure CMInvalidateInParentWMSize(var Message:TMessage);message CM_InvalidateInParentWMSize;


  protected
    //IBindSkinItemTextControl
    procedure BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
    //IBindSkinItemValueControl
    procedure SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);

  protected
    //����
    function GetCaption:String;
    procedure SetCaption(const Value:String);


  protected
//    //��ListBox�е���Զ��༭
//    FIsAutoEditInItem:Boolean;


    //�߿�߾�
    FBorderMargins:TBorderMargins;
    FNCBorderMargins:TBorderMargins;

    procedure SetBorderMargins(const Value: TBorderMargins);
    procedure SetNCBorderMargins(const Value: TBorderMargins);
    procedure OnBorderMarginsChangeNotify(Sender:TObject);
  published
    //�߿���չ�߾�(��VCL�²�����,FMX�´���������)
    property BorderMargins:TBorderMargins read FBorderMargins write SetBorderMargins;
    property NCBorderMargins:TBorderMargins read FNCBorderMargins write SetNCBorderMargins;



  protected
    function GetText:String;
    function IsReadOnly:Boolean;
    function GetPasswordChar:Char;


  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;


  published
  published
    property HitTest:Boolean read GetNeedHitTest write FNeedHitTest;
    //����
    property Properties:TEditProperties read GetEditProperties write SetEditProperties;
    //���Ա���
    property EditProperties:TEditProperties read GetEditProperties write SetEditProperties;

//    //���б������Զ������༭
//    property IsAutoEditInItem:Boolean read FIsAutoEditInItem write FIsAutoEditInItem;

  published
    property Align;
    property Alignment;
    property Anchors;
    property AutoSelect;
//    property AutoSize;
//    property BevelEdges;
//    property BevelInner;
//    property BevelKind default bkNone;
//    property BevelOuter;
//    property BevelWidth;
    property BiDiMode;
//    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
//    property Ctl3D;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property NumbersOnly;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
//    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property TextHint;
    property Touch;
    property Visible;
    {$IF CompilerVersion >= 30.0}
    property StyleElements;
    {$IFEND}
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  TSkinEdit=TSkinWinEdit;




implementation




{ TSkinWinEdit }


{$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Code.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Code.inc}
{$I Source\Controls\INC\VCL\ISkinControl_Control_Impl_Code_VCL.inc}
{$I Source\Controls\INC\VCL\ISkinControl_Control_Impl_Mouse_Code_VCL.inc}
{$I Source\Controls\INC\VCL\ISkinControl_Control_Impl_Key_Code_VCL.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_DirectUI_Code.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Code.inc}







constructor TSkinWinEdit.Create(AOwner: TComponent);
begin

  FBorderMargins:=TBorderMargins.Create;
  FBorderMargins.SetBounds(3,3,3,3);

  FNCBorderMargins:=TBorderMargins.Create;
  FNCBorderMargins.SetBounds(2,2,2,2);


  inherited Create(AOwner);
  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Create_Code.inc}


  //�����ؼ�����
  FProperties:=Self.GetPropertiesClassType.Create(Self);


  FBorderMargins.OnChange:=Self.OnBorderMarginsChangeNotify;


  Self.AutoSize:=False;
  Self.BorderStyle:=bsNone;
  Self.Ctl3D:=False;
  Self.ParentCtl3D:=False;
  Self.BevelEdges:=[];
  Self.BevelInner:=bvNone;
  Self.BevelKind:=bkNone;
  Self.BevelOuter:=bvNone;
  Self.BevelWidth:=1;

end;

destructor TSkinWinEdit.Destroy;
begin

  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Destroy_Code.inc}

  FreeAndNil(FBufferBitmap);

  FreeAndNil(FTransparentBrush);
  FreeAndNil(FTransparentBitmap);

  FreeAndNil(FProperties);

  FBorderMargins.OnChange:=nil;
  uFuncCommon.FreeAndNil(FBorderMargins);

  FNCBorderMargins.OnChange:=nil;
  uFuncCommon.FreeAndNil(FNCBorderMargins);
  inherited;
end;

procedure TSkinWinEdit.SetBorderMargins(const Value: TBorderMargins);
begin
  FBorderMargins.Assign(Value);
end;

procedure TSkinWinEdit.SetNCBorderMargins(const Value: TBorderMargins);
begin
  FNCBorderMargins.Assign(Value);
end;

procedure TSkinWinEdit.OnBorderMarginsChangeNotify(Sender: TObject);
begin
end;

function TSkinWinEdit.GetBufferBitmap: TBufferBitmap;
begin
  if (FBufferBitmap=nil) then
  begin
    FBufferBitmap:=TBufferBitmap.Create;
  end;
  Result:=Self.FBufferBitmap;
end;

procedure TSkinWinEdit.CreateCheckMouseStayTimer;
begin
  if FCheckMouseStayTimer=nil then
  begin
    FCheckMouseStayTimer:=TTimer.Create(Self);
    FCheckMouseStayTimer.OnTimer:=OnCheckMouseStayTimer;
    FCheckMouseStayTimer.Interval:=100;
    FCheckMouseStayTimer.Enabled:=False;
  end;
end;

procedure TSkinWinEdit.WMEraseBkGnd(var Message: TWMEraseBkGnd);
begin
  Inherited;
end;

procedure TSkinWinEdit.CMInvalidateInParentWMSize(var Message: TMessage);
begin
  Inherited;
  Self.NCPaintWindow;
  Self.Invalidate;
end;

procedure TSkinWinEdit.WMPaint(var Message: TWMPaint);
var
  DC:HDC;
  ACanvas:TDrawCanvas;
begin
  Inherited;

  //������ʾ�ı�
  if (Text='') and (Self.EditProperties.HelpText<>'') then
  begin
    if Self.GetSkinControlType<>nil then
    begin
      DC := GetDC(Handle);
      try
        ACanvas:=CreateDrawCanvas('TSkinWinEdit.WMPaint');
        if ACanvas<>nil then
        begin
          try
            ACanvas.Prepare(DC);

            FPaintData:=GlobalNullPaintData;
            FPaintData.IsDrawInteractiveState:=True;
            FPaintData.IsInDrawDirectUI:=False;
            TSkinEditDefaultType(Self.GetSkinControlType).CustomPaintHelpText(
                  ACanvas,
                  Self.GetCurrentUseMaterial,
                  RectF(Self.GetClientRect.Left,Self.GetClientRect.Top,Self.GetClientRect.Right,Self.GetClientRect.Bottom),
                  FPaintData);

          finally
            FreeAndNil(ACanvas);
          end;
        end;
      finally
        ReleaseDC(Handle,DC);
      end;
    end;

  end;

end;




function TSkinWinEdit.NCPaint(ACanvas: TDrawCanvas;const ADrawRect: TRect): Boolean;
begin


    //���Ƹ��ؼ�����
    if (Self.GetCurrentUseMaterial<>nil) then
    begin
      if TSkinControlMaterial(Self.GetCurrentUseMaterial).IsTransparent then
      begin
        DrawParent(Self,
                    ACanvas.Handle,
                    0,0,Self.Width,Self.Height,
                    0,0);
      end;
    end;



    //����
    if (GetSkinControlType<>nil) then
    begin
      FPaintData:=GlobalNullPaintData;
      FPaintData.IsDrawInteractiveState:=True;
      FPaintData.IsInDrawDirectUI:=False;
      TSkinControlType(Self.GetSkinControlType).Paint(ACanvas,
                                                        Self.GetCurrentUseMaterial,
                                                        RectF(0,0,Self.Width,Self.Height),
                                                        FPaintData);
    end;


    //���ʱ�������߿�Ϳؼ�����
    if (csDesigning in Self.ComponentState) then
    begin
      ACanvas.DrawDesigningRect(RectF(0,0,Width,Height),GlobalNormalDesignRectBorderColor);

      ACanvas.DrawDesigningText(RectF(0,0,Width,Height),Self.Name);
    end;





//    //���������ʱ�����������ð棬���ҵ��ڣ���ô��ʾ���ð��ѵ��ڣ�����ϵ����DelphiTeacher
//    if not (csDesigning in Self.ComponentState)
//        and TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_IsTray')).ConvertNode_Bool32.Data
//        and ((Now-TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_LicensedDate')).ConvertNode_DateTime.Data)
//                  >TBTNode20(uCopyRight.GetCopyRightInfo('GlobalNode_TrayMonths')).ConvertNode_Int32.Data*31)
//    then
//    begin
//      ACanvas.Canvas.TextOut(0,0,'���ð��ѵ���');
//    end;

end;

procedure TSkinWinEdit.NCPaintWindow;
var
  DC:HDC;
begin

  DC:=GetWindowDC(Handle);

  //���Ʊ߿�������ǿͻ���
  if (Self.BufferBitmap.Width<>Self.Width) or (Self.BufferBitmap.Height<>Self.Height) then
  begin
    Self.BufferBitmap.CreateBufferBitmap(Self.Width,Self.Height);
  end;



  Try
    if Self.BufferBitmap.DrawCanvas<>nil then
    begin

      NCPaint(Self.BufferBitmap.DrawCanvas,Rect(0,0,Self.Width,Self.Height));



      StretchBlt(DC,0,0,
                  Self.Width,Self.FBorderMargins.Top,
                  Self.BufferBitmap.Handle,0,0,
                  Self.Width,Self.FBorderMargins.Top,
                  SRCCOPY);
      StretchBlt(DC,0,Self.Height-Self.FBorderMargins.Bottom,
                  Self.Width,Self.FBorderMargins.Bottom,
                  Self.BufferBitmap.Handle,0,Self.Height-Self.FBorderMargins.Bottom,
                  Self.Width,Self.FBorderMargins.Bottom,
                  SRCCOPY);
      StretchBlt(DC,0,Self.FBorderMargins.Top,
                  Self.FBorderMargins.Left,//+Self.GetCustomWMNCCalcSizeLeftWidth,
                  Self.Height-Self.FBorderMargins.Top-Self.FBorderMargins.Bottom,
                  Self.BufferBitmap.Handle,0,Self.FBorderMargins.Top,
                  Self.FBorderMargins.Left,//+Self.GetCustomWMNCCalcSizeLeftWidth,
                  Self.Height-Self.FBorderMargins.Top-Self.FBorderMargins.Bottom,
                  SRCCOPY);
      StretchBlt(DC,Self.Width-Self.FBorderMargins.Right,//-Self.GetCustomWMNCCalcSizeRightWidth,
                  Self.FBorderMargins.Top,
                  Self.FBorderMargins.Right,//+Self.GetCustomWMNCCalcSizeRightWidth,
                  Self.Height-Self.FBorderMargins.Top-Self.FBorderMargins.Bottom,
                  Self.BufferBitmap.Handle,Self.Width-Self.FBorderMargins.Right,//-Self.GetCustomWMNCCalcSizeRightWidth,
                  Self.FBorderMargins.Top,
                  Self.FBorderMargins.Right,//+Self.GetCustomWMNCCalcSizeRightWidth,
                  Self.Height-Self.FBorderMargins.Top-Self.FBorderMargins.Bottom,
                  SRCCOPY);

    end;
  finally
    ReleaseDC(Handle,DC);
  end;

end;

procedure TSkinWinEdit.CNCtlColorEdit(var Message: TWMCtlColorEdit);
begin
  Inherited;

  FreeAndNil(FTransparentBitmap);
  FreeAndNil(FTransparentBrush);

  FTransparentBitmap:=TBitmap.Create;
  FTransparentBrush:=TBrush.Create;

  SetBkMode(TWMCtlColorEdit(Message).ChildDC,TRANSPARENT);
  FTransparentBitmap.Width:=Self.Width;
  FTransparentBitmap.Height:=Self.Height;

  DrawParent(Self,
              Self.FTransparentBitmap.Canvas.Handle,
              0,0,
              Self.Width-Self.FBorderMargins.Left-Self.FBorderMargins.Right,
              Self.Height-Self.FBorderMargins.Top-Self.FBorderMargins.Bottom,
              Self.FBorderMargins.Left,
              Self.FBorderMargins.Top);

  if FBufferBitmap<>nil then
  begin
    Bitblt(FTransparentBitmap.Canvas.Handle,
           0,0,FTransparentBitmap.Width,FTransparentBitmap.Height,
           Self.FBufferBitmap.Handle,
           Self.FBorderMargins.Left,
           Self.FBorderMargins.Top,
           SRCCOPY
            );
  end;

  FTransparentBrush.Bitmap:=FTransparentBitmap;

  TWMCtlColorEdit(Message).Result:=FTransparentBrush.Handle;


end;

procedure TSkinWinEdit.WMNCCalcSize(var Message: TWMNCCalcSize);
var
  NewWindowRect:TRect;
  OldWindowRect:TRect;
  OldClientRect:TRect;
  NewClientRect:TRect;
  PNewWindowRect:PRect;
  NCCalcSizeParams: PNCCalcSizeParams;
begin
  Inherited;
  if
        (Self.EditProperties<>nil)
    and (Self.FNCBorderMargins<>nil) then
  begin
    //�Զ���߿�
    if TWMNCCalcSize(Message).CalcValidRects then
    begin
      NCCalcSizeParams:=TWMNCCalcSize(Message).CalcSize_Params;

      NewWindowRect:=NCCalcSizeParams.rgrc[0];
      OldWindowRect:=NCCalcSizeParams.rgrc[1];
      OldClientRect:=NCCalcSizeParams.rgrc[2];
      NewClientRect.Left:=NewWindowRect.Left+Self.FNCBorderMargins.Left;//+GetCustomWMNCCalcSizeLeftWidth;
      NewClientRect.Top:=NewWindowRect.Top+Self.FNCBorderMargins.Top;
      NewClientRect.Right:=NewWindowRect.Right-Self.FNCBorderMargins.Right;//-GetCustomWMNCCalcSizeRightWidth;
      NewClientRect.Bottom:=NewWindowRect.Bottom-Self.FNCBorderMargins.Bottom;
      NCCalcSizeParams.rgrc[0]:=NewClientRect;
      NCCalcSizeParams.rgrc[1]:=NewWindowRect;
      NCCalcSizeParams.rgrc[2]:=OldClientRect;

    end
    else
    begin
      PNewWindowRect:=PRect(Pointer(TWMNCCalcSize(Message).CalcSize_Params));
      PNewWindowRect.Left:=PNewWindowRect.Left+Self.FNCBorderMargins.Left;//+GetCustomWMNCCalcSizeLeftWidth;
      PNewWindowRect.Top:=PNewWindowRect.Top+Self.FNCBorderMargins.Top;
      PNewWindowRect.Right:=PNewWindowRect.Right-Self.FNCBorderMargins.Right;//-GetCustomWMNCCalcSizeRightWidth;
      PNewWindowRect.Bottom:=PNewWindowRect.Bottom-Self.FNCBorderMargins.Bottom;
    end;
  end;
end;

procedure TSkinWinEdit.WMNCPaint(var Message: TWMNCPaint);
begin
//  Inherited;
  Message.Result:=1;
  NCPaintWindow;
end;

procedure TSkinWinEdit.WMKillFocus(var Message: TMessage);
begin
  Inherited;
  Invalidate;
  NCPaintWindow;
end;

procedure TSkinWinEdit.OnCheckMouseStayTimer(Sender: TObject);
var
  CursorPos:TPoint;
  WindowRect:TRect;
begin
  case FCheckMouseStayTimerID of
    0://�ж�����Ƿ��ڿؼ���
    begin

      if GetCursorPos(CursorPos)
          and Windows.GetWindowRect(Handle,WindowRect)
          and Windows.PtInRect(WindowRect,CursorPos) then
      begin
        //����ڿؼ���,ˢ��
        NCPaintWindow;
        Invalidate;
      end
      else
      begin
        Self.IsMouseOver:=False;
        CreateCheckMouseStayTimer;
        Self.FCheckMouseStayTimer.Enabled:=False;
//        DoCustomMouseLeave;
        NCPaintWindow;
        Invalidate;
      end;
    end;
  end;
end;

procedure TSkinWinEdit.WMNCHitTest(var Message: TWMNCHitTest);
begin
  Inherited;
  if Not (csDesigning in Self.ComponentState) then
  begin

//      //����������״̬
//      if Not Self.IsMouseOver then
//      begin
//        Self.IsMouseOver:=True;
////        DoCustomMouseEnter;
//        CreateCheckMouseStayTimer;
//        Self.FCheckMouseStayTimerID:=0;
//        Self.FCheckMouseStayTimer.Enabled:=True;
//        Invalidate;
//        Self.NCPaintWindow;
//      end;

  end;
end;

procedure TSkinWinEdit.WMSize(var Message: TWMSize);
begin
  Inherited;
//  if Not (csDesigning in Self.ComponentState) then
//  begin
    Invalidate;
    Self.NCPaintWindow;
//  end;
end;

function TSkinWinEdit.GetEditProperties: TEditProperties;
begin
  Result:=TEditProperties(Self.FProperties);
end;

procedure TSkinWinEdit.SetEditProperties(Value: TEditProperties);
begin
  Self.FProperties.Assign(Value);
end;

function TSkinWinEdit.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TEditProperties;
end;

function TSkinWinEdit.IsReadOnly:Boolean;
begin
  Result:=ReadOnly;
end;

function TSkinWinEdit.GetPasswordChar:Char;
begin
  Result:=PasswordChar;
end;

function TSkinWinEdit.GetText:String;
begin
  Result:=Text;
end;

procedure TSkinWinEdit.SetCaption(const Value:String);
begin
  if Caption<>Value then
  begin
    Inherited Caption:=Value;
    if GetSkinControlType<>nil then
    begin
      TSkinControlType(GetSkinControlType).TextChanged;
    end;
  end;
end;

function TSkinWinEdit.GetCaption:String;
begin
  Result:=Inherited Caption;
end;


procedure TSkinWinEdit.BindingItemText(const AName:String;const AText:String;ASkinItem:TObject;AIsDrawItemInteractiveState:Boolean);
begin
  Self.EditProperties.DrawText:=AText;
end;


procedure TSkinWinEdit.SetControlValueByBindItemField(const AFieldName:String;
                                              const AFieldValue:Variant;
                                              ASkinItem:TObject;
                                              AIsDrawItemInteractiveState:Boolean);
begin
  Self.EditProperties.DrawText:=AFieldValue;
end;



end.

