//convert pas to utf8 by ¥

unit uSkinPageControlEditor;


interface
{$I FrameWork.inc}


uses
  SysUtils,
  Classes,
  uLang,
  uLanguage,
  uSkinPageControlType,
  uComponentTypeNameEditor,

  {$IFDEF FMX}
  uSkinFireMonkeyPageControl,
  {$ENDIF}
  {$IFDEF VCL}
//  uSkinPageControlType,
  {$ENDIF}

  Windows,
//  uSkinPackage,
  DesignIntf,
  DesignEditors;



type
  TSkinPageControlEditor = class(TSkinControlComponentEditor)// TDefaultEditor )
  protected
    function PageControl: TSkinPageControl;
  public
    procedure Edit; override;
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
  RegisterComponentEditor(TSkinFMXPageControl,TSkinPageControlEditor);
  RegisterComponentEditor(TSkinFMXTabSheet,TSkinPageControlEditor);
  {$ENDIF}
  {$IFDEF VCL}
  RegisterComponentEditor(TSkinWinPageControl,TSkinPageControlEditor);
  RegisterComponentEditor(TSkinWinTabSheet,TSkinPageControlEditor);
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
  if CompareText( Copy( AComponent.ClassName, 1, 1 ), 'TSkin' ) = 0 then
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






{ TSkinPageControlEditor }

procedure TSkinPageControlEditor.Edit;
begin
  if PageControl<>nil then
  begin
    //切换分页
    if PageControl.Properties.ActivePageIndex<PageControl.Properties.PageCount-1 then
    begin
      PageControl.Properties.ActivePageIndex:=PageControl.Properties.ActivePageIndex+1;
      Designer.Modified;
    end
    else
    begin
      PageControl.Properties.ActivePageIndex:=0;
      Designer.Modified;
    end;
  end;
end;

procedure TSkinPageControlEditor.ExecuteVerb(Index: Integer);
var
  Page: TSkinTabSheet;
begin
  Inherited ExecuteVerb(Index);

  if PageControl <> nil then
  begin
    case Index-(Inherited GetVerbCount) of
      0:
      begin
        //新标签页
        //创建分页
        Page := TSkinTabSheet.Create(Designer.Root);
        try

          Page.Name := UniqueName(Page);
          Page.Caption := Page.Name;
          Page.Properties.PageControl := PageControl;
        except
          Page.Free;
          raise;
        end;

        PageControl.Properties.ActivePage := Page;
        Designer.SelectComponent(Page);
        Designer.Modified;
      end;
    end;


  end;

end;

function TSkinPageControlEditor.GetVerb(Index: Integer): string;
begin
  Result:='';
  if PageControl<>nil then
  begin

      case Index-(Inherited GetVerbCount) of
        0:
        begin
          //新标签页
          Result := Langs_NewTabSheet[LangKind];
        end;
        else
        begin
          Result:=Inherited GetVerb(Index);
        end;
      end;
  end;
end;

function TSkinPageControlEditor.GetVerbCount: Integer;
begin
  Result:=0;
  if PageControl<>nil then
  begin
    Result := //新建分页
              1
              +(Inherited GetVerbCount)
              ;
  end;
end;

function TSkinPageControlEditor.PageControl: TSkinPageControl;
begin
  Result:=nil;
  if Component is TSkinPageControl then
  begin
    Result := TSkinPageControl(Component);
  end
  else if Component is TSkinTabSheet then
  begin
    Result := TSkinPageControl(TSkinTabSheet(Component).Properties.PageControl);
  end;
end;


end.


