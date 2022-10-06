unit BaiduMapFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
//  uBaseBaiduMapView,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls;

type
  TFrameBaiduMap = class(TFrame)
    tmrMapAlign: TTimer;
    procedure FrameResize(Sender: TObject);
    procedure tmrMapAlignTimer(Sender: TObject);
  private
//    FMapView:TBaseBaiduMapView;
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
    procedure CreateMapView;
    procedure DestroyMapView;
    procedure ShowMapView;
    procedure HideMapView;
    { Public declarations }
  end;

implementation

uses
  MainForm;

{$R *.fmx}

constructor TFrameBaiduMap.Create(AOwner: TComponent);
begin
  inherited;
end;

procedure TFrameBaiduMap.CreateMapView;
begin
//  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
//  FMapView:=TBaiduMapViewClassFactory.CreateMapView(Self);
//  //IOS下需要Key,Android下的Key是在XML中配置的
//  FMapView.InitSDK('ahYunc3V6VGRvPHenPSmThfM','');
//  FMapView.SetBounds(0,Self.Height,Width,Height);
//  FMapView.Parent:=Self;
//  FMapView.Align:=TAlignLayout.alClient;
//  FMapView.CreateMapView(frmMain);
//  FMapView.Realign;
//  {$ENDIF}

end;

destructor TFrameBaiduMap.Destroy;
begin
//  if FMapView<>nil then
//  begin
//    FMapView.HideMapView;
//    FMapView.DestroyMapView;
//    FreeAndNil(FMapView);
//  end;
  inherited;
end;

procedure TFrameBaiduMap.DestroyMapView;
begin
//  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
//  if FMapView<>nil then FMapView.DestroyMapView;
//  {$ENDIF}
end;

procedure TFrameBaiduMap.FrameResize(Sender: TObject);
begin
//  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
//  if FMapView<>nil then FMapView.Realign;
//  {$ENDIF}
end;

procedure TFrameBaiduMap.HideMapView;
begin
//  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
//  if FMapView<>nil then FMapView.HideMapView;
//  {$ENDIF}
end;

procedure TFrameBaiduMap.ShowMapView;
begin
//  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
//  if FMapView<>nil then FMapView.ShowMapView;
//  {$ENDIF}
end;

procedure TFrameBaiduMap.tmrMapAlignTimer(Sender: TObject);
begin
//  {$IF DEFINED(IOS) OR DEFINED(ANDROID)}
//  if Visible and (FMapView<>nil) and FMapView.IsMapViewVisible then
//  begin
//    FMapView.ReAlign;
//  end;
//  {$ENDIF}
end;

end.
