javaaddpath('gson-2.2.4.jar');
import com.google.gson.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;
import java.io.BufferedReader;
import java.io.InputStreamReader;

listener = ServerSocket(8787);

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
        'initialize_simulation'
    elseif (message == '2')
        [nodes,sources,sinks,paths,delay] = ... 
                advance_simulation(nodes,sources,sinks,paths,delay);        
        'advance_simulation'
    elseif (message == '0')       
        'stop simulation'
        stop = 1;
    else
        'skip'        
    end
   
    numcars = size(sources,1);
    data = zeros(numcars,2);
    
    for i = 1:numcars
        sources(i)
        nodes(2:3,int32(sources(i)))
        data(i,:) = nodes(2:3,int32(sources(i)));
    end
        
    response(out,data);
    
    socket.close();       
end
listener.close();