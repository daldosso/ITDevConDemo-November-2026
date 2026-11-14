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
begin
  ReportMemoryLeaksOnShutdown := True;
  try
    LServerListener := TMVCListener.Create(
      TMVCListenerProperties.New
        .SetName('Listener1')
        .SetPort(8081)
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
    Writeln('Server running on http://localhost:8080');
    Writeln('Press Enter to stop...');
    Readln;
    LServerListener.Stop;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
