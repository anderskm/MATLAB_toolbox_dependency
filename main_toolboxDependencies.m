clearvars;
close all;

inputFolder = uigetdir(pwd,'Select folder');

%%

disp(['Input folder: ' inputFolder]);

disp('Locating m-files recursively...')
mfiles = folder2mfileCellArray(inputFolder);
mfilesShort = cellfun(@(x) x((length(inputFolder)+1):end),mfiles,'UniformOutput',false)';
disp([num2str(length(mfiles)) ' m-files located.']);

disp('Determining required toolboxes...');
[~, allToolboxes] = matlab.codetools.requiredFilesAndProducts(mfiles);
allToolboxNames = {allToolboxes.Name};
allToolboxCertainty = double([allToolboxes.Certain]);
disp([num2str(length(allToolboxNames)) ' toolboxes required:']);
disp([num2cell(allToolboxCertainty') allToolboxNames']);
disp('[1] indicates, that a toolbox is required. [0] indicates, that a toolbox might be required.')

%% Create m-file vs toolbox dependency matrix

disp('Creating m-file vs. toolbox dependency matrix...');
dependencyMatrix = zeros(length(mfiles),length(allToolboxNames));
for i = 1:length(mfiles)
    [~,toolboxes] = matlab.codetools.requiredFilesAndProducts(mfiles(i));
    [C, ai, bi] = intersect(allToolboxNames,{toolboxes.Name});
    dependencyMatrix(i, ai) = 1;
end
disp('Dependency matrix created.');

%% Plot dependencies

figure;
subplot('Position',[0.1 0.3 0.89 0.7]);
imagesc((dependencyMatrix.*(allToolboxCertainty-0.5)*2)',[-1 1]);
set(gca,'YTick',1:length(allToolboxNames), ...
        'YTickLabels',allToolboxNames, ...
        'YTickLabelRotation',45);
filesOfInterestIdx = find(sum(dependencyMatrix,2) > 1);
set(gca,'XTick',filesOfInterestIdx, ...
        'XTickLabels',mfilesShort(filesOfInterestIdx), ...
        'XTickLabelRotation',90, ...
        'FontSize',7)
colormap([0.9 0.8 0;
          1 1 1;
          0 0.8 0;]);