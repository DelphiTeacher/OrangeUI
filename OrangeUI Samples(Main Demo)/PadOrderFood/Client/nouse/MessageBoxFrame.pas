unit MessageBoxFrame;

interface

uses
  System.SysUtils,uFuncCommon, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyLabel,

//  uUIFunction,
//  uTimerTask,
//  XSuperObject,
//  uInterfaceClass,
//  uBaseHttpControl,
//  uInterfaceHttpControl,
//
//  uInterfaceManager,

  Math,
  uComponentType,
  uBufferBitmap,
  uSkinLabelType,
  uDrawTextParam,
  uSkinFireMonkeyButton, FMX.Objects;

type
  TFrameMessageBox = class(TFrame)
    BackRectangle: TRectangle;
    pnlMessageBox: TSkinFMXPanel;
    pnlTop: TSkinFMXPanel;
    lblType: TSkinFMXLabel;
    pnlContent: TSkinFMXPanel;
    lblCaption: TSkinFMXLabel;
    lblMsg: TSkinFMXLabel;
    pnlBottom: TSkinFMXPanel;
    btnButton1: TSkinFMXButton;
    btnButton2: TSkinFMXButton;
    pnlButtonDevide: TSkinFMXPanel;
    pnlTopDevide: TSkinFMXPanel;
    pnlBottomDevide: TSkinFMXPanel;
    tmrBringToFont: TTimer;
    procedure FrameResize(Sender: TObject);
    procedure btnButton1Click(Sender: TObject);
    procedure btnButton2Click(Sender: TObject);
    procedure tmrBringToFontTimer(Sender: TObject);
  private

    ParentOldResize:TNotifyEvent;
    procedure AlignButtons;
    procedure DoParentResize(Sender: TObject);
    { Private declarations }
  public
    ModalResult:String;
    OnModalResult:TNotifyEvent;
    constructor Create(AOwner:TComponent);override;
    procedure ShowMessageBox(Parent:TFmxObject;
              const Caption:String;
              const Msg: string;
              DlgType: TMsgDlgType;
              Buttons:Array of String;
              OnModalResult:TNotifyEvent;
              CustomControl:TControl;
              CustomDlgType:String
              );
    procedure HideMessageBox;
    { Public declarations }
  end;

var
  GlobalMessageBoxFrame:TFrameMessageBox;


procedure ShowMessageBoxFrame(Parent:TFmxObject;
              const Caption:String;
              const Msg: string;
              DlgType: TMsgDlgType;
              Buttons:Array of String;
              OnModalResult:TNotifyEvent;
              CustomControl:TControl=nil;
              CustomDlgType:String='');
procedure HideMessageBoxFrame;

implementation

{$R *.fmx}

//uses
//  MainForm,
//  LoginFrame;
//


procedure ShowMessageBoxFrame(Parent:TFmxObject;
              const Caption:String;
              const Msg: string;
              DlgType: TMsgDlgType;
              Buttons:Array of String;
              OnModalResult:TNotifyEvent;
              CustomControl:TControl;
              CustomDlgType:String);
begin
  if GlobalMessageBoxFrame=nil then
  begin
    GlobalMessageBoxFrame:=TFrameMessageBox.Create(Application);
  end;
  GlobalMessageBoxFrame.ShowMessageBox(Parent,Caption,Msg,DlgType,Buttons,OnModalResult,CustomControl,CustomDlgType);
end;

procedure HideMessageBoxFrame;
begin
  if GlobalMessageBoxFrame<>nil then
  begin
    GlobalMessageBoxFrame.HideMessageBox;
  end;
end;

procedure TFrameMessageBox.AlignButtons;
begin
  if btnButton1.Visible and Not btnButton2.Visible then
  begin
    Self.btnButton1.Width:=Self.pnlMessageBox.Width;
  end
  else
  begin
    Self.btnButton1.Width:=Self.pnlMessageBox.Width/2;
    Self.btnButton2.Width:=Self.pnlMessageBox.Width/2;
    Self.pnlButtonDevide.Left:=Self.btnButton1.Left+Self.btnButton1.Width;
  end;
end;

procedure TFrameMessageBox.btnButton1Click(Sender: TObject);
begin
  ModalResult:=Self.btnButton1.Caption;
  HideMessageBox;



  if Assigned(OnModalResult) then
  begin
    OnModalResult(Self);
  end;

//  if Self.lblCaption.Caption='�����˺�������һ̨�豸�ϵ�¼' then
//  begin
//    HideFrame(CurrentFrame,hfcttBeforeShowFrame,ufsefNone);
//    //��ת����½����
//    //��ʾ��¼����
//    //����Ҫ����Ч��
//    ShowFrame(TFrame(GlobalLoginFrame),TFrameLogin,frmMain,nil,nil,nil,Application,True,True,ufsefNone);
//    GlobalLoginFrame.FrameHistroy:=CurrentFrameHistroy;
//
//  end;
end;

procedure TFrameMessageBox.btnButton2Click(Sender: TObject);
begin
  ModalResult:=Self.btnButton2.Caption;
  HideMessageBox;
  if Assigned(OnModalResult) then
  begin
    OnModalResult(Self);
  end;
end;

constructor TFrameMessageBox.Create(AOwner: TComponent);
begin
  inherited;
  Self.OnResize:=Self.FrameResize;
end;

procedure TFrameMessageBox.DoParentResize(Sender: TObject);
begin
  Self.Left:=0;
  Self.Top:=0;
//  if (Parent<>nil) and (Parent is TControl) then
//  begin
    Width:=GetControlParentWidth(Parent);
    Height:=GetControlParentHeight(Parent);
//  end;
//  if (Parent<>nil) and (Parent is TForm) then
//  begin
//    Width:=TForm(Parent).Width;
//    Height:=TForm(Parent).Height;
//  end;
  AlignButtons;

  if Assigned(ParentOldResize) then
  begin
    ParentOldResize(Sender);
  end;
end;

procedure TFrameMessageBox.FrameResize(Sender: TObject);
var
  AWidth:Integer;
begin
  AWidth:=0;
  if Width>Height then
  begin
    AWidth:=Ceil(Height);
  end
  else
  begin
    AWidth:=Ceil(Width);//�ٷֱ�������
  end;

//  if AWidth>300 then
//  begin
//    AWidth:=300;//AWidth*0.85
//  end;

//  if AWidth>300 then
//  begin
    AWidth:=Ceil(AWidth*0.9);//AWidth*0.85
//  end;
  Self.pnlMessageBox.Width:=AWidth;


  Self.pnlMessageBox.Left:=Ceil(Self.Width-Self.pnlMessageBox.Width) div 2;
  Self.pnlMessageBox.Top:=Ceil(Self.Height-Self.pnlMessageBox.Height) div 2;

  AlignButtons;
end;

procedure TFrameMessageBox.HideMessageBox;
begin
//  if (Self.Parent<>nil) and (Self.Parent is TControl) then
//  begin
//    TControl(Self.Parent).OnResize:=Self.ParentOldResize;
//  end;
//  if (Self.Parent<>nil) and (Self.Parent is TForm) then
//  begin
//    TForm(Self.Parent).OnResize:=Self.ParentOldResize;
//  end;
  Self.Parent:=nil;
  Self.Visible:=False;
end;

procedure TFrameMessageBox.ShowMessageBox(Parent:TFmxObject;
              const Caption:String;
              const Msg: string;
              DlgType: TMsgDlgType;
              Buttons:Array of String;
              OnModalResult:TNotifyEvent;
              CustomControl:TControl;
              CustomDlgType:String);
begin

  Self.Parent:=Parent;
  Self.OnModalResult:=OnModalResult;


  //�Ի�������
  Self.lblType.Caption:=CustomDlgType;
  case DlgType of
    TMsgDlgType.mtWarning: Self.lblType.Caption:='����';
    TMsgDlgType.mtError: Self.lblType.Caption:='����';
    TMsgDlgType.mtInformation: Self.lblType.Caption:='��ʾ';
    TMsgDlgType.mtConfirmation: Self.lblType.Caption:='ȷ��';
  end;


  //����
  Self.lblCaption.Caption:=Caption;
  if Pos(#13#10,Caption)>0 then
  begin
    TSkinLabelDefaultMaterial(Self.lblCaption.SelfOwnMaterial).DrawCaptionParam.FontHorzAlign:=TFontHorzAlign.fhaLeft;
  end
  else
  begin
    TSkinLabelDefaultMaterial(Self.lblCaption.SelfOwnMaterial).DrawCaptionParam.FontHorzAlign:=TFontHorzAlign.fhaCenter;
  end;



  //��Ϣ
  Self.lblMsg.Caption:=Msg;
  //�Զ���ؼ�
  if CustomControl<>nil then
  begin
    CustomControl.Parent:=Self.pnlContent;
    CustomControl.Visible:=True;
  end;


  //��Щ�ؼ��Ƿ���ʾ
  Self.lblCaption.Visible:=(Caption<>'');
  Self.lblMsg.Visible:=(Msg<>'');



  Self.pnlMessageBox.Height:=Self.pnlTop.HeightInt+Self.pnlBottom.Height;

  if (Caption<>'') then
  begin
    Self.lblCaption.Height:=GetStringHeight(Caption,
              RectF(0,0,Self.lblCaption.WidthInt,1000),
              TSkinLabelDefaultMaterial(Self.lblCaption.SelfOwnMaterial).DrawCaptionParam);//+20;

    if (Msg='') and (CustomControl=nil) then
    begin
      //��������
      Self.lblCaption.Height:=Self.lblCaption.Height+40;
    end
    else
    begin
      Self.lblCaption.Height:=Self.lblCaption.Height+20;
    end;

    Self.pnlMessageBox.Height:=Self.pnlMessageBox.Height+Self.lblCaption.Height;
  end;

  if (Msg<>'') then
  begin
    Self.lblMsg.Height:=GetStringHeight(Msg,
              RectF(0,0,Self.lblMsg.WidthInt,1000),
              TSkinLabelDefaultMaterial(Self.lblMsg.SelfOwnMaterial).DrawCaptionParam)+20;
    Self.pnlMessageBox.Height:=Self.pnlMessageBox.Height+Self.lblMsg.Height;//+30;
  end;

  if (CustomControl<>nil) then
  begin
    Self.pnlMessageBox.Height:=Self.pnlMessageBox.Height+CustomControl.Height;
    CustomControl.Align:=TAlignLayout.alTop;
  end;






  //�жϰ�ť�ĸ���
  if Length(Buttons)=1 then
  begin
    Self.btnButton1.Visible:=True;
    Self.btnButton1.Caption:=Buttons[0];

    Self.btnButton2.Visible:=False;

    Self.pnlButtonDevide.Visible:=False;
  end;
  if Length(Buttons)=2 then
  begin
    Self.btnButton1.Visible:=True;
    Self.btnButton1.Caption:=Buttons[0];

    Self.btnButton2.Visible:=True;
    Self.btnButton2.Caption:=Buttons[1];

    Self.pnlButtonDevide.Visible:=True;
  end;


  //���а�ť
  AlignButtons;


  //�ڶԻ���ĸ��ؼ��ж���Ի���
  Self.DoParentResize(Parent);

  //����
  Self.FrameResize(Self);

  //���ø��ؼ������пؼ�
//  ParentOldResize:=nil;
//  if (Parent<>nil) and (Parent is TControl) then
//  begin
//    Self.ParentOldResize:=TControl(Parent).OnResize;
//    TControl(Parent).OnResize:=Self.DoParentResize;
//  end;
//  if (Parent<>nil) and (Parent is TForm) then
//  begin
//    Self.ParentOldResize:=TForm(Parent).OnResize;
//    TForm(Parent).OnResize:=Self.DoParentResize;
//  end;




  //��ʾ����ǰ
  Self.BringToFront;


  //��ʾ�Ի���
  Self.Visible:=True;


end;

procedure TFrameMessageBox.tmrBringToFontTimer(Sender: TObject);
begin
  Self.BringToFront;
  //�ڶԻ���ĸ��ؼ��ж���Ի���
  Self.DoParentResize(Parent);
  //
  FrameResize(Sender);
end;

end.
