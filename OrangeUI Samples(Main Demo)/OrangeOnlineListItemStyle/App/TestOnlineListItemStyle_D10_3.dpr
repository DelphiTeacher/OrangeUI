program TestOnlineListItemStyle_D10_3;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit8 in 'Unit8.pas' {Form8},
  EasyServiceCommonMaterialDataMoudle in '..\..\..\OrangeProjectCommon\EasyServiceCommonMaterialDataMoudle.pas' {dmEasyServiceCommonMaterial: TDataModule},
  FMX.Platform.iOS in '..\..\..\OrangeProjectCommon\FMX.Platform.iOS.pas',
  FMX.FontGlyphs.iOS in '..\..\..\OrangeProjectCommon\FMX.FontGlyphs.iOS.pas',
  FMX.Context.GLES.iOS in '..\..\..\OrangeProjectCommon\FMX.Context.GLES.iOS.pas',
  ProcessTaskOrderListFrame in 'ProcessTaskOrderListFrame.pas',
  ListItemStyleFrame_ScanInStoreConfirm in '..\..\..\OrangeUIStyles\DoorManage\ListItemStyleFrame_ScanInStoreConfirm.pas' {FrameListItemStyle_ScanInStoreConfirm: TFrame},
  ListItemStyleFrame_ProcessTaskOrder in '..\..\..\OrangeUIStyles\DoorManage\ListItemStyleFrame_ProcessTaskOrder.pas' {FrameListItemStyle_ProcessTaskOrder: TFrame},
  ListItemStyleFrame_FinishedProcessTask in '..\..\..\OrangeUIStyles\DoorManage\ListItemStyleFrame_FinishedProcessTask.pas' {FrameListItemStyle_FinishedProcessTask: TFrame},
  ListItemStyleFrame_DefaultSelected in '..\..\..\OrangeUIStyles\ListItemStyleFrame_DefaultSelected.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmEasyServiceCommonMaterial, dmEasyServiceCommonMaterial);
  Application.CreateForm(TForm8, Form8);
  Application.Run;
end.
