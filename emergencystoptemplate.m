function main ();
Stop_Button = 0; % Assigned to the GUI  Emergency Stop button
start = 1; %assign to a start button on GUI
enable = 0;

%%

function emergency()  % emergency stop button
    

    if Stop_Button ==1  %% check if stop button is pressed
        enable = 0;
        fprintf 'EMERGENCY STOP'
    else if Stop_Button ==0, start==1  %%check if stop button is unpressed AND start button has been pessed
      
        
        enable = 1;
        fprintf 'ok' %mostly for debugging 
    end

end


    
end
  
    
%% setup code here


%%
emergency % checking that the emergency stop is not pressed and the start button has been pressed required to start the while loop
while enable ==1        % check if emergency button is pressed
    emergency
    if enable ==0
        break
    end 
    fprintf 'run main code'
    
    Stop_Button = 1;  % test
    


end








end

