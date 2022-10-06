unit PopupMenuFrame;

interface

uses
  System.SysUtils,uFuncCommon, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyLabel,
  Math,
  uVersion,
  uSkinItems,
  uComponentType,
  uBufferBitmap,
  uSkinLabelType,
  uDrawTextParam,
  uSkinFireMonkeyButton, FMX.Objects, uSkinMaterial, uSkinButtonType,
  uSkinFireMonkeyScrollControl, uSkinFireMonkeyVirtualList,
  uSkinFireMonkeyListBox;


type
  TMenuClickEvent=procedure(Sender:TObject;Menu:String) of object;
  TFramePopupMenu = class(TFrame)
    BackRectangle: TRectangle;
    pnlPopupMenu: TSkinFMXPanel;
    pnlTopDevide: TSkinFMXPanel;
    tmrBringToFont: TTimer;
    lbMenus: TSkinFMXListBox;
    lblCaption: TSkinFMXLabel;
    procedure FrameResize(Sender: TObject);
    procedure tmrBringToFontTimer(Sender: TObject);
    procedure lbMenusClickItem(Sender: TObject);
    procedure BackRectangleClick(Sender: TObject);
    procedure lblCaptionClick(Sender: TObject);
  private
    FMenuEvent:TMenuClickEvent;
    ParentOldResize:TNotifyEvent;
    procedure DoParentResize(Sender: TObject);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
//    Tag:Integer;
    Data:Pointer;
    procedure ShowPopupMenu(AParent:TFmxObject;
                            const ACaption:String;
                            AMenus:Array of String;
                            AMenuEvent:TMenuClickEvent;
                            ATag:Integer;
                            AData:Pointer);
    procedure HidePopupMenu;
    { Public declarations }
  end;

var
  GlobalPopupMenuFrame:TFramePopupMenu;


procedure ShowPopupMenuFrame(AParent:TFmxObject;
                            const ACaption:String;
                            AMenus:Array of String;
                            AMenuEvent:TMenuClickEvent;
                            ATag:Integer;
                            AData:Pointer);
procedure HidePopupMenuFrame;

implementation

{$R *.fmx}



procedure ShowPopupMenuFrame(AParent:TFmxObject;
                            const ACaption:String;
                            AMenus:Array of String;
                            AMenuEvent:TMenuClickEvent;
                            ATag:Integer;
                            AData:Pointer);
begin
  if GlobalPopupMenuFrame=nil then
  begin
    GlobalPopupMenuFrame:=TFramePopupMenu.Create(Application);
  end;
  GlobalPopupMenuFrame.ShowPopupMenu(AParent,ACaption,AMenus,AMenuEvent,ATag,AData);
end;

procedure HidePopupMenuFrame;
begin
  if GlobalPopupMenuFrame<>nil then
  begin
    GlobalPopupMenuFrame.HidePopupMenu;
  end;
end;

procedure TFramePopupMenu.BackRectangleClick(Sender: TObject);
begin
  HidePopupMenu;
end;

constructor TFramePopupMenu.Create(AOwner: TComponent);
begin
  inherited;
  Self.OnResize:=Self.FrameResize;
end;

destructor TFramePopupMenu.Destroy;
begin
  GlobalPopupMenuFrame:=nil;
  inherited;
end;

procedure TFramePopupMenu.DoParentResize(Sender: TObject);
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

  if Assigned(ParentOldResize) then
  begin
    ParentOldResize(Sender);
  end;
end;

procedure TFramePopupMenu.FrameResize(Sender: TObject);
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
    AWidth:=Ceil(Width);//百分比来计算
  end;

//  if AWidth>300 then
//  begin
//    AWidth:=300;//AWidth*0.85
//  end;

//  if AWidth>300 then
//  begin
    AWidth:=Ceil(AWidth*0.8);//AWidth*0.85
//  end;
  Self.pnlPopupMenu.Width:=AWidth;


  Self.pnlPopupMenu.Left:=Ceil(Self.Width-Self.pnlPopupMenu.Width) div 2;
  Self.pnlPopupMenu.Top:=Ceil(Self.Height-Self.pnlPopupMenu.Height) div 2;

end;

procedure TFramePopupMenu.HidePopupMenu;
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
  Self.tmrBringToFont.Enabled:=False;
end;

procedure TFramePopupMenu.lblCaptionClick(Sender: TObject);
begin
  HidePopupMenu;
end;

procedure TFramePopupMenu.lbMenusClickItem(Sender: TObject);
begin
  if Assigned(Self.FMenuEvent) then
  begin
    FMenuEvent(Sender,TSkinItem(Sender).Caption);
  end;
  HidePopupMenu;
end;

procedure TFramePopupMenu.ShowPopupMenu(AParent:TFmxObject;
                                        const ACaption:String;
                                        AMenus:Array of String;
                                        AMenuEvent:TMenuClickEvent;
                                        ATag:Integer;
                                        AData:Pointer);
var
  I: Integer;
begin
  FMenuEvent:=AMenuEvent;
  Self.Parent:=AParent;
  Tag:=ATag;
  Data:=AData;

  //标题
  Self.lblCaption.Caption:=ACaption;
  Self.lbMenus.Prop.Items.BeginUpdate;
  try
    Self.lbMenus.Prop.Items.Clear(True);
    for I := 0 to Length(AMenus)-1 do
    begin
      Self.lbMenus.Prop.Items.Add.Caption:=AMenus[I]
    end;
  finally
    Self.lbMenus.Prop.Items.EndUpdate;
  end;


  Self.pnlPopupMenu.Height:=Self.lblCaption.Height
                          +Self.pnlTopDevide.Height
                          +Self.lbMenus.Prop.Items.Count*Self.lbMenus.Prop.ItemHeight;


  //在对话框的父控件中对齐对话框
  Self.DoParentResize(Parent);

  //居中
  Self.FrameResize(Self);

  //设置父控件的排列控件
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

//  Self.DoParentResize(Parent);

  //显示到最前
  Self.BringToFront;

//  Self.imgPopupMenu.Properties.ImageListAnimated:=True;


  //显示对话框
  Self.Visible:=True;
  Self.tmrBringToFont.Enabled:=True;


//  while Visible and not FIsProcessed do
//  begin
//    Application.ProcessMessages;
//  end;
//  Result:=FModalResult;
end;

procedure TFramePopupMenu.tmrBringToFontTimer(Sender: TObject);
begin
  Self.BringToFront;
  //在对话框的父控件中对齐对话框
  Self.DoParentResize(Parent);
  //
  FrameResize(Sender);
end;

end.
