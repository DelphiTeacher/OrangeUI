//convert pas to utf8 by ¥

unit uSkinItemDeignerPanelEditor;

interface
 {$I FrameWork.inc}

uses
  Classes,
  SysConst,
  Windows,
  {$IFDEF VCL}
  Controls,
  {$ENDIF}
  {$IFDEF FMX}
  FMX.Controls,
  {$ENDIF}

  uSkinItemDesignerPanelType,
  uComponentTypeNameEditor,
  uSkinRegManager,
  uComponentType,
//  uSkinPackage,

  VCLEditors,
  CommCtrl,
  ColnEdit,
  ToolWnds,
  DesignIntf,
  DesignEditors;



type
  //设置面板的BindingControl属性编辑器
  TItemDeignerPanelProperty = class(TComponentProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TItemBindingStringsControlsProperty = class(TCollectionProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;



procedure Register;

implementation

uses
  TypInfo,
  SysUtils;


procedure Register;
begin
  //属性编辑器
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemCaptionBindingControl',TItemDeignerPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemDetailBindingControl',TItemDeignerPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemDetail1BindingControl',TItemDeignerPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemDetail2BindingControl',TItemDeignerPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemDetail3BindingControl',TItemDeignerPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemDetail4BindingControl',TItemDeignerPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemDetail5BindingControl',TItemDeignerPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemDetail6BindingControl',TItemDeignerPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemIconBindingControl',TItemDeignerPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemPicBindingControl',TItemDeignerPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemCheckedBindingControl',TItemDeignerPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemExpandedBindingControl',TItemDeignerPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemSelectedBindingControl',TItemDeignerPanelProperty);
  RegisterPropertyEditor(TypeInfo(TChildControl),TItemDesignerPanelProperties,'ItemAccessoryMoreBindingControl',TItemDeignerPanelProperty);

  RegisterPropertyEditor(TypeInfo(TChildControl),TItemBindingStringsControlItem,'BindingControl',TItemDeignerPanelProperty);

  RegisterPropertyEditor(TypeInfo(TItemBindingStringsControls),
                          TItemDesignerPanelProperties,
                          'ItemStringsBindingControlCollection',
                          TItemBindingStringsControlsProperty);


end;




{ TItemDeignerPanelProperty }


function TItemDeignerPanelProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList];
end;

procedure TItemDeignerPanelProperty.GetValues(Proc: TGetStrProc);
var
  ASkinControlIntf:ISkinControl;
  ASkinControl:ISkinControl;
  List: IDesignerSelections;
begin
  //把每个控件类型的可以ComponentType列出来
  //皮肤组件接口
  List := CreateSelectionList;
  if Designer<>nil then
  begin
    Designer.GetSelections(List);
  end;


  if (List.Count = 0) or (List.Count > 1) then
  begin
    inherited GetValues(Proc);
    Exit;
  end;


  //ItemDesignerPanel的属性
  if List[0] is TControl then
  begin
    if List[0].GetInterface(IID_ISkinControl,ASkinControlIntf) then
    begin
      AddPropertySelectValue(ASkinControlIntf,
                              IID_ISkinControl,
                              ASkinControl,
                              Proc);
    end;
  end;

  //TItemBindingStringsControlItem中的BindingControl属性
  if List[0] is TItemBindingStringsControlItem then
  begin
    if TItemBindingStringsControls(TItemBindingStringsControlItem(List[0]).Collection)
      .Properties.SkinControl.GetInterface(IID_ISkinControl,ASkinControlIntf) then
    begin
      AddPropertySelectValue(ASkinControlIntf,IID_ISkinControl,ASkinControl,Proc);
    end;
  end;

end;


{ TItemBindingStringsControlsProperty }

procedure TItemBindingStringsControlsProperty.Edit;
begin
  ShowCollectionEditor(Designer,
        TComponent(TItemBindingStringsControls(GetOrdValue).Properties.SkinControl),
        TItemBindingStringsControls(GetOrdValue),
        GetName);
end;

function TItemBindingStringsControlsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly{$IFDEF LINUX}, paVCL{$ENDIF}];
end;


end.
