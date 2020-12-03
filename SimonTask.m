clear all; close all; % 'clear all' will clear all the variables/data stored on workspace. 'closes all' closes  the figures that are currently open in MATLAB
partStr = 'SimonTask';

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Simon Task %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The Simon task is a choice-reaction task whereby the participant responds
% to non-spatial attributes of stimuli by pressing the corresponding keys
% on the left or the right. They are also asked to ignore the physical
% position of the stimuli on the screen and only focus their responses on
% the corresponding keys to the stimuli.
% the following data is recorded after each run through the experiment: 
% response times, which key was pressed, and what condition was in each trial.


%% On-screen presentation %%

% the following section of code (lines 20 to 35) have been mainly based
% of off Peter Scarfe's PTB tutorials (see journal)

AssertOpenGL;
screens = Screen('Screens'); % returns an array of numbers, where each number represents one screen connected to the computer 
screenNumber = max(screens); % tells us which screenrect is to be returned

[window, screenRect] = Screen('OpenWindow', screenNumber, [0 0 0]); % opens a black on-screen window

rect = Screen('Rect', window); % returns an array with the top left corner and the bottom right corner coordiantes of the screen
[screenXpixels, screenYpixels] = Screen('WindowSize', window); % gets the size of the screen window in pixels

[center(1), center(2)] = RectCenter(screenRect); % calculates the centre position of the screen and returns it in variable 'center'
% center(1) returns the x-coordinate and center(2) returns the y-coordinate

ifi = Screen('GetFlipInterval', window); % this returns the flip interval (in seconds) of the frame duration

Priority(MaxPriority(window)); % this prioritises Psychtoolbox when the experiment is running so that 
HideCursor(); % the cursor is hidden on the screen so that it doesn't distract the participant whilst they are doing the experiment

%% Trials and conditions in the experiment %%

% the following lines of code (lines 44 to 56) have been taken and modified
% from Erman Misirlisoy's book (see journal). I also added variables for
% practice trials so that the participant is able to have a practice
% session before moving on to the real experiment.

TotalTrials = 20; % total number of trials in the task - I have changed the original code in order to give the variable a different name
BlueTrials = 10; % number of blue square trials as opposed to red square trials. 
PracticeTrials = 6; % total number of practice trials
BluePractice = 3; % total number of blue squares in the practice trials 

Response = zeros(TotalTrials, 1); % will record whether or not a key is pressed at each trial of the experiment
StimulusTime = zeros(TotalTrials, 1); % will record the time at which the stimulus was presented on-screen for each trial
ReactionTime = zeros(TotalTrials, 1); % will record the point in time at which the response key was pressed (will leave a 0 for NoGo responses)
% at this point, all three of these variables are a column of ten zeros, one for each trial of the experiment

conditions = [repmat(1,1,BlueTrials),repmat(2,1,TotalTrials-BlueTrials)]; % this represents the combinations of trials
rng('shuffle'); % ensures that the same sequence of numbers are not always generated at a fresh start
conditionsrand = conditions(randperm(length(conditions))); % 'conditionsrand' randomises the order of the elements in the conditions variable using 'randperm'


%% Instructions to be presented on the screen %%

% I mainly took lines 65 to 80 from Peter Scarf'es Psychtoolbox tutorials
% online (see journal). I modified the text size, font and style to tailor 
% to my specific experiment.

screentext= ' Welcome to the Simon task! \n\n\n\n On each trial in this experiment, you will see a fixation point followed by a blue square or a red square. \n\n\n These squares will be shown on either the right side or the left side of the screen. \n\n\n Press the "A" key to respond if you see a RED square. \n\n\n Press the "L" key if you see a BLUE square. \n\n\n\n Try and respond as quickly as possible. \n\n\n If you are too slow, you will get a message saying so which will stay on the screen for a second before disappearing.\n\n\n\n\n Press any key to start your practice trial.';

% formatting the text size, font, style, and colour
Screen('TextSize', window, 20); % changes the size of the text
Screen('TextFont',window,'Courier'); % changes the text font
Screen('TextStyle',window,1); % formats the style of the text

DrawFormattedText(window,screentext, center(1)-860 ,center(2)-350,[255 255 255]); % this draws the text on the screen and positions it onto its respective coordinates
% I have changed the original code from 'center', 'center', to center(1) and
% center(2) as I have already included these arguments above and the script
% will not run otherwise if these arguments are not consistent within the
% script.

Screen('Flip', window); % draws all of the previous commands and displays/flips them onto the screen
KbStrokeWait; % this waits for the participant to press any key to terminate the current screen and continue on to the next screen
Screen('Flip', window);

% the code below from lines 87 to 96 were taken and modified from Kielan's
% 'DrawAPicture' demonstration on the PSM207 Moodle page. I used these
% codes to create a red square and a blue square that will be presented on
% either the left or right side of the screen in each trial.

StimWidth = 150; % This variable defines the size of the shape in pixels (in this case the square is 200 by 200 pixels).
% The coordinates correspond to the top left and bttom right coordinates of the rectangle respectively
DRect = [0 0 StimWidth StimWidth]; % create coordinates for a square
DRect = CenterRect(DRect, screenRect); % center them within screen
DRect = OffsetRect(DRect, -500, -20); % initial offset (to the left)
Right = OffsetRect(DRect, center(1)+75, 0); % positioning the square to the right

colours = [255 0 0 ; 0 0 255]; % getting the red and blue squares

Screen('FillRect', window, [0 0 0]); % draw the rect to the screen

% defining key names of interest in the study
KbName ('UnifyKeyNames');
AKey = KbName ('A'); % 'A' key is defined as a button press
LKey = KbName ('L'); % 'L' key is define as a button press

% the timing of stimulus presentation
% Query duration of the monitor refresh interval:
InterFrameInterval=Screen('GetFlipInterval', window);


%% Practice trial loop %%

% this section involves the practice trials that the participants will 
% through before taking part in the actual experiment. Here, you will find 
% that the codes for the practice trial and the real experiment are the 
% same - the only difference is the screentext which shows up before the 
% trials, explaining to the participant that they are about to take part 
% in a practice run. 

for trial = 1:PracticeTrials
    
    
Screen('gluDisk', window, [255 255 255], center(1), center(2), [20]); % draws a fixation dot on the screen
Screen('Flip', window); 
WaitSecs(1); % the fixation point will appear for one second before the stimulus appears

% when randomising my trials I firstly created a variable to tell MATLAB 
% that have four conditions. I  

    conditionsrand = 4; % I have four conditions that need to be randomised across each trial
    thisCondition = randi(conditionsrand); % I want to create a variable that specifies that if this is a certain condition, then randomise it across the trials

    if thisCondition == 1
         Screen('FillRect', window, [255 0 0], DRect); % draw a Red square on the left side of the screen
        elseif thisCondition == 2
            Screen('FillRect', window, [255 0 0], Right); % draw a Red square on the right side of the screen
        elseif thisCondition == 3
                Screen('FillRect', window, [0 0 255], DRect); % draw a Blue square on the left side of the screen
        elseif thisCondition == 4
                Screen('FillRect', window, [0 0 255], Right); % draw a Blue square on the right side of the screen

    end
  
    Screen('Flip', window);
    timelimit = 0.45; % the stimulus is presented for 500ms
    starttime = GetSecs(); % get the start time from when the stimulus is first presented on the screen.
    resptime = GetSecs-starttime; % this variable is saying to get the response time by subtracting the 
    
    notResp = 1; 
    respLR =0;
    while notResp == 1 && resptime <= timelimit % whilst the participant responds AND also whilst the
    % response time is less than or equal to 450ms, then their response
    % will be recorded and the loop will continue onto the next trial
        
        [keyIsDown, seconds, keyCode] = KbCheck; % 
        if keyIsDown % if any key is pressed
            if keyCode(KbName('A')) == 1 % if the key pressed is the A key
                notResp = 0; % if there is no response, then it will be recorded as 0
                respLR = 1; % the A key is the left key response, which will be recorded as 1
            end
            if keyCode(KbName('L')) == 1 % if the key pressed is the L key
                notResp = 0; % if there is no response, then it will be recorded as 0
                respLR = 2;  % the L key is the right key response, which will be recorded as 2
            end
        end
        resptime = GetSecs-starttime; % response time will be recorded as the start time of the on-screen stimulus subtracted from 
    end
    
    
   
    %clear screen
    Screen('FillRect',window,[0 0 0] ,screenRect); % stays on a black screen
    Screen('Flip',window);
    %insert a break
    WaitSecs(0.7); % wait 700ms second before moving on to the next trial
    
    
    %if the time to respond is too slow, then present an on-screen message to the participant informing them this
 
    if resptime > timelimit % if the participant's response time is more than 450ms, then a feedback message will be displayed on the screen for 600ms before moving on to the next trial
        screentext = 'Too slow!'; % this is the text will be shown on the screen
        Screen('TextSize', window, 32); % changes the size of the text
        Screen('TextFont',window,'Courier'); % changes the text font
        Screen('TextStyle',window,1);
      DrawFormattedText(window, screentext, center(1)-90, center(2), [255 0 0]); % draws the text on the screen, a little to the left, and it will be in red
      Screen('Flip', window);
        WaitSecs(0.6); % wait 600ms before moving on to the next trial
    
    end
    
    
end

%% Real Experiment loop %%

screentext= ' The real experiment is now about to begin. \n\n\n Remember, the "A" key corresponds to the RED square. \n\n The "L" key corresponds to the BLUE square. \n\n Ignore the location of the stimulus when responding. \n\n\n Press any key when you are ready to start the experiment.';
Screen('TextSize', window, 25); % changes the size of the text
Screen('TextFont',window,'Courier'); % changes the text font
Screen('TextStyle',window,1); % formats the style of the text

DrawFormattedText(window,screentext, center(1)-500 ,center(2)-200,[255 255 255]); % this draws the text on the screen and positions it onto its respective coordinates
Screen('Flip', window); % draws all of the previous commands and displays/'flips' them onto the screen
KbStrokeWait; % this waits for the participant to press any key to terminate the current screen and continue on to the next screen
Screen('Flip', window);


for trial = 1:TotalTrials
    
    
Screen('gluDisk', window, [255 255 255], center(1), center(2), [20]); % draws a fixation dot on the screen
Screen('Flip', window); 
WaitSecs(1); % stays on the screen for one second

    conditionsrand = 4; 
    thisCondition = randi(conditionsrand);

    if thisCondition == 1
         Screen('FillRect', window, [255 0 0], DRect); 
        elseif thisCondition == 2
            Screen('FillRect', window, [255 0 0], Right); 
        elseif thisCondition == 3
                Screen('FillRect', window, [0 0 255], DRect); 
        elseif thisCondition == 4
                Screen('FillRect', window, [0 0 255], Right); 

    end
  
    Screen('Flip', window);
    timelimit = 0.45; % the stimulus is presented for 500ms
    starttime = GetSecs(); %get start time
    resptime = GetSecs-starttime; % the variable 'response time' is measured by the onset of the stimulus on the screen
    
    notResp = 1; % no response will show up as '0' in the data file
    respLR =0; % any left of right response will show up as '1' in the data file
    while notResp == 1 && resptime <= timelimit % whilst the participant responds AND also whilst the
    % response time is less than or equal to 450ms, then their response
    % will be recorded and the loop will continue onto the next trial
        
        [keyIsDown, seconds, keyCode] = KbCheck; % 'keyIsDown' returns the status of the keyboard, 'seconds' records the time interval at which the button was pressed, and 'keyCode' is a 256-element array  
        if keyIsDown % if any key is pressed
            if keyCode(KbName('A')) == 1 % if the key pressed is the A key
                notResp = 0; % if there is no response, then it will be recorded as 0
                respLR = 1; % the A key is the left key response, which will be recorded as 1
            end
            if keyCode(KbName('L')) == 1 % if the key pressed is the L key
                notResp = 0; % if there is no response, then it will be recorded as 0
                respLR = 2;  % the L key is the right key response, which will be recorded as 2
            end
        end
        resptime = GetSecs-starttime; % response time will be recorded as the start time of the on-screen stimulus subtracted from 
    end
    
    
   
    %clear screen
    Screen('FillRect',window,[0 0 0] ,screenRect); % stays on a black screen
    Screen('Flip',window);
    WaitSecs(0.7); % wait 700ms second before moving on to the next trial
    
    %if too slow speed up
    if resptime > timelimit % if the participant's response time is more than 450ms, then a feedback message will be displayed on the screen for 600ms before moving on to the next trial
        screentext = 'Too slow!'; % this is the text that will be shown on the screen when participants are too slow to respond
        Screen('TextSize', window, 32); % changes the size of the text
        Screen('TextFont',window,'Courier'); % changes the text font
        Screen('TextStyle',window,1);
      DrawFormattedText(window, screentext, center(1)-90, center(2), [255 0 0]); % draws the text on the screen, a little to the left, and it will be in red
      Screen('Flip', window);
        WaitSecs(0.6); % waits 600ms second before moving on to the next trial
    
    end
    
      
    %trial matrix that records data
    trialMat(trial,:) = [thisCondition, resptime, respLR]; 
    
end

save(partStr, 'trialMat') % saves the data recorded from the experiment into a variable called 'trialMat'

%% End of experiment %%
 screentext = ' The experiment is now over! \n\n Thank you for your participation.\n\n\n\n Press any key to exit the experiment.';
        Screen('TextSize', window, 25); % changes the size of the text
        Screen('TextFont',window,'Courier'); % changes the text font
        Screen('TextStyle',window,1);
      DrawFormattedText(window, screentext, center(1)-350, center(2)-100, [255 255 255]); 
      Screen('Flip', window);
      KbStrokeWait;
     

%close down the psychtoolbox display window
Screen('CloseAll');
ShowCursor();
sca;
