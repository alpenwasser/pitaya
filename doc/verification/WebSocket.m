classdef WebSocket < WebSocketClient
    %CLIENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        Callback
        SamplingRate
        FrameSize
    end
    
    methods
        function obj = WebSocket(varargin)
            %Constructor
            obj@WebSocketClient(varargin{1}, varargin{5:end});
            obj.Callback = varargin{2};
            obj.SamplingRate = varargin{3};
            obj.FrameSize = varargin{4};
        end
    end
    
    methods (Access = protected)
        function onOpen(obj,message)
            % This function simply displays the message received
            fprintf('%s\n',message);
            obj.send('{ "setNumberOfChannels": 2 }');
            obj.send(strcat('{ "frameConfiguration": { "frameSize": ', int2str(obj.FrameSize), ', "pre": ', int2str(obj.FrameSize / 2), ', "suf": ', int2str(obj.FrameSize / 2), ' } }'));
            obj.send('{ "triggerOn": {"type": "risingEdge", "channel": 1,"level": 32768, "slope":0}}');
            obj.send('{ "requestFrame": true, "channel": 1}');
            obj.send(strcat('{ "samplingRate": ', int2str(obj.SamplingRate), ' }'));
        end
        
        function onTextMessage(obj,message)
            % This function simply displays the message received
            fprintf('Message received:\n%s\n',message);
        end
        
        function onBinaryMessage(obj,bytearray)
            % This function simply displays the message received
            fprintf('Binary message received:\n');
            x = typecast(bytearray, 'uint16');
            x = cast(cast(x, 'int32') - 2^15, 'double');
            obj.Callback(x, obj.SamplingRate);
            obj.close();
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
