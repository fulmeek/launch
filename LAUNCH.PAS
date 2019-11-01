{
    LAUNCH v3.0.0
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

uses Dos, VidMode;


function GetTimeStamp: word;
var
   h, min, s, cs: word;
begin
     GetTime(h, min, s, cs);
     GetTimeStamp := cs + (s * 100)
                   + (min * 60 * 100)
                   + (h * 60 * 60 * 100);
end;

procedure CallCommand;
var
   args: string;
   i: word;
begin
     args := '/C ';

     for i := 1 to ParamCount do
     begin
          if (i > 1) then
          begin
               args := args + ' ' + ParamStr(i);
          end else begin
               args := args + ParamStr(i);
          end;
     end;

     SwapVectors;
     Exec(GetEnv('COMSPEC'), args);
     SwapVectors;

     if (DosError <> 0) then
     begin
          writeln('Failed to execute command');
          halt(1);
     end;
end;


(*** Main Program ***)

const
     TIME_INTRO = 500;
     TIME_OUTRO = 100;
var
   calltime: word;
BEGIN
     if (ParamCount < 1) then
     begin
          writeln('Usage: launch [command]');
          halt(0);
     end;

     ShowBar(TIME_INTRO);
     calltime := GetTimeStamp;

     CallCommand;

     if (GetTimeStamp <> calltime) then
     begin
          ShowBar(TIME_OUTRO);
     end;
END.