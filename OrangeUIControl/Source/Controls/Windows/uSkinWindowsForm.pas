//WindowsƤ������
unit uSkinWindowsForm;

interface
{$I FrameWork.inc}

{$I Source\Controls\Windows\WinForm.inc}

uses
  SysUtils,
  Classes,
  Windows,
  Messages,
  Graphics,
  Controls,
  Menus,
  Math,
  Dialogs,
  ExtCtrls,
  Forms,
  Types,
  uVersion,
  uFuncCommon,
  uSkinPublic,
  uGraphicCommon,
  uBaseLog,
  uBaseList,
  uComponentType,
  uSkinFormType,
  uDrawEngine,
  uDrawCanvas,
  uSkinBufferBitmap,
  uDrawPicture,
//  uSkinPackage,
  uDrawParam,
//  uCopyRight,

  Dwmapi,
  UxTheme,
//  Winapi.Dwmapi,
//  Winapi.UxTheme,

  uBinaryTreeDoc,
  uSkinRegManager,
  uSkinMaterial,
  uSkinButtonType,
  uSkinImageType,
  uSkinLabelType,
//  uSkinWindowsLabel,
//  uSkinWindowsButton,
//  uSkinWindowsImage,
  uDrawPictureParam,
  uDrawRectParam,
  uDrawLineParam,
  uDrawTextParam;


type
  TSkinWinForm=class(TComponent,
                    ISkinForm,
                    ISkinControl,
                    IDirectUIParent,
                    ISkinControlMaterial
                    )
  private
    {$I Source\Controls\Windows\ISkinForm_Declare.inc}
  private
    {$I Source\Controls\INC\Common\ISkinControl_Declare.inc}
    {$I Source\Controls\Windows\ISkinControl_Form_Impl_Mouse_Declare_VCL.inc}
    {$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Property_Declare.inc}
    {$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Declare.inc}
  protected
    //{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Common_Declare.inc}

    Left:Integer;
    Top:Integer;
    Parent:TParentControl;
    FParentMouseEvent:Boolean;

    //����¼���������-�Զ�,����,������
    FMouseEventTransToParentType:TMouseEventTransToParentType;
    FParentIsScrollBox:Boolean;
    FParentScrollBox:TControl;


    //���������Ϣ����
    FParentIsCanGesutrePageControl:Boolean;
    FParentCanGesutrePageControl:TControl;


    function GetParentMouseEvent:Boolean;
    procedure SetParentMouseEvent(const AValue:Boolean);
    property ParentMouseEvent:Boolean read GetParentMouseEvent write SetParentMouseEvent;



    function GetMouseEventTransToParentType:TMouseEventTransToParentType;
    procedure SetMouseEventTransToParentType(const AValue:TMouseEventTransToParentType);

    function GetParentIsScrollBox:Boolean;
    function GetParentScrollBox:TControl;
  protected
    //ˢ�¿ؼ�
    procedure Invalidate;
    //���ÿؼ�λ�úͳߴ�
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);overload;
    procedure SetBounds(ABoundsRect:TRectF);overload;
  protected
    //���ʱ���
    FDesignWidth: Integer;
    //���ʱ�߶�
    FDesignHeight: Integer;
  published
    //���ʱ����Ĵ�����
    property DesignWidth:Integer read FDesignWidth write FDesignWidth;
    //���ʱ����Ĵ���߶�
    property DesignHeight:Integer read FDesignHeight write FDesignHeight;






  protected
    //����λͼ
    FBufferBitmap:TBufferBitmap;
    //����λͼ
    function GetBufferBitmap: TBufferBitmap;
    //����λͼ
    property BufferBitmap:TBufferBitmap read GetBufferBitmap;
  protected
    function GetSkinFormType:TSkinBaseFormType;







  protected
    FSyncSystemControlsTimer:TTimer;
    procedure OnSyncSystemControlsTimer(Sender:TObject);
  protected
    //�رհ�ť
    FCloseSysBtn:TSkinChildButton;
    //��С����ť
    FMinSysBtn:TSkinChildButton;
    //��ԭ/��󻯰�ť
    FMaxRestoreSysBtn:TSkinChildButton;
    //����ͼ��
    FFormSysIcon:TSkinChildImage;
    //�������
    FFormSysCaption:TSkinChildLabel;
    //����ؼ��б�
    FSystemControls:TSkinControlList;

    FOnSyncSystemControls:TNotifyEvent;
  protected
    function GetCloseSysBtn: TSkinChildButton;
    function GetMaxRestoreSysBtn: TSkinChildButton;
    function GetMinSysBtn: TSkinChildButton;
    function GetFormSysCaption: TSkinChildLabel;
    function GetFormSysIcon: TSkinChildImage;
  protected
    //�رհ�ť
    procedure OnCloseSysBtnClick(Sender:TObject);
    //��ԭ/��󻯰�ť
    procedure OnMaxRestoreSysBtnClick(Sender:TObject);
    //��С����ť
    procedure OnMinSysBtnClick(Sender:TObject);
  published
    //����
    property Caption:String read GetCaption write SetCaption;


    //�رհ�ť
    property CloseSysBtn:TSkinChildButton read GetCloseSysBtn;
    //��ԭ/��󻯰�ť
    property MaxRestoreSysBtn:TSkinChildButton read GetMaxRestoreSysBtn;
    //��С����ť
    property MinSysBtn:TSkinChildButton read GetMinSysBtn;
    //����ͼ��
    property FormSysIcon:TSkinChildImage read GetFormSysIcon;
    //�������
    property FormSysCaption:TSkinChildLabel read GetFormSysCaption;



    property OnSyncSystemControls:TNotifyEvent read FOnSyncSystemControls write FOnSyncSystemControls;







  protected
    //���������
    procedure Loaded;override;
    //�ؼ�֪ͨ
    procedure Notification(AComponent:TComponent;Operation:TOperation);override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;









  protected
    FPaintData:TPaintData;


    //���õĴ���
    FForm:TForm;

    //ԭ�ȵ���Ϣѭ��
    FOldWindowMethod:TWndMethod;


    //��ȡ������
    function GetFormHandle:HWND;
    //��ȡ����߿�
    function GetBorderStyle:TBorderStyle;
    //��ȡ����״̬(��С��,���,��ԭ)
    function GetWindowState:TWindowState;
    //���ô���״̬
    procedure SetWindowState(const Value:TWindowState);




    //��ȡ���廭��
    function GetFormWindowCanvas:TDrawCanvas;
    //��ȡ�ͻ�������
    function GetFormClientCanvas:TDrawCanvas;

    //�ͷŴ��廭��
    procedure ReleaseFormCanvas(ACanvas:TDrawCanvas);



//    //�ػ洰��ϵͳ�ؼ�(�����ͼ����ĵ�ʱ��)
//    procedure InvalidateSystemControls;virtual;

    //�����ӿؼ�
    procedure PaintSubControlsInFormPaint(DC: HDC);



  private
    //�ؼ�������ͻ������Ƿǿͻ���
    procedure IsControlInWhere(AControl:TControl;AControlIntf:IDirectUIControl;var InClient:Boolean;var InNotClient:Boolean);
    //��ȡ�ؼ����еķǿͻ�������
    function GetControlWindowRect(AControl:TControl;AControlIntf:IDirectUIControl):TRectF;
    //�ػ浥������ؼ�
    procedure UpdateChild(AControl:TControl;AControlIntf:IDirectUIControl);
    //���ƿͻ�����DirectUI�ؼ�
    procedure DrawDirectUIControls(ACanvas:TDrawCanvas;const InClientRect:Boolean);





    //����ؼ��������Ϣ
    function ProcessMouseDownDirectUIControls(AHitTestValue:Integer;Button: TMouseButton; Shift: TShiftState;X,Y:Integer):Boolean;
    function ProcessMouseUpDirectUIControls(AHitTestValue:Integer;Button: TMouseButton; Shift: TShiftState;X,Y:Integer):Boolean;
    procedure ProcessMouseMoveDirectUIControls(AHitTestValue:Integer;Shift: TShiftState; X,Y:Integer);
    procedure ProcessMouseLeaveDirectUIControls;
    function NCHitTestDirectUIControls(Pt:TPointF):Integer;
    function GetDirectUIControlByHitTestValue(AHitTestValue:Integer;var AHitedControlIntf:IDirectUIControl):Boolean;
//    function GetCaption: String;
//    function GetEnabled: Boolean;
//    function GetFocused: Boolean;
//    function GetHeight: Integer;
//    function GetHeightInt: Integer;
//    function GetLeft: Integer;
//    function GetParent: TParentControl;
//    function GetPropertiesClassType: TPropertiesClassType;
//    function GetTop: Integer;
//    function GetVisible: Boolean;
//    function GetWidth: Integer;
//    function GetWidthInt: Integer;
//    procedure InvalidateSubControls;
//    procedure SetBounds(ALeft, ATop, AWidth, AHeight: TControlSize);
//    procedure SetCaption(const Value: String);
//    procedure SetFocused(const Value: Boolean);
//    procedure SetHeight(const Value: Integer);
//    procedure SetHeightInt(const Value: Integer);
//    procedure SetLeft(const Value: Integer);
//    procedure SetParent(const Value: TParentControl);
//    procedure SetTop(const Value: Integer);
//    procedure SetVisible(const Value: Boolean);
//    procedure SetWidth(const Value: Integer);
//    procedure SetWidthInt(const Value: Integer);
//    procedure SyncSystemControls;
//    procedure UpdateWindowClient(AWindowClientCanvas: TDrawCanvas;
//      const AUpdateClientRect, AUpdateWindowRect: PRectF;
//      const EnableBuffer: Boolean);
//    procedure UpdateWindowNotClient(const AUpdateWindowRect: PRectF;
//      const EnableBuffer: Boolean);
//    function GetCaption: String;
//    function GetEnabled: Boolean;
//    function GetFocused: Boolean;
//    function GetHeight: Integer;
//    function GetHeightInt: Integer;
//    function GetLeft: Integer;
//    function GetParent: TParentControl;
//    function GetPropertiesClassType: TPropertiesClassType;
//    function GetTop: Integer;
//    function GetVisible: Boolean;
//    function GetWidth: Integer;
//    function GetWidthInt: Integer;
//    procedure InvalidateSubControls;
//    procedure SetBounds(ALeft, ATop, AWidth, AHeight: TControlSize);
//    procedure SetCaption(const Value: String);
//    procedure SetFocused(const Value: Boolean);
//    procedure SetHeight(const Value: Integer);
//    procedure SetHeightInt(const Value: Integer);
//    procedure SetLeft(const Value: Integer);
//    procedure SetParent(const Value: TParentControl);
//    procedure SetTop(const Value: Integer);
//    procedure SetVisible(const Value: Boolean);
//    procedure SetWidth(const Value: Integer);
//    procedure SetWidthInt(const Value: Integer);
//    procedure SyncSystemControls;
//    procedure UpdateWindowClient(AWindowClientCanvas: TDrawCanvas;
//      const AUpdateClientRect, AUpdateWindowRect: PRectF;
//      const EnableBuffer: Boolean);
//    procedure UpdateWindowNotClient(const AUpdateWindowRect: PRectF;
//      const EnableBuffer: Boolean);










  protected
    procedure DoFormPaint(Sender:TObject);
//    //���ô���Բ��
//    procedure SetFormRegion;virtual;
  public
//    FIsEnabledDwmShadow:Boolean;
//    FIsSetedFormShadow:Boolean;
    //����
    property Form:TForm read FForm;

    //���ô���
    procedure SetForm(const Value: TForm);
  public
    //��ȡ���ؼ����ӿؼ�
    function GetParentChildControlCount:Integer;
    function GetParentChildControl(Index:Integer):TChildControl;


    //��ȡ�ӿؼ�
    function GetChildControlCount:Integer;
    function GetChildControl(Index:Integer):TChildControl;











  protected
    //�������Ϣѭ��
    procedure NewWindowMethod(var Message:TMessage);

    //VCL��Ϣѭ��
    procedure BeforeWndProc(var Message:TMessage;var AIsNoNeedCallStdWndProd:Boolean);
    procedure AfterWndProc(var Message:TMessage);

    //���´������
    procedure WMSetTextAfter(var Message:TMessage);message WM_SETTEXT;
    //����������
    procedure CMTextChangedAfter(var Message:TMessage);virtual;
    //ͼ�����
    procedure CMIconChangedAfter(var Message:TMessage);virtual;


    //��������Ϣ����
    procedure CMMouseEnter(var Message:TMessage);message CM_MOUSEENTER;
    //����뿪
    procedure CMMouseLeave(var Message:TMessage);message CM_MOUSELEAVE;






    //��Ϣ����//
    //�ǿͻ��������л���Ϣ
    procedure WMNCActivateBefore(var Message:TWMNCActivate;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    procedure WMNCActivateAfter(var Message:TWMNCActivate);virtual;
    //���㴰��ͻ������ε���Ϣ
    procedure WMNCCalcSizeBefore(var Message:TWMNCCalcSize;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    procedure WMNCCalcSizeAfter(var Message:TWMNCCalcSize);virtual;
    //�ǿͻ������������
    procedure WMNCHitTestBefore(var Message: TWMNCHitTest;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    procedure WMNCHitTestAfter(var Message: TWMNCHitTest);virtual;



    //������屳��
    procedure WMEraseBackGndBefore(var Message:TWMEraseBkGnd;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    procedure WMEraseBackGndAfter(var Message:TWMEraseBkGnd);virtual;
//    //�ͻ���������Ϣ
//    procedure WMPaintBefore(var Message:TWMPaint;var AIsNoNeedCallStdWndProd:Boolean);virtual;
//    procedure WMPaintAfter(var Message:TWMPaint);virtual;
//    //���ʱ������Ϣ����
//    procedure PaintHandler(var Message: TWMPaint);

    //�ӿؼ�����͸����Ҫ
    procedure WMPrintClientBefore(var Message:TWMPrintClient;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    procedure WMPrintClientAfter(var Message:TWMPrintClient);virtual;

//    //���յ�DWM�����û���õ���Ϣ
//    procedure WMDWMNCRENDERINGCHANGEDBefore(var Message:TMessage;var AIsNoNeedCallStdWndProd: Boolean);



    //�ǿͻ���������Ϣ
    procedure WMNCPaintBefore(var Message: TWMNCPaint;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    procedure WMNCPaintAfter(var Message: TWMNCPaint);virtual;


    //ϵͳ����
    procedure WMNCUAHDrawFrameBefore(var Message: TMessage;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    procedure WMNCUAHDrawCaptionBefore(var Message: TMessage;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    procedure WMSYNCPaintBefore(var Message: TMessage;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    procedure WMActivateAfter(var Message: TMessage);virtual;
    procedure WMSetCursorAfter(var Message: TMessage);virtual;
    procedure CMRePaintInFormNCMessageBefore(var Message:TMessage;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    //�϶������С
    procedure WMSizeBefore(var Message:TWMSize;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    procedure WMSizeAfter(var Message:TWMSize);virtual;




    //�ǿͻ��������������¼�����
    procedure WMNCLButtonDownBefore(var Message: TWMNCLButtonDown;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    procedure WMNCLButtonDownAfter(var Message: TWMNCLButtonDown);virtual;
    //�ǿͻ��������������¼�����
    procedure WMNCLButtonUpBefore(var Message: TWMNCLButtonUp;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    procedure WMNCLButtonUpAfter(var Message: TWMNCLButtonUp);virtual;
    //�ǿͻ�������ƶ��¼�����
    procedure WMNCMouseMoveBefore(var Message: TWMNCMouseMove;var AIsNoNeedCallStdWndProd:Boolean);virtual;
    procedure WMNCMouseMoveAfter(var Message: TWMNCMouseMove);virtual;
    //�ǿͻ�������뿪�¼�����
    procedure WMNCMouseLeaveAfter(var Message: TMessage);virtual;

    //�ǿͻ������˫���¼�
    procedure WMNCLBUTTONDBLCLK(var Message: TWMNCLButtonDblClk);virtual;


    //�ͻ��������������¼�����
    procedure WMLButtonDownAfter(var Message: TWMLButtonDown);virtual;
    //�ͻ��������������¼�����
    procedure WMLButtonUpAfter(var Message: TWMLButtonUp);virtual;
    //�ͻ�������ƶ��¼�����
    procedure WMMouseMoveAfter(var Message: TWMMouseMove);virtual;

  end;





  TSkinWinNormalForm=class(TSkinWinForm)
  protected
    function GetSkinControlTypeClass:TControlTypeClass;override;
    function GetMaterialClass:TMaterialClass;override;
    procedure CreateSkinControlType;override;
    procedure CheckSelfOwnMaterial;override;
    procedure CheckCurrentUseMaterial;override;
  end;

procedure SetFormShadow(AFormHandle:THandle;AEnabled:Boolean;var AIsSetedFormShadow:Boolean);


implementation





{ TSkinWinForm }

{$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Field_Code.inc}
{$I Source\Controls\INC\Common\ISkinComponent_Properties_Impl_Code.inc}
{$I Source\Controls\Windows\ISkinControl_Form_Impl_Mouse_Code_VCL.inc}
{$I Source\Controls\INC\Common\ISkinControl_Control_Impl_Mouse_Code.inc}


function TSkinWinForm.GetParentMouseEvent:Boolean;
begin
end;

function TSkinWinForm.GetMouseEventTransToParentType:TMouseEventTransToParentType;
begin
  {$IFDEF FMX}
  Result:=FMouseEventTransToParentType;
  {$ENDIF}

  {$IFDEF VCL}
  {$ENDIF}
end;

procedure TSkinWinForm.SetMouseEventTransToParentType(const AValue:TMouseEventTransToParentType);
begin
  {$IFDEF FMX}
  FMouseEventTransToParentType:=AValue;
  {$ENDIF}

  {$IFDEF VCL}
  {$ENDIF}
end;

procedure TSkinWinForm.SetParentMouseEvent(const AValue:Boolean);
begin
end;

function TSkinWinForm.GetParentChildControlCount:Integer;
begin
  Result:=0;
  if (FForm<>nil) and (Self.FForm.Parent<>nil) then Result:=Self.FForm.Parent.ControlCount;
end;

function TSkinWinForm.GetParentChildControl(Index:Integer):TChildControl;
begin
  Result:=nil;
  if (FForm<>nil) and (Self.FForm.Parent<>nil) then Result:=Self.FForm.Parent.Controls[Index];
end;

function TSkinWinForm.GetChildControlCount:Integer;
begin
  Result:=0;
  if FForm<>nil then Result:=FForm.ControlCount;
end;

function TSkinWinForm.GetChildControl(Index:Integer):TChildControl;
begin
  Result:=nil;
  if FForm<>nil then Result:=FForm.Controls[Index];
end;

procedure TSkinWinForm.SetLeft(const Value: Integer);
begin
  if FForm<>nil then FForm.Left:=Value;
end;

procedure TSkinWinForm.SetParent(const Value: TParentControl);
begin
  if FForm<>nil then FForm.Parent:=Value;
end;

procedure TSkinWinForm.SetFocused(const Value: Boolean);
begin
end;

procedure TSkinWinForm.SetTop(const Value: Integer);
begin
  if FForm<>nil then FForm.Top:=Value;
end;

procedure TSkinWinForm.DoFormPaint(Sender:TObject);
begin
  Self.UpdateWindowClient(nil);
end;

procedure TSkinWinForm.SetForm(const Value: TForm);
begin
  if FForm<>Value then
  begin
    if (FForm<>nil) then
    begin
      FForm.WindowProc:=Self.FOldWindowMethod;


      if Self.FCloseSysBtn<>nil then
      begin
        Self.FCloseSysBtn.Parent:=nil;
      end;
      if Self.FMinSysBtn<>nil then
      begin
        Self.FMinSysBtn.Parent:=nil;
      end;
      if Self.FMaxRestoreSysBtn<>nil then
      begin
        Self.FMaxRestoreSysBtn.Parent:=nil;
      end;
      if Self.FFormSysIcon<>nil then
      begin
        Self.FFormSysIcon.Parent:=nil;
      end;
      if Self.FFormSysCaption<>nil then
      begin
        Self.FFormSysCaption.Parent:=nil;
      end;


      //ˢ��ԭ����

      FForm.OnPaint:=nil;

    end;



    FForm := Value;



    if (FForm<>nil) then
    begin

      if Self.FCloseSysBtn<>nil then
      begin
        Self.FCloseSysBtn.Parent:=FForm;
      end;
      if Self.FMinSysBtn<>nil then
      begin
        Self.FMinSysBtn.Parent:=FForm;
      end;
      if Self.FMaxRestoreSysBtn<>nil then
      begin
        Self.FMaxRestoreSysBtn.Parent:=FForm;
      end;
      if Self.FFormSysIcon<>nil then
      begin
        Self.FFormSysIcon.Parent:=FForm;
      end;
      if Self.FFormSysCaption<>nil then
      begin
        Self.FFormSysCaption.Parent:=FForm;
      end;



      Self.FOldWindowMethod:=FForm.WindowProc;
      FForm.WindowProc:=Self.NewWindowMethod;
      FForm.FreeNotification(Self);




      if Self.FDesignWidth>0 then
      begin
        FForm.SetBounds(FForm.Left,FForm.Top,FDesignWidth,FDesignHeight);
      end
      else
      begin
        FDesignWidth:=FForm.Width;
        FDesignHeight:=FForm.Height;
      end;
      //ˢ���´���

      FForm.OnPaint:=DoFormPaint;

    end;
  end;
end;








procedure TSkinWinForm.ReleaseFormCanvas(ACanvas:TDrawCanvas);
begin
  if ACanvas<>nil then
  begin
    ReleaseDC(GetFormHandle,ACanvas.Handle);
    FreeAndNil(ACanvas);
  end;
end;

function TSkinWinForm.GetFormWindowCanvas:TDrawCanvas;
var
  ADC:HDC;
begin
  Result:=nil;
  ADC:=GetWindowDC(GetFormHandle);
  Result:=CreateDrawCanvas('TSkinWinForm.GetFormWindowCanvas');
  if Result<>nil then
  begin
    Result.Prepare(ADC);
  end;
end;

function TSkinWinForm.GetFormClientCanvas:TDrawCanvas;
var
  ADC:HDC;
begin
  Result:=nil;
  ADC:=GetDC(GetFormHandle);
  Result:=CreateDrawCanvas('TSkinWinForm.GetFormClientCanvas');
  if Result<>nil then
  begin
    Result.Prepare(ADC);
  end;
end;

procedure TSkinWinForm.NewWindowMethod(var Message: TMessage);
var
  AIsNoNeedCallStdWndProd:Boolean;
begin
  AIsNoNeedCallStdWndProd:=False;


//  DebugMessage(Message);

  if Message.Msg=WM_SIZE then
  begin
    FDesignWidth:=FForm.Width;
    FDesignHeight:=FForm.Height;
  end;


  if (Self.GetSkinControlType<>nil) then
  begin
    BeforeWndProc(Message,AIsNoNeedCallStdWndProd);
  end;


  if Not AIsNoNeedCallStdWndProd then
  begin
    //����Inherited;
    Self.FOldWindowMethod(Message);
  end;


  if (GetSkinControlType<>nil) then
  begin
    AfterWndProc(Message);
  end;


end;

function TSkinWinForm.GetFormHandle: HWND;
begin
  Result:=Self.FForm.Handle;
end;

procedure TSkinWinForm.AfterWndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_NCCALCSIZE:
    begin
      WMNCCalcSizeAfter(TWMNCCalcSize(Message));
    end;
    WM_NCPAINT:
    begin
      WMNCPaintAfter(TWMNCPaint(Message));
    end;
    WM_NCHITTEST:
    begin
      WMNCHitTestAfter(TWMNCHitTest(Message));
    end;
    WM_NCACTIVATE:
    begin
      WMNCActivateAfter(TWMNCActivate(Message));
    end;

    WM_NCMOUSEMOVE:
    begin
      WMNCMouseMoveAfter(TWMNCMouseMove(Message));
    end;
    WM_NCMOUSELEAVE:
    begin
      WMNCMouseLeaveAfter(Message);
    end;
    WM_NCLBUTTONDOWN:
    begin
      WMNCLButtonDownAfter(TWMNCLButtonDown(Message));
    end;
    WM_NCLBUTTONUP:
    begin
      WMNCLButtonUpAfter(TWMNCLButtonUp(Message));
    end;

    WM_MOUSEMOVE:
    begin
      WMMouseMoveAfter(TWMMouseMove(Message));
    end;
    WM_LBUTTONDOWN:
    begin
      WMLButtonDownAfter(TWMLButtonDown(Message));
    end;
    WM_LBUTTONUP:
    begin
      WMLButtonUpAfter(TWMLButtonUp(Message));
    end;


    WM_ACTIVATE:
    begin
      WMActivateAfter(Message);
    end;
    WM_SETCURSOR:
    begin
      WMSetCursorAfter(Message);
    end;
    WM_SIZE:
    begin
      WMSizeAfter(TWMSize(Message));
    end;
//    WM_PAINT:
//    begin
//      WMPaintAfter(TWMPaint(Message));
//    end;
    WM_PRINTCLIENT:
    begin
      WMPrintClientAfter(TWMPrintClient(Message));
    end;
    WM_ERASEBKGND:
    begin
      WMEraseBackGndAfter(TWMEraseBkGnd(Message));
    end;
    CM_TEXTCHANGED:
    begin
      CMTextChangedAfter(Message);
    end;
    CM_ICONCHANGED:
    begin
      CMIconChangedAfter(Message);
    end;

    WM_SETTEXT:
    begin
      WMSetTextAfter(Message);
    end;
  end;
end;

procedure TSkinWinForm.BeforeWndProc(var Message: TMessage;var AIsNoNeedCallStdWndProd: Boolean);
begin
  case Message.Msg of
    WM_NCCALCSIZE:
    begin
      WMNCCalcSizeBefore(TWMNCCalcSize(Message),AIsNoNeedCallStdWndProd);
    end;
    WM_NCPAINT:
    begin
      WMNCPaintBefore(TWMNCPaint(Message),AIsNoNeedCallStdWndProd);
    end;
    WM_NCACTIVATE:
    begin
      WMNCActivateBefore(TWMNCActivate(Message),AIsNoNeedCallStdWndProd);
    end;
    WM_NCHITTEST:
    begin
      WMNCHitTestBefore(TWMNCHitTest(Message),AIsNoNeedCallStdWndProd);
    end;


    WM_NCMOUSEMOVE:
    begin
      WMNCMouseMoveBefore(TWMNCMouseMove(Message),AIsNoNeedCallStdWndProd);
    end;
    WM_NCLBUTTONDOWN:
    begin
      WMNCLButtonDownBefore(TWMNCLButtonDown(Message),AIsNoNeedCallStdWndProd);
    end;
    WM_NCLBUTTONUP:
    begin
      WMNCLButtonUpBefore(TWMNCLButtonUp(Message),AIsNoNeedCallStdWndProd);
    end;
    WM_NCLBUTTONDBLCLK:
    begin
      WMNCLBUTTONDBLCLK(TWMNCLButtonDblClk(Message));
    end;



    WM_ERASEBKGND:
    begin
      WMEraseBackGndBefore(TWMEraseBkGnd(Message),AIsNoNeedCallStdWndProd);
    end;
    WM_SIZE:
    begin
      WMSizeBefore(TWMSize(Message),AIsNoNeedCallStdWndProd);
    end;
    WM_PRINTCLIENT:
    begin
      WMPrintClientBefore(TWMPrintClient(Message),AIsNoNeedCallStdWndProd);
    end;
//    WM_PAINT:
//    begin
//      WMPaintBefore(TWMPaint(Message),AIsNoNeedCallStdWndProd);
//    end;
    WM_NCUAHDRAWFRAME:
    begin
      WMNCUAHDrawFrameBefore(Message,AIsNoNeedCallStdWndProd);
    end;
    WM_NCUAHDRAWCAPTION:
    begin
      WMNCUAHDrawCaptionBefore(Message,AIsNoNeedCallStdWndProd);
    end;
    WM_SYNCPAINT:
    begin
      WMSYNCPaintBefore(Message,AIsNoNeedCallStdWndProd);
    end;
    CM_RePaintInFormNCMessage:
    begin
      CMRePaintInFormNCMessageBefore(Message,AIsNoNeedCallStdWndProd);
    end;
//    WM_DWMNCRENDERINGCHANGED:
//    begin
//      WMDWMNCRENDERINGCHANGEDBefore(Message,AIsNoNeedCallStdWndProd);
//    end;
  end;
end;

procedure TSkinWinForm.CMIconChangedAfter(var Message: TMessage);
begin
  //���Self.FForm.IconΪ��,Assign֮�󱣴�ᱨ��
//  if (Self.FFormSysIcon<>nil) then
//  begin
//    if not Self.FForm.Icon.Empty then
//    begin
//      FFormSysIcon.Properties.Picture.Assign(Self.FForm.Icon);
//    end
//    else
//    begin
//      FFormSysIcon.Properties.Picture.Clear;
//    end;
//  end;
end;

procedure TSkinWinForm.CMTextChangedAfter(var Message: TMessage);
begin
  if Self.GetSkinControlType<>nil then
  begin
    TSkinControlType(Self.GetSkinControlType).TextChanged;
  end;

  if Self.FFormSysCaption<>nil then
  begin
    FFormSysCaption.Caption:=GetCaption;
  end;
end;

//procedure TSkinWinForm.PaintHandler(var Message: TWMPaint);
//var
//  I, Clip, SaveIndex: Integer;
//  DC: HDC;
//  PS: TPaintStruct;
//  AWindowClientCanvas:TDrawCanvas;
//begin
//  Exit;
//  DC := Message.DC;
//  if DC = 0 then DC := BeginPaint(Self.GetFormHandle, PS);
//  AWindowClientCanvas:=CreateDrawCanvas;
//  if AWindowClientCanvas<>nil then
//  begin
//    try
//        AWindowClientCanvas.Prepare(DC);
//
//
//
//
//  //      if Self.GetControlCount=0 then
//  //      begin
//  //        Self.UpdateWindowClient(AWindowClientCanvas);
//  //      end
//  //      else
//  //      begin
//    //      SaveIndex := SaveDC(DC);
//    //      try
//    //        Clip := SimpleRegion;
//    //        for I := 0 to Self.FSkinFormIntf.ControlCount-1 do//FControls.Count - 1 do
//    //          with TControl(Self.FSkinFormIntf.Controls[I]) do//FControls[I]) do
//    //            if (Visible and (not (csDesigning in ComponentState) or not (csDesignerHide in ControlState)) or
//    //              ((csDesigning in ComponentState) and not (csDesignerHide in ControlState)) and
//    //              not (csNoDesignVisible in ControlStyle)) and
//    //              (csOpaque in ControlStyle) then
//    //            begin
//    //              Clip := ExcludeClipRect(DC, Left, Top, Left + Width, Top + Height);
//    //              if Clip = NullRegion then Break;
//    //            end;
//    //        if Clip <> NullRegion then
//            UpdateWindowClient(AWindowClientCanvas);
//    //      finally
//    //        RestoreDC(DC, SaveIndex);
//    //      end;
//  //      end;
//
//
//
////        //����OnPaint�¼�
////        if Assigned(Self.FForm.OnPaint) then
////        begin
////          Self.FForm.OnPaint(FForm);
////        end;
//
//
//
//        //�����ӿؼ�GraphicControl
//        PaintSubControlsInFormPaint(DC);
//
//
//
//
//
//
//    finally
//      if Message.DC = 0 then EndPaint(Self.GetFormHandle, PS);
//      //�ͷŻ���
//      FreeAndNil(AWindowClientCanvas);
//    end;
//  end;
//
//end;

procedure TSkinWinForm.WMNCCalcSizeBefore(var Message: TWMNCCalcSize;var AIsNoNeedCallStdWndProd: Boolean);
begin
  if (csDesigning in Self.ComponentState) then Exit;

  if not IsIconic(Self.GetFormHandle) then
  begin
    AIsNoNeedCallStdWndProd:=True;
  end
  else
  begin
    AIsNoNeedCallStdWndProd:=False;
  end;
end;

procedure TSkinWinForm.WMNCHitTestAfter(var Message: TWMNCHitTest);
var
  P: TPointF;
  CanResize: Boolean;
  Hitted:Boolean;
  ABorderSize:Integer;
begin
  //    'HTERROR',
  //    'HTTRANSPARENT',
  //    'HTNOWHERE',
  //    'HTCLIENT - �ͻ���',
  //    'HTCAPTION - ����',
  //    'HTSYSMENU - ϵͳ�˵�',
  //    'HTGROWBOX',
  //    'HTMENU - �˵�',
  //    'HTHSCROLL - ˮƽ������',
  //    'HTVSCROLL - ��ֱ������',
  //    'HTMINBUTTON - ��С����ť',
  //    'HTMAXBUTTON - ��󻯰�ť',
  //    'HTLEFT - ��߽�',
  //    'HTRIG - �ұ߽�',
  //    'HTTOP - �ϱ߽�',
  //    'HTTOPLEFT - ���Ͻ�',
  //    'HTTOPRIG - ���Ͻ�',
  //    'HTBOTTOM - �±߽�',
  //    'HTBOTTOMLEFT - ���½�',
  //    'HTBOTTOMRIG - ���½�',
  //    'HTBORDER',
  //    'HTOBJECT',
  //    'HTCLOSE - �رհ�ť',
  //    'HTHELP');
  ////�� WM_NCHITTEST ��Ϣ�� Result ���������п���ֵ���б�:
  //HTERROR       = -2;
  //HTTRANSPARENT = -1;
  //HTNOWHERE     = 0;
  //HTCLIENT      = 1;
  //HTCAPTION     = 2;
  //HTSYSMENU     = 3;
  //HTGROWBOX     = 4;
  //HTSIZE        = HTGROWBOX;
  //HTMENU        = 5;
  //HTHSCROLL     = 6;
  //HTVSCROLL     = 7;
  //HTMINBUTTON   = 8;
  //HTMAXBUTTON   = 9;
  //HTLEFT        = 10;
  //HTRIGHT       = 11;
  //HTTOP         = 12;
  //HTTOPLEFT     = 13;
  //HTTOPRIGHT    = 14;
  //HTBOTTOM      = 15;
  //HTBOTTOMLEFT  = $10;
  //HTBOTTOMRIGHT = 17;
  //HTBORDER      = 18;
  //HTREDUCE      = HTMINBUTTON;
  //HTZOOM        = HTMAXBUTTON;
  //HTSIZEFIRST   = HTLEFT;
  //HTSIZELAST    = HTBOTTOMRIGHT;
  //HTOBJECT      = 19;
  //HTCLOSE       = 20;
  //HTHELP        = 21;

  if Not (csDesigning in Self.ComponentState) then
  begin

      P.X:=Message.XPos - Self.GetLeft;
      P.Y:=Message.YPos - Self.GetTop;

      if not IsIconic(Self.GetFormHandle) then
      begin

        CanResize:=(Self.GetBorderStyle<>bsNone) and
                  (Self.GetBorderStyle<>bsDialog) and (Self.GetBorderStyle<>bsSingle) and (Self.GetBorderStyle<>bsToolWindow);

        Hitted:=False;

        if Not Hitted then
        begin
          Message.Result:=NCHitTestDirectUIControls(P);
          if Message.Result<>HTNOWHERE then
          begin
            Hitted:=True;
          end;
        end;


        ABorderSize:=5;


        if Hitted then
        begin
        end
        else if CanResize
          and (P.X>=-ABorderSize)
          and (P.X<=ABorderSize)
          and (P.Y>=-ABorderSize)
          and (P.Y<=ABorderSize)
          then
        begin
          Message.Result:=HTTOPLEFT;
        end
        else if CanResize
            and (P.X>=Self.GetWidth-ABorderSize)
            and (P.X<=Self.GetWidth+ABorderSize)
            and (P.Y>=-ABorderSize)
            and (P.Y<=ABorderSize)
            then
        begin
          Message.Result:=HTTOPRIGHT;
        end
        else if CanResize
            and (P.X>=-ABorderSize)
            and (P.X<=ABorderSize)
            and (P.Y>=Self.GetHeight-ABorderSize)
            and (P.Y<=Self.GetHeight+ABorderSize)
            then
        begin
          Message.Result:=HTBOTTOMLEFT;
        end
        else if CanResize
            and (P.X>=Self.GetWidth-ABorderSize)
            and (P.X<=Self.GetWidth+ABorderSize)
            and (P.Y>=Self.GetHeight-ABorderSize)
            and (P.Y<=Self.GetHeight+ABorderSize)
            then
        begin
          Message.Result:=HTBOTTOMRIGHT;
        end
        else if CanResize
            and (P.X>=-ABorderSize)
            and (P.X<=ABorderSize)
            then
        begin
          Message.Result:=HTLEFT;
        end
        else if CanResize
            and (P.Y>=-ABorderSize)
            and (P.Y<=ABorderSize)
            then
        begin
          Message.Result:=HTTOP;
        end
        else if CanResize
            and (P.X>=Self.GetWidth-ABorderSize)
            and (P.X<=Self.GetWidth+ABorderSize)
            then
        begin
          Message.Result:=HTRIGHT;
        end
        else if CanResize
            and (P.Y>=Self.GetHeight-ABorderSize)
            and (P.Y<=Self.GetHeight+ABorderSize)
            then
        begin
          Message.Result:=HTBOTTOM;
        end
        else if (P.X>=ABorderSize)
            and (P.X<=Self.GetWidth-ABorderSize)
            and (P.Y>=ABorderSize)
            and ((P.Y<=GetSkinFormType.GetCustomCaptionBarHeight)
                or  (P.Y<=30) )
            then
        begin
          Message.Result:=HTCAPTION;
        end
         else if (P.X>=ABorderSize)
            and (P.X<=Self.GetWidth-ABorderSize)
            and ((P.Y>=25)
                or (P.Y>=GetSkinFormType.GetCustomCaptionBarHeight))
            and (P.Y<=Self.GetHeight-ABorderSize)
            then
        begin
          Message.Result:=HTCLIENT;
        end
        else
        begin
          Message.Result:=HTNOWHERE;
        end;

    end

    ;
  end;

//  Windows.OutputDebugString(PWideChar('WMNCHitTestAfter '+IntToStr(Message.Result)));
end;

procedure TSkinWinForm.WMNCHitTestBefore(var Message: TWMNCHitTest;var AIsNoNeedCallStdWndProd: Boolean);
begin
  if Not (csDesigning in Self.ComponentState) then
  begin
    if not IsIconic(Self.GetFormHandle) or GetSkinFormType.IsProcessIconicState then
    begin
      AIsNoNeedCallStdWndProd:=True;
    end;
  end;
end;

procedure TSkinWinForm.WMNCLButtonDownAfter(var Message: TWMNCLButtonDown);
begin
  if Not (csDesigning in Self.ComponentState) then
  begin
    ProcessMouseDownDirectUIControls(Message.HitTest,TMouseButton.mbLeft,[],Message.XCursor-Self.FForm.Left,Message.YCursor-Self.FForm.Top);
  end;
end;

procedure TSkinWinForm.WMNCLButtonDownBefore(var Message: TWMNCLButtonDown;var AIsNoNeedCallStdWndProd: Boolean);
begin
  if Not (csDesigning in Self.ComponentState) then
  begin
    if (Message.HitTest>=HTERROR) and (Message.HitTest<=HTHELP) then
    begin
      AIsNoNeedCallStdWndProd:=False;
    end
    else
    begin
      AIsNoNeedCallStdWndProd:=True;
    end;
  end;
end;

procedure TSkinWinForm.WMNCLButtonUpAfter(var Message: TWMNCLButtonUp);
begin
  if Not (csDesigning in Self.ComponentState) then
  begin
    ProcessMouseUpDirectUIControls(Message.HitTest,TMouseButton.mbLeft,[],Message.XCursor-Self.FForm.Left,Message.YCursor-Self.FForm.Top);
  end;
end;

procedure TSkinWinForm.WMNCLButtonUpBefore(var Message: TWMNCLButtonUp;var AIsNoNeedCallStdWndProd: Boolean);
begin
  if Not (csDesigning in Self.ComponentState) then
  begin
    if (Message.HitTest>=HTERROR) and (Message.HitTest<=HTHELP) then
    begin
      AIsNoNeedCallStdWndProd:=False;
    end
    else
    begin
      AIsNoNeedCallStdWndProd:=True;
    end;
  end;
end;

procedure TSkinWinForm.WMNCMouseLeaveAfter(var Message: TMessage);
begin
  if Not (csDesigning in Self.ComponentState) then
  begin
    ProcessMouseLeaveDirectUIControls;
  end;
end;





procedure TSkinWinForm.WMLButtonDownAfter(var Message: TWMLButtonDown);
begin
  if Not (csDesigning in Self.ComponentState) then
  begin
//    ProcessMouseDownDirectUIControls(-99,TMouseButton.mbLeft,[],Message.XPos,Message.YPos);


      //�������϶��ı��С

  end;
end;

procedure TSkinWinForm.WMLButtonUpAfter(var Message: TWMLButtonUp);
begin
  if Not (csDesigning in Self.ComponentState) then
  begin
    ProcessMouseUpDirectUIControls(-99,TMouseButton.mbLeft,[],Message.XPos,Message.YPos);
  end;
end;

procedure TSkinWinForm.WMMouseMoveAfter(var Message: TWMMouseMove);
begin
  if Not (csDesigning in Self.ComponentState) then
  begin
  end;
end;

procedure TSkinWinForm.WMSetCursorAfter(var Message: TMessage);
begin
  if Not (csDesigning in Self.ComponentState) then
  begin
    Self.UpdateWindowNotClient;
  end;
end;

procedure TSkinWinForm.WMActivateAfter(var Message: TMessage);
begin
//  Self.SetFormShadow(True);
  if Not (csDesigning in Self.ComponentState) then
  begin
//    Self.UpdateWindowNotClient;
  end;
end;

procedure TSkinWinForm.WMNCMouseMoveBefore(var Message: TWMNCMouseMove;var AIsNoNeedCallStdWndProd:Boolean);
begin
  if Not (csDesigning in Self.ComponentState) then
  begin
  end;
end;

procedure TSkinWinForm.WMNCMouseMoveAfter(var Message: TWMNCMouseMove);
begin
  if Not (csDesigning in Self.ComponentState) then
  begin
    ProcessMouseMoveDirectUIControls(Message.HitTest,[],Message.XCursor-Self.FForm.Left,Message.YCursor-Self.FForm.Top);
  end;
end;

procedure TSkinWinForm.WMNCPaintBefore(var Message: TWMNCPaint;var AIsNoNeedCallStdWndProd: Boolean);
begin
//  SetFormShadow(True);
//  if not IsIconic(Self.GetFormHandle) or GetSkinFormType.IsProcessIconicState then
//  begin


//    Message.Result:=1;

//    //�б߿��ʱ������Ҫ���߿��
//    Self.UpdateWindowNotClient;
//    AIsNoNeedCallStdWndProd:=True;



//  end;
end;

procedure TSkinWinForm.WMNCPaintAfter(var Message: TWMNCPaint);
begin
  //�б߿��ʱ������Ҫ���߿��
  Self.UpdateWindowNotClient;
end;

procedure TSkinWinForm.WMNCUAHDrawCaptionBefore(var Message: TMessage;var AIsNoNeedCallStdWndProd: Boolean);
begin
  if not IsIconic(Self.GetFormHandle) or (GetSkinFormType<>nil) and GetSkinFormType.IsProcessIconicState then
  begin
    Message.Result:=1;
    AIsNoNeedCallStdWndProd:=True;
  end;
end;

procedure TSkinWinForm.WMNCUAHDrawFrameBefore(var Message: TMessage;var AIsNoNeedCallStdWndProd: Boolean);
begin
  if not IsIconic(Self.GetFormHandle) or (GetSkinFormType<>nil) and GetSkinFormType.IsProcessIconicState then
  begin
    Message.Result:=1;
    AIsNoNeedCallStdWndProd:=True;
  end;
end;

//procedure TSkinWinForm.WMDWMNCRENDERINGCHANGEDBefore(var Message:TMessage;var AIsNoNeedCallStdWndProd: Boolean);
//begin
////  if Message.WParam=0 then
////  begin
////    uBaseLog.HandleException(nil,'WMDWMNCRENDERINGCHANGED �ر�');
////    FIsSetedFormShadow:=False;
////  end
////  else
////  begin
////    uBaseLog.HandleException(nil,'WMDWMNCRENDERINGCHANGED ����');
////  end;
////  Message.Result:=1;
////  AIsNoNeedCallStdWndProd:=True;
//end;


//procedure TSkinWinForm.WMPaintAfter(var Message: TWMPaint);
////var
////  LDC: HDC;
////  PS: TPaintStruct;
////  R: TRect;
//var
//  DC: HDC;
//  PS: TPaintStruct;
//  AWindowClientCanvas:TDrawCanvas;
//begin
//  Exit;
////  if (csDesigning in Self.ComponentState) then
////  begin
////    with TWMPaint(Message) do
////    begin
////      LDC := DC;
////      if LDC = 0 then
////        DC := BeginPaint(Self.GetClientHandle, PS);
////      try
////        if LDC = 0 then
////        begin
////          GetWindowRect(Self.GetClientHandle, R);
////          R.TopLeft := Self.GetScreenToClient(R.TopLeft);
////          MoveWindowOrg(DC, -R.Left, -R.Top);
////        end;
//
//        if not IsIconic(Self.GetFormHandle) then
//        begin
//          Self.FForm.ControlState:=Self.FForm.ControlState + [csCustomPaint];
//          PaintHandler(TWMPaint(Message));
//          Self.FForm.ControlState:=Self.FForm.ControlState - [csCustomPaint];
//        end;
//
////        else
////        if Not (csDesigning in Self.ComponentState) then
////        begin
////          //��С��ʱ����
////          DC := BeginPaint(Self.GetFormHandle, PS);
////          if GetSkinFormType.IsProcessIconicState then
////          begin
////            AWindowClientCanvas:=CreateDrawCanvas;
////            if AWindowClientCanvas<>nil then
////            begin
////              AWindowClientCanvas.Prepare(DC);
////              Self.UpdateWindowClient(AWindowClientCanvas);
////              FreeAndNil(AWindowClientCanvas);
////            end;
////          end
////          else
////          begin
//////            DrawIcon(DC, 0, 0, Self.GetIcon.Handle);
////          end;
////          EndPaint(Self.GetFormHandle, PS);
////        end
////        ;
//
//
//
//
////      finally
////        if LDC = 0 then
////          EndPaint(Self.GetClientHandle, PS);
////      end;
////    end;
////  end;
//end;
//
//procedure TSkinWinForm.WMPaintBefore(var Message: TWMPaint;var AIsNoNeedCallStdWndProd: Boolean);
//begin
////  if not IsIconic(Self.GetFormHandle) then
////  begin
////    AIsNoNeedCallStdWndProd:=True;
////    Message.Result:=1;
////  end;
//end;

procedure TSkinWinForm.WMPrintClientAfter(var Message: TWMPrintClient);
begin
  if (FBufferBitmap<>nil) and (GetSkinFormType<>nil) then
  begin
    Message.Result:=1;
    Bitblt(Message.DC,
          0,0,
          Self.GetWidth,
          Self.GetHeight,
          Self.GetBufferBitmap.Handle,
          GetSkinFormType.GetCustomBorderLeftWidth,
          GetSkinFormType.GetCustomCaptionBarNCHeight,
          SRCCOPY
          );
  end;
end;

procedure TSkinWinForm.WMPrintClientBefore(var Message: TWMPrintClient;var AIsNoNeedCallStdWndProd: Boolean);
begin
  if Not (csDesigning in Self.ComponentState) then
  begin
    AIsNoNeedCallStdWndProd:=True;
  end;
end;

procedure TSkinWinForm.WMSizeAfter(var Message: TWMSize);
begin
//  uBaseLog.OutputDebugString('TSkinWinForm.WMSizeAfter');
  if GetSkinFormType=nil then Exit;
  

  //���ô�������
  //������϶���ʱ���к�Ӱ,����DWM��Ӱ��Ч
//  SetFormRegion;

  GetSkinFormType.SizeChanged;
  GetSkinFormType.InvalidateAfterFormSize;
  InvalidateSubControls;
end;

procedure TSkinWinForm.WMSizeBefore(var Message: TWMSize; var AIsNoNeedCallStdWndProd: Boolean);
begin
  if GetSkinFormType=nil then Exit;
//  if Not (csDesigning in Self.ComponentState) then
//  begin
//    Self.AlignSystemControls;
    SyncSystemControls;
    GetSkinFormType.InvalidateBeforeFormSize;
//  end;
end;

procedure TSkinWinForm.WMSYNCPaintBefore(var Message: TMessage;var AIsNoNeedCallStdWndProd: Boolean);
begin
  if GetSkinFormType=nil then Exit;
  if not IsIconic(Self.GetFormHandle) or GetSkinFormType.IsProcessIconicState then
  begin
    Message.Result:=1;
    AIsNoNeedCallStdWndProd:=True;
  end;
end;

procedure TSkinWinForm.WMNCLBUTTONDBLCLK(var Message: TWMNCLButtonDblClk);
begin
//  TWMNCHitMessage = record
//    Msg: Cardinal;
//    MsgFiller: TDWordFiller;
//    HitTest: Longint;
//    HitTestFiller: TDWordFiller;
//    XCursor: Smallint;
//    YCursor: Smallint;
//    XYCursorFiller: TDWordFiller;
//    Result: LRESULT;
//  end;

  if (Message.HitTest=HTCAPTION) and (Form.BorderStyle<>bsSingle) then
  begin
      if Self.FForm.WindowState=wsMaximized then
      begin
        //Self.FForm.WindowState:=wsNormal;//����������Ч,SendMessageҲ��Ч,Ҫ��PostMessage
        PostMessage(FForm.Handle, WM_SYSCOMMAND,SC_RESTORE,0);
      end
      else
      begin
        //Self.FForm.WindowState:=wsMaximized;//����������Ч
        PostMessage(FForm.Handle, WM_SYSCOMMAND,SC_MAXIMIZE,0);
      end;
  end;

end;

procedure TSkinWinForm.CMRePaintInFormNCMessageBefore(var Message: TMessage;var AIsNoNeedCallStdWndProd: Boolean);
begin
  if GetSkinFormType=nil then Exit;
  if Not (csDesigning in Self.ComponentState) then
  begin
    GetSkinFormType.InvalidateInFormNCMessage;
  end;
end;

procedure TSkinWinForm.WMEraseBackGndAfter(var Message: TWMEraseBkGnd);
begin
//  if Not (csDesigning in Self.ComponentState) then
//  begin
//    if not IsIconic(Self.GetFormHandle) then
//    begin
//  //    Self.UpdateWindowNotClient;
//      Message.Result:=1;
//    end;
//  end;
end;

procedure TSkinWinForm.WMEraseBackGndBefore(var Message: TWMEraseBkGnd;var AIsNoNeedCallStdWndProd: Boolean);
begin
//  if Not (csDesigning in Self.ComponentState) then
//  begin
//    if GetSkinFormType=nil then Exit;
//    if not IsIconic(Self.GetFormHandle) or GetSkinFormType.IsProcessIconicState then
//    begin
//      Message.Result:=1;
//      AIsNoNeedCallStdWndProd:=True;
//    end;
//  end;
end;

procedure TSkinWinForm.WMNCActivateBefore(var Message: TWMNCActivate;var AIsNoNeedCallStdWndProd:Boolean);
begin
  if GetSkinFormType=nil then Exit;
//  if not Message.Active then
//  begin



//    //Ҫ��,��Ȼ���役���л�����ϵͳ�߿����ȥ
//    Message.Result:=1;//Ord(not Message.Active);
//    AIsNoNeedCallStdWndProd:=True;





//    Self.UpdateWindowNotClient;



//  end;
//  if FIsWMNCActivateInherited then
//  begin
//
//  end
//  else
//  begin
//    if not IsIconic(Self.GetFormHandle) or GetSkinFormType.IsProcessIconicState then
//    begin
//      Message.Result:=1;
//      AIsNoNeedCallStdWndProd:=True;
//    end;
//  end;
end;

procedure TSkinWinForm.WMNCActivateAfter(var Message: TWMNCActivate);
begin
  if GetSkinFormType=nil then Exit;
//  uBaseLog.OutputDebugString('TSkinWinForm.WMNCActivateAfter');
//  Self.UpdateWindowNotClient();
//  if FIsWMNCActivateInherited then
//  begin
//
//  end
//  else
//  begin
//    if not IsIconic(Self.GetFormHandle) or GetSkinFormType.IsProcessIconicState then
//    begin
//      Message.Result:=1;
//      AIsNoNeedCallStdWndProd:=True;
//    end;
//  end;
end;

procedure TSkinWinForm.WMNCCalcSizeAfter(var Message: TWMNCCalcSize);
var
  aRect:TRect;
  bRect:TRect;
  OldClientRect:TRect;
  NewClientRect:TRect;
  PNewWindowRect:PRect;
  NCCalcSizeParams: PNCCalcSizeParams;
var
  DesignTimeBorderFrameWidth:Integer;
  DesignTimeBorderFrameHeight:Integer;
  DesignTimeMenuFrameHeight:Integer;
  DesignTimeCaptionFrameHeight:Integer;
begin
    if (csDesigning in Self.ComponentState) then Exit;


    if IsIconic(Self.GetFormHandle) then Exit;
    if GetSkinFormType=nil then Exit;

    NCCalcSizeParams:=Message.CalcSize_Params;

    if Message.CalcValidRects then
    begin

        //��һ�����ΰ������ƶ�����߸ı��С��������꣨Ҳ����B�����꣩�����ǽ�������ꡣ
        //�ڶ������ΰ������ƶ���ı��Сǰ�����꣨Ҳ����A���꣩��
        //���������ΰ����˿ͻ������ƶ�ǰ�����꣨Ҳ����A�����еĿͻ������꣩��
        aRect:=NCCalcSizeParams.rgrc[1];
        bRect:=NCCalcSizeParams.rgrc[0];

        NewClientRect.Left:=bRect.Left+GetSkinFormType.GetCustomBorderLeftWidth;
//        NewClientRect.Top:=bRect.Top+GetSkinFormType.GetCustomCaptionBarHeight;
        //����ϵͳȥ��ϵͳ�Դ��ı������ȶ���
        NewClientRect.Top:=bRect.Top+GetSkinFormType.GetCustomCaptionBarNCHeight;
        NewClientRect.Right:=bRect.Right-GetSkinFormType.GetCustomBorderRightWidth;
        NewClientRect.Bottom:=bRect.Bottom-GetSkinFormType.GetCustomBorderBottomHeight;

        //���������Ϣ����֮ǰ��Ҳ����WM_NCCALCSIZE������ɺ󣩣�
        //��һ������Ӧ�������¿ͻ��������꣨Ҳ����B�����еĿͻ������꣩��
        //�ڶ������ΰ����˿��õ�Ŀ����Σ�B���꣩��
        //���������������Դ���Σ�A���꣩��
        //�������������Ҳ�ᱻ�õ���

        NCCalcSizeParams.rgrc[0]:=NewClientRect;

        //���ܼ�,��Ȼ�϶���ʱ��ͻ�������
//        NCCalcSizeParams.rgrc[1]:=bRect;
//        NCCalcSizeParams.rgrc[2]:=aRect;



    end
    else
    begin


          if (csDesigning in Self.ComponentState) then
          begin
              //���ģʽ(������IDE��Form��)
              DesignTimeMenuFrameHeight:=0;
              if
                (Self.GetParent <> nil)
                and (Self.FForm.Menu <> nil)
                and (Self.FForm.Menu.Items <> nil)
                and (Self.FForm.Menu.Items.Count > 0) then
              begin
                DesignTimeMenuFrameHeight:=GetSystemMetrics(SM_CYMENU);
              end;

              DesignTimeBorderFrameWidth:=GetSystemMetrics(SM_CXFRAME);
              DesignTimeBorderFrameHeight:=GetSystemMetrics(SM_CYFRAME);
              DesignTimeCaptionFrameHeight:=GetSystemMetrics(SM_CYCAPTION);
          end
          else
          begin
              DesignTimeMenuFrameHeight:=0;
              DesignTimeBorderFrameWidth:=0;
              DesignTimeBorderFrameHeight:=0;
              DesignTimeCaptionFrameHeight:=0;

          end;


          Dec(NCCalcSizeParams.rgrc[0].Top,DesignTimeCaptionFrameHeight+DesignTimeBorderFrameHeight+DesignTimeMenuFrameHeight-GetSkinFormType.GetCustomCaptionBarNCHeight);
          Dec(NCCalcSizeParams.rgrc[0].Left,DesignTimeBorderFrameWidth-GetSkinFormType.GetCustomBorderLeftWidth);
          Inc(NCCalcSizeParams.rgrc[0].Right,DesignTimeBorderFrameWidth-GetSkinFormType.GetCustomBorderRightWidth);
          Inc(NCCalcSizeParams.rgrc[0].Bottom,DesignTimeBorderFrameHeight-GetSkinFormType.GetCustomBorderBottomHeight);




    end;

end;

procedure TSkinWinForm.PaintSubControlsInFormPaint(DC: HDC);
var
  I,
  Count,
  SaveIndex: Integer;
  AControl:TControl;
//  FrameBrush: HBRUSH;
begin
//  if DockSite and UseDockManager and (DockManager <> nil) then
//    DockManager.PaintSite(DC);
//  if FControls <> nil then
//  begin
    I := 0;
    Count := Self.Form.ControlCount;
    while I < Count do
    begin
      AControl:=TControl(Self.FForm.Controls[I]);
        if Not (AControl is TWinControl)
           and (AControl.Visible and (not (csDesigning in AControl.ComponentState){ or not (csDesignerHide in AControl.ControlState)})
              or ((csDesigning in AControl.ComponentState){ and not (csDesignerHide in AControl.ControlState)}) and not (csNoDesignVisible in AControl.ControlStyle))
           and RectVisible(DC, Types.Rect(AControl.Left, AControl.Top, AControl.Left + AControl.Width,AControl.Top + AControl.Height)) then
        begin
//          if csPaintCopy in Self.ControlState then
//            Include(FControlState, csPaintCopy);

          SaveIndex := SaveDC(DC);
          try
            MoveWindowOrg(DC, AControl.Left, AControl.Top);
            IntersectClipRect(DC, 0, 0, AControl.Width, AControl.Height);
            AControl.Perform(WM_PAINT, DC, 0);
          finally
            RestoreDC(DC, SaveIndex);
          end;
//          Exclude(FControlState, csPaintCopy);
        end;
      Inc(I);
    end;
//  end;
//  if FWinControls <> nil then
//    for I := 0 to FWinControls.Count - 1 do
//      with TWinControl(FWinControls[I]) do
//        if FCtl3D and (csFramed in ControlStyle) and
//          (((not (csDesigning in ComponentState)) and Visible) or
//          ((csDesigning in ComponentState) and
//          not (csNoDesignVisible in ControlStyle) and not (csDesignerHide in ControlState))) then
//        begin
//          FrameBrush := CreateSolidBrush(ColorToRGB(clBtnShadow));
//          FrameRect(DC, Types.Rect(Left - 1, Top - 1,
//            Left + Width, Top + Height), FrameBrush);
//          DeleteObject(FrameBrush);
//          FrameBrush := CreateSolidBrush(ColorToRGB(clBtnHighlight));
//          FrameRect(DC, Types.Rect(Left, Top, Left + Width + 1,
//            Top + Height + 1), FrameBrush);
//          DeleteObject(FrameBrush);
//        end;

end;

//procedure TSkinWinForm.SetFormRegion;
//var
//  WindowRgn:HRGN;
//begin
//  if (Self.GetCurrentUseMaterial<>nil) then
//  begin
//    //������϶���ʱ���к�Ӱ
//    if TSkinFormMaterial(Self.GetCurrentUseMaterial).IsRoundForm then
//    begin
//      WindowRgn:=CreateRoundRectRgn(0, 0,
//                                    Self.GetWidth+1,
//                                    Self.GetHeight+1,
//                                    TSkinFormMaterial(Self.GetCurrentUseMaterial).FormRoundWidth,
//                                    TSkinFormMaterial(Self.GetCurrentUseMaterial).FormRoundHeight);
//      try
//        SetWindowRgn(Self.GetFormHandle,WindowRgn,False);
//      finally
//        DeleteObject(WindowRgn);
//      end;
//    end
//    else
//    begin
////      WindowRgn:=CreateRectRgn(0, 0,
////                                Self.GetWidth,
////                                Self.GetHeight);
////      try
////        SetWindowRgn(Self.GetFormHandle,WindowRgn,False);
////      finally
////        DeleteObject(WindowRgn);
////      end;
//    end;
//  end;
//end;

procedure SetFormShadow(AFormHandle:THandle;AEnabled:Boolean;var AIsSetedFormShadow:Boolean);
var
  attr: DWORD;
  m:MARGINS;
  hr:HResult;
  dwmValue:Integer;
  pfEnabled: BOOL;
//  ahRgn:HRGN;
//  blurbehind:DWM_BLURBEHIND;
begin
//  //HRGN
//  ahRgn := CreateRectRgn(10,10,500,500);
//  FillChar(blurbehind,SizeOf(blurbehind),0);
//  // DWM_BLURBEHIND blurbehind = {0};
//   blurbehind.dwFlags := DWM_BB_ENABLE or DWM_BB_BLURREGION or DWM_BB_TRANSITIONONMAXIMIZED;
//   blurbehind.fEnable := true;
//   blurbehind.hRgnBlur := ahRgn;
//   blurbehind.fTransitionOnMaximized := TRUE;
//   DwmEnableBlurBehindWindow(Self.FForm.Handle, &blurbehind);
//   DeleteObject(ahRgn);

// MARGINS m = {-1};

//  DwmExtendFrameIntoClientArea(Self.FForm.Handle, &m);

//    """ �����������Ӱ
//    Parameter
//    ----------
//    hWnd: int or `sip.voidptr`
//        ���ھ��
//    """
//    hWnd = int(hWnd)
//    self.DwmSetWindowAttribute(
//        hWnd,
//        DWMWINDOWATTRIBUTE.DWMWA_NCRENDERING_POLICY.value,
//        byref(c_int(DWMNCRENDERINGPOLICY.DWMNCRP_ENABLED.value)),
//        4,
//    )
//    margins = MARGINS(-1, -1, -1, -1)
//    self.DwmExtendFrameIntoClientArea(hWnd, byref(margins))


//  attr := 2;
//  DwmSetWindowAttribute(Self.FForm.Handle,
//                        2,
//                        @attr,
//                        4);


//  if not AIsEnabledDwmShadow then Exit; //DWMWA_ALLOW_NCPAINT


  //�ж�Vistaϵͳ
  if (Win32MajorVersion<6) then
  begin
    Exit;
  end;

  //���Aero�Ƿ�Ϊ��
  DwmIsCompositionEnabled(pfEnabled);
  if not pfEnabled then
  begin
    Exit;
  end;




  if (not AIsSetedFormShadow) then
  begin
    uBaseLog.HandleException(nil,'SetFormShadow DWMWA_NCRENDERING_POLICY ������');

    //Ҫ�ص�DWMWA_ALLOW_NCPAINT,��Ȼ����ǿ�ƻ�������
    attr := DWMNCRP_DISABLED;
    DwmSetWindowAttribute(AFormHandle,
                          DWMWA_ALLOW_NCPAINT,
                          @attr,
                          Sizeof(attr));

//    attr:=0;
//    DwmGetWindowAttribute(AFormHandle,
//                          DWMWA_NCRENDERING_ENABLED,
//                          @attr,
//                          Sizeof(attr));

    //Ҫ�ص�DWMWA_NCRENDERING_POLICY,������,������,��������Ч��
    attr := DWMNCRP_DISABLED;
    DwmSetWindowAttribute(AFormHandle,
                          DWMWA_NCRENDERING_POLICY,
                          @attr,
                          Sizeof(attr));

    attr := DWMNCRP_ENABLED;
    DwmSetWindowAttribute(AFormHandle,
                          DWMWA_NCRENDERING_POLICY,
                          @attr,
                          Sizeof(attr));

    dwmValue:=0;
    with m do
    begin
      cxLeftWidth := dwmValue;
      cxRightWidth := dwmValue;
      cyTopHeight := dwmValue;
      cyBottomHeight := dwmValue;
    end;
    hr:=DwmExtendFrameIntoClientArea(AFormHandle, m);
    if hr=0 then
    begin

    end;
  end
  else
  begin
//    uBaseLog.HandleException(nil,'SetFormShadow DWMWA_NCRENDERING_POLICY ������');
  end;

  AIsSetedFormShadow:=True;
end;

procedure TSkinWinForm.UpdateWindowClient(AWindowClientCanvas: TDrawCanvas;
                                        const AUpdateClientRect: PRectF;
                                        const AUpdateWindowRect: PRectF;
                                        EnableBuffer: Boolean);
var
  ADrawCanvas:TDrawCanvas;
  AIsTempCanvas:Boolean;
  ATopMagin:Double;
  ALeftMagin:Double;
begin
    if IsIconic(Self.GetFormHandle) then Exit;
    if GetSkinFormType=nil then Exit;

//  uBaseLog.OutputDebugString('TSkinWinForm.UpdateWindowClient');


    AIsTempCanvas:=AWindowClientCanvas=nil;
    if AIsTempCanvas then
    begin
      AWindowClientCanvas:=Self.GetFormClientCanvas;
      //ֻ��������
      if AUpdateClientRect<>nil then
      begin
        IntersectClipRect(AWindowClientCanvas.Handle,
                    Ceil(AUpdateClientRect.Left),
                    Ceil(AUpdateClientRect.Top),
                    Ceil(AUpdateClientRect.Right),
                    Ceil(AUpdateClientRect.Bottom)
                    );
      end;
    end;




    if EnableBuffer then
    begin
      if (Self.GetBufferBitmap.Width<>Self.GetWidth)
        or (Self.GetBufferBitmap.Height<>Self.GetHeight) then
      begin
        Self.GetBufferBitmap.CreateBufferBitmap(Self.GetWidth,Self.GetHeight);
      end;
      ADrawCanvas:=Self.GetBufferBitmap.DrawCanvas;
    end
    else
    begin
      ADrawCanvas:=AWindowClientCanvas;
    end;

    if ADrawCanvas<>nil then
    begin
        //���Ʒǿͻ���,��Ϊ����û�зǿͻ�����,������,ϵͳ��ťȫ�����ڿͻ���ͳһ������
        Self.GetSkinFormType.PaintNotClient(ADrawCanvas);
        //���ƿͻ���
        Self.GetSkinFormType.PaintClient(ADrawCanvas);

        //����DirectUI�ؼ�
        Self.DrawDirectUIControls(ADrawCanvas,True);


        if EnableBuffer then
        begin
          //ֻ��������
          if AUpdateClientRect<>nil then
          begin
            //���Ƶ�����
            ATopMagin:=0;
            if (AUpdateClientRect.Top<0) then
            begin
              ATopMagin:=-AUpdateClientRect.Top;
            end;
            ALeftMagin:=0;
            if (AUpdateClientRect.Left<0) then
            begin
              ALeftMagin:=-AUpdateClientRect.Left;
            end;
            Bitblt(AWindowClientCanvas.Handle,
                  Ceil(AUpdateClientRect.Left+ALeftMagin),
                  Ceil(AUpdateClientRect.Top+ATopMagin),
                  Ceil(AUpdateClientRect.Right),
                  Ceil(AUpdateClientRect.Bottom),
                  Self.GetBufferBitmap.Handle,
                  Ceil(AUpdateWindowRect.Left+ALeftMagin),
                  Ceil(AUpdateWindowRect.Top+ATopMagin),
                  SRCCOPY);
          end
          else
          begin
            //���Ƶ�������
            Bitblt(AWindowClientCanvas.Handle,0,0,
                   Self.GetBufferBitmap.Width-Self.GetSkinFormType.GetCustomBorderLeftWidth-Self.GetSkinFormType.GetCustomBorderRightWidth,
                   Self.GetBufferBitmap.Height-Self.GetSkinFormType.GetCustomCaptionBarNCHeight-Self.GetSkinFormType.GetCustomBorderBottomHeight,
                   Self.GetBufferBitmap.Handle,
                   Self.GetSkinFormType.GetCustomBorderLeftWidth,Self.GetSkinFormType.GetCustomCaptionBarNCHeight,
                   SRCCOPY);
          end;
      end;
    end;

    if AIsTempCanvas then
    begin
      Self.ReleaseFormCanvas(AWindowClientCanvas);
    end;




//    //���ô�������
//    SetFormRegion;

end;

procedure TSkinWinForm.UpdateWindowNotClient(const AUpdateWindowRect:PRectF;
                                               EnableBuffer:Boolean);
var
  ADrawCanvas:TDrawCanvas;
  AWindowNotClientCanvas:TDrawCanvas;
begin
  Exit;//������,�߿���Щ�ÿͻ�������ɫ��ʵ��

  if IsIconic(Self.GetFormHandle) then Exit;
  if GetSkinFormType=nil then Exit;

//  uBaseLog.OutputDebugString('TSkinWinForm.UpdateWindowNotClient');



  if     (Self.GetBorderStyle<>bsNone)
    and
        (    //���ڷǿͻ���
             (GetSkinFormType.GetCustomBorderLeftWidth<>0)
          or (GetSkinFormType.GetCustomCaptionBarNCHeight<>0)
          or (GetSkinFormType.GetCustomBorderBottomHeight<>0)
          or (GetSkinFormType.GetCustomBorderRightWidth<>0)
          ) then
  begin

    AWindowNotClientCanvas:=Self.GetFormWindowCanvas;
    //ȥ���ͻ���
    ExcludeClipRect(AWindowNotClientCanvas.Handle,
                      GetSkinFormType.GetCustomBorderLeftWidth,
                      GetSkinFormType.GetCustomCaptionBarNCHeight,
                      Self.GetWidth-GetSkinFormType.GetCustomBorderRightWidth,
                      Self.GetHeight-GetSkinFormType.GetCustomBorderBottomHeight);
    try
      if EnableBuffer then
      begin
        if (Self.GetBufferBitmap.Width<>Self.GetWidth)
          or (Self.GetBufferBitmap.Height<>Self.GetHeight) then
        begin
          Self.GetBufferBitmap.CreateBufferBitmap(Self.GetWidth,Self.GetHeight);
        end;
        ADrawCanvas:=Self.GetBufferBitmap.DrawCanvas;
      end
      else
      begin
        ADrawCanvas:=AWindowNotClientCanvas;
      end;


      if (ADrawCanvas<>nil) then
      begin

        //���Ʒǿͻ���
        Self.GetSkinFormType.PaintNotClient(ADrawCanvas);

        //����DirectUI�ؼ�
        Self.DrawDirectUIControls(ADrawCanvas,False);

        if EnableBuffer then
        begin
//          //ֻ��������
//          if AUpdateWindowRect<>nil then
//          begin
//            //���Ƶ�����
//            Bitblt(AWindowNotClientCanvas.Handle,
//                  Ceil(AUpdateWindowRect.Left),
//                  Ceil(AUpdateWindowRect.Top),
//                  Ceil(AUpdateWindowRect.Right),
//                  Ceil(AUpdateWindowRect.Bottom),
//                  Self.GetBufferBitmap.Handle,
//                  Ceil(AUpdateWindowRect.Left),
//                  Ceil(AUpdateWindowRect.Top),
//                  SRCCOPY);
//          end
//          else
//          begin



            //���Ƶ�����
            Bitblt(AWindowNotClientCanvas.Handle,
                  0,0,
                  Self.GetBufferBitmap.Width,
                  Self.GetBufferBitmap.Height,
                  Self.GetBufferBitmap.Handle,
                  0,0,
                  SRCCOPY);
            //�ֿ����



//          end;
        end;
      end;

    finally
      Self.ReleaseFormCanvas(AWindowNotClientCanvas);
    end;
  end;
end;

procedure TSkinWinForm.InvalidateSubControls;
//var
//  I: Integer;
//  AControl:TControl;
//  ASkinComponentIntf:ISkinComponent;
begin
//  if Not (csDesigning in Self.ComponentState) then
//  begin
//    //����Ƥ���ؼ�
//    for I := 0 to Self.FForm.ControlCount - 1 do
//    begin
//      AControl:=Self.FForm.Controls(I);
//      if (AControl is TWinControl) and (AControl.Visible) then
//      begin
//        if AControl.GetInterface(IID_ISkinComponent,ASkinComponentIntf) then
//        begin
//          SendMessage(TWinControl(AControl).Handle,CM_InvalidateInParentWMSize,0,0);
//        end;
//      end;
//    end;
//  end
//  else
//  begin
//    for I := 0 to Self.GetControlCount - 1 do
//    begin
//      AControl:=Self.GetControl(I);
//      if AControl.Visible then
//      begin
//        AControl.Invalidate;
//      end;
//    end;
//  end;
end;

procedure TSkinWinForm.WMSetTextAfter(var Message:TMessage);
begin
  if Self.GetSkinControlType<>nil then
  begin
    TSkinControlType(Self.GetSkinControlType).TextChanged;
  end;

  if Self.FFormSysCaption<>nil then
  begin
    FFormSysCaption.Caption:=GetCaption;
  end;
end;

procedure TSkinWinForm.CMMouseEnter(var Message: TMessage);
begin
  Inherited;
//  if Not (csDesigning in Self.ComponentState) then
//  begin
////    MouseEnter;
//    IsMouseOver:=True;
//  end;
end;

procedure TSkinWinForm.CMMouseLeave(var Message: TMessage);
begin
  Inherited;
//  if Not (csDesigning in Self.ComponentState) then
//  begin
////    MouseLeave;
//    IsMouseOver:=False;
//  end;
end;


function TSkinWinForm.GetControlWindowRect(AControl:TControl;AControlIntf:IDirectUIControl): TRectF;
begin
  Result:=AControlIntf.AutoSizeBoundsRect;
//  if Self.FSystemControls.IndexOf(AControl)<>-1 then
//  begin
//    //��ϵͳ�ؼ�,ֱ��ȡ���ھ���
//  end
//  else
//  begin
//    //����ϵͳ�ؼ�,��ô����
//    OffsetRect(Result,GetSkinFormType.GetCustomBorderLeftWidth,GetSkinFormType.GetCustomCaptionBarNCHeight);
//  end;
end;

procedure TSkinWinForm.IsControlInWhere(AControl:TControl;AControlIntf: IDirectUIControl;var InClient:Boolean;var InNotClient:Boolean);
var
  AIntersectRect:TRectF;
  AControlClientRect:TRectF;
  AControlWindowRect:TRectF;
begin
  InClient:=False;
  InNotClient:=False;
  if GetSkinFormType=nil then Exit;

  AControlClientRect:=AControlIntf.AutoSizeBoundsRect;
  AControlWindowRect:=AControlClientRect;//GetControlWindowRect(AControl,AControlIntf);



  //����漰�ǿͻ���,��ô���·ǿͻ���
  //����漰�ͻ���,��ô���¿ͻ���
  if IntersectRectF(AIntersectRect,
                  RectF(0,
                      0,
                      Self.GetWidth,
                      Self.GetHeight),
                      AControlWindowRect) then
  begin
    //�ڴ�����
    //�ͻ���
    if IntersectRectF(AIntersectRect,
              RectF(GetSkinFormType.GetCustomBorderLeftWidth,
                  GetSkinFormType.GetCustomCaptionBarNCHeight,
                  Self.GetWidth-GetSkinFormType.GetCustomBorderRightWidth,
                  Self.GetHeight-GetSkinFormType.GetCustomBorderBottomHeight),
                  AControlWindowRect) then
    begin
      //����(�ͻ���)
      InClient:=True;
    end;


    //��ǿͻ����н���
    if (
            (AControlWindowRect.Left>=0) and (AControlWindowRect.Left<=GetSkinFormType.GetCustomBorderLeftWidth)
         or (AControlWindowRect.Left>=Self.GetWidth-GetSkinFormType.GetCustomBorderRightWidth) and (AControlWindowRect.Left<=Self.GetWidth)
         or (AControlWindowRect.Right>=0) and (AControlWindowRect.Right<=GetSkinFormType.GetCustomBorderLeftWidth)
         or (AControlWindowRect.Right>=Self.GetWidth-GetSkinFormType.GetCustomBorderRightWidth) and (AControlWindowRect.Right<=Self.GetWidth)

         or (AControlWindowRect.Top>=0) and (AControlWindowRect.Top<=GetSkinFormType.GetCustomCaptionBarNCHeight)
         or (AControlWindowRect.Top>=Self.GetHeight-GetSkinFormType.GetCustomBorderBottomHeight) and (AControlWindowRect.Top<=Self.GetHeight)
         or (AControlWindowRect.Bottom>=0) and (AControlWindowRect.Bottom<=GetSkinFormType.GetCustomCaptionBarNCHeight)
         or (AControlWindowRect.Bottom>=Self.GetHeight-GetSkinFormType.GetCustomBorderBottomHeight) and (AControlWindowRect.Bottom<=Self.GetHeight)

        ) then
    begin
      InNotClient:=True;
    end;
  end;
end;




function TSkinWinForm.GetDirectUIControlByHitTestValue(AHitTestValue:Integer;var AHitedControlIntf:IDirectUIControl):Boolean;
var
  I: Integer;
  AControlCount:Integer;
  ASubControl:TChildControl;
  ASubControlIntf:IDirectUIControl;
begin
  Result:=False;
  AControlCount:=Self.FSystemControls.Count;
  AHitedControlIntf:=nil;
  for I := 0 to AControlCount - 1 do
  begin
    ASubControl:=Self.FSystemControls[I];
    if ASubControl.GetInterface(IID_IDirectUIControl,ASubControlIntf) then
    begin
      if ASubControlIntf.GetHitTestValue=AHitTestValue then
      begin
        AHitedControlIntf:=ASubControlIntf;
        Break;
      end;
    end;
  end;
end;

function TSkinWinForm.NCHitTestDirectUIControls(Pt: TPointF): Integer;
var
  I: Integer;
  InClient,InNotClient:Boolean;
  AIntersectRect:TRectF;
  AControlCount:Integer;
  AControlWindowRect:TRectF;
  ASubControl:TControl;
  AControl:TControl;
  AControlIntf:IDirectUIControl;
begin
  Result:=HTNOWHERE;


  AControlCount:=Self.FSystemControls.Count;
  for I := 0 to AControlCount - 1 do
  begin
    ASubControl:=Self.FSystemControls[I];
    if ASubControl.GetInterface(IID_IDirectUIControl,AControlIntf) then
    begin
      AControl:=ASubControl;
      AControlWindowRect:=Self.GetControlWindowRect(AControl,AControlIntf);

      if    (
              //AControl.Visible
              //and
              AControlIntf.GetDirectUIVisible
              )
        and AControlIntf.GetNeedHitTest
//        and (RectWidthF(AControlWindowRect)>0)
//        and (RectHeightF(AControlWindowRect)>0)
        and PtInRect(AControlWindowRect,Pt)
      then
      begin



        //ֻ��ǿͻ����н�����
//        Self.IsControlInWhere(AControl,AControlIntf,InClient,InNotClient);
//        if InNotClient then
//        begin
          Result:=AControlIntf.GetHitTestValue;
          Exit;
//        end;
//
//        //����������ͻ�������ôʹ�÷ǿͻ�����HitTestValue������ڿͻ�������ôʹ��HTCLIENT;
//        if InClient then
//        begin
//          Result:=HTCLIENT;
//          Exit;
//        end;



      end;
    end;
  end;

end;

function TSkinWinForm.ProcessMouseUpDirectUIControls(AHitTestValue: Integer;Button: TMouseButton; Shift: TShiftState;X,Y:Integer):Boolean;
var
  I: Integer;
  AControlCount:Integer;
  ASubControl:TControl;
  AHitedControlIntf:IDirectUIControl;
  ASubControlIntf:IDirectUIControl;
begin
  Result:=False;

  AControlCount:=Self.FSystemControls.Count;


  GetDirectUIControlByHitTestValue(AHitTestValue,AHitedControlIntf);


  //���ԭ������갴�¿ؼ���״̬
  for I := 0 to AControlCount - 1 do
  begin
    ASubControl:=Self.FSystemControls[I];
    if ASubControl.GetInterface(IID_IDirectUIControl,ASubControlIntf) then
    begin
      if (ASubControlIntf<>AHitedControlIntf) and ASubControlIntf.IsMouseDown then
      begin
        if (ASubControlIntf.GetSkinControlType<>nil) then
        begin
          TSkinControlType(ASubControlIntf.GetSkinControlType).CustomMouseUp(Button,Shift,
                          -999,
                          -999);
        end;
      end;
    end;
  end;




  if AHitedControlIntf<>nil then
  begin
    Result:=True;
    if AHitedControlIntf.IsMouseDown then
    begin
      AHitedControlIntf.Click;
    end;
    if (AHitedControlIntf.GetSkinControlType<>nil) then
    begin
      TSkinControlType(AHitedControlIntf.GetSkinControlType).CustomMouseUp(Button,Shift,
                  X-AHitedControlIntf.Left,
                  Y-AHitedControlIntf.Top);
    end;
  end;

end;

procedure TSkinWinForm.ProcessMouseLeaveDirectUIControls;
var
  I: Integer;
  AControlCount:Integer;
  ASubControl:TControl;
  ASubControlIntf:IDirectUIControl;
begin
  AControlCount:=Self.FSystemControls.Count;
  //���ԭ������갴�¿ؼ���״̬
  for I := 0 to AControlCount - 1 do
  begin
    ASubControl:=Self.FSystemControls[I];
    if ASubControl.GetInterface(IID_IDirectUIControl,ASubControlIntf) then
    begin
      if ASubControlIntf.IsMouseOver then
      begin
        if (ASubControlIntf.GetSkinControlType<>nil) then
        begin
          TSkinControlType(ASubControlIntf.GetSkinControlType).CustomMouseLeave;
        end;
      end;
    end;
  end;
end;

procedure TSkinWinForm.ProcessMouseMoveDirectUIControls(AHitTestValue:Integer;Shift: TShiftState; X,Y: Integer);
var
  I: Integer;
  AControlCount:Integer;
  ASubControl:TControl;
  ASubControlIntf:IDirectUIControl;
  AHitedControlIntf:IDirectUIControl;
begin
  AControlCount:=Self.FSystemControls.Count;


  GetDirectUIControlByHitTestValue(AHitTestValue,AHitedControlIntf);


  //���ԭ������갴�¿ؼ���״̬
  for I := 0 to AControlCount - 1 do
  begin
    ASubControl:=Self.FSystemControls[I];
    if ASubControl.GetInterface(IID_IDirectUIControl,ASubControlIntf) then
    begin
      if (ASubControlIntf<>AHitedControlIntf) and (ASubControlIntf.IsMouseOver) then
      begin
        ASubControlIntf.IsMouseOver:=False;
        if (ASubControlIntf.GetSkinControlType<>nil) then
        begin
          TSkinControlType(ASubControlIntf.GetSkinControlType).CustomMouseLeave;
        end;
      end;
    end;
  end;



  if AHitedControlIntf<>nil then
  begin
    if Not AHitedControlIntf.IsMouseOver then
    begin
      AHitedControlIntf.IsMouseOver:=True;
      if (AHitedControlIntf.GetSkinControlType<>nil) then
      begin
        TSkinControlType(AHitedControlIntf.GetSkinControlType).CustomMouseEnter;
      end;
    end;
    if (AHitedControlIntf.GetSkinControlType<>nil) then
    begin
      TSkinControlType(AHitedControlIntf.GetSkinControlType).CustomMouseMove(Shift,
                  X-AHitedControlIntf.Left,
                  Y-AHitedControlIntf.Top);
    end;
  end;

end;

function TSkinWinForm.ProcessMouseDownDirectUIControls(AHitTestValue: Integer;Button: TMouseButton; Shift: TShiftState;X,Y:Integer):Boolean;
var
  I: Integer;
  AControlCount:Integer;
  ASubControl:TControl;
  ASubControlIntf:IDirectUIControl;
  AHitedControlIntf:IDirectUIControl;
begin
  Result:=False;

  AControlCount:=Self.FSystemControls.Count;


  GetDirectUIControlByHitTestValue(AHitTestValue,AHitedControlIntf);


  //���ԭ������갴�¿ؼ���״̬
  for I := 0 to AControlCount - 1 do
  begin
    ASubControl:=Self.FSystemControls[I];
    if ASubControl.GetInterface(IID_IDirectUIControl,ASubControlIntf) then
    begin
      if (ASubControlIntf<>AHitedControlIntf) and ASubControlIntf.IsMouseDown then
      begin
        if (ASubControlIntf.GetSkinControlType<>nil) then
        begin
          TSkinControlType(ASubControlIntf.GetSkinControlType).CustomMouseUp(Button,Shift,
                      -999,
                      -999);
        end;
      end;
    end;
  end;


  if AHitedControlIntf<>nil then
  begin
    Result:=True;
    if (AHitedControlIntf.GetSkinControlType<>nil) then
    begin
      TSkinControlType(AHitedControlIntf.GetSkinControlType).CustomMouseDown(Button,Shift,
                  X-AHitedControlIntf.Left,
                  Y-AHitedControlIntf.Top);
    end;
  end;

end;

procedure TSkinWinForm.DrawDirectUIControls(ACanvas: TDrawCanvas;const InClientRect:Boolean);
var
  I: Integer;
  ASubControl:TControl;
  ASubControlIntf:IDirectUIControl;
  AControlCount:Integer;
  InClient,InNotClient: Boolean;
  AControlWindowRect:TRectF;
begin
  AControlCount:=Self.FSystemControls.Count;
  for I := 0 to AControlCount - 1 do
  begin
    ASubControl:=Self.FSystemControls[I];
    if //ASubControl.Visible
      //and
      ASubControl.GetInterface(IID_IDirectUIControl,ASubControlIntf) then
    begin

      AControlWindowRect:=Self.GetControlWindowRect(ASubControl,ASubControlIntf);


      if    (//ASubControl.Visible
//              and
              ASubControlIntf.GetDirectUIVisible
              )
        and (RectWidthF(AControlWindowRect)>0)
        and (RectHeightF(AControlWindowRect)>0)
      then
      begin
        Self.IsControlInWhere(ASubControl,ASubControlIntf,InClient,InNotClient);

        //�ͻ���
        if InClient and InClientRect then
        begin



//          //���ƿؼ�����
//          if (ASubControlIntf.GetCurrentUseMaterial<>nil) then
//          begin
//            if TSkinControlMaterial(ASubControlIntf.GetCurrentUseMaterial).IsTransparent then
//            begin
//        //              DrawParent(Self,ACanvas.Handle,
//        //                                  0,0,Self.Width,Self.Height,
//        //                                  0,0);
//            end
//            else
//            begin
//              ACanvas.DrawRect(TSkinControlMaterial(ASubControlIntf.GetCurrentUseMaterial).BackColor,
//                                AControlWindowRect);
//            end;
//          end;



          //����(�ͻ���)
          if ASubControlIntf.GetSkinControlType<>nil then
          begin
//            ACanvas.SetClip(AControlWindowRect);


            FPaintData:=GlobalNullPaintData;
            FPaintData.IsDrawInteractiveState:=True;
            FPaintData.IsInDrawDirectUI:=False;
            TSkinControlType(ASubControlIntf.GetSkinControlType).Paint(ACanvas,ASubControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial,AControlWindowRect,FPaintData);
//            ACanvas.ResetClip;
          end;



        end;



        //��ǿͻ����н���
        if InNotClient and Not InClientRect then
        begin



//          //���ƿؼ�����
//          if (ASubControlIntf.GetCurrentUseMaterial<>nil) then
//          begin
//            if TSkinControlMaterial(ASubControlIntf.GetCurrentUseMaterial).IsTransparent then
//            begin
//        //              DrawParent(Self,ACanvas.Handle,
//        //                                  0,0,Self.Width,Self.Height,
//        //                                  0,0);
//            end
//            else
//            begin
//              ACanvas.DrawRect(TSkinControlMaterial(ASubControlIntf.GetCurrentUseMaterial).BackColor,
//                                AControlWindowRect);
//            end;
//          end;


          //����(�ǿͻ���)
          if ASubControlIntf.GetSkinControlType<>nil then
          begin
//            ACanvas.SetClip(AControlWindowRect);
            FPaintData:=GlobalNullPaintData;
            FPaintData.IsDrawInteractiveState:=True;
            FPaintData.IsInDrawDirectUI:=False;
            TSkinControlType(ASubControlIntf.GetSkinControlType).Paint(ACanvas,ASubControlIntf.GetSkinControlType.GetPaintCurrentUseMaterial,AControlWindowRect,FPaintData);
//            ACanvas.ResetClip;
          end;


        end;




      end;
    end;
  end;
end;

procedure TSkinWinForm.UpdateChild(AControl: TControl;AControlIntf:IDirectUIControl);
var
  InClient,InNotClient: Boolean;
  AControlWindowRect:TRectF;
begin
  if Self.FForm=nil then Exit;
  

  AControlWindowRect:=Self.GetControlWindowRect(AControl,AControlIntf);

  //����漰�ǿͻ���,��ô���·ǿͻ���
  //����漰�ͻ���,��ô���¿ͻ���
  IsControlInWhere(AControl,AControlIntf,InClient,InNotClient);

  //�ڴ�����
  if InClient then
  begin
    //����(�ͻ���)
    GlobalClientPRect^:=AControlIntf.AutoSizeBoundsRect;
    GlobalWindowPRect^:=AControlWindowRect;
//    Self.UpdateWindowClient(nil,GlobalClientPRect,GlobalWindowPRect,False);
    Self.UpdateWindowClient(nil,GlobalClientPRect,GlobalWindowPRect);
  end;

  //��ǿͻ����н���
  if InNotClient then
  begin
    //����(�ǿͻ���)
    GlobalWindowPRect^:=AControlWindowRect;
    Self.UpdateWindowNotClient(GlobalWindowPRect);
  end;
end;









function TSkinWinForm.GetHeight: Integer;
begin
  Result:=Self.FForm.Height;
end;

function TSkinWinForm.GetHeightInt: Integer;
begin
  Result:=Self.FForm.Height;
end;

function TSkinWinForm.GetBorderStyle: TBorderStyle;
begin
  Result:=Self.FForm.BorderStyle;
end;

function TSkinWinForm.GetCaption: String;
begin
  Result:=Self.FForm.Caption;
end;

procedure TSkinWinForm.OnCloseSysBtnClick(Sender: TObject);
begin
  Self.FForm.Close;
end;

//procedure TSkinWinForm.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
//begin
//
//end;

procedure TSkinWinForm.SetCaption(const Value:String);
begin
  Self.FForm.Caption:=Value;

end;

procedure TSkinWinForm.OnMaxRestoreSysBtnClick(Sender: TObject);
begin
  if Self.FForm.WindowState=wsNormal then
  begin
    Self.FForm.WindowState:=wsMaximized;
  end
  else
  begin
    Self.FForm.WindowState:=wsNormal;
  end;


  if FMaxRestoreSysBtn<>nil then
  begin
    FMaxRestoreSysBtn.IsMouseOver:=False;
//    FMaxRestoreSysBtn.SkinControlType.CurrentEffectStates:=FMaxRestoreSysBtn.SkinControlType.CurrentEffectStates-[dpstMouseDown,dpstMouseOver];
  end;

//  SetFormShadow(Self.FForm.Handle,True,Self.FIsSetedFormShadow);
end;

procedure TSkinWinForm.OnMinSysBtnClick(Sender: TObject);
begin
  Self.FForm.WindowState:=wsMinimized;
  //showwindow(Self.Form.Handle,sw_hide);
  //FForm.Hide;


  if FMinSysBtn<>nil then
  begin
    FMinSysBtn.IsMouseOver:=False;
//    FMinSysBtn.SkinControlType.CurrentEffectStates:=FMinSysBtn.SkinControlType.CurrentEffectStates-[dpstMouseDown,dpstMouseOver];
  end;



end;


procedure TSkinWinForm.OnSyncSystemControlsTimer(Sender: TObject);
begin
  //���尴ť
  Self.SyncSystemControls;
end;













procedure TSkinWinForm.SetBounds(ALeft, ATop, AWidth, AHeight: TControlSize);
begin
  Self.FForm.SetBounds(ControlSize(ALeft), ControlSize(ATop), ControlSize(AWidth), ControlSize(AHeight));
end;

//procedure TSkinWinForm.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
//begin
//
//end;

procedure TSkinWinForm.SetBounds(ABoundsRect:TRectF);
begin
  Self.FForm.SetBounds(ControlSize(ABoundsRect.Left), ControlSize(ABoundsRect.Top), ControlSize(ABoundsRect.Width), ControlSize(ABoundsRect.Height));
end;

procedure TSkinWinForm.SetHeight(const Value: Integer);
begin
  Self.FForm.Height:=Value;
end;

procedure TSkinWinForm.SetHeightInt(const Value: Integer);
begin
  Self.FForm.Height:=Value;
end;

procedure TSkinWinForm.SetVisible(const Value: Boolean);
begin
  Self.FForm.Visible:=Value;
end;

function TSkinWinForm.GetParentIsScrollBox:Boolean;
begin
  Result:=False;
end;

function TSkinWinForm.GetParentScrollBox:TControl;
begin
  Result:=nil;
end;

procedure TSkinWinForm.Invalidate;
begin
  if Not (csDesigning In Self.ComponentState)
    and Not (csLoading in Self.ComponentState)
    and (FForm<>nil) then
  begin
    Self.FForm.Invalidate;
  end;
end;

function TSkinWinForm.GetLeft: Integer;
begin
  Result:=Self.FForm.Left;
end;

function TSkinWinForm.GetParent: TParentControl;
begin
  Result:=Self.FForm.Parent;
end;

procedure TSkinWinForm.SetWidth(const Value: Integer);
begin
  Self.FForm.Width:=Value;
end;

procedure TSkinWinForm.SetWidthInt(const Value: Integer);
begin
  Self.FForm.Width:=Value;
end;

procedure TSkinWinForm.SetWindowState(const Value: TWindowState);
begin
  Self.FForm.WindowState:=Value;
end;

function TSkinWinForm.GetEnabled: Boolean;
begin
  Result:=True;
end;

function TSkinWinForm.GetFocused: Boolean;
begin
  Result:=Self.FForm.Active;
end;

function TSkinWinForm.GetTop: Integer;
begin
  Result:=Self.FForm.Top;
end;

function TSkinWinForm.GetVisible: Boolean;
begin
  Result:=Self.FForm.Visible;
end;

function TSkinWinForm.GetWidth: Integer;
begin
  Result:=Self.FForm.Width;
end;

function TSkinWinForm.GetWidthInt: Integer;
begin
  Result:=Self.FForm.Width;
end;

function TSkinWinForm.GetWindowState: TWindowState;
begin
  Result:=Self.FForm.WindowState;
end;












constructor TSkinWinForm.Create(AOwner: TComponent);
begin
  //����ؼ��б�
  FSystemControls:=TSkinControlList.Create(ooReference);

  inherited Create(AOwner);

  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Create_Code.inc}

  //�����ؼ�����
  FProperties:=Self.GetPropertiesClassType.Create(TControl(Self));


  //���ô���
  if (Owner<>nil) and (Owner is TForm) then
  begin
    SetForm(TForm(Owner));
  end;



  //����Ƿ񴴽�
  GetCloseSysBtn;
  GetFormSysCaption;
  GetFormSysIcon;
  GetMaxRestoreSysBtn;
  GetMinSysBtn;




  FSyncSystemControlsTimer:=TTimer.Create(nil);
  FSyncSystemControlsTimer.OnTimer:=Self.OnSyncSystemControlsTimer;



  uBaseLog.OutputDebugString('TSkinWinForm.Create');
end;

procedure TSkinWinForm.Loaded;
begin
  inherited;

  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Loaded_Code.inc}

  //����Ƿ񴴽�
  GetCloseSysBtn;
  GetFormSysCaption;
  GetFormSysIcon;
  GetMaxRestoreSysBtn;
  GetMinSysBtn;

end;


destructor TSkinWinForm.Destroy;
begin
  uBaseLog.OutputDebugString('TSkinWinForm.Destroy Begin');

  FreeAndNil(FBufferBitmap);

  FreeAndNil(FSyncSystemControlsTimer);

  SetForm(nil);

  {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_Destroy_Code.inc}


  FreeAndNil(FProperties);

//  FSystemControls.Clear(False);
  FSystemControls.Clear(True);


  FreeAndNil(FSystemControls);
  inherited;

  uBaseLog.OutputDebugString('TSkinWinForm.Destroy End');

end;


function TSkinWinForm.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TFormProperties;
end;

function TSkinWinForm.GetMinSysBtn: TSkinChildButton;
begin
  if FMinSysBtn=nil then
  begin
    //��С����ť
    FMinSysBtn:=CreateChildButton(Self);
    if FMinSysBtn<>nil then
    begin
      FMinSysBtn.Name:='MinSysBtn';
      FMinSysBtn.Caption:='';
      FMinSysBtn.OnClick:=OnMinSysBtnClick;
      FMinSysBtn.SetBounds(0,0,16,16);


      FMinSysBtn.HitTest:=True;
      FMinSysBtn.Visible:=False;
//      FMinSysBtn.Visible:=True;
//      FMinSysBtn.Parent:=TWinControl(Owner);
      FMinSysBtn.HitTestValue:=1024+HTMINBUTTON;
      (FMinSysBtn as IDirectUIControl).SetDirectUIParentIntf(Self);
      FMinSysBtn.DirectUIVisible:=True;


      FMinSysBtn.SetSubComponent(True);
      AddFreeNotification(FMinSysBtn,Self);
      Self.FSystemControls.Add(FMinSysBtn);
    end;
  end;

  if FMinSysBtn.Width=0 then
  begin
    FMinSysBtn.Width:=FMinSysBtn.Height;
  end;
  Result:=FMinSysBtn;
end;

function TSkinWinForm.GetCloseSysBtn: TSkinChildButton;
begin
  if FCloseSysBtn=nil then
  begin
    //�رհ�ť
    FCloseSysBtn:=CreateChildButton(Self);
    if FCloseSysBtn<>nil then
    begin
      (FCloseSysBtn as IDirectUIControl).SetDirectUIParentIntf(Self);
      FCloseSysBtn.Name:='CloseSysBtn';
      FCloseSysBtn.Caption:='';
      FCloseSysBtn.OnClick:=OnCloseSysBtnClick;
      FCloseSysBtn.SetBounds(0,0,16,16);


      FCloseSysBtn.HitTest:=True;
      FCloseSysBtn.HitTestValue:=1024+HTCLOSE;
      FCloseSysBtn.Visible:=False;
//      FCloseSysBtn.Visible:=True;
//      FCloseSysBtn.Parent:=TWinControl(Owner);
      FCloseSysBtn.DirectUIVisible:=True;


      FCloseSysBtn.SetSubComponent(True);
      AddFreeNotification(FCloseSysBtn,Self);
      Self.FSystemControls.Add(FCloseSysBtn);
    end;
  end;
  if FCloseSysBtn.Width=0 then
  begin
    FCloseSysBtn.Width:=FCloseSysBtn.Height;
  end;

  Result:=FCloseSysBtn;
end;


function TSkinWinForm.GetMaxRestoreSysBtn: TSkinChildButton;
begin
  if FMaxRestoreSysBtn=nil then
  begin
    //��ԭ/��󻯰�ť
    FMaxRestoreSysBtn:=CreateChildButton(Self);
    if FMaxRestoreSysBtn<>nil then
    begin
      (FMaxRestoreSysBtn as IDirectUIControl).SetDirectUIParentIntf(Self);
      FMaxRestoreSysBtn.Name:='MaxRestoreSysBtn';
      FMaxRestoreSysBtn.Caption:='';
      FMaxRestoreSysBtn.OnClick:=OnMaxRestoreSysBtnClick;
      FMaxRestoreSysBtn.SetBounds(0,0,16,16);


      FMaxRestoreSysBtn.HitTest:=True;
      FMaxRestoreSysBtn.HitTestValue:=1024+HTMAXBUTTON;
      FMaxRestoreSysBtn.Visible:=False;
//      FMaxRestoreSysBtn.Visible:=True;
//      FMaxRestoreSysBtn.Parent:=TWinControl(Owner);
      FMaxRestoreSysBtn.DirectUIVisible:=True;




      FMaxRestoreSysBtn.SetSubComponent(True);
      AddFreeNotification(FMaxRestoreSysBtn,Self);
      Self.FSystemControls.Add(FMaxRestoreSysBtn);
    end;
  end;

  if FMaxRestoreSysBtn.Width=0 then
  begin
    FMaxRestoreSysBtn.Width:=FMaxRestoreSysBtn.Height;
  end;

  Result:=FMaxRestoreSysBtn;
end;

function TSkinWinForm.GetFormSysCaption: TSkinChildLabel;
begin
  if FFormSysCaption=nil then
  begin
    //�������
    FFormSysCaption:=CreateChildLabel(Self);
    if FFormSysCaption<>nil then
    begin
      (FFormSysCaption as IDirectUIControl).SetDirectUIParentIntf(Self);
      FFormSysCaption.Name:='SysCaption';
      FFormSysCaption.Caption:='';
      FFormSysCaption.SetBounds(24,4,0,0);


      FFormSysCaption.HitTest:=True;
      FFormSysCaption.Visible:=False;
//      FFormSysCaption.Visible:=True;
//      FFormSysCaption.Parent:=TWinControl(Owner);
      FFormSysCaption.DirectUIVisible:=True;


      FFormSysCaption.Caption:=Self.GetCaption;


      FFormSysCaption.SetSubComponent(True);
      AddFreeNotification(FFormSysCaption,Self);
      Self.FSystemControls.Add(FFormSysCaption);
    end;
  end;
  Result:=FFormSysCaption;
end;

function TSkinWinForm.GetFormSysIcon: TSkinChildImage;
begin
  if FFormSysIcon=nil then
  begin
    //����ͼ��
    FFormSysIcon:=CreateChildImage(Self);
    if FFormSysIcon<>nil then
    begin
      (FFormSysIcon as IDirectUIControl).SetDirectUIParentIntf(Self);
      FFormSysIcon.Name:='SysIcon';
      FFormSysIcon.SetBounds(6,5,16,16);
      FFormSysIcon.Caption:='';


      FFormSysIcon.HitTest:=True;
      FFormSysIcon.Visible:=False;
//      FFormSysIcon.Visible:=True;
//      FFormSysIcon.Parent:=TWinControl(Owner);
      FFormSysIcon.HitTestValue:=HTSYSMENU;
      FFormSysIcon.DirectUIVisible:=True;

      //���ܸ���,���IconΪ�յĻ�
//      FFormSysIcon.Properties.Picture.Assign(Self.FForm.Icon);


      FFormSysIcon.SetSubComponent(True);
      AddFreeNotification(FFormSysIcon,Self);
      Self.FSystemControls.Add(FFormSysIcon);
    end;
  end;
  Result:=FFormSysIcon;
end;

//procedure TSkinWinForm.SetCloseSysBtn(const Value: TSkinChildButton);
//begin
//  if FCloseSysBtn<>Value then
//  begin
//    if FCloseSysBtn<>nil then
//    begin
//      if FCloseSysBtn.Owner=Self then
//      begin
//        FreeAndNil(FCloseSysBtn);
//      end
//      else
//      begin
//        Self.FSystemControls.Remove(FCloseSysBtn,False);
//        FCloseSysBtn:=nil;
//      end;
//    end;
//    if Value<>nil then
//    begin
//      FCloseSysBtn:=Value;
////      FCloseSysBtnIntf:=FCloseSysBtn as ISkinButton;
//
//
//      AddFreeNotification(FCloseSysBtn,Self);
//      FCloseSysBtn.SetSubComponent(True);
//      Self.FSystemControls.Add(FCloseSysBtn);
//    end;
//  end;
//end;
//
//procedure TSkinWinForm.SetFormSysCaption(const Value: TSkinChildLabel);
//begin
//  if FFormSysCaption<>Value then
//  begin
//    if FFormSysCaption<>nil then
//    begin
//      if FFormSysCaption.Owner=Self then
//      begin
//        FreeAndNil(FFormSysCaption);
//      end
//      else
//      begin
//        Self.FSystemControls.Remove(FFormSysCaption,False);
//        FFormSysCaption:=nil;
//      end;
//    end;
//    if Value<>nil then
//    begin
//      FFormSysCaption:=Value;
////      FFormSysCaptionIntf:=FFormSysCaption as ISkinLabel;
////      FFormSysCaptionDUIIntf:=FFormSysCaption as IDirectUIControl;
//
//
//
//      FFormSysCaption.SetSubComponent(True);
//      AddFreeNotification(FFormSysCaption,Self);
//      Self.FSystemControls.Add(FFormSysCaption);
//    end;
//  end;
//end;
//
//procedure TSkinWinForm.SetFormSysIcon(const Value: TSkinChildImage);
//begin
//  if FFormSysIcon<>Value then
//  begin
//    if FFormSysIcon<>nil then
//    begin
//      if FFormSysIcon.Owner=Self then
//      begin
//        FreeAndNil(FFormSysIcon);
//      end
//      else
//      begin
//        Self.FSystemControls.Remove(FFormSysIcon,False);
//        FFormSysIcon:=nil;
//      end;
//    end;
//    if Value<>nil then
//    begin
//      FFormSysIcon:=Value;
////      FFormSysIconIntf:=FFormSysIcon as ISkinImage;
////      FFormSysIconDUIIntf:=FFormSysIcon as IDirectUIControl;
//
//
//
//      FFormSysIcon.SetSubComponent(True);
//      AddFreeNotification(FFormSysIcon,Self);
//      Self.FSystemControls.Add(FFormSysIcon);
//    end;
//  end;
//end;
//
//procedure TSkinWinForm.SetMaxRestoreSysBtn(const Value: TSkinChildButton);
//begin
//  if FMaxRestoreSysBtn<>Value then
//  begin
//    if FMaxRestoreSysBtn<>nil then
//    begin
//      if FMaxRestoreSysBtn.Owner=Self then
//      begin
//        FreeAndNil(FMaxRestoreSysBtn);
//      end
//      else
//      begin
//        Self.FSystemControls.Remove(FMaxRestoreSysBtn,False);
//        FMaxRestoreSysBtn:=nil;
//      end;
//    end;
//    if Value<>nil then
//    begin
//      FMaxRestoreSysBtn:=Value;
////      FMaxRestoreSysBtnIntf:=FMaxRestoreSysBtn as ISkinButton;
////      FMaxRestoreSysBtnDUIIntf:=FMaxRestoreSysBtn as IDirectUIControl;
//
//
//
//      FMaxRestoreSysBtn.SetSubComponent(True);
//      AddFreeNotification(FMaxRestoreSysBtn,Self);
//      Self.FSystemControls.Add(FMaxRestoreSysBtn);
//    end;
//  end;
//end;
//
//procedure TSkinWinForm.SetMinSysBtn(const Value: TSkinChildButton);
//begin
//  if FMinSysBtn<>Value then
//  begin
//    if FMinSysBtn<>nil then
//    begin
//      if FMinSysBtn.Owner=Self then
//      begin
//        FreeAndNil(FMinSysBtn);
//      end
//      else
//      begin
//        Self.FSystemControls.Remove(FMinSysBtn,False);
//        FMinSysBtn:=nil;
//      end;
//    end;
//    if Value<>nil then
//    begin
//      FMinSysBtn:=Value;
////      FMinSysBtnIntf:=FMinSysBtn as ISkinButton;
////      FMinSysBtnDUIIntf:=FMinSysBtn as IDirectUIControl;
//
//
//
//      FMinSysBtn.SetSubComponent(True);
//      AddFreeNotification(FMinSysBtn,Self);
//      Self.FSystemControls.Add(FMinSysBtn);
//    end;
//  end;
//end;

//procedure TSkinWinForm.AddSystemControl(ASystemControl: TControl);
//begin
//  if Self.FSystemControls.IndexOf(ASystemControl)=-1 then
//  begin
//    Self.FSystemControls.Add(ASystemControl);
//  end;
//end;









procedure TSkinWinForm.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent,Operation);

  if (Operation=opRemove) then
  begin
    if (AComponent=FForm) then
    begin
      SetForm(nil);
    end
    else




    if (AComponent=Self.FMaterial) then
    begin
      //���ʹ�õ����Լ����ز�,��ôҲҪ���
      if FCurrentUseSkinMaterial=FMaterial then
      begin
        FCurrentUseSkinMaterial:=nil;
      end;
      FMaterial:=nil;
    end
    else
    if (AComponent=Self.FRefMaterial) then
    begin
      if FCurrentUseSkinMaterial=FRefMaterial then
      begin
        FCurrentUseSkinMaterial:=nil;
      end;
      FRefMaterial:=nil;
    end
    else
    if (AComponent=Self.FCurrentUseSkinMaterial) then
    begin
      FCurrentUseSkinMaterial:=nil;
    end




    else if (AComponent=Self.FCloseSysBtn) then
    begin
      FCloseSysBtn:=nil;
    end
    else if (AComponent=Self.FMinSysBtn) then
    begin
      FMinSysBtn:=nil;
    end
    else if (AComponent=Self.FMaxRestoreSysBtn) then
    begin
      FMaxRestoreSysBtn:=nil;
    end
    else if (AComponent=Self.FFormSysIcon) then
    begin
      FFormSysIcon:=nil;
    end
    else if (AComponent=Self.FFormSysCaption) then
    begin
      FFormSysCaption:=nil;
    end



    ;
  end;
end;

procedure TSkinWinForm.SyncSystemControls;
//begin
//  if (FFormSysCaption<>nil)
//    and (FFormSysCaption.Caption<>Self.GetCaption) then
//  begin
//    FFormSysCaption.Caption:=Self.GetCaption;
//  end;
//
//  if (Self.FFormSysIcon<>nil)
//    and (FFormSysIconIntf.ImageProperties.Picture.AssignSourcePicture<>Self.GetIcon) then
//  begin
//    FFormSysIconIntf.ImageProperties.Picture.Assign(Self.GetIcon);
//  end;

//begin
//  AlignSysSkinFormSysControls;
//  procedure SetParentByChildVisible(AChild:TControl);
//  begin
//    if AChild<>nil then
//    begin
//      if AChild.Visible then
//      begin
//        AChild.Parent:=Self.FForm;
//      end
//      else
//      begin
//        AChild.Parent:=nil;
//      end;
//    end;
//  end;
var
  RightMargin:Integer;
  AMaterial:TSkinFormMaterial;
begin
//  {$IFDEF VCL}
  if GetSkinFormType=nil then Exit;

//  TBorderIcon = (biSystemMenu, biMinimize, biMaximize, biHelp);
//  TBorderIcons = set of TBorderIcon;
//biSystemMenuû�еĻ������е�ϵͳ��ť��������


  if (Self.GetCurrentUseMaterial<>nil) and TSkinFormMaterial(Self.GetCurrentUseMaterial).EnableAutoAlignSysBtn then
  begin
        AMaterial:=TSkinFormMaterial(Self.GetCurrentUseMaterial);

//      if biSystemMenu in Self.FForm.BorderIcons then
//      begin
//        if FCloseSysBtn<>nil then
//        begin
//          Self.FCloseSysBtn.DirectUIVisible:=True;
////          Self.FCloseSysBtn.Visible:=False;
//        end;
//        if FMinSysBtn<>nil then
//        begin
//          Self.FMinSysBtn.DirectUIVisible:=biMinimize in Self.FForm.BorderIcons;
////          Self.FCloseSysBtn.Visible:=False;
//        end;
//        if FMaxRestoreSysBtn<>nil then
//        begin
//          Self.FMaxRestoreSysBtn.DirectUIVisible:=biMaximize in Self.FForm.BorderIcons;
//        end;
//        if FFormSysIcon<>nil then
//        begin
//          Self.FFormSysIcon.DirectUIVisible:=True;
//        end;
//      end
//      else
//      begin
//        if FCloseSysBtn<>nil then
//        begin
//          Self.FCloseSysBtn.DirectUIVisible:=False;
//        end;
//        if FMinSysBtn<>nil then
//        begin
//          Self.FMinSysBtn.DirectUIVisible:=False;
//        end;
//        if FMaxRestoreSysBtn<>nil then
//        begin
//          Self.FMaxRestoreSysBtn.DirectUIVisible:=False;
//        end;
//        if FFormSysIcon<>nil then
//        begin
//          Self.FFormSysIcon.DirectUIVisible:=False;
//        end;
//      end;



      //��ʱ����Ҫ�Զ���
      if Assigned(FOnSyncSystemControls) then
      begin
        FOnSyncSystemControls(Self);
      end;

//      SetParentByChildVisible(FCloseSysBtn);
//      SetParentByChildVisible(FMinSysBtn);
//      SetParentByChildVisible(FMaxRestoreSysBtn);
//      SetParentByChildVisible(FFormSysIcon);


  //    //ͼ��ͱ���
  //    if FFormSysIcon<>nil then Self.FFormSysIcon.Top:=TSkinFormMaterial(Self.GetSkinMaterial).FAlignSysBtnTopMargin;


      if TSkinBaseFormType(Self.SkinControlType).GetCustomCaptionBarHeight>0 then
      begin
        if FFormSysCaption<>nil then Self.FFormSysCaption.Height:=TSkinBaseFormType(Self.SkinControlType).GetCustomCaptionBarHeight;
        if FFormSysIcon<>nil then Self.FFormSysIcon.Height:=TSkinBaseFormType(Self.SkinControlType).GetCustomCaptionBarHeight;
      end;
      



      //ϵͳ��ť
      if FCloseSysBtn<>nil then Self.FCloseSysBtn.Top:=ScreenScaleSizeInt(AMaterial.AlignSysBtnTopMargin);
      if FMinSysBtn<>nil then Self.FMinSysBtn.Top:=ScreenScaleSizeInt(AMaterial.AlignSysBtnTopMargin);
      if FMaxRestoreSysBtn<>nil then Self.FMaxRestoreSysBtn.Top:=ScreenScaleSizeInt(AMaterial.AlignSysBtnTopMargin);



      RightMargin:=Self.GetWidth-ScreenScaleSizeInt(AMaterial.AlignSysBtnRightMargin);
      if (FCloseSysBtn<>nil) and Self.FCloseSysBtn.DirectUIVisible then
      begin
        Self.FCloseSysBtn.Height:=ScreenScaleSizeInt(AMaterial.SysBtnHeight);
        Self.FCloseSysBtn.Width:=ScreenScaleSizeInt(AMaterial.SysBtnWidth);
        Self.FCloseSysBtn.Left:=RightMargin-Self.FCloseSysBtn.Width;
        RightMargin:=RightMargin-Self.FCloseSysBtn.Width-AMaterial.AlignSysBtnSpace;
      end;
      if (FMaxRestoreSysBtn<>nil) and Self.FMaxRestoreSysBtn.DirectUIVisible then
      begin
        Self.FMaxRestoreSysBtn.Height:=ScreenScaleSizeInt(AMaterial.SysBtnHeight);
        Self.FMaxRestoreSysBtn.Width:=ScreenScaleSizeInt(AMaterial.SysBtnWidth);
        Self.FMaxRestoreSysBtn.Left:=RightMargin-Self.FMaxRestoreSysBtn.Width;
        RightMargin:=RightMargin-Self.FMaxRestoreSysBtn.Width-AMaterial.AlignSysBtnSpace;
      end;
      if (FMinSysBtn<>nil) and Self.FMinSysBtn.DirectUIVisible then
      begin
        Self.FMinSysBtn.Height:=ScreenScaleSizeInt(AMaterial.SysBtnHeight);
        Self.FMinSysBtn.Width:=ScreenScaleSizeInt(AMaterial.SysBtnWidth);
        Self.FMinSysBtn.Left:=RightMargin-Self.FMinSysBtn.Width;
        RightMargin:=RightMargin-Self.FMinSysBtn.Width-AMaterial.AlignSysBtnSpace;
      end;

  end;
//  {$ENDIF}



//  if (Self.FFormSysIcon<>nil)
////    and (FFormSysIconIntf.ImageProperties.Picture.AssignSourcePicture<>Self.GetIcon)
//    then
//  begin
//    FFormSysIcon.Properties.Picture.Assign(Self.GetIcon);
//  end;

end;

function TSkinWinForm.GetSkinFormType:TSkinBaseFormType;
begin
  Result:=TSkinBaseFormType(Self.GetSkinControlType);
end;

function TSkinWinForm.GetBufferBitmap: TBufferBitmap;
begin
  if FBufferBitmap=nil then
  begin
    FBufferBitmap:=TBufferBitmap.Create;
  end;
  Result:=Self.FBufferBitmap;
end;






{ TSkinWinNormalForm }

procedure TSkinWinNormalForm.CheckCurrentUseMaterial;
begin
  //
end;

procedure TSkinWinNormalForm.CheckSelfOwnMaterial;
begin
  //
end;

function TSkinWinNormalForm.GetSkinControlTypeClass:TControlTypeClass;
begin
  Result:=TSkinFormNormalType;
end;

function TSkinWinNormalForm.GetMaterialClass:TMaterialClass;
begin
  Result:=TSkinFormNormalMaterial;
end;

procedure TSkinWinNormalForm.CreateSkinControlType;
var
  AControlTypeClass:TControlTypeClass;
begin

    //���������Լ��Ŀؼ�����,ָ��ComponentTypeName
    if (FSkinControlType=nil)
      and (Self.FProperties<>nil)
      and (Self.FProperties.GetComponentClassify<>'')
      and (GetCurrentUseComponentTypeName<>'') then
    begin
        //��ȡ�ؼ�������
        AControlTypeClass:=TSkinFormNormalType;
        if (AControlTypeClass<>nil) then
        begin

            FSkinControlType:=TSkinControlType(AControlTypeClass.Create(TControl(Self)));
//            //�������������Ϊ�Լ�
//            FSkinControlType.SkinControl:=TControl(Self);
//            //�ж��ز������Ƿ�ͷ��ע���������ͬ
//            Self.CheckCurrentUseMaterial;
//            Self.CheckSelfOwnMaterial;

        end
        else
        begin
            uBaseLog.OutputDebugString(
                        'Name:'+Name
                        +' ClassName:'+ClassName
                        +' ComponentTypeName:'+ComponentTypeName
                        +' CreateSkinControlType Can Not Find ControlTypeClass');
        end;
    end;

end;

end.

