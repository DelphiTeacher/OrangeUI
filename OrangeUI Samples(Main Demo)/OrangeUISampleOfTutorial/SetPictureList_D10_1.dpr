program SetPictureList_D10_1;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit12 in 'Unit12.pas' {Form12},
  ClipHeadFrame in '..\..\OrangeProjectCommon\CommonFrames\ClipHeadFrame.pas' {FrameClipHead: TFrame},
  uAPPCommon in '..\..\OrangeProjectCommon\uAPPCommon.pas',
  uNativeHttpControl in '..\..\OrangeProjectCommon\uNativeHttpControl.pas',
  uThumbCommon in '..\..\OrangeProjectCommon\uThumbCommon.pas',
  uUIFunction in '..\..\OrangeProjectCommon\uUIFunction.pas',
  XSuperJSON in '..\..\OrangeProjectCommon\XSuperObject\XSuperJSON.pas',
  XSuperObject in '..\..\OrangeProjectCommon\XSuperObject\XSuperObject.pas',
  TakePictureMenuFrame in '..\..\OrangeProjectCommon\CommonFrames\TakePictureMenuFrame.pas' {FrameTakePictureMenu: TFrame},
  TestAddPictureListSubFrame in 'TestAddPictureListSubFrame.pas' {FrameTestAddPictureListSub: TFrame},
  AddPictureListSubFrame in '..\..\OrangeProjectCommon\CommonFrames\AddPictureListSubFrame.pas' {FrameAddPictureListSub: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
