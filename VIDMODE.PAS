{
  Video Mode Unit
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
unit VidMode;

interface

procedure ShowBar(Time: word);

implementation

uses Dos, Graph, VGADrv;

var
  Screen: record
    Width: integer;
    Height: integer;
  end;
  SBar: record
    X, Y: integer;
    Width: integer;
    Height: integer;
    Position: word;
  end;
  Timer: record
    Time: integer;
    CS: word;
  end;


procedure ScreenBegin;
var
  ScrDriver: integer;
  ScrMode: integer;
begin
  ScrDriver := VGA;
  ScrMode := VGAMed;

  InitGraph(ScrDriver, ScrMode, '');
  if GraphResult <> grOK then
  begin
    writeln('Failed to set screen mode.');
    halt(1);
  end;

  Screen.Width := GetMaxX;
  Screen.Height := GetMaxY;
end;

procedure ScreenEnd;
begin
  CloseGraph;
end;

procedure BarInit;
const
  BorderColor = 15;
  BorderPadding = 2;
  ModWidth = 0.8;
  ModHeight = 0.02;
  ModX = 0.5;
  ModY = 0.8;
begin
  SBar.Width := round(Screen.Width * ModWidth);
  SBar.Height := round(Screen.Height * ModHeight);
  SBar.X := round((Screen.Width - SBar.Width) * ModX);
  SBar.Y := round((Screen.Height - SBar.Height) * ModY);
  SBar.Position := 0;

  SetColor(BorderColor);
  Rectangle(SBar.X - BorderPadding,
    SBar.Y - BorderPadding,
    SBar.X + SBar.Width + BorderPadding,
    SBar.Y + SBar.Height + BorderPadding);
end;

procedure BarDraw(Scale: real);
const
  BarColor = 10;
var
  Width: word;
begin
  if Scale < 0.0 then
  begin
    Scale := 0.0;
  end
  else if Scale > 1.0 then
  begin
    Scale := 1.0;
  end;

  Width := round(SBar.Width * Scale);
  if Width > SBar.Position then
  begin
    SetFillStyle(SolidFill, BarColor);
    Bar(SBar.X + SBar.Position, SBar.Y,
      SBar.X + Width, SBar.Y + SBar.Height);
    SBar.Position := Width;
  end;
end;

procedure TimerInit;
var
  H, Min, S, CS: word;
begin
  GetTime(H, Min, S, CS);

  Timer.Time := CS * -1;
  Timer.CS := 0;
end;

procedure TimerUpdate;
var
  H, Min, S, CS: word;
begin
  GetTime(H, Min, S, CS);

  if Timer.CS > CS then
  begin
    Timer.Time := Timer.Time + (CS + 100 - Timer.CS);
  end
  else
  begin
    Timer.Time := Timer.Time + (CS - Timer.CS);
  end;
  Timer.CS := CS;
end;

procedure ShowBar(Time: word);
begin
  ScreenBegin;
  BarInit;
  TimerInit;
  repeat
    TimerUpdate;
    BarDraw(Timer.Time / Time);
  until Timer.Time >= Time;
  ScreenEnd;
end;

end.
