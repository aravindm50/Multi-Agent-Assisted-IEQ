classdef Sim_server < WebSocketServer
    %ECHOSERVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Sim_server(varargin)
            %Constructor
            obj@WebSocketServer(varargin{:});
        end
    end
    
    methods (Access = protected)
        function onOpen(obj,conn,message)
            fprintf('%s\n',message)
        end
        
        function onTextMessage(obj,conn,message)
            % This function sends an echo back to the client
            %conn.send(message); % Echo
            fprintf('%s\n',message)
            if(~isnan(str2double(message)))
                set_param([gcs '/ROOM/Setpoint'],'Value',num2str(message));
            end
        end
        
        function onBinaryMessage(obj,conn,bytearray)
            % This function sends an echo back to the client
            conn.send(bytearray); % Echo
        end
        
        function onError(obj,conn,message)
            fprintf('%s\n',message)
        end
        
        function onClose(obj,conn,message)
            fprintf('%s\n',message)
        end
    end
end

