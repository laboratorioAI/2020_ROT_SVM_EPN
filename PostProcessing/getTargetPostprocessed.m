% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------

function TargetFixed = getTargetPostprocessed(emgDataTarget,sourceData)


if sourceData =="online"
    clc
    
            conditionBuffer       =  evalin('base','conditionBuffer');
            conditionBuffer_one   =  evalin('base','conditionBuffer_one');
            conditionBuffer_two   =  evalin('base','conditionBuffer_two');
            
            
            responseBuffer        =  evalin('base', 'responseBuffer');
            responseBuffer_one    =  evalin('base', 'responseBuffer_one');
            responseBuffer_two    =  evalin('base', 'responseBuffer_two');
            counter_target        =  evalin('base', 'counter_target');
            
            
            
            % ====================================================
            if counter_target>=3
                emgDataTarget='noGesture';
                counter_target=0;
                assignin('base','counter_target', counter_target);
            end
            
            
            %==========================================================================
            if conditionBuffer_two == true
                
                if string(emgDataTarget)=="noGesture"
                    
                    assignin('base','conditionBuffer',     false);
                    assignin('base','conditionBuffer_one', false);
                    assignin('base','conditionBuffer_two', false);
                    assignin('base','responseBuffer',     'noGesture');
                    assignin('base','responseBuffer_one', 'noGesture');
                    assignin('base','responseBuffer_two', 'noGesture');
                    TargetFixed     = 'noGesture';
                    
                elseif string(emgDataTarget)~=string(responseBuffer_one)
                    TargetFixed=responseBuffer_one;
                    counter_target=counter_target+1;
                    assignin('base','counter_target', counter_target);
                else
                    TargetFixed=emgDataTarget;
                    assignin('base','responseBuffer', TargetFixed);
                    assignin('base','responseBuffer_one', TargetFixed);
                    
                end
            end
            
            %====================================================================
            if conditionBuffer_one == true && conditionBuffer_two == false
                
                if (string(emgDataTarget)~= string(responseBuffer_two))
                    
                    responseBuffer_two=emgDataTarget;
                    assignin('base','responseBuffer_two', responseBuffer_two);
                    
                    if string(responseBuffer_one)==string(responseBuffer_two)
                        conditionBuffer_two = true;
                        assignin('base','conditionBuffer_two',conditionBuffer_two);
                        TargetFixed     = emgDataTarget;
                    else
                        conditionBuffer_one = false;
                        assignin('base','conditionBuffer_one',conditionBuffer_one);
                        TargetFixed     = 'noGesture';
                    end
                else
                    TargetFixed     = emgDataTarget;
                    conditionBuffer_two = true;
                    assignin('base','conditionBuffer_two',conditionBuffer_two);
                    
                end

            end
            
            %==================================================================================
            if conditionBuffer == true && conditionBuffer_one == false

                if (string(emgDataTarget)~= string(responseBuffer_one))
                    
                    responseBuffer_one=emgDataTarget;
                    assignin('base','responseBuffer_one', responseBuffer_one);
                    
                    if string(responseBuffer)==string(responseBuffer_one)
                        conditionBuffer_one = true;
                        assignin('base','conditionBuffer_one',conditionBuffer_one);
                        TargetFixed     = emgDataTarget;
                    else
                        conditionBuffer_one = false;
                        assignin('base','conditionBuffer_one',conditionBuffer_one);
                        
                        conditionBuffer = false;
                        assignin('base','conditionBuffer',conditionBuffer);
                        assignin('base','responseBuffer',     'noGesture');
                        TargetFixed     = 'noGesture';
                    end
                else
                    TargetFixed     = emgDataTarget;
       
                end

            end
            %====================================================================================
            if (string(emgDataTarget)~= string(responseBuffer)) && conditionBuffer == false
                
                responseBuffer=emgDataTarget;
                assignin('base','responseBuffer', responseBuffer);
                conditionBuffer = true;
                assignin('base','conditionBuffer',conditionBuffer);
                
                TargetFixed     = 'noGesture';
                
            elseif (string(emgDataTarget)== string(responseBuffer)) && conditionBuffer == false
                TargetFixed     = 'noGesture';
            end




end



if sourceData =="offline"
    
    controlExit      =  evalin('base','controlExit');
    usuario          =  evalin('base','usuario');
    
    if controlExit==true && usuario~="NaN"
        
        response         =  evalin('base','response');
        emgRepetition    =  evalin('base','emgRepetition');
        
        % ========================================================================================
        % This code gest the summary of the actual specific user
        % whose EMG data is analized
        %
        resume               =  response.(usuario).vectorOfLabels{emgRepetition,1}(1,:);
        resumeTimePoints     =  response.(usuario).vectorOfTimePoints{emgRepetition,1}(1,:);
        resumeProcessingTime =  response.(usuario).vectorOfProcessingTime{emgRepetition,1}(1,:);
        
        idwaveOut = strfind(resume, 'waveOut');
        idwaveOut = find(not(cellfun('isempty', idwaveOut)));
        waveOut_  = length(idwaveOut);
        
        idwaveIn  = strfind(resume, 'waveIn');
        idwaveIn  = find(not(cellfun('isempty', idwaveIn)));
        waveIn_   = length(idwaveIn);
        
        idfist    = strfind(resume, 'fist');
        idfist    = find(not(cellfun('isempty', idfist)));
        fist_     = length(idfist);
        
        idopen    = strfind(resume, 'open');
        idopen    = find(not(cellfun('isempty', idopen)));
        open_     = length(idopen);
        
        idpinch   = strfind(resume, 'pinch');
        idpinch   = find(not(cellfun('isempty', idpinch)));
        pinch_    = length(idpinch);
        
        vector      = [waveOut_ waveIn_ fist_ open_ pinch_ ];
        checkVector = max(vector);
        
        if checkVector==0
            TargetFixed='noGesture';
        else
            [~,pos]=max(vector);
            switch pos
                
                case 1
                    TargetFixed='waveOut';
                case 2
                    TargetFixed='waveIn';
                case 3
                    TargetFixed='fist';
                case 4
                    TargetFixed='open';
                case 5
                    TargetFixed='pinch';
                    
            end
        end
        response.(usuario).class{emgRepetition,1}{1,1} = TargetFixed;
        assignin('base','response',response);
        
        
        
        % ================================================================
        
        % ================================================================
        % This code returns to the original values to start analizing
        % new user data
        %
        
        assignin('base','responseIndex',1);
        assignin('base','responseBuffer', 'noGesture');
        assignin('base','emgRepetition',emgRepetition+1);
        
        
        % ================================================================
        
        % ================================================================
        % This code gets values and send these to be analized by J
        % code
        %
        
        
        
    else
        
        if usuario~="NaN"
            timeAnalized     =  evalin('base','timeAnalized');
            response         =  evalin('base','response');
            responseIndex    =  evalin('base','responseIndex');
            timeRecognition  =  evalin('base','timeRecognition');
            usuario          =  evalin('base','usuario');
            emgRepetition    =  evalin('base','emgRepetition');
            %=================================================

            conditionBuffer       =  evalin('base','conditionBuffer');
            conditionBuffer_one   =  evalin('base','conditionBuffer_one');
            conditionBuffer_two   =  evalin('base','conditionBuffer_two');
            
            
            responseBuffer        =  evalin('base', 'responseBuffer');
            responseBuffer_one    =  evalin('base', 'responseBuffer_one');
            responseBuffer_two    =  evalin('base', 'responseBuffer_two');
            counter_target        =  evalin('base', 'counter_target');
            
            
            
            % ====================================================
            if counter_target>=2
                emgDataTarget='noGesture';
                counter_target=0;
                assignin('base','counter_target', counter_target);
            end
                
            %==========================================================================
            if conditionBuffer_two == true
                
                if string(emgDataTarget)=="noGesture"
                    
                    assignin('base','conditionBuffer',     false);
                    assignin('base','conditionBuffer_one', false);
                    assignin('base','conditionBuffer_two', false);
                    assignin('base','responseBuffer',     'noGesture');
                    assignin('base','responseBuffer_one', 'noGesture');
                    assignin('base','responseBuffer_two', 'noGesture');
                    TargetFixed     = 'noGesture';
                    
                elseif string(emgDataTarget)~=string(responseBuffer_one)
                    TargetFixed=responseBuffer_one;
                    counter_target=counter_target+1;
                    assignin('base','counter_target', counter_target);
                else
                    TargetFixed=emgDataTarget;
                    assignin('base','responseBuffer', TargetFixed);
                    assignin('base','responseBuffer_one', TargetFixed);
                    
                end

            end
            
            %====================================================================
            if conditionBuffer_one == true && conditionBuffer_two == false
                
                if (string(emgDataTarget)~= string(responseBuffer_two))
                    
                    responseBuffer_two=emgDataTarget;
                    assignin('base','responseBuffer_two', responseBuffer_two);
                    
                    if string(responseBuffer_one)==string(responseBuffer_two)
                        conditionBuffer_two = true;
                        assignin('base','conditionBuffer_two',conditionBuffer_two);
                        TargetFixed     = emgDataTarget;
                    else
                        conditionBuffer_one = false;
                        assignin('base','conditionBuffer_one',conditionBuffer_one);
                        TargetFixed     = 'noGesture';
                    end
                else
                    TargetFixed     = emgDataTarget;
                    conditionBuffer_two = true;
                    assignin('base','conditionBuffer_two',conditionBuffer_two);
                    
                end

            end
            
            %==================================================================================
            if conditionBuffer == true && conditionBuffer_one == false
          
                if (string(emgDataTarget)~= string(responseBuffer_one))
                    
                    responseBuffer_one=emgDataTarget;
                    assignin('base','responseBuffer_one', responseBuffer_one);
                    
                    if string(responseBuffer)==string(responseBuffer_one)
                        conditionBuffer_one = true;
                        assignin('base','conditionBuffer_one',conditionBuffer_one);
                        TargetFixed     = emgDataTarget;
                    else
                        conditionBuffer_one = false;
                        assignin('base','conditionBuffer_one',conditionBuffer_one);
                        
                        conditionBuffer = false;
                        assignin('base','conditionBuffer',conditionBuffer);
                        assignin('base','responseBuffer',     'noGesture');
                        TargetFixed     = 'noGesture';
                    end
                    
              else
                     TargetFixed     = emgDataTarget;

             end
 
            end
            %====================================================================================
            if (string(emgDataTarget)~= string(responseBuffer)) && conditionBuffer == false
                
                responseBuffer=emgDataTarget;
                assignin('base','responseBuffer', responseBuffer);

                conditionBuffer = true;
                assignin('base','conditionBuffer',conditionBuffer);
                
                TargetFixed     = 'noGesture';
    
                
            elseif (string(emgDataTarget)== string(responseBuffer)) && conditionBuffer == false

                TargetFixed     = 'noGesture';
            end
            
 
            %=================================================
            
            response.(usuario).vectorOfLabels{emgRepetition,1}{1,responseIndex}         = TargetFixed;
            response.(usuario).vectorOfTimePoints{emgRepetition,1}{1,responseIndex}     = round(timeAnalized*(200));
            response.(usuario).vectorOfProcessingTime{emgRepetition,1}{1,responseIndex} = timeRecognition;
            assignin('base','response',response);
            responseIndex=responseIndex+1;
            assignin('base','responseIndex',responseIndex);
            fprintf('Gesture Predicted = %s \n',TargetFixed);
        else
            TargetFixed='noGesture';
        end
   
        
    end
    
end

end