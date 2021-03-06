% CH4Fig9
figure_width = 11.4; % cm
figure_hight = 5.7; % cm
figure('NumberTitle','off','name', 'CH4Fig10', 'units', 'centimeters', ...
    'color','w', 'position', [0, 0, figure_width, figure_hight], ...
    'PaperSize', [figure_width, figure_hight]); % this is the trick!
%%
repeat = 2000;
% subplot(1,2,1)
IE = 1:7;
n = 100; % 50
Color = [0.93 0.69 0.13;1 0 1;0 1 1;1 0 0;0 1 0;0 0 1;0 0 0];
for i = 1:length(IE)
    heiy = zeros(1,n);
    for j = 1:n
        try
        pd = fitdist([Ceny{i,round(repeat/n*(j-1)+1:repeat/n*j)}]','Normal');
        heiy(j) = 1/pd.sigma^2;
        catch
            heiy(j) = 0;
        end
    end
    edges = 0:2:100; % 0:4:200;
    [N,edges] = histcounts(heiy,edges,'Normalization','probability');
    edges = (edges(1:end-1)+edges(2:end))/2;
    pd = fitdist(heiy','gamma') % gamma
    y = pdf(pd,edges);
    plot(edges,y/sum(y),'-','color',Color(i,:)); % ,'LineWidth',1
    hold on
end
for i = 1:length(IE)
    heiy = zeros(1,n);
    for j = 1:n
        try
        pd = fitdist([Ceny{i,round(repeat/n*(j-1)+1:repeat/n*j)}]','Normal');
        heiy(j) = 1/pd.sigma^2;
        catch
            heiy(j) = 0;
        end
    end
    edges = 0:2:100;
    [N,edges] = histcounts(heiy,edges,'Normalization','probability');
    edges = (edges(1:end-1)+edges(2:end))/2;
    plot(edges,N,'.','color',Color(i,:)) % ,'MarkerSize',8
    hold on
end
legend('1-item','2-item','3-item','4-item','5-item','6-item','7-item') %
xlabel('Precision','fontSize',10)
ylabel('Probability','fontSize',10)
% text(-0.1,1,'A','Units', 'Normalized','FontSize',12)
%%
dir_strut = dir('*_RYG.mat');
num_files = length(dir_strut);
files = cell(1,num_files);
for id_out = 1:num_files
    files{id_out} = dir_strut(id_out).name;
end
%% precision decided capacity
IE = 1:7;
n = 20;
Color = [0.93 0.69 0.13;1 0 1;0 1 1;1 0 0;0 1 0;0 0 1;0 0 0];
repeat = 2000;
w = 30; % 22.5
for w1 = [0.8 1 1.2 1.5]*w
    cap = zeros(1,7);
    for i = 1:length(IE)
        for item = 1:i
            ceny = cellfun(@(x) x(item),{Ceny{i,:}},'UniformOutput',false);
            heiy = zeros(1,n);
            for j = 1:n
                try
                    errorDis = cellfun(@(x) x(:)',[ceny{round(repeat/n*(j-1)+1:repeat/n*j)}],'UniformOutput',false);
                    pd = fitdist([errorDis{:}]','Normal');
                    heiy(j) = 1/pd.sigma^2;
                catch
                    heiy(j) = 0;
                end
            end
            if mean(heiy) > w1
                cap(i) = cap(i) + 1;
            end
        end
    end
    plot(IE,cap,'o-')
    hold on
end
legend('0.8w1','w1','1.2w1','1.5w1')
xlabel('Item','fontSize',10)
ylabel('Capacity','fontSize',10)
%% precision decided capacityV2
IE = 1:7;
n = 20; % 20
Color = [0.93 0.69 0.13;1 0 1;0 1 1;1 0 0;0 1 0;0 0 1;0 0 0];
repeat = 2000;
w = 25; % 22.5
for w1 = [0.8 1 1.2 1.5]*w
    cap = zeros(n,7);
    for i = 1:length(IE)
        for item = 1:i
            ceny = cellfun(@(x) x(item),{Ceny{i,:}},'UniformOutput',false);
            %         heiy = zeros(1,n);
            for j = 1:n
                try
                    errorDis = cellfun(@(x) x(:)',[ceny{round(repeat/n*(j-1)+1:repeat/n*j)}],'UniformOutput',false);
                    pd = fitdist([errorDis{:}]','Normal');
                    heiy = 1/pd.sigma^2;
                catch
                    heiy = 0;
                end
                if heiy > w1
                    cap(j,i) = cap(j,i) + 1;
                end
            end
        end
    end
    plot(IE,mean(cap),'o-')
%     errorbar(IE,mean(cap),std(cap),'o-')
    hold on
end
legend('0.8w1','w1','1.2w1','1.5w1')
xlabel('Item','fontSize',10)
ylabel('Capacity','fontSize',10)
%%
subplot(1,2,2)
for NumP = 1:7
    switch NumP
        case 1
            Coor = [0;0];
        case 2
            Coor = [-16 15.5;-16 15.5];
        case 3
            Coor = [-10.5*sqrt(3) 10.5*sqrt(3) 0;-10.5 -10.5 21];
        case 4
            Coor = [-15.8 15.8 -15.8 15.8;-15.8 -15.8 15.8 15.8];
        case 5
            Coor = [-18.5 18.5 0 -18.5 18.5;-18.5 -18.5 0 18.5 18.5];
        case 6
            Coor = [0 -9.8*sqrt(3) 9.8*sqrt(3) -9.8*sqrt(3) 9.8*sqrt(3) 0;...
                -19.6 -9.8         -9.8        9.8          9.8         19.6];
        case 7
            Coor = [0 -9.8*sqrt(3) 9.8*sqrt(3) 0 -9.8*sqrt(3) 9.8*sqrt(3) 0;...
                -19.6 -9.8         -9.8        0 9.8          9.8         19.6];
    end
    hw = 31;
    [Lattice, ~] = lattice_nD(2, hw);
    R = load(files{1+1000*(NumP-1)});
    LoalNeu = cell(1,R.ExplVar.NumP);
    for i = 1:R.ExplVar.NumP
        dist = Distance_xy(Lattice(:,1),Lattice(:,2),Coor(1,i),Coor(2,i),2*hw+1); %calculates Euclidean distance between centre of lattice and node j in the lattice
        LoalNeu{i} = find(dist<=R.ExplVar.AreaR)';
    end
    bin = 1e3:1e3:2e4;
    SpikeMat = zeros(1000,length(bin));
    for i = 1:length(bin)
        for id_out = 1:1000
            fprintf('Processing output file No.%d out of %d...\n', id_out+1000*(NumP-1), num_files);
            fprintf('\t File name: %s\n', files{id_out+1000*(NumP-1)});
            R = load(files{id_out+1000*(NumP-1)});
            for no = 1:NumP
                SpikeMat(id_out,i) = SpikeMat(id_out,i) + mean(sum(R.spike_hist{1}(LoalNeu{no},3e4+1:3e4+bin(i)),2));
            end
            %     SpikeMat(id_out,:) = sum(R.spike_hist{1}(StiNeu{1},1e4+1:1e4+bin),2);
        end
    end
    fanoMat = var(SpikeMat)./nanmean(SpikeMat);
    % fanoMean = nanmean(fanoMat);
    plot(0.1*bin,fanoMat,'o-','color',Color(NumP,:))
    hold on
end
xlabel('Counting Time T (ms)','fontSize',10)
ylabel('F(T)','fontSize',10)
legend('1-item','2-item','3-item','4-item','5-item','6-item','7-item')
text(-0.1,1,'B','Units', 'Normalized','fontSize',12)
%
set(gcf, 'PaperPositionMode', 'auto'); % this is the trick!
print -depsc CH4Fig10