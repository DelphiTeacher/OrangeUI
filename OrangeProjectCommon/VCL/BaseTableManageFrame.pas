unit BaseTableManageFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, BasePageFrame, uSkinWindowsControl, Math,

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

  uSkinButtonType, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  dxDateRanges, Data.DB, cxDBData, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, uRestIntfMemTable;

type
  TFrameBaseTableManagePage = class(TFrameBasePage)
    DataSource1: TDataSource;
    RestMemTable1: TRestMemTable;
    cxGrid1: TcxGrid;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    btnRefresh: TSkinWinButton;
    btnSaveGrid: TSkinWinButton;
    btnDelete: TSkinWinButton;
    Splitter1: TSplitter;
    procedure RestMemTable1AfterInsert(DataSet: TDataSet);
    procedure RestMemTable1BeforeDelete(DataSet: TDataSet);
    procedure RestMemTable1GetRestDatasetPage(Sender: TObject;
      var ACallAPIResult: Boolean; var ACode: Integer; var ADesc: string;
      var ADataJson: ISuperObject);
    procedure btnSaveGridClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure cxGrid1DBTableView1CellClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  protected

    procedure CustomInit;override;
    //�Զ����ֶ�
    procedure InitFieldDefs;virtual;
    //�Զ�������
    procedure InitColumns;virtual;
    //�����Ӽ�¼ʱ��ʼ���ݼ��ֶ�ֵ
    procedure CustomDatasetAfterInsert(Sender:TObject;ADataset:TDataset);virtual;
    //�Զ�����ýӿڻ�ȡ���ݵĲ�ѯ����
    function CustomGetRestDatasetPageCustomWhereKeyJson:String;virtual;

    //ҳ�汣������¼�
    procedure DoPageInstanceAfterSaveRecord(Sender:TObject);override;

  public
    FRecordList:ISuperArray;
    //��ҳ���ƿؼ�
    FGridSwitchPageFrame:TFrameGridSwitchPage;

  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    { Public declarations }
  end;




var
  FrameBaseTableManagePage: TFrameBaseTableManagePage;

function SaveDatasetToServer(AAppID:Integer;ADataset:TDataset;
                             ARecordList:ISuperArray;
                             AKeyFieldName:String;
                             ARestName:String;
                             AHasAppID:Boolean;
                             var ADesc:String):Boolean;

implementation

{$R *.dfm}


function SaveDatasetToServer(AAppID:Integer;ADataset:TDataset;
                             ARecordList:ISuperArray;
                             AKeyFieldName:String;
                             ARestName:String;
                             AHasAppID:Boolean;
                             var ADesc:String):Boolean;
var
  AIsAdd:Boolean;
  ABookmark:TBookmark;
  ARecordJson:ISuperObject;
  ADataJson:ISuperObject;
  AKeyFieldValue:Variant;
begin
  //����
  //����
  ABookmark:=ADataset.GetBookmark;
  ADataset.DisableControls;
  try
    ADataset.First;

    while not ADataset.Eof do
    begin

        if ADataset.FieldByName(AKeyFieldName).IsNull then
        begin
            //����ӵ�����

            ARecordJson:=JsonFromRecord(ADataset,nil,False);

            //��ҳ���¼���浽�����
            if not SaveRecordToServer(InterfaceUrl,
                                      AAppID,
                                      '',
                                      '',
                                      ARestName,
                                      0,
                                      ARecordJson,
                                      //�����Ƿ��������ļ�¼
                                      AIsAdd,
                                      ADesc,
                                      ADataJson,
                                      GlobalRestAPISignType,
                                      GlobalRestAPIAppSecret,
                                      AHasAppID) then
            begin
              Exit;
            end;

            ADataset.Edit;
            LoadRecordFromJson(ADataset,ADataJson);
            ADataset.Post;


        end
        else
        begin
            //�޸ĵļ�¼
            AKeyFieldValue:=ADataset.FieldByName(AKeyFieldName).AsVariant;
            ARecordJson:=LocateJsonArray(ARecordList,AKeyFieldName,AKeyFieldValue);

            if (ARecordJson<>nil) and not CompareRecordAndJsonIsSame(ADataset,ARecordJson) then
            begin
                ARecordJson:=JsonFromRecord(ADataset,nil,False);


                //��ҳ���¼���浽�����
                if not SaveRecordToServer(InterfaceUrl,
                                          AAppID,
                                          '',
                                          '',
                                          ARestName,
                                          AKeyFieldValue,
                                          ARecordJson,
                                          //�����Ƿ��������ļ�¼
                                          AIsAdd,
                                          ADesc,
                                          ADataJson,
                                          GlobalRestAPISignType,
                                          GlobalRestAPIAppSecret,
                                          AHasAppID) then
                begin
                  Exit;
                end;


                ADataset.Edit;
                LoadRecordFromJson(ADataset,ADataJson);
                ADataset.Post;

            end;

        end;


        ADataset.Next;

    end;

    Result:=True;

  finally
    ADataset.EnableControls;
    ADataset.Bookmark:=ABookmark;
  end;

end;



procedure TFrameBaseTableManagePage.btnDeleteClick(Sender: TObject);
begin
  inherited;

  //ɾ��
  Self.RestMemTable1.Delete;

end;

procedure TFrameBaseTableManagePage.btnRefreshClick(Sender: TObject);
begin
  inherited;

  //ˢ��
  RestMemTable1.Refresh;

//  Self.FPageInstance.LoadData(FPageInstance.FLoadDataSetting);
end;

procedure TFrameBaseTableManagePage.btnSaveClick(Sender: TObject);
begin
  inherited;
//  //��ӻ����޸ı���¼
//  Self.FPageInstance.FLoadDataSetting


end;

procedure TFrameBaseTableManagePage.btnSaveGridClick(Sender: TObject);
var
  ADesc:String;
begin
  inherited;
  //ȫ������
  if not SaveDatasetToServer(AppID,
                              Self.RestMemTable1,
                              Self.FRecordList,
                              FPage.DataInterface.FKeyFieldName,
                              FPage.DataInterface.Name,//FRestName,
                              FPage.DataInterface.FHasAppID,
                              ADesc) then
  begin
    ShowMessage(ADesc);
    Exit;
  end;

end;

constructor TFrameBaseTableManagePage.Create(AOwner: TComponent);
begin
  inherited;


  FGridSwitchPageFrame:=TFrameGridSwitchPage.Create(Self);
  FGridSwitchPageFrame.Parent:=Self;
  FGridSwitchPageFrame.Align:=alBottom;
  FGridSwitchPageFrame.Visible:=True;
  FGridSwitchPageFrame.Load(RestMemTable1);


  Self.cxGrid1DBTableView1.OptionsView.NoDataToDisplayInfoText:='';


  //��ṹ�Ѿ�������,ÿ�λ�ȡ����֮����Ҫ�ؽ���
  RestMemTable1.IsNeedReCreateFieldDefs:=False;


end;

procedure TFrameBaseTableManagePage.CustomDatasetAfterInsert(Sender: TObject;
  ADataset: TDataset);
begin

end;

function TFrameBaseTableManagePage.CustomGetRestDatasetPageCustomWhereKeyJson: String;
begin
  Result:='';

end;

procedure TFrameBaseTableManagePage.CustomInit;
var
  I: Integer;
  AColumn:TcxGridDBColumn;
//  AColumnSettingJson:ISuperObject;
  AFieldControlSetting:TFieldControlSetting;
begin
  inherited;

  //��ʼ�����
  if Self.cxGrid1DBTableView1.ColumnCount=0 then
  begin

      //��ʼ�ֶ�
      InitFieldDefs;


      InitColumns;
//      if (Self.FColumnsSettingArray=nil) then
//      begin
//        Exit;
//      end;

      //����Ҫ�༭���ֶ���ʾ����
      for I := 0 to Self.cxGrid1DBTableView1.ColumnCount-1 do
      begin
        AColumn:=Self.cxGrid1DBTableView1.Columns[I];

        AFieldControlSetting:=Self.FPage.MainLayoutControlList.FindByFieldName(AColumn.DataBinding.FieldName);
//        AColumnSettingJson:=LocateJsonArray(FColumnsSettingArray,'field_name',AColumn.DataBinding.FieldName);
//        if AColumnSettingJson=nil then
//        begin
//          AColumn.Visible:=False;
//          Continue;
//        end;
        if AFieldControlSetting=nil then
        begin
          AColumn.Visible:=False;
          Continue;
        end;

//        AColumn.Visible:=(AColumnSettingJson.I['visible']=1);
//        AColumn.Editing:=(AColumnSettingJson.I['readonly']=0);
//        AColumn.Width:=AColumnSettingJson.I['Width'];
//        AColumn.Caption:=AColumnSettingJson.S['caption'];
        AColumn.Visible:=(AFieldControlSetting.col_visible=1);
        AColumn.Editing:=(AFieldControlSetting.readonly=0);
        AColumn.Width:=Ceil(AFieldControlSetting.col_Width);
        AColumn.Caption:=AFieldControlSetting.field_caption;

      end;
  end;


  //��ȡ����
  RestMemTable1.Refresh;


end;

procedure TFrameBaseTableManagePage.cxGrid1DBTableView1CellClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
var
  ARecordDataJson:ISuperObject;
begin
  inherited;

  ARecordDataJson:=JsonFromRecord(Self.RestMemTable1);
  Self.FPageInstance.LoadDataJsonToControls(ARecordDataJson);

end;

destructor TFrameBaseTableManagePage.Destroy;
begin

  inherited;
end;

procedure TFrameBaseTableManagePage.DoPageInstanceAfterSaveRecord(
  Sender: TObject);
begin
  inherited;
  if Self.FPageInstance.FLoadDataSetting.IsAddRecord then
  begin
    Self.RestMemTable1.Append;
  end
  else
  begin
    Self.RestMemTable1.Edit;
  end;
  try
    uJsonToDataset.LoadRecordFromJson(Self.RestMemTable1,Self.FPageInstance.FSaveDataIntfResult.DataJson)
  finally
    Self.RestMemTable1.Post;
  end;
end;

procedure TFrameBaseTableManagePage.InitColumns;
begin
  //�������е���
  Self.cxGrid1DBTableView1.DataController.CreateAllItems();


end;

procedure TFrameBaseTableManagePage.InitFieldDefs;
var
  ACode:Integer;
  ADesc:String;
  ADataJson:ISuperObject;
begin
  //��ȡ�ֶ��б�
  if not SimpleCallAPI('get_field_list',
                       nil,
                       TableRestCenterInterfaceUrl,
                      ['appid',
                      'rest_name'
                      ],
                      [AppID,
                      FPage.DataInterface.Name//FRestName
                      ],
                      ACode,
                      ADesc,
                      ADataJson,
                      GlobalRestAPISignType,
                      GlobalRestAPIAppSecret
                      ) or (ACode<>SUCC) then
  begin
    ShowMessage(ADesc);
    Exit;
  end;

  //if ADataJson.A['RecordList'] then
  LoadMemTableFeildDefsByFieldDefArray(Self.RestMemTable1,ADataJson.A['FieldList']);



end;

procedure TFrameBaseTableManagePage.RestMemTable1AfterInsert(DataSet: TDataSet);
begin
  inherited;
  CustomDatasetAfterInsert(Self,DataSet);

end;

procedure TFrameBaseTableManagePage.RestMemTable1BeforeDelete(
  DataSet: TDataSet);
var
  AIsAdd:Boolean;
  ADesc:String;
  ARecordJson:ISuperObject;
  ADataJson:ISuperObject;
  AKeyFieldValue:Variant;
begin

  inherited;

  if not Dataset.FieldByName(FPage.DataInterface.FKeyFieldName).IsNull then
  begin

    //��¼��ɾ��������
    AKeyFieldValue:=Dataset.FieldByName(FPage.DataInterface.FKeyFieldName).AsVariant;
    ARecordJson:=LocateJsonArray(FRecordList,FPage.DataInterface.FKeyFieldName,AKeyFieldValue);
    //���Ϊ��ɾ��
    ARecordJson.I[FPage.DataInterface.FDeletedFieldName]:=1;


    //ֱ��ɾ��
    //��ҳ���¼���浽�����
    if not SaveRecordToServer(InterfaceUrl,
                              AppID,
                              '',
                              '',
                              FPage.DataInterface.Name,//FRestName,
                              AKeyFieldValue,
                              ARecordJson,
                              AIsAdd,
                              ADesc,
                              ADataJson,
                              GlobalRestAPISignType,
                              GlobalRestAPIAppSecret,
                              FPage.DataInterface.FHasAppID
                              ) then
    begin
      Exit;
    end;

  end;

end;

procedure TFrameBaseTableManagePage.RestMemTable1GetRestDatasetPage(
  Sender: TObject; var ACallAPIResult: Boolean; var ACode: Integer;
  var ADesc: string; var ADataJson: ISuperObject);
begin
  inherited;
  FPageInstance.FLoadDataSetting.Clear;
  FPageInstance.FLoadDataSetting.PageIndex:=Self.RestMemTable1.PageIndex;
  FPageInstance.FLoadDataSetting.PageSize:=Self.RestMemTable1.PageSize;

  FPageInstance.FLoadDataSetting.CustomWhereKeyJson:=CustomGetRestDatasetPageCustomWhereKeyJson;//GetWhereKeyJson(['Zgdm','is_deleted'],[GlobalManager.User.fid,0]);

  FPageInstance.LoadData(FPageInstance.FLoadDataSetting,False);

//  RestMemTable1.EmptyDataSet;
//
//  if ADataIntfResult.Succ then
//  begin
//    FRecordList:=ADataIntfResult.DataJson.A['RecordList'];
//
////    LoadDataFromJsonArray(Self.RestMemTable1,ADataIntfResult.DataJson.A['RecordList']);
////    LoadDataJsonTokbmMemTable(Self.RestMemTable1,ADataIntfResult.DataJson,'RecordList');
//
//
//    Self.RestMemTable1.LoadDataIntfResult(ADataIntfResult.DataJson,False);
//  end;

  ACallAPIResult:=FPageInstance.FLoadDataIntfResult.Succ;
  ADesc:=FPageInstance.FLoadDataIntfResult.Desc;
  ADataJson:=FPageInstance.FLoadDataIntfResult.DataJson;


  if FPageInstance.FLoadDataIntfResult.Succ then
  begin
    FRecordList:=FPageInstance.FLoadDataIntfResult.DataJson.A['RecordList'];
    ACode:=SUCC;

//    LoadDataFromJsonArray(Self.RestMemTable1,ADataIntfResult.DataJson.A['RecordList']);
//    LoadDataJsonTokbmMemTable(Self.RestMemTable1,ADataIntfResult.DataJson,'RecordList');


//    Self.RestMemTable1.LoadDataIntfResult(ADataIntfResult.DataJson,False);
  end
  else
  begin
      ACode:=FAIL;

  end;


end;

end.
