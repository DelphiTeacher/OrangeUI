//convert pas to utf8 by ¥

unit DateEditFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.DateTimeCtrls, uSkinFireMonkeyDateEdit, FMX.Controls.Presentation,
  uSkinFireMonkeyTimeEdit, uSkinFireMonkeyControl, uSkinFireMonkeyPanel;

type
  TFrameDateEdit = class(TFrame)
    SkinFMXDateEdit1: TSkinFMXDateEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
