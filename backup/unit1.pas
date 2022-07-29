unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, JwaTlHelp32,
  windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    function KillTask(ExeFileName: string): Integer;
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}


function TForm1.KillTask(ExeFileName: string): Integer;
  const
    PROCESS_TERMINATE = $0001;
  var
    ContinueLoop: BOOL;
    FSnapshotHandle: THandle;
    FProcessEntry32: TProcessEntry32;
  begin
    Result := 0;
    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
    ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
    while Integer(ContinueLoop) <> 0 do
    begin
      if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
        UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
        UpperCase(ExeFileName))) then
        Result := Integer(TerminateProcess(
                          OpenProcess(PROCESS_TERMINATE,
                                      BOOL(0),
                                      FProcessEntry32.th32ProcessID),
                                      0));
       ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
    end;
    CloseHandle(FSnapshotHandle);
  end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if KillTask('setuphost.exe') > 0 then
    Memo1.Lines.Append(TimeToStr(Now()) + ' Killed')
  else
      Memo1.Lines.Append(TimeToStr(Now()) + ' Process Not Found');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Timer1Timer(self);
end;

end.

