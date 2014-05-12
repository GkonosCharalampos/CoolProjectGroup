javaaddpath('gson-2.2.4.jar');
import com.google.gson.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;
import java.io.BufferedReader;
import java.io.InputStreamReader;

clearvars;
global graph cars nodes paths millis travel_times over;

listener = ServerSocket(int32(8383));

init = 0;
json = Gson;

c = onCleanup(@()listener.close());

while 1

    socket = listener.accept();

    instream = socket.getInputStream();
    outstream = socket.getOutputStream();

    in = BufferedReader(InputStreamReader(instream));

    message = -1;
    line = in.readLine();
    if(~isempty(line) && ~isnumeric(line) && line.length() >= 6)
        line = line.substring(5,6);
        message = char(line);
    end

    out = PrintWriter(outstream);

    if message == '1'
        'initialize_simulation'
        init = 1;
        initialize_simulation(1000);
    elseif message == '0'
        'stop simulation'
        init = 0;
        break;
    elseif message ~= '2'
        'skip'
        continue;
    end

    'advance simulation'

    if init
        data = cars(:,1:2);
        if over
           response(out,[]);
           break;
        end

        response(out,data);
        advance_simulation();
    end

    socket.close();
end
listener.close();

fprintf('mean: %d\n std: %d\n', mean(travel_times), int32(std(travel_times)));
