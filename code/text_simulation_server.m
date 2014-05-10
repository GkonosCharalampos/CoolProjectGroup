javaaddpath('gson-2.2.4.jar');
import com.google.gson.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;
import java.io.BufferedReader;
import java.io.InputStreamReader;

global graph cars nodes paths millis tottime safetydist defaultspeed;

json = Gson;
tottime = 0;
stop = 0;
while not(stop)
        
    message = input('command: ','s');        
    
    if(message == '1') 
        initialize_simulation();        
        'initialize_simulation'
    elseif (message == '2')
        advance_simulation();  
        'advance_simulation'
    elseif (message == '0')       
        'stop simulation'
        stop = 1;
        continue
    else
        'skip'
        continue
    end
  
    data = cars(:,1:2)    
end