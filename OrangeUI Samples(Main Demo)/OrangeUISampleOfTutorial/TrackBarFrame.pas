//convert pas to utf8 by ¥

unit TrackBarFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  Math,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyTrackBar,
  uSkinFireMonkeyLabel, uSkinFireMonkeyButton, uSkinTrackBarType,
  uBaseSkinControl, uSkinLabelType;

type
  TFrameTrackBar = class(TFrame)
    lblTrackPosition1: TSkinFMXLabel;
    lblTrackPosition2: TSkinFMXLabel;
    lblTrackPosition3: TSkinFMXLabel;
    lblTrackPosition4: TSkinFMXLabel;
    lblTrackPosition5: TSkinFMXLabel;
    lblTrackPosition6: TSkinFMXLabel;
    tbTrackBar1: TSkinFMXTrackBar;
    tbTrackBar2: TSkinFMXTrackBar;
    tbTrackBar3: TSkinFMXTrackBar;
    tbTrackBar4: TSkinFMXTrackBar;
    tbTrackBar5: TSkinFMXTrackBar;
    tbTrackBar6: TSkinFMXTrackBar;
    SkinFMXTrackBar1: TSkinFMXTrackBar;
    procedure tbTrackBar1Change(Sender: TObject);
    procedure tbTrackBar2Change(Sender: TObject);
    procedure tbTrackBar3Change(Sender: TObject);
    procedure tbTrackBar4Change(Sender: TObject);
    procedure tbTrackBar5Change(Sender: TObject);
    procedure tbTrackBar6Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TFrameTrackBar.tbTrackBar1Change(Sender: TObject);
begin
  Self.lblTrackPosition1.Caption:=IntToStr(Ceil(tbTrackBar1.Properties.Position));

end;

procedure TFrameTrackBar.tbTrackBar2Change(Sender: TObject);
begin
  Self.lblTrackPosition2.Caption:=IntToStr(Ceil(tbTrackBar2.Properties.Position));

end;

procedure TFrameTrackBar.tbTrackBar3Change(Sender: TObject);
begin
  Self.lblTrackPosition3.Caption:=IntToStr(Ceil(tbTrackBar3.Properties.Position));

end;

procedure TFrameTrackBar.tbTrackBar4Change(Sender: TObject);
begin
  Self.lblTrackPosition4.Caption:=IntToStr(Ceil(tbTrackBar4.Properties.Position));

end;

procedure TFrameTrackBar.tbTrackBar5Change(Sender: TObject);
begin
  Self.lblTrackPosition5.Caption:=IntToStr(Ceil(tbTrackBar5.Properties.Position));

end;

procedure TFrameTrackBar.tbTrackBar6Change(Sender: TObject);
begin
  Self.lblTrackPosition6.Caption:=IntToStr(Ceil(tbTrackBar6.Properties.Position));

end;

end.
