program tee;

{
  tee command under Delphi Alexandria
  (c)2022 Paul TOTH <contact@execute.fr>


  > echo hello | tee hello.txt

  Under LGPL
}

{$APPTYPE CONSOLE}
{$WEAKLINKRTTI ON}
{$SETPEFLAGS 1}

{.$R *.res}

uses
  Winapi.Windows;

procedure help(append_switch: string);
begin
  writeLn('Delphi Tee (c)2022 Paul TOTH <contact@execute.fr>');
  WriteLn('copy standard input to each file, and also to standard output');
  WriteLn;
  writeLn('tee [',append_switch,'] filename [filename...]');
  WriteLn;
  WriteLn('  ',append_switch,#9'append to the given files instead of overwriting them');
end;

const
  shareflags = FILE_SHARE_READ;

var
  filename: string;
  append: Boolean;
  firstname: Integer;
  fileflag: Cardinal;
  filehandles: array of THandle;
  filecount  : Integer;
  buffer: array[0..1023] of byte;
  readed: Cardinal;
  written: Cardinal;
begin
  if ParamCount = 0 then
    filename := '-h'
  else
    filename := ParamStr(1);
  if filename = '-h' then
  begin
    help('-a');
    exit;
  end;
  if filename = '/?' then
  begin
    help('/a');
    exit;
  end;

  if (filename = '-a') or (filename = '/a') then
  begin
    append := True;
    firstname := 2;
    fileflag := OPEN_ALWAYS;
  end else begin
    append := False;
    firstname := 1;
    fileflag := CREATE_ALWAYS;
  end;

  SetLength(filehandles, ParamCount - firstname + 1);
  filecount := 0;
  for var i := 0 to length(filehandles) - 1 do
  begin
    filename := ParamStr(firstname + i);
    filehandles[filecount] := createfile(PChar(filename), GENERIC_WRITE, shareflags, nil, fileflag, FILE_ATTRIBUTE_NORMAL, 0);
    if filehandles[filecount] <> INVALID_HANDLE_VALUE then
    begin
      if append then
        SetFilePointer(filehandles[filecount], 0, 0, FILE_END);
      Inc(filecount);
    end;
  end;

  while readfile(STD_INPUT_HANDLE, buffer, SizeOf(buffer), readed, nil) do
  begin
    writefile(STD_OUTPUT_HANDLE, buffer, readed, written, nil);
    for var i := 0 to filecount - 1 do
      writefile(filehandles[i], buffer, readed, written, nil);
  end;

  for var i := 0 to filecount - 1 do
    closehandle(filehandles[i]);
end.
