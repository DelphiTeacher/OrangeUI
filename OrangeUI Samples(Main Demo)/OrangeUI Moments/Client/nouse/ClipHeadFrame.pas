unit ClipHeadFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  uBufferBitmap,
  uDrawCanvas,
  uUIFunction,
  uSkinControlGestureManager,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyImage, FMX.Objects,
  uSkinFireMonkeyScrollBoxContent, uSkinFireMonkeyScrollControl,
  uSkinFireMonkeyScrollBox, uSkinFireMonkeyRoundImage, uSkinFireMonkeyButton,
  uSkinFireMonkeyPanel, FMX.Gestures;

type
  TFrameClipHead = class(TFrame)
    sbClient: TSkinFMXScrollBox;
    sbcClient: TSkinFMXScrollBoxContent;
    imgOrigin: TSkinFMXImage;
    rimgClipFrame: TSkinFMXRoundImage;
    pnlToolBar: TSkinFMXPanel;
    btnOK: TSkinFMXButton;
    btnReturn: TSkinFMXButton;
    btnTestZoom: TSkinFMXButton;
    procedure btnOKClick(Sender: TObject);
    procedure btnTestZoomClick(Sender: TObject);
    procedure btnReturnClick(Sender: TObject);
  private
    FInitPictureSize:TSizeF;
    //ͷ��ߴ�
    FHeadSize:Integer;
    FLastZoomDistance: Integer;
    procedure SetZoomDistance(AWidthDistance:Double);
    { Private declarations }
  public
    procedure Init(ABitmap:TBitmap;
                    const AHeadSize:Integer=300);
    procedure DoGesture(Sender: TObject;
                        const EventInfo: TGestureEventInfo;
                        var Handled: Boolean);
    function GetClipBitmap:TBitmap;

  public
    constructor Create(AOwner:TComponent);override;
    { Public declarations }
  end;

var
  GlobalClipHeadFrame:TFrameClipHead;

implementation

{$R *.fmx}

uses
  MainForm;



{ TFrameClipPicture }

procedure TFrameClipHead.btnOKClick(Sender: TObject);
begin
  HideFrame(Self,hfcttBeforeReturnFrame);
  ReturnFrame(Self);
end;

procedure TFrameClipHead.btnReturnClick(Sender: TObject);
begin
  if GetFrameHistory(Self)<>nil then GetFrameHistory(Self).OnReturnFrame:=nil;

  HideFrame(Self,hfcttBeforeReturnFrame);
  ReturnFrame(self);
end;

procedure TFrameClipHead.btnTestZoomClick(Sender: TObject);
begin
  //��������50������
  Self.SetZoomDistance(100);
end;

constructor TFrameClipHead.Create(AOwner: TComponent);
begin
  inherited;
  {$IFNDEF MSWINDOWS}
  Self.btnTestZoom.Visible:=False;
  {$ENDIF}
end;

procedure TFrameClipHead.DoGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo;
  var Handled: Boolean);
//var
//  LObj: IControl;
//  LImage: TSkinFMXImage;
//  LImageCenter: TPointF;
var
  AWidthDistance:Double;
  AHeightDistance:Double;
begin
  FMX.Types.Log.d('OrangeUI TFrameClipHead.imgOriginGesture');

  if EventInfo.GestureID = igiZoom then
  begin

      //���ſ�ʼ
      if (TInteractiveGestureFlag.gfBegin in EventInfo.Flags) then
      begin
        FMX.Types.Log.d('OrangeUI TFrameClipHead.imgOriginGesture Begin');
        ZoomingHorzGestureManager:=Self.sbClient.Prop.HorzControlGestureManager;
        ZoomingVertGestureManager:=Self.sbClient.Prop.VertControlGestureManager;
      end;


//      LObj := Self.ObjectAtPoint(Application.MainForm.ClientToScreen(EventInfo.Location));
//      if LObj is TSkinFMXImage then
//      begin
          if (not (TInteractiveGestureFlag.gfBegin in EventInfo.Flags)) and
            (not (TInteractiveGestureFlag.gfEnd in EventInfo.Flags)) then
          begin
            { zoom the image }

            AWidthDistance:=(EventInfo.Distance - FLastZoomDistance);

            SetZoomDistance(AWidthDistance);
          end;
          FLastZoomDistance := EventInfo.Distance;
//      end;


      //���Ž���
      if (TInteractiveGestureFlag.gfEnd in EventInfo.Flags) then
      begin
        FMX.Types.Log.d('OrangeUI TFrameClipHead.imgOriginGesture End');

        //����С�ڳ�ʼ���
        if Self.imgOrigin.Width<FInitPictureSize.Width then
        begin
          AWidthDistance:=FInitPictureSize.Width-Self.imgOrigin.Width;
          SetZoomDistance(AWidthDistance);
        end;

      end;


  end;
end;

function TFrameClipHead.GetClipBitmap: TBitmap;
var
  AZoomScale:Double;
  ALeftOffset:Double;
  ATopOffset:Double;
begin
  //���ű���
  AZoomScale:=Self.imgOrigin.Prop.Picture.Width/Self.imgOrigin.Width;

  ALeftOffset:=Self.sbClient.Prop.HorzControlGestureManager.Position;
  ATopOffset:=Self.sbClient.Prop.VertControlGestureManager.Position;


  Result:=TBitmap.Create(FHeadSize,FHeadSize);
  Result.Canvas.BeginScene();
  try
    Result.Canvas.DrawBitmap(Self.imgOrigin.Prop.Picture,
                            RectF(ALeftOffset*AZoomScale,
                                  ATopOffset*AZoomScale,
                                  (ALeftOffset+FHeadSize)*AZoomScale,
                                  (ATopOffset+FHeadSize)*AZoomScale),
                            RectF(0,0,FHeadSize,FHeadSize),
                            1);
//    Result.SaveToFile('E:\bb.jpg');
  finally
    Result.Canvas.EndScene;
  end;
end;

procedure TFrameClipHead.Init(ABitmap: TBitmap;const AHeadSize:Integer);
begin
  FHeadSize:=AHeadSize;


  Self.imgOrigin.Prop.Picture.Assign(ABitmap);


  //�м�͸��������ֱ��
  Self.rimgClipFrame.SelfOwnMaterialToDefault.ClipRoundWidth:=0;
  Self.rimgClipFrame.SelfOwnMaterialToDefault.ClipRoundHeight:=0;
  //�м��͸�����εĳߴ�
  Self.rimgClipFrame.SelfOwnMaterialToDefault.ClipRoundRectSetting.Width:=FHeadSize;
  Self.rimgClipFrame.SelfOwnMaterialToDefault.ClipRoundRectSetting.Height:=FHeadSize;


  //��������ʵ���ʾ�ߴ�
  FInitPictureSize:=AutoFillPictureDrawRect(Self.imgOrigin.Prop.Picture.Width,
                                      Self.imgOrigin.Prop.Picture.Height,
                                      FHeadSize,
                                      FHeadSize);

  Self.imgOrigin.Align:=TAlignLayout.None;
  //Image�ؼ��ĳߴ�ΪͼƬ�ĳߴ�
  Self.imgOrigin.Width:=FInitPictureSize.Width;
  Self.imgOrigin.Height:=FInitPictureSize.Height;


  //���Ͽճ�,�����ƶ�
  Self.imgOrigin.Position.X:=(sbClient.Width-FHeadSize)/2;
  Self.imgOrigin.Position.Y:=(sbClient.Height-FHeadSize)/2;


  //ScrollBox�����ݳߴ�,ͼƬ�Ŀ��+�ؼ��Ŀ��-ͷ��Ŀ��
  Self.sbClient.Prop.ContentWidth:=Self.imgOrigin.Width
                                    +Self.sbClient.Width
                                    -FHeadSize;
  Self.sbClient.Prop.ContentHeight:=Self.imgOrigin.Height
                                    +Self.sbClient.Height
                                    -FHeadSize;


end;

procedure TFrameClipHead.SetZoomDistance(AWidthDistance: Double);
var
  AHeightDistance:Double;
begin
  //���ֱ���
  AHeightDistance:=AWidthDistance*Self.imgOrigin.Height/Self.imgOrigin.Width;


  Self.imgOrigin.Width := Self.imgOrigin.Width
            + AWidthDistance;
  Self.imgOrigin.Height := Self.imgOrigin.Height
            + AHeightDistance;

  Self.sbClient.Prop.ContentWidth:=Self.sbClient.Prop.ContentWidth
            + AWidthDistance;
  Self.sbClient.Prop.ContentHeight:=Self.sbClient.Prop.ContentHeight
            + AHeightDistance;

end;

end.
