//convert pas to utf8 by ¥

unit SetBackColorFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyButton, uBaseSkinControl,
  uSkinButtonType;

type
  TFrameSetBackColor = class(TFrame)
    SkinFMXButton1: TSkinFMXButton;
    SkinFMXButton2: TSkinFMXButton;
    SkinFMXButton3: TSkinFMXButton;
    btnSetColorByCode: TSkinFMXButton;
    procedure btnSetColorByCodeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses
  uDrawParam,
  uDrawTextParam;

procedure TFrameSetBackColor.btnSetColorByCodeClick(Sender: TObject);
begin

  SkinFMXButton3.Caption:='我是代码设置的按钮';

  //设置按钮为不透明
  SkinFMXButton3.SelfOwnMaterialToDefault.IsTransparent:=False;
  //按钮背景颜色填充
  SkinFMXButton3.SelfOwnMaterialToDefault.BackColor.IsFill:=True;
  //设置为圆角
  SkinFMXButton3.SelfOwnMaterialToDefault.BackColor.IsRound:=True;
  //按钮背景颜色设置为蓝色
  SkinFMXButton3.SelfOwnMaterialToDefault.BackColor.FillColor.Color:=TAlphaColorRec.Cornflowerblue;
  //按钮背景颜色鼠标点击效果
  SkinFMXButton3.SelfOwnMaterialToDefault.BackColor.DrawEffectSetting.MouseDownEffect.CommonEffectTypes
              :=[dpcetAlphaChange];
  //按钮标题字体设置为白色
  SkinFMXButton3.SelfOwnMaterialToDefault.DrawCaptionParam.FontColor:=TAlphaColorRec.White;
  SkinFMXButton3.SelfOwnMaterialToDefault.DrawCaptionParam.FontSize:=14;
  //按钮标题垂直居中
  SkinFMXButton3.SelfOwnMaterialToDefault.DrawCaptionParam.FontVertAlign:=TFontVertAlign.fvaCenter;
  //按钮标题水平居中
  SkinFMXButton3.SelfOwnMaterialToDefault.DrawCaptionParam.FontHorzAlign:=TFontHorzAlign.fhaCenter;
  //按钮标题鼠标点击效果
  SkinFMXButton3.SelfOwnMaterialToDefault.DrawCaptionParam.DrawEffectSetting.MouseDownEffect.CommonEffectTypes
              :=[dpcetAlphaChange];

end;

end.
