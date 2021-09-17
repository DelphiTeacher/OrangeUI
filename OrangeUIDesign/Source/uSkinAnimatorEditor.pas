//convert pas to utf8 by ¥

unit uSkinAnimatorEditor;


interface
{$I FrameWork.inc}

uses
  SysUtils,
  Classes,
  uLanguage,
  uSkinAnimator,
  Windows,
  uLang,
  DesignIntf,
  DesignEditors;


type
  //动画组件编辑器
  TBaseSkinAnimatorEditor = class(TDefaultEditor)
  public
    procedure Edit; override;
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;

procedure Register;


implementation


procedure Register;
begin
  RegisterComponentEditor(TBaseSkinAnimator,TBaseSkinAnimatorEditor );
end;


{ TBaseSkinAnimatorEditor }

procedure TBaseSkinAnimatorEditor.Edit;
var
  AAnimator: TBaseSkinAnimator;
begin
  AAnimator := TBaseSkinAnimator(Component);
  if AAnimator <> nil then
  begin
    if Not AAnimator.Tween.IsRuning
      and Not AAnimator.Tween.IsPauseing then
    begin
        //没有启动
        if AAnimator.Position=AAnimator.Max then
        begin
          //返回
          AAnimator.GoBackward;
        end
        else
        begin
          //前进
          AAnimator.GoForward;
        end;
    end
    else
    begin
        //已经启动了
        if AAnimator.Tween.IsPauseing then
        begin
          //如果暂停了就继续
          AAnimator.Tween.Continue;
        end
        else
        begin
          //如果在运行就暂停
          AAnimator.Tween.Pause;
        end;
    end;
  end;

  Designer.Modified;
end;

procedure TBaseSkinAnimatorEditor.ExecuteVerb(Index: Integer);
var
  AAnimator: TBaseSkinAnimator;
begin
  AAnimator := TBaseSkinAnimator(Component);
  if AAnimator <> nil then
  begin
    case Index of
        0: AAnimator.GoForward;
        1: AAnimator.GoBackward;
        2: AAnimator.Pause;
        3: AAnimator.Continue;
        4: AAnimator.Stop;
    end;
  end;

  Designer.Modified;
end;

function TBaseSkinAnimatorEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := Langs_Forward[LangKind];//'前进';
    1: Result := Langs_Backward[LangKind];//'后退';
    2: Result := Langs_Pause[LangKind];//'暂停';
    3: Result := Langs_Continue[LangKind];//'继续';
    4: Result := Langs_Stop[LangKind];//'停止';
  end;
end;

function TBaseSkinAnimatorEditor.GetVerbCount: Integer;
begin
  Result := 5;
end;


end.

