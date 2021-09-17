
procedure {$I Source\Controls\INC\FMX\ISkinEdit_Impl_ClassName.inc}.SetIsUseDefaultStyle(const Value: Boolean);
begin
  if FIsUseDefaultStyle<>Value then
  begin
    FIsUseDefaultStyle := Value;
    if not (csReading in Self.ComponentState)
      and not (csLoading in Self.ComponentState) then
    begin
      Self.StyleLookup:='';
      Self.ApplyStyle;
    end;
  end;
end;

