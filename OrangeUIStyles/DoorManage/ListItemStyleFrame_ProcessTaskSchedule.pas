//convert pas to utf8 by ¥
unit ListItemStyleFrame_ProcessTaskSchedule;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,

  EasyServiceCommonMaterialDataMoudle,
  uSkinItems,
  uSkinVirtualListType,
  uSkinCustomListType,

  uDrawCanvas,
  XSuperObject,
  uSkinItemJsonHelper,

  uSkinFireMonkeyControl, uSkinItemDesignerPanelType,
  uSkinFireMonkeyItemDesignerPanel, uSkinLabelType, uSkinFireMonkeyLabel,
  uSkinPanelType, uSkinFireMonkeyPanel, uSkinCheckBoxType,
  uSkinFireMonkeyCheckBox, uSkinButtonType, uSkinFireMonkeyButton,
  uSkinMultiColorLabelType, uSkinFireMonkeyMultiColorLabel, uSkinImageType,
  uSkinFireMonkeyImage;


type
  TFrameListItemStyle_ProcessTaskSchedule = class(TFrame,IFrameBaseListItemStyle)
    ItemDesignerPanel: TSkinFMXItemDesignerPanel;
    SkinFMXMultiColorLabel1: TSkinFMXMultiColorLabel;
    lblError: TSkinFMXLabel;
    lblBillNO: TSkinFMXLabel;
    pnlClient: TSkinFMXPanel;
    lblSchedule: TSkinFMXLabel;
    SkinFMXLabel5: TSkinFMXLabel;
    pnlDetail: TSkinFMXPanel;
    SkinFMXLabel10: TSkinFMXLabel;
    lblStyle: TSkinFMXLabel;
    SkinFMXLabel3: TSkinFMXLabel;
    SkinFMXLabel4: TSkinFMXLabel;
    procedure ItemDesignerPanelPrepareDrawItem(Sender: TObject;
      ACanvas: TDrawCanvas; AItemDesignerPanel: TSkinItemDesignerPanel;
      AItem: TSkinItem; AItemDrawRect: TRectF);
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



{ TFrameListItemStyleFrame_ProcessTaskSchedule }

constructor TFrameListItemStyle_ProcessTaskSchedule.Create(AOwner: TComponent);
begin
  inherited;

  //ListBox在绘制的时候会对ItemDesignerPanel进行SetSize,
  //避免Client拉伸不了
  ItemDesignerPanel.Align:=TAlignLayout.None;
end;

function TFrameListItemStyle_ProcessTaskSchedule.GetItemDesignerPanel: TSkinItemDesignerPanel;
begin
  Result:=ItemDesignerPanel;
end;

procedure TFrameListItemStyle_ProcessTaskSchedule.ItemDesignerPanelPrepareDrawItem(
  Sender: TObject; ACanvas: TDrawCanvas;
  AItemDesignerPanel: TSkinItemDesignerPanel; AItem: TSkinItem;
  AItemDrawRect: TRectF);
//var
//  AItemDataJson:ISuperObject;
begin
    inherited;

//    if AItem.Json=nil then Exit;

    if AItem.Json.S['进度'] = '' then
    begin
      Self.lblSchedule.Visible:=False;
    end
    else
    begin
      Self.lblSchedule.Visible:=True;
    end;

    if AItem.Json.S['异常'] = '' then
    begin
      Self.lblError.Visible:=False;
    end
    else
    begin
      Self.lblError.Visible:=True;
    end;

    if (lblBillNO<>nil)
      and (lblSchedule<>nil)
      and (pnlDetail<>nil)
      and (lblError<>nil) then
    begin
      lblBillNO.Position.Y:=0;

      if Self.lblSchedule.Visible = True then
      begin
        lblSchedule.Position.Y:=
                lblSchedule.Margins.Top
                +lblBillNO.Position.Y
                +lblBillNO.Height;

        pnlDetail.Position.Y:=
                pnlDetail.Margins.Top
                +lblSchedule.Position.Y
                +lblSchedule.Height;
      end
      else
      begin
        pnlDetail.Position.Y:=
                pnlDetail.Margins.Top
                +lblBillNO.Position.Y
                +lblBillNO.Height;
      end;

      lblError.Position.Y:=
              lblError.Margins.Top
              +pnlDetail.Position.Y
              +pnlDetail.Height;
    end;

end;

initialization
  RegisterListItemStyle('ProcessTaskSchedule',TFrameListItemStyle_ProcessTaskSchedule,-1,True);

finalization
  UnRegisterListItemStyle(TFrameListItemStyle_ProcessTaskSchedule);

end.
