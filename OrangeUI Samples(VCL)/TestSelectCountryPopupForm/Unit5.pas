unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  uSelectCountryComboBoxFrame,
  IOUtils,
  StrUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uSkinWindowsControl, uSkinImageType,
  uDrawCanvas, uSkinItems, uSkinScrollControlType, uSkinCustomListType,
  uSkinVirtualListType, uSkinListViewType;

type
  TForm5 = class(TForm)
    SkinWinImage1: TSkinWinImage;
    SkinWinListView1: TSkinWinListView;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    FSelectCountryComboBoxFrame:TFrameSelectCountryComboBox;
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.FormCreate(Sender: TObject);
var
  ARCList:TStringList;
  AFiles:TArray<String>;
  I: Integer;
  AFileName:String;
begin
  FSelectCountryComboBoxFrame:=TFrameSelectCountryComboBox.Create(Self);
  FSelectCountryComboBoxFrame.Parent:=Self;


  //将图片做成RC
  ARCList:=TStringList.Create;
  try
    AFiles:=TDirectory.GetFiles('C:\MyFiles\OrangeUI Samples(VCL)\TestSelectCountryPopupForm\country_icons\');

    //RC文件
    ARCList.Add('CFGJson_countrydata RCDATA "CFGJson_countrydata.json"');

    for I := 0 to Length(AFiles)-1 do
    begin
      AFileName:=ExtractFileName(AFiles[I]);
      if pos('.png',AFileName)>0 then
      begin
        AFileName:=ReplaceStr(AFileName,'.png','');
        //RC文件
        ARCList.Add('country_icon_'+AFileName+' RCDATA '+'"'+AFileName+'.png"');
      end;

    end;

    ARCList.SaveToFile('C:\MyFiles\OrangeUI Samples(VCL)\TestSelectCountryPopupForm\country_icons\country_icons.rc');

  finally
    FreeAndNil(ARCList);
  end;

end;

end.
