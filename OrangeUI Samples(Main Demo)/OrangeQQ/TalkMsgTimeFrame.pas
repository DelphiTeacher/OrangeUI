//convert pas to utf8 by ¥

unit TalkMsgTimeFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  QQCommonSkinMaterialFrame,


  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinFireMonkeyControl, uSkinFireMonkeyPanel, uSkinFireMonkeyLabel,
  uSkinLabelType, uSkinPanelType;

type
  TFrameTalkMsgTime = class(TFrame)
    pnlClient: TSkinFMXPanel;
    lblTime: TSkinFMXLabel;
  private
    { Private declarations }
  public
    procedure SetTime(ADateTime:TDateTime);
    { Public declarations }
  end;

implementation

{$R *.fmx}

{ TFrameTalkMsgTime }

procedure TFrameTalkMsgTime.SetTime(ADateTime: TDateTime);
begin
  //获取时间
  Self.lblTime.Caption:=FormatDateTime('HH:MM:SS',ADateTime);
end;

end.
