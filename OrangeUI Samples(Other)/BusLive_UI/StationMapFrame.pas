﻿//convert pas to utf8 by ¥
unit StationMapFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  uUIFunction,
  uFrameContext,
//  BaiduMapFrame,
  BusLiveCommonSkinMaterialModule,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyButton, uSkinFireMonkeyControl, uSkinFireMonkeyPanel,
  uSkinButtonType, uSkinPanelType;

type
  TFrameStationMap = class(TFrame)
    pnlToolBar: TSkinFMXPanel;
    btnReturn: TSkinFMXButton;
    procedure btnReturnClick(Sender: TObject);
  private
//    FBaiduMapFrame:TFrameBaiduMap;
    { Private declarations }
  public
//    FrameHistroy:TFrameHistroy;
    procedure LoadData;
    procedure UnLoadData;
    { Public declarations }
  end;

var
  GlobalStationMapFrame:TFrameStationMap;

implementation

uses
  MainForm;

{$R *.fmx}

procedure TFrameStationMap.btnReturnClick(Sender: TObject);
begin
  UnLoadData;

  HideFrame;////(Self);
  ReturnFrame;//(FrameHistroy);
end;

procedure TFrameStationMap.LoadData;
begin
//  FBaiduMapFrame:=TFrameBaiduMap.Create(Self);
//  SetFrameName(FBaiduMapFrame);
//  FBaiduMapFrame.Parent:=Self;
//  FBaiduMapFrame.Align:=TAlignLayout.Client;
//  FBaiduMapFrame.SetBounds(0,Self.pnlToolBar.Height,Width,Height-Self.pnlToolBar.Height);
//  FBaiduMapFrame.CreateMapView;
end;

procedure TFrameStationMap.UnLoadData;
begin
//  FBaiduMapFrame.HideMapView;
//  FBaiduMapFrame.DestroyMapView;
//  FreeAndNil(FBaiduMapFrame);
end;

end.