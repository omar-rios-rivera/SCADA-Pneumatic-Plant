program PROY1;

uses
  Vcl.Forms,
  PROY1_MAIN in 'PROY1_MAIN.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
