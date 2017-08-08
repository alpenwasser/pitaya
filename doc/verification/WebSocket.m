classdef WebSocket < WebSocketClient
    %CLIENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        Measurement
        DataReceived = false
    end
    
    methods
        function obj = WebSocket(varargin)
            %Constructor
            obj@WebSocketClient(varargin{:});
        end
    end
    
    methods (Access = protected)
        function onOpen(obj,message)
            % This function simply displays the message received
            fprintf('%s\n',message);
        end
        
        function onTextMessage(obj,message)
            % This function simply displays the message received
            fprintf('Message received:\n%s\n',message);
        end
        
        function onBinaryMessage(obj,bytearray)
            % This function simply displays the message received
            fprintf('Binary message received:\n');
            obj.Measurement = bytearray;
            x = typecast(bytearray, 'uint16');
            x = cast(cast(x, 'int32') - 2^15, 'double');
            snr(x, 50e3, 10);
            thd(x, 50e3, 10);
            obj.DataReceived = true;
        end
        
        function onError(obj,message)
            % This function simply displays the message received
            fprintf('Error: %s\n',message);
        end
        
        function onClose(obj,message)
            % This function simply displays the message received
            fprintf('%s\n',message);
        end
    end
end
