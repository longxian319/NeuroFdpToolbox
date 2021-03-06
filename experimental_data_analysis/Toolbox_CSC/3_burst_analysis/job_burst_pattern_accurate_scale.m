function job_burst_pattern_accurate_scale(arrayID)

cd ..
addpath(genpath([pwd,'/Toolbox_CSC']))
addpath(genpath([pwd,'/ToolOthers/ToolNeuroPatt']))
%%
% arrayID = 8 ;

switch arrayID
    case 1
        dataFileName = 'my144_101' ;
        timeStart = 0 ;     % for finding centres
        timeStart2 = 0;        % for movie
        subBand = [30 , 100] ;
        plotAmp = 1 ;
        % timeStep = 5 ;
        % totalSur = 200 ;
        minBurstTime = 25 ;
        % minSize = 4;      
        
    case 2
        dataFileName = 'my144_101' ;
        timeStart = 0 ;
        timeStart2 = 0;
        subBand = [30 , 100] ;
        plotAmp = 1 ;
        % timeStep = 5 ;
        % totalSur = 200 ;
        minBurstTime = 35 ;
        % minSize = 4 ;
        
    case 3
        dataFileName = 'my144_101' ;
        timeStart = 0 ;
        timeStart2 = 0;
        subBand = [30 , 100] ;
        plotAmp = 1 ;
        % timeStep = 5 ;
        % totalSur = 200 ;
        minBurstTime = 30 ;
        % minSize = 1 ;
        
    case 4
        dataFileName = 'my147_53' ;
        timeStart = 0 ;     % for finding centres
        timeStart2 = 0;        % for movie
        subBand = [30 , 100] ;
        plotAmp = 1 ;
        % timeStep = 5 ;
        Fs = 1.0173e3 ;
        % totalSur = 200 ;
        minBurstTime = 25 ;
        % minSize = 4;
        
    case 5
        dataFileName = 'my147_53' ;
        timeStart = 0 ;     % for finding centres
        timeStart2 = 0;
        subBand = [30 , 100] ;
        plotAmp = 1 ;
        % timeStep = 5 ;
        Fs = 1.0173e3 ;
        % totalSur = 200 ;
        minBurstTime = 35 ;
        % minSize = 4 ;
        
    case 6
        dataFileName = 'my147_53' ;
        timeStart = 0 ;     % for finding centres
        timeStart2 = 0;
        subBand = [30 , 100] ;
        plotAmp = 1 ;
        % timeStep = 5 ;
        Fs = 1.0173e3 ;
        % totalSur = 200 ;
        minBurstTime = 30 ;
        % minSize = 1 ;
        
    case 7
        dataFileName = 'ma027_032' ;
        timeStart = 0 ;     % for finding centres
        timeStart2 = 0;
        subBand = [30 , 100] ;
        plotAmp = 1 ;
        % timeStep = 5 ;
        % totalSur = 200 ;
        minBurstTime = 25 ;
        % minSize = 4;
        
    case 8
        dataFileName = 'ma027_032' ;
        timeStart = 0 ;     % for finding centres
        timeStart2 = 0;
        subBand = [30 , 100] ;
        plotAmp = 1 ;
        % timeStep = 5 ;
        % totalSur = 200 ;
        minBurstTime = 35 ;
        % minSize = 4 ;
        
    case 9
        dataFileName = 'ma027_032' ;
        timeStart = 0 ;     % for finding centres
        timeStart2 = 0;
        subBand = [30 , 100] ;
        plotAmp = 1 ;
        % timeStep = 5 ;
        % totalSur = 200 ;
        minBurstTime = 30 ;
        % minSize = 1 ;
        
    case 10
        dataFileName = 'ma025_03' ;
        timeStart = 0 ;     % for finding centres
        timeStart2 = 0;
        subBand = [30 , 100] ;
        plotAmp = 1 ;
        % timeStep = 5 ;
        % totalSur = 200 ;
        minBurstTime = 25 ;
        % minSize = 4;
        
    case 11
        dataFileName = 'ma025_03' ;
        timeStart = 0 ;     % for finding centres
        timeStart2 = 0;
        subBand = [30 , 100] ;
        plotAmp = 1 ;
        % timeStep = 5 ;
        % totalSur = 200 ;
        minBurstTime = 35 ;
        % minSize = 4 ;
        
    case 12
        dataFileName = 'ma025_03' ;
        timeStart = 0 ;     % for finding centres
        timeStart2 = 0;
        subBand = [30 , 100] ;
        plotAmp = 1 ;
        % timeStep = 5 ;
        % totalSur = 200 ;
        minBurstTime = 30 ;
        % minSize = 1 ;
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load([pwd,'/Data/UtahArrayData/',dataFileName],'LFPs','Fs')
%% preprocess the raw LFP data
fsTemporal = Fs ;
flagBandstop = 1 ;
[sigOri,~,badChannels] = preprocess_LFP(LFPs, flagBandstop) ;
clearvars LFPs
sigOriTemp = reshape(sigOri,10*10,[]) ;
surSigTemp = nan(size(sigOriTemp)) ;

%%
totalSur = 200 ;
for nSur = 1:totalSur
         randNumHalf =  2*pi*rand(size(sigOri,3)/2-1,1) ;
         randNum = [0;randNumHalf;0;-flip(randNumHalf) ]' ;
         for iChannel = setdiff(1:100,badChannels)
             freqSig = fft(sigOriTemp(iChannel,:)) ;
             absFreq = abs(freqSig) ;
             phaseFreq = angle(freqSig) ;
             reconSig = ifft(absFreq.*exp(1i*phaseFreq)) ;
    
             surSigTemp(iChannel,:) = ifft(absFreq.*exp(1i*(phaseFreq+randNum))) ;
         end
      surSig = reshape(real(surSigTemp),10,10,[]) ;
    
    % surSig = sigOri ;
    
    % find subband signals
    bandpassSig = find_bandpassSig(surSig,subBand, fsTemporal,3) ;
    hilbertSig = find_Hilbert(bandpassSig, fsTemporal,4) ;
    
    if plotAmp
        sigIn = abs(squeeze(hilbertSig(1,:,:,11*fsTemporal+1:150*fsTemporal) ));
    else
        sigIn = angle(squeeze(hilbertSig(1,:,:,11*fsTemporal+1:150*fsTemporal) ));
    end
    
    clearvars bandpassSig hilbertSig
    
    
    
    %% Interpolation and smoothing
    
    close all
    plotLength = fix(100*fsTemporal) ;
    sigSmooth = zeros(20,20,plotLength) ;
    % timeStart = 5000 ;
    
    addpath(genpath([pwd,'/ToolNeuroPatt']))
    addpath(genpath([pwd,'/ToolOthers/nanconv']))
    
    resizeScale = 2 ;
    for iTime = 1:plotLength
        timeSlot = iTime+timeStart ;
        %Try smoothing
        filtWidth = 3;
        filtSigma = 0.6;
        imageFilter=fspecial('gaussian',filtWidth,filtSigma);
        smoothTemp = nanconv(abs(squeeze(sigIn(:,:,timeSlot))),imageFilter,'edge', 'nonanout');
        sigSmooth(:,:,iTime) = imresize(smoothTemp, resizeScale);
    end
    clearvars smoothTemp
    % find 95 percentile
    if ~plotAmp
        sigBinary = zeros(size(sigSmooth)) ;
        sigBinary(sigSmooth>pi*5/6) = 1 ;
        sigPlot = sigBinary.*sigSmooth ;
    else
        boundPrctile = 95 ;
        prcBound = prctile(sigSmooth(:),boundPrctile) ;
        sigBinary = zeros(size(sigSmooth)) ;
        sigBinary(sigSmooth>prcBound) = 1;
        sigPlot = sigBinary.*sigSmooth ;
    end
    
    %%
    CC = bwconncomp(sigBinary) ;                % 3D
    % B = regionprops(CC,'BoundingBox');
    % boundary = cat(1, B.BoundingBox);
    Area = regionprops(CC,'Area') ;
    count = 1;
    % Centroids = [] ;
    % WCentroids = [] ;
    
    for iBurst = 1: size(CC.PixelIdxList,2)
        currentIdx = CC.PixelIdxList{iBurst} ;
        % Duration1(iBurst) = boundary(iBurst,6) ;    % should be similar to
        % Duration2
        burstTimeEnd = floor((currentIdx(end)-1)/400) +1 ;
        burstTimeStart = floor((currentIdx(1)-1)/400) +1 ;
        Duration2(iBurst) =  burstTimeEnd-burstTimeStart+1 ;    %
        if Duration2(iBurst) < minBurstTime
            continue
        end
        Duration(count,nSur) = burstTimeEnd-burstTimeStart+1 ;    % duration
        
        patternScale(count,nSur) = Area(iBurst).Area ;  % 4 total scale
        
%         burstIdxTemp = zeros(size(sigPlot)) ;
%         burstIdxTemp(currentIdx) = 1 ;
%         currentBurst = sigPlot.*burstIdxTemp ;
      %  sumAmp(count,nSur) = sum(currentBurst(:)) ;     % sum of amplitude
      %  peakAmp(count) = max(currentBurst(:)) ;    % peak amplitude
      % 
%         for iTime = burstTimeStart:burstTimeEnd   
%             instantPattern = currentBurst(:,:,iTime) ;          
%             instantBinary = burstIdxTemp(:,:,iTime) ;
%             instantScale(iTime,count,:) = sum(instantBinary(:)) ;  % instant scale
%             S = regionprops(instantBinary,instantPattern,{'Centroid','WeightedCentroid'});
%             Centroids(iTime,count,:) = cat(1, S.Centroid);
%             WCentroids(iTime,count,:) = cat(1, S.WeightedCentroid) ;
%         end 
%         if count>1
%             firstCentroidsLoc = squeeze(WCentroids(burstTimeStart,count,:)) ;
%             distCent(count) = sqrt(sum((firstCentroidsLoc - lastCentroidsLoc).^2)) ;
%             
%             firstCentroidsTime = burstTimeStart ;
%             centInterval(count) = firstCentroidsTime - lastCentroidsTime ;
%         end
%         lastCentroidsLoc = squeeze(WCentroids(burstTimeEnd,count,:)) ;
%         lastCentroidsTime = burstTimeEnd ;
        count = count+1 ;
    end

%%
% burstMaxWidth = max([burstXwidth,burstYwidth],[],2) ;
% allVar = [burstDuration(1:end-1),burstArea(1:end-1),burstMaxWidth(1:end-1),...
%     peak(1:end-1),spaceDist,timeDist] ;
% [r,p] = corrcoef(allVar) ;
% hist(areaBurst,20)
% title(['Histogram of burst area, mean = ', meanArea(end)])
% xlabel('Area (electrode^2)')

% print(gcf,[pwd,'/Results/random_noise/',dataFileName,...
%        'HistArea_surr'],'-dpng')



end

t = datetime('now') ;
dateStr = datestr(t,'mmmmdd_HH:MM') ;

saveFileName = ['FullBurstSur',dataFileName,'_Start',...
   'minTime',num2str(minBurstTime),'ms',dateStr,'.mat'] ;
save(saveFileName, ...
    'patternScale','Duration') ;    

