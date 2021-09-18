unit ChatCreatTime;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  uDrawCanvas,
  uSkinItems,

  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyLabel,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uBaseSkinControl,
  uSkinItemDesignerPanelType;

type
  TFrameChatCreatTime = class(TFrame)
    idpTime: TSkinFMXItemDesignerPanel;
    lblTime: TSkinFMXLabel;
    procedure idpTimePrepareDrawItem(Sender: TObject; ACanvas: TDrawCanvas;
      AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
      AItemDrawRect: TRectF);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  GlobalChatCreatTime:TFrameChatCreatTime;

implementation

{$R *.fmx}

procedure TFrameChatCreatTime.idpTimePrepareDrawItem(Sender: TObject;
  ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
  AItem: TSkinItem; AItemDrawRect: TRectF);
begin
  Self.lblTime.Width:=AItem.Tag1;
end;

end.
