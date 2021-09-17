//convert pas to utf8 by ¥

unit SettingFrame;

interface

uses
  System.SysUtils,uFuncCommon, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyLabel,

  Math,
  uManager,

  uComponentType,
  uSkinBufferBitmap,
  uSkinLabelType,
  uDrawTextParam,
  uSkinFireMonkeyButton, FMX.Objects, FMX.Controls.Presentation, FMX.Edit,
  uSkinFireMonkeyEdit, uDrawCanvas, uSkinButtonType, uSkinPanelType;

type
  TFrameSetting = class(TFrame)
    BackRectangle: TRectangle;
    pnlClient: TSkinFMXPanel;
    pnlTop: TSkinFMXPanel;
    lblType: TSkinFMXLabel;
    pnlContent: TSkinFMXPanel;
    pnlBottom: TSkinFMXPanel;
    btnOK: TSkinFMXButton;
    btnCancel: TSkinFMXButton;
    pnlButtonDevide: TSkinFMXPanel;
    pnlTopDevide: TSkinFMXPanel;
    pnlBottomDevide: TSkinFMXPanel;
    lblRoomNO: TSkinFMXLabel;
    pnlRoomNO: TSkinFMXPanel;
    edtRoomNO: TSkinFMXEdit;
    pnlWaitorNO: TSkinFMXPanel;
    lblWaitorNO: TSkinFMXLabel;
    edtWaitorNO: TSkinFMXEdit;
    ClearEditButton1: TClearEditButton;
    DrawCanvasSetting1: TDrawCanvasSetting;
    ClearEditButton2: TClearEditButton;
    btnClose: TSkinFMXButton;
    procedure FrameResize(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalSettingFrame:TFrameSetting;


implementation

uses
  MainForm,
  MainFrame;

{$R *.fmx}

//procedure TFrameSetting.AlignButtons;
//begin
//  if btnOK.Visible and Not btnCancel.Visible then
//  begin
//    Self.btnOK.Width:=Self.pnlMessageBox.Width;
//  end
//  else
//  begin
//    Self.btnOK.Width:=Self.pnlMessageBox.Width/2;
//    Self.btnCancel.Width:=Self.pnlMessageBox.Width/2;
//    Self.pnlButtonDevide.Left:=Self.btnOK.Left+Self.btnOK.Width;
//  end;
//end;

procedure TFrameSetting.btnCloseClick(Sender: TObject);
begin
  btnCancelClick(Sender);
end;

procedure TFrameSetting.btnOKClick(Sender: TObject);
begin
  GlobalManager.RoomNO:=Self.edtRoomNO.Text;
  GlobalManager.WaitorNO:=Self.edtWaitorNO.Text;
  GlobalManager.Save;

  GlobalMainFrame.SyncCaption;

  Visible:=False;
end;

procedure TFrameSetting.btnCancelClick(Sender: TObject);
begin
  Self.edtRoomNO.Text:=GlobalManager.RoomNO;
  Self.edtWaitorNO.Text:=GlobalManager.WaitorNO;

  Visible:=False;
end;

constructor TFrameSetting.Create(AOwner: TComponent);
begin
  inherited;

  Self.edtRoomNO.Text:=GlobalManager.RoomNO;
  Self.edtWaitorNO.Text:=GlobalManager.WaitorNO;

  Self.OnResize:=Self.FrameResize;
end;

//procedure TFrameSetting.DoParentResize(Sender: TObject);
//begin
//  Self.Left:=0;
//  Self.Top:=0;
////  if (Parent<>nil) and (Parent is TControl) then
////  begin
//    Width:=GetControlParentWidth(Parent);
//    Height:=GetControlParentHeight(Parent);
////  end;
////  if (Parent<>nil) and (Parent is TForm) then
////  begin
////    Width:=TForm(Parent).Width;
////    Height:=TForm(Parent).Height;
////  end;
//  AlignButtons;
//
////  if Assigned(ParentOldResize) then
////  begin
////    ParentOldResize(Sender);
////  end;
//end;

procedure TFrameSetting.FrameResize(Sender: TObject);
//var
//  AWidth:Integer;
begin
//  AWidth:=0;
//  if Width>Height then
//  begin
//    AWidth:=Ceil(Height);
//  end
//  else
//  begin
//    AWidth:=Ceil(Width);//百分比来计算
//  end;

//  if AWidth>300 then
//  begin
//    AWidth:=300;//AWidth*0.85
//  end;

//  if AWidth>300 then
//  begin
//    AWidth:=Ceil(AWidth*0.9);//AWidth*0.85
//  end;
//  Self.pnlClient.Width:=AWidth;


  Self.pnlClient.Left:=Ceil(Self.Width-Self.pnlClient.Width) div 2;
  Self.pnlClient.Top:=Ceil(Self.Height-Self.pnlClient.Height) div 2
                                -100;

//  AlignButtons;
end;

//procedure TFrameSetting.HideMessageBox;
//begin
////  if (Self.Parent<>nil) and (Self.Parent is TControl) then
////  begin
////    TControl(Self.Parent).OnResize:=Self.ParentOldResize;
////  end;
////  if (Self.Parent<>nil) and (Self.Parent is TForm) then
////  begin
////    TForm(Self.Parent).OnResize:=Self.ParentOldResize;
////  end;
//  Self.Parent:=nil;
//  Self.Visible:=False;
//end;
//
//procedure TFrameSetting.ShowMessageBox(Parent:TFmxObject;
//              const Caption:String;
//              const Msg: string;
//              DlgType: TMsgDlgType;
//              Buttons:Array of String;
//              OnModalResult:TNotifyEvent;
//              CustomControl:TControl;
//              CustomDlgType:String);
//begin
//
//  Self.Parent:=Parent;
//  Self.OnModalResult:=OnModalResult;
//
//
//  //对话框类型
//  Self.lblType.Caption:=CustomDlgType;
//  case DlgType of
//    TMsgDlgType.mtWarning: Self.lblType.Caption:='警告';
//    TMsgDlgType.mtError: Self.lblType.Caption:='报错';
//    TMsgDlgType.mtInformation: Self.lblType.Caption:='提示';
//    TMsgDlgType.mtConfirmation: Self.lblType.Caption:='确认';
//  end;
//
//
//  //标题
//  Self.lblCaption.Caption:=Caption;
//  if Pos(#13#10,Caption)>0 then
//  begin
//    TSkinLabelDefaultMaterial(Self.lblCaption.SelfOwnMaterial).DrawCaptionParam.FontHorzAlign:=TFontHorzAlign.fhaLeft;
//  end
//  else
//  begin
//    TSkinLabelDefaultMaterial(Self.lblCaption.SelfOwnMaterial).DrawCaptionParam.FontHorzAlign:=TFontHorzAlign.fhaCenter;
//  end;
//
//
//
//  //信息
//  Self.lblMsg.Caption:=Msg;
//  //自定义控件
//  if CustomControl<>nil then
//  begin
//    CustomControl.Parent:=Self.pnlContent;
//    CustomControl.Visible:=True;
//  end;
//
//
//  //这些控件是否显示
//  Self.lblCaption.Visible:=(Caption<>'');
//  Self.lblMsg.Visible:=(Msg<>'');
//
//
//
//  Self.pnlClient.Height:=Self.pnlTop.HeightInt+Self.pnlBottom.Height;
//
//  if (Caption<>'') then
//  begin
//    Self.lblCaption.Height:=GetStringHeight(Caption,
//              RectF(0,0,Self.lblCaption.WidthInt,1000),
//              TSkinLabelDefaultMaterial(Self.lblCaption.SelfOwnMaterial).DrawCaptionParam);//+20;
//
//    if (Msg='') and (CustomControl=nil) then
//    begin
//      //加上两行
//      Self.lblCaption.Height:=Self.lblCaption.Height+40;
//    end
//    else
//    begin
//      Self.lblCaption.Height:=Self.lblCaption.Height+20;
//    end;
//
//    Self.pnlClient.Height:=Self.pnlClient.Height+Self.lblCaption.Height;
//  end;
//
//  if (Msg<>'') then
//  begin
//    Self.lblMsg.Height:=GetStringHeight(Msg,
//              RectF(0,0,Self.lblMsg.WidthInt,1000),
//              TSkinLabelDefaultMaterial(Self.lblMsg.SelfOwnMaterial).DrawCaptionParam)+20;
//    Self.pnlClient.Height:=Self.pnlClient.Height+Self.lblMsg.Height;//+30;
//  end;
//
//  if (CustomControl<>nil) then
//  begin
//    Self.pnlClient.Height:=Self.pnlClient.Height+CustomControl.Height;
//    CustomControl.Align:=TAlignLayout.alTop;
//  end;
//
//
//
//
//
//
//  //判断按钮的个数
//  if Length(Buttons)=1 then
//  begin
//    Self.btnOK.Visible:=True;
//    Self.btnOK.Caption:=Buttons[0];
//
//    Self.btnCancel.Visible:=False;
//
//    Self.pnlButtonDevide.Visible:=False;
//  end;
//  if Length(Buttons)=2 then
//  begin
//    Self.btnOK.Visible:=True;
//    Self.btnOK.Caption:=Buttons[0];
//
//    Self.btnCancel.Visible:=True;
//    Self.btnCancel.Caption:=Buttons[1];
//
//    Self.pnlButtonDevide.Visible:=True;
//  end;
//
//
//  //排列按钮
//  AlignButtons;
//
//
//  //在对话框的父控件中对齐对话框
//  Self.DoParentResize(Parent);
//
//  //居中
//  Self.FrameResize(Self);
//
//  //设置父控件的排列控件
////  ParentOldResize:=nil;
////  if (Parent<>nil) and (Parent is TControl) then
////  begin
////    Self.ParentOldResize:=TControl(Parent).OnResize;
////    TControl(Parent).OnResize:=Self.DoParentResize;
////  end;
////  if (Parent<>nil) and (Parent is TForm) then
////  begin
////    Self.ParentOldResize:=TForm(Parent).OnResize;
////    TForm(Parent).OnResize:=Self.DoParentResize;
////  end;
//
//
//
//
//  //显示到最前
//  Self.BringToFront;
//
//
//  //显示对话框
//  Self.Visible:=True;
//
//
//end;
//
//procedure TFrameSetting.tmrBringToFontTimer(Sender: TObject);
//begin
//  Self.BringToFront;
//  //在对话框的父控件中对齐对话框
//  Self.DoParentResize(Parent);
//  //
//  FrameResize(Sender);
//end;

end.
