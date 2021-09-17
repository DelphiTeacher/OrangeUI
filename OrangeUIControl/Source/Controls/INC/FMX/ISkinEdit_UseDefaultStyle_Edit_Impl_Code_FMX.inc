
procedure {$I Source\Controls\INC\FMX\ISkinEdit_Impl_ClassName.inc}.SetIsUseDefaultStyle(const Value: Boolean);
begin
  if FIsUseDefaultStyle<>Value then
  begin
    FIsUseDefaultStyle:=Value;
    if GetStyleEdit<>nil then
    begin
      GetStyleEdit.IsUseDefaultStyle:=Value;
    end;
  end;
end;
