//convert pas to utf8 by ¥

unit ScrollControlFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uDrawCanvas,
  uSkinFireMonkeyControl, uSkinFireMonkeyScrollControl, uSkinFireMonkeyImage,
  uSkinFireMonkeyPanel, FMX.Layouts, FMX.ExtCtrls, FMX.TabControl,
  FMX.Controls.Presentation, uSkinScrollControlType, uSkinImageType,
  uBaseSkinControl, uSkinPanelType;

type
  TFrameScrollControl = class(TFrame)
    SkinFMXPanel1: TSkinFMXPanel;
    SkinFMXImage1: TSkinFMXImage;
    SkinFMXScrollControl1: TSkinFMXScrollControl;
    procedure SkinFMXScrollControl1PaintContent(ACanvas: TDrawCanvas;
      const ADrawRect: TRectF);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}


procedure TFrameScrollControl.SkinFMXScrollControl1PaintContent(
  ACanvas: TDrawCanvas; const ADrawRect: TRectF);
begin
  //引用uDrawCanvas
  //绘制图片
  ACanvas.FCanvas.DrawBitmap(
    Self.SkinFMXImage1.Properties.Picture,
    RectF(0,0,
          Self.SkinFMXImage1.Properties.Picture.Width,
          Self.SkinFMXImage1.Properties.Picture.Height),
    RectF(ADrawRect.Left,ADrawRect.Top,
          ADrawRect.Left+Self.SkinFMXImage1.Properties.Picture.Width,
          ADrawRect.Top+Self.SkinFMXImage1.Properties.Picture.Height),
    1
    );
end;

end.
