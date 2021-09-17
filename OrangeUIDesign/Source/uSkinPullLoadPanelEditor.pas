//convert pas to utf8 by ¥

unit uSkinPullLoadPanelEditor;

interface
 {$I FrameWork.inc}

uses
  Classes,
  uComponentType,
  SysConst,
//  uSkinPackage,
  uSkinPullLoadPanelType,
  uComponentTypeNameEditor,
  uSkinRegManager,
  Windows,
  CommCtrl,
  VCLEditors,
  DesignIntf,
  DesignEditors;

type
  TPullLoadPanelProperty = class(TComponentProperty)
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
  RegisterPropertyEditor(TypeInfo(TChildControl),TPullLoadPanelProperties,'LoadingImage',TPullLoadPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TPullLoadPanelProperties,'DecideLoadHintImage',TPullLoadPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TPullLoadPanelProperties,'LoadingLabel',TPullLoadPanelProperty);
//  RegisterPropertyEditor(TypeInfo(TChildControl),TPullLoadPanelProperties,'LastLoadingInfoLabel',TPullLoadPanelProperty);
end;




{ TPullLoadPanelProperty }

function TPullLoadPanelProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TPullLoadPanelProperty.GetValues(Proc: TGetStrProc);
var
  ASkinControlIntf:ISkinControl;
  ASkinControl:ISkinControl;
  List: IDesignerSelections;
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
    AddPropertySelectValue(ASkinControlIntf,IID_ISkinControl,ASkinControl,Proc);
  end
  else
  begin
    inherited GetValues(Proc);
    Exit;
  end;


end;

end.
