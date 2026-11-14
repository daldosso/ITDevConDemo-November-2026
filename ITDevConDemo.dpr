program ITDevConDemo;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Server,
  MVCFramework.Server.Impl,
  ITDevConController in 'ITDevConController.pas';

var
  LServerListener: IMVCListener;
  LPort: Integer;
begin
  ReportMemoryLeaksOnShutdown := True;
  try
    LPort := StrToIntDef(GetEnvironmentVariable('ITDEVCON_PORT'), 8081);
    LServerListener := TMVCListener.Create(
      TMVCListenerProperties.New
        .SetName('Listener1')
        .SetPort(LPort)
        .SetMaxConnections(1024)
        .SetConfigAction(
          procedure(Config: TMVCConfig)
          begin
            Config['document_root'] := 'www';
          end)
        .SetEngineConfig(
          procedure(Engine: TMVCEngine)
          begin
            Engine.AddController(TITDevConController);
          end)
    );
    LServerListener.Start;
    Writeln('Server running on http://localhost:', LPort);
    Writeln('Press Enter to stop...');
    Readln;
    LServerListener.Stop;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
