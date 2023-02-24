unit Triangle;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TTriangle }

  TTriangle = class
  private
    // circle center coords
    FX, FY: Single;
    FCircleRadius: Single;
    FCanvas: TCanvas;
    // shift of triangle points on the circle
    FShift: Single;
  public
    procedure SetCircleCenter(X, Y: Single);
    procedure SetCircleRadius(Radius: Single);
    procedure Rotate(Angle: Single);
    procedure Draw;
    constructor Create(Canvas: TCanvas);
  end;

  { TMainForm }

  TMainForm = class(TForm)
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    Triangle: TTriangle;
  public

  end;



var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses
  Math;

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Triangle := TTriangle.Create(Canvas);
  Triangle.SetCircleCenter(100, 100);
  Triangle.SetCircleRadius(90);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Triangle.Draw;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  Triangle.Rotate(10);
  Invalidate;
end;

{ TTriangle }    

constructor TTriangle.Create(Canvas: TCanvas);
begin
  FCanvas := Canvas;
end;

procedure ExcludeWholeCirles(var T: Single);
begin
  if Abs(T) > 2 then
  begin
    if T > 0 then
      T -= 2 * (Floor(Abs(T)) div 2)
    else
      T += 2 * (Floor(Abs(T)) div 2);
  end;
end;

procedure TTriangle.Draw;
const
  N = 3;
var
  X: array [1..N] of Integer;
  Y: array [1..N] of Integer;
  // T is a fraction of Pi
  T: Single;
  I: Integer;
begin
  T := 1/6 + FShift;
  for I := 1 to N do
  begin
    X[I] := trunc(FX + FCircleRadius * Cos(T * Pi));
    Y[I] := trunc(FY + FCircleRadius * Sin(T * Pi));
    T += 2/3;
    ExcludeWholeCirles(T);
  end;

  FCanvas.Pen.Style := psSolid;
  FCanvas.Pen.Width := 1;

  FCanvas.Pen.Color := clBlack;
  FCanvas.Line(X[1], Y[1], X[2], Y[2]);
  FCanvas.Pen.Color := clRed;
  FCanvas.Line(X[2], Y[2], X[3], Y[3]);
  FCanvas.Pen.Color := clGreen;
  FCanvas.Line(X[3], Y[3], X[1], Y[1]);
end;

procedure TTriangle.SetCircleCenter(X, Y: Single);
begin
  FX := X;
  FY := Y;
end;

procedure TTriangle.SetCircleRadius(Radius: Single);
begin
  FCircleRadius := Radius;
end;

procedure TTriangle.Rotate(Angle: Single);
var
  Shift: Single;
begin
  if Abs(Angle) > 360 then
    raise Exception.Create(
      'The angle of rotation cannot be more 360 degrees!');
  // get radians
  Shift := Angle / 180;
  FShift -= Shift;
  ExcludeWholeCirles(FShift);
end;

end.

