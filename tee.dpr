program tee;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Winapi.Windows;

var
  filename: string;
  log: THandle;
  buffer: array[0..1023] of byte;
  readed: Cardinal;
  written: Cardinal;
begin
  filename := ParamStr(1);
  log := createfile(PChar(filename),  GENERIC_WRITE, 0, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if log <> INVALID_HANDLE_VALUE then
    SetFilePointer(log, 0, 0, FILE_END);
  while readfile(STD_INPUT_HANDLE, buffer, SizeOf(buffer), readed, nil) do
  begin
    writefile(STD_OUTPUT_HANDLE, buffer, readed, written, nil);
    if log <> INVALID_HANDLE_VALUE then
      writefile(log, buffer, readed, written, nil);
  end;
  closehandle(log);
end.
