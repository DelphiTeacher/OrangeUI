//convert pas to utf8 by ¥

unit uSkinScrollBarPullLoadPanelEditor;

interface
 {$I FrameWork.inc}

uses
  Classes,
  uComponentType,
  SysConst,
//  uSkinPackage,
  uSkinScrollBarType,
  uSkinPullLoadPanelType,
  uComponentTypeNameEditor,
  uSkinRegManager,
  Windows,
  CommCtrl,
  VCLEditors,
  DesignIntf,
  DesignEditors;

type
  TScrollBarPullLoadPanelProperty = class(TComponentProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

procedure Register;

implementation

uses
  TypInfo,
  SysUtils;


procedure Register;
begin
  //属性编辑器
  RegisterPropertyEditor(TypeInfo(TChildControl),
                          TScrollBarProperties,
                          'MinPullLoadPanel',
                          TScrollBarPullLoadPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),
                          TScrollBarProperties,
                          'MaxPullLoadPanel',
                          TScrollBarPullLoadPanelProperty);
end;




{ TScrollBarPullLoadPanelProperty }

function TScrollBarPullLoadPanelProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TScrollBarPullLoadPanelProperty.GetValues(Proc: TGetStrProc);
var
  ASkinControlIntf:ISkinControl;
  List: IDesignerSelections;
  ASkinPullLoadPanel:ISkinPullLoadPanel;
begin
  //把每个控件类型的可以ComponentType列出来
  //皮肤组件接口
  List := CreateSelectionList;
  if Designer<>nil then Designer.GetSelections(List);

  if (List.Count = 0) or (List.Count > 1) then
  begin
    inherited GetValues(Proc);
    Exit;
  end;

  if List[0].GetInterface(IID_ISkinControl,ASkinControlIntf) then
  begin
    //添加支持指定接口的控件及子控件
    AddPropertySelectValue(ASkinControlIntf,IID_ISkinPullLoadPanel,ASkinPullLoadPanel,Proc);
  end
  else
  begin
    inherited GetValues(Proc);
    Exit;
  end;

end;

end.
