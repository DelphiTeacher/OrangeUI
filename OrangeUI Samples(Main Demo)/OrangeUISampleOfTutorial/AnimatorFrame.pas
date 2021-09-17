//convert pas to utf8 by ¥

unit AnimatorFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, uSkinFireMonkeyControl, uSkinFireMonkeyLabel, FMX.Objects, FMX.ListBox,
  uSkinAnimator, FMX.Controls.Presentation, uBaseSkinControl, uSkinLabelType;

type
  TFrameAnimator = class(TFrame)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    PaintBox1: TPaintBox;
    SkinFMXLabel14: TSkinFMXLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ControlMoveAnimator: TSkinControlMoveAnimator;
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ControlMoveAnimatorAnimate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}


procedure TFrameAnimator.Button1Click(Sender: TObject);
begin
  Self.ComboBox1Change(Self);
  Self.ComboBox2Change(Self);

  ControlMoveAnimator.GoForward;
end;

procedure TFrameAnimator.Button2Click(Sender: TObject);
begin
  ControlMoveAnimator.GoBackward;
end;

procedure TFrameAnimator.Button3Click(Sender: TObject);
begin
  ControlMoveAnimator.Pause;
end;

procedure TFrameAnimator.Button4Click(Sender: TObject);
begin
  ControlMoveAnimator.Continue;
end;

procedure TFrameAnimator.Button5Click(Sender: TObject);
begin
  ControlMoveAnimator.Stop;
end;

procedure TFrameAnimator.ComboBox1Change(Sender: TObject);
begin
  ControlMoveAnimator.TweenType:=TTweenType(Self.ComboBox1.ItemIndex);
end;

procedure TFrameAnimator.ComboBox2Change(Sender: TObject);
begin
  ControlMoveAnimator.EaseType:=TEaseType(Self.ComboBox2.ItemIndex);
end;

procedure TFrameAnimator.ControlMoveAnimatorAnimate(Sender: TObject);
begin
  Self.PaintBox1.Repaint;
end;

procedure TFrameAnimator.PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
begin
  Canvas.Fill.Color:=TAlphaColorRec.Red;
  Canvas.Fill.Kind:=TBrushKind.Solid;
  Canvas.FillRect(RectF(ControlMoveAnimator.Position,0,ControlMoveAnimator.Position+30,Self.PaintBox1.Height),
                  0,0,[],1);

end;



end.
