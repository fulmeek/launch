{
  LAUNCH v3.0.1
  Copyright 2012, 2017, 2019 fulmeek

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
}
program Launch;

{$M 2048,0,65565}

uses
  Dos,
  VidMode;

  function GetTimeStamp: word;
  var
    H, Min, S, CS: word;
  begin
    GetTime(H, Min, S, CS);
    GetTimeStamp := CS + (S * 100) +
      (Min * 60 * 100) + (H * 60 * 60 * 100);
  end;

  procedure CallCommand;
  var
    Args: string;
    I: word;
  begin
    Args := '/C ';

    for I := 1 to ParamCount do
    begin
      if I > 1 then
      begin
        Args := Args + ' ' + ParamStr(I);
      end
      else
      begin
        Args := Args + ParamStr(I);
      end;
    end;

    SwapVectors;
    Exec(GetEnv('COMSPEC'), Args);
    SwapVectors;

    if DosError <> 0 then
    begin
      writeln('Failed to execute command');
      halt(1);
    end;
  end;


(*** Main Program ***)

const
  TimeIntro = 500;
  TimeOutro = 100;
var
  CallTime: word;
begin
  if ParamCount < 1 then
  begin
    writeln('Usage: launch [command]');
    halt(0);
  end;

  ShowBar(TimeIntro);
  CallTime := GetTimeStamp;

  CallCommand;

  if GetTimeStamp <> CallTime then
  begin
    ShowBar(TimeOutro);
  end;
end.
