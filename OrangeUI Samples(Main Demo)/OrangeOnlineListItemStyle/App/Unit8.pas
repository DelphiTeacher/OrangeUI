unit Unit8;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,

  uUIFunction,
  ProcessTaskOrderListFrame,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs;

type
  TForm8 = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form8: TForm8;

implementation

{$R *.fmx}

procedure TForm8.FormShow(Sender: TObject);
begin
  ShowFrame(TFrame(GlobalProcessTaskOrderListFrame),TFrameProcessTaskOrderList);
  GlobalProcessTaskOrderListFrame.Load('我的工单',
                                        '',
                                        '',
                                        '',
                                        '',
                                        ''
                                        );
end;

end.
