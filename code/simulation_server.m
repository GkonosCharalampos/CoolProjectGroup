javaaddpath('/Users/simone/Documents/MATLAB/gson-2.2.4.jar');
import com.google.gson.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;
import java.io.BufferedReader;
import java.io.InputStreamReader;

%[nodes,edges,sources,sinks,paths] = initialize_simulation();

listener = ServerSocket(8181);

state = [];

json = Gson;

stop = 0;
while not(stop)
    
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
    
    if(message == '1') 
        [nodes,sources,sinks,paths,delay] = initialize_simulation();
        response(out);
        'initialize_simulation'
    elseif (message == '2')
        [nodes,sources,sinks,paths,delay] = ... 
                advance_simulation(nodes,sources,sinks,paths,delay);
        response(out);
        'advance_simulation'
    elseif (message == '0')
        response(out);
        'stop simulation'
        stop = 1;
    else
        'skip'
        response(out);
    end
                
    socket.close();       
end
listener.close();