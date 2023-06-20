unit PROY1_MAIN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg, dOPCDA, dOPCDlgBrowse, dOPCComn, dOPCIntf,
  dOPCOld, System.ImageList, Vcl.ImgList, Vcl.Mask;

type
  TForm1 = class(TForm)
    pMain: TPanel;
    Label1: TLabel;
    bConnect: TSpeedButton;
    bDisconnect: TSpeedButton;
    bStart: TButton;
    bStop: TButton;
    cbServer: TComboBox;
    Panel1: TPanel;
    Label2: TLabel;
    cbTopic: TComboBox;
    Image1: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    OPCClient: TdOPCDAClient;
    Label6: TLabel;
    Image2: TImage;
    bReset: TButton;
    Label7: TLabel;
    Label8: TLabel;
    leTimer: TLabeledEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    leCount: TLabeledEdit;
    Label15: TLabel;
    lRep: TLabel;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    imgVastago_4: TImage;
    imgVastago_5: TImage;
    imgVastago_3: TImage;
    imgVastago_2: TImage;
    imgVastago_1: TImage;
    bOK_T: TButton;
    bOK_C: TButton;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    imgRedE1: TImage;
    imgRedE2: TImage;
    imgRedE3: TImage;
    imgRedC2: TImage;
    imgRedC1: TImage;
    imgRedC3: TImage;
    TimerRoutine: TTimer;
    pCounter: TPanel;
    pTimer: TPanel;
    ImageList1: TImageList;
    procedure cbServerDropDown(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bConnectClick(Sender: TObject);
    procedure bDisconnectClick(Sender: TObject);
    procedure cbTopicChange(Sender: TObject);
    procedure cbTopicDropDown(Sender: TObject);
    procedure OPCClientConnect(Sender: TObject);
    procedure OPCClientDisconnect(Sender: TObject);
    procedure OPCClientTimeout(Sender: TObject);
    procedure bStartMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bStartMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bStopMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bStopMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OPCClientDatachange(Sender: TObject; ItemList: TdOPCItemList);
    procedure bOK_TClick(Sender: TObject);
    procedure bOK_CClick(Sender: TObject);
    procedure bResetMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bResetMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimerRoutineTimer(Sender: TObject);

  private
  TAGS: TdOPCGroup;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  pneumatic_temp: Integer;
  time_up: Integer;

  START_V: TdOPCItem;  // Bot�n START Virtual
  STOP_V: TdOPCItem;   // Bot�n STOP Virtual
  RESET_V: TdOPCItem;  // Bot�n RESET Virtual

  SC1: TdOPCItem;     // Interruptor de l�mite de compresi�n 1
  SC2: TdOPCItem;     // Interruptor de l�mite de compresi�n 2
  SC3: TdOPCItem;     // Interruptor de l�mite de compresi�n 3
  SE1: TdOPCItem;     // Interruptor de l�mite de expansi�n 1
  SE2: TdOPCItem;     // Interruptor de l�mite de expansi�n 2
  SE3: TdOPCItem;     // Interruptor de l�mite de expansi�n 3

  EV_E1: TdOPCItem;     // Interruptor de l�mite de compresi�n 1
  EV_C1: TdOPCItem;     // Interruptor de l�mite de compresi�n 2
  EV_E2: TdOPCItem;     // Interruptor de l�mite de compresi�n 3
  EV_C2: TdOPCItem;     // Interruptor de l�mite de expansi�n 1
  EV_E3: TdOPCItem;     // Interruptor de l�mite de expansi�n 2
  EV_C3: TdOPCItem;     // Interruptor de l�mite de expansi�n 3

  TIMER_0_PRE: TdOPCItem;   // Temporizador de tiempo de espera (PRESET)
  TIMER_1_DN: TdOPCItem;    // Temporizador de tiempo de espera (PRESET)
  COUNT_0_PRE: TdOPCItem;   // Contador de repeticiones (PRESET)
  COUNT_0_ACC: TdOPCItem;   // Contador de repeticiones (ACCUM)

implementation

{$R *.dfm}     // Directivas de compilador

// -----------------------------------------------------------------------------
// -----------------  Rutina de configuraci�n y comunicaci�n -------------------
// -----------------------------------------------------------------------------

// M�todo de creaci�n de ventana
procedure TForm1.FormCreate(Sender: TObject);
begin
  // A�ade un grupo prueba
  OPCClient.OPCGroups.Add('PRUEBA');
end;


// M�todo de pulsar bot�n conectar
procedure TForm1.bConnectClick(Sender: TObject);
begin
   if Trim(cbServer.Text) <> '' then      // Condici�n de servidor seleccionado
   begin
     // Memo1.Clear;
     OPCClient.ServerName     := cbServer.Text;// Obtiene nombre de servidor
     OPCClient.Active         := true;         // Se conecta al servidor
     cbTopic.Enabled:= true;                   // Habilita men� de t�picos
     bStart.Enabled:= true;                    // Habilita bot�n de START
     bStop.Enabled:= true;                     // Habilita bot�n de STOP
     bReset.Enabled:= true;                    // Habilita bot�n de RESET
     leTimer.Enabled := true;                  // Habilita etiqueta de tempor.
     leCount.Enabled := true;                  // Habilita etiqueta de cont.
     lRep.Enabled := true;                     // Habilita etiqueta de tiempo
     bOK_T.Enabled:= true;                     // Habilita bot�n de confirmaci�n 1
     bOK_C.Enabled:= true;                     // Habilita bot�n de confirmaci�n 2

   end
   else        // Condici�n de servidor no seleccionado
     ShowMessage('Primero selecciona un servidor OPC');
end;

// M�todo de pulsar bot�n desconectar
procedure TForm1.bDisconnectClick(Sender: TObject);
begin
  OPCClient.Active := false;          // Se desconecta del servidor
  OPCClient.OPCGroups.RemoveAll;      // Elimina Grupos
  cbTopic.Items.Clear();              // Elimina texto de men�
  cbTopic.Text := 'Elegir';           // Restablece texto de men� t�picos
  cbServer.Text := 'Elegir';          // Restablece texto de men� servidores
  cbTopic.Enabled:= false;            // Deshabilita men� de t�picos
  bStart.Enabled:= false;             // Desabilita bot�n de START
  bStop.Enabled:= false;              // Deshabilita bot�n de STOP
  bReset.Enabled:= false;             // Deshabilita bot�n de RESET
  leTimer.Enabled := false;           // Deshabilita etiqueta de tempor.
  leCount.Enabled := false;           // Deshabilita etiqueta de cont.
  lRep.Enabled := false;              // Deshabilita etiqueta de tiempo
  bOK_T.Enabled:= false;              // Deshabilita bot�n de confirmaci�n 1
  bOK_C.Enabled:= false;              // Deshabilita bot�n de confirmaci�n 2
end;


// Funci�n de escritura en OPC, recibe servidor OPC, grupo, objeto y valor
function WriteOPCItem(OpcServer: TdOPCDAClient; Groupname: string;
                      ItemName: string; Value: Variant): boolean;
var
  WriteGroup  : TdOPCGroup;
  Item        : TdOPCItem;
begin
Screen.Cursor := crHourGlass;  // Cursor de espera
  result := false;   // Resultado de funci�n si no se escribe
  // Define grupo de escritura
  WriteGroup := OPCServer.OPCGroups.GetOPCGroup(GroupName);
  if WriteGroup <> nil then         // Si grupo no es nulo
  begin
    Item := WriteGroup.OPCItems.FindOPCItem(ItemName); // Busca objeto en grupo
    if Item <> nil then           // Si objeto no es nulo
    begin
      Item.WriteSync(Value);      // Escibe valor en objeto
      result := true;
      Screen.Cursor := crDefault;  // Cursor de espera
    end;
  end;
end;

 // Funci�n de lectura en OPC, recibe servidor OPC, grupo,
 // objeto y devuelve valor
function ReadOPCItem(OpcServer: TdOPCDAClient; Groupname: string;
                     ItemName: string): Variant;
var
  ReadGroup  : TdOPCGroup;
  Item       : TdOPCItem;
begin
  result := false;     // Resultado de funci�n si no se lee
  // Define grupo de lectura
  ReadGroup := OPCServer.OPCGroups.GetOPCGroup(GroupName);
  if ReadGroup.SyncRead() then   // Si grupo se lee
  begin
    Item := ReadGroup.OPCItems.FindOPCItem(ItemName); // Busca objeto en grupo
    if Item <> nil then
    begin
      result := Item.ValueStr;          // Escibe valor en variable de funci�n
    end;
  end
  else
     ShowMessage('No es posible escribir valor: ' + ItemName);
end;

// M�todo de men� desplegable de servidores
procedure TForm1.cbServerDropDown(Sender: TObject);
begin
  OPCClient.Protocol := coCOM;         // Protocolo COM
  Screen.Cursor := crHourGlass;        // Cursor de espera
  try
    // Obtiene nombres de servidores de registro
    GetOPCDAServers(cbServer.Items,OPCClient.Protocol);
  finally
    Screen.Cursor := crDefault;   // Regresa cursor a predeterminado
  end;
end;

// M�todo de cambio de selecci�n en men� desplegable de t�picos
procedure TForm1.cbTopicChange(Sender: TObject);
begin
  TAGS := OPCClient.OPCGroups.Add('TAGS'); // A�ade grupo
  TAGS.CreateOnDatachange := true; // Acepta evento de cambio de datos en grupo
  { Agrega etiquetas con direccionamiento }
  STOP_V := TAGS.OPCItems.AddItem('[PROY1_LD]B3:0/0');  // Direcci�n STOP Virtual
  START_V := TAGS.OPCItems.AddItem('[PROY1_LD]B3:0/1'); // Direcci�n START Virtual
  RESET_V := TAGS.OPCItems.AddItem('[PROY1_LD]B3:0/4'); // Direcci�n START Virtual

  SC1 := TAGS.OPCItems.AddItem('[PROY1_LD]I:1.0/10');    // Interruptor de l�mite de compresi�n 1
  SC2 := TAGS.OPCItems.AddItem('[PROY1_LD]I:1.0/12');    // Interruptor de l�mite de compresi�n 2
  SC3 := TAGS.OPCItems.AddItem('[PROY1_LD]I:1.0/14');    // Interruptor de l�mite de compresi�n 3
  SE1 := TAGS.OPCItems.AddItem('[PROY1_LD]I:1.0/11');    // Interruptor de l�mite de expansi�n 1
  SE2 := TAGS.OPCItems.AddItem('[PROY1_LD]I:1.0/13');    // Interruptor de l�mite de expansi�n 2
  SE3 := TAGS.OPCItems.AddItem('[PROY1_LD]I:1.0/15');    // Interruptor de l�mite de expansi�n 3

  EV_E1 := TAGS.OPCItems.AddItem('[PROY1_LD]O:3.0/8');    // Electrov�lvula de expansi�n 1
  EV_C1 := TAGS.OPCItems.AddItem('[PROY1_LD]O:3.0/9');    // Electrov�lvula de compresi�n 1
  EV_E2 := TAGS.OPCItems.AddItem('[PROY1_LD]O:3.0/10');   // Electrov�lvula de expansi�n 2
  EV_C2 := TAGS.OPCItems.AddItem('[PROY1_LD]O:3.0/11');   // Electrov�lvula de compresi�n 2
  EV_E3 := TAGS.OPCItems.AddItem('[PROY1_LD]O:3.0/12');   // Electrov�lvula de expansi�n 3
  EV_C3 := TAGS.OPCItems.AddItem('[PROY1_LD]O:3.0/13');   // Electrov�lvula de compresi�n 3

  TIMER_0_PRE := TAGS.OPCItems.AddItem('[PROY1_LD]T4:0.PRE');   // Temporizador de tiempo de espera (PRESET)
  TIMER_1_DN := TAGS.OPCItems.AddItem('[PROY1_LD]T4:1/DN');     // Temporizador de tiempo de rutina neum�tica (DN)
  COUNT_0_PRE := TAGS.OPCItems.AddItem('[PROY1_LD]C5:0.PRE');   // Contador de repeticiones (PRESET)
  COUNT_0_ACC := TAGS.OPCItems.AddItem('[PROY1_LD]C5:0.ACC');   // Contador de repeticiones (ACCUM)
  // Lee y convierte string de temporizador en segundos
  leTimer.EditLabel.Caption := FloatToStr(StrToInt(ReadOPCItem(OPCClient,'TAGS',TIMER_0_PRE.ItemName))/100) + ' [s]';
  // Lee y convierte string de contador en repeticiones
  leCount.EditLabel.Caption := ReadOPCItem(OPCClient,'TAGS',COUNT_0_PRE.ItemName) + ' rep.';
  // Lee y convierte string de repetici�n actual
  lRep.Caption := ReadOPCItem(OPCClient,'TAGS',COUNT_0_ACC.ItemName) + ' rep.';
end;


// Funci�n para obtener t�picos
procedure GetAllItems(Browser: TdOPCBrowser;
          ItemList: TStrings; Level: integer = 0);
var
  i          : integer;
  Items      : TdOPCBrowseItems;
  BrowseItem : TdOPCBrowseItem;
  LevelStr   : string;
begin
  Browser.Browse;                        // Obtiene Items de servidor OPC
  Items  := TdOPCBrowseItems.Create;     // Crea nueva lista
  Items.Assign(Browser.Items);           // Guarda y copia lista

  for i := 0 to Level do
    ItemList.Add(Browser.CurrentPosition.Name);  // Muestra nombre de folder

  for i := 0 to Items.Count-1 do         // Recorre t�picos en ruta
  begin
     BrowseItem := Items[i];
     if BrowseItem.IsFolder then         // Si es un folder
        ItemList.Add(BrowseItem.ItemId)  // A�ade nombre de t�pico a la lista
  end;
end;

// M�todo de men� desplegable de t�picos
procedure TForm1.cbTopicDropDown(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;                     // Cursor de espera
  try
    GetAllItems(OPCClient.Browser,cbTopic.Items);   // Agrega t�picos
  finally
    Screen.Cursor := crDefault;                     // Cursor predeterminado
  end;

end;

// Evento OPCServer->OnConnect
procedure TForm1.OPCClientConnect(Sender: TObject);
begin
  ShowMessage('Servidor OPC conectado');
end;


// Evento OPCServer->OnDisconnect
procedure TForm1.OPCClientDisconnect(Sender: TObject);
begin
  OPCClient.OPCGroups[0].OPCItems.RemoveAll;  // Elimina grupos
  ShowMessage('Servidor OPC desconectado');
end;

// Evento OPCServer->OnTimeout
procedure TForm1.OPCClientTimeout(Sender: TObject);
begin
  ShowMessage('Servidor OPC no responde');
end;


// -----------------------------------------------------------------------------
// --------------------  Rutina de supervisi�n ---------------------------------
// -----------------------------------------------------------------------------


// M�todo de presionar bot�n Start
procedure TForm1.bStartMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Funci�n de escritura con valor 0
  bStart.ImageIndex := 1; // Cambia imagen de bot�n
  WriteOPCItem(OPCClient,'TAGS' ,START_V.ItemName,'1')
end;

// M�todo de soltar bot�n Start
procedure TForm1.bStartMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    // Funci�n de escritura con valor 0
    bStart.ImageIndex := 0;     // Cambia imagen de bot�n
    WriteOPCItem(OPCClient,'TAGS' ,START_V.ItemName,'0');
    lRep.Caption := IntToStr(StrToInt(ReadOPCItem(OPCClient,'TAGS',COUNT_0_ACC.ItemName))+1)+' rep.';
end;

// M�todo de presionar bot�n Stop
procedure TForm1.bStopMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Funci�n de escritura con valor 1
   bStop.ImageIndex := 3;        // Cambia imagen de bot�n
   WriteOPCItem(OPCClient,'TAGS' ,STOP_V.ItemName,'1')
end;

// M�todo de soltar bot�n Stop
procedure TForm1.bStopMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Funci�n de escritura con valor 0
  bStop.ImageIndex := 2;      // Cambia imagen de bot�n
  WriteOPCItem(OPCClient,'TAGS' ,STOP_V.ItemName,'0')
end;

// M�todo de presionar bot�n RESET
procedure TForm1.bResetMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  bReset.ImageIndex := 5;   // Cambia imagen de bot�n
  // Funci�n de escritura con valor 1
  WriteOPCItem(OPCClient,'TAGS' ,RESET_V.ItemName,'1');
  imgVastago_4.Left := 1112;      // Mueve v�stago a la derecha
  imgVastago_5.Left := 1112;      // Mueve v�stago a la derecha
  lRep.Caption := '1 rep.';      // Reinicia label de repeticiones
end;

// M�todo de soltar bot�n RESET
procedure TForm1.bResetMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // Funci�n de escritura con valor 0
  bReset.ImageIndex := 4;        // Cambia imagen de bot�n
  WriteOPCItem(OPCClient,'TAGS' ,RESET_V.ItemName,'0')
end;


// M�todo de presionar bot�n confirmaci�n contador
 procedure TForm1.bOK_CClick(Sender: TObject);
begin
  // Escribe nuevo valor de repeticiones
  WriteOPCItem(OPCClient,'TAGS' ,COUNT_0_PRE.ItemName, leCount.Text);
  Screen.Cursor := crDefault;   // Regresa cursor a predeterminado
  // Cambia label con nuevo valor
  leCount.EditLabel.Caption := leCount.Text + ' rep.';
  lRep.Caption  :=  '1 rep.';
end;

// M�todo de presionar bot�n confirmaci�n temporizador
procedure TForm1.bOK_TClick(Sender: TObject);
begin
  // Escribe nuevo valor de temporizador
  WriteOPCItem(OPCClient,'TAGS' ,TIMER_0_PRE.ItemName, FloatToStr(StrToInt(leTimer.Text)*100));
  Screen.Cursor := crDefault;   // Regresa cursor a predeterminado
  // Cambia label con nuevo valor
  leTimer.EditLabel.Caption := leTimer.Text + ' [s]';
end;


// Evento fin de timer entre cil�ndros neum�ticos (4 y 5)
procedure TForm1.TimerRoutineTimer(Sender: TObject);
begin
  time_up:= time_up + 1;
  if time_up = 1 then      // Tiempo entre cil�ndro 4 y 5
  begin
      Form1.imgVastago_5.Left := 929;     // Mueve cilindro 5 a la izquierda
      Form1.TimerRoutine.Enabled := false;       // Reinicia timer
      Form1.TimerRoutine.Enabled := true;
  end;

  if time_up = 2 then
  begin                    // Tiempo para compresi�n de cil�ndros 4 y 5
      Form1.imgVastago_4.Left := 1112;      // Mueve cilindro 4 a la derecha
      Form1.imgVastago_5.Left := 1112;      // Mueve cilindro 5 a la derecha
      Form1.TimerRoutine.Enabled := false;  // Desactiva timer
  end;
end;

// Evento OPCServer->OnDataChange
procedure TForm1.OPCClientDatachange(Sender: TObject; ItemList: TdOPCItemList);
begin
  var
  readvalue: Variant;
  begin
    if ItemList.Count > 0 then      // Condici�n de lista no vac�a
    begin
      try
      // Lee sensor de l�mite de compresi�n de pist�n 1
        readValue:= ReadOPCItem(OPCClient,'TAGS',SC1.ItemName)
      finally
        if readValue = 1 then     // Si valor de salida es 1
        begin
        imgVastago_1.Left := 1096;
        imgRedC1.Visible := true;     // Muestra indicador de sensor C1
        imgRedE1.Visible := false;     // Oculta indicador de sensor C1
        Screen.Cursor := crDefault;   // Regresa cursor a predeterminado
        end;
      end;

      try
      // Lee sensor de l�mite de expansi�n de pist�n 1
        readValue:= ReadOPCItem(OPCClient,'TAGS',SE1.ItemName)
      finally
        if readValue = 1 then     // Si valor de salida es 1
        begin
        imgVastago_1.Left := 822;
        imgRedE1.Visible := true;     // Muestra indicador de sensor E1
        imgRedC1.Visible := false;     // Oculta indicador de sensor C1
        Screen.Cursor := crDefault;   // Regresa cursor a predeterminado
        end;
      end;

      try
      // Lee sensor de l�mite de compresi�n de pist�n 2
        readValue:= ReadOPCItem(OPCClient,'TAGS',SC2.ItemName)
      finally
        if readValue = 1 then     // Si valor de salida es 1
        begin
        imgVastago_2.Left := 1096;
        imgRedE2.Visible := false;    // Oculta indicador de sensor E1
        imgRedC2.Visible := true;     // Muestra indicador de sensor C1
        Screen.Cursor := crDefault;   // Regresa cursor a predeterminado
        end;
      end;

      try
      // Lee sensor de l�mite de expansi�n de pist�n 2
        readValue:= ReadOPCItem(OPCClient,'TAGS',SE2.ItemName)
      finally
        if readValue = 1 then     // Si valor de salida es 1
        begin
        imgVastago_2.Left := 822;
        imgRedE2.Visible := true;     // Muestra indicador de sensor E2
        imgRedC2.Visible := false;     // Oculta indicador de sensor C2
        Screen.Cursor := crDefault;   // Regresa cursor a predeterminado
        end;
      end;

      try
      // Lee sensor de l�mite de compresi�n de pist�n 3
        readValue:= ReadOPCItem(OPCClient,'TAGS',SC3.ItemName)
      finally
        if readValue = 1 then     // Si valor de salida es 1
        begin
          imgVastago_3.Left := 1096;    // Mueve v�stago 5 a la derecha
          imgRedE3.Visible := false;    // Oculta indicador de sensor E3
          imgRedC3.Visible := true;     // Muestra indicador de sensor C3
          if pneumatic_temp = 1 then    // Condici�n de compresi�n en rutina
          begin
            time_up:= 0;         // Reinicia variable de cuenta de timer Delphi
            Form1.imgVastago_4.Left := 929;  // Mueve v�stago 4 a la izquierda
            Form1.TimerRoutine.Enabled := true;
            pneumatic_temp := 0;  // Reinicia condici�n de rutina neum. cuando E3->C3
          end;
        Screen.Cursor := crDefault;   // Regresa cursor a predeterminado
        end;
      end;

      try
      // Lee sensor de l�mite de expansi�n de pist�n 3
        readValue:= ReadOPCItem(OPCClient,'TAGS',SE3.ItemName)
      finally
        if readValue = 1 then     // Si valor de salida es 1
        begin
        imgVastago_3.Left := 822;     // Mueve v�stago 3 a la izq.
        imgRedE3.Visible := true;     // Muestra indicador de sensor E3
        imgRedC3.Visible := false;     // Oculta indicador de sensor C3
        pneumatic_temp := 0;           // Condici�n de rutina neum. cuando E3->C3
        pneumatic_temp := pneumatic_temp + 1;
        Screen.Cursor := crDefault;   // Regresa cursor a predeterminado
        end;
      end;

      try
      // Lee Dn Timer 1 (Fin de secuencia neum�tica)
        readValue:= ReadOPCItem(OPCClient,'TAGS',TIMER_1_DN.ItemName)
      finally
        if readValue = 1 then     // Si valor de salida es 1
        begin
        // Actualiza repetici�n actual en label
        lRep.Caption := IntToStr(StrToInt(ReadOPCItem(OPCClient,'TAGS',COUNT_0_ACC.ItemName))+1) +' rep.';
        Screen.Cursor := crDefault;   // Regresa cursor a predeterminado
        end;
      end;

      end;
    end;
  end;
end.
