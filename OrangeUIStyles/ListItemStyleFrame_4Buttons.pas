//convert pas to utf8 by ¥
unit ListItemStyleFrame_4Buttons;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,
  EasyServiceCommonMaterialDataMoudle,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinImageType,
  uSkinFireMonkeyImage, uSkinButtonType, uSkinFireMonkeyButton, uSkinMaterial,
  uSkinPanelType, uSkinFireMonkeyPanel;


type
  //根基类
  TFrameListItemStyle_4Buttons = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    imgBackground: TSkinFMXImage;
    btnButton1: TSkinFMXButton;
    btnButton3: TSkinFMXButton;
    btnButton4: TSkinFMXButton;
    btnButton2: TSkinFMXButton;
    panelBackground: TSkinFMXPanel;
    procedure imgBackgroundResize(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;


implementation

{$R *.fmx}



{ TFrameBaseListItemStyle }

constructor TFrameListItemStyle_4Buttons.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_4Buttons.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

procedure TFrameListItemStyle_4Buttons.imgBackgroundResize(Sender: TObject);
begin
  panelBackground.Width:=trunc(imgBackground.Width/4*4);
  btnButton1.Width:=imgBackground.Width/4;
  btnButton3.Width:=imgBackground.Width/4;
  btnButton4.Width:=imgBackground.Width/4;
  btnButton2.Width:=imgBackground.Width/4;
end;


initialization
  RegisterListItemStyle('4Buttons',TFrameListItemStyle_4Buttons);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_4Buttons);

end.
