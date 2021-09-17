//convert pas to utf8 by ¥
unit uProcessNativeControlModalShowPanel;

interface

uses
  SysUtils,
  Classes,
  uBaseList,
  Types,
  uComponentType,
  uSkinFireMonkeyControl,
  uFrameContext,
  FMX.Graphics,
  FMX.Controls,
  FMX.Types;


type
  //生成原生控件图片的事件,绘制在控件上
  TOnGetNativeControlBitmap=procedure(Sender:TObject;
                                      ANativeControl:TControl;
                                      var ABitmap:TBitmap) of Object;


  TProcessNativeControlModalShowPanelProperties=class(TSkinControlProperties)
  public
    //获取分类名称
    function GetComponentClassify:String;override;
  end;



  {$I Source\Controls\ComponentPlatformsAttribute.inc}
  TProcessNativeControlModalShowPanel=class(TSkinFireMonkeyControl)
  private
    FModalShowCount:Integer;
    FNativeControl:TControl;
    FRefreshScreenshotTimer:TTimer;
    FNativeControlScreenshot:TBitmap;
    FOnGetNativeControlBitmap: TOnGetNativeControlBitmap;
    FIsEnableModalShow: Boolean;
    procedure DoRefreshScreenshotTimer(Sender:TObject);
    procedure SetIsEnableModalShow(const Value: Boolean);
  protected
    //控件绘制
    procedure Paint;override;
    //获取控件属性类
    function GetPropertiesClassType:TPropertiesClassType;override;
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
//    IsEnableModalShow:Boolean;

    //更新原生控件的截图
    procedure UpdateModalShow;
    //停止显示原生控件,改成显示原生控件的截图
    procedure BeginModalShow;
    //显示原生控件
    procedure EndModalShow;
    //主要是禁用的时候,能停止ModalShow,显示原生控件
    property IsEnableModalShow:Boolean read FIsEnableModalShow write SetIsEnableModalShow;
  published
    property OnGetNativeControlBitmap:TOnGetNativeControlBitmap read FOnGetNativeControlBitmap write FOnGetNativeControlBitmap;
  published
//    property StaysPressed default False;
    property Action;
    property Align default TAlignLayout.{$IF CompilerVersion >= 35.0}None{$ELSE}alNone{$IFEND};
    property Anchors;
//    property AutoTranslate default True;
//    property Cancel: Boolean read FCancel write FCancel default False;
    property CanFocus;// default True;
    property CanParentFocus;
    property ClipChildren;// default False;
    property ClipParent;// default False;
//    property Cursor default crDefault;
//    property Default: Boolean read FDefault write FDefault default False;
//    property DesignVisible default True;
//    property DisableFocusEffect;
//    property DragMode default TDragMode.dmManual;
//    property EnableDragHighlight default True;
    property Enabled default True;
//    property Font;
//    property StyledSettings;
    property Height;
//    property HelpContext;
//    property HelpKeyword;
//    property HelpType;
    property HitTest default True;
//    property IsPressed default False;
    property Locked default False;
    property Padding;
//    property ModalResult default mrNone;
    property Opacity;
    property Margins;
    property PopupMenu;
    property Position;
    property Scale;
    property Size;
//    {$ENDIF}
//    property RepeatClick default False;
    property RotationAngle;
    property RotationCenter;
//    property Scale;
//    property StyleLookup;
    property TabOrder;
//    property Text;
//    property Trimming;
//    property TextAlign default TTextAlign.taCenter;
    property TouchTargetExpansion;
    property Visible default True;
    property Width;
//    pro
//    property WordWrap default False;
//    property OnApplyStyleLookup;
//    property OnGestureLongTap:TOnGestureLongTap read FOnGestureLongTap write FOnGestureLongTap;

    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    property OnKeyDown;
    property OnKeyUp;
    property OnCanFocus;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;
//    property OnPainting;
//    property OnPaint;
    property OnResize;
  end;


var
  GlobalModalShowPanelList:TBaseList;
  GlobalModalShowCount:Integer;

//模态对话框显示了,原生控件需要移动到隐藏的地方
procedure ProcessNativeControlBeginModalShow;
//模态对话框隐藏了,原生控件需要恢复原样
procedure ProcessNativeControlEndModalShow;


implementation


procedure ProcessNativeControlBeginModalShow;
var
  I: Integer;
begin
  //有模态显示的Frame,隐藏原生控件
  Inc(GlobalModalShowCount);
  for I := GlobalModalShowPanelList.Count-1 downto 0 do
  begin
    TProcessNativeControlModalShowPanel(GlobalModalShowPanelList[I]).BeginModalShow;
  end;
end;

procedure ProcessNativeControlEndModalShow;
var
  I: Integer;
begin
  //有模态显示的Frame隐藏了,显示原生控件
  Dec(GlobalModalShowCount);

  if GlobalModalShowCount=0 then
  begin
    for I := GlobalModalShowPanelList.Count-1 downto 0 do
    begin
      TProcessNativeControlModalShowPanel(GlobalModalShowPanelList[I]).EndModalShow;
    end;
  end;

end;



{ TProcessNativeControlModalShowPanel }

procedure TProcessNativeControlModalShowPanel.BeginModalShow;
begin
  if IsEnableModalShow then
  begin


      Inc(FModalShowCount);

      if FModalShowCount=1 then
      begin

        FNativeControl:=nil;

        UpdateModalShow;
      end;
  end;
end;

constructor TProcessNativeControlModalShowPanel.Create(AOwner: TComponent);
begin
  inherited;


  GlobalModalShowPanelList.Add(Self);
end;

destructor TProcessNativeControlModalShowPanel.Destroy;
begin

  FreeAndNil(FRefreshScreenshotTimer);

  GlobalModalShowPanelList.Remove(Self,False);


  FreeAndNil(FNativeControlScreenshot);
  inherited;
end;

procedure TProcessNativeControlModalShowPanel.DoRefreshScreenshotTimer(Sender: TObject);
begin
  if (FNativeControl<>nil) then
  begin
    FreeAndNil(FNativeControlScreenshot);
    //刷新缓存图片
    if Assigned(FOnGetNativeControlBitmap) then
    begin
      FOnGetNativeControlBitmap(Self,FNativeControl,FNativeControlScreenshot);
    end
    else
    begin
      FNativeControlScreenshot:=FNativeControl.MakeScreenshot;
    end;
    RePaint;
  end;
end;

procedure TProcessNativeControlModalShowPanel.EndModalShow;
begin
  if FModalShowCount>0 then
  begin
      Dec(FModalShowCount);

      if FModalShowCount=0 then
      begin

        //恢复原位
        if FNativeControl<>nil then
        begin
          FNativeControl.Position.X:=0;
          FNativeControl.Position.Y:=0;
          FNativeControl.Align:=TAlignLayout.Client;
        end;

        //停止刷新
        FreeAndNil(FRefreshScreenshotTimer);

      end;
  end;
end;

function TProcessNativeControlModalShowPanel.GetPropertiesClassType: TPropertiesClassType;
begin
  Result:=TProcessNativeControlModalShowPanelProperties;
end;

procedure TProcessNativeControlModalShowPanel.Paint;
begin
  Inherited;


//  if FIsModalShow then
//  begin
    if (FNativeControlScreenshot<>nil)
      and (Not FNativeControlScreenshot.IsEmpty) then
    begin
        Canvas.BeginScene();
        try
          Canvas.DrawBitmap(
              FNativeControlScreenshot,
              RectF(0,0,FNativeControlScreenshot.Width,FNativeControlScreenshot.Height),
              RectF(0,0,Width,Height),
              1
              );
        finally
          Canvas.EndScene;
        end;
    end;
//  end;
end;


procedure TProcessNativeControlModalShowPanel.SetIsEnableModalShow(
  const Value: Boolean);
begin
  if FIsEnableModalShow<>Value then
  begin
    FIsEnableModalShow := Value;

    if FIsEnableModalShow then
    begin
      //启用
      Self.FModalShowCount:=0;
    end
    else
    begin
      //禁用
      if Self.FModalShowCount>0 then
      begin
        FModalShowCount:=1;
        Self.EndModalShow;
      end;
    end;

  end;
end;

procedure TProcessNativeControlModalShowPanel.UpdateModalShow;
begin
  if IsEnableModalShow then
  begin
      if Self.FModalShowCount>0 then
      begin

        if Self.ControlsCount>0 then
        begin
            FNativeControl:=Self.Controls[0];


            //更新缓存图片
            DoRefreshScreenshotTimer(nil);
            //显示出来,避免空白
            RePaint;



            //先设置为None,在有Parent的情况下,设置位置才有效,不然无效
            FNativeControl.Align:=TAlignLayout.None;
            FNativeControl.Position.X:=10000;
            FNativeControl.Position.Y:=10000;
            FNativeControl.Width:=Self.Width;
            FNativeControl.Height:=Self.Height;



            if FRefreshScreenshotTimer=nil then
            begin
              FRefreshScreenshotTimer:=TTimer.Create(nil);
              //如果每200ms刷新一次,可能会造成ListBox滑动卡顿
              FRefreshScreenshotTimer.Interval:=1000;
              FRefreshScreenshotTimer.OnTimer:=Self.DoRefreshScreenshotTimer;
            end;
            if Not FRefreshScreenshotTimer.Enabled then
            begin
              FRefreshScreenshotTimer.Enabled:=True;
            end;


        end;
      end;
  end;
end;

{ TProcessNativeControlModalShowPanelProperties }

function TProcessNativeControlModalShowPanelProperties.GetComponentClassify: String;
begin
  Result:='ProcessNativeControlModalShowPanel';
end;

initialization
  GlobalModalShowPanelList:=TBaseList.Create(ooReference);

finalization
  FreeAndNil(GlobalModalShowPanelList);


end.
