%% Test the rain detection function
clear all
close all

fileNameCells{1}='TestFile1.flac' ; %Lets assume this file starts at 9am on 13th august 2014
fileNameCells{2}='TestFile2.flac'; %This files follows on immeadiately from the the first one

startDate=datenum(2014,08,13,09,00,00);  % this is the date number

plotYN=1;  %plot updates as data is computed

 nCores=feature('numCores'); % how many processing cores do you have?

[RainDet, RainDetRaw, Time]=acousticRainDetection(fileNameCells,startDate,plotYN,nCores);


       plot((Time),RainDet)
        ax = gca;
        ax.XTick = Time;        
        datetick('x',15,'keepticks')
        xlabel('Time')
        ylabel('Detection Output (1=rain, 0 = rain free)')
        drawnow
