
procedure {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.SetCaption(const Value:String);
begin
  if FCaption<>Value then
  begin
    FCaption:=Value;
    if GetSkinControlType<>nil then
    begin
      GetSkinControlType.TextChanged;
    end;
  end;
end;

function {$I Source\Controls\INC\Common\ISkinComponent_Skin_Impl_ClassName.inc}.GetCaption:String;
begin
  Result:=Self.FCaption;
end;

