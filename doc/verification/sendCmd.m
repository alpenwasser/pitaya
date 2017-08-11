function response = sendCmd(sock, cmd, timeout)
    ccmd = double(cmd)';
    fprintf(sock, ccmd);

    start = clock;
    while(sock.BytesAvailable <= 0 && etime(clock,start) < timeout)
        drawnow
    end
    if(sock.BytesAvailable > 0)
        response = fscanf(sock, '%s', sock.BytesAvailable);
    end
end