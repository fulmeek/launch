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


INTERFACE

procedure ShowBar(time:word);


IMPLEMENTATION

uses Dos, Graph, VGADrv;

var
   screen: record
           width: integer;
           height: integer;
   end;
   sbar: record
         x, y: integer;
         width: integer;
         height: integer;
         position: word;
   end;
   timer: record
          time: integer;
          cs: word;
   end;


procedure ScreenBegin;
var
   scrDriver: integer;
   scrMode: integer;
begin
     scrDriver := VGA;
     scrMode := VGAMed;

     InitGraph(scrDriver, scrMode, '');
     if (GraphResult <> grOK) then
     begin
          writeln('Failed to set screen mode.');
          halt(1);
     end;

     screen.width := getMaxX;
     screen.height := getMaxY;
end;

procedure ScreenEnd;
begin
     CloseGraph;
end;

procedure BarInit;
const
     BORDER_COLOR = 15;
     BORDER_PADDING = 2;
     MOD_WIDTH = 0.8;
     MOD_HEIGHT = 0.02;
     MOD_X = 0.5;
     MOD_Y = 0.8;
begin
     sbar.width := round(screen.width * MOD_WIDTH);
     sbar.height := round(screen.height * MOD_HEIGHT);
     sbar.x := round((screen.width - sbar.width) * MOD_X);
     sbar.y := round((screen.height - sbar.height) * MOD_Y);
     sbar.position := 0;

     SetColor(BORDER_COLOR);
     Rectangle(sbar.x - BORDER_PADDING,
               sbar.y - BORDER_PADDING,
               sbar.x + sbar.width + BORDER_PADDING,
               sbar.y + sbar.height + BORDER_PADDING);
end;

procedure BarDraw(scale:real);
const
     BAR_COLOR = 10;
var
   width: word;
begin
     if (scale < 0.0) then
     begin
          scale := 0.0;
     end
     else if (scale > 1.0) then
     begin
          scale := 1.0;
     end;

     width := round(sbar.width * scale);
     if (width > sbar.position) then
     begin
          SetFillStyle(SolidFill, BAR_COLOR);
          Bar(sbar.x + sbar.position, sbar.y,
              sbar.x + width, sbar.y + sbar.height);
              sbar.position := width;
     end;
end;

procedure TimerInit;
var
   h, min, s, cs: word;
begin
     GetTime(h, min, s, cs);

     timer.time := cs * -1;
     timer.cs := 0;
end;

procedure TimerUpdate;
var
   h, min, s, cs: word;
begin
     GetTime(h, min, s, cs);

     if (timer.cs > cs) then
     begin
          timer.time := timer.time + (cs + 100 - timer.cs);
     end else begin
          timer.time := timer.time + (cs - timer.cs);
     end;
     timer.cs := cs;
end;

procedure ShowBar(time:word);
begin
     ScreenBegin;
     BarInit;
     TimerInit;
     repeat
           TimerUpdate;
           BarDraw(timer.time / time);
     until timer.time >= time;
     ScreenEnd;
end;

END.
