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
//    //用于清理数据
//    procedure DoClear;override;
    //初始页面这个数据结构
    procedure InitPage(APage:uPageStructure.TPage);virtual;

    //自定义查询条件
    function GetCustomKeyJsonStr:String;virtual;
//    //自定义调用接口获取数据的查询条件
//    function CustomGetRestDatasetPageCustomWhereKeyJson:String;virtual;
    //自定义初始控件,比如ListView
    procedure CustomInitFieldControl(AControl:TComponent;AFieldControlSetting:TFieldControlSetting);virtual;

//    //Page加载数据结束事件
//    procedure DoLoadDataTaskEnd(Sender:TObject;
//                                 APageInstance:TPageInstance;
//                                 ADataIntfResult: TDataIntfResult;
//                                 ADataIntfResult2: TDataIntfResult
//                                 );
    //页面保存结束事件
    procedure DoPageInstanceAfterSaveRecord(Sender:TObject);virtual;

    procedure CustomInit;virtual;

  public
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
  public
//    //是否包含AppID字段
//    FHasAppID:Boolean;
//    //通用接口的rest_name
//    FRestName:String;
//    //主键字段名
//    FKeyFieldName:String;
//    //删除标记的字段名
//    FDeletedFieldName:String;
//    //表格列设置数组
//    FColumnsSettingArray:ISuperArray;
//    //加载数据时的查询条件
//    FWhereKeyJsonStr:String;

    //页面控件列表
    FPage:uPageStructure.TPage;

    FPageInstance:TPageInstance;

    FOnPageInstanceAfterSaveRecord:TNotifyEvent;

    procedure SyncButtonState;

    procedure Init;//(ACaption:String;
//                    AHasAppID:Boolean;
//                    //通用接口名
//                    ARestName:String;
//                    //加载数据时的查询条件
//                    AWhereKeyJsonStr:String;
//                    //主键字段名
//                    AKeyFieldName:String;
//                    //删除标记的字段名
//                    ADeletedFieldName:String;
//                    //表格列设置数组
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
  //取消
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
//  //编辑记录
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
//  //保存添加/修改
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


  //页面控件列表
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

//    //如果有选中,按回车表示确定选中
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
  //初始页面结构
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

  //初始页面结构
  InitPage(FPage);



  //创建输入区控件
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
