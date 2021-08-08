unit BasePageFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Math,

  uFuncCommon,
  XSuperObject,
  uRestInterfaceCall,
  uManager,
  uDatasetToJson,
  uJsonToDataset,
  uOpenClientCommon,
  uOpenCommon,
  uTimerTask,
  SelectPopupForm,
  GridSwitchPageFrame,
  uPageStructure,
  uBasePageStructure,
  uDataInterface,
//  uTableCommonRestCenter,
  EasyServiceCommonMaterialDataMoudle_VCL,

  uSkinWindowsControl, uSkinButtonType, Vcl.ExtCtrls;

type
  TFrameBasePage = class(TFrame)
    pnlToolbar: TPanel;
    pnlBottombar: TPanel;
    btnSave: TSkinWinButton;
    pnlInput: TScrollBox;
    btnNew: TSkinWinButton;
    btnEdit: TSkinWinButton;
    btnCancel: TSkinWinButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSaveClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure pnlInputResize(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  protected

//    procedure DoFilter(AKeyword:String);override;
//    //������������
//    procedure DoClear;override;
    //��ʼҳ��������ݽṹ
    procedure InitPage(APage:uPageStructure.TPage);virtual;

    //�Զ����ѯ����
    function GetCustomKeyJsonStr:String;virtual;
//    //�Զ�����ýӿڻ�ȡ���ݵĲ�ѯ����
//    function CustomGetRestDatasetPageCustomWhereKeyJson:String;virtual;
    //�Զ����ʼ�ؼ�,����ListView
    procedure CustomInitFieldControl(AControl:TComponent;AFieldControlSetting:TFieldControlSetting);virtual;

//    //Page�������ݽ����¼�
//    procedure DoLoadDataTaskEnd(Sender:TObject;
//                                 APageInstance:TPageInstance;
//                                 ADataIntfResult: TDataIntfResult;
//                                 ADataIntfResult2: TDataIntfResult
//                                 );
    //ҳ�汣������¼�
    procedure DoPageInstanceAfterSaveRecord(Sender:TObject);virtual;

    procedure CustomInit;virtual;

  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
//    //�Ƿ����AppID�ֶ�
//    FHasAppID:Boolean;
//    //ͨ�ýӿڵ�rest_name
//    FRestName:String;
//    //�����ֶ���
//    FKeyFieldName:String;
//    //ɾ����ǵ��ֶ���
//    FDeletedFieldName:String;
//    //�������������
//    FColumnsSettingArray:ISuperArray;
//    //��������ʱ�Ĳ�ѯ����
//    FWhereKeyJsonStr:String;

    //ҳ��ؼ��б�
    FPage:uPageStructure.TPage;

    FPageInstance:TPageInstance;

    FOnPageInstanceAfterSaveRecord:TNotifyEvent;

    procedure SyncButtonState;

    procedure Init;//(ACaption:String;
//                    AHasAppID:Boolean;
//                    //ͨ�ýӿ���
//                    ARestName:String;
//                    //��������ʱ�Ĳ�ѯ����
//                    AWhereKeyJsonStr:String;
//                    //�����ֶ���
//                    AKeyFieldName:String;
//                    //ɾ����ǵ��ֶ���
//                    ADeletedFieldName:String;
//                    //�������������
//                    AColumnsSettingArray:ISuperArray);
//    procedure Load(ADataJson:ISuperObject);
    { Public declarations }
  end;





var
  FrameBasePage: TFrameBasePage;


implementation

{$R *.dfm}


procedure TFrameBasePage.btnCancelClick(Sender: TObject);
begin
  //ȡ��
  if Self.FPageInstance.FLoadDataSetting.IsAddRecord then
  begin
    Self.FPageInstance.CancelAddRecord;
  end;
  if Self.FPageInstance.FLoadDataSetting.IsEditRecord then
  begin
    Self.FPageInstance.CancelEditRecord;
  end;

  SyncButtonState;
end;

procedure TFrameBasePage.btnEditClick(Sender: TObject);
begin
//  //�༭��¼
//  Self.FPageInstance.FLoadDataSetting.IsAddRecord:=False;
//  Self.FPageInstance.FLoadDataSetting.IsEditRecord:=True;
//
////  Self.FPageInstance.MainControlMapList.ClearValue;

  Self.FPageInstance.BeginEditRecord();

  SyncButtonState;

end;

procedure TFrameBasePage.btnNewClick(Sender: TObject);
begin

//  Self.FPageInstance.FLoadDataSetting.IsAddRecord:=True;
//  Self.FPageInstance.MainControlMapList.ClearValue;
  Self.FPageInstance.BeginAddRecord();

  SyncButtonState;
end;

procedure TFrameBasePage.btnSaveClick(Sender: TObject);
begin
//  //�������/�޸�
//  Self.FPageInstance.DoSaveRecordAction(False);
//
//  Self.FPageInstance.FLoadDataSetting.IsAddRecord:=False;
//  Self.FPageInstance.FLoadDataSetting.IsEditRecord:=False;
//

  Self.FPageInstance.SaveRecord;

  SyncButtonState;
end;

constructor TFrameBasePage.Create(AOwner: TComponent);
begin
  inherited;

  GlobalMainProgramSetting.AppID:=AppID;

  GlobalDataInterfaceClass:=TTableCommonRestHttpDataInterface;


  //ҳ��ؼ��б�
  FPage:=uPageStructure.TPage.Create(nil);
  FPageInstance:=TPageInstance.Create;
  FPageInstance.PageStructure:=FPage;
  FPageInstance.FOnCustomInitFieldControl:=Self.CustomInitFieldControl;
//  FPageInstance.OnLoadDataTaskEnd:=DoLoadDataTaskEnd;
  Self.FPageInstance.FOnAfterSaveRecord:=DoPageInstanceAfterSaveRecord;

end;

destructor TFrameBasePage.Destroy;
begin
  FreeAndNil(FPage);
  inherited;
end;

procedure TFrameBasePage.DoPageInstanceAfterSaveRecord(Sender: TObject);
begin
  //
  if Assigned(FOnPageInstanceAfterSaveRecord) then
  begin
    FOnPageInstanceAfterSaveRecord(Self);
  end;
end;

//function TFrameBasePage.CustomGetRestDatasetPageCustomWhereKeyJson: String;
//begin
//  Result:='';
//end;

procedure TFrameBasePage.CustomInitFieldControl(AControl: TComponent;
  AFieldControlSetting: TFieldControlSetting);
begin

end;

procedure TFrameBasePage.CustomInit;
begin

end;

procedure TFrameBasePage.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;

  if Key=13 then
  begin

//    //�����ѡ��,���س���ʾȷ��ѡ��
//    if Assigned(OnSelectRecord) then
//    begin
//      OnSelectRecord(Sender,Self.RestMemTable1);
//    end;
//
//    HidePopup;


      Key:=0;
  end;
end;

function TFrameBasePage.GetCustomKeyJsonStr: String;
begin
  Result:='';
//  Result:=FWhereKeyJsonStr;
end;

procedure TFrameBasePage.InitPage(APage:uPageStructure.TPage);
begin
  //��ʼҳ��ṹ
  FPage.page_type:=Const_PageType_ListPage;
end;

procedure TFrameBasePage.Init;//(ACaption:String;AHasAppID:Boolean;
//                                  ARestName: String;
//                                  AWhereKeyJsonStr:String;
//                                  AKeyFieldName:String;
//                                  ADeletedFieldName:String;
//                                  AColumnsSettingArray:ISuperArray;
//                                  APage:TPage);
var
  ADesc:String;
//var
//  I: Integer;
////  AColumnSettingJson:ISuperObject;
//  AFieldControlSetting:TFieldControlSetting;
begin

//  Caption:=ACaption;
//
//  FHasAppID:=AHasAppID;
//  FRestName:=ARestName;
//  FWhereKeyJsonStr:=AWhereKeyJsonStr;
//  FKeyFieldName:=AKeyFieldName;
//  FDeletedFieldName:=ADeletedFieldName;
//  FColumnsSettingArray:=AColumnsSettingArray;

  //��ʼҳ��ṹ
  InitPage(FPage);



  //�����������ؼ�
  if not Self.FPageInstance.CreateControls(Self,Self.pnlInput,'','',False,ADesc,True) then
  begin
    ShowMessage(ADesc);
    Exit;
  end;
  FPageInstance.MainControlMapList.AlignControls();
  Self.pnlInput.Height:=FPageInstance.MainControlMapList.FListLayoutsManager.CalcContentHeight;


  Self.CustomInit;

  Self.SyncButtonState;
end;

procedure TFrameBasePage.pnlInputResize(Sender: TObject);
begin
  if FPageInstance<>nil then
  begin
    FPageInstance.MainControlMapList.AlignControls();
  end;
end;

procedure TFrameBasePage.SyncButtonState;
begin

  Self.btnNew.Enabled:=not (Self.FPageInstance.FLoadDataSetting.IsAddRecord or Self.FPageInstance.FLoadDataSetting.IsEditRecord);

  Self.btnEdit.Enabled:=not (Self.FPageInstance.FLoadDataSetting.IsAddRecord or Self.FPageInstance.FLoadDataSetting.IsEditRecord);

  Self.btnSave.Enabled:=Self.FPageInstance.FLoadDataSetting.IsAddRecord
                        or Self.FPageInstance.FLoadDataSetting.IsEditRecord;

  Self.btnCancel.Enabled:=Self.FPageInstance.FLoadDataSetting.IsAddRecord
                        or Self.FPageInstance.FLoadDataSetting.IsEditRecord;


  Self.btnNew.Invalidate;
  Self.btnEdit.Invalidate;
  Self.btnSave.Invalidate;
  Self.btnCancel.Invalidate;


//  Self.pnlInput.Enabled:=
  Self.FPageInstance.MainControlMapList.SetReadOnly(not Self.FPageInstance.FLoadDataSetting.IsAddRecord
                                                    and not Self.FPageInstance.FLoadDataSetting.IsEditRecord);

end;




end.
