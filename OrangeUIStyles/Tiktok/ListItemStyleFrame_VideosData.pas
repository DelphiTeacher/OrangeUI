unit ListItemStyleFrame_VideosData;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,

  uSkinCustomListType,
  EasyServiceCommonMaterialDataMoudle,
  uSkinFireMonkeyItemDesignerPanel, uSkinImageType, uSkinFireMonkeyImage,
  uSkinLabelType, uSkinFireMonkeyLabel, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinMaterial;

type
  TFrameListItemStyle_VideosData = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    pnlTitle: TSkinFMXPanel;
    lblDataName: TSkinFMXLabel;
    lblSubscribeSetting: TSkinFMXLabel;
    pnlContainer: TSkinFMXPanel;
    btnFromShop: TSkinFMXButton;
    btnUnread: TSkinFMXButton;
    btnFromKeyWord: TSkinFMXButton;
    procedure pnlContainerResize(Sender: TObject);
  private
    { Private declarations }
  public
    function GetItemDesignerPanel:TSkinItemDesignerPanel;virtual;
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameListItemStyle_VideosData }

function TFrameListItemStyle_VideosData.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;



procedure TFrameListItemStyle_VideosData.pnlContainerResize(Sender: TObject);
begin
  //
  btnFromShop.Width:=pnlContainer.Width / 3;
  btnFromKeyWord.Width:=pnlContainer.Width / 3;
  btnUnread.Width:=pnlContainer.Width / 3;

end;

initialization
  RegisterListItemStyle('VideosData',TFrameListItemStyle_VideosData);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_VideosData);

end.
