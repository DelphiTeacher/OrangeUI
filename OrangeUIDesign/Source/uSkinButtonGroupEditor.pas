//convert pas to utf8 by ¥

unit uSkinButtonGroupEditor;


interface
{$I FrameWork.inc}

uses
  SysUtils,
  Classes,
  {$IFDEF FMX}
  uSkinFireMonkeyButton,
  {$ENDIF}
  {$IFDEF VCL}
//  uSkinWindowsButton,
  {$ENDIF}
  uSkinButtonType,
  uLanguage,
  uLang,
  uComponentTypeNameEditor,

  Windows,
  DesignIntf,
  DesignEditors;


type
  //按钮分组编辑器
  TSkinButtonGroupEditor = class( TSkinControlComponentEditor )
//  protected
//    function ButtonGroup: TSkinParentButtonGroup;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;



procedure Register;


implementation


procedure Register;
begin
  {$IFDEF FMX}
  RegisterComponentEditor(TSkinFMXButtonGroup,TSkinButtonGroupEditor);
  RegisterComponentEditor(TSkinFMXButton,TSkinButtonGroupEditor);
  {$ENDIF}
  {$IFDEF VCL}
  RegisterComponentEditor(TSkinWinButtonGroup,TSkinButtonGroupEditor);
  RegisterComponentEditor(TSkinWinButton,TSkinButtonGroupEditor);
  {$ENDIF}
end;

function TryName( const AName: string; AComponent: TComponent ): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to AComponent.ComponentCount - 1 do
  begin
    if CompareText( AComponent.Components[ I ].Name, AName ) = 0 then
      Exit;
  end;
  Result := True;
end;

function UniqueName( AComponent: TComponent ): string;
var
  I: Integer;
  Fmt: string;
begin
  // Create a Format string to use as a name template.
  if CompareText( Copy( AComponent.ClassName, 1, 4 ), 'TSkin' ) = 0 then
    Fmt := Copy( AComponent.ClassName, 2, 255 ) + '%d'
  else
    Fmt := Copy( AComponent.ClassName, 2, 255 ) + '%d';

  if AComponent.Owner = nil then
  begin
    // No owner; any name is unique. Use 1.
    Result := Format( Fmt, [ 1 ] );
    Exit;
  end
  else
  begin
    // Try all possible numbers until we find a unique name.
    for I := 1 to High( Integer ) do
    begin
      Result := Format( Fmt, [ I ] );
      if TryName( Result, AComponent.Owner ) then
        Exit;
    end;
  end;

  // This should never happen, but just in case...
  raise Exception.CreateFmt('Cannot create unique name for %s.', [ AComponent.ClassName ] );
end;





{ TSkinButtonGroupEditor }

procedure TSkinButtonGroupEditor.ExecuteVerb(Index: Integer);
var
  AButtonGroup: TSkinParentButtonGroup;
  ANewButton: TSkinChildButton;
  AClickButton: TSkinChildButton;
  Designer: IDesigner;
begin
  Inherited ExecuteVerb(Index);

  AButtonGroup:=nil;
  AClickButton:=nil;
  if Component is TSkinChildButton then
  begin
    //是按钮
    AClickButton:=TSkinChildButton(Component);
    AButtonGroup := TSkinParentButtonGroup(TSkinChildButton(Component).Properties.ButtonGroup);
  end
  else if Component is TSkinParentButtonGroup then
  begin
    //是按钮分组
    AButtonGroup := TSkinParentButtonGroup(Component);
  end;


  if AButtonGroup <> nil then
  begin
    Designer := Self.Designer;

    //去除素材的几个编辑菜单
    //0.创建一个新按钮
    //1.在前面插入一个新按钮
    //2.在后面创建一个新按钮
    if    (Index>(Inherited GetVerbCount)-1)
      and (Index<(Inherited GetVerbCount)+3) then
    begin
        //创建一个新按钮
        ANewButton := TSkinChildButton.Create(Designer.Root);
        try

          ANewButton.Name := UniqueName(ANewButton);
          ANewButton.Caption := ANewButton.Name;
          ANewButton.Properties.ButtonGroup := AButtonGroup;
        except
          ANewButton.Free;
          raise;
        end;
        if Index=(Inherited GetVerbCount)+0 then
        begin
          //仅创建,无其他操作
        end;

        //在前面插入一个新按钮
        if Index=(Inherited GetVerbCount)+1 then
        begin
          if AClickButton<>nil then
          begin
            ANewButton.Properties.ButtonIndex:=AClickButton.Properties.ButtonIndex;
          end;
        end;

        //在后面创建一个新按钮
        if Index=(Inherited GetVerbCount)+2 then
        begin
          if AClickButton<>nil then
          begin
            ANewButton.Properties.ButtonIndex:=AClickButton.Properties.ButtonIndex+1;
          end;
        end;


        Designer.SelectComponent(ANewButton);
        Designer.Modified;
    end;
  end;
end;

function TSkinButtonGroupEditor.GetVerb(Index: Integer): string;
begin
  Result:=Inherited GetVerb(Index);
  if Index=(Inherited GetVerbCount)+0 then
  begin
    Result := Langs_NewButton[LangKind];
  end;
  if Index=(Inherited GetVerbCount)+1 then
  begin
    Result := Langs_InsertFront[LangKind];
  end;
  if Index=(Inherited GetVerbCount)+2 then
  begin
    Result := Langs_InsertBehind[LangKind];
  end;
end;

function TSkinButtonGroupEditor.GetVerbCount: Integer;
begin
  Result := (Inherited GetVerbCount)+3;
end;

//function TSkinButtonGroupEditor.ButtonGroup: TSkinParentButtonGroup;
//begin
//  Result:=nil;
//  if Component is TSkinParentButtonGroup then
//  begin
//    Result := TSkinParentButtonGroup(Component);
//  end
//  else if Component is TSkinChildButton then
//  begin
//    Result := TSkinParentButtonGroup(TSkinChildButton(Component).Properties.ButtonGroup);
//  end;
//end;



end.


