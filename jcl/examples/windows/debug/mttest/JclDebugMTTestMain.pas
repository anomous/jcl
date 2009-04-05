unit JclDebugMTTestMain;

{$I jcl.inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, PSAPI, JclDebug, JclFileUtils;

type
  TMTTestForm = class(TForm)
    Button1: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MTTestForm: TMTTestForm;

implementation

{$R *.dfm}

function CSVEncode(const AStr: string): string;
begin
  Result := '"' + StringReplace(AStr, '"', '""', [rfReplaceAll]) + '"';
end;

procedure LoadedModules(ModuleList: TStrings);
var
  I: Integer;
  ProcessHandle: THandle;
  FileName: array [0..Max_Path] of Char;
  S, BinFileVersion, FileVersion, FileDescription: string;
  FileVersionInfo: TJclFileVersionInfo;
  ModuleInfoList: TJclModuleInfoList;
  ModuleBase: Cardinal;
begin
  ProcessHandle := GetCurrentProcess;
  ModuleList.Add('StartAddr;EndAddr;SystemModule;FileName;BinFileVersion;FileVersion;FileDescription');
  ModuleInfoList := TJclModuleInfoList.Create(False, False);
  try
    for I := 0 to ModuleInfoList.Count - 1 do
    begin
      ModuleBase := Cardinal(ModuleInfoList.Items[I].StartAddr);
      GetModuleFileNameEx(ProcessHandle, ModuleBase, FileName, SizeOf(FileName));
      FileVersion := '';
      if (FileName <> '') and VersionResourceAvailable(FileName) then
      begin
        FileVersionInfo := TJclFileVersionInfo.Create(FileName);
        try
          BinFileVersion := FileVersionInfo.BinFileVersion;
          FileVersion := FileVersionInfo.FileVersion;
          FileDescription := FileVersionInfo.FileDescription;
        finally
          FileVersionInfo.Free;
        end;
      end;
      if ModuleInfoList.Items[I].SystemModule then
        S := '1'
      else
        S := '0';
      S := Format('"0x%.8x";"0x%.8x";"%s";%s;%s;%s;%s', [ModuleBase, Cardinal(ModuleInfoList.Items[I].EndAddr), S,
        CSVEncode(FileName), CSVEncode(BinFileVersion), CSVEncode(FileVersion), CSVEncode(FileDescription)]);
      ModuleList.Add(S);
    end;
  finally
    ModuleInfoList.Free;
  end;
end;

procedure SaveExceptInfo(AExceptObj: TObject; AThreadInfoList: TJclThreadInfoList);
var
  StackInfo, DetailSL: TStringList;
begin
  StackInfo := TStringList.Create;
  try
    StackInfo.Add('Type;Data');
    if AExceptObj is Exception then
    begin
      DetailSL := TStringList.Create;
      try
        DetailSL.Add('ClassName;Message');
        DetailSL.Add(CSVEncode(Exception(AExceptObj).ClassName) + ';' + CSVEncode(Exception(AExceptObj).Message));
        StackInfo.Add('"Exception";' + CSVEncode(DetailSL.Text));
      finally
        DetailSL.Free;
      end;
    end;
    StackInfo.Add('"ThreadInfo";' + CSVEncode(AThreadInfoList.AsCSVString));
    DetailSL := TStringList.Create;
    try
      LoadedModules(DetailSL);
      StackInfo.Add('"Modules";' + CSVEncode(DetailSL.Text));
    finally
      DetailSL.Free;
    end;
    StackInfo.SaveToFile('ExceptInfo.csv');
  finally
    StackInfo.Free;
  end;
end;

type
  TCrashThread = class(TThread)
  public
    procedure Execute; override;
  end;

procedure TCrashThread.Execute;
begin
  Sleep(5000);
  raise Exception.Create('TestException');
end;

procedure ExceptionAcquiredProc(AObj: TObject);
var
  TID: DWORD;
  ThreadInfoList: TJclThreadInfoList;
  ThreadName, ExceptMessage, ExceptInfo: string;
begin
  if (not (stDisableIfDebuggerAttached in JclStackTrackingOptions) or (not IsDebuggerAttached)) then
  begin
    TID := GetCurrentThreadId;
    ThreadInfoList := TJclThreadInfoList.Create;
    try
      ThreadInfoList.Add.FillFromExceptThread(ThreadInfoList.GatherOptions);
      ThreadInfoList.Gather(TID);

      ThreadName := ThreadInfoList[0].Name;
      if tioIsMainThread in ThreadInfoList[0].Values then
        ThreadName := '[MainThread]'
      else
        ThreadName := ThreadInfoList[0].Name;
      //ExceptInfo := ThreadInfoList.AsCSVString;
      ExceptInfo := ThreadInfoList.AsString;
      SaveExceptInfo(AObj, ThreadInfoList);
    finally
      ThreadInfoList.Free;
    end;
    ExceptMessage := Exception(AObj).Message;
    MessageBox(0, PChar(ExceptMessage + #13#10#13#10 + ExceptInfo), PChar(Format('Exception in Thread %d%s', [TID, ThreadName])), MB_OK);
  end;
end;

procedure TMTTestForm.Button1Click(Sender: TObject);
begin
  {$IFDEF COMPILER12_UP}
  ExceptionAcquired := @ExceptionAcquiredProc;
  {$ELSE}
  raise Exception.Create('This is not supported by your Delphi version!');
  {$ENDIF COMPILER12_UP}
  TCrashThread.Create(False);
end;

type
  TLoopSleepThread = class(TThread)
  public
    procedure Execute; override;
  end;

procedure TLoopSleepThread.Execute;
begin
  while True do
  begin
    Sleep(100);
    Sleep(100);
    Sleep(100);
    Sleep(100);
    Sleep(100);
    Sleep(100);
    Sleep(100);
    Sleep(100);
    Sleep(100);
    Sleep(100);
  end;
end;

procedure TMTTestForm.Button3Click(Sender: TObject);
var
  TID: DWORD;
  ThreadInfoList: TJclThreadInfoList;
  ThreadInfo: string;
begin
  TLoopSleepThread.Create(False);
  Sleep(100);
  TLoopSleepThread.Create(False);
  Sleep(100);
  TLoopSleepThread.Create(False);
  Sleep(100);
  TID := GetCurrentThreadId;
  ThreadInfoList := TJclThreadInfoList.Create;
  try
    ThreadInfoList.Gather(TID);
    //ExceptInfo := ThreadInfoList.AsCSVString;
    ThreadInfo := ThreadInfoList.AsString;
  finally
    ThreadInfoList.Free;
  end;
  MessageBox(0, PChar(ThreadInfo), 'Thread info (except current thread)', MB_OK);
end;

procedure TMTTestForm.FormCreate(Sender: TObject);
begin
  JclStartExceptionTracking;
  JclDebugThreadList.SaveCreationStack := True;
  JclHookThreads;
end;

end.
