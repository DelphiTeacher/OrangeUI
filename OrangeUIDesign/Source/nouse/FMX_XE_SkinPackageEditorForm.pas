//convert pas to utf8 by ¥

unit FMX_XE_SkinPackageEditorForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  DesignWindows,
  DesignIntf,
  uSkinPackage,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.TreeView, FMX.StdCtrls, FMX.Controls.Presentation;

type
  TfrmSkinPackageEditor = class(TForm)
    tvPackage: TTreeView;
    pnlTopToolBar: TPanel;
    btnAddMaterial: TButton;
    btnLoadFromFile: TButton;
    OpenDialog1: TOpenDialog;
    procedure btnAddMaterialClick(Sender: TObject);
    procedure tvPackageChange(Sender: TObject);
    procedure btnLoadFromFileClick(Sender: TObject);
  private
    Designer:IDesigner;
    FSkinPackage:TSkinPackage;
    function AddMaterial(ATypeTreeViewItem:TTreeViewItem;const AName:String):Boolean;
    { Private declarations }
  public
    destructor Destroy;override;
    function LoadSkinPackage(ADesigner:IDesigner;ASkinPackage:TSkinPackage):Boolean;
    function EditMaterial(const AControlClassify:String;
                          const AComponentType:String;
                          const AMaterialName:String):Boolean;
    { Public declarations }
  end;

var
  frmSkinPackageEditor: TfrmSkinPackageEditor;




implementation

{$R *.fmx}




{ TfrmSkinPackageEditor }

function TfrmSkinPackageEditor.AddMaterial(ATypeTreeViewItem: TTreeViewItem;const AName:String): Boolean;
var
  AControlTypeSkinItem:TControlTypeSkinItem;
  AMaterialSkinItem:TMaterialSkinItem;
  AMaterialTreeViewItem:TTreeViewItem;
begin
//  //是否选中组件类型
//  if (Self.tvPackage.Selected<>nil)
//    and (Self.tvPackage.Selected.TagObject is TControlTypeSkinItem) then
//  begin

    Self.tvPackage.BeginUpdate;
    try
      //创建新素材
      AControlTypeSkinItem:=TControlTypeSkinItem(ATypeTreeViewItem.TagObject);


      AMaterialSkinItem:=AControlTypeSkinItem.MaterialSkinList.AddMaterialSkinItem;
      AMaterialSkinItem.Name:=AName;//'未命名';

      AMaterialTreeViewItem:=TTreeViewItem.Create(tvPackage);
      AMaterialTreeViewItem.Parent:=ATypeTreeViewItem;

      AMaterialTreeViewItem.Text:=AMaterialSkinItem.Name;
      AMaterialTreeViewItem.TagObject:=AControlTypeSkinItem;

      ATypeTreeViewItem.Expand;
      Self.tvPackage.Selected:=AMaterialTreeViewItem;

      Designer.SelectComponent(AMaterialSkinItem);


    finally
      Self.tvPackage.EndUpdate;
    end;
//  end;

end;

procedure TfrmSkinPackageEditor.btnAddMaterialClick(Sender: TObject);
var
  AControlTypeSkinItem:TControlTypeSkinItem;
begin
  //是否选中组件类型
  if (Self.tvPackage.Selected<>nil)
    and (Self.tvPackage.Selected.TagObject is TControlTypeSkinItem) then
  begin
    //创建新素材
    AControlTypeSkinItem:=TControlTypeSkinItem(Self.tvPackage.Selected.TagObject);

    AddMaterial(Self.tvPackage.Selected,'未命名');
  end;
end;

procedure TfrmSkinPackageEditor.btnLoadFromFileClick(Sender: TObject);
begin
  if Self.OpenDialog1.Execute then
  begin
    //从文件加载
    Self.FSkinPackage.LoadFromDocFile(Self.OpenDialog1.FileName);
    //重新再加载树
    LoadSkinPackage(Self.Designer,Self.FSkinPackage);
  end;
end;

destructor TfrmSkinPackageEditor.Destroy;
begin
  frmSkinPackageEditor:=nil;
  inherited;
end;

function TfrmSkinPackageEditor.EditMaterial(const AControlClassify,
                                            AComponentType,
                                            AMaterialName: String): Boolean;
var
  I: Integer;
  J: Integer;
  K: Integer;
  AClassifyTreeViewItem:TTreeViewItem;
  ATypeTreeViewItem:TTreeViewItem;
  AMaterialTreeViewItem:TTreeViewItem;
  AMaterialSkinItem:TMaterialSkinItem;
begin
  for I := 0 to Self.tvPackage.Count-1 do
  begin
    if TControlClassifySkinItem(Self.tvPackage.Items[I].TagObject).ControlClassifyReg.ControlClassify
      =AControlClassify then
    begin
      AClassifyTreeViewItem:=Self.tvPackage.Items[I];

      for J := 0 to AClassifyTreeViewItem.Count-1 do
      begin
        if TControlTypeSkinItem(AClassifyTreeViewItem.Items[J].TagObject).ControlTypeReg.ControlTypeName
          =AComponentType then
        begin
          ATypeTreeViewItem:=AClassifyTreeViewItem.Items[J];


          AMaterialSkinItem:=nil;
          for K := 0 to ATypeTreeViewItem.Count-1 do
          begin
            if TMaterialSkinItem(ATypeTreeViewItem.Items[K].TagObject).Name=AMaterialName then
            begin
              //已经存在此素材
              AMaterialTreeViewItem:=ATypeTreeViewItem.Items[K];
              AMaterialSkinItem:=TMaterialSkinItem(ATypeTreeViewItem.Items[K].TagObject);

              Self.tvPackage.Selected:=ATypeTreeViewItem.Items[K];
              Designer.SelectComponent(AMaterialSkinItem);

              Break;
            end;
          end;

          if AMaterialSkinItem=nil then
          begin
            //不存在此素材,那么新建
            AddMaterial(ATypeTreeViewItem,AMaterialName);
          end;


        end;
        break;
      end;
      break;
    end;
  end;
end;

function TfrmSkinPackageEditor.LoadSkinPackage(ADesigner:IDesigner;ASkinPackage: TSkinPackage): Boolean;
var
  I: Integer;
  J: Integer;
  K: Integer;
  AClassifyTreeViewItem:TTreeViewItem;
  ATypeTreeViewItem:TTreeViewItem;
  AMaterialTreeViewItem:TTreeViewItem;
  AControlClassifySkinItem:TControlClassifySkinItem;
  AControlTypeSkinItem:TControlTypeSkinItem;
  AMaterialSkinItem:TMaterialSkinItem;
begin
  FSkinPackage:=ASkinPackage;
  Designer:=ADesigner;

//  ShowMessage('皮肤包名:'+FSkinPackage.Caption+' 地址:'+IntToStr(Integer(FSkinPackage)));


  Self.tvPackage.BeginUpdate;
  try
    Self.tvPackage.Clear;

    //第一级，控件分类(Button,Edit,Panel,Label)
    for I := 0 to FSkinPackage.ControlClassifySkinList.Count-1 do
    begin
      AControlClassifySkinItem:=FSkinPackage.ControlClassifySkinList[I];
      AClassifyTreeViewItem:=TTreeViewItem.Create(tvPackage);
      AClassifyTreeViewItem.Parent:=tvPackage;

      AClassifyTreeViewItem.Text:=AControlClassifySkinItem.ControlClassifyReg.ControlClassify;
      AClassifyTreeViewItem.TagObject:=AControlClassifySkinItem;


      //第二级，控件类型(Default,Color......)
      for J := 0 to AControlClassifySkinItem.ControlTypeSkinList.Count-1 do
      begin
        AControlTypeSkinItem:=AControlClassifySkinItem.ControlTypeSkinList[J];
        ATypeTreeViewItem:=TTreeViewItem.Create(tvPackage);
        ATypeTreeViewItem.Parent:=AClassifyTreeViewItem;

        ATypeTreeViewItem.Text:=AControlTypeSkinItem.ControlTypeReg.ControlTypeName;
        ATypeTreeViewItem.TagObject:=AControlTypeSkinItem;


        //第三级,控件素材
        for K := 0 to AControlTypeSkinItem.MaterialSkinList.Count-1 do
        begin
          AMaterialSkinItem:=AControlTypeSkinItem.MaterialSkinList[K];

          AMaterialTreeViewItem:=TTreeViewItem.Create(tvPackage);
          AMaterialTreeViewItem.Parent:=ATypeTreeViewItem;

          AMaterialTreeViewItem.Text:=AMaterialSkinItem.Name;
          AMaterialTreeViewItem.TagObject:=AMaterialSkinItem;

        end;

      end;

    end;


    Self.tvPackage.ExpandAll;
  finally
    Self.tvPackage.EndUpdate;
  end;
end;

procedure TfrmSkinPackageEditor.tvPackageChange(Sender: TObject);
var
  AMaterialSkinItem:TMaterialSkinItem;
begin
  //是否选中组件类型
  if (Self.tvPackage.Selected<>nil)
    and (Self.tvPackage.Selected.TagObject<>nil)
    and (Self.tvPackage.Selected.TagObject is TMaterialSkinItem) then
  begin
    //创建新素材
    AMaterialSkinItem:=TMaterialSkinItem(Self.tvPackage.Selected.TagObject);

    //编辑此皮肤
    Designer.SelectComponent(AMaterialSkinItem);
  end;
end;

end.
