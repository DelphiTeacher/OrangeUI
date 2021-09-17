


function {$I Source\Controls\INC\FMX\ISkinEdit_Impl_ClassName.inc}.GetContentMarginsLeft: Integer;
begin
  Result:=FContentMarginsLeft;
end;

function {$I Source\Controls\INC\FMX\ISkinEdit_Impl_ClassName.inc}.GetContentMarginsTop: Integer;
begin
  Result:=FContentMarginsTop;
end;

function {$I Source\Controls\INC\FMX\ISkinEdit_Impl_ClassName.inc}.GetContentMarginsRight: Integer;
begin
  Result:=FContentMarginsRight;
end;

function {$I Source\Controls\INC\FMX\ISkinEdit_Impl_ClassName.inc}.GetContentMarginsBottom: Integer;
begin
  Result:=FContentMarginsBottom;
end;




procedure {$I Source\Controls\INC\FMX\ISkinEdit_Impl_ClassName.inc}.SetContentMarginsLeft(const Value:Integer);
begin
  if FContentMarginsLeft<>Value then
  begin
    FContentMarginsLeft := Value;

    if GetEditContentMarginsIntf<>nil then
    begin
      GetEditContentMarginsIntf.ContentMarginsLeft:=FContentMarginsLeft;
    end;

  end;
end;

procedure {$I Source\Controls\INC\FMX\ISkinEdit_Impl_ClassName.inc}.SetContentMarginsTop(const Value:Integer);
begin
  if FContentMarginsTop<>Value then
  begin
    FContentMarginsTop := Value;

    if GetEditContentMarginsIntf<>nil then
    begin
      GetEditContentMarginsIntf.ContentMarginsTop:=FContentMarginsTop;
    end;

  end;
end;

procedure {$I Source\Controls\INC\FMX\ISkinEdit_Impl_ClassName.inc}.SetContentMarginsRight(const Value:Integer);
begin
  if FContentMarginsRight<>Value then
  begin
    FContentMarginsRight := Value;

    if GetEditContentMarginsIntf<>nil then
    begin
      GetEditContentMarginsIntf.ContentMarginsRight:=FContentMarginsRight;
    end;

  end;
end;

procedure {$I Source\Controls\INC\FMX\ISkinEdit_Impl_ClassName.inc}.SetContentMarginsBottom(const Value:Integer);
begin
  if FContentMarginsBottom<>Value then
  begin
    FContentMarginsBottom := Value;

    if GetEditContentMarginsIntf<>nil then
    begin
      GetStyleEdit.ContentMarginsBottom:=FContentMarginsBottom;
    end;

  end;
end;

