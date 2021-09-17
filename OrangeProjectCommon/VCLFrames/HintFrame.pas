unit HintFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,

  uComponentType,

  Graphics, Controls, Forms, Dialogs;

type
  TFrame8 = class(TFrame)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowHintFrame(AParent:TParentControl;AHint:String;AChangeOpacityInterval:Integer=100);


implementation

{$R *.dfm}

procedure ShowHintFrame(AParent:TParentControl;AHint:String;AChangeOpacityInterval:Integer);
begin
  ShowMessage(AHint);
end;

end.
