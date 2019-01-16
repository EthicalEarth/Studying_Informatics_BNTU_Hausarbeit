unit Graph;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, Forms, Controls, Graphics, Dialogs,
  StdCtrls, crt, CustApp, math,  Buttons, Menus, EditBtn,
  CheckLst, Interfaces, ExtCtrls, tachartlazaruspkg, TASeries;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);



  private
    { private declarations }
  public
    { public declarations }
  end;

  type koef_auto1=array[0..25] of extended;
  type  koef_auto=array[0..25] of real;
var
  Form1: TForm1;
  pi:real;
  x:extended;
  yj: extended;                {аргумент вычисляется в цикле, значение функции}
  m: integer;                  {количество членов}
  j: integer;                  {счетчик}
  y, ysr: extended;            {промежуточное значение, среднее арифметическое}
  variant:integer;             {вариант вычисления}
  st:integer;                  //степень многочлена
  d_i:koef_auto;
  d_auto:extended;
  b_k:koef_auto1;
  b_auto:extended;
  ver:integer;
  XStr:string[7];
  YStr:string[7];
  Sinput:string[38];
  Input:string[38];
  Separator:String[35];
 // kolichestvo:integer;
  srednee:string[5];
  txtfile:text;
  i:integer;

implementation
function Gorner_1(x:real; st:integer):real;
 var i: integer;
     y:real;
     d_nach:real;
 begin
 d_i[0]:=0;
 pi:=3.14;
 d_nach:=0;
 for i:=1 to st+1 do begin
                    d_auto:=d_nach+3/i;
                    d_i[i]:=d_auto;
                    end;
 y:=0;
 for i:=st+1 downto 1 do y:=d_i[i]+y*x;
 Gorner_1:=y;
 end;
function Gorner_2(x:real; st:integer):real;
var k: integer;
    y:extended;
    b_nach:real;
begin
b_k[0]:=0;
b_nach:=0;
for k:=1 to st+1 do begin
                   b_auto:=b_nach+(k+4)/(k*k+1);
                   b_k[k]:=b_auto;
                   end;
y:=0;
for k:=st+1 downto 1 do y:=b_k[k]+y*x;
Gorner_2:=y;
end;
{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
 begin
 pi:=3.14;
 m:=2;//По варианту задания
 j:=1;
 yj:=0;
 y:=0;
 ysr:=0;
 Chart1LineSeries1.Clear;
 Form1.Memo1.Clear;
 m:=StrToint(Edit1.Text);
 Separator:='-------------------------';
 Form1.Memo1.Lines.Append(Separator);
 SInput:='|X=         | Y=        |';
 Form1.Memo1.Lines.Append(SInput);
 Form1.Memo1.Lines.Append(Separator);

 for j:=1 to m do begin
                  x:=sin((j/10)+pi/12);
                  if x<0 then {d3x3+d2x2+d1x+C0} begin
                                                 variant:=1;
                                                 writeln('Вариант вычисления ', variant);
                                                 writeln('                               ');
                                                 ///
                                                 st:=3;
                                                 yj:=Gorner_1(x, st);
                                                 writeln('yj(',x:5:4,')=',yj:0:4);
                                                 Chart1LineSeries1.AddXY(x ,yj,'',clBlue);
                                                  writeln('Коэфиценты при икс');
                                                  for ver:=1 to st+1 do writeln('',d_i[ver]);
                                                  writeln(Separator);
                                                 end
                         else                    begin
                                if x>=0.5 then {ctgx+3sqrtx}   begin
                                                               variant:=3;
                                                               writeln('Вариант вычисления ', variant);
                                                               writeln('                               ');
                                                               yj:=(1/tan(x))+ (Exp((1/3)*Ln(x)));
                                                               writeln('yj(',x:5:4,')=',yj:0:4);
                                                               writeln(Separator);
                                                               Chart1LineSeries1.AddXY(x ,yj,'',clRed);
                                                               end
                                          else  {b5x5+b4x4+b3x3+b2x2+b1x+b0}
                                                               begin
                                                               variant:=2;
                                                               writeln('Вариант вычисления ', variant);
                                                               writeln('                               ');
                                                                st:=5;
                                                                yj:=Gorner_2(x, st);
                                                                writeln('yj(',x:5:4,')=',yj:0:4);
                                                                ///
                                                                writeln('Коэфиценты при икс');
                                                                for ver:=1 to st+1 do writeln('',b_k[ver]);
                                                                writeln(Separator);
                                                                Chart1LineSeries1.AddXY(x ,yj,'',clGreen);
                                                               end
                                                               end;
                                                               y:=y+yj;
                                                               XStr:=FloatToStr(x);
                                                               YStr:=FloatToStr(yj);
                                                               Input:='|'+'X= '+Xstr+' | '+'Y= '+Ystr+'|';
                                                               Form1.Memo1.Lines.Append(input);
                                                               Form1.Memo1.Lines.Append(separator);
                         end;
ysr:=y/m;
srednee:=FloatToStr(ysr);
label2.caption:=srednee;
label1.visible:=true;
label2.visible:=true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
SaveDialog1.Execute;
AssignFile(TxtFile, SaveDialog1.FileName);
Rewrite(TxtFile);
for i:=1 to Memo1.Lines.Count do
begin
Writeln(TxtFile, Memo1.Lines[i-1]);
end;
closefile(TxtFile);
end;
end.

