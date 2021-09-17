unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  XSuperObject,
  FMX.Controls.Presentation, FMX.Edit, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TForm3 = class(TForm)
    edtLongitude: TEdit;
    edtLatitude: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    IdHTTP1: TIdHTTP;
    ListView1: TListView;
    edtAddress: TEdit;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.Button1Click(Sender: TObject);
var
  AResponseStream:TStringStream;
  ASuperObject:ISuperObject;
  I: Integer;
  AListViewItem:TListViewItem;
begin
  AResponseStream:=TStringStream.Create('',TEncoding.Utf8);
  try

    //调用百度接口
    //把返回的数据放入AResponseStream
    Self.IdHTTP1.Get(
        'http://api.map.baidu.com/geocoder/v2/?'
        +'location='+Self.edtLatitude.Text+','+Self.edtLongitude.Text//'29.076777,119.649462'
        +'&output=json'
        +'&pois=1'
        +'&radius=100'
        +'&coordtype=gcj02ll'
        +'&ak='+'8dlnIKumxm6hAhkxs7OyCrg3',
        AResponseStream
        );


    //把AResponseStream中的数据解析成Json
    AResponseStream.Position:=0;
    ASuperObject:=TSuperObject.Create(AResponseStream.DataString);

    Self.edtAddress.Text:=ASuperObject.O['result'].S['formatted_address'];

    Self.ListView1.BeginUpdate;
    try
      for I := 0 to ASuperObject.O['result'].A['pois'].Length-1 do
      begin
        AListViewItem:=Self.ListView1.Items.Add;
        AListViewItem.Text:=ASuperObject.O['result'].A['pois'].O[I].S['name'];
      end;
    finally
      Self.ListView1.EndUpdate;
    end;

  finally
    AResponseStream.Free;
  end;
end;

end.
