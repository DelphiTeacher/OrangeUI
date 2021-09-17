unit TestAddPictureListSubFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 

  StrUtils,
  uUIFunction,
  AddPictureListSubFrame,

  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uSkinButtonType, uSkinFireMonkeyButton, uSkinFireMonkeyControl,
  uSkinScrollControlType, uSkinCustomListType, uSkinVirtualListType,
  uSkinListBoxType, uSkinFireMonkeyListBox;

type
  TFrameTestAddPictureListSub = class(TFrame)
    lbPictures: TSkinFMXListBox;
    btnAddPictureList: TSkinFMXButton;
    procedure btnAddPictureListClick(Sender: TObject);
  private
    FAddPictureListSubFrame:TFrameAddPictureListSub;
    procedure DoReturnFrameFromAddPictureListSubFrame(AFrame:TFrame);
    { Private declarations }
  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;

var
  GlobalTestAddPictureListSubFrame:TFrameTestAddPictureListSub;

implementation

{$R *.fmx}

procedure TFrameTestAddPictureListSub.btnAddPictureListClick(Sender: TObject);
var
  ANames:TStringDynArray;
  AUrls:TStringDynArray;
  I: Integer;
begin
  SetLength(ANames,Self.lbPictures.Prop.Items.Count);
  SetLength(AUrls,Self.lbPictures.Prop.Items.Count);
  for I := 0 to Self.lbPictures.Prop.Items.Count-1 do
  begin
    ANames[I]:=Self.lbPictures.Prop.Items[I].Caption;
    AUrls[I]:=Self.lbPictures.Prop.Items[I].Icon.Url;
  end;

  HideFrame(Self);
  ShowFrame(TFrame(FAddPictureListSubFrame),TFrameAddPictureListSub,DoReturnFrameFromAddPictureListSubFrame);
  FAddPictureListSubFrame.Init('…Ã∆∑Õº∆¨',ANames,AUrls,False,400,300,6);

end;

constructor TFrameTestAddPictureListSub.Create(AOwner: TComponent);
begin
  inherited;
  Self.lbPictures.Prop.Items.Clear();
end;

destructor TFrameTestAddPictureListSub.Destroy;
begin
  inherited;
end;

procedure TFrameTestAddPictureListSub.DoReturnFrameFromAddPictureListSubFrame(AFrame: TFrame);
var
  I: Integer;
  AUrls:TStringDynArray;
  ASkinListBoxItem:TSkinListBoxItem;
begin
  Self.lbPictures.Prop.Items.BeginUpdate;
  try
    AUrls:=FAddPictureListSubFrame.GetServerFileNameArray(6);
    for I := 0 to Length(AUrls)-1 do
    begin
      if AUrls[I]<>'' then
      begin
        ASkinListBoxItem:=Self.lbPictures.Prop.Items.Add;
        ASkinListBoxItem.Caption:=AUrls[I];
        ASkinListBoxItem.Icon.Url:=
                            'http://www.orangeui.cn:10001/'
                            +ReplaceStr(AUrls[I],'\','/');
      end;
    end;
  finally
    Self.lbPictures.Prop.Items.EndUpdate;
  end;
end;

end.
