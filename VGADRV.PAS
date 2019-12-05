{
  EGA/VGA Video Driver Unit
  Copyright 2019 fulmeek

  To create the EGAVGA.OBJ file, go to the BGI directory in your
  Turbo Pascal installation and run the following command:

  binobj egavga.bgi egavga EGAVGADriverProc
}
unit VGADrv;

interface

implementation

uses Graph;

procedure EGAVGADriverProc; external;
{$L EGAVGA.OBJ}

begin
  RegisterBGIdriver(@EGAVGADriverProc);
end.
